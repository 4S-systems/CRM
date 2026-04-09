<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.tracker.db_access.ProjectMgr, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.common.ParseSideMenu"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    String message = null;
    message = "يوجد عدد مستخدمين الان اكثر من المسموح به";
%>
<html lang="en-US">
    <head>
        <TITLE> CRM System</TITLE>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html  charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=8">
        <link rel="stylesheet"  href="css/message-boxs/box.css" />
        <link rel="Shortcut Icon" href="images/short_cut_icon.png" />
    </head>
    <body>
        <div class="alert-box error"><span>خطاء: </span><%=message%></div>
    </body>
</html>