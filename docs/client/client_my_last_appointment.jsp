
<%@page import="com.maintenance.common.Tools"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    List<WebBusinessObject> users = (ArrayList<WebBusinessObject>) request.getAttribute("users");
    String from = (String) request.getAttribute("from");
    String to = (String) request.getAttribute("to");
    String createdBy = (String) request.getAttribute("createdBy");

    List<WebBusinessObject> userProjects = (List<WebBusinessObject>) request.getAttribute("userProjects");
    List<WebBusinessObject> meetings = (List<WebBusinessObject>) request.getAttribute("meetings");

    Calendar calendar = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(calendar.getTime());
    String jDateFormat = "yyyy/MM/dd";
    sdf = new SimpleDateFormat(jDateFormat);
    if (from == null || to == null) {
        createdBy = "";
        to = sdf.format(calendar.getTime());
        calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        int yaer = calendar.get(Calendar.YEAR);
        int month = (calendar.get(Calendar.MONTH)) + 1;
        int day = calendar.get(Calendar.DATE);
        from = yaer + "/" + month + "/" + day;
    }

    String stat = "Ar";
    String dir = null, xAlign;
    String title, beginDate, endDate;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "My Last Appointments";
        beginDate = "From Date";
        endDate = "To Date";
        xAlign = "left";
    } else {
        dir = "RTL";
        title = "أخر متابعاتي";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        xAlign = "left";
    }

    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

    ArrayList<String> userPrevList = new ArrayList<>();
    WebBusinessObject wboPrev;
    for (int i = 0; i < groupPrev.size(); i++) {
        wboPrev = (WebBusinessObject) groupPrev.get(i);
        userPrevList.add((String) wboPrev.getAttribute("prevCode"));
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery.datetimepicker.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <link type='text/css' rel='stylesheet' href='jquery-ui/themes/base/jquery-ui-timepicker-addon.css' />
        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#from").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });

                $("#to").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });

                $("#meetingDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    formatTime: 'H:i',
                    defaultTime: '10:00',
                    timepickerScrollbar: false,
                    step: 5
                });

                $("#meetingDateDialog").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: new Date(),
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm"
                });

                $("[title]").tooltip({
                    position: {
                        my: "left top",
                        at: "right+5 top-5"
                    }
                });
            });

            $(document).ready(function () {
                $("#requests").dataTable({
                    "order": [[6, "desc"]],
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });

            function getComplaints() {
                var from = $("#from").val();
                var to = $("#to").val();
                var createdBy = $("#createdBy").val();
                if (from === null || from === "") {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if (to === null || to === "") {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else if (createdBy === null || createdBy === "") {
                    alert("من فضلك أختر المصدر");
                } else {
                    document.COMP_FORM.action = "<%=context%>/AppointmentServlet?op=getMyLastAppointmentWithClient&createdBy=" + createdBy + "&from=" + from + "&to=" + to;
                    document.COMP_FORM.submit();
                }
            }

            function switchValue(id) {
                if (id === 'callResultMetting') {
                    $("#meetingDateDiv").css("display", "block");
                    $("#appCallResult").css("display", "none");
                } else if (id === 'callResultPhone') {
                    $("#meetingDateDiv").css("display", "none");
                    $("#appCallResult").css("display", "block");
                } else {
                    $("#meetingDateDiv").css("display", "none");
                    $("#appCallResult").css("display", "none");
                }
            }

            function callResultsChng() {
                var callResult = $("#callResult option:selected").val();
                if (callResult === "meeting") {
                    $("#callStatusTd").css("display", "none");
                    $("#callStatus").css("display", "none");
                } else if (callResult === "inboundcall") {
                    $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
                } else if (callResult === "outbouncall") {
                    $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
                } else if (callResult === "internet") {
                    $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
                } else {
                    $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
                }
            }

            function callResultsChange() {
                var selectedValue = $("#nextAction option:selected").val();
                if (selectedValue === "Follow" || selectedValue === "Visit" || selectedValue === "Waiting")
                {
                    $("#meetresaultlbl").css("display", "block");
                    $("#meetingDateTD").css("display", "block");
                }
                else
                {
                    $("#meetresaultlbl").css("display", "none");
                    $("#meetingDateTD").css("display", "none");
                }

                if (selectedValue === "Visit")
                {
                    $("#appointmentPlacelbl").css("display", "block");
                    $("#appointmentPlaceDDL").css("display", "block");
                } else {
                    $("#appointmentPlacelbl").css("display", "none");
                    $("#appointmentPlaceDDL").css("display", "none");
                }
            }

            function callStatusChange() {
                var selectedValue = $("#callStatus option:selected").val();

                if (selectedValue === "answered")
                {
                    $("#callResultTD").css("display", "block");
                    $("#nextAction").css("display", "block");
                }
                else
                {
                    $("#callResultTD").css("display", "none");
                    $("#nextAction").css("display", "none");

                    $("#meetresaultlbl").css("display", "none");
                    $("#meetingDateTD").css("display", "none");

                    $("#appointmentPlacelbl").css("display", "none");
                    $("#appointmentPlaceDDL").css("display", "none");
                }
            }

            function  resetfollowup()
            {
                $("#comment").val("");
                $('#callResult option["مقابلة"]').attr("checked", true);

            }

            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }

            function openCommentDailog(clientId) {
                var divTag = $("#commentDailog");
                divTag.dialog({
                    modal: true,
                    title: 'التعليق',
                    show: "blind",
                    hide: "explode",
                    width: 500,
                    position: {
                        my: 'center',
                        at: 'center'
                    },
                    buttons: {
                        Cancel: function () {
                            $(this).dialog('close');
                        },
                        Save: function () {
                            saveComment(clientId);
                        }
                    }

                }).dialog('open');
            }

            function saveComment(clientId) {
                loadingComment("block");
                var comment = $("#comment").val();
                var type = 0;
                var businessObjectType = 1;
                if (comment.length > 0) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/CommentsServlet?op=saveComment",
                        data: {
                            clientId: clientId,
                            type: type,
                            comment: comment,
                            businessObjectType: businessObjectType
                        }
                        ,
                        success: function (jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status === 'ok') {
                                $("#commentMsg").css("color", "green");
                                $("#commentMsg").text(" تمت الأضافة بنجاح");
                                $('#commentMsg').fadeIn("fast", function () {
                                    $('#commentMsg').css("display", "block");
                                });
                                $('#commentMsg').fadeOut(3000, function () {
                                    $('#commentMsg').css("display", "none");
                                });
                            } else if (eqpEmpInfo.status === 'no') {
                                alert("لم تتم الأضافة");
                            }
                        }
                    });
                } else {
                    $('#commentMsg').css("display", "block");
                    $("#commentMsg").css("color", "red");
                    $("#commentMsg").text("أدخل التعليق");
                }
                loadingComment("none");
            }

            function loading(val) {
                if (val === "none") {
                    $('#loading').fadeOut(2000, function () {
                        $('#loading').css("display", val);
                    });
                } else {
                    $('#loading').fadeIn("fast", function () {
                        $('#loading').css("display", val);
                    });
                }
            }

            function loadingComment(val) {
                if (val === "none") {
                    $('#loadingComment').fadeOut(2000, function () {
                        $('#loadingComment').css("display", val);
                    });
                } else {
                    $('#loadingComment').fadeIn("fast", function () {
                        $('#loadingComment').css("display", val);
                    });
                }
            }
            function exportToExcel() {
                var createdBy = $("#createdBy").val();
                var to = $("#to").val();
                var from = $("#from").val();
                var departmentID = $("#departmentID").val();
                var url = "<%=context%>/AppointmentServlet?op=getLastAppointmentWithClientExel&createdBy=" + createdBy + "&to=" + to + "&from=" + from + "&departmentID=" + departmentID;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=500, height=500");
            }
            var sec = -1;
            function pad(val) {
                return val > 9 ? val : "0" + val;
            }
            setInterval(function () {
                $("#timer").html(pad(parseInt(sec / 3600, 10)) + ":" + pad(parseInt(sec / 60, 10) % 60) + ":" + pad(++sec % 60));
            }, 1000);
            function showFirstAppointment(obj, clientID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/AppointmentServlet?op=getFirstAppointmentAjax",
                    data: {
                        clientID: clientID
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).tooltip({
                            content: function () {
                                return "<table class='appointment_table' border='0' dir='<%=dir%>'><tr><td class='appointment_header' colspan='2'>أول متابعة</td></tr>\n\
                                <tr><td class='appointment_title'>المتابع</td><td class='appointment_data'>" + info.appointmentBy + "</td></tr>\n\
                                <tr><td class='appointment_title' nowrap>تاريخ المتابعة</td><td class='appointment_data'>" + info.appointmentDate + "</td></tr>\n\
                                <tr><td class='appointment_title' nowrap>نوع المتابعة</td><td class='appointment_data'>" + info.appointmentType + "</td></tr>\n\
                                <tr><td class='appointment_title'>التعليق</td><td class='appointment_data'>" + info.comment + "</td></tr>\n\
                                </table>";
                            }
                        });
                    }
                });
            }
        </script>

        <style type="text/css">
            .confirmed {
                background-color: #EBB462;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
            .container {width: 100px; margin: 0 auto; overflow: hidden;}
            .contentBar {width:100px; margin:0 auto; padding-top:0px; padding-bottom:0px;}
            .barlittle {
                background-color:#2187e7;  
                background-image: -moz-linear-gradient(45deg, #2187e7 25%, #a0eaff); 
                background-image: -webkit-linear-gradient(45deg, #2187e7 25%, #a0eaff);
                border-left:1px solid #111; border-top:1px solid #111; border-right:1px solid #333; border-bottom:1px solid #333; 
                width:10px;
                height:10px;
                float:left;
                margin-left:5px;
                opacity:0.1;
                -moz-transform:scale(0.7);
                -webkit-transform:scale(0.7);
                -moz-animation:move 1s infinite linear;
                -webkit-animation:move 1s infinite linear;
            }
            #block_1{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            #block_2{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_3{
                -moz-animation-delay: .2s;
                -webkit-animation-delay: .2s;
            }
            #block_4{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_5{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            @-moz-keyframes move{
                0%{-moz-transform: scale(1.2);opacity:1;}
                100%{-moz-transform: scale(0.7);opacity:0.1;}
            }
            @-webkit-keyframes move{
                0%{-webkit-transform: scale(1.2);opacity:1;}
                100%{-webkit-transform: scale(0.7);opacity:0.1;}
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
                text-height: font-size;


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
            .table label {float: right;}
            .table td {border: none; padding-bottom: 10px;}

            #hideANDseek{ display: none;}          
            .appointment_table {
                padding: 10px 20px;
                color: white;
                border-radius: 20px;
                font: bold 16px "Helvetica Neue", Sans-Serif;
                box-shadow: 0 0 7px black;
            }
            .appointment_header {
                background-color: #d18080;
                padding: 5px;
            }
            .appointment_title {
                background-color: #abc0e5;
                padding: 5px;
            }
            .appointment_data {
                background-color: white;
                padding: 5px;
            }
        </style>
    </head>
    <body>
        <form name="COMP_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table align="center" dir="rtl" width="70%" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="30%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="30%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                    <td style="text-align:center; margin-bottom: 5px; margin-top: 5px" bgcolor="#dedede" rowspan="2">
                                        <button type="button" onclick="JavaScript: getComplaints();" style="color: #27272A;font-size:15px;margin-top: 8px;margin-bottom: 8px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input id="from" readonly name="from" type="text" value="<%=from%>" style="width: 180px; cursor: hand" />                 
                                        <br/><br/>
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input id="to" readonly name="to" type="text" value="<%=to%>" style="width: 180px; cursor: hand" />
                                        <br/><br/>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <% if (data != null) {%>
                            <center>
                                <button type="button" STYLE="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold;"
                                        onclick="exportToExcel()" title="Export to Excel">Excel<IMG HEIGHT="15" SRC="images/search.gif" />
                                </button>
                                <br/>
                                <br/>
                                <div style="width: 99%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%">رقم العميل</TH>  
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>اسم العميل</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="4%"></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%"><b>التليفون</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%"><b>المحمول</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="8%"><b>الرقم الدولى</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>اخر متابع</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="12%"><b>تاريخ أخر متابعة</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>نوع المتابعة</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%"><b> المدة </b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="26%"><b>نتيجة المتابعة</b></TH>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                WebBusinessObject formatted;
                                                String customerName, lastCommenter, phone, mobile, interPhone, description, note, appointmentDate, appointmentType, appointmentResult, callDuration;
                                                for (WebBusinessObject wbo : data) {
                                                    formatted = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("creationTime"), stat);
                                                    phone = (wbo.getAttribute("phone") != null && !wbo.getAttribute("phone").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("phone") : "";
                                                    mobile = (wbo.getAttribute("mobile") != null && !wbo.getAttribute("mobile").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("mobile") : "";
                                                    interPhone = (wbo.getAttribute("interPhone") != null && !wbo.getAttribute("interPhone").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("interPhone") : "";
                                                    description = (wbo.getAttribute("description") != null && !wbo.getAttribute("description").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("description") : "";
                                                    note = (wbo.getAttribute("note") != null && !wbo.getAttribute("note").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("note") : "لا يوجد";
                                                    appointmentType = (wbo.getAttribute("option2") != null && !wbo.getAttribute("option2").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("option2") : "لا يوجد";
                                                    appointmentResult = (wbo.getAttribute("comment") != null && !wbo.getAttribute("comment").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("comment") : "لا يوجد";
                                                    appointmentDate = wbo.getAttribute("appointmentDate") != null ? (String) wbo.getAttribute("appointmentDate") : "";
                                                    callDuration = wbo.getAttribute("callDuration") != null ? (String) wbo.getAttribute("callDuration") : "";

                                                    if (appointmentDate.length() > 10) {
                                                        appointmentDate = appointmentDate.substring(0, appointmentDate.indexOf(" "));
                                                    }
                                                    switch (note) {
                                                        case "INSTANCE-FOLLOW-UP":
                                                            note = "متابعة مباشرة";
                                                            break;
                                                        case "meeting":
                                                            note = "تحديد مقابلة بتاريخ " + appointmentDate;
                                                            break;
                                                    }
                                                    customerName = Tools.checkLength((String) wbo.getAttribute("name"), 25);
                                                    lastCommenter = Tools.checkLength((String) wbo.getAttribute("createdByName"), 15);
                                            %>
                                            <tr id="row">
                                                <td width="5%"><b><%=wbo.getAttribute("clientNO")%></b></td>
                                                <td width="10%"><b title="<%=description%>"><%=customerName%></b></td>   
                                                <td width="4%">
                                                    <img src="images/comment_no.png" title="أضافة تعليق" onclick="JavaScript: openCommentDailog('<%=wbo.getAttribute("id")%>');" height="25" style="cursor: hand;"/>
                                                    <a target="blank" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>"><img src="images/client_details.jpg" title="تفاصيل العميل" height="20"/></a>
                                                </td>  
                                                <td width="5%"><b><%=phone%></b></td>  
                                                <td width="5%"><b><%=mobile%></b></td>  
                                                <td width="8%"><b><%=interPhone%></b></td>     
                                                <td width="10%"><b><%=lastCommenter%></b></td>                                    
                                                <td width="12%"><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                                                <td width="10%"><b><%=appointmentType%></b></td>  
                                                <td width="5%"><b><%=callDuration%> Min</b></td> 
                                                <td width="26%" class="confirmed" onmouseover="JavaScript: showFirstAppointment(this, '<%=wbo.getAttribute("id")%>');" title="<%=appointmentResult%>"><b><%=appointmentResult%></b></td>  
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <% }%>
                        </fieldset>
                    </td>
                </tr>
            </table>

            <div id="commentDailog" style="width: 40%;display: none;">
                <div class="login" style="width:100%;margin-left: auto;margin-right: auto;">
                    <TABLE class="backgroundTable" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="RIGHT" DIR="rtl">
                        <tr>
                            <td style="width: 30%;" class="backgroundHeader"><font color="black" size="3">التعليق : </font></TD>
                            <td style="width: 70%;"><TEXTAREA cols="40" rows="5" name="comment" id="comment" style="width: 100%"></TEXTAREA></TD>
                        </TR>
                    </table>
                    <div id="loadingComment" class="container" style="float: right; width: auto; margin-right: 4px; margin-bottom: 5px;; margin-top: 5px; display: none">
                        <div class="contentBar">
                            <div id="block_1" class="barlittle"></div>
                            <div id="block_2" class="barlittle"></div>
                            <div id="block_3" class="barlittle"></div>
                            <div id="block_4" class="barlittle"></div>
                            <div id="block_5" class="barlittle"></div>
                        </div>
                    </div>
                    <div style="float: left; width: 40%; margin-left: 4px; margin-bottom: 5px; text-align: left;color: black;font-size: 16px;font-weight: bold; color: green; display: none" id="commentMsg">تم إضافة التعليق </div>
                </div>
            </div>
        </form>
    </body>
</html>     
