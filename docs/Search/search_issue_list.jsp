<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*,com.tracker.engine.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory,com.docviewer.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%
System.out.println("in JSP ---------");
AppConstants appCons = new AppConstants();
WebIssue webIssue = null;

WebBusinessObject viewOrigin = new WebBusinessObject();
System.out.println(request.getParameter("op").toString());
viewOrigin.setAttribute("filter", request.getParameter("op").toString());
if(!request.getParameter("filterValue").equalsIgnoreCase("")) {
    viewOrigin.setAttribute("filterValue",request.getParameter("filterValue"));
}else {
    viewOrigin.setAttribute("filterValue",request.getParameter("searchTitle"));
}
viewOrigin.printSelf();


String[] issueAtt = {"issueDesc","expectedBeginDate","currentStatus"};
String[] issueTitle ;

int s = issueAtt.length;
int t = s+5;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;

IssueMgr issueMgr = IssueMgr.getInstance();

ImageMgr imageMgr = ImageMgr.getInstance();

Vector  issueList = (Vector) request.getAttribute("data");
System.out.println("Vector Count = "+issueList.size());

WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;
String bgColorm = null;
String ts = (String) request.getAttribute("ts");
/*String issueStatus = (String) request.getAttribute("status");
String filterName = (String) request.getAttribute("filterName");
String filterValue = (String) request.getAttribute("filterValue");*/

//System.out.println("Status = "+issueStatus);
//if(null==issueStatus) {
//  issueStatus = "**";
//}
String issueID = null;
String UnitName = null;
String MaintenanceTitle=null;
String ScheduleUnitId=null;
String Configure = null;
WebBusinessObject eqWbo = (WebBusinessObject) request.getAttribute("eqWbo");
String unitName = new String("");
if(eqWbo != null){
    unitName = (String) eqWbo.getAttribute("unitName");
}
String stat= (String) request.getSession().getAttribute("currentMode");
String align="center";
String dir=null;
String style=null;
String lang,langCode,indGuid,attached,termainanted,nconfig,Config,updateTime,notAattached,notTermainanted;
String showDetails,searchRe,numTask,QuikSummry,basicOP,workFlow,signe,mark,viewD,DM,sta,schduled,Begined,Finished,Canceled,Holded,Rejected,external,em,pm;
if(stat.equals("En")){
    
    
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    
    issueTitle =new String[8];
    issueTitle[0]="Mainttenance number";
    issueTitle[1]="start date";
    issueTitle[2]="Status";
    issueTitle[3]="Mainttenance name";
    issueTitle[4]="Details";
    issueTitle[5]="Bookmark";
    issueTitle[6]="Backward";
    issueTitle[7]="Forward";
    indGuid=" Indicators guide ";
    nconfig="configured task";
    Config="Not yet configured task";
    attached="view attached files";
    notAattached="There is no attached files";
    termainanted="Termaintanted task"  ;
    notTermainanted="Not Termaintanted task"  ;
    updateTime="update date time";
    showDetails="show Details";
    searchRe="Search by Title";
    numTask=" Tasks Number";
    QuikSummry=" Quick Summary ";
    basicOP="Basic Operations";
    workFlow="Work Flow";
    signe="Guide";
    mark="Mark";
    viewD="View Details";
    DM="Delete Mark";
    sta="Status";
    schduled="Scheduled";
    Begined="Started";
    Finished="Finished";
    Canceled="Canceled";
    Holded="on Hold";
    Rejected="Rejected";
    external="External job Order";
    em="Emergency Job Order";
    pm="Premaintative Maintenance";
    
}else{
    
    
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    issueTitle =new String[8];
    issueTitle[0]="&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    issueTitle[1]=" &#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;";
    issueTitle[2]="&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
    issueTitle[3]="&#1575;&#1587;&#1605; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    issueTitle[4]="&#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    issueTitle[5]="&#1593;&#1604;&#1575;&#1605;&#1607; ";
    issueTitle[6]= "&#1604;&#1604;&#1582;&#1604;&#1601;";
    issueTitle[7]="&#1604;&#1604;&#1571;&#1605;&#1575;&#1605;";
    indGuid= "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    attached="&#1573;&#1590;&#1594;&#1591; &#1604;&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;&#1607;";
    notAattached="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;";
    termainanted="&#1605;&#1607;&#1605;&#1607; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;";
    notTermainanted="&#1605;&#1607;&#1605;&#1607; &#1594;&#1610;&#1585; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;"  ;
    Config="&#1580;&#1583;&#1608;&#1604; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    nconfig="&#1580;&#1583;&#1608;&#1604; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    updateTime="&#1578;&#1581;&#1583;&#1610;&#1579; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1593;&#1605;&#1604;";
    showDetails="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    searchRe="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
    numTask="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;  ";
    QuikSummry="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    basicOP="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    workFlow="&#1575;&#1604;&#1583;&#1608;&#1585;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1610;&#1577;";
    signe="&#1575;&#1604;&#1585;&#1605;&#1586;";
    mark="&#1593;&#1604;&#1575;&#1605;&#1607;";
    viewD="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    DM="&#1581;&#1584;&#1601; &#1575;&#1604;&#1593;&#1604;&#1575;&#1605;&#1577;";
    sta="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    schduled="&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
    Begined="&#1576;&#1583;&#1571;&#1578;";
    Finished="&#1573;&#1606;&#1578;&#1607;&#1578;";
    Canceled="&#1605;&#1604;&#1594;&#1575;&#1577;";
    Holded="&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
    Rejected="&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
    external="&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1582;&#1575;&#1585;&#1580;&#1610;";
    em="&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1587;&#1585;&#1610;&#1593;";
    pm="&#1589;&#1610;&#1575;&#1606;&#1577; &#1608;&#1602;&#1575;&#1574;&#1610;&#1607;";
}

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Tracker- List Schedules</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        <!-- Begin hiding Javascript
        function submitForm()
        {
    
        document.ISSUE_LISTING_FORM.action = "/Tracker/IssueServlet?op=ListTimeBound";
        document.ISSUE_LISTING_FORM.submit();  
        }
      
        -->
    </script>
    
    <script type="text/javascript">//<![CDATA[

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
    //]]>

    </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY>
        <table align="<%=align%>" border="0" width="100%">
            <tr>
                <td width="50%" STYLE="border:0px;">
                    <div STYLE="margin: auto;width:80%;border:2px solid gray;background-color:#91a6b7;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                        <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#91a6b7;color:white;cursor:hand;font-size:16;">
                            <b>
                                <%=indGuid%>
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu1">
                            <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                <tr>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="20%"><IMG SRC="images/view.png" ALIGN=""ALT="view file" > <b><%=attached%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="20%"><IMG SRC="images/unassign.gif"  ALT="Terminated Task" > <b><%=termainanted%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="20%"><IMG SRC="images/config.jpg"  ALT="Configured Schedule" > <b><%=Config%></b></td>
                                    <!--td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<!%=style%>;" width="16%"><IMG SRC="images/timer.gif"  ALT="Update Job Date"> <b><!%=updateTime%></b></td-->
                                    <td CLASS="indicator" bgcolor="white"STYLE="<%=style%>" width="20%"><IMG WIDTH="20" HEIGHT="20" SRC="images/emr.gif" ALT="Emergency job order"> <b><%=em%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="20%"><IMG WIDTH="20" HEIGHT="20" SRC="images/external.gif" ALT="External job order"> <b><%=external%></b></td>
                                </tr>
                                <tr>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>"<IMG SRC="images/unview.gif" ALT="non attached file" > <b><%=notAattached%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>"<IMG SRC="images/assign.gif" ALT="UnTerminated Task" > <b><%=notTermainanted%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>"<IMG SRC="images/nonconfig.gif"  ALT="Un configure Schedule"> <b><%=nconfig%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>"<IMG WIDTH="20" HEIGHT="20" src="images/metal-Inform.gif"  ALT="Un configure Schedule"> <b><%=showDetails%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>"<IMG WIDTH="20" HEIGHT="20" SRC="images/internal.gif" ALT="Premaintative Maintenance"> <b><%=pm%></b></td>
                                    <!--td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<!%=style%>;"></td-->
                                </tr>                                
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
            
            <tr>
                <td width="100%" STYLE="border:0px;">
                    
                    <div STYLE="margin: auto;width:80%;border:2px solid gray;background-color:#91a6b7;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                        <div ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#91a6b7;color:white;cursor:hand;font-size:16;">
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
        <FORM NAME="ISSUE_LISTING_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
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
                <br><br>
                <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                    <th colspan="5" class="td" dir="<%=dir%>">  <DIV  align="<%=align%>">
                            
                            <B> <%=numTask%> : <%=issueList.size()%>   </B>
                        </DIV>
                    </th>
                    <TR >
                        <TD class="blueBorder blueHeaderTD" COLSPAN="5" bgcolor="#808000" STYLE="height: 20px;text-align:center;color:white;font-size:18">
                            <B><%=QuikSummry%></B>
                        </TD>
                        <TD class="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                            <B><%=basicOP%></B>
                        </TD>
                        <TD class="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#999999" STYLE="text-align:center;color:white;font-size:18">
                            <B><%=workFlow%></B>
                        </TD>
                        <TD class="blueBorder blueHeaderTD" COLSPAN="4" bgcolor="#CC9900" STYLE=" text-align:center;color:white;font-size:18">
                            <B><%=indGuid%></B>
                        </TD>
                    </TR>
                    <Tr >
                    <TD nowrap CLASS="silver_header" bgcolor="#9B9B00" STYLE="border-WIDTH:0; font-size:14;" nowrap>
                        <font >   <a href="" onclick="return sortTable2(0)" >#</a></font>
                    </td>
                    <%
                    String columnColor = new String("");
                    String columnWidth = new String("");
                    String font = new String("");
                    for(int i = 0;i<t;i++) {
                        if(i == 0 || i == 1 ||i == 2 || i==3 ){
                            columnColor = "#9B9B00";
                        } else if ( i==5 || i==4){
                            columnColor = "#7EBB00";
                        } else {
                            columnColor = "#CCCCCC";
                        }
                        if(issueTitle[i].equalsIgnoreCase("")){
                            columnWidth = "1";
                            columnColor = "black";
                            font = "1";
                        } else {
                            columnWidth = "100";
                            font = "12";
                        }
                    
                    %>
                    
                    <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
                        <% if (i <= 3) {
                        
                        %>
                        
                        
                        <a href="" onclick="return sortTable2(<%=i+1%>)" ><%=issueTitle[i]%></a>
                        
                        <% 
                        } else { %>
                        <%=issueTitle[i]%>
                        <%
                        }
                        
                        %>
                        
                    </TD>
                    
                    
                    
                    <%
                    
                    }
                    %>
                    
                    <td nowrap BGCOLOR="#FFBF00" colspan="4" CLASS="silver_header" WIDTH="60" STYLE="text-align:center;border-top-WIDTH:0; font-size:12" nowrap>
                        <font > &nbsp; </font>
                    </td>
                    </tr>
                    <tbody id="planetData2">
                        <%
                        
                        Enumeration e = issueList.elements();
                        String status = null;
                        
                        while(e.hasMoreElements()) {
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();
                            webIssue = (WebIssue) wbo;
                            webIssue.setViewOrigin(viewOrigin);
                            flipper++;
                         if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    }
                            issueID = (String) wbo.getAttribute("id");
                        %>
                        
                        <TR>
                            <%
                            for(int i = 0;i<s;i++) {
                                attName = issueAtt[i];
                                attValue = (String) wbo.getAttribute(attName);
                                if(i==1){
                                    attValue = attValue.substring(8,10)+"-"+attValue.substring(5,7)+"-"+attValue.substring(0,4);
                                    
                                }
                                if(attName.equalsIgnoreCase("urgencyId") && attValue.equalsIgnoreCase("very urgent")) {
                                    
                                    
                                    
                                    cellBgColor = "red";
                                }
                                
                                
                                
                                else {
                                    
                                    cellBgColor = bgColor;
                                }
                                
                                
                                
                                if(i == 0) {
                            %>
                            
                            <%
                            ScheduleUnitId=issueMgr.getScheduleUnitId(issueID);
                            MaintenanceTitle= issueMgr.getUnitName(ScheduleUnitId);
                            
                            if(MaintenanceTitle == null){
                                MaintenanceTitle="No found Title";
                            }
                            %>
                            
                            <TD nowrap BGCOLOR="#DDDD00" STYLE="text-align:center" CLASS="<%=bgColorm%>">
                                <b><%=iTotal%> </b> 
                            </td>
                            <TD  nowrap  BGCOLOR="#DDDD00" CLASS="cell" >
                                <%= (String) webIssue.getAttribute("id")%>
                            </td>
                            <%
                                } else { %>
                            
                            
                            <TD bgcolor="#DDDD00" nowrap  CLASS="<%=bgColor%>" >
                                <DIV >
                                    
                                    <b> <%=attValue%> </b>
                                </DIV>
                            </TD>
                            <%
                                }
                            }
                            %>
                            
                            <%
                            ScheduleUnitId=issueMgr.getScheduleUnitId(issueID);
                            UnitName= issueMgr.getUnitName(ScheduleUnitId);
                            if(UnitName == null){
                                UnitName="No found Unit for Schedule";
                            }
                            %>
                            <TD nowrap BGCOLOR="#DDDD00" CLASS="<%=bgColor%>" STYLE="padding-left:10;text-align:left;">
                                <DIV ID="links">
                                    <%=UnitName%>
                                    
                                </DIV>
                            </TD>
                            <TD  nowrap  BGCOLOR="#D7FF82" DIR="<%=dir%>" CLASS="<%=bgColor%>">
                                <DIV align="<%=align%>">
                                    <A HREF="<%=webIssue.getViewDetailLink()%>&mainTitle=<%=MaintenanceTitle%>">
                                        
                                        
                                        <img src="images/metal-Inform.gif" alt="<%=(String) wbo.getAttribute(attName)%>" width="20">
                                        <%=viewD%>
                                    </A>
                                </DIV>
                            </TD>
                            <%
                            
                            if(webIssue.isBookmarked()) {
                            %>
                            
                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-left:10;<%=style%>;">
                                
                                <DIV ID="links">
                                    
                                    <A HREF="<%=webIssue.getUndoBookmarkLink()%>">
                                        <%=DM%>  
                                    </A>
                                    
                                    <A HREF="<%=webIssue.getViewBookmarkLink()%>">
                                        <IMG SRC="images/img_bookmarks.gif"  ALT="Click icon for bookmark note"> 
                                    </A>
                                </DIV>
                            </TD>
                            <%
                            } else {
                            %> 
                            <TD nowrap BGCOLOR="#D7FF82" CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>;">
                                <DIV ID="links">
                                    <A HREF="javascript:popup('<%=webIssue.getBookmarkLink()%>')" alt="Add bookmark">
                                        <%=mark%>
                                        
                                    </A>
                                </DIV>
                            </TD>
                            <%
                            }
                            
                            
                            %>
                            <TD BGCOLOR="#EBEBEB" nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;text-align:left;">
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
                                        %>
                                        
                                        <td width="80">
                                            <A HREF="<%=webIssue.getReverseStateLink()%>">
                                                <b> <%=webIssue.getReverseStateAction()%> </b>
                                            </A>
                                        </td> 
                                        
                                        <%
                                        if(webIssue.isUserOwner()) {
                                        %>
                                        <td width="20">
                                            
                                            <A HREF="<%=webIssue.getReverseStateLink()%>">
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
                            
                            <TD BGCOLOR="#EBEBEB" nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;text-align:left;">
                                <table>
                                    <tr>
                                        
                                        <%
                                        String myState = (String) webIssue.getState();
                                        if (webIssue.isTerminal()|| myState.equalsIgnoreCase(IssueStatusFactory.DELETED))
                                            
                                        {
                                        %>
                                        <td width="80">
                                            <b> <%=webIssue.getNextStateAction()%> </b>
                                        </td>
                                        <%
                                        
                                        if(webIssue.isUserOwner()) {
                                        %>
                                        
                                        <td>
                                            <IMG SRC="images/unassign.gif"  ALT="Click to move forward"> 
                                        </td>
                                        <%
                                        }
                                        %>
                                        
                                        <%
                                        } else {
                                        %>
                                        <td width="80">
                                            <A HREF="<%=webIssue.getNextStateLink()%>">
                                                <b> <%=webIssue.getNextStateAction()%> </b>
                                            </A>
                                        </td>
                                        <%
                                        if(webIssue.isUserOwner()) {
                                        %>
                                        
                                        <td >
                                            <A HREF="<%=webIssue.getNextStateLink()%>">
                                                
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
                            </TD>
                            
                            <DIV align="center">
                                
                                
                                <td CLASS="<%=bgColor%>">
                                    <%
                                    if(imageMgr.hasDocuments(webIssue.getAttribute("id").toString())) {
                                    %>
                                    <A HREF="<%=webIssue.getViewFileLink()%>">
                                        <IMG SRC="images/view.png"  ALT="view file"> 
                                    </A>
                                    
                                    <%
                                    } else {
                                    %> 
                                    
                                    <IMG SRC="images/unview.gif"  ALT="non attached file">
                                    <% } %>
                                </td>
                                
                                
                                
                                <td CLASS="<%=bgColor%>">
                                    <%
                                    if (webIssue.isTerminal()) {
                                    %>
                                    <b> <%//=webIssue.getReverseStateAction()%> </b>
                                    
                                    <IMG SRC="images/unassign.gif"  ALT="Terminated Task">
                                    
                                    <%
                                    } else {
                                    %> 
                                    
                                    <IMG SRC="images/assign.gif"  ALT="UnTerminated Task">
                                    <% } %>
                                </td>
                                <td CLASS="<%=bgColor%>">
                                    <%
                                    ScheduleUnitId=issueMgr.getScheduleUnitId(issueID);
                                    Configure= issueMgr.getConfigure(ScheduleUnitId);
                                    if(Configure.equals("Yes")) {
                                    %>
                                    <!--
                                    <A HREF="<%//=webIssue.getViewBookmarkLink()%>">
                        <IMG SRC="images/config.gif"  ALT="Configure Schedule"> 
                    </A>
                    -->
                                    <IMG SRC="images/config.jpg"  ALT="Configured Schedule"> 
                                    <%
                                    } else {
                                    %> 
                                    
                                    <IMG SRC="images/nonconfig.gif"  ALT="Un configure Schedule">
                                    <% } %>
                                </td>
                            </div>
                            
                        </TR>
                        
                        
                        <%
                        
                        }
                        
                        %>
                        
                    </tbody>
                    <TR>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="6" STYLE="<%=style%>text-align:right;padding-right:5;border-right-width:1;font-size:16;">
                            <B><%=numTask%></B>
                        </TD>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="1" STYLE="<%=style%>;padding-left:5;font-size:16;">
                            
                            <DIV NAME="" ID="">
                                <B><%=iTotal%></B>
                            </DIV>
                        </TD>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="1" STYLE="<%=style%>;padding-left:5;font-size:16;"></td>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="1" STYLE="<%=style%>;padding-left:5;font-size:16;"></td>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="1" STYLE="<%=style%>;padding-left:5;font-size:16;"></td>
                    </TR>
                </TABLE>
                <BR>
            </FIELDSET>
        </FORM>
    </body>
</html>