<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        String stat = (String) request.getSession().getAttribute("currentMode");
        WebBusinessObject stageWbo = (WebBusinessObject) request.getAttribute("stageWbo");
        WebBusinessObject unitWbo = (WebBusinessObject) request.getAttribute("unitWbo");
        WebBusinessObject projectWbo = (WebBusinessObject) request.getAttribute("projectWbo");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String align = null;
        String dir = null;
        String style = null;
        String saveButton;
        String fStatus;
        String sStatus, unitNo, title;
        String mainProject, estimatedFinishDate, estimatedCost, back;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align: left";
            saveButton = "Save ";
            sStatus = "Stage Updates Successfully";
            fStatus = "Fail To Update Stage";
            unitNo = "Stage Code";
            mainProject = "Project";
            estimatedFinishDate = "Estimated Finish Date";
            estimatedCost = "Estimated Cost";
            title = "Update Stage";
            back = "Back";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align: right";
            saveButton = "تسجيل";
            fStatus = "لم يتم تعديل المرحلة";
            sStatus = "تم تعديل المرحلة بنجاح";
            unitNo = "كود المرحلة";
            mainProject = "المشروع";
            estimatedFinishDate = "تاريخ الأنتهاء المتوقع";
            estimatedCost = "التكلفة المتوقعة";
            title = "تعديل مرحلة هندسية";
            back = "عــودة";
        }
    %>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css" />
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#estimatedFinishDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            function saveApartment() {
                var estimatedFinishDate = $("#estimatedFinishDate").val();
                var estimatedCost = $("#estimatedCost").val();
                if (estimatedFinishDate.length === 0) {
                    alert("يجب ادخال تاريخ الأنتهاء المتوقع");
                    $("#estimatedFinishDate").focus();
                } else if (estimatedCost.length === 0 || estimatedCost.includes("e") || estimatedCost.includes("-")) {
                    alert("يجب ادخال التكلفة المتوقعة بشكل صحيح");
                    $("#estimatedCost").focus();
                } else {
                    $.ajax({
                        url: "<%=context%>/StageServlet?op=updateEngUnitAsAjax",
                        data: {
                            stageID: '<%=unitWbo.getAttribute("projectID")%>',
                            estimatedFinishDate: estimatedFinishDate,
                            estimatedCost: estimatedCost
                        },
                        type: 'POST',
                        dataType: 'Text',
                        success: function (data) {
                            if (data === 'ok') {
                                alert("<%=sStatus%>");
                                location.href = "<%=context%>/ProjectServlet?op=getProjectsStages&projectID=" + "<%=projectWbo != null ? projectWbo.getAttribute("projectID") : ""%>";
                            } else if (data === 'fail') {
                                alert("<%=fStatus%>");
                            }
                        }
                    });
                }
            }
            function back() {
                location.href = "<%=context%>/ProjectServlet?op=getProjectsStages&projectID=" + "<%=projectWbo != null ? projectWbo.getAttribute("projectID") : ""%>";
            }
        </script>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
        <style>
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
    </head>
    <body>
        <form NAME="UNIT_FORM" id="UNIT_FORM" METHOD="POST">
            <input type="hidden" dir="<%=dir%>" name="isMngmntStn" ID="isMngmntStn" size="3" value="isMngmntStn" maxlength="3">
            <div align="left" STYLE="color:blue; margin-left: 7.5%">
                <button type="button" onclick="JavaScript: back();" class="button"><%=back%></button>
                <button type="button" onclick="JavaScript: saveApartment();" class="button"><%=saveButton%><img height="15" src="images/save.gif"/></button>
            </div>
            <br />
            <center>
                <fieldset class="set backstyle" style="width: 65%; border-color: #006699" >
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td width="100%" class="titlebar">
                                <font color="#005599" size="4"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table id="unitsTable" width="40%" CELLPADDING="0" CELLSPACING="8" ALIGN="center" DIR="<%=dir%>">
                        <tr>
                            <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=mainProject%></b></p>
                            </td>
                            <td class="td" style="text-align: <%=align%>;">
                                <%=projectWbo != null ? projectWbo.getAttribute("projectName") : ""%>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=unitNo%></b></p>
                            </td>
                            <td class="td" style="text-align: <%=align%>;">
                                <%=unitWbo != null ? unitWbo.getAttribute("projectName") : ""%>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=estimatedFinishDate%></b></p>
                            </td>
                            <td class="td" style="text-align: <%=align%>;">
                                <input type="text" style="width: 90%; text-align: center;" dir="<%=dir%>"
                                       name="estimatedFinishDate" id="estimatedFinishDate" readonly
                                       value="<%=stageWbo != null && stageWbo.getAttribute("estimatedFinishDate") != null ? ((String) stageWbo.getAttribute("estimatedFinishDate")).substring(0, 10).replaceAll("-", "/") : ""%>"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=estimatedCost%></b></p>
                            </td>
                            <td class="td" style="text-align: <%=align%>;">
                                <input type="number" style="width: 100px; text-align: center;" dir="<%=dir%>" name="estimatedCost"
                                       id="estimatedCost" min="1" value="<%=stageWbo != null ? stageWbo.getAttribute("estimatedCost") : "1"%>"/>
                            </td>
                        </tr>
                    </table>
                    <br />
                </fieldset>
            </center>
        </form>
    </body>
</html>