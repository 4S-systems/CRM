<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String productionLineId = (String) request.getAttribute("productionLineId");
    String productionLineCode = (String) request.getAttribute("productionLineCode");
    boolean canDelete = (Boolean) request.getAttribute("canDelete");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    String sup_number, save, TT;
    String title_1,title_2;
    String cancel_button_label;
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sup_number = "Production Line Code";
        TT="Cannot Delete This Production Line Because Is Linked With Equipments";
        title_1="Delete Production Line";
        title_2="Delete Production Line - <font color=#F3D596>Are you Sure ?</font>";
        cancel_button_label="Back To List ";
        langCode="Ar";
        save="Delete";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        save=" &#1573;&#1581;&#1584;&#1601;";
        sup_number = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        title_1="&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1582;&#1600;&#1600;&#1600;&#1591; &#1571;&#1606;&#1600;&#1600;&#1578;&#1600;&#1600;&#1575;&#1580;";
        title_2="&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1582;&#1600;&#1600;&#1600;&#1591; &#1571;&#1606;&#1600;&#1600;&#1578;&#1600;&#1600;&#1575;&#1580; - <font color=#F3D596>&#1607;&#1600;&#1600;&#1604; &#1571;&#1606;&#1600;&#1600;&#1578; &#1605;&#1600;&#1600;&#1578;&#1600;&#1600;&#1571;&#1603;&#1600;&#1600;&#1600;&#1600;&#1583; &#1567;</font>";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        langCode="En";
        TT="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1607;&#1584;&#1575; &#1575;&#1604;&#1582;&#1600;&#1600;&#1600;&#1591; &#1604;&#1571;&#1606;&#1607; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1600;&#1600; &#1605;&#1600;&#1600;&#1600;&#1593;&#1600;&#1600;&#1600;&#1583;&#1575;&#1578;";
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <script language="javascript" type='text/javascript'>
        function submitForm() {
          document.DELETE_PRODUCTION_LINE_FORM.action = "<%=context%>/ProductionLineServlet?op=delete&productionLineId=<%=productionLineId%>&productionLineCode=<%=productionLineCode%>";
          document.DELETE_PRODUCTION_LINE_FORM.submit();
       }

        function cancelForm() {
            document.DELETE_PRODUCTION_LINE_FORM.action = "<%=context%>/ProductionLineServlet?op=ListProductionLine";
            document.DELETE_PRODUCTION_LINE_FORM.submit();
        }
    </script>
    <BODY>
        <FORM action=""  NAME="DELETE_PRODUCTION_LINE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; padding-bottom: 10px; padding-left: 5%">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%></button>
                <% if(canDelete) { %>
                    &ensp;
                    <button onclick="submitForm()" class="button"><%=save%></button>
                <% } %>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699; width: 90%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1">
                                    <% if(canDelete) { %>
                                        <%=title_2%>
                                    <% } else  { %>
                                        <%=title_1%>
                                    <% } %>
                                </FONT>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <% if(canDelete) { %>
                    <TABLE class="backgroundTable" CELLPADDING="0" CELLSPACING="5" width="60%" BORDER="0" ALIGN="<%=align%>" DIR="<%=dir%>">
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px;" class='backgroundHeader' width="30%">
                                <p><b><%=sup_number%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="productionLineCode" ID="productionLineCode" value="<%=productionLineCode%>">
                                <input type="hidden" name="productionLineId" ID="productionLineId" value="<%=productionLineId%>">
                            </TD>
                        </TR>
                    </TABLE>
                    <% } else { %>
                    <TABLE class="blueBorder" cellspacing="0" cellpadding="0" align="<%=align%>" dir="<%=dir%>" width="90%">
                        <TR>
                            <TD class="backgroundTable">
                                <b><font size=4 color='red'><%=TT%></font></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <% } %>
                    <BR>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>     
