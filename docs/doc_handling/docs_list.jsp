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
    
    String[] docAttributes = appCons.getDocAttributes();
    String[] docTitles = appCons.getDocHeaders();
    
    int s = docAttributes.length;
    int t = s+4;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    String configItemType = new String();
    //BigDecimal grandTotal = new BigDecimal(0.0);
    
    Vector  docList = (Vector) request.getAttribute("data");
    Document doc = null;
    WebBusinessObject VO = null;
    
    int flipper = 0;
    String bgColor = null;
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
    
    String issueid = (String) request.getAttribute("issueid");
    String filterName = (String) request.getAttribute("fName");
    String filterBack="ListDoc";
    String filterValue = (String) request.getAttribute("fValue");
    
    //MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    //String context = metaMgr.getContext();
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    
    String projectname = (String) request.getAttribute("projectName");
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sQuickSummary, sBasicOperations, sMoreDetails, sDocNo;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Documents List";
        sCancel="Back";
        sOk="Ok";
        langCode="Ar";
        sQuickSummary="Quick Summary";
        sBasicOperations="Basic Oprations";
        docTitles[0] = "Title";
        docTitles[1] = "Date";
        docTitles[2] = "Type";
        docTitles[3] = "View Document";
        docTitles[4] = "Details";
        docTitles[5] = "Edit";
        docTitles[6] = "Delete";
        sMoreDetails = "More Details";
        sDocNo = "Documents Number";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        sOk="&#1605;&#1608;&#1575;&#1601;&#1602;";
        langCode="En";
        sQuickSummary="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        sBasicOperations="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        sMoreDetails = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1603;&#1579;&#1585;";
        sDocNo = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
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
    
    function cancelForm()
    {    
        document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=viewdetails&issueId=<%=issueid%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>&filterBack=<%=filterBack%>&projectName=<%=projectname%>";
        document.ISSUE_FORM.submit();  
    }
//]]>
    </script> 
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <body>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <br>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                    <TR>
                        <TD CLASS="td" COLSPAN="3" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=sQuickSummary%></B>
                        </TD>
                        <TD CLASS="td" COLSPAN="4" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=sBasicOperations%></B>
                        </TD>
                    </TR>
                    <TR CLASS="head">
                        <%
                        for(int i = 0;i<t;i++) {
                        String columnColor = new String("");
                        if(i == 0 || i == 1 || i == 2){
                            columnColor = "#9B9B00";
                        } else {
                            columnColor = "#7EBB00";
                        }
                        %>
                        
                        <TD nowrap CLASS="firstname" WIDTH="100" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0;color:white;" nowrap>
                            <%
                            if (i <= 2) {    
                            
                            %>
                            
                            <a href="" onclick="return sortTable2(<%=i%>)" STYLE="color:white;"><%=docTitles[i]%></a>
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
            String docId2 = (String)doc.getAttribute("docID");
            fileDescriptor = fileMgr.getObjectFromCash(doc.getDocumentType());
            //DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
            //configItemType = docTypeMgr.getDocTypeIcon((String)doc.getAttribute("configItemType"));
            //grandTotal = grandTotal.add(doc.getMoney());
            VO = doc.getViewOrigin();
            //VO.printSelf();
            docsNumber++;
            //flipper++;
            
            //if(doc.isLastBaseline()) {
            //    bgColor = doc.getColor();
            //} else
            //if((flipper%2) == 1) {
            //    bgColor="#c8d8f8";
            //} else {
            //    bgColor="white";
            //}
                        %>
                        
                        <TR>
                        <%
                        for(int i = 0;i<s;i++) {
                attName = docAttributes[i];
                attValue = (String) doc.getAttribute(attName);
                        
                        
                        %>
                        
                        <TD  nowrap  CLASS="cell" BGCOLOR="#DDDD00" STYLE="<%=style%>">
                            <DIV >
                                <%
                                if(attName.equalsIgnoreCase("total") && attValue.equalsIgnoreCase("0.00")) {
                    attValue = new String("none");
                                }
                if(i==1) {
                                %>
                                <!--
                    <img  src='images/folder.gif' >  -->
                                <%}
                                if(i==2) {
                                %>
                                <!--
                                <IMG SRC="images/<%//=configItemType%>"  ALT="<%//=doc.getAttribute("configItemType")%>" >
                    -->
                                <%-- <img  src='images/conticon.gif' > --%>
                                <%}
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
                        
                        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82">
                            <DIV ID="links">
                                
                                <A HREF="<%=doc.getViewDocumentLink()%>">
                                    <%=docTitles[3]%>
                                </A>
                                <IMG   SRC="images/<%=fileDescriptor.getAttribute("iconFile")%>"  ALT="Document Image"> 
                            </DIV>
                        </TD>                     
                        
                        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82">
                            <DIV ID="links">
                                <A HREF="<%=doc.getViewDocDetailsLink(filterName,filterValue,issueid,projectname)%>">
                                    <%=sMoreDetails%>...
                                </A>
                            </DIV>
                        </TD>
                        
                        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82">
                            <DIV ID="links">
                                <A HREF="<%=doc.getEditLink(filterValue,filterName)%>">
                                    <%=docTitles[5]%>
                                </A>
                                
                            </DIV>
                        </TD>
                        
                        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82">
                            <DIV ID="links">
                                <A HREF="<%=doc.getDeleteLink(filterBack,filterName,filterValue,issueid)%>">
                                    <%=docTitles[6]%>
                                </A>
                                
                            </DIV>
                        </TD>
                        <%
                        
                        }
                        %>
                        
                    </tbody>
                    
                    <TR >
                        <TD  CLASS="cell" BGCOLOR="#808080" COLSPAN="6" STYLE="<%=style%>;padding-right:5;border-right-width:1;color:white;font-size:14;">
                            <B><%=sDocNo%></B>
                        </TD>
                        
                        
                        <TD STYLE="<%=style%>;padding-left:5;;color:white;font-size:14;" CLASS="cell" BGCOLOR="#808080" colspan="1">
                            
                            <DIV NAME="" ID="">
                                <B><%=docsNumber%></B>
                            </DIV>
                        </TD>
                        
                    </TR>   
                    
                </table>
                
                <%
                        } else {
                %>
                <br><br>
                <table align="right" dir="rtl">
                    <tr>
                        <td style="text-align:right">
                            <%=sDocNo%>
                        </td> 
                    </tr>
                </table>
                
                <%
                        }
                %>
                <br>
            </fieldset>
        </form>
    </body>
</html>
