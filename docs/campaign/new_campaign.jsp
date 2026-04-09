<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<HTML>
    
    <%
        String status = (String) request.getAttribute("status");
        String dataSaved = "";
        if (status != null) {
            dataSaved = status;
        }
        WebBusinessObject campaignWbo = (WebBusinessObject) request.getAttribute("campaignWbo");
        ArrayList<WebBusinessObject> toolsList = (ArrayList<WebBusinessObject>) request.getAttribute("toolsList");
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        
        String mainPrjID = (String)request.getAttribute("mainPrjID");
        
        ArrayList<WebBusinessObject> campaignProjectsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignProjectsList");
        String directionValue = "";
        if(campaignWbo != null && campaignWbo.getAttribute("direction") != null) {
            directionValue = (String) campaignWbo.getAttribute("direction");
        }
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String campaignTitle, fromDate, toDate, approximateCost, objective, toolID, projects, subCampaignCode;
        String direction, forword, backword,both;
        String title;
        String cancelButtonLabel;
        String saveButtonLabel;
        String fStatus;
        String sStatus;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            campaignTitle = "Campaign Name";
            subCampaignCode = "Sub Campaign Code";
            title = "New Campaign";
            cancelButtonLabel = "Cancel ";
            saveButtonLabel = "Save ";
            sStatus = "Campaign Saved Successfully";
            fStatus = "Fail To Save This Campaign";
            fromDate = "From Date";
            toDate = "To Date";
            approximateCost = "Approximate Cost";
            objective = "Calls Targeted";
            toolID = "Tool ID";
            projects = "Projects";
            direction = "Direction";
            forword = " Outbound ";
            backword = " Inbound ";
            both=" Recycle ";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            campaignTitle = "أسم الحملة";
            subCampaignCode = "كود الحملة الفرعية";
            title = "حملة جديدة";
            cancelButtonLabel = "إنهاء ";
            saveButtonLabel = "تسجيل ";
            fStatus = "لم يتم تسجيل هذه الحملة";
            sStatus = "تم تسجيل الحملة بنجاح";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            approximateCost = "التكلفة التقريبية";
            objective = "المكالمات المستهدفة";
            toolID = "أداة الحملة";
            projects = "المشروعات";
            direction = " نوع الحملة ";
            forword = " Outbound ";
            backword = " Inbound ";
            both=" Recycle ";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>new Campaign</TITLE>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <SCRIPT  TYPE="text/javascript">
            $(function () {
                $("#projects").select2();
            });
            
            var divID;
            function submitForm()
            {
                var fromDate = new Date($("#fromDate").val());
                var toDate = new Date($("#toDate").val());
                if (!validateData("req", this.CAMPAIGN_FORM.campaignTitle, "الرجاء أدخال عنوان الحملة")) {
                    this.CAMPAIGN_FORM.campaignTitle.focus();
                }
                else if (!validateData("req", this.CAMPAIGN_FORM.fromDate, "الرجاء أدخال تاريخ من")) {
                    this.CAMPAIGN_FORM.fromDate.focus();
                }
                else if (!validateData("req", this.CAMPAIGN_FORM.toDate, "الرجاء أدخال تاريخ إلي")) {
                    this.CAMPAIGN_FORM.toDate.focus();
                }
                else if (fromDate > toDate) {
                    alert("'من تاريخ' يجب أن يكون أكبر من 'ألي تاريخ'");
                }
                else if (!validateData("req", this.CAMPAIGN_FORM.cost, "الرجاء أدخال التكلفة التقريبية")) {
                    this.CAMPAIGN_FORM.cost.focus();
                }
                else if (!validateData("numericfloat", this.CAMPAIGN_FORM.cost, "الرجاء أدخال رقم صحيح للتكلفة")) {
                    this.CAMPAIGN_FORM.cost.focus();
                }
                else if (!validateData("numericfloat", this.CAMPAIGN_FORM.objective, "الرجاء أدخال رقم صحيح للمكالمات المستهدفة")) {
                    this.CAMPAIGN_FORM.objective.focus();
                }
                else if (!validateData("req", this.CAMPAIGN_FORM.projects, "الرجاء أختيار المشاريع")) {
                    this.CAMPAIGN_FORM.projects.focus();
                }
                else {
                    document.CAMPAIGN_FORM.action = "<%=context%>/CampaignServlet?op=saveCampaign";
                    document.CAMPAIGN_FORM.submit();
                }
            }


            function IsNumeric(sText)

            {
                var ValidChars = "0123456789.";
                var IsNumber = true;
                var Char;
                for (i = 0; i < sText.length && IsNumber == true; i++)
                {
                    Char = sText.charAt(i);
                    if (ValidChars.indexOf(Char) == -1)
                    {
                        var TCode = document.getElementById('code').value;
                        if (/[^a-zA-Z0-9]/.test(TCode)) {
                            alert('Input is not alphanumeric');
                            return false;
                        }
                    }
                    else {
                        alert("The code is either alphanumeric or alphabetical");
                        break;
                    }
                }
                return IsNumber;
            }

            function cancelForm()
            {
                document.CAMPAIGN_FORM.action = "main.jsp";
                document.CAMPAIGN_FORM.submit();
            }

            $(function() {
                $("#fromDate,#toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            $(function() {
                centerDiv("add_tool");
            });
            var minDateS = '<%=campaignWbo != null ? campaignWbo.getAttribute("fromDate") : ""%>';
            var maxDateS = '<%=campaignWbo != null ? campaignWbo.getAttribute("toDate") : ""%>';
            $(function() {
                $("#fromDateForm,#toDateForm").datepicker({
                    minDate: new Date(minDateS),
                    maxDate: new Date(maxDateS),
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function showToolPopup()
            {
                divID = "add_tool";
                $('#overlay').show();
                $('#add_tool').css("display", "block");
                rename();
                $('#add_tool').dialog(); //.bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
//                    speed: 400,
//                    transition: 'slideDown'});
            }
            function closePopup(formID) {
//                $("#" + formID).bPopup().close();
                $("#" + formID).hide();
                $('#overlay').hide();
            }
            var count = 0;
            function saveTool() {
                var campaignID = $("#campaignID").val();
                var campaignTitle = $("#campaignTitleForm").val();
                var mainCampaignTtile = $("#mainCampaignTtile").val();
                var toolName = $("#toolName").val();
                var toolID = $("#toolID").val();
                var fromDate = $("#fromDateForm").val();
                var toDate = $("#toDateForm").val();
                var cost = $("#costForm").val();
                var objective = 0;//$("#objectiveForm").val();
                var direction = '<%=directionValue%>';
//                var projects = [];
//                $('#projects :selected').each(function(i, selected) {
//                    projects[i] = $(selected).val();
//                });
                if (validateSubCampaign()) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/CampaignServlet?op=saveSubCampaignByAjax",
                        data: {
                            parentID: campaignID,
                            campaignTitle: mainCampaignTtile + " - " + toolName + " - " + campaignTitle,
                            toolID: toolID,
                            fromDate: fromDate,
                            toDate: toDate,
                            cost: cost,
                            objective: objective,
                            direction: direction
//                            ,
//                            projects: JSON.stringify(projects)
                        }
                        ,
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'Ok') {
                                alert("تم التسجيل بنجاح");
                                $("#add_tool").css("display", "none");
//                            $("#add_tool").bPopup().close();
                                $("#campaignTitleForm").val("");
                                $("#toolID").val("");
                                $("#fromDateForm").val("<%=campaignWbo != null ? campaignWbo.getAttribute("fromDate") : ""%>");
                                $("#toDateForm").val("<%=campaignWbo != null ? campaignWbo.getAttribute("toDate") : ""%>");
                                $("#costForm").val("");
//                                $("#objectiveForm").val("");
//                                $("#projects").val("");
                                count++;
                                $("#tblData").append($('<tr id="row' + count + '">')
                                        .append($('<td class="silver_odd_main">')
                                                .append("&nbsp;" + count)
                                                ).append($('<td class="silver_odd_main">')
                                        .append(mainCampaignTtile + " - " + toolName + " - " + campaignTitle)
                                        ).append($('<td class="silver_odd_main">')
                                        .append(info.toolName)
                                        ).append($('<td class="silver_odd_main">')
                                        .append(fromDate)
                                        ).append($('<td class="silver_odd_main">')
                                        .append(toDate)
                                        ).append($('<td class="silver_odd_main">')
                                        .append(cost
                                                + '<input type="hidden" value="' + info.id + '" id="campaignIDTable"/>')
                                        ).append($('<td class="silver_odd_main">')
                                        .append('<div class="remove" onclick="removeRow(\'' + info.id + '\',' + count + ')" title="حذف" style="margin-left:auto;margin-right:auto"/>')
                                        )
                                        );
                            } else if (info.status == 'faild') {
                                alert("لم يتم التسجيل");
                            }
                            $('#overlay').hide();

                        }
                    });
                }
            }
            function validateSubCampaign() {
                var fromDate = new Date($("#fromDateForm").val());
                var toDate = new Date($("#toDateForm").val());
                if (!validateData("req", document.getElementById("campaignTitleForm"), "الرجاء أدخال عنوان الحملة")) {
                    document.getElementById("campaignTitleForm").focus();
                    return false;
                }
                else if (!validateData("req", document.getElementById("fromDateForm"), "الرجاء أدخال تاريخ من")) {
                    document.getElementById("fromDateForm").focus();
                    return false;
                }
                else if (!validateData("req", document.getElementById("toDateForm"), "الرجاء أدخال تاريخ إلي")) {
                    document.getElementById("toDateForm").focus();
                    return false;
                }
                else if (fromDate > toDate) {
                    alert("'من تاريخ' يجب أن يكون أكبر من 'ألي تاريخ'");
                    return false;
                }
                else if (!validateData("req", document.getElementById("costForm"), "الرجاء أدخال التكلفة التقريبية")) {
                    document.getElementById("costForm").focus();
                    return false;
                }
                else if (!validateData("numericfloat", document.getElementById("costForm"), "الرجاء أدخال رقم صحيح للتكلفة")) {
                    document.getElementById("costForm").focus();
                    return false;
                }
//                else if (!validateData("numericfloat", document.getElementById("objectiveForm"), "الرجاء أدخال رقم صحيح للمكالمات المستهدفة")) {
//                    document.getElementById("objectiveForm").focus();
//                    return false;
//                }
                return true;
            }
            function removeRow(id, rowNo) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=deleteSubCampaignByAjax",
                    data: {
                        campaignID: id
                    }
                    ,
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("تم الحذف بنجاح");
                            for (i = rowNo + 1; i <= count; i++) {
                                var newRow = i - 1;
                                $("#row" + i + " td:first").html(newRow);
                                $("#row" + i + " td:last").html('<div class="remove" onclick="removeRow(\'' + $("#row" + i + " #campaignIDTable").val() + '\',' + newRow + ')" title="حذف" style="margin-left:auto;margin-right:auto"/>');
                                $("#row" + i).attr("id", "row" + (newRow));
                            }
                            count--;
                            $("#row" + rowNo).remove();
                        } else if (info.status == 'faild') {
                            alert("لم يتم الحذف");
                        }
                    }
                });

            }
            function closeOverlay() {
                $("#" + divID).hide();
                $("#overlay").hide();
            }
            function centerDiv(div) {
                $("#" + div).css("position", "fixed");
                $("#" + div).css("top", Math.max(0, (($(window).height() - $("#" + div).outerHeight()) / 2) +
                        $(window).scrollTop()) + "px");
                $("#" + div).css("left", Math.max(0, (($(window).width() - $("#" + div).outerWidth()) / 2) +
                        $(window).scrollLeft()) + "px");
            }
            
            function saveTools(){
                var toolsTitle =new Array(), i="0", campaignTitle = " ";
                $("#toolID option").each(function(){
                     toolsTitle[Number(i)] = $(this).text();
                     i = Number(i) + 1;
                    });
                    $("#campaignTitle").val(campaignTitle);
                    $("#campaignTitleForm").val(campaignTitle);
                    var campaignID = $("#campaignID").val();
                //    var toolID = $(this).val();
                    var fromDate = $("#fromDateForm").val();
                    var toDate = $("#toDateForm").val();
                    $("#costForm").val("1");
                    var cost = $("#costForm").val();
                    var objective = 0;
                    var direction = '<%=directionValue%>';
                     var mainCampaignTtile = $("#mainCampaignTtile").val();
                            
                    if (validateSubCampaign()) {
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/CampaignServlet?op=saveSubCampaignsByAjax",
                            data: {
                                parentID: campaignID,
                                toolsTitle: toolsTitle,
                                mainCampaignTtile: mainCampaignTtile,
                                fromDate: fromDate,
                                toDate: toDate,
                                cost: cost,
                                objective: objective,
                                direction: direction
                            } ,
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'Ok') {
                                alert("تم التسجيل بنجاح");
                                $("#add_tool").css("display", "none");
                            }
                        }
                        });
                    }
            }
            
            function rename(){
                $("#toolName").val($("#toolID option:selected").text());
            }
        </SCRIPT>
        <script src='ChangeLang.js' type='text/javascript'></script>
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
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
        </style>
    </HEAD>
    <BODY>
        <FORM NAME="CAMPAIGN_FORM" METHOD="POST">
            <input type="hidden" id="mainPrjID" name="mainPrjID" value="<%=mainPrjID%>">
            <DIV align="left" STYLE="color:blue;">
                <button onclick="JavaScript: cancelForm();" class="button"><%=cancelButtonLabel%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button onclick="JavaScript: submitForm();
                        return false;" class="button" style="display: <%=dataSaved.equalsIgnoreCase("Ok") ? "none" : ""%>"><%=saveButtonLabel%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

            </div>
            <div id="add_tool"  style="width: 95%; display: none; position: fixed; top: 30%; left: 20%; z-index: 1000;">
                <div style="clear: both;margin-left: 95%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup('add_tool')"/>
                </div>
                <div class="login" style="width: 95%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                    <table  border="0px"  style="width:100%;"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                <%=subCampaignCode%>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width: 30%;" ID="mainCampaignTtile" readonly="true" value="<%=dataSaved.equalsIgnoreCase("Ok") ? campaignWbo.getAttribute("campaignTitle") : ""%>"/> - 
                                <input type="TEXT" style="width: 30%;" ID="toolName" size="" maxlength="" readonly=""/>-
                                <input type="TEXT" style="width: 30%; " ID="campaignTitleForm" size="" maxlength=""/>
                            </td>
                        </tr>
                        <TR>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                <%=toolID%>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <select style="float: right;width: 190px; font-size: 14px;" id="toolID" name="toolID" onload="rename();" onchange="rename();">
                                    <%
                                        if (toolsList != null) {
                                            for (WebBusinessObject toolWbo : toolsList) {
                                    %>
                                    <option value="<%=toolWbo.getAttribute("id")%>"><%=toolWbo.getAttribute("arabicName")%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </td>
                        </TR>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 33%;" nowrap>
                                <%=fromDate%>
                            </td>
                            <td style="width: 33%; text-align: right;">
                                <input type="TEXT" style="width:190px" ID="fromDateForm" size="20" maxlength="100" readonly="true"
                                       value="<%=campaignWbo != null ? campaignWbo.getAttribute("fromDate") : ""%>"/>
                            </td>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 3%;" nowrap>
                                <%=toDate%>
                            </td>
                            <td style="width: 34%; text-align: right;">
                                <input type="TEXT" style="width:190px" ID="toDateForm" size="20" maxlength="100" readonly="true"
                                       value="<%=campaignWbo != null ? campaignWbo.getAttribute("toDate") : ""%>"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                <%=approximateCost%>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:100px" ID="costForm" size="33" maxlength="15"/>
                            </td>
                        </tr>
                        <!--tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                <!%=objective%>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:100px" ID="objectiveForm" size="33" value="" maxlength="15"/>
                            </td>
                        </tr-->
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value="حفظ" onclick="saveTool(this)" id="saveComm" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6"><%=title%>                
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("Ok")) {
                %>  
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="black"><%=sStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%
                } else {%>
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%}
                    }

                %>
                <br><br>
                <input type="hidden" id="campaignID" value="<%=campaignWbo != null ? campaignWbo.getAttribute("id") : ""%>"/>
                <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0" id="MainTable" width="60%">
                    <TR>
                        <TD STYLE="<%=style%>; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                            <LABEL>
                                <p><b><%=campaignTitle%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "none" : "block"%>" class='td' colspan="3">
                            <input type="TEXT" style="width:230px;"
                                   name="campaignTitle" ID="campaignTitle" size="33" value="" maxlength="100"/>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "block" : "none"%>" class='td' colspan="3">
                            <p><b><%=dataSaved.equalsIgnoreCase("Ok") ? campaignWbo.getAttribute("campaignTitle") : ""%></b>
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                            <LABEL>
                                <p><b><%=fromDate%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "none" : "block"%>" class='td'>
                            <input type="TEXT" style="width:190px" name="fromDate" ID="fromDate" size="20" value="" maxlength="100" readonly="true"/>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "block" : "none"%>" class='td'>
                            <p><b><%=dataSaved.equalsIgnoreCase("Ok") ? campaignWbo.getAttribute("fromDate") : ""%></b>
                        </TD>
                        <TD STYLE="<%=style%>; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                            <LABEL>
                                <p><b><%=toDate%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "none" : "block"%>" class='td'>
                            <input type="TEXT" style="width:190px" name="toDate" ID="toDate" size="20" value="" maxlength="100" readonly="true"/>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "block" : "none"%>" class='td'>
                            <p><b><%=dataSaved.equalsIgnoreCase("Ok") ? campaignWbo.getAttribute("toDate") : ""%></b>
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                            <LABEL>
                                <p><b><%=approximateCost%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "none" : "block"%>" class='td' colspan="3">
                            <input type="TEXT" style="width:100px" name="cost" ID="cost" size="33" value="" maxlength="15"/>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "block" : "none"%>" class='td' colspan="3">
                            <p><b><%=dataSaved.equalsIgnoreCase("Ok") ? campaignWbo.getAttribute("cost") : ""%></b>
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                            <LABEL>
                                <p><b><%=objective%></b>
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "none" : "block"%>" class='td' colspan="3">
                            <input type="TEXT" style="width:100px" name="objective" ID="objective" size="33" value="" maxlength="15"/>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "block" : "none"%>" class='td' colspan="3">
                            <p><b><%=dataSaved.equalsIgnoreCase("Ok") ? campaignWbo.getAttribute("objective") : ""%></b></p>
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                            <LABEL>
                                <p><b><%=direction%></b>
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "none" : "block"%>" class='td' colspan="3">
                            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                <TR>
                                    <TD class="td">
                                        <input type="radio" name="direction" ID="direction" value="4" checked/>
                                    </TD>
                                    <TD class="td">
                                        <%=forword%>
                                    </TD>
                                    <TD class="td">
                                        <input type="radio" name="direction" ID="direction" value="2"/>
                                    </TD>
                                    <TD class="td">
                                        <%=backword%>
                                    </TD>
                                    <TD class="td">
                                        <input type="radio" name="direction" ID="direction" value="3"/>
                                    </TD>
                                    <TD  class="td">
                                        <%=both%>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") && campaignWbo.getAttribute("direction") != null ? "block" : "none"%>" class='td' colspan="3">
                            <p><b><%=dataSaved.equalsIgnoreCase("Ok") && ((String) campaignWbo.getAttribute("direction")).equalsIgnoreCase("1") ? forword : ""%></b></p>
                            <p><b><%=dataSaved.equalsIgnoreCase("Ok") && ((String) campaignWbo.getAttribute("direction")).equalsIgnoreCase("2") ? backword : ""%></b></p>
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                            <LABEL>
                                <p><b><%=projects%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="width: 100%<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "none" : "block"%>" class='td' colspan="3">
                            <select style="float: right; width: 100%; font-size: 14px;" id="projects" name="projects" multiple="true">
                                <%
                                    if (projectsList != null) {
                                        for (WebBusinessObject projectWbo : projectsList) {
                                %>
                                <option value="<%=projectWbo.getAttribute("projectID")%>"><%=projectWbo.getAttribute("projectName")%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </TD>
                        <TD STYLE="<%=style%>; display: <%=dataSaved.equalsIgnoreCase("Ok") ? "block" : "none"%>" class='td' colspan="3">
                            <p><b>
                                    <%
                                        if (campaignProjectsList != null) {
                                            for (WebBusinessObject campaignProject : campaignProjectsList) {
                                    %>
                                    <%=campaignProject.getAttribute("projectName")%><br />
                                    <%
                                            }
                                        }
                                    %>
                                </b></p>
                        </TD>
                    </TR>
                </TABLE>
                <br /><br />

                <DIV id="tblDataDiv" style="display: <%=dataSaved.equalsIgnoreCase("Ok") ? "block" : "none"%>">
                    <input type="button" id="addTool" onclick="JavaScript:showToolPopup();" value=" إضافة أداة للحملة "/>
                    <input type="button" id="addTools" style="margin: 40px;" onclick="JavaScript:saveTools();" value=" إضافة أدوات للحملة "/>
                    <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="80%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=campaignTitle%></b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=toolID%></b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=fromDate%> </b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=toDate%></b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=approximateCost%></b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>&nbsp;</b></TD>
                        </TR>
                    </TABLE>
                </DIV>
                <br />
                <br />
            </fieldset>

        </FORM>
    </BODY>
</HTML>     
