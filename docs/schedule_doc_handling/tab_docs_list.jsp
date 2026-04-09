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
    int t = s + 1;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    String configItemType = new String();
    
    Vector  docList = (Vector) request.getAttribute("docData");
    Document doc = null;
    WebBusinessObject VO = null;
    
    WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
    
    int flipper = 0;
    String bgColor = null;
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
    
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
    String sType = new String("");
    if(request.getParameter("type") != null){
        sType = "&type=" + request.getParameter("type");
    }
    String sBackURL = new String("");
    if(request.getParameter("equipmentCat") != null){
        sBackURL = "&equipmentCat=" + request.getParameter("equipmentCat") + "&source=\\'cat\\'" + sType;
    } else {
        sBackURL = "&equipmentID=" + request.getParameter("equipmentID") + "&source=eqp";
    }
    %>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <body>
        <br>
        <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR>
                <TD CLASS="td" COLSPAN="3" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                    <B><%=sQuickSummary%></B>
                </TD>
                <TD CLASS="td" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
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
            VO = doc.getViewOrigin();
            docsNumber++;
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
                        <%}
                        if(i==2) {
                        %>
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
                        <A HREF="<%=context%>/ScheduleDocReaderServlet?op=ViewDocument&docType=<%=doc.getDocumentType()%>&docID=<%=(String) doc.getAttribute("docID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>&scheduleID=<%=request.getParameter("scheduleID")%><%=sBackURL%>">
                            <%=docTitles[3]%>
                        </A>
                        <IMG   SRC="images/<%=fileDescriptor.getAttribute("iconFile")%>"  ALT="Document Image"> 
                    </DIV>
                </TD>
                <%
                }
                %>
            </tbody>
            <TR >
                <TD  CLASS="cell" BGCOLOR="#808080" COLSPAN="3" STYLE="<%=style%>;padding-right:5;border-right-width:1;color:white;font-size:14;">
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
    </body>
</html>
