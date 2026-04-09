package com.tracker.db_access;

import com.contractor.db_access.MaintainableMgr;
import com.crm.db_access.CommentsMgr;
//import com.inspection.ComplaintInspectionMgr;
//import com.inspection.InspectionMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.maintenance.db_access.*;
import com.silkworm.Exceptions.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.common.FilterQuery;
import com.silkworm.common.SecurityUser;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.*;
import com.silkworm.timeutil.*;
import com.silkworm.util.*;
import com.tracker.business_objects.WebIssue;
import com.tracker.common.*;
import java.sql.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueMgr extends RDBGateWay {

    private static IssueMgr issueMgr = new IssueMgr();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
    ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
    UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    MaintainableMgr unitMgr = MaintainableMgr.getInstance();
    // private static final String VIEWALL = "ListAll";
    SQLCommandBean forInsert = null;
    private String centralView = null;
    public String issueId = null;
    public String sID = null;
    private String ScheduleUnitId = null;
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    WebIssue webIssue = null;
    WebBusinessObject viewOrigin = null;
    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();

    public static IssueMgr getInstance() {
        logger.info("Getting IssueMgr Instance ....");
        return issueMgr;
    }

    public IssueMgr() {
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue.xml")));
                logger.debug("supportedForm --> " + supportedForm);
            } catch (Exception e) {
                logger.error("Could not locate XML Document from issueMgr");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveFirstState(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        forInsert = new SQLCommandBean();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        WebIssue issue = (WebIssue) wbo;
        Vector issueStatusParams = new Vector();
        Vector issueParams = new Vector();
        forInsert = new SQLCommandBean();

        issueParams.addElement(new StringValue(new String("Assigned")));
        issueParams.addElement(new StringValue((String) issue.getIssueID()));

        /**
         * *** Get Virtual end date for first status ******
         */
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_ASSIGNED));
        issueStatusParams.addElement(new StringValue((String) issue.getIssueID()));
        issueStatusParams.addElement(new StringValue((String) issue.getIssueTitle()));
        issueStatusParams.addElement(new StringValue((String) issue.getManagerNote()));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));//Total Time

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            executeQuery(sqlMgr.getSql("updateIssueDeviation").trim(), issueParams);
            //executeQuery(updateIssueStatusSQL,issueStatusParams);
//            executeQuery(sqlMgr.getSql("insertFirstIssueStatus").trim(), issueStatusParams);
            executeQuery(sqlMgr.getSql("insertFirstIssueStatusVEDate").trim(), issueStatusParams);

            endTransaction();
        } catch (SQLException sex) {
            return false;

        } finally {
        }
        return true;
    }

    public void saveSchedule(WebBusinessObject wbo, HttpSession s) throws java.sql.SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        Vector issueStatusParams = new Vector();
        StringValue sIssueID = new StringValue(UniqueIDGen.getNextID());

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(sIssueID);
        params.addElement(new StringValue((String) wbo.getAttribute("maintenanceTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("site")));
        params.addElement(new StringValue((String) wbo.getAttribute("machine")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("workTrade")));
        params.addElement(new StringValue((String) wbo.getAttribute("duration")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("beginDate")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("endDate")));
        params.addElement(new StringValue((String) wbo.getAttribute("scheduleUnitID")));
        //
        Long iID = new Long(sIssueID.getString());
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(iID.longValue());
        String sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
        //
        params.addElement(new StringValue(sID));
        String unitId = issueMgr.getUnitId((String) wbo.getAttribute("maintenanceTitle"));
        params.addElement(new StringValue(unitId));

        /**
         * *** Get Virtual end date for first status ******
         */
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_SCHEDULE));
        issueStatusParams.addElement(sIssueID);
        issueStatusParams.addElement(new StringValue((String) wbo.getAttribute("maintenanceTitle")));
        issueStatusParams.addElement(new StringValue((String) wbo.getAttribute("desc")));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));

        Connection connection = dataSource.getConnection();
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueSchedule").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            Thread.sleep(200);
//            forInsert.setSQLQuery(sqlMgr.getSql("insertFirstIssueStatus").trim());
            forInsert.setSQLQuery(sqlMgr.getSql("insertFirstIssueStatusVEDate").trim());
            forInsert.setparams(issueStatusParams);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException ex) {
            throw ex;
        } catch (InterruptedException e) {
        } finally {
            connection.close();

        }
    }

    public void saveSchedule(WebBusinessObject wbo, HttpSession s, Vector sTasks) throws java.sql.SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        Vector issueStatusParams = new Vector();
        StringValue sIssueID = new StringValue(UniqueIDGen.getNextID());

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(sIssueID);
        params.addElement(new StringValue((String) wbo.getAttribute("maintenanceTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("site")));
        params.addElement(new StringValue((String) wbo.getAttribute("machine")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("workTrade")));
        params.addElement(new StringValue((String) wbo.getAttribute("duration")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("beginDate")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("endDate")));
        params.addElement(new StringValue((String) wbo.getAttribute("scheduleUnitID")));
        //
        Long iID = new Long(sIssueID.getString());
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(iID.longValue());
        String sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
        //
        params.addElement(new StringValue(sID));
        params.addElement(new StringValue((String) wbo.getAttribute("eqpId")));

        /**
         * *** Get Virtual end date for first status ******
         */
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_SCHEDULE));
        issueStatusParams.addElement(sIssueID);
        issueStatusParams.addElement(new StringValue((String) wbo.getAttribute("maintenanceTitle")));
        issueStatusParams.addElement(new StringValue((String) wbo.getAttribute("desc")));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));

        Connection connection = dataSource.getConnection();
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueSchedule").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            Thread.sleep(200);
//            forInsert.setSQLQuery(sqlMgr.getSql("insertFirstIssueStatus").trim());
            forInsert.setSQLQuery(sqlMgr.getSql("insertFirstIssueStatusVEDate").trim());
            forInsert.setparams(issueStatusParams);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException ex) {
            throw ex;
        } catch (InterruptedException e) {
        } finally {
            connection.close();

            saveIssueTasks(sIssueID, sTasks);

        }
    }

    public boolean saveState(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        forInsert = new SQLCommandBean();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String nextStatus = null;
        Vector issueStatusParams = new Vector();

        String beginDate = null;
        String endDate = null;
        long lTemp;
        long lHours;
        String sTemp = null;
        DateServices dsDate = new DateServices();
        Vector issueSelect = new Vector();
        String sEndDeviation = null;
        String sBeginDeviation = null;
        String sEstimatedDeviation = null;
        //***;
        Vector issueUpdateStatusParams = new Vector();

        Vector issueParams = new Vector();
        forInsert = new SQLCommandBean();

        String issueId = (String) wbo.getAttribute("issueId");
        String workerNote = (String) wbo.getAttribute("workerNote");

        String causeDescription = (String) wbo.getAttribute("causeDescription");
        String actionTaken = (String) wbo.getAttribute("actionTaken");
        String preventionTaken = (String) wbo.getAttribute("preventionTaken");

        String direction = (String) wbo.getAttribute(AppConstants.DIRECTION);

        String aft = Integer.toString(new Integer(wbo.getAttribute("actual_finish_time").toString()).intValue());
        Float aftI = new Float(aft);

        WebIssue myWebIssue = (WebIssue) getOnSingleKey(issueId);

        String issueTitle = (String) myWebIssue.getAttribute("issueTitle");

        if (direction.equalsIgnoreCase(AppConstants.FORWARD_DIRECTION)) {
            nextStatus = myWebIssue.getNextStateName();
        } else {
            if (direction.equalsIgnoreCase(AppConstants.BACKWARD_DIRECTION)) {
                nextStatus = myWebIssue.getReverseStateName();
            }
        }
        //B New
        long lDeviation = 0;
        lTemp = 0;
        IssueMgr issueMgr = IssueMgr.getInstance();

        WebBusinessObject issueStatusList = issueMgr.getOnSingleKey(issueId);
        if (nextStatus.equalsIgnoreCase("INPROGRESS")) {
            beginDate = (String) issueStatusList.getAttribute("expectedBeginDate");
            endDate = "2010-12-31";
            lTemp = dsDate.convertMySQLDate(endDate) - dsDate.convertMySQLDate(beginDate);
            lTemp = lTemp / (1000);
            lDeviation = lTemp / (60 * 60 * 24);
            if ((lTemp - (lDeviation * 60 * 60 * 24)) > 0) {
                lDeviation++;
            }
            sBeginDeviation = sTemp.valueOf(lDeviation);
            sEndDeviation = (String) issueStatusList.getAttribute("endDeviation");
            sEstimatedDeviation = (String) issueStatusList.getAttribute("estimatedDeviation");
        } else if (nextStatus.equalsIgnoreCase("RESOLVED")) {
            beginDate = (String) issueStatusList.getAttribute("expectedEndDate");
            endDate = "2010-12-31";
            lTemp = dsDate.convertMySQLDate(endDate) - dsDate.convertMySQLDate(beginDate);
            lTemp = lTemp / (1000);
            lDeviation = lTemp / (60 * 60 * 24);
            if ((lTemp - (lDeviation * 60 * 60 * 24)) > 0) {
                lDeviation++;
            }
            int iDeviation;
            sBeginDeviation = (String) issueStatusList.getAttribute("beginDeviation");
            sEndDeviation = sTemp.valueOf(lDeviation);
            Long lDivTemp1 = new Long((String) issueStatusList.getAttribute("finishedTime"));
            iDeviation = lDivTemp1.intValue();
            iDeviation = aftI.intValue() - iDeviation;
            sEstimatedDeviation = sTemp.valueOf(iDeviation);
        } else {
            sBeginDeviation = (String) issueStatusList.getAttribute("beginDeviation");
            sEndDeviation = (String) issueStatusList.getAttribute("endDeviation");
            sEstimatedDeviation = (String) issueStatusList.getAttribute("estimatedDeviation");
        }
        //E New
        Integer iBeginDate = new Integer(sBeginDeviation);
        Integer iEndDate = new Integer(sEndDeviation);
        Integer iEstimatedDeviation = new Integer(sEstimatedDeviation);
        java.sql.Date dTemp = null;

        String hour = (String) wbo.getAttribute("hour");
        String min = (String) wbo.getAttribute("minute");
        int h = Integer.parseInt(hour);
        int m = Integer.parseInt(min);
        String actualEndDate = (String) wbo.getAttribute("actualEndDate");
//        String []beactualEndDate = actualEndDate.split("/");
//        int bYear=Integer.parseInt(beactualEndDate[2]);
//        int bMonth=Integer.parseInt(beactualEndDate[0]);
//        int bDay=Integer.parseInt(beactualEndDate[1]);
//        java.util.Date siteD=new java.util.Date(bYear-1900,bMonth-1,bDay,h,m);

        DateParser dateParser = new DateParser();

        /**
         * *** Get Virtual end date for first status ******
         */
        java.sql.Timestamp virtaulEndDate;
        if (nextStatus.equalsIgnoreCase("Finished")) {
            virtaulEndDate = new java.sql.Timestamp(Calendar.getInstance().getTimeInMillis());
        } else {
            java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
            virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());
        }

        java.util.Date siteD = dateParser.formatUtilDate(actualEndDate, h, m);

        java.sql.Timestamp endJobDate = new java.sql.Timestamp(siteD.getTime());

        if (wbo.getAttribute("actualEndDate") != null) {
            DropdownDate dropdownDate = new DropdownDate();
            dTemp = new java.sql.Date(dropdownDate.getDate((String) wbo.getAttribute("actualEndDate")).getTime());
        }
        java.sql.Timestamp actDate = new java.sql.Timestamp(dTemp.getTime());

        IssueStatusMgr iStatusMgr = IssueStatusMgr.getInstance();
        issueParams.addElement(new StringValue(new String(nextStatus)));
        // issueParams.addElement(new FloatValue(new new Float(aftI).floatValue())));
        issueParams.addElement(new FloatValue(new Float(aft).floatValue()));

        WebBusinessObject lastIssueStatus = iStatusMgr.getLastIssueStatus(issueId);
        issueParams.addElement(new IntValue(iEndDate.intValue()));
        issueParams.addElement(new IntValue(iBeginDate.intValue()));
        issueParams.addElement(new IntValue(iEstimatedDeviation.intValue()));
        issueParams.addElement(new TimestampValue(endJobDate));
        issueParams.addElement(new StringValue(issueId));
        //***;

        beginDate = (String) lastIssueStatus.getAttribute("beginDate");
        endDate = (String) lastIssueStatus.getAttribute("endDate");
        lTemp = dsDate.convertMySQLDateToLong(endDate) - dsDate.convertMySQLDateToLong(beginDate);
        lTemp = lTemp / (1000);
        lHours = lTemp / (60 * 60);
        if ((lTemp - (lHours * 60 * 60)) > 0) {
            lHours++;
        }
        issueUpdateStatusParams.addElement(new StringValue(sTemp.valueOf(lHours)));
        issueUpdateStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueUpdateStatusParams.addElement(new StringValue(issueId));

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));//issuestatusid
        issueStatusParams.addElement(new StringValue(nextStatus));//status name
        issueStatusParams.addElement(new StringValue(issueId));//issue id
        issueStatusParams.addElement(new StringValue(issueTitle)); // issue title
        issueStatusParams.addElement(new StringValue(workerNote));//worker notes
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));//Total Time
        issueStatusParams.addElement(new StringValue(causeDescription));
        issueStatusParams.addElement(new StringValue(actionTaken));
        issueStatusParams.addElement(new StringValue(preventionTaken));

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            executeQuery(sqlMgr.getSql("updateIssueDeviation").trim(), issueParams);
            //***;
//            executeQuery(sqlMgr.getSql("updateIssueStatusDate").trim(), issueUpdateStatusParams);
            executeQuery(sqlMgr.getSql("updateIssueStatusDateVirtualDate").trim(), issueUpdateStatusParams);

//            executeQuery(sqlMgr.getSql("insertClosedIssueStatus").trim(), issueStatusParams);
            executeQuery(sqlMgr.getSql("insertClosedIssueStatusVirtualDate").trim(), issueStatusParams);

            endTransaction();
        } catch (SQLException sex) {
            return false;

        } finally {
        }
        return true;
    }

    public boolean saveOrderState(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        forInsert = new SQLCommandBean();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String nextStatus = null;
        Vector issueStatusParams = new Vector();

        String beginDate = null;
        String endDate = null;
        long lTemp;
        long lHours;
        String sTemp = null;
        DateServices dsDate = new DateServices();
        Vector issueSelect = new Vector();
        String sEndDeviation = null;
        String sBeginDeviation = null;
        String sEstimatedDeviation = null;
        //***;
        Vector issueUpdateStatusParams = new Vector();

        Vector issueParams = new Vector();
        forInsert = new SQLCommandBean();

        String issueId = (String) wbo.getAttribute("issueId");
        String workerNote = (String) wbo.getAttribute("workerNote");

        String causeDescription = (String) wbo.getAttribute("causeDescription");
        String actionTaken = (String) wbo.getAttribute("actionTaken");
        String preventionTaken = (String) wbo.getAttribute("preventionTaken");

        String direction = (String) wbo.getAttribute(AppConstants.DIRECTION);

        String aft = (String) wbo.getAttribute("actual_finish_time");
        Float aftI = new Float(aft);

        WebIssue myWebIssue = (WebIssue) getOnSingleKey(issueId);

        String issueTitle = (String) myWebIssue.getAttribute("issueTitle");

        if (direction.equalsIgnoreCase(AppConstants.FORWARD_DIRECTION)) {
            nextStatus = myWebIssue.getNextStateName();
        } else {
            if (direction.equalsIgnoreCase(AppConstants.BACKWARD_DIRECTION)) {
                nextStatus = myWebIssue.getReverseStateName();
            }
        }
        //B New
        long lDeviation = 0;
        lTemp = 0;
        IssueMgr issueMgr = IssueMgr.getInstance();

        WebBusinessObject issueStatusList = issueMgr.getOnSingleKey(issueId);
        if (nextStatus.equalsIgnoreCase("INPROGRESS")) {
            beginDate = (String) issueStatusList.getAttribute("expectedBeginDate");
            endDate = "2010-12-31";
            lTemp = dsDate.convertMySQLDate(endDate) - dsDate.convertMySQLDate(beginDate);
            lTemp = lTemp / (1000);
            lDeviation = lTemp / (60 * 60 * 24);
            if ((lTemp - (lDeviation * 60 * 60 * 24)) > 0) {
                lDeviation++;
            }
            sBeginDeviation = sTemp.valueOf(lDeviation);
            sEndDeviation = (String) issueStatusList.getAttribute("endDeviation");
            sEstimatedDeviation = (String) issueStatusList.getAttribute("estimatedDeviation");
        } else if (nextStatus.equalsIgnoreCase("RESOLVED")) {
            beginDate = (String) issueStatusList.getAttribute("expectedEndDate");
            endDate = "2010-12-31";
            lTemp = dsDate.convertMySQLDate(endDate) - dsDate.convertMySQLDate(beginDate);
            lTemp = lTemp / (1000);
            lDeviation = lTemp / (60 * 60 * 24);
            if ((lTemp - (lDeviation * 60 * 60 * 24)) > 0) {
                lDeviation++;
            }
            int iDeviation;
            sBeginDeviation = (String) issueStatusList.getAttribute("beginDeviation");
            sEndDeviation = sTemp.valueOf(lDeviation);
            Long lDivTemp1 = new Long((String) issueStatusList.getAttribute("finishedTime"));
            iDeviation = lDivTemp1.intValue();
            iDeviation = aftI.intValue() - iDeviation;
            sEstimatedDeviation = sTemp.valueOf(iDeviation);
        } else {
            sBeginDeviation = (String) issueStatusList.getAttribute("beginDeviation");
            sEndDeviation = (String) issueStatusList.getAttribute("endDeviation");
            sEstimatedDeviation = (String) issueStatusList.getAttribute("estimatedDeviation");
        }
        //E New
        Integer iBeginDate = new Integer(sBeginDeviation);
        Integer iEndDate = new Integer(sEndDeviation);
        Integer iEstimatedDeviation = new Integer(sEstimatedDeviation);
        java.sql.Date dTemp = null;

//        String hour=(String) wbo.getAttribute("hour");
//        String min=(String) wbo.getAttribute("minute");
//        int h=Integer.parseInt(hour);
//        int m=Integer.parseInt(min);
//        String actualEndDate = (String) wbo.getAttribute("actualEndDate");
//        String []beactualEndDate = actualEndDate.split("/");
//        int bYear=Integer.parseInt(beactualEndDate[2]);
//        int bMonth=Integer.parseInt(beactualEndDate[0]);
//        int bDay=Integer.parseInt(beactualEndDate[1]);
//        java.util.Date siteD=new java.util.Date(bYear-1900,bMonth-1,bDay,h,m);
//        java.sql.Timestamp endJobDate = new java.sql.Timestamp(siteD.getTime());
//        if (wbo.getAttribute("actualEndDate") != null) {
//            DropdownDate dropdownDate = new DropdownDate();
//            dTemp = new java.sql.Date(dropdownDate.getDate((String) wbo.getAttribute("actualEndDate")).getTime());
//        }
//        java.sql.Timestamp actDate = new java.sql.Timestamp(dTemp.getTime());
        IssueStatusMgr iStatusMgr = IssueStatusMgr.getInstance();
        issueParams.addElement(new StringValue(new String(nextStatus)));
        // issueParams.addElement(new FloatValue(new new Float(aftI).floatValue())));
        issueParams.addElement(new FloatValue(new Float(aft).floatValue()));

        WebBusinessObject lastIssueStatus = iStatusMgr.getLastIssueStatus(issueId);
        issueParams.addElement(new IntValue(iEndDate.intValue()));
        issueParams.addElement(new IntValue(iBeginDate.intValue()));
        issueParams.addElement(new IntValue(iEstimatedDeviation.intValue()));
//        issueParams.addElement(new TimestampValue(endJobDate));
        issueParams.addElement(new StringValue(issueId));
        //***;

        beginDate = (String) lastIssueStatus.getAttribute("beginDate");
        endDate = (String) lastIssueStatus.getAttribute("endDate");
        lTemp = dsDate.convertMySQLDateToLong(endDate) - dsDate.convertMySQLDateToLong(beginDate);
        lTemp = lTemp / (1000);
        lHours = lTemp / (60 * 60);
        if ((lTemp - (lHours * 60 * 60)) > 0) {
            lHours++;
        }
        issueUpdateStatusParams.addElement(new StringValue(sTemp.valueOf(lHours)));
        issueUpdateStatusParams.addElement(new StringValue(issueId));

        DateParser dateParser = new DateParser();

        /**
         * *** Get Virtual end date for first status ******
         */
        java.sql.Timestamp virtaulEndDate;
        if (nextStatus.equalsIgnoreCase("Canceled")) {
            virtaulEndDate = new java.sql.Timestamp(Calendar.getInstance().getTimeInMillis());
        } else {
            java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
            virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());
        }

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));//issuestatusid
        issueStatusParams.addElement(new StringValue(nextStatus));//status name
        issueStatusParams.addElement(new StringValue(issueId));//issue id
        issueStatusParams.addElement(new StringValue(issueTitle)); // issue title
        issueStatusParams.addElement(new StringValue(workerNote));//worker notes
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));//Total Time
        issueStatusParams.addElement(new StringValue(causeDescription));
        issueStatusParams.addElement(new StringValue(actionTaken));
        issueStatusParams.addElement(new StringValue(preventionTaken));

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            executeQuery(sqlMgr.getSql("updateIssueDeviationOnholdCancel").trim(), issueParams);
            //***;
            executeQuery(sqlMgr.getSql("updateIssueStatusDate").trim(), issueUpdateStatusParams);
//            executeQuery(sqlMgr.getSql("insertClosedIssueStatus").trim(), issueStatusParams);
            executeQuery(sqlMgr.getSql("insertClosedIssueStatusVirtualDate").trim(), issueStatusParams);

            endTransaction();
        } catch (SQLException sex) {
            return false;

        } finally {
        }
        return true;
    }

    public boolean cancelJopOrder(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        forInsert = new SQLCommandBean();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String nextStatus = null;
        Vector issueStatusParams = new Vector();

        String beginDate = null;
        String endDate = null;
        long lTemp;
        long lHours;
        String sTemp = null;
        DateServices dsDate = new DateServices();
        Vector issueSelect = new Vector();
        String sEndDeviation = null;
        String sBeginDeviation = null;
        String sEstimatedDeviation = null;
        //***;
        Vector issueUpdateStatusParams = new Vector();

        Vector issueParams = new Vector();
        forInsert = new SQLCommandBean();

        String issueId = (String) wbo.getAttribute("issueId");
        String workerNote = (String) wbo.getAttribute("workerNote");

        String causeDescription = (String) wbo.getAttribute("causeDescription");
        String actionTaken = (String) wbo.getAttribute("actionTaken");
        String preventionTaken = (String) wbo.getAttribute("preventionTaken");

        String direction = (String) wbo.getAttribute(AppConstants.DIRECTION);

        String aft = (String) wbo.getAttribute("actual_finish_time");
        Float aftI = new Float(aft);

        WebIssue myWebIssue = (WebIssue) getOnSingleKey(issueId);

        String issueTitle = (String) myWebIssue.getAttribute("issueTitle");
        nextStatus = "Canceled";

        //B New
        long lDeviation = 0;
        lTemp = 0;
        IssueMgr issueMgr = IssueMgr.getInstance();

        WebBusinessObject issueStatusList = issueMgr.getOnSingleKey(issueId);
        if (nextStatus.equalsIgnoreCase("INPROGRESS")) {
            beginDate = (String) issueStatusList.getAttribute("expectedBeginDate");
            endDate = "2010-12-31";
            lTemp = dsDate.convertMySQLDate(endDate) - dsDate.convertMySQLDate(beginDate);
            lTemp = lTemp / (1000);
            lDeviation = lTemp / (60 * 60 * 24);
            if ((lTemp - (lDeviation * 60 * 60 * 24)) > 0) {
                lDeviation++;
            }
            sBeginDeviation = sTemp.valueOf(lDeviation);
            sEndDeviation = (String) issueStatusList.getAttribute("endDeviation");
            sEstimatedDeviation = (String) issueStatusList.getAttribute("estimatedDeviation");
        } else if (nextStatus.equalsIgnoreCase("RESOLVED")) {
            beginDate = (String) issueStatusList.getAttribute("expectedEndDate");
            endDate = "2010-12-31";
            lTemp = dsDate.convertMySQLDate(endDate) - dsDate.convertMySQLDate(beginDate);
            lTemp = lTemp / (1000);
            lDeviation = lTemp / (60 * 60 * 24);
            if ((lTemp - (lDeviation * 60 * 60 * 24)) > 0) {
                lDeviation++;
            }
            int iDeviation;
            sBeginDeviation = (String) issueStatusList.getAttribute("beginDeviation");
            sEndDeviation = sTemp.valueOf(lDeviation);
            Long lDivTemp1 = new Long((String) issueStatusList.getAttribute("finishedTime"));
            iDeviation = lDivTemp1.intValue();
            iDeviation = aftI.intValue() - iDeviation;
            sEstimatedDeviation = sTemp.valueOf(iDeviation);
        } else {
            sBeginDeviation = (String) issueStatusList.getAttribute("beginDeviation");
            sEndDeviation = (String) issueStatusList.getAttribute("endDeviation");
            sEstimatedDeviation = (String) issueStatusList.getAttribute("estimatedDeviation");
        }
        //E New
        Integer iBeginDate = new Integer(sBeginDeviation);
        Integer iEndDate = new Integer(sEndDeviation);
        Integer iEstimatedDeviation = new Integer(sEstimatedDeviation);
        java.sql.Date dTemp = null;

        IssueStatusMgr iStatusMgr = IssueStatusMgr.getInstance();
        issueParams.addElement(new StringValue(new String(nextStatus)));
        issueParams.addElement(new FloatValue(new Float(aft).floatValue()));

        WebBusinessObject lastIssueStatus = iStatusMgr.getLastIssueStatus(issueId);
        issueParams.addElement(new IntValue(iEndDate.intValue()));
        issueParams.addElement(new IntValue(iBeginDate.intValue()));
        issueParams.addElement(new IntValue(iEstimatedDeviation.intValue()));
        issueParams.addElement(new StringValue(issueId));
        //***;

        beginDate = (String) lastIssueStatus.getAttribute("beginDate");
        endDate = (String) lastIssueStatus.getAttribute("endDate");
        lTemp = dsDate.convertMySQLDateToLong(endDate) - dsDate.convertMySQLDateToLong(beginDate);
        lTemp = lTemp / (1000);
        lHours = lTemp / (60 * 60);
        if ((lTemp - (lHours * 60 * 60)) > 0) {
            lHours++;
        }
        issueUpdateStatusParams.addElement(new StringValue(sTemp.valueOf(lHours)));
        issueUpdateStatusParams.addElement(new StringValue(issueId));

        /**
         * *** Get Virtual end date for first status ******
         */
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));//issuestatusid
        issueStatusParams.addElement(new StringValue(nextStatus));//status name
        issueStatusParams.addElement(new StringValue(issueId));//issue id
        issueStatusParams.addElement(new StringValue(issueTitle)); // issue title
        issueStatusParams.addElement(new StringValue(workerNote));//worker notes
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));//Total Time
        issueStatusParams.addElement(new StringValue(causeDescription));
        issueStatusParams.addElement(new StringValue(actionTaken));
        issueStatusParams.addElement(new StringValue(preventionTaken));

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            executeQuery(sqlMgr.getSql("updateIssueDeviationOnholdCancel").trim(), issueParams);
            //***;
            executeQuery(sqlMgr.getSql("updateIssueStatusDate").trim(), issueUpdateStatusParams);
//            executeQuery(sqlMgr.getSql("insertClosedIssueStatus").trim(), issueStatusParams);
            executeQuery(sqlMgr.getSql("insertClosedIssueStatusVirtualDate").trim(), issueStatusParams);

            endTransaction();
        } catch (SQLException sex) {
            return false;

        } finally {
        }
        return true;
    }

    public boolean saveEmgObject(HttpServletRequest request, WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        //Get Logged User
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        dateAndTime = new DateAndTimeControl();
        int minutes = 0;

        // check status of job order number, automate or user defined
        String orderID = request.getParameter("automatedOrderID");
        if (orderID != null) {
            orderID = request.getParameter("sequence");
        } else {
            orderID = request.getParameter("orderID");
        }

        // date of update equipment that create issue on it
        long dateUpdate;

        String day = (String) request.getParameter("day");
        String hours = (String) request.getParameter("hour");
        String minute = (String) request.getParameter("minute");

        if (day != null && !day.equals("")) {
            minutes = minutes + dateAndTime.getMinuteOfDay(day);
        }
        if (hours != null && !hours.equals("")) {
            minutes = minutes + dateAndTime.getMinuteOfHour(hours);
        }
        if (minute != null && !minute.equals("")) {
            minutes = minutes + new Integer(minute).intValue();
        }
        //Define System params Variables
        Vector unitScheduleParams = new Vector();
        Vector issueParams = new Vector();
        Vector issueStatusParams = new Vector();

        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();

        int queryResult = -1000;

        Connection connection = null;

        //Get WebIssue
        String UnitId = request.getParameter("unitId");
        try {
            //define command been
            SQLCommandBean command = new SQLCommandBean();

            //Get expected begin and end date
            String bDate = request.getParameter("beginDate");
            String eDate = request.getParameter("endDate");
            String sDate = request.getParameter("siteEntryDate");
            String hour = request.getParameter("h");
            String min = request.getParameter("m");
            int h = Integer.parseInt(hour);
            int m = Integer.parseInt(min);

            String jsDateFormat = waUser.getAttribute("jsDateFormat").toString();
            DateParser dateParser = new DateParser();
            java.sql.Date beginD = dateParser.formatSqlDate(bDate, jsDateFormat);
            java.sql.Date endD = dateParser.formatSqlDate(eDate, jsDateFormat);
            java.util.Date siteD = dateParser.formatUtilDate(sDate, h, m, jsDateFormat);

            java.sql.Timestamp beginDate = new java.sql.Timestamp(beginD.getTime());
            java.sql.Timestamp endDate = new java.sql.Timestamp(endD.getTime());
            java.sql.Timestamp siteEntryDate = new java.sql.Timestamp(siteD.getTime());

            // set dateUpdate for update average_unit by siteEnteryDate of issue
            dateUpdate = siteEntryDate.getTime();

            /**
             * *** Get Virtual end date for first status ******
             */
            java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
            java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

            //Get main wbo attributes
            ScheduleUnitId = UniqueIDGen.getNextID().toString();

            String UnitName = request.getParameter("unitName");
            MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
            if (UnitName == null) {
                UnitName = maintainableMgr.getUnitName(UnitId);
            }
            String ScheduleId = issueMgr.getScheduleId("Emergency");
            StringValue sIssueID = new StringValue(UniqueIDGen.getNextID());
            String pname = (String) wbo.getAttribute("project_name");

            //Set Unit Schedule Params
            unitScheduleParams.addElement(new StringValue(ScheduleUnitId));
            unitScheduleParams.addElement(new StringValue(UnitId));
            unitScheduleParams.addElement(new StringValue(UnitName));
            unitScheduleParams.addElement(new StringValue(ScheduleId));
            unitScheduleParams.addElement(new StringValue("Emergency"));
            unitScheduleParams.addElement(new TimestampValue(beginDate));
            unitScheduleParams.addElement(new TimestampValue(endDate));

            //Set Issue Params
            issueParams.addElement(sIssueID);
            issueParams.addElement(new StringValue(pname));
            issueParams.addElement(new StringValue(UnitName));
            issueParams.addElement(new StringValue((String) waUser.getAttribute("userId")));
            issueParams.addElement(new StringValue(urgencyMgr.getUrgencyId(request.getParameter("urgencyName"))));
            issueParams.addElement(new StringValue(request.getParameter("issueDesc")));
            issueParams.addElement(new StringValue(request.getParameter("receivedby")));
            issueParams.addElement(new StringValue(request.getParameter("trade")));
            issueParams.addElement(new IntValue(minutes));
            issueParams.addElement(new TimestampValue(beginDate));
            issueParams.addElement(new TimestampValue(endDate));
            issueParams.addElement(new StringValue(ScheduleUnitId));
            issueParams.addElement(new StringValue(orderID));

            Long iID = new Long(sIssueID.getString());
            Calendar calendar = Calendar.getInstance();
            calendar.setTimeInMillis(iID.longValue());
            sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);

            issueParams.addElement(new StringValue(request.getParameter("jobSize")));

            issueParams.addElement(new StringValue(sID));
            issueParams.addElement(new TimestampValue(siteEntryDate));
            issueParams.addElement(new StringValue(UnitId));
            issueParams.addElement(new StringValue(request.getParameter("shift")));

            issueId = sIssueID.getString();
            request.setAttribute("issueId", issueId);

            //Set IssueStatus Params
            issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
            issueStatusParams.addElement(new StringValue(AppConstants.LC_SCHEDULE));
            issueStatusParams.addElement(sIssueID);
            issueStatusParams.addElement(new StringValue(request.getParameter("issueDesc")));
            issueStatusParams.addElement(new TimestampValue(virtaulEndDate));

            //Setup connection
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);

            //Save UnitSchedule
            command.setSQLQuery(sqlMgr.getSql("insertIssueUnitSchedule").trim());
            command.setparams(unitScheduleParams);
            if (command.executeUpdate() == 0) {
                connection.rollback();
                return false;
            }

            //Save Issue
            command.setSQLQuery(sqlMgr.getSql("insertIssueEmg").trim());
            command.setparams(issueParams);
            if (command.executeUpdate() == 0) {
                connection.rollback();
                return false;
            }

            //Save Issue_Status
            command.setSQLQuery(sqlMgr.getSql("insertEmgIssueStatusVirtualDate").trim());
            command.setparams(issueStatusParams);
            if (command.executeUpdate() == 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException sql) {
                logger.error(sql.getMessage());
            }

            logger.error(ex.getMessage());
            return false;
        } catch (Exception ex) {
            try {
                connection.rollback();
            } catch (SQLException sql) {
                logger.error(sql.getMessage());
            }

            logger.error(ex.getMessage());
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

    public boolean saveObject(HttpServletRequest request, WebBusinessObject wbo, HttpSession s, String urgencyId) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject tradeWbo = new WebBusinessObject();
        WebBusinessObject userTradeWbo = new WebBusinessObject();
        Vector tradeParams = new Vector();
        Vector userTradeParams = new Vector();

        try {
            tradeParams = tradeMgr.getOnArbitraryKey(request.getParameter("workTrade").toString(), "key1");
            for (int i = 0; i < tradeParams.size(); i++) {
                tradeWbo = (WebBusinessObject) tradeParams.get(i);
            }
            userTradeParams = userTradeMgr.getOnArbitraryDoubleKey(tradeWbo.getAttribute("tradeId").toString(), "key2", waUser.getAttribute("userId").toString(), "key1");
            for (int i = 0; i < userTradeParams.size(); i++) {
                userTradeWbo = (WebBusinessObject) userTradeParams.get(i);
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        theRequest = request;

//        java.sql.Timestamp beginDate = dropdownDate.getDate(request.getParameter("beginDate"));//super.extractFromDateFromRequest();
//        java.sql.Timestamp endDate = dropdownDate.getDate(request.getParameter("endDate"));//super.extractToDateFromRequest();
        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Timestamp beginDate = new java.sql.Timestamp(sqlDate.getTime());

        sqlDate = dateParser.formatSqlDate(request.getParameter("endDate"));
        java.sql.Timestamp endDate = new java.sql.Timestamp(sqlDate.getTime());

        WebIssue issue = (WebIssue) wbo;
        Vector issueStatusParams = new Vector();
        Vector unitScheduleParams = new Vector();

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        //B New
        int queryResult1 = -1000;
        //E New
        String pname = (String) wbo.getAttribute("project_name");
        String TotalCost = request.getParameter("totalCost");
        String UnitName = request.getParameter("unitName");
        String ScheduleTitle = request.getParameter("maintenanceTitle");
        int estDuration = new Integer(request.getParameter("estimatedduration").toString()).intValue();
        // String issueId = null;
//        String ScheduleUnitId = null;

        String UnitId = null;
        String ScheduleId = null;
        UnitId = issueMgr.getUnitId(UnitName);
        ScheduleId = issueMgr.getScheduleId(ScheduleTitle);
        ScheduleUnitId = UniqueIDGen.getNextID().toString();

        StringValue sIssueID = new StringValue(UniqueIDGen.getNextID());
        params.addElement(sIssueID);
        params.addElement(new StringValue(ScheduleTitle));
        params.addElement(new StringValue(pname));
        params.addElement(new StringValue(request.getParameter("FAName") + "/" + request.getParameter("groupNum")));
        //params.addElement(new StringValue(request.getParameter("issueType")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue(urgencyId));
        params.addElement(new StringValue(request.getParameter("issueDesc")));
        params.addElement(new StringValue(request.getParameter("receivedby")));
        params.addElement(new StringValue((String) tradeWbo.getAttribute("tradeId")));
        //params.addElement(new StringValue(request.getParameter("workTrade")));
        params.addElement(new IntValue(estDuration));
        params.addElement(new StringValue(request.getParameter("failurecode")));
//        params.addElement(new StringValue(issue.getDocBaseUrl()));
//        params.addElement(new StringValue(issue.getDocRefId()));
//        params.addElement(new StringValue((String)request.getParameter("docBaseUrl")));
//        params.addElement(new StringValue((String)request.getParameter("docRefId")));
        //params.addElement(new StringValue(request.getParameter("groupNum")));
        params.addElement(new TimestampValue(beginDate));
        params.addElement(new TimestampValue(endDate));
        params.addElement(new StringValue(TotalCost));
        params.addElement(new StringValue(ScheduleUnitId));
        //
        Long iID = new Long(sIssueID.getString());
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(iID.longValue());
        sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
        //

        params.addElement(new StringValue(request.getParameter("jobzise")));
//        params.addElement(new StringValue((String)waUser.getAttribute("groupID")));
//        params.addElement(new StringValue((String)userTradeWbo.getAttribute("Id")));
        params.addElement(new StringValue(sID));
        params.addElement(new StringValue(UnitId));
        issueId = sIssueID.getString();
        request.setAttribute("issueId", issueId);
//        params.addElement(new StringValue((String)request.getParameter("auditor")));
//        params.addElement(new StringValue((String)request.getParameter("auditee")));
//        params.addElement(new TimestampValue(auditDate));
//        params.addElement(new TimestampValue(reportDate));
        //B New

        /**
         * *** Get Virtual end date for first status ******
         */
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_SCHEDULE));
        issueStatusParams.addElement(sIssueID);
        issueStatusParams.addElement(new StringValue(ScheduleTitle));
        issueStatusParams.addElement(new StringValue(request.getParameter("issueDesc")));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));
        //E New

        //B New
//        unitScheduleParams.addElement(sIssueID);
        unitScheduleParams.addElement(new StringValue(ScheduleUnitId));
        unitScheduleParams.addElement(new StringValue(UnitId));
        unitScheduleParams.addElement(new StringValue(UnitName));
        unitScheduleParams.addElement(new StringValue(ScheduleId));
        unitScheduleParams.addElement(new StringValue(ScheduleTitle));
        unitScheduleParams.addElement(new TimestampValue(beginDate));
        unitScheduleParams.addElement(new TimestampValue(endDate));
        //E New

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueUnitSchedule").trim());
            forInsert.setparams(unitScheduleParams);
            queryResult1 = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("insertIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //Thread.sleep(200);
            //B New
//            forInsert.setSQLQuery(sqlMgr.getSql("insertFirstIssueStatus").trim());
            forInsert.setSQLQuery(sqlMgr.getSql("insertFirstIssueStatusVEDate").trim());
            forInsert.setparams(issueStatusParams);
            queryResult1 = forInsert.executeUpdate();
            //E New
            //Thread.sleep(200);
            //B New
//            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueUnitSchedule").trim());
//            forInsert.setparams(unitScheduleParams);
//            queryResult1 = forInsert.executeUpdate();
            //E New

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            return false;
        } //catch(InterruptedException e){
        //    }
        finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }

    public boolean updateObject(HttpServletRequest request, HttpSession s) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        theRequest = request;

//        java.sql.Timestamp beginDate = dropdownDate.getDate(request.getParameter("beginDate"));//super.extractFromDateFromRequest();
//        java.sql.Timestamp endDate = dropdownDate.getDate(request.getParameter("endDate"));//super.extractToDateFromRequest();
        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Timestamp beginDate = new java.sql.Timestamp(sqlDate.getTime());

        sqlDate = dateParser.formatSqlDate(request.getParameter("endDate"));
        java.sql.Timestamp endDate = new java.sql.Timestamp(sqlDate.getTime());

//        java.sql.Timestamp auditDate = super.extractDateFromRequest();
//        java.sql.Timestamp reportDate = super.extractDate2FromRequest();
//        Vector issueStatusParams = new Vector();
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
//        int queryResult1 = -1000;

        String pname = (String) request.getParameter("project_name");

//        params.addElement(new StringValue((String) request.getParameter("issueTitle")));
        params.addElement(new StringValue(pname));
        params.addElement(new StringValue((String) request.getParameter("FAName")));
        params.addElement(new StringValue((String) request.getParameter("typeName")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) request.getParameter("urgencyName")));
//        params.addElement(new StringValue((String)request.getParameter("issueDesc")));
//        params.addElement(new StringValue(issue.getDocBaseUrl()));
//        params.addElement(new StringValue(issue.getDocRefId()));
//        params.addElement(new StringValue((String)request.getParameter("docBaseUrl")));
//        params.addElement(new StringValue((String)request.getParameter("docRefId")));
        params.addElement(new TimestampValue(beginDate));
        params.addElement(new TimestampValue(endDate));
        params.addElement(new StringValue((String) request.getParameter("isRisk")));
//        params.addElement(new StringValue((String)request.getParameter("auditor")));
//        params.addElement(new StringValue((String)request.getParameter("auditee")));
//        params.addElement(new TimestampValue(auditDate));
//        params.addElement(new TimestampValue(reportDate));

        StringValue sIssueID = new StringValue((String) request.getParameter("id"));
        params.addElement(sIssueID);
        //B New
//        issueStatusParams.addElement(new StringValue((String) request.getParameter("issueTitle")));
//        issueStatusParams.addElement(new StringValue((String)request.getParameter("issueDesc")));
//        issueStatusParams.addElement(sIssueID);
        //E New

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateIssue").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            //B New
//            forUpdate.setSQLQuery(updateIssueStatusSQL);
//            forUpdate.setparams(issueStatusParams);
//            queryResult1 = forUpdate.executeUpdate();
            //E New
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
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

    public boolean updateEmgOrder(HttpServletRequest request, HttpSession s) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        theRequest = request;
        UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();

        String machine = (String) request.getParameter("machineName");
        String[] machineData = machine.split(",");
        String machineId = machineData[0];
        String machineName = machineData[1];

        String receivedby = (String) request.getParameter("receivedby");
        String workTrade = (String) request.getParameter("workTrade");
        String issueTitle = (String) request.getParameter("issueTitle");
        String urgencyId = urgencyMgr.getUrgencyId(request.getParameter("urgencyName"));
        String jobZise = request.getParameter("jobzise");

        Vector params = new Vector();
        Vector sqlParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        String scheduleId = (String) request.getParameter("issueId");
        StringValue sIssueID = new StringValue(scheduleId);
        WebBusinessObject wbotemp = (WebBusinessObject) issueMgr.getOnSingleKey(scheduleId);
        String unit_Schedule_ID = (String) wbotemp.getAttribute("unitScheduleID");

        params.addElement(new StringValue(receivedby));
        params.addElement(new StringValue(workTrade));
        params.addElement(new StringValue(urgencyId));
        params.addElement(new StringValue(jobZise));
        params.addElement(new IntValue(new Integer(request.getParameter("duration"))));
        params.addElement(new StringValue(request.getParameter("issueDesc")));
        params.addElement(new StringValue(request.getParameter("shift")));
        params.addElement(sIssueID);

        sqlParams.addElement(new StringValue(machineId));
        sqlParams.addElement(new StringValue(machineName));
        sqlParams.addElement(new StringValue(unit_Schedule_ID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateOrderIssue").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            forUpdate.setSQLQuery(sqlMgr.getSql("updateUnitSchedule").trim());
            forUpdate.setparams(sqlParams);
            queryResult = forUpdate.executeUpdate();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
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

    /**
     * *******************************************************************
     */
    public boolean updateJobOrder(WebBusinessObject wbo) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("workTrade")));
        params.addElement(new StringValue((String) wbo.getAttribute("shift")));

        params.addElement(new IntValue((Integer) wbo.getAttribute("estimatedduration")));
        params.addElement(new StringValue((String) wbo.getAttribute("issueDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateJobOrder").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

//            cashData();
        } catch (SQLException ex) {

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

    /**
     * *******************************************************************
     */
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        Iterator it = cashedTable.iterator();
        while (it.hasNext()) {
            wbo = (WebBusinessObject) it.next();

            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        return null;
    }

//    protected WebBusinessObject fabricateBusObj(Row r) {
//
//        ListIterator li = supportedForm.getFormElemnts().listIterator();
//        FormElement fe = null;
//        Hashtable ht = new Hashtable();
//        String colName;
//        String state = null;
//        String issueOwnerId = null;
//
//        while (li.hasNext()) {
//
//            try {
//                fe = (FormElement) li.next();
//                colName = (String) fe.getAttribute("column");
//                // needs a case ......
//                ht.put(fe.getAttribute("name"), r.getString(colName));
//            } catch (Exception e) {
//                // raise an exception
//            }
//        }
//
//        WebIssue webIssue = new WebIssue(ht);
//        // fish for status
//        state = (String) webIssue.getAttribute("currentStatus");
//        if (state == null) {
//            webIssue.setAttribute("currentStatus", "Finished");
//            state = "Finished";
//        }
//        issueOwnerId = (String) webIssue.getAttribute("assignedToId");
//        webIssue.setIssueStateObject(webIssue);
//        String userid = (String) currentUser.getAttribute("userId");
//
//        webIssue.setWebUser(currentUser);
//        webIssue.setViewrsIds(issueOwnerId, (String) currentUser.getAttribute("userId"));
//
//        WebBusinessObject bm = bookmarkMgr.getBookmark((String) webIssue.getAttribute("id"), currentUser);
//        webIssue.setBookmark(bm);
//
//        //BB New
//        String sDate = null;
//        long lDeviation = 0;
//        sDate = (String) webIssue.getAttribute("expectedEndDate");
//        DateServices dt = new DateServices();
//        lDeviation = dt.convertMySQLDate("2010-12-31") - dt.convertMySQLDate(sDate);
//        String sCurrStatus = (String) webIssue.getAttribute("currentStatus");
//        if ((!(sCurrStatus.equalsIgnoreCase("Resolved") || sCurrStatus.equalsIgnoreCase("Finished")) && lDeviation > 0)) {
//            webIssue.setAttribute("isDelayed", "true");
//        } else {
//            webIssue.setAttribute("isDelayed", "false");
//        }
//        return (WebBusinessObject) webIssue;
//    }
    public Vector getIssueList(String issueStatus, WebBusinessObject user) {

        // centralView = new String(AppConstants.LIST_USER_ASSIGNED);
        centralView = AppConstants.getMatchingView(issueStatus);

        WebBusinessObject wbo = null;
        Connection connection = null;

//        StringBuffer query = new StringBuffer("SELECT * FROM ");
//        query.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ASSIGNED_TO_ID = ? AND CURRENT_STATUS = ?");
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue((String) user.getAttribute("userId")));
        SQLparams.addElement(new StringValue(issueStatus));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            if (issueStatus.equalsIgnoreCase("SCHEDULE")) {
                return getSearchOnStatus(issueStatus);
            }

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueByWorker").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public Vector getAllIssues() {

        WebBusinessObject issue = null;
        // centralView = new String(AppConstants.LIST_ALL);

        viewOrigin = new WebBusinessObject();
        viewOrigin.setAttribute("filter", "ListAll");
        viewOrigin.setAttribute("filterValue", "ALL");
        //

        Vector conditionedData = new Vector();

        Vector data = null;
        try {
            data = super.getAllTableRaws();

            Enumeration issueEnum = data.elements();

            while (issueEnum.hasMoreElements()) {
                issue = (WebBusinessObject) issueEnum.nextElement();
                issue.setViewOrigin(viewOrigin);
                conditionedData.addElement(issue);
            }

        } catch (SQLException sqlEx) {
            logger.error("Unable to get All table rows");

        } catch (Exception ex) {
        } finally {
        }
        return conditionedData;
    }

    public Vector getSearchOnStatus(String status) {

        centralView = new String(AppConstants.LIST_SCHEDULE);
        try {
            return super.getSearchOnStatus(status);
        } catch (SQLException seqlEx) {
            ;
        } catch (Exception ex) {
            ;
        }
        return null;
    }

    private boolean executeQuery(String query, Vector p) throws SQLException {
        int queryResult = -1000;
        Vector params = p;

        try {
            forInsert.setSQLQuery(query);

            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (Exception ex) {
            logger.error("Save Assigned Issue Exception : " + ex.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public Vector getIssuesInRange(String filterName, String filterValue) throws Exception, SQLException {

        QueryMgrFactory qMgrFactory = QueryMgrFactory.getInstance();

        IQueryMgr queryMgr = qMgrFactory.getQueryMgr(filterValue);

        Vector SQLparams = null;
//        SQLparams.addElement(new DateValue(d1));
//        SQLparams.addElement(new DateValue(d2));

        SQLparams = queryMgr.getQueryVectorParam(filterValue);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            //forQuery.setSQLQuery(docsInRangeSQL);
            forQuery.setSQLQuery(queryMgr.getQuery(filterName, ""));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception" + ex.getMessage());
            throw ex;
        } catch (UnsupportedTypeException uste) {
            logger.error("UnspportedTypeException " + uste.getMessage());
        } catch (Exception ex) {
            logger.error("UNKNOWN Exception" + ex.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {

            r = (Row) e.nextElement();
            //  wbo = fabricateBusObj(r);

            webIssue = (WebIssue) fabricateBusObj(r);
            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);

            reultBusObjs.add(webIssue);
        }

        return reultBusObjs;
    }

    public Vector getStatisticsForProject(String sProjectName) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(sProjectName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueVar").trim());
//            queryResult = forQuery.executeQuery();
            if (sProjectName.equalsIgnoreCase("All")) {
                forQuery.setSQLQuery(sqlMgr.getSql("selectIssueAllTotal").trim());
            } else {
                forQuery.setSQLQuery(sqlMgr.getSql("selectIssueTotal").trim());
                forQuery.setparams(SQLparams);
            }
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("currentStatus", r.getString("CURRENT_STATUS"));
                wbo.setAttribute("total", r.getString("TOTAL"));
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public Vector getHoursForProject(String sProjectName, HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Timestamp beginDate = dropdownDate.getDate(request.getParameter("beginDate"));
//        java.sql.Timestamp endDate = dropdownDate.getDate(request.getParameter("endDate"));

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Timestamp beginDate = new java.sql.Timestamp(sqlDate.getTime());

        sqlDate = dateParser.formatSqlDate(request.getParameter("endDate"));
        java.sql.Timestamp endDate = new java.sql.Timestamp(sqlDate.getTime());

        if (!sProjectName.equalsIgnoreCase("ALL")) {
            SQLparams.addElement(new StringValue(sProjectName));
        }
        SQLparams.addElement(new TimestampValue(beginDate));
        SQLparams.addElement(new TimestampValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (sProjectName.equals("ALL")) {
                forQuery.setSQLQuery(sqlMgr.getSql("selectIssueAllHours").trim());
            } else {
                forQuery.setSQLQuery(sqlMgr.getSql("selectIssueHours").trim());
            }
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                wbo.setAttribute("assignedToName", r.getString("ASSIGNED_TO_NAME"));
                wbo.setAttribute("total", r.getString("TOTAL"));
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public Vector getRiskForProject(String filterName, String filterValue) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(filterName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueRisk").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
            wbo = (WebIssue) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getProjectByWorker(String userId, String ProjectName, String filterValue) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

//        SQLparams.addElement(new StringValue(userID));
        SQLparams.addElement(new StringValue(userId));
        SQLparams.addElement(new StringValue(ProjectName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueProjectByWorker").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
            wbo = (WebIssue) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getIssuePerProjectWithMaintenance(String funId, String ProjectName) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(funId));
        SQLparams.addElement(new StringValue(ProjectName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueProjectByMaintenance").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
            wbo = (WebIssue) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getStatusForProject(String filterValue) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(filterValue.substring(filterValue.indexOf(">") + 1)));
        Long lTemp = new Long(filterValue.substring(0, filterValue.indexOf(":")));
        java.sql.Date dTemp = new java.sql.Date(lTemp.longValue());
        SQLparams.addElement(new DateValue(dTemp));
        lTemp = new Long(filterValue.substring(filterValue.indexOf(":") + 1, filterValue.indexOf(">")));
        dTemp = new java.sql.Date(lTemp.longValue());
        SQLparams.addElement(new DateValue(dTemp));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueStatusForProject").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        java.sql.Date dEndDate = new java.sql.Date(100000);
        java.sql.Date dToday = null;
        String sEndDate = null;
        Calendar c = Calendar.getInstance();
        //long dTemp = c.getTimeInMillis();
        dToday = new java.sql.Date(c.getTimeInMillis());
        //dToday.setTime();

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("issueTitle", r.getString("ISSUE_TITLE"));
                wbo.setAttribute("expectedBeginDate", r.getString("EXPECTED_B_DATE"));
                sEndDate = r.getString("EXPECTED_E_DATE");
                dEndDate = dToday.valueOf(sEndDate);
                dEndDate.compareTo(dToday);
                wbo.setAttribute("expectedEndDate", r.getString("EXPECTED_E_DATE"));
                wbo.setAttribute("currentStatus", r.getString("CURRENT_STATUS"));
                if (r.getString("ASSIGNED_TO_NAME").equalsIgnoreCase("UL")) {
                    wbo.setAttribute("assignedToName", "---");
                } else {
                    wbo.setAttribute("assignedToName", r.getString("ASSIGNED_TO_NAME"));
                }
                if (r.getString("CURRENT_STATUS").equalsIgnoreCase("Finished")) {
                    wbo.setAttribute("color", "#66FFFF");
                } else if (dEndDate.compareTo(dToday) < 0) {
                    wbo.setAttribute("color", "#FFCCCC");
                } else {
                    wbo.setAttribute("color", "white");
                }
                wbo.setAttribute("assignedByName", r.getString("ASSIGNED_BY_NAME"));
                wbo.setAttribute("actualFinishTime", r.getString("ACTUAL_FINISH_TIME"));

                wbo.setAttribute("id", r.getString("ID"));
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public Vector getStatusForProjectWorker(String workerID, String filterValue) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(filterValue.substring(filterValue.indexOf(">") + 1)));
        SQLparams.addElement(new StringValue(workerID));
        Long lTemp = new Long(filterValue.substring(0, filterValue.indexOf(":")));
        java.sql.Date dTemp = new java.sql.Date(lTemp.longValue());
        SQLparams.addElement(new DateValue(dTemp));
        lTemp = new Long(filterValue.substring(filterValue.indexOf(":") + 1, filterValue.indexOf(">")));
        dTemp = new java.sql.Date(lTemp.longValue());
        SQLparams.addElement(new DateValue(dTemp));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueProjectWorkerStatus").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        java.sql.Date dEndDate = new java.sql.Date(100000);
        java.sql.Date dToday = null;
        String sEndDate = null;
        Calendar c = Calendar.getInstance();
        //long dTemp = c.getTimeInMillis();
        dToday = new java.sql.Date(c.getTimeInMillis());
        //dToday.setTime();

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("faId", r.getString("FA_ID"));
                wbo.setAttribute("issueTitle", r.getString("ISSUE_TITLE"));
                wbo.setAttribute("expectedBeginDate", r.getString("EXPECTED_B_DATE"));
                sEndDate = r.getString("EXPECTED_E_DATE");
                dEndDate = dToday.valueOf(sEndDate);
                dEndDate.compareTo(dToday);
                wbo.setAttribute("expectedEndDate", r.getString("EXPECTED_E_DATE"));
                wbo.setAttribute("currentStatus", r.getString("CURRENT_STATUS"));
                if (r.getString("ASSIGNED_TO_NAME").equalsIgnoreCase("UL")) {
                    wbo.setAttribute("assignedToName", "---");
                } else {
                    wbo.setAttribute("assignedToName", r.getString("ASSIGNED_TO_NAME"));
                }
                if (r.getString("CURRENT_STATUS").equalsIgnoreCase("Finished")) {
                    wbo.setAttribute("color", "#66FFFF");
                } else if (dEndDate.compareTo(dToday) < 0) {
                    wbo.setAttribute("color", "#FFCCCC");
                } else {
                    wbo.setAttribute("color", "white");
                }
                wbo.setAttribute("assignedByName", r.getString("ASSIGNED_BY_NAME"));
                wbo.setAttribute("actualFinishTime", r.getString("ACTUAL_FINISH_TIME"));

                wbo.setAttribute("id", r.getString("ID"));
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public Vector getSearchByTitle(String sSearch, HttpSession s) {
        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();

        Vector SQLparams = new Vector();
        Connection connection = null;
//        StringBuffer query = new StringBuffer("SELECT * FROM issue WHERE ISSUE_TITLE LIKE '%");
//        query.append(sSearch);
//        query.append("%'");
        SQLparams.addElement(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueSearchByTitle").trim().replace("$", sSearch));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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

    public Vector getSearchByNote(String sSearch, HttpSession s) {
        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        Vector SQLparams = new Vector();
        Connection connection = null;
        SQLparams.addElement(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueSearchByNote").trim().replace("$", sSearch));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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

    public Vector getSearchByShift(String shift, HttpSession s) {
        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        Vector SQLparams = new Vector();
        Connection connection = null;
        SQLparams.addElement(new StringValue(shift));
        SQLparams.addElement(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSearchByShift"));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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

    public Vector getSearchByDepartment(String department, HttpSession s, String beginDate, String endDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        Vector SQLparams = new Vector();
        Connection connection = null;
        SQLparams.addElement(new StringValue(department));
        SQLparams.addElement(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        try {
            java.util.Date dateBeg = sdf.parse(beginDate);
            java.util.Date dateEnd = sdf.parse(endDate);
            java.sql.Date beginDatesql = new java.sql.Date(dateBeg.getTime());
            java.sql.Date endDatesql = new java.sql.Date(dateEnd.getTime());
            SQLparams.addElement(new DateValue(beginDatesql));
            SQLparams.addElement(new DateValue(endDatesql));
        } catch (Exception e) {
        }
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSearchByDepartment"));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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

    public int hasData(String fieldName, String fieldValue) throws NoUserInSessionException {
//        StringBuffer query = new StringBuffer("SELECT * FROM ");
//        query.append(supportedForm.getTableSupported().getAttribute("name"));
//        query.append(" WHERE " + fieldName);
//        query.append(" = ?");

        Vector params = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector queryResult = new Vector();

        params.addElement(new StringValue(fieldValue));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("selectIssueHasData").trim().replace("$", fieldName));
            forSelect.setparams(params);
            queryResult = forSelect.executeQuery();

            cashData();
        } catch (SQLException ex) {
            logger.error("Exception selecting data: " + ex.getMessage());
            return 0;
        } catch (UnsupportedTypeException us) {
            logger.error("Exception : " + us.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return 0;
            }
        }

        return (queryResult.size());
    }

    public String getUnitName(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String unitName = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUnitSchedule").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                unitName = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

    public String getScheduleUnitId(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String scheduleunitId = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueUnitSchedule").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                scheduleunitId = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return scheduleunitId;

    }

    public String getMaintenanceTitle(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String mainTitle = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUnitScheduleMaintenance").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                mainTitle = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return mainTitle;

    }

    public String getConfigure(String scheduleunitId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(scheduleunitId));

        Connection connection = null;
        String configure = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUnitScheduleConfigure").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                configure = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return configure;

    }

    public String getCreateBy(String createdBy) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(createdBy));

        Connection connection = null;
        String creatby = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueUser").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                creatby = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return creatby;

    }

    public String getUnitId(String unitname) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitname));

        Connection connection = null;
        String unitId = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueMaintainableUnit").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                unitId = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return unitId;

    }

    public String getScheduleId(String scheduletitle) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(scheduletitle));

        Connection connection = null;
        String scheduleId = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueScheduleMaintenance").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                scheduleId = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return scheduleId;

    }

    public void updateTotalCost(String unitScheduleID, float totalCost) {
        Vector issueParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();

        issueParams.addElement(new FloatValue(new Float(totalCost).floatValue()));
        issueParams.addElement(new StringValue(unitScheduleID));//Total Time
        Connection connection = null;

        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateIssueTotalCost").trim());
            forUpdate.setparams(issueParams);
            int queryResult = forUpdate.executeUpdate();
        } catch (SQLException sex) {
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }

    public void updateActualCost(String issueID, float actualCost) {
        Vector issueParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();

        issueParams.addElement(new FloatValue(new Float(actualCost).floatValue()));
        issueParams.addElement(new StringValue(issueID));//Total Time
        Connection connection = null;

        try {
            connection = dataSource.getConnection();
//            beginTransaction();
//            executeQuery(updateActualCostSQL,issueParams);
//
//
//            endTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateIssueActualCost").trim());
            forUpdate.setparams(issueParams);
            int queryResult = forUpdate.executeUpdate();
        } catch (SQLException sex) {
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }

    public void updateConfigureValue(String scheduleunitId) {
        Vector unitscheduleParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();

        unitscheduleParams.addElement(new StringValue(scheduleunitId));//Total Time
        Connection connection = null;

        try {
            connection = dataSource.getConnection();
//            beginTransaction();
//            executeQuery(updateActualCostSQL,issueParams);
//
//
//            endTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateIssueUnitSchedule").trim());
            forUpdate.setparams(unitscheduleParams);
            int queryResult = forUpdate.executeUpdate();
        } catch (SQLException sex) {
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }

    public String getScheduleUnitID() {
        return ScheduleUnitId;
    }

    public String getIssueID() {
        return issueId;
    }

    public String getSID() {
        return sID;
    }

    public Vector getIssuesListInRange(java.sql.Date beginDate, java.sql.Date endDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
//        StringBuffer query = new StringBuffer("SELECT * FROM issue WHERE EXPECTED_B_DATE BETWEEN ? AND ?");

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueInRange").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
        viewOrigin = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            webIssue = (WebIssue) fabricateBusObj(r);
//            webIssue.setViewOrigin(wbo);
            resultBusObjs.add(webIssue);
        }
        return resultBusObjs;
    }

    public Vector getIssuesListInRangeByEmg(java.sql.Date beginDate, java.sql.Date endDate, HttpSession s) {
        FilterQuery filterQuery = new FilterQuery();
        SecurityUser securityUser = new SecurityUser();
        securityUser = (SecurityUser) s.getAttribute("securityUser");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        String queryFilter = null;
        if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
            queryFilter = filterQuery.getJobOrderQuery(securityUser.getSearchBy());
        }
        String site = securityUser.getSiteId();
        UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
        String projs = null;
        try {

            String[] userProjs = userProjectsMgr.getProjectsIdForUser(userId);
            projs = Tools.concatenation(userProjs, ",");
        } catch (Exception ex) {
        }
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
//        StringBuffer query = new StringBuffer("SELECT * FROM issue WHERE EXPECTED_B_DATE BETWEEN ? AND ?");

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        //SQLparams.addElement(new StringValue(site));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (queryFilter != null && !queryFilter.equals("")) {
                forQuery.setSQLQuery(sqlMgr.getSql("getIssuesListInRangeByEmg").trim().concat(queryFilter).replaceAll("projs", projs).concat(" order by id desc"));
            } else {

                forQuery.setSQLQuery(sqlMgr.getSql("getIssuesListInRangeByEmg").trim().replaceAll("projs", projs).concat(" order by id desc"));
            }

            if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
                if (securityUser.getSearchBy().equals("byTradeAndSite")) {
                    SQLparams.addElement(new StringValue(userId));
                    SQLparams.addElement(new StringValue(userId));
                } else {
                    SQLparams.addElement(new StringValue(userId));
                }
            }

            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
        viewOrigin = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            webIssue = (WebIssue) fabricateBusObj(r);
//            webIssue.setViewOrigin(wbo);
            resultBusObjs.add(webIssue);
        }
        return resultBusObjs;
    }

    public Vector getIssuesListInRangeBySch(java.sql.Date beginDate, java.sql.Date endDate, HttpSession s) {
        FilterQuery filterQuery = new FilterQuery();
        SecurityUser securityUser = new SecurityUser();
        securityUser = (SecurityUser) s.getAttribute("securityUser");
        String queryFilter = null;
        if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
            queryFilter = filterQuery.getJobOrderQuery(securityUser.getSearchBy());
        }
        String site = securityUser.getSiteId();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
//        StringBuffer query = new StringBuffer("SELECT * FROM issue WHERE EXPECTED_B_DATE BETWEEN ? AND ?");

        UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
        String projs = null;
        try {

            String[] userProjs = userProjectsMgr.getProjectsIdForUser(userId);
            projs = Tools.concatenation(userProjs, ",");
        } catch (Exception ex) {
        }
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        //SQLparams.addElement(new StringValue(site));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (queryFilter != null && !queryFilter.equals("")) {
                forQuery.setSQLQuery(sqlMgr.getSql("getIssuesListInRangeBySch").trim().concat(queryFilter).replaceAll("projs", projs).concat(" order by id desc"));
            } else {
                forQuery.setSQLQuery(sqlMgr.getSql("getIssuesListInRangeBySch").trim().replaceAll("projs", projs).concat(" order by id desc"));
            }
            if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
                if (securityUser.getSearchBy().equals("byTradeAndSite")) {
                    SQLparams.addElement(new StringValue(userId));
                    SQLparams.addElement(new StringValue(userId));
                } else {
                    SQLparams.addElement(new StringValue(userId));
                }
            }
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
        viewOrigin = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            webIssue = (WebIssue) fabricateBusObj(r);
//            webIssue.setViewOrigin(wbo);
            resultBusObjs.add(webIssue);
        }
        return resultBusObjs;
    }

    public String getTechName(String techId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(techId));

        Connection connection = null;
        String techName = new String("");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectTechName").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                techName = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return techName;

    }

    public String getFailureCode(String id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));

        Connection connection = null;
        String failuretitle = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectFailureTitle").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                failuretitle = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return failuretitle;

    }

    public String getUrgencyLevel(String id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));

        Connection connection = null;
        String UrgencyLevel = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUrgencyLevel").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                UrgencyLevel = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return UrgencyLevel;

    }

    public String getSiteName(String id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));

        Connection connection = null;
        String SiteName = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectSiteName").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                SiteName = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return SiteName;

    }

    public boolean getActiveUnit(String unitID) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(unitID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveUnit").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public boolean saveHourlySchedule(WebBusinessObject schedule, WebBusinessObject average, HttpSession s, String siteName) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject configureWbo = new WebBusinessObject();

        Vector issueStatusParams = new Vector();
        Vector unitScheduleParams = new Vector();
        Vector params = new Vector();
        Vector itemConfig = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        //B New
        int queryResult1 = -1000;
        float totalCost = 0;
        float updateTotalCost = 0;

        //E New
//        String pname =(String) wbo.getAttribute("project_name");
//        String TotalCost=request.getParameter("totalCost");
//        String UnitName=request.getParameter("unitName");
//        String ScheduleTitle=request.getParameter("maintenanceTitle");
//        int estDuration = new Integer (request.getParameter("estimatedduration").toString()).intValue();
        // String issueId = null;
//        String ScheduleUnitId = null;
        String unitName = null;
        String ScheduleId = null;
        unitName = issueMgr.getEquipName(average.getAttribute("unitName").toString());

//        ScheduleId=issueMgr.getScheduleId(ScheduleTitle);
        ScheduleUnitId = UniqueIDGen.getNextID().toString();

        // Coder Ussed ///
        StringValue sIssueID = new StringValue(UniqueIDGen.getNextID());
        params.addElement(sIssueID);
        params.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        params.addElement(new StringValue(siteName));
        params.addElement(new StringValue(unitName));
//        params.addElement(new StringValue((String)schedule.getAttribute("maintenanceTitle")));
//        params.addElement(new StringValue(issue.getFAID()));
//        params.addElement(new StringValue(issue.getIssueID()));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//        params.addElement(new StringValue(urgencyId));
//        params.addElement(new StringValue(issue.getIssueDesc()));
//        params.addElement(new StringValue(request.getParameter("receivedby")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//        params.addElement(new StringValue(request.getParameter("workTrade")));
        params.addElement(new StringValue((String) schedule.getAttribute("workTrade")));
        params.addElement(new StringValue((String) schedule.getAttribute("duration")));
//        params.addElement(new IntValue(estDuration));
//        params.addElement(new StringValue(request.getParameter("failurecode")));

        /// End Coder Used ///
//        params.addElement(new StringValue(issue.getDocBaseUrl()));
//        params.addElement(new StringValue(issue.getDocRefId()));
//        params.addElement(new StringValue((String)request.getParameter("docBaseUrl")));
//        params.addElement(new StringValue((String)request.getParameter("docRefId")));
        // Coder Used ///
//        params.addElement(new TimestampValue(beginDate));
//        params.addElement(new TimestampValue(endDate));
//        params.addElement(new StringValue(TotalCost));
        params.addElement(new StringValue(ScheduleUnitId));
        Long iID = new Long(sIssueID.getString());
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(iID.longValue());
        String sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
        //
        params.addElement(new StringValue(sID));
        params.addElement(new StringValue(average.getAttribute("unitName").toString()));
        issueId = sIssueID.getString();
//        request.setAttribute("issueId",issueId);

        /// End Coder Used  ///
//        params.addElement(new StringValue((String)request.getParameter("auditor")));
//        params.addElement(new StringValue((String)request.getParameter("auditee")));
//        params.addElement(new TimestampValue(auditDate));
//        params.addElement(new TimestampValue(reportDate));
        //B New
        /**
         * *** Get Virtual end date for first status ******
         */
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        /// Coder Used  //
        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_SCHEDULE));
        issueStatusParams.addElement(sIssueID);
        issueStatusParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        issueStatusParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));

        //// End Coder Used ///
        //E New
        //B New
//        unitScheduleParams.addElement(sIssueID);
        ///Coder Used ///
        unitScheduleParams.addElement(new StringValue(ScheduleUnitId));
        unitScheduleParams.addElement(new StringValue((String) average.getAttribute("unitName")));
        unitScheduleParams.addElement(new StringValue(unitName));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("periodicID")));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
//        unitScheduleParams.addElement(new TimestampValue(beginDate));
//        unitScheduleParams.addElement(new TimestampValue(endDate));
        //// End Coder Used ///

//        for(int x = 0; x < confgure.size(); x++){
//
////          unitScheduleId = issueMgr.getScheduleUnitID();
//          configureWbo = (WebBusinessObject) confgure.elementAt(x);
//          saveQuantifiedItem(configureWbo,ScheduleUnitId);
//
//        }
        //E New
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueUnitSchedule").trim());
            forInsert.setparams(unitScheduleParams);
            queryResult1 = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyScheduleIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //Thread.sleep(200);
            //B New
//            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueStatus").trim());
            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueStatusVEDate").trim());
            forInsert.setparams(issueStatusParams);
            queryResult1 = forInsert.executeUpdate();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            return false;
        } //catch(InterruptedException e){
        //    }
        finally {
            try {
                connection.close();
                try {

                    /// new //
                    itemConfig = configureMainTypeMgr.getOnArbitraryKey(schedule.getAttribute("periodicID").toString(), "key1");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                for (int x = 0; x < itemConfig.size(); x++) {

                    configureWbo = (WebBusinessObject) itemConfig.elementAt(x);
                    totalCost = new Float(configureWbo.getAttribute("totalCost").toString()).floatValue();
//          totalCost =  costTemp.intValue();
                    updateTotalCost = totalCost + updateTotalCost;
                    saveQuantifiedItem(configureWbo, ScheduleUnitId);

                }
                updateTotalCost(updateTotalCost, ScheduleUnitId);

                //End //
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }

    public String saveInUnitSchedule(WebBusinessObject schedule, WebBusinessObject average, HttpSession s, String siteName) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject configureWbo = new WebBusinessObject();

        Vector issueStatusParams = new Vector();
        Vector unitScheduleParams = new Vector();
        Vector params = new Vector();
        Vector itemConfig = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        //B New
        int queryResult1 = -1000;
        float totalCost = 0;
        float updateTotalCost = 0;

        String unitName = null;
        String ScheduleId = null;
        unitName = issueMgr.getEquipName(average.getAttribute("unitName").toString());

        ScheduleUnitId = UniqueIDGen.getNextID().toString();
        unitScheduleParams.addElement(new StringValue(ScheduleUnitId));
        unitScheduleParams.addElement(new StringValue((String) average.getAttribute("unitName")));
        unitScheduleParams.addElement(new StringValue(unitName));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("periodicID")));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueUnitSchedule").trim());
            forInsert.setparams(unitScheduleParams);
            queryResult = forInsert.executeUpdate();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } //catch(InterruptedException e){
        //    }
        finally {
            try {
                connection.close();
                try {

                    /// new //
                    itemConfig = configureMainTypeMgr.getOnArbitraryKey(schedule.getAttribute("periodicID").toString(), "key1");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                for (int x = 0; x < itemConfig.size(); x++) {

                    configureWbo = (WebBusinessObject) itemConfig.elementAt(x);
                    totalCost = new Float(configureWbo.getAttribute("totalCost").toString()).floatValue();
//          totalCost =  costTemp.intValue();
                    updateTotalCost = totalCost + updateTotalCost;
                    saveQuantifiedItem(configureWbo, ScheduleUnitId);

                }
                updateTotalCost(updateTotalCost, ScheduleUnitId);

                //End //
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        String saveStatus = "saveFail";
        if (queryResult > 0) {
            return ScheduleUnitId;
        } else {
            return saveStatus;
        }

    }

    public String saveInUnitSchedule(WebBusinessObject schedule) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject configureWbo = new WebBusinessObject();

        Vector issueStatusParams = new Vector();
        Vector unitScheduleParams = new Vector();
        Vector params = new Vector();
        Vector itemConfig = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        //B New
        int queryResult1 = -1000;
        float totalCost = 0;
        float updateTotalCost = 0;

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-mm-dd");
        java.sql.Date beginScheduleDate = null;
        java.sql.Date endScheduleDate = null;
        try {
            beginScheduleDate = new java.sql.Date(formatter.parse(schedule.getAttribute("beginDate").toString()).getTime());
            endScheduleDate = new java.sql.Date(formatter.parse(schedule.getAttribute("endDate").toString()).getTime());
        } catch (ParseException ex) {
            ex.printStackTrace();
        }

        String unitName = null;
        String ScheduleId = null;
        // unitName = issueMgr.getEquipName(average.getAttribute("unitName").toString());

        ScheduleUnitId = UniqueIDGen.getNextID();
        unitScheduleParams.addElement(new StringValue(ScheduleUnitId));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("unitId")));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("unitName")));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("periodicId")));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        unitScheduleParams.addElement(new DateValue(beginScheduleDate));
        unitScheduleParams.addElement(new DateValue(endScheduleDate));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("insertUnitSchedule").trim());
            forInsert.setparams(unitScheduleParams);
            queryResult = forInsert.executeUpdate();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } //catch(InterruptedException e){
        //    }
        finally {
            try {
                connection.close();
                try {

                    /// new //
                    itemConfig = configureMainTypeMgr.getOnArbitraryKey(schedule.getAttribute("periodicId").toString(), "key1");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                for (int x = 0; x < itemConfig.size(); x++) {

                    configureWbo = (WebBusinessObject) itemConfig.elementAt(x);
                    totalCost = new Float(configureWbo.getAttribute("totalCost").toString()).floatValue();
//          totalCost =  costTemp.intValue();
                    updateTotalCost = totalCost + updateTotalCost;
                    saveQuantifiedItem(configureWbo, ScheduleUnitId);

                }
                updateTotalCost(updateTotalCost, ScheduleUnitId);

                //End //
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        String saveStatus = "saveFail";
        if (queryResult > 0) {
            return ScheduleUnitId;
        } else {
            return saveStatus;
        }

    }

    public boolean saveKilSchedule(WebBusinessObject schedule, String unitId, HttpSession s, String siteName) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject configureWbo = new WebBusinessObject();

        Vector issueStatusParams = new Vector();
        Vector unitScheduleParams = new Vector();
        Vector params = new Vector();
        Vector itemConfig = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        //B New
        int queryResult1 = -1000;
        float totalCost = 0;
        float updateTotalCost = 0;

        String unitName = null;
        String ScheduleId = null;
        unitName = issueMgr.getEquipName(unitId);

//        ScheduleId=issueMgr.getScheduleId(ScheduleTitle);
        ScheduleUnitId = UniqueIDGen.getNextID().toString();

        StringValue sIssueID = new StringValue(UniqueIDGen.getNextID());
        params.addElement(sIssueID);
        params.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        params.addElement(new StringValue(siteName));
        params.addElement(new StringValue(unitName));
//        params.addElement(new StringValue((String)schedule.getAttribute("maintenanceTitle")));
//        params.addElement(new StringValue(issue.getFAID()));
//        params.addElement(new StringValue(issue.getIssueID()));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//        params.addElement(new StringValue(urgencyId));
//        params.addElement(new StringValue(issue.getIssueDesc()));
//        params.addElement(new StringValue(request.getParameter("receivedby")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//        params.addElement(new StringValue(request.getParameter("workTrade")));
        params.addElement(new StringValue((String) schedule.getAttribute("workTrade")));
        params.addElement(new StringValue((String) schedule.getAttribute("duration")));

        params.addElement(new StringValue(ScheduleUnitId));
        Long iID = new Long(sIssueID.getString());
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(iID.longValue());
        String sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
        //
        params.addElement(new StringValue(sID));
        issueId = sIssueID.getString();

        /**
         * *** Get Virtual end date for first status ******
         */
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_SCHEDULE));
        issueStatusParams.addElement(sIssueID);
        issueStatusParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        issueStatusParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));

        unitScheduleParams.addElement(new StringValue(ScheduleUnitId));
        unitScheduleParams.addElement(new StringValue(unitId));
        unitScheduleParams.addElement(new StringValue(unitName));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("periodicID")));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));

        Connection connection = null;
        try {
//            connection = dataSource.getConnection();
//            forInsert.setConnection(connection);
//            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueUnitSchedule").trim());
//            forInsert.setparams(unitScheduleParams);
//            queryResult1 = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyScheduleIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
//            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueStatus").trim());
            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueStatusVEDate").trim());
            forInsert.setparams(issueStatusParams);
            queryResult1 = forInsert.executeUpdate();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            return false;
        } //catch(InterruptedException e){
        //    }
        finally {
            try {
                connection.close();
                try {

                    /// new //
                    itemConfig = configureMainTypeMgr.getOnArbitraryKey(schedule.getAttribute("periodicID").toString(), "key1");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                for (int x = 0; x < itemConfig.size(); x++) {

                    configureWbo = (WebBusinessObject) itemConfig.elementAt(x);
                    totalCost = new Float(configureWbo.getAttribute("totalCost").toString()).floatValue();
//          totalCost =  costTemp.intValue();
                    updateTotalCost = totalCost + updateTotalCost;
                    saveQuantifiedItem(configureWbo, ScheduleUnitId);

                }
                updateTotalCost(updateTotalCost, ScheduleUnitId);

                //End //
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }

    /*//////////////////Ibrahim////////////////////*/
    public String saveKilSchedule2(WebBusinessObject schedule, String unitId, HttpSession s, String siteName, String scheduleId) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject configureWbo = new WebBusinessObject();

        Vector issueStatusParams = new Vector();
        Vector unitScheduleParams = new Vector();
        Vector params = new Vector();
        Vector itemConfig = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        //B New
        int queryResult1 = -1000;
        float totalCost = 0;
        float updateTotalCost = 0;

        String unitName = null;
        unitName = issueMgr.getEquipName(unitId);
        String idGen = UniqueIDGen.getNextID();
        StringValue sIssueID = new StringValue(idGen);
        params.addElement(sIssueID);
        params.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        params.addElement(new StringValue(siteName));
        params.addElement(new StringValue(unitName));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) schedule.getAttribute("workTrade")));
        params.addElement(new StringValue((String) schedule.getAttribute("duration")));

        params.addElement(new StringValue(scheduleId));
        Long iID = new Long(sIssueID.getString());
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(iID.longValue());
        String sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
        //
        params.addElement(new StringValue(sID));
        params.addElement(new StringValue(unitId));
        issueId = sIssueID.getString();

        /**
         * *** Get Virtual end date for first status ******
         */
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_SCHEDULE));
        issueStatusParams.addElement(sIssueID);
        issueStatusParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        issueStatusParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyScheduleIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
//            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueStatus").trim());
            forInsert.setSQLQuery(sqlMgr.getSql("insertHourlyIssueStatusVEDate").trim());
            forInsert.setparams(issueStatusParams);
            queryResult1 = forInsert.executeUpdate();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            return "saveFail";
//        } catch(InterruptedException e){
        } finally {
            try {
                connection.close();
                try {

                    /// new //
                    itemConfig = configureMainTypeMgr.getOnArbitraryKey(schedule.getAttribute("id").toString(), "key1");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                for (int x = 0; x < itemConfig.size(); x++) {

                    configureWbo = (WebBusinessObject) itemConfig.elementAt(x);
                    totalCost = new Float(configureWbo.getAttribute("totalCost").toString()).floatValue();
//          totalCost =  costTemp.intValue();
                    updateTotalCost = totalCost + updateTotalCost;
                    saveQuantifiedItem(configureWbo, schedule.getAttribute("id").toString());

                }
                updateTotalCost(updateTotalCost, schedule.getAttribute("id").toString());

                //End //
            } catch (SQLException ex) {
                logger.error("Close Error");
                return "saveFail";
            }
        }
        if (queryResult > 0) {
            return idGen;
        } else {
            return "saveFail";
        }
    }

    /**
     * **********************************************
     */
    public String getNumberSchedule(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));

        Connection connection = null;
        String total = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getNumberSchedule").trim());

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

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

    public String getEquipName(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String unitName = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEquipName").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                unitName = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

    public boolean saveQuantifiedItem(WebBusinessObject configire, String unitScheduleId) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        int queryResult1 = -1000;

        StringValue sQID = new StringValue(UniqueIDGen.getNextID());
        params.addElement(sQID);
        params.addElement(new StringValue(unitScheduleId));
        params.addElement(new StringValue((String) configire.getAttribute("itemId")));
        params.addElement(new StringValue((String) configire.getAttribute("itemQuantity")));
        params.addElement(new StringValue((String) configire.getAttribute("itemPrice")));
        params.addElement(new StringValue((String) configire.getAttribute("totalCost")));
        params.addElement(new StringValue((String) configire.getAttribute("note")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("insertConfigureSchedule").trim());
            forInsert.setparams(params);
            queryResult1 = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
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

    public boolean updateTotalCost(float totalCost, String unitScheduleId) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        int queryResult1 = -1000;

        params.addElement(new FloatValue(totalCost));
        params.addElement(new StringValue(unitScheduleId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("updateTotalCost").trim());
            forInsert.setparams(params);
            queryResult1 = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
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

    public boolean updateJobDate(HttpServletRequest request) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        Vector params = new Vector();
        Vector changeDateParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        int queryResult2 = -1000;

//        java.sql.Timestamp beginDate = dropdownDate.getDate(request.getParameter("beginDate"));//super.extractFromDateFromRequest();
//        java.sql.Timestamp endDate = dropdownDate.getDate(request.getParameter("endDate"));//super.extractToDateFromRequest();
        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Timestamp beginDate = new java.sql.Timestamp(sqlDate.getTime());

        sqlDate = dateParser.formatSqlDate(request.getParameter("endDate"));
        java.sql.Timestamp endDate = new java.sql.Timestamp(sqlDate.getTime());

        params.addElement(new TimestampValue(beginDate));
        params.addElement(new TimestampValue(endDate));
        StringValue sIssueID = new StringValue((String) request.getParameter("issueId"));
        params.addElement(sIssueID);

        changeDateParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        changeDateParams.addElement(new StringValue(request.getParameter("issueId")));
        changeDateParams.addElement(new TimestampValue(beginDate));
        changeDateParams.addElement(new TimestampValue(endDate));
        changeDateParams.addElement(new StringValue(request.getParameter("reason")));
        changeDateParams.addElement(new StringValue((String) waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateJobIssueDate").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            forUpdate.setSQLQuery(sqlMgr.getSql("insertChangeDateSQL").trim());
            forUpdate.setparams(changeDateParams);
            queryResult2 = forUpdate.executeUpdate();
            endTransaction();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0 & queryResult2 > 0);
    }

    public boolean updateJobOrder(HttpServletRequest request, String urgencyId, String failureCode, String employeeId, HttpSession s) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject tradeWbo = new WebBusinessObject();
        WebBusinessObject userTradeWbo = new WebBusinessObject();
        Vector tradeParams = new Vector();
        Vector userTradeParams = new Vector();

        try {
            tradeParams = tradeMgr.getOnArbitraryKey(request.getParameter("workTrade").toString(), "key1");
            for (int i = 0; i < tradeParams.size(); i++) {
                tradeWbo = (WebBusinessObject) tradeParams.get(i);
            }
            userTradeParams = userTradeMgr.getOnArbitraryDoubleKey(tradeWbo.getAttribute("tradeId").toString(), "key2", waUser.getAttribute("userId").toString(), "key1");
            for (int i = 0; i < userTradeParams.size(); i++) {
                userTradeWbo = (WebBusinessObject) userTradeParams.get(i);
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        theRequest = request;

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(employeeId));
        params.addElement(new StringValue((String) tradeWbo.getAttribute("tradeId")));
        params.addElement(new StringValue(failureCode));
        params.addElement(new StringValue(request.getParameter("estimatedduration").toString()));
        params.addElement(new StringValue(urgencyId));
        params.addElement(new StringValue(request.getParameter("issueDesc").toString()));
        params.addElement(new StringValue((String) waUser.getAttribute("groupID")));
        params.addElement(new StringValue((String) userTradeWbo.getAttribute("Id")));

        StringValue sIssueID = new StringValue((String) request.getParameter("issueId"));
        params.addElement(sIssueID);

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateJobOrder").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
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

    public boolean getScheduleCase(String issueId) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(issueId));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getScheduleCase").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("database error " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public void executeMainReport(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());

        DateParser dateParser = new DateParser();
        java.sql.Date beginDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Date endDate = dateParser.formatSqlDate(request.getParameter("endDate"));

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        SQLparams.addElement(new IntValue(7));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("{call createweek(?, ?, ?)}");
            forQuery.setparams(SQLparams);

            forQuery.execute();

        } catch (SQLException ex) {
            logger.error("database error " + ex.getMessage());
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

    public void executeMainReportByEquip(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());

        DateParser dateParser = new DateParser();
        java.sql.Date beginDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Date endDate = dateParser.formatSqlDate(request.getParameter("endDate"));

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        SQLparams.addElement(new IntValue(7));
        SQLparams.addElement(new StringValue(request.getParameter("unitName")));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("{call createweek_by_machine(?, ?, ?,?)}");
            forQuery.setparams(SQLparams);

            forQuery.execute();

        } catch (SQLException ex) {
            logger.error("database error " + ex.getMessage());
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

    public void executeMainReportByMonth(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());

        DateParser dateParser = new DateParser();
        java.sql.Date beginDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Date endDate = dateParser.formatSqlDate(request.getParameter("endDate"));

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("{call createmonth(?, ?)}");
            forQuery.setparams(SQLparams);

            forQuery.execute();

        } catch (SQLException ex) {
            logger.error("database error " + ex.getMessage());
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

    public void executeRatioSuccess(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());

        DateParser dateParser = new DateParser();
        java.sql.Date beginDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Date endDate = dateParser.formatSqlDate(request.getParameter("endDate"));

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("{call successpercent(?, ?)}");
            forQuery.setparams(SQLparams);

            forQuery.execute();

        } catch (SQLException ex) {
            logger.error("database error " + ex.getMessage());
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

    public void executeMainReportByEquipByMonth(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());

        DateParser dateParser = new DateParser();
        java.sql.Date beginDate = dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Date endDate = dateParser.formatSqlDate(request.getParameter("endDate"));

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        SQLparams.addElement(new StringValue(request.getParameter("unitName")));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("{call createmonth_by_machine(?, ?, ?)}");
            forQuery.setparams(SQLparams);

            forQuery.execute();

        } catch (SQLException ex) {
            logger.error("database error " + ex.getMessage());
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

    public Vector getStatisticsForFailureCode(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));

        Vector queryResult = null;
        Vector queryResultEmergency = null;
        Vector queryResultExternal = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectFailureCodeAllIssue").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            forQuery.setSQLQuery(sqlMgr.getSql("selectFailureCodeEmergencyIssue").trim());
            //forQuery.setparams(SQLparams);
            queryResultEmergency = forQuery.executeQuery();

            forQuery.setSQLQuery(sqlMgr.getSql("selectFailureCodeExternalIssue").trim());
            //forQuery.setparams(SQLparams);
            queryResultExternal = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultVectors = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        queryResult = new Vector();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("failureCode", r.getString("TITLE"));
                wbo.setAttribute("total", r.getString("TOTAL"));
                queryResult.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        resultVectors.add(queryResult);

        e = queryResultEmergency.elements();

        queryResultEmergency = new Vector();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("failureCode", r.getString("TITLE"));
                wbo.setAttribute("total", r.getString("TOTAL"));
                queryResultEmergency.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        resultVectors.add(queryResultEmergency);

        e = queryResultExternal.elements();

        queryResultExternal = new Vector();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("failureCode", r.getString("TITLE"));
                wbo.setAttribute("total", r.getString("TOTAL"));
                queryResultExternal.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        resultVectors.add(queryResultExternal);

        return resultVectors;
    }

    public String getCreateTimeAssigned(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String time = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getCreateTimeAssigned").trim());

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
                time = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return time;

    }

    public String getNotesAssigned(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String note = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getNotesAssigned").trim());

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
                note = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return note;

    }

    public void saveIssueTasks(StringValue sIssueID, Vector sTasks) {
        Vector params = null;

        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();

        int queryResult = -1000;

        try {
            connection = dataSource.getConnection();

            for (int i = 0; i < sTasks.size(); i++) {
                WebBusinessObject wbo = (WebBusinessObject) sTasks.get(i);
                String codeTask = (String) wbo.getAttribute("codeTask");

                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(sIssueID);
                params.addElement(new StringValue(codeTask));
                params.addElement(new StringValue(wbo.getAttribute("desc").toString()));
                params.addElement(new StringValue("0"));

                forInsert.setConnection(connection);
                forInsert.setSQLQuery(sqlMgr.getSql("insertIssueTasksSql").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                Thread.sleep(200);
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());

        } catch (InterruptedException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");

            }
        }

    }

    public boolean getUpdateCaseConfigEmg(String Id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(Id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getUpdateCaseConfigEmg").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("database error " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public boolean getTasksforIssue(String Id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(Id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getTasksforIssue").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("database error " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public Vector getIssue() {
        WebIssue expense = null;

        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getdelayed").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
            expense = (WebIssue) fabricateBusObj(r);
            reultBusObjs.add(expense);
        }
        return reultBusObjs;
    }

    public String getsitDate(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String sitDate = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getsitDate").trim());

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
                sitDate = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return sitDate;

    }

    public String getActualBeginDate(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String actualBeginDate = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getActualBeginDate").trim());

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
                actualBeginDate = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return actualBeginDate;

    }

    public String getActualBeginDateFormat(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String actualBeginDate = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getActualBeginDateFormat").trim());

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
                actualBeginDate = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return actualBeginDate;

    }

    public String getEndJobDate(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String endJobDate = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEndJobDate").trim());

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
                endJobDate = r.getString(1);
            }

        } catch (SQLException ex) {
            logger.error("troubles closing connection " + ex.getMessage());
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

        return endJobDate;

    }

    private WebBusinessObject buildEqpStatusWbo(HttpServletRequest request) {
        WebBusinessObject eqpStatusWbo = new WebBusinessObject();

        eqpStatusWbo.setAttribute("beginDate", request.getParameter("siteEntryDate"));
        eqpStatusWbo.setAttribute("hour", request.getParameter("h"));
        eqpStatusWbo.setAttribute("minute", request.getParameter("m"));
        eqpStatusWbo.setAttribute("equipmentID", request.getParameter("unitName"));
        eqpStatusWbo.setAttribute("stateID", "2");
        eqpStatusWbo.setAttribute("note", "Equipment is out of work for job order");

        return eqpStatusWbo;
    }

    public String getJobOrderByBusinessIdAndBusinessByDate(String businessId, String businessIdBuDate) {

        String issueId = "";
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(businessId));
        SQLparams.addElement(new StringValue(businessIdBuDate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getJobOrderByBusinessIdAndBusinessByDate").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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
            try {
                issueId = r.getString("id");
            } catch (NoSuchColumnException ex) {
                logger.error("error when get issue id");
            }
        }
        return issueId;
    }

    public Vector getEqIssuesInRange(java.sql.Date beginDate, java.sql.Date endDate, String eqId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
//        StringBuffer query = new StringBuffer("SELECT * FROM issue WHERE EXPECTED_B_DATE BETWEEN ? AND ?");

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        SQLparams.addElement(new StringValue(eqId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectEqIssueInRange").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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

    public Vector getScheduleIssuesInRange(String unitId, String scheduleId, java.sql.Date beginDate, java.sql.Date endDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
//        StringBuffer query = new StringBuffer("SELECT * FROM issue WHERE EXPECTED_B_DATE BETWEEN ? AND ?");

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLparams.addElement(new StringValue(unitId));
        SQLparams.addElement(new StringValue(scheduleId));
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getScheduleIssuesInRange").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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

    public Vector getIssueByMinMaxId(String minId, String maxId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(minId));
        SQLparams.addElement(new StringValue(maxId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getIssuesByMinMaxIds").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
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

    public Vector getAllIssueByIds(Vector issueIds) {
        Vector issues = new Vector();
        WebBusinessObject wbo;
        for (int i = 0; i < issueIds.size(); i++) {
            wbo = issueMgr.getOnSingleKey((String) issueIds.get(i));
            issues.add(wbo);
        }

        return issues;
    }

    public String getExpctedBeginDate(String issueId) {
        String temp = "";
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(issueId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectExpectedBeginDate").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            Row row = (Row) queryResult.get(0);
            temp = row.getString("expectedBeginDate");
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return temp;
    }

    public String getExpctedEndDate(String issueId) {
        String temp = "";
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(issueId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectExpectedEndDate").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            Row row = (Row) queryResult.get(0);
            temp = row.getString("expectedEndDate");
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return temp;
    }

//    public boolean saveJobOrderOfInspection(HttpServletRequest request, WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
//        InspectionMgr inspectionMgr = InspectionMgr.getInstance();
//        //Get Logged User
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
//        dateAndTime = new DateAndTimeControl();
//        int minutes = 0;
//
//        String day = (String) request.getParameter("day");
//        String hours = (String) request.getParameter("hour");
//        String minute = (String) request.getParameter("minute");
//
//        if (day != null && !day.equals("")) {
//            minutes = minutes + dateAndTime.getMinuteOfDay(day);
//        }
//        if (hours != null && !hours.equals("")) {
//            minutes = minutes + dateAndTime.getMinuteOfHour(hours);
//        }
//        if (minute != null && !minute.equals("")) {
//            minutes = minutes + new Integer(minute).intValue();
//        }
//        //Define System params Variables
//        Vector unitScheduleParams = new Vector();
//        Vector issueParams = new Vector();
//        Vector issueStatusParams = new Vector();
//        Vector compInspecParams = new Vector();
//        Vector inspectionParams = new Vector();
//        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
//
//        int queryResult = -1000;
//
//        Connection connection = null;
//
//        //Get WebIssue
//        WebBusinessObject complInspecWbo = new WebBusinessObject();
//        Vector compInspecVec = new Vector();
//        ComplaintInspectionMgr compInspectionMgr = ComplaintInspectionMgr.getInstance();
//
//        compInspecVec = compInspectionMgr.getInspectionComplaint(request.getParameter("inspectionId").toString());
//
//        try {
//            //define command been
//            SQLCommandBean forInsert = new SQLCommandBean();
//
//            //Get expected begin and end date
//            String bDate = request.getParameter("beginDate");
//            String eDate = request.getParameter("endDate");
//            String sDate = request.getParameter("siteEntryDate");
//            String hour = request.getParameter("h");
//            String min = request.getParameter("m");
//            int h = Integer.parseInt(hour);
//            int m = Integer.parseInt(min);
//
//            String jsDateFormat = waUser.getAttribute("jsDateFormat").toString();
//            DateParser dateParser = new DateParser();
//            java.sql.Date beginD = dateParser.formatSqlDate(bDate, jsDateFormat);
//            java.sql.Date endD = dateParser.formatSqlDate(eDate, jsDateFormat);
//            java.util.Date siteD = dateParser.formatUtilDate(sDate, h, m, jsDateFormat);
//
//            java.sql.Timestamp beginDate = new java.sql.Timestamp(beginD.getTime());
//            java.sql.Timestamp endDate = new java.sql.Timestamp(endD.getTime());
//            java.sql.Timestamp siteEntryDate = new java.sql.Timestamp(siteD.getTime());
//
//            /**
//             * *** Get Virtual end date for first status ******
//             */
//            java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
//            java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());
//
//            //Get main wbo attributes
//            ScheduleUnitId = UniqueIDGen.getNextID().toString();
//            String UnitId = request.getParameter("unitName");
//            String UnitName = request.getParameter("equipName");
//            String ScheduleId = issueMgr.getScheduleId("Emergency");
//            StringValue sIssueID = new StringValue(UniqueIDGen.getNextID());
//            String pname = (String) wbo.getAttribute("project_name");
//
//            //Set Unit Schedule Params
//            unitScheduleParams.addElement(new StringValue(ScheduleUnitId));
//            unitScheduleParams.addElement(new StringValue(UnitId));
//            unitScheduleParams.addElement(new StringValue(UnitName));
//            unitScheduleParams.addElement(new StringValue(ScheduleId));
//            unitScheduleParams.addElement(new StringValue("Emergency"));
//            unitScheduleParams.addElement(new TimestampValue(beginDate));
//            unitScheduleParams.addElement(new TimestampValue(endDate));
//
//            //Set Issue Params
//            issueParams.addElement(sIssueID);
//            issueParams.addElement(new StringValue(pname));
//            issueParams.addElement(new StringValue(UnitName));
//            issueParams.addElement(new StringValue((String) waUser.getAttribute("userId")));
//            issueParams.addElement(new StringValue(urgencyMgr.getUrgencyId(request.getParameter("urgencyName"))));
//            issueParams.addElement(new StringValue(request.getParameter("issueDesc")));
//            issueParams.addElement(new StringValue(request.getParameter("receivedby")));
//            issueParams.addElement(new StringValue(request.getParameter("trade")));
//            issueParams.addElement(new IntValue(minutes));
//            issueParams.addElement(new TimestampValue(beginDate));
//            issueParams.addElement(new TimestampValue(endDate));
//            issueParams.addElement(new StringValue(ScheduleUnitId));
//            issueParams.addElement(new StringValue(request.getParameter("sequence")));
//
//            Long iID = new Long(sIssueID.getString());
//            Calendar calendar = Calendar.getInstance();
//            calendar.setTimeInMillis(iID.longValue());
//            sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
//
//            issueParams.addElement(new StringValue(request.getParameter("jobzise")));
//            issueParams.addElement(new StringValue(sID));
//            issueParams.addElement(new TimestampValue(siteEntryDate));
//            issueParams.addElement(new StringValue(UnitId));
//            issueParams.addElement(new StringValue(request.getParameter("shift")));
//
//            issueId = sIssueID.getString();
//            request.setAttribute("issueId", issueId);
//
//            //Set IssueStatus Params
//            issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
//            issueStatusParams.addElement(new StringValue(AppConstants.LC_SCHEDULE));
//            issueStatusParams.addElement(sIssueID);
//            issueStatusParams.addElement(new StringValue(request.getParameter("issueDesc")));
//            issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
//
//            //Setup connection
//            connection = dataSource.getConnection();
//            connection.setAutoCommit(false);
//            forInsert.setConnection(connection);
//
//            //Save UnitSchedule
//            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueUnitSchedule").trim());
//            forInsert.setparams(unitScheduleParams);
//            queryResult = forInsert.executeUpdate();
//
//            if (queryResult <= 0) {
//                connection.rollback();
//                return false;
//            }
//
//            //Save Issue
//            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueByInspection").trim());
//            forInsert.setparams(issueParams);
//            queryResult = forInsert.executeUpdate();
//
//            if (queryResult <= 0) {
//                connection.rollback();
//                return false;
//            }
//
//            //Save Issue_Status
//            forInsert.setSQLQuery(sqlMgr.getSql("insertEmgIssueStatusVirtualDate").trim());
//            forInsert.setparams(issueStatusParams);
//            queryResult = forInsert.executeUpdate();
//
//            if (queryResult <= 0) {
//                connection.rollback();
//                return false;
//            }
//
//            ///////// updat job order id for inspection ///////
//            inspectionParams.addElement(sIssueID);
//            inspectionParams.addElement(new StringValue(request.getParameter("inspectionId")));
//            forInsert.setSQLQuery(sqlMgr.getSql("updateInspectionByIssue").trim());
//            forInsert.setparams(inspectionParams);
//            queryResult = forInsert.executeUpdate();
//
//            if (queryResult <= 0) {
//                connection.rollback();
//                return false;
//            }
//
//            ////////// end //////////////////////////////////
//            //////// saving for complaint inspection job order ////
//            forInsert.setSQLQuery(sqlMgr.getSql("insertComplaintSql").trim());
//            for (int i = 0; i < compInspecVec.size(); i++) {
//                complInspecWbo = (WebBusinessObject) compInspecVec.get(i);
//                compInspecParams = new Vector();
//                compInspecParams.addElement(new StringValue(UniqueIDGen.getNextID()));
//                compInspecParams.addElement(new StringValue((String) waUser.getAttribute("userId")));
//                compInspecParams.addElement(sIssueID);
//                compInspecParams.addElement(new StringValue((String) complInspecWbo.getAttribute("descSLevel")));
//                compInspecParams.addElement(new StringValue((String) waUser.getAttribute("userName")));
//                compInspecParams.addElement(new StringValue("NO"));
//
//                forInsert.setparams(compInspecParams);
//                queryResult = forInsert.executeUpdate();
//
//                if (queryResult <= 0) {
//                    connection.rollback();
//                    return false;
//                }
//                try {
//                    Thread.sleep(50);
//                } catch (InterruptedException ex) {
//                    logger.error(ex.getMessage());
//                }
//
//            }
//
//            /////////////// end /////////
//        } catch (SQLException ex) {
//            try {
//                connection.rollback();
//            } catch (SQLException q) {
//                logger.error(q.getMessage());
//            }
//            logger.error(ex.getMessage());
//            return false;
//
//        } catch (Exception ex) {
//            try {
//                connection.rollback();
//            } catch (SQLException q) {
//                logger.error(q.getMessage());
//            }
//            logger.error(ex.getMessage());
//            return false;
//        } finally {
//            try {
//                connection.commit();
//                connection.close();
//            } catch (SQLException ex) {
//                logger.error("Close Error");
//                return false;
//            }
//        }
//
//        inspectionMgr.updateInspectionAsClosedAgree(request.getParameter("inspectionId"), (String) waUser.getAttribute("userId"));
//        WebBusinessObject inspectionWbo = inspectionMgr.getOnSingleKey(request.getParameter("inspectionId"));
//        inspectionMgr.updateInspectionStatusInERP((String) inspectionWbo.getAttribute("trnsNo"), (String) inspectionWbo.getAttribute("location"), 2);
//        return (queryResult > 0);
//    }
    public String getUnitScheduleId(String issueId) {
        WebBusinessObject issue = issueMgr.getOnSingleKey(issueId);

        try {
            return (String) issue.getAttribute("unitScheduleID");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            return null;
        }
    }

    public boolean deleteAllIssues() {
        SQLCommandBean command = new SQLCommandBean();

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery("{ CALL DELETE_ALL_ISSUE() }");

            command.executeUpdate();
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException sq) {
                logger.error("Close Error " + sq.getMessage());
            }
            logger.error(ex.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
                return false;
            }
        }

        return (true);
    }

    public long getNumberOfAllIssue() {
        SQLCommandBean command = new SQLCommandBean();
        Vector<Row> result = new Vector<Row>();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("getNumberOfAllIssue").trim());

            result = command.executeQuery();

            if (!result.isEmpty()) {
                Row row = result.get(0);
                String count = row.getString("NUMBER_OF_ALL_ISSUE");
                return Long.valueOf(count).longValue();
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch (NoSuchColumnException ex) {
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

    public Vector getIssueCountPerProject() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getIssueCountPerProject").trim());
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());

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
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("projectName", r.getString("project_name"));
                wbo.setAttribute("issueCount", r.getString("issue_count"));
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public WebBusinessObject getLastIssueBySchedule(String unitId, String scheduleId, String sites, String toDate) {
        Connection connection = null;
        WebBusinessObject wbo = null;
        Row r = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        String query = getQuery("getLastIssueBySchedule").trim();
        query = query.replaceAll("sss", sites);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");
        java.util.Date toD = null;

        try {
            toD = dateFormat.parse(toDate);

        } catch (ParseException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);

        }

        Timestamp toDateTS = new Timestamp(toD.getTime());
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            SQLparams.addElement(new StringValue(scheduleId));
            SQLparams.addElement(new StringValue(unitId));
            SQLparams.addElement(new StringValue(unitId));
            SQLparams.addElement(new StringValue(scheduleId));
            SQLparams.addElement(new TimestampValue(toDateTS));

            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            if (queryResult.size() > 0) {
                wbo = new WebBusinessObject();
                r = (Row) queryResult.get(0);
                wbo.setAttribute("unitName", r.getString("unit_name"));
                wbo.setAttribute("scheduleTitle", r.getString("maintenance_title"));
                wbo.setAttribute("projectName", r.getString("project_name"));
                wbo.setAttribute("JONumber", r.getString("business_id") + "/" + r.getString("business_id_by_date"));
                wbo.setAttribute("JODate", r.getString("actual_begin_date"));
                wbo.setAttribute("counterReading", r.getString("counter_reading"));

            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return wbo;
    }

    public Vector getIssues() {
        Connection connection = null;
        WebBusinessObject wbo = null;
        Row r = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        String query = getQuery("getIssue").trim();
        Vector data = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
            Enumeration e = null;
            e = queryResult.elements();

            IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
            while (e.hasMoreElements()) {
                wbo = new WebBusinessObject();
                r = (Row) e.nextElement();
                wbo.setAttribute("issueDesc", r.getString("issue_desc"));
                wbo.setAttribute("issueId", r.getString("id"));
                wbo.setAttribute("creationTime", r.getString("creation_time"));
                wbo.setAttribute("clientNo", r.getString("client_no"));
                wbo.setAttribute("callType", r.getString("call_type"));
                wbo.setAttribute("clientName", r.getString("name"));
                wbo.setAttribute("busId", r.getString("business_id"));
                Vector complaints = new Vector();

                complaints = issueByComplaintAllCaseMgr.getAllCase(r.getString("id"));
                int numOfOrders = 0;
                if (complaints != null) {
                    for (int i = 0; i < complaints.size(); i++) {
                        numOfOrders++;
                    }
                    wbo.setAttribute("numOfOrders", numOfOrders);
                } else {
                    wbo.setAttribute("numOfOrders", "empty");
                }

                data.add(wbo);

            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return data;
    }

    public WebBusinessObject getPenultimateIssueBySchedule(String unitId, String scheduleId, String sites, String toDate) {
        Connection connection = null;
        WebBusinessObject wbo = null;
        Row r = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        String query = getQuery("getPenultimateIssueBySchedule").trim();
        query = query.replaceAll("sss", sites);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");
        java.util.Date toD = null;

        try {
            toD = dateFormat.parse(toDate);

        } catch (ParseException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);

        }

        Timestamp toDateTS = new Timestamp(toD.getTime());

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            SQLparams.addElement(new StringValue(scheduleId));
            SQLparams.addElement(new StringValue(unitId));
            SQLparams.addElement(new StringValue(unitId));
            SQLparams.addElement(new StringValue(scheduleId));
            SQLparams.addElement(new TimestampValue(toDateTS));
            SQLparams.addElement(new StringValue(unitId));
            SQLparams.addElement(new StringValue(scheduleId));
            SQLparams.addElement(new TimestampValue(toDateTS));

            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            if (queryResult.size() > 0) {
                wbo = new WebBusinessObject();
                r = (Row) queryResult.get(0);
                wbo.setAttribute("unitName", r.getString("unit_name"));
                wbo.setAttribute("scheduleTitle", r.getString("maintenance_title"));
                wbo.setAttribute("projectName", r.getString("project_name"));
                wbo.setAttribute("JONumber", r.getString("business_id") + "/" + r.getString("business_id_by_date"));
                wbo.setAttribute("JODate", r.getString("actual_begin_date"));
                wbo.setAttribute("counterReading", r.getString("counter_reading"));

            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return wbo;
    }

    public String saveCallData(HttpServletRequest request, HttpSession s, String objType) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String clientPhone = null;
        String comments = null;

        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

//        if (request.getParameter("phone")!= null && !request.getParameter("comments").equals("")) {
//            clientPhone = request.getParameter("phone").toString();
//        } else {
        clientPhone = "123456789";
//        }

        if (request.getParameter("comments") != null && !request.getParameter("comments").equals("")) {
            comments = request.getParameter("comments").toString();
        } else {
            comments = "none";
        }
        String note = "none";
        if (request.getParameter("note") != null && !request.getParameter("note").equals("")) {
            note = (String) request.getParameter("note");
        }

        java.util.Date date = new java.util.Date();
        DateFormat df = new SimpleDateFormat("yyyy/MM/dd hh:mm");
        java.sql.Timestamp entryTime = null;
        String entDate = request.getParameter("entryDate").toString();
        String[] arDate = entDate.split(" ");
        entDate = arDate[0].replace("-", "/") + " " + arDate[1];

        try {
            entryTime = new java.sql.Timestamp(df.parse(entDate).getTime());
        } catch (ParseException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
//        String entryDate = df.format(date);
//        DateParser dateParser = new DateParser();
        //request.getParameter("entryDate")
//        java.sql.Date entryDate = dateParser.formatSqlDate("2013/03/23");
        Vector params = new Vector();
        Vector statusParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
//        String clientNoByDate = null;
        String issueId = UniqueIDGen.getNextID();

        params.addElement(new StringValue(issueId));
        //issueTitle
        params.addElement(new StringValue(clientPhone));
        //projectName
        params.addElement(new StringValue("ay 7aga "));
        //fa_id

        //issueType
        params.addElement(new StringValue(note));
        //userId
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        //urgencyId
        params.addElement(new StringValue(request.getParameter("clientId")));
        //issueDesc
        params.addElement(new StringValue(note));
        //SYSDATE

        //currentStatus
        params.addElement(new StringValue("1"));

        //currentStatusSince
        params.addElement(new TimestampValue(
                new java.sql.Timestamp(entryTime.getTime())));

        //assignedById        
        params.addElement(new StringValue(comments));

        //unit_id
        params.addElement(new StringValue("1225014080921"));

        params.addElement(new StringValue(sequenceMgr.getSequence()));
        params.addElement(new StringValue(
                (calendar.get(Calendar.MONTH) + 1)
                + "/" + calendar.get(Calendar.YEAR)));
        // call_type
        params.addElement(new StringValue(request.getParameter("call_status")));

        String issueStatusId = UniqueIDGen.getNextID();
        statusParams.addElement(new StringValue(issueStatusId));
        // 1 mean received from Issue // 2 mean sent from complaint //
        statusParams.addElement(new StringValue("1"));
        statusParams.addElement(new StringValue("Opened"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new TimestampValue(new java.sql.Timestamp(entryTime.getTime())));
        statusParams.addElement(new StringValue("0"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue(issueId));
        statusParams.addElement(new StringValue(objType));
        statusParams.addElement(new StringValue("0"));
        statusParams.addElement(new StringValue((String) waUser.getAttribute("userId")));

        //Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssueStatus").trim());
            forInsert.setparams(statusParams);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;

        } finally {
            request.setAttribute("issueId", issueId);
            endTransaction();
        }

        if (queryResult > 0) {
            return issueId;
        } else {
            return null;
        }
    }

    public String saveIssueFromTypeExtracting(WebBusinessObject extract, WebBusinessObject persistentUser) throws SQLException, ParseException {
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();

        String businessID = sequenceMgr.getSequence();
        String title = "Extracting";
        if (extract.getAttribute("title") != null) {
            title = (String) extract.getAttribute("title");
        }
        String comments = "none";
        String note = "none";
        String unitId = (String) extract.getAttribute("unitId");

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

        if (extract.getAttribute("unitId") != null && !extract.getAttribute("unitId").toString().isEmpty()) {
            unitId = extract.getAttribute("unitId").toString();
        }
        if (extract.getAttribute("comments") != null && !extract.getAttribute("comments").equals("")) {
            comments = extract.getAttribute("comments").toString();
        }
        if (extract.getAttribute("note") != null && !extract.getAttribute("note").equals("")) {
            note = (String) extract.getAttribute("note");
        }

        DateFormat df = new SimpleDateFormat("yyyy/MM/dd hh:mm");
        java.sql.Timestamp entryTime = null;
        String entDate = extract.getAttribute("entryDate").toString();
        String[] arDate = entDate.split(" ");
        entDate = arDate[0].replace("-", "/") + " " + arDate[1];

        try {
            entryTime = new java.sql.Timestamp(df.parse(entDate).getTime());
        } catch (ParseException ex) {
            logger.error(ex);
        }

        Vector issueParameters = new Vector();
        Vector statusParameters = new Vector();
        forInsert = new SQLCommandBean();
        int queryResult = -1000;
        issueId = UniqueIDGen.getNextID();

        String deliveryDate = (String) extract.getAttribute("deliveryDate");
        if (deliveryDate.contains(" ")) {
            df = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        } else {
            df = new SimpleDateFormat("yyyy/MM/dd");
        }
        // setup issue data
        issueParameters.addElement(new StringValue(issueId));
        issueParameters.addElement(new StringValue(title));//issueTitle
        issueParameters.addElement(new StringValue("ay 7aga "));//projectName
        issueParameters.addElement(new StringValue(extract.getAttribute("type").toString()));//issueType
        issueParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));//userId
        issueParameters.addElement(new StringValue(extract.getAttribute("clientId").toString()));//urgencyId
        issueParameters.addElement(new StringValue(note));//issueDesc
        issueParameters.addElement(new TimestampValue(new java.sql.Timestamp(df.parse(deliveryDate).getTime())));//creationTime
        issueParameters.addElement(new StringValue("1"));//currentStatus
        issueParameters.addElement(new TimestampValue(new java.sql.Timestamp(entryTime.getTime())));//currentStatusSince
        issueParameters.addElement(new StringValue("UL"));//assignedById 
        issueParameters.addElement(new StringValue(unitId));//unit_id
        issueParameters.addElement(new StringValue(businessID));
        issueParameters.addElement(new StringValue((calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR)));
        issueParameters.addElement(new StringValue(extract.getAttribute("callType").toString()));// call type

        String issueStatusId = UniqueIDGen.getNextID();
        statusParameters.addElement(new StringValue(issueStatusId));
        // 1 mean received from Issue // 2 mean sent from complaint //
        statusParameters.addElement(new StringValue("1"));
        statusParameters.addElement(new StringValue("Opened"));
        statusParameters.addElement(new StringValue("UL"));
        statusParameters.addElement(new TimestampValue(new java.sql.Timestamp(entryTime.getTime())));
        statusParameters.addElement(new StringValue("0"));
        statusParameters.addElement(new StringValue("UL"));
        statusParameters.addElement(new StringValue("UL"));
        statusParameters.addElement(new StringValue("UL"));
        statusParameters.addElement(new StringValue(issueId));
        statusParameters.addElement(new StringValue("issue"));
        statusParameters.addElement(new StringValue("0"));
        statusParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // saving issue data
            forInsert.setSQLQuery(getQuery("insertIssueForTypeExtracting").trim());
            forInsert.setparams(issueParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }

            forInsert.setSQLQuery(sqlMgr.getSql("saveIssueStatus").trim());
            forInsert.setparams(statusParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            connection.rollback();
            return null;
        } finally {
            extract.setAttribute("issueId", issueId);
            connection.commit();
            connection.close();
        }

        if (queryResult > 0) {
            return issueId;
        } else {
            return null;
        }
    }

    public Vector getCallCountPerDepartment(String userID) throws NoSuchColumnException {
        StringBuilder where = new StringBuilder();
        if (userID != null && !userID.isEmpty()) {
            where.append("and user_id = '").append(userID).append("'");
        }
        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getCallRatioo").replaceFirst("whereUserID", where.toString()).trim());

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
        String entryDate = null;

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            if (r.getString("connection_type") != null) {
                wbo = fabricateBusObj(r);
                wbo.setAttribute("callType", r.getString("connection_type"));
                wbo.setAttribute("callCount", r.getString("connection_count"));

                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public Vector getRequestCountPerDepartment(String departmentName) throws NoSuchColumnException {

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getRequestRatioo").trim());
        params.addElement(new StringValue(departmentName));

        try {

            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setparams(params);
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
        String entryDate = null;

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            wbo.setAttribute("type_name", r.getString("type_name"));
            wbo.setAttribute("request_count", r.getString("request_count"));

            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    ///////////////////////////////////////////////////

    public Vector getCallDate(String clientId) throws NoSuchColumnException {

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getCallDate").trim());
        params.addElement(new StringValue(clientId));

        try {

            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setparams(params);
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
        String entryDate = null;

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
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

    public boolean updateCallType(String issueId, String callType) {

        int queryResult = -1000;
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(getQuery("updateCallType").trim());
        params.addElement(new StringValue(callType));
        params.addElement(new StringValue(callType));
        params.addElement(new StringValue(issueId));
        try {

            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            if (queryResult <= 0) {
                return false;
            }
        } catch (Exception se) {
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

        return true;
    }

    public boolean updateCallDirection(String issueId, String direction) {

        int queryResult = -1000;
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(getQuery("updateCallDirection").trim());
        params.addElement(new StringValue(direction));
        params.addElement(new StringValue(issueId));
        try {

            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            if (queryResult <= 0) {
                return false;
            }
        } catch (Exception se) {
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

        return true;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

    private java.sql.Date getSqlBeginDate(String date) {
        DateParser parser = new DateParser();
        java.sql.Date sqlDate = parser.formatSqlDate(date);

        return sqlDate;
    }

    public Vector getIssues(int within, String createdBy, String fromDate, String toDate) {
        Connection connection = null;
        WebBusinessObject wbo = null;
        Row r = null;
        Vector queryResult = null;
        String query = getQuery("getIssuesWithin").trim();
        Vector data = new Vector();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            parameters.addElement(new DateValue(getSqlBeginDate(fromDate)));
            parameters.addElement(new DateValue(getSqlBeginDate(toDate)));
            parameters.addElement(new StringValue(createdBy));

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
            Enumeration e = null;
            e = queryResult.elements();

            IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
            while (e.hasMoreElements()) {
                wbo = new WebBusinessObject();
                r = (Row) e.nextElement();
                wbo.setAttribute("issueDesc", r.getString("issue_desc"));
                wbo.setAttribute("issueId", r.getString("id"));
                wbo.setAttribute("creationTime", r.getString("creation_time"));
                wbo.setAttribute("clientNo", r.getString("client_no"));
                wbo.setAttribute("callType", r.getString("call_type"));
                wbo.setAttribute("clientName", r.getString("name"));
                wbo.setAttribute("busId", r.getString("business_id"));
                Vector complaints = new Vector();
                complaints = issueByComplaintAllCaseMgr.getAllCase(r.getString("id"));
                int numOfOrders = 0;
                if (complaints != null) {
                    for (int i = 0; i < complaints.size(); i++) {
                        numOfOrders++;
                    }
                    wbo.setAttribute("numOfOrders", numOfOrders);
                } else {
                    wbo.setAttribute("numOfOrders", "empty");
                }
                data.add(wbo);
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return data;
    }

    public Vector getIssuesByDepartmentWithin(int within, String code) {
        Connection connection = null;
        WebBusinessObject wbo;
        Row row;
        Vector queryResult;
        String query = getQuery("getIssuesByDepartmentWithin").trim().replaceFirst("no_of_hours", new Integer(within).toString());
        query = query.replaceFirst("CODE", code);
        Vector data = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
            Enumeration enumeration;
            enumeration = queryResult.elements();

            IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
            while (enumeration.hasMoreElements()) {
                wbo = new WebBusinessObject();
                row = (Row) enumeration.nextElement();
                wbo.setAttribute("issueDesc", row.getString("issue_desc"));
                wbo.setAttribute("issueId", row.getString("id"));
                wbo.setAttribute("creationTime", row.getString("creation_time"));
                wbo.setAttribute("clientNo", row.getString("client_no"));
                wbo.setAttribute("callType", row.getString("call_type"));
                wbo.setAttribute("clientName", row.getString("name"));
                wbo.setAttribute("busId", row.getString("business_id"));
                Vector complaints = issueByComplaintAllCaseMgr.getAllCase(row.getString("id"));
                int numOfOrders = 0;
                if (complaints != null) {
                    for (int i = 0; i < complaints.size(); i++) {
                        numOfOrders++;
                    }
                    wbo.setAttribute("numOfOrders", numOfOrders);
                } else {
                    wbo.setAttribute("numOfOrders", "empty");
                }
                data.add(wbo);
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return data;
    }

    public String saveCallDataAuto(String clientId, String meetingType, String callStatus, HttpSession s, String objType, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());
        java.sql.Timestamp entryTime = new java.sql.Timestamp(Calendar.getInstance().getTimeInMillis());
        Vector params = new Vector();
        Vector statusParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String issueId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(issueId));
        //issueTitle
        params.addElement(new StringValue("123456789"));
        //projectName
        params.addElement(new StringValue("ay 7aga "));
        //issueType
        params.addElement(new StringValue(meetingType));
        //userId
        params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
        //urgencyId
        params.addElement(new StringValue(clientId));
        //issueDesc
        params.addElement(new StringValue(meetingType));
        //currentStatus
        params.addElement(new StringValue("1"));
        //currentStatusSince
        params.addElement(new TimestampValue(
                new java.sql.Timestamp(entryTime.getTime())));
        //assignedById        
        params.addElement(new StringValue("none"));
        //unit_id
        params.addElement(new StringValue("1225014080921"));
        params.addElement(new StringValue(sequenceMgr.getSequence()));
        params.addElement(new StringValue(
                (calendar.get(Calendar.MONTH) + 1)
                + "/" + calendar.get(Calendar.YEAR)));
        // call_type
        params.addElement(new StringValue(callStatus));
        String issueStatusId = UniqueIDGen.getNextID();
        statusParams.addElement(new StringValue(issueStatusId));
        // 1 mean received from Issue // 2 mean sent from complaint //
        statusParams.addElement(new StringValue("1"));
        statusParams.addElement(new StringValue("Opened"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new TimestampValue(new java.sql.Timestamp(entryTime.getTime())));
        statusParams.addElement(new StringValue("0"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue(issueId));
        statusParams.addElement(new StringValue(objType));
        statusParams.addElement(new StringValue("0"));
        statusParams.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssueStatus").trim());
            forInsert.setparams(statusParams);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;
        } finally {
            endTransaction();
        }
        if (queryResult > 0) {
            return issueId;
        } else {
            return null;
        }
    }

    public String getLastIssueForClient(String clientId) {
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        Connection connection = null;
        Vector result;

        parameters.add(new StringValue(clientId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getLastIssueForClient").trim());
            command.setparams(parameters);

            result = command.executeQuery();

            if (!result.isEmpty()) {
                Enumeration e = result.elements();
                while (e.hasMoreElements()) {
                    try {
                        Row row = (Row) e.nextElement();
                        return row.getString("ISSUE_ID");
                    } catch (NoSuchColumnException se) {
                        logger.error(se.getMessage());
                    }
                }
            }

        } catch (UnsupportedTypeException se) {
            logger.error(se.getMessage());
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return null;
    }

    public ArrayList<WebBusinessObject> getClearErrorTasks(String beginDate, String endDate, String issueType) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        StringBuilder where = new StringBuilder(" where ");
        where.append("i.CREATION_TIME between TO_DATE ('").append(beginDate);
        where.append(" 00:00:00', 'yyyy/mm/dd HH24:mi:ss') AND TO_DATE ('");
        where.append(endDate).append(" 23:59:59', 'yyyy/mm/dd HH24:mi:ss')");
        where.append(" AND i.ISSUE_TYPE = '").append(issueType).append("'");
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClearErrorTasks") + where.toString());
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
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            try {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                if (r.getString("name") != null) {
                    wbo.setAttribute("clientName", r.getString("name"));
                }
                resultBusObjs.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return resultBusObjs;
    }

    public List<WebBusinessObject> getClearErrorTasksByBusiness(String businessCode) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<Row>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        parameters.addElement(new StringValue(businessCode));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getClearErrorTasksByBusiness"));
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }

        List<WebBusinessObject> result = new ArrayList<WebBusinessObject>();
        for (Row row : query) {
            try {
                wbo = fabricateBusObj(row);
                if (row.getString("name") != null) {
                    wbo.setAttribute("clientName", row.getString("name"));
                }
                result.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return result;
    }

    public boolean deleteAllIssueData(String issueId) throws SQLException {
        Connection connection = null;
        Vector params = new Vector();
        params.add(new StringValue(issueId));
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            // Delete Distribution
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteDistributionWithIssueID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Issue Documents Data
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteDocumentDataWithIssueID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Issue Documents
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteDocumentWithIssueID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Client Complaints
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteComplaintsWithIssueID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Issue Status
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteStatusWithIssueID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Items for contarcting
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteItemsWithIssueID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Issue
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteIssueByID"));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            connection.commit();
            connection.setAutoCommit(true);
        } catch (SQLException se) {
            logger.error("database error " + se.getMessage());
            if (connection != null) {
                connection.rollback();
            }
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return (queryResult > 0);
    }

    public boolean saveDocRequests(WebBusinessObject wbo, String userID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(UniqueIDGen.getNextID()));
        parameters.addElement(new StringValue((String) wbo.getAttribute("docCode")));
        parameters.addElement(new StringValue((String) wbo.getAttribute("requestCode")));
        parameters.addElement(new StringValue((String) wbo.getAttribute("requestCode")));
        parameters.addElement(new StringValue(userID));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("insertDocRequest").trim());
            command.setparams(parameters);
            result = command.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error("Exception updating project: " + se.getMessage());
            }
        }

        return (result > 0);
    }

    public WebBusinessObject getRequestExtraditionReport(String issueId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = new Vector<Row>();
        Vector parameters = new Vector();
        WebBusinessObject data = null;

        parameters.addElement(new StringValue(issueId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getRequestExtraditionReport"));
            result = command.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }

        WebBusinessObject formattedDate;
        for (Row row : result) {
            try {
                data = fabricateBusObj(row);
                formattedDate = DateAndTimeControl.getFormattedDateTime((String) data.getAttribute("creationTime"), "Ar");
                data.setAttribute("clientName", row.getString("CLIENT_NAME"));
                data.setAttribute("creatorName", row.getString("FULL_NAME"));
                data.setAttribute("status", row.getString("STATUS_NAME"));
                data.setAttribute("date", formattedDate.getAttribute("day") + " - " + formattedDate.getAttribute("time"));

                String info = (String) data.getAttribute("unitId");
                if (info != null) {
                    String[] infos = info.split("-");
                    try {
                        data.setAttribute("buildingNo", infos[0]);
                        data.setAttribute("modelNo", infos[1]);
                        data.setAttribute("floorNo", infos[2]);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                break;
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }

        if (data != null) {
            RequestItemsDetailsMgr detailsMgr = RequestItemsDetailsMgr.getInstance();
            CommentsMgr commentsMgr = CommentsMgr.getInstance();
            List<WebBusinessObject> items = detailsMgr.getByIssueId(issueId);
            List<WebBusinessObject> comments = commentsMgr.getCommentsByObjectId(issueId);

            // prepare comment format
            int index = 0;
            for (WebBusinessObject comment : comments) {
                try {
                    formattedDate = DateAndTimeControl.getFormattedDateTime((String) data.getAttribute("creationTime"), "Ar");
                    comment.setAttribute("date", formattedDate.getAttribute("day") + " - " + formattedDate.getAttribute("time"));
                    comment.setAttribute("commentTitle", commentsTitle[index++ % commentsTitle.length]);
                } catch (Exception ex) {
                    logger.error(ex);
                }
            }

            data.setAttribute("items", items);
            data.setAttribute("comments", comments);
        }

        return data;
    }

    public boolean updateCurrentStatus(String issueId, String statusCode) throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        int queryResult = -1000;

        parameters.addElement(new StringValue(statusCode));
        parameters.addElement(new StringValue(issueId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateCurrentStatus").trim());
            command.setparams(parameters);
            queryResult = command.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } finally {
            connection.close();
        }

        return (queryResult > 0);
    }

    public boolean updateExtraditionContractor(String issueID, String clientID) throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        int queryResult = -1000;
        parameters.addElement(new StringValue(clientID));
        parameters.addElement(new StringValue(issueID));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateExtraditionContractor"));
            command.setparams(parameters);
            queryResult = command.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
        return (queryResult > 0);
    }

    public boolean updateIssueTitle(String issueID, String issueTitle) throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        int queryResult = -1000;
        parameters.addElement(new StringValue(issueTitle));
        parameters.addElement(new StringValue(issueID));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateIssueTitle"));
            command.setparams(parameters);
            queryResult = command.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getUnderFollowup(String issueType) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(issueType));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getUnderFollowup"));
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        for (Row row : query) {
            try {
                wbo = fabricateBusObj(row);
                if (row.getString("COMPLAINTS_NO") != null) {
                    wbo.setAttribute("complaintsNo", row.getString("COMPLAINTS_NO"));
                }
                if (row.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                }
                result.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return result;
    }

    public boolean deleteDocRequests(String issueID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;
        parameters.addElement(new StringValue(issueID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("deleteDocRequests").trim());
            command.setparams(parameters);
            result = command.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception deleteing reuested docs: " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error("Exception deleteing reuested docs: " + se.getMessage());
            }
        }

        return (result > 0);
    }

    public ArrayList<WebBusinessObject> getAllIssuesDepOnIssue(String issueID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(issueID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getAllIssuesDepOnIssue"));
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        for (Row row : query) {
            wbo = fabricateBusObj(row);
            result.add(wbo);
        }
        return result;
    }

    public boolean updateIssueSourceID(String issueID, String userID) throws SQLException {
        SQLCommandBean updateCommand = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int queryResult = -1000;
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new StringValue(issueID));
        try {
            connection = dataSource.getConnection();
            updateCommand.setConnection(connection);
            updateCommand.setSQLQuery(getQuery("updateIssueSourceID").trim());
            updateCommand.setparams(parameters);
            queryResult = updateCommand.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
        return queryResult > 0;
    }

    public String saveAutoData(WebBusinessObject wbo) throws NoUserInSessionException, SQLException {
        String comments = wbo.getAttribute("notes") != null ? (String) wbo.getAttribute("notes") : "none";
        String note = wbo.getAttribute("notes") != null ? (String) wbo.getAttribute("notes") : "none";
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();
        Calendar calendar = Calendar.getInstance();
        Vector params = new Vector();
        Vector statusParams = new Vector();
        forInsert = new SQLCommandBean();
        int queryResult = -1000;
        issueId = UniqueIDGen.getNextID();

        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue(note)); //issueType
        params.addElement(new StringValue((String) wbo.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("clientId"))); //urgencyId
        params.addElement(new StringValue(note)); //issueDesc
        params.addElement(new StringValue("1")); //currentStatus
        params.addElement(new TimestampValue((java.sql.Timestamp) wbo.getAttribute("entryDate"))); //currentStatusSince
        params.addElement(new StringValue(comments)); //assignedById
        params.addElement(new StringValue("1225014080921")); //unit_id
        params.addElement(new StringValue(sequenceMgr.getSequence()));
        params.addElement(new StringValue((calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR)));
        params.addElement(new StringValue("none")); // call_type

        String issueStatusId = UniqueIDGen.getNextID();
        statusParams.addElement(new StringValue(issueStatusId));
        // 1 mean received from Issue // 2 mean sent from complaint //
        statusParams.addElement(new StringValue("1"));
        statusParams.addElement(new StringValue("Opened"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new TimestampValue((java.sql.Timestamp) wbo.getAttribute("entryDate")));
        statusParams.addElement(new StringValue("0"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue(issueId));
        statusParams.addElement(new StringValue("issue"));
        statusParams.addElement(new StringValue("0"));
        statusParams.addElement(new StringValue((String) wbo.getAttribute("userId")));

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssueStatus").trim());
            forInsert.setparams(statusParams);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;
        } finally {
            wbo.setAttribute("issueId", issueId);
            endTransaction();
        }
        if (queryResult > 0) {
            return issueId;
        } else {
            return null;
        }
    }

    public String insertIssueProcurement(WebBusinessObject extract, WebBusinessObject persistentUser) {
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();

        String businessID = sequenceMgr.getSequence();
        String title = "Procurement Request";
        if (extract.getAttribute("title") != null) {
            title = (String) extract.getAttribute("title");
        }
        String note = "none";
        String unitId = (String) extract.getAttribute("unitId");

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

        if (extract.getAttribute("note") != null && !extract.getAttribute("note").equals("")) {
            note = (String) extract.getAttribute("note");
        }

        DateFormat df = new SimpleDateFormat("yyyy/MM/dd hh:mm");
        java.sql.Timestamp entryTime = null;
        String entDate = extract.getAttribute("entryDate").toString();
        String[] arDate = entDate.split(" ");
        entDate = arDate[0].replace("-", "/") + " " + arDate[1];

        try {
            entryTime = new java.sql.Timestamp(df.parse(entDate).getTime());
        } catch (ParseException ex) {
            logger.error(ex);
        }

        Vector issueParameters = new Vector();
        Vector statusParameters = new Vector();
        forInsert = new SQLCommandBean();
        int queryResult = -1000;
        issueId = UniqueIDGen.getNextID();

        String deliveryDate = (String) extract.getAttribute("deliveryDate");
        if (deliveryDate.contains(" ")) {
            df = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        } else {
            df = new SimpleDateFormat("yyyy/MM/dd");
        }

        Connection connection = null;
        try {
            // setup issue data
            issueParameters.addElement(new StringValue(issueId));
            issueParameters.addElement(new StringValue(title));//issueTitle
            issueParameters.addElement(new StringValue("UL"));//projectName
            issueParameters.addElement(new StringValue(extract.getAttribute("type").toString()));//issueType
            issueParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));//userId
            issueParameters.addElement(new StringValue((String) extract.getAttribute("clientId")));//urgencyId
            issueParameters.addElement(new StringValue(note));//issueDesc
            issueParameters.addElement(new TimestampValue(new java.sql.Timestamp(df.parse(deliveryDate).getTime())));//creationTime
            issueParameters.addElement(new StringValue("1"));//currentStatus
            issueParameters.addElement(new TimestampValue(new java.sql.Timestamp(entryTime.getTime())));//currentStatusSince
            issueParameters.addElement(new StringValue("UL"));//assignedById 
            issueParameters.addElement(new StringValue(unitId));//unit_id
            issueParameters.addElement(new StringValue(businessID));
            issueParameters.addElement(new StringValue((calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR)));
            issueParameters.addElement(new StringValue(extract.getAttribute("callType").toString()));// call type

            String issueStatusId = UniqueIDGen.getNextID();
            statusParameters.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            statusParameters.addElement(new StringValue("1"));
            statusParameters.addElement(new StringValue("Opened"));
            statusParameters.addElement(new StringValue("UL"));
            statusParameters.addElement(new TimestampValue(new java.sql.Timestamp(entryTime.getTime())));
            statusParameters.addElement(new StringValue("0"));
            statusParameters.addElement(new StringValue("UL"));
            statusParameters.addElement(new StringValue("UL"));
            statusParameters.addElement(new StringValue("UL"));
            statusParameters.addElement(new StringValue(issueId));
            statusParameters.addElement(new StringValue("issue"));
            statusParameters.addElement(new StringValue("0"));
            statusParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            // saving issue data
            forInsert.setSQLQuery(getQuery("insertIssueProcurement").trim());
            forInsert.setparams(issueParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssueStatus").trim());
            forInsert.setparams(statusParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex1);
            }
            return null;
        } catch (ParseException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                extract.setAttribute("issueId", issueId);
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if (queryResult > 0) {
            return issueId;
        } else {
            return null;
        }
    }

    public void addBusinessItm(String issueId, String itmID, int hours, int total, String comment, String loggegUserId, String busObjID) {
        try {
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            int queryResult = -1000;

            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(issueId));
            params.addElement(new StringValue(itmID));
            params.addElement(new IntValue(hours));
            params.addElement(new IntValue(total));
            params.addElement(new StringValue(busObjID));
            params.addElement(new StringValue(comment));
            params.addElement(new StringValue(loggegUserId));
            params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));

            Connection connection = dataSource.getConnection();
            try {
                forInsert.setConnection(connection);
                forInsert.setSQLQuery(getQuery("addBusinessItm").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            } catch (SQLException se) {
                throw se;
            } finally {

                connection.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public ArrayList<WebBusinessObject> getBusItmLst(String issueID, String busObjID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(issueID));
        parameters.addElement(new StringValue(busObjID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getBusItmLst"));
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
            for (Row row : query) {
                wbo = fabricateBusObj(row);
                if (row.getString("ID") != null) {
                    wbo.setAttribute("itmID", row.getString("ID"));
                }
                if (row.getString("TOTAL") != null) {
                    wbo.setAttribute("total", row.getString("TOTAL"));
                }
                if (row.getString("NOTE") != null) {
                    wbo.setAttribute("note", row.getString("NOTE"));
                }
                if (row.getString("EQ_NO") != null) {
                    wbo.setAttribute("code", row.getString("EQ_NO"));
                }
                if (row.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("prjName", row.getString("PROJECT_NAME"));
                }
                if (row.getString("OPTION_THREE") != null) {
                    wbo.setAttribute("option3", row.getString("OPTION_THREE"));
                }
                if (row.getString("HOUR_NUM") != null) {
                    wbo.setAttribute("hourNum", row.getString("HOUR_NUM"));
                }
                wbo.setAttribute("creationTime", row.getString("CREATION_TIME"));
                wbo.setAttribute("creatorName", row.getString("FULL_NAME"));
                result.add(wbo);
            }
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    public String getComStatus(String issueID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(issueID));
        parameters.addElement(new StringValue(issueID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getComStatus"));
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }
        String result = new String();
        try {
            for (Row row : query) {
                if (row.getString("CURRENT_STATUS") != null) {
                    result = row.getString("CURRENT_STATUS");
                }
            }
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    public void deleteBusinessItm(String itmID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(itmID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("deleteBusinessItm"));
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }
    }

    public WebBusinessObject jobOrderInfo(String issueId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = new Vector<Row>();
        Vector parameters = new Vector();
        WebBusinessObject data = null;

        parameters.addElement(new StringValue(issueId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("jobOrderInfo"));
            result = command.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }

        for (Row row : result) {
            try {
                data = fabricateBusObj(row);
                data.setAttribute("creationTime", row.getString("CREATION_TIME"));
                data.setAttribute("creatorName", row.getString("FULL_NAME"));
                data.setAttribute("oUsr", row.getString("oUsr"));
                data.setAttribute("status", row.getString("CASE_EN"));
                data.setAttribute("busID", row.getString("BUSINESS_ID"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public String generateComplaintNo(HttpServletRequest request, HttpSession s, String objType) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String clientPhone = null;
        String comments = null;

        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

//        if (request.getParameter("phone")!= null && !request.getParameter("comments").equals("")) {
//            clientPhone = request.getParameter("phone").toString();
//        } else {
        clientPhone = "123456789";
//        }

        if (request.getParameter("comments") != null && !request.getParameter("comments").equals("")) {
            comments = request.getParameter("comments").toString();
        } else {
            comments = "none";
        }
        String note = "none";
        if (request.getParameter("note") != null && !request.getParameter("note").equals("")) {
            note = (String) request.getParameter("note");
        }

        java.util.Date date = new java.util.Date();
        DateFormat df = new SimpleDateFormat("yyyy/MM/dd hh:mm");
        java.sql.Timestamp entryTime = null;
        String entDate = request.getParameter("entryDate").toString();
        String[] arDate = entDate.split(" ");
        entDate = arDate[0].replace("-", "/") + " " + arDate[1];

        try {
            entryTime = new java.sql.Timestamp(df.parse(entDate).getTime());
        } catch (ParseException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
//        String entryDate = df.format(date);
//        DateParser dateParser = new DateParser();
        //request.getParameter("entryDate")
//        java.sql.Date entryDate = dateParser.formatSqlDate("2013/03/23");
        Vector params = new Vector();
        Vector statusParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
//        String clientNoByDate = null;
        String issueId = UniqueIDGen.getNextID();

        params.addElement(new StringValue(issueId));
        //issueTitle
        params.addElement(new StringValue(clientPhone));
        //projectName
        params.addElement(new StringValue("ay 7aga "));
        //fa_id

        //issueType
        params.addElement(new StringValue(note));
        //userId
        params.addElement(new StringValue("279"));
        //urgencyId
        params.addElement(new StringValue(request.getParameter("clientId")));
        //issueDesc
        params.addElement(new StringValue(note));
        //SYSDATE

        //currentStatus
        params.addElement(new StringValue("1"));

        //currentStatusSince
        params.addElement(new TimestampValue(
                new java.sql.Timestamp(entryTime.getTime())));

        //assignedById        
        params.addElement(new StringValue(comments));

        //unit_id
        params.addElement(new StringValue("1225014080921"));

        params.addElement(new StringValue(sequenceMgr.getSequence()));
        params.addElement(new StringValue(
                (calendar.get(Calendar.MONTH) + 1)
                + "/" + calendar.get(Calendar.YEAR)));
        // call_type
        params.addElement(new StringValue(request.getParameter("call_status")));

        String issueStatusId = UniqueIDGen.getNextID();
        statusParams.addElement(new StringValue(issueStatusId));
        // 1 mean received from Issue // 2 mean sent from complaint //
        statusParams.addElement(new StringValue("1"));
        statusParams.addElement(new StringValue("Opened"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new TimestampValue(new java.sql.Timestamp(entryTime.getTime())));
        statusParams.addElement(new StringValue("0"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue("UL"));
        statusParams.addElement(new StringValue(issueId));
        statusParams.addElement(new StringValue(objType));
        statusParams.addElement(new StringValue("0"));
        statusParams.addElement(new StringValue("279"));

        //Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            forInsert.setSQLQuery(sqlMgr.getSql("saveIssueStatus").trim());
            forInsert.setparams(statusParams);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;

        } finally {
            request.setAttribute("issueId", issueId);
            endTransaction();
        }

        if (queryResult > 0) {
            return issueId;
        } else {
            return null;
        }
    }

    public boolean updateSpareAmnt(String spareID, String amnt) {
        SQLCommandBean updateCommand = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int queryResult = -1000;
        parameters.addElement(new StringValue(amnt));
        parameters.addElement(new StringValue(spareID));
        try {
            connection = dataSource.getConnection();
            updateCommand.setConnection(connection);
            updateCommand.setSQLQuery(getQuery("updateSpareAmnt").trim());
            updateCommand.setparams(parameters);
            queryResult = updateCommand.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return queryResult > 0;
    }

    public boolean addWithdrawInfo(String drawerID, ArrayList<WebBusinessObject> distributionsList, WebBusinessObject clientWbo, WebBusinessObject loggerWbo) {
        SQLCommandBean updateCommand = new SQLCommandBean();
        Connection connection = null;
        Vector parameters;
        int queryResult = -1000;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            updateCommand.setConnection(connection);
            updateCommand.setSQLQuery(getQuery("addWithdrawInfo").trim());
            for (WebBusinessObject distributionwbo : distributionsList) {
                parameters = new Vector();
                parameters.addElement(new StringValue(UniqueIDGen.getNextID()));
                parameters.addElement(new StringValue(drawerID));
                parameters.addElement(new StringValue((String) distributionwbo.getAttribute("receipId")));
                parameters.addElement(new StringValue((String) clientWbo.getAttribute("id")));
                parameters.addElement(new StringValue(clientWbo.getAttribute("mobile") != null ? (String) clientWbo.getAttribute("mobile") : "UL"));
                parameters.addElement(new StringValue(clientWbo.getAttribute("phone") != null ? (String) clientWbo.getAttribute("phone") : "UL"));
                parameters.addElement(new StringValue(clientWbo.getAttribute("interPhone") != null ? (String) clientWbo.getAttribute("interPhone") : "UL"));
                updateCommand.setparams(parameters);
                queryResult = updateCommand.executeUpdate();
                if (queryResult <= 0) {
                    connection.rollback();
                    return false;
                }
            }
            // for logging
            updateCommand.setSQLQuery(sqlMgr.getSql("insertLog").trim());
            parameters = new Vector();
            parameters.addElement(new StringValue(UniqueIDGen.getNextID()));
            parameters.addElement(new StringValue(loggerWbo.getAttribute("objectTypeId").toString()));
            parameters.addElement(new StringValue(loggerWbo.getAttribute("eventTypeId").toString()));
            parameters.addElement(new StringValue(loggerWbo.getAttribute("userId").toString()));
            parameters.addElement(new StringValue(loggerWbo.getAttribute("objectName").toString()));
            parameters.addElement(new StringValue(loggerWbo.getAttribute("eventName").toString()));
            parameters.addElement(new StringValue(loggerWbo.getAttribute("loggerMessage").toString()));
            parameters.addElement(new StringValue(loggerWbo.getAttribute("objectXml").toString()));
            parameters.addElement(new StringValue(loggerWbo.getAttribute("realObjectId").toString()));
            parameters.addElement(new StringValue((String) loggerWbo.getAttribute("ipForClient"))); //unused field
            updateCommand.setparams(parameters);
            queryResult = updateCommand.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return false;
            }
            connection.commit();
            connection.setAutoCommit(true);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
                    return false;
                }
            }
        }
        return queryResult > 0;
    }

    public ArrayList<WebBusinessObject> getWithdraw(String oUsrID, String from, String to) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();

        if (oUsrID != null && !oUsrID.isEmpty()) {
            parameters.addElement(new StringValue(oUsrID));
            parameters.addElement(new StringValue(oUsrID));
            where.append(" WHERE (WD.ORIGINAL_USER_ID = ? OR WD.DRAWER_ID = ?) ");
        }

        if (from != null) {
            if (where != null && where.length() > 0) {
                where.append(" AND ");
            } else {
                where.append(" WHERE ");
            }

            parameters.addElement(new StringValue(from));
            where.append(" TRUNC(WIHDRAW_TIME) >= to_date(?,'YYYY/MM/DD') ");
        }

        if (to != null) {
            if (where != null && where.length() > 0) {
                where.append(" AND ");
            } else {
                where.append(" WHERE ");
            }

            parameters.addElement(new StringValue(to));
            where.append(" TRUNC(WIHDRAW_TIME) <= to_date(?,'YYYY/MM/DD')");
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getWithdraw") + where.toString());
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
            for (Row row : query) {
                wbo = fabricateBusObj(row);
                if (row.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clntID", row.getString("CLIENT_ID"));
                }

                if (row.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("clientNo", row.getString("CLIENT_NO"));
                }

                if (row.getString("NAME") != null) {
                    wbo.setAttribute("clientName", row.getString("NAME"));
                }

                if (row.getString("CLIENT_MOBILE") != null) {
                    wbo.setAttribute("mobile", row.getString("CLIENT_MOBILE"));
                }

                if (row.getString("CLIENT_PHONE") != null) {
                    wbo.setAttribute("phone", row.getString("CLIENT_PHONE"));
                }

                if (row.getString("CLIENT_INTER_PHONE") != null) {
                    wbo.setAttribute("interPhone", row.getString("CLIENT_INTER_PHONE"));
                }

                if (row.getString("OWNER") != null) {
                    wbo.setAttribute("owner", row.getString("OWNER"));
                }

                if (row.getString("WITHDRAWED_BY") != null) {
                    wbo.setAttribute("withdrawedBy", row.getString("WITHDRAWED_BY"));
                }

                if (row.getString("WIHDRAW_TIME") != null) {
                    wbo.setAttribute("withdrawedTime", row.getString("WIHDRAW_TIME"));
                }

                if (row.getString("RATE_NAME") != null) {
                    wbo.setAttribute("rateName", row.getString("RATE_NAME"));
                }

                result.add(wbo);
            }
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    public ArrayList<WebBusinessObject> getWithdrawTl(String oUsrID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(oUsrID));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getWithdrawTl"));
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
            for (Row row : query) {
                wbo = fabricateBusObj(row);
                if (row.getString("CUSTOMER_ID") != null) {
                    wbo.setAttribute("clntID", row.getString("CUSTOMER_ID"));
                }

                if (row.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("clientNo", row.getString("CLIENT_NO"));
                }

                if (row.getString("NAME") != null) {
                    wbo.setAttribute("clientName", row.getString("NAME"));
                }

                if (row.getString("CLIENT_MOBILE") != null) {
                    wbo.setAttribute("mobile", row.getString("CLIENT_MOBILE"));
                }

                if (row.getString("CLIENT_PHONE") != null) {
                    wbo.setAttribute("phone", row.getString("CLIENT_PHONE"));
                }

                if (row.getString("INTER_PHONE") != null) {
                    wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                }

                if (row.getString("FULL_NAME") != null) {
                    wbo.setAttribute("owner", row.getString("FULL_NAME"));
                }

                if (row.getString("SENDER_NAME") != null) {
                    wbo.setAttribute("withdrawedBy", row.getString("SENDER_NAME"));
                }

                if (row.getString("ENTRY_DATE") != null) {
                    wbo.setAttribute("withdrawedTime", row.getString("ENTRY_DATE"));
                }

		//if (row.getString("RATE_NAME") == null) {
                //    wbo.setAttribute("rateName", "0");
                //} 
                result.add(wbo);
            }
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    public ArrayList<WebBusinessObject> getEmployeesClientsWithdraw(String oUsrID, String from, String to, String sender, String recipe) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();

        if (oUsrID != null && !oUsrID.isEmpty()) {
            parameters.addElement(new StringValue(oUsrID));
            where.append(" AND WD.ORIGINAL_USER_ID = ? ");
        }

        if (sender != null && !sender.isEmpty() && !sender.equalsIgnoreCase("all")) {
            parameters.addElement(new StringValue(sender));
            where.append(" AND  WD.ORIGINAL_USER_ID= ? ");
        }

        if (recipe != null && !recipe.isEmpty() && !recipe.equalsIgnoreCase("all")) {
            parameters.addElement(new StringValue(recipe));
            where.append(" AND  WD.DRAWER_ID= ? ");
        }

        if (from != null) {
            where.append(" AND ");

            parameters.addElement(new StringValue(from));
            where.append(" TRUNC(WIHDRAW_TIME) >= to_date(?,'YYYY/MM/DD') ");
        }

        if (to != null) {
            where.append(" AND ");

            parameters.addElement(new StringValue(to));
            where.append(" TRUNC(WIHDRAW_TIME) <= to_date(?,'YYYY/MM/DD')");
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getEmployeesClientsWithdraw") + where.toString());
            query = forQuery.executeQuery();
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
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
            for (Row row : query) {
                wbo = fabricateBusObj(row);
                if (row.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clntID", row.getString("CLIENT_ID"));
                }

                if (row.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("clientNo", row.getString("CLIENT_NO"));
                }

                if (row.getString("NAME") != null) {
                    wbo.setAttribute("clientName", row.getString("NAME"));
                }

                if (row.getString("CLIENT_MOBILE") != null) {
                    wbo.setAttribute("mobile", row.getString("CLIENT_MOBILE"));
                }

                if (row.getString("CLIENT_PHONE") != null) {
                    wbo.setAttribute("phone", row.getString("CLIENT_PHONE"));
                }

                if (row.getString("CLIENT_INTER_PHONE") != null) {
                    wbo.setAttribute("interPhone", row.getString("CLIENT_INTER_PHONE"));
                }

                if (row.getString("OWNER") != null) {
                    wbo.setAttribute("owner", row.getString("OWNER"));
                }

                if (row.getString("WITHDRAWED_BY") != null) {
                    wbo.setAttribute("withdrawedBy", row.getString("WITHDRAWED_BY"));
                }

                if (row.getString("WIHDRAW_TIME") != null) {
                    wbo.setAttribute("withdrawedTime", row.getString("WIHDRAW_TIME"));
                }

                result.add(wbo);
            }
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    public boolean deleteWithdraw(String customerId) {
        SQLCommandBean command = new SQLCommandBean();

        Vector parameters = new Vector();

        parameters.addElement(new StringValue(customerId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(getQuery("deleteWithdraw"));
            command.setparams(parameters);
            command.executeUpdate();
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException sq) {
                logger.error("Close Error " + sq.getMessage());
            }
            logger.error(ex.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
                return false;
            }
        }
        return (true);
    }

    public boolean deleteAllFutureAppointments(String[] clientIds, String employeeId) {
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(employeeId));

        StringBuilder cond = new StringBuilder();
        if (clientIds != null && clientIds.length != 0) {
            for (int i = 0; i < clientIds.length; i++) {
                if (i == 0) {
                    cond.append("'").append(clientIds[i]).append("'");
                } else {
                    cond.append(",'").append(clientIds[i]).append("'");
                }
            }
        }

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(getQuery("deleteAllFutureAppointments").replace("CLIENTIDS", cond));
            command.setparams(parameters);
            command.executeUpdate();
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException sq) {
                logger.error("Close Error " + sq.getMessage());
            }
            logger.error(ex.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
                return false;
            }
        }
        return (true);
    }
    
     public Connection getConnection() {
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
        } catch (SQLException ex) {
            logger.getLogger(IssueMgr.class.getName()).log(org.apache.log4j.Level.WARN, null, ex);
        }
        return connection;
    }

    private String[] commentsTitle = new String[]{"المرجعة الأولى", "المراجعة الثانية", "المرجعة الثالثة"};
}
