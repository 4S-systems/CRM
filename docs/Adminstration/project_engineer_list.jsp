<%@page import="java.text.DecimalFormat"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <%
        int flipper = 0;
        String className;
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] projectAttributes = {"projectName"};
        String[] projectListTitles = new String[7];
        int s = projectAttributes.length;
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        boolean isSuperUser = securityUser.isSuperUser();
        String attName, attValue, maxInstalments, edite, projectAccId, mPrice, garageNum, lockerNum;
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        ArrayList<WebBusinessObject> neightborhoodList = (ArrayList<WebBusinessObject>) request.getAttribute("neightborhoodList");
        Map<String, String> projectPrices = (Map<String, String>) request.getAttribute("projectPrices");
        DecimalFormat df = new DecimalFormat("##,###.##");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign;
        String dir = null;
        String style = null;
        String sProjectsList, viewEngineers, projectName,chooseProject, active, inactive, successMsg, faildMsg, status, choosePaySys,
                confirmMsg, prjDeleted, prjNotDeleted, editHistory, alreadyGeneratedMsg, garageGeneratedMsg, failToGenerateMsg, total,
                update, successProjectNameMsg, failProjectNameMsg;
        if (stat.equals("En")) {
            chooseProject=" Choose Region for Projects";
            align = "center";
            xAlign = "right";
            dir = "LTR";
            style = "text-align:left";
            projectListTitles[0] = "Project Name";
            projectListTitles[1] = "Units Total Price";
            projectListTitles[2] = "Instalments Number";
            projectListTitles[3] = " Meter Price ";
            projectListTitles[4] = " Garage Number ";
            projectListTitles[5] = " Lockers Number ";
            projectListTitles[6] = "View";
            status = "Status";
            sProjectsList = "Projects List";
            viewEngineers = "View Engineers";
            edite = "Edite";
            active = "Active";
            inactive = "Inactive";
            successMsg = "Saved Successfully";
            faildMsg = "Faild to save";
            choosePaySys = " Choose Payment System for Projects ";
            confirmMsg = "This Project Has Units Do You Want To Delete This Units ?";
            prjDeleted ="Project Has Been Deleted";
            prjNotDeleted = "Project Not Deleted";
            editHistory = "Edit History";
            alreadyGeneratedMsg = "Already generated before, cannot generate it again";
            garageGeneratedMsg = "Garages generated successfully";
            failToGenerateMsg = "Fail to generate garages";
            total = "Total";
            update="Update";
            successProjectNameMsg = "Successfully Update Project Name";
            failProjectNameMsg = "Fail to Update Project Name, May be there is appartments under this project.";
        } else {
            edite = "تعديل";
            align = "center";
            xAlign = "left";
            dir = "RTL";
            style = "text-align:Right";
            projectListTitles[0] = "اسم المشروع";
            projectListTitles[1] = "إجمالي سعر الوحدات";
            projectListTitles[2] = "عدد الوحدات";
            projectListTitles[3] = " سعر المتر ";
            projectListTitles[4] = " عدد الجراچات ";
            projectListTitles[5] = " عدد وحدات التخزين ";
            projectListTitles[6] = "عرض";
            status = "الحالة";
            sProjectsList = "عرض المشاريع";
            viewEngineers = "عرض المهندسين";
            chooseProject=" إختر منطقة للمشاريع ";
            active = "Active";
            inactive = "Inactive";
            successMsg = "\u062a\u0645 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0628\u0646\u062c\u0627\u062d";
            faildMsg = "لم يتم التسجيل";
            choosePaySys = " إضافة خطة دفع للمشاريع ";
            confirmMsg = "يوجد وحدات لهذا المشروع هل تريد حذف الوحدات ؟";
            prjDeleted  ="تم حذف المشروع";
            prjNotDeleted = "لم يتم الحذف";
            editHistory = "تاريخ التعديل";
            alreadyGeneratedMsg = "تم توليد الجراجات مسبقا, لا يمكن التوليد مجددا";
            garageGeneratedMsg = "تم توليد الجراجات بنجاح";
            failToGenerateMsg = "خطأ لم يتم توليد الجراجات";
            total = "إجمالي";
            update="تحديث";
            successProjectNameMsg = "تم تحديث اسم المشروع بنجاح";
            failProjectNameMsg = "لم يتم التحديث, ربما يوجد وحدات تحت هذا المشروع";
        }

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

        ArrayList<WebBusinessObject> sPayPlanLst = (ArrayList<WebBusinessObject>) request.getAttribute("sPayPlanLst");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
    %>

    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <title>Project List</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script  TYPE="text/javascript">
            var divID;
            function closePopup(formID) {
                $("#" + formID).hide();
                $('#overlay').hide();
            }

            function closeOverlay() {
                $("#" + divID).hide();
                $("#overlay").hide();
            }

            function showProjectUsers(projectID) {
                divID = "project_engineers";
                $('#overlay').show();
                var url = "<%=context%>/ProjectServlet?op=manageProjectEngineers&projectID=" + projectID;
                jQuery('#project_engineers').load(url);
                $('#project_engineers').css("display", "block");
                $('#project_engineers').dialog();
            }

            function editProjectAccount(projectAccId, projectName, projectID) {
                divID = "project_engineers";
                $('#overlay').show();
                var url = "<%=context%>/ProjectServlet?op=editeProjectAccount&projectAccId=" + projectAccId + "&projectID=" + projectID + "&projectName=" + encodeURI(projectName);
                jQuery('#project_engineers').load(url);
                $('#project_engineers').css("display", "block");
                $('#project_engineers').dialog();
            }

            function addEntity(projectAccId, projectName) {
                divID = "project_engineers";
                $('#overlay').show();
                var url = "<%=context%>/ProjectServlet?op=editeProjectAccount&projectAccId=" + projectAccId + "&projectName=" + encodeURI(projectName) + "&addEntity=yes";
                jQuery('#project_engineers').load(url);
                $('#project_engineers').css("display", "block");
                $('#project_engineers').dialog();
            }

            function showEditHistory(projectID, projectName) {
                divID = "project_engineers";
                $('#overlay').show();
                var url = "<%=context%>/ProjectServlet?op=getPriceEditHistory&projectID=" + projectID + "&projectName=" + encodeURI(projectName);
                jQuery('#project_engineers').load(url);
                $('#project_engineers').css("display", "block");
                $('#project_engineers').dialog();
            }

            function showEditProjectName(projectID, projectName){
                divID = "edit_project_name";
                $('#overlay').show();
                $('#projectID').val(projectID);
                $('#newProjectName').val(projectName);
                $('#edit_project_name').css("display", "block");
                $('#edit_project_name').dialog();
            }

            function editProjectName() {
                var projectID = $("#projectID").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=editProjectNameByAjax",
                    data: {
                        projectID: projectID,
                        projectName: $("#newProjectName").val()
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok'){
                            alert('<%=successProjectNameMsg%>');
                            location.reload();
                        } else if (info.status === 'fail') {
                            alert('<%=failProjectNameMsg%>');
                        }
                    }
                });
            }

            $(document).ready(function(){
                $('#projects').DataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });

            function changeProjectStatus(projectID, newStatus) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=changeProjectStatusByAjax",
                    data: {
                        projectID: projectID,
                        newStatus: newStatus
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'Ok') {
                            alert("<%=successMsg%>");
                            if(newStatus === '66') {
                                $("#active" + projectID).show();
                                $("#activeBtn" + projectID).hide();
                                $("#inactive" + projectID).hide();
                                $("#inactiveBtn" + projectID).show();
                            } else {
                                $("#active" + projectID).hide();
                                $("#activeBtn" + projectID).show();
                                $("#inactive" + projectID).show();
                                $("#inactiveBtn" + projectID).hide();
                            }
                        } else if (info.status === 'faild') {
                            alert("<%=faildMsg%>");
                        }
                    }
                });
            }

            function selectAll(obj) {
                $("input[name='prjID']").prop('checked', $(obj).is(':checked'));
            }

            function isChecked() {
                var isChecked = false;
                $("input[name='prjID']").each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                    }
                });

                return isChecked;
            }

            function addPrj() {
                if (!isChecked()) {
                    alert('<fmt:message key="selectPrjMsg" />');
                    return false;
                } else {
                    document.prjForm.action = "<%=context%>/ProjectServlet?op=addProjectNBPaySys&save=trueRegion&page=prjEngLst";
                    document.prjForm.submit();
                }
            }

            function addPaymentSys() {
                if (!isChecked()) {
                    alert('<fmt:message key="selectPrjMsg" />');
                    return false;
                } else {
                    document.prjForm.action = "<%=context%>/ProjectServlet?op=addProjectNBPaySys&save=truePaySys&page=prjEngLst";
                    document.prjForm.submit();
                }
            }

            function exportToExcel() {
                var url = "<%=context%>/ProjectServlet?op=exportProjectsToExcel";
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }

            function checkUnitsAvailability(projectAccId){
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=checkUnitsAvailability",
                    data: {
                        projectAccId: projectAccId,
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'yes') {
                            var r = confirm("<%=confirmMsg%>");
                            if (r == true) {
                                deleteProject(projectAccId);
                            }
                        } else if (info.status === 'no') {
                            deleteProject(projectAccId);
                        }
                    }
                });
            }

            function deleteProject(projectAccId){
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=deleteProject",
                    data: {
                        projectAccId: projectAccId
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("<%=prjDeleted%>");
                            location.reload();
                        } else if (info.status === 'no') {
                            alert("<%=prjNotDeleted%>");
                        }
                    }
                });
            }

            function generateGarages(projectID, garageNo){
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=generateGaragesAjax",
                    data: {
                        projectID: projectID,
                        garageNo: garageNo
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'alreadyGenerated') {
                            alert("<%=alreadyGeneratedMsg%>");
                        } else if (info.status === 'ok') {
                            alert("<%=garageGeneratedMsg%>");
                        } else if (info.status === 'no') {
                            alert("<%=failToGenerateMsg%>");
                        }
                    }
                });
            }
            function openPopup(obj){
                var url =obj ;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=800,height=400");
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

            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }

            .smallDialog {
                width: 320px;
                display: none;
                position: fixed;
                z-index: 1100;
                left: 38%;
            }

            .mediumDialog {
                width: 90%;
                display: none;
                position: fixed;
                z-index: 1100;
                left: 5%;
            }

            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 1000;
                top: 0px;
                left: 0px;
                position: fixed;
            }

            .img:hover{
                cursor: pointer ;
            }

            #container{
                font-family:Arial, Helvetica, sans-serif;
                position:absolute;
                top:0;
                left:0;
                background: #005778;
                width:100%;
                height:100%;
            }

            .hot-container p { 
                margin-top: 10px;
            }

            a { 
                text-decoration: none; 
                margin: 0 10px;
            }

            .hot-container {
                min-height: 100px;
                margin-top: 100px;
                width: 100%;
                text-align: center;
            }

            a.btn {
                display: inline-block;
                color: #666;
                background-color: #eee;
                text-transform: uppercase;
                letter-spacing: 2px;
                font-size: 12px;
                padding: 10px 30px;
                border-radius: 5px;
                -moz-border-radius: 5px;
                -webkit-border-radius: 5px;
                border: 1px solid rgba(0,0,0,0.3);
                border-bottom-width: 3px;
            }

            a.btn:hover {
                background-color: #e3e3e3;
                border-color: rgba(0,0,0,0.5);
            }

            a.btn:active {
                background-color: #CCC;
                border-color: rgba(0,0,0,0.9);
            }
        </style>
    </head>

    <body>
        <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">
        </div>

        <div id="project_engineers" class="mediumDialog">
        </div>

        <div align="left" style="color:blue;">
        </div>
        <div id="edit_project_name" class="smallDialog" align="center" style="padding: auto; margin: auto;">
            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_project_name')"/>
            </div>
            <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                <table border="0px" style="width: 100%;" class="table">
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                            <%=projectListTitles[0]%> 
                        </td>
                        <td style="width: 70%; text-align: right;" colspan="3">
                            <input type="text" style="width: 160px;" name="newProjectName" ID="newProjectName" size="" value="" onkeyup="checkCampaignName(this)" onmousedown="checkCampaignName(this)"/>
                            <input type="hidden" id="projectID" name="projectID" />
                        </td>
                    </tr>
                </table>
                <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                    <input type="button" value="<%=update%>" onclick="editProjectName()" id="editProjectName" class="login-submit"/>
                </div>                           
            </div>
        </div>

        <fieldset align=center class="set" style="width: 95%;">
            <legend align="center">
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            <%=sProjectsList%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >

            <br/>

            <form name="prjForm" id="prjForm" method="POST">
                <!--DIV style="padding-left: 20%; padding-right: 20%; padding-bottom: 10%;">
                    <table style="float: right; width: 25%;" align="<%=align%>" cellpadding="0" cellspacing="0" BORDER="0">
                        <Tr>
                            <TD>
                <%=choosePaySys%>
            </TD>
        </Tr>
        
        <tr>
            <td class='td' style="text-align: center;">
                <select id="paySysID" name="paySysID" class="chosen-select-campaign" style="font-size: 14px;font-weight: bold; width: 300px;" >
                    <option > Choose a Payment System </option>
                <sw:WBOOptionList wboList='<%=sPayPlanLst%>' displayAttribute="planTitle" valueAttribute="ID" />
            </select>
            <a href="#" class="btn" onclick="addPaymentSys();"> Attach Projects </a>
        </td>
    </tr>
</table> 
            
<table style="float: left; width: 25%;" align="<%=align%>" cellpadding="0" cellspacing="0" BORDER="0">
    <Tr>
        <TD>
                <%=chooseProject%>
            </TD>
        </Tr>
        
        <tr>
            <td class='td'  style="text-align: center;">
                <select id="areaID" name="areaID" class="chosen-select-campaign" style="font-size: 14px;font-weight: bold; width: 300px;" >
                    <option > Choose a Region </option>
                <sw:WBOOptionList wboList='<%=neightborhoodList%>' displayAttribute="projectName" valueAttribute="projectID" />
            </select>
            <a href="#" class="btn" onclick="addPrj();"> Attach Projects </a>
        </td>
    </tr>
</table> 
</DIV-->

                <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <button type="button" style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #000;font-size:15px;font-weight:bold; width: 150px; height: 30px; vertical-align: top;"
                            onclick="JavaScript: exportToExcel();" title="Export to Excel">Excel &nbsp; &nbsp;<img height="15" src="images/icons/excel.png" />
                    </button>
                </DIV>                

                <div style="width: 90%; margin-left:auto; margin-right:auto;" >
                    <table id="projects" align="<%=align%>" width="100%" dir="<%=dir%>" cellpadding="0" cellspacing="0" >
                        <thead>
                            <tr>
                                <!--TH>
                                    <input type="checkbox" name="allPrj" id="allPrj" onclick="selectAll(this);"/>
                                </TH-->

                                <%
                                    String font = new String("12");
                                    for (int i = 0; i < projectListTitles.length; i++) {
                                %>
                                <th nowrap class="silver_header" style="border-width:0; font-size:<%=font%>;" nowrap>
                                    <b>
                                        <%=projectListTitles[i]%>
                                    </b>
                                </th>
                                <%  } %>

                                <th nowrap class="silver_header" style="border-width:0; font-size:<%=font%>;" nowrap>
                                    <b>
                                        <%=edite%>
                                    </b>
                                </th>
                                <th nowrap class="silver_header" style="border-width:0; font-size:<%=font%>;" nowrap>
                                    <b>
                                        <%=editHistory%>
                                    </b>
                                </th>

                                <th nowrap class="silver_header" style="border-width:0; font-size:<%=font%>;" nowrap>
                                    <b>
                                        <%=status%>
                                    </b>
                                </th>

                                <%
                                    if (userPrevList.contains("CHANGE_PROJECT_STATUS")) {
                                %>
                                <th nowrap class="silver_header" style="border-width:0; font-size:<%=font%>;" nowrap>
                                    &nbsp;
                                </th>
                                <%
                                    }
                                %>

                                <th nowrap class="silver_header" style="border-width:0; font-size:<%=font%>;" nowrap>
                                    &nbsp;
                                </th>

                                <th nowrap class="silver_header" style="display: <%=userPrevList.contains("DELETE_PROJECT") ? "" : "none"%> ;border-width:0; font-size:<%=font%>;" nowrap >
                                    &nbsp;
                                </th>

                                <th nowrap class="silver_header" style="border-width:0; font-size:<%=font%>;" nowrap >
                                    &nbsp;
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <%
                                String statusCode;
                                for (WebBusinessObject wbo : projectsList) {
                                    flipper++;
                                    if ((flipper % 2) == 1) {
                                        className = "silver_odd_main";
                                    } else {
                                        className = "silver_even_main";
                                    }

                                    projectAccId = ((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("projectAccId") + "";
                                    projectName = wbo.getAttribute("projectName") + "";
                            %>
                            <tr>
                                <%
                                    statusCode = (String) wbo.getAttribute("integratedId");
                                    for (int i = 0; i < s; i++) {
                                        attName = projectAttributes[i];
                                        attValue = (String) wbo.getAttribute(attName);
                                                maxInstalments = ((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("maxInstalments") != null ? (String)((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("maxInstalments") : "0";
                                                mPrice = ((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("meterPrice") != null ? (String)((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("meterPrice") : "0";
                                                garageNum = ((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("garageNumber") != null ? (String)((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("garageNumber") : "0";;
                                                lockerNum = ((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("lockerNumber") != null ? (String)((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("lockerNumber") : "0";
                                %>
                                <!--td>
                                    <div >
                                        <input type="checkbox" name="prjID" value="<%=wbo.getAttribute("projectID")%>"/>
                                    </div>
                                </td-->

                                <td style="<%=style%>"  nowrap  class="<%=className%>" >
                                    <div >
                                        <b>
                                            <a target="_blanck" href="<%=context%>/SearchServlet?op=getUnitsForSpecificProject&prjID=<%=wbo.getAttribute("projectID")%>" style="cursor: pointer;"> <%=attValue%> </a>
                                        </b>
                                        <img src="images/edit.png" width="50" align="center" style="cursor: hand;" onclick="JavaScript: showEditProjectName('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("projectName")%>');"/>
                                    </div>
                                </td>

                                <td style="<%=style%>" nowrap  class="<%=className%>" >
                                    <div>
                                        <b id="maxInstamnts<%=wbo.getAttribute("projectID")%>">
                                             <% 
                                                 String priceS=projectPrices.get((String) wbo.getAttribute("projectID"))==null?"0.0d":projectPrices.get((String) wbo.getAttribute("projectID")) ;
                                        Double v1=Double.valueOf(priceS) ;
                                        long v21=(long) Math.ceil(v1);  
                                     %>
                                            <%=projectPrices.containsKey((String) wbo.getAttribute("projectID")) ? df.format(v21): "0"%>
                                        </b>
                                    </div>
                                </td>

                                <td style="<%=style%>" nowrap  class="<%=className%>" >
                                    <div>
                                        <b id="maxInstamnts<%=wbo.getAttribute("projectID")%>">
                                            <%=maxInstalments%>
                                        </b>
                                    </div>
                                </td>

                                <td style="<%=style%>" nowrap  class="<%=className%>" >
                                    <div>
                                        <b id="mPrice<%=wbo.getAttribute("projectID")%>">
                                            <%=mPrice%>
                                        </b>
                                    </div>
                                </td>

                                <td style="<%=style%>" nowrap  class="<%=className%>" >
                                    <div>
                                        <b id="garageNum<%=wbo.getAttribute("projectID")%>">
                                            <%=garageNum%> 
                                        </b>
                                        <%
                                            if (!"0".equals(garageNum)) {
                                        %>
                                        <a href="JavaScript: generateGarages('<%=wbo.getAttribute("projectID")%>', '<%=garageNum%>');">
                                            <img src="images/garage-icon.png" style="width: 30px; vertical-align: middle; float: <%=xAlign%>;"
                                                 title="Generate Garages"/>
                                        </a>
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>

                                <td style="<%=style%>" nowrap  class="<%=className%>" >
                                    <div>
                                        <b id="lockerNum<%=wbo.getAttribute("projectID")%>">
                                            <%=lockerNum%>
                                        </b>
                                    </div>
                                </td>
                                            <% } %>
                                <td style="<%=style%>"   nowrap  class="<%=className%>" >
                                    <div >
                                        <b onclick="JavaScript: showProjectUsers('<%=wbo.getAttribute("projectID")%>');" style="cursor: pointer;"> <%=viewEngineers%> </b>
                                    </div>
                                </td>

                                <td style="<%=style%>" bgcolor="#DDDD00"  nowrap  class="<%=className%>" >
                                    <div >
                                        <b onclick="JavaScript: editProjectAccount('<%=projectAccId%>', '<%=projectName%>', '<%=wbo.getAttribute("projectID")%>');" style="cursor: pointer;"> <%=edite%> </b>
                                    </div>
                                </td>
                                <td style="<%=style%>" bgcolor="#DDDD00"  nowrap  class="<%=className%>" >
                                    <div >
                                        <b onclick="JavaScript: showEditHistory('<%=wbo.getAttribute("projectID")%>', '<%=projectName%>');" style="cursor: pointer;"> <%=editHistory%> </b>
                                    </div>
                                </td>

                                <td>
                                    <div id="links">
                                        <b id="active<%=wbo.getAttribute("projectID")%>" style="color: green; display: <%=statusCode != null && statusCode.equals("66") ? "" : "none"%>"><%=active%></b>
                                        <b id="inactive<%=wbo.getAttribute("projectID")%>" style="color: red; display: <%=statusCode != null && statusCode.equals("66") ? "none" : ""%>"><%=inactive%></b>
                                    </div>
                                </td>

                                <%
                                    if (userPrevList.contains("CHANGE_PROJECT_STATUS")) {
                                %>
                                <td>
                                    <div id="links">
                                        <input type="button" id="inactiveBtn<%=wbo.getAttribute("projectID")%>" style="display: <%=statusCode != null && statusCode.equals("66") ? "" : "none"%>" value="<%=inactive%>"
                                               onclick="JavaScript: changeProjectStatus('<%=wbo.getAttribute("projectID")%>', '67')"/>
                                        <input type="button" id="activeBtn<%=wbo.getAttribute("projectID")%>" style="display: <%=statusCode != null && statusCode.equals("66") ? "none" : ""%>" value="<%=active%>"
                                               onclick="JavaScript: changeProjectStatus('<%=wbo.getAttribute("projectID")%>', '66')"/>
                                    </div>
                                </td>
                                <%
                                    }
                                %>

                                <td>
                                    <div>
                                        <input type="button" value="Add Outbuilding" style="cursor: pointer;" onclick="JavaScript: addEntity('<%=projectAccId%>', '<%=projectName%>');"/>
                                    </div>
                                </td>

                                <td style="display: <%=userPrevList.contains("DELETE_PROJECT") ? "" : "none"%>;">
                                    <div>
                                        <input  type="button" value="Delete" style="cursor: pointer;" onclick="JavaScript: checkUnitsAvailability('<%=wbo.getAttribute("projectID")%>');"/>
                                    </div>
                                </td>

                                <td nowrap style="padding-left: 5px; padding-right: 5px;">
                                            <img onclick="JavaScript: openPopup('<%=context%>'+'/UnitDocWriterServlet?op=attach&projId='+'<%=wbo.getAttribute("projectID")%>'+'&type=tree');"
                                         width="19px" height="19px" src="images/icons/Attach.png" style="margin: -4px 0; cursor: pointer;" title="Attach File"/>
                                    &nbsp;
                                            <img onclick="JavaScript: openPopup('<%=context%>'+'/UnitDocReaderServlet?op=ListAttachedDocs&projId='+'<%=wbo.getAttribute("projectID")%>')"
                                         width="19px" height="19px" src="images/unit_doc.png" style="margin: -4px 0; cursor: pointer;" title="View Files"/>
                                    &nbsp;
                                            <img onclick="JavaScript: openPopup('<%=context%>'+'/UnitDocReaderServlet?op=unitDocGallery&unitID='+'<%=wbo.getAttribute("projectID")%>');"
                                         width="25px" height="25px" src="images/gallery.png" style="margin: -4px 0; cursor: pointer;" title="Gallery"/>
                                    &nbsp;
                                            <img onclick="JavaScript: openPopup('<%=context%>/ProjectServlet?op=insertProjectMap&single=image&projectId='+'<%=wbo.getAttribute("projectID")%>');"
                                         width="25px" height="25px" src="images/position.png" style="margin: -4px 0; cursor: pointer;" title="Update Location"/>
                                </td>

                            </tr>
                            <%
                                }
                            %> 
                        </tbody>
                        <tfoot>
                            <tr>
                                <th style="font-size: 16px; font-weight: bolder;">
                                    <%=total%>
                                </th>
                                <th style="font-size: 16px; font-weight: bolder;">
                                     <% 
                                        Double v=Double.valueOf((String) request.getAttribute("totalSum")); 
                                        long v2=(long) Math.ceil(v);  
                                     %>
                                    <%=request.getAttribute("totalSum") != null ? df.format(v2): "0"%>
                                </th>
                                <th colspan="11">
                                    &nbsp;
                                </th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </FORM>

            <br><br>
        </fieldset>

        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>