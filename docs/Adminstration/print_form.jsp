<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<html>
    <%
        String stat = (String) request.getSession().getAttribute("currentMode");
        SimpleDateFormat sdf = new SimpleDateFormat("EEEE dd MMMM yyyy / hh:mm:ss a");
        String dir;
        String align = null, alignX;
        String lang, langCode, close;
        if (stat.equals("En")) {
            align = "left";
            alignX = "right";
            dir = "LTR";
            lang = "&#1593;&#1585;&#1576;&#1610;";
            langCode = "Ar";
            close = "Close";
        } else {
            align = "right";
            alignX = "left";
            dir = "RTL";
            lang = "English";
            langCode = "En";
            close = "أغلاق";
        }
    %>
    <head>
        <script src="jquery-ui/jquery-1.10.2.js"></script>
        <script src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script src="jquery-ui/jquery-ui.js"></script>
        <script src="js/jquery/fileupload/jquery.form.js" ></script>
        <!-- Include css styles here -->
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <LINK rel="stylesheet" href="css/CSS.css">
        <LINK rel="stylesheet" href="css/Button.css">
    </head>
    <body>
        <div id="printFramDiv" align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px; padding-top: 10px; vertical-align: top;">
            
        </div>
    </body>
</html>