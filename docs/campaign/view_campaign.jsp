<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
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
    <fmt:setBundle basename="Languages.Campaigns.Campaigns"  />

    <%
        String status = (String) request.getAttribute("status");
         
        WebBusinessObject campaignWbo = (WebBusinessObject) request.getAttribute("campaignWbo");
        ArrayList<WebBusinessObject> toolsList = (ArrayList<WebBusinessObject>) request.getAttribute("toolsList");
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        ArrayList<String> selectedProjectIDs = (ArrayList<String>) request.getAttribute("selectedProjectIDs");
        ArrayList<WebBusinessObject> campaignProjectsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignProjectsList");
        ArrayList<WebBusinessObject> subCampaignsList = request.getAttribute("subCampaignsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("subCampaignsList") : new ArrayList<WebBusinessObject>();
        ArrayList<WebBusinessObject> chldCmpnActvLst = (ArrayList<WebBusinessObject>) request.getAttribute("chldCmpnActvLst");
        Map<String, String> campaingClientsTotal = (HashMap<String, String>) request.getAttribute("campaingClientsTotal");
        String directionValue = "";
        if(campaignWbo != null && campaignWbo.getAttribute("direction") != null) {
            directionValue = (String) campaignWbo.getAttribute("direction");
        }
        
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String date = sdf.format(cal.getTime());
    
        sdf = new SimpleDateFormat("yyyy-MM-dd");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        double allowedCost = Double.parseDouble((String) campaignWbo.getAttribute("cost"));
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }
        long total = 0;
        if (campaingClientsTotal.containsKey((String) campaignWbo.getAttribute("id"))) {
            total += Long.valueOf(campaingClientsTotal.get((String) campaignWbo.getAttribute("id")));
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
        <link rel="stylesheet" href="css/chosen.css"/>
        
        <script src="js/amcharts/amcharts.js"></script>
        <script src="js/amcharts/serial.js"></script>
        <script src="js/amcharts/gantt.js"></script>
        <script src="js/amcharts/plugins/export/export.min.js"></script>
        <link rel="stylesheet" href="js/amcharts/plugins/export/export.css" type="text/css" media="all" />
        <script src="js/amcharts/themes/light.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <SCRIPT  TYPE="text/javascript">
            var minDateS = '<%=sdf.format(sdf.parse((String) campaignWbo.getAttribute("fromDate")))%>';
            var maxDateS = '<%=sdf.format(sdf.parse((String) campaignWbo.getAttribute("toDate")))%>';
            var date = new Date();
            
            $(document).ready(function(){
                $("#fromDate, #toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                $("#fromDateForm, #toDateForm").datepicker({
                    minDate: new Date(minDateS),
                    maxDate: new Date(maxDateS),
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                $("#fromDateEdit").datepicker({
                    maxDate: new Date(maxDateS),
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                $("#toDateEdit").datepicker({
                    minDate: new Date(maxDateS),
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                //centerDiv("add_tool");
                centerDiv("edit_from_date");
                centerDiv("edit_to_date");
                centerDiv("edit_cost");
                centerDiv("edit_objective");
                centerDiv("edit_projects");
                centerDiv("edit_direction");
                centerDiv("edit_cam_name");
                //centerDiv("edit_sub_campaign_title");
                //centerDiv("edit_sub_campaign_cost");
                
               /* <%
                    if(subCampaignsList != null && subCampaignsList.size()>1){
                %>
                        var chart = AmCharts.makeChart( "chartdiv", {
                            "type": "gantt",
                            "mouseWheelScrollEnabled" : true,
                            "mouseWheelZoomEnabled": true,
                            "marginRight": 50,
                            "marginLeft": 50,
                            "period": "DD",
                            "dataDateFormat": "YYYY-MM-DD",
                            "columnWidth": 0.5,
                            "valueAxis": {
                                "type": "date"
                            }, "brightnessStep": 0,
                            "graph": {
                                "fillAlphas": 1,
                                "lineAlpha": 1,
                                //"lineColor": "#fff",
                                "fillAlphas": 1,
                                "balloonText": "<b>[[campaign]]</b>:<br />[[open]] : [[value]]"
                            }, "rotate": true,
                            "categoryField": "campaign",
                            "segmentsField": "segments",
                            //"colorField": "color",
                            "startDateField": "start",
                            "endDateField": "end",
                            "dataProvider": [
                                <%
                                    String cmp = "false";
                                    for (int i=0; i<chldCmpnActvLst.size(); i++) {
                                        WebBusinessObject chldCmpnActvWbo = chldCmpnActvLst.get(i);
                                %>
                                        <%
                                            if(i == 0 || cmp.equals("false")){
                                        %>    
                                                {
                                                    "campaign": "<%=chldCmpnActvWbo.getAttribute("task")%>",
                                                    "segments": [
                                        <%
                                            }
                                        %>
                                            {
                                                "start": "<%=chldCmpnActvWbo.getAttribute("start") != null ? chldCmpnActvWbo.getAttribute("start") : date%>",
                                                "end": "<%=chldCmpnActvWbo.getAttribute("end") != null ? chldCmpnActvWbo.getAttribute("end") : date%>",
                                                //"color": "#b9783f",
                                                "campaign": "<%=chldCmpnActvWbo.getAttribute("task")%>"
                                        <%
                                            if(i<chldCmpnActvLst.size()-1 && chldCmpnActvLst.get(i+1).getAttribute("cmpnId").equals(chldCmpnActvWbo.getAttribute("cmpnId").toString())){
                                                cmp = "true";
                                        %>    
                                                },
                                        <%
                                            } else {
                                                cmp = "false";
                                        %>
                                                    }
                                        <%
                                            }
                                        %>
                                <%
                                        if(cmp.equals("true")){
                                %>
                                <%
                                        }else if(i<chldCmpnActvLst.size()-1 || cmp.equals("false")){
                                %>
                                            ]},
                                <%
                                        } else if(i == chldCmpnActvLst.size()-1 || cmp.equals("false")){
                                %>
                                            ]}
                                <%
                                        }
                                    }
                                %>
                            ],
                            "valueScrollbar": {
                                "autoGridCount": true
                            }, "chartCursor": {
                                "cursorColor": "#2E86C1",
                                "valueBalloonsEnabled": true,
                                "cursorAlpha": 1,
                                "valueLineAlpha": 1,
                                "valueLineBalloonEnabled": true,
                                "valueLineEnabled": true,
                                "zoomable": true,
                                "valueZoomable": true
                            }, "export": {
                                "enabled": true
                            },"listeners":[{
                                "event": "rollOverGraphItem",
                                "method": function (event) {
                                  changeStroke(event, 5);
                                }
                            },{
                                "event": "rollOutGraphItem",
                                "method": function (event) {
                                    changeStroke(event, 1);
                                }     
                            }]
                        });
                <%
                    }
                %>*/
            });
            
            var divID;
            var oldCost;
            function submitForm(){
                var fromDate = new Date($("#fromDate").val());
                var toDate = new Date($("#toDate").val());
                if (!validateData("req", this.CAMPAIGN_FORM.campaignTitle,'<fmt:message key="camptittle" />')) {
                    this.CAMPAIGN_FORM.campaignTitle.focus();
                } else if (!validateData("req", this.CAMPAIGN_FORM.fromDate, '<fmt:message key="campfromdate" />')) {
                    this.CAMPAIGN_FORM.fromDate.focus();
                } else if (!validateData("req", this.CAMPAIGN_FORM.toDate, '<fmt:message key="camptodate" />')) {
                    this.CAMPAIGN_FORM.toDate.focus();
                } else if (fromDate > toDate) {
                    alert('<fmt:message key="daterangeerror" />');
                } else if (!validateData("req", this.CAMPAIGN_FORM.cost, '<fmt:message key="campapproximateCost" />')) {
                    this.CAMPAIGN_FORM.cost.focus();
                } else if (!validateData("numericfloat", this.CAMPAIGN_FORM.cost,'<fmt:message key="costerror" />')) {
                    this.CAMPAIGN_FORM.cost.focus();
                } else if (!validateData("numericfloat", this.CAMPAIGN_FORM.objective, "الرجاء أدخال رقم صحيح للمكالمات المستهدفة")) {
                    this.CAMPAIGN_FORM.objective.focus();
                } else if (!validateData("req", this.CAMPAIGN_FORM.projects, '<fmt:message key="projectserror" />')) {
                    this.CAMPAIGN_FORM.projects.focus();
                } else {
                    document.CAMPAIGN_FORM.action = "<%=context%>/CampaignServlet?op=saveCampaign";
                    document.CAMPAIGN_FORM.submit();
                }
            }

            function IsNumeric(sText){
                var ValidChars = "0123456789.";
                var IsNumber = true;
                var Char;
                for (i = 0; i < sText.length && IsNumber == true; i++){
                    Char = sText.charAt(i);
                    if (ValidChars.indexOf(Char) == -1){
                        var TCode = document.getElementById('code').value;
                        if (/[^a-zA-Z0-9]/.test(TCode)) {
                            alert('Input is not alphanumeric');
                            return false;
                        }
                    } else {
                        alert("The code is either alphanumeric or alphabetical");
                        break;
                    }
                }
                return IsNumber;
            }

            function cancelForm(){
                document.CAMPAIGN_FORM.action = "<%=context%>/CampaignServlet?op=listCampaigns";
                document.CAMPAIGN_FORM.submit();
            }
            
            function showToolPopup(){
                divID = "add_tool";
                $('#overlay').show();
                $('#add_tool').css("display", "block");
                rename();
                $('#add_tool').dialog(); 
            }
            
            function closePopup(formID) {
                $("#" + formID).hide();
                $('#overlay').hide();
            }
            
            var count = <%=subCampaignsList != null ? subCampaignsList.size() : "0"%>;
            function saveTool() {
                var campaignID = $("#campaignID").val();
                var campaignTitle = $("#campaignTitleForm").val();
                var toolID = $("#toolID").val();
                var fromDate = $("#fromDateForm").val();
                var toDate = $("#toDateForm").val();
                var cost = $("#costForm").val();
                var objective = 0;
                var direction = '<%=directionValue%>';
                if (validateSubCampaign()) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/CampaignServlet?op=saveSubCampaignByAjax",
                        data: {
                            parentID: campaignID,
                            campaignTitle: campaignTitle,
                            toolID: toolID,
                            fromDate: fromDate,
                            toDate: toDate,
                            cost: cost,
                            objective: objective,
                            direction: direction
                        }, success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'Ok') {
                                alert('<fmt:message key="ssavestatus"/>');
                                allowedCost -= parseInt(cost);
                                $("#add_tool").css("display", "none");
                                $("#campaignTitleForm").val("");
                                $("#toolID").val("");
                                $("#fromDateForm").val("<%=campaignWbo != null ? sdf.format(sdf.parse((String) campaignWbo.getAttribute("fromDate"))) : ""%>");
                                $("#toDateForm").val("<%=campaignWbo != null ? sdf.format(sdf.parse((String) campaignWbo.getAttribute("toDate"))) : ""%>");
                                $("#costForm").val("");
                                count++;
                                $("#tblData").append($('<tr id="row' + count + '">').append($('<td class="silver_odd_main">').append("&nbsp;" + count))
                                        .append($('<td class="silver_odd_main">').append(campaignTitle))
                                        .append($('<td class="silver_odd_main">').append(info.toolName)).append($('<td class="silver_odd_main">')
                                        .append(fromDate)).append($('<td class="silver_odd_main">').append(toDate)).append($('<td class="silver_odd_main">')
                                        .append(cost + '<input type="hidden" value="' + info.id + '" id="campaignIDTable"/>')).append($('<td class="silver_odd_main">')
                                        .append('<div class="remove" onclick="removeRow(\'' + info.id + '\',' + count + ')" title="حذف" style="margin-left:auto;margin-right:auto"/>')
                                        ));
                            } else if (info.status == 'faild') {
                                alert('<fmt:message key="fsavestatus"/>');
                            }
                            $("#overlay").hide();
                        }
                    });
                }
            }
            
            function removeRow(id, rowNo) {
                var cost = $("#costForm").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=deleteSubCampaignByAjax",
                    data: {
                        campaignID: id
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert('<fmt:message key="donedeleted" />');
                            allowedCost += parseInt(cost);
                            for (i = rowNo + 1; i <= count; i++) {
                                var newRow = i - 1;
                                $("#row" + i + " td:first").html(newRow);
                                $("#row" + i + " td:last").html('<div class="remove" onclick="removeRow(\'' + $("#row" + i + " #campaignIDTable").val() + '\',' + newRow + ')" title="حذف" style="margin-left:auto;margin-right:auto"/>');
                                $("#row" + i).attr("id", "row" + (newRow));
                            }
                            
                            count--;
                            $("#row" + rowNo).remove();
                        } else if (info.fdelete_Statusstatus == 'faild') {
                            alert('<fmt:message key="fdelete_Status" />');
                        }
                    }
                });
            }
            
            function showEditFromDate(){
                divID = "edit_from_date";
                $('#overlay').show();
                $('#edit_from_date').css("display", "block");
                $('#edit_from_date').dialog();
            }
            
            function showEditToDate(){
                divID = "edit_to_date";
                $('#overlay').show();
                $('#edit_to_date').css("display", "block");
                $('#edit_to_date').dialog();
            }
            
            function showEditCampName(){
                divID = "edit_cam_name";
                $('#overlay').show();
                $('#edit_cam_name').css("display", "block");
                $('#edit_cam_name').dialog();
            }
            
            function showEditCost(){
                oldCost = parseInt($("#costEdit").val());
                divID = "edit_cost";
                $('#overlay').show();
                $('#edit_cost').css("display", "block");
                $('#edit_cost').dialog();
            }
            
            function showEditObjective(){
                divID = "edit_objective";
                $('#overlay').show();
                $('#edit_objective').css("display", "block");
                $('#edit_objective').dialog();
            }
            
            function showEditProjects(){
                divID = "edit_projects";
                $('#overlay').show();
                $('#edit_projects').css("display", "block");
                $('#edit_projects').dialog();
            }
            
            function showEditDirection(){
                divID = "edit_direction";
                $('#overlay').show();
                $('#edit_direction').css("display", "block");
                $('#edit_direction').dialog();
            }
            
            function showEditSubCampaignTitle(id, title){
                divID = "edit_sub_campaign_title";
                $("#subCampaignID").val(id);
                $("#newSubCampaignTitle").val(title);
                $('#overlay').show();
                $('#edit_sub_campaign_title').css("display", "block");
                $('#edit_sub_campaign_title').dialog();
            }
            
            function showEditSubCampaignCost(id, cost){
                divID = "edit_sub_campaign_cost";
                $("#subCampaignID").val(id);
                $("#newSubCampaignCost").val(cost);
                $("#oldSubCampaignCost").val(cost);
                $('#overlay').show();
                $('#edit_sub_campaign_cost').css("display", "block");
                $('#edit_sub_campaign_cost').dialog();
            }
            
            function editCamapaign(editType) {
                var projects = [];
                var projectsText = '';
                if (editType === 'cost') {
                    var newCost = parseInt($("#costEdit").val());
                    if (newCost > oldCost || oldCost - newCost < allowedCost) {
                        allowedCost += (newCost - oldCost);
                    } else {
                        alert('<fmt:message key="totalSubCostError" />');
                        return;
                    }
                }
                
                if (editType === 'title') {
                    checkCampaignName($('#nwcampaignTitle'));
                }
                
                $('#projectsEdit :selected').each(function(i, selected) {
                    projects[i] = $(selected).val();
                    projectsText = projectsText + $(selected).text() + "<br/>";
                });
                
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=editCampaignByAjax",
                    data: {
                        campaignID: '<%=campaignWbo.getAttribute("id")%>',
                        editType: editType,
                        fromDate: $("#fromDateEdit").val(),
                        toDate: $("#toDateEdit").val(),
                        cost: $("#costEdit").val(),
                        objective: $("#objectiveEdit").val(),
                        title: $("#nwcampaignTitle").val(),
                        projects: JSON.stringify(projects),
                        direction: $("input[name=directionEdit]:checked").val()
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok'){
                            alert('<fmt:message key="supdate_Status" />');
                            if (editType == 'fromDate'){
                                $("#fromDateCell").html($("#fromDateEdit").val());
                                var minDate = $("#fromDateEdit").val();
                                $('#fromDateForm').datepicker('option', 'minDate', new Date(minDate));
                                $('#toDateForm').datepicker('option', 'minDate', new Date(minDate));
                                $('#fromDateForm').val(minDate);
                                $("#edit_from_date").hide();
                            } else if (editType == 'toDate') {
                                $("#toDateCell").html($("#toDateEdit").val());
                                var maxDate = $("#toDateEdit").val();
                                $('#fromDateForm').datepicker('option', 'maxDate', new Date(maxDate));
                                $('#toDateForm').datepicker('option', 'maxDate', new Date(maxDate));
                                $('#toDateForm').val(maxDate);
                                $("#edit_to_date").hide();
                            } else if (editType == 'cost') {
                                $("#costCell").html($("#costEdit").val());
                                $("#edit_cost").hide();
                            } else if (editType == 'objective') {
                                $("#objectiveCell").html($("#objectiveEdit").val());
                                $("#edit_objective").hide();
                            } else if (editType == 'projects') {
                                $("#projectsCell").html(projectsText);
                                $("#edit_projects").hide();
                            } else if (editType == 'direction'){
                                if($("input[name=directionEdit]:checked").val() == '1'){
                                    $("#directionCell").html($("#forwardCell").html());
                                } else  if($("input[name=directionEdit]:checked").val() == '2'){
                                    $("#directionCell").html($("#backwardCell").html());
                                } else  if($("input[name=directionEdit]:checked").val() == '3'){
                                    $("#directionCell").html($("#bothCell").html());
                                }
                                
                                $("#edit_direction").hide();
                            } else if (editType == 'title'){
                                $("#edit_cam_name").hide();
                                location.reload();
                            }
                        } else if (info.status == 'faild') {
                            alert('<fmt:message key="fupdate_Status" />');
                        }
                        
                        $("#overlay").hide();
                    }
                });
            }
            
            function closeOverlay() {
                $("#" + divID).hide();
                $("#overlay").hide();
            }
            
            function centerDiv(div) {
                $("#" + div).css("position", "fixed");
                $("#" + div).css("top", Math.max(0, (($(window).height() - $("#" + div).outerHeight()) / 2) + $(window).scrollTop()) + "px");
                $("#" + div).css("left", Math.max(0, (($(window).width() - $("#" + div).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
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
                var mainCampaignTtile = "<%=campaignWbo.getAttribute("campaignTitle")%>";
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
                        }, success: function(jsonString) {
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
            
            function checkCampaignName(obj) {
                var campaignName = $(obj).val();
                if (campaignName.length > 0) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/CampaignServlet?op=getCampaignName",
                        data: {
                            campaignName: campaignName
                        }, success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'Ok') {
                                alert(" يوجد حملة بهذا الإسم ");
                            }
                        }
                    });
                }
            }
            
            function editSubCamapaignTitle() {
                checkCampaignName($('#newSubCampaignTitle'));
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=editCampaignByAjax",
                    data: {
                        campaignID: $("#subCampaignID").val(),
                        editType: 'title',
                        title: $("#newSubCampaignTitle").val()
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok'){
                            alert('<fmt:message key="supdate_Status" />');
                            location.reload();
                        } else if (info.status == 'faild') {
                            alert('<fmt:message key="fupdate_Status" />');
                        }
                        $("#edit_sub_campaign_title").hide();
                        $("#overlay").hide();
                    }
                });
            }
            function popupchangetool(campaingID){
              divID = "change_campaign_tool";
                $('#overlay').show();
                $("#campaingIdFt").val(campaingID);
                $('#change_campaign_tool').css("display", "block");
                $('#change_campaign_tool').dialog();
            
            }
            
            function editSubCampaignTool() {
                //checkCampaignName($('#newSubCampaignTitle'));
                var toolN=$("#changetoolId option:selected").html();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=editCampaignTool",
                    data: {
                        campaignID: $("#campaingIdFt").val(),
                        toolID:$('#changetoolId').val(),
                       
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok'){
                            alert('<fmt:message key="supdate_Status" />');
                            
                        } else if (info.status == 'faild') {
                            alert('<fmt:message key="fupdate_Status" />');
                        }
                        var campaignID=$("#campaingIdFt").val()
                        $("#change_campaign_tool").hide();
                        $("#overlay").hide();
                        $('#toolName'+campaignID).html(toolN);
                    }
                });
            }
            function changeStatusToActive(id){
            var active="16";
             $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=changeSubCampaignStatus",
                    data: {
                        campaignID: id,
                        active:active
                       
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok'){
                            $('#changeToactive'+id).html("active");
                            
                            alert('<fmt:message key="supdate_Status" />');
                            
                            
                        } else if (info.status == 'faild') {
                            alert('<fmt:message key="fupdate_Status" />');
                        }

                    }
                });
            
            
            }
        </SCRIPT>
        
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
                /*                top: 80%;
                                left: 35%;*/
                z-index: 1000;
            }
            
            .mediumDialog {
                width: 370px;
                display: none;
                position: fixed;
                /*                top: 80%;
                                left: 35%;*/
                z-index: 1000;
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
            
            .img:hover{
                cursor: pointer ;
            }
            
            #chartdiv {
              width: 100%;
              height: 500px;
            }
            
            #project tr:nth-child(even) {background-color: #bfbfbf;}
            
            
        </style>
    </HEAD>
    
    <BODY>
        <FORM NAME="CAMPAIGN_FORM" METHOD="POST">
            <DIV align="left" STYLE="color: blue; width: 80%;">
                <IMG class="img" width="5%" style="cursor: pointer;" VALIGN="BOTTOM" onclick="JavaScript: cancelForm();" SRC="images/buttons/backBut.png" > 
                
                <button onclick="JavaScript: submitForm(); return false;" class="button" style="display: none;">
                     <fmt:message key="saveButtonLabel"/> 
                    <IMG HEIGHT="15" SRC="images/save.gif">
                </button>
            </DIV>
                    
            <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">
            </div>
                    
            <div id="add_tool" style="width: 45%; display: none; position: fixed; z-index: 1000;margin-left:500px;margin-right:500px">
                <div style="clear: both; margin-left: 95%; margin-top: 0px; margin-bottom: -38px; z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('add_tool')"/>
                </div>
                
                <div class="login" style="width: 95%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table  border="0px" style="width: 100%;" class="table" dir="<fmt:message key="direction"/>">
                        <tr><TD colspan="4" style="font-size:20px;align-self: center;border:none;color:white">اضافة حملة فرعية</TD></tr>
                        <TR>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="toolID"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: <fmt:message key="textalign"/>;" colspan="3">
                                <select class="chosen-select-tool" style="float: <fmt:message key="textalign"/>;width: 190px; font-size: 14px;" id="toolID" name="toolID">
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
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="subCampaignCode"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: <fmt:message key="textalign"/>;" colspan="3">
                                <input type="TEXT" style="width: 150px;" ID="campaignTitleForm" size="" maxlength=""/>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 33%;" nowrap>
                                 <fmt:message key="fromDate"/> 
                            </td>
                            
                            <td style="width: 33%; text-align: <fmt:message key="textalign"/>;">
                                <input type="TEXT" style="width:150px" ID="fromDateForm" size="20" maxlength="100" readonly="true" value="<%=sdf.format(sdf.parse((String) campaignWbo.getAttribute("fromDate")))%>"/>
                            </td>
                            
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 33%;" nowrap>
                                 <fmt:message key="toDate"/> 
                            </td>
                            
                            <td style="width: 34%; text-align: <fmt:message key="textalign"/>;">
                                <input type="TEXT" style="width: 150px;" ID="toDateForm" size="20" maxlength="100" readonly="true" value="<%=sdf.format(sdf.parse((String) campaignWbo.getAttribute("toDate")))%>"/>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="approximateCost"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: <fmt:message key="textalign"/>;" colspan="3">
                                <input type="number" style="width:100px" ID="costForm" size="33" value="" maxlength="15" min="1"/>
                            </td>
                        </tr>
                    </table>
                                
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="saveTool(this)" id="saveComm" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
            <div id="edit_from_date" class="smallDialog">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                 -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                 -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_from_date')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table border="0px" style="width: 100%;" class="table">
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="fromDate"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:190px" name="fromDateEdit" ID="fromDateEdit" size="20" value="<%=sdf.format(sdf.parse((String) campaignWbo.getAttribute("fromDate")))%>" maxlength="100" readonly="true"/>
                            </td>
                        </tr>
                    </table>
                            
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editCamapaign('fromDate')" id="editFromDate" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
            <div id="edit_cam_name" class="smallDialog" align="center" style="padding: auto; margin: auto;">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_cam_name')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table border="0px" style="width: 100%;" class="table">
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="campaignTitle"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:190px" name="nwcampaignTitle" ID="nwcampaignTitle" size="" value="" onkeyup="checkCampaignName(this)" onmousedown="checkCampaignName(this)"/>
                            </td>
                        </tr>
                    </table>
                            
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editCamapaign('title')" id="EditcampaignTitle" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
            <div id="edit_to_date" class="smallDialog">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_to_date')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table  border="0px"  style="width: 100%;"  class="table">
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                 <fmt:message key="toDate"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:190px" name="toDateEdit" ID="toDateEdit" size="20" value="<%=sdf.format(sdf.parse((String) campaignWbo.getAttribute("toDate")))%>" maxlength="100" readonly="true"/>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editCamapaign('toDate')" id="editToDate" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
            <div id="edit_cost" class="smallDialog">
                <div style="clear: both; margin-left: 88%; margin-top: 0px; margin-bottom: -38px; z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_cost')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table border="0px" style="width: 100%;" class="table">
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="approximateCost"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width: 100px;" ID="costEdit" size="33" value="<%=campaignWbo.getAttribute("cost")%>" maxlength="15"/>
                            </td>
                        </tr>
                    </table>
                            
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editCamapaign('cost')" id="editCost" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
            <div id="edit_objective" class="smallDialog">
                <div style="clear: both; margin-left: 88%; margin-top: 0px; margin-bottom: -38px; z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_objective')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table border="0px" style="width: 100%;" class="table">
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="objective"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:100px" ID="objectiveEdit" size="33" value="<%=campaignWbo.getAttribute("objective")%>" maxlength="15"/>
                            </td>
                        </tr>
                    </table>
                            
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editCamapaign('objective')" id="editObjective" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
            <div id="edit_projects" class="smallDialog" style="width: 390px;">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_projects')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table border="0px" style="width: 100%;" class="table">
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="projects"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <select style="float: right; width: 230px; font-size: 14px;" id="projectsEdit" name="projectsEdit" multiple="true">
                                    <%
                                        if (projectsList != null) {
                                            for (WebBusinessObject projectWbo : projectsList) {
                                    %>
                                                <option value="<%=projectWbo.getAttribute("projectID")%>" <%=selectedProjectIDs.contains((String) projectWbo.getAttribute("projectID")) ? "selected" : ""%>><%=projectWbo.getAttribute("projectName")%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                    </table>
                                
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editCamapaign('projects')" id="editObjective" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
            <div id="edit_direction" class="mediumDialog">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow:0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_direction')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table  border="0px"  style="width: 100%;"  class="table">
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="directioncall"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                    <TR>
                                        <TD class="td" nowrap>
                                            <input type="radio" name="directionEdit" ID="directionEdit" value="1" <%=directionValue.equals("1") ? "checked" : ""%>/>
                                        </TD>
                                        
                                        <TD class="td" nowrap id="forwardCell">
                                             <fmt:message key="forward"/> 
                                        </TD>
                                    </TR>
                                    
                                    <TR>
                                        <TD class="td" nowrap>
                                            <input type="radio" name="directionEdit" ID="directionEdit" value="2" <%=directionValue.equals("2") ? "checked" : ""%>/>
                                        </TD>
                                        
                                        <TD class="td" nowrap id="backwardCell">
                                             <fmt:message key="backward"/> 
                                        </TD>
                                    </TR>
                                    
                                    <TR>
                                        <TD class="td" nowrap>
                                            <input type="radio" name="directionEdit" ID="directionEdit" value="3" <%=directionValue.equals("3") ? "checked" : ""%>/>
                                        </TD>
                                        
                                        <TD class="td" nowrap id="bothCell">
                                             <fmt:message key="both"/> 
                                        </TD>
                                    </TR>
                                </TABLE>
                            </td>
                        </tr>
                    </table>
                                        
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editCamapaign('direction')" id="editDirection" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            <div id="edit_sub_campaign_title" class="smallDialog" style="margin-left:500px;margin-right:500px">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_sub_campaign_title')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table border="0px" style="width: 100%;" class="table">
                  
                        <tr>
                            <td  style="color: #f1f1f1; font-size: 16px; font-weight: bold; align-self: center" colspan="2">
                                <fmt:message key="changeCampaignCode"/> 
                            </td>
                        </tr>
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="campaignTitle"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:190px" name="newSubCampaignTitle" ID="newSubCampaignTitle" size="" value=""/>
                                <input type="hidden" style="width:190px" name="subCampaignID" ID="subCampaignID" size="" value=""/>
                            </td>
                        </tr>
                    </table>
                            
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editSubCamapaignTitle()" id="editSunCampaignTitle" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
              <div id="change_campaign_tool" class="smallDialog" style="margin-left: 400px;margin-right: 500px;width: 500px;">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('change_campaign_tool')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table border="0px" style="width: 100%;" class="table">
                        <tr>
                            <td  style="color: #f1f1f1; font-size: 16px; font-weight: bold;align-self: center " colspan="2">
                                <fmt:message key="changeCampaignTool"/> 
                            </td>
                        </tr>    
                        <TR>
                                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="toolID"/> 
                            </td>
                            
                            <td style="width:70%; text-align: <fmt:message key="textalign"/>;" colspan="3">
                                <select class="chosen-select-tool" style="float: <fmt:message key="textalign"/>;width: 190px; font-size: 14px;" id="changetoolId" name="changetoolId">
                                    <%
                                        if (toolsList != null) {
                                            for (WebBusinessObject toolWbo : toolsList) {
                                    %>
                                                <option style="width:270px;" value="<%=toolWbo.getAttribute("id")%>"><%=toolWbo.getAttribute("arabicName")%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                                <INPUT type="text" id="campaingIdFt" name="campaingIdFt" hidden="true"/>
                            </td>

                        </TR> 
                    </table>
                            
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editSubCampaignTool()" id="editSunCampaignTitle" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            <div id="edit_sub_campaign_cost" class="smallDialog" style="margin-left:500px;margin-right:500px">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup('edit_sub_campaign_cost')"/>
                </div>
                
                <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                    <table border="0px" style="width: 100%;" class="table">
                        <tr>
                            <td  style="color: #f1f1f1; font-size: 16px; font-weight: bold; align-self: center" colspan="2">
                                <fmt:message key="changeCampaignCost"/> 
                            </td>
                        </tr>
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;" nowrap>
                                 <fmt:message key="approximateCost"/> 
                            </td>
                            
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="number" style="width:100px" name="newSubCampaignCost" id="newSubCampaignCost" size="" value=""/>
                                <input type="hidden" name="oldSubCampaignCost" id="oldSubCampaignCost" size="" value=""/>
                            </td>
                        </tr>
                    </table>
                            
                    <div style="text-align: center; margin-left: auto; margin-right: auto;" >
                        <input type="button" value=<fmt:message key="save"/> onclick="editSubCamapaignCost()" id="editSunCampaignCost" class="login-submit"/>
                    </div>                           
                </div>
            </div>
                    
            <fieldset class="set" align="center" style="width: 95%;">
                <legend align="center">
                    <table dir=<fmt:message key="direction"/> align="center"  >
                        <tr>
                            <td class="td">
                                <font color="blue" size="4">
                                     Campaign Detail 
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
                                <table align="center" dir=<fmt:message key="direction"/>>
                                    <tr>                    
                                        <td class="td">
                                            <font size=4 color="black">
                                                 <fmt:message key="sStatus"/> 
                                            </font> 
                                        </td>                    
                                    </tr>
                                </table>
                            </tr>
                <%
                        } else {%>
                            <tr>
                                <table align="center" dir=<fmt:message key="direction"/>>
                                    <tr>                    
                                        <td class="td">
                                            <font size=4 color="red" >
                                                 <fmt:message key="fStatus"/> 
                                            </font> 
                                        </td>                    
                                    </tr>
                                </table>
                            </tr>
                <%
                        }
                    }

                %>
                
                <br><br>
                
                <input type="hidden" id="campaignID" value="<%=campaignWbo != null ? campaignWbo.getAttribute("id") : ""%>"/>
                
                <fieldset align="center" style="border-radius:0px; width:50%;margin-left: 25%;padding: 1px;" class="set">
                    <TABLE align="center" dir=<fmt:message key="direction"/> CELLPADDING="0" CELLSPACING="0" BORDER="0" id="MainTable" width="100%" >
                        <TR>
                            <TD STYLE="text-align : <fmt:message key="textalign"/> ;font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="14%">
                                <LABEL style="text-align:center;color:black;font-size:14px;font-weight: bold;padding:10" nowrap width="10%">
                                    <b>
                                         <fmt:message key="campaignTitle"/> 
                                    </b>
                                </LABEL>
                            </TD>
                            
                            <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'>
                                <b style="padding:10;"><%=campaignWbo.getAttribute("campaignTitle")%></b>
                                <img src="images/edit.png" width="50" align="center" onclick="JavaScript: showEditCampName();"/>
                            </TD>

                            <td style="text-align : <fmt:message key="textalign"/> ;font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="14%">
                                <LABEL style="text-align:center;color:black;font-size:14px;font-weight: bold;padding:10" nowrap width="10%">
                                    <b>
                                        <fmt:message key="clientsCount"/> 
                                    </b>
                                </LABEL>
                            </td>
                            
                            <td style="text-align : <fmt:message key="textalign"/>" class='td'>
                                <%=campaingClientsTotal.containsKey((String) campaignWbo.getAttribute("id")) ? campaingClientsTotal.get((String) campaignWbo.getAttribute("id")) : 0%>
                            </td>
                        </TR>
                        
                        <TR style="border: 1px solid #C3C6C8 ">
                            <TD width="14%" STYLE="text-align : <fmt:message key="textalign"/>;font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                                <LABEL style="text-align:center;padding:10;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                    <b>
                                         <fmt:message key="fromDate"/> 
                                    </b>
                                </LABEL>
                            </TD>
                            
                            <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'>
                                <b id="fromDateCell" style="padding:10;font-size:12px;">
                                     <%=sdf.format(sdf.parse((String) campaignWbo.getAttribute("fromDate")))%> 
                                </b>
                                <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditFromDate();" style="display :<%=campaignWbo.getAttribute("currentStatus") != null && ((String) campaignWbo.getAttribute("currentStatus")).equals("15") ? "" : "none"%>"/>
                            </TD>
                            
                            <TD width="14%" STYLE="text-align : <fmt:message key="textalign"/>font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                                <LABEL style="text-align:center;padding:10;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                    <b>
                                         <fmt:message key="toDate"/> 
                                    </b>
                                </LABEL>
                            </TD>
                            
                            <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'>
                                <b id="toDateCell" style="padding:10;font-size:12px;">
                                     <%=sdf.format(sdf.parse((String) campaignWbo.getAttribute("toDate")))%> 
                                </b>
                                 <img src="images/edit.png" width="50" align="center" onclick="JavaScript: showEditToDate();"/>
                            </TD>
                            
                             <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'>
                                
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD width="14%" STYLE="text-align : <fmt:message key="textalign"/>;font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                                <LABEL style="text-align:center;padding:10;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                    <b>
                                         <fmt:message key="approximateCost"/> 
                                    </b>
                                </LABEL>
                            </TD>
                            
                            <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'  >
                                <TABLE>
                                    <TR>
                                        <TD style="border: none; width: 50%">
                                            <b id="costCell" style=" font-size:12px;">
                                                 <%=campaignWbo.getAttribute("cost")%> 
                                            </b>
                                        </TD>
                                        
                                        <TD style="border: none; width: 50%">
                                             <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditCost();"/>
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD width="14%" STYLE="text-align : <fmt:message key="textalign"/>;font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                                <LABEL style="text-align:center;padding:10;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                    <b>
                                         <fmt:message key="objective"/> 
                                    </b>
                                </LABEL>
                            </TD>
                            
                            <td class="td">
                                <TABLE>
                                    <tr>
                                        <Td style="border: none; width: 50%" >
                                            <b id="objectiveCell" style="font-size:12px;">
                                                 <%=campaignWbo.getAttribute("objective")%> 
                                            </b>
                                        </Td>
                                        
                                        <TD style="border: none; width: 50%">
                                             <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditObjective();"/> 
                                        </TD>
                                    </tr>
                                </TABLE>
                            </td>
                        </TR>
                        
                        <TR>
                            <TD width="14%" STYLE="text-align : <fmt:message key="textalign"/>;font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                                <LABEL style="text-align:center;padding:10;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                    <b> 
                                         <fmt:message key="directioncall"/> 
                                    </b>
                                </LABEL>
                            </TD>
                            
                            <td class="td">
                                <TABLE>
                                    <tr>
                                        <Td style="border: none; width: 50%" >
                                            <b id="directionCell" style="font-size:12px;">
                                
                                                <%  
                                                    if(directionValue.equalsIgnoreCase("1")){
                                                %>
                                                        <fmt:message key="forward" />
                                
                                                <%
                                                    } else if(directionValue.equalsIgnoreCase("2")){
                                                %>
                                                         <fmt:message key="backward" /> 
                                                <%
                                                    }else if(directionValue.equalsIgnoreCase("3")){
                                                %>
                                                         <fmt:message key="both" /> 
                                                <%
                                                    } else {
                                                %>
                                                          
                                                <%
                                                    }
                                                %>
                                            </b>
                                        </Td>
                                        
                                        <TD style="border: none; width: 50%">
                                             <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditDirection();"/>
                                        </TD>
                                    </tr>
                            </TABLE>
                        </td>
                    </TR>
                    
                    <%--<TR>
                        <TD width="14%" STYLE="text-align : <fmt:message key="textalign"/>;font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag">
                            <LABEL style="text-align:center;padding:10;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                <b>
                                     <fmt:message key="projects"/> 
                                </b>
                            </LABEL>
                        </TD>
                        
                        <td class="td" colspan="3">
                            <TABLE style="width: 80%;">
                                 <tr>
                                     <td>
                                         <table id="project" style="width:  100%;">
                                             <%
                                                 if (campaignProjectsList != null) {
                                                     for (WebBusinessObject campaignProject : campaignProjectsList) {
                                             %>
                                             <tr>
                                                 <Td style="border: none;">
                                                     <b id="projectsCell" style="font-size:12px;">
                                                         <%=campaignProject.getAttribute("projectName")%>
                                                     </b>
                                                 </Td>
                                             </tr>
                                             <%
                                                     }
                                                 }
                                             %>
                                         </table>
                                     </td>
                                     <TD style="border: none; width: 20%">
                                         <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditProjects();"/>
                                     </TD>
                                 </tr>
                             </TABLE>
                        </td>
                    </TR>--%>
                </TABLE>
            </FIELDSET>
            
            <br /> 
                <%--<DIV id="tblDataDiv">
                    <TABLE style="width: 50%; border: none; margin-bottom: 2%;" align="center">
                        <TR style="border: none;">
                            <TD style="width: 50%; border: none; text-align: center;">
                                <input type="button" class="button" id="addTool" style="width: 200px;" onclick="JavaScript:showToolPopup();" value=" إضافة حملة فرعية "/>
                            </TD>
                            
                            <TD style="width: 50%; border: none; text-align: center; display: <%=userPrevList.contains("ADD_CAMPAIGN_TOOLS") ? "block" : "none"%>;">
                                <input type="button" class="button" id="addTools" style="width: 200px;" onclick="JavaScript:saveTools();" value=" إضافة أدوات للحملة "/>
                            </TD>
                        </TR>
                    </TABLE>
                    
                    <TABLE id="tblData" class="blueBorder" ALIGN="center" dir=<fmt:message key="direction"/> width="80%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%">
                                <b>
                                     # 
                                </b>
                            </TD>
                            
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                <b>
                                     <fmt:message key="secondaryCampaign"/> 
                                </b>
                            </TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                <b>
                                     <fmt:message key="toolID"/> 
                                </b>
                                
                            </TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                <b>
                                     <fmt:message key="campaignStatus"/> 
                                </b>
                                
                            </TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                <b>
                                     <fmt:message key="changeCampaignStatus"/> 
                                </b>
                                
                            </TD>

                            
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                <b>
                                     <fmt:message key="fromDate"/> 
                                </b>
                            </TD>
                            
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%">
                                <b>
                                     <fmt:message key="toDate"/> 
                                </b>
                            </TD>
                            
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%">
                                <b>
                                     <fmt:message key="approximateCost"/> 
                                </b>
                            </TD>
                            
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%">
                                <b>
                                     <fmt:message key="clientsCount"/> 
                                </b>
                            </TD>
                            
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%">
                                <b>
                                </b>
                            </TD>
                        </TR>
                        
                        <%
                            int i = 1;
                            for (WebBusinessObject subCampaignWbo : subCampaignsList) {
                                allowedCost -= Double.parseDouble((String) subCampaignWbo.getAttribute("cost"));
                                if (campaingClientsTotal.containsKey((String) subCampaignWbo.getAttribute("id"))) {
                                    total += Long.valueOf(campaingClientsTotal.get((String) subCampaignWbo.getAttribute("id")));
                                }
                        %>
                                <TR id="row<%=i%>">
                                    <td class="silver_odd_main">
                                         <%=i%> 
                                    </td>
                                        
                                    <td class="silver_odd_main">
                                        <%=subCampaignWbo.getAttribute("campaignTitle")%> 
                                        <img src="images/edit.png" width="50" align="center" style="float: <fmt:message key="xAlign" />;"
                                             onclick="JavaScript: showEditSubCampaignTitle('<%=subCampaignWbo.getAttribute("id")%>', '<%=subCampaignWbo.getAttribute("campaignTitle")%>');"/>
                                    </td>
                                        
                                    <td class="silver_odd_main">
                                        <SPAN id="toolName<%=subCampaignWbo.getAttribute("id")%>"> <%=subCampaignWbo.getAttribute("toolName")%> </SPAN>
                                         <input type="button" onclick="javascript:popupchangetool('<%=subCampaignWbo.getAttribute("id")%>');" style="border-radius: 10px;color:white;font-weight: bold; background-color: #94B7E2;float: <fmt:message key="xAlign" />;" value="change"/>
                                    </td>
                                    <td class="silver_odd_main">
                                        <span style="color: blue;" id="changeToactive<%=subCampaignWbo.getAttribute("id")%>"><%=subCampaignWbo.getAttribute("currentStatusName")%></SPAN>
                                          
                                    </td>
                                      
                                      <td class="silver_odd_main">
                                          <!--change status col 5 to be added--> 
                                          
                                          <input <%if(subCampaignWbo.getAttribute("currentStatus").equals("16")){%> disabled <%}%> type="button" id="active" value="Active" onclick="JavaScript: changeStatusToActive('<%=subCampaignWbo.getAttribute("id")%>');"/>
                                      </TD>
                                    <td class="silver_odd_main">
                                         <%=sdf.format(sdf.parse((String) subCampaignWbo.getAttribute("fromDate")))%> 
                                    </td>
                                        
                                    <td class="silver_odd_main">
                                         <%=sdf.format(sdf.parse((String) subCampaignWbo.getAttribute("toDate")))%> 
                                    </td>
                                        
                                    <td class="silver_odd_main">
                                         <%=subCampaignWbo.getAttribute("cost")%> 
                                         <img src="images/edit.png" width="50" align="center" style="float: <fmt:message key="xAlign" />;"
                                             onclick="JavaScript: showEditSubCampaignCost('<%=subCampaignWbo.getAttribute("id")%>', '<%=subCampaignWbo.getAttribute("cost")%>');"/>
                                    </td>
                                        
                                    <td class="silver_odd_main">
                                        <%=campaingClientsTotal.containsKey((String) subCampaignWbo.getAttribute("id")) ? campaingClientsTotal.get((String) subCampaignWbo.getAttribute("id")) : 0%>
                                    </td>
                                        
                                    <td class="silver_odd_main">
                                        <div class="remove" onclick="removeRow('<%=subCampaignWbo.getAttribute("id")%>', '<%=i%>')" title="<fmt:message key="delete"/>" style="margin-left:auto;margin-right:auto"/>
                                        </div>
                                    </td>
                                </TR>
                        <%
                                i++;
                            }
                        %>
                        <tr>
                            <td class="td" colspan="4">
                                &nbsp;
                            </td>
                            <td colspan="2">
                                <fmt:message key="totalClients"/>
                            </td>
                            <td colspan="2">
                                <b><%=total%></b>
                            </td>
                        </tr>
                    </TABLE>
                </DIV>--%>
                        
                <br />
                <br />
                
                <!--%
                    if(subCampaignsList != null && subCampaignsList.size()>1){
                        int divHeight = subCampaignsList != null && subCampaignsList.size() > 0 ? subCampaignsList.size()*10 : 100;
                %>
                <h3><!fmt:message key="synchronizeTools"/></h3>
                        <div id="chartdiv" style="height: <!%=divHeight%>%; width: 100%;"></div>
                <!%
                    }
                %-->
            </fieldset>
        </FORM>
                        
        <script  TYPE="text/javascript">
            var allowedCost = <%=allowedCost%>;
            function validateSubCampaign() {
                var fromDate = new Date($("#fromDateForm").val());
                var toDate = new Date($("#toDateForm").val());
                if (!validateData("req", document.getElementById("campaignTitleForm"), '<fmt:message key="camptittle" />')) {
                    document.getElementById("campaignTitleForm").focus();
                    return false;
                } else if (!validateData("req", document.getElementById("fromDateForm"), '<fmt:message key="campfromdate" />')) {
                    document.getElementById("fromDateForm").focus();
                    return false;
                } else if (!validateData("req", document.getElementById("toDateForm"), '<fmt:message key="campfromdate" />')) {
                    document.getElementById("toDateForm").focus();
                    return false;
                } else if (fromDate > toDate) {
                    alert('<fmt:message key="daterangeerror" />');
                    return false;
                } else if (!validateData("req", document.getElementById("costForm"), '<fmt:message key="campapproximateCost" />')) {
                    document.getElementById("costForm").focus();
                    return false;
                } else if (!validateData("numericfloat", document.getElementById("costForm"), '<fmt:message key="costerror" />')) {
                    document.getElementById("costForm").focus();
                    return false;
                } else if (allowedCost === 0 || parseInt($("#costForm").val()) > allowedCost) {
                    $("#costForm").focus();
                    alert('<fmt:message key="totalSubCostError" />');
                    return false;
                }
//                
                return true;
            }
            
            function editSubCamapaignCost() {
                if (parseInt($("#newSubCampaignCost").val()) > allowedCost + parseInt($("#oldSubCampaignCost").val())) {
                    $("#newSubCampaignCost").focus();
                    alert('<fmt:message key="totalSubCostError" />');
                    return false;
                }
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=editCampaignByAjax",
                    data: {
                        campaignID: $("#subCampaignID").val(),
                        editType: 'cost',
                        cost: $("#newSubCampaignCost").val()
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok'){
                            alert('<fmt:message key="supdate_Status" />');
                            location.reload();
                        } else if (info.status == 'faild') {
                            alert('<fmt:message key="fupdate_Status" />');
                        }
                        $("#edit_sub_campaign_cost").hide();
                        $("#overlay").hide();
                    }
                });
            }
            var config = {
                '.chosen-select-tool': {no_results_text: 'No tool found with this name!', width:"250px"}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </BODY>
</HTML>     