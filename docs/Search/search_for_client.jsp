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


<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String messageFlag = (String) request.getAttribute("messageFlag");
        String stat = (String) request.getSession().getAttribute("currentMode");
        WebBusinessObject userWbo = new WebBusinessObject();
        userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String groupId = "";
        if (userWbo != null) {
            groupId = (String) userWbo.getAttribute("groupID");
        }
        String clientNo = (String) request.getAttribute("clientNo");
        String clientTel = (String) request.getAttribute("clientTel");
        String clientMobile = (String) request.getAttribute("clientMobile");
        String clientName = (String) request.getAttribute("clientName");

        String status = (String) request.getAttribute("status");
        String checked = (String) request.getAttribute("check");

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
            employees = userMgr.getUsersByGroup(CRMConstants.CUSTOMER_SERVICE_GROUP_ID);
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
        String[] tableHeader = new String[4];
        String align = null;
        String dir = null;
        String style = null;
        String sTitle, message, client_number, client_name, client_phone;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Search";
            tableHeader[0] = "id";
            tableHeader[1] = "username";
            tableHeader[2] = "email";
            tableHeader[3] = "full name";
            client_name = "Client name";
            client_number = "Client number";
            client_phone = "Client phone";
            message = "";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "&#1576;&#1581;&#1579;";
            tableHeader[0] = "رقم العميل";
            tableHeader[1] = "إسم العميل";
            tableHeader[2] = "رقم الموبايل";
            tableHeader[3] = "الايميل";
            client_name = "اسم العميل";
            client_number = "رقم العميل";
            client_phone = "&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
            message = "";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
    </HEAD>
    <script type="text/javascript">

        var oTable;
        var users = new Array();
        $(document).ready(function() {

            //                if ($("#tblData").attr("class") == "blueBorder") {
            //                    $("#tblData").bPopup();
            //                }
            var buttonPlaceholder = $("#buttonPlaceholder").html("<button>Test</button>");
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
        $(document).ready(function() {
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
                    formatter: function() {
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

        //        function getClientInfo(searchBy) {
        //            var searchByValue = '';
        //            var clientNo = $("#clientNo").val();
        //            var clientTel = $("#clientTel").val();
        //            var clientMobile = $("#clientMobile").val();
        //            //            var clientNo = $("#clientNo").val();
        //            if (searchBy == 'clientNo') {
        //                searchByValue = clientNo;
        //
        //            } else if (searchBy == 'clientTel') {
        //                searchByValue = clientTel;
        //
        //            }
        //            else if (searchBy == 'clientMobile') {
        //                searchByValue = clientMobile;
        //
        //            }
        //            else if (searchBy == 'clientName') {
        //                searchByValue = $("#clientName").val();
        //                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForClient&searchBy=" + searchBy;
        //                document.CLIENT_FORM.submit();
        //
        //            }
        //            if ($.trim(searchByValue).length > 0) {
        //                //                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForClient&searchBy=" + searchBy;
        //                //                document.CLIENT_FORM.submit();
        //                $.ajax({
        //                    type: "post",
        //                    url: "<%=context%>/SearchServlet?op=searchForClient",
        //                    data: {searchBy: searchBy,
        //                        searchByValue: searchByValue,
        //                        clientTel: clientTel,
        //                        clientNo: clientNo,
        //                        clientMobile: clientMobile
        //
        //                    },
        //                    success: function(jsonString) {
        //                        var info = $.parseJSON(jsonString);
        //
        //                        if (info.clientNoStatus == 'ok') {
        //                            createComplaint(info.clientId);
        //                            $("#msgNo").html("");
        //                        }
        //                        if (info.clientNoStatus == 'no') {
        //                            $("#msgNo").html("رقم العميل غير صحيح");
        //                            //                            $("#clientNo").val("");
        //                            $("#clientTel").val("");
        //                            $("#clientMobile").val("");
        //                            $("#msgT").html("");
        //                            $("#msgM").html("");
        //                        }
        //                        if (info.clientTelStatus == 'ok') {
        //                            createComplaint(info.clientId);
        //                            $("#msgT").html("");
        //                        }
        //                        if (info.clientTelStatus == 'no') {
        //                            $("#msgT").html("رقم التليفون غير صحيح");
        //                            $("#clientNo").val("");
        //                            //                            $("#clientTel").val("");
        //                            $("#clientMobile").val("");
        //                            $("#msgNo").html("");
        //                            $("#msgM").html("");
        //                        }
        //                        if (info.clientMobileStatus == 'ok') {
        //                            createComplaint(info.clientId);
        //                            $("#msgM").html("");
        //                        }
        //                        if (info.clientMobileStatus == 'no') {
        //                            $("#msgM").html("رقم الموبايل غير صحيح");
        //                            $("#clientNo").val("");
        //                            $("#clientTel").val("");
        //                            $("#msgNo").html("");
        //                            $("#msgT").html("");
        //                            //                            $("#clientMobile").val("");
        //                        }
        //                    }
        //                });
        //                //                createComplaint();
        //
        //            }
        //        }

        $(function() {
            $("input[name=search]").change(function() {
                var value = $("input[name=search]:checked").attr("id");
                if (value == 'clientNo') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "رقم العميل/ التليفون / الموبايل / اخر / دولي");
                    //                alert(searchByValue);
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");

                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                } else if (value == 'clientTel') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "رقم التليفون");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#msgNa").html("");
                    $("#info").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                }
                else if (value == 'clientMobile') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "رقم الموبايل");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#msgNa").html("");
                    $("#info").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                } else if (value == 'clientName') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", " إسم العميل");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
                    $("#searchValue").css("border", "");

                }
            })

        })
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
            var value = $(obj).parent().parent().parent().parent().find("input[name=search]:checked").attr("id");
            $("#info").html("");
//                                    alert(value)
            if ($(obj).parent().find("#searchValue").val().length > 0) {

                var clientNo = $(obj).parent().find("#searchValue").val();
                var clientTel = $(obj).parent().parent().find("#searchValue").val();
                var clientMobile = $(obj).parent().parent().find("#searchValue").val();
                //            var clientNo = $("#clientNo").val();
                if (value == 'clientNo') {
                    searchByValue = $(obj).parent().parent().find("#searchValue").val();
                    //                alert(searchByValue);

                }
//                else if (value == 'clientTel') {
//                    searchByValue = $(obj).parent().parent().find("#searchValue").val();
//
//                }
//                else if (value == 'clientMobile') {
//                    searchByValue = $(obj).parent().parent().find("#searchValue").val();
//
//                }
                else if (value == 'clientName') {
                    searchByValue = $(obj).parent().parent().find("#searchValue").val();

                    document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForClient&searchBy=" + value;
                    document.CLIENT_FORM.submit();
                    $("#clients").css("display", "");
                    $("#showClients").val("show");


                }
                if ($.trim(searchByValue).length > 0) {
                    //                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForClient&searchBy=" + searchBy;
                    //                document.CLIENT_FORM.submit();
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/SearchServlet?op=searchForClient",
                        data: {searchBy: value,
                            searchByValue: searchByValue,
                            clientTel: clientTel,
                            clientNo: clientNo,
                            clientMobile: clientMobile

                        },
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);

                            if (info.clientNoStatus == 'ok') {
                                createComplaint(info.clientId, info.age);
                                $("#msgNo").html("");
                                $("#searchValue").val("")
                            }
                            if (info.clientNoStatus == 'no') {
                                $("#msgNo").html("رقم العميل غير صحيح");
                                //                            $("#clientNo").val("");
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
                                $("#msgT").html("رقم التليفون غير صحيح");
                                $("#clientNo").val("");
                                //                            $("#clientTel").val("");
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
                                $("#msgM").html("رقم الموبايل غير صحيح");
                                $("#clientNo").val("");
                                $("#clientTel").val("");
                                $("#msgNo").html("");
                                $("#msgT").html("");
                                //                                $("#msgM").html("").fadeIn();
                                //                            $("#clientMobile").val("");
                            }
                        }
                    });
                    //                createComplaint();

                }
            } else {
                $("#info").html("أدخل محتوى البحث");
                $("#searchValue").focus();
                $("#searchValue").css("border", "1px solid red");
            }
        }


    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchSPInSchedule";
            document.CLIENT_FORM.submit();
        }

        function cancelForm()
        {
            document.CLIENT_FORM.action = "main.jsp";
            document.CLIENT_FORM.submit();
        }

        function createComplaint(clientId, age) {
            //            var clientId = $("#clientId").val();
            if (clientId == null || clientId == "") {
                $("#errorMsg").css("display", "block");
            } else {
                document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=" + clientId + "&clientType=" + age;
                document.CLIENT_FORM.submit();
            }
        }
        function createComplaints(obj, clientType) {


            document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=" + obj + "&clientType=" + clientType;
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
            color:#005599;
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
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div class="toolBox" style="width:40px; border:1px solid black; height:40px; float:left; padding: 2px; margin: 20px;">
                    <a href="#" onclick="showEmployeeLoads()"><image style="width:40px;" src="images/stat.png" title="Eployee's Loads"/></a>
                </div>
                <div style="display: inline-block;width: 350px;margin-left: auto;margin-right: auto;height: 37px;">
                    <input type="button"  onclick="JavaScript:newClient();" style="float: right;margin-right:15px; display: <%=displayClient ? "block" : "none"%>;" class="client_btn" />
                    <input type="button"  onclick="JavaScript:newCompany();" style="display: <%=displayCompany ? "block" : "none"%>;" class="company_btn" />

                    <!--<button  onclick="JavaScript: createComplaint();" class="enter_call"></button>-->
                </div>
                <div style="display:none;width: 310px;margin-top: 10px;margin-left: auto;margin-right: auto;height: 20px;background-color: #f3f3f5;" id="errorMsg">
                    <FONT style="color: red;font-size: 16px;"><b>يجب أولا إختيار عميل</B></font>
                </div>
                <BR>
                <div style="width: 100%;">
                    <fieldset class="set" align="center" width="100%" style="width: 70%;margin-bottom: 10px;">
                        <legend align="center">
                            <table dir="<%=dir%>" align="center">
                                <tr>
                                    <td class="td">
                                        <font color="blue" size="6">
                                        <%=sTitle%>
                                        </font>
                                    </td>
                                </tr>
                            </table>
                        </legend>
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%">
                            <tr>
                                <td class='td'>
                                    <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                                        <tr>
                                            <td colspan="3" STYLE="<%=style%>" class='td'>

                                                <span>
                                                    <input type="radio" name="search" value="<%=(clientNo == null) ? "" : clientNo%>" id="clientNo" checked="true" /> 
                                                    <font size="2"  color="#000"><b>أرقام العميل</b></font>
                                                </span>
                                                <span>
                                                    <input type="radio" name="search" value="<%=(clientName == null) ? "" : clientName%>" id="clientName" />
                                                    <font size="2" color="#000"><b>إسم العميل</b></font>
                                                </span>
                                                <%--
                                                <span>
                                                    <input type="radio" name="search" value="<%=(clientNo == null) ? "" : clientNo%>" id="clientNo"/> 
                                                    <font size="2"  color="#000"><b>رقم العميل</b></font>
                                                </span>
                                                <span>
                                                    <input type="radio" name="search" value="<%=(clientTel == null) ? "" : clientTel%>" id="clientTel" />  
                                                    <font size="2" color="#000"><b>رقم التليفون</b></font>
                                                </span>
                                                <span>
                                                    <input type="radio" name="search" value="<%=(clientMobile == null) ? "" : clientMobile%>" id="clientMobile" />
                                                    <font size="2" color="#000"><b>رقم الموبايل</b></font>
                                                </span>
                                                <span>
                                                    <input type="radio" name="search" value="<%=(clientName == null) ? "" : clientName%>" id="clientName" checked="true"   />
                                                    <font size="2" color="#000"><b>إسم العميل</b></font>
                                                </span>
                                                --%> 
                                            </td>
                                        </tr>
                                        <tr><td colspan="4" STYLE="<%=style%>" class='td'></td></tr>
                                        <tr>
                                            <td colspan="3" STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 80%;margin-left: auto;margin-right: auto" id="te">
                                                    <%if (checked != null) {%>
                                                    <input type="text" name="searchValue" id="searchValue" placeholder="رقم العميل/ التليفون / الموبايل / اخر" onkeyup="clearAlert()" onkeypress="clearAlert()"onblur="getClientInfo2(this)"/>
                                                    <%} else {%>
                                                    <input type="text" name="searchValue" id="searchValue" placeholder="رقم العميل/ التليفون / الموبايل / اخر" onkeyup="clearAlert()" onkeypress="clearAlert()" onblur="getClientInfo2(this)"/>
                                                    <%}%>
                                                    <input type="button"  id="searchBtn" onclick="getClientInfo2(this)" value="بحث"/>
                                                </div>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="3" STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 96%;margin-left: auto;margin-right: auto">
                                                    <LABEL id="msgM" style="color: red;"></LABEL>
                                                    <LABEL id="msgT" style="color: red;"></LABEL>
                                                    <LABEL id="msgNo" style="color: red;"></LABEL>
                                                    <LABEL id="info" style="color: green;"></LABEL>
                                                        <%if (status != null && status.equals("error")) {%>
                                                    <LABEL id="msgNa" style="color: red;">إسم العميل غير موجود</LABEL>
                                                        <%} else {%>
                                                        <%}%>
                                                </div>
                                            </td>

                                        </tr>
                                        <!--                            <TR>
                                                                        <TD STYLE="<%=style%>" class='td'>
                                                                            <LABEL>
                                                                                <p><b><%=client_number%></b>&nbsp;
                                                                            </LABEL>
                                                                        </TD>
                                                                        <TD STYLE="<%=style%>" class='td'>

                                                                            <input type="TEXT" value="<%=(clientNo == null) ? "" : clientNo%>" id="clientNo" name="clientNo" onblur="getClientInfo('clientNo');
                                                                                return false;">

                                                                        </TD>
                                                                        <td STYLE="<%=style%>;width: 150px;" class='td'> <LABEL id="msgNo" style="color: red;"></LABEL></td>
                                                                    </TR>
                                                                    <TR>
                                                                        <TD STYLE="<%=style%>" class='td'>
                                                                            <LABEL>
                                                                                <p><b><%=client_phone%></b>&nbsp;
                                                                            </LABEL>
                                                                        </TD>
                                                                        <TD STYLE="<%=style%>" class='td'>
                                                                            <input type="TEXT" value="<%=(clientTel == null) ? "" : clientTel%>" id="clientTel" name="clientTel" onblur="getClientInfo('clientTel');
                                                                                return false;">  
                                                                        </TD>
                                                                        <td STYLE="<%=style%>;width: 150px;" class='td'> <LABEL id="msgT" style="color: red;"></LABEL></td>
                                                                    </TR> 
                                                                    <TR>
                                                                        <TD STYLE="<%=style%>" class='td'>
                                                                            <LABEL>
                                                                                <p><b>رقم الموبايل</b>&nbsp;
                                                                            </LABEL>
                                                                        </TD>
                                                                        <TD STYLE="<%=style%>" class='td'>
                                                                            <input type="TEXT" value="<%=(clientMobile == null) ? "" : clientMobile%>" id="clientMobile" name="clientMobile" onblur="getClientInfo('clientMobile');
                                                                                return false;">  
                                                                        </TD>
                                                                        <td STYLE="<%=style%>;width: 150px;" class='td'> <LABEL id="msgM" style="color: red;"></LABEL></td>
                                                                    </TR>
                                                                    <TR>
                                                                        <TD STYLE="<%=style%>" class='td'>
                                                                            <LABEL>
                                                                                <p><b><%=client_name%></b>&nbsp;
                                                                            </LABEL>
                                                                        </TD>
                                                                        <TD STYLE="<%=style%>" class='td'>
                                                                            <input type="TEXT" value="<%=(clientName == null) ? "" : clientName%>" id="clientName" name="clientName" onblur="getClientInfo('clientName');
                                                                                return false;">
                                                                        </TD>
                                                                    </TR> -->
                                    </TABLE>
                                </td>
                                <td class='td'>
                                    <img src="images/customer-service.jpg" width="250px"/>
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
                        <%                        if (messageFlag
                                    != null) {
                        %>
                        <center>
                            <table  dir="<%=dir%>">
                                <tr>
                                    <td class="td"  align="<%=align%>">
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
        </FORM>


        <%if (clients != null && !clients.isEmpty()) {
        %>
        <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                <thead>
                    <tr>


                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">رقم العميل</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">إسم العميل</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">حالة العميل</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">رقم الموبايل</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">البريد الإلكترونى</th>

                    </tr>
                <thead>
                <tbody >  
                    <%

                        Enumeration e = clients.elements();

                        WebBusinessObject wbo = new WebBusinessObject();
                        while (e.hasMoreElements()) {

                            wbo = (WebBusinessObject) e.nextElement();
                    %>

                    <tr  onclick="createComplaints(<%=wbo.getAttribute("id")%>,<%=wbo.getAttribute("age")%>);" style="cursor: pointer" id="row">

                        <TD>

                            <%if (wbo.getAttribute("clientNO") != null) {%>
                            <b><%=wbo.getAttribute("clientNO")%></b>
                            <%}
                            %>

                        </TD>

                        <TD >

                            <%if (wbo.getAttribute("name") != null) {%>
                            <b><%=wbo.getAttribute("name")%></b>
                            <%}%>

                        </TD>
                        <TD>
                            <%if (wbo.getAttribute("currentStatusNameEn") != null) {%>
                            <b><%=wbo.getAttribute("currentStatusNameEn")%></b>
                            <%}%>
                        </TD>
                        <TD >

                            <%if (wbo.getAttribute("mobile") != null) {%>
                            <b><%=wbo.getAttribute("mobile")%></b>
                            <%}%>

                        </TD>
                        <TD >

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
        <%        } else {%>   
        <%}%>
    </div>
    <fieldset id="effect" class="set" style="border-color: #006699; width: 95%;margin-top: 20px;border-radius: 5px; display: none; background-color: white;">
        <img src="images/stat.png" width="40"/>
        <div id="container" style="width: 80%; height: 50%; margin: 0 auto"></div>
        <br/>
        <br/><br/>
        <br/>
    </fieldset>
    <br/><br/>
    <br/><br/>
</BODY>
</HTML>     
