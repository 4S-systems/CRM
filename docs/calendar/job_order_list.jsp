<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    int iTotal = 0;
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    WebBusinessObject areaWbo = (WebBusinessObject) request.getAttribute("areaWbo");
    ArrayList<WebBusinessObject> techniciansList = (ArrayList<WebBusinessObject>) request.getAttribute("techniciansList");
    //String areaID = areaWbo != null && areaWbo.getAttribute("projectID") != null ? (String) areaWbo.getAttribute("projectID") : "";
    String areaName = areaWbo != null && areaWbo.getAttribute("projectName") != null ? (String) areaWbo.getAttribute("projectName") : "";
    //String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate, areaTitle, search, technician;
    String complaintNo, customerName;
    String sat, sun, mon, tue, wed, thu, fri;
    String complStatus, fullName = null;
    String sDate, sTime = null, spareParts, rawMaterials, workers, workItems, actionItems, close;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Job Orders Search";
        beginDate = "From Date";
        endDate = "To Date";
        complaintNo = "Order No.";
        customerName = "Customer name";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        spareParts = "Spare Parts";
        rawMaterials = "Raw Materials";
        workers = "Workers";
        workItems = "Work Items";
        actionItems = "Acrion Items";
        close = "Close";
        areaTitle = "Area";
        search = "Search";
        technician = "Technician";
    } else {
        dir = "RTL";
        title = "بحث عن أوامر صيانة";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        spareParts = "قطع غيار";
        rawMaterials = "مواد خام";
        workers = "عمالة";
        workItems = "بنود أعمال";
        actionItems = "بنود صيانة";
        close = "إغلاق كل الأوامر المختارة";
        areaTitle = "المنطقة";
        search = "بحث";
        technician = "الفني";
    }
%>
<html>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });
                $("#closedEndDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: '<%=nowTime%>',
                    dateFormat: "yy/mm/dd",
                    timeFormat: "hh:mm"
                });
            });
            $(document).ready(function () {
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "bAutoWidth": true,
                    "aaSorting": [[0, "asc"]]

                }).fadeIn(2000);
                $(".dataTables_length, .dataTables_info").css("float", "left");
                $(".dataTables_filter, .dataTables_paginate").css("float", "right");
            });
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }
            function popupClose(obj) {
                if ($("input[name='moveTo']:checked").not(":disabled").length > 0) {
                    $("#closedMsg").hide();
                    $('#closeNote').find("#notes").val("");
                    $('#closeNote').css("display", "block");
                    $('#closeNote').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                        speed: 400,
                        transition: 'slideDown'});
                } else {
                    alert("يجب أختيار أمر واحد علي اﻷقل ﻷغلاقه");
                }
            }
            function selectAll(obj) {
                $("input[name='moveTo']").prop('checked', $(obj).is(':checked'));
            }
            function closeComplaint(obj) {
                var notes = $('#notes').val();
                var endDate = $('#closedEndDate').val();
                var actionTaken = $('#actionTaken').val();
                $("input[name='moveTo']:checked").not(":disabled").each(function () {
                    var clientComplanitID = $(this).val();
                    var issueID = $("#issueID" + clientComplanitID).val();
                    var clientID = $("#clientID" + clientComplanitID).val();
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ComplaintEmployeeServlet?op=closeComp&issueId=" + issueID + "&compId=" + clientComplanitID + "&subject=Job Order&comment=Job Order&complaintId=" + clientComplanitID + "&objectType=" + $("#businessObjectType2").val(),
                        data: {
                            notes: notes,
                            clientId: clientID,
                            endDate: endDate,
                            actionTaken: actionTaken
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                                $("#closedMsg").show();
                                $(obj).removeAttr("onclick");
                            }
                            else {

                            }
                        }
                    });
                });
            }
            function viewAppointment(appointmentID) {
                var url = "<%=context%>/AppointmentServlet?op=viewAppointment&appointmentID=" + appointmentID;
                jQuery('#view_joborder').load(url);
                $('#view_joborder').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            
            function getComplaints(){
                document.COMP_FORM.action = "<%=context%>/AppointmentServlet?op=listJobOrders";
                document.COMP_FORM.submit();
            }
        </script>
        <style>
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
            .num{background: #ffc578; /* Old browsers */
                 background: -moz-linear-gradient(top,  #ffc578 0%, #fb9d23 100%); /* FF3.6+ */
                 background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ffc578), color-stop(100%,#fb9d23)); /* Chrome,Safari4+ */
                 background: -webkit-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Chrome10+,Safari5.1+ */
                 background: -o-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Opera 11.10+ */
                 background: -ms-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* IE10+ */
                 background: linear-gradient(to bottom,  #ffc578 0%,#fb9d23 100%); /* W3C */
                 filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffc578', endColorstr='#fb9d23',GradientType=0 ); /* IE6-9 */
                 font-weight: bold
            }
            .button_close {
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close.png);
            }
            .button_action_items {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/action_items.png);
            }
            .button_raw_materials {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/raw_materials.png);
            }
            .button_spare_parts {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/spare_parts.png);
            }
            .button_worker {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/worker.png);
            }
            .button_work_items {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/work_items.png);
            }
        </style>
    </head>
    <body>
        <div id="view_joborder" style="width: 40% !important;display: none;position: fixed; z-index: 10000;">

        </div>
        <div id="closeNote"  style="width: 40%;display: none; position: fixed">
            <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإغلاق</label></td>
                        <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA>
                            <input type="hidden" name="actionTaken" id="actionTaken" value=""/>
                        </td>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></td>
                        <td style="width: 60%;">  <input name="closedEndDate" id="closedEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></td>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript:closeComplaint(this);" class="button_close">
                            
                        </td>
                    </tr>
                    <tr>
                        <%
                            String msg = "\u062A\u0645 \u0627\u0644\u0623\u063A\u0644\u0627\u0642 \u0628\u0646\u062C\u0627\u062D";
                            if (MetaDataMgr.getInstance().getSendMail() != null && MetaDataMgr.getInstance().getSendMail().equalsIgnoreCase("1")) {
                                msg += " \u0648 \u0623\u0631\u0633\u0627\u0644 \u0625\u0645\u064A\u0644 \u0628\u0630\u0644\u0643";
                        %>
                        
                        <% }%>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="closedMsg"><%=msg%></div>
                        </td>
                    </tr>
                </TABLE>
            </div>
        </div>
        <form NAME="COMP_FORM" METHOD="POST">
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset >
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%>
                                            </font>
                                        </td>
                                    </tr>
                                </table>
                            </legend>
                            <table align="center" dir="rtl" width="570" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate != null && !beDate.isEmpty() ? beDate : ""%>" readonly /><img src="images/showcalendar.gif" > 
                                        <br/><br/>
                                    </td>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate != null && !eDate.isEmpty() ? eDate : ""%>" readonly /><img src="images/showcalendar.gif" > 
                                        <br/><br/>
                                    </td>
                                </tr>
                                 <%--<tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"> <%=areaTitle%></b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
                                        <b> <font size=3 color="white"> <%=technician%> </b>
                                    </td>
                                </tr>
                               <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input type="text" readonly id="regionName" name="regionName" value="<%=areaName%>" />
                                        <input type="hidden" id="region" name="region" value="<%=areaID%>" />
                                        <input type="button" onclick="window.open('<%=context%>/EquipmentServlet?op=getAllRegions', '_blank', 'status=1,scrollbars=1,width=400')" value="<%=search%>">
                                        <br/><br/>
                                    </td>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                        <select name="userID" style="font-size: 14px; width: 200px;">
                                            <option value="">الكل</option>
                                            <sw:WBOOptionList wboList="<%=techniciansList%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=userID%>"/>
                                        </select>
                                        <br/><br/>
                                    </td>
                                </tr>--%>
                                <tr>
                                    <td style="text-align:center" class="td" colspan="3">
                                        <br/><br/>
                                        <button  onclick="JavaScript: getComplaints();" style="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
        <br/>
        <br/>
        <%
            if (data != null && !data.isEmpty()) {
        %>
        <div style="width: 100%; text-align: center;">
            <input type="button" title="<%=close%>" class="button_close" onclick="JavaScript: popupClose();"/>
        </div>
        <br/>
        <table class="display" id="indextable" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="4%"><b>#</b></th>
                    <th ><input type="checkbox" id="ToggleTo" name="ToggleTo" onchange="JavaScript: selectAll(this);"/></th>                
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>الموبايل</b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%"><b>عامل الأتصال</b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>الحاله</b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>تاريخ اﻷمر</b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>الفني</b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b><%=spareParts%></b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b><%=rawMaterials%></b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b><%=workers%></b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b><%=workItems%></b></th>
                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b><%=actionItems%></b></th>
                </tr>
            </thead> 
            <tbody  id="planetData2">  
                <%
                    String compStyle = "";
                    String clientDescription;
                    String disabled;
                    Calendar c = Calendar.getInstance();
                    for (WebBusinessObject wbo : data) {
                        iTotal++;
                        clientDescription = (String) wbo.getAttribute("description");
                        if (clientDescription == null || clientDescription.equalsIgnoreCase("UL")) {
                            clientDescription = "";
                        }
                        disabled = "";
                        if (wbo.getAttribute("statusCode") != null && wbo.getAttribute("statusCode").equals("7")) {
                            disabled = "disabled";
                        }
                %>
                <tr style="padding: 1px;">
                    <td>
                        <%=iTotal%>
                    </td>
                    <td>
                        <input type="checkbox" id="moveTo" name="moveTo" value="<%=wbo.getAttribute("clientComplaintId")%>" <%=disabled%>/>
                        <input type="hidden" id="issueID<%=wbo.getAttribute("clientComplaintId")%>" value="<%=wbo.getAttribute("issueId")%>"/>
                        <input type="hidden" id="clientID<%=wbo.getAttribute("clientComplaintId")%>" value="<%=wbo.getAttribute("clientId")%>"/>
                    </td>
                    <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                        <%if (wbo.getAttribute("issueId") != null) {%>
                        <a href="#" onclick="JavaScript: viewAppointment('<%=wbo.getAttribute("id")%>')"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDByDate").toString()%></font>
                        </a>
                        <%}
                        %>
                    </td>
                    <td>
                        <%if (wbo.getAttribute("clientName") != null) {%>
                            <b title="<%=clientDescription%>" style="cursor: hand;">
                                 <%=wbo.getAttribute("clientName")%> 
                                <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetailsOrder&clientId=<%=wbo.getAttribute("clientId")%>">
                                    <img src="images/icons/client.png" width="20" height="20"/>
                                </a>
                            </b>
                        <%}%>
                    </td>
                    <td>
                        <%if (wbo.getAttribute("clientMobile") != null && !((String) wbo.getAttribute("clientMobile")).equalsIgnoreCase("UL")) {%>
                        <b><%=wbo.getAttribute("clientMobile")%></b>
                        <%}%>
                    </td>
                    <td>
                        <%if (wbo.getAttribute("createdByName") != null) {%>
                        <b><%=wbo.getAttribute("createdByName")%></b>
                        <%}%>
                    </td>
                    <% if (stat.equals("En")) {
                            complStatus = (String) wbo.getAttribute("statusEnName");
                        } else {
                            complStatus = (String) wbo.getAttribute("statusArName");
                        }
                    %>
                    <td><b><%=complStatus%></b></td>
                    <%  c = Calendar.getInstance();
                        DateFormat formatter;
                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                        String[] arrDate = wbo.getAttribute("appointmentDate").toString().split(" ");
                        Date date = new Date();
                        sDate = arrDate[0];
                        sDate = sDate.replace("-", "/");
                        arrDate = sDate.split("/");
                        sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                        c.setTime((Date) formatter.parse(sDate));
                        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                        String currentDate = formatter.format(date);
                        String sDay = null;
                        if (dayOfWeek == 7) {
                            sDay = sat;
                        } else if (dayOfWeek == 1) {
                            sDay = sun;
                        } else if (dayOfWeek == 2) {
                            sDay = mon;
                        } else if (dayOfWeek == 3) {
                            sDay = tue;
                        } else if (dayOfWeek == 4) {
                            sDay = wed;
                        } else if (dayOfWeek == 5) {
                            sDay = thu;
                        } else if (dayOfWeek == 6) {
                            sDay = fri;
                        }
                    %>
                    <%if (currentDate.equals(sDate)) {%>
                    <td nowrap  ><font color="red">Today</font></td>
                            <%} else {%>
                    <td nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate%></b></td>
                            <%}%>
                            <% if (wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("")) {
                                    fullName = (String) wbo.getAttribute("currentOwner");
                                } else {
                                    fullName = "";
                                }
                            %>
                    <td style="width: 10%;" nowrap><b><%=fullName%></b></td>
                    <td nowrap><input type="button" title="<%=spareParts%>" class="button_spare_parts"/></td>
                    <td nowrap><input type="button" title="<%=rawMaterials%>" class="button_raw_materials"/></td>
                    <td nowrap><input type="button" title="<%=workers%>" class="button_worker"/></td>
                    <td nowrap><input type="button" title="<%=workItems%>" class="button_work_items"/></td>
                    <td nowrap><input type="button" title="<%=actionItems%>" class="button_action_items"/></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
        } else if (data != null && data.isEmpty()) {
        %>
        <b style="color: red; font-size: x-large;">لا يوجد نتائج للبحث</b>
        <%
            }
        %>
        <input type="hidden" id="clientId" value="1"/>
    </body>
</html>