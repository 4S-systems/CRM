<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*,com.tracker.engine.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory,com.docviewer.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%
System.out.println("in JSP ---------");
AppConstants appCons = new AppConstants();
WebIssue webIssue = null;

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

WebBusinessObject viewOrigin = new WebBusinessObject();
System.out.println(request.getParameter("op").toString());
viewOrigin.setAttribute("filter", request.getParameter("op").toString());
if(!request.getParameter("filterValue").equalsIgnoreCase("")) {
    viewOrigin.setAttribute("filterValue",request.getParameter("filterValue"));
}else {
    viewOrigin.setAttribute("filterValue",request.getParameter("maintenanceID"));
}
viewOrigin.printSelf();


String projectname = (String) request.getAttribute("projectName");

String[] issueAtt = appCons.getIssueMaintenanceAttributes();
String[] issueTitle = appCons.getIssueMaintenanceHeaders();

int s = issueAtt.length;
int t = s;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;

ImageMgr imageMgr = ImageMgr.getInstance();

IssueMgr issueMgr = IssueMgr.getInstance();

Vector  issueList = (Vector) request.getAttribute("data");
System.out.println("Vector Count = "+issueList.size());

WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;
String ts = (String) request.getAttribute("ts");

request.getSession().setAttribute("data", issueList);

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
}

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

//]]></script>

<script src='ChangeLang.js' type='text/javascript'></script>

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
    
    <BODY>
        <left>
        
        <FORM NAME="ISSUE_LISTING_FORM" METHOD="POST">
            
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"
                       onclick="reloadAE('<%=langCode%>')" STYLE="background:#cc6699;font-size:15;color:white;font-weight:bold; ">
            </DIV> 
            <TABLE  stylel="position:absolute;top:400px;left:30px;border-right-WIDTH:1px"  WIDTH="400" CELLPADDING="0" CELLSPACING="0" dir="<%=dir%>">
                <TR>
                    <TD CLASS="tabletitle"  STYLE="border-left-WIDTH: 1;<%=style%>;">
                        <b>Schedules for Site '<%=projectname%>' &amp;</b>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                </TR>
                <TR>
                    <TD CLASS="tabletitle" COLSPAN="2" STYLE="border-left-WIDTH: 1;<%=style%>;"> Maintenance '<%=request.getAttribute("maintenanceName").toString()%>'</TD>
                </TR>
                <TR>
                    <TD style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;" COLSPAN="3">
                        <A HREF="<%=context%>/SearchServlet?op=ExcelMaintenanceListProject&projectName=<%=projectname%>&MaintenanceName=<%=request.getAttribute("maintenanceName").toString()%>">
                            <img src="<%=context%>/images/xlsicon.gif"> Extract to Excel
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
                <TR CLASS="head">
                    <%
                    for(int i = 0;i<t;i++) {
                    %>
                    <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                        <a href="" onclick="return sortTable2(<%=i%>)"><%=issueTitle[i]%></a>
                    </TD>
                    
                    
                    
                    <%
                    }
                    %>
                </TR>  
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
                            bgColor="#c8d8f8";
                        } else {
                            bgColor="white";
                        }
                    %>
                    
                    <TR bgcolor="<%=bgColor%>">
                        <%
                        for(int i = 0;i<s;i++) {
                            attName = issueAtt[i];
                            attValue = (String) wbo.getAttribute(attName);
                            if(attName.equalsIgnoreCase("urgencyId") && attValue.equalsIgnoreCase("very urgent")) {
                                
                                
                                
                                cellBgColor = "red";
                            }
                            
                            
                            
                            else {
                                
                                cellBgColor = bgColor;
                            }
                        
                        
                        
                        %>
                        
                        <TD bgcolor=<%=cellBgColor%> nowrap  CLASS="cell" >
                            <DIV >
                                
                                <b> <%=attValue%> </b>
                            </DIV>
                        </TD>
                        <%
                        }
                        %>
                    </TR>
                    
                    
                    <%
                    
                    }
                    
                    %>
                    
                </tbody>
                <TR>
                    <TD CLASS="total" COLSPAN="2" STYLE="<%=style%>;padding-right:5;border-right-width:1;">
                        Total Schedules
                    </TD>
                    <TD CLASS="total" colspan="2" STYLE="<%=style%>;padding-left:5;">
                        
                        <DIV NAME="" ID="">
                            <%=iTotal%>
                        </DIV>
                    </TD>
                </TR>
            </TABLE>
            
            
        </FORM>
    </body>
</html>