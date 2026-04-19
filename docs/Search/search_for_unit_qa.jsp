<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
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
<fmt:setBundle basename="Languages.Units.Units"  />

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    Vector<WebBusinessObject> paymentPlace = (Vector) request.getAttribute("paymentPlace");
    String messageFlag = (String) request.getAttribute("messageFlag");
    String stat = (String) request.getSession().getAttribute("currentMode");
    ArrayList<WebBusinessObject> bokersList = (ArrayList<WebBusinessObject>) request.getAttribute("bokersList");
    String searchBy = (String) request.getAttribute("searchBy");
    if(searchBy == null) {
        searchBy = "unitNo";
    }

    String status = (String) request.getAttribute("status");

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
    String[] tableHeader = new String[4];
    String align, dir, style, sTitle, message, model;
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
        model = " Model ";
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
        model = " النموذج ";
    }

    String untStsExlRprt = request.getAttribute("untStsExlRprt") != null ? (String) request.getAttribute("untStsExlRprt") : "";
%>
    
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <link rel="stylesheet" href="css/chosen.css"/>
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.12.1.js"></script>
        <script src="js/select2.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
    </HEAD>
    
    <script type="text/javascript">
        var oTable;
        var users = new Array();
        $(document).ready(function() {
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
            
            $("#unitTime").datepicker({
                changeMonth: true,
                changeYear: true,
                minDate: new Date(),
                dateFormat: "yy/mm/dd",
                defaultDate: new Date()
            });
            
            $("#unitTime").datepicker("setDate", new Date());
        });

        $(function() {
            $("input[name=search]").change(function() {
                var value = $("input[name=search]:checked").attr("id");
                if (value === 'buildingCode') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "كود العمارة ");
                    //                alert(searchByValue);
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");

                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                } else if (value === 'unitNo') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "كود الوحدة / المشروع");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#msgNa").html("");
                    $("#info").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                }
            })

        });
        
        function clearAlert() {
            $("#msgT").html("");
            $("#msgM").html("");
            $("#msgNo").html("");
            $("#info").html("");
            $("#msgNa").html("");
            $("#searchValue").css("border", "");
            $("#showClients").css("display", "none");
        }
        
        function getClientInfo2(obj) {
            var searchByValue = '';
            var value = $(obj).parent().parent().parent().parent().find("input[name=search]:checked").attr("id");
            $("#info").html("");
            if ($(obj).parent().find("#searchValue").val().length > 0) {
                if (value == 'unitNo') {
                    searchByValue = $(obj).parent().parent().find("#searchValue").val();
                } else {
                    searchByValue = $(obj).parent().parent().find("#searchValue").val();

                }
                
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForUnitQA&searchBy=" + value + "&searchByValue=" + searchByValue;
                document.CLIENT_FORM.submit();
                $("#clients").css("display", "");
                $("#showClients").val("show");
            } else {
                if(value == 'unitNo'){
                    document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=SearchForAllUnits";
                    document.CLIENT_FORM.submit();
                }else{
                    $("#info").html("أدخل محتوى البحث");
                    $("#searchValue").focus();
                    $("#searchValue").css("border", "1px solid red");
                }
            }
        }
        
        function submitForm(){
            document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchSPInSchedule";
            document.CLIENT_FORM.submit();
        }

        function cancelForm(){
            document.CLIENT_FORM.action = "main.jsp";
            document.CLIENT_FORM.submit();
        }

        function createComplaint(clientId, age) {
            //            var clientId = $("#clientId").val();
            if (clientId == null || clientId == "") {
                $("#errorMsg").css("display", "block");
            } else {
                document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=" + clientId + "&clientType=" + age;
                document.CLIENT_FORM.submit();
            }
        }
        
        function createComplaints(obj, clientType) {
            document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=" + obj + "&clientType=" + clientType;
            document.CLIENT_FORM.submit();
        }
        
        function newClient() {
            document.CLIENT_FORM.action = "<%=context%>/ClientServlet?op=GetClientForm";
            document.CLIENT_FORM.submit();
        }
        
        function newCompany() {
            document.CLIENT_FORM.action = "<%=context%>/ClientServlet?op=GetCompanyForm";
            document.CLIENT_FORM.submit();
        }
        
        function createComplaint2() {
            var clientId = $("#clientId").val();
            document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=mail&clientId=" + clientId;
            document.CLIENT_FORM.submit();
        }

        function createComplaint3() {
            var clientId = $("#clientId").val();
            document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newComplaint&type=visit&clientId=" + clientId;
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
            $('#attachDialog').bPopup({
                easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
        
        function viewDocuments(parentId) {
            var url='<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId +'';
            var wind = window.open(url,"عرض المستندات","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }
        
        function viewGallery(unitID, modelID) {
            var url='<%=context%>/UnitDocReaderServlet?op=unitDocGallery&unitID=' + unitID +'&modelID=' + modelID;
            var wind = window.open(url,"عرض المستندات","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
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
            $("#attachForm").submit(function(e){
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
                    success: function(data, textStatus, jqXHR){
                        $("#progressx").html('');
                        $("#progressx").css("display", "none");
                    }, complete: function(response){
                        $("#attachInfo").html("<font color='white'>تم رفع الملفات</font>");

                    }, error: function(){
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
            $('#unitInformation').bPopup({
                easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
        
        function popup(proId, busObjId, projectName) {
            $('#reserveDialog').bPopup({modal: true});
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
                }, success: function(jsonString) {
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
            var brokerID=document.getElementById("brokerID").value;
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
                    issueId: parentId,
                    brokerID:brokerID
                }, success: function(jsonString) {
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
                        $("#parentId").val("");
                        $("#reservedPlace").html("");
                        $("#clientName").html("");
                        $("#brokerID").val("");
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
            var notes = document.getElementById("sellNotes").value;
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
                    issueId: parentId,
                    notes: notes
                }, success: function(jsonString) {
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
                        $("#sellNotes").val("");
                        location.reload();
                    } else if (eqpEmpInfo.status == 'no') {
                        alert("error");
                    }
                }
            });
        }
        
        function popupSell(proId, busObjId, projectName) {
            $('#sellDialog').bPopup({modal: true});
            $('#sellDialog').css("display", "block");
            $("#sellPlace").html(projectName);
            $("#unitIdSell").val(proId);
            $("#parentIdSell").val(busObjId);
        }
        
        function getClient(obj, type) {
            var clientNumber = $("#clientCode" + type).val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=getClientNameByNo",
                data: {
                    clientNumber: clientNumber
                }, success: function(jsonString) {
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
                }, success: function(jsonString) {
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
            $('#rentDialog').bPopup({modal:false});
            $('#rentDialog').css("display", "block");
            $("#rentPlace").html(projectName);
            $("#unitIdRent").val(proId);
            $("#parentIdRent").val(busObjId);
        }
        
        function closeRentPopup(obj) {
            $("#rentDialog").bPopup().close();
            $("#rentDialog").css("display", "none");
        }
        function openSearch(obj)
        {
            if(obj.name==="bSell")
            { //  document.getElementById("treatType").value="1";
                $('#treatType').val("1");
                 getDataInPopup('ClientServlet?op=getClientsPopup&value=' + $("#clientCodeSell").val());
            }
         else  if(obj.name==="bReserv")
         {
              $('#treatType').val("2");
             getDataInPopup('ClientServlet?op=getClientsPopup&value=' + $("#clientCode").val());
         }
         else
         {
               $('#treatType').val("3");
             getDataInPopup('ClientServlet?op=getClientsPopup&value=' + $("#clientCodeRent").val());
             
         }
        }
        function addUnitDate() {
            if($("input[name='unitID']:checked").length === 0) {
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
                },success: function (data){
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
        
        function exportToExcel() {
	    var unitStatus = $('input[name=unitStatus]:checked').val();
            
	    var url = "<%=context%>/SearchServlet?op=SearchForAllUnits&excel=1&unitStatus=" + unitStatus;
	    window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=350, height=350");
	}
        function getReserveSellUser(obj, unitID, type) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=getReserveSellUserAjax",
                data: {
                    unitID: unitID,
                    type: type
                }, success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status === 'ok') {
                        $(obj).attr("title", "بواسطة: " + info.fullName);
                    }
                }
            });
        }
    </SCRIPT>
    
    <style>
        #element_to_pop_up {
            display: none;
        }
        
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

        input {
            font-size: 18px;
        }
        
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
        
        .dropdown{
            color: #555;

            /*margin: 3px -22px 0 0;*/
            width: 128px;
            position: relative;
            height: 17px;
            text-align:left;
        }
        
        .dropdown li a{
            color: #555555;
            display: block;
            font-family: arial;
            font-weight: bold;
            padding: 6px 15px;
            cursor: pointer;
            text-decoration:none;
        }
        
        .dropdown li a:hover {
            background:#155FB0;
            color:yellow;
            text-decoration: none;
        }
        
        .submenux{
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
        
        .submenuxx{
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
        
        #title{
            padding:10px;
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
        }
        
        .managerBt{
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
        
        .toolBox {
            width:45px;
            height: 40px;
            float:right;
            margin: 0px;
            padding: 0px;
            border: 1px solid black;
        }
        
        .toolBox a img {
            width: 40px important;
            height: 40px important;
            float: right;
            margin: 0px;
            padding: 0px;
            text-align: right;
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
    </style>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="display:none;width: 310px;margin-top: 10px;margin-left: auto;margin-right: auto;height: 20px;background-color: #f3f3f5;" id="errorMsg">
                    <FONT style="color: red;font-size: 16px;"><b>يجب أولا إختيار عميل</B></font>
                </div>
                <BR>
                <div style="width: 100%;">
                    <FIELDSET class="set" style="width:85%;border-color: #006699" >
                        <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                            <tr>
                                <td width="100%" class="titlebar">
                                    <font color="#005599" size="4"><%=sTitle%></font>
                                </td>
                            </tr>
                        </table>
                        <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                            <TR>
                                <TD style="border: none" width="50%">
                                    <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER">
                                        <tr>
                                            <td STYLE="<%=style%>" class='td'>
                                                <LABEL style="font-size: 20px;">بحث بـــ : </LABEL>
                                                <span><input type="radio" name="search" value="unitNo" id="unitNo" <%=searchBy.equalsIgnoreCase("unitNo")?"checked":""%>  />  <font size="2"  color="#000"><b>كود الوحده / المشروع </b></font></span>
                                                <span><input type="radio" name="search" value="buildingCode" id="buildingCode" <%=searchBy.equalsIgnoreCase("buildingCode") ? "checked" : ""%> /><font size="2" color="#000"><b> كود العمارة </b></font></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td STYLE="<%=style%>" class='td'></td></tr>
                                        <tr>
                                            <td STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto" id="te">
                                                    <input type="button" value="بحث" style="display: inline" class="" width="150px" onclick="getClientInfo2(this)"/>
                                                    <input type="text" name="searchValue" id="searchValue" placeholder="<%=searchBy.equalsIgnoreCase("unitNo") ? "كود الوحدة / المشروع" : "كود العمارة "%>" onkeyup="clearAlert()" onkeypress="clearAlert()"onblur="getClientInfo2(this)"/>
                                                    
                                                </div>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 96%;margin-left: auto;margin-right: auto">
                                                    <LABEL id="msgM" style="color: red;"></LABEL>
                                                    <LABEL id="msgT" style="color: red;"></LABEL>
                                                    <LABEL id="msgNo" style="color: red;"></LABEL>
                                                    <LABEL id="info" style="color: green;"></LABEL>
                                                        <%if (status != null && status.equals("error")) {%>
                                                    <LABEL id="msgNa" style="color: red;">إسم العميل غير موجود</LABEL>
                                                        <%} else {%>
                                                        <%}%>
                                                </div>
                                            </td>

                                        </tr>
                                    </TABLE>
                                </TD>
                                <TD style="border: none" align="right" width="50%">
                                    <img alt="Database Configuration" src="images/housing_unit.jpg" width="190" style="border: none; vertical-align: middle;" />
                                </TD>
                            </TR>
                        </TABLE>
                        <% if (messageFlag != null) {%>
                        <center>
                            <table  dir="<%=dir%>">
                                <tr>
                                    <td class="td"  align="<%=align%>">
                                        <H4><font color="red"><%=message%></font></H4>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                        </center>
                        <% } %>
                    </FIELDSET>
                    <br />
                </div>

                <%if (units != null && !units.isEmpty()) {%>
                
                <table style="direction: <%=dir%>; width: 60%; padding-bottom: 2%; padding-top: 2%; margin-bottom: 2%; margin-top: 2%;">
                        <tr>
                            <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                                <input type="radio" name="unitStatus" value="" <%=untStsExlRprt != null && untStsExlRprt.equals("") ? "checked" : ""%>>  
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                                <font size=3 color="white">
                                     الكل 
                            </td>
                            
                            <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                                <input type="radio" name="unitStatus" value="8" <%=untStsExlRprt != null && untStsExlRprt.equals("8") ? "checked" : ""%>>
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                                <font size=3 color="white">
                                     متاحة 
                            </td>
                            
                            <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                                <input type="radio" name="unitStatus" value="9" <%=untStsExlRprt != null && untStsExlRprt.equals("9") ? "checked" : ""%>>
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                                <font size=3 color="white">
                                     محجوزة 
                            </td>

                            <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                                <input type="radio" name="unitStatus" value="10" <%=untStsExlRprt != null && untStsExlRprt.equals("10") ? "checked" : ""%>>  
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                                <font size=3 color="white">
                                     مباعة 
                            </td>
                            
                            <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                                <input type="radio" name="unitStatus" value="33" <%=untStsExlRprt != null && untStsExlRprt.equals("33") ? "checked" : ""%>> 
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                                <font size=3 color="white">
                                     حجز مرتجع 
                            </td>
                            
                            <td bgcolor="#F7F6F6" style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; text-align:center; width: 30%; border: none;" valign="middle" rowspan="2">
                                <input class="button" class="button2" type="button" onclick="exportToExcel();" style="width: 50%; color: #27272A; font-size:15; font-weight:bold;" value="Excel">
                                 
                            </td>
                        </tr>
                    </table>
                <br />
                <table  border="0px" dir='<fmt:message key="direction"/>' align='center' >
                    <tr>
                        <td class="td" style="text-align: center;">
                            <div class="toolBox" style="padding: 2px 2px 2px 0px;">
                                <image style="height:39px; cursor: hand;" src="images/icons/history.png" onclick="JavaScript: addUnitDate();" title='<fmt:message key="addDate"/>'/>
                            </div>
                        </td>
                    </tr>
                </table>
                <br />
                <div style="width: 95%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 7%;"></th>
                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 7%;"></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">المشروع</th>
				<th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;"> <%=model%> </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">تاريخ الانشاء</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">كود الوحده</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">المساحة</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">السعر</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">المصدر</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">اسم العميل</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">الحالة</th>
                                <%
                                    if (metaMgr.getDataMigration().equals("1")) {
                                        if (userPrevList.contains("RESERVE_UNIT")) {
                                %>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">حجز</th>
                                    <%
                                        }
                                        if (userPrevList.contains("SELL_UNIT")) {
                                    %>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">بيع</th>
                                    <%
                                        }
                                        if (userPrevList.contains("RENT_UNIT")) {
                                    %>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 7%;">أيجار</th>
                                <%
                                        }
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody >  
                            <%

                                Enumeration e = units.elements();

                                WebBusinessObject wbo = new WebBusinessObject();
                                String type = "";
                                while (e.hasMoreElements()) {
                                    
                                    wbo = (WebBusinessObject) e.nextElement();
                            %>

                            <tr style="cursor: pointer" id="row">
                                <td>
                                    <input type="checkbox" name="unitID" value="<%=wbo.getAttribute("projectID")%>" />
                                </td>
                                <TD>
                                    <b><IMG value="" onclick="JavaScript: popupAttach(this, '<%=wbo.getAttribute("projectID")%>');" width="19px" height="19px" src="images/icons/Attach.png" title="أرفاق رسم هندسي" alt="أرفاق رسم هندسي" style="margin: -4px 0"/></b>
                                    &nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("projectID")%>');" width="19px" height="19px" src="images/unit_doc.png" title="مشاهدة ملفات الوحده" alt="مشاهدة ملفات الوحده" style="margin: -4px 0"/></b>
                                    &nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("Model_Code")%>');" width="19px" height="19px" src="images/model.png" title="مشاهدة ملفات النموذج" alt="مشاهدة ملفات النموذج" style="margin: -4px 0"/></b>
                                    <%--&nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("mainProjId")%>');" width="19px" height="19px" src="images/units.png" title="مشاهدة ملفات الكومبوند" alt="مشاهدة ملفات الكومبوند" style="margin: -4px 0"/></b>--%>
                                    &nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewGallery('<%=wbo.getAttribute("projectID")%>','<%=wbo.getAttribute("Model_Code")%>');" width="25px" height="25px" src="images/gallery.png" title="عرض جميع الصور" alt="عرض جميع الصور" style="margin: -4px 0"/></b>
                                    
                                </TD>
                                <TD>
                                    <%if(wbo.getAttribute("parentName") != null){%>
                                    <b><%=wbo.getAttribute("parentName")%></b>
                                    <%}else{%>
                                      <b>لا يوجد</b>
                                      <%
                                    }
                                    %>
                                </TD>
				
				<TD>
                                    <%
					if(wbo.getAttribute("modelName") != null){
				    %>
					    <b>
						 <%=wbo.getAttribute("modelName")%> 
					    </b>
                                    <%
					}else{
				    %>
                                    <%
					}
                                    %>
                                </TD>
				
                                <TD>
                                    <%if (wbo.getAttribute("creationTime") != null) {%>
                                        <b><%=wbo.getAttribute("creationTime")%></b>
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
					    
					    if(wbo.getAttribute("totalArea") != null){
					%>
						 <%=wbo.getAttribute("totalArea")%> 
					<% 
					    } else {
						if(wbo.getAttribute("area") != null){
					%>
						     <%=wbo.getAttribute("area")%> 
				        <%
						}
					    }
					%>
				    </b>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("price") != null ? wbo.getAttribute("price") : ""%></b>
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
                                    <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientId")%>">
                                            <img src="images/client_details.jpg" width="30" style="float: left;" title="بيانات العميل"/>
                                        </a>
                                         <a target="_blanck" href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wbo.getAttribute("clientId")%>&clientType=30-40">
                                            <img src="images/icons/eHR.gif" width="30" style="float: left;" title="تفاصيل"/>
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
                                                type = "";
                                            } else if (unitStatus.equalsIgnoreCase("9")) {
                                                UniStatus = "محجوزة";
                                                color = "red";
                                                type = "reserved";
                                            } else if (unitStatus.equalsIgnoreCase("10")) {
                                                UniStatus = "مباعة";
                                                color = "blue";
                                                type = "purche";
                                            } else if (unitStatus.equalsIgnoreCase("33")) {
                                                UniStatus = "حجز مرتجع";
                                                color = "purple";
                                                type = "";
                                            } else if (unitStatus.equalsIgnoreCase("61")) {
                                                UniStatus = "مؤجرة";
                                                color = "brown";
                                                type = "";
                                            }
                                        }%>
                                        <b style="color: <%=color%>" onmouseover="<%=unitStatus.equals("9") || unitStatus.equals("10") ? "JavaScript: getReserveSellUser(this, '" + wbo.getAttribute("projectID") + "', '" + type + "')" : ""%>"><%=UniStatus%></b>

                                </TD>
                                <%
                                    if (metaMgr.getDataMigration().equals("1")) {
                                        if (userPrevList.contains("RESERVE_UNIT")) {
                                            if (unitStatus != null && unitStatus.equalsIgnoreCase("8")) {
                                %>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" >
                                    <a id="reservedBtn" onclick="popup('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("mainProjId")%>', '<%=wbo.getAttribute("projectName")%>')" href="#">حجز </a>
                                </TD>
                                <%} else {%>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;">

                                </TD>
                                <%}
                                        }
                                        if (userPrevList.contains("SELL_UNIT")) {
                                %>
                                <%if (unitStatus != null && !unitStatus.equalsIgnoreCase("10") && !unitStatus.equalsIgnoreCase("61")) {%>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" >
                                    <a id="reservedBtn" onclick="popupSell('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("mainProjId")%>', '<%=wbo.getAttribute("projectName")%>')" href="#">بيع </a>
                                </TD>
                                <%} else {%>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;">

                                </TD>
                                <%
                                            }
                                        }
                                        if (userPrevList.contains("RENT_UNIT")) {
                                            if (unitStatus != null && unitStatus.equalsIgnoreCase("8")) {%>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" >
                                    <a id="reservedBtn" onclick="popupRent('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("mainProjId")%>', '<%=wbo.getAttribute("projectName")%>')" href="#">أيجار </a>
                                </TD>
                                <%} else {%>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;">

                                </TD>
                                <%
                                            }
                                        }
                                    }
                                %>
                            </tr>


                            <% } %>

                        </tbody>  

                    </TABLE>
                    <BR />
                </div>
                <%
                } else {%>   
                <%}%>
            </div>
        </FORM>
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
        <div id="reserveDialog" style="width: 35%;display: none;position: fixed;margin-left: auto;margin-right: auto" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeReservePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">حجز وحدة</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول المبيعات</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">كود الوحدة</td>
                        <td width="70%"style="text-align:right;"><b id="reservedPlace"></b>
                            <input type="hidden" id="unitId" name="unitId"/>
                            <input type="hidden" id="parentId" name="parentId"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">رقم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientCode"  style='width:170px;float: right;' onkeyup="saveOrder(this)"/>
                                <input type="button" onclick="JavaScript: openSearch(this);" name ="bReserv" value="بحث" />
                                <div style="color: red;width: 80px;"><b  id="errorMsgReserve"></b></div>

                            </div>
                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">إسم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientName" style="float: right;"></b>
                        </td>
                    </tr>

                      <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>الوسيط</td>
                        <td width="70%"style="text-align:right;">
                            <select id="brokerID" name="brokerID" style="width:170px;" class="chosen-select-broker">
                                <option value=""></option>
                                <sw:WBOOptionList wboList="<%=bokersList%>" displayAttribute="fullName" valueAttribute="userId" />
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مدة الحجز (بالساعة)</td>
                        <td width="70%"style="text-align:right;">
                            <input type="number" size="7" maxlength="7" id="period" name="period" style='width:170px;'
                                   <%=metaMgr.getReservationDefaultPeriod() != null && !"".equals(metaMgr.getReservationDefaultPeriod()) && !"0".equals(metaMgr.getReservationDefaultPeriod()) && !userPrevList.contains("EDIT_RESERVE_PERIOD") ? "readonly" : ""%>
                                   value="<%=metaMgr.getReservationDefaultPeriod() != null && !"".equals(metaMgr.getReservationDefaultPeriod()) && !"0".equals(metaMgr.getReservationDefaultPeriod()) ? metaMgr.getReservationDefaultPeriod() : ""%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">مقدم الحجز</td>
                        <td width="70%"style="text-align:right;">
                            <input type="number" size="7" maxlength="7" id="budget" name="budget" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">نظام الدفع</td>
                        <td width="70%"style="text-align:right;">
                            <select name="paymentSystem" id="paymentSystem" style='width:170px;font-size:16px;'>
                                <option value="فورى">فورى</option>
                                <option value="تقسيط">تقسيط</option>
                            </select>
                        </td>
                    </tr> 
                    <tr style="display: none;">
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">مكان الدفع</td>
                        <td width="70%"style="text-align:right;">
                            <input type="hidden" size="30" id="paymentPlace" name="paymentPlace" maxlength="30" width="200" value="UL"/>
                            <!--SELECT name='paymentPlace' id='paymentPlace' style='width:170px;font-size:16px;'>
                                <!%if (paymentPlace != null && !paymentPlace.isEmpty()) {

                                %>
                                <!%for (WebBusinessObject Wbo : paymentPlace) {
                                        String productName = (String) Wbo.getAttribute("projectName");
                                        String productId = (String) Wbo.getAttribute("projectID");%>
                                <option value='<!%=productName%>'><!%=productName%></option>

                                <!%}
                            } else {%>
                                <option>لم يتم العثور على فروع</option>
                                <!%}%>
                            </select-->
                        </td>
                    </tr>



                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input type="submit" value="حجز الأن" onclick="javascript: reservedUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
        <div id="sellDialog" style="width: 35%;display: none;position: fixed;margin-left: auto;margin-right: auto" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeSellPopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">بيع وحدة (سابقة)</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول المبيعات</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">كود الوحدة</td>
                        <td width="70%"style="text-align:right;"><b id="sellPlace"></b>
                            <input type="hidden" id="unitIdSell" name="unitIdSell"/>
                            <input type="hidden" id="parentIdSell" name="parentIdSell"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">رقم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientCodeSell"  style='width:170px;float: right;' onkeyup="getClient(this, 'Sell')"/>
                                 <input type="button" onclick="JavaScript: openSearch(this);" name ="bSell" value="بحث"  />
                                 <input type="hidden" id="treatType" name="treatType" value="0"/>
                                <div style="color: red;width: 80px;"><b  id="errorMsgSell"></b></div>

                            </div>
                        </td>
                     <!--   <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">رقم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientCode"  style='width:170px;float: right;' onkeyup="saveOrder(this)"/>
                                <input type="button" onclick="JavaScript: openSearch();" value="بحث" />
                                <div style="color: red;width: 80px;"><b  id="errorMsgReserve"></b></div>

                            </div>
                        </td>


                    </tr>-->
                    


                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">إسم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientNameSell" style="float: right;"></b>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>ملاحظات</td>
                        <td width="70%"style="text-align:right;">
                            <textarea id="sellNotes" name="sellNotes" style="width: 250px; height: 100px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="clientIdSell" name="clientId"/>
                            <input type="submit" value="بيع" onclick="javascript: sellUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
        <div id="rentDialog" style="width: 35%;display: none;position: fixed;margin-left: auto;margin-right: auto" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeRentPopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">أيجار وحدة</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول الشركة</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">كود الوحدة</td>
                        <td width="70%"style="text-align:right;"><b id="rentPlace"></b>
                            <input type="hidden" id="unitIdRent" name="unitIdRent"/>
                            <input type="hidden" id="parentIdRent" name="parentIdRent"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">رقم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientCodeRent"  style='width:170px;float: right;' onkeyup="getClient(this, 'Rent')"/>
                                <input type="button" onclick="JavaScript: openSearch(this);" name ="bRent" value="بحث"  />
                                <div style="color: red;width: 80px;"><b  id="errorMsgRent"></b></div>

                            </div>
                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">إسم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientNameRent" style="float: right;"></b>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="clientIdRent" name="clientId"/>
                            <input type="submit" value="أيجار" onclick="javascript: rentUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
        <div id="addDateDiv" style="width: 50% !important;display: none;position: fixed">
            <div style="clear: both;margin-left: 80%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" 
                    style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                    -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                    box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                    -webkit-border-radius: 100px;
                    -moz-border-radius: 100px;
                    border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 60%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <h1 align="center" style="vertical-align: middle"> <fmt:message key="addDate"/></h1>
                <table class="table" id="DateTbl">
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="date"/> </td>
                    <td style="text-align:right">
                        <input id="unitTime" type="text" style="width: 190px;" value="" readonly/>
                    </td>
                    </tr>
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="type"/> </td>
                    <td td style="text-align:right" id="dateTypeTD">
                        <select id="dateType" name="dateType" STYLE="width: 190px;font-size: medium; font-weight: bold;">
                            <option value="تاريخ التسليم">تاريخ التسليم</option>
                            <option value="تاريخ دخول الكهرباء">تاريخ دخول الكهرباء</option>
                            <option value="تاريخ دخول عداد المياة">تاريخ دخول عداد المياة</option>
                            <option value="تاريخ أبتدائي">تاريخ أبتدائي</option>
                            <option value="تاريخ العقد النهائي">تاريخ العقد النهائي</option>
                        </select>
                    </td>
                    </tr>
                </table>
                <div style="text-align: left;margin-left: 2%;margin-right: auto;" >
                    <button type="button" onclick="javascript: saveUnitDate();" style="font-size: 14px; font-weight: bold; width: 150px"> <fmt:message key="save"/></button>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg"> <fmt:message key="saved"/> </div>
            </div>
        </div>
        <script>
            var config = {
                '.chosen-select-broker': {no_results_text: 'No broker found with this name!', width: "170px"},
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </BODY>
</HTML>     
