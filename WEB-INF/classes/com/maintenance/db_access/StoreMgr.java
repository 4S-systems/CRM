package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;

public class StoreMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static StoreMgr storeMgr = new StoreMgr();

    public static StoreMgr getInstance() {
        logger.info("Getting StoreMgr Instance ....");
        return storeMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("store.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request) {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(request.getParameter("storeName")));
        params.addElement(new StringValue(request.getParameter("storeNo")));
        params.addElement(new StringValue(request.getParameter("location")));
        params.addElement(new StringValue(request.getParameter("empID")));
        params.addElement(new StringValue(request.getParameter("phone")));
        params.addElement(new StringValue(waUser.getAttribute("userId").toString()));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertStoreSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean saveExcelObject(HttpServletRequest request, Vector data) {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(data.elementAt(0).toString()));
        params.addElement(new StringValue(data.elementAt(1).toString()));
        params.addElement(new StringValue(data.elementAt(2).toString()));
        params.addElement(new StringValue(data.elementAt(3).toString()));
        params.addElement(new StringValue(data.elementAt(4).toString()));
        params.addElement(new StringValue(waUser.getAttribute("userId").toString()));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertStoreSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("storeName"));
        }

        return cashedData;
    }

    public boolean updateStore(HttpServletRequest request) {
        Vector params = new Vector();

        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(request.getParameter("storeName")));
        params.addElement(new StringValue(request.getParameter("storeNo")));
        params.addElement(new StringValue(request.getParameter("location")));
        params.addElement(new StringValue(request.getParameter("empID")));
        params.addElement(new StringValue(request.getParameter("phone")));
        params.addElement(new StringValue(request.getParameter("storeID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateStoreSQL").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            cashData();
        } catch (SQLException se) {
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean checkExcelHeader(String[] headers, HSSFSheet sheet) {
        boolean isRightHeader = true;

        HSSFRow header = sheet.getRow(sheet.getFirstRowNum());

        int colNo = header.getLastCellNum() - header.getFirstCellNum();
        if (colNo != headers.length) {
            isRightHeader = false;
        } else {
            for (int i = 0; i < headers.length; i++) {
                HSSFCell cell = header.getCell((short) i);

                if (cell.getStringCellValue().toString().equalsIgnoreCase(headers[i]) == false) {
                    isRightHeader = false;
                    break;
                }
            }
        }

        return isRightHeader;
    }

    public Vector createExcelData(HSSFRow row) {
        Vector rowData = new Vector();

        for (int i = row.getFirstCellNum(); i < row.getLastCellNum(); i++) {
            HSSFCell cell = row.getCell((short) i);

            String stringCellValue = "";

            if (cell.getCellType() == 0) {
                Double intCellValue = new Double(cell.getNumericCellValue());
                rowData.addElement(new Integer(intCellValue.intValue()).toString());
            } else {
                stringCellValue = cell.getStringCellValue();
                rowData.addElement(stringCellValue);
            }
        }

        return rowData;
    }
    
    public boolean addSpareTypesStore(String strID, String typID, String usrID) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        Calendar calendar = Calendar.getInstance();

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(strID));
        params.addElement(new StringValue(typID));
        params.addElement(new TimestampValue(new Timestamp(calendar.getTime().getTime())));
        params.addElement(new StringValue(usrID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("addSpareTypesStore").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }
    
    public ArrayList<WebBusinessObject> getNotSpareTypesStore(String strID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
       
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            
            parameters.addElement(new StringValue(strID));
            
            forQuery.setSQLQuery(sqlMgr.getSql("getNotSpareTypesStore").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("PROJECT_ID") != null) {
                        wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                    } else {
                        wbo.setAttribute("projectID", "");
                    }
                    
                    if (r.getString("PROJECT_NAME") != null) {
                        wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                    } else {
                        wbo.setAttribute("projectName", "");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(StoreMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(StoreMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getSpareTypesStore(String strID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
       
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            
            parameters.addElement(new StringValue(strID));
            
            forQuery.setSQLQuery(sqlMgr.getSql("getSpareTypesStore").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("PROJECT_ID") != null) {
                        wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                    } else {
                        wbo.setAttribute("projectID", "");
                    }
                    
                    if (r.getString("PROJECT_NAME") != null) {
                        wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                    } else {
                        wbo.setAttribute("projectName", "");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(StoreMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(StoreMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getAllSpareStore(String strID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
       
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            
            parameters.addElement(new StringValue(strID));
            
            forQuery.setSQLQuery(sqlMgr.getSql("getAllSpareStore").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("PROJECT_ID") != null) {
                        wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                    } else {
                        wbo.setAttribute("projectID", "");
                    }
                    
                    if (r.getString("PROJECT_NAME") != null) {
                        wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                    } else {
                        wbo.setAttribute("projectName", "");
                    }
                    
                    if (r.getString("OPTION_ONE") != null) {
                        wbo.setAttribute("optionOne", r.getString("OPTION_ONE"));
                    } else {
                        wbo.setAttribute("optionOne", "0");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(StoreMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(StoreMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
