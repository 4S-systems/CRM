<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.TaskMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>Plan List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
    int flipper = 0;
    String bgColor = null;
    String bgColorm = null;
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    Vector<WebBusinessObject> scheduleVec = (Vector) request.getAttribute("scheduleVec");

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,
           langCode,
           scheduleNum,
           ListTitle,
           newSearchStr,
           scheduleNameStr,
           modelNameStr,
           mainTypeNameStr;
    
    if(stat.equals("En")) {
        align="left";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        scheduleNameStr="Schedule Name";
        modelNameStr="Model Name";
        ListTitle="Schedule List";
        scheduleNum="Schedules Number";
        newSearchStr="New Search";
        mainTypeNameStr = "Main Type Name";

    } else {

        align = "right";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        scheduleNameStr="إسم الجدول";
        modelNameStr="إسم الموديل";
        ListTitle="عرض الجداول";
        scheduleNum="عدد الجداول";
        newSearchStr="بحث جديد";
        mainTypeNameStr = "إسم النوع الرئيسى";
    }
    %>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
        
    </SCRIPT>
    <BODY>
        <FORM action=""  NAME="SCHEDULE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; padding-left: 2.5%; padding-bottom: 10px">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="window.location='<%=context%>/SearchServlet?op=getSearchSPInScheduleForm'" class="button"><%=newSearchStr%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:95%;border-color: #006699;">
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueBorder blueHeaderTD">
                                <font  size="4"><%=ListTitle%></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <TABLE class="blueBorder" width="90%" align="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0">
                        <TR>
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=scheduleNameStr%></B>
                            </TD>
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=mainTypeNameStr%></B>
                            </TD> 
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=modelNameStr%></B>
                            </TD>                            
                        </TR>
                        
                        <% for(WebBusinessObject wbo : scheduleVec) {
                            
                            flipper++;
                            if((flipper%2) == 1) {
                                bgColor = "silver_odd";
                                bgColorm = "silver_odd_main";
                            } else {
                               bgColor = "silver_even";
                               bgColorm = "silver_even_main";
                            } %>

                        <TR style="cursor: pointer" onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <b><%=wbo.getAttribute("scheduleTitle")%></b>
                            </TD>
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <%if(((String) wbo.getAttribute("modelId")).equals("")) {%>
                                    <b><%=wbo.getAttribute("parentName")%></b>
                                <%} else {%>
                                    <b>-</b>
                                <%}%>
                            </TD>
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <%if(((String) wbo.getAttribute("mainTypeId")).equals("")) {%>
                                    <b><%=wbo.getAttribute("parentName")%></b>
                                <%} else {%>
                                    <b>-</b>
                                <%}%>
                            </TD>
                        </TR>
                        <% } %>
                        <TR>
                            <TD COLSPAN="2" CLASS="silver_footer" BGCOLOR="#808080" STYLE="text-align: center; font-size:14px;" >
                                <b><%=scheduleNum%></b>
                            </TD>
                            <TD CLASS="silver_footer" BGCOLOR="#808080" STYLE="text-align: center; font-size:12px;" >
                                <b><%=scheduleVec.size()%></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
