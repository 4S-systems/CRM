<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Departments List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        int flipper = 0;
    String bgColor = null;
    String bgColorm=null;
        Vector<WebBusinessObject>  productionList = (Vector) request.getAttribute("data");

        String cMode= (String) request.getSession().getAttribute("currentMode");
        String  stat=cMode;
        String align=null;
        String dir=null;
        String style=null;
        String lang,langCode,BO,PN,PL, code, view, delete, edit;
        if(stat.equals("En")) {
            align="CENTER";
            dir="LTR";
            style="text-align:left";
            lang="   &#1593;&#1585;&#1576;&#1610;    ";
            langCode="Ar";
            BO="Basic Operations";
            code = "Production Line Code";
            view = "View";
            edit = "Edit";
            delete = "Delete";
            PN="Production No.";
            PL="Production Line List";
        }else {
            align="CENTER";
            dir="RTL";
            style="text-align:Right";
            lang="English";
            langCode="En";
            BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
            code = "&#1603;&#1608;&#1583; &#1582;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580;";
            view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            edit = "&#1578;&#1581;&#1585;&#1610;&#1585;";
            delete = "&#1581;&#1584;&#1601;";
            PN="&#1593;&#1583;&#1583; &#1575;&#1604;&#1582;&#1591;&#1608;&#1591;";
            PL="&#1593;&#1585;&#1590; &#1582;&#1591;&#1608;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580;";
        }
    %>
    
    <script language="javascript" type="text/javascript">
        function changeMode(name) {
            if(document.getElementById(name).style.display == 'none') {
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
    </script>
    
    <BODY>
        <DIV align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
        </DIV>
        <CENTER>
            <FIELDSET class="set" style="border-color: #006699; width: 90%">
                <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD style="text-align:center;border-color: #006699; font-size: 18;" width="100%" class="blueBorder blueHeaderTD">
                            <FONT color='white' SIZE="+1"><%=PL%></FONT>
                        </TD>
                    </TR>
                </TABLE>
                <TABLE class="blueBorder" style="margin-top: 10px; margin-bottom: 10px" cellpadding="0" cellspacing="0" dir="<%=dir%>" align="center" width="70%">
                    <TR>
                        <TD class="backgroundTable">
                            <font size="3" color="black"><%=PN%>&ensp;:&ensp;<font color="red"><%=productionList.size()%></font></font>
                        </TD>
                    </TR>
                </TABLE>
                <TABLE class="blueBorder" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="70%" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD CLASS="silver_header" COLSPAN="1" STYLE="text-align:CENTER;color:black;font-size:16px; height: 25px">
                            <B><font size="3" color="black"><%=code%></font></B>
                        </TD>
                        <TD CLASS="silver_header" COLSPAN="3" STYLE="text-align:CENTER;color:black;font-size:16px; height: 25px">
                            <B><font size="3" color="black"><%=BO%></font></B>
                        </TD>
                    </TR>
                    <% for(WebBusinessObject productionLine : productionList) {flipper++;
                     if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    } %>
                    <TR style="cursor: pointer" onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <TD STYLE="<%=style%>; padding-right:10px;" nowrap CLASS="<%=bgColorm%>" >
                            <b><%=productionLine.getAttribute("code")%></b>
                        </TD>
                        <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-right:10px;<%=style%>;">
                            <A HREF="<%=context%>/ProductionLineServlet?op=ViewproductionLine&prodID=<%=productionLine.getAttribute("id")%>" style="color: black; font-weight: bold;"><%=view%></A>
                        </TD>
                        <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-right:10px;<%=style%>">
                            <A HREF="<%=context%>/ProductionLineServlet?op=GetUpdateForm&prodID=<%=productionLine.getAttribute("id")%>" style="color: black; font-weight: bold;"><%=edit%></A>
                        </TD>
                        <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-right:10px;<%=style%>">
                            <A HREF="<%=context%>/ProductionLineServlet?op=ConfirmDelete&productionLineId=<%=productionLine.getAttribute("id")%>&code=<%=productionLine.getAttribute("code")%>" style="color: black; font-weight: bold;"><%=delete%></A>
                        </TD>
                    </TR>
                    <% } %>
                    <TR>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="3" STYLE="text-align: center;font-size:16px; height: 20px">
                            <B><%=PN%></B>
                        </TD>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="1" STYLE="text-align: center;font-size:16px; height: 20px">
                            <B><%=productionList.size()%></B>
                        </TD>
                    </TR>
                </TABLE>
                <br>
            </FIELDSET>
        </CENTER>
    </BODY>
</HTML>
