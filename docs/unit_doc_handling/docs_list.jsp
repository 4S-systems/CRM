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
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    String context = metaMgr.getContext();
    
    DVAppConstants appCons = new DVAppConstants();
    
    String[] docAttributes = {"docTitle","docDate","configItemType"};
    String[] docTitles = appCons.getDocHeaders();
    
    int s = docAttributes.length;
    int t = s+4;
    
    String attName = null;
    String attValue = null;
    Vector  docList = (Vector) request.getAttribute("data");
    Document doc = null;
    
    String equipmentID = (String) request.getAttribute("equipmentID");
    
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String lang,langCode,cancel,PN,PL,noDataDis;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        cancel="Back To List";
        docTitles[0]="Name";
        docTitles[1]="Date";
        docTitles[2]="Type";
        docTitles[3]="View";
        docTitles[4]="More Details";
        docTitles[5]="Edit";
        docTitles[6]="Delete";
        PN="Documents No.";
        PL="Documents List";
        noDataDis="No Data To Display";
    }else{
        
        align="center";
        dir="RTL";
        lang="English";
        langCode="En";
        noDataDis=" &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        docTitles[0]="&#1575;&#1604;&#1573;&#1587;&#1605;";
        docTitles[1]="&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
        docTitles[2]="&#1575;&#1604;&#1606;&#1608;&#1593;";
        docTitles[3]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        docTitles[4]="&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1603;&#1579;&#1585;";
        docTitles[5]="&#1578;&#1581;&#1585;&#1610;&#1585;";
        docTitles[6]="&#1581;&#1584;&#1601;";
        PN="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
        PL=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    }    
    String type = (String) request.getAttribute("type");
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
 function cancelForm(url)
        {    
        window.location=url;
        
     
        }
        $(document).ready(function() {
            $('#indextable').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
            })
        });
    //]]></script> 
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <input type="hidden" name="type" value="<%=type%>">
    <body>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <% if (type!=null && !type.equals("") && type.equals("client")){ %>
            <button    onclick="cancelForm('ClientServlet?op=ListClients');" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            <% }if (type!=null && !type.equals("") && type.equals("project")){  %>
            <button    onclick="cancelForm('ProjectServlet?op=ListProjects');" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            <% } %>
        </DIV>
        
        <fieldset align=center class="set">
        <legend align="center">
            
            <table dir=" <%=dir%>" align="<%=align%>">
                <tr>
                    
                    <td class="td">
                        <font color="blue" size="6"><%=PL%> 
                        </font>
                    </td>
                </tr>
            </table>
        </legend >
        
        <br><br>
        <TABLE ALIGN="<%=align%>" dir=<%=dir%> WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
        
        <br>
        
        <center> <b> <font size="3" color="red"> <%=PN%> : <%= docList.size()%> </font></b></center> 
        <br>   
        <table id="indextable" ALIGN="center" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="width: 100%;text-align: center">
            <thead>
                    <TR >
                
                <%
                for(int i = 0;i<t;i++) {
                %>                
                <TD>
                    <B><%=docTitles[i]%></B>
                </TD>
                <%
                }
                %>
                
            </TR>  
                </thead>  
            
            <tbody>
                
                <%
                if(null!=docList) {
                    Enumeration e = docList.elements();
                    
                    
                    while(e.hasMoreElements()) {
                        doc = (Document) e.nextElement();
                        fileDescriptor = fileMgr.getObjectFromCash(doc.getDocumentType());
                %>
                <TR>
                <%
                for(int i = 0;i<s;i++) {
                            attName = docAttributes[i];
                            attValue = (String) doc.getAttribute(attName);                
                %>
                
                <TD>
                    <DIV >
                        <%
                        if(attName.equalsIgnoreCase("total") && attValue.equalsIgnoreCase("0.00")) {
                                attValue = new String("none");
                        }
                            if(i==2 & doc.getAttribute("configItemType") != null) {
                                WebBusinessObject tempWBO = docTypeMgr.getOnSingleKey(attValue);
                        %>
                        <img  src='images/<%=docTypeMgr.getIconFile(tempWBO.getAttribute("typeName").toString())%>' >
                        
                        <b> <%=tempWBO.getAttribute("typeName").toString()%> </b>
                        <%} else {%>
                        <b> <%=attValue%> </b>
                        <%}%>
                        
                    </DIV>
                </TD>
                <%
                
                }
                %>
                
                <TD>
                    <DIV ID="links">
                        
                        <A HREF="<%=context%>/UnitDocReaderServlet?op=ViewDocument&docType=<%=doc.getDocumentType()%>&docID=<%=(String) doc.getAttribute("docID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>&equipmentID=<%=equipmentID%>">
                            <%=docTitles[3]%>  
                        </A>
                        <IMG   SRC="images/<%=fileDescriptor.getAttribute("iconFile")%>"  ALT="Document Image"> 
                        
                    </DIV>
                </TD>                     
                
                <TD>
                    <DIV ID="links">
                        <A HREF="<%=context%>/UnitDocReaderServlet?op=DocDetails&docID=<%=doc.getAttribute("docID")%>&metaType=<%=doc.getAttribute("metaType")%>&equipmentID=<%=equipmentID%>">
                            <%=docTitles[4]%>...
                        </A>
                    </DIV>
                </TD>
                
                <TD>
                    <DIV ID="links">
                        <A HREF="<%=context%>/UnitDocWriterServlet?op=GetEditForm&docID=<%=(String) doc.getAttribute("docID")%>&docTitle=<%=(String) doc.getAttribute("docTitle")%>&equipmentID=<%=equipmentID%>">
                            <%=docTitles[5]%> 
                        </A>
                        
                    </DIV>
                </TD>
                
                <TD>
                    <DIV ID="links">
                        <A HREF="<%=context%>/UnitDocReaderServlet?op=ConfirmDelete&docID=<%=(String) doc.getAttribute("docID")%>&equipmentID=<%=equipmentID%>&docTitle=<%=(String) doc.getAttribute("docTitle")%>">
                        <%=docTitles[6]%>  
                        
                    </DIV>
                </TD>
                
                <%
                    }
                %>
            </tbody>
        </table>
        
        <%
                } else {
        %>
        
        <%=noDataDis%>
        
        <%
                }
        %>
        
    </body>
</html>
