package com.financials.db_access;

//import com.maintenance.db_access.EmpEqpMgr;
import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteNoSuchColumnException;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.android.persistence.LiteStringValue;
import java.sql.*;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ExpenseItemMgr extends LiteRDBGateWay{
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ExpenseItemMgr expenseItemMgr = new ExpenseItemMgr();

    public ExpenseItemMgr(){}

    public static ExpenseItemMgr getInstance(){
        logger.info("Getting expenseItemMgr Instance ....");
        return expenseItemMgr;
    }

    @Override
    protected void initSupportedForm(){
        if (webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        
        if (supportedForm == null){
            try{
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("ExpenseItemMgr.xml")));
            } catch (Exception e){
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(LiteWebBusinessObject wbo) throws SQLException{
        Vector params = new Vector();
        String id = UniqueIDGen.getNextID();
        params.addElement(new LiteStringValue(id));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("code")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("arName")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("enName")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("transType")));
//        params.addElement(new LiteStringValue((String) wbo.getAttribute("indriveCalc")));
        if (wbo.getAttribute("unit_price") != null & !wbo.getAttribute("unit_price").equals("")){
            params.addElement(new LiteStringValue((String) wbo.getAttribute("unit_price")));
        } else{
            params.addElement(new LiteStringValue("0"));
        }
        
        params.addElement(new LiteStringValue((String) wbo.getAttribute("userId")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("measure_unit")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("accountType")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("itemType")));

        Connection connection = dataSource.getConnection();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        forInsert.setConnection(connection);
        forInsert.setSQLQuery(sqlMgr.getSql("insertExpenseItem"));
        forInsert.setparams(params);

        return forInsert.executeUpdate() > 0;
    }

    public String saveObject2(LiteWebBusinessObject wbo, HttpServletRequest request) throws SQLException{
        int queryResult = 0;
        Vector params = new Vector();
        String id = UniqueIDGen.getNextID();
        String query = "";
        if (wbo.getAttribute("costItemId").equals("0")){
            params.addElement(new LiteStringValue(id));
            query = sqlMgr.getSql("insertExpenseItem").trim();
        }
        
        params.addElement(new LiteStringValue((String) wbo.getAttribute("code")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("arName")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("enName")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("transType")));
//        params.addElement(new LiteStringValue((String) wbo.getAttribute("indriveCalc")));
        if (wbo.getAttribute("unit_price") != null & !wbo.getAttribute("unit_price").equals("")){
            params.addElement(new LiteStringValue((String) wbo.getAttribute("unit_price")));
        } else{
            params.addElement(new LiteStringValue("0"));
        }
        
        params.addElement(new LiteStringValue((String) wbo.getAttribute("userId")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("measure_unit")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("accountType")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("itemType")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("calc_type")));

        if (!wbo.getAttribute("costItemId").equals("0")){
            params.addElement(new LiteStringValue((String) wbo.getAttribute("costItemId")));
            query = sqlMgr.getSql("updateExpenseItem").trim();
        }

        Connection connection = dataSource.getConnection();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        forInsert.setConnection(connection);
        forInsert.setSQLQuery(query);
        forInsert.setparams(params);
        try{
            queryResult = forInsert.executeUpdate();
        } catch (SQLException ex){
            try{
                connection.rollback();
            } catch (SQLException ex1){
                Logger.getLogger(ExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex1);
                return null;
            }
        } finally{
            try{
                connection.commit();
                connection.close();
            } catch (SQLException ex){
                Logger.getLogger(ExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
                return null;
            }
//            endTransaction();
//            endTransaction();
        }

        if (queryResult > 0){
            if (wbo.getAttribute("costItemId").equals("0")){
                return id;
            } else{
                id = wbo.getAttribute("costItemId").toString();
            }
            
            return id;
        } else{
            return null;
        }
    }

    public List<LiteWebBusinessObject> getMeasurementUnits(String busObjTyp){
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new LiteStringValue(busObjTyp));
        String query = "select id, base, ar_desc, en_desc,system from MEASUREMENT_UNIT WHERE BUS_OBJ_TYPE = ? order by creation_time desc";
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try{
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }catch (SQLException se){
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException uste){
            logger.error("***** " + uste.getMessage());
        } finally{
            try{
                connection.close();
            } catch (SQLException ex){
                logger.error(ex.getMessage());
            }
        }
        
        List<LiteWebBusinessObject> resultObjList = new ArrayList<LiteWebBusinessObject>();
        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()){
            r = (LiteRow) e.nextElement();
            LiteWebBusinessObject wbo = new LiteWebBusinessObject();
            try{
                wbo.setAttribute("ID", r.getString("id"));
                wbo.setAttribute("base", r.getString("base"));
                wbo.setAttribute("arDesc", r.getString("ar_desc"));
                wbo.setAttribute("enDesc", r.getString("en_desc"));
                wbo.setAttribute("system", r.getString("system"));
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(ExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultObjList.add(wbo);
        }
        return resultObjList;
    }
    
    public String getMeasurementUnitName(String id) throws SQLException, LiteUnsupportedTypeException, NoSuchColumnException, LiteNoSuchColumnException{
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new LiteStringValue(id));
        Connection connection = dataSource.getConnection();
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        forQuery.setConnection(connection);
        forQuery.setSQLQuery("select ar_desc from MEASUREMENT_UNIT where id=?");
        forQuery.setparams(params);
        queryResult = forQuery.executeQuery();
        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()){
            r = (LiteRow) e.nextElement();
        }
        return r.getString("ar_desc");
    }

    public boolean updateExpenseItem(LiteWebBusinessObject expenseWbo) throws SQLException{
        Vector params = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = 0;
        Connection connection = dataSource.getConnection();
        beginTransaction();
        forInsert.setConnection(connection);

        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("code")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("arName")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("enName")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("trans_type")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("indrive_calc")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("userId")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("measureUnit")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("accountType")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("itemType")));
        params.addElement(new LiteStringValue((String) expenseWbo.getAttribute("expenseItemId")));

        forInsert.setSQLQuery(sqlMgr.getSql("updateExpenseItem").trim());
        forInsert.setparams(params);
        try{
            queryResult = forInsert.executeUpdate();
        }catch (SQLException ex){
            try{
                connection.rollback();
            } catch (SQLException ex1){
                Logger.getLogger(ExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex1);
            }
        } finally{
            try{
                connection.commit();
                connection.close();
            } catch (SQLException ex){
                Logger.getLogger(ExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            endTransaction();
        }

        return (queryResult > 0);
    }
    
    public ArrayList<LiteWebBusinessObject> getExpensItem(){
        Connection connection = null;
        Vector queryResult = null;
        String query = "SELECT * FROM EXPENSE_ITEM";
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try{
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        }catch (SQLException se){
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException uste){
            logger.error("***** " + uste.getMessage());
        } finally{
            try{
                connection.close();
            } catch (SQLException ex){
                logger.error(ex.getMessage());
            }
        }
        
        ArrayList<LiteWebBusinessObject> resultObjList = new ArrayList<LiteWebBusinessObject>();
        LiteRow r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()){
            r = (LiteRow) e.nextElement();
            LiteWebBusinessObject wbo = new LiteWebBusinessObject();
            try {
                //wbo = fabricateBusObj(r);
                if(r.getString("ID") != null){
                    wbo.setAttribute("id", r.getString("ID"));
                } else {
                    wbo.setAttribute("id", "");
                }
                
                if(r.getString("CODE") != null){
                    wbo.setAttribute("code", r.getString("CODE"));
                } else {
                    wbo.setAttribute("code", "");
                }

                if(r.getString("DESC_AR") != null){
                    wbo.setAttribute("arName", r.getString("DESC_AR"));
                } else {
                    wbo.setAttribute("arName", "");
                }

                if(r.getString("DESC_EN") != null){
                    wbo.setAttribute("enName", r.getString("DESC_EN"));
                } else {
                    wbo.setAttribute("enName", "");
                }

                if(r.getString("TRANSACTION_TYPE") != null){
                    wbo.setAttribute("transType", r.getString("TRANSACTION_TYPE"));
                } else {
                    wbo.setAttribute("transType", "");
                }

                if(r.getString("INDRIVE_CALC") != null){
                    wbo.setAttribute("indriveCalc", r.getString("INDRIVE_CALC"));
                } else {
                    wbo.setAttribute("indriveCalc", "");
                }

                if(r.getString("CREATED_BY") != null){
                    wbo.setAttribute("createdBy", r.getString("CREATED_BY"));
                } else {
                    wbo.setAttribute("createdBy", "");
                }

                if(r.getString("CREATION_TIME") != null){
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                } else {
                    wbo.setAttribute("creationTime", "");
                }

                if(r.getString("MEASURE_UNIT") != null){
                    wbo.setAttribute("measureUnit", r.getString("MEASURE_UNIT"));
                } else {
                    wbo.setAttribute("measureUnit", "");
                }

                if(r.getString("EXPENSE_ITEM_TYPE") != null){
                    wbo.setAttribute("expenseItemType", r.getString("EXPENSE_ITEM_TYPE"));
                } else {
                    wbo.setAttribute("expenseItemType", "");
                }

                if(r.getString("CALC_TYPE") != null){
                    wbo.setAttribute("calcType", r.getString("CALC_TYPE"));
                } else {
                    wbo.setAttribute("calcType", "");
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(ExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultObjList.add(wbo);
        }
        return resultObjList;
    }

    @Override
    public ArrayList getCashedTableAsBusObjects(){
        cashData();
        cashedData = new ArrayList();
        LiteWebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++){
            wbo = (LiteWebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries(){
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList(){
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public ArrayList<LiteWebBusinessObject> getEmployeeExpensItems(String employeeID){
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        String query = getQuery("getEmployeeExpensItems").trim();
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        params.addElement(new LiteStringValue(employeeID));
        try{
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }catch (SQLException se){
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException uste){
            logger.error("***** " + uste.getMessage());
        } finally{
            try{
                connection.close();
            } catch (SQLException ex){
                logger.error(ex.getMessage());
            }
        }
        ArrayList<LiteWebBusinessObject> result = new ArrayList<>();
        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()){
            r = (LiteRow) e.nextElement();
            LiteWebBusinessObject wbo = fabricateBusObj(r);
            try {
                if(r.getString("CONFIG_VALUE") != null){
                    wbo.setAttribute("value", r.getString("CONFIG_VALUE"));
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(ExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            result.add(wbo);
        }
        return result;
    }
}