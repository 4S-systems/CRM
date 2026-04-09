<%-- 
    Document   : Ajax_Code
    Created on : Mar 4, 2012, 11:18:04 AM
    Author     : Waled
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%
    ArrayList wbo = (ArrayList) request.getAttribute("code");
    String eqNo = ((WebBusinessObject) wbo.get(0)).getAttribute("projectName").toString();

    
%>

<%
    String allCode = "{" + "\"eqNo\"" + ":\"" + eqNo+ "\"" + "}";
%>
<%=allCode%>