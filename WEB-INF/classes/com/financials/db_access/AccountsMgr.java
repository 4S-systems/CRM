package com.financials.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class AccountsMgr extends RDBGateWay{   
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static AccountsMgr accountsMgr = new AccountsMgr();

    public AccountsMgr()
    {
    }
    
    public static AccountsMgr getInstance()
    {
        System.out.println("Getting AccountsMgr Instance ....");
        return accountsMgr;
    }
    
    @Override
    protected void initSupportedForm()
    {
        if (webInfPath != null)
        {
            System.out.println("AccountMgr ..***********.trying to get the XML file from path: " + webInfPath);
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
            
        }
        if (supportedForm == null)
        {
            try
            {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("Accounts.xml")));
                System.out.println("After Execution = ");
                supportedForm.printSelf();
            }
            catch (Exception e)
            {
                System.out.println("Account Manager : Could not locate XML Document "+e.getMessage());
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    public ArrayList<WebBusinessObject> getAccountTree(String accountID) throws SQLException, UnsupportedTypeException {
        Connection connection = null;
        
        Vector<Row> queryResult = new Vector();
        Vector parameters = new Vector();
        
        SQLCommandBean command = new SQLCommandBean();

        parameters.addElement(new StringValue(accountID));
        
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getAccountTree").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        
        ArrayList<WebBusinessObject> accounts = new ArrayList<WebBusinessObject>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            accounts.add(temp);
        }
        return accounts;
    }
}
