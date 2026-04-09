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
    
    String[] docAttributes = {"docTitle","docDate","configItemType"};
    String[] docTitles = appCons.getDocHeaders();
    
    int s = docAttributes.length;
    int t = s+1;
    
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
    
    String scheduleID = (String) request.getAttribute("scheduleID");
    
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,IG,AS,QS,BO,CD,PN,NAS,PL,NF,IMA,att,noDataDis,havenotDoc;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Delete Schedule - Are you Sure ?";
        save="Delete";
        cancel="Back To List";
        TT="Task Title ";
        IG="Indicators guide ";
        AS="Active Site by Equipment";
        NAS="Non Active Site";
        QS="Quick Summary";
        BO="Basic Operations";
        docTitles[0]="Name";
        docTitles[1]="Date";
        docTitles[2]="Type";
        docTitles[3]="View";
        //docTitles[4]="More Details";
        //docTitles[5]="Edit";
        //docTitles[6]="Delete";
        
        CD="Can't Delete Site";
        PN="Documents No.";
        PL="Documents List";
        NF="No Attached Files";
        IMA="No Attached Images";
        att="Attach File";
        noDataDis="No Data To Display";
        havenotDoc="Haven't Document for Equipment";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        noDataDis=" &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578;";
        tit=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        AS="&#1605;&#1608;&#1602;&#1593; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
        NAS="&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
        QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        docTitles[0]="&#1575;&#1604;&#1573;&#1587;&#1605;";
        docTitles[1]="&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
        docTitles[2]="&#1575;&#1604;&#1606;&#1608;&#1593;";
        docTitles[3]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
       // docTitles[4]="&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1603;&#1579;&#1585;";
        //docTitles[5]="&#1578;&#1581;&#1585;&#1610;&#1585;";
       // docTitles[6]="&#1581;&#1584;&#1601;";
        
        CD=" &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        PN="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
        PL=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        NF="&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583";
        IMA=" &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1589;&#1608;&#1585;";
        att="&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        havenotDoc = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1577; &#1604;&#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
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
 function cancelForm(url)
        {    
        window.navigate(url);
        
     
        }
    //]]></script> 
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <body>
        <!--DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%//=lang%>"  onclick="reloadAE('<%//=langCode%>')" class="button">
            <button    onclick="cancelForm('<%//=context%>/ScheduleDocReaderServlet?op=ViewImages&scheduleID=<%//=scheduleID%>')" class="button"><%//=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
        </DIV--> 
        
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
        <% if (docList.size()==0 ) { %>
        <center><b><font size="3" color="red"> <%=havenotDoc%>  </font></b></center> 
       <% } %> 
        <br>   
        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            
            <TR>
                <TD CLASS="td" COLSPAN="3" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                    <B><%=QS%></B>
                </TD>
                <TD CLASS="td" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                    <B><%=BO%></B>
                </TD>
                
            </tr>
            
            <TR CLASS="head">
                
                <%
                String columnColor = new String("");
                String columnWidth = new String("");
                String font = new String("");
                for(int i = 0;i<t;i++) {
                    if(i == 0 || i==1 || i==2 ){
                        columnColor = "#9B9B00";
                    } else {
                        columnColor = "#7EBB00";
                    }
                    if(docTitles[i].equalsIgnoreCase("")){
                        columnWidth = "1";
                        columnColor = "black";
                        font = "1";
                    } else {
                        columnWidth = "100";
                        font = "12";
                    }
                %>                
                <TD nowrap CLASS="firstname" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;color:white;" nowrap>
                    <B><%=docTitles[i]%></B>
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
                
                <TD  STYLE="<%=style%>" nowrap BGCOLOR="#DDDD00" CLASS="cell" >
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
                
                <TD nowrap CLASS="cell"  BGCOLOR="#D7FF82" STYLE="padding-left:10;<%=style%>">
                    <DIV ID="links">
                        
                        <A HREF="<%=context%>/ScheduleDocReaderServlet?op=ViewDocument&docType=<%=doc.getDocumentType()%>&docID=<%=(String) doc.getAttribute("docID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>&scheduleID=<%=scheduleID%>">
                            <%=docTitles[3]%>  
                        </A>
                        <IMG   SRC="images/<%=fileDescriptor.getAttribute("iconFile")%>"  ALT="Document Image"> 
                        
                    </DIV>
                </TD>                     
                
                <!--TD nowrap CLASS="cell"  BGCOLOR="#D7FF82" STYLE="padding-left:10;<%//=style%>">
                    <DIV ID="links">
                        <A HREF="<%//=context%>/ScheduleDocReaderServlet?op=DocDetails&docID=<%//=doc.getAttribute("docID")%>&metaType=<%//=doc.getAttribute("metaType")%>&scheduleID=<%//=scheduleID%>">
                            <%//=docTitles[4]%>...
                        </A>
                    </DIV>
                </TD-->
                
                <!--TD nowrap CLASS="cell"  BGCOLOR="#D7FF82" STYLE="padding-left:10;<%//=style%>">
                    <DIV ID="links">
                        <A HREF="<%//=context%>/ScheduleDocWriterServlet?op=GetEditForm&docID=<%//=(String) doc.getAttribute("docID")%>&docTitle=<%//=(String) doc.getAttribute("docTitle")%>&scheduleID=<%//=scheduleID%>">
                            <%//=docTitles[5]%> 
                        </A>
                        
                    </DIV>
                </TD-->
                
                <!--TD nowrap CLASS="cell"  BGCOLOR="#D7FF82" STYLE="padding-left:10;<%//=style%>">
                    <DIV ID="links">
                        <A HREF="<%//=context%>/ScheduleDocReaderServlet?op=ConfirmDelete&docID=<%//=(String) doc.getAttribute("docID")%>&scheduleID=<%//=scheduleID%>&docTitle=<%//=(String) doc.getAttribute("docTitle")%>">
                        <%//=docTitles[6]%>  
                        
                    </DIV>
                </TD-->
                
                <%
                    }
                %>
            </tbody>
            
            <TR >
                <TD CLASS="total" COLSPAN="6" STYLE="<%=style%>;padding-right:5;border-right-width:1;">
                    <%=PN%>
                </TD>
                
                
                
                <TD STYLE="<%=style%>" CLASS="total" colspan="1">
                    
                    <DIV NAME="" ID="">
                        <%=docsNumber%>
                    </DIV>
                </TD>
                
            </TR>   
            
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
