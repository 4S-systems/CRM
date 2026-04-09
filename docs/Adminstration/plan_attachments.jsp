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
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    Vector<WebBusinessObject>  planVec = (Vector) request.getAttribute("planVec");

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,
           langCode,
           planNum,
           ListTitle,
           Basic,
           Quick,
           confirmDelete,
           Delete,
           edit,
           view,
           cancel,
           planCodeStr,
           planNameStr,
           planDescStr,
           beginDateStr,
           endDateStr,
           planTypeStr,
           attachSeasonStr;
    
    if(stat.equals("En")) {
        align="left";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        planCodeStr="Plan Code";
        planNameStr="Plan Name";
        planDescStr="Plan Description";
        planTypeStr = "Plan Type";
        beginDateStr="Plan Begin Date";
        endDateStr="Plan End Date";
        view = "View";
        edit = "Edit";
        confirmDelete = "Confirm Delete";
        Delete = "Delete";
        Quick="Quick Summary";
        Basic="Basic Oprations";
        ListTitle="Plan List";
        planNum="Plans Number";
        cancel="Weekly Diary";
        attachSeasonStr="Attach To Season";

    } else {

        align = "right";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        Delete = tGuide.getMessage("delete");
        confirmDelete = "&#1578;&#1571;&#1603;&#1610;&#1600;&#1600;&#1600;&#1600;&#1583; &#1575;&#1604;&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601;";
        edit = tGuide.getMessage("edit");
        view = tGuide.getMessage("view");
        planCodeStr="رقم الخطة";
        planNameStr="إسم الخطة";
        planDescStr="وصف الخطة";
        planTypeStr = "نوع الخطة";
        beginDateStr="تاريخ بداية الخطة";
        endDateStr="تاريخ نهاية الخطة";
        Quick="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        Basic="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        ListTitle="عرض الخطط";
        planNum="عدد الخطط";
        cancel="&#1575;&#1604;&#1575;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1575;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607;";
        attachSeasonStr="ربط بموسم";
    }
    %>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function viewPlan(planId) {
           var url = "<%=context%>/PlanServlet?op=viewPlan&planId=" + planId;
           document.PLAN_LIST_FORM.action = url;
           document.PLAN_LIST_FORM.submit();

        }
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
        
    </SCRIPT>
    <BODY>
        <FORM action=""  NAME="PLAN_LIST_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; padding-left: 2.5%; padding-bottom: 10px">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="window.location='<%=context%>/main.jsp'" class="button"><%=cancel%></button>
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
                                <B><%=planCodeStr%></B>
                            </TD>
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=planNameStr%></B>
                            </TD>
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=planDescStr%></B>
                            </TD>
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=planTypeStr%></B>
                            </TD>
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=beginDateStr%></B>
                            </TD>
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=endDateStr%></B>
                            </TD>
                            <TD CLASS="blueHeaderTD" STYLE="text-align:center;font-size:16px;">
                                <B><%=attachSeasonStr%></B>
                            </TD>
                        </TR>
                        
                        <% for(WebBusinessObject wbo : planVec) {
                            
                            flipper++;
                            if((flipper%2) == 1) {
                                bgColor = "silver_odd";
                                bgColorm = "silver_odd_main";
                            } else {
                               bgColor = "silver_even";
                               bgColorm = "silver_even_main";
                            } %>

                        <TR onclick="JavaScript:viewPlan(<%=wbo.getAttribute("planId")%>);" style="cursor: pointer" onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <b><%=wbo.getAttribute("planCode")%></b>
                            </TD>
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <b><%=wbo.getAttribute("planName")%></b>
                            </TD>
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <b><%=wbo.getAttribute("planDesc")%></b>
                            </TD>
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <b><%=wbo.getAttribute("planType")%></b>
                            </TD>
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <b><%=wbo.getAttribute("beginDate")%></b>
                            </TD>
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <b><%=wbo.getAttribute("endDate")%></b>
                            </TD>
                            <TD CLASS="<%=bgColorm%>" STYLE="padding-<%=align%>:10px; <%=style%>">
                                <A HREF="<%=context%>/SeasonPlanServlet?op=getAttachSeasonForm&planId=<%=wbo.getAttribute("planId")%>">
                                    <%=attachSeasonStr%>
                                </A>
                            </TD>
                        </TR>
                        <% } %>
                        <TR>
                            <TD CLASS="silver_footer" COLSPAN="6" BGCOLOR="#808080" STYLE="text-align: center; font-size:14px;" >
                                <b><%=planNum%></b>
                            </TD>
                            <TD CLASS="silver_footer" BGCOLOR="#808080" STYLE="text-align: center; font-size:12px;" >
                                <b><%=planVec.size()%></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
