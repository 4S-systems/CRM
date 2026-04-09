<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*,com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.IssueTasksMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%
System.out.println("in JSP ---------");
AppConstants appCons = new AppConstants();
WebIssue webIssue = null;

String projectname = (String) request.getParameter("projectName");
IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
Vector issueTasksVec = new Vector();

String fltr = (String) request.getParameter("oper");
if (fltr != null) {
    if (fltr.equalsIgnoreCase("StatusProjectList")) {
        session.setAttribute("EquipMentID", projectname);
    }
} else if (session.getAttribute("EquipMentID") != null) {
    projectname = (String) session.getAttribute("EquipMentID");
}


int noOfLinks=0;
int count=0;
String tempcount=(String)request.getAttribute("count");
if(tempcount!=null)
    count=Integer.parseInt(tempcount);
String tempLinks=(String)request.getAttribute("noOfLinks");
if(tempLinks!=null)
    noOfLinks=Integer.parseInt(tempLinks);

//String eq_id = (String)request.getParameter("equipmentID");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

//String[] issueAtt = appCons.getIssueAttributes();
//String[] issueTitle = appCons.getIssueHeaders();
String[] issueAtt = {"businessID", "expectedBeginDate", "currentStatus", "issueTitle", "issueType"};
String[] issueTitle;

int s = issueAtt.length;
int t = s + 2;

String attName = null;
String attValue = null;
String cellBgColor = null;

IssueMgr issueMgr = IssueMgr.getInstance();

Vector issueList = (Vector) request.getAttribute("data");
System.out.println("Vector Count = " + issueList.size());

WebBusinessObject wbo = null;
int flipper = 0;
int iTotal = 0;
String bgColor = null;
String bgColorm = null;
String ts = (String) request.getAttribute("ts");
String issueStatus = (String) request.getAttribute("status");
String filterName = (String) request.getAttribute("filterName");
String filterValue = (String) request.getAttribute("filterValue");

String url = context + "/SearchServlet?op=" + filterName + "&filterValue=" + filterValue + "&projectName=" + projectname + "&statusName=" + issueStatus;

String unitName = new String("");
String URL = "&projectName=" + projectname;
if (request.getAttribute("UnitName") != null) {
    unitName = (String) request.getAttribute("UnitName");
    URL = "&case=case39&title=" + (String) request.getAttribute("Title") + "&unitName=" + unitName;
    
} else {
    WebBusinessObject eqWbo = (WebBusinessObject) request.getAttribute("eqWbo");
    
    if (eqWbo != null) {
        unitName = (String) eqWbo.getAttribute("unitName");
    }
    
}
String issueID = null;
String UnitName = null;
String MaintenanceTitle = null;
String ScheduleUnitId = null;
String Configure = null;

ImageMgr imageMgr = ImageMgr.getInstance();

System.out.println("Status = " + issueStatus);
if (null == issueStatus) {
    issueStatus = "**";
    String ID = (String) request.getAttribute("id");
    
//String fileExtension = (String) request.getAttribute("fileExtension");
//String destServlet = (String) request.getAttribute("destServlet");
    
//String operation = (String) request.getAttribute("operation");
    
}


String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align = "center";
String dir = null;
String style = null;
String cancel_button_label;
String lang, langCode, indGuid, attached, termainanted, nconfig, Config, updateTime, notAattached, notTermainanted;
String showDetails, searchRe,viewFiles,items,externalOrder,configureSchedule,unConfigureSchedule,orderSatus,noFiles,jobOrderType,jobOrder, attachedFiles, jobOrderStatus,terminatedTask, unTerminated, normalOrder, plannedOrder,viewDetails, numTask, QuikSummry, basicOP, workFlow, signe, mark, viewD, DM, sta, schduled, Begined, Finished, Canceled, Holded, Rejected, external, em, pm, timeout;
String haveTasks,haventTasks,taskSatus,noOdfTask;
if (stat.equals("En")) {
    
    cancel_button_label = "Back to list";
    dir = "LTR";
    style = "text-align:left";
    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
    langCode = "Ar";
    
    issueTitle = new String[7];
    issueTitle[0] = "Job Order number";
    issueTitle[1] = "start date";
    issueTitle[2] = "Status";
    issueTitle[3] = "Maintenance Schedule Name";
    issueTitle[4] = "On Equipment";
    issueTitle[5] = "Details";
    issueTitle[6] = "Sign";
  //  issueTitle[6] = "Bookmark";
   // issueTitle[7] = "Cancel";
  //  issueTitle[8] = "Execute";
    indGuid = " Indicators guide ";
    nconfig = "configured task";
    Config = "Not yet configured task";
    attached = "view attached files";
    notAattached = "There is no attached files";
    termainanted = "Termaintanted task";
    notTermainanted = "Not Termaintanted task";
    updateTime = "update date time";
    showDetails = "show Details";
    if (unitName.equals("")) {
        searchRe = "Search Results for All Equipment ";
    } else {
        searchRe = "Search Results for Equipment '" + unitName + "'";
    }
    
    numTask = " Tasks Numbers ";
    QuikSummry = " Quick Summary ";
    basicOP = "Basic Operations";
    workFlow = "Work Flow";
    signe = "Guide";
    mark = "Mark";
    viewD = "View Details";
    DM = "Delete Mark";
    sta = "Status";
    schduled = "Scheduled";
    Begined = "Started";
    Finished = "Finished";
    Canceled = "Canceled";
    Holded = "on Hold";
    Rejected = "Rejected";
    external = "External job Order";
    em = "Emergency Job Order";
    pm = "Premaintative Maintenance";
    timeout = "Don't change date after start engine";
    viewFiles="View Attached Files";
    viewDetails="View Order Details";
    terminatedTask="Terminated Task";
    unTerminated="Unterminated Task";
    normalOrder="Normal Job Order";
    plannedOrder="Planned Job Order";
    noFiles="No Attached Files";
    attachedFiles="View Attached Files";
    jobOrderStatus="Task Satus";
    jobOrder="Job Order";
    jobOrderType="Job Order Type";
    orderSatus="Job Order Satus";
    configureSchedule="Configured Schedule";
    unConfigureSchedule="un Configured Schedule";
    items="Spare parts";
    externalOrder="External job order";
    haveTasks = "Related to maintenance item";
    haventTasks = "Not related to maintenance item";
    taskSatus="Maintenance items";
    noOdfTask = "No of tasks ";
} else {
    
    cancel_button_label = "&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    issueTitle = new String[7];
    issueTitle[0] = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    issueTitle[1] = " &#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;";
    issueTitle[2] = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
    issueTitle[3] = "&#1575;&#1587;&#1605; &#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    issueTitle[4] = "&#1593;&#1604;&#1609; &#1605;&#1575;&#1603;&#1610;&#1606;&#1577;";
    issueTitle[5] = "&#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    issueTitle[6] = "&#1593;&#1604;&#1575;&#1605;&#1577;";
   // issueTitle[7] = "&#1573;&#1604;&#1594;&#1575;&#1569;";
   // issueTitle[8] = "&#1578;&#1606;&#1601;&#1610;&#1584;";
    indGuid = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    attached = "&#1573;&#1590;&#1594;&#1591; &#1604;&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;&#1607;";
    notAattached = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;";
    termainanted = "&#1605;&#1607;&#1605;&#1607; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;";
    notTermainanted = "&#1605;&#1607;&#1605;&#1607; &#1594;&#1610;&#1585; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;";
    Config = "&#1580;&#1583;&#1608;&#1604; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    nconfig = "&#1580;&#1583;&#1608;&#1604; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    updateTime = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1593;&#1605;&#1604;";
    showDetails = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    
    if (unitName.equals("")) {
        searchRe = "&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1576;&#1581;&#1579; &#1604;&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
    } else {
        searchRe = "'" + unitName + "' &#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1576;&#1581;&#1579; &#1604;&#1604;&#1605;&#1593;&#1583;&#1577;";
        
    }
    numTask = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;  ";
    QuikSummry = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    basicOP = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    workFlow = "&#1575;&#1604;&#1583;&#1608;&#1585;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1610;&#1577;";
    signe = "&#1575;&#1604;&#1585;&#1605;&#1586;";
    mark = "&#1593;&#1604;&#1575;&#1605;&#1607;";
    viewD = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    DM = "&#1581;&#1584;&#1601; &#1575;&#1604;&#1593;&#1604;&#1575;&#1605;&#1577;";
    sta = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    schduled = "&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
    Begined = "&#1576;&#1583;&#1571;&#1578;";
    Finished = "&#1573;&#1606;&#1578;&#1607;&#1578;";
    Canceled = "&#1605;&#1604;&#1594;&#1575;&#1577;";
    Holded = "&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
    Rejected = "&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
    external = "&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1582;&#1575;&#1585;&#1580;&#1610;";
    em = "&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1587;&#1585;&#1610;&#1593;";
    pm = "&#1589;&#1610;&#1575;&#1606;&#1577; &#1608;&#1602;&#1575;&#1574;&#1610;&#1607;";
    timeout = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1608;&#1602;&#1578; &#1576;&#1593;&#1583; &#1576;&#1583;&#1569; &#1605;&#1585;&#1581;&#1604;&#1577; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    viewFiles="&#1605;&#1588;&#1600;&#1575;&#1607;&#1600;&#1583;&#1607; &#1575;&#1604;&#1600;&#1605;&#1600;&#1587;&#1600;&#1578;&#1600;&#1606;&#1600;&#1583;&#1575;&#1578; &#1575;&#1604;&#1600;&#1605;&#1600;&#1585;&#1601;&#1600;&#1602;&#1600;&#1607;";
    viewDetails="&#1605;&#1600;&#1588;&#1600;&#1575;&#1607;&#1600;&#1583;&#1607; &#1578;&#1600;&#1601;&#1600;&#1575;&#1589;&#1600;&#1610;&#1600;&#1604; &#1575;&#1605;&#1600;&#1585; &#1575;&#1604;&#1600;&#1600;&#1588;&#1600;&#1594;&#1604;";
    terminatedTask="&#1605;&#1600;&#1607;&#1600;&#1605;&#1600;&#1607; &#1605;&#1600;&#1606;&#1600;&#1578;&#1600;&#1607;&#1600;&#1610;&#1600;&#1607;";
    unTerminated="&#1605;&#1600;&#1607;&#1600;&#1605;&#1600;&#1607; &#1594;&#1600;&#1610;&#1600;&#1585; &#1605;&#1600;&#1606;&#1600;&#1607;&#1600;&#1610;&#1600;&#1607;";
    normalOrder="&#1575;&#1605;&#1600;&#1585; &#1588;&#1600;&#1594;&#1600;&#1604; &#1593;&#1600;&#1600;&#1575;&#1583;&#1609;";
    plannedOrder="&#1575;&#1605;&#1600;&#1585; &#1588;&#1600;&#1594;&#1600;&#1604; &#1605;&#1600;&#1580;&#1600;&#1583;&#1608;&#1604;";
    noFiles="&#1604;&#1575; &#1578;&#1600;&#1608;&#1580;&#1600;&#1583; &#1605;&#1600;&#1587;&#1600;&#1578;&#1600;&#1606;&#1600;&#1583;&#1575;&#1578; &#1605;&#1600;&#1585;&#1601;&#1600;&#1602;&#1600;&#1607;";
    attachedFiles="&#1575;&#1604;&#1600;&#1605;&#1600;&#1587;&#1600;&#1578;&#1600;&#1606;&#1600;&#1583;&#1575;&#1578; &#1575;&#1604;&#1600;&#1605;&#1600;&#1585;&#1601;&#1600;&#1602;&#1600;&#1607;";
    jobOrderStatus="&#1581;&#1600;&#1575;&#1604;&#1600;&#1600;&#1600;&#1600;&#1607; &#1575;&#1604;&#1600;&#1600;&#1605;&#1600;&#1600;&#1607;&#1600;&#1600;&#1605;&#1600;&#1600;&#1607;</p>";
    jobOrder="&#1575;&#1605;&#1600;&#1585; &#1575;&#1604;&#1600;&#1600;&#1588;&#1600;&#1594;&#1604;";
    jobOrderType="&#1606;&#1600;&#1600;&#1608;&#1593; &#1575;&#1605;&#1600;&#1585; &#1575;&#1604;&#1600;&#1588;&#1600;&#1594;&#1600;&#1604;";
    orderSatus="&#1581;&#1600;&#1575;&#1604;&#1600;&#1600;&#1600;&#1600;&#1607; &#1575;&#1604;&#1600;&#1600;&#1605;&#1600;&#1600;&#1607;&#1600;&#1600;&#1605;&#1600;&#1600;&#1607";
    configureSchedule="&#1605;&#1593;&#1610;&#1606; &#1593;&#1604;&#1610;&#1607;&#1575; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    unConfigureSchedule="&#1594;&#1610;&#1585; &#1605;&#1593;&#1610;&#1606; &#1593;&#1604;&#1610;&#1607;&#1575; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    items="&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    externalOrder="&#1575;&#1605;&#1585; &#1588;&#1594;&#1604; &#1582;&#1575;&#1585;&#1580;&#1609;";
    haveTasks = "&#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    haventTasks = "&#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    taskSatus ="&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    noOdfTask ="&#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; ";
}

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Tracker- List Schedules</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        
        <link rel="stylesheet" href="windowfiles/dhtmlwindow.css" type="text/css" />
        
        <script type="text/javascript" src="windowfiles/dhtmlwindow.js"></script>
        
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
    </script>   
    
    <script type="text/javascript">//<![CDATA[
        
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
                        
                        function sortTable2(col) {
                            
                            // Get the table section to sort.
                            var tblEl = document.getElementById("planetData2");
                            
                            // Set up an array of reverse sort flags, if not done already.
                            if (tblEl.reverseSort == null)
                                tblEl.reverseSort = new Array();
                            
                            // If this column was the last one sorted, reverse its sort direction.
                            if (col == tblEl.lastColumn)
                                tblEl.reverseSort[col] = !tblEl.reverseSort[col];
                            
                            // Remember this column as the last one sorted.
                            tblEl.lastColumn = col;
                            
                            // Set the table display style to "none" - necessary for Netscape 6 
                            // browsers.
                            var oldDsply = tblEl.style.display;
                            tblEl.style.display = "none";
                            
                            // Sort the rows based on the content of the specified column using a
                            // selection sort.
                            
                            var tmpEl;
                            var i, j;
                            var minVal, minIdx;
                            var testVal;
                            var cmp;
                            
                            for (i = 0; i < tblEl.rows.length - 1; i++) {
                                
                                // Assume the current row has the minimum value.
                                minIdx = i;
                                minVal = getTextValue(tblEl.rows[i].cells[col]);
                                
                                // Search the rows that follow the current one for a smaller value.
                                for (j = i + 1; j < tblEl.rows.length; j++) {
                                    testVal = getTextValue(tblEl.rows[j].cells[col]);
                                    cmp = compareValues(minVal, testVal);
                                    // Reverse order?
                                    if (tblEl.reverseSort[col])
                                        cmp = -cmp;
                                    // If this row has a smaller value than the current minimum, remember its
                                    // position and update the current minimum value.
                                    if (cmp > 0) {
                                        minIdx = j;
                                        minVal = testVal;
                                    }
                                }
                                
                                // By now, we have the row with the smallest value. Remove it from the
                                // table and insert it before the current row.
                                if (minIdx > i) {
                                    tmpEl = tblEl.removeChild(tblEl.rows[minIdx]);
                                    tblEl.insertBefore(tmpEl, tblEl.rows[i]);
                                }
                            }
                            
                            // Restore the table's display style.
                            tblEl.style.display = oldDsply;
                            
                            return false;
                        }
                        
                        //-----------------------------------------------------------------------------
                        // Functions to get and compare values during a sort.
                        //-----------------------------------------------------------------------------
                        
                        // This code is necessary for browsers that don't reflect the DOM constants
                        // (like IE).
                        if (document.ELEMENT_NODE == null) {
                            document.ELEMENT_NODE = 1;
                            document.TEXT_NODE = 3;
                        }
                        
                        function getTextValue(el) {
                            
                            var i;
                            var s;
                            
                            // Find and concatenate the values of all text nodes contained within the
                            // element.
                            s = "";
                            for (i = 0; i < el.childNodes.length; i++)
                                if (el.childNodes[i].nodeType == document.TEXT_NODE)
                                    s += el.childNodes[i].nodeValue;
                                else if (el.childNodes[i].nodeType == document.ELEMENT_NODE &&
                                    el.childNodes[i].tagName == "BR")
                                s += " ";
                                else
                                    // Use recursion to get text within sub-elements.
                                s += getTextValue(el.childNodes[i]);
                                
                                return normalizeString(s);
                            }
                            
                            function compareValues(v1, v2) {
                                
                                var f1, f2;
                                
                                // If the values are numeric, convert them to floats.
                                
                                f1 = parseFloat(v1);
                                f2 = parseFloat(v2);
                                if (!isNaN(f1) && !isNaN(f2)) {
                                    v1 = f1;
                                    v2 = f2;
                                }
                                
                                // Compare the two values.
                                if (v1 == v2)
                                    return 0;
                                if (v1 > v2)
                                    return 1
                                return -1;
                            }
                            
                            // Regular expressions for normalizing white space.
                            var whtSpEnds = new RegExp("^\\s*|\\s*$", "g");
                            var whtSpMult = new RegExp("\\s\\s+", "g");
                            
                            function normalizeString(s) {
                                
                                s = s.replace(whtSpMult, " ");  // Collapse any multiple whites space.
                                s = s.replace(whtSpEnds, "");   // Remove leading or trailing white space.
                                
                                return s;
                            }
                            
                            //]]>
                            
                            function openPrintWindow(context)
                            {  
                                open(context+"/printWindow.jsp","printWindow");
                            }
                            
                            function changeMode(name){
                                if(document.getElementById(name).style.display == 'none'){
                                    document.getElementById(name).style.display = 'block';
                                } else {
                                document.getElementById(name).style.display = 'none';
                            }
                        }
                        function popup(url){

                            window.navigate(url);

                        }
                        
                        function cancelForm()
                        {    
                            
                            var url ="<%=context%>/main.jsp";//ScheduleServlet?op=BindSingleSchedUnit&equipmentID=<%=projectname%>";
                            window.navigate(url);
                        }
                        
                        function getData(issueID)
                        { 
                            var url = "<%=context%>/AssignedIssueServlet?op=ViewPopUpDetails&issueId=" + issueID;
                            if (window.XMLHttpRequest)
                                { 
                                    req = new XMLHttpRequest(); 
                                } 
                                else if (window.ActiveXObject)
                                    { 
                                        req = new ActiveXObject("Microsoft.XMLHTTP"); 
                                    } 
                                    req.open("Get",url,true); 
                                    req.onreadystatechange =  fillDiv;
                                    req.send(null);
                                }
                                
                                function fillDiv(){
                                    if (req.readyState==4)
                                        { 
                                            if (req.status == 200)
                                                { 
                                                    //alert(req.responseText);
                                                    document.getElementById('pop-up-body').innerHTML = req.responseText;
                                                } 
                                            }
                                        }
                                        
                                        function showDiv(event, issueID){
                                            getData(issueID);
                                            document.getElementById('pop-up').style.position = 'absolute';
                                            document.getElementById('pop-up').style.left = event.clientX;
                                            document.getElementById('pop-up').style.top = event.clientY;
                                            document.getElementById('pop-up').style.display = 'block';
                                        }
                                        
                                        function hideDiv(event){
                                            document.getElementById('pop-up').style.display = 'none';
                                            document.getElementById('pop-up-body').innerHTML = '';
                                        }
                                        
                                        function selectRow(tableRow){
                                            var cells = tableRow.cells;
                                            for (x in cells)
                                                {
                                                    if(cells[x].style != null){
                                                        cells[x].style.backgroundColor = 'yellow';
                                                    }
                                                }
                                            }
                                            
                                            var p;
                                            function show_popup(issueID)
                                            {
                                                getData(issueID);
                                                p=window.createPopup()
                                                var pbody=p.document.body
                                                //p.location = "<%=context%>/AssignedIssueServlet?op=ViewPopUpDetails&issueId=" + issueID;
                                                pbody.style.backgroundColor="#FFFF99"
                                                pbody.style.border="solid black 2px"
                                                pbody.style.margin="10px";
                                                pbody.style.fontSize="10";
                                                var v = setTimeout("showHtml();",3000);
                                                //pbody.innerHTML=req.responseText;//"This is a pop-up! Click outside to close."
                                                p.show(event.clientX,event.clientY,310,520,document.body)
                                            }
                                            ///////////////////////////////////////////
                                               function showtest_popup(issueID)
                                            {
                                                getData(issueID);
                                                divwin=dhtmlwindow.open('divbox', 'div', 'pop-up', 'title', 'width=450px,height=300px,left=200px,top=150px,resize=1,scrolling=1');
                                              } 
                                              //////////////////////////////////////////                                         
                                            function showHtml(){
                                                p.document.body.innerHTML=req.responseText;
                                            }
              function goToUrlDown(){
                   var no = document.getElementById('pageNoDown').value;
                   var url = "<%=url%>&count=" + no;
                   document.ISSUE_LISTING_FORM.action = url;
                   document.ISSUE_LISTING_FORM.submit();
               }
            function goToUrlUp(){
                   var no = document.getElementById('pageNoUp').value;
                   var url = "<%=url%>&count=" + no;
                   document.ISSUE_LISTING_FORM.action = url;
                   document.ISSUE_LISTING_FORM.submit();
               }             
               
    </script>
    
    <BODY>
        
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        
        <table align="<%=align%>" border="0" width="80%">
            <tr>
                <td width="50%" STYLE="border:0px;" class="blueHeaderTD">
                    <div STYLE="width:99.5%;border:2px solid gray;background-color:#9db0c1;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                        <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#9db0c1;color:white;cursor:hand;font-size:16;">
                            <b>
                                <%=indGuid%>
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu1">
                            <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                <tr>
                                    <!--td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><IMG SRC="images/view.png" ALIGN=""ALT="view file" > <b><%=attached%></b></td-->
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><IMG SRC="images/have_item.jpg" ALIGN=""ALT="Have Tasks" > <b><%=haveTasks%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><IMG SRC="images/unassign.gif"  ALT="Terminated Task" > <b><%=termainanted%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><IMG SRC="images/config.jpg"  ALT="Configured Schedule" > <b><%=Config%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><IMG SRC="images/timer.gif"  ALT="Update Job Date"> <b><%=updateTime%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/emr.gif" ALT="Emergency job order"> <b><%=em%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/external.gif" ALT="External job order"> <b><%=external%></b></td>
                                </tr>
                                <tr bgcolor="#E6E6FA">
                                    <!--td CLASS="indicator" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/unview.gif" ALT="non attached file"> <b><%=notAattached%></b></td-->
                                    <td bgcolor="white" CLASS="indicator" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/have_not_item.jpg" ALT="Have Not Tasks"> <b><%=haventTasks%></b></td>
                                    <td bgcolor="white" CLASS="indicator" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/assign.gif" ALT="UnTerminated Task" > <b><%=notTermainanted%></b></td>
                                    <td bgcolor="white" CLASS="indicator" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/nonconfig.gif"  ALT="Un configure Schedule"> <b><%=nconfig%></b></td>
                                    <td bgcolor="white" CLASS="indicator" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/timout.gif"  ALT="Cann't Update Job Date"> <b><%=timeout%></b></td>
                                    <td bgcolor="white" CLASS="indicator" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/field.jpg" ALT="View Job order Details"> <b><%=showDetails%></b></td>
                                    <td bgcolor="white" CLASS="indicator" STYLE="<%=style%>" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/internal.gif" ALT="Premaintative Maintenance"> <b><%=pm%></b></td>
                                    
                                </tr>                                
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
            
            <tr>
                <td width="100%" STYLE="border:0px;" class="blueHeaderTD">
                    
                    <div STYLE="width:99.5%;border:2px solid gray;background-color:#9db0c1;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                        <div ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#9db0c1;color:white;cursor:hand;font-size:16;">
                            <b>
                                <%=sta%>
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu3">
                            <table width="100%">
                                <tr>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><b style="font-size:14px"><%=schduled%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><b style="font-size:14px"><%=Begined%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><b style="font-size:14px"><%=Finished%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><b style="font-size:14px"><%=Canceled%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><b style="font-size:14px"><%=Holded%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="16%"><b style="font-size:14px"><%=Rejected%></b></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    
                </td>
            </tr>
        </table>
        <br>
        
        <DIV align="left" STYLE="color:blue;">
            
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <%
            
            System.out.println("mero" + fltr);
            // System.out.println(request.getParameter("opName"));
            
            //if (request.getAttribute("ViewBack") == null) {
            %>
            <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <%//}%>
        </DIV> 
        <fieldset >
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">  
                            <IMG WIDTH="40" HEIGHT="40" SRC="images/Search.png">
                        </td>
                        <td class="td">
                            <font color="blue" size="6"> <%=searchRe%>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            
            <FORM NAME="ISSUE_LISTING_FORM" METHOD="POST">
             <br>
                <div align="center">
                    <input type="hidden" name="url" value="<%=url%>" id="url" >
                        <%if(noOfLinks>0){%>
                            <font size="3" color="red" style="font-weight:bold" >Page No</font><font size="3" color="black" ><%=(count+1)%></font><font size="3" color="red" style="font-weight:bold" > of </font><font size="3" color="black" ><%=noOfLinks%></font>
                            &ensp;
                                <select id="pageNoUp" onchange="goToUrlUp()" style="font-size:14px;font-weight:bold;color:black">
                                     <%for(int i = 0 ;i<noOfLinks; i++){%>
                                     <option  value="<%=i%>" <%if(i == count){%> selected <%}%> ><%=(i+1)%></option>
                                     <%}%>
                                </select>
                        <%
                        }
                        %>
                </div>
                
                <TABLE align="<%=align%>" border="0" width="100%" DIR= <%=dir%>  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                    <th colspan="5" class="td" dir="<%=dir%>">  <DIV  align="<%=align%>">
                            
                            <B> <%=numTask%> : <%=issueList.size()%>   </B>
                        </DIV>
                    </th>
                    <TR>
                        <TD class="blueBorder blueHeaderTD" COLSPAN="6" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                            <B><%=QuikSummry%></B>
                        </TD>
                        <TD class="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                            <B><%=basicOP%></B>
                        </TD>
                        <!--TD CLASS="td" COLSPAN="2" bgcolor="#999999" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=workFlow%></B>
                        </TD-->
                        <TD class="blueBorder blueHeaderTD" COLSPAN="4" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:18">
                            <B><%=indGuid%></B>
                        </TD>
                    </TR>
                    
                    <TR >
                        <TD nowrap CLASS="silver_header" BGCOLOR="#9B9B00" STYLE="border-top-WIDTH:0; font-size:14" nowrap>
                            <font ><a href="" onclick="return sortTable2(0)" >#</a></font>
                        </td>
                        <%
                        String columnColor = new String("");
                        String columnWidth = new String("");
                        String font = new String("");
                        for (int i = 0; i < t; i++) {
                            if (i == 0 || i == 1 || i == 2 || i == 3 || i == 4) {
                                columnColor = "#9B9B00";
                            } else if (i == 5 || i == 6) {
                                columnColor = "#7EBB00";
                            } else {
                                columnColor = "#CCCCCC";
                            }
                            if (issueTitle[i].equalsIgnoreCase("")) {
                                columnWidth = "1";
                                columnColor = "black";
                                font = "1";
                            } else {
                                columnWidth = "100";
                                font = "12";
                            }
                        %>  
                        <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
                            
                            <%
                            if (i <= 4) {
                            %>
                            
                            
                            <a href="" onclick="return sortTable2(<%=i + 1%>)" ><%=issueTitle[i]%></a>
                            
                            <%
                            } else {%>
                            <%=issueTitle[i]%>
                            <%
                            }
                            %>
                            
                        </TD>
                        
                        <%
                        }
                        %>
                        <td nowrap BGCOLOR="#FFBF00" colspan="6" CLASS="silver_header" WIDTH="60" STYLE="text-align:center;border-top-WIDTH:0; font-size:14" nowrap>
                            <font > <%=signe%> </font>
                        </td>
                    </TR>
                    
                    <tbody id="planetData2">  
                        <%
                        Enumeration e = issueList.elements();
                        String status = null;
                        String eqpId="";
                        WebBusinessObject unitWbo=new WebBusinessObject();
                        MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
                        while (e.hasMoreElements()) {
                            unitWbo=new WebBusinessObject();
                            eqpId="";
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();
                            webIssue = (WebIssue) wbo;
                            issueID = (String) wbo.getAttribute("id");
                            eqpId=webIssue.getAttribute("unitId").toString();
                            unitWbo=maintainableMgr.getOnSingleKey(eqpId);
                            flipper++;
                         if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    }
                            
                        //    wbo.printSelf();
                        %>
                        <TR STYLE="cursor:hand;" onclick="JavaScript: selectRow(this);">
                            <TD nowrap BGCOLOR="#DDDD00" STYLE="text-align:center" CLASS="<%=bgColorm%>">
                                <b><%=iTotal%> </b> 
                            </td>
                            
                            <%
                            for (int i = 0; i < s; i++) {
                                attName = issueAtt[i];
                                attValue = (String) wbo.getAttribute(attName);
                                //if(i==0){
                                //    attValue = attValue.substring(8,10)+"-"+attValue.substring(5,7)+"-"+attValue.substring(0,4);
                                //}
                                
                                if (attName.equalsIgnoreCase("urgencyId") && attValue.equalsIgnoreCase("very urgent")) {
                                    cellBgColor = "red";
                                } else {
                                    
                                    cellBgColor = bgColor;
                                }
                            %>
                            
                            <%
                            ScheduleUnitId = issueMgr.getScheduleUnitId(issueID);
                            MaintenanceTitle = issueMgr.getUnitName(ScheduleUnitId);
                            
                            if (MaintenanceTitle == null) {
                                MaintenanceTitle = "No found Title";
                            }
                            Long iID = new Long(webIssue.getAttribute("id").toString());
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTimeInMillis(iID.longValue());
                            String sID = (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
                            WebBusinessObject wboSID = issueMgr.getOnSingleKey(webIssue.getAttribute("id").toString());
                            String sBID =wboSID.getAttribute("businessIDbyDate").toString();
                            %>
                            
                            <%if (i == 0) {%>
                            <TD  nowrap  BGCOLOR="#DDDD00" CLASS="<%=bgColor%>" >
                                <font color="red"><%=attValue%></font><font color="blue">/<%=sBID%></font>
                            </td>
                            <%} else if (i == 1) {
                            %>
                            <TD  nowrap  BGCOLOR="#DDDD00" CLASS="<%=bgColor%>" >
                                <% if (issueMgr.getScheduleCase(webIssue.getAttribute("id").toString())) {%>
                                <DIV >
                                    <A HREF="<%=context%>/IssueServlet?op=ViewUpdateJobIssueDate&issueId=<%=webIssue.getAttribute("id")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%><%=URL%>">
                                        <b> <%=attValue%> <IMG SRC="images/timer.gif"  ALT="Update Job Date"></b>
                                    </A>
                                </DIV>
                                <% } else {%>
                                <DIV >
                                    
                                    <b> <%=attValue%><IMG SRC="images/timout.gif"  ALT="Don't Update Job Date"> </b>
                                </DIV>
                                <% } %>
                                
                            </TD>
                            <%} else if (i == 2) { %>
                                <TD BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>">
                                <DIV ALIGN="CENTER">
                                    <% if (attValue.equals("Schedule")) {%>

                                        <b><font face="Arial" size="2" ><%=schduled%></font></b>


                                    <%} else if (attValue.equals("Assigned")) {%>

                                        <b><font face="Arial" size="2" ><%=Begined%></font></b>


                                    <% } else if (attValue.equals("Finished")) {%>

                                        <b><font face="Arial" size="2" ><%=Finished%></font></b>


                                    <%} else if (attValue.equals("Canceled")) {%>

                                        <b><font face="Arial" size="2" ><%=Canceled%></font></b>

                                    <%} else if (attValue.equals("Onhold")) {%>

                                        <b><font face="Arial" size="2" ><%=Holded%></font></b>

                                    <%} %>

                                </DIV>
                            </TD>
                            <%} else if (i == 3) {
                            if (attValue.equals("Emergency")) {
                            String tempVal = (String) wbo.getAttribute("issueDesc");
                            attValue="";
                            if(tempVal.length()>20)
                                attValue=tempVal.substring(0,20)+".....";
                            %>
                            
                            
                            <TD BGCOLOR="#DDDD00" STYLE="<%=style%>" CLASS="<%=bgColor%>" >
                                <DIV >
                                    
                                    <b><font color="red">EMG</font> <%=attValue%> </b>
                                </DIV>
                            </TD> 
                            <% } else {%>
                            
                            <TD BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>" >
                                <DIV >
                                    
                                    <b> <%=attValue%> </b>
                                </DIV>
                            </TD> 
                            <% } %>
                            <%} else if (i == 4) {
                            
                            attValue = MaintenanceTitle;
                            %>
                            <TD BGCOLOR="#DDDD00" nowrap style="white-space: normal;"  CLASS="<%=bgColor%>" >
                                <DIV >
                                    
                                    <b> <%=unitWbo.getAttribute("unitName").toString()%> </b>
                                </DIV>
                            </TD>
                            
                            <% } else {%>
                            <TD BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>"style="white-space: normal;" >
                                <DIV >
                                    
                                    <b> <%=attValue%> </b>
                                </DIV>
                            </TD>
                            <%
                            }
                            }
                            %>
                            <%
                            ScheduleUnitId = issueMgr.getScheduleUnitId(issueID);
                            UnitName = issueMgr.getUnitName(ScheduleUnitId);
                            if (UnitName == null) {
                                UnitName = "No found Unit for Schedule";
                            }
                            
                            %>
                            
                            <TD  nowrap  BGCOLOR="#D7FF82" DIR="<%=dir%>" CLASS="<%=bgColor%>">
                                <DIV align="<%=align%>">
                                    <%
                                    String checkCmplx=(String)wbo.getAttribute("issueType");
                                    if(checkCmplx.equalsIgnoreCase("cmplx")){
                                    %>
                                    <A HREF="<%=context%>/ComplexIssueServlet?op=viewDetailsCmplx&issueId=<%=issueID%>&filterValue=null&filterName=null&mainTitle=cmplx&count=<%=count%>">
                                        <img src="images/metal-Inform.gif" alt="<%=(String) wbo.getAttribute(attName)%>" width="20">
                                        <%=viewD%>
                                    </A>
                                    <%}else{%>
                                    <A HREF="<%=webIssue.getViewDetailLink()%>&mainTitle=<%=MaintenanceTitle%><%=URL%>&count=<%=count%>">
                                        <img src="images/metal-Inform.gif" alt="<%=(String) wbo.getAttribute(attName)%>" width="20">
                                        <%=viewD%>
                                    </A>                                        
                                    <%}%>
                                </DIV>
                            </TD>
                            
                            <%
                            if (webIssue.isBookmarked()) {
                            %>
                            
                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-left:10;<%=style%>;">
                                
                                <DIV ID="links">
                                    
                                    <A HREF="<%=webIssue.getUndoBookmarkLink()%><%=URL%>">
                                        <%=DM%>  
                                    </A>
                                    
                                    <A HREF="<%=webIssue.getViewBookmarkLink()%><%=URL%>">
                                        <IMG SRC="images/img_bookmarks.gif"  ALT="Click icon for bookmark note"> 
                                    </A>
                                </DIV>
                            </TD>
                            <%
                            } else {
                            %>
                            <TD nowrap BGCOLOR="#D7FF82" CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>;">
                                <DIV ID="links">
                                    <A HREF="javascript:popup('<%=webIssue.getBookmarkLink()%><%=URL%>')" alt="Add bookmark">
                                        <%=mark%>
                                        
                                    </A>
                                </DIV>
                            </TD>
                            <%
                            }
                            %>
                            
                            <!--
                            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                            <DIV ID="links">
                
                            <A HREF="<%//=context%>/IssueServlet?op=print" alt="print"> 
                                    Print
                                </A>
                            </DIV>
                        </TD>
                            -->
                            <!--TD BGCOLOR="#EBEBEB" nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                                <table>
                                    <tr>
                                        <%
                                        
                                        if (webIssue.isTerminal()) {
                                        %>
                                        <td width="80">
                                            <b> <%=webIssue.getReverseStateAction()%> </b>
                                        </td>
                                        <td  width="20">
                                            <IMG SRC="images/unassign.gif"  ALT="Click to move forward">
                                        </td>
                                        
                                        
                                        <%
                                        } else {
                                        webIssue.isUserOwner();
                                        String PreUrl = webIssue.getReverseStateLink() + URL;
                                        System.out.println(PreUrl);
                                        PreUrl = PreUrl.replace(' ', '+');
                                        %>
                                        
                                        <td width="80">
                                            
                                            <A HREF="<%=PreUrl%>">
                                                <b> <%=webIssue.getReverseStateAction()%> </b>
                                            </A>
                                        </td> 
                                        
                                        <%
                                        if (webIssue.isUserOwner()) {
                                        %>
                                        <td width="20">
                                            
                                            <A HREF="<%=PreUrl%>">
                                                <IMG SRC="images/arrow_right_red.gif"  ALT="Click to execute state"> 
                                            </A>
                                        </td>
                                        <%
                                        }
                                        %>
                                        <%
                                        }
                                        %>  
                                    </tr>
                                </table>             
                            </TD>   
                            
                            <TD BGCOLOR="#EBEBEB" nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                                <table>
                                    <tr>
                                        
                                        <%
                                        String myState = (String) webIssue.getState();
                                        if (webIssue.isTerminal() || myState.equalsIgnoreCase(IssueStatusFactory.DELETED)) {
                                        %>
                                        <td width="80">
                                            <b> <%=webIssue.getNextStateAction()%> </b>
                                        </td>
                                        <%
                                        
                                        if (webIssue.isUserOwner()) {
                                        %>
                                        
                                        <td>
                                            <IMG SRC="images/unassign.gif"  ALT="Click to move forward"> 
                                        </td>
                                        <%
                                        }
                                        %>
                                        
                                        <%
                                        } else {
                                            String NextUrl = webIssue.getNextStateLink() + URL;
                                            NextUrl = NextUrl.replace(' ', '+');
                                        %>
                                        <td width="80">
                                            <A HREF="<%=NextUrl%>">
                                                <b> <%=webIssue.getNextStateAction()%> </b>
                                            </A>
                                        </td>
                                        <%
                                        
                                        if (webIssue.isUserOwner()) {
                                        
                                        %>
                                        
                                        <td >
                                            <A HREF="<%=NextUrl%>">
                                                
                                                <IMG SRC="images/arrow_right_red.gif"  ALT="Click to move forward">
                                            </A>
                                        </td> 
                                        <%
                                        }
                                        %>
                                        
                                        <%
                                        }
                                        %>
                                        
                                    </tr>
                                </table>
                            </TD-->
                            
                            <DIV align="<%=align%>">
                                
                                
                                <!--td BGCOLOR="#FFE391">
                                    <%
                                    if (imageMgr.hasDocuments(webIssue.getAttribute("id").toString())) {
                                    %>
                                    <A HREF="<%=webIssue.getViewFileLink()%><%=URL%>">
                                        <IMG SRC="images/view.png"  WIDTH="20" HEIGHT="20" onmouseover="Tip('<%=attachedFiles%>',CENTERMOUSE, true, OFFSETX, 0,TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=attachedFiles%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()"> 
                                    </A>
                                    
                                    <%
                                    } else {
                                    %> 
                                    
                                    <IMG SRC="images/unview.gif"  WIDTH="20" HEIGHT="20" onmouseover="Tip('<%=notAattached%>',CENTERMOUSE, true, OFFSETX, 0,TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=attachedFiles%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                    <% }%>
                                </td-->
                                
                                
                                
                                <td CLASS="<%=bgColor%>">
                                    <% issueTasksVec = issueTasksMgr.getOnArbitraryKey(issueID, "key1");
                                    if (issueTasksVec.size()>0) {
                                    %>
                                    
                                    
                                    <IMG SRC="images/have_item.jpg" WIDTH="20" HEIGHT="20"  onmouseover="Tip('<%=noOdfTask%><%=issueTasksVec.size()%>',CENTERMOUSE, true, OFFSETX, 0,TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=taskSatus%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                    
                                    <%
                                    } else {
                                    %> 
                                    
                                    <IMG WIDTH="20" HEIGHT="20" SRC="images/have_not_item.jpg"  onmouseover="Tip('<%=haventTasks%>',CENTERMOUSE, true, OFFSETX, 0, TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=taskSatus%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                    <% }%>
                                </td>
                                <td CLASS="<%=bgColor%>">
                                    <%
                                    ScheduleUnitId = issueMgr.getScheduleUnitId(issueID);
                                    Configure = issueMgr.getConfigure(ScheduleUnitId);
                                    if (Configure.equals("Yes")) {
                                    %>
                                    <!--
                                    <A HREF="<%//=webIssue.getViewBookmarkLink()%>">
                        <IMG SRC="images/config.gif"  ALT="Configure Schedule"> 
                    </A>
                                    -->
                                    <IMG WIDTH="20" HEIGHT="20" SRC="images/config.jpg"  onmouseover="Tip('<%=configureSchedule%>',CENTERMOUSE, true, OFFSETX, 0, TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=items%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()"> 
                                    <%
                                    } else {
                                    %> 
                                    
                                    <IMG WIDTH="20" HEIGHT="20" SRC="images/nonconfig.gif"  onmouseover="Tip('<%=unConfigureSchedule%>',CENTERMOUSE, true, OFFSETX, 0, TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=items%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                    <% }%>
                                </td>
                                
                                <% if (wbo.getAttribute("scheduleType").toString().equalsIgnoreCase("External")) {%>
                                <td CLASS="<%=bgColor%>">
                                    <IMG WIDTH="20" HEIGHT="20" SRC="images/external.gif"  onmouseover="Tip('<%=externalOrder%>',CENTERMOUSE, true, OFFSETX, 0, TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=jobOrderType%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                </td>
                                <% } else if (wbo.getAttribute("issueTitle").toString().equalsIgnoreCase("Emergency")) {%>
                                <td BGCOLOR="#FFE391" >
                                    <IMG WIDTH="20" HEIGHT="20" SRC="images/emr.gif"  onmouseover="Tip('<%=normalOrder%>',CENTERMOUSE, true, OFFSETX, 0, TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=jobOrderType%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                </td>
                                <%} else {%>
                                <td CLASS="<%=bgColor%>">
                                    <IMG WIDTH="20" HEIGHT="20" SRC="images/internal.gif" onmouseover="Tip('<%=pm%>',CENTERMOUSE, true, OFFSETX, 0, TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=jobOrderType%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                </td>
                                <%}%>
                                
                                <td CLASS="<%=bgColor%>">
                                    <A onclick="JavaScript: show_popup(<%=issueID%>);">
                                        <IMG WIDTH="20" HEIGHT="20" SRC="images/field.jpg"  onmouseover="Tip('<%=viewDetails%>',CENTERMOUSE, true, OFFSETX, 0, TEXTALIGN,'<%=align%>', BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'<%=jobOrder%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                    </A>
                                </td>
                                
                            </div>
                        </TR>
                        <%}%>
                    </tbody>   
                    
                    <TR>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="10" STYLE="<%=style%>padding-right:5;border-right-width:1;font-size:16;">
                            <B><%=numTask%></B>
                        </TD>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="6" STYLE="<%=style%>;padding-left:5;font-size:16;">
                            
                            <DIV NAME="" ID="">
                                <B><%=iTotal%></B>
                            </DIV>
                        </TD>
                    </TR>
                </TABLE>
                
                <div id="pop-up" style="border:solid 2px black; display:none; z-index:10000; background-color:white;">
                    <div id="pop-up-header" style="height:20px; width:100%; background-color:#BABAD1; text-align:right; verticalAlign:middle;"><img src="images/close.gif" onclick="JavaScript: hideDiv();" style="cursor:hand; height:95%" /></div>
                    <div id="pop-up-body" style="overflow:auto; "></div>
                </div>
                <%--
                <div id="pop-up" style="height:250px; width:300px; border:solid 2px black; display:none; z-index:10000; background-color:white;">
                    <div id="pop-up-header" style="height:20px; width:100%; background-color:#BABAD1; text-align:right; verticalAlign:middle;"><img src="images/close.gif" onclick="JavaScript: hideDiv();" style="cursor:hand; height:95%" /></div>
                    <div id="pop-up-body" style="overflow:auto; width:300px; height:230px;"></div>
                </div>
                --%>
                <br>
                <div align="center">
                    <input type="hidden" name="url" value="<%=url%>" id="url" >
                        <%if(noOfLinks>0){%>
                                <br>
                            <font size="3" color="red" style="font-weight:bold" >Page No</font><font size="3" color="black" ><%=(count+1)%></font><font size="3" color="red" style="font-weight:bold" > of </font><font size="3" color="black" ><%=noOfLinks%></font>
                            &ensp;
                                <select id="pageNoDown" onchange="goToUrlDown()" style="font-size:14px;font-weight:bold;color:black">
                                     <%for(int i = 0 ;i<noOfLinks; i++){%>
                                     <option  value="<%=i%>" <%if(i == count){%> selected <%}%> ><%=(i+1)%></option>
                                     <%}%>
                                </select>
                        <%
                        }
                        %>
                </div>
                
            </FORM>
        </fieldset >
    </body>
</html>