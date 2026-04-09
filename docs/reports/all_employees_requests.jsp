<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);

        String sBDate = (String) request.getAttribute("fromDate");
        String sEDate = (String) request.getAttribute("toDate");
        String Utype = (String) request.getAttribute("Utype");
        String req = (String) request.getAttribute("reqTyp");
        String empID = (String) request.getAttribute("empID");
        String EmpID = (String) request.getAttribute("EmpID") == null ? " " : (String) request.getAttribute("EmpID");

        ArrayList<WebBusinessObject> reqTypLst = (ArrayList<WebBusinessObject>) request.getAttribute("reqTypLst");
        ArrayList<LiteWebBusinessObject> MyEmpList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("MyEmpList");
        ArrayList<WebBusinessObject> reqStutsLst = (ArrayList<WebBusinessObject>) request.getAttribute("reqStutsLst");
        String reqStatus = (String) request.getAttribute("reqStatus") == null ? " " : (String) request.getAttribute("reqStatus");
        String startDate = null;
        String toDateValue = null;
        if (sEDate != null && !sEDate.equals("")) {
            toDateValue = sEDate;
        } else {
            toDateValue = sdf.format(cal.getTime());
        }
        if (sBDate != null && !sBDate.equals("")) {
            startDate = sBDate;
        } else {
            cal.add(Calendar.MONTH, -1);
            startDate = sdf.format(cal.getTime());
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String Mtitle, Etitle, Atitle, fromDate, toDate, print, note, emp, cT, accept, reject, cancel, notes,
                save, acceptR, rejectR, cancelR, status, ReqTyp, all, Choliday, Eper, Latt, Sholiday, hourCount, req_type;
        if (stat.equals("En")) {
            dir = "LTR";
            align = "center";
            Mtitle = "Employees Requests";
            Etitle = "My Requests";
            Atitle = "All Employees Requests";
            fromDate = "From Date";
            toDate = "To Date";
            print = "View Report";
            note = "Request Notes";
            emp = "Employee Name";
            cT = "Creation Time";
            accept = "Accept";
            reject = "Reject";
            cancel = "Cancel";
            notes = "Notes";
            save = "Save";
            acceptR = "Accept Request";
            rejectR = "Reject Request";
            cancelR = "Cancel Request";
            status = "Request Status";
            ReqTyp = "Request Type";
            hourCount = "Hour Count";
            all = "all";
            Choliday = "Casual Holiday";
            Eper = "Departure Permission";
            Latt = "Attendence Permission";
            Sholiday = "Standard Holiday";
        } else {
            dir = "RTL";
            align = "center";
            Mtitle = "طلبات الموظفين";
            Etitle = "طلبات أجازاتي";
            Atitle = "طلبات كل الموظفين";
            fromDate = "من تاريخ";
            toDate = "الى تاريخ";
            print = "مشاهده التقرير";
            note = "ملاحظات الطلب";
            emp = "اسم الموظف";
            cT = "تاريخ الاضافه";
            accept = "قبول";
            reject = "رفض";
            cancel = "الغاء";
            notes = "ملاحظات";
            save = "حفظ";
            acceptR = "قبول الطلب";
            rejectR = "رفض الطلب";
            cancelR = "الغاء الطلب";
            status = "حالة الطلب";
            ReqTyp = "نوع الطلب";
            hourCount = "المدة(ساعة/دقيقة)";
            Choliday = "اجازة عارضة";
            Eper = "اذن انصراف";
            Latt = "اذن حضور";
            Sholiday = "اجازة اعتيادية";
            all = "الكل";
        }

        ArrayList<LiteWebBusinessObject> reqList = new ArrayList<LiteWebBusinessObject>();
        reqList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("reqList");
        String typ = (String) request.getAttribute("typ");
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet"></link>

        <script type="text/javascript">
            $(document).ready(function () {
                //$("#ReqTyp").val(<%=req%>);
                $("#ReqTyp option[value=<%=req%>]").attr('selected', 'selected');
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });
                $("#empID").select2();

                oTable = $('#EmpRequests').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });

            function submitForm() {
                var empID = '<%=empID%>';
                document.EmployeesLoads.action = "<%=context%>/ReportsServletThree?op=getAllEmployeesRequestsReport&empID=" + empID;
                document.EmployeesLoads.submit();
            }

            function popupAccept(rowId, boId, empId, reqAmount) {
                $("#ArowId").val(rowId);
                $("#AboId").val(boId);
                $("#empId").val(empId);
                $("#reqAmount").val(reqAmount);

                $("#acceptingNotes").val("");
                $('#accept_request').css("display", "block");
                $('#accept_request').bPopup({
                    easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'
                });
            }

            function popupReject(rowId, boId) {
                $("#RrowId").val(rowId);
                $("#RboId").val(boId);
                $("#rejectingNotes").val("");
                $('#reject_request').css("display", "block");
                $('#reject_request').bPopup({
                    easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'
                });
            }

            function popupCancel(rowId, boId) {
                $("#CrowId").val(rowId);
                $("#CboId").val(boId);
                $("#cancelingNotes").val("");
                $('#cancel_request').css("display", "block");
                $('#cancel_request').bPopup({
                    easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'
                });
            }

            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }

            function saveAccept(obj) {
                var rowId = $("#ArowId").val();
                var boId = $("#AboId").val();
                var empId = $("#empId").val();
                var reqAmount = $("#reqAmount").val();
                var comment = $(obj).parent().parent().parent().find("#acceptingNotes").val();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/ReportsServletThree?op=changeEmployeeRequestStatus",
                    data: {
                        rowId: rowId,
                        boId: boId,
                        empId: empId,
                        reqAmount: reqAmount,
                        comment: comment,
                        typ: "accept"
                    }, success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'OK') {
                            $('#accept_request').css("display", "none");
                            $('#accept_request').bPopup().close();
                            alert("Accepted Successfully");
                            location.reload();
                        } else if (eqpEmpInfo.status == 'NO') {
                            alert("Not Accepted");
                        }
                    }
                });
            }

            function saveReject(obj) {
                var rowId = $("#RrowId").val();
                var boId = $("#RboId").val();
                var comment = $(obj).parent().parent().parent().find("#rejectingNotes").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ReportsServletThree?op=changeEmployeeRequestStatus",
                    data: {
                        rowId: rowId,
                        boId: boId,
                        comment: comment,
                        typ: "reject"
                    }, success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'OK') {
                            $('#reject_request').css("display", "none");
                            $('#reject_request').bPopup().close();
                            alert("Rejected Successfully");
                            location.reload();
                        } else if (eqpEmpInfo.status == 'NO') {
                            alert("Not Rejected");
                        }
                    }
                });
            }

            function saveCancel(obj) {
                var rowId = $("#CrowId").val();
                var boId = $("#CboId").val();
                var comment = $(obj).parent().parent().parent().find("#cancelingNotes").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ReportsServletThree?op=changeEmployeeRequestStatus",
                    data: {
                        rowId: rowId,
                        boId: boId,
                        comment: comment,
                        typ: "cancel"
                    }, success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'OK') {
                            $('#cancel_request').css("display", "none");
                            $('#cancel_request').bPopup().close();
                            alert("Canceled Successfully");
                            location.reload();
                        } else if (eqpEmpInfo.status == 'NO') {
                            alert("Not Canceled");
                        }
                    }
                });
            }
        </script>

        <style>
            table label {
                float: right;
            }

            td {
                border: none;
                padding-bottom: 10px;
            }
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }

            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataTD {
                background: #FFF
            }

            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
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
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }

            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }

            .titleRow {
                background-color: orange;
            }

            .detailTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color: #FCC90D;
            }

            .dataDetailTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataDetailTD {
                background: #FFF19F
            }

            tr:nth-child(odd) td.dataDetailTD {
                background: #FFF19F
            }

            .login  h1 {
                font-size: 16px;
                font-weight: bold;

                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;

                margin-left: auto;
                margin-right: auto;
                text-height: 30px;

                color: black;

                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }

            .tbFStyle{
                background: silver;
                width: auto; 
                text-align: right; 
                margin-bottom: 10px !important; 
                margin-left: 135px; 
                margin-right: auto; 
                letter-spacing: 35px;
                border-radius: 10px;
                padding-right: 20px;
            }

            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }
        </style>
    </head>
    <body>
        <table border="0px" class="table tbFStyle" style="margin-top: -10px">
            <tr style="padding: 0px 0px 0px 50px;">
                <td class="td" style="text-align: center;">
                    <a title="Back" style="padding: 5px;">
                        <image style="height:42px;" src="images/icons/BACKNEWTO.png" onclick="window.history.go(-1);"/>
                    </a>
                </td>
            </tr>
        </table>

        <form name="EmployeesLoads" method="post"> 
            <br/>
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <%
                                if (typ != null && typ.equalsIgnoreCase("manager")) {
                            %>
                            <font color="#005599" size="4">
                            <%=Mtitle%>
                            </font>
                            <%
                            } else if (typ != null && typ.equalsIgnoreCase("employee")) {
                            %>
                            <font color="#005599" size="4">
                            <%=Etitle%>
                            </font>
                            <%
                            } else if (typ != null && typ.equalsIgnoreCase("admin")) {
                            %>
                            <font color="#005599" size="4">
                            <%=Atitle%>
                            </font>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" readonly value="<%=startDate%>"/><img src="images/showcalendar.gif"/> 
                            <br/><br/>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" readonly value="<%=toDateValue%>"/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%"  >
                            <b><font size=3 color="white"><%=ReqTyp%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%"  >
                            <b><font size=3 color="white"><%=status%></b>

                        </td>
                    </tr>
                    <tr>

                        <td bgcolor="#dedede" style="text-align:center" valign="middle"  >
                            <SELECT id="reqTyp" name="reqTyp" style="width: 50%">
                                <option value="all" selected="true"><%=all%></option>
                                <sw:WBOOptionList wboList='<%=reqTypLst%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=req%>"/>
                            </SELECT>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle"  >
                            <select id="statusReq" name="statusReq" style="width: 50%">
                                <option value="all"><%=all%></option>
                                <% if (reqStutsLst != null && reqStutsLst.size() > 0) {
                                        for (WebBusinessObject wbo : reqStutsLst) {
                                %>
                                <option value="<%=wbo.getAttribute("ID")%>"  <%if (reqStatus.equals(wbo.getAttribute("ID"))) {%> selected="true" <%}%>><%=stat.equals("En") ? wbo.getAttribute("CASE_EN") : wbo.getAttribute("CASE_AR")%> </option>
                                <%}
                                    }%>
                            </select>

                        </td>
                    </tr>
                    <%if (typ != null && !typ.equalsIgnoreCase("employee")) {%>
                    <tr>
                        

                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%"  >
                            <b><font size=3 color="white"><%=emp%></b>

                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="1" WIDTH="20%" colspan="1">

                            <select id="selectedEMP" name="selectedEMP" style="width: 50%">
                                <option value="all"><%=all%></option>

                                <% if (MyEmpList != null && MyEmpList.size() > 0) {
                                        for (LiteWebBusinessObject wbo : MyEmpList) {
                                %>
                                <option value="<%=wbo.getAttribute("empID")%>" <%if (EmpID.equals(wbo.getAttribute("empID"))) {%> selected="true" <%}%>><%=wbo.getAttribute("employeeName")%> </option>
                                <%}
                                    }%>
                            </select>
                        </td>
                    </tr>
                    <%}%>
                    <tr>
                       
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="1" colspan="2">
                            <button  onclick="JavaScript: submitForm();" STYLE="color: #000;font-size:15px;font-weight:bold;height: 35px;"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"/> </button>
                            <input type="hidden" value="<%=Utype%>" id="typ" name="typ"/>
                        </td>

                    </tr>
                </table>
                <br>
                <%
                    if (reqList != null) {
                %>
                <div style="width: 90%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table width="100%" id="EmpRequests" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=fromDate%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=toDate%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=hourCount%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=note%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=emp%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=ReqTyp%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=cT%></th>
                                    <%
                                        if (typ != null && (typ.equalsIgnoreCase("employee") || typ.equalsIgnoreCase("admin") || typ.equalsIgnoreCase("manager"))) {
                                    %>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=status%></th>
                                    <%
                                        }
                                    %>
                                    <%
                                        if (typ != null && (typ.equalsIgnoreCase("employee") || typ.equalsIgnoreCase("manager"))) {
                                    %>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 22%;"></th>
                                    <%
                                        }
                                    %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                ProjectMgr projectMgr = ProjectMgr.getInstance();
                                for (LiteWebBusinessObject wbo : reqList) {

                                    WebBusinessObject typeWbo = projectMgr.getOnSingleKey("key", wbo.getAttribute("reqID").toString());
                                    Date d1 = new Date();
                                    Date d2 = new Date();
                                    String t1 = wbo.getAttribute("fromDate").toString();
                                    String t2 = wbo.getAttribute("toDate").toString();

                                    /*long diffHours = 0;
                                    SimpleDateFormat format = new SimpleDateFormat("YYYY-MM-DD HH:mm:ss.0");
                                    try {
                                        d1 = format.parse(t1);
                                        d2 = format.parse(t2);
                                        long diff = d2.getTime() - d1.getTime();
                                        if (diff != 0) {
                                            diffHours = diff / (60 * 60 * 1000) % 24;
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }*/
                                    
                                    int hours = Integer.parseInt(wbo.getAttribute("vacByMinute").toString()) / 60;
                                    int minutes = Integer.parseInt(wbo.getAttribute("vacByMinute").toString()) % 60;


                            %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <b>
                                        <%=wbo.getAttribute("fromDate").toString().split(" ")[0]%>
                                        <font style="color: red">
                                        <%=wbo.getAttribute("fromDate").toString().split(" ")[1]%>
                                    </b>
                                </TD>
                                <TD>
                                    <b>
                                        <%=wbo.getAttribute("toDate").toString().split(" ")[0]%>
                                        <font style="color: red">
                                        <%=wbo.getAttribute("toDate").toString().split(" ")[1]%>
                                    </b>
                                </TD>
                                <TD>
                                    <%=hours%><font color="red">/</font><%=minutes%>                      
                                </TD>
                                <TD>
                                    <%=wbo.getAttribute("note") != null ? wbo.getAttribute("note") : "---"%>
                                </TD>
                                <TD>
                                    <%=wbo.getAttribute("empName")%>
                                </TD>
                                <TD>
                                    <%=typeWbo.getAttribute("projectName")%>
                                </TD>
                                <TD>
                                    <%=wbo.getAttribute("creationTime").toString().split(" ")[0]%>
                                </TD>
                                <%
                                    if (typ != null && (typ.equalsIgnoreCase("employee") || typ.equalsIgnoreCase("admin") || typ.equalsIgnoreCase("manager"))) {
                                        if (stat.equals("En")) {
                                %>
                                <TD>
                                    <%=wbo.getAttribute("statusEn")%>
                                </TD>
                                <%
                                } else {
                                %>
                                <TD>
                                    <%=wbo.getAttribute("statusAr")%>
                                </TD>
                                <%
                                        }
                                    }
                                %>
                                <%
                                    if (typ != null && (typ.equalsIgnoreCase("employee") || typ.equalsIgnoreCase("manager"))) {
                                %>
                                <TD>
                                    <%
                                        if (typ != null && typ.equalsIgnoreCase("manager")&&wbo.getAttribute("STCODE").equals("68") ) {
                                    %>
                                    <input type="button" id="accept" name="accept"  value="<%=accept%>" onclick="popupAccept(<%=wbo.getAttribute("issStatusId")%>, <%=wbo.getAttribute("rowID")%>, <%=wbo.getAttribute("empID")%>, <%=wbo.getAttribute("reqAmount")%>);" style="margin: 2px;">
                                    <input type="button" id="reject" name="reject"  value="<%=reject%>" onclick="popupReject(<%=wbo.getAttribute("issStatusId")%>, <%=wbo.getAttribute("rowID")%>);" style="margin: 2px;">
                                    <%
                                    } else if (typ != null && typ.equalsIgnoreCase("employee")) {
                                        if (wbo.getAttribute("statusAr").equals("مطلوب")) {
                                    %>
                                    <input type="button" id="cancel" name="cancel" value="<%=cancel%>" onclick="popupCancel(<%=wbo.getAttribute("issStatusId")%>, <%=wbo.getAttribute("rowID")%>);" style="margin: 2px;">
                                    <%
                                            }
                                        }
                                    %>
                                </TD>

                                <%
                                    }
                                %>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    <BR>   
                    <div id="accept_request" style="width: 40% !important;display: none;position: fixed"><!--class="popup_appointment" -->
                        <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                 -webkit-border-radius: 100px;
                                 -moz-border-radius: 100px;
                                 border-radius: 100px;" onclick="closePopup(this)"/>
                        </div>
                        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                            <h1><%=acceptR%></h1>
                            <table style="width:90%;">
                                <tr>
                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                        <%=notes%>
                                    </td>
                                    <td style="text-align:right;width: 70%;">
                                        <textarea cols="26" rows="3" id="acceptingNotes">
                                        </textarea>
                                    </td>
                                </tr>
                            </table>
                            <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                                <input type="submit" value="<%=save%>" onclick="javascript: saveAccept(this)" class="login-submit" style="background: #FF9900;"/>
                            </div>
                            <div id="progress" style="display: none;">
                                <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                            </div>
                            <input type="hidden" id="ArowId" value=""/>
                            <input type="hidden" id="AboId" value=""/>
                            <input type="hidden" id="empId" value=""/>
                            <input type="hidden" id="reqAmount" value=""/>
                        </div>  
                    </div>
                    <div id="reject_request" style="width: 40% !important;display: none;position: fixed"><!--class="popup_appointment" -->
                        <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                 -webkit-border-radius: 100px;
                                 -moz-border-radius: 100px;
                                 border-radius: 100px;" onclick="closePopup(this)"/>
                        </div>
                        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                            <h1><%=rejectR%></h1>
                            <table style="width:90%;">
                                <tr>
                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                        <%=notes%>
                                    </td>
                                    <td style="text-align:right;width: 70%;">
                                        <textarea cols="26" rows="3" id="rejectingNotes">
                                        </textarea>
                                    </td>
                                </tr>
                            </table>
                            <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                                <input type="submit" value="<%=save%>" onclick="javascript: saveReject(this)" class="login-submit" style="background: #FF9900;"/>
                            </div>
                            <div id="progress" style="display: none;">
                                <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                            </div>
                            <input type="hidden" id="RrowId" value=""/>
                            <input type="hidden" id="RboId" value=""/>
                        </div>  
                    </div> 
                    <div id="cancel_request" style="width: 40% !important;display: none;position: fixed"><!--class="popup_appointment" -->
                        <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                 -webkit-border-radius: 100px;
                                 -moz-border-radius: 100px;
                                 border-radius: 100px;" onclick="closePopup(this)"/>
                        </div>
                        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                            <h1><%=cancelR%></h1>
                            <table style="width:90%;">
                                <tr>
                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                        <%=notes%>
                                    </td>
                                    <td style="text-align:right;width: 70%;">
                                        <textarea cols="26" rows="3" id="cancelingNotes">
                                        </textarea>
                                    </td>
                                </tr>
                            </table>
                            <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                                <input type="submit" value="<%=save%>" onclick="javascript: saveCancel(this)" class="login-submit" style="background: #FF9900;"/>
                            </div>
                            <div id="progress" style="display: none;">
                                <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                            </div>
                            <input type="hidden" id="CrowId" value=""/>
                            <input type="hidden" id="CboId" value=""/>
                        </div>  
                    </div>        
                </div>
            </fieldset>
        </form>
    </body>
</html>
