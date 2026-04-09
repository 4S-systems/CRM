<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        List<WebBusinessObject> departments = (List<WebBusinessObject>) request.getAttribute("departments");

        String state = (String) request.getSession().getAttribute("currentMode");
        String dir, title;
        String departmentTitle, intervalTitle;
        if (state.equals("En")) {
            dir = "LTR";
            title = "Auto Finish Rules";
            departmentTitle = "Department";
            intervalTitle = "Finished Each";
        } else {
            dir = "RTL";
            title = "قواعد الأنهاء الاتوماتيكى";
            departmentTitle = "اﻷدارة";
            intervalTitle = "أنهاء بعد (الفترة بالساعات)";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function () {
                $('#quartzClosedClientComplaint').dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });

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

            function saveScheduler(id) {
                loading('block');
                if ($("#interval" + id).val() !== "") {
                    var quartzId = $("#quartzId" + id).val();
                    var objectId = $("#departmentId" + id).val();
                    var interval = $("#interval" + id).val();
                    var running = $("#running" + id).val();
                    var toSave = (quartzId !== "-1") ? "0" : "1";
                    $.ajax({
                        type: "post",
                        url: '<%=context%>/QuartzSchedulerConfigurationServlet?op=clientCompliantFinishQuartzSave',
                        data: {
                            quartzId: quartzId,
                            objectId: objectId,
                            interval: interval,
                            running: running,
                            toSave: toSave
                        },
                        success: function (data) {
                            var info = $.parseJSON(data);
                            if (info.status === "ok") {
                                if (toSave === "1") {
                                    $("#quartzId" + id).val(info.id);
                                    $("#saveIcon" + id).attr("src", "images/icons/edit.png");
                                }
                            } else {
                                alert("لم يتم التعديل");
                            }
                        }
                    });
                } else {
                    alert("من فضلك أدخل الفترة");
                    $("#interval" + id).focus();
                }
                loading('none');
            }

            function startScheduler(id) {
                loading('block');
                if ($("#interval" + id).val() !== "") {
                    var quartzId = $("#quartzId" + id).val();
                    var objectId = $("#departmentId" + id).val();
                    var interval = $("#interval" + id).val();
                    var toSave = (quartzId !== "-1") ? "0" : "1";
                    var running = $("#running" + id).val();
                    $.ajax({
                        type: "post",
                        url: '<%=context%>/QuartzSchedulerConfigurationServlet?op=clientCompliantFinishQuartzUpdateRunning',
                        data: {
                            quartzId: quartzId,
                            objectId: objectId,
                            interval: interval,
                            running: running,
                            toSave: toSave
                        },
                        success: function (data) {
                            var info = $.parseJSON(data);
                            if (info.status === "ok") {
                                if (running === "<%=CRMConstants.QUARTZ_ACTION_STATUS_RUNNING%>") {
                                    $("#imgStatus" + id).attr("src", "images/icons/stop.png");
                                    $("#running" + id).val("<%=CRMConstants.QUARTZ_ACTION_STATUS_NOT_RUNNING%>");
                                    $("#quartzId" + id).val(info.id);
                                    $("#saveIcon" + id).attr("src", "images/icons/edit.png");
                                } else {
                                    $("#imgStatus" + id).attr("src", "images/icons/play.png");
                                    $("#running" + id).val("<%=CRMConstants.QUARTZ_ACTION_STATUS_RUNNING%>");
                                }
                            } else {
                                alert("لم يتم البدء");
                            }
                        }
                    });
                } else {
                    alert("من فضلك أدخل الفترة");
                    $("#interval" + id).focus();
                }
                loading('none');
            }
        </script>
        <style type="text/css">
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
            }// loading progress bar
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
        </style>
    </head>
    <body>
        <form NAME="CLIENTS_RULES_FORM" METHOD="POST">
            <FIELDSET class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <div id="loading" class="container" style="margin-right: auto; margin-bottom: auto; margin-top: auto; margin-left: auto; display: none; position: fixed; top: 400px; z-index: 1000;">
                    <div class="contentBar">
                        <div id="block_1" class="barlittle"></div>
                        <div id="block_2" class="barlittle"></div>
                        <div id="block_3" class="barlittle"></div>
                        <div id="block_4" class="barlittle"></div>
                        <div id="block_5" class="barlittle"></div>
                    </div>
                </div>
                <div style="width:90%; margin-right: auto; margin-left: auto;">
                    <table class="display" id="quartzClosedClientComplaint" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th style="font-size: 16px; font-weight: bold" rowspan="2" width="35%"><b><%=departmentTitle%></b></th>
                                <th style="font-size: 16px; font-weight: bold" rowspan="2" width="35%"><b><%=intervalTitle%></b></th>
                                <TH STYLE="font-size: 16px; font-weight: bold" colspan="2">
                                    <img src="images/icons/operation.png" width="24" height="24"/>
                                    <br />
                                </TH>  
                            </tr>
                            <tr>
                                <TH STYLE="font-size: 16px; font-weight: bold" width="10%">أضافة / تحديث</TH>
                                <TH STYLE="font-size: 16px; font-weight: bold" width="10%">تشغيل / ايقاف</TH>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Integer interval;
                                String quartzId, running, nextRunning, runningIcon, saveIcon;
                                int index = 0;
                                for (WebBusinessObject department : departments) {
                                    interval = null;
                                    try {
                                        interval = Integer.parseInt(department.getAttribute("interval").toString());
                                    } catch (Exception ex) {
                                    }
                                    quartzId = (String) department.getAttribute("id");
                                    running = (String) department.getAttribute("running");
                                    saveIcon = "edit";
                                    if (interval == null) {
                                        interval = 24;
                                        quartzId = "-1";
                                        saveIcon = "done";
                                        running = CRMConstants.QUARTZ_ACTION_STATUS_NOT_RUNNING;
                                    }
                                    if (quartzId == null) {
                                        quartzId = "-1";
                                        saveIcon = "done";
                                    }
                                    if (interval == null) {
                                        interval = 24;
                                    }
                                    nextRunning = CRMConstants.QUARTZ_ACTION_STATUS_NOT_RUNNING;
                                    if (running == null || CRMConstants.QUARTZ_ACTION_STATUS_NOT_RUNNING.equalsIgnoreCase(running)) {
                                        nextRunning = CRMConstants.QUARTZ_ACTION_STATUS_RUNNING;
                                    }

                                    if (CRMConstants.QUARTZ_ACTION_STATUS_RUNNING.equalsIgnoreCase(nextRunning)) {
                                        runningIcon = "play";
                                    } else {
                                        runningIcon = "stop";
                                    }
                            %>
                            <tr>
                                <td>
                                    <b><%=department.getAttribute("departmentName")%></b>&ensp;
                                    <b><%=ProjectMgr.getInstance().getProjectCode((String) department.getAttribute("departmentId"))%></b>
                                </td>
                                <td>
                                    <input type="text" id="interval<%=index%>" name="interval" value="<%=interval%>" style="font-size: 13px; font-weight: bold; text-align: center" />
                                </td>
                                <td>
                                    <input type="hidden" id="quartzId<%=index%>" name="quartzId" value="<%=quartzId%>" />
                                    <input type="hidden" id="departmentId<%=index%>" name="departmentId" value="<%=department.getAttribute("departmentId")%>" />
                                    <a href="JavaScript: saveScheduler('<%=index%>');">
                                        <img id="saveIcon<%=index%>" style="margin: 3px" src="images/icons/<%=saveIcon%>.png" width="30" height="30"/>
                                    </a>
                                </td>
                                <td>
                                    <input type="hidden" id="running<%=index%>" name="running" value="<%=nextRunning%>" />
                                    <a href="JavaScript: startScheduler('<%=index%>');">
                                        <img id="imgStatus<%=index%>" style="margin: 3px" src="images/icons/<%=runningIcon%>.png" width="30" height="30"/>
                                    </a>
                                </td>
                            </tr>
                            <% index++;
                                }%>
                        </tbody>
                    </table>
                </div>
                <br/>
            </fieldset>
        </form>
    </body>
</html>