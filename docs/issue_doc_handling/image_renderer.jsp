<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    response.addHeader("Pragma","No-cache");
    response.addHeader("Cache-Control","no-cache");
    response.addDateHeader("Expires",1);
    
    Document doc = (Document) request.getAttribute("docObject");
    String imagePath = (String) request.getAttribute("imagePath");
    String equipmentID = request.getParameter("equipmentID");
    String issueid = (String) request.getAttribute("issueid");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    Document childDoc = null;
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sView, cancel;
    if(cMode.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        sView = "View";
        cancel="Back To List";
    } else {
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sView = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Document Details</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm()
        {    
        window.location = "<%=context%>/UnitDocReaderServlet?op=ListDoc&equipmentID=<%=equipmentID%>";
        } 
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            
        </DIV> 
        
        <br><br>
        <fieldset align=center class="set">
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=sView%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br>
            <div align="center">
                <img name='docImage' alt='document image' src='<%=imagePath%>' >
            </div>
            <br>
        </fieldset>
    </BODY>
</HTML>     
