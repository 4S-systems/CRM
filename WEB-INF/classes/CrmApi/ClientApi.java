package CrmApi;

import com.silkworm.common.MetaDataMgr;
import java.io.BufferedReader;
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

@WebServlet(name = "ClientApi", urlPatterns = {"/api/clients/*"})
public class ClientApi extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // التحقق من الـ Token
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            sendError(response, "No token provided", 401);
            return;
        }

        String token = authHeader.substring(7);
        JSONObject tokenData = verifyToken(token);

        if (tokenData == null) {
            sendError(response, "Invalid or expired token", 401);
            return;
        }

        // الـ Token صحيح - نكمل
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || "/".equals(pathInfo)) {
            // GET /api/clients - جلب كل العملاء
            getAllClients(request, response);
        } else {
            // GET /api/clients/123 - جلب عميل معين
            String clientId = pathInfo.substring(1);
            getClientById(clientId, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // التحقق من الـ Token
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            sendError(response, "No token provided", 401);
            return;
        }

        String token = authHeader.substring(7);
        JSONObject tokenData = verifyToken(token);

        if (tokenData == null) {
            sendError(response, "Invalid or expired token", 401);
            return;
        }

        // إضافة عميل جديد
        addClient(request, response);
    }
    private void getAllClients(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String receiptId = request.getParameter("receipt_id");
            if (receiptId == null || receiptId.trim().isEmpty()) {
                receiptId = "1778157886532";
            }

            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
           conn = DriverManager.getConnection(
                    MetaDataMgr.getInstance().getDataBaseURL(),
                    MetaDataMgr.getInstance().getUserName(),
                    MetaDataMgr.getInstance().getUserName()
            );
           
       
            String sql = "SELECT DISTINCT "
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
            stmt.setString(1, receiptId);
            rs = stmt.executeQuery();

            JSONArray jsonArray = new JSONArray();

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

            JSONObject result = new JSONObject();
            result.put("status", "success");
            result.put("count", jsonArray.length());
            result.put("data", jsonArray);

            sendResponse(response, result, 200);

        } catch (Exception e) {
            sendError(response, "Failed to fetch clients: " + e.getMessage(), 500);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    private void getClientById(String clientId, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            conn = DriverManager.getConnection(
                    metaMgr.getDataBaseURL(),
                    metaMgr.getUserName(),
                    metaMgr.getUserName()
            );

            String sql = "SELECT * FROM CLIENT WHERE SYS_ID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, clientId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                JSONObject obj = new JSONObject();
                obj.put("sys_id", nvl(rs.getString("SYS_ID")));
                obj.put("name", nvl(rs.getString("CLIENT_NAME")));
                obj.put("mobile", nvl(rs.getString("CLIENT_MOBILE")));
                obj.put("email", nvl(rs.getString("EMAIL")));
                obj.put("status", nvl(rs.getString("CURRENT_STATUS")));
                
                JSONObject result = new JSONObject();
                result.put("status", "success");
                result.put("data", obj);
                sendResponse(response, result, 200);
            } else {
                sendError(response, "Client not found", 404);
            }

        } catch (Exception e) {
            sendError(response, "Failed to fetch client: " + e.getMessage(), 500);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    private void addClient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
                      String requestBody = getRequestBody(request);
            JSONObject json = new JSONObject(requestBody);

            String clientName = json.optString("client_name", "").trim();
            String clientMobile = json.optString("client_mobile", "").trim();
            String clientEmail = json.optString("email", "").trim();
            String currentStatus = json.optString("current_status", "Active").trim();
            String description = json.optString("description", "").trim();

            if (clientName.isEmpty() || clientMobile.isEmpty()) {
                sendError(response, "Client name and mobile are required", 400);
                return;
            }

            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            conn = DriverManager.getConnection(
                    metaMgr.getDataBaseURL(),
                    metaMgr.getUserName(),
                    metaMgr.getUserName()
            );

            String sql = "INSERT INTO CLIENT (CLIENT_NAME, CLIENT_MOBILE, EMAIL, CURRENT_STATUS, DESCRIPTION, CREATION_TIME) "
                    + "VALUES (?, ?, ?, ?, ?, SYSDATE)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, clientName);
            stmt.setString(2, clientMobile);
            stmt.setString(3, clientEmail);
            stmt.setString(4, currentStatus);
            stmt.setString(5, description);

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                JSONObject result = new JSONObject();
                result.put("status", "success");
                result.put("message", "Client added successfully");
                sendResponse(response, result, 201);
            } else {
                sendError(response, "Failed to add client", 500);
            }

        } catch (Exception e) {
            sendError(response, "Error adding client: " + e.getMessage(), 500);
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    private JSONObject verifyToken(String token) {
        try {
            byte[] decodedBytes = java.util.Base64.getDecoder().decode(token);
            String decodedString = new String(decodedBytes, "UTF-8");
            
            JSONObject tokenData = new JSONObject(decodedString);
            
            long expiryTime = tokenData.getLong("exp");
            long currentTime = System.currentTimeMillis();

            if (currentTime > expiryTime) {
                return null;
            }

            return tokenData;

        } catch (Exception e) {
            return null;
        }
    }

    private String getRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;
        BufferedReader reader = request.getReader();
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }

    private void sendResponse(HttpServletResponse response, JSONObject json, int status) 
            throws IOException {
        response.setStatus(status);
        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
        out.close();
    }

    private void sendError(HttpServletResponse response, String message, int status) 
            throws IOException {
        response.setStatus(status);
        JSONObject error = new JSONObject();
        error.put("status", "error");
        error.put("message", message);
        PrintWriter out = response.getWriter();
        out.print(error.toString());
        out.flush();
        out.close();
    }

       private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
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

    private String nvl(String value) {
        return value == null ? "" : value.replace("\"", "\\\"");
    }

}  // <- النهاية الفعلية للـ Class

