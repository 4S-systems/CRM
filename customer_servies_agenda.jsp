<%-- 
    Document   : customer_servies_agenda
    Created on : Aug 7, 2017, 4:15:46 PM
    Author     : fatma
--%>

<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8" %>

<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>CS Secretary</title>
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

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
        <div >
            <center>
                <div style="border:0px solid gray; width:100%; margin:auto; padding: 10px;margin-bottom: 0px;">
                    <ul id="tabs" class="shadetabs" style="margin-right:21px;margin-bottom: 0px;">
                        <li ><a id="div1"  style="height: 30px;" href="" ><SPAN style="display: inline-block;padding: 2px;"><%=input%><IMG src="images/icons/appointment.png"width="22px" height="22px"onclick="javascript:showDev1();" ></SPAN></a></li>
                    </ul>
                    <div  dir="rtl" id="con1" style="display:block;border:0px solid gray; width:96%; margin: 0px; ">
                        <jsp:include page="customer_servies_agenda_details.jsp" flush="true"></jsp:include>
                    </div>
                    <br>
                </div>
            </center>
        </div>

    </BODY>
</HTML>