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
    viewOrigin.setAttribute("filterValue",request.getParameter("workerID"));
}
viewOrigin.printSelf();


String projectname = (String) request.getAttribute("projectName");

String[] issueAtt = appCons.getIssueAttributes();
String[] issueTitle = appCons.getIssueHeaders();

int s = issueAtt.length;
int t = s+6;
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

<table border="0" dir="ltr">
    
    <tr>
        <td colspan="3" border="0" bgcolor="#F3F3F3"><font color="#009FEC"><b>Indicators guide</b></font></td>
    </tr>
    <tr>
        <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/view.png" ALT="view file" ALIGN="left"><FONT COLOR="red" dir="ltr">Click to view attached file</font></td>
        <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/unassign.gif"  ALT="Terminated Task" ALIGN="left"><FONT COLOR="red" dir="ltr">Terminated Task</font></td>
        <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/img_bookmarks.gif"  ALT="Click icon for bookmark note" ALIGN="left"><FONT COLOR="red" dir="ltr">Click icon for bookmark note</font></td>
        <td></td>
    </tr>
    <tr>
        <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/unview.gif" ALT="non attached file" ALIGN="left"><FONT COLOR="red" dir="ltr">No file attached</font></td>
        <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/assign.gif" ALT="UnTerminated Task" ALIGN="left"><FONT COLOR="red" dir="ltr">UnTerminated Task</font></td>
        <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/nonmark.jpg"  ALT="Unmarked Task"><FONT COLOR="red" dir="ltr">Unmarked Task</font></td>
        <td></td>
    </tr>
    
</table>

<FORM NAME="ISSUE_LISTING_FORM" METHOD="POST">

<TABLE  stylel="position:absolute;top:400px;left:30px;border-right-WIDTH:1px"  WIDTH="400" CELLPADDING="0" CELLSPACING="0">
    
    
    <%                       
    //<TD nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
    //    //issueStatus Issues
    //</TD>%>
    <TD COLSPAN="2" CLASS="tabletitle"  STYLE="border-left-WIDTH: 1;text-align:left;">
                        <b> Search By Worker</b>
                    </TD>
    <TD CLASS="tabletitle" STYLE="">
        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
    </TD>
    
    
    </TR>
</TABLE>


<TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    <TR CLASS="head">
        
        <%
        for(int i = 0;i<t;i++) {
        
        
        
        %>
        
        <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <% if (i <= 5 && i > 0) {
            
            %>
            
            
            <a href="" onclick="return sortTable2(<%=i+3%>)"><%=issueTitle[i]%></a>
            
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
        
        <td nowrap  colspan="3" CLASS="firstname" WIDTH="60" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                                                                                                             Indicators
                                                                                                             </td>
        
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
            
            issueID = (String) wbo.getAttribute("id");
        %>
        
        <TR bgcolor="<%=bgColor%>">
            <!--TD>
                        <!%
                        if(wbo.getAttribute("isRisk").toString().equalsIgnoreCase("Yes")) {
                        %>
                        <img src="images/stop.gif">
                        <!%
                        } else {
                        %>
                        <img src="images/testplan.gif">
                        <!%
                        }
                        %>
                        </TD-->
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
                
                
                
                if(i == 0) {
            %>
            <%
                        ScheduleUnitId=issueMgr.getScheduleUnitId(issueID);
                        MaintenanceTitle= issueMgr.getUnitName(ScheduleUnitId);
                        
                         if(MaintenanceTitle == null){
                             MaintenanceTitle="No found Title";
                                     }
                         %>
            
            
            <TD bgcolor=<%=cellBgColor%> nowrap  CLASS="cell">
                <DIV align="center">
                    <A HREF="<%=webIssue.getViewDetailLink()%>&mainTitle=<%=MaintenanceTitle%>">
                        View Details
                        <img src="images/metal-Inform.gif" alt="<%=(String) wbo.getAttribute(attName)%>" width="20">
                        
                    </A>
                </DIV>
            </TD>
            <%
                } else { %>
            
            <TD bgcolor=<%=cellBgColor%> nowrap  CLASS="cell" >
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
                        <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                            <DIV ID="links">
                                       <%=UnitName%>
                                
                            </DIV>
                        </TD>
                        
                        <%
                        ScheduleUnitId=issueMgr.getScheduleUnitId(issueID);
                        MaintenanceTitle= issueMgr.getMaintenanceTitle(ScheduleUnitId);
                         if(MaintenanceTitle == null){
                             MaintenanceTitle="No found Title";
                                     }
                         %>
                        <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                            <DIV ID="links">
                                       <%=MaintenanceTitle%>
                                
                            </DIV>
                        </TD>
            <!--TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                        <DIV ID="links">
                        <A HREF="<!%=webIssue.getViewWorkerDetailLink(projectname)%>">
                        View Details
                        </A>
                        </DIV>
                        </TD-->
                        
                       
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
                    <A HREF="<%//=webIssue.getViewWorkerHistoryLink(projectname)%>">
                        View History
                    </A>
                </DIV>
            </TD>
            
             <!--
            
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
                    <A HREF="<%//=webIssue.getAttachFileLink(projectname)%>">
                        Attach Files
                    </A>
                </DIV>
                
            </TD>
            
            <%
           // if(imageMgr.hasDocuments(webIssue.getAttribute("id").toString())) {
            %>
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
                    <A HREF="<%//=webIssue.getViewFileLink()%>&projectName=<%=projectname%>">
                        View Files
                    </A>
                    <A HREF="<%//=webIssue.getViewFileLink()%>&projectName=<%=projectname%>">
                        <IMG SRC="images/view.png"  ALT="Click icon for bookmark note"> 
                    </A>
                </DIV>
                
            </TD>
            
            <%
           // } else {
            %> 
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
                    
                    No file Attach
                    
                </DIV>
            </TD>
            
            <%
          //  }
            %>
            -->
            
            <%
            
            if(webIssue.isBookmarked()) {
            %>
            
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                
                <DIV ID="links">
                    
                    <A HREF="<%=webIssue.getUndoBookmarkLink(projectname)%>">
                        Unmark
                    </A>
                    
                    <A HREF="<%=webIssue.getViewBookmarkLink(projectname)%>">
                        <IMG SRC="images/img_bookmarks.gif"  ALT="Click icon for bookmark note"> 
                    </A>
                </DIV>
            </TD>
            <%
            } else {
            %> 
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
                    <A HREF="<%=webIssue.getBookmarkLink(projectname)%>">
                        Bookmark
                    </A>
                </DIV>
            </TD>
            <%
            }
            
            
            %>
            <TD  nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
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
                            <A HREF="<%=webIssue.getReverseStateLink(projectname)%>&projectName=<%=projectname%>">
                                <b> <%=webIssue.getReverseStateAction()%> </b>
                            </A>
                        </td> 
                        
                        <%
                        if(webIssue.isUserOwner()) {
                        %>
                        <td width="20">
                            
                            <A HREF="<%=webIssue.getReverseStateLink(projectname)%>&projectName=<%=projectname%>">
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
            
            <TD     nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
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
                            <A HREF="<%=webIssue.getNextStateLink(projectname)%>&projectName=<%=projectname%>">
                                <b> <%=webIssue.getNextStateAction()%> </b>
                            </A>
                        </td>
                        <%
                        if(webIssue.isUserOwner()) {
                        %>
                        
                        <td >
                            <A HREF="<%=webIssue.getNextStateLink(projectname)%>&projectName=<%=projectname%>">
                                
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
                
                
                <td>
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
                
                
                
                <td>
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
                <td>
                    <%
                    
                    if(webIssue.isBookmarked()) {
                    %>
                    <A HREF="<%=webIssue.getViewBookmarkLink()%>">
                        <IMG SRC="images/img_bookmarks.gif"  ALT="Click icon for bookmark note"> 
                    </A>
                    <%
                    } else {
                    %> 
                    
                    <IMG SRC="images/nonmark.jpg"  ALT="Unmarked Task">
                    <% } %>
                </td>
            </div>
            
            
            
        </TR>
        
        
        <%
        
        }
        
        %>
        
    </tbody>
    <TR>
        <TD CLASS="total" COLSPAN="6" STYLE="text-align:right;padding-right:5;border-right-width:1;">
            Total Schedules
        </TD>
        <TD CLASS="total" colspan="1" STYLE="text-align:left;padding-left:5;">
            
            <DIV NAME="" ID="">
                <%=iTotal%>
            </DIV>
        </TD>
    </TR>
</TABLE>


</FORM>
</body>
</html>