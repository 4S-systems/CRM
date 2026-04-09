package AndroidCrm;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStreamWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.DataSource;

public class AndroidLoginServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        System.out.println("I am here");
        OutputStreamWriter out = new OutputStreamWriter(response.getOutputStream());

        String n = request.getParameter("name");
        String p = request.getParameter("pass");
        System.out.println(n);
        System.out.println(p);

        if (AndroidMgr.validate(n, p)) {
            //out.writeBoolean(true);
            out.write("success");

        } else {
            //out.writeBoolean(false);
            out.write("Sorry username or password error");

        }

        out.close();
    }

    

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);

    }
}
