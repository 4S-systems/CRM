package com.clients.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.tracker.common.*;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientSeasonsMgr extends RDBGateWay {
    //ClientProductMgr ClientProductMgr = ClientProductMgr.getInstance();

    private static ClientSeasonsMgr clientSeasonsMgr = new ClientSeasonsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertProSQL = "INSERT INTO project VALUES (?,?,?,NOW(),?,?)";
//      private static final String updateOldProjectNameUnitSQL ="UPDATE maintainable_unit SET SITE =?  WHERE SITE=?";
//        private static final String updateProjectNameIssueSQL ="UPDATE issue SET PROJECT_NAME =?  WHERE PROJECT_NAME=?";
    public static ClientSeasonsMgr getInstance() {
        logger.info("Getting ClientProductMgr Instance ....");
        return clientSeasonsMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_seasons.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("projectName"));
        }

        return cashedData;
    }

    public boolean saveClientSeasons(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        String id = UniqueIDGen.getNextID();
        String userId = (String) request.getAttribute("userId");
        Vector params = new Vector();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(request.getParameter("clientId")));
        params.addElement(new StringValue(request.getParameter("seasonId")));
        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(request.getParameter("seasonNotes")));
        params.addElement(new StringValue(request.getParameter("seasonName")));
        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

//            beginTransaction();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertClientSeasons").trim());
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

    public boolean updateCampaign(HttpServletRequest request, HttpSession s) throws SQLException {

        WebBusinessObject loggedUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = (String) loggedUser.getAttribute("userId");
        Connection connection = null;
        String note = request.getParameter("note");
        String id = request.getParameter("campaignId");
        try {
            int queryResult = -1000;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

            params.addElement(new StringValue(note));

            params.addElement(new StringValue(userId));
            params.addElement(new StringValue(id));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateSeason").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult <= 0) {

                return false;
            } else {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }
  public boolean deteleCampaign(String id) throws SQLException {
        Connection connection = null;
        try {

            int queryResult = -1000;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

            params.addElement(new StringValue(id));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("deleteSeason").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {

                return false;
            } else {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();

        }
    }
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
