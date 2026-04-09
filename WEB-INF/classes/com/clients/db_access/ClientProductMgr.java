package com.clients.db_access;

import com.maintenance.common.Tools;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import com.tracker.db_access.ProjectMgr;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.ArrayList;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientProductMgr extends RDBGateWay {

    private static final ClientProductMgr clientProductMgr = new ClientProductMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ClientProductMgr getInstance() {
        logger.info("Getting ClientProductMgr Instance ....");
        return clientProductMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }

        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_projects.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("projectName"));
        }

        return cashedData;
    }

    public boolean saveClientProduct(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
//        String userId = (String) waUser.getAttribute("loggedUser");
        String id = UniqueIDGen.getNextID();
        String userId = (String) request.getAttribute("userID");
        String clientId = request.getParameter("clientId");
        String productId = request.getParameter("productId");
        String productCategoryId = request.getParameter("productCategoryId");
        String productName = request.getParameter("productName");
        String productCategoryName = request.getParameter("productCategoryName");
        String budget = request.getParameter("budget");
        String period = request.getParameter("period");
        String paymentSystem = request.getParameter("paymentSystem");
        String notes = request.getParameter("notes");
        String unitValue = request.getParameter("unitValue");
        String reservationValue = request.getParameter("reservationValue");
        String contractValue = request.getParameter("contractValue");
        String plotArea = request.getParameter("plotArea");
        String buildingArea = request.getParameter("buildingArea");
        String beforeDiscount = request.getParameter("beforeDiscount");

//        String servLevel = "0";
//        String depCode = null;
//        String ownerComplaint = (String) request.getAttribute("userId");
//        ProjectMgr projectMgr = ProjectMgr.getInstance();
//        WebBusinessObject wboProj = new WebBusinessObject();
        Vector params = new Vector();

        params.addElement(new StringValue(id));
//        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(clientId));
        params.addElement(new StringValue(productId));
        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(productId));
        params.addElement(new StringValue(productCategoryId));
        params.addElement(new StringValue(budget));
        params.addElement(new StringValue(period));
        params.addElement(new StringValue(paymentSystem));
        params.addElement(new StringValue(notes));
        params.addElement(new StringValue(productName));
        params.addElement(new StringValue(productCategoryName));
        params.addElement(new StringValue(unitValue));
        params.addElement(new StringValue(reservationValue));
        params.addElement(new StringValue(contractValue));
        params.addElement(new StringValue(plotArea));
        params.addElement(new StringValue(buildingArea));
        params.addElement(new StringValue(beforeDiscount));

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientProduct").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            connection.close();
        }

        return (queryResult > 0);
    }

    public WebBusinessObject saveInterestedProduct(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = (String) waUser.getAttribute("userId");
        String id = UniqueIDGen.getNextID();
//        String userId = (String) request.getAttribute("userID");
        String clientId = (String) request.getAttribute("clientId");
        String productId = (String) request.getAttribute("productId");
        String productCategoryId = (String) request.getAttribute("productCategoryId");
        String productName = (String) request.getAttribute("productName");
        String productCategoryName = (String) request.getAttribute("productCategoryName");
        String budget = (String) request.getAttribute("budget");
        String period = (String) request.getAttribute("period");
        String paymentSystem = (String) request.getAttribute("paymentSystem");
        String notes = (String) request.getAttribute("notes");
        String unitValue = request.getParameter("unitValue");
        String reservationValue = request.getParameter("reservationValue");
        String contractValue = request.getParameter("contractValue");
        String plotArea = request.getParameter("plotArea");
        String buildingArea = request.getParameter("buildingArea");
        String beforeDiscount = request.getParameter("beforeDiscount");

        Vector params = new Vector();

        params.addElement(new StringValue(id));
//        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(clientId));
        params.addElement(new StringValue(productId));
        params.addElement(new StringValue(userId));
        params.addElement(new StringValue("interested"));
        params.addElement(new StringValue(productCategoryId));
        params.addElement(new StringValue(budget));
        params.addElement(new StringValue(period));
        params.addElement(new StringValue(paymentSystem));
        params.addElement(new StringValue(notes));
        params.addElement(new StringValue(productName));
        params.addElement(new StringValue(productCategoryName));
        params.addElement(new StringValue(unitValue));
        params.addElement(new StringValue(reservationValue));
        params.addElement(new StringValue(contractValue));
        params.addElement(new StringValue(plotArea));
        params.addElement(new StringValue(buildingArea));
        params.addElement(new StringValue(beforeDiscount));

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientProduct").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {

                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(id);
        return wbo;
    }
    
    public WebBusinessObject updateInterestedProduct(String codeWish, String codeWishReal) throws SQLException {
        codeWish = (String) codeWish;
        codeWishReal = (String) codeWishReal;
        
        Vector params = new Vector();

        params.addElement(new StringValue(codeWishReal));
        params.addElement(new StringValue(codeWish));

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forUpdate = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateClientProducts").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            if (queryResult < 0) {

                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(codeWish);
        return wbo;
    }
    
    public WebBusinessObject saveInterestedProductRealEstat(String ReservCard_CodeClient,WebBusinessObject clientInfo, String projectDatabase,WebBusinessObject clientAotherPhone) throws SQLException {
        String userId = (String) projectDatabase;
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        String getAssetErpPassword = metaDataMgr.getAssetErpPassword().toString();
        String dataBaseRealEstat = null;
        if (userId.equals(getAssetErpName)){
           dataBaseRealEstat = metaDataMgr.getStoreErpName().toString();
        } else if (userId.equals(getAssetErpPassword)){
           dataBaseRealEstat = metaDataMgr.getStoreErpPassword().toString();
        } 
        String clientNO = ReservCard_CodeClient;
        String name = (String) clientInfo.getAttribute("name");
        String address = (String) clientInfo.getAttribute("address");
        String mobile = (String) clientInfo.getAttribute("mobile");
        String nationality = (String) clientInfo.getAttribute("nationality");
        String clientSsn = (String) clientInfo.getAttribute("clientSsn");
        WebBusinessObject jobs = new WebBusinessObject();
        jobs = TradeMgr.getInstance().getOnSingleKey((String) clientInfo.getAttribute("job"));
        String job = "";
        if (jobs == null){
           job = "";
        } else {
           job = (String) jobs.getAttribute("tradeName");
        }
        
        String gender = (String) clientInfo.getAttribute("gender");
        String genderStatus = null;
        if (gender.equals("ذكر")){
        genderStatus = "1";
        } else {
        genderStatus = "2";
        }
        String birthDateReal = (String) clientInfo.getAttribute("birthDate");
        String birthDate= "";
        // Define the format for the desired output
        SimpleDateFormat desiredDateFormat = new SimpleDateFormat("dd/MM/yy");

        try {
            // Format the Date object into the desired output format
            birthDate = desiredDateFormat.format(birthDateReal);
        } catch (Exception e) {
        }
        String email = (String) clientInfo.getAttribute("email");
        String anotherPhone = "";
        if (clientAotherPhone == null) {
            anotherPhone = "";
        } else {
           anotherPhone = (String) clientAotherPhone.getAttribute("communicationValue");
        }

        Vector params = new Vector();

        params.addElement(new StringValue(clientNO));
        params.addElement(new StringValue(name));
        params.addElement(new StringValue(address));
        params.addElement(new StringValue(mobile));
        params.addElement(new StringValue(nationality));
        params.addElement(new StringValue(clientSsn));
        params.addElement(new StringValue(job));
        params.addElement(new StringValue(genderStatus));
        params.addElement(new StringValue(birthDate));
        params.addElement(new StringValue(email));
        params.addElement(new StringValue(anotherPhone));


        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstate").replace("datebase", dataBaseRealEstat).trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {

                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(clientNO);
        return wbo;
    }

    public WebBusinessObject saveInterestedProductRealEstatWifi(String id,String codeId,WebBusinessObject clientInfo,String trnsNo,String storeNo,String itemCode,String priceItem) throws SQLException, InterruptedException {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        
        String clientNO = id;
        String clientNOStore = codeId;
        String name = (String) clientInfo.getAttribute("name");
        String mobile = (String) clientInfo.getAttribute("mobile");
        String trnsNoId = trnsNo;
        String storeNoId = storeNo;
        String itemId = itemCode;
        String priceNo = priceItem;
        
        Vector params = new Vector();
        Vector paramsTel = new Vector();
        Vector paramsStoreM = new Vector();
        Vector paramsStoreO = new Vector();
        
        params.addElement(new StringValue(clientNO));
        params.addElement(new StringValue(name));
        params.addElement(new StringValue(name));
        params.addElement(new StringValue(clientNOStore));
        
        paramsTel.addElement(new StringValue(clientNOStore));
        paramsTel.addElement(new StringValue(mobile));
        
        paramsStoreM.addElement(new StringValue(trnsNoId));
        paramsStoreM.addElement(new StringValue(clientNOStore));
        paramsStoreM.addElement(new StringValue(storeNoId));
        paramsStoreM.addElement(new StringValue(priceNo));
        
        paramsStoreO.addElement(new StringValue(storeNoId));
        paramsStoreO.addElement(new StringValue(itemId));
        paramsStoreO.addElement(new StringValue(priceNo));
        
        
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWifi").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(params);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(3000);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }
            
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWifiTel").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(paramsTel);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(3000);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }
            
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWifiStoreM").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(paramsStoreM);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(3000);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }
            
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWifiStoreO").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(paramsStoreO);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(3000);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }
            
            
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(clientNO);
        return wbo;
    }
    
    public WebBusinessObject saveClientRealEsatate(String id,String codeId,WebBusinessObject clientInfo) throws SQLException, InterruptedException {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        
        String clientNO = id;
        String clientNOStore = codeId;
        String name = (String) clientInfo.getAttribute("name");
        String mobile = (String) clientInfo.getAttribute("mobile");
        
        Vector params = new Vector();
        Vector paramsTel = new Vector();
        
        params.addElement(new StringValue(clientNO));
        params.addElement(new StringValue(name));
        params.addElement(new StringValue(name));
        //params.addElement(new StringValue(clientNOStore));
        
        paramsTel.addElement(new StringValue(name));
        paramsTel.addElement(new StringValue(clientNO));
        paramsTel.addElement(new StringValue(mobile));
        
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWifi").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(params);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(1500);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }
            
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWifiTel").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(paramsTel);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(1500);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }       
            
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(clientNO);
        return wbo;
    }
    
    public WebBusinessObject saveClientRealEsatateWeb(String id,String codeId,WebBusinessObject clientInfo) throws SQLException, InterruptedException {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        
        String clientNO = id;
        String clientNOStore = codeId;
        String name = (String) clientInfo.getAttribute("name");
        String mobile = (String) clientInfo.getAttribute("mobile");
        
        Vector params = new Vector();
        Vector paramsTel = new Vector();
        
        params.addElement(new StringValue(clientNO));
        params.addElement(new StringValue(name));
        params.addElement(new StringValue(name));
        params.addElement(new StringValue(clientNOStore));
        
        paramsTel.addElement(new StringValue(clientNOStore));
        paramsTel.addElement(new StringValue(mobile));
        
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWifi").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(params);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(1500);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }
            
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWifiTel").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(paramsTel);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(1500);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }       
            
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(clientNO);
        return wbo;
    }
    
    public WebBusinessObject saveClientRealEsatateWebReserv(String getUnitId, String getUserCode, String getMaxClientIdStore, WebBusinessObject clientInfo, String budget, String instProg) throws SQLException, InterruptedException {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        
        String UnitId = getUnitId;
        String UserCode = getUserCode;
        String getMaxClientName = (String) clientInfo.getAttribute("name");
        String MaxClientIdStore = getMaxClientIdStore;
        String getBudget = budget;
        String getInstProg = instProg;
        
        Vector params = new Vector();
        Vector paramsTel = new Vector();
        
        params.addElement(new StringValue(UnitId));
        params.addElement(new StringValue(UserCode));
        params.addElement(new StringValue(getMaxClientName));
        params.addElement(new StringValue(MaxClientIdStore));
        params.addElement(new StringValue(getBudget));
        params.addElement(new StringValue(getInstProg));
        
        System.out.println("INSTITEMID: " + UnitId);
System.out.println("RESERVED_BY: " + UserCode);
System.out.println("Aname: " + getMaxClientName);
System.out.println("Code: " + MaxClientIdStore);
System.out.println("Deposit: " + getBudget);
System.out.println("INSTPROGID: " + getInstProg);

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientRealEstateWeb").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(params);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(1500);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }
                       
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(UnitId);
        return wbo;
    }
    
    public WebBusinessObject saveDataRealEstateWebAllCode(String getUnitId, String getUserCode) throws SQLException, InterruptedException {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        
        String UnitId = getUnitId;
        String UserCode = getUserCode;
        
        Vector params = new Vector();
        
        params.addElement(new StringValue(UnitId));
        params.addElement(new StringValue(UserCode));
        params.addElement(new StringValue(UserCode));
        
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveDataRealEstateWebAllCode").replace("datebase", getAssetErpName).trim());
            forInsert.setparams(params);
            try {
                   queryResult = forInsert.executeUpdate();
                   Thread.sleep(1500);
                   if (queryResult < 0) {
                        return null;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt(); // Restore interrupt flag
                    logger.error("Operation interrupted", e);
                    return null;
                } catch (SQLException e) {
                    logger.error("Database error", e);
                    return null;
                }
                       
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(UnitId);
        return wbo;
    }
    
    public WebBusinessObject saveInterestedProductRealEstatQuestion(HttpServletRequest request,String clientInfo, String projectDatabase, String QUESTIONNAIRE_CODE) throws SQLException {
        String userId = (String) projectDatabase;
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        String getAssetErpPassword = metaDataMgr.getAssetErpPassword().toString();
        String dataBaseRealEstat = null;
        if (userId.equals(getAssetErpName)){
           dataBaseRealEstat = metaDataMgr.getStoreErpName().toString();
        } else if (userId.equals(getAssetErpPassword)){
           dataBaseRealEstat = metaDataMgr.getStoreErpPassword().toString();
        } 
        String codeRealEstate = (String) QUESTIONNAIRE_CODE;
        String mainBuilding = (String) request.getAttribute("mainBuilding");
        String clientNO = clientInfo;
        String typeUnit = (String) request.getAttribute("typeUnit");
        String budgetType = (String) request.getAttribute("budgetType");
        int index = budgetType.indexOf("-");
        String budgetTypeBefore = budgetType.substring(0, index);
        String budgetTypeAfter = budgetType.substring(index + 1);
        String priceWish = (String) request.getAttribute("priceWish");
        int indexPriceWish = priceWish.indexOf("-");
        String priceWishBefore = priceWish.substring(0, indexPriceWish);
        String priceWishAfter = priceWish.substring(indexPriceWish + 1);
        String perCentWish = (String) request.getAttribute("perCentWish");
        String amountWish = (String) request.getAttribute("amountWish");
        String unitNotesReceiot = (String) request.getAttribute("unitNotesReceiot");
        String paymentSystemInterested = (String) request.getAttribute("paymentSystemInterested");
        String sourceClient = (String) request.getAttribute("sourceClient");
        String sourceClientName = (String) request.getAttribute("sourceClientName");

        Vector params = new Vector();

        params.addElement(new StringValue(clientNO));
        params.addElement(new StringValue(mainBuilding));
        params.addElement(new StringValue(budgetTypeBefore));
        params.addElement(new StringValue(priceWishBefore));
        params.addElement(new StringValue(amountWish));
        params.addElement(new StringValue(unitNotesReceiot));
        params.addElement(new StringValue(paymentSystemInterested));
        params.addElement(new StringValue(sourceClient));
        params.addElement(new StringValue(sourceClientName));
        params.addElement(new StringValue(budgetTypeAfter));
        params.addElement(new StringValue(priceWishAfter));
        params.addElement(new StringValue(codeRealEstate));
        params.addElement(new StringValue(typeUnit));
        params.addElement(new StringValue(perCentWish));

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("interestedProductRealEstatQuestion").replace("datebase", dataBaseRealEstat).trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {

                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(clientNO);
        return wbo;
    }

    public WebBusinessObject updateInterestedProduct(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = (String) waUser.getAttribute("userId");
        String id = (String) request.getAttribute("id");
//        String userId = (String) request.getAttribute("userID");
        String clientId = (String) request.getAttribute("clientId");
        String productId = (String) request.getAttribute("productId");
        String productCategoryId = (String) request.getAttribute("productCategoryId");
        String productName = (String) request.getAttribute("productName");
        String productCategoryName = (String) request.getAttribute("productCategoryName");
        String budget = (String) request.getAttribute("budget");
        String period = (String) request.getAttribute("period");
        String paymentSystem = (String) request.getAttribute("paymentSystem");
        String notes = (String) request.getAttribute("notes");

        Vector params = new Vector();

//        params.addElement(new StringValue(id));
//        params.addElement(new StringValue(userId));
//        params.addElement(new StringValue(clientId));
        params.addElement(new StringValue(productId));
//        params.addElement(new StringValue(userId));
//        params.addElement(new StringValue("interested"));
        params.addElement(new StringValue(productCategoryId));
        params.addElement(new StringValue(budget));
        params.addElement(new StringValue(period));
        params.addElement(new StringValue(paymentSystem));
        params.addElement(new StringValue(notes));
        params.addElement(new StringValue(productName));
        params.addElement(new StringValue(productCategoryName));

        params.addElement(new StringValue((String) request.getAttribute("id")));

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateClientProduct").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {

                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            connection.close();
        }

        WebBusinessObject wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        wbo = clientProductMgr.getOnSingleKey(id);
        return wbo;
    }

    public boolean deleteProduct(String id, String res, String issue) throws NoUserInSessionException, SQLException {
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            Vector params = new Vector();
            params.addElement(new StringValue(id));

//            beginTransaction();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("deleteProduct").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {

                return false;
            }

            if (res != null) {
                params = new Vector();
                params.addElement(new StringValue(res));
                forInsert.setConnection(connection);

                forInsert.setSQLQuery(sqlMgr.getSql("deleteReservation").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {

                    return false;
                }
            }

            if (issue != null) {
                params = new Vector();
                params.addElement(new StringValue(issue));
                forInsert.setConnection(connection);

                forInsert.setSQLQuery(sqlMgr.getSql("updateIssueStatus").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    return false;
                }
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
//            connection.setAutoCommit(true);
            connection.close();
        }

        return true;
    }

    public Vector getReservedUnit(String clientId) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getReservedUnit").trim();
        try {
            param.add(new StringValue(clientId));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("RES_ID") != null) {
                    wbo.setAttribute("resID", r.getString("RES_ID"));
                }

                if (r.getString("ISS_ID") != null) {
                    wbo.setAttribute("issID", r.getString("ISS_ID"));
                }

                if (r.getString("PROJECT_DESCRIPTION") != null) {
                    wbo.setAttribute("desc", r.getString("PROJECT_DESCRIPTION"));
                }

                try {
                    if (r.getBigDecimal("AREA") != null) {
                        wbo.setAttribute("area", r.getString("AREA"));
                    } else {
                        wbo.setAttribute("area", "---");
                    }
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
                    wbo.setAttribute("price", "---");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("rowId", r.getString("ID"));
                } else {
                    wbo.setAttribute("rowId", "---");
                }

                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public Vector getInterestedUnit(String clientId) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getInterestedUnit").trim();
        try {
            param.add(new StringValue(clientId));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
    
    public Vector getClientInterests(String clientId) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getInterestedUnit").trim();
        try {
            param.add(new StringValue(clientId));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public Vector getViewsUnit(String clientId) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getViewsUnit").trim();
        try {
            param.add(new StringValue(clientId));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("ClientName", r.getString("NAME"));
                }

                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("ClientMobile", r.getString("MOBILE"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("project_id", r.getString("PROJECT_ID"));
                }

                if (r.getString("PRODUCT_CATEGORY_ID") != null) {
                    wbo.setAttribute("productCategoryID", r.getString("PRODUCT_CATEGORY_ID"));
                } else {
                    wbo.setAttribute("productCategoryID", "---");
                }

                if (r.getString("PRODUCT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PRODUCT_NAME"));
                } else {
                    wbo.setAttribute("projectName", "---");
                }

                if (r.getString("PRODUCT_CATEGORY_NAME") != null) {
                    wbo.setAttribute("productCategoryName", r.getString("PRODUCT_CATEGORY_NAME"));
                } else {
                    wbo.setAttribute("productCategoryName", "---");
                }

                if (r.getString("PROJECT_DESCRIPTION") != null) {
                    wbo.setAttribute("productDesc", r.getString("PROJECT_DESCRIPTION"));
                } else {
                    wbo.setAttribute("productDesc", "---");
                }

                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("budget", r.getString("BUDGET"));
                } else {
                    wbo.setAttribute("budget", "---");
                }

                if (r.getString("OPTION1") != null) {
                    wbo.setAttribute("price", r.getString("OPTION1"));
                } else {
                    wbo.setAttribute("price", "---");
                }

                if (r.getString("MAX_PRICE") != null) {
                    wbo.setAttribute("area", r.getString("MAX_PRICE"));
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("rowId", r.getString("ID"));
                }

                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
    
    public Vector getViewsUnitByDate(String clientId, String Date) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getViewsUnitByDate").trim();
        try {
            param.add(new StringValue(clientId));
            param.add(new StringValue(Date));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("ClientName", r.getString("NAME"));
                }

                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("ClientMobile", r.getString("MOBILE"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("project_id", r.getString("PROJECT_ID"));
                }

                if (r.getString("PRODUCT_CATEGORY_ID") != null) {
                    wbo.setAttribute("productCategoryID", r.getString("PRODUCT_CATEGORY_ID"));
                } else {
                    wbo.setAttribute("productCategoryID", "---");
                }

                if (r.getString("PRODUCT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PRODUCT_NAME"));
                } else {
                    wbo.setAttribute("projectName", "---");
                }

                if (r.getString("PRODUCT_CATEGORY_NAME") != null) {
                    wbo.setAttribute("productCategoryName", r.getString("PRODUCT_CATEGORY_NAME"));
                } else {
                    wbo.setAttribute("productCategoryName", "---");
                }

                if (r.getString("PROJECT_DESCRIPTION") != null) {
                    wbo.setAttribute("productDesc", r.getString("PROJECT_DESCRIPTION"));
                } else {
                    wbo.setAttribute("productDesc", "---");
                }

                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("budget", r.getString("BUDGET"));
                } else {
                    wbo.setAttribute("budget", "---");
                }

                if (r.getString("OPTION1") != null) {
                    wbo.setAttribute("price", r.getString("OPTION1"));
                } else {
                    wbo.setAttribute("price", "---");
                }

                if (r.getString("MAX_PRICE") != null) {
                    wbo.setAttribute("area", r.getString("MAX_PRICE"));
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("rowId", r.getString("ID"));
                }

                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public Vector getPurcheUnit(String clientId) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getPurcheUnits").trim();
        try {
            param.add(new StringValue(clientId));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("ClientName", r.getString("NAME"));
                }

                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("ClientMobile", r.getString("MOBILE"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("project_id", r.getString("PROJECT_ID"));
                }

                if (r.getString("PRODUCT_CATEGORY_ID") != null) {
                    wbo.setAttribute("productCategoryID", r.getString("PRODUCT_CATEGORY_ID"));
                } else {
                    wbo.setAttribute("productCategoryID", "---");
                }

                if (r.getString("PRODUCT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PRODUCT_NAME"));
                } else {
                    wbo.setAttribute("projectName", "---");
                }

                if (r.getString("PRODUCT_CATEGORY_NAME") != null) {
                    wbo.setAttribute("productCategoryName", r.getString("PRODUCT_CATEGORY_NAME"));
                } else {
                    wbo.setAttribute("productCategoryName", "---");
                }

                try {
                    if (r.getBigDecimal("AREA") != null) {
                        wbo.setAttribute("area", r.getBigDecimal("AREA"));
                    } else {
                        wbo.setAttribute("area", "---");
                    }
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
                    wbo.setAttribute("price", "---");
                }

                if (r.getString("PROJECT_DESCRIPTION") != null) {
                    wbo.setAttribute("productDesc", r.getString("PROJECT_DESCRIPTION"));
                } else {
                    wbo.setAttribute("productDesc", "---");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("rowId", r.getString("ID"));
                } else {
                    wbo.setAttribute("rowId", "---");
                }

                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public Vector getProductsRatioPerRegion() throws NoSuchColumnException {
        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Connection connection = null;
        forUpdate.setSQLQuery(getQuery("getProductsRatioPerRegion").trim());
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);

            queryResult = forUpdate.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            if (r.getString("region") != null) {
                wbo.setAttribute("region", r.getString("region"));
            } else {
                wbo.setAttribute("region", "");
            }

            wbo.setAttribute("productCount", r.getString("product_count"));
            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public Vector getProductsRatio(String startDate, String endDate) throws NoSuchColumnException {
        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        StringBuilder sql = new StringBuilder();
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" and CP.CREATION_TIME >= ?");
            params.addElement(new DateValue(java.sql.Date.valueOf(startDate)));
        }

        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" and CP.CREATION_TIME <= ?");
            params.addElement(new DateValue(java.sql.Date.valueOf(endDate)));
        }

        forUpdate.setSQLQuery(getQuery("getProductsRatio").trim().replaceAll("whereCreationTime", sql.toString()));
        forUpdate.setparams(params);
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);

            queryResult = forUpdate.executeQuery();
        } catch (SQLException | UnsupportedTypeException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            if (r.getString("product_name") != null) {
                wbo.setAttribute("productName", r.getString("product_name"));
            } else {
                wbo.setAttribute("productName", "");
            }

            if (r.getString("product_count") != null) {
                wbo.setAttribute("productCount", r.getString("product_count"));
            } else {
                wbo.setAttribute("productCount", "");
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    public boolean saveClientProduct(WebBusinessObject clientProductWbo, HttpSession s) throws NoUserInSessionException, SQLException {
        String id = UniqueIDGen.getNextID();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("clientID")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("projectID")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("interested"));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("productCategoryId")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("area"))); //budget
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("period")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("paymentType")));
        params.addElement(new StringValue("UL")); //notes
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("productCategoryName")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("productName")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("unitValue")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("reservationValue")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("contractValue")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("plotArea")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("buildingArea")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("beforeDiscount")));
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientProduct").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {

                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            if (connection != null) {
                connection.close();
            }
        }

        return (queryResult > 0);
    }

    public Vector getClientsWithWidth(java.sql.Date beginDate, java.sql.Date endDate, boolean hasVisits, String groupID) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if (hasVisits) {
            where.append(" AND CLIENT.SYS_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended') ");
        }

        String query = getQuery("getprojectsNameByClientsAndWidth").replaceAll("whereStatement", where.toString()).trim();
        try {
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            param.addElement(new StringValue(groupID != null ? groupID : ""));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("budget", r.getString("BUDGET"));
                } else {
                    wbo.setAttribute("budget", "--");
                }

                if (r.getString("NAME") != null) {
                    wbo.setAttribute("name", r.getString("NAME"));
                }

                if (r.getString("projNm") != null) {
                    wbo.setAttribute("projNm", r.getString("projNm"));
                }

                if (r.getString("unitNm") != null) {
                    wbo.setAttribute("unitNm", r.getString("unitNm"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectId", r.getString("PROJECT_ID"));
                }

                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
//            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
    
    public Vector getMyClientsWithWidth(String UserID, java.sql.Date beginDate, java.sql.Date endDate) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getprojectsNameByMyClientsAndWidth").trim();
        try {
            param.addElement(new StringValue(UserID));
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("budget", r.getString("BUDGET"));
                } else {
                    wbo.setAttribute("budget", "--");
                }

                if (r.getString("NAME") != null) {
                    wbo.setAttribute("name", r.getString("NAME"));
                }

                if (r.getString("projNm") != null) {
                    wbo.setAttribute("projNm", r.getString("projNm"));
                }

                if (r.getString("unitNm") != null) {
                    wbo.setAttribute("unitNm", r.getString("unitNm"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectId", r.getString("PROJECT_ID"));
                }

                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
//            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public boolean updateProductStatus(String id, String newStatus) throws SQLException {
        Vector params = new Vector();
        params.addElement(new StringValue(newStatus));
        params.addElement(new StringValue(id));
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forUpdate = new SQLCommandBean();
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateProductStatus").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            if (queryResult < 0) {
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            if (connection != null) {
                connection.close();
            }
        }

        return (queryResult > 0);
    }

    public boolean canceledReservation(String id) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(id));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("canceledReservation"));
            command.setparams(parameters);
            result = command.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        return (result > 0);
    }

    public boolean isClientReservedUnits(String clientId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;

        parameters.addElement(new StringValue(clientId));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("isClientReservedUnits").trim());
            command.setparams(parameters);
            result = command.executeQuery();
            for (Row row : result) {
                int units = row.getInt("NUMBER_UNITS");
                return (units > 0);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } catch (UnsupportedTypeException se) {
            logger.error(se.getMessage());
            return false;
        } catch (NoSuchColumnException se) {
            logger.error(se.getMessage());
            return false;
        } catch (UnsupportedConversionException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException se) {
                    logger.error(se.getMessage());
                    return false;
                }
            }
        }

        return false;
    }

    public boolean saveImplicitClientQuery(String clientId, String userId, WebBusinessObject wbo) throws NoUserInSessionException, SQLException {
        SQLCommandBean command = new SQLCommandBean();
        int queryResult;

        Vector parameters = new Vector();
        String id = UniqueIDGen.getNextID();
        String productId = (String) wbo.getAttribute("productId");
        String productCategoryId = (String) wbo.getAttribute("productCategoryId");
        String productName = (String) wbo.getAttribute("productName");
        String productCategoryName = (String) wbo.getAttribute("productCategoryName");
        String budget = (String) wbo.getAttribute("budget");
        String period = (String) wbo.getAttribute("period");
        String paymentSystem = (String) wbo.getAttribute("paymentSystem");
        String notes = (String) wbo.getAttribute("notes");

        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(clientId));
        parameters.addElement(new StringValue(productId));
        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue("interested"));
        parameters.addElement(new StringValue(productCategoryId));
        parameters.addElement(new StringValue(budget));
        parameters.addElement(new StringValue(period));
        parameters.addElement(new StringValue(paymentSystem));
        parameters.addElement(new StringValue(notes));
        parameters.addElement(new StringValue(productName));
        parameters.addElement(new StringValue(productCategoryName));
        parameters.addElement(new StringValue(""));
        parameters.addElement(new StringValue(""));
        parameters.addElement(new StringValue(""));
        parameters.addElement(new StringValue(""));
        parameters.addElement(new StringValue(""));
        parameters.addElement(new StringValue(""));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("insertClientProduct").trim());
            command.setparams(parameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            if (connection != null) {
                connection.rollback();
            }

            return false;

        } finally {
            if (connection != null) {
                connection.commit();
                connection.close();
            }
        }

        return (queryResult > 0);
    }

    public boolean updateReservedUnit(HttpServletRequest request) {
        //String budget = (String) request.getParameter("budget");
        String budget = (String) request.getParameter("000");
        String period = (String) request.getParameter("period");
        String paymentSystem = (String) request.getParameter("paymentSystem");
        //String notes = (String) request.getParameter("paymentPlace");
        String notes = (String) request.getParameter("addtions");
        String unitValue = (String) request.getParameter("unitValue");
        String reservationValue = (String) request.getParameter("reservationValue");
        String contractValue = (String) request.getParameter("contractValue");
        String plotArea = (String) request.getParameter("plotArea");
        String buildingArea = (String) request.getParameter("buildingArea");
        String beforeDiscount = (String) request.getParameter("beforeDiscount");
        String clientProductID = (String) request.getParameter("clientProductID");

        Vector params = new Vector();
        params.addElement(new StringValue(budget));
        params.addElement(new StringValue(period));
        params.addElement(new StringValue(paymentSystem));
        params.addElement(new StringValue(notes));
        params.addElement(new StringValue(unitValue));
        params.addElement(new StringValue(reservationValue));
        params.addElement(new StringValue(contractValue));
        params.addElement(new StringValue(plotArea));
        params.addElement(new StringValue(buildingArea));
        params.addElement(new StringValue(beforeDiscount));
        params.addElement(new StringValue(clientProductID));

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateReservedUnit").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        return true;
    }

    public ArrayList<WebBusinessObject> getClientProductWidthRatio(java.sql.Date beginDate, java.sql.Date endDate, boolean hasVisits, String groupID) {
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if (hasVisits) {
            where.append(" AND CLIENT.SYS_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended') ");
        }
        String query = getQuery("getClientProductWidthRatio").replaceAll("whereStatement", where.toString()).trim();
        try {
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            param.addElement(new StringValue(groupID != null ? groupID : ""));
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            param.addElement(new StringValue(groupID != null ? groupID : ""));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        WebBusinessObject wbo;
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("unitWidth", r.getString("BUDGET"));
                }

                if (r.getString("TOTAL") != null) {
                    wbo.setAttribute("total", r.getString("TOTAL"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getMyClientProductWidthRatio(String UserID, java.sql.Date beginDate, java.sql.Date endDate) {
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getMyClientProductWidthRatio").trim();
        try {
            param.addElement(new StringValue(UserID));
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        WebBusinessObject wbo;
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("unitWidth", r.getString("BUDGET"));
                }

                if (r.getString("TOTAL") != null) {
                    wbo.setAttribute("total", r.getString("TOTAL"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public WebBusinessObject getReservedlientProduct(String clientId, String unitID) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getReservedlientProduct").trim();
        try {
            param.add(new StringValue(clientId));
            param.add(new StringValue(unitID));

            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
        }

        return wbo;
    }

    public boolean saveClientProductPartner(WebBusinessObject clientProductWbo) {
        String id = UniqueIDGen.getNextID();

        Vector params = new Vector();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("clientId")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("projectId")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("createdBy")));
        params.addElement(new StringValue("reserved"));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("productCategoryId")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("budget"))); //budget
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("period")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("paymentSystem")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("note"))); //notes
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("productCategoryName")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("productName")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("unitValue")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("reservationValue")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("contractValue")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("plotArea")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("buildingArea")));
        params.addElement(new StringValue((String) clientProductWbo.getAttribute("beforeDiscount")));
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientProduct").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
                    return false;
                }
            }
        }

        return (queryResult > 0);
    }

    public boolean updateClientSProject(String prjID, String prjNm, String usrID, String[] clntIds, String prvPrj) {
        Vector params = new Vector();
        params.addElement(new StringValue(prjID));
        params.addElement(new StringValue(prjID));
        params.addElement(new StringValue(prjNm));
        params.addElement(new StringValue(usrID));

        StringBuilder clntIDSStr = new StringBuilder();
        for (int i = 0; i < clntIds.length; i++) {
            if (clntIDSStr.length() > 0) {
                clntIDSStr.append(", ?");
            } else {
                clntIDSStr.append("?");
            }

            params.addElement(new StringValue(clntIds[i]));
        }

        params.addElement(new StringValue(prvPrj));
        params.addElement(new StringValue(prvPrj));

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateClientSProject").replaceAll("clntIDS", clntIDSStr.toString()).trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
                return false;
            }
        }

        return true;
    }

    public ArrayList<WebBusinessObject> viewMyPurchUnits(HttpSession session, Date fromDate, Date toDate) {
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("viewMyPurchUnits").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT") != null) {
                    wbo.setAttribute("project", r.getString("PROJECT"));
                }

                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }

                if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY"));
                }

                if (r.getString("UNIT") != null) {
                    wbo.setAttribute("unit", r.getString("UNIT"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }

                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
                    wbo.setAttribute("area", "---");
                }

                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
                    wbo.setAttribute("price", "---");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("id", r.getString("ID"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectId", r.getString("PROJECT_ID"));
                }

                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("CLIENT_ID"));
                }

                if (r.getString("distTo") != null) {
                    wbo.setAttribute("distTo", r.getString("distTo"));
                } else {
                    wbo.setAttribute("distTo", "---");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> viewMyViewsUnits(HttpSession session, Date fromDate, Date toDate) {
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("viewMyViewsUnits").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT") != null) {
                    wbo.setAttribute("project", r.getString("PROJECT"));
                }

                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }

                if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY"));
                }

                if (r.getString("UNIT") != null) {
                    wbo.setAttribute("unit", r.getString("UNIT"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }

                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
                    wbo.setAttribute("area", "---");
                }

                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
                    wbo.setAttribute("price", "---");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("id", r.getString("ID"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectId", r.getString("PROJECT_ID"));
                }

                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("CLIENT_ID"));
                }
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                } else {
                    wbo.setAttribute("mobile", "---");
                }
                
                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("mail", r.getString("EMAIL"));
                } else {
                    wbo.setAttribute("mail", "---");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> viewClientsViewsUnits(Date fromDate, Date toDate, boolean hasVisitsOnly, String minArea, String maxArea) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        if (hasVisitsOnly) {
            where.append(" AND CP.CLIENT_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended')");
        }
        if (minArea != null && !minArea.isEmpty()) {
            where.append(" AND UP.MAX_PRICE >= ").append(minArea);
        }
        if (maxArea != null && !maxArea.isEmpty()) {
            where.append(" AND UP.MAX_PRICE <= ").append(maxArea);
        }
        try {
            String query = getQuery("viewClientsViewsUnits").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT") != null) {
                    wbo.setAttribute("project", r.getString("PROJECT"));
                }

                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }

                if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY"));
                }

                if (r.getString("UNIT") != null) {
                    wbo.setAttribute("unit", r.getString("UNIT"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }

                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
                    wbo.setAttribute("area", "---");
                }

                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
                    wbo.setAttribute("price", "---");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("id", r.getString("ID"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectId", r.getString("PROJECT_ID"));
                }

                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("CLIENT_ID"));
                }
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                } else {
                    wbo.setAttribute("mobile", "---");
                }
                
                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("mail", r.getString("EMAIL"));
                } else {
                    wbo.setAttribute("mail", "---");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> viewSalesUnits(Date fromDate, Date toDate) {
        Vector queryResult = new Vector();
        Vector params = new Vector();

        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("viewSalesUnits").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT") != null) {
                    wbo.setAttribute("project", r.getString("PROJECT"));
                }

                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }

                if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY"));
                }

                if (r.getString("UNIT") != null) {
                    wbo.setAttribute("unit", r.getString("UNIT"));
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }

                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
                    wbo.setAttribute("area", "---");
                }

                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
                    wbo.setAttribute("price", "0");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("id", r.getString("ID"));
                }

                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectId", r.getString("PROJECT_ID"));
                }

                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("CLIENT_ID"));
                }
                if (r.getString("REGISTRATION_DATE") != null) {
                    wbo.setAttribute("registrationDate", r.getString("REGISTRATION_DATE"));
                }

                wbo.setAttribute("modelName", r.getString("MODEL_NAME") != null ? r.getString("MODEL_NAME") : "---");
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public ArrayList<String> getSalesTotalByYear(String year) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(year));
        try {
            String query = getQuery("getSalesTotalByYear").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        ArrayList<String> result = new ArrayList<>();
        for (int i = 0; i < 12; i++) {
            result.add("0");
        }

        Row r;
        Enumeration e = queryResult.elements();
        int month;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                if (r.getBigDecimal("MONTH") != null && r.getBigDecimal("TOTAL_VALUE") != null) {
                    month = r.getBigDecimal("MONTH").intValue();
                    result.set(month - 1, r.getBigDecimal("TOTAL_VALUE") + "");
                }
            } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                Logger.getLogger(ReservationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return result;
    }
    
    public WebBusinessObject getReserveSellUser(String unitID, String type) {
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getReserveSellUser").trim();
        try {
            param.add(new StringValue(unitID));
            param.add(new StringValue(type));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if(r.getString("USER_ID") != null) {
                    wbo.setAttribute("userID", r.getString("USER_ID"));
                }
                if(r.getString("USER_NAME") != null) {
                    wbo.setAttribute("userName", r.getString("USER_NAME"));
                }
                if(r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientProductMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            return wbo;
        }
        return wbo;
    }
}
