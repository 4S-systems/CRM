<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%@ page import="com.tracker.common.*,com.silkworm.util.*,com.maintenance.db_access.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*"%>

<HTML>

<%

String ScheduleUnitId=null;
UserMgr userMgr = UserMgr.getInstance();
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
String context = metaMgr.getContext();
IssueMgr issueMgr=IssueMgr.getInstance();
ImageMgr imageMgr = ImageMgr.getInstance();


String issueStatus = (String) request.getAttribute("status");
String filterName = (String) request.getAttribute("filterName");
String filterValue = (String) request.getAttribute("filterValue");


String filterBack="ListDoc";
//IssueMgr issueMgr = IssueMgr.getInstance();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebIssue webIssue = (WebIssue) request.getAttribute("webIssue");
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



WebBusinessObject web=new WebBusinessObject() ;
web.setAttribute("equipmentID",equipmentID);
web.setAttribute("MaintenanceTitle",MaintenanceTitle);
web.setAttribute("FinishTime",FinishTime);
web.setAttribute("createdBy",createdBy);
web.setAttribute("AssignByName",AssignByName);
web.setAttribute("FailureCode",FailureCode);
web.setAttribute("UrgencyLevel",UrgencyLevel);
web.setAttribute("SiteName",SiteName);
vec.add(web);

request.getSession().setAttribute("infor", vec);

WebBusinessObject tradeIssueWbo = new WebBusinessObject();
tradeIssueWbo =  tradeMgr.getOnSingleKey(webIssue.getAttribute("workTrade").toString());
String url=context+"/SearchServlet?op="+filterName+"&filterValue="+filterValue+"&projectName="+projectname;
if(session.getAttribute("case")!=null){
    
    url=context+"/SearchServlet?op=StatusProjctListTitle&filterValue="+filterValue+"&projectName="+projectname+"&case=case39&unitName="+(String)session.getAttribute("unitName")+"&title="+(String)session.getAttribute("title");
}


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
    MNumber="Mainttenance number";
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
    MNumber="&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
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

	WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

	GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>DebugTracker-Schedule detail</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>
<style type="text/css"> 
  
.tabs {position:relative; left: 5; top: 3; border:1px solid #194367; height: 50px; width: 750; margin: 0; padding: 0; background:#C0D9DE; overflow:hidden; } 
.tabs li {display:inline} 
.tabs a:hover, .tabs a.tab-active {background:#fff;} 
.tabs a { height: 27px; font:11px verdana, helvetica, sans-serif;font-weight:bold; 
       position:relative; padding:6px 10px 10px 10px; margin: 0px -4px 0px 0px; color:#2B4353;text-decoration:none; } 
.tab-container { background: #fff; border:0px solid #194367; height:320px; width:500px} 
.tab-panes { margin: 3px; border:1px solid #194367; height:320px} 
div.content { padding: 5px; } 
    
</style>
<script language="JavaScript1.3"> 
var panes = new Array(); 

function setupPanes(containerId, defaultTabId) { 
     // go through the DOM, find each tab-container 
     // set up the panes array with named panes 
     panes[containerId] = new Array(); 
     var maxHeight = 0; var maxWidth = 0; 
     var container = document.getElementById(containerId); 
     var paneContainer = container.getElementsByTagName("div")[0]; 
     var paneList = paneContainer.childNodes; 
     for (var i=0; i < paneList.length; i++ ) { 
       var pane = paneList[i]; 
       if (pane.nodeType != 1) continue; 
       panes[containerId][pane.id] = pane; 
       pane.style.display = "none"; 
    } 
     document.getElementById(defaultTabId).onclick(); 
} 

function showPane(paneId, activeTab) { 
     // make tab active class 
     // hide other panes (siblings) 
     // make pane visible 

     for (var con in panes) { 
       activeTab.blur(); 
       activeTab.className = "tab-active"; 
       if (panes[con][paneId] != null) { // tab and pane are members of this container 
         var pane = document.getElementById(paneId); 
         pane.style.display = "block"; 
         var container = document.getElementById(con); 
         var tabs = container.getElementsByTagName("ul")[0]; 
         var tabList = tabs.getElementsByTagName("a") 
         for (var i=0; i < tabList.length; i++ ) { 
           var tab = tabList[i]; 
           if (tab != activeTab) tab.className = "tab-disabled"; 
         } 
         for (var i in panes[con]) { 
           var pane = panes[con][i]; 
           if (pane == undefined) continue; 
           if (pane.id == paneId) continue; 
           pane.style.display = "none" 
         } 
       } 
     } 
       return false; 
} 
</script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
     
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
           function changePage(url){
                window.navigate(url);
            }
             function reloadAE(nextMode){
      
       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFillreload;
            req.send(null);
      
      }

       function callbackFillreload(){
         if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                     window.location.reload();
                }
            }
       }
       function cancelForm()
        {    
        document.ISSUE_DETAIL_FORM.action = "<%=url%>";
        document.ISSUE_DETAIL_FORM.submit();  
        }
</SCRIPT>

<BODY onload='setupPanes("container1", "tab1");'>
    
    <FORM NAME="ISSUE_DETAIL_FORM" METHOD="POST">
        
        
        
        <table align="<%=align%>" dir="<%=dir%>" border="0" width="100%">
            
            <tr>
                
                
                <TD STYLE="border:0px" width="34%"  VALIGN="top">
                    <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                        <DIV ONCLICK="JavaScript: changeMode('menu2');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                            <B> <B><%=plusOp%></B> <img src="images/arrow_down.gif">
                        </DIV>
                        
                        <DIV ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu2">
                            <table border="0" cellpadding="0"  width="100%" cellspacing="3"  bgcolor="#FFFFCC">
                                <tr>
                                    <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell">
                                        <b><font color="white"> &nbsp;  </font></b>
                                    </TD>
                                    <TD nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context %>/ImageWriterServlet?op=SelectFile&issueId=<%=(String) webIssue.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>');">
                                        <b> <font color="white"><%=attach_file%></font>   </b>
                                    </TD>
                                    <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white; display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/UnitDocWriterServlet?op=excel2');">
                                        <b><font color="white"> <%=excel%>  </font></b>
                                    </TD>
                                </tr>
                                
                                <tr>
                                    
                                    <%
                                    if(webIssue.getAttribute("scheduleType").equals("NONE")){
                                    %>
                                    <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/ScheduleServlet?op=ChangeToExternal&issueId=<%=webIssue.getAttribute("id")%>&issueTitle=<%=webIssue.getAttribute("issueTitle")%>&issueStatus=<%=webIssue.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                        <b><font color="white"><%=sChangeExternal%></font></b>
                                    </TD>
                                    <%
                                    } else {
                                    %>
                                    <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell">
                                        <b><font color="white"><%=sCantChange%></font></b>
                                    </TD>
                                    <%
                                    }
                                    %>
                                    <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell">
                                        <b><font color="white">&nbsp;</font></b>
                                    </TD>
                                    <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                                        <b><font color="white">&nbsp;</font></b>
                                    </TD>
                                </tr>
                                <tr>
                                    <%
                                    if(!webIssue.getAttribute("currentStatus").equals("Assigned")){
                                    %>
                                    <TD nowrap CLASS="cell" width="34%" bgcolor="#CC3300" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                                        <b>  <font color="white"><%=sCantAddTask%></font>  </b>
                                    </TD>
                                    <TD nowrap CLASS="cell"  bgcolor="#CC3300" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                                        <b><font color="white"><%=sCantAddPart%></font></b>
                                    </TD>
                                    <TD nowrap CLASS="cell"  bgcolor="#CC3300" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                                        <b><font color="white">&nbsp;</font></b>
                                    </TD>
                                    <%
                                    } else {
                                    %>
                                    <TD  nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=GetTasksForm&issueId=<%=(String) webIssue.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                        <b>  <font color="white"><%=add_task%></font>  </b>
                                    </TD>
                                    <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/AssignedIssueServlet?op=configParts&issueId=<%=(String) webIssue.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                        <b><font color="white"><%=addParts%></font></b>
                                    </TD>
                                    <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell">
                                        <b><font color="white">&nbsp;</font></b>
                                    </TD>
                                    <%
                                    }
                                    %>
                                </tr>
                            </table>
                        </DIV>
                    </DIV>
                </TD> 
                
                <TD STYLE="border:0px" width="34%"  VALIGN="top">
                <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                <DIV ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                    <b><%=viewOP%></B> <img src="images/arrow_down.gif">
                </DIV>
                <DIV ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;<%=style%>" ID="menu3">
                <table border="0" cellpadding="0"  width="100%" cellspacing="3"  bgcolor="#FFFFCC">
                    <tr>
                    <TD  nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%= context %>/SearchServlet?op=ViewHistory&issueId=<%=(String) webIssue.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>');">
                        <b><font color="white"> <%=View_hist%></font></b>
                    </TD>
                    
                    <%
                    if(imageMgr.hasDocuments(webIssue.getAttribute("id").toString())) {
                    %>
                    
                    <TD  nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/ImageReaderServlet?op=ListDoc&issueId=<%=(String) webIssue.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>&filterBack=<%=filterBack%>');">
                        <b> <font color="white"> <%=View_file%></font></b>
                        <IMG SRC="images/view.png"  ALT="Click icon for bookmark note">
                    </TD>
                    
                    <%
                    } else {
                    %> 
                    <TD nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;color:white;">
                        <b> <font color="white"> <%=noFiles%></font> </b>
                    </td>
                    
                    <%
                    }
                    %>
                    <TD nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/EquipmentServlet?op=ViewJobEquipment&equipmentID=<%=equipmentID%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>&issueId=<%=(String) webIssue.getAttribute("id")%>');">
                        <b><%=viewEquipment%></b>
                    </td>
                    <tr>
                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ListTasks&issueId=<%=(String) webIssue.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                            <b> <font color="white"> <%=View_task%> </font> </b>
                        </TD>
                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ViewParts&issueId=<%=(String) webIssue.getAttribute("id")%>&issueTitle=<%=(String) webIssue.getAttribute("issueTitle")%>&issueState=<%=(String) webIssue.getAttribute("currentStatus")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                            <b> <font color="white"> <%=view_spar%> </font></b>
                        </TD>
                        <%
                        Long iIDno = new Long(webIssue.getAttribute("id").toString());
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTimeInMillis(iIDno.longValue());
                        String numjob = webIssue.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
                        %>
                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=printJobOrder&issueId=<%=webIssue.getAttribute("id")%>&issueTitle=<%=webIssue.getAttribute("issueTitle")%>&issueStatus=<%=webIssue.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&sID=<%=numjob%>&unitName=<%=MaintenanceTitle%>');">
                            <DIV ID="links">
                                <b><font color="white"> <%=View_jop%> </font></b>
                            </DIV>
                        </TD>
                    </tr>
                    <tr> 
                        <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ChangeDateHistory&issueId=<%=webIssue.getAttribute("id")%>&issueTitle=<%=webIssue.getAttribute("issueTitle")%>&issueStatus=<%=webIssue.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                            <b><font color="white"><%=sChangeDateHistory%></font></b>
                        </TD>
                        <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=Re_Jops&key=<%=webIssue.getAttribute("id")%>&issueTitle=<%=webIssue.getAttribute("issueTitle")%>&issueStatus=<%=webIssue.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&projcteName=<%=projectname%>&mainTitle=<%=MaintenanceTitle%>');">
                            <b><font color="white"> <%=ViewMaintenance%></font></b>
                        </TD>
                        <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell">
                            <b><font color="white">&nbsp;</font></b>
                        </TD>
                    </tr>
                    <tr>
                        <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;"  nowrap  CLASS="cell">
                            <b><font color="white">&nbsp;</font></b>
                        </TD>
                        <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                            <b><font color="white">&nbsp;</font></b>
                        </TD>
                        <TD   nowrap CLASS="cell"  bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                            <b><font color="white">&nbsp;</font></b>
                        </TD>
                    </tr>
                </table>
            </tr>
            </DIV>
            </DIV>
            </TD>
            
            <td  STYLE="border:0px"  width="34%" VALIGN="top">
                <div STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                    <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                        <b>
                            <%=status%>
                        </b>
                        <img src="images/arrow_down.gif">
                    </div>
                    
                    <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                        <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                            <%if(currentStatus.equalsIgnoreCase("Schedule")){%>
                            <tr>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3" width="16%"><b><%=schduled%></b></td>
                            </tr>
                            <%} else if(currentStatus.equalsIgnoreCase("Assigned")){%>
                            <tr>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3" width="16%"><b><%=Begined%></b></td>
                            </tr>
                            <%} else if(currentStatus.equalsIgnoreCase("Finished")){%>
                            <tr>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3" width="16%"><b><%=Finished%></b></td>
                            </tr>
                            <%} else if(currentStatus.equalsIgnoreCase("Canceled")){%>
                            <tr>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3" width="16%"><b><%=Canceled%></b></td>
                            </tr>
                            <%} else if(currentStatus.equalsIgnoreCase("Onhold")){%>
                            <tr>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3" width="16%"><b><%=Holded%></b></td>
                            </tr>
                            <%} else if(currentStatus.equalsIgnoreCase("Rejected")){%>
                            <tr>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3" width="16%"><b><%=Rejected%></b></td>
                            </tr>
                            <%}%>
                        </table>
                    </div>
                </div>
            </td>
            </tr>
        </table>
        <br><br>
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            
            
        </DIV> 
        <fieldset align=center class="set">
        <legend align="<%=align%>">
            
            <table dir="<%=dir%>" align="<%=align%>">
                <tr>
                    <td class="td">  
                        <IMG WIDTH="50" HEIGHT="50" src="images/metal-Inform.gif"">
                         </td>
                    <td class="td">
                        <font color="blue" size="6">        <%=viewDetails%>
                        </font>
                        
                    </td>
                </tr>
            </table>
        </legend >
        <div class="tab-container" id="container1" style="width:100%;"> 
        <ul class="tabs"> 
            <li style="border-right: 1px solid #194367;" > 
                <a href="#" onClick="return showPane('pane1', this)" id="tab1">&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;<BR>Details <img src="images/metal-Inform.gif" width="20px" alt="" /></a> 
            </li> 
            <li> 
                <a href="#" onClick="return showPane('pane2', this)" id="tab2">&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;<BR>Spare Parts <img src="images/configure.jpg" width="20px" alt="" /></a> 
            </li> 
            <!--li style="border-left: 1px solid #194367;"> 
                <a href="#" onClick="return showPane('pane3', this)" id="tab3">&#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;<BR>Workers</a> 
            </li--> 
            <li style="border-left: 1px solid #194367;"> 
                <a href="#" onClick="return showPane('pane4', this)" id="tab4">&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1578;&#1606;&#1601;&#1610;&#1584;<BR>Execution Instructions <img src="images/instructions.jpg" width="20px" alt="" /></a> 
            </li>
            <li style="border-left: 1px solid #194367;"> 
                <a href="#" onClick="return showPane('pane5', this)" id="tab5">&#1605;&#1604;&#1582;&#1589; &#1605;&#1589;&#1608;&#1585;<BR>Images Summery <img src="images/images.jpg" width="20px" alt="" /></a> 
            </li>
            <li style="border-left: 1px solid #194367;"> 
                <a href="#" onClick="return showPane('pane6', this)" id="tab6">&#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;<BR>Documents <img src="images/view.png" width="20px" alt="" /></a> 
            </li>
            <li style="border-left: 1px solid #194367;"> 
                <a href="#" onClick="return showPane('pane7', this)" id="tab6">&#1575;&#1604;&#1605;&#1593;&#1583;&#1577;<BR>Equipment</a> 
            </li>
        </ul> 
        
        <div class="tab-panes"> 
                <div class="content" id="pane1" style="text-align:center;">
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
                        calendar = Calendar.getInstance();
                        calendar.setTimeInMillis(iID.longValue());
                        String sID = webIssue.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
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
                                <input disabled type="TEXT" name="receivedby" ID="receivedby" size="34" value="<%=wboSupplier.getAttribute("name")%>" maxlength="255">
                            </TD>
                            <TD STYLE="<%=style%>"  class='td'>
                                <LABEL FOR="ISSUE_TITLE">
                                    <p><b><font color="#003499"> <%=sConversionDate%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>"  class='td'>
                                <input disabled type="TEXT" name="conversionDate" ID="conversionDate" size="34" value="<%=wboExternal.getAttribute("conversionDate")%>" maxlength="255">
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
                            <TD STYLE="<%=style%>"  class='td'>
                                &nbsp;
                            </TD>
                            <TD STYLE="<%=style%>"  class='td'>
                                &nbsp;
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="<%=style%>"  class='td' COLSPAN="4">
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
                                <input disabled type="TEXT" name="id" ID="id" size="34" value="<%=sID%>" maxlength="255">
                            </TD>
                            <!--/TR-->
                
                            <!--TD class='td'>
                    &nbsp;
                </TD-->
                
                            <!--TR-->
                            <TD STYLE="<%=style%>"  class='td'>
                                <LABEL FOR="ISSUE_TITLE">
                                    <p><b><font color="#003499"> <%=jobFor%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>"  class='td'>
                                <input disabled type="TEXT" name="issueTitle" ID="issueTitle" size="34" value="<%=MaintenanceTitle%>" maxlength="255">
                            </TD>
                        </TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        <TR>
                            <!--TD STYLE="<%//=style%>" class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                            <p><b><font color="#003499"><%=RcievedBy%></font></b>&nbsp;
                    </LABEL>
                </TD>
                            <TD STYLE="<%//=style%>" class='td'>
                            <input disabled type="TEXT" name="Receivedby" ID="Receivedby" size="34" value="<%//=Receivedby%>" maxlength="255">
                </TD-->
                
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="ISSUE_TITLE">
                                    <p><b><font color="#003499"><%=Workorder%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="workTrade" ID="workTrade" size="34" value="<%= (String) tradeIssueWbo.getAttribute("tradeName")%>" maxlength="255">
                            </TD>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="ISSUE_TITLE">
                                    <p><b><font color="#003499"><%=Failure_Code%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="title" ID="title" size="34" value="<%=FailureCode%>" maxlength="255">
                            </TD>
                        </TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        <TR>
                            
                            <!--/TR>
                
                <TD class='td'>
                    &nbsp;
                </TD>
                <TR-->
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="Project_Name">
                                    <p><b><font color="#003499"><%=Site_Name%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="projectName" ID="projectName" size="34" value="<%=SiteName%>" maxlength="255">
                            </TD>
                            
                            <TD STYLE="<%=style%>"  class='td'>
                                <LABEL FOR="Project_Name">
                                    <p><b><font color="#003499"><%=Urgency_Level%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>"  class='td'>
                                <input disabled type="TEXT" name="urgencyLevel" ID="urgencyLevel" size="34" value="<%=UrgencyLevel%>" maxlength="255">
                            </TD>
                        </TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        <TR>
                            
                            
                            <TD STYLE="<%=style%>"  class='td'>
                                <LABEL FOR="estimated_duration">
                                    <p><b><font color="#003499"><%=Estimated_Duration%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="estimatedduration" ID="estimatedduration" size="34" value="<%= (String) webIssue.getAttribute("estimatedduration")%>" maxlength="255">
                            </TD>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_IssueType_Name">
                                    <p><b><font color="#003499"><%=Job_Type%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="issueId" ID="typeName" size="34" value="<%= (String) webIssue.getAttribute("issueType")%>" maxlength="255">
                            </TD>
                            
                        </TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        
                        <% if(jobType.equals("Emergency")) {
                        
                        %>
                        
                        <TR>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="Project_Name">
                                    <p><b><font color="#003499"><%=groupname%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="group" ID="group" size="34" value="<%=group%>" maxlength="255">
                            </TD>
                            
                            <TD STYLE="<%=style%>"  class='td'>
                                <LABEL FOR="Project_Name">
                                    <p><b><font color="#003499"><%=shiftname%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>"  class='td'>
                                <input disabled type="TEXT" name="shift" ID="shift" size="34" value="<%=shift%>" maxlength="255">
                            </TD>
                        </TR>
                        <% } %>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        
                        
                        
                        <TR>
                            
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_IssueType_Name">
                                    <p><b><font color="#003499"><%=CreatedBy%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="createdBy" ID="createdBy" size="34" value="<%= createdBy%>" maxlength="255">
                            </TD>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_current_status">
                                    <p><b><font color="#003499"><%=current_status%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="currentStatus" ID="currentStatus" size="34" value="<%= (String) webIssue.getAttribute("currentStatus")%>" maxlength="255">
                            </TD>
                            
                        </TR>
                        
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        
                        
                        <TR>
                            
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_creation_time">
                                    <p><b><font color="#003499"><%=creationTime%> </font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="CREATION_TIME" ID="CREATION_TIME" size="34" value="<%= (String) webIssue.getAttribute("currentStatusSince")%>" maxlength="255">
                            </TD>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="EXPECTED_B_DATE">
                                    <p><b><font color="#003499"><%=expectedB%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="expectedBeginDate" ID="expectedBeginDate" size="34" value="<%= (String) webIssue.getAttribute("expectedBeginDate")%>" maxlength="255">
                            </TD>
                        </TR>
                        
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        
                        <TR>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_assigned_by">
                                    <p><b><font color="#003499"><%=assignedby%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <%
                            if(! AssignByName.equals("UL")){
                            
                            %>
                            <TD STYLE="<%=style%>" class='td'>
                                <!--
                                <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="34" value="<%//= (String) webIssue.getAttribute("assignedByName")%>" maxlength="255">
                        -->
                                <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="34" value="<%=AssignByName%>" maxlength="255">
                            </TD>
                            <% } else {
                            AssignByName="Not assigned";
                            %>
                            <TD STYLE="<%=style%>" class='td'>   
                                <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="34" value="<%=AssignByName%>" maxlength="255">
                                <% } %>
                                
                            </TD>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="EXPECTED_E_DATE">
                                    <p><b><font color="#003499"><%=expectededate%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="expectedEndDate" ID="expectedEndDate" size="34" value="<%= (String) webIssue.getAttribute("expectedEndDate")%>" maxlength="255">
                            </TD>
                            
                        </TR>
                        
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        
                        <TR>
                            
                            <!--/TR>
                
                <TD class='td'>
                    &nbsp;
                </TD>
               
                             
                             <TR-->
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_finshed_time">
                                    <p><b><font color="#003499"><%=finishedtime%></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <%
                            if(! FinishTime.equals("0")){
                            %>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="finishedTime" ID="finishedTime" size="34" value="<%=FinishTime%>" maxlength="255">
                            </TD>
                            
                            <% }else {
                            FinishTime="Has not been specified ";  
                            
                            %>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="finishedTime" ID="finishedTime" size="34" value="<%=FinishTime%>" maxlength="255">
                            </TD>
                        </TR>
                        <% } %>
                        
                        <TD class='td'>
                            &nbsp;
                        </TD>
                        <TR>
                            
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_Maintenance_Desc">
                                    <p><b><font color="#003499"><%=Problem_Description%></font> </b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD class='td'>
                                <TEXTAREA disabled rows="5" name="issueDesc" cols="27"> <%= (String) webIssue.getAttribute("issueDesc")%></TEXTAREA>
                            </TD>
                            
                        </TR>
                    </TABLE>
                    <br>
                </DIV>
                <div class="content" id="pane2"> 
                    <jsp:include page="/docs/Search/tab_spare_parts.jsp" flush="true" />
                </div> 
                <div class="content" id="pane3">
                    <jsp:include page="/docs/Search/tab_workers.jsp" flush="true" />
                </div>
                <div class="content" id="pane4">
                    <jsp:include page="/docs/Search/tab_operation_order.jsp" flush="true" />
                </div>
                <div class="content" id="pane5">
                    <jsp:include page="/docs/Search/tab_issue_images.jsp" flush="true" />
                </div>
                <div class="content" id="pane6">
                    <jsp:include page="/docs/Search/tab_docs_list.jsp" flush="true" />
                </div>
                <div class="content" id="pane7">
                    <jsp:include page="/docs/unit_doc_handling/view_tab.jsp" flush="true" />
                </div>
            </div> 
        </div>
    </FORM>
    </fieldset>
</BODY>
</HTML>     

