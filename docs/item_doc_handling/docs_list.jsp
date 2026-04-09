<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.docviewer.common.*,com.docviewer.business_objects.*,java.math.*,com.silkworm.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.sw.constants.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<HEAD>
    <TITLE>System Users List</TITLE>
     <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
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

String[] docAttributes = {"docTitle","creationTime","configItemType"};
//String[] docTitles = appCons.getDocHeaders();
String[] docTitles={"Title","Date","Category","View","More details","Edit","Delete"};

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

String itemID = (String) request.getAttribute("itemID");

DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
String categoryId = request.getAttribute("categoryId").toString();
String pIndex = request.getParameter("pIndex");



String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String head_1,head_2;
String saving_status;
String title_1,title_2;
//String head_1,head_2,field_1_1;
String cancel_button_label;
String  cat_f, more_details_f, del_f, edit_f, view_f,title_f,doc_num_f, info_f;
//String view, edit, delete;
String save_button_label;
String parts_numb="&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1593;&#1585;&#1590;";
String piece_word="&#1602;&#1591;&#1593;&#1577;";
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
   doc_num_f="Documents number";
info_f="No data to show";
    
   
    cat_f="Category";
    
    title_1="Documents view";
    title_2="All information are needed";
    cancel_button_label=" Return to menu ";
    save_button_label="Delete category";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
//    {"Title","Date","Category","View","More details","Edit","Delete"};
     String[] x={"&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;","&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;"
     ,"&#1575;&#1604;&#1602;&#1587;&#1605;","&#1593;&#1585;&#1590;","&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1603;&#1579;&#1585;"
     ,"&#1578;&#1581;&#1585;&#1610;&#1585;","&#1581;&#1584;&#1601;"};
     docTitles=x;
     
    head_1="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    head_2="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    //field_1_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1602;&#1591;&#1593;";
    doc_num_f=" &#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
   
    cat_f="&#1575;&#1604;&#1606;&#1608;&#1593;";
   info_f="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1604;&#1604;&#1593;&#1585;&#1590;";
    
    title_1=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
    langCode="En";
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
 function changePage(url){
                window.navigate(url);
            }

//]]></script> 
<script src='ChangeLang.js' type='text/javascript'></script>

<body>

<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/ItemsServlet?op=ShowItem&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
</DIV> 

<fieldset class="set" align="center">
<legend align="center">
    <table align="<%=align%>" dir=<%=dir%>>
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=title_1%>                
                </font>
                
            </td>
        </tr>
    </table>
</legend>

<%
        if(null!=docList) {
    Enumeration e = docList.elements();
    
    
    while(e.hasMoreElements()) {
        doc = (Document) e.nextElement();
        fileDescriptor = fileMgr.getObjectFromCash(doc.getDocumentType());
        VO = doc.getViewOrigin();
        docsNumber++;
        }
        }
%>
<DIV align="center" STYLE="color:blue;">
    <B><font color="red" size="3"><%=doc_num_f%> : <%=docsNumber%> </B></font>
</DIV>
<%
docsNumber=0;
%>
<br><br>


<TABLE align="<%=align%>" dir=<%=dir%> WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
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
        
        <TD  STYLE="<%=style%>" nowrap  CLASS="cell" >
            <DIV >
                <%
                if(attName.equalsIgnoreCase("total") && attValue.equalsIgnoreCase("0.00")) {
                attValue = new String("none");
                }
            if(i==2 & doc.getAttribute("configItemType") != null) {
                WebBusinessObject tempWBO = docTypeMgr.getOnSingleKey(attValue);
                %>
                <img  src='images/<%=docTypeMgr.getIconFile(tempWBO.getAttribute("typeName").toString())%>' >
                
                <b> <%=cat_f%> </b>
                <%} else {%>
                <b> <%=attValue%> </b>
                <%}%>
                
            </DIV>
        </TD>
        <%
        
        }
        %>
        
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;" DIR="LTR">
            <DIV ID="links">
                
                <A HREF="<%=context%>/ItemDocReaderServlet?op=ViewDocument&docType=<%=doc.getDocumentType()%>&docID=<%=(String) doc.getAttribute("docID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>">
                    <%=docTitles[3]%>
                </A>
                <IMG   SRC="images/<%=fileDescriptor.getAttribute("iconFile")%>"  ALT="Document Image"> 
                
            </DIV>
        </TD>                     
        
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
            <DIV ID="links">
               <A HREF="<%=context%>/ItemDocReaderServlet?op=DocDetails&docID=<%=doc.getAttribute("docID")%>&metaType=<%=doc.getAttribute("metaType")%>&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>">
                  <%=docTitles[4]%>
                </A>
            </DIV>
        </TD>
        
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
            <DIV ID="links">
                <A HREF="<%=context%>/ItemDocWriterServlet?op=GetEditForm&docID=<%=(String) doc.getAttribute("docID")%>&docTitle=<%=(String) doc.getAttribute("docTitle")%>&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>">
                  <%=docTitles[5]%>
                </A>
                
            </DIV>
        </TD>
        
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;">
            <DIV ID="links">
              <A HREF="<%=context%>/ItemDocReaderServlet?op=ConfirmDelete&docID=<%=(String) doc.getAttribute("docID")%>&itemID=<%=itemID%>&docTitle=<%=(String) doc.getAttribute("docTitle")%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>">
                    <%=docTitles[6]%>
                </A>
                
            </DIV>
        </TD>
        
        <%
        }
        %>
    </tbody>
    
    <TR >
       
        
        <TD STYLE="<%=style%>" CLASS="total" colspan="6">
            
            <DIV NAME="" ID="">
               <%=doc_num_f%>
            </DIV>
        </TD>
         <TD CLASS="total" COLSPAN="1" ALIGN="<%=align%>" STYLE="<%=style%>">
         <%=docsNumber%>
        </TD>
        
    </TR>   
    
</table>

<%
        } else {
%>
<table align="<%=align%>" dir=<%=dir%>>
    <tr><td style="<%=style%>" >
         <%=info_f%>
            
</td></tr></table>
<%
        }
%>
<br><br><br>
</body>
</html>
