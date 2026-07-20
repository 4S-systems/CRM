package CrmApi;

import com.silkworm.common.MetaDataMgr;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "CrmApi", urlPatterns = {"/CrmApi"})
public class CrmApi extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        JSONArray jsonArray = new JSONArray();
        String sql = null;

        try {

            conn = DriverManager.getConnection(
                    metaMgr.getDataBaseURL(),
                    metaMgr.getUserName(),
                    metaMgr.getUserName());

            // قراءة بيانات المصادقة من الباراميتر
            String authUser = request.getParameter("auth_user");
            String authPass = request.getParameter("auth_pass");
            if (authUser == null) authUser = "";
            if (authPass == null) authPass = "";
            authUser = authUser.trim();
            authPass = authPass.trim();

            // تحقق بسيط من وجود المستخدم وكلمة المرور في الجدول
            String authSql = "SELECT COUNT(*) CNT FROM BRIGHT.USER_GROUP WHERE USER_NAME = ? AND PASSWORD = ?";
            stmt = conn.prepareStatement(authSql);
            stmt.setString(1, authUser);
            stmt.setString(2, authPass);
            rs = stmt.executeQuery();

            boolean authenticated = false;
            if (rs.next()) {
                authenticated = rs.getInt("CNT") > 0;
            }
            rs.close();
            stmt.close();

            if (!authenticated) {
                JSONObject error = new JSONObject();
                error.put("status", "error");
                error.put("message", "Authentication failed");
                out.print(error.toString());
                return;
            }

            // بعد المصادقة ننفّذ العملية المطلوبة
            String action = request.getParameter("action");
            if (action == null || action.trim().isEmpty()) {
                action = "crm";
            }

            if ("groups".equalsIgnoreCase(action)) {

                sql = "SELECT * FROM BRIGHT.USER_GROUP ORDER BY USER_NAME";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    JSONObject obj = new JSONObject();
                    obj.put("group_name", nvl(rs.getString("GROUP_NAME")));
                    obj.put("group_id", nvl(rs.getString("GROUP_ID")));
                    obj.put("user_id", nvl(rs.getString("USER_ID")));
                    obj.put("user_name", nvl(rs.getString("USER_NAME")));
                    obj.put("user_home", nvl(rs.getString("USER_HOME")));
                    obj.put("email", nvl(rs.getString("EMAIL")));
                    obj.put("creation_time", nvl(rs.getString("CREATION_TIME")));
                    obj.put("default_page", nvl(rs.getString("DEFAULT_PAGE")));
                    obj.put("is_default", nvl(rs.getString("IS_DEFAULT")));
                    obj.put("project_id", nvl(rs.getString("PROJECT_ID")));
                    jsonArray.put(obj);
                }
                rs.close();
                stmt.close();

            } else if ("clients".equalsIgnoreCase(action)) { // default crm

                sql =
                        "SELECT DISTINCT "
                        + "IC.CUSTOMER_ID SYS_ID, "
                        + "IC.CUSTOMER_NAME NAME, "
                        + "IC.CLIENT_MOBILE MOBILE, "
                        + "CL.INTER_PHONE INTERPHONE, "
                        + "CL.CLIENT_NO, "
                        + "CL.EMAIL, "
                        + "CL.CURRENT_STATUS, "
                        + "CL.DESCRIPTION, "
                        + "CL.CREATION_TIME, "
                        + "ST.ENGLISHNAME, "
                        + "CASE WHEN P.PROJECT_NAME IS NOT NULL THEN P.PROJECT_NAME ELSE 'Following up' END CLASS_TITLE, "
                        + "P.OPTION_THREE IMAGE_NAME, "
                        + "CR.RATE_ID, "
                        + "AP.CREATION_TIME APPDATE, "
                        + "AP.APPOINTMENT_DATE, "
                        + "COM.CREATION_TIME COMDATE, "
                        + "AP.\"COMMENT\" LSTAPPCOM "
                        + "FROM ISSUE_BY_COMPLAINT IC "
                        + "LEFT JOIN CLIENT_COMPLAINTS CCC ON IC.COMP_ID = CCC.ID "
                        + "LEFT JOIN CLIENT_COMPLAINTS_TYPE CCT ON CCC.ID = CCT.ID "
                        + "LEFT JOIN CLIENT CL ON IC.CUSTOMER_ID = CL.SYS_ID "
                        + "LEFT JOIN APPOINTMENT AP ON CL.SYS_ID = AP.CLIENT_ID "
                        + "LEFT JOIN COMMENTS COM ON CL.CLIENT_NO = COM.BUSNIESS_OBJECT_ID "
                        + "LEFT JOIN CLIENT_RATING CR ON CR.CLIENT_ID = CL.SYS_ID AND CR.CREATED_BY = '' "
                        + "LEFT JOIN PROJECT P ON CR.RATE_ID = P.PROJECT_ID "
                        + "LEFT JOIN CLIENT_COMPLAINTS CC ON IC.COMP_ID = CC.ID "
                        + "LEFT JOIN SEASON_TYPE ST ON CL.OPTION3 = ST.ID "
                        + "WHERE IC.RECEIP_ID = ? "
                        + "AND (AP.CURRENT_STATUS_SINCE IN "
                        + "(SELECT MAX(CURRENT_STATUS_SINCE) FROM APPOINTMENT WHERE APPOINTMENT.CLIENT_ID = CL.SYS_ID) "
                        + "OR AP.CREATION_TIME IS NULL) "
                        + "AND (COM.CREATION_TIME IN "
                        + "(SELECT MAX(CREATION_TIME) FROM COMMENTS WHERE COMMENTS.BUSNIESS_OBJECT_ID = CL.CLIENT_NO) "
                        + "OR COM.CREATION_TIME IS NULL) "
                        + "AND IC.STATUS_CODE NOT IN ('5','6','7') "
                        + "AND TRUNC(CC.CREATION_TIME) BETWEEN "
                        + "TO_DATE('15/01/2026','DD/MM/YYYY') "
                        + "AND TO_DATE('15/06/2026','DD/MM/YYYY')";

                stmt = conn.prepareStatement(sql);

                String receiptId = request.getParameter("receipt_id");
                if (receiptId == null || receiptId.trim().isEmpty()) {
                    receiptId = "1778157886532";
                }

                stmt.setString(1, receiptId);
                rs = stmt.executeQuery();

                while (rs.next()) {

                    JSONObject obj = new JSONObject();

                    obj.put("sys_id", nvl(rs.getString("SYS_ID")));
                    obj.put("name", nvl(rs.getString("NAME")));
                    obj.put("mobile", nvl(rs.getString("MOBILE")));
                    obj.put("interphone", nvl(rs.getString("INTERPHONE")));
                    obj.put("client_no", nvl(rs.getString("CLIENT_NO")));
                    obj.put("email", nvl(rs.getString("EMAIL")));
                    obj.put("current_status", nvl(rs.getString("CURRENT_STATUS")));
                    obj.put("description", nvl(rs.getString("DESCRIPTION")));
                    obj.put("creation_time", nvl(rs.getString("CREATION_TIME")));
                    obj.put("english_name", nvl(rs.getString("ENGLISHNAME")));
                    obj.put("class_title", nvl(rs.getString("CLASS_TITLE")));
                    obj.put("image_name", nvl(rs.getString("IMAGE_NAME")));
                    obj.put("rate_id", nvl(rs.getString("RATE_ID")));
                    obj.put("app_date", nvl(rs.getString("APPDATE")));
                    obj.put("appointment_date", nvl(rs.getString("APPOINTMENT_DATE")));
                    obj.put("comment_date", nvl(rs.getString("COMDATE")));
                    obj.put("last_comment", nvl(rs.getString("LSTAPPCOM")));

                    jsonArray.put(obj);
                }
                rs.close();
                stmt.close();
            }

            JSONObject result = new JSONObject();
            result.put("status", "success");
            result.put("action", action);
            result.put("count", jsonArray.length());
            result.put("data", jsonArray);

            out.print(result.toString());

        } catch (Exception e) {

            JSONObject error = new JSONObject();
            error.put("status", "error");
            error.put("message", e.getMessage());
            out.print(error.toString());

        } finally {

            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
            }

            try {
                if (stmt != null) stmt.close();
            } catch (Exception e) {
            }

            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }

    private String nvl(String value) {
        return value == null ? "" : value.replace("\"", "\\\"");
    }
}
