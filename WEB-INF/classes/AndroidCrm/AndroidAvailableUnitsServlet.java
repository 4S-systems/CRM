package AndroidCrm;

import com.maintenance.common.Tools;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tracker.db_access.ProjectMgr;
import com.silkworm.business_objects.*;
import java.io.OutputStreamWriter;

public class AndroidAvailableUnitsServlet extends HttpServlet
{
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType("text/html;charset=UTF-8");

        System.out.println("Android Avialable Units Servlet");
        OutputStreamWriter out = new OutputStreamWriter(response.getOutputStream(),"UTF-8");

        out.write(Tools.getJSONArrayAsString(AndroidMgr.getAvailableUnits()));
        out.close();

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        doGet(request, response);

    }
}
