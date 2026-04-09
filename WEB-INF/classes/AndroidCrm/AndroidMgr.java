/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package AndroidCrm;

import com.clients.db_access.AppointmentMgr;
import com.maintenance.common.Tools;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.tracker.db_access.ProjectMgr;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author asteriskpbx
 */
public class AndroidMgr extends RDBGateWay
{

    private static final AndroidMgr androidMgr = new AndroidMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static AndroidMgr getInstance()
    {
        logger.info("Getting ClientProductMgr Instance ....");
        return androidMgr;
    }
    public static List<WebBusinessObject> getAvailableUnits()
    {
        List<WebBusinessObject> availableUnits=null;
        //Get Connection
        try {
            Connection con = dataSource.getConnection();
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            
            availableUnits = projectMgr.getAllAvailableUnitsList();
            

        } catch (Exception e) {
            System.out.println(e);
        }
        return availableUnits;
    }
    public static boolean validate(String name, String pass)
    {
        boolean status = false;
        try
        {
            //Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = dataSource.getConnection();//DriverManager.getConnection("jdbc:oracle:thin:@20.20.20.8:1521:maint", "pcrm", "pcrm");

            PreparedStatement ps = con.prepareStatement(
                    "select * from users where user_name=? and password=?");
            ps.setString(1, name);
            ps.setString(2, pass);

            ResultSet rs = ps.executeQuery();
            status = rs.next();

        } catch (Exception e)
        {
            System.out.println(e);
        }
        return status;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedForm()
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedQueries()
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public ArrayList getCashedTableAsArrayList()
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
