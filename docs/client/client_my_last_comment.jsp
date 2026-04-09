
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.maintenance.common.Tools"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String from = (String) request.getAttribute("from");
    String to = (String) request.getAttribute("to");
    String interCode = (String) request.getAttribute("interCode");

    List<WebBusinessObject> userProjects = (List<WebBusinessObject>) request.getAttribute("userProjects");
    List<WebBusinessObject> callResults = (List<WebBusinessObject>) request.getAttribute("callResults");
    List<WebBusinessObject> meetings = (List<WebBusinessObject>) request.getAttribute("meetings");
    String defaultCampaign = (String) request.getAttribute("defaultCampaign");

    Calendar calendar = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(calendar.getTime());
    String jDateFormat = "yyyy/MM/dd";
    sdf = new SimpleDateFormat(jDateFormat);
    if (from == null || to == null) {
        to = sdf.format(calendar.getTime());
        calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        int yaer = calendar.get(Calendar.YEAR);
        int month = (calendar.get(Calendar.MONTH)) + 1;
        int day = calendar.get(Calendar.DATE);
        from = yaer + "/" + month + "/" + day;
    }

    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate, source, internationalCode, dep;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "My Last Comments";
        beginDate = "From Date";
        endDate = "To Date";
        source = "Source";
        internationalCode = "International Code";
        dep = " Department ";
    } else {
        dir = "RTL";
        title = "أخر تعليقاتي";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        source = "المصــــــــــــدر";
        internationalCode = "الكود الدولي";
        dep = " الإدارة ";
    }
    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    ArrayList groupPrev = groupPrev = new ArrayList(groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1"));

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
        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

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
                    showOn: "button",
                    buttonImageOnly: true,
                    buttonText: "Select end date",
                    formatTime: 'H:i',
                    defaultTime: '10:00',
                    timepickerScrollbar: false,
                    step: 5
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
                var interCode = $("#interCode").val();
                if (from === null || from === "") {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if (to === null || to === "") {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
                    document.COMP_FORM.action = "<%=context%>/CommentsServlet?op=getMyLastCommentWithClient&from=" + from + "&to=" + to + "&interCode=" + interCode;
                    document.COMP_FORM.submit();
                }
            }

            function openDailog(clientName, clientId) {
                var divTag = $("#addFollowUpContent");
                $("#appClientName").html(clientName);
                $("#clientId").val(clientId);
                divTag.dialog({
                    modal: true,
                    title: "أضافة متابعة مباشرة",
                    show: "blind",
                    hide: "explode",
                    width: 800,
                    position: {
                        my: 'center',
                        at: 'center'
                    },
                    buttons: {
                        Close: function () {
                            $(this).dialog('close');
                        },
                        Save: function () {
                            saveFollowUp();
                        }
                    }

                }).dialog('open');
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

            function saveFollowUp() {
                loading("block");

                var clientId = $("#clientId").val();
                var title = '';
                if ($("#appTitle").val() !== null) {
                    title = $("#appTitle").val();
                }
                var callResult = $("input:radio[name=callResult]:checked").val();
                var resultValue = "";
                var appCallResult = $("#appCallResult").val();
                var meetingDate = $("#meetingDate").val();
                if (callResult === '<%=CRMConstants.CALL_RESULT_CALL%>') {
                    resultValue = appCallResult;
                } else if (callResult === '<%=CRMConstants.CALL_RESULT_MEETING%>') {
                    resultValue = meetingDate;
                }

                var appType = '<%=CRMConstants.CALL_RESULT_FOLLOWUP%>';
                var appointmentPlace = $("#appointmentPlace").val();
                var comment = $("#appointmentComment").val();
                var note = '<%=CRMConstants.CALL_RESULT_FOLLOWUP.toUpperCase()%>';

                if (title.length > 0) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=saveFollowUpAppointment",
                        data: {
                            clientId: clientId,
                            title: title,
                            callResult: callResult,
                            resultValue: resultValue,
                            note: note,
                            appType: appType,
                            appointmentPlace: appointmentPlace,
                            comment: comment
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                $("#appMsg").css("color", "green");
                                $('#appMsg').fadeIn("fast", function () {
                                    $('#appMsg').css("display", "block");
                                });
                                $('#appMsg').fadeOut(3000, function () {
                                    $('#appMsg').css("display", "none");
                                });
                            } else if (info.status === 'no') {
                                alert("لم يتم الأضافة");
                            }
                        }
                    });
                } else {
                    $("#appMsg").css("color", "red");
                    $("#appMsg").text("أدخل عنوان المقابلة");
                }
                loading("none");
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
                var interCode = $("#interCode").val();
                var departmentID = $("#departmentID").val();
                var url = "<%=context%>/CommentsServlet?op=getLastCommentWithClientExcel&createdBy=" + createdBy + "&to=" + to + "&from=" + from + "&interCode=" + interCode + "&departmentID=" + departmentID;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }
            function showFirstComment(obj, clientID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=getFirstCommentAjax",
                    data: {
                        clientID: clientID
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).tooltip({
                            content: function () {
                                return "<table class='comment_table' border='0' dir='<%=dir%>'><tr><td class='comment_header' colspan='2'>أول تعليق</td></tr>\n\
                                <tr><td class='comment_title'>المعلق</td><td class='comment_data'>" + info.commentedBy + "</td></tr>\n\
                                <tr><td class='comment_title' nowrap>تاريخ التعليق</td><td class='comment_data'>" + info.commentDate + "</td></tr>\n\
                                <tr><td class='comment_title'>التعليق</td><td class='comment_data'>" + info.comment + "</td></tr>\n\
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
            .comment_table {
                padding: 10px 20px;
                color: white;
                border-radius: 20px;
                font: bold 16px "Helvetica Neue", Sans-Serif;
                box-shadow: 0 0 7px black;
            }
            .comment_header {
                background-color: #d18080;
                padding: 5px;
            }
            .comment_title {
                background-color: #abc0e5;
                padding: 5px;
            }
            .comment_data {
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

                            <br>

                            <table align="center" dir="rtl" width="70%" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="20%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="20%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="20%">
                                        <b> <font size=3 color="white"> <%=internationalCode%> </b>
                                    </td>
                                    <td style="text-align:center; margin-bottom: 5px; margin-top: 5px" bgcolor="#dedede" rowspan="2">
                                        <button type="button" onclick="JavaScript: getComplaints();" style="color: #000;font-size:15px;margin-top: 8px;margin-bottom: 8px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input id="from" readonly name="from" type="text" value="<%=from%>" style="width: 180px; cursor: hand" />                 
                                        <br><br>
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input id="to" readonly name="to" type="text" value="<%=to%>" style="width: 180px; cursor: hand" />
                                        <br><br>
                                    </td>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <select id="interCode" name="interCode" style="font-size: 14px;font-weight: bold; width: 180px;" >
                                            <option value="-">الكل</option>
                                            <option value="00974" <%="00974".equals(interCode) ? "selected" : ""%>>00974</option>
                                            <option value="00971" <%="00971".equals(interCode) ? "selected" : ""%>>00971</option>
                                            <option value="00966" <%="00966".equals(interCode) ? "selected" : ""%>>00966</option>
                                            <option value="00965" <%="00965".equals(interCode) ? "selected" : ""%>>00965</option>
                                            <option value="00973" <%="00973".equals(interCode) ? "selected" : ""%>>00973</option>
                                            <option value="00968" <%="00968".equals(interCode) ? "selected" : ""%>>00968</option>
                                            <option value="00213" <%="00213".equals(interCode) ? "selected" : ""%>>00213</option>
                                            <option value="00964" <%="00964".equals(interCode) ? "selected" : ""%>>00964</option>
                                            <option value="00967" <%="00967".equals(interCode) ? "selected" : ""%>>00967</option>
                                            <option value="00963" <%="00963".equals(interCode) ? "selected" : ""%>>00963</option>
                                            <option value="00961" <%="00961".equals(interCode) ? "selected" : ""%>>00961</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <% if (data != null) {%>
                            <center>
                                <button type="button" STYLE="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #000;font-size:15px;margin-top: 20px;font-weight:bold;"
                                        onclick="exportToExcel()" title="Export to Excel">Excel<IMG HEIGHT="15" SRC="images/search.gif" />
                                </button>
                                <br/>
                                <br/>
                                <div style="width: 99%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="6%">رقم العميل</TH>  
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="11%"><b>اسم العميل</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="3%"></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="8%"><b>التليفون</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="8%"><b>المحمول</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="9%"><b>الرقم الدولى</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="11%"><b>اخر معلق</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>تاريخ أخر تعليق</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="22%"><b>التعليق</b></TH>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                WebBusinessObject formatted;
                                                String customerName, lastCommenter, phone, mobile, interPhone, description, comment, callDuration;
                                                for (WebBusinessObject wbo : data) {
                                                    formatted = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("creationTime"), stat);
                                                    phone = (wbo.getAttribute("phone") != null && !wbo.getAttribute("phone").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("phone") : "";
                                                    mobile = (wbo.getAttribute("mobile") != null && !wbo.getAttribute("mobile").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("mobile") : "";
                                                    interPhone = (wbo.getAttribute("interPhone") != null && !wbo.getAttribute("interPhone").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("interPhone") : "";
                                                    description = (wbo.getAttribute("description") != null && !wbo.getAttribute("description").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("description") : "";
                                                    comment = (wbo.getAttribute("comment") != null && !wbo.getAttribute("comment").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("comment") : "";
                                                    customerName = Tools.checkLength((String) wbo.getAttribute("name"), 25);
                                                    lastCommenter = Tools.checkLength((String) wbo.getAttribute("createdByName"), 15);
                                            %>
                                            <tr id="row">
                                                <td width="6%"><b><%=wbo.getAttribute("clientNO")%></b></td>
                                                <td width="11%"><b title="<%=description%>"><%=customerName%></b></td>   
                                                <td width="3%">
                                                    <img src="images/comment_no.png" title="أضافة تعليق" onclick="JavaScript: openCommentDailog('<%=wbo.getAttribute("id")%>');" height="25" style="cursor: hand;"/>
                                                    <img src="images/user_appointments.png" title="أضافة متابعة" onclick="JavaScript: openDailog('<%=wbo.getAttribute("name")%>', '<%=wbo.getAttribute("id")%>');" height="20" style="cursor: hand;"/>
                                                </td>  
                                                <td width="8%"><b><%=phone%></b></td>  
                                                <td width="8%"><b><%=mobile%></b></td>  
                                                <td width="9%"><b><%=interPhone%></b></td>     
                                                <td width="11%"><b><%=lastCommenter%></b></td>                                    
                                                <td width="10%"><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>

                                                <td width="22%" class="confirmed" onmouseover="JavaScript: showFirstComment(this, '<%=wbo.getAttribute("id")%>');" title="<%=comment%>"><b><%=comment%>..</b></td>
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
            <div id="addFollowUpContent" style="width: 95%;margin-bottom: 10px;margin-left: auto;margin-right: auto; display: none">
                <h1 align="center" style="vertical-align: middle">متابعة العميل <b id="appClientName" style="font-weight: bold; font-size: 20px; color: #005599"></b> &nbsp;&nbsp;&nbsp;<img src="images/dialogs/phone.png" alt="phone" width="24px"/></h1>
                <input type="hidden" id="clientId" name="clientId" value="" />
                <table class="table" dir="rtl" style="width:100%; border-width: 2px" bgcolor="#dedede" cellspacing="0" cellpadding="0">
                    <tr style="display: <%=!defaultCampaign.isEmpty() ? "" : "none"%>">
                        <td colspan="3" style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">
                            <table align="center" width="100%" style="border-width: 0px">
                                <tr>
                                    <td style="text-align: left; font-size: 16px;font-weight: bold; border-width: 0px">
                                        <%=defaultCampaign%>
                                    </td>
                                    <td style="color: black; font-size: 16px;font-weight: bold; border-width: 0px">
                                        : 
                                    </td>
                                    <td style="text-align: right; color: black; font-size: 16px;font-weight: bold; border-width: 0px">
                                        Active Campaign  
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">الهدف : </td>
                        <td width="15%" style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <select id="appTitle" name="appTitle" STYLE="width: 100%;font-size: 14px; font-weight: bold;">
                                <sw:WBOOptionList wboList='<%=meetings%>' displayAttribute = "projectName" valueAttribute="projectName" />
                            </select>
                        </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <label id="appTitleMsg"></label>
                        </td>
                    </tr>
                    <tr>
                        <td width="10%" rowspan="3" style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">النتيجة:  </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <input type="radio" id="callResultMetting" name="callResult" value="<%=CRMConstants.CALL_RESULT_MEETING%>" checked onchange="JavaScript: switchValue(this.id);"/>
                            <label><img src="images/icons/meeting.png" alt="meeting" width="24px"/> مقابلة</label>
                        </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <div id="meetingDateDiv">
                                <input name="meetingDate" id="meetingDate" readonly type="text" size="50" maxlength="50" style="width:40%;font-size: medium" value="<%=nowTime%>"/>
                                <img id="meetingDateIcon" src="images/icons/calendar-icon.png" alt="phone" width="16"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px" width="15%">
                            <input type="radio" id="callResultPhone" name="callResult" value="<%=CRMConstants.CALL_RESULT_CALL%>" onchange="JavaScript: switchValue(this.id);"/>
                            <label><img src="images/icons/call.png" alt="phone" width="24px"/>مكالمة </label>
                        </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px" width="75%">
                            <select id="appCallResult" name="appCallResult" STYLE="font-size: medium; font-weight: bold; width: 40%; display: none">
                                <sw:WBOOptionList wboList='<%=callResults%>' displayAttribute = "projectName" valueAttribute="projectID" />
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px" width="25%">
                            <input type="radio" id="callResultNotRespone" name="callResult" value="<%=CRMConstants.CALL_RESULT_FAIL%>" onchange="JavaScript: switchValue(this.id);" />
                            <label><img src="images/icons/call_failed.png" alt="phone" width="24px"/>لايوجد رد</label>
                        </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            &ensp;
                        </td>
                    </tr>
                    <tr>
                        <td style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">الفرع : </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                                <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                <option value="Other">Other</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">تعليق : </td>
                        <td colspan="2" style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <textarea cols="26" rows="10" id="appointmentComment" style="width: 99%; background-color: #FFF7D6;"></textarea>
                        </td>
                    </tr>
                </table>
                <div id="loading" class="container" style="float: right; width: auto; margin-right: 4px; margin-bottom: 5px;; margin-top: 5px; display: none">
                    <div class="contentBar">
                        <div id="block_1" class="barlittle"></div>
                        <div id="block_2" class="barlittle"></div>
                        <div id="block_3" class="barlittle"></div>
                        <div id="block_4" class="barlittle"></div>
                        <div id="block_5" class="barlittle"></div>
                    </div>
                </div>
                <div style="float: left; width: 40%; margin-left: 4px; margin-bottom: 5px; text-align: left;color: black;font-size: 16px;font-weight: bold; color: green; display: none" id="appMsg">تم إضافة المقابلة </div>
            </div>
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
                    <div style="float: left; width: 40%; margin-left: 4px; margin-bottom: 5px; text-align: left;color: black;font-size: 16px;font-weight: bold; color: green; display: none" id="commentMsg">تم إضافة المقابلة </div>
                </div>
            </div>
        </form>
    </body>
</html>     
