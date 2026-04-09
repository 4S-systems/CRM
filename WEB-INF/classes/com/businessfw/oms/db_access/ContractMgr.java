package com.businessfw.oms.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteIntValue;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author folla
 */
public class ContractMgr extends LiteRDBGateWay {

    private static final ContractMgr contractMgr = new ContractMgr();

    public static ContractMgr getInstance() {
        logger.info("Getting ContractMgr Instance ....");
        return contractMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("contract.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        LiteWebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (LiteWebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        if (cashedTable != null) {
            for (int i = 0; i < cashedTable.size(); i++) {
                wbo = (WebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("name"));
            }
        }

        return cashedData;
    }

    @Override
    public boolean saveObject(LiteWebBusinessObject lwbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public String saveResidenceContract(String clientId, String employeeId, String contractNo, String contractName, String contractType, String contractValue, String paymentType, Date beginDate, Date endDate, String notes, String loggedUserId, String period, String shiftNo, String workType, String otherReq, String periodType, String automated) {
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        int results = -1000;

        String id = UniqueIDGen.getNextID();
        String contNo = "";
        String query;
        if ("yes".equals(automated)) {
            query = getQuery("insertContract").trim().replace("contractNo", "CONTACT_NUMBER.NEXTVAL");
        } else {
            LiteWebBusinessObject contWbo = contractMgr.getOnSingleKey("key2", contractNo);
            if (contWbo != null) {
                return null;
            } else {
                contNo = contractNo;
                query = getQuery("insertContract").trim().replace("contractNo", "?");
            }
        }

        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(clientId));
        parameters.addElement(new StringValue(employeeId != null ? employeeId : "UL"));
        
        if (!"yes".equals(automated)) {
            parameters.addElement(new StringValue(contNo));
        }
        parameters.addElement(new StringValue(contractName));
        parameters.addElement(new StringValue(contractType));
        parameters.addElement(new StringValue("13")); // option 4 hold contact status
        
        parameters.addElement(new StringValue(contractValue));
        parameters.addElement(new StringValue(paymentType));
        
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        
        parameters.addElement(new StringValue(notes));
        
        parameters.addElement(new StringValue(loggedUserId));
        
        parameters.addElement(new StringValue(period));
        parameters.addElement(new StringValue(shiftNo));
        parameters.addElement(new StringValue(workType));
        parameters.addElement(new StringValue(otherReq));
        parameters.addElement(new StringValue(periodType != null ? periodType : "UL"));

        try {
            beginTransaction();
            command.setConnection(transConnection);
            command.setSQLQuery(query);
            command.setparams(parameters);
            results = command.executeUpdate();
            if (results <= 0) {
                transConnection.rollback();
                return null;
            }
        } catch (SQLException se) {
            try {
                transConnection.rollback();

            } catch (SQLException ex) {
                Logger.getLogger(ContractMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            logger.error("Exception inserting file descriptor: " + se.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        return (results > 0) ? id : null;
    }
    
    public ArrayList<LiteWebBusinessObject> getAllContractsAboutToExpire(int expireInterval) {
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        params.addElement(new LiteIntValue(expireInterval));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllContractsAboutToExpire").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(ContractScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<LiteWebBusinessObject> resultBusObjs = new ArrayList<>();
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                resultBusObjs.add(fabricateBusObj(r));
            }
        }
        return resultBusObjs;
    }
}
