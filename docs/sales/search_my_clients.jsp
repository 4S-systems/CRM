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
<fmt:setBundle basename="Languages.searchClient.searchClient"  />


    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String messageFlag = (String) request.getAttribute("messageFlag");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String clientNo = (String) request.getAttribute("clientNo");
        String clientName = (String) request.getAttribute("clientName");
        String description = (String) request.getAttribute("description");

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
        List<WebBusinessObject> loads = new ArrayList<>();
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
        ArrayList<WebBusinessObject> clients = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        String[] tableHeader = new String[5];
        String align = null;
        String dir = null;
        String style = null;
        String sTitle, message, client;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "My Client Search";
            tableHeader[0] = "id";
            tableHeader[1] = "Client Name";
            tableHeader[2] = "Client Status";
            tableHeader[3] = "Cell Phone";
            tableHeader[4] = "Email";
            message = "";
            client = " New Client ";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "بحث عملائي";
            tableHeader[0] = "رقم العميل";
            tableHeader[1] = "إسم العميل";
            tableHeader[2] = "حالة العميل";
            tableHeader[3] = "رقم الموبايل";
            tableHeader[4] = "الايميل";
            message = "";
            client = " عميل جديد ";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
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
            $(function () {
                $("input[name=clientSearch]").change(function () {
                    var value = $("input[name=clientSearch]:checked").attr("id");
                    if (value === 'clientNo') {
                        $("#searchValue").val("");
                        $("#searchValue").attr("placeholder", "رقم العميل/ التليفون / الموبايل / اخر");
                        $("#msgT").html("");
                        $("#msgM").html("");
                        $("#msgNo").html("");
                        $("#info").html("");
                        $("#msgNa").html("");
                        $("#searchValue").css("border", "");
                        $("#showClients").css("display", "none");
                    } else if (value === 'clientTel') {
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
                    else if (value === 'clientMobile') {
                        $("#searchValue").val("");
                        $("#searchValue").attr("placeholder", "رقم الموبايل");
                        $("#msgT").html("");
                        $("#msgM").html("");
                        $("#msgNo").html("");
                        $("#msgNa").html("");
                        $("#info").html("");
                        $("#searchValue").css("border", "");
                        $("#showClients").css("display", "none");
                    } else if (value === 'clientName') {
                        $("#searchValue").val("");
                        $("#searchValue").attr("placeholder", " إسم العميل");
                        $("#msgT").html("");
                        $("#msgM").html("");
                        $("#msgNo").html("");
                        $("#info").html("");
                        $("#msgNa").html("");
                        $("#searchValue").css("border", "");
                    } else if (value === 'description') {
                        $("#searchValue").val("");
                        $("#searchValue").attr("placeholder", "ملاحظات");
                        $("#msgT").html("");
                        $("#msgM").html("");
                        $("#msgNo").html("");
                        $("#info").html("");
                        $("#msgNa").html("");
                        $("#searchValue").css("border", "");
                    }
                });
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
                var value = $("input[name=clientSearch]:checked").attr("id");
                $("#info").html("");
                if ($("#searchValue").val().length >= 3) {

                    var clientNo = $("#searchValue").val();
                    var clientTel = $("#searchValue").val();
                    var clientMobile = $("#searchValue").val();
                    if (value == 'clientNo') {
                        searchByValue = $("#searchValue").val();
                        document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForMyClients&searchBy=" + value + "&valueSearch=" + searchByValue;
                        document.CLIENT_FORM.submit();
                        $("#clients").css("display", "");
                        $("#showClients").val("show");
                    } else if (value === 'clientName') {
                        searchByValue = $("#searchValue").val();
                        value = "clientName";
                        document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForMyClients&searchBy=" + value + "&valueSearch=" + searchByValue;
                        document.CLIENT_FORM.submit();
                        $("#clients").css("display", "");
                        $("#showClients").val("show");
                    }else if (value === 'description') {
                        searchByValue = $("#searchValue").val();
                        document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForMyClients&searchBy=" + value + "&valueSearch=" + searchByValue;
                        document.CLIENT_FORM.submit();
                        $("#clients").css("display", "");
                        $("#showClients").val("show");
                    }
                } else if ($("#searchValue").val().length < 3 && $("#searchValue").val().length > 0){
                $("#info").html('<fmt:message key="contentsearchln"/>');
                $("#searchValue").focus();
                $("#searchValue").css("border", "1px solid red");
                } else {
                    if (value === 'clientName') {
                        searchByValue = $("#searchValue").val();
                        value = "clientName";
                        document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForMyClients&searchBy=" + value + "&valueSearch=" + searchByValue;
                        document.CLIENT_FORM.submit();
                        $("#clients").css("display", "");
                        $("#showClients").val("show");
                    }else {
                        $("#info").html("<fmt:message key='Message3'/>");
                        $("#searchValue").focus();
                        $("#searchValue").css("border", "1px solid red");
                    }
                }
            }
        </script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function createComplaint(clientId, age) {
                if (clientId == null || clientId === "") {
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
    </head>
    <body>
        <form name="CLIENT_FORM" method="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="display:none;width: 310px;margin-top: 10px;margin-left: auto;margin-right: auto;height: 20px;background-color: #f3f3f5;" id="errorMsg">
                    <font style="color: red;font-size: 16px;"><b>يجب أولا إختيار عميل</B></font>
                </div>
                <br/>
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
                                        
                        <div style="display: inline-block;width: 350px;margin-left: auto;margin-right: auto;height: 37px;">
                            <input type="button"  onclick="JavaScript:newClient();" style="float: right;margin-right:15px; display: <%=displayClient ? "block" : "none"%>;" class="button2" value='<%=client%>' />
                        </div>
                                        
                        <table align="<%=align%>" dir="<%=dir%>" WIDTH="100%">
                            <tr>
                                <td class='td'>
                                    <table align="center" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0" style="margin-right: auto;margin-left: auto;">
                                        <tr>
                                            <td colspan="3" style="<%=style%>" class='td'>
                                                <span>
                                                    <input type="radio" name="clientSearch" value="<%=(clientNo == null) ? "" : clientNo%>" id="clientNo"/> 
                                                    <font size="2" color="#000"><b><fmt:message key="noClient"/></b></font>
                                                </span>
                                                <span>
                                                    <input type="radio" name="clientSearch" value="<%=(clientName == null) ? "" : clientName%>" id="clientName" <%=description == null ? "checked" : ""%>/>
                                                    <font size="2" color="#000"><b><fmt:message key="nameClient"/></b></font>
                                                </span>
                                                <span>
                                                    <input type="radio" name="clientSearch" value="<%=(description == null) ? "" : description%>" id="description" <%=description != null ? "checked" : ""%>/>
                                                    <font size="2" color="#000"><b><fmt:message key="Notes"/></b></font>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr><td colspan="4" style="<%=style%>" class='td'></td></tr>
                                        <tr>
                                            <td colspan="3" style="<%=style%>" class='td'>
                                                <%if (checked != null) {%>
                                                <input type="text" name="searchValue" id="searchValue" placeholder="<fmt:message key='Message'/>" onkeyup="clearAlert()" onkeypress="clearAlert()"onblur=""/>
                                                <%} else {%>
                                                <input type="text" name="searchValue" id="searchValue" placeholder="<fmt:message key='Message'/>" onkeyup="clearAlert()" onkeypress="clearAlert()" onblur=""/>
                                                <%}%>
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                                <input type="button" id="searchBtn" onclick="getClientInfo2(this)" value="<fmt:message key='Search'/>" style=" background-color: #fc8c1c; width:75px"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" style="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 96%;margin-left: auto;margin-right: auto">
                                                    <label id="msgM" style="color: red;"></label>
                                                    <label id="msgT" style="color: red;"></label>
                                                    <label id="msgNo" style="color: red;"></label>
                                                    <label id="info" style="color: green;"></label>
                                                        <%if (status != null && status.equals("error")) {%>
                                                        <label id="msgNa" style="color: red;"><fmt:message key="Message2"/></label>
                                                        <%} else {%>
                                                        <%}%>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td class='td'>
                                    <img src="images/client-search.jpg" width="250px"/>
                                </td>
                            </tr>
                        </table>
                        <br><br>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td class="td">
                                    &nbsp;
                                </td>
                            </tr>
                        </table>
                        <%
                            if (messageFlag != null) {
                        %>
                        <center>
                            <table  dir="<%=dir%>">
                                <tr>
                                    <td class="td" align="<%=align%>">
                                        <h4><font color="red"><%=message%></font></h4>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                        </center>
                        <%
                            }
                        %>
                    </fieldset>
                </div>

                <%if (clients != null && !clients.isEmpty()) {
                %>
                <div style="width: 87%; margin-right: auto; margin-left: auto;" id="showClients">
                    <table align="<%=align%>" dir="<%=dir%>" width="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;padding-top: 5px"><fmt:message key="tableHeader[0]"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;padding-top: 5px"><fmt:message key="tableHeader[1]"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;padding-top: 5px"><fmt:message key="tableHeader[3]"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;padding-top: 5px"><fmt:message key="tableHeader[4]"/></th>
                                <!--<th style="color: #005599 !important;font: 14px; font-weight: bold;">مشاهده الملفات</th>-->
                            </tr>
                        <thead>
                        <tbody>  
                            <%
                                for (WebBusinessObject wbo : clients) {
                            %>
                           <!-- onclick="createComplaints(<%=wbo.getAttribute("id")%>,<%=wbo.getAttribute("age")%>);"-->
                            <tr  style="cursor: pointer" id="row">
                                <td>
                                    <%if (wbo.getAttribute("clientNO") != null) {%>
                                    <b><%=wbo.getAttribute("clientNO")%></b>
                                    <%}
                                    %>
                                </td>
                                <td>
                                    <%if (wbo.getAttribute("name") != null) {%>
                                    <b><%=wbo.getAttribute("name")%></b>
                                         <a target="_blanck"  href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                            <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل" />
                                        </a>
                                        <a target="_blanck" href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wbo.getAttribute("id")%>&clientType=30-40">
                                            <img src="images/icons/eHR.gif" width="30" style="float: left;" title="تفاصيل"
                                                onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("id")%>', this);"/>
                                        </a>
                                    <%}%>
                                </td>
                                <td>
                                    <%if (wbo.getAttribute("mobile") != null) {%>
                                    <b><%=wbo.getAttribute("mobile")%></b>
                                    <%}%>
                                </td>
                                <td>
                                    <%if (wbo.getAttribute("email") != null) {%>
                                    <b><%=wbo.getAttribute("email")%></b>
                                    <%}%>
                                </td>
                                <!--<td id="showFiles">
                                    <a href="<%=context%>/UnitDocReaderServlet?op=ListDoc&equipmentID=<%=wbo.getAttribute("id")%>&type=client">
                                        مشاهدة
                                    </a>
                                </td>-->
                            </tr>
                            <%
                                }
                            %>
                        </tbody>  
                    </table>
                </div>
                <%
                    }
                %>
            </div>
        </form>
    </body>
</html>     
