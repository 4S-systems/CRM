<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.db_access.EmployeesLoadsMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String messageFlag = (String) request.getAttribute("messageFlag");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String clientNo = (String) request.getAttribute("clientNo");
        String clientId = (String) request.getAttribute("clientId");
        String clientTel = (String) request.getAttribute("clientTel");
        String clientMobile = (String) request.getAttribute("clientMobile");
        String clientName = (String) request.getAttribute("clientName");
        String description = (String) request.getAttribute("description");
        String email = (String) request.getAttribute("email");
        String status = (String) request.getAttribute("status");
        String checked = (String) request.getAttribute("check");
        String incpage = (String) request.getAttribute("incpage");
        String valueS="";
        if(clientTel!=null)
           valueS= clientTel;
        else if(clientMobile!=null)
           valueS= clientMobile;
        else if(clientName!=null)
           valueS= clientName;
        else if(description!=null)
           valueS= description;
        else if(email!=null)
           valueS= email;
        
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        ArrayList<WebBusinessObject> prevList = securityUser.getComplaintMenuBtn();
        boolean displayClient = false;
        boolean displayCompany = false;
        for (WebBusinessObject prevWbo : prevList) {
            if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("add_client")) {
                displayClient = true;
            } else if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("add_company")) {
                displayCompany = true;
            }
        }
        EmployeesLoadsMgr loadsMgr = EmployeesLoadsMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();
        List<WebBusinessObject> loads = new ArrayList<WebBusinessObject>();
        try {
            securityUser = (SecurityUser) session.getAttribute("securityUser");
            List<WebBusinessObject> employees;
            if (securityUser.isCanRunCampaignMode()) {
                employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
            } else {
                employees = userMgr.getUsersByProjectAndGroup(securityUser.getSiteId(), CRMConstants.SALES_MARKTING_GROUP_ID);
            }
            WebBusinessObject employee;
            String[] employeeIds = new String[employees.size() + 1];
            for (int i = 0; i < employees.size(); i++) {
                employee = employees.get(i);
                employeeIds[i] = (String) employee.getAttribute("userId");
            }
            employeeIds[employees.size()] = securityUser.getUserId();
            loads = loadsMgr.employeesLoads(employeeIds);
        } catch (Exception ex) {
        }
        request.setAttribute("loads", loads);
        loads = (List<WebBusinessObject>) request.getAttribute("loads");
        Vector clients = new Vector();
        clients = (Vector) request.getAttribute("clientsVec");
        String align = "center";
        String message = "";
        

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
    </HEAD>
    <script type="text/javascript">

        var oTable;
        var users = new Array();
        $(document).ready(function () {
            $("#clients").css("display", "none");
            oTable = $('#clients').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true

            }).fadeIn(2000);
        });
        /* preparing bar chart */
        var chart;
        $(document).ready(function () {
            $("#searchValue").attr("placeholder", "<fmt:message key="clientno_placeholder"/>");
            
            chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'container',
                    defaultSeriesType: 'bar'
                },
                title: {
                    text: 'أحمال الموظفين',
                    style: {
                        fontWeight: 'bolder'
                    }
                },
                subtitle: {
                    text: ''
                },
                xAxis: {
                    labels: {
                        style: {
                            color: '#6D869F',
                            fontWeight: 'bold'
                        }
                    },
                    categories: [<% if (loads != null) {
                            for (int i = 0; i < loads.size(); i++) {
                                WebBusinessObject wbo_ = loads.get(i);
                                if (i > 0) {
                                    out.write(",");
                                }
                                out.write("'" + (String) wbo_.getAttribute("currentOwnerFullName") + "'");
                            }
                        }%>],
                    title: {
                        text: null
                    }
                },
                yAxis: {
                    allowDecimals: false,
                    min: 0,
                    labels: {
                        style: {
                            fontWeight: 'bold'
                        }
                    },
                    title: {
                        text: 'عدد الطلبات',
                        align: 'high'
                    }
                },
                tooltip: {
                    formatter: function () {
                        return ' ' + 'طلبات' + ' ' + this.y + ' ';
                    }
                },
                plotOptions: {
                    bar: {
                        dataLabels: {
                            enabled: true
                        }
                    }
                },
                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    borderWidth: 0,
                    backgroundColor: '#FFFFFF',
                    shadow: true
                },
                credits: {
                    enabled: false
                },
                series: [{
                        name: 'الطلبات',
                        data: [<% if (loads != null) {
                                for (int i = 0; i < loads.size(); i++) {
                                    WebBusinessObject wbo_ = loads.get(i);
                                    if (i > 0) {
                                        out.write(",");
                                    }
                                    out.write((String) wbo_.getAttribute("noTicket"));
                                }
                            }%>]
                    }]
            });
        });
        /* -preparing bar chart */
        $(function () {
             $("#searchValue").val('<%=valueS %>');
            $("input[name=clientSearch]").change(function () {
                var value = $("input[name=clientSearch]:checked").attr("id");
                if (value == '') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "<fmt:message key="clientno_placeholder"/>");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                } else if (value == 'clientNo') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "<fmt:message key="clientno_placeholder"/>");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                } else if (value == 'clientTel') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "<fmt:message key="phone"/>");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#msgNa").html("");
                    $("#info").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                } else if (value == 'clientMobile') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "<fmt:message key="mobile"/>");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#msgNa").html("");
                    $("#info").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                } else if (value == 'clientName') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "<fmt:message key="clientname"/>");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
                    $("#searchValue").css("border", "");
                } else if (value == 'description') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "<fmt:message key="notes"/>");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
                    $("#searchValue").css("border", "");
                }else if (value == 'email') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "<fmt:message key="email"/>");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
                    $("#searchValue").css("border", "");
                }
            })
        });
        function clearAlert() {
            $("#msgT").html("");
            $("#msgM").html("");
            $("#msgNo").html("");
            $("#info").html("");
            $("#msgNa").html("");
            $("#searchValue").css("border", "");
            $("#showClients").css("display", "none");
        }
        function getClientInfo2(obj) {
            var searchByValue = '';
            var value = $(obj).parent().parent().parent().parent().find("input[name=clientSearch]:checked").attr("id");
            $("#info").html("");
            if ($("#searchValue").val().length >= 3) {
                var clientNo = $("#searchValue").val();
                var clientTel = $("#searchValue").val();
                var clientMobile = $("#searchValue").val();
                /*  if (value == 'clientId') {
                 searchByValue = $("#searchValue").val();
                 document.CLIENT_FORM.action = "<%=context%>/SalesMarketingServlet?op=searchForClient&searchBy=" + value;
                 document.CLIENT_FORM.submit();
                 $("#clients").css("display", "");
                 $("#showClients").val("show");
                 } else */
                if (value == 'clientNo') {
                    searchByValue = $("#searchValue").val();
                    document.CLIENT_FORM.action = "<%=context%>/SalesMarketingServlet?op=searchForClient&searchBy=" + value;
                    document.CLIENT_FORM.submit();
                    $("#clients").css("display", "");
                    $("#showClients").val("show");
                } else if (value == 'clientName') {
                    searchByValue = $("#searchValue").val();
                    document.CLIENT_FORM.action = "<%=context%>/SalesMarketingServlet?op=searchForClient&searchBy=" + value;
                    document.CLIENT_FORM.submit();
                    $("#clients").css("display", "");
                    $("#showClients").val("show");
                } else if (value == 'description') {
                    searchByValue = $("#searchValue").val();
                    document.CLIENT_FORM.action = "<%=context%>/SalesMarketingServlet?op=searchForClient&searchBy=" + value;
                    document.CLIENT_FORM.submit();
                    $("#clients").css("display", "");
                    $("#showClients").val("show");
                } else if (value == 'email') {
                    searchByValue = $("#searchValue").val();
                    document.CLIENT_FORM.action = "<%=context%>/SalesMarketingServlet?op=searchForClient&searchBy=" + value;
                    document.CLIENT_FORM.submit();
                    $("#clients").css("display", "");
                    $("#showClients").val("show");
                }

                /*if ($.trim(searchByValue).length > 0) {
                 $.ajax({
                 type: "post",
                 url: "<%=context%>/SalesMarketingServlet?op=searchForClient",
                 data: {searchBy: value,
                 searchByValue: searchByValue,
                 clientTel: clientTel,
                 clientNo: clientNo,
                 clientMobile: clientMobile
                 },
                 success: function (jsonString) {
                 var info = $.parseJSON(jsonString);
                 if (info.clientNoStatus == 'ok') {
                 createComplaint(info.clientId, info.age);
                 $("#msgNo").html("");
                 $("#searchValue").val("")
                 }
                 if (info.clientNoStatus == 'no') {
                 $("#msgNo").html("<fmt:message key="incorrect_clientno"/>");
                 $("#clientTel").val("");
                 $("#clientMobile").val("");
                 $("#msgT").html("");
                 $("#msgM").html("");
                 }
                 if (info.clientTelStatus == 'ok') {
                 createComplaint(info.clientId, info.age);
                 $("#msgT").html("");
                 }
                 if (info.clientTelStatus == 'no') {
                 $("#msgT").html("<fmt:message key="incorrect_phone"/>");
                 $("#clientNo").val("");
                 $("#clientMobile").val("");
                 $("#msgNo").html("");
                 $("#msgM").html("");
                 }
                 if (info.clientMobileStatus == 'ok') {
                 createComplaint(info.clientId, info.age);
                 $("#msgM").html("").fadeIn();
                 }
                 if (info.clientMobileStatus == 'no') {
                 $("#msgM").html("");
                 $("#msgM").html("<fmt:message key="incorrect_mobile"/>");
                 $("#clientNo").val("");
                 $("#clientTel").val("");
                 $("#msgNo").html("");
                 $("#msgT").html("");
                 }
                 }
                 });
                 }*/
            } else {
                $("#info").html('<fmt:message key="contentsearchln"/>');
                $("#searchValue").focus();
                $("#searchValue").css("border", "1px solid red");
            }
        }
    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function createComplaint(clientId, age) {
            if (clientId == null || clientId == "") {
                $("#errorMsg").css("display", "block");
            } else {
                document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=" + clientId + "&clientType=" + age + "&pageType=clientDetailes";
                document.CLIENT_FORM.submit();
            }
        }
        function createComplaints(obj, clientType) {
            document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=" + obj + "&clientType=" + clientType + "&pageType=clientDetailes";
            document.CLIENT_FORM.submit();
        }
        function newClient() {
            document.CLIENT_FORM.action = "<%=context%>/ClientServlet?op=GetClientForm";
            document.CLIENT_FORM.submit();
        }
        function newCompany() {
            document.CLIENT_FORM.action = "<%=context%>/ClientServlet?op=GetCompanyForm";
            document.CLIENT_FORM.submit();
        }
        function createComplaint2() {
            var clientId = $("#clientId").val();
            document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=mail&clientId=" + clientId;
            document.CLIENT_FORM.submit();
        }

        function createComplaint3() {
            var clientId = $("#clientId").val();
            document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=visit&clientId=" + clientId;
            document.CLIENT_FORM.submit();
        }
        function showEmployeeLoads() {
            $("#effect").css('display', 'block');
        }
    </SCRIPT>
    <style>
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#27272a !important;
            margin-right: 5px;
        }
        #row:hover{
            background-color: #EEEEEE;
        }
        .client_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addclient.png);
        }
        .company_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addCompany.png);
        }
        .enter_call {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
        .login {
            direction: rtl;
            margin: 20px auto;
            padding: 10px 5px;
            background: #3f65b7;
            background-clip: padding-box;
            border: 1px solid #ffffff;
            border-bottom-color: #ffffff;
            border-radius: 5px;
            color: #ffffff;

            background: #7abcff; /* Old browsers */
            background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
            background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
        }
        .remove{
            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);
        }
        .toolBox {
            width:40px;
            height: 40px;
            float:right;
            margin: 0px;
            padding: 0px;
        }

        .toolBox a img {
            width: 40px important;
            height: 40px important;
            float: right;
            margin: 0px;
            padding: 0px;
            text-align: right;
        }
        .button2{
            font-family: "Script MT", cursive;
            font-size: 18px;
            font-style: normal;
            font-variant: normal;
            font-weight: 400;
            line-height: 20px;
            width: 134px;
            height: 32px;
            text-decoration: none;
            display: inline-block;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.8s;
            cursor: pointer;
            border-radius: 12px;
            border: 1px solid #008CBA;
            padding-left:2%;
            text-align: center;
        }


        .button2:hover {
            background-color: #afdded;
            padding-top: 0px;
        }
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <%--<div class="toolBox" style="width:40px; border:1px solid black; height:40px; float:left; padding: 2px; margin: 20px;">
                    <a href="#" onclick="showEmployeeLoads()"><image style="width:40px;" src="images/stat.png" title="Eployee's Loads"/></a>
                </div>--%>
                <div style="display: inline-block;width: 350px;margin-left: auto;margin-right: auto;height: 37px;">
                    <input type="button"  onclick="JavaScript:newClient();" style="float: right;margin-right:15px; display: <%=displayClient ? "block" : "none"%>;" class="button2" value='<fmt:message key="client" />' />


                    <input type="button"  onclick="JavaScript:newCompany();" style="display: <%=displayCompany ? "block" : "none"%>;" class="button2" value='<fmt:message key="company" />' />
                </div>
                <div style="display:none;width: 310px;margin-top: 10px;margin-left: auto;margin-right: auto;height: 20px;background-color: #f3f3f5;" id="errorMsg">
                    <FONT style="color: red;font-size: 16px;"><b>
                        <fmt:message key="chooseclient"/></B></font>
                </div>
                <BR>
                <div style="width: 100%;">
                    <fieldset class="set" align="center" width="100%" style="width: 70%;margin-bottom: 10px;">
                        <legend align="center">
                            <table dir=<fmt:message key="direction"/> align="center">
                                <tr>
                                    <td class="td">
                                        <font color="blue" size="6">
                                        <fmt:message key="search"/>
                                        </font>
                                    </td>
                                </tr>
                            </table>
                        </legend>
                        <TABLE ALIGN="<%=align%>" dir=<fmt:message key="direction"/> WIDTH="100%">
                            <tr>
                                <td class='td'>
                                    <TABLE ALIGN="center" DIR=<fmt:message key="direction"/>  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                                        <tr>
                                            <td colspan="3" STYLE="text-align: <fmt:message key="align"/>" class='td'>
                                                <%--<span>
                                                    <input type="radio" name="clientSearch" value="<%=(clientId == null) ? "" : clientId%>" id="clientId"/> 
                                                    <font size="2"  color="#000"><b>
                                                        <fmt:message key="clientId"/>
                                                    </b></font>
                                                </span>--%>
                                                <span>
                                                    <input type="radio" name="clientSearch" value="<%=(clientNo == null) ? "" : clientNo%>" id="clientNo" checked/> 
                                                    <font size="2"  color="#000"><b>
                                                        <fmt:message key="clientno"/>
                                                    </b></font>
                                                </span>
                                                <span>
                                                    <input type="radio" name="clientSearch" value="<%=(clientName == null) ? "" : clientName%>" id="clientName" <%if(clientName!=null){%>checked <%}%>/>
                                                    <font size="2" color="#000"><b>
                                                        <fmt:message key="clientname"/>
                                                    </b></font>
                                                </span>
                                                <span>
                                                    <input type="radio" name="clientSearch" value="<%=(description == null) ? "" : description%>" id="description" <%if(description!=null){%>checked <%}%>/>
                                                    <font size="2" color="#000"><b>
                                                        <fmt:message key="notes"/>
                                                    </b></font>
                                                </span>
                                                    <span>
                                                        <input type="radio" name="clientSearch" value="email" id="email" <%if(email!=null){%>checked <%}%>/>
                                                    <font size="2" color="#000"><b>
                                                        <fmt:message key="email"/>
                                                    </b></font>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr><td colspan="4" STYLE="text-align: <fmt:message key="align"/>" class='td'></td></tr>
                                        <tr>
                                        <div style="text-align: center;width: 80%;margin-left: auto;margin-right: auto" id="te">
                                            <td colspan="3" STYLE="text-align: <fmt:message key="align"/>" class='td'>

                                                <%if (checked != null) {%>
                                                <input type="text" name="searchValue" style="width: 100%" id="searchValue" placeholder='<fmt:message key="clientname"/>' onkeyup="clearAlert()" onkeypress="clearAlert()"/>
                                                <%} else {%>
                                                <input type="text" name="searchValue" style="width: 100%" id="searchValue" placeholder='<fmt:message key="clientname"/>' onkeyup="clearAlert()" onkeypress="clearAlert()" />
                                                <%}%>
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                                <input type="button"  id="searchBtn" onclick="getClientInfo2(this)" value=<fmt:message key="search"/> style=" background-color: #00a2e8; width:75px"/>
                                            </td>
                                        </div>
                            </tr>
                            <tr>
                                <td colspan="3" STYLE="text-align: <fmt:message key="align"/>" class='td'>
                                    <div style="text-align: center;width: 96%;margin-left: auto;margin-right: auto">
                                        <LABEL id="msgM" style="color: red;"></LABEL>
                                        <LABEL id="msgT" style="color: red;"></LABEL>
                                        <LABEL id="msgNo" style="color: red;"></LABEL>
                                        <LABEL id="info" style="color: green;"></LABEL>
                                            <%if (status != null && status.equals("error")) {%>
                                        <LABEL id="msgNa" style="color: red;">
                                            <fmt:message key="noclient"/>
                                        </LABEL>
                                            <%} else if ("errorNo".equals(status)){%>
                                        <LABEL id="msgNa" style="color: red;">
                                            <fmt:message key="incorrect_clientno"/>
                                        </LABEL>
                                            <%}%>
                                    </div>
                                </td>

                            </tr>
                        </TABLE>
                        </td>
                        <td class='td'>
                            <img src="images/sales marketing.jpg" width="250px"/>
                        </td>
                        </tr>
                        </table>
                        <br><br>
                        <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                            <TR>
                                <TD class="td">
                                    &nbsp;
                                </TD>
                            </TR>
                        </TABLE>
                        <%
                            if (messageFlag != null) {
                        %>
                        <center>
                            <table  dir=<fmt:message key="direction"/>>
                                <tr>
                                    <td class="td"  align="<fmt:message key="align"/>">
                                        <H4><font color="red"><%=message%></font></H4>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                        </center>
                        <%
                            }
                        %>
                    </FIELDSET>
                </div>

                <%if (clients != null && !clients.isEmpty()) {
                %>
                <div style="width: 87%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir=<fmt:message key="direction"/> WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="number"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"> <fmt:message key="name"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"> <fmt:message key="mobile"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="mail"/> </th>
                            </tr>
                        <thead>
                        <tbody>  
                            <%
                                Enumeration e = clients.elements();
                                WebBusinessObject wbo = new WebBusinessObject();
                                while (e.hasMoreElements()) {
                                    wbo = (WebBusinessObject) e.nextElement();
                            %>
                            <tr <%--onclick="createComplaints(<%=wbo.getAttribute("id")%>,<%=wbo.getAttribute("age")%>);"--%> style="cursor: pointer" id="row">
                                <TD>
                                    <%if (wbo.getAttribute("clientNO") != null) {%>
                                    <b><%=wbo.getAttribute("clientNO")%></b>
                                    <%}
                                    %>
                                </TD>
                                
                                <TD>
                                    <%if (wbo.getAttribute("name") != null) {%>
                                    <b>
                                         <%=wbo.getAttribute("name")%> 
                                         <a target="_SELF" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                            <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                                onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("id")%>', this);"/>
                                        </a>
                                    </b>
                                    <%if (securityUser.getUserId().equalsIgnoreCase((String) wbo.getAttribute("createdBy")) || securityUser.getUserId().equalsIgnoreCase((String) wbo.getAttribute("ownerUser"))) {%>
                                        <img src="images/icons/done.png" width="20" style="float: left;" title="Owner"/>
                                    <%}%>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo.getAttribute("mobile") != null) {%>
                                    <b><%=wbo.getAttribute("mobile")%></b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo.getAttribute("email") != null) {%>
                                    <b><%=wbo.getAttribute("email")%></b>
                                    <%}%>
                                </TD>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>  

                    </TABLE>
                </div>
                <%        }
                %>
            </div>

            <fieldset id="effect" class="set" style="border-color: #006699; width: 95%;margin-top: 20px;border-radius: 5px; display: none; background-color: white;">
                <img src="images/stat.png" width="40" />
                <div id="container" style="width: 80%; height: 50%; margin: 0 auto"></div>
                <br/>
                <br/><br/>
                <br/>
            </fieldset>
            <br/><br/>
            <br/><br/>
        </FORM>
    </BODY>
</HTML>     
