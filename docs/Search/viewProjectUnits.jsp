<%@page import="java.text.DecimalFormat"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String stat = (String) request.getSession().getAttribute("currentMode");
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo1;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo1 = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo1.getAttribute("prevCode"));
        }

        Vector units = new Vector();
        units = (Vector) request.getAttribute("unitsVec");
        DecimalFormat df = new DecimalFormat("##,###.##");
        String[] tableHeader = new String[4];
        String align = null;
        String dir = null;
        String style = null;
        String sTitle, message, unitCode, unitType, search, unitArea, model, title;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Search";
            tableHeader[0] = "id";
            tableHeader[1] = "username";
            tableHeader[2] = "email";
            tableHeader[3] = "full name";
            message = "";
            unitCode = "Unit / Projcet Code";
            unitType = "Unit Type";
            search = "Search";
            unitArea = " Unit Area ";
            model = " Model ";
            title = "Units Of Project ";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "بحث عن وحده عقارية";
            tableHeader[0] = "رقم العميل";
            tableHeader[1] = "إسم العميل";
            tableHeader[2] = "رقم الموبايل";
            tableHeader[3] = "الايميل";
            message = "";
            unitCode = "كود الوحدة/ المشروع ";
            unitType = "نوع الوحدة";
            search = "بحث";
            unitArea = " المساحة ";
            model = " النموذج ";
            title = "الوحدات الخاصة بمشروع ";
        }

        String prjNM = (String)request.getAttribute("prjNM");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <head>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <link rel="stylesheet" type="text/css" href="js/jquery.dataTables.css">
    </head>
    <script type="text/javascript">
        var oTable;
        var users = new Array();
        $(document).ready(function () {
            $("#clients").css("display", "none");
            oTable = $('#clients').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true

            }).fadeIn(2000);
        });
        
        function viewDocuments(parentId) {
            var url = '<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId + '';
            var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }

        function viewGallery(unitID, modelID) {
            var url = '<%=context%>/UnitDocReaderServlet?op=unitDocGallery&unitID=' + unitID + '&modelID=' + modelID;
            var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }

        function closePopup(obj) {
            $('#unitInformation').bPopup().close();
            $('#unitInformation').css("display", "none");
        }
        function closeAttachPopup(obj) {
            $("#attachDialog").bPopup().close();
            $("#attachDialog").css("display", "none");
        }
        function closeReservePopup(obj) {
            $("#reserveDialog").bPopup().close();
            $("#reserveDialog").css("display", "none");
        }
        function addFiles2(obj) {
            if ((count * 1) == 4) {
                $("#addFile2").removeAttr("disabled");
            }

            if (count >= 1 & count <= 4) {
                $("#listFile2").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
                $("#counter2").val(count);
                count = Number(count * 1 + 1)

            } else {
                $("#addFile2").attr("disabled", true);
            }
        }
        function sendFilesByAjax(obj) {
            $("#attachForm").submit(function (e)
            {
                $(obj).parent().find("#progressx").css("display", "block");
                var formObj = $(this);
                var formURL = formObj.attr("action");
                var formData = new FormData(this);
                $.ajax({
                    url: formURL,
                    type: 'POST',
                    data: formData,
                    mimeType: "multipart/form-data",
                    contentType: false,
                    cache: false,
                    processData: false,
                    success: function (data, textStatus, jqXHR)
                    {
                        $("#progressx").html('');
                        $("#progressx").css("display", "none");
                    },
                    complete: function (response)
                    {
                        $("#attachInfo").html("<font color='white'>تم رفع الملفات</font>");

                    },
                    error: function ()
                    {
                        $("#attachInfo").html("<font color='red'>لم يتم رفع الملفات</font>");
                    }
                });
                e.preventDefault(); //Prevent Default action. 
                e.unbind();
            });

        }
        function viewUnitDetails(projectId) {
            var url = "<%=context%>/ProjectServlet?op=viewUnitData&projectId=" + projectId;
            jQuery('#unitInformation').load(url);

            $('#unitInformation').css("display", "block");
            $('#unitInformation').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
        function popup(proId, busObjId, projectName) {
            $('#reserveDialog').bPopup({modal: false});
            $('#reserveDialog').css("display", "block");
            $("#reservedPlace").html(projectName);
            $("#unitId").val(proId);
            $("#parentId").val(busObjId);
        }
        function saveOrder(obj) {
            var clientNumber = $("#clientCode").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=getClientNameByNo",
                data: {
                    clientNumber: clientNumber
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'Ok') {
                        $("#clientName").html(info.name);
                        $("#errorMsgReserve").html("");
                        $("#clientId").val(info.id);

                    } else if (info.status == 'No') {
                        $("#errorMsgReserve").html("هذا الرقم غير صحيح");
                        $("#clientName").html("");
                    }
                }
            });

        }
        function reservedUnit() {
            var clientId = $("#clientId").val();
            var unitId = document.getElementById("unitId").value;

//            var unitCategoryId = document.getElementById("unitCategoryId").value;

            var budget = document.getElementById("budget").value;
            var period = document.getElementById("period").value;
            var paymentSystem = document.getElementById("paymentSystem").value;
            var paymentPlace = document.getElementById("paymentPlace").value;
            var parentId = document.getElementById("parentId").value;

            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=saveAvailableUnits",
                data: {
                    clientId: clientId,
                    unitId: unitId,
                    budget: budget,
                    period: period,
                    unitCategoryId: parentId,
                    paymentSystem: paymentSystem,
                    paymentPlace: paymentPlace,
                    issueId: parentId

                },
                success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
                        $("#reserveDialog").bPopup().close();
                        $("#reserveDialog").css("display", "none");
                        $("#clientId").val("");
                        $("#clientCode").val("");
                        $("#unitId").val("");
                        $("#budget").val("");
                        $("#period").val("");
                        $("#paymentSystem").val("");
                        $("#paymentPlace").val("");
                        $("#parentId").val("");
                        $("#reservedPlace").html("");
                        $("#clientName").html("");
                    } else if (eqpEmpInfo.status == 'no') {
                        alert("error");
                    }
                }
            });
        }
        function sellUnit() {
            var clientId = $("#clientIdSell").val();
            var unitId = document.getElementById("unitIdSell").value;
            var budget = "0";
            var period = "UL";
            var paymentSystem = "UL";
            var paymentPlace = "UL";
            var parentId = document.getElementById("parentIdSell").value;

            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=saveSellUnits",
                data: {
                    clientId: clientId,
                    unitId: unitId,
                    budget: budget,
                    period: period,
                    unitCategoryId: parentId,
                    paymentSystem: paymentSystem,
                    paymentPlace: paymentPlace,
                    issueId: parentId

                },
                success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
                        $("#sellDialog").bPopup().close();
                        $("#sellDialog").css("display", "none");
                        $("#clientIdSell").val("");
                        $("#clientCodeSell").val("");
                        $("#unitIdSell").val("");
                        $("#parentIdSell").val("");
                        $("#sellPlace").html("");
                        $("#clientNameSell").html("");
                    } else if (eqpEmpInfo.status == 'no') {
                        alert("error");
                    }
                }
            });
        }
        function popupSell(proId, busObjId, projectName) {
            $('#sellDialog').bPopup({modal: false});
            $('#sellDialog').css("display", "block");
            $("#sellPlace").html(projectName);
            $("#unitIdSell").val(proId);
            $("#parentIdSell").val(busObjId);
        }
        function getClient(obj, type) {
            var clientNumber = $(obj).val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=getClientNameByNo",
                data: {
                    clientNumber: clientNumber
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'Ok') {
                        $("#clientName" + type).html(info.name);
                        $("#errorMsg" + type).html("");
                        $("#clientId" + type).val(info.id);

                    } else if (info.status == 'No') {
                        $("#errorMsg" + type).html("هذا الرقم غير صحيح");
                        $("#clientName" + type).html("");
                    }
                }
            });

        }
        function closeSellPopup(obj) {
            $("#sellDialog").bPopup().close();
            $("#sellDialog").css("display", "none");
        }
        function rentUnit() {
            var clientId = $("#clientIdRent").val();
            var unitId = document.getElementById("unitIdRent").value;
            var budget = "0";
            var period = "UL";
            var paymentSystem = "UL";
            var paymentPlace = "UL";
            var parentId = document.getElementById("parentIdRent").value;

            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=saveRentUnits",
                data: {
                    clientId: clientId,
                    unitId: unitId,
                    budget: budget,
                    period: period,
                    unitCategoryId: parentId,
                    paymentSystem: paymentSystem,
                    paymentPlace: paymentPlace,
                    issueId: parentId

                },
                success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
                        $("#rentDialog").bPopup().close();
                        $("#rentDialog").css("display", "none");
                        $("#clientIdRent").val("");
                        $("#clientCodeRent").val("");
                        $("#unitIdRent").val("");
                        $("#parentIdRent").val("");
                        $("#rentPlace").html("");
                        $("#clientNameRent").html("");
                    } else if (eqpEmpInfo.status == 'no') {
                        alert("error");
                    }
                }
            });
        }
        function popupRent(proId, busObjId, projectName) {
            $('#rentDialog').bPopup({modal: false});
            $('#rentDialog').css("display", "block");
            $("#rentPlace").html(projectName);
            $("#unitIdRent").val(proId);
            $("#parentIdRent").val(busObjId);
        }
        function closeRentPopup(obj) {
            $("#rentDialog").bPopup().close();
            $("#rentDialog").css("display", "none");
        }
        function addUnitDate() {
            if ($("input[name='unitID']:checked").length === 0) {
                alert('<fmt:message key="selectOneUnitMsg" />');
            } else {
                $('#addDateDiv').css("display", "block");
                $('#addDateDiv').bPopup({
                    easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'
                });
            }
        }
        function saveUnitDate() {
            var unitIDs = $("input[name='unitID']:checked").map(function () {
                return $(this).val();
            }).get();
            var dateType = $("#dateType").val();
            var unitTime = $("#unitTime").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/UnitServlet?op=saveMultiUnitTimeLine",
                data: {
                    unitID: unitIDs.join(","),
                    dateType: dateType,
                    unitTime: unitTime
                }, success: function (data) {
                    var jsonString = $.parseJSON(data);
                    if (jsonString.status === 'ok') {
                        alert('<fmt:message key="successSaveMsg" />');
                    } else {
                        alert('<fmt:message key="errorMultiSaveMsg" />');
                    }
                    $('#addDateDiv').css("display", "none");
                    $('#addDateDiv').bPopup().close();
                }
            });
        }

        function printProjectInformation(mainProjID) {
            document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=projectInformation&mainProjID=" + mainProjID;
            document.CLIENT_FORM.submit();
        }
        function popupAttach(obj, projectId) {
            $("#attachInfo").html("");
            $("#projectId").val(projectId);
            count = 1;
            $("#addFile2").removeAttr("disabled");
            $("#counter2").val("0");
            $("#listFile2").html("");
            $('#attachDialog').show();
            $("#attachDialog").css("display", "block");
            $('#attachDialog').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
    </script>
    
    <style>
        #element_to_pop_up { display:none; }
        .titlebar {
            background-image: url(<%=context%>/jquery-ui/themes/base/images/ui-bg_highlight-soft_75_cccccc_1x100.png);
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
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
        #row:hover{
            background-color: #EEEEEE;
        }
        .client_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addclient.png);
        }
        .company_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addCompany.png);
        }
        .enter_call {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
        .show{
            display: block;
        }
        .hide{
            display: none;
        }
        .remove{

            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);

        }
        #showHide{
            /*background: #0066cc;*/
            border: none;
            padding: 10px;
            font-size: 16px;
            font-weight: bold;
            color: #0066cc;
            cursor: pointer;
            padding: 5px;
        }
        #dropDown{
            position: relative;
        }
        .backStyle{
            border-bottom-width:0px;
            border-left-width:0px;
            border-right-width:0px;
            border-top-width:0px
        }

        .datepick {}

        .save {
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .silver_odd_main,.silver_even_main {
            text-align: center;
        }

        input { font-size: 18px; }
        textarea{
            resize:none;
        }
        .table td{
            padding:5px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            /*height:20px;*/
            border: none;
        }

        #claim_division {

            width: 97%;
            display: none;
            margin:3px auto;
            border: 1px solid #999;
        }
        #order_division{

            width: 97%;
            display: none;
            margin:3px auto;
            border: 1px solid #999;
        }
        label{
            font:Verdana, Geneva, sans-serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
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
        .table td{
            padding:5px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            border: none;
            margin-bottom: 30px;
        }
        .dropdown 
        {
            color: #555;

            /*margin: 3px -22px 0 0;*/
            width: 128px;
            position: relative;
            height: 17px;
            text-align:left;
        }
        .dropdown li a 
        {
            color: #555555;
            display: block;
            font-family: arial;
            font-weight: bold;
            padding: 6px 15px;
            cursor: pointer;
            text-decoration:none;
        }
        .dropdown li a:hover
        {
            background:#155FB0;
            color:yellow;
            text-decoration: none;
        }
        .submenux
        {

            background:#FFFFCC;
            position: absolute;
            top: 30px;
            left:0px;
            /*left: 0px;*/
            /*        z-index: 1000;*/
            width: 120px;
            display: none;
            margin-left: 0px;;
            padding: 0px 0 5px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
        }
        .submenuxx
        {

            background:#FFFFCC;
            position: absolute;
            top: 30px;
            left:30px;
            /*left: 0px;*/
            /*        z-index: 1000;*/
            width: 120px;
            display: none;
            margin-left: 0px;;
            padding: 0px 0 5px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
        }

        #call_center{
            direction:rtl;
            padding:0px;
            margin-top: 10px;
            /*        background-color: #dedede;*/
            margin-left: auto;
            margin-right: auto;
            margin-bottom: 5px;
            color:#005599;
            /*            height:600px;*/
            width:98%;
            /*position:absolute;*/
            border:1px solid #f1f1f1;
            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;

        }
        #title{padding:10px;
               margin:0px 10px;
               height:30px;
               width:95%;
               clear: both;
               text-align:center;

        }
        .text-success{
            font-family:Verdana, Geneva, sans-serif;
            font-size:24px;
            font-weight:bold;
        }

        #tableDATA th{

            font-size: 15px;
        }

        .save {
            width:32px;
            height:32px;
            background-image:url(images/icons/check.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .status{

            width:32px;
            height:32px;
            background-image:url(images/icons/status.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .remove {
            width:32px;
            height:32px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/remove.png);

        }
        .button_commx {
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            /**/
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/comm.png);
        }
        .button_attach{
            width:128px;
            height:27px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            /**/
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/attach.png);
        }
        .button_bookmar {
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/bookmark.png);
        }

        .button_redirec{
            width:132px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/redi.png);
        }

        .button_finis{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/finish.png);
        }

        .button_clos {
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
        .rejectedBtn{
            width:145px;
            height:40px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/button5.png);
        }
        .attach_button{
            width:145px;
            height:40px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/attachF.png);
        }

        .button_clientO{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/clientO.png);
            /*        background-position: top right;*/
        }.managerBt{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/manager.png);
            /*        background-position: top right;*/
        }
        .popup_conten{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 300px;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }
        .popup_content{ 
            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #dfdfdf;
            margin-bottom: 5px;
            width: 300px;
            height: 300px;
            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }

        #projectsTbl{
            width: 100%;
        }
        #projectsTbl th{
            padding: 5px;
            font-size: 16px;
            background:#f1f1f1;
            font-family: arial;


        }
        #projectsTbl td{
            font-size: 12px;
            border: none;
        }
    </style>
    <body>
        <fieldset>
            <legend>
                <b style="font-size: 25px;color: #005599;"> <%=title%> <%=prjNM%></b>
            </legend>
            <FORM NAME="CLIENT_FORM" METHOD="POST">

                <div style="width: 95%;margin-right: auto;margin-left: auto;margin-top: 20px;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 9%;"></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">المشروع</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;"> <%=model%> </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">تاريخ الانشاء</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">كود الوحده</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">المساحة</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">السعر</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">المصدر</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">اسم العميل</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">الحالة</th>

                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;">العقد</th>
                            </tr>
                        <thead>
                        <tbody >  
                            <%
                                if (units != null && !units.isEmpty()) {
                                    Enumeration e = units.elements();

                                    WebBusinessObject wbo = new WebBusinessObject();
                                    while (e.hasMoreElements()) {

                                        wbo = (WebBusinessObject) e.nextElement();
                            %>

                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <b><IMG value="" onclick="JavaScript: popupAttach(this, '<%=wbo.getAttribute("projectID")%>');" width="19px" height="19px" src="images/icons/Attach.png" title="أرفاق رسم هندسي" alt="أرفاق رسم هندسي" style="margin: -4px 0"/></b>
                                    &nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("projectID")%>');" width="19px" height="19px" src="images/unit_doc.png" title="مشاهدة ملفات الوحده" alt="مشاهدة ملفات الوحده" style="margin: -4px 0"/></b>
                                    &nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("Model_Code")%>');" width="19px" height="19px" src="images/model.png" title="مشاهدة ملفات النموذج" alt="مشاهدة ملفات النموذج" style="margin: -4px 0"/></b>
                                        <%--&nbsp;
                                        <b><IMG value="" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("mainProjId")%>');" width="19px" height="19px" src="images/units.png" title="مشاهدة ملفات الكومبوند" alt="مشاهدة ملفات الكومبوند" style="margin: -4px 0"/></b>--%>
                                    &nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewGallery('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("Model_Code")%>');" width="25px" height="25px" src="images/gallery.png" title="عرض جميع الصور" alt="عرض جميع الصور" style="margin: -4px 0"/></b>

                                </TD>
                                <TD>
                                    <%if (wbo.getAttribute("parentName") != null) {%>
                                    <b><%=wbo.getAttribute("parentName")%></b>
                                    <%} else {%>
                                    <b>لا يوجد</b>
                                    <%
                                        }
                                    %>
                                </TD>

                                <TD>
                                    <%
                                        if (wbo.getAttribute("modelName") != null) {
                                    %>
                                    <b>
                                        <%=wbo.getAttribute("modelName")%> 
                                    </b>
                                    <%
                                    } else {
                                    %>
                                    <%
                                        }
                                    %>
                                </TD>

                                <TD>
                                    <%if (wbo.getAttribute("creationTime") != null) {%>
                                    <b><%=wbo.getAttribute("creationTime").toString().split(" ")[0]%></b>
                                    <%}
                                    %>

                                </TD>
                                <TD>
                                    <%if (wbo.getAttribute("projectName") != null) {%>
                                    <a href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=wbo.getAttribute("projectID")%>&searchBy=<%=request.getAttribute("searchBy")%>&searchValue=<%=request.getAttribute("searchValue")%>&ownerID=<%=wbo.getAttribute("ownerID")%>">
                                        <b><%=wbo.getAttribute("projectName")%></b>
                                    </a>
                                    <%}
                                    %>

                                </TD>
                                <td>
                                    <b>
                                        <%
                                            if (wbo.getAttribute("totalArea") != null) {
                                        %>
                                        <%=wbo.getAttribute("totalArea")%> 
                                        <%
                                        } else {
                                            if (wbo.getAttribute("area") != null) {
                                        %>
                                        <%=wbo.getAttribute("area")%> 
                                        <%
                                                }
                                            }
                                        %>
                                    </b>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("price") != null ? df.format(Double.valueOf((String) wbo.getAttribute("price"))) : ""%></b>
                                </td>
                                <TD>
                                    <%if (wbo.getAttribute("fullName") != null) {%>
                                    <b><%=wbo.getAttribute("fullName")%></b>
                                    <%}
                                    %>

                                </TD>

                                <TD>
                                    <%if (wbo.getAttribute("clientName") != null && !((String) wbo.getAttribute("clientName")).isEmpty()) {%>
                                    <a href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wbo.getAttribute("clientId")%>&clientType=<%=wbo.getAttribute("clientType")%>">
                                        <b><%=wbo.getAttribute("clientName")%></b>
                                    </a>
                                    <a target="_blanck" href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wbo.getAttribute("clientId")%>&clientType=30-40">
                                        <img src="images/icons/eHR.gif" width="30" style="float: left;" title="تفاصيل"/>
                                    </a>
                                    <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientId")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="بيانات العميل"/>
                                    </a>

                                    <a style="display: <%=userPrevList.contains("BRCKR_ICN") ? "" : "none"%>" target="_blanck" href="<%=context%>/ClientServlet?op=newBokerClient&projectID=<%=wbo.getAttribute("projectID")%>&ownerID=<%=wbo.getAttribute("ownerID")%>&unitName=<%=wbo.getAttribute("projectName")%>">
                                        <%if (wbo.getAttribute("ownerID") != null) {%>
                                        <img src="images/icons/manager.png" width="30" style="float: left;" title="مالك وحدة"/>
                                        <%} else {%>
                                        <img src="images/notOwner.png" width="30" style="float: left;" title="مالك وحدة"/>
                                        <%}%>
                                    </a>
                                    <%} else {
                                    %>

                                    <b>لا يوجد</b>
                                    <%
                                        }
                                    %>
                                </TD>
                                <TD onclick="getDetails(<%=wbo.getAttribute("projectID")%>)">

                                    <%
                                        String UniStatus = "", color = "";
                                        String unitStatus = (String) wbo.getAttribute("statusName");
                                        if (wbo.getAttribute("statusName") != null) {

                                            if (unitStatus.equalsIgnoreCase("8")) {
                                                UniStatus = "متاحة";
                                                color = "green";
                                            } else if (unitStatus.equalsIgnoreCase("9")) {
                                                UniStatus = "محجوزة";
                                                color = "red";
                                            } else if (unitStatus.equalsIgnoreCase("10")) {
                                                UniStatus = "مباعة";
                                                color = "blue";
                                            } else if (unitStatus.equalsIgnoreCase("33")) {
                                                UniStatus = "حجز مرتجع";
                                                color = "purple";
                                            }
                                        }%>
                                    <b style="color: <%=color%>"><%=UniStatus%></b>

                                </TD>

                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;">
                                    <%
                                        if (unitStatus.equalsIgnoreCase("10")) {
                                    %>
                                    <a href="JavaScript: <%=wbo.getAttribute("documentID") != null ? "viewClientContract('" + wbo.getAttribute("clientId") + "')" : "alert('لا يوجد عقد مرفق')"%>;">
                                        <img src="images/<%=wbo.getAttribute("documentID") != null ? "contract_icon.jpg" : "no_contract.png"%>" style="height: 30px" title="العقد"/>
                                    </a>
                                    <%
                                        }
                                    %>
                                </TD>
                                <%
                                    }
                                %>
                            </tr>
                        </tbody> 
                        <tfoot>
                            <tr>
                                <th colspan="5">
                                    &nbsp;
                                </th>
                                <th style="font-size: 16px; font-weight: bolder;">
                                    إجمالي السعر
                                </th>
                                <th style="font-size: 16px; font-weight: bolder;">
                                    <%=request.getAttribute("totalPrice") != null ? df.format(Double.valueOf((String) request.getAttribute("totalPrice"))) : "0"%>
                                </th>
                                <th colspan="4">
                                    &nbsp;
                                </th>
                            </tr>
                        </tfoot>

                    </TABLE>
                    <BR />
                </div>
                <%
                } else {%>   
                <%}%>
            </FORM>
        </fieldset>
        <div id="attachDialog"  style="width: 30%;display: none;position: fixed;margin-left: auto;margin-right: auto">
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeAttachPopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <form id="attachForm" action="<%=context%>/UnitDocWriterServlet?op=saveMultiFiles" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable>إرفاق رسم هندسي</lable>
                        <input type="button" id="addFile2" onclick="addFiles2(this)" value="+" />

                        <input id="counter2" value="" type="hidden" name="counter"/>
                        <input id="projectId" name="projectId" value="" type="hidden" />
                        </td>
                        <td style="text-align:right;width: 70%;" id="listFile2"> 
                        </td>
                        </tr>
                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="status"></div>
                    <div id="attachInfo" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <input type="submit" value="تحميل"  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendFilesByAjax(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
        <div id="unitInformation"   style="width: 70% !important;display: none;position: fixed ;">

        </div>
    </body>
</html>
