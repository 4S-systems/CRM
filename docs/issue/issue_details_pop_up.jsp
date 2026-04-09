<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%@ page import="com.tracker.common.*,com.silkworm.util.*,com.maintenance.db_access.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*"%>
<%
String ScheduleUnitId=null;
UserMgr userMgr = UserMgr.getInstance();
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
String context = metaMgr.getContext();
IssueMgr issueMgr=IssueMgr.getInstance();
ImageMgr imageMgr = ImageMgr.getInstance();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebIssue webIssue = (WebIssue) request.getAttribute("wbo");
ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
SupplierMgr supplierMgr = SupplierMgr.getInstance();
Vector vecExternal = externalJobMgr.getOnArbitraryKey((String) webIssue.getAttribute("id"), "key2");
String jobType = webIssue.getAttribute("issueType").toString();
String groupbyShift =(String) webIssue.getAttribute("faId") ;
String group= groupbyShift.substring(0,1);
String shift = groupbyShift.substring(2);
Vector vec=new Vector();


webIssue.printSelf();
WebBusinessObject viewOrigin = webIssue.getViewOrigin();
// viewOrigin.printSelf();
String equipmentID = (String) request.getAttribute("equipmentID");
String projectname = (String) request.getAttribute("projectName");
String MaintenanceTitle = (String) request.getAttribute("mainTitle");

ScheduleUnitId=issueMgr.getScheduleUnitId((String) webIssue.getAttribute("id"));
if(MaintenanceTitle == null){
    MaintenanceTitle= issueMgr.getUnitName(ScheduleUnitId);
}

if(MaintenanceTitle == null){
    MaintenanceTitle="No found Title";
}

String FinishTime = (String) webIssue.getAttribute("finishedTime");
String createdBy = (String) webIssue.getAttribute("userId");

String AssignByName=(String) webIssue.getAttribute("assignedByName");
//String AssignToName=(String) issueMgr.getTechName(webIssue.getAttribute("techName").toString());
String Receivedby = (String) issueMgr.getTechName((String)webIssue.getAttribute("receivedby"));
String FailureCode = (String) issueMgr.getFailureCode((String)webIssue.getAttribute("failureCode"));
String UrgencyLevel = (String) issueMgr.getUrgencyLevel((String)webIssue.getAttribute("urgencyId"));
String SiteName = (String) issueMgr.getSiteName(webIssue.getAttribute("projectName").toString());
if(SiteName==null)
    SiteName=request.getAttribute("siteName").toString();
System.out.println("projectName  "+MaintenanceTitle);
String currentStatus = new String("");
if(webIssue.getAttribute("currentStatus") != null){
    currentStatus = (String) webIssue.getAttribute("currentStatus");
}




WebBusinessObject tradeIssueWbo = new WebBusinessObject();
tradeIssueWbo =  tradeMgr.getOnSingleKey(webIssue.getAttribute("workTrade").toString());

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align="center";
String dir=null;
String style=null;
String back = "back";
String lang,langCode,BackToList,viewDetails,indGuid,viewOP,plusOp,MNumber,jobFor,RcievedBy,Workorder,ViewMaintenance,
        Failure_Code,Site_Name,Urgency_Level,Estimated_Duration,Job_Type,CreatedBy,current_status,
        creationTime,assignedby,Problem_Description,finishedtime,expectededate,expectedB,schduled, sConversionDate, sConversionReason,
        Begined,Finished,Canceled,Holded,Rejected,Edite,add_task,attach_file,noFiles,view_spar,View_task, sAddWorkers, sWorkersReport, sCantChange, sExternalMessage, sReceivedBY,
        View_file,View_hist,View_jop,status,viewEquipment,excel,groupname,shiftname, sChangeDateHistory, sChangeExternal,addJobTeam,addInstructions,addTaskbyJob,addParts,itemStore,
        sCantAddTask, sCantAddPart, sCantAddWorkers, sStoreRequest,sTransactionList;
if(stat.equals("En")){
    
    
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    excel="Excel";
    BackToList = "Back to list";
    indGuid=" Indicators guide ";
    viewDetails="View task details";
    plusOp= "Addition Operations";
    viewOP=" Viewing Operations";
    MNumber="Job Order Number";
    jobFor="Job Order for machine";
    RcievedBy="Received by";
    Workorder="Work Order Trade";
    Failure_Code="Failure Code";
    Site_Name=" Site Name";
    Urgency_Level="Urgency Level";
    Estimated_Duration=" Estimated Duration/Hours " ;
    Job_Type ="Job Type";
    CreatedBy="Created By";
    current_status=" Current Status";
    creationTime="Creation Time";
    assignedby="Assinged By";
    Problem_Description="Problem Description";
    finishedtime="Finished Time/hours ";
    expectededate="Expected Finish Date";
    expectedB="Expected Begine Date";
    schduled="Scheduled";
    Begined="Started";
    Finished="Finished";
    Canceled="Canceled";
    Holded="on Hold";
    Rejected="Rejected";
    Edite ="Edit";
    add_task="Adding Maintenance Item";
    sCantAddTask = "Can't Add Maintenance Item";
    attach_file="Attaching File";
    noFiles="No Attached Files";
    view_spar="View Spare parts";
    View_task="View Task";
    View_file="View Attached Files";
    View_hist="View task history";
    View_jop="View Jop order";
    status="Status";
    viewEquipment = "View Equipment";
    groupname = "Group";
    shiftname = "Shift";
    sChangeDateHistory = "Change Date History";
    sChangeExternal = "Change to External";
    addJobTeam="Add Job Team";
    addInstructions="Add Instructions for Task";
    addTaskbyJob="Add Jobs For Task";
    sAddWorkers = "Add Workers";
    sCantAddWorkers = "Can't Add Workers";
    ViewMaintenance="View Maintenance Items & Jops";
    sWorkersReport = "Workers Report";
    sCantChange = "Can not Change";
    addParts="Add Spare Parts";
    sCantAddPart = "Can't Add Spare Parts";
    sExternalMessage = "This Job Order has been changed External";
    sReceivedBY="To Importer";
    sConversionDate = "Conversion Date";
    sConversionReason = "Conversion Reason";
    itemStore="Items Store Request";
    sStoreRequest = "Request from the Store";
    sTransactionList="View Transaction Status";
}else{
    
    
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    excel="&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
    
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    viewDetails="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    indGuid= "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    plusOp="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1577;";
    viewOP="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
    MNumber = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    jobFor="&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1605;&#1593;&#1583;&#1577;";
    RcievedBy="&#1571;&#1587;&#1578;&#1604;&#1605; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
    Workorder="&#1606;&#1608;&#1593; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    Failure_Code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604;";
    Site_Name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    Urgency_Level="&#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1610;&#1577;";
    Estimated_Duration=" &#1575;&#1604;&#1605;&#1583;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1577; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1577; ";
    Job_Type ="&#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;";
    CreatedBy="&#1571;&#1606;&#1588;&#1571;&#1578; &#1576;&#1608;&#1575;&#1587;&#1591;&#1607;";
    current_status=" &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;";
    creationTime="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1575;&#1606;&#1588;&#1575;&#1569;";
    assignedby="&#1587;&#1604;&#1605; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
    Problem_Description="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;";
    finishedtime=" &#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1607;";
    expectededate="&#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    expectedB="&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; &#1604;&#1604;&#1576;&#1583;&#1610;&#1607;";
    schduled="&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
    Begined="&#1576;&#1583;&#1571;&#1578;";
    Finished="&#1573;&#1606;&#1578;&#1607;&#1578;";
    Canceled="&#1605;&#1604;&#1594;&#1575;&#1577;";
    Holded="&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
    Rejected="&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
    Edite ="&#1578;&#1581;&#1585;&#1610;&#1585;";
    add_task="&#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; ";
    sCantAddTask = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607;";
    attach_file="&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
    noFiles="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
    view_spar="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    View_task="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    View_file="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
    
    View_jop="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    View_hist=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582; ";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    viewEquipment = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    groupname ="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    shiftname = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1577;";
    sChangeDateHistory = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
    sChangeExternal = "&#1578;&#1581;&#1608;&#1610;&#1604; &#1582;&#1575;&#1585;&#1580;&#1609;";
    addJobTeam="&#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1607;&#1606; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    addInstructions="&#1573;&#1590;&#1575;&#1601;&#1577; &#1573;&#1585;&#1588;&#1575;&#1583;&#1575;&#1578; &#1604;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    addTaskbyJob="&#1573;&#1590;&#1575;&#1601;&#1577; &#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1605;&#1607;&#1606; &#1604;&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    sAddWorkers = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1593;&#1605;&#1575;&#1604;&#1577;";
    sCantAddWorkers = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1573;&#1590;&#1575;&#1601;&#1577; &#1593;&#1605;&#1575;&#1604;&#1577;";
    ViewMaintenance="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    sWorkersReport = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
    sCantChange = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
    addParts="&#1573;&#1590;&#1575;&#1601;&#1577; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    sCantAddPart = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1573;&#1590;&#1575;&#1601;&#1577; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    sExternalMessage = "&#1578;&#1605; &#1578;&#1581;&#1608;&#1610;&#1604; &#1607;&#1584;&#1575; &#1575;&#1604;&#1571;&#1605;&#1585; &#1582;&#1575;&#1585;&#1580;&#1610;&#1575;&#1611;";
    sReceivedBY=" &#1604;&#1604;&#1605;&#1608;&#1585;&#1583;";
    sConversionDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
    sConversionReason = "&#1587;&#1576;&#1576; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
    itemStore = "&#1591;&#1604;&#1576; &#1589;&#1585;&#1601; &#1605;&#1582;&#1575;&#1586;&#1606;";
    sStoreRequest = "&#1571;&#1591;&#1604;&#1576; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
    sTransactionList = "&#1593;&#1585;&#1590; &#1581;&#1575;&#1604;&#1577; &#1591;&#1604;&#1576;&#1575;&#1578; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
}
// AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
%>
<br>
<%
if(webIssue.getAttribute("scheduleType").equals("External")){
%>
<DIV STYLE="text-align:center; font-size:30px; color:#ff0000;">
    <%=sExternalMessage%>
</DIV>
<BR>
<%
}
%>
<TABLE ALIGN="RIGHT" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
    <%
    Long iID = new Long(webIssue.getAttribute("id").toString());
    
    //String sID = webIssue.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
    %>
    <%
    if(webIssue.getAttribute("scheduleType").equals("External")){
        if(vecExternal.size() > 0){
            WebBusinessObject wboExternal = (WebBusinessObject) vecExternal.get(0);
            WebBusinessObject wboSupplier = supplierMgr.getOnSingleKey((String) wboExternal.getAttribute("supplierID"));
    %>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><font color="#003499"><%=sReceivedBY%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="receivedby" ID="receivedby" size="20" value="<%=wboSupplier.getAttribute("name")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>"  class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><font color="#003499"> <%=sConversionDate%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <input disabled type="TEXT" name="conversionDate" ID="conversionDate" size="20" value="<%=wboExternal.getAttribute("conversionDate")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><font color="#003499"><%=sConversionReason%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <TEXTAREA disabled rows="5" cols="27" name="reason" ID="reason"><%=wboExternal.getAttribute("reason")%>"</TEXTAREA>
            <BR><BR>
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>"  class='td' COLSPAN="2">
            <hr size="3px" width="100%" noshade style="color:red;">
        </TD>
    </TR>
    <%
        }
    }
    %>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><font color="#003499"><%=MNumber%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="id" ID="id" size="20" value="<%= (String) webIssue.getAttribute("businessID")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>"  class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><font color="#003499"> <%=jobFor%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <input disabled type="TEXT" name="issueTitle" ID="issueTitle" size="20" value="<%=MaintenanceTitle%>" maxlength="255">
        </TD>
    </TR>
    <TR>     
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><font color="#003499"><%=Workorder%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="workTrade" ID="workTrade" size="20" value="<%= (String) tradeIssueWbo.getAttribute("tradeName")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><font color="#003499"><%=Failure_Code%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="title" ID="title" size="20" value="<%=FailureCode%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="Project_Name">
                <p><b><font color="#003499"><%=Site_Name%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="projectName" ID="projectName" size="20" value="<%=SiteName%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>"  class='td'>
            <LABEL FOR="Project_Name">
                <p><b><font color="#003499"><%=Urgency_Level%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <input disabled type="TEXT" name="urgencyLevel" ID="urgencyLevel" size="20" value="<%=UrgencyLevel%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>"  class='td'>
            <LABEL FOR="estimated_duration">
                <p><b><font color="#003499"><%=Estimated_Duration%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="estimatedduration" ID="estimatedduration" size="20" value="<%= (String) webIssue.getAttribute("estimatedduration")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_IssueType_Name">
                <p><b><font color="#003499"><%=Job_Type%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="issueId" ID="typeName" size="20" value="<%= (String) webIssue.getAttribute("issueType")%>" maxlength="255">
        </TD>
        
    </TR>
    <% if(jobType.equals("Emergency")) {
    %>
    <TR>
        
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="Project_Name">
                <p><b><font color="#003499"><%=groupname%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="group" ID="group" size="20" value="<%=group%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>"  class='td'>
            <LABEL FOR="Project_Name">
                <p><b><font color="#003499"><%=shiftname%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <input disabled type="TEXT" name="shift" ID="shift" size="20" value="<%=shift%>" maxlength="255">
        </TD>
    </TR>
    <% } %>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_IssueType_Name">
                <p><b><font color="#003499"><%=CreatedBy%></font></b>&nbsp;
            </LABEL>
        </TD>
        <% WebBusinessObject wboUser = new WebBusinessObject();
            wboUser = userMgr.getOnSingleKey(createdBy);
            %>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="createdBy" ID="createdBy" size="20" value="<%= (String) wboUser.getAttribute("userName")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_current_status">
                <p><b><font color="#003499"><%=current_status%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="currentStatus" ID="currentStatus" size="20" value="<%= (String) webIssue.getAttribute("currentStatus")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_creation_time">
                <p><b><font color="#003499"><%=creationTime%> </font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="CREATION_TIME" ID="CREATION_TIME" size="20" value="<%= (String) webIssue.getAttribute("currentStatusSince")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="EXPECTED_B_DATE">
                <p><b><font color="#003499"><%=expectedB%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="expectedBeginDate" ID="expectedBeginDate" size="20" value="<%= (String) webIssue.getAttribute("expectedBeginDate")%>" maxlength="255">
        </TD>
    </TR>
    <TR>
        
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_assigned_by">
                <p><b><font color="#003499"><%=assignedby%></font></b>&nbsp;
            </LABEL>
        </TD>
        <%
        if(! AssignByName.equals("UL")){
        
        %>
        <TD STYLE="<%=style%>" class='td'>   -->
            <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="20" value="<%=AssignByName%>" maxlength="255">
        </TD>
        <% } else {
        AssignByName="Not assigned";
        %>
        <TD STYLE="<%=style%>" class='td'>   
            <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="20" value="<%=AssignByName%>" maxlength="255">
            <% } %>
            
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="EXPECTED_E_DATE">
                <p><b><font color="#003499"><%=expectededate%></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="expectedEndDate" ID="expectedEndDate" size="20" value="<%= (String) webIssue.getAttribute("expectedEndDate")%>" maxlength="255">
        </TD>
        
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_finshed_time">
                <p><b><font color="#003499"><%=finishedtime%></font></b>&nbsp;
            </LABEL>
        </TD>
        <%
        if(! FinishTime.equals("0")){
        %>
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="finishedTime" ID="finishedTime" size="20" value="<%=FinishTime%>" maxlength="255">
        </TD>
        
        <% }else {
        FinishTime="Has not been specified ";  
        
        %>
        
        <TD STYLE="<%=style%>" class='td'>
            <input disabled type="TEXT" name="finishedTime" ID="finishedTime" size="20" value="<%=FinishTime%>" maxlength="255">
        </TD>
    </TR>
    <% } %>
    
    <TR>
        
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Maintenance_Desc">
                <p><b><font color="#003499"><%=Problem_Description%></font> </b>&nbsp;
            </LABEL>
        </TD>
        <TD class='td'>
            <TEXTAREA disabled rows="5" name="issueDesc" cols="16"> <%= (String) webIssue.getAttribute("issueDesc")%></TEXTAREA>
        </TD>
        
    </TR>
</TABLE>
</BODY>
</HTML>     

