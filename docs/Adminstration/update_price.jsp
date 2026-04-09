<%-- 
    Document   : update_price
    Created on : Jun 30, 2010, 6:48:24 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <center>
        <h1>Update Price..</h1>
        <%
        String message = (String) request.getAttribute("message");
        if(message != null){
        %>
        <p><font color="blue" size="5"><%=message%></font></p>
        <%}%>
        <ol>
            <ul>
                <a style="color:blue;font:italic x-large cursive;" href="DataBaseControlServlet?op=updateQuantifiedPrice">Firstly...</a>
            </ul>
            <ul>
                &ensp;
            </ul>
            <ul>
                And Then Click Secondly
            </ul>
            <ul>
                &ensp;
            </ul>
            <ul>
                <a style="color:blue;font:italic x-large cursive;" href="DataBaseControlServlet?op=updateConfigPrice">Secondly..</a>
            </ul>
        </ol>
        </center>
    </body>
</html>
