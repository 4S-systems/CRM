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

@WebServlet(name = "GroupApi", urlPatterns = {"/api/groups/*"})
public class GroupApi extends HttpServlet {

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
            // GET /api/groups - جلب كل المجموعات
            getAllGroups(request, response);
        } else {
            // GET /api/groups/123 - جلب مجموعة معينة
            String groupId = pathInfo.substring(1);
            getGroupById(groupId, response);
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

        // إضافة مجموعة جديدة
        addGroup(request, response);
    }

    private void getAllGroups(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(
                    MetaDataMgr.getInstance().getDataBaseURL(),
                    MetaDataMgr.getInstance().getUserName(),
                    MetaDataMgr.getInstance().getUserName()
            );

                      String sql = "SELECT * FROM BRIGHT.USER_GROUP ORDER BY USER_NAME";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            JSONArray jsonArray = new JSONArray();

            while (rs.next()) {
                JSONObject obj = new JSONObject();
                obj.put("group_id", nvl(rs.getString("GROUP_ID")));
                obj.put("group_name", nvl(rs.getString("GROUP_NAME")));
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

            JSONObject result = new JSONObject();
            result.put("status", "success");
            result.put("count", jsonArray.length());
            result.put("data", jsonArray);

            sendResponse(response, result, 200);

        } catch (Exception e) {
            sendError(response, "Failed to fetch groups: " + e.getMessage(), 500);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    private void getGroupById(String groupId, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(
                    MetaDataMgr.getInstance().getDataBaseURL(),
                    MetaDataMgr.getInstance().getUserName(),
                    MetaDataMgr.getInstance().getUserName()
            );

            String sql = "SELECT * FROM BRIGHT.USER_GROUP WHERE GROUP_ID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, groupId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                JSONObject obj = new JSONObject();
                obj.put("group_id", nvl(rs.getString("GROUP_ID")));
                obj.put("group_name", nvl(rs.getString("GROUP_NAME")));
                obj.put("user_id", nvl(rs.getString("USER_ID")));
                obj.put("user_name", nvl(rs.getString("USER_NAME")));
                obj.put("user_home", nvl(rs.getString("USER_HOME")));
                obj.put("email", nvl(rs.getString("EMAIL")));
                obj.put("creation_time", nvl(rs.getString("CREATION_TIME")));
                obj.put("default_page", nvl(rs.getString("DEFAULT_PAGE")));
                obj.put("is_default", nvl(rs.getString("IS_DEFAULT")));
                obj.put("project_id", nvl(rs.getString("PROJECT_ID")));
                
                JSONObject result = new JSONObject();
                result.put("status", "success");
                result.put("data", obj);
                sendResponse(response, result, 200);
            } else {
                sendError(response, "Group not found", 404);
            }

        } catch (Exception e) {
            sendError(response, "Failed to fetch group: " + e.getMessage(), 500);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    private void addGroup(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            String requestBody = getRequestBody(request);
            JSONObject json = new JSONObject(requestBody);
            String groupName = json.optString("group_name", "").trim();
            String userId = json.optString("user_id", "").trim();
            String userName = json.optString("user_name", "").trim();
            String userHome = json.optString("user_home", "").trim();
            String email = json.optString("email", "").trim();
            String defaultPage = json.optString("default_page", "").trim();
            String isDefault = json.optString("is_default", "0").trim();
            String projectId = json.optString("project_id", "").trim();

            if (groupName.isEmpty() || userId.isEmpty() || userName.isEmpty()) {
                sendError(response, "group_name, user_id and user_name are required", 400);
                return;
            }

            conn = DriverManager.getConnection(
                    MetaDataMgr.getInstance().getDataBaseURL(),
                    MetaDataMgr.getInstance().getUserName(),
                    MetaDataMgr.getInstance().getUserName()
            );

            String sql = "INSERT INTO BRIGHT.USER_GROUP (GROUP_ID, GROUP_NAME, USER_ID, USER_NAME, USER_HOME, EMAIL, CREATION_TIME, DEFAULT_PAGE, IS_DEFAULT, PROJECT_ID) "
                    + "VALUES (?, ?, ?, ?, ?, ?, SYSDATE, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            // إذا عندك sequence أو SYS_GUID استخدمه؛ هنا نستخدم UUID كنموذج
            stmt.setString(1, java.util.UUID.randomUUID().toString());
            stmt.setString(2, groupName);
            stmt.setString(3, userId);
            stmt.setString(4, userName);
            stmt.setString(5, userHome);
            stmt.setString(6, email);
            stmt.setString(7, defaultPage);
            stmt.setString(8, isDefault);
            stmt.setString(9, projectId);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                JSONObject result = new JSONObject();
                result.put("status", "success");
                result.put("message", "Group added successfully");
                sendResponse(response, result, 201);
            } else {
                sendError(response, "Failed to add group", 500);
            }

        } catch (Exception e) {
            sendError(response, "Error adding group: " + e.getMessage(), 500);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // Helper methods (copy from other classes if needed)

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
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    private JSONObject verifyToken(String token) {
        try {
            byte[] decodedBytes = java.util.Base64.getDecoder().decode(token);
            String decodedString = new String(decodedBytes, "UTF-8");
            JSONObject tokenData = new JSONObject(decodedString);
            long expiryTime = tokenData.getLong("exp");
            if (System.currentTimeMillis() > expiryTime) return null;
            return tokenData;
        } catch (Exception e) {
            return null;
        }
    }

    private String nvl(String value) {
        return value == null ? "" : value.replace("\"", "\\\"");
    }

} // نهاية الكلاس

            

            
