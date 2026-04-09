<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.db_access.AlertMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
    </head>
 <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.employee_agenda.employee_agenda"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getDefaultRefreshPageInterval();
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        Map<String, String> selectedTabMap = securityUser.getSelectedTab();
        String selectedTab = selectedTabMap.get(CRMConstants.SELECTED_TAB_EMPLOYEE_SHEET);
        if (selectedTab == null) {
            selectedTab = "1";
            securityUser.getSelectedTab().put(CRMConstants.SELECTED_TAB_EMPLOYEE_SHEET, selectedTab);
        }

        AlertMgr alertMgr = AlertMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String count = alertMgr.getUnReadCommentsAlertCount((String) loggedUser.getAttribute("userId"));
    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function() {
            /*if (document.getElementById("selectedTab").value == "2") {
                showDev2();
            } else */if (document.getElementById("selectedTab").value == "3") {
                showDev3();
            } else {
                showDev1();
            }
        });
            
        
        function showDev1() {
            setSeletedTab("1");
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con1").style.display = 'block';
            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

//        function showDev2() {
//            setSeletedTab("2");
//            document.getElementById("con2").style.display = 'block';
//            document.getElementById("con1").style.display = 'none';
//            document.getElementById("con3").style.display = 'none';
//            document.getElementById("con4").style.display = 'none';
//            document.getElementById("con5").style.display = 'none';
//            document.getElementById("con6").style.display = 'none';
//            document.getElementById("con7").style.display = 'none';
//            document.getElementById("div2").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
//        }

        function showDev3() {
            setSeletedTab("3");
            document.getElementById("con3").style.display = 'block';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div3").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        
       
        function setSeletedTab(seletedTab) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ajaxServlet?op=setSeletedTab",
                data: {
                    seletedTab: seletedTab,
                    forPage: '<%=CRMConstants.SELECTED_TAB_EMPLOYEE_SHEET%>'
                }
            });
        }

        
        function openInNewWindow(url) {
            var win = window.open(url, '_blank');
            win.focus();
        }
    </SCRIPT>
    <style>
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
        .popup_{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 30%;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }
        .popup_conten{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 30%;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }
        
        .urgent{
            background-image: url(images/redBgt.png);
        }
    </style>
    <BODY>
        
        <input type="hidden" id="selectedTab" name="selectedTab" value="<%=selectedTab%>"/>
        <div >
            <center>
                <div style="border:0px solid gray; width:100%; margin:auto; padding: 10px;margin-bottom: 0px;">
                    <ul id="tabs" class="shadetabs" style="text-align:right; margin-right:21px;margin-bottom: 0px;">
                        
                        <li><a id="div3" style="height: 60px;"href="javascript:showDev3();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="My_req"/><IMG src="images/MyReq.jpg" width="30px" height="30px" onclick="javascript:showDev3();"></SPAN></a></li>
                        <li><a id="div1"  style="height: 60px;"href="javascript:showDev1();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="emp_req"/><IMG src="images/employee_req1.png"width="30px" height="30px"onclick="javascript:showDev1();" ></SPAN></a></li>
                    </ul>
                        <div dir=<fmt:message key="direction"/> id="con1" style="display:block;border:0px solid gray; width:96%; margin: 0px;">
                        <jsp:include page="/docs/EmpReqs/holidayRequest.jsp" flush="true"></jsp:include>
                    </div>
                    <div dir=<fmt:message key="direction"/> id="con3" style="display:none;border:0px solid gray; width:96%;margin: 0px;">
                        <jsp:include page="all_employees_requests.jsp" flush="true"></jsp:include>
                    </div>
                    <br>
                    <br>
                    <br>
                </div>
            </center>
        </div>
        <script language="JavaScript" type="text/javascript">
            $(document).ready(function(){
                $(".fromToDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
            });
        </script>
    </BODY>
</HTML>