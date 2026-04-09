<%-- 
    Document   : CHD_Manager
    Created on : Aug 14, 2017, 10:12:23 AM
    Author     : fatma
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <head>
        <title>CHD Manager</title>
    </head>

    <%
        String stat = (String) request.getSession().getAttribute("currentMode");
        String input, output;

        if (stat.equals("En")) {
            input = "input";
            output = "output";
        } else {
            input = "&#1575;&#1604;&#1608;&#1575;&#1585;&#1583;";
            output = "&#1575;&#1604;&#1589;&#1575;&#1583;&#1585;";
        }
    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        window.onload = function() {
            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
        }
    </SCRIPT>

    <style type="text/css">
        #tabs li{
            display: inline;
        }
        
        #tabs li a{
            text-align:center; font:bold 15px;
            display:inline;
            text-decoration:none;
            padding-right:20px;
            padding-left:20px;
            padding-bottom:0;
            margin:0px;
            font-size: 15px;
            background-image:url(images/buttonbg.jpg);       
            background-repeat: repeat-x;
            background-position: bottom;
            color:#069;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        
        #tabs li a:hover{
            background-color:#FFF;
            color:#069; 
        }
    </style>
    <BODY>     
        <div>
            <center>
                <div style="border:0px solid gray; width:100%; margin:auto; padding: 10px; margin-bottom: 0px;">
                    <div dir="rtl" id="con1" style="display:block; border:0px solid gray; width:96%; margin: 0px;">
                        <jsp:include page="docs/calendar/jobOrderLst.jsp" flush="true"></jsp:include>
                    </div>
                    <br>
                </div>
            </center>
        </div>
    </BODY>
</HTML>