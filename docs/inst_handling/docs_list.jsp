<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.docviewer.common.*,com.docviewer.business_objects.*,java.math.*,com.silkworm.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.sw.constants.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Users List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        FileMgr fileMgr = FileMgr.getInstance();
        WebBusinessObject fileDescriptor = null;
        CIConstants constant = new CIConstants();
        String context = metaMgr.getContext();
        int docsNumber = 0;

        WebIssue webIssue = null;

        DVAppConstants appCons = new DVAppConstants();
        System.out.println(" then I am here .......    ");

        String[] docAttributes = {"instTitle","creationTime","configItemType"};
        String[] docTitles = appCons.getDocHeaders();

        int s = docAttributes.length;
        int t = s+4;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;
        String configItemType = new String();
        Vector  docList = (Vector) request.getAttribute("data");
        Document doc = null;
        WebBusinessObject VO = null;

        int flipper = 0;
        String bgColor = null;

        TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");

        String unitScheduleID = (String) request.getAttribute("unitScheduleID");

        DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
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
    
    
    <body>

        <TABLE  stylel="position:absolute;top:400px;left:30px;border-right-WIDTH:0px"  WIDTH="400" CELLPADDING="0" CELLSPACING="0">
            <Tr class='td'>
                &nbsp;
            </Tr>
            <TD nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                <%=tGuide.getMessage("doclist")%> 
            
            </TD>
        
            <TD CLASS="tabletitle" STYLE="">
                <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
            </TD>
        
        
        
            <TD CLASS="tableright" colspan="10">
                    
                <A HREF="<%=context%>/ScheduleServlet?op=ScheduleList">                        
                    Cancel
                    <IMG SRC="images/leftarrow.gif">
                </A>
                <!--IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                   
             
                    
                    
                <A HREF="<-%=context%>/AssignedIssueServlet?op=viewdetails&unitScheduleID=<-%=unitScheduleID%>">
                    <IMG SRC="images/conticon.gif">
                    <b font="10">View Schedule</b>
                        
                </A-->
       
            </TD>
        
            </TR>
        </TABLE>

        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR CLASS="head">
                <%
                    for(int i = 0;i<t;i++) {


                %>
              
                <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                    <%
               if (i <= 2) {    
                   
                    %>
                    
                <a href="" onclick="return sortTable2(<%=i%>)"><%=docTitles[i]%></a>
           <% 
                } else { %>
                   <%=docTitles[i]%>
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
                if(null!=docList) {
            Enumeration e = docList.elements();


            while(e.hasMoreElements()) {
                doc = (Document) e.nextElement();
                fileDescriptor = fileMgr.getObjectFromCash(doc.getDocumentType());
                VO = doc.getViewOrigin();
                docsNumber++;
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
                        attName = docAttributes[i];
                        attValue = (String) doc.getAttribute(attName);


            %>

            <TD  nowrap  CLASS="cell" >
                <DIV >
                    <%
                        if(attName.equalsIgnoreCase("total") && attValue.equalsIgnoreCase("0.00")) {
                    attValue = new String("none");
                        }
                if(i==2 & doc.getAttribute("configItemType") != null) {
                    %>
                    <img  src='images/<%=docTypeMgr.getIconFile(doc.getAttribute("configItemType").toString())%>' >
                    <%}%>
                    <b> <%=attValue%> </b>

                           
                </DIV>
            </TD>
            <%

                }
            %>
        
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
             
                    <A HREF="<%=context%>/InstReaderServlet?op=ViewDocument&docType=<%=doc.getDocumentType()%>&instId=<%=(String) doc.getAttribute("instID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>">
                        <%=doc.getDisplayString()%>
                    </A>
                    <IMG   SRC="images/<%=fileDescriptor.getAttribute("iconFile")%>"  ALT="Document Image"> 
                    
                </DIV>
            </TD>                     
                     
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
                    <A HREF="<%=context%>/InstReaderServlet?op=DocDetails&instId=<%=doc.getAttribute("instID")%>&metaType=<%=doc.getAttribute("metaType")%>&unitScheduleID=<%=unitScheduleID%>">
                        <%=doc.getMoreDetailRendering()%> ...
                    </A>
                </DIV>
            </TD>
        
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
                    <A HREF="<%=context%>/InstWriterServlet?op=GetEditForm&instId=<%=(String) doc.getAttribute("instID")%>&instTitle=<%=(String) doc.getAttribute("instTitle")%>">
                        edit
                    </A>
               
                </DIV>
            </TD>

            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
                    <A HREF="<%=context%>/InstReaderServlet?op=ConfirmDelete&instId=<%=(String) doc.getAttribute("instID")%>&unitScheduleID=<%=unitScheduleID%>&instTitle=<%=(String) doc.getAttribute("instTitle")%>">
                        delete
                    </A>
               
                </DIV>
            </TD>

            <%
                }
            %>
            </tbody>
            
            <TR >
                <TD CLASS="total" COLSPAN="6" STYLE="text-align:right;padding-right:5;border-right-width:1;">
                    Documents Number
                </TD>


                <TD CLASS="total" colspan="1">
                    
                    <DIV NAME="" ID="">
                        <%=docsNumber%>
                    </DIV>
                </TD>

            </TR>   
    
        </table>

        <%
                    } else {
        %>
    
        No data to display
  
        <%
            }
        %>
    
    </body>
</html>
