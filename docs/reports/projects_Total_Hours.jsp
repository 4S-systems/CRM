<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
    
<HTML>
    <%
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();


        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        //String op = (String) request.getAttribute("op");
        String ts = (String) request.getAttribute("ts");
        //System.out.println("target op is " + op );

        Vector  projectStatusList = (Vector) request.getAttribute("data");
        WebBusinessObject wbo = null;

        Enumeration e = projectStatusList.elements();
        Enumeration eTotal = projectStatusList.elements();
        Double iTemp = new Double(0);
        int iTotal = 0;
        
        request.getSession().setAttribute("data", projectStatusList);

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
        <TITLE>Equipment Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
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
    
    
    <BODY>
        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR VALIGN="MIDDLE">
                <TD COLSPAN="2" CLASS="tabletitle"  STYLE="border-left-WIDTH: 1;text-align:left;">
                  <font size="5">  <b>Worker Statistics for '<%=request.getParameter("projectName")%>'</b></font>
                </TD>
                <TD CLASS="tabletitle" STYLE="">
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                </TD>
            </TR>
            <TR style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;"><TD COLSPAN="3"><A HREF="<%=context%>/SearchServlet?op=HoursExcel&projectName=<%=request.getParameter("projectName")%>"><img src="<%=context%>/images/xlsicon.gif"> Extract to Excel</A></TD></TR>
        </TABLE>
        <%
            while(eTotal.hasMoreElements()) {
                wbo = (WebBusinessObject) eTotal.nextElement();
                iTemp = new Double((String) wbo.getAttribute("total"));
                iTotal = iTotal + iTemp.intValue();
            }
        %>
        
        <BR>
        <p dir="ltr"><b><font size="4" color="#800080">Total Hours for Schedules : <%=iTotal%> Hours </font></b></p>
        <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR>  
                <TD class="td" >
                    &nbsp;
                </TD>
            </TR>
        </TABLE>
        <TABLE WIDTH="500" CELLPADDING="0" CELLSPACING="0" >
            <TR  bgcolor="#C8D8F8">
            
                <TD><font size="4">
                    Site
                </font></TD>
                <TD><font size="4">
                    Assigin To
                </font></TD>
                <TD><font size="4">
                    Total
                </font> </TD>
                
            </TR>
            <%
                String sLabels = new String("");
                String sworker = new String("");
                String sValues = new String("");
                while(e.hasMoreElements()) {
                    wbo = (WebBusinessObject) e.nextElement();
                    sLabels = sLabels + " " + wbo.getAttribute("projectName").toString();
                    sworker = sworker + " " + wbo.getAttribute("assignedToName").toString();
            %>
            <TR>
            
                <TD>
                <p ><b><font size="4" color="#800080">
                    <%=wbo.getAttribute("projectName")%>
                </font></b></p>
                </TD>
                
                <TD>
                <p ><b><font size="4" color="#800080">
                    <%=wbo.getAttribute("assignedToName")%>
                </font></b></p>
                </TD>
                
                <TD>
                    <p ><b><font size="4" color="#800080">
                    <%
                        iTemp = new Double((String) wbo.getAttribute("total"));
                        sValues = sValues + " " + iTemp.toString();
                    %>
                    <%=iTemp.intValue()%>
                    </font></b></p>
                </TD>
            
            </TR>      
            <%
                    }
            %>
            
            <TR>
                <TD bgcolor="#C8D8F8"COLSPAN="2">
                <p ><b><font size="3">
                   <B>Total Hours</B>
                    </FONT></b></p>
                </TD>
                
                <TD bgcolor="#C8D8F8">
                <p><font size="3">
                   <B><%=iTotal%></B>
                </font></b></p>
                
                </TD>
            </TR>
        </TABLE>
        
    </BODY>
</HTML>     
                    