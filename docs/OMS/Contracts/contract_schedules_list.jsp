<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@page pageEncoding="UTF-8" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String[] operationOrderAttributes = {"contractNumber", "scheduleTitle", "creationTime", "fromDate", "toDate", "frequencyType", "frequencyRate", "scheduleStatusName"};
    String[] operationOrderTitles = new String[11];
    int s = operationOrderAttributes.length;
    int t = operationOrderTitles.length;

    String attName, attValue;
    ArrayList<LiteWebBusinessObject> contractSchedulesList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("contractSchedulesList");
    int flipper = 0;
    String bgColor;
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align, dir, style;
    String lang, langCode, schedulesNo, schedulesTitle, scheduleCancelMsg, cancelSuccessMsg, cancelFailMsg, scheduleExecuteMsg,
            executeSuccessMsg, executeFailMsg, processing;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        operationOrderTitles[0] = "Contract No.";
        operationOrderTitles[1] = "Title";
        operationOrderTitles[2] = "Schedule Date";
        operationOrderTitles[3] = "From Date";
        operationOrderTitles[4] = "To Date";
        operationOrderTitles[5] = "Frequency Type";
        operationOrderTitles[6] = "Rate";
        operationOrderTitles[7] = "Status";
        operationOrderTitles[8] = "Edit";
        operationOrderTitles[9] = "Cancel";
        operationOrderTitles[10] = "Execute";
        schedulesNo = "Schedules  No.";
        schedulesTitle = "Schedules List";
        scheduleCancelMsg = "Schudle will be canceled?";
        cancelSuccessMsg = "Canceled Successfully";
        cancelFailMsg = "Fail to cancel schedule";
        scheduleExecuteMsg = "Schedule will be executed?";
        executeSuccessMsg = "Executed Successfully";
        executeFailMsg = "Fail to execute schedule";
        processing = "Processing ... ";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        operationOrderTitles[0] = "رقم العقد";
        operationOrderTitles[1] = "عنوان الجدول";
        operationOrderTitles[2] = "تاريخ الجدول";
        operationOrderTitles[3] = "من تاريخ";
        operationOrderTitles[4] = "ألي تاريخ";
        operationOrderTitles[5] = "نوع التكرار";
        operationOrderTitles[6] = "معدل التكرار";
        operationOrderTitles[7] = "الحالة";
        operationOrderTitles[8] = "تعديل";
        operationOrderTitles[9] = "ألغاء";
        operationOrderTitles[10] = "تنفيذ";
        schedulesNo = "عدد الجداول";
        schedulesTitle = "عرض الجداول";
        scheduleCancelMsg = "سيتم ألغاء الجدولة؟";
        cancelSuccessMsg = "تم الألغاء";
        cancelFailMsg = "لم يتم الألغاء";
        scheduleExecuteMsg = "سيتم تنفيذ الجدولة؟";
        executeSuccessMsg = "تم التنفيذ بنجاح";
        executeFailMsg = "لم يتم التنفيذ";
        processing = "جاري التنفيذ... ";
    }

%>
<html>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script language="javascript" type="text/javascript">
            $(function () {
                $("#progressbar").progressbar({
                    value: false
                });
            });
            $(document).ready(function () {
                $("#listTable").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });

            function cancelSchedule(scheduleID) {
                var r = confirm("<%=scheduleCancelMsg%>");
                if (r === true) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ContractsServlet?op=cancelContractScheduleAjax",
                        data: {
                            scheduleID: scheduleID
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
                                alert("<%=cancelSuccessMsg%>");
                                location.reload();
                            } else {
                                alert("<%=cancelFailMsg%>");
                            }
                        }
                    });
                }
            }
            function executeSchedule(scheduleID) {
                var r = confirm("<%=scheduleExecuteMsg%>");
                if (r === true) {
                    $("#progressbarDiv").css("display", "block");
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ContractsServlet?op=executeContractScheduleAjax",
                        data: {
                            scheduleID: scheduleID
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
                                alert("<%=executeSuccessMsg%>");
                                location.reload();
                            } else {
                                alert("<%=executeFailMsg%>");
                            }
                            $("#progressbarDiv").css("display", "none");
                        }
                    });
                }
            }
        </script>
        <style type="text/css">
            .table_ th,td{
                text-align: center;
                border: none;
            }
            .login {
                /*display: none;*/
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                /*        width:30%;*/
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            #progressbarDiv {
                left: 0;
                top: 0;
                position: fixed;
                width: 100%;
                height: 100%;
                z-index: 10000;
                background-color: #7abcff;
                background: rgba(122, 188, 255, 0.3);
                display: none;
            }
            #progressbar {
                position: absolute;
                top: 50%; left: 50%;
                transform: translate(-50%,-50%);
                width: 40%;
                z-index: 11000;
            }
            .progress-label {
                position: absolute;
                left: 45%;
                top: 4px;
                font-weight: bold;
                text-shadow: 1px 1px 0 #fff;
            }
            .ui-progressbar-value {
                background: #7abcff;
            }
        </style>
    </head>
    <body>
        <div id="progressbarDiv">
            <div id="progressbar">
                <div class="progress-label"><%=processing%></div>
            </div>
        </div>
        <form action="" name="FLEET_SCHEDULE_FORM" method="post">
            <fieldset align=center class="set">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                            <%=schedulesTitle%>
                            </font>
                        </td>
                    </tr>
                </table>
                <br/>
                <center><b><font size="3" color="red"> <%=schedulesNo%> : <%=contractSchedulesList.size()%> </font></b></center>   
                <div style="width: 90%;margin: 0px auto;">
                    <br/><br/>
                    <table id="listTable" align="<%=align%>" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0" style="display: none">
                        <thead>
                            <tr>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>
                                <th>
                                    <b><%=operationOrderTitles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (LiteWebBusinessObject wbo : contractSchedulesList) {
                                    flipper++;
                                    if ((flipper % 2) == 1) {
                                        bgColor = "silver_odd";
                                    } else {
                                        bgColor = "silver_even";
                                    }
                            %>
                            <tr>
                                <%
                                    for (int i = 0; i < s; i++) {
                                        attName = operationOrderAttributes[i];
                                        attValue = (String) wbo.getAttribute(attName) + " ";
                                        if (attValue != null) {
                                            if (attName.equals("creationTime")) {
                                                attValue = attValue.substring(0, attValue.indexOf(" "));
                                            } else if (attName.equals("fromDate") || attName.equals("toDate")) {
                                                attValue = attValue.substring(0, attValue.indexOf(" "));
                                            } else if (attName.equals("frequencyType")) {
                                                switch (attValue.trim()) {
                                                    case "1":
                                                        attValue = "يومي";
                                                        break;
                                                    case "2":
                                                        attValue = "أسبوعي";
                                                        break;
                                                    case "3":
                                                        attValue = "شهري";
                                                        break;
                                                    case "4":
                                                        attValue = "سنوي";
                                                        break;
                                                }
                                            }
                                        }
                                %>
                                <td style="<%=style%>" bgcolor="#DDDD00" nowrap  class="<%=bgColor%>" >
                                    <b> <%=attValue%> </b><b style="color: blue;"></b>
                                </td>
                                <%
                                    }
                                %>
                                <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-right:10px;<%=style%>">
                                    <div id="links">
                                        <%
                                            if (CRMConstants.SCHEDULE_STATUS_CANCELED.equals(wbo.getAttribute("scheduleStatus"))
                                                    || CRMConstants.SCHEDULE_STATUS_DONE.equals(wbo.getAttribute("scheduleStatus"))) {
                                        %>
                                        ---
                                        <%
                                        } else {
                                        %>
                                        <a href="<%=context%>/ContractsServlet?op=updateContractSchedule&scheduleID=<%=wbo.getAttribute("id")%>&contractID=<%=wbo.getAttribute("contractID")%>">
                                            <%=operationOrderTitles[8]%>
                                        </a>
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>
                                <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-right:10px;<%=style%>">
                                    <div id="links">
                                        <%
                                            if (CRMConstants.SCHEDULE_STATUS_CANCELED.equals(wbo.getAttribute("scheduleStatus"))
                                                    || CRMConstants.SCHEDULE_STATUS_DONE.equals(wbo.getAttribute("scheduleStatus"))) {
                                        %>
                                        ---
                                        <%
                                        } else {
                                        %>
                                        <a href="JavaScript: cancelSchedule('<%=wbo.getAttribute("id")%>');">
                                            <%=operationOrderTitles[9]%>
                                        </a>
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>
                                <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-right:10px;<%=style%>">
                                    <div id="links">
                                        <%
                                            if (CRMConstants.SCHEDULE_STATUS_CANCELED.equals(wbo.getAttribute("scheduleStatus"))
                                                    || CRMConstants.SCHEDULE_STATUS_DONE.equals(wbo.getAttribute("scheduleStatus"))) {
                                        %>
                                        ---
                                        <%
                                        } else {
                                        %>
                                        <a href="JavaScript: executeSchedule('<%=wbo.getAttribute("id")%>');">
                                            <%=operationOrderTitles[10]%>
                                        </a>
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <br/><br/>
            </fieldset>
        </form>
    </body>
</html>
