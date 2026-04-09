<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%
System.out.println("in JSP ---------");
AppConstants appCons = new AppConstants();
WebIssue webIssue = null;

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String[] issueAtt = appCons.getIssueAttributes();
String[] issueTitle = appCons.getIssueHeaders();

int s = issueAtt.length;
int t = s+7;

String attName = null;
String attValue = null;
String cellBgColor = null;

IssueMgr issueMgr = IssueMgr.getInstance();

ImageMgr imageMgr = ImageMgr.getInstance();

Vector  issueList = (Vector) request.getAttribute("data");
System.out.println("Vector Count = "+issueList.size());

WebBusinessObject wbo = null;
int flipper = 0;
int iTotal = 0;
String bgColor = null;
String ts = (String) request.getAttribute("ts");
String issueStatus = (String) request.getAttribute("status");
String filterName = "RiskReport";
String filterValue = (String) request.getAttribute("filterValue");
String issueID = null;

String projectname = (String) request.getAttribute("projectName");

System.out.println("Status = "+issueStatus);
if(null==issueStatus) {
    issueStatus = "**";
}
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

//]]></script> 

<script src='ChangeLang.js' type='text/javascript'></script>


<BODY>
<left>

<FORM NAME="ISSUE_LISTING_FORM" METHOD="POST">


<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>"
           onclick="reloadAE('<%=langCode%>')" STYLE="background:#cc6699;font-size:15;color:white;font-weight:bold; ">
</DIV> 
<TABLE  stylel="position:absolute;top:400px;left:30px;border-right-WIDTH:1px"  WIDTH="400" CELLPADDING="0" CELLSPACING="0" dir="<%=dir%>">
    
    
    
    <TD nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;<%=style%>;">
        <%=issueStatus%> Schedules
    </TD>
    <TD CLASS="tabletitle" STYLE="<%=style%>">
        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
    </TD>
    
    
    </TR>
</TABLE>


<TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
    <TR CLASS="head">
        <%
        for(int i = 0;i<t;i++) {
        
        
        
        %>
        
        <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <%
            if (i <= 5 && i > 0) {
            
            %>
            
            <a href="" onclick="return sortTable2(<%=i%>)"><%=issueTitle[i]%></a>
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
    </TR>  
    <tbody id="planetData2">    
        
        <%
        
        Enumeration e = issueList.elements();
        String status = null;
        
        while(e.hasMoreElements()) {
            iTotal++;
            wbo = (WebBusinessObject) e.nextElement();
            webIssue = (WebIssue) wbo;
            flipper++;
            if((flipper%2) == 1) {
                bgColor="#c8d8f8";
            } else {
                bgColor="white";
            }
            issueID = (String) wbo.getAttribute("id");
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
                
                
                
                if(i == 0) {
            %>
            <TD bgcolor=<%=cellBgColor%> nowrap  CLASS="cell">
                <DIV align="<%=align%>">
                    <A HREF="<%=context%>/AssignedIssueServlet?op=viewdetails&issueId=<%=webIssue.getAttribute("id")%> &filterValue=<%=filterValue%>&filterName=RiskReport&projectName=<%=projectname%>">
                        <img src="images/metal-Inform.gif" alt="<%=(String) wbo.getAttribute(attName)%>" width="20">
                        View Details
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
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                <DIV ID="links">
                    <A HREF="<%=context%>/IssueServlet?op=GetEditForm&issueID=<%=issueID%>&filterName=RiskReport&filterValue=<%=filterValue%>&projectName=<%=projectname%>">
                        Edit
                    </A>
                </DIV>
            </TD>
          
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                <DIV ID="links">
                    <A HREF="<%=context%>/SearchServlet?op=ViewHistory&issueId=<%=webIssue.getAttribute("id")%>&fValue=<%=filterValue%>&fName=RiskReport&projectName=<%=projectname%>">
                        View History
                    </A>
                </DIV>
            </TD>
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                <DIV ID="links">
                    <A HREF="<%=webIssue.getAttachFileLink(filterName,filterValue,projectname)%>">
                        Attach Files
                    </A>
                </DIV>
                
            </TD>
            
            <%
            if(imageMgr.hasDocuments(webIssue.getAttribute("id").toString())) {
            %>
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                <DIV ID="links">
                    <A HREF="<%=webIssue.getViewFileLink(filterName,filterValue,projectname)%>">
                        View Files
                    </A>
                    <A HREF="<%=webIssue.getViewFileLink(filterName,filterValue,projectname)%>">
                        <IMG SRC="images/conticon.gif"  ALT="Click icon for bookmark note"> 
                    </A>
                </DIV>
                
            </TD>
            
            <%
            } else {
            %> 
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                <DIV ID="links">
                    
                    No file Attach
                    
                </DIV>
            </TD>
            
            <%
            }
            %>
            
            
            
            <%
            
            if(webIssue.isBookmarked()) {
            %>
            
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                
                <DIV ID="links">
                    
                    <A HREF="<%=context%>/BookmarkServlet?op=delete&key=<%=webIssue.getBookmarkId()%>&issueState=<%=webIssue.getState()%>&viewOrigin=&filterValue=<%=filterValue%>&filterName=RiskReport&projectName=<%=projectname%>">
                        Unmark
                    </A>
                    
                    <A HREF="<%=context%>/BookmarkServlet?op=view&key=<%=webIssue.getBookmarkId()%>&issueState=<%=webIssue.getState()%>&viewOrigin=&filterValue=<%=filterValue%>&filterName=RiskReport&projectName=<%=projectname%>">
                        <IMG SRC="images/img_bookmarks.gif"  ALT="Click icon for bookmark note"> 
                    </A>
                </DIV>
            </TD>
            <%
            } else {
            %>
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                <DIV ID="links">
                    <A HREF="<%=context%>/BookmarkServlet?op=togol&issueId=<%=webIssue.getAttribute("id")%>&issueTitle=<%=webIssue.getAttribute("issueTitle")%>&issueState=<%=webIssue.getState()%>&filterValue=<%=filterValue%>&filterName=RiskReport&projectName=<%=projectname%>">
                        Bookmark
                    </A>
                </DIV>
            </TD>
            <%
            }
            
            
            %>
            <TD  nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                <table dir="<%=dir%>">
                    <tr>
                        <%
                        
                        if (webIssue.isTerminal()) {
                        %>
                        <td width="80">
                            <b> <%=webIssue.getReverseStateAction()%> </b>
                        </td>
                        <td  width="20">
                            <IMG SRC="images/stop.gif"  ALT="Click to move forward">
                        </td>
                        
                        
                        <%
                        } else {
                        %>
                        
                        <td width="80">
                            <A HREF="<%=webIssue.getReverseStateRiskLink(filterValue,projectname)%>">
                                <b> <%=webIssue.getReverseStateAction()%> </b>
                            </A>
                        </td> 
                        
                        <%
                        if(webIssue.isUserOwner()) {
                        %>
                        <td width="20">
                            
                            <A HREF="<%=webIssue.getReverseStateRiskLink(filterValue,projectname)%>">
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
            
            <TD     nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
                <table dir="<%=dir%>">
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
                            <IMG SRC="images/stop.gif"  ALT="Click to move forward"> 
                        </td>
                        <%
                        }
                        %>
                        
                        <%
                        } else {
                        %>
                        <td width="80">
                            <A HREF="<%=webIssue.getNextStateRiskLink(filterValue,projectname)%>&projectName=<%=projectname%>">
                                <b> <%=webIssue.getNextStateAction()%> </b>
                            </A>
                        </td>
                        <%
                        if(webIssue.isUserOwner()) {
                        %>
                        
                        <td >
                            <A HREF="<%=webIssue.getNextStateRiskLink(filterValue,projectname)%>&projectName=<%=projectname%>">
                                
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
        </TR>
        
        
        <%
        
        }
        
        %>
        
    </tbody>
    
    <TR>
        <TD CLASS="total" COLSPAN="6" STYLE="<%=style%>;padding-right:5;border-right-width:1;">
            Total Schedules
        </TD>
        <TD CLASS="total" colspan="1" STYLE="<%=style%>;padding-left:5;">
            
            <DIV NAME="" ID="">
                <%=iTotal%>
            </DIV>
        </TD>
    </TR>
</TABLE>


</FORM>
</body>
</html>