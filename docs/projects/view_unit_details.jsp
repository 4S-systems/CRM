<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Units.Units"  />

    <head>
        <title></title>
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <script type="text/javascript" src="js/jquery.carouFredSel-6.2.0.js"></script>
        <script type="text/javascript" src="js/jquery.transit.min.js"></script>
        <script type="text/javascript" src="js/jquery.mousewheel.min.js"></script>
        
        <script type="text/javascript" src="js/jquery-ui-1.12.1.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">  
        <link rel="stylesheet" type="text/css" href="js/w2ui/w2ui-1.5.rc1.min.css" />  
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <!--*new added 
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.position.js"></script>-->

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>

        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="js/w2ui/w2ui-1.5.rc1.min.js"></script>
        
        <script>
            $(document).ready(function() {
                
                 $('#levelID').hide();
                   
        $('#levelID').change(function() {
            var lvlSelected= $("#levelID option:selected").text();
            $('#levelName').text(lvlSelected);
           $('#levelName').toggle();
             $('#levelID').toggle();
             editProject('unitlevel');
             
         });
                $('#timeLine').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
                $('#addOnsTable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
               
            });
             
            
        </script>
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        HttpSession s = request.getSession();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String loggedUser = (String) waUser.getAttribute("userId");
        WebBusinessObject unitWbo = (WebBusinessObject) request.getAttribute("unitWbo");
        WebBusinessObject statusWbo = (WebBusinessObject) request.getAttribute("statusWbo");
        WebBusinessObject unitPriceWbo = (WebBusinessObject) request.getAttribute("unitPriceWbo");
        WebBusinessObject modelWbo = (WebBusinessObject) request.getAttribute("modelWbo");
        WebBusinessObject archDetailsWbo = (WebBusinessObject) request.getAttribute("archDetailsWbo");
        WebBusinessObject buildingWbo = (WebBusinessObject) request.getAttribute("buildingWbo");
        WebBusinessObject projectWbo = (WebBusinessObject) request.getAttribute("projectWbo");
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        ArrayList<WebBusinessObject> modelsList = request.getAttribute("modelsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("modelsList") : new ArrayList<WebBusinessObject>();
        ArrayList<WebBusinessObject> unitAddonsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitAddonsList");
        String statusName = statusWbo != null ? (String) statusWbo.getAttribute("statusName") : "";

        String ownerId = (String) request.getAttribute("ownerID");
        String projectId = (String) request.getAttribute("projectID");

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo1;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo1 = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo1.getAttribute("prevCode"));
        }
        
        String levelN=(String)request.getAttribute("levelN")==null?"not Specific":(String)request.getAttribute("levelN"); 
        //String unitRentType= unitPriceWbo != null ? (String)unitPriceWbo.getAttribute("option2") : "UL";
        String unitRentType = unitWbo != null && unitWbo.getAttribute("newCode") != null ? (String) unitWbo.getAttribute("newCode") : "UL";
        String unitStatusImage = "";
        String unitStatusTtile = "";
        boolean displayEditPriceArea = false;
        if (statusWbo != null && statusWbo.getAttribute("statusName") != null) {
            if (statusName.equalsIgnoreCase("8")) {
                unitStatusImage = "available_house.JPG";
                unitStatusTtile = "Available";
            } else if (statusName.equalsIgnoreCase("9")) {
                unitStatusImage = "reserved_house.JPG";
                unitStatusTtile = "Reserved";
            } else if (statusName.equalsIgnoreCase("10")) {
                unitStatusImage = "house.JPG";
                unitStatusTtile = "Sold";
                displayEditPriceArea = false;
            } else if (statusName.equalsIgnoreCase("33")) {
                unitStatusImage = "reserved_house.JPG";
                unitStatusTtile = "حجز مرتجع";
            }
        }
        String stat = (String) request.getSession().getAttribute("currentMode");
        Vector imagePath = (Vector) request.getAttribute("imagePath");
        Vector imagesPathModel = (Vector) request.getAttribute("imagesPathModel");
        String fromPage = (String) request.getAttribute("fromPage");
        String url = context + "/SearchServlet?op=searchForUnitQA&searchBy=" + request.getAttribute("searchBy") + "&searchValue=" + request.getAttribute("searchValue");
        if (fromPage != null) {
            if (fromPage.equalsIgnoreCase("listApartment")) {
                url = context + "/UnitServlet?op=listApartments";
            } else if (fromPage.equalsIgnoreCase("listAvailableApartments")) {
                String fromDate = request.getParameter("fromDate");
                String toDate = request.getParameter("toDate");
                url = context + "/UnitServlet?op=listAvailableApartments&fromDate=" + fromDate + "&toDate=" + toDate;
            } else if (fromPage.equalsIgnoreCase("getUnitsDetailsReport")) {
                url = context + "/UnitServlet?op=getUnitsDetailsReport";
            }
        }

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        ArrayList<WebBusinessObject> prevList = securityUser.getComplaintMenuBtn();
        boolean displayEdit = false;
        for (WebBusinessObject prevWbo : prevList) {
            if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("EDIT_NAME")) {
                displayEdit = true;
            }

            if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("EDIT_UNIT_PRICE")) {
                displayEditPriceArea = true;
            }
        }

        String none, sendEmail, successMsg, failMsg;

        if (stat.equals("En")) {

            none = "None";
            sendEmail = "Send Email";
            successMsg = "Message Sent Successfully";
            failMsg = "Fail to Send Message";

        } else {

            none = "لا يوجد";
            sendEmail = "أرسال رسالة ألكترونية";
            successMsg = "تم أرسال الرسالة";
            failMsg = "لم يتم أرسال الرسالة";
        }

        Calendar calendar = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(calendar.getTime());
        calendar.add(Calendar.YEAR, 1);
        int currentDay = calendar.get(Calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(Calendar.YEAR);
        int currentMonth = calendar.get(Calendar.MONTH);

        ArrayList<WebBusinessObject> timeLine = new ArrayList<WebBusinessObject>();
        timeLine = (ArrayList<WebBusinessObject>) request.getAttribute("timeLine");
        ArrayList<WebBusinessObject> dateTypes = (ArrayList<WebBusinessObject>) request.getAttribute("dateTypes");
                ArrayList<WebBusinessObject> levelsList = (ArrayList<WebBusinessObject>) request.getAttribute("levelsList");
       ArrayList<WebBusinessObject> AddOnsVector = new ArrayList<WebBusinessObject>();
       AddOnsVector = (ArrayList<WebBusinessObject>) request.getAttribute("AddOnsVector");
      ArrayList<String> AddOnsType1 = (ArrayList<String>) request.getAttribute("AddOnsType");
    %>
    <script type="text/javascript">
                $(function () {
                    
                $("#foo").carouFredSel({
                auto: false,
                        transition: true,
                        mousewheel: true,
                        prev: "#foo_prev",
                        next: "#foo_next"
                });
                        $("#foo2").carouFredSel({
                auto: false,
                        transition: true,
                        mousewheel: true,
                        prev: "#foo2_prev",
                        next: "#foo2_next"
                });
                });
                function cancelForm()
                {
                document.UNIT_FORM.action = "<%=url%>";
                        document.UNIT_FORM.submit();
                }
        function editProject(editType) {
        $.ajax({
        type: "post",
                url: "<%=context%>/ProjectServlet?op=editProjectByAjax",
                data: {
                projectID: '<%=unitWbo.getAttribute("projectID")%>',
                        editType: editType,
                        projectName: $("#nameEdit").val(),
                        unitLevel :$("#levelID").val(),
                }
        ,
                success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                alert("تم التحديث بنجاح");
                        if (editType == 'name') {
                $("#nameCell").html($("#nameEdit").val());
                        //                            $("#edit_name").hide();
                }


                } else if (info.status == 'faild') {
                alert("لم يتم التحديث");
                }
                closePopup('edit_name');
                        closeOverlay();

                }
        });
        }

        function editProjectDesc(editType) {
        $.ajax({
        type: "post",
                url: "<%=context%>/ProjectServlet?op=editProjectDescByAjax",
                data: {
                projectID: '<%=unitWbo.getAttribute("projectID")%>',
                        editType: editType,
                        projectDesc: $("#descEdit").val()
                }
        ,
                success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                alert("تم التحديث بنجاح");
                        if (editType == 'name') {
                $("#descCell").html($("#descEdit").val());
                        //                            $("#edit_name").hide();
                }


                } else if (info.status == 'faild') {
                alert("لم يتم التحديث");
                }
                closePopup('edit_name');
                        closeOverlay();

                }
        });
        }

        var divID;
                $(function () {
                centerDiv("edit_name");
                        centerDiv("edit_desc");
                        centerDiv("model_form");
                        centerDiv("attachDialog");
                        centerDiv("edit_price_area");
                        centerDiv("edit_unit_rent");
                        centerDiv("email_content");
                });
                function closePopup(formID) {
                $("#" + formID).bPopup().close();
                        /*$("#" + formID).hide();*/
                        $('#overlay').hide();
                }
        function showEditName() {
        divID = "edit_name";
                centerDiv("edit_name");
                $('#edit_name').css("display", "block");
                //$('#edit_name').dialog();
                $('#edit_name').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }

        function showEditDesc() {
        divID = "edit_desc";
                centerDiv("edit_desc");
                $('#edit_desc').css("display", "block");
                //$('#edit_name').dialog();
                $('#edit_desc').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }

        function showEditPriceArea() {
        divID = "edit_price_area";
                centerDiv("edit_price_area");
                $('#edit_price_area').css("display", "block");
                //$('#edit_price_area').dialog();
                $('#edit_price_area').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});

        }
        function showEditUnitRent() {
        divID = "edit_unit_rent";
                centerDiv("edit_unit_rent");
                $('#edit_unit_rent').css("display", "block");
//            $('#edit_unit_rent').dialog();
                $('#edit_unit_rent').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});

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
        function linkUnitWithModel() {
        divID = "model_form";
                centerDiv("model_form");
                $('#model_form').css("display", "block");
                $('#model_form').bPopup();
        }
        function saveLinkUnitWithModelByAjax() {
        $.ajax({
        type: "post",
                url: "<%=context%>/ProjectServlet?op=saveLinkUnitWithModelByAjax",
                data: {
                projectID: '<%=unitWbo.getAttribute("projectID")%>',
                        modelID: $("#modelID").val()
                }
        ,
                success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                alert("تم التحديث بنجاح");
                        location.reload();
                } else if (info.status == 'faild') {
                alert("لم يتم التحديث");
                }
                closeOverlay();
                }
        });
        }

        function popupAttach(obj, projectId) {
        divID = "attachDialog";
                centerDiv("attachDialog");
                $("#attachInfo").html("");
                $("#projectId").val(projectId);
                count = 1;
                $("#addFile2").removeAttr("disabled");
                $("#counter2").val("0");
                $("#listFile2").html("");
                $("#attachDialog").bPopup();
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

                        $("#attachInfo").html("<font color='white'> '<fmt:message key="filesuploaded" />'    </font>");
                                location.reload();
                        },
                        error: function ()
                        {
                        $("#attachInfo").html("<font color='red'> '<fmt:message key="filesnotuploaded" />'       </font>");
                        }
                });
                e.preventDefault(); //Prevent Default action. 
                e.unbind();
        });

        }

        function viewDocuments(parentId) {
        var url = '<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId + '';
                var wind = window.open(url, '<fmt:message key="listdocs" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
        }

        function linkUnitFinance(projectId) {
        var url = '<%=context%>/UnitFinanceServlet?op=getUnitInstallments&projectId=' + projectId;
                var wind = window.open(url, '<fmt:message key="listdocs" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
        }
        function editUnitPriceArea() {
        $.ajax({
        type: "post",
                url: "<%=context%>/UnitServlet?op=editUnitPriceByAjax",
                data: {
                unitID: '<%=unitWbo.getAttribute("projectID")%>',
                        unitPrice: $("#priceEdit").val(),
                        unitArea: $("#areaEdit").val()
                }
        ,
                success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                alert('<fmt:message key="updateddone" />');
                        $("#priceCell").html($("#priceEdit").val());
                        $("#areaCell").html($("#areaEdit").val());
                } else if (info.status == 'faild') {
                alert('<fmt:message key="updatenotdone" />');
                }

                closePopup('edit_price_area');
                        closeOverlay();
                }
        });
        }

        function openGallaryDialog(projectId) {
        var url = '<%=context%>/UnitDocReaderServlet?op=viewProjectMasterPlan&projectId=' + projectId + '';
                var wind = window.open(url, '<fmt:message key="showmaps" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
        }

        function openInsertMapDialog(projectId) {
        $.ajax({
        type: "POST",
                url: "<%=context%>/ProjectServlet",
                data: "op=insertProjectMap&projectId=" + projectId,
                success: function (msg) {
                var url = '<%=context%>/ProjectServlet?op=insertProjectMap&single=image&projectId=' + projectId + '';
                        var wind = window.open(url, '<fmt:message key="showmaps" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                        wind.focus();
                }
        });
        }

        function openViewMapDialog(projectId) {
        var url = '<%=context%>/ProjectServlet?op=viewProjectMap&single=image&projectID=' + projectId + '';
                var wind = window.open(url, '<fmt:message key="showmaps" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
        }

        function openClientDetailsDialog(projectId) {
        window.navigate('<%=context%>/ClientServlet?op=clientDetails&clientId=' + projectId);
        }

        function viewClientContract(obj) {
        $.ajax({
        type: "post",
                url: "./EmailServlet?op=getContractID&clientID=<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>",
                success: function (jsonString) {
                var hiddenIFrameID = 'hiddenDownloader',
                        iframe = document.getElementById(hiddenIFrameID);
                        if (jsonString != '') {
                var url = "<%=context%>/EmailServlet?op=viewDocument&docID=" + jsonString + "&docType=pdf";
                        window.open(url);
                }
                },
                error: function ()
                {
                alert('لا يوجد عقد مرفق');
                }
        });
        }

        function showUnitsList(buildingId) {
        var url = "<%=context%>/ProjectServlet?op=showUnits&buildingId=" + buildingId;
                jQuery('#units_list').load(url);
                centerDiv("units_list");
                $('#units_list').show();
                divID = 'units_list';
                $("#overlay").show();
        }
        <%--Kareem--%>
        function editUnitRent() {
        $.ajax({
        type: "post",
                url: "<%=context%>/UnitServlet?op=editUnitRentTypeByAjax",
                data: {
                projectID: '<%=unitWbo.getAttribute("projectID")%>',
                        unitStatus: $("input[name='unit_status']:checked").val(),
                }
        ,
                success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                alert('<fmt:message key="updateddone" />');
                        //alert($("input[name='unit_status']:checked").val());
                        var statusG = 'statusGroup-' + $("input[name='unit_status']:checked").val();
                        // $("#status").html($("#unit_status").val());
                        $('#' + statusG).prop('checked', true);
                        //$("#status").html($("input[name='unit_status']:checked").val());


                }
                else if (info.status == 'faild') {
                alert('<fmt:message key="updatenotdone" />');
                }

                closePopup('edit_unit_rent');
                        closeOverlay();
                }
        });
        }
        <%--Kareem end--%>

        function addUnitDate() {
        $('#addDateDiv').css("display", "block");
                $('#addDateDiv').bPopup({
        easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'
        });
        }
        
          function UnitAddOns() {
          $('#addOnsType').css("display", "block");
          $('#typeT').css("display", "block");
          $('#updateAddonI').val("0")
          $('#AddOnTit').text('<fmt:message key="addsTitle"/>');
        $('#addOnsDiv').css("display", "block");
                $('#addOnsDiv').bPopup({
        easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'
        });
        }
        
        function updateAddOn(addOnType,type1){
           var addOnType=addOnType;
           var type1=type1;
          $('#addOnsType').css("display", "none");
          $('#typeT').css("display", "none");
          $('#AddOnTit1').text(addOnType);
          $('#updateAddonI').val("1");
            
            $('#addonName').val(type1);
          $('#addOnsDiv2').css("display", "block");
                $('#addOnsDiv2').bPopup({
        easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'
        });  
        }
        function saveUnitDate(projectId) {
        var projectId = projectId;
                var dateType = $("#dateType").val();
                var ChoosenDate = $("#ChoosenDate").val();
                var saveStatus = "no";
                $.ajax({
                type: "post",
                        url: "<%=context%>/UnitServlet?op=saveUnitTimeLine",
                        data: {
                        projectId: projectId,
                                dateType: dateType,
                                ChoosenDate: ChoosenDate
                        }, success: function () {
                $('#addDateDiv').css("display", "none");
                        $('#addDateDiv').bPopup().close();
                }
                });
                location.reload();
        }

        function closeBPopup(obj) {
        $(obj).parent().parent().bPopup().close();
        }

        var minDateS = '<%=nowTime%>';
                $(function () {
                $("#ChoosenDate").datepicker({
                changeMonth: true,
                        changeYear: true,
                        minDate: new Date(minDateS),
                        //maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                        dateFormat: "yy/mm/dd",
                });

                        $("#ChoosenDateEdit").datepicker({
                changeMonth: true,
                        changeYear: true,
                        minDate: new Date(minDateS),
                        maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                        dateFormat: "yy/mm/dd",
                });
                });

                function deleteDate(timeLineID) {
                $("#oldDate" + timeLineID).hide();
                        $("#oldDateType" + timeLineID).hide();
                        $.ajax({
                        type: "post",
                                url: "<%=context%>/UnitServlet?op=deleteUnitTimeLine",
                                data: {
                                timeLineID: timeLineID
                                }
                        });
                        location.reload();
                }

        function editDate(timeLineID) {
            $("#oldDate" + timeLineID).hide();
            $("#oldDateType" + timeLineID).hide();
            $("#editDateTbl").show();
            $("#hiddenID").val(timeLineID);
        }

        function saveEditUnitDate(projectID) {
        var dateType = $("#dateTypeEdit").val();
                var ChoosenDate = $("#ChoosenDateEdit").val();
                var timeLineID = $("#hiddenID").val();
                console.log("ChoosenDate = " + ChoosenDate);
                $.ajax({
                type: "post",
                        url: "<%=context%>/UnitServlet?op=editUnitTimeLine",
                        data: {
                        projectID: projectID,
                                timeLineID: timeLineID,
                                dateType: dateType,
                                ChoosenDate: ChoosenDate
                        }
                });
                $("#oldDate" + timeLineID).show();
                $("#oldDateType" + timeLineID).show();
                $("#editDateTbl").hide();
        }

        function newDate() {
        $("#DateTbl").show();
        }
        $(document).ready(function () {
        $('.imageClass').contextMenu('conMenu', {
        bindings: {
        'email': function (t) {
        popupEmail1($(t).attr('src'));
                //openEmailDialog(Cname, Cmail, sendEmail, unitNo, project, price, area);

        }
        },
                itemStyle: {
                width: '98%',
                        backgroundColor: '#C8C8C8',
                        color: 'black',
                        border: 'none',
                        padding: '1px'
                },
                itemHoverStyle: {
                color: 'white',
                        backgroundColor: '#66CCFF',
                        border: 'none'
                }
        });
        });
                function popupEmail(src) {
                $("#imageSrc").val(src);
                        $("#clientName").html("");
                        $("#emailTo").val("");
                        $("#clientNo").val("");
                        $("#subject").val("");
                        $("#msgContent").val($("#projectDesc").val().trim());
                        $("#progressx").hide();
                        $("#sendEmailBtn").show();
                        divID = "email_content";
                        $('#email_content').css("display", "block");
                        $('#email_content').bPopup();
                }
        function popupEmail1(src) {
            var Cname= $("#Cname").val();
            var Cmail= $("#Cmail").val();
            var sendEmail= $("#sendEmail").val();
            var unitNo= $("#unitNo").val();
            var project= $("#project").val();
            var price= $("#price").val();
            var area= $("#area").val();
                console.log(Cname);
                $("#imageSrc").val(src);
                openEmailDialog(Cname, Cmail, sendEmail, unitNo, project, price, area);
        }
        function popupEmailAllImages() {
        var src = '';
                $('.imageClass').each(function (index, obj) {
        src += ',' + $(obj).attr('src');
        });
                if (src !== '') {
        src = src.substring(1, src.length);
        }
        $("#imageSrc").val(src);
                $("#clientName").html("");
                $("#emailTo").val("");
                $("#clientNo").val("");
                $("#subject").val("");
                $("#msgContent").val($("#projectDesc").val().trim());
                $("#progressx").hide();
                $("#sendEmailBtn").show();
                divID = "email_content";
                $('#email_content').css("display", "block");
                $('#email_content').bPopup();
        }
        function editUnitLvl()
        {
             $('#levelName').toggle();
             $('#levelID').toggle();
        }
      
         
        function getClient() {
        var clientNo = $("#clientNo").val();
                $.ajax({
                type: "post",
                        url: "<%=context%>/ClientServlet?op=getClientNameByNo",
                        data: {
                        clientNumber: clientNo
                        },
                        success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                                if (info.status === 'Ok') {
                        $("#clientName").html(info.name);
                                $("#emailTo").val(info.email);
                                $("#errorMsgSell").html("");
                        } else {
                        $("#errorMsgSell").html("<fmt:message key="clientNoWrongMsg"/>");
                                $("#clientName").html("");
                                $("#emailTo").val("");
                        }
                        }
                });

        }
        function sendEmail() {
        var email = $("#emailTo").val();
                var imageSrc = $("#imageSrc").val();
                var subject = $("#subject").val();
                var details = $("#details").text();
                var body = $("#msgContent").val() + details;
                console.log(body);

                $("#sendEmailBtn").hide();
                $.ajax({
                type: "post",
                        url: "<%=context%>/EmailServlet?op=sendImageMailByAjax",
                        data: {
                        email: email,
                                imageSrc: imageSrc,
                                subject: subject,
                                body: body
                        },
                        success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                                if (info.status === 'ok') {
                        alert("<fmt:message key="emailSuccessMsg"/>");
                                closePopup("email_content");
                        } else {
                        alert("<fmt:message key="emailFailMsg"/>");
                                $("#sendEmailBtn").show();
                        }
                        }
                });
                return false;
        }
        function confirmDeleteUnit(unitID) {
        var r = confirm('<fmt:message key="deleteConfirm"/>');
                if (r) {
        $.ajax({
        type: "post",
                url: "<%=context%>/UnitServlet?op=deleteUnitAjax",
                data: {
                unitID: unitID
                },
                success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                alert("<fmt:message key="deleteddone"/>");
                        document.location.replace(document.referrer);
                } else if (info.status === 'purchase') {
                alert("<fmt:message key="purchaseMsg"/>");
                } else if (info.status === 'reserved') {
                alert("<fmt:message key="reservedMsg"/>");
                } else {
                alert("<fmt:message key="deletednotdone"/>");
                }
                }
        });
        }
        }
        function openEmailDialog(clientName, clientEmail, title, unitNo, project, price, area) {
        loading("block");
                var src = '';
                $('.imageClass').each(function (index, obj) {
        src += ',' + $(obj).attr('src');
        });
                if (src !== '') {
        src = src.substring(1, src.length);
        }
        $("#imageSrc").val(src);
                var imageSrc = $("#imageSrc").val();
                //console.log(imageSrc);
                divCommentsTag = $("div[name='divCommentsTag']");
                count = 1
                $.ajax({
                type: "post",
                        url: '<%=context%>/EmailServlet?op=getEmailPopupClient',
                        data: {
                        clientName: clientName,
                                clientEmail: clientEmail,
                                title: title,
                                unitNo: unitNo,
                                project: project,
                                price: price,
                                area: area,
                                imageSrc: imageSrc,
                        },
                        success: function (data) {
                        divCommentsTag.html(data)
                                .dialog({
                                modal: true,
                                        title: "<%=sendEmail%>",
                                        show: "fade",
                                        hide: "explode",
                                        width: 650,
                                        height: 620,
                                        position: {
                                        my: 'center',
                                                at: 'center'
                                        },
                                        buttons: {
                                        Close: function () {
                                        divCommentsTag.dialog('destroy').hide();
                                        },
                                                Send: function () {
                                                sendMailByAjax2();
                                                }
                                        }
                                })
                                .dialog('open');
                        },
                        error: function (data) {
                alert('Data Error = '+data);
                        }
                });
                loading("none");
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

        var count = 1;
                function addEmailFiles(obj) {
                if ((count * 1) == 4) {
                $("#addEmailFile").removeAttr("disabled");
                }

                if (count >= 1 & count <= 4) {
                $("#listFile").append("<input type='file' style='text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
                        $("#emailCounter").val(count);
                        count = Number(count * 1 + 1)

                } else {
                $("#addEmailFile").attr("disabled", true);
                }
                }

        function sendMailByAjax2() {
        console.log("kkkkkkkkkkkkkkkkk");
                $("#progressx").css("display", "block");
                $("#progressx").show();
                $("#emailStatus").html("");
                $("#progressx").css("display", "block");
                var formData = new FormData($("#emailForm")[0]);
                var obj = $("#listFile");
                $.each($(obj).find("input[type='file']"), function (i, tag) {
                $.each($(tag)[0].files, function (i, file) {
                formData.append(tag.name, file);
                });
                });
                formData.append("to", $("#to").val());
                formData.append("subject", $("#subject2").val());
                formData.append("unitDetails", $("#unitDetails").text());
                formData.append("counter", $("#emailCounter").val());
                formData.append("message", $("#mailBody").val());
                formData.append("imageSrc", $("#imageSrc").val());
                $.ajax({
                url: '<%=context%>/EmailServlet?op=sendByAjaxClient',
                        type: 'POST',
                        data: formData,
                        async: false,
                        success: function (data) {
                        var result = $.parseJSON(data);
                                $("#progressx").html('');
                                $("#progressx").css("display", "none");
                                if (result.status == 'ok') {
                        $("#emailStatus").html("<font color='green'><%=successMsg%></font>");
                        } else if (result.status == 'error') {
                        $("#emailStatus").html("<font color='red'><%=failMsg%></font>");
                        }
                        },
                        error: function ()
                        {
                        $("#emailStatus").html("<font color='red'><%=failMsg%></font>");
                        },
                        cache: false,
                        contentType: false,
                        processData: false
                });
                return false;
        }
        
        
         function removeAddon(type) {
             var type1=type;
            $.ajax({
                type: "post",
                url: "<%=context%>/AddonServlet?op=deleteUnitAddonAjax",
                data: {
                    projectID: $("#projectId1").val(),
                    type1: type1
                
                },
                success: function (data1) {
                   location.reload();
                    var result1 = $.parseJSON(data1);
                    if (result1.status == 'ok') {
                        location.reload();
                    }
                }
            });
        }

        function saveUnitAddon(projectID) {
        var checkUpdate=$("#updateAddonI").val();
        var type1=$("#addonName").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/AddonServlet?op=saveUnitAddonAjax",
                data: {
                    projectID: projectID,
                    type: $("#addOnsType").val(),
                    price: $("#onPrice").val(),
                    area: $("#onArea").val(),
                    checkUpdate :checkUpdate,
                    type1: type1,
                    price1: $("#onPrice1").val(),
                    area1: $("#onArea1").val(),
                    
                },
                success: function (data) {
                    var result = $.parseJSON(data);
                    if (result.status == 'ok') {
                        location.reload();
                    }
                }
            });
        }

    </script>
    <style type="text/css">
        *>*{
            vertical-align: middle;
        }
        
        .image_carousel {
            padding: 15px 0 15px 40px;
            width: 100%;
            height: 100%;
            position: relative;
        }
        .image_carousel img {
            border: 1px solid #ccc;
            background-color: white;
            padding: 9px;
            margin: 7px;
            display: block;
            float: left;
        }
        a.prev {
            background: url(images/miscellaneous_sprite.png) no-repeat transparent;
            width: 45px;
            height: 50px;
            display: block;
            position: absolute;
            top: -40px;
        }
        a.prev {			
            left: 15px;
            background-position: 0 0; }
        a.prev:hover {		background-position: 0 -50px; }

        a.prev span {
            display: none;
        }
        .clearfix {
            float: none;
            clear: both;
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
            background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
            background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
        }
        .cursorH{
              cursor: pointer;
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
        .smallDialog {
            width: 320px;
            display: none;
            position: fixed;
            z-index: 1000;
        }

        .DescDialog {
            width: 700px;
            display: none;
            position: fixed;
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

        .status-icon {
            content:url('images/<%=unitStatusImage%>');
        }
        .broker-icon {
            content:url('images/<%=ownerId != null && !ownerId.equals("null") ? "icons/manager.png" : "notOwner.png"%>');
        }
        .model-icon {
            content:url('images/model.png');
        }
        .attach-icon {
            content:url('images/icons/Attach.png');
        }
        .view-document-icon {
            content:url('images/unit.png');
        }.add-on-icon {
            content:url('images/homeAdds.png');
        }
        .gallery-icon {
            content:url('images/gallery.png');
        }
        .client-details-icon {
            content:url('images/user_red_edit.png');
        }
        .contract-icon {
            content:url('images/contract_icon.jpg');
        }
        .payment-icon {
            content:url('images/building.gif');
        }
        .finance-icon {
            content:url('images/icons/list_.png');
        }
        .history-icon {
            content:url('images/icons/history.png');
        }
        .email-icon {
            content:url('images/icons/email.png');
        }
        .new-map-icon {
            content:url('images/icons/region.png');
        }
        .view-map-icon {
            content:url('images/icons/place.png');
        }
        .delete-icon {
            content:url('images/icons/delete_ready.png');
        }

        .w2ui-grid .w2ui-grid-toolbar {
            padding: 14px 5px;
            height: 150px;
        }
.infoTable {
 border-spacing: 30px;  
}
        .w2ui-grid .w2ui-grid-header {
            padding: 14px;
            font-size: 20px;
            height: 150px;
        }
    </style>
    <body>
        <div name="divAttachmentTag"></div>
        <div name="divCommentsTag"></div>
        <div class="contextMenu" id="conMenu">
            <ul>
                <li id="email"> Send Email ... </li>
            </ul>
        </div>
        <div id="email_content"  style="width: 400px;display: none;position: absolute;margin-left: auto;margin-right: auto; top: 100px; z-index: 1000;">
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closePopup('email_content')"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <form id="myForm" method="post">
                    <table class="table " style="width:100%;">
                        <tr >
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message key="clientNo"/></td>
                            <td style="text-align:right;width: 70%;">
                                <input id="clientNo" type="text" onkeyup="getClient(this)" size="25" maxlength="60"></b>
                                <div style="color: red;width: 80px;"><b  id="errorMsgSell"></b></div>
                                <input type="hidden" id="imageSrc"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message key="clientName"/></td>
                            <td style="text-align:right;width: 70%;">
                                <b id="clientName" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message key="to"/></td>
                            <td style="text-align:right;width: 70%;">
                                <input type="email" size="25" maxlength="60" id="emailTo" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" ><fmt:message key="subject"/></td>
                            <td style="text-align:right;width: 70%;">
                                <input type="text" size="25" maxlength="60" id="subject" name="subject" class="login-input" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" ><fmt:message key="details"/></td>
                            <td style="text-align:right;width: 70%;">
                                <P type="text" style="width: 90%; text-align: left; color: white; font-weight: bold " id="details" name="details" class="login-input" readonly>
                                    .Unit No: <%=unitWbo.getAttribute("projectName")%>- <br> 
                                    .Project: <%=projectWbo.getAttribute("projectName")%>-<br> 
                                    .Price: <%=unitPriceWbo != null && !("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("option1")) ? unitPriceWbo.getAttribute("option1") : none%>-<br> 
                                    .area: <%=unitPriceWbo != null && !("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("maxPrice")) ? unitPriceWbo.getAttribute("maxPrice") : none%>-

                                </P>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message key="messageBody"/></td>
                            <td  style="text-align:right;width: 70%;">
                                <textarea placeholder="<fmt:message key="messageContent"/>" rows="10" cols="24" name="message"  id="msgContent"class="login-input" style="height: 100px;"></textarea>
                            </td>
                        </tr> 
                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="status"></div>
                    <div id="message" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <input id="sendEmailBtn" type="button" value="<fmt:message key="send"/>"  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendEmail(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
        <div id="attachDialog" class="smallDialog">
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closePopup('attachDialog')"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <form id="attachForm" action="<%=context%>/UnitDocWriterServlet?op=saveMultiFiles" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable>

                            <fmt:message key="attach"/>
                        </lable>
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
                    <input type="submit" value=' <fmt:message key="upload"/>'  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendFilesByAjax(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
        <FORM NAME="UNIT_FORM" id="new_location_type_Form" METHOD="POST">
            <div id="units_list" style="width: 700px !important;display: none; z-index: 10000; top: 50px; left: 350px; position: fixed;"></div>
            <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

            </div>
            <div id="edit_name" class="smallDialog">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup('edit_name')"/>
                </div>
                <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                    <table  border="0px"  style="width:100%;"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                <fmt:message key="unitno" />
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:180px" ID="nameEdit" size="33" value="<%=unitWbo.getAttribute("projectName")%>"/>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value=' <fmt:message key="save"/>' onclick="editProject('name')" id="editName" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            <%--Kareem--%>
            <div id="edit_unit_rent" class="smallDialog">
                <div style="clear: both;margin-left: 118%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup('edit_unit_rent')"/>
                </div>
                <div class="login" style="width: 120%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                    <table  border="0px"  style="width:100%;"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>

                                <fmt:message key="commstate"/>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <%--<input type="TEXT" style="width:180px" ID="nameEdit" size="33" value="<%=unitWbo.getAttribute("projectName")%>"/>--%>
                                <input type="radio" name="unit_status" value="ايجار" <%=unitRentType.equals("ايجار") ? "checked" : ""%> >Rent</input>
                                <input type="radio" name="unit_status" value="تمليك" <%=unitRentType.equals("تمليك") ? "checked" : ""%> >Titling</input>
                                <input type="radio" name="unit_status" value="ايهما" <%=unitRentType.equals("ايهما") || "UL".equals(unitRentType) ? "checked" : ""%>>Which one</input>

                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value=' <fmt:message key="save"/>' onclick="javascript:editUnitRent();" id="edit_unit_rent" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            <%--Kareem--%>
            <div id="edit_desc" class="DescDialog">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup('edit_desc')"/>
                </div>
                <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                    <table  border="0px"  style="width:100%;"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                              
                                <fmt:message key="unitDes"/>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <textarea rows="4" cols="50" ID="descEdit" size="33"><%=unitWbo.getAttribute("projectDesc")%></textarea>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value=' <fmt:message key="save"/>' onclick="editProjectDesc('desc')" id="editDesc" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            <%--Kareem--%>
            <div id="model_form" class="smallDialog">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup('model_form')"/>
                </div>
                <div class="login" style="width: 90%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                    <table  border="0px"  style="width:100%;"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>

                                <fmt:message key="model"/>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <select id="modelID" name="modelID" style="width: 180px; font-size: medium;">
                                    <sw:WBOOptionList wboList="<%=modelsList%>" displayAttribute="projectName" valueAttribute="projectID"/>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value=' <fmt:message key="save"/>' onclick="saveLinkUnitWithModelByAjax()" id="saveModel" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            <div id="edit_price_area" class="smallDialog">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup('edit_price_area')"/>
                </div>
                <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                    <table  border="0px"  style="width:100%;"  class="table" dir='<fmt:message key="direction" />'>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>

                                <fmt:message key="unitprice"/>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="number" style="width:80px" ID="priceEdit" size="33"
                                       value="<%=unitPriceWbo != null && !("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("option1")) ? unitPriceWbo.getAttribute("option1") : none%>"/>
                            </td>

                        </tr>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>

                                <fmt:message key="unitarea"/>
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="number" style="width:80px" ID="areaEdit" size="33"
                                       value="<%=unitPriceWbo != null && !("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("maxPrice")) ? unitPriceWbo.getAttribute("maxPrice") : ""%>"/>
                            </td>


                        </tr>
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value=' <fmt:message key="save"/>' onclick="editUnitPriceArea('name')" id="editName" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            <div>
                <IMG class="img" style="cursor: pointer; float:left" width="5%" VALIGN="BOTTOM" onclick="window.history.go(-1);" SRC="images/buttons/backBut.png" > 
            </dIV>
            <TABLE style="width:95% ">

                <TR>
                    <!--<TD style="width: 5%;border: none ; padding-bottom: 75%">
                        <IMG class="img" style="cursor: pointer" width="75%" VALIGN="BOTTOM" onclick="JavaScript: cancelForm();" SRC="images/buttons/backBut.png" > 

                    </TD>-->
                    <TD style="width: 95%; border: none">
                        <fieldset class="set" style="border-color: #006699; width: 95%; min-height: 400px;">
                            <legend align="center">
                                <font color="blue" size="6"> 
                                <fmt:message key="viewunitdetails"/>
                                </font>
                            </legend>
                            <div style="margin-left: auto; margin-right: auto; width: 1100px;">
                                <div id="toolbar" dir="<fmt:message key="direction"/>" style="padding: 4px; border: 1px solid #dfdfdf; border-radius: 3px; width: 1100px;">
                                </div>
                            </div>

                            <script type="text/javascript">
                                        $(function () {
                                        $('#toolbar').w2toolbar({
                                        name: 'toolbar',
                                                items: [
                                                {
                                                type: 'html',
                                                        id: 'unitStatus',
                                                        html: function (item) {
                                                        var html = '<img style="height:35px;" class="status-icon" title="<%=unitStatusTtile%>"/>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                <%
                                                if (userPrevList.contains("BRCKR_ICN")) {
                                %>
                                                {
                                                type: 'html',
                                                        id: 'broker',
                                                        html: function (item) {
                                                        var html = '<img style="height:35px;" class="broker-icon" title="مالك الوحدة"/>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                <%
                                                }
                                %>
                                                {
                                                type: 'html',
                                                        id: 'model',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="model-icon" onclick="JavaScript: linkUnitWithModel(this);" title="<fmt:message key="attachmodel" />"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                                {
                                                type: 'html',
                                                        id: 'attach',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="attach-icon" onclick="JavaScript: popupAttach(this, \x27<%=unitWbo.getAttribute("projectID")%>\x27);" title="<fmt:message key="attach" />"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                                {
                                                type: 'html',
                                                        id: 'viewDocument',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="view-document-icon" onclick="JavaScript: viewDocuments(\x27<%=unitWbo.getAttribute("projectID")%>\x27);" title="<fmt:message key="showunitfiles" />"/></a>';
                                                                return html;
                                                        }
                                                },{
                                                type: 'break'
                                                },
                                                {
                                                type: 'html',
                                                        id: 'addOns',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="add-on-icon" onclick="JavaScript: UnitAddOns(\x27<%=unitWbo.getAttribute("projectID")%>\x27);" title="<fmt:message key="addsTitle" />"/></a>';
                                                                return html;
                                                        }
                                                }, 
                                                    {
                                                type: 'break'
                                                },
                                                {
                                                type: 'html',
                                                        id: 'gallery',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="gallery-icon" onclick="JavaScript: openGallaryDialog(\x27<%=projectWbo != null ? projectWbo.getAttribute("projectID") : ""%>\x27);" title="<fmt:message key="showmaps" />"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                <%
                                                    if (clientWbo != null) {
                                %>
                                                {
                                                type: 'html',
                                                        id: 'clientDetails',
                                                        html: function (item) {
                                                        var html = '<a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientWbo.getAttribute("id")%>"><img style="height:35px;" class="client-details-icon" title="<fmt:message key="clientdetails" />"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                                {
                                                type: 'html',
                                                        id: 'viewContract',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="contract-icon" onclick="JavaScript: viewClientContract(this);" title="Contracts"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                <%
                                                }
                                                if (buildingWbo != null) {
                                %>
                                              //  {
                                              //  type: 'html',
                                              //          id: 'payment',
                                              //          html: function (item) {
                                              //          var html = '<a href="#"><img style="height:35px;" class="payment-icon" onclick="JavaScript: showUnitsList(\x27<%=buildingWbo.getAttribute("projectID")%>\x27);" title="<fmt:message key="payment" />"/></a>';
                                              //                  return html;
                                              //          }
                                              //  },
                                                {
                                                type: 'break'
                                                },
                                <%
                                                }
                                                if (metaMgr.getUnitFinanceFlag().equals("1")) {
                                %>
                                            //    {
                                            //    type: 'html',
                                            //            id: 'finance',
                                            //            html: function (item) {
                                            //            var html = '<a href="#"><img style="height:35px;" class="finance-icon" onclick="JavaScript: linkUnitFinance(\x27<%=unitWbo.getAttribute("projectID")%>\x27);" title="<fmt:message key="payment" />"/></a>';
                                            //                    return html;
                                            //            }
                                            //    }, 
                                            //            {
                                            //    type: 'break'
                                            //    },
                                <%
                                                }
                                %>
                                                {
                                                type: 'html',
                                                        id: 'history',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="history-icon" onclick="JavaScript: addUnitDate();" title="<fmt:message key="addDate" />"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                <%
                                                String name = null, email = null, unitName, projectName, price = none, area = none;
                                                if (clientWbo != null) {
                                                    name = (String) clientWbo.getAttribute("name");
                                                    email = (String) clientWbo.getAttribute("email");
                                                }
                                                unitName = (String) unitWbo.getAttribute("projectName");
                                                projectName = (String) projectWbo.getAttribute("projectName");
                                                if (unitPriceWbo != null) {
                                                    if (!("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("option1"))) {
                                                        price = (String) unitPriceWbo.getAttribute("option1");
                                                    }
                                                    if(!("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("maxPrice"))) {
                                                        area = (String) unitPriceWbo.getAttribute("maxPrice");
                                                    }
                                                }
                                %>
                                                //{
                                                //type: 'html',
                                                //        id: 'email',
                                                //        html: function (item) {
                                                //        var html = '<a href="#"><img style="height:35px;" class="email-icon" onclick="JavaScript: openEmailDialog(\x27<%=name%>\x27,\x27<%=email%>\x27,\x27<%=sendEmail%>\x27,\x27<%=unitName%>\x27,\x27<%=projectName%>\x27,\x27<%=price%>\x27,\x27<%=area%>\x27);" title="<fmt:message key="sendAllImage" />"/></a>';
                                                //                return html;
                                                //        }
                                                //}, 
                                             //   {
                                             //   type: 'break'
                                             //   },
                                                {
                                                type: 'html',
                                                        id: 'newMap',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="new-map-icon" onclick="JavaScript: openInsertMapDialog(\x27<%=projectWbo != null ? projectWbo.getAttribute("projectID") : ""%>\x27);" title="<fmt:message key="showmaps" />"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                },
                                                {
                                                type: 'html',
                                                        id: 'viewMap',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="view-map-icon" onclick="JavaScript: openViewMapDialog(\x27<%=projectWbo != null ? projectWbo.getAttribute("projectID") : ""%>\x27);" title="<fmt:message key="showmaps" />"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                }
                                <%
                                                    if (userPrevList.contains("DELETE_UNIT")) {
                                %>
                                                ,
                                                {
                                                type: 'html',
                                                        id: 'delete',
                                                        html: function (item) {
                                                        var html = '<a href="#"><img style="height:35px;" class="delete-icon" onclick="JavaScript: confirmDeleteUnit(\x27<%=unitWbo.getAttribute("projectID")%>\x27);" title="<fmt:message key="delete" />"/></a>';
                                                                return html;
                                                        }
                                                }, {
                                                type: 'break'
                                                }
                                <%
                                                    }
                                %>
                                                ], onClick: function (event) {}
                                        });
                                        });                            </script>
                            <%
                                if (clientWbo != null) {
                            %>
                            <input type="hidden" id="Cname" value="<%=clientWbo.getAttribute("name") != null ? clientWbo.getAttribute("name") : ""%>"/>
                            <input type="hidden" id="Cmail" value="<%=clientWbo.getAttribute("email") != null ? clientWbo.getAttribute("email") : ""%>"/>
                            <%}%>
                            <input type="hidden" id="sendEmail" value="<%=sendEmail%>"/>
                            <input type="hidden" id="unitNo" value="<%=unitWbo.getAttribute("projectName")%>"/>
                             <input type="hidden" id="projectId1" value="<%=unitWbo.getAttribute("projectID")%>"/>
                            <input type="hidden" id="project" value="<%=projectWbo.getAttribute("projectName")%>"/>
                            <input type="hidden" id="price" value="<%=unitPriceWbo != null && !("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("option1")) ? unitPriceWbo.getAttribute("option1") : none%>"/>
                            <input type="hidden" id="area" value="<%=unitPriceWbo != null && !("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("maxPrice")) ? unitPriceWbo.getAttribute("maxPrice") : none%>"/>
                            <input type="hidden"  id="updateAddonI" value="0"/>

                            <br />
                            <br />

                            <TABLE class="blueBorder" dir='<fmt:message key="direction" />' align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <TR>
                                    <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                        <FONT color='white' SIZE="+1"> <fmt:message key="unitdetails"/> </FONT>
                                        <BR/>
                                    </TD>
                                </TR>
                            </TABLE>

                            <table border="0" dir='<fmt:message key="direction" />' cellpadding="10" cellspacing="10" style="width: 100%;">
                                <tr>
                                    <td style="width: 60%; vertical-align: top;">
                                        <table dir='<fmt:message key="direction" />' cellspacing="20" cellpadding="10"  style="width: 60%;">
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 25%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="unitno" /> 
                                                    </b>
                                                </td>
                                                <td style="width: 50%;" >
                                                   
                                                        <%=unitWbo.getAttribute("projectName")%>
                                             <b><font color="red" size="3" id="nameCell">
                                                               </font>
                                                    </b>
                                                </td>
                                                <TD style="width: 25%;">
                                                     <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditName();"
                                                         style="display: <%=displayEdit ? "" : "none"%>;" />
                                                </TD>

                                            </tr>
                                            <%
                                                if (projectWbo != null) {
                                            %>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 25%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="project" /> 
                                                    </b>
                                                </td>
                                                <td style="width: 75%;" colspan="2">
                                                    <b>
                                                        <font color="red" size="3">
                                                        <%=projectWbo.getAttribute("projectName")%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 25%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="projectDesc" /> 
                                                    </b>
                                                </td>
                                                <td style="width: 75%;" colspan="2">
                                                    <textarea id="desc" readonly style="width:70%; height:25; background:#E9EC8D; color:red; font-weight: bold; overflow-y: scroll ">
                                                        <%=projectWbo.getAttribute("projectDesc")%>
                                                    </textarea>
                                                </td>

                                            </tr>
                                            <%
                                                }
                                                if (buildingWbo != null) {
                                            %>
                                            <tr>
                                                <td style="width: 25%;" colspan="2">
                                                    <b>
                                                        <font color="red" size="3">
                                                        <%=buildingWbo.getAttribute("projectName")%>
                                                        </font>
                                                    </b>
                                                </td>
                                                <td bgcolor="#CCCCCC" style="width: 75%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="building" />
                                                    </b>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 25%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="unitprice" />
                                                    </b>
                                                </td>
                                                <td style="width: 50%;">
                                                    <b><font color="red" size="3" id="priceCell">
                                                        <%=unitPriceWbo != null && !("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("option1")) ? unitPriceWbo.getAttribute("option1") : none%>
                                                        </font>
                                                    </b>
                                                </td>

                                                <td rowspan="2" style="width: 25%;">
                                                    <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditPriceArea();"
                                                         style="display: <%=displayEditPriceArea ? "" : "none"%>;" />
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 25%;">
                                                    <b><font size="2" color="black"> 
                                                        <fmt:message key="unitarea" />
                                                    </b>
                                                </td>
                                                <td style="width: 75%;">
                                                    <b><font color="red" size="3" id="areaCell">
                                                        <%=unitPriceWbo != null && !("0").equalsIgnoreCase((String) unitPriceWbo.getAttribute("maxPrice")) ? unitPriceWbo.getAttribute("maxPrice") : none%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <%--Kareem--%>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 25%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="commstate" />
                                                    </b>
                                                </td>
                                                <td style="width: 50%;">
                                                    <table dir='<fmt:message key="dir" />' style="border: 0px;margin-left: 50px;">
                                                        <tr>
                                                            <td style="border: 0px;color: red;size: 3;font-style: normal;"><input type="radio" name="statusGroup" id="statusGroup-ايجار" value="ايجار" disabled="false" <%=unitRentType.equals("ايجار") ? "checked" : ""%>>Rent&nbsp;&nbsp;</td>
                                                            <td style="border: 0px;color: red;size: 3;font-style: normal;"><input type="radio" name="statusGroup" id="statusGroup-تمليك" value="تمليك" disabled="false"<%=unitRentType.equals("تمليك") ? "checked" : ""%>>Titling&nbsp;&nbsp;</td>
                                                            <td style="border: 0px;color: red;size: 3;font-style: normal;"><input type="radio" name="statusGroup" id="statusGroup-ايهما" value="ايهما" disabled="false" <%=unitRentType.equals("ايهما") || "UL".equals(unitRentType) ? "checked" : ""%>>Which one</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="width: 25%;">
                                                    <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditUnitRent();"
                                                         style="display: <%=displayEdit ? "" : "none"%>;" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 25%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="levelu" />
                                                    </b>
                                                </TD>
                                                <TD>
                                                    <b id="levelName" name="levelName"><font size="2" color="black" >
                                                        <%=levelN%>
                                                    </b>
                                                    <select style="width: 80%; font-size: 16px;" dir="<fmt:message key="direction" />" name="levelID" ID="levelID">
                                                              <sw:WBOOptionList wboList="<%=levelsList%>" displayAttribute="projectName" valueAttribute="projectID"/>
                                                    </select>
                                                </td>
                                                <td style="width: 25%;">
                                                    <img src="images/edit.png" width="50" align="left" onclick="JavaScript: editUnitLvl();"
                                                         style="display: <%=displayEdit ? "" : "none"%>;" />
                                                </td>
                                            </TR>
                                             <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b>
                                                        <font size="2" color="black">
                                                        <fmt:message key="model" /> 
                                                    </b>
                                                </td>
                                                <td style="width: 70%;">
                                                    <b>
                                                       
                                                        <font color="red" size="3" id="nameCell">
                                                        <%if (modelWbo!=null) {%>
                                                        <%=modelWbo.getAttribute("projectName") != null ? modelWbo.getAttribute("projectName") : "---"%>
                                                        <%} else {%>
                                                        <fmt:message key="noCmodel" /> 
                                                        <%}%>
                                                        </font>
                                                    </b>
                                                </TD>
                                                <td>
                                                    <img src="images/edit.png" width="50" align="left" onclick="JavaScript: linkUnitWithModel();"
                                                         style="display: <%=displayEdit ? "" : "none"%>;" />
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 25%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="unitDes" />
                                                    </b>
                                                </td>
                                               
                                                <td>
                                                    <textarea id="projectDesc" readonly style="width:70%; height:65; background:#E9EC8D; color:red; font-weight: bold; overflow-y: scroll ">
                                                        <%=unitWbo.getAttribute("projectDesc")%>
                                                    </textarea>
                                                </td>
                                                 <td style="width: 75%;" colspan="2">
                                                    <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditDesc();"
                                                         style="display: <%=displayEdit ? "" : "none"%>;" />
                                                </TD>
                                            </tr>
                                            <%--Kareem end--%>
                                        </table>
                                    </td>
                                    <td style="width: 70%;">
                                        <% if (imagePath.size() > 0) {
                                        %>
                                        <div class="image_carousel">
                                            <div id="foo">
                                                <%for (int i = 0; i < imagePath.size(); i++) {%>
                                                <img class="imageClass" src="<%=imagePath.get(i)%>" width="600" height="600"/>
                                                <%}%>
                                            </div>
                                            <div class="clearfix"></div>
                                            <a class="prev" id="foo_prev" href="#"><span>Previous</span></a>
                                            <a class="next" id="foo_next" href="#"><span>Next</span></a>
                                        </div>
                                        <% } else {
                                        %>
                                        <b style="font-size: large;">
                                            <fmt:message key="noimageunit" />
                                        </b>
                                        <%
                                            }
                                        %>
                                    </td>
                                </tr>
                            </table>
                                    
                            <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <TR>
                                    <TD  style="border-color: #006699;direction: rtl;" width="50% " class="blueBorder blueHeaderTD">
                                        <FONT color='white' SIZE="+1"> 
                                        <%
                                            if (userPrevList.contains("TIMELINE")) {
                                        %>
                                        <fmt:message key="timeLine" />
                                        <%
                                            }
                                        %>
                                        </FONT>
                                        <BR/>
                                    </TD>
                                    <TD style="border-color: #006699;direction: ltr;" width="50%" class="blueBorder blueHeaderTD">
                                        <FONT color='white' SIZE="+1"> 
                                            <fmt:message key="addOnsT" />
                                        </FONT>
                                        <BR/>
                                    </TD>
                                </TR>
                            </TABLE>
                            
                            
                                 <div style="width: 40%; padding: 2%;display: inline-block" >
                                     
                                    <%
                                        if(userPrevList.contains("TIMELINE")) {
                                    %>
                                    <table dir='<fmt:message key="direction" />'  align="center" WIDTH="100%" id="timeLine" style="">
                                        <THEAD>
                                            <tr>
                                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 40%;"> <fmt:message key="dateType" /> </th>
                                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 40%;"> <fmt:message key="date" /> </th>
                                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 20%; display: <%=userPrevList.contains("DELETE_UNIT_TIMELINE") ? "block" : "none"%>;"> <fmt:message key="delete" /> </th>
                                            </TR>
                                        </THEAD>

                                        <TBODY>
                                            <%
                                                for(WebBusinessObject timeLineWbo : timeLine){
                                            %>
                                                    <tr>
                                                        <td>
                                                             <%=timeLineWbo != null ? timeLineWbo.getAttribute("dateType") : ""%>
                                                        </TD>

                                                        <td>
                                                            <%=timeLineWbo != null ? timeLineWbo.getAttribute("unitDate").toString().split(" ")[0] : ""%>
                                                        </TD>

                                                        <td style="display: <%=userPrevList.contains("DELETE_UNIT_TIMELINE") ? "block" : "none"%>;">
                                                            <div align="center" style="width: 100%; display: block;">
                                                                <img src="images/icons/stop.png" width="19" height="19" style="vertical-align: middle;" onclick="deleteDate('<%=timeLineWbo.getAttribute("id")%>');"/>
                                                            </div>
                                                        </TD>
                                                    </TR>
                                            <%
                                                }
                                            %>
                                        </TBODY>
                                    </table>
                                    <%
                                        }
                                    %>
                                    
                                </div>
                                <div style="width: 40%; padding: 2%;display: inline-block" >
                                 
                                    <table  dir='<fmt:message key="direction" />' align="center" WIDTH="100%" id="addOnsTable" style="">
                                        <THEAD>
                                            <tr>
                                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 30%;"> <fmt:message key="AddonType" /> </th>
                                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 25%;"> <fmt:message key="AddOnPrice" /> </th>
                                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 25%;"> <fmt:message key="AddOnArea" /> </th>
                                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 10%;"> <fmt:message key="EditAddOn" /> </th>
                                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 10%;"> <fmt:message key="RemveAddOn" /> </th>
                                            </TR>
                                        </THEAD>

                                       <TBODY>
                                            <%
                                                int m=0; 
                                                for(WebBusinessObject addonsDet : AddOnsVector){
                                                    String typeN=AddOnsType1 != null ? AddOnsType1.get(m) : "";
                                            %>
                                                    <tr>
                                                        <td>
                                                             <%=AddOnsType1 != null ? AddOnsType1.get(m) : ""%>
                                                        </TD>

                                                        <td>
                                                            <%=addonsDet != null ? addonsDet.getAttribute("price") :""%>
                                                        </TD>

                                                        <td >
                                                          <%=addonsDet != null ? addonsDet.getAttribute("area") :""%>
  
                                                        </TD>
                                                        <td >
                                                            <img src="images/icons/editA.png" title="Edit this Add on" class="cursorH" width="19" height="19" style="vertical-align: middle;" onclick="updateAddOn('<%=typeN%>','<%=addonsDet.getAttribute("type")%>')"/>
                                                        </TD>
                                                        <td >
                                                            <img  src="images/icons/delete_ready.png" title="Delet this Add on"  class="cursorH" width="19" height="19" style="vertical-align: middle;" onclick="removeAddon('<%=addonsDet.getAttribute("type")%>')"/>

                                                        </TD>
                                                        </TD>

                                                        
                                                    </TR>
                                            <%
                                               m++; }
                                            %>
                                        </TBODY>
                                    </table>
                                      
                                </div>
                   
                                    
                            <br/>
                            <br/>
                            <TABLE class="blueBorder" dir='<fmt:message key="direction" />' align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <TR>
                                    <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                        <FONT color='white' SIZE="+1"> 
                                        <fmt:message key="modeldetails" />
                                        </FONT>
                                        <BR/>
                                    </TD>
                                </TR>
                            </TABLE>
                            <%
                                if (modelWbo != null) {
                            %>
                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;" dir='<fmt:message key="direction" />'>
                                <tr>
                                    <td style="width: 600px; vertical-align: top;">
                                        <table style="width: 100%;" dir='<fmt:message key="direction" />'>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b>
                                                        <font size="2" color="black">
                                                        <fmt:message key="model" /> 
                                                    </b>
                                                </td>
                                                <td style="width: 70%;">
                                                    <b>
                                                        <font color="red" size="3" id="nameCell">
                                                        <%=modelWbo.getAttribute("projectName") != null ? modelWbo.getAttribute("projectName") : "---"%>
                                                        </font>
                                                    </b>

                                                    <img src="images/edit.png" width="50" align="left" onclick="JavaScript: linkUnitWithModel();"
                                                         style="display: <%=displayEdit ? "" : "none"%>;" />
                                                </td>

                                            </tr>
                                            <%
                                                if (archDetailsWbo != null) {
                                            %>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b><font size="2" color="black">   
                                                        <fmt:message key="scarification" />
                                                    </b>
                                                </td>

                                                <td style="width: 70%;">
                                                    <b><font color="red" size="3" id="nameCell">
                                                        <%=archDetailsWbo.getAttribute("categoryName") != null ? archDetailsWbo.getAttribute("categoryName") : "---"%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="totalarea" />
                                                    </b>
                                                </td>

                                                <td style="width: 70%;">
                                                    <b><font color="red" size="3" id="nameCell">
                                                        <%=archDetailsWbo.getAttribute("totalArea") != null ? archDetailsWbo.getAttribute("totalArea") : "---"%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b><font size="2" color="black">   	
                                                        <fmt:message key="netarea" />
                                                    </b>
                                                </td>

                                                <td style="width: 70%;">
                                                    <b><font color="red" size="3" id="nameCell">
                                                        <%=archDetailsWbo.getAttribute("netArea") != null ? archDetailsWbo.getAttribute("netArea") : "---"%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="rooms" />
                                                    </b>
                                                </td>

                                                <td style="width: 70%;">
                                                    <b><font color="red" size="3" id="nameCell">
                                                        <%=archDetailsWbo.getAttribute("roomsNo") != null ? archDetailsWbo.getAttribute("roomsNo") : "---"%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="kitchens" />
                                                    </b>
                                                </td>

                                                <td style="width: 70%;">
                                                    <b><font color="red" size="3" id="nameCell">
                                                        <%=archDetailsWbo.getAttribute("kitchensNo") != null ? archDetailsWbo.getAttribute("kitchensNo") : "---"%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b><font size="2" color="black">	
                                                        <fmt:message key="pathrooms" />
                                                    </b>
                                                </td>

                                                <td style="width: 70%;">
                                                    <b><font color="red" size="3" id="nameCell">
                                                        <%=archDetailsWbo.getAttribute("pathroomNo") != null ? archDetailsWbo.getAttribute("pathroomNo") : "---"%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC" style="width: 30%;">
                                                    <b><font size="2" color="black">
                                                        <fmt:message key="balcony" />
                                                    </b>
                                                </td>

                                                <td style="width: 70%;">
                                                    <b><font color="red" size="3" id="nameCell">
                                                        <%=archDetailsWbo.getAttribute("balconyNo") != null ? archDetailsWbo.getAttribute("balconyNo") : "---"%>
                                                        </font>
                                                    </b>
                                                </td>

                                            </tr>
                                            <%
                                            } else {
                                            %>
                                            <tr>
                                                <td colspan="2">
                                                    <br/><b style="font-size: large;">
                                                        <fmt:message key="nomodeldetails" />
                                                    </b><br/><br/>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </table>
                                    </td>
                                    <td style="width: 70%;">
                                        <% if (imagesPathModel.size() > 0) {
                                        %>
                                        <div class="image_carousel">
                                            <div id="foo2">
                                                <%for (int i = 0; i < imagesPathModel.size(); i++) {%>
                                                <img class="imageClass" src="<%=imagesPathModel.get(i)%>" width="600" height="600"/>
                                                <%}%>
                                            </div>
                                            <div class="clearfix"></div>
                                            <a class="prev" id="foo2_prev" href="#"><span>Previous</span></a>
                                            <a class="next" id="foo2_next" href="#"><span>Next</span></a>
                                        </div>
                                        <% } else {
                                        %>
                                        <b style="font-size: large;">
                                            <fmt:message key="noimagemodel" />
                                        </b>
                                        <%
                                            }
                                        %>
                                    </td>
                                </tr>
                            </table>
                            <%
                                }
                            %>
                        </fieldset>
                    </TD>
                </TR>
            </TABLE>

            <br />


        </FORM>
        <div id="addOnsDiv" style="width: 50% !important;display: none;position: fixed">
            <div style="clear: both;margin-left: 80%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;"><img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                -webkit-border-radius: 100px;
                                                                                                -moz-border-radius: 100px;
                                                                                                border-radius: 100px;" onclick="closeBPopup(this)"/>
            </div>
            <div class="login" style="width: 60%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <h3 align="center" style="vertical-align: middle" id="AddOnTit"></h3>
                <table class="table" id="OnsTbl">

                    <tr>
                        <td id="typeT" name="typeT" style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;" > <fmt:message key="AddOnsType"/> </td>
                        <td style="text-align: right;" id="dateTypeTD">
                            <select id="addOnsType" name="addOnsType" style="width: 160px; font-size: medium; font-weight: bold;">
                                <sw:WBOOptionList wboList="<%=unitAddonsList%>" displayAttribute="projectName" valueAttribute="projectID"/>
                            </select>

                        </td>
                    </tr>
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"><fmt:message key="onPrice"/></TD>
                        <td style="text-align: right;"><input style="width: 160px;" type="number" id="onPrice" name="onPrice"/></td>
                    </tr>
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"><fmt:message key="onArea"/>/<fmt:message key="onUnit"/></TD>
                        <td style="text-align: right;"><input style="width: 160px;" type="number" id="onArea" name="onArea"/></td>
                    </tr>

                </table>
                <div style="text-align: left;margin-left: 2%;margin-right: auto;" >
                    <button type="button" onclick="javascript: saveUnitAddon('<%=unitWbo.getAttribute("projectID")%>');" style="font-size: 14px; font-weight: bold; width: 150px"> <fmt:message key="save"/> </button>
                </div>

            </div>
        </div>
                 <div id="addOnsDiv2" style="width: 50% !important;display: none;position: fixed">
            <div style="clear: both;margin-left: 80%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;"><img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                -webkit-border-radius: 100px;
                                                                                                -moz-border-radius: 100px;
                                                                                                border-radius: 100px;" onclick="closeBPopup(this)"/>
            </div>
            <div class="login" style="width: 60%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <h3 align="center" style="vertical-align: middle" id="AddOnTit1"></h3>
                <table class="table" id="OnsTbl">

                    <tr>
                        <td style="text-align: right;" id="dateTypeTD">
                            <input type="hidden" id="addonName" />

                        </td>
                    </tr>
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"><fmt:message key="onPrice"/></TD>
                        <td style="text-align: right;"><input style="width: 160px;" type="number" id="onPrice1" name="onPrice1"/></td>
                    </tr>
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"><fmt:message key="onArea"/>/<fmt:message key="onUnit"/></TD>
                        <td style="text-align: right;"><input style="width: 160px;" type="number" id="onArea1" name="onArea1"/></td>
                    </tr>

                </table>
                <div style="text-align: left;margin-left: 2%;margin-right: auto;" >
                    <button type="button" onclick="javascript: saveUnitAddon('<%=unitWbo.getAttribute("projectID")%>');" style="font-size: 14px; font-weight: bold; width: 150px"> <fmt:message key="save"/> </button>
                </div>

            </div>
        </div>

       <div id="addDateDiv" style="width: 70% !important;display: none;position: fixed">
            <div style="clear: both;margin-left: 80%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;"><img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                                    -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                                    box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                                                    -webkit-border-radius: 100px;
                                                                                                                    -moz-border-radius: 100px;
                                                                                                                    border-radius: 100px;" onclick="closeBPopup(this)"/>
            </div>
            <div class="login" style="width: 60%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <h1 align="center" style="vertical-align: middle"> <fmt:message key="addDate"/></h1>
                <div align="left" style="width: 100%; display: block;">
                    <img src="img/678092-sign-add-128.png" width="30" height="30" style="vertical-align: middle;" onclick="newDate()"/>
                </div>
                <%if (timeLine.size() <= 0) {%>
                <table class="table" id="DateTbl">
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="chsDate"/> </td>
                        <td style="text-align:right" id="ChoosenDateTD">
                            <input id="ChoosenDate" type="text" maxlength="50" value="<%=nowTime%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="dateType"/> </td>
                        <td td style="text-align:right" id="dateTypeTD">
                            <select id="dateType" name="dateType" STYLE="width: 60%;font-size: medium; font-weight: bold;">
                                <option value="تاريخ التسليم">تاريخ التسليم</option>
                                <option value="تاريخ دخول الكهرباء">تاريخ دخول الكهرباء</option>
                                <option value="تاريخ دخول عداد المياة">تاريخ دخول عداد المياة</option>
                            </select>
                        </td>
                    </tr>
                </table>
                <div style="text-align: left;margin-left: 2%;margin-right: auto;" >
                    <button type="button" onclick="javascript: saveUnitDate('<%=unitWbo.getAttribute("projectID")%>');" style="font-size: 14px; font-weight: bold; width: 150px"> <fmt:message key="save"/> <img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
                </div>
                <%} else {
                    for (int i = 0; i < timeLine.size(); i++) {
                        WebBusinessObject timeLineWbo = timeLine.get(i);%>
                <table class="table" id="showDateTbl">
                    <tr id="oldDate<%=timeLineWbo.getAttribute("id")%>">
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="dateType"/> </td>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: right;"> <b><font color="red" size="3"> <%=timeLineWbo.getAttribute("dateType")%> </font></b>
                    </TR>
                    <tr id="oldDateType<%=timeLineWbo.getAttribute("id")%>">
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="chsDate"/> </td>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: right;"> <b><font color="red" size="3"> <%=timeLineWbo.getAttribute("unitDate")%> </font></b>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: right;">
                            <div align="center" style="width: 100%; display: block;">
                                <img src="images/icons/edit.png" width="19" height="19" style="vertical-align: middle; display: <%=userPrevList.contains("EDIT_UNIT_TIMELINE") ? "block" : "none"%>;" onclick="editDate(<%=timeLineWbo.getAttribute("id")%>)"/>
                                <INPUT id="hiddenID" type="hidden" value="">
                                <img src="images/icons/stop.png" width="19" height="19" style="vertical-align: middle; display: <%=userPrevList.contains("DELETE_UNIT_TIMELINE") ? "block" : "none"%>;" onclick="deleteDate(<%=timeLineWbo.getAttribute("id")%>)"/>
                            </div>
                        </TD>
                    </TR>
                </TABLE>
                <table class="table" id="editDateTbl" style="display: none;">
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="chsDate"/> </td>
                        <td style="text-align:right" id="ChoosenDateTDEdit">
                            <input id="ChoosenDateEdit" type="text" maxlength="50" value="<%=nowTime%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="dateType"/> </td>
                        <td td style="text-align:right" id="dateTypeTDEdit">
                            <select id="dateTypeEdit" name="dateTypeEdit" STYLE="width: 60%;font-size: medium; font-weight: bold;">
                                <option value="تاريخ التسليم">تاريخ التسليم</option>
                                <option value="تاريخ دخول الكهرباء">تاريخ دخول الكهرباء</option>
                                <option value="تاريخ دخول عداد المياة">تاريخ دخول عداد المياة</option>
                            </select>
                        </td>
                    </tr>
                    <TR>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: center; " colspan="2">
                            <button type="button" onclick="javascript: saveEditUnitDate(<%=unitWbo.getAttribute("projectID")%>);" style="font-size: 14px; font-weight: bold; width: 150px"> <fmt:message key="save"/> <img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
                        </TD>
                    </TR>
                </table>
                <%}%>
                <%}%>
                <DIV id="DateTbl" style="display: none;">
                    <table class="table" >
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="chsDate"/> </td>
                            <td style="text-align:right" id="ChoosenDateTD">
                                <input id="ChoosenDate" type="text" maxlength="50" value="<%=nowTime%>"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: left;"> <fmt:message key="dateType"/> </td>
                            <td td style="text-align:right" id="dateTypeTD">
                                <select id="dateType" name="dateType" STYLE="width: 60%;font-size: medium; font-weight: bold;">
                                    <option value="تاريخ التسليم">تاريخ التسليم</option>
                                    <option value="تاريخ دخول الكهرباء">تاريخ دخول الكهرباء</option>
                                    <option value="تاريخ دخول عداد المياة">تاريخ دخول عداد المياة</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: left;margin-left: 2%;margin-right: auto;" >
                        <button type="button" onclick="javascript: saveUnitDate('<%=unitWbo.getAttribute("projectID")%>');" style="font-size: 14px; font-weight: bold; width: 150px"> <fmt:message key="save"/> <img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
                    </div>
                </DIV>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg"> <fmt:message key="saved"/> </div>
            </div>
        </div>
    </body>
</html>