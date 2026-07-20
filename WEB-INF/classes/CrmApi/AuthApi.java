package CrmApi;

import com.silkworm.common.MetaDataMgr;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "AuthApi", urlPatterns = {"/api/auth/login", "/api/auth/logout", "/api/auth/verify"})
public class AuthApi extends HttpServlet {

    private static final long TOKEN_VALIDITY = 24 * 60 * 60 * 1000;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getServletPath();

        if ("/api/auth/login".equals(pathInfo)) {
            handleLogin(request, response);
        } else if ("/api/auth/logout".equals(pathInfo)) {
            handleLogout(request, response);
        } else if ("/api/auth/verify".equals(pathInfo)) {
            handleVerify(request, response);
        } else {
            sendError(response, "Invalid endpoint", 404);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getServletPath();

        if ("/api/auth/verify".equals(pathInfo)) {
            handleVerify(request, response);
        } else {
            sendError(response, "Method not allowed", 405);
        }
    }
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String requestBody = getRequestBody(request);
            JSONObject json = new JSONObject(requestBody);

            String username = json.optString("username", "").trim();
            String password = json.optString("password", "").trim();

            if (username.isEmpty() || password.isEmpty()) {
                sendError(response, "Username and password are required", 400);
                return;
            }

            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            conn = DriverManager.getConnection(
                    metaMgr.getDataBaseURL(),
                    metaMgr.getUserName(),
                    metaMgr.getUserName()
            );

          
            String sql = "SELECT USER_ID, USER_NAME, EMAIL, GROUP_NAME, GROUP_ID "
                    + "FROM BRIGHT.USER_GROUP "
                    + "WHERE USER_NAME = ? AND PASSWORD = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String userId = rs.getString("USER_ID");
                String userName = rs.getString("USER_NAME");
                String email = nvl(rs.getString("EMAIL"));
                String groupName = nvl(rs.getString("GROUP_NAME"));
                String groupId = nvl(rs.getString("GROUP_ID"));

                // إنشاء Token
                String token = generateToken(userId, userName);

                JSONObject userData = new JSONObject();
                userData.put("id", userId);
                userData.put("name", userName);
                userData.put("email", email);
                userData.put("group", groupName);
                userData.put("group_id", groupId);

                JSONObject result = new JSONObject();
                result.put("status", "success");
                result.put("message", "Login successful");
                result.put("token", token);
                result.put("user", userData);

                sendResponse(response, result, 200);
            } else {
                sendError(response, "Invalid username or password", 401);
            }

        } catch (Exception e) {
            sendError(response, "Login failed: " + e.getMessage(), 500);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            JSONObject result = new JSONObject();
            result.put("status", "success");
            result.put("message", "Logout successful");
            sendResponse(response, result, 200);
        } catch (Exception e) {
            sendError(response, "Logout failed: " + e.getMessage(), 500);
        }
    }

    private void handleVerify(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            String authHeader = request.getHeader("Authorization");

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                sendError(response, "No token provided", 401);
                return;
            }

            String token = authHeader.substring(7);

            JSONObject tokenData = verifyToken(token);

            if (tokenData != null) {
                JSONObject result = new JSONObject();
                result.put("status", "success");
                result.put("message", "Token is valid");
                result.put("user", tokenData);
                sendResponse(response, result, 200);
            } else {
                sendError(response, "Invalid or expired token", 401);
            }

        } catch (Exception e) {
            sendError(response, "Verification failed: " + e.getMessage(), 500);
        }
    }
    private String generateToken(String userId, String userName) {
        try {
            long expiryTime = System.currentTimeMillis() + TOKEN_VALIDITY;
            
            JSONObject tokenData = new JSONObject();
            tokenData.put("userId", userId);
            tokenData.put("userName", userName);
            tokenData.put("exp", expiryTime);

            String tokenString = tokenData.toString();
            return Base64.getEncoder().encodeToString(tokenString.getBytes("UTF-8"));

        } catch (Exception e) {
            return null;
        }
    }

   private JSONObject verifyToken(String token) {
        try {
            byte[] decodedBytes = Base64.getDecoder().decode(token);
            String decodedString = new String(decodedBytes, "UTF-8");
            
            JSONObject tokenData = new JSONObject(decodedString);
            
            long expiryTime = tokenData.getLong("exp");
            long currentTime = System.currentTimeMillis();

            if (currentTime > expiryTime) {
                return null; // Token منتهي الصلاحية
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