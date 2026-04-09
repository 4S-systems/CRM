<%-- 
    Document   : demo
    Created on : Jan 13, 2015, 2:05:54 PM
    Author     : yasser
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        List<WebBusinessObject> images = (List<WebBusinessObject>) request.getAttribute("images");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" type="text/css" href="docs/calendar/demo.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" src="docs/calendar/script.js"></script>
    </head>
    <body>
        <div id="main">
            <div id="gallery">
                <div id="slides">
                    <%for (WebBusinessObject image : images) {%>
                    <div class="slide" style="width: 920px; height: 400px">
                        <img src="<%=image.getAttribute("imagePath")%>" style="" width="920" height="400" alt="" />
                    </div>
                    <%}%>
                </div>
                <div id="menu">
                    <ul class="ul">
                        <li class="fbar li">&nbsp;</li>
                            <%for (WebBusinessObject image : images) {%>
                        <li class="menuItem li">
                            <a href=""><img src="<%=image.getAttribute("imagePath")%>" width="45" height="30" alt="thumbnail" /></a>
                        </li>
                        <%}%>
                    </ul>
                </div>
            </div>
        </div>
    </body>
</html>
