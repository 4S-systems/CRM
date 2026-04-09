<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.silkworm.db_access.PersistentSessionMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Main.Main"  />
    <%
        response.addHeader("Pragma", "No-cache");
        response.addHeader("Cache-Control", "no-cache");
        response.addDateHeader("Expires", 1);
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String context = metaDataMgr.getContext();
        String lang = (String) request.getSession().getAttribute("currentMode");
        String companyName = metaDataMgr.getCompanyNameForLogo();
        String managerName = "غير محدد";
        String departmentTitle = "المدير";
        WebBusinessObject loggedUser = PersistentSessionMgr.getInstance().getOnSingleKey(request.getSession().getId());
        if (loggedUser != null) {
            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            String userName = securityUser.getFullName();
            if (securityUser.getManagerName() != null) {
                managerName = securityUser.getManagerName();
            } else {
                if (securityUser.getDepartmentName() != null) {
                    managerName = securityUser.getDepartmentName();
                    if (lang.equalsIgnoreCase("Ar")) {
                        departmentTitle = "الأدارة";
                    } else {
                        departmentTitle = "Managment";
                    }
                }
            }
            if (userName.length() > 20) {
                userName = userName.substring(0, 5) + "..." + userName.substring(userName.length() - 5);
            }
            Vector vecBuild = metaDataMgr.getVecBuild();
            String sBuild = new String("");
            for (int i = 0; i < vecBuild.size(); i++) {
                if (i == 0) {
                    sBuild = ((String) vecBuild.get(i));
                } else {
                    sBuild = sBuild + "\n" + ((String) vecBuild.get(i));
                }
            }
            String align = new String("LEFT");
            if (lang == null) {
                lang = new String("En");
            }
            if (lang.equalsIgnoreCase("Ar")) {
                align = new String("RIGHT");
                departmentTitle = "المدير";
            } else {
                align = new String("LEFT");
                departmentTitle = "Manager";
            }
    %>
    <head>
        <script type="text/javascript" src="scripts/jquery-1.4.3.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.position.js"></script>  
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"></link>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"></link>


        <style type="text/css" >
            .summary_td {
                border: 1px solid #C3C6C8; 
                border-right-width: 0px; 
                font-family: arial,verdana,tahoma, sans-serif; 
                font-size: 11px; 
                color: #666666; 
                padding: inherit; 
                height: 16px; 
                color: black; 
                text-align: center; 
                font-weight: capitalize;
                width:130px;
            }
            html,body {
                height:96%;
                margin: 0px 0px 0px 0px ;
                padding: 0px 0px 0px 0px ;
                font-family:  Amiri ;
                font-family:  'Amiri' ;
            }
            #site-body-content {
                padding: 15px 15px 15px 15px ;
            }
            #site-bottom-bar {
                margin:auto;
                bottom: 0px ;
                font-family:  Amiri ;
                /*font-size: 11px ;*/
                height: 30px ;
                width: 96% ;
            }
            #site-bottom-bar-frame {
                height: 30px ;
                /* width:1000px; */
                padding-right: 0px;
                padding-left: 0px;
                border: 1px solid #4f6582 ;
                background-image:url(images/menubg1.jpg);
                background-repeat: repeat-x;
                background-position:bottom;
                margin:auto;
            }
        </style>

        <script type="text/javascript" >
            function openUserData(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }
        </script>
    </head>
    <body style="margin-top: 0px;min-width: 950px;">
        <center id="site-body-container"  style="min-height:93%;height: auto;">
            <div style="border: 1px solid #4f6582;/*width: 1000px;*/ min-height:96%; position: relative; margin: auto;padding-right: 0px; padding-left: 0px ;height: auto;">
                <table align="center" cellpadding="0" cellspacing="0" STYLE="border-top-width:2px; border-right-width:2px; border-left-width:2px; border-bottom-width:2px;" width="100%;">
                    <tr align='<fmt:message key="align" />' dir='<fmt:message key="direction" />'>
                        <td align="right" colspan="15" bgcolor="white" width="90%" class="TD" style="text-align: left; height: auto; background:-webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(0,0,0,0.65)), color-stop(100%,rgba(0,0,0,0.8)));">
                            <% if (companyName != null) {%>
                            <img alt="logo" width='100%' height='70px' align="ABSMIDDLE" style="height: 85px" SRC="images/banner-<%=companyName%>.png"  />    
                            <% } else {%>
                            <img alt="logo" width='100%' height='70px' align="ABSMIDDLE" style="height: 60px" SRC="images/commun.jpg"  />
                            <% }%>
                        </td>
                        <td class="summary_td" align="left">
                            <table  bgcolor="#dedede" align="center" DIR='<fmt:message key="direction" />' CELLPADDING="0" CELLSPACING="0" width="100%" STYLE="border-width:1px;display: block; height: auto" >
                                <tr>
                                    <td class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b>
                                            <fmt:message key="curruser"/> :
                                        </b>
                                    </td>
                                    <td class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=userName%> 
                                    </td>
                                </tr>
                                <tr>
                                    <td class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b><%=departmentTitle%> :</b>
                                    </td>
                                    <td class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=managerName%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b><fmt:message key="manggroup"/>  :</b>
                                    </td>
                                    <td class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=securityUser.getUserGroupName()%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b><fmt:message key="lastsign"/> :</b>
                                    </td>
                                    <td class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=securityUser.getLastLogin()%>
                                    </td>
                                </tr>

                                <%if (securityUser.getCompanyName() != "") {%>
                                <tr>
                                    <td class="summary_td" style="text-align: right; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b><fmt:message key="company"/>   </b>
                                    </td>
                                    <td class="summary_td" style="text-align: right; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=securityUser.getCompanyName()%>
                                    </td>
                                </tr>
                                <%}%>
                            </table>
                        </td>
                    </tr>
                </table>
                <div style="background-color: transparent;width: 20%;text-align: left;;float: left;display: block;clear: both;margin-top: 5px;">
                    <%
                        String lastLogin = securityUser.getLoginDate();
                    %>
                    <div style="margin-left: 5px;color: white;">
                        Last login : <b style=""><%=lastLogin%></B>
                    </div>
                </div>

                <div style="margin: 0px; clear: both;height: 10px;display: block;"></div>
                <img src="images/payment-required.png" height="80%"/>
                <div style="margin: 0px; clear: both;height: 10px;display: block;"></div>
            </div>
            <div id="site-bottom-bar" style="width: 100%">
                <center>
                    <div id="site-bottom-bar-frame" style="width: 100%">
                        <div id="site-bottom-bar-content" style="width: 100%">
                            <div style="padding-top: 5px; font-family: 'Times New Roman', Times, serif;float: left;color: #e7f7fb; font-size: 15px;padding-left: 30px" >
                                © 4S Advanced Technologies
                            </div>
                        </div>
                    </div>
                </center>
            </div>
        </center>
        <%
            } else {
                String servedPage = context + "/index.jsp";
                response.sendRedirect(servedPage);
            }
        %>
    </BODY>
</HTML>
