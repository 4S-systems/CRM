package com.contractor.db_access;

import com.maintenance.common.EquipmentWorkOrderTools;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.xml.DOMFabricatorBean;
import com.silkworm.business_objects.*;
import com.tracker.db_access.ProjectMgr;
import java.util.*;
import com.silkworm.persistence.relational.*;
import com.silkworm.events.*;
import java.sql.*;
import com.maintenance.db_access.UnitScheduleMgr;
import com.silkworm.common.FilterQuery;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.StringValue;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class MaintainableMgr extends RDBGateWay {

    Vector businessObjectEventListeners = null;
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static MaintainableMgr maintainableMgr = new MaintainableMgr();

    private MaintainableMgr() {
    }

    public static MaintainableMgr getInstance() {
        logger.info("Getting Maintainable Mgr Instance ....");
        return maintainableMgr;
    }

    public boolean deletObject(WebBusinessObject wbo) throws java.sql.SQLException {

        Vector params = new Vector();
        SQLCommandBean forDelete = new SQLCommandBean();
        int queryResult = -1000;
        int qResult = -1000;
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        Connection connection = dataSource.getConnection();
        try {
            forDelete.setConnection(connection);
            forDelete.setSQLQuery(sqlMgr.getSql("deleteMaintainableUnit").trim());
            forDelete.setparams(params);
            qResult = forDelete.executeUpdate();
            params.clear();
            params.addElement(new StringValue((String) wbo.getAttribute("id")));
            forDelete.setSQLQuery(sqlMgr.getSql("deleteChildMaintainableUnit").trim());
            forDelete.setparams(params);
            queryResult = forDelete.executeUpdate();
        } catch (SQLException se) {
            throw se;
        } finally {

            connection.close();
        }
        return qResult > 0;
    }

    public boolean deletObject(String sEquipmentID) throws java.sql.SQLException {

        StringValue stimeStamp = new StringValue(UniqueIDGen.getNextID());

        Vector params = new Vector();
        SQLCommandBean forDelete = new SQLCommandBean();
        int queryResult = -1000;
        int qResult = -1000;
        params.addElement(stimeStamp);
        params.addElement(new StringValue(sEquipmentID));
        Connection connection = dataSource.getConnection();
        try {
            forDelete.setConnection(connection);
            forDelete.setSQLQuery(sqlMgr.getSql("setIsDeletedMaintainableUnit").trim());
            forDelete.setparams(params);
            qResult = forDelete.executeUpdate();
        } catch (SQLException se) {
            throw se;
        } finally {

            connection.close();
        }
        return qResult > 0;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("maintainableUnit.xml")));//"C:\\temp\\maintainableUnit.xml"));
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws java.sql.SQLException {
        MaintainableUnit e = new MaintainableUnit();
        e.setObjectKey("Just Inserted");
        e.setAttribute("itemName", "I came from backend");
        notifyBusinessObjectEvent(e, "InsertOp");
        return false;
    }

    // Save in first table
    public boolean saveNewObject(WebBusinessObject wbo) {


        Vector params = new Vector();
        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();


        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new StringValue((String) wbo.getAttribute("parentId")));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("unitLevel").toString()).intValue() + 1));
        params.addElement(new StringValue((String) wbo.getAttribute("unitNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("engineNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("modelNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("serialNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("unitName")));
        params.addElement(new StringValue((String) wbo.getAttribute("manufacturer")));
        params.addElement(new StringValue((String) wbo.getAttribute("location")));
        params.addElement(new StringValue((String) wbo.getAttribute("dept")));
        params.addElement(new StringValue((String) wbo.getAttribute("status")));
        params.addElement(new StringValue((String) wbo.getAttribute("empID")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("isMaintainable")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("noOfHours")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("rateType")));
        params.addElement(new StringValue((String) wbo.getAttribute("opType")));
        params.addElement(new StringValue((String) wbo.getAttribute("productionLine")));

        //Equipment Supplier
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("supplierID")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("equipID")));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("purchaseDate")));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("purchasePrice").toString()).floatValue()));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("currentValue").toString()).floatValue()));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("displosedDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("contractorEmp")));
////        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("warranty")));
////        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("warrantyDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("notes")));

        //Operation
        eqpOperationParams.add(new StringValue((String) UniqueIDGen.getNextID()));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("equipID")));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("opeartionType")));
        eqpOperationParams.add(new IntValue((Integer) wbo.getAttribute("average")));

        try {
            Connection connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("insertMaintainableUnit").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

//            forInsert.setSQLQuery(sqlMgr.getSql("insertSupplierEquipment").trim());
//            forInsert.setparams(supEquipParams);
//            queryResult = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("insertEquipmentOperation").trim());
            forInsert.setparams(eqpOperationParams);
            queryResult = forInsert.executeUpdate();

            endTransaction();
            connection.close();

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return true;
    }
    public boolean saveInMaintainableUnit(WebBusinessObject wbo) {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new StringValue((String) wbo.getAttribute("parentId")));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("unitLevel").toString()).intValue() + 1));
        params.addElement(new StringValue((String) wbo.getAttribute("unitNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("engineNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("modelNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("serialNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("unitName")));
        params.addElement(new StringValue((String) wbo.getAttribute("manufacturer")));
        params.addElement(new StringValue((String) wbo.getAttribute("location")));
        params.addElement(new StringValue((String) wbo.getAttribute("dept")));
        params.addElement(new StringValue((String) wbo.getAttribute("status")));
        params.addElement(new StringValue((String) wbo.getAttribute("empID")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("isMaintainable")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("noOfHours")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("rateType")));
        params.addElement(new StringValue((String) wbo.getAttribute("opType")));
        params.addElement(new StringValue((String) wbo.getAttribute("productionLine")));
        params.addElement(new StringValue((String) wbo.getAttribute("statusFlag")));
        params.addElement(new StringValue((String) wbo.getAttribute("erpFlag")));
        params.addElement(new StringValue((String) wbo.getAttribute("isStandalone")));
        params.addElement(new StringValue((String) wbo.getAttribute("mainCat")));
        params.addElement(new StringValue((String) wbo.getAttribute("userEnterEq")));


        try {

            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertBranchEqpMaintainableUnit").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
//
            endTransaction();
         } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return true;
    }

    // Save in first table
    public boolean saveNewObject3(WebBusinessObject wbo, long now, String flag) {



        Vector params = new Vector();
        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();
        Vector eqpReadingParams = new Vector();
        Vector eqpReadingRateParams = new Vector();
        Vector eqpDriverParams = new Vector();
        Vector eqpStatusParams = new Vector();
        Vector eqpMoveHistoryParams = new Vector();
        String query = null;

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new StringValue((String) wbo.getAttribute("parentId")));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("unitLevel").toString()).intValue() + 1));
        params.addElement(new StringValue((String) wbo.getAttribute("unitNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("engineNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("modelNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("serialNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("unitName")));
        params.addElement(new StringValue((String) wbo.getAttribute("manufacturer")));
        params.addElement(new StringValue((String) wbo.getAttribute("location")));
        params.addElement(new StringValue((String) wbo.getAttribute("dept")));
        params.addElement(new StringValue((String) wbo.getAttribute("status")));
        params.addElement(new StringValue((String) wbo.getAttribute("empID")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("isMaintainable")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("noOfHours")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("rateType")));
        params.addElement(new StringValue((String) wbo.getAttribute("opType")));
        params.addElement(new StringValue((String) wbo.getAttribute("productionLine")));
        params.addElement(new StringValue((String) wbo.getAttribute("statusUnit")));
        params.addElement(new StringValue((String) wbo.getAttribute("erpFlag")));
        params.addElement(new StringValue((String) wbo.getAttribute("isStandalone")));
        params.addElement(new StringValue((String) wbo.getAttribute("mainCat")));

        //Equipment Supplier
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("supplierID")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("equipID")));
////        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("purchaseDate")));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("purchasePrice").toString()).floatValue()));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("currentValue").toString()).floatValue()));
////        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("displosedDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("contractorEmp")));
////        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("warranty")));
////        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("warrantyDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("notes")));

        //Operation
        eqpOperationParams.add(new StringValue((String) UniqueIDGen.getNextID()));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("equipID")));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("opeartionType")));
        eqpOperationParams.add(new IntValue((Integer) wbo.getAttribute("average")));

        eqpDriverParams.add(new StringValue((String) UniqueIDGen.getNextID()));
        eqpDriverParams.addElement(new StringValue((String) wbo.getAttribute("id")));
        eqpDriverParams.addElement(new StringValue((String) wbo.getAttribute("empID")));
        eqpDriverParams.addElement(new StringValue((String) wbo.getAttribute("user")));
        eqpDriverParams.addElement(new StringValue((String) wbo.getAttribute("empName")));

        eqpStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        eqpStatusParams.addElement(new StringValue((String) wbo.getAttribute("id")));
        eqpStatusParams.addElement(new StringValue("1"));
        eqpStatusParams.addElement(new StringValue(null));
        eqpStatusParams.addElement(new StringValue((String) wbo.getAttribute("user")));
        eqpStatusParams.addElement(new StringValue("Start Save"));

        if (flag.equals("equip")) {
            params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("serviceEntryDate")));
            params.addElement(new StringValue((String) wbo.getAttribute("user")));

            eqpReadingParams.add(new StringValue((String) UniqueIDGen.getNextID()));
            eqpReadingParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
            eqpReadingParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
            eqpReadingParams.addElement(new LongValue(now));
            eqpReadingParams.addElement(new StringValue("None"));
            eqpReadingParams.addElement(new LongValue(now));
            eqpReadingParams.add(new StringValue((String) wbo.getAttribute("equipID")));

            eqpReadingRateParams.add(new StringValue((String) UniqueIDGen.getNextID()));
            eqpReadingRateParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
            eqpReadingRateParams.addElement(new LongValue(now));
            eqpReadingRateParams.addElement(new StringValue("Begin Rate"));
            eqpReadingRateParams.add(new StringValue((String) wbo.getAttribute("equipID")));
            
            eqpMoveHistoryParams.add(new StringValue(UniqueIDGen.getNextID()));
            eqpMoveHistoryParams.add(new StringValue((String) wbo.getAttribute("equipID")));
            eqpMoveHistoryParams.add(new DateValue((java.sql.Date) wbo.getAttribute("serviceEntryDate")));
            eqpMoveHistoryParams.add(new StringValue("first save"));
            eqpMoveHistoryParams.add(new StringValue((String) wbo.getAttribute("location")));
        
            query = sqlMgr.getSql("insertMaintainableUnit").trim();

        } else {
            params.addElement(new StringValue((String) wbo.getAttribute("user")));
            query = sqlMgr.getSql("insertMaintainableUnitCat").trim();
        }

        try {
            Connection connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(query);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

//            forInsert.setSQLQuery(sqlMgr.getSql("insertSupplierEquipment").trim());
//            forInsert.setparams(supEquipParams);
//            queryResult = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("insertEquipmentOperation").trim());
            forInsert.setparams(eqpOperationParams);
            queryResult = forInsert.executeUpdate();

            if (flag.equals("equip")) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertAverageUnitSQL").trim());
                forInsert.setparams(eqpReadingParams);
                queryResult = forInsert.executeUpdate();

                forInsert.setSQLQuery(sqlMgr.getSql("insertReadingRateUnit").trim());
                forInsert.setparams(eqpReadingRateParams);
                queryResult = forInsert.executeUpdate();

                forInsert.setSQLQuery(sqlMgr.getSql("insertDriver").trim());
                forInsert.setparams(eqpDriverParams);
                queryResult = forInsert.executeUpdate();

                forInsert.setSQLQuery(sqlMgr.getSql("insertStatusEquip").trim());
                forInsert.setparams(eqpStatusParams);
                queryResult = forInsert.executeUpdate();
                
                forInsert.setSQLQuery(sqlMgr.getSql("insertMove").trim());
                forInsert.setparams(eqpMoveHistoryParams);
                queryResult = forInsert.executeUpdate();
            }

            endTransaction();
            connection.close();

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return true;
    }

    public boolean saveSimpleEquipment(WebBusinessObject wbo, long now, String flag) {
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        Vector eqpOperationParams = new Vector();
        Vector eqpReadingParams = new Vector();
        Vector eqpReadingRateParams = new Vector();
        Vector eqpStatusParams = new Vector();
        Vector eqpMoveHistoryParams = new Vector();
        String query = null;

        // Equipment
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new StringValue((String) wbo.getAttribute("parentId")));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("unitLevel").toString()).intValue() + 1));
        params.addElement(new StringValue((String) wbo.getAttribute("unitNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("engineNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("modelNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("serialNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("unitName")));
        params.addElement(new StringValue((String) wbo.getAttribute("manufacturer")));
        params.addElement(new StringValue((String) wbo.getAttribute("location")));
        params.addElement(new StringValue((String) wbo.getAttribute("dept")));
        params.addElement(new StringValue((String) wbo.getAttribute("status")));
        params.addElement(new StringValue((String) wbo.getAttribute("empID")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("isMaintainable")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("noOfHours")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("rateType")));
        params.addElement(new StringValue((String) wbo.getAttribute("opType")));
        params.addElement(new StringValue((String) wbo.getAttribute("statusUnit")));
        params.addElement(new StringValue((String) wbo.getAttribute("productionLine")));
        params.addElement(new StringValue((String) wbo.getAttribute("statusUnit")));
        params.addElement(new StringValue((String) wbo.getAttribute("erpFlag")));
        params.addElement(new StringValue((String) wbo.getAttribute("isStandalone")));
        params.addElement(new StringValue((String) wbo.getAttribute("mainCat")));

        //Operation
        eqpOperationParams.add(new StringValue((String) UniqueIDGen.getNextID()));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("equipID")));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("opeartionType")));
        eqpOperationParams.add(new IntValue((Integer) wbo.getAttribute("average")));

        //Status
        eqpStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        eqpStatusParams.addElement(new StringValue((String) wbo.getAttribute("id")));
        eqpStatusParams.addElement(new StringValue((String) wbo.getAttribute("statusUnit")));
        eqpStatusParams.addElement(new StringValue(null));
        eqpStatusParams.addElement(new StringValue((String) wbo.getAttribute("user")));
        eqpStatusParams.addElement(new StringValue("Start Save"));

        if (flag.equals("equip")) {
            params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("serviceEntryDate")));
            params.addElement(new StringValue((String) wbo.getAttribute("user")));

            eqpReadingParams.add(new StringValue((String) UniqueIDGen.getNextID()));
            eqpReadingParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
            eqpReadingParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
            eqpReadingParams.addElement(new LongValue(now));
            eqpReadingParams.addElement(new StringValue("None"));
            eqpReadingParams.addElement(new LongValue(now));
            eqpReadingParams.add(new StringValue((String) wbo.getAttribute("equipID")));

            eqpReadingRateParams.add(new StringValue((String) UniqueIDGen.getNextID()));
            eqpReadingRateParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
            eqpReadingRateParams.addElement(new LongValue(now));
            eqpReadingRateParams.addElement(new StringValue("Begin Rate"));
            eqpReadingRateParams.add(new StringValue((String) wbo.getAttribute("equipID")));
            
            eqpMoveHistoryParams.add(new StringValue(UniqueIDGen.getNextID()));
            eqpMoveHistoryParams.add(new StringValue((String) wbo.getAttribute("equipID")));
            eqpMoveHistoryParams.add(new DateValue((java.sql.Date) wbo.getAttribute("serviceEntryDate")));
            eqpMoveHistoryParams.add(new StringValue("first save"));
            eqpMoveHistoryParams.add(new StringValue((String) wbo.getAttribute("location")));
            
            query = sqlMgr.getSql("insertMaintainableUnitSimple").trim();

        } else {
            params.addElement(new StringValue((String) wbo.getAttribute("user")));
            query = sqlMgr.getSql("insertMaintainableUnitCat").trim();
        }

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(query);
            forInsert.setparams(params);
            if(forInsert.executeUpdate() == 0) {
                connection.rollback();
                return false;
            }

            forInsert.setSQLQuery(sqlMgr.getSql("insertEquipmentOperation").trim());
            forInsert.setparams(eqpOperationParams);
            if(forInsert.executeUpdate() == 0) {
                connection.rollback();
                return false;
            }

            if (flag.equals("equip")) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertAverageUnitSQL").trim());
                forInsert.setparams(eqpReadingParams);
                if(forInsert.executeUpdate() == 0) {
                    connection.rollback();
                    return false;
                }

                forInsert.setSQLQuery(sqlMgr.getSql("insertReadingRateUnit").trim());
                forInsert.setparams(eqpReadingRateParams);
                if(forInsert.executeUpdate() == 0) {
                    connection.rollback();
                    return false;
                }

                forInsert.setSQLQuery(sqlMgr.getSql("insertStatusEquip").trim());
                forInsert.setparams(eqpStatusParams);
                if(forInsert.executeUpdate() == 0) {
                    connection.rollback();
                    return false;
                }
                
                forInsert.setSQLQuery(sqlMgr.getSql("insertMove").trim());
                forInsert.setparams(eqpMoveHistoryParams);                
                if(forInsert.executeUpdate() == 0) {
                    connection.rollback();
                    return false;
                }
                
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            try {
                connection.rollback();
            } catch(SQLException sql) { logger.error(sql.getMessage()); }
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch(SQLException sql) { logger.error(sql.getMessage()); }
        }

        return true;
    }

    // Save in second table
    public boolean saveNewObject1(WebBusinessObject wbo) {
        Vector supEquipParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("supplierID")));
        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("equipID")));
        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("purchaseDate")));
        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("purchasePrice").toString()).floatValue()));
        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("currentValue").toString()).floatValue()));
        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("displosedDate")));
        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("contractorEmp")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("warranty")));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("warrantyDate")));
        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("notes")));



        try {
            Connection connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertSupplierEquipment").trim());
            forInsert.setparams(supEquipParams);
            queryResult = forInsert.executeUpdate();
            connection.close();
        } catch (SQLException se) {
            logger.error("Exception");
        }
        return queryResult > 0;

    }

    // Save in third table
    public boolean saveNewObject2(WebBusinessObject wbo) {
        Vector eqpOperationParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        eqpOperationParams.add(new StringValue((String) UniqueIDGen.getNextID()));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("equipID")));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("opeartionType")));
        eqpOperationParams.add(new IntValue((Integer) wbo.getAttribute("average")));


        try {
            Connection connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEquipmentOperation").trim());
            forInsert.setparams(eqpOperationParams);
            queryResult = forInsert.executeUpdate();
            connection.close();
        } catch (SQLException se) {
            logger.error("Exception 3");
        }

        return queryResult > 0;
    }

    /*Save Equipment Warranty data */
    public boolean updateWarrantyData(HttpServletRequest request, String eqID) {


        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String warrantyType = (String) request.getParameter("warrantyType");
        String beginDate = (String) request.getParameter("beginDate");
        String endDate = (String) request.getParameter("endDate");

        DateParser dateParser = new DateParser();
        java.sql.Date beginWarraintDate = dateParser.formatSqlDate(beginDate);
        java.sql.Date endWarrantyDate = dateParser.formatSqlDate(endDate);

        supEquipParams.addElement(new DateValue(beginWarraintDate));
        supEquipParams.addElement(new StringValue(warrantyType));
        supEquipParams.addElement(new DateValue(endWarrantyDate));
        supEquipParams.addElement(new StringValue(eqID));

        try {
            Connection connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("updateEquipmentWarranty").trim());
            forInsert.setparams(supEquipParams);
            queryResult = forInsert.executeUpdate();

            endTransaction();
            connection.close();

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return true;
    }
    public boolean updateequipmapData(String coordinate, String eqID) {


        Vector supEquipParams = new Vector();

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        supEquipParams.addElement(new StringValue(coordinate));
        supEquipParams.addElement(new StringValue(eqID));

        try {
            Connection connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("updateEquipmentMap").trim());
            forInsert.setparams(supEquipParams);
            queryResult = forInsert.executeUpdate();

            endTransaction();
            connection.close();

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return true;
    }

    public boolean saveWarrantyData(HttpServletRequest request, String eqID) {


        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();


        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String warrantyType = (String) request.getParameter("warrantyType");
        String beginDate = (String) request.getParameter("beginDate");
        String endDate = (String) request.getParameter("endDate");

//        String []arrbeginDate = beginDate.split("/");
//        int bYear=Integer.parseInt(arrbeginDate[2]);
//        int bMonth=Integer.parseInt(arrbeginDate[0]);
//        int bDay=Integer.parseInt(arrbeginDate[1]);
//        java.sql.Date beginWarraintDate=new java.sql.Date(bYear-1900,bMonth-1,bDay);

//        String []arrendDate= endDate.split("/");
//        int eYear=Integer.parseInt(arrendDate[2]);
//        int eMonth=Integer.parseInt(arrendDate[0]);
//        int eDay=Integer.parseInt(arrendDate[1]);
//        java.sql.Date endWarrantyDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);

        DateParser dateParser = new DateParser();
        java.sql.Date beginWarraintDate = dateParser.formatSqlDate(beginDate);
        java.sql.Date endWarrantyDate = dateParser.formatSqlDate(endDate);

        supEquipParams.addElement(new StringValue("1"));
        supEquipParams.addElement(new StringValue(eqID));
        supEquipParams.addElement(new DateValue(beginWarraintDate));
        supEquipParams.addElement(new FloatValue(new Float(request.getParameter("price").toString()).floatValue()));
        supEquipParams.addElement(new FloatValue(new Float(request.getParameter("price").toString()).floatValue()));
//        supEquipParams.addElement(new DateValue(beginWarraintDate));
//        supEquipParams.addElement(new StringValue("1"));
        supEquipParams.addElement(new StringValue(warrantyType));
        supEquipParams.addElement(new DateValue(endWarrantyDate));
        supEquipParams.addElement(new StringValue("No Notes"));
//        supEquipParams.addElement(new StringValue(eqID));

        try {
            Connection connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("insertEquipmentWarranty").trim());
            forInsert.setparams(supEquipParams);
            queryResult = forInsert.executeUpdate();

            endTransaction();
            connection.close();

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return true;
    }

    public boolean updateCategoryObject(WebBusinessObject wbo) throws java.sql.SQLException {

        String eqQuery = "select ID FROM maintainable_unit WHERE PARENT_ID = ? and IS_DELETED = '0'";
        String updateEqQuery = "update maintainable_unit set MAIN_TYPE_ID = ? WHERE id = ?";
        Vector params = new Vector();
        Vector supEquipParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("unitName")));
        params.addElement(new StringValue((String) wbo.getAttribute("mainCategory")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("countryOfOrigin")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));

        /****************************************/
        Vector EquipParams = new Vector();
        SQLCommandBean forUpdateEq = new SQLCommandBean();
        int queryResultEq = -1000;

        Vector eqps_parent = maintainableMgr.getEquipmentRecord(eqQuery, (String) wbo.getAttribute("id"));
        WebBusinessObject eqWbo = new WebBusinessObject();

        /****************************************/
        Connection connection = dataSource.getConnection();
        try {
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateMaintainableUnitCat").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            if (queryResult == 1) {
                for (int i = 0; i < eqps_parent.size(); i++) {
                    eqWbo = new WebBusinessObject();
                    queryResultEq = -1000;
                    eqWbo = (WebBusinessObject) eqps_parent.get(i);
                    EquipParams = new Vector();
                    EquipParams.add(new StringValue((String) wbo.getAttribute("mainCategory")));
                    EquipParams.add(new StringValue((String) eqWbo.getAttribute("id")));
                    forUpdateEq.setConnection(connection);
                    forUpdateEq.setSQLQuery(updateEqQuery.trim());
                    forUpdateEq.setparams(EquipParams);
                    queryResultEq = forUpdateEq.executeUpdate();
                }
            }
        } catch (SQLException se) {
            throw se;
        } finally {
            connection.close();
        }
        return queryResult > 0;
    }

    public boolean updateObject(WebBusinessObject wbo) throws java.sql.SQLException {


        Vector params = new Vector();
        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();

        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("parentId")));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("unitLevel").toString()).intValue() + 1));
        params.addElement(new StringValue((String) wbo.getAttribute("unitNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("engineNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("modelNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("serialNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("unitName")));
        params.addElement(new StringValue((String) wbo.getAttribute("manufacturer")));
        params.addElement(new StringValue((String) wbo.getAttribute("location")));
        params.addElement(new StringValue((String) wbo.getAttribute("dept")));
        params.addElement(new StringValue((String) wbo.getAttribute("productionLine")));
        params.addElement(new StringValue((String) wbo.getAttribute("status")));
        //params.addElement(new StringValue((String) wbo.getAttribute("empID")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("rateType")));
        params.addElement(new StringValue((String) wbo.getAttribute("opType")));
        params.addElement(new StringValue((String) wbo.getAttribute("isStandalone")));
        params.addElement(new StringValue((String) wbo.getAttribute("mainCat")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));

//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("supplierID")));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("purchaseDate")));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("purchasePrice").toString()).floatValue()));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("currentValue").toString()).floatValue()));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("displosedDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("contractorEmp")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("warranty")));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("warrantyDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("notes")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("equipID")));

        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("opeartionType")));
        eqpOperationParams.add(new IntValue((Integer) wbo.getAttribute("average")));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("equipID")));



        Connection connection = dataSource.getConnection();
        try {
            forUpdate.setConnection(connection);
            beginTransaction();
            forUpdate.setSQLQuery(sqlMgr.getSql("updateMaintainableUnit").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

//            forUpdate.setSQLQuery(sqlMgr.getSql("updateEquipmentSupplier").trim());
//            forUpdate.setparams(supEquipParams);
//            queryResult = forUpdate.executeUpdate();

            forUpdate.setSQLQuery(sqlMgr.getSql("updateEquipmentOperation").trim());
            forUpdate.setparams(eqpOperationParams);
            queryResult = forUpdate.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            throw se;
        } finally {

            connection.close();
        }
        return queryResult > 0;
    }

    /*******************************************************************/
    public boolean updateEqBasicData(WebBusinessObject wbo) throws java.sql.SQLException {


        Vector params = new Vector();
        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();

        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("parentId")));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("unitLevel").toString()).intValue() + 1));
        params.addElement(new StringValue((String) wbo.getAttribute("unitNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("engineNo")));
//        params.addElement(new StringValue((String) wbo.getAttribute("modelNo")));
//        params.addElement(new StringValue((String) wbo.getAttribute("serialNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("unitName")));
//        params.addElement(new StringValue((String) wbo.getAttribute("manufacturer")));
        params.addElement(new StringValue((String) wbo.getAttribute("location")));
        params.addElement(new StringValue((String) wbo.getAttribute("dept")));
        params.addElement(new StringValue((String) wbo.getAttribute("productionLine")));
        params.addElement(new StringValue((String) wbo.getAttribute("status")));
        //params.addElement(new StringValue((String) wbo.getAttribute("empID")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
//        params.addElement(new StringValue((String) wbo.getAttribute("rateType")));
//        params.addElement(new StringValue((String) wbo.getAttribute("opType")));
        params.addElement(new StringValue((String) wbo.getAttribute("isStandalone")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("serviceEntryDate")));
        params.addElement(new StringValue((String) wbo.getAttribute("mainCat")));
        params.addElement(new StringValue((String) wbo.getAttribute("serialNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("manufacturer")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));


//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("supplierID")));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("purchaseDate")));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("purchasePrice").toString()).floatValue()));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("currentValue").toString()).floatValue()));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("displosedDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("contractorEmp")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("warranty")));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("warrantyDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("notes")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("equipID")));
//
//        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("opeartionType")));
//        eqpOperationParams.add(new IntValue((Integer) wbo.getAttribute("average")));
//        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("equipID")));



        Connection connection = dataSource.getConnection();
        try {
            forUpdate.setConnection(connection);

            forUpdate.setSQLQuery(sqlMgr.getSql("updateEqBasicData").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

        } catch (SQLException se) {
            throw se;
        } finally {

            connection.close();
        }
        return queryResult > 0;
    }

    /*******************************************************************/
    public boolean updateEqManuf(WebBusinessObject wbo) throws java.sql.SQLException {


        Vector params = new Vector();
        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();

        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("modelNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("serialNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("manufacturer")));
        params.addElement(new StringValue((String) wbo.getAttribute("engineNo")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));

        Connection connection = dataSource.getConnection();
        try {
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateMaintainableUnitManuf").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

        } catch (SQLException se) {
            throw se;
        } finally {

            connection.close();
        }
        return queryResult > 0;
    }

    /*******************************************************************/
    /*******************************************************************/
    public boolean updateEqOperation(WebBusinessObject wbo) throws java.sql.SQLException {


        Vector params = new Vector();
        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();

        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("rateType")));
        params.addElement(new StringValue((String) wbo.getAttribute("opType")));
        params.addElement(new StringValue((String) wbo.getAttribute("equipID")));

        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("opeartionType")));
        eqpOperationParams.add(new IntValue((Integer) wbo.getAttribute("average")));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("equipID")));



        Connection connection = dataSource.getConnection();
        try {
            forUpdate.setConnection(connection);
            beginTransaction();
            forUpdate.setSQLQuery(sqlMgr.getSql("updateMaintainableUnitOperation").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            forUpdate.setSQLQuery(sqlMgr.getSql("updateEquipmentOperation").trim());
            forUpdate.setparams(eqpOperationParams);
            queryResult = forUpdate.executeUpdate();
            endTransaction();

        } catch (SQLException se) {
            throw se;
        } finally {

            connection.close();
        }
        return queryResult > 0;
    }

    /*******************************************************************/
    public boolean updateEqWarranty(WebBusinessObject wbo) throws java.sql.SQLException {


        Vector params = new Vector();
        Vector supEquipParams = new Vector();
        Vector eqpOperationParams = new Vector();

        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("supplierID")));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("purchaseDate")));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("purchasePrice").toString()).floatValue()));
//        supEquipParams.addElement(new FloatValue(new Float(wbo.getAttribute("currentValue").toString()).floatValue()));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("displosedDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("contractorEmp")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("warranty")));
//        supEquipParams.addElement(new DateValue((java.sql.Date) wbo.getAttribute("warrantyDate")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("notes")));
//        supEquipParams.addElement(new StringValue((String) wbo.getAttribute("equipID")));

//        Connection connection = dataSource.getConnection();
//        try {
//            forUpdate.setConnection(connection);
//            forUpdate.setSQLQuery(sqlMgr.getSql("updateEquipmentSupplier").trim());
//            forUpdate.setparams(supEquipParams);
//            queryResult = forUpdate.executeUpdate();
//
//        } catch (SQLException se) {
//            throw se;
//        } finally {
//
//            connection.close();
//        }
        return queryResult > 0;
    }

    /*******************************************************************/
    protected WebBusinessObject fabricateBusObj(Row r) {

        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        String state = null;
        String docOwnerId = null;



        while (li.hasNext()) {

            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
// needs a case ......
//check to replace status precent with string
                if (colName.equalsIgnoreCase("STATUS")) {
                    String value = r.getString(colName).toString();
                    ht.put("statusReal", value);
                    if (value.equalsIgnoreCase("NON")) {
                        ht.put(fe.getAttribute("name"), "NON");
                        ht.put(fe.getAttribute("name") + "Value", "NON");
                    } else if (value.equals("100%") || value.equals("95%") || value.equals("90%") || value.equals("85%") || value.equals("80%")) {
                        ht.put(fe.getAttribute("name"), "Excellent");
                        ht.put(fe.getAttribute("name") + "Value", value);
                    } else if (value.equals("75%") || value.equals("70%") || value.equals("60%") || value.equals("65%") || value.equals("60%") || value.equals("55%")) {
                        ht.put(fe.getAttribute("name"), "Good");
                        ht.put(fe.getAttribute("name") + "Value", value);
                    } else {
                        ht.put(fe.getAttribute("name"), "Bad");
                        ht.put(fe.getAttribute("name") + "Value", value);
                    }
                } else if (colName.equalsIgnoreCase("TYPE_OF_RATE")) {
                    if (r.getString(colName).toString().equalsIgnoreCase("odometer")) {
                        ht.put(fe.getAttribute("name"), "By K.M");
                    } else {
                        ht.put(fe.getAttribute("name"), "By Hour");
                    }
                } else if (colName.equalsIgnoreCase("TYPE_OF_OPERATION")) {
                    if (r.getString(colName).toString().equalsIgnoreCase("2")) {
                        ht.put(fe.getAttribute("name"), "By Order");
                    } else {
                        ht.put(fe.getAttribute("name"), "continuous");
                    }
                } else {
                    ht.put(fe.getAttribute("name"), r.getString(colName));
                }
            } catch (Exception e) {
            }

        }

        MaintainableUnit expense = new MaintainableUnit(ht);
        return (WebBusinessObject) expense;
    }

    public Vector getChildren(String parentId) {
        MaintainableUnit expense = null;
        Connection connection = null;
//        String query = "SELECT * FROM maintainable_unit WHERE PARENT_ID = ? ORDER BY UNIT_NAME";

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(parentId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectMaintainableUnit").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();


            expense = (MaintainableUnit) fabricateBusObj(r);

            reultBusObjs.add(expense);
        }


        return reultBusObjs;


    }

    public Vector getAllParentSortingById() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllParentSortingById").trim());

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();


            wbo = fabricateBusObj(r);

            reultBusObjs.add(wbo);
        }


        return reultBusObjs;


    }

    public Vector getAllBasicTypeBySortingByID() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllBasicTypeBySortingByID").trim());

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();


            wbo = fabricateBusObj(r);

            reultBusObjs.add(wbo);
        }


        return reultBusObjs;


    }

    public Vector getRootNodes() {
        MaintainableUnit expense = null;

        Connection connection = null;
//        String query = "SELECT * FROM maintainable_unit WHERE PARENT_ID = '0' ORDER BY UNIT_NAME";
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectRootNodesMaintainableUnit").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            expense = (MaintainableUnit) fabricateBusObj(r);
            reultBusObjs.add(expense);
        }
        return reultBusObjs;
    }

    protected void notifyBusinessObjectEvent(WebBusinessObject subject, String eventName) {
        java.util.EventObject eo = new java.util.EventObject("");

        BusinessObjectEvent boe = new BusinessObjectEvent("RDBGateway", subject, eventName);
        Vector v;
        synchronized (this) {
            v = (Vector) businessObjectEventListeners.clone();

        }

        int cnt = v.size();
        for (int i = 0; i < cnt; i++) {
            BusinessObjectEventListener client = (BusinessObjectEventListener) v.elementAt(i);
            client.businessObjectEvent(boe);
        }


    }

    public Connection getDatabaseConnection() throws SQLException {
        return dataSource.getConnection();
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

    public ArrayList getAllParentsOrderByName() {
        ArrayList parents = new ArrayList();

        Vector parentsAsVec = maintainableMgr.getRootNodes();
        parents = Tools.toArrayList(parentsAsVec);

        return parents;
    }

    public ArrayList getEquAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("rateType").toString().equalsIgnoreCase("By Hour") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
                cashedData.add(wbo);
            }
        }

        return cashedData;
    }

    public ArrayList getMaintenanbleEquAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
                cashedData.add(wbo);
            }
        }

        return cashedData;
    }

    public ArrayList getEquKelAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("rateType").toString().equalsIgnoreCase("By K.M") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
                cashedData.add(wbo);
            }
        }

        return cashedData;
    }

    public ArrayList getCategoryAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                cashedData.add(wbo);
            }
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("unitName"));
        }

        return cashedData;
    }

    public boolean hasSchedules(String unitID) {
        Connection connection = null;
//        String query = "SELECT * FROM unit_schedule WHERE UNIT_ID = ?";

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitID));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectHasSchedulesMaintainableUnit").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public boolean hasIssues(String unitID) {
        Connection connection = null;

        Vector SQLparams = new Vector();

        WebBusinessObject unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(unitID);

        SQLparams.addElement(new StringValue(unitScheduleWbo.getAttribute("id").toString()));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectHasIssuesMaintainableUnit").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public boolean equipmentHasChild(String unitID) {
        Connection connection = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(unitID));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("EquipmentChildren").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public Vector getUnitsBySite(String siteName) {
        MaintainableUnit unit = null;
        Connection connection = null;
//        String query = "SELECT * FROM maintainable_unit WHERE SITE = ? AND IS_MAINTAINABLE = '1'";
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(siteName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectMaintainableUnitBySite").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        Vector result = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            unit = (MaintainableUnit) fabricateBusObj(r);
            result.add(unit);
        }
        return result;
    }

    public ArrayList getAllModelsAsArrayList(){
        ArrayList allAsArrayList = new ArrayList();

        Vector allAsVector = getAllCategoryEqu();

        for (int i = 0; i < allAsVector.size(); i++) {
            allAsArrayList.add((WebBusinessObject) allAsVector.get(i));
        }

        return allAsArrayList;
    }

    public Vector getAllCategoryEqu() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllCategoryEqu").trim());
//        query.append(sSearch);
//        query.append("%'");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getAllCategoryEquBySite(String site) {


        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
//        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllCategoryEquBySite").trim());

        StringBuffer query = new StringBuffer("SELECT ID,UNIT_NAME FROM maintainable_unit WHERE IS_MAINTAINABLE = '0' AND SITE=?");

//        query.append(sSearch);
//        query.append("%'");
        Vector params = new Vector();
        params.addElement(new StringValue(site));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public String getTotalEquipmentByMainCat(String mainCategoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(mainCategoryId));

        Connection connection = null;
        String total = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTotalEquipmentByMainCat").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                total = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return total;

    }

    public String getTotalEquipment(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));

        Connection connection = null;
        String total = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTotalEquipment").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                total = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return total;

    }

    public Vector getAllEquipment(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllEquipment").trim());
//        query.append(sSearch);
//        query.append("%'");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public String getAllEquipmentOnly(String Id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(Id));

        Connection connection = null;
        String unitName = null;

        StringBuffer query = new StringBuffer("getAllEquipmentOnly");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                unitName = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return unitName;

    }

    public WebBusinessObject getOnNameKey(String key) {

        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key2"));
        query.append(" = ?");

        Vector SQLparams = new Vector();


        SQLparams.addElement(new StringValue(key));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        WebBusinessObject reultBusObj = null;

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = fabricateBusObj(r);
        }


        return reultBusObj;

    }

    public String getAllNumbers() {
        Connection connection = null;
        ResultSet result = null;
        StringBuffer returnSB = null;

        try {
            connection = dataSource.getConnection();
            Statement select = connection.createStatement();
            result = select.executeQuery(sqlMgr.getSql("selectAllNumbers").trim());
            returnSB = new StringBuffer();
            while (result.next()) {
                returnSB.append(result.getString("unit_no") + ",");
            }
            returnSB.deleteCharAt(returnSB.length() - 1);
        } catch (SQLException e) {
            logger.error("error ================ > " + e.toString());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return returnSB.toString();
    }

    public String getParentId(String equipId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(equipId));

        Connection connection = null;
        String categoryId = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getParentId").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                categoryId = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return categoryId;

    }

    public boolean GetEquipmentKel() {
        Connection connection = null;

        Vector SQLparams = new Vector();



        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("GetEquipmentKel").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public boolean GetEquipmentRate() {
        Connection connection = null;

        Vector SQLparams = new Vector();



        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("GetEquipmentRate").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public String getUnitName(String equipId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(equipId));

        Connection connection = null;
        String unitName = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitName").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                unitName = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return unitName;

    }

    public void getNonScheduleUnits(Vector scheduleUnits, Vector nonSceduleUnits, Vector units, String periodicID) {
        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
        Vector bindedScheduleUnitsVector = unitScheduleMgr.getBindedEquipmentsSchedules(periodicID);
        String projectID = new String("");
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        for (int i = 0; i < units.size(); i++) {
            WebBusinessObject tempWbo = (WebBusinessObject) units.get(i);
            if (bindedScheduleUnitsVector.contains((String) tempWbo.getAttribute("unitName"))) {
                projectID = tempWbo.getAttribute("site").toString();
                WebBusinessObject wboProject = projectMgr.getOnSingleKey(projectID);
                tempWbo.setAttribute("siteName", wboProject.getAttribute("projectName").toString());
                scheduleUnits.add(tempWbo);
            } else {
                projectID = tempWbo.getAttribute("site").toString();
                WebBusinessObject wboProject = projectMgr.getOnSingleKey(projectID);
                tempWbo.setAttribute("siteName", wboProject.getAttribute("projectName").toString());
                nonSceduleUnits.add(tempWbo);
            }
        }
    }

    public boolean getHourUnitName(String equipId) {
        Connection connection = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(equipId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getHourUnitName").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public boolean getHourUnitNameContinues(String equipId) {
        Connection connection = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(equipId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getHourUnitNameContinues").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public boolean getKLUnitName(String equipId) {
        Connection connection = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(equipId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getKLUnitName").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public Vector getAllEqpsForMainCat(String mainCatId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Vector SQLparams = new Vector();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllEqpsForMainCat").trim());
        SQLparams.add(new StringValue(mainCatId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public boolean getKLUnitNameContinues(String equipId) {
        Connection connection = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(equipId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getKLUnitNameContinues").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public String getFixedMachineNo(String equipName) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(equipName));

        Connection connection = null;
        String unitNo = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getFixedMachineNo").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                unitNo = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return unitNo;

    }

    public void executeProcedureMachine(String txt) {
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(txt));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("{call filter_machine(?)}");
            forQuery.setparams(SQLparams);

            forQuery.execute();


        } catch (SQLException se) {
            logger.error("database error " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

    }

    
    public Vector getAllIEquipmentByDate(String beginDate,String endDate) {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        try {
                java.util.Date dateBeg = sdf.parse(beginDate);
                java.util.Date dateEnd = sdf.parse(endDate);
                java.sql.Date beginDatesql = new java.sql.Date(dateBeg.getTime());
                java.sql.Date endDatesql = new java.sql.Date(dateEnd.getTime());
                SQLparams.addElement(new DateValue(beginDatesql));
                SQLparams.addElement(new DateValue(endDatesql));
            } catch (Exception e) {
        
            }
        
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllIEquipmentByDate").trim());
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    
    public boolean getErpAssets(String equipNo, String equipName) {
        Connection connection = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(equipNo));
        SQLparams.addElement(new StringValue(equipName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getErpAssets").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }

    public String getUnitType(String Id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(Id));

        Connection connection = null;
        String unitType = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitType").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                unitType = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return unitType;

    }

    public ArrayList getAttachableEquipment() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAttachableEquipment").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        ArrayList resultBusObjs = new ArrayList();

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

    public Vector getEquipmentRecord(String query, String Id) {

        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(Id));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject result = null;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            result = (WebBusinessObject) fabricateBusObj(r);
            reultBusObjs.add(result);
        }
        return reultBusObjs;
    }

    public Vector getEquipmentRecordAll(String query) {

        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject result = null;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            result = (WebBusinessObject) fabricateBusObj(r);
            reultBusObjs.add(result);
        }
        return reultBusObjs;
    }

    public Vector getEqpsOutOfWorking() {

        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpsOutOfWorking").trim());

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject result = null;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            result = (WebBusinessObject) fabricateBusObj(r);
            reultBusObjs.add(result);
        }
        return reultBusObjs;
    }

    public Vector getEqpsOutOfWorkingTime(String begin, String end) {

        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new DateValue(EquipmentWorkOrderTools.getBeginDate(begin)));
        params.addElement(new DateValue(EquipmentWorkOrderTools.getEndDate(end)));
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpsOutOfWorking2").trim());

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject result = null;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            result = (WebBusinessObject) fabricateBusObj(r);
            reultBusObjs.add(result);
        }
        return reultBusObjs;
    }

    public Vector getEqpsOutOfWorkingWithOutJo() {

        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpsOutOfWorkingWithOutJo").trim());

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject result = null;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            result = (WebBusinessObject) fabricateBusObj(r);
            reultBusObjs.add(result);
        }
        return reultBusObjs;
    }

    public Vector getEquipBySubName(String name) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;



        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEquipBySubName").trim().replaceAll("ppp", name));

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipByTypeOfRateBySubName(String name, String typeOfRate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(typeOfRate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEquipByTypeOfRateBySubName").trim().replaceAll("ppp", name));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySiteId(String siteId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

       
        Vector queryResult = null;

        String query = sqlMgr.getSql("getEquipBySiteId").replaceAll("mmm", siteId).trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipByTypeOfRateBySiteId(String siteId, String typeOfRate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getEquipByTypeOfRateBySiteId").trim();



        SQLparams.add(new StringValue(siteId));
        SQLparams.add(new StringValue(typeOfRate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipByTypeOfRate(String typeOfRate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getEquipByTypeOfRate").trim();

        SQLparams.add(new StringValue(typeOfRate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySiteIdAndType(String siteId, String mainType) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getEquipBySiteIdAndMainType").trim();



        SQLparams.add(new StringValue(siteId));
        SQLparams.add(new StringValue(mainType));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySubNameAndSiteId(String siteId, String name) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getEquipBySubNameAndSite").trim().replaceAll("ppp", name);

        SQLparams.add(new StringValue(siteId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipByTypeOfRateBySubNameAndSite(String siteId, String name, String typeOfRate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getEquipByTypeOfRateBySubNameAndSite").trim().replaceAll("ppp", name);

        SQLparams.add(new StringValue(siteId));
        SQLparams.add(new StringValue(typeOfRate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySubNameAndSiteIdAndType(String siteId, String name, String mainType) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getEquipBySubNameAndSiteAndMainType").trim().replaceAll("ppp", name);

        SQLparams.add(new StringValue(siteId));
        SQLparams.add(new StringValue(mainType));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySubNameOrCode(String name, String projectId, String searchType) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = "";
        if (searchType != null) {
            if (searchType.equalsIgnoreCase("name")) {
                query = sqlMgr.getSql("getEquipBySubNameAndSite").trim().replaceAll("ppp", name).replaceAll("mmm", projectId);
            } else {
                query = sqlMgr.getSql("getEquipBySubCodeAndSite").trim().replaceAll("ppp", name).replaceAll("mmm", projectId);
            }
        }


        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySubNameOrCodeAndSites(String name, String projectId, String searchType, String sites) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector queryResult = null;

        String query = "";
        if (searchType != null) {
            if (searchType.equalsIgnoreCase("name")) {
                query = getQuery("getEquipBySubNameAndSites").trim().replaceAll("ppp", name);
            } else {
                query = getQuery("getEquipBySubCodeAndSites").trim().replaceAll("ppp", name);
            }
        }

        query = query.replaceAll("sss", sites);
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySites(String sites) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        String query = getQuery("getEquipBySites").trim();
        query = query.replaceAll("sss", sites);

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySubNameOrCode(String name, String searchType) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = "";
        if (searchType != null) {
            if (searchType.equalsIgnoreCase("name")) {
                query = sqlMgr.getSql("getEquipBySubName").trim().replaceAll("ppp", name);
            } else {
                query = sqlMgr.getSql("getEquipBySubCode").trim().replaceAll("ppp", name);
            }
        }

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipBySubNameOrCode(String name, String[] branches, String searchType) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        String query = "";

        if (searchType.equalsIgnoreCase("name")) {
            query = sqlMgr.getSql("getEquipBySubNameAndBranches").trim().replaceAll("ppp", name);
        } else {
            query = sqlMgr.getSql("getEquipBySubCodeAndBranches").trim().replaceAll("ppp", name);
        }

        query = query.replaceAll("sss", Tools.concatenation(branches, ","));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getBrandBySubNameOrCode(String name, String[] branches, String searchType) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        String query = "";

        if (searchType.equalsIgnoreCase("name")) {
            query = sqlMgr.getSql("getBrandBySubName").trim().replaceAll("ppp", name);
        } else {
            query = sqlMgr.getSql("getBrandBySubCode").trim().replaceAll("ppp", name);
        }

        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getEquipmentsByBranches(String[] branches) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        String query = "";

        query = sqlMgr.getSql("getEquipmentsByBranches").trim();

        query = query.replaceAll("sss", Tools.concatenation(branches, ","));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getAllEquipmentByAllMainType() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        StringBuilder query = new StringBuilder(sqlMgr.getSql("getAllEquipmentByAllMainType").trim());
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getAllEquipmentByMainTypeId(String mainTypeId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllEquipmentByMainTypeId").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(mainTypeId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getAllEquipmentByProjectId(String projectId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllEquipmentByProjectId").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(projectId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    /**************End Of Farahat*******************/
    public boolean updateEqpOperation(WebBusinessObject wbo, long now) {

        /************ Insert Equipment Operation As it is first Time ***************/
        Vector eqpOperationParams = new Vector();
        Vector eqpReadingParams = new Vector();
        Vector eqpReadingRateParams = new Vector();
        Vector params = new Vector();
        String query = null;

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("rateType")));
        params.addElement(new StringValue((String) wbo.getAttribute("opType")));
        params.addElement(new StringValue((String) wbo.getAttribute("equipID")));

        //Operation
        eqpOperationParams.add(new StringValue((String) UniqueIDGen.getNextID()));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("equipID")));
        eqpOperationParams.add(new StringValue((String) wbo.getAttribute("opeartionType")));
        eqpOperationParams.add(new IntValue((Integer) wbo.getAttribute("average")));

        eqpReadingParams.add(new StringValue((String) UniqueIDGen.getNextID()));
        eqpReadingParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
        eqpReadingParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
        eqpReadingParams.addElement(new LongValue(now));
        eqpReadingParams.addElement(new StringValue("None"));
        eqpReadingParams.addElement(new LongValue(now));
        eqpReadingParams.add(new StringValue((String) wbo.getAttribute("equipID")));

        eqpReadingRateParams.add(new StringValue((String) UniqueIDGen.getNextID()));
        eqpReadingRateParams.add(new StringValue((String) wbo.getAttribute("averageReading")));
        eqpReadingRateParams.addElement(new LongValue(now));
        eqpReadingRateParams.addElement(new StringValue("Begin Rate"));
        eqpReadingRateParams.add(new StringValue((String) wbo.getAttribute("equipID")));

        try {
            Connection connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(connection);

            /*** Update maintainable Unit and eqp Operation ****/
//            if(maintainableMgr.updateEqOperation(wbo)){
            forInsert.setSQLQuery(sqlMgr.getSql("updateMaintainableUnitOperation").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("insertEquipmentOperation").trim());
            forInsert.setparams(eqpOperationParams);
            queryResult = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("insertAverageUnitSQL").trim());
            forInsert.setparams(eqpReadingParams);
            queryResult = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("insertReadingRateUnit").trim());
            forInsert.setparams(eqpReadingRateParams);
            queryResult = forInsert.executeUpdate();

//                forInsert.setSQLQuery(sqlMgr.getSql("updateEqpAverageSQL").trim());
//                forInsert.setparams(eqpReadingParams);
//                queryResult = forInsert.executeUpdate();
//                
//                forInsert.setSQLQuery(sqlMgr.getSql("updateReadingRateUnit").trim());
//                forInsert.setparams(eqpReadingRateParams);
//                queryResult = forInsert.executeUpdate();
//            }
            endTransaction();
            connection.close();

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return true;
    }

    public Vector getParentBySort() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getParentBySort").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEqpbyParentSorting(String parentId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpbyParentSorting").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(parentId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getBrandByBasictype(String basicTypeId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getBrandByBasictype").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(basicTypeId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    
    public Vector getEqpBySitesSorting(String siteId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpBySitesSorting").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(siteId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    
     public Vector getEqpBySiteId(String siteId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpBySiteId").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(siteId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    
     
    
       public Vector getEqpByAllSites() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpByAllSites").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
       
       
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    
    
    public Vector getEqpByProLineSorting(String proLineId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpByProLineSorting").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(proLineId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getCheckAttachedEq(String mainTypeId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getCheckAttachedEq").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(mainTypeId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getEquipByCheckUser(int numOfKeys, String[] keysValue, String[] keysIndex, HttpSession s) throws SQLException, Exception {


        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        String theQuery = "";
        FilterQuery filterQuery = new FilterQuery();
        SecurityUser securityUser = new SecurityUser();
        securityUser = (SecurityUser) s.getAttribute("securityUser");
        String branchIdForUser = securityUser.getSiteId();
        String authUser = securityUser.getSearchBy();

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 1; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
                    dq.append("AND ");
                }
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 1]));
                dq.append(" = ? ");

                if (authUser.equals("all")) {
                    theQuery = dq.toString();
                } else {
                    dq.append(" AND site = ? ");
                    theQuery = dq.toString();
                }

            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }

        if (authUser.equals("all")) {
            System.out.print("without params");
        } else {
            SQLparams.add(new StringValue(branchIdForUser));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        return reultBusObjs;
    }

    public Vector getEquipBySitesAndTypeRate(String sites, String[] typeOfRate) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = sqlMgr.getSql("getEquipBySitesAndTypeRate").trim();
       
        String stringTypeOfRate = Tools.concatenation(typeOfRate, ",");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        query = query.replaceAll("xxx", sites);
        query = query.replaceAll("yyy", stringTypeOfRate);

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = super.fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getEquipBySiteAndTypeRateAndId(String[] ids, String sites, String[] typeOfRate) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = sqlMgr.getSql("getEquipBySiteAndTypeRateAndId").trim();
        String stringIds = Tools.concatenation(ids, ",");
        
        String stringTypeOfRate = Tools.concatenation(typeOfRate, ",");

        query = query.replaceAll("xxx", stringIds);
        query = query.replaceAll("yyy", sites);
        query = query.replaceAll("zzz", stringTypeOfRate);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = super.fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getEquipmentsByIds(String[] ids) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = sqlMgr.getSql("getEquipmentsByIds").trim();
        String stringIds = Tools.concatenation(ids, ",");

        query = query.replaceAll("iii", stringIds);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = super.fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getUnitsName(String[] unitIds) {
        Connection connection = null;

        String quary = sqlMgr.getSql("selectEquipmentsByIds").trim();

        quary = quary.replaceAll("iii", Tools.concatenation(unitIds, ","));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        Vector resAsWbo = new Vector();
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                resAsWbo.addElement(row.getString("unit_name"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }

    public boolean maintainableExsit(String mainId) {

        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("maintainableExsit").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(mainId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
            return false;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return (queryResult.size() > 0);

    }

    public String getIdByUnitNo(String mainId) {

        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("maintainableExsit").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(mainId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            if (queryResult.size() > 0) {
                try {
                    return ((Row) queryResult.get(0)).getString("ID");
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return null;

    }

    public Vector getAllParents(String name) {
        Vector returned_Codes = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        String quary;
        if (name == null) {
            quary = sqlMgr.getSql("getAllParents").trim();
        } else {
            quary = sqlMgr.getSql("getAllParentsBySubName").trim().replaceAll("PPP", name);
        }
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            //3shn ageb el customer id mn el ticket id
            forInsert.setSQLQuery(quary);
            returned_Codes = forInsert.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resAsWeb = new Vector();
        Row row;
        WebBusinessObject wbo;

        for (int i = 0; i < returned_Codes.size(); i++) {
            row = (Row) returned_Codes.get(i);
            wbo = super.fabricateBusObj(row);
            resAsWeb.add(wbo);
        }

        return resAsWeb;
    }

    public Vector getBrandName(String[] brand) {
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getBrandName").trim().replaceAll("BBB", Tools.concatenation(brand, ",")));
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("Persistence Error " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        return reultBusObjs;
    }
    
    public Vector getParentIdAndName(String parentId) {
        Vector<Row> queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;

        params.addElement(new StringValue(parentId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("getParentIdAndName").trim());
            
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("Persistence Error " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Error " + ex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();

        for (Row row : queryResult) {
            reultBusObjs.add(fabricateBusObj(row));
        }

        return reultBusObjs;
    }

    public String getMainTypeByModelId(String parentId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector<Row>();

        parameters.addElement(new StringValue(parentId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(sqlMgr.getSql("getMainTypeByModelId").trim());

            rows = command.executeQuery();
            if(!rows.isEmpty()) {
                return rows.get(0).getString("MAIN_TYPE_ID");
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return "***";
    }

    public String getModelNameById(String parentId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector<Row>();

        parameters.addElement(new StringValue(parentId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(sqlMgr.getSql("getModelNameById").trim());

            rows = command.executeQuery();
            if(!rows.isEmpty()) {
                return rows.get(0).getString("UNIT_NAME");
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return "***";
    }

    public boolean canDelete(String equipmentId) {
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector resault = new Vector();
        Vector params = new Vector();
        Connection connection = null;

        params.addElement(new StringValue(equipmentId));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("isMaintainableHasIssues").trim());
            forInsert.setparams(params);

            resault = forInsert.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return resault.isEmpty();
    }

    public boolean deleteEquipment(String equipmentId) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        params.addElement(new StringValue(equipmentId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            forInsert.setSQLQuery("{ CALL DELETE_EQUIPMENT(?) }");
            forInsert.setparams(params);

            forInsert.executeUpdate();
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) { logger.error("Close Error"); }
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (true);
    }
    
    public boolean deleteCategory(String categoryId) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        params.addElement(new StringValue(categoryId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            forInsert.setSQLQuery("{ CALL DELETE_CATEGORY(?) }");
            forInsert.setparams(params);

            forInsert.executeUpdate();
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) { logger.error("Close Error : " + ex.getMessage()); }
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error : " + ex.getMessage());
                return false;
            }
        }

        return (true);
    }
    
    public Vector getEquipmentsByInterval(int beginInterval, int endInterval) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows = new Vector();
        Vector params = new Vector();
        
        params.addElement(new IntValue(beginInterval));
        params.addElement(new IntValue(endInterval));
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEquipmentsByInterval").trim());
            forQuery.setparams(params);
            
            rows = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("Persistence Error " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();
        WebBusinessObject wbo;
        for (Row row : rows) {
            wbo = fabricateBusObj(row);
            try {
               wbo.setAttribute("index", row.getString("INDICES"));
            } catch(Exception ex) { logger.error(ex.getMessage()); }
            reultBusObjs.add(wbo);
        }
        
        return reultBusObjs;
    }

    public Vector getBrandsByInterval(int beginInterval, int endInterval) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows = new Vector();
        Vector params = new Vector();

        params.addElement(new IntValue(beginInterval));
        params.addElement(new IntValue(endInterval));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getBrandsByInterval").trim());
            forQuery.setparams(params);

            rows = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("Persistence Error " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();
        WebBusinessObject wbo;
        for (Row row : rows) {
            wbo = fabricateBusObj(row);
            try {
               wbo.setAttribute("index", row.getString("INDICES"));
            } catch(Exception ex) { logger.error(ex.getMessage()); }
            reultBusObjs.add(wbo);
        }

        return reultBusObjs;
    }
    
    public long getEquipmentsNumber() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows = new Vector<Row>();
        
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("getEquipmentsNumber").trim());

            rows = command.executeQuery();
            if(!rows.isEmpty()) {
                Row row = rows.get(0);
                String count = row.getString("EQUIPMENTS_NUMBER");
                return Long.valueOf(count).longValue();
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return 0;
    }

    public long getBrandsNumber() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows = new Vector<Row>();

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("getBrandsNumber").trim());

            rows = command.executeQuery();
            if(!rows.isEmpty()) {
                Row row = rows.get(0);
                String count = row.getString("BRANDS_NUMBER");
                return Long.valueOf(count).longValue();
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return 0;
    }

    public long getMainTypesNumber() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows = new Vector<Row>();

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("getBrandsNumber").trim());

            rows = command.executeQuery();
            if(!rows.isEmpty()) {
                Row row = rows.get(0);
                String count = row.getString("BRANDS_NUMBER");
                return Long.valueOf(count).longValue();
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return 0;
    }

    public String getProjectNameByUnitId(String unitId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector<Row>();

        parameters.addElement(new StringValue(unitId));
        
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(sqlMgr.getSql("getProjectNameByUnitId").trim());

            rows = command.executeQuery();
            if(!rows.isEmpty()) {
                return rows.get(0).getString("PROJECT_NAME");
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return "***";
    }
    
    
     public Vector getAllEqp(String parenId){
        Connection connection = null;

        String quary = sqlMgr.getSql("getAllEqp").trim();

        Vector param = new Vector();

        param.addElement(new StringValue(parenId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(param);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        Vector resAsWbo = new Vector();
        
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                WebBusinessObject tempAsWbo = new WebBusinessObject();
                tempAsWbo.setAttribute("id", row.getString("id"));
                tempAsWbo.setAttribute("name", row.getString("unit_name"));
                resAsWbo.addElement(tempAsWbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }
     
     public Vector getModelsNames(String[] parenId){
        Connection connection = null;

        String quary = sqlMgr.getSql("selectModelsByIds").trim();

        quary = quary.replaceAll("iii", Tools.concatenation(parenId, ","));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        Vector resAsWbo = new Vector();
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                resAsWbo.addElement(row.getString("UNIT_NAME"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }
   
   
        public Vector getBrandsByName(String name) {
        WebBusinessObject wbo = new WebBusinessObject();
       Connection connection = null;
     
        Vector queryResult = null;

        String query = "";
        query = sqlMgr.getSql("getBrandsByName").trim().replaceAll("ppp", name);
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();
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

    public Vector getAllEquipments(){
        Connection connection = null;
        
        String quary = sqlMgr.getSql("getAllEquipments").trim();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        Vector resAsWbo = new Vector();

        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                WebBusinessObject tempAsWbo = new WebBusinessObject();
                tempAsWbo.setAttribute("id", row.getString("id"));
                tempAsWbo.setAttribute("name", row.getString("unit_name"));
                tempAsWbo.setAttribute("site", row.getString("site"));
                resAsWbo.addElement(tempAsWbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }
    
        public String getParentName(String parentId, String id, String code) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(parentId));

        Connection connection = null;
        String categoryName = "";

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getParentName").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();
            if(queryResult.size()>0){
                Row r = (Row)queryResult.get(0);
                categoryName = r.getString("unit_name");
            }
            else {
                categoryName="";
                logger.error("Eqipment with id="+id+" and code= "+code+" without parent ");
            }
           // Enumeration e = queryResult.elements();

//            while (e.hasMoreElements()) {
//                r = (Row) e.nextElement();
//                categoryName = r.getString(1);
//            }

        } catch (SQLException se) {
            logger.error("Eqipment without parent" + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("Eqipment without parent2 " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("Eqipment without parent3 " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return categoryName;

    }
        
    public boolean updateEquipSite(WebBusinessObject wbo) {
        Vector params = new Vector();
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = 0;
        

        
        try {
            connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(connection);

            params.add(new StringValue((String) wbo.getAttribute("siteId")));
            params.add(new StringValue((String) wbo.getAttribute("equipId")));
            
            forInsert.setSQLQuery(getQuery("updateEquipSite"));
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            endTransaction();
            connection.close();

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        
        return (queryResult > 0);
    }

    public Vector getAllMaintainableUnits(String name) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;

        String query=sqlMgr.getSql("getAllMaintainableUnits").trim().replaceAll("ppp", name);

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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
    public Vector getUnitByType(String name, String typeRate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;

        String query=sqlMgr.getSql("getUnitByType").trim().replaceAll("ppp", name);
        params.addElement(new StringValue(typeRate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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
    
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

}
