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


<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        Vector<WebBusinessObject> paymentPlace = (Vector) request.getAttribute("paymentPlace");
        Vector<WebBusinessObject> mainCatsTypesBuilding = new Vector();
        mainCatsTypesBuilding = (Vector) request.getAttribute("dataBuilding");
        String userId = null;
        ArrayList<WebBusinessObject> projectsLst = (ArrayList<WebBusinessObject>) request.getAttribute("projects");
        ArrayList<WebBusinessObject> unitTypesList = (ArrayList<WebBusinessObject>) request.getAttribute("unitTypesList");
        ArrayList<WebBusinessObject> bokersList = (ArrayList<WebBusinessObject>) request.getAttribute("bokersList");
        String messageFlag = (String) request.getAttribute("messageFlag");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String searchBy = (String) request.getAttribute("searchBy");
        String[] projectsArr = (String[]) request.getAttribute("projectsArr");
        String AddOnPrice, totalPrice, ClientName, Status, reserve, buy, contract, available, reserved, buyed;
        if (searchBy == null) {
            searchBy = "unitNo";
        }
        String AttaD, viewUF, viewMF, viewP;
        String unitTypeID = request.getAttribute("unitTypeID") != null ? (String) request.getAttribute("unitTypeID") : "";
        String chooseC, ClintInfo, Details, UnitOwner, Upload;
        String status = (String) request.getAttribute("status");
        ArrayList<WebBusinessObject> AreaList = (ArrayList<WebBusinessObject>) request.getAttribute("AreaList");
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
        String align = null;
        String dir = null;
        String style = null;
        String sTitle, Reservation_booked, allU, noEx, pay_Plan, message, unitC, unitP, unitCode1, unitCode, Projecth, Areah, projectClient, SearchW, unitType, search, unitArea, model;
        String ReserveUnit, SalesOfficer, ClientNo, Search, Broker, ReservationPeriod,
                payPu = "", installment, Cash,hold, Area, ReservationPreamble, PaymentSys, PaymentPlace, noBranch, ReserveNow, buyUnit, successMsg, failMsg,
                clientRequiredMsg, by, rsrv_Status;
        String viewA, Att_upl, Att_N_upl, WrongNo, noCon, notes;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Search";
            tableHeader[0] = "id";
            tableHeader[1] = "username";
            tableHeader[2] = "email";
            tableHeader[3] = "full name";
            SearchW = "Search With:";
            Areah = "Region";
            projectClient = "Project Clients";
            message = "";
            unitCode = "Unit Code/project";
            unitType = "Unit Type";
            search = "Search";
            unitArea = " Unit Area ";
            model = " Model ";
            Projecth = "Project";
            unitCode1 = "Building Code";
            unitC = "Unit Code";
            unitP = "price";
            AddOnPrice = "Add Ons Price";
            Area = "Area";
            totalPrice = "Total Price";
            ClientName = "Client Name";
            Status = "Status";
            reserve = "Reserve";
            buy = "Waiver";
            contract = "Contract";
            available = "Available";
            reserved = "Reserved";
            buyed = "Sold";
            hold = "Hold";
            Reservation_booked = "Reservation booked";
            allU = "All";
            installment = "Installment";
            Cash = "Cash";
            pay_Plan = "Payment Plans";
            noEx = "There Is No";
            ReserveUnit = "Reserve Unit";
            SalesOfficer = "Current User";
            ClientNo = "Client Number";
            Search = "Search";
            Broker = "Source";
            payPu = "Unit's Payment Plans";
            ReservationPeriod = "Reservation Period(Per Hour)";
            viewA = "View Attachments";
            Att_upl = "Attachments have been Uploaded";
            Att_N_upl = "Attachments have not been Uploaded";
            WrongNo = "Wrong Number";
            ReservationPreamble = "Reservation Cost";
            PaymentSys = "Payment System";
            PaymentPlace = "Payment Place";
            noBranch = "There Is No Breanch";
            ReserveNow = "Reserve Now";
            buyUnit = "Waiver";
            noCon = "there is no attached contractor";
            AttaD = "Attach Engineering Drawing";
            viewUF = "View Unit's File";
            viewMF = "View Model's File";
            viewP = "View All Pictures";
            chooseC = "you should choose client first";
            Details = "Details";
            UnitOwner = "Unit Owner";
            Upload = "Upload";
            ClintInfo = "Client Informations";
            successMsg = "Save Successfully";
            failMsg = "Fail to Save";
            clientRequiredMsg = "You must select client to save";
            notes = "Notes";
            by = "By:";
            rsrv_Status = "Reservation Status";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "بحث عن وحده عقارية";
            tableHeader[0] = "رقم العميل";
            tableHeader[1] = "إسم العميل";
            tableHeader[2] = "رقم الموبايل";
            tableHeader[3] = "الايميل";
            SearchW = "بحث ب: ";
            Areah = "المنطقة";
            Area = "المساحه";
            payPu = "خطط الدفع للوحدة";
            projectClient = "عملاء المشروع";
            message = "";
            unitCode = "كود الوحدة/ المشروع ";
            unitType = "نوع الوحدة";
            unitCode1 = " كود العمارة";
            search = "بحث";
            hold = "حجز مؤقت";
            AddOnPrice = "سعر الأضافات";
            totalPrice = "السعر الأجمالي";
            ClientName = "اسم العميل";
            Status = "الحالة";
            noCon = "لا يوجد عقد مرفق";
            reserve = "حجز";
            buy = "تنازل";
            viewA = "عرض المستندات";
            Att_upl = "تم رفع الملفات";
            Att_N_upl = "لم يتم رفع الملفات";
            WrongNo = "هذا الرقم غير صحيح";
            contract = "العقد";
            available = "متاحة";
            reserved = "محجوزة";
            buyed = "مباعة";
            Reservation_booked = "حجز مرتجع";
            allU = "الكل";
            pay_Plan = "خطط الدفع";
            unitArea = " المساحة ";
            model = " النموذج ";
            Projecth = "المشروع";
            unitC = "كود الوحده";
            unitP = "السعر";
            noEx = "لا يوجد";
            ReserveUnit = "حجز وحدة";
            SalesOfficer = "المستخدم الحالي";
            ClientNo = "رقم العميل";
            Search = "بحث  ";
            Broker = "المصدر";
            installment = "تقسيط";
            Cash = "فوري";
            ReservationPeriod = "مدة الحجز (بالساعة)";

            ReservationPreamble = "مقدم الحجز";
            PaymentSys = "نظام الدفع";
            PaymentPlace = "مكان الدفع";
            noBranch = "لم يتم العثور على فروع";
            ReserveNow = "حجز الأن";
            buyUnit = "التنازل";
            chooseC = "يجب أولا إختيار عميل";
            Details = "تفاصيل";
            UnitOwner = "مالك وحدة";
            Upload = "تحميل";
            ClintInfo = "بيانات العميل";
            AttaD = "أرفاق رسم هندسي";
            viewUF = "مشاهدة ملفات الوحده";
            viewMF = "مشاهدة ملفات النموذج";
            viewP = "عرض جميع الصور";
            successMsg = "تم الحفظ بنجاح";
            failMsg = "لم يتم الحفظ";
            clientRequiredMsg = "يجب أختيار عميل للحفظ";
            notes = "ملاحظات";
            by = "بواسطة:";
            rsrv_Status = "حالة الحجز";
        }

        String unitAreaID = request.getAttribute("unitAreaID") != null ? (String) request.getAttribute("unitAreaID") : "All";
        String untStsExlRprt = request.getAttribute("untStsExlRprt") != null ? (String) request.getAttribute("untStsExlRprt") : "";

        String companyName = metaMgr.getCompanyNameForLogo();
        String logoName = "logo.png";
        if (companyName != null) {
            logoName = "logo-" + companyName + ".png";
        }
        DecimalFormat df = new DecimalFormat("#,##0.00");
        String clientWaiver = "";
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="css/chosen.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script src="js/select2.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>


    </HEAD>
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
            $("#unitTime").datepicker({
                changeMonth: true,
                changeYear: true,
                minDate: new Date(),
                dateFormat: "yy/mm/dd",
                defaultDate: new Date()
            });
            $("#unitTime").datepicker("setDate", new Date());

            $('#projectsTbl').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[5, 25, 50, 100, -1], [5, 25, 50, 100, "All"]],
                iDisplayLength: 5,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
            }).fadeIn(2000);

            var unitAreaID = '<%=unitAreaID%>';
            $('#unitAreaID  option[value="' + unitAreaID + '"]').prop("selected", true);
        });


        $(function () {
            $("input[name=search]").change(function () {
                var value = $("input[name=search]:checked").attr("id");
                if (value === 'buildingCode') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "<%=unitCode1%>");
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
                    $("#searchValue").attr("placeholder", "<%=unitCode%>");
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
        function getClientInfo2(obj) {
            var searchByValue = '';
            var value = $("input[name='search']:checked").val();
            $("#info").html("");
            if ($("#searchValue").val().length > 0) {
                searchByValue = $(obj).parent().parent().find("#searchValue").val();
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=getUnitByProject&searchBy=" + value + "&searchByValue=" + searchByValue;
                document.CLIENT_FORM.submit();
                $("#clients").css("display", "");
                $("#showClients").val("show");
            } else {
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=getUnitByProject";
                document.CLIENT_FORM.submit();
            }
        }
        function openSearch(obj)
        {
            if (obj.name === "bSell")
            { //  document.getElementById("treatType").value="1";
                $('#treatType').val("1");
                getDataInPopup('ClientServlet?op=getClientsPopup&value=' + $("#clientCodeSell").val());
            }
            else
            {
                $('#treatType').val("2");
                getDataInPopup('ClientServlet?op=getClientsPopup&value=' + $("#clientCode").val());
            }

        }

        function exportToExcel() {
            var unitStatus = $('input[name=unitStatus]:checked').val();
            var projects = "";
            $('input[name="projects"]:checked').each(function () {
                projects = projects + this.value + ",";
            });

            var searchByValue = $("#searchValue").val();
            var value = 'unitNo';

            var url = "<%=context%>/SearchServlet?op=getUnitByProject&excel=1&unitStatus=" + unitStatus + "&projects=" + projects + "&search=" + value + "&searchByValue=" + searchByValue;
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=350, height=350");
        }

        function viewClientContract(clientID) {
            $.ajax({
                type: "post",
                url: "./EmailServlet?op=getContractID&clientID=" + clientID,
                success: function (jsonString) {
                    if (jsonString !== '') {
                        var url = "<%=context%>/EmailServlet?op=viewDocument&docID=" + jsonString + "&docType=pdf";
                        window.open(url);
                    }
                },
                error: function () {
                    alert('<%=noCon%>');
                }
            });
        }
        function getReserveSellUser(obj, unitID, type) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=getReserveSellUserAjax",
                data: {
                    unitID: unitID,
                    type: type
                }, success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status === 'ok') {
                        $(obj).attr("title", "<%=by%> " + info.fullName);
                    }
                }
            });
        }
    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
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

        function viewDocuments(parentId) {
            var url = '<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId + '';
            var wind = window.open(url, "<%=viewA%>", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }

        function viewGallery(unitID, modelID) {
            var url = '<%=context%>/UnitDocReaderServlet?op=unitDocGallery&unitID=' + unitID + '&modelID=' + modelID;
            var wind = window.open(url, "<%=viewA%>", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
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
                        $("#attachInfo").html("<font color='white'><%=Att_upl%></font>");

                    },
                    error: function ()
                    {
                        $("#attachInfo").html("<font color='red'><%= Att_N_upl%></font>");
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
        function popup(proId, busObjId, projectName, mainProject) {
            $('#reserveDialog').bPopup({modal: true});
            $('#reserveDialog').css("display", "block");
            $("#reservedPlace").html(projectName);
            $("#reservedPlaceMain").html(mainProject);


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
                        $("#errorMsgReserve").html("<%=WrongNo%>");
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
            var brokerID = document.getElementById("brokerID").value;
                            <% if(metaMgr.getRealEstateWeb().equals(0)){ %>
    
        var mainBuilding = document.getElementById("mainBuilding").value;
          //var sourceID = document.getElementById("sourceID").value;
            var unitNotes = document.getElementById("unitNotes").value;
<% } %> 


            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=saveFastAvailableUnits",
                data: {
                    clientId: clientId,
                    unitId: unitId,
                    budget: budget,
                    period: period,
                    unitCategoryId: parentId,
                    paymentSystem: paymentSystem,
                    paymentPlace: paymentPlace,
                    issueId: parentId,
                    brokerID: brokerID
                    /*mainBuilding: mainBuilding,
                    sourceID: sourceID,
                    unitNotes: unitNotes*/
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
                        $("#parentId").val("");
                        $("#reservedPlace").html("");
                        $("#reservedPlaceMain").html("");
                        $("#clientName").html("");
                        $("#brokerID").val("");
                        alert('Reservation successfully');
                        location.reload(); // إعادة تحميل الصفحة بعد إنهاء العملية بنجاح
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
                        $("#sellNotes").val("");
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
                        $("#errorMsg" + type).html("<%=WrongNo%>");
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
        function viewPaymentPlan(projectID, projectName, price, addonPrice, paymentPlanID, startDate) {
            var divTag = $("#installmentDiv");
            $.ajax({
                type: "post",
                url: '<%=context%>/FinancialServlet?op=getInstallmentsForm',
                data: {
                    projectID: projectID,
                    price: price,
                    addonPrice: addonPrice,
                    paymentPlanID: paymentPlanID,
                    startDate: startDate
                }, success: function (data) {
                    divTag.html(data).dialog({
                        modal: true,
                        title: "<%=payPu%> " + projectName,
                        show: "fade",
                        hide: "explode",
                        width: 950,
                        closeOnEscape: false,
                        position: {
                            my: 'center',
                            at: 'center'
                        }, buttons: {
                            'Close': function () {
                                $(this).dialog('close').dialog('destroy');
                                divTag.html("");
                            },
                            'Save': function () {
                                saveInstallments();
                            }
                        }
                    }).dialog('open');
                }, error: function (data) {
                    alert(data);
                }
            });
            function saveInstallments() {
                if ($("#clientID").val() === '') {
                    alert("<%=clientRequiredMsg%>");
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/FinancialServlet?op=saveInstallmentsAjax",
                        data: $("#INSTALLMENT_FORM").serialize(),
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                alert("<%=successMsg%>");
                                var divTag = $("#installmentDiv");
                                divTag.dialog('close').dialog('destroy');
                                divTag.html("");
                                var m = new Date();
                                var dateString = m.getUTCFullYear() + "/" + (m.getUTCMonth() + 1) + "/" + m.getUTCDate();
                                var url = "<%=context%>/UnitServlet?op=getMyPaymentPlans&fromD=" + dateString + "&toD=" + dateString + "&reqTyp=";
                                window.open(url, "paymentPlanTab");
                            } else {
                                alert("<%=failMsg%>");
                            }
                        }
                    });
                }
            }
        }
    </SCRIPT>
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
        .ui-dialog-titlebar-close {
            display: none;
        }
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <div id="installmentDiv"></div>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="display:none;width: 310px;margin-top: 10px;margin-left: auto;margin-right: auto;height: 20px;background-color: #f3f3f5;" id="errorMsg">
                    <FONT style="color: red;font-size: 16px;"><b><%=chooseC%></B></font>
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
                        <br/>
                        <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                            <TR>
                                <TD style="border: none" width="70%">
                                    <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER">
                                        <tr>
                                            <td style="<%=style%>" class='td' nowrap colspan="2">
                                                <label style="font-size: 20px;"> <%=SearchW%> </label>
                                                <span><input type="radio" name="search" value="unitNo" id="unitNo" <%=searchBy.equalsIgnoreCase("unitNo") ? "checked" : ""%>  />  <font size="2"  color="#000"><b><%= unitCode%></b></font></span>
                                                <span><input type="radio" name="search" value="buildingCode" id="buildingCode" <%=searchBy.equalsIgnoreCase("buildingCode") ? "checked" : ""%> /><font size="2" color="#000"><b> <%= unitCode1%> </b></font></span></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td STYLE="<%=style%>" class='td' nowrap>
                                                &nbsp;
                                            </td>
                                            <td STYLE="<%=style%>" class='td' nowrap>
                                                <input type="text" name="searchValue" id="searchValue" placeholder="<%=unitCode%>" />
                                                <input type="button" value="<%=search%>" style="display: inline" class="" width="150px" onclick="getClientInfo2(this)"/>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td style="<%=style%>" class='td'>
                                                <%=unitType%> 
                                            </td>
                                            <td style="<%=style%>" class='td'>
                                                <select name="unitTypeID" id="unitTypeID" style="width: 291px; font-size: 18px;">
                                                    <option value=""></option>
                                                    <sw:WBOOptionList wboList="<%=unitTypesList%>" displayAttribute="typeName" valueAttribute="id" scrollToValue="<%=unitTypeID%>"/>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td style="<%=style%>" class='td'>
                                                <%=unitArea%> 
                                            </td>
                                            <td style="<%=style%>" class='td'>
                                                <select id="unitAreaID" name="unitAreaID" style="width:170px;">
                                                    <OPTION value="All">All</OPTION>
                                                        <sw:WBOOptionList wboList="<%=AreaList%>" displayAttribute="AREA" valueAttribute="AREA" />
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <TD style="border: none" align="right" width="50%">
                                    <img alt="Database Configuration" src="images/<%=logoName%>" width="190" style="border: none; vertical-align: middle;" />
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
                        <% }%>

                        <br/>

                        <input type="hidden" name="rows" id="rows" value="<%=projectsLst.size()%>">
                        <div style="width:60%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                            <TABLE dir="<%=dir%>"  class="projectsTbl" id="projectsTbl">
                                <THEAD>
                                    <tr>
                                        <th></th>
                                        <th> <%=Projecth%> </th>

                                        <th> <%=Areah%> </th>

                                       <%-- <th> <%=projectClient%> </th> --%>


                                    </tr>
                                </THEAD>

                                <tbody>
                                    <%
                                        String type = "";
                                        for (int i = 0; i < projectsLst.size(); i++) {
                                            WebBusinessObject wbo = (WebBusinessObject) projectsLst.get(i);%>
                                    <TR>
                                        <TD  CLASS="cell">
                                            <INPUT TYPE="CHECKBOX" NAME="projects" value ="<%=wbo.getAttribute("projectID")%>" ID="project<%=i%>" <%if (projectsArr != null && projectsLst.size() != projectsArr.length && Arrays.asList(projectsArr).contains(wbo.getAttribute("projectID"))) {%>checked="true"<%}%> class="off"> 
                                        </TD>
                                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:center;">
                                            <%=wbo.getAttribute("projectName")%>
                                        </TD>


                                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:right;">
                                            <%if (wbo.getAttribute("prjZoneName") != null) {%>
                                            <%=wbo.getAttribute("prjZoneName")%>
                                            <% } else { %>

                                            <% }%>
                                        </TD>
                                       <%-- <TD  CLASS="cell" STYLE="padding-left:40;text-align: center; width: 50px;">
                                            <a href="#" onclick="printProjectInformation(<%=wbo.getAttribute("projectID")%>)"><image style="height:39px;" src="images/pdf_icon.gif" title="ProjectDetails"/></a>
                                        </td> --%>


                                    </TR>
                                    <%}%>
                                </tbody>
                            </TABLE>
                            <br/>
                            <input type="button" value="<%=search%>" style="display: inline" class="" width="150px" onclick="getClientInfo2(this)"/>

                        </DIV>
                        <%--<TABLE id="projectsTbl" CLASS="blueBorder" style="border-color: silver; border-right-WIDTH:1px;" WIDTH="600" CELLPADDING="0" CELLSPACING="0"  ALIGN="center" DIR="<%=dir%>">
                            <TR class="backgroundHeader">
                                <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="50">
                                    <input type="checkbox" onclick="JavaScript: selectAll(this);">
                                </TD>
                                <TD nowrap CLASS="firstname" WIDTH="550" STYLE="border-top-WIDTH:0; font-size:12;color:white;" nowrap >
                                    المشروع
                                </TD>
                            </TR>

                            <input type="hidden" name="rows" id="rows" value="<%=projectsVec.size()%>">

                            <%
                                for (int i = 0; i < projectsVec.size(); i++) {
                                    WebBusinessObject wbo = (WebBusinessObject) projectsVec.get(i);
                            %>
                            <TR>
                                <TD  CLASS="cell">
                                    <INPUT TYPE="CHECKBOX" NAME="projects" value ="<%=wbo.getAttribute("projectID")%>" ID="project<%=i%>"> 
                                </TD>

                                <TD  CLASS="cell" STYLE="padding-left:40;text-align:right;">
                                    <%=wbo.getAttribute("projectName")%>
                                </TD>
                            </TR>
                            <%}%>
                        </TABLE>--%>
                        <br/>
                    </FIELDSET>
                    <br />
                </div>
<table style="direction: <%=dir%>; width: 60%; padding-bottom: 2%; padding-top: 2%; margin-bottom: 2%; margin-top: 2%;">
                    <tr>
                        <% if (userPrevList.contains("SHOW_RESERVED")){ %>
                        <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                            <input type="radio" name="unitStatus" value="" <%=untStsExlRprt != null && untStsExlRprt.equals("") ? "checked" : ""%>>  
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                            <font size=3 color="white">
                            <%=allU%>
                        </td>

                        <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                            <input type="radio" name="unitStatus" value="8" <%=untStsExlRprt != null && untStsExlRprt.equals("8") ? "checked" : ""%>>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                            <font size=3 color="white">
                            <%=available%>
                        </td>

                        <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                            <input type="radio" name="unitStatus" value="9" <%=untStsExlRprt != null && untStsExlRprt.equals("9") ? "checked" : ""%>>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                            <font size=3 color="white">
                            <%=reserved%> 

                        </td>

                        <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                            <input type="radio" name="unitStatus" value="10" <%=untStsExlRprt != null && untStsExlRprt.equals("10") ? "checked" : ""%>>  
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                            <font size=3 color="white">
                            <%=buyed%> 

                        </td>

                        <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                            <input type="radio" name="unitStatus" value="33" <%=untStsExlRprt != null && untStsExlRprt.equals("33") ? "checked" : ""%>> 
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                            <font size=3 color="white">
                            <%=Reservation_booked%> 
                        </td>

                        <td bgcolor="#F7F6F6" style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; text-align:center; width: 30%; border: none;" valign="middle" rowspan="2">
                            <input class="button" class="button2" type="button" onclick="exportToExcel();" style="width: 50%; color: #000; font-size:15; font-weight:bold;" value="Excel">

                        </td>
                        <%} else {%>
                        <td bgcolor="#F7F6F6" style="text-align:center; width: 5%; border: none;" valign="middle">
                            <input type="radio" name="unitStatus" value="8" checked>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 10%;">
                            <font size=3 color="white">
                            <%=available%>
                        </td>
                        <%}%>

                    </tr>
                </table>
                <%
                    if (units != null) {
                %>
                

            <div style="width: 95%;margin-right: auto;margin-left: auto;" id="showClients">
              <table dir="<%=dir%>" width="100%" id="clients" border="1" cellspacing="0" cellpadding="5">
                <thead>
                  <!-- الصف الرئيسي -->
                  <tr>
                    <th style="color:#005599;font:20px;font-weight:bold;width:9%;"></th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=Projecth%></th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=model%></th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=unitC%></th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:9%;">Floor</th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:9%;">Room Of No.</th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=Area%></th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=unitP%></th>
                    <% if ("1".equals(metaMgr.getAddonActive())) { %>
                      <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=AddOnPrice%></th>
                      <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=totalPrice%></th>
                    <% } %>
                    <th style="color:#005599;font:14px;font-weight:bold;width:55%;"><%=ClientName%></th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:55%;">User Name</th>
                    <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=Status%></th>
                    <% if (metaMgr.getDataMigration().equals("1")) {
                         if (userPrevList.contains("RESERVE_UNIT")) { %>
                      <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=reserve%></th>
                    <% } if (userPrevList.contains("SELL_UNIT")) { %>
                      <th style="color:#005599;font:14px;font-weight:bold;width:9%;"><%=buy%></th>
                    <% }} %>
                  </tr>

                  <!-- صف البحث -->
                  <tr>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <% if ("1".equals(metaMgr.getAddonActive())) { %>
                      <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                      <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <% } %>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <% if (metaMgr.getDataMigration().equals("1")) {
                         if (userPrevList.contains("RESERVE_UNIT")) { %>
                     <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <% } if (userPrevList.contains("SELL_UNIT")) { %>
                     <th><input style="font-size:12px;font-weight:bold;width:100%;" type="text" placeholder="Search..." /></th>
                    <% }} %>
                  </tr>
                </thead>
                        <tbody >  
                            <%
                                Enumeration e = units.elements();

                                WebBusinessObject wbo = new WebBusinessObject();
                                int price = 0;
                                int addonPrice = 0;
                                int areaPrive = 0;
                                float price1 = 0;
                                float addonPrice1 = 0;

                                while (e.hasMoreElements()) {

                                    wbo = (WebBusinessObject) e.nextElement();
                                    clientWaiver = wbo.getAttribute("price").toString();
                                    if (!userPrevList.contains("SHOW_RESERVED") || wbo.getAttribute("newCode").equals("N")){
                            %>

                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <b><IMG value="" onclick="JavaScript: popupAttach(this, '<%=wbo.getAttribute("projectID")%>');" width="19px" height="19px" src="images/icons/Attach.png" title="<%=AttaD%>" alt="<%=AttaD%>" style="margin: -4px 0"/></b>
                                    &nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("projectID")%>');" width="19px" height="19px" src="images/unit_doc.png" title="<%=viewUF%>" alt="<%=viewUF%>" style="margin: -4px 0"/></b>
                                    &nbsp;
                                    <b><IMG value="" onclick="JavaScript: viewGallery('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("Model_Code")%>');" width="25px" height="25px" src="images/gallery.png" title="<%=viewP%>" alt="<%=viewP%>" style="margin: -4px 0"/></b>

                                </TD>
                                <TD>
                                    <%if (wbo.getAttribute("parentName") != null) {%>
                                    <b><%=wbo.getAttribute("parentName")%></b>
                                    <%} else {%>
                                    <b><%=noEx%></b>
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
                                    <%if (wbo.getAttribute("projectName") != null) {%>
                                    <!--a href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<1%=wbo.getAttribute("projectID")%>&searchBy=<1%=request.getAttribute("searchBy")%>&searchValue=<1%=request.getAttribute("searchValue")%>&ownerID=<1%=wbo.getAttribute("ownerID")%>"-->
                                        <b><%=wbo.getAttribute("projectName")%></b>
                                    <!--/a-->
                                    <%}
                                    %>

                                </TD>
                                <td>
                                    <b>
                                       <%=wbo.getAttribute("optionOne")%> 
                                    </b>
                                </td>
                                <td>
                                    <b>
                                       <%=wbo.getAttribute("integratedId")%> 
                                    </b>
                                </td>
                                <td>
                                    <b>
                                        <%
                                            if (wbo.getAttribute("totalArea") != null && !"".equals(wbo.getAttribute("totalArea"))) {
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
                                <%
                                    String str = (String) wbo.getAttribute("price");
                                    areaPrive = wbo.getAttribute("area") != null ? Integer.parseInt((String) wbo.getAttribute("area")) : 0;
                                    //check if int 
                                    try {

                                        Integer.parseInt(str);
                                        price = wbo.getAttribute("price") != null ? Integer.parseInt((String) wbo.getAttribute("price")) : 0;

                                    } catch (NumberFormatException e1) {
                                        //not int
                                    }
                                    //check if float
                                    try {
                                        Float.parseFloat(str);
                                        price1 = wbo.getAttribute("price") != null ? Float.valueOf((String) wbo.getAttribute("price")) : 0;
                                        price = (int) Math.ceil(price1);
                                    } catch (NumberFormatException e1) {
                                        //not float
                                    }
                                %>
                                <td>
                                    <b><%=df.format(price)%></b>
                                </td>
                                <%
                                    if ("1".equals(metaMgr.getAddonActive())) {
                                        addonPrice = wbo.getAttribute("addonPrice") != null ? Integer.parseInt((String) wbo.getAttribute("addonPrice")) : 0;
                                %>
                                <td>
                                    <b><%=df.format(addonPrice)%></b>
                                </td>
                                <td>
                                    <b><%=df.format((price * areaPrive) + addonPrice)%></b>
                                </td>
                                <%
                                    }
                                %>

                                <TD>
                                    <%if (wbo.getAttribute("clientName") != null && !((String) wbo.getAttribute("clientName")).isEmpty()) {%>
                                        <b><%=wbo.getAttribute("clientName")%></b>
                                    <!--a target="_blanck" href="<1%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<1%=wbo.getAttribute("clientId")%>&clientType=30-40">
                                        <img src="images/icons/eHR.gif" width="30" style="float: left;" title="<1%=Details%>"/>
                                    </a-->
                                    <a target="_Self" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientId")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="<%=ClintInfo%>"/>
                                    </a>

                                    <a style="display: <%=userPrevList.contains("BRCKR_ICN") ? "" : "none"%>" target="_blanck" href="<%=context%>/ClientServlet?op=newBokerClient&projectID=<%=wbo.getAttribute("projectID")%>&ownerID=<%=wbo.getAttribute("ownerID")%>&unitName=<%=wbo.getAttribute("projectName")%>">
                                        <%if (wbo.getAttribute("ownerID") != null) {%>
                                        <img src="images/icons/manager.png" width="30" style="float: left;" title="<%=UnitOwner%>"/>
                                        <%} else {%>
                                        <img src="images/notOwner.png" width="30" style="float: left;" title="<%=UnitOwner%>"/>
                                        <%}%>
                                    </a>
                                    <%} else {
                                    %>

                                    <b><%=noEx%></b>
                                    <%
                                        }
                                    %>
                                </TD>
                                <TD>
                                    <b><%=wbo.getAttribute("ownerID")%></b>
                                </TD>
                                <TD onclick="getDetails(<%=wbo.getAttribute("projectID")%>)">

                                    <%
                                        String UniStatus = "", color = "";
                                        String unitStatus = (String) wbo.getAttribute("statusName");
                                        if (wbo.getAttribute("statusName") != null) {

                                            if (unitStatus.equalsIgnoreCase("8")) {
                                                UniStatus = available;
                                                color = "green";
                                                type = "";
                                            } else if (unitStatus.equalsIgnoreCase("9")) {
                                                UniStatus = reserved;
                                                color = "red";
                                                type = "reserved";
                                            } else if (unitStatus.equalsIgnoreCase("10")) {
                                                UniStatus = buyed;
                                                color = "blue";
                                                type = "purche";
                                            }  else if (unitStatus.equalsIgnoreCase("85")) {
                                                UniStatus = hold;
                                                color = "red";
                                                type = "Hold";
                                            } else if (unitStatus.equalsIgnoreCase("33")) {
                                                UniStatus = Reservation_booked;
                                                color = "purple";
                                                type = "";
                                            }
                                        }%>
                                    <b style="color: <%=color%>" onmouseover="<%=unitStatus.equals("9") || unitStatus.equals("10") ? "JavaScript: getReserveSellUser(this, '" + wbo.getAttribute("projectID") + "', '" + type + "')" : ""%>"><%=UniStatus%></b>

                                </TD>
                                <%
                                    if (metaMgr.getDataMigration().equals("1")) {
                                        if (userPrevList.contains("RESERVE_UNIT")) {
                                            if (unitStatus != null && unitStatus.equalsIgnoreCase("8")) {%>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" >
                                    <a id="reservedBtn" onclick="popup('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("mainProjId")%>', '<%=wbo.getAttribute("projectName")%>', '<%=wbo.getAttribute("OPTION3")%>')" href="#"><%=reserve%> </a>
                                </TD>
                                <%} else {%>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;">

                                </TD>
                                <%}
                                    }
                                    if (userPrevList.contains("SELL_UNIT")) {
                                %>
                                <%if (unitStatus != null && !unitStatus.equalsIgnoreCase("8") && !unitStatus.equalsIgnoreCase("85") && !unitStatus.equalsIgnoreCase("10")) {%>
                                <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" >
                                    <a id="reservedBtn" onclick="popupSell('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("mainProjId")%>', '<%=wbo.getAttribute("projectName")%>')" href="#"><%=buy%> </a>
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


                            <% }} %>

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
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable><%=AttaD%></lable>
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
                    <input type="submit" value="<%=Upload%>"  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendFilesByAjax(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
        <div id="unitInformation"   style="width: 70% !important;display: none;position: fixed ;">

        </div>
        <div id="reserveDialog"  style="width: 50%;display: none;position: fixed;margin-left: auto;margin-right: auto;" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeReservePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " dir="<%=dir%>" style="width:100%; ">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2"><%=ReserveUnit%></td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap><%=SalesOfficer%></td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: center;">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=unitC%></td>
                        <td width="70%"style="text-align:center;"><b id="reservedPlace"></b>
                            <input type="hidden" id="unitId" name="unitId"/>
                            <input type="hidden" id="parentId" name="parentId"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=ClientNo%></td>
                        <td width="50%"style="text-align:center;">

                            <input type="number" size="7" maxlength="7" id="clientCode"  style='width:170px;float: right;' onkeyup="saveOrder(this)"/>
                        </td>
                        <td width="20%"style="text-align:right;">
                            <input type="button" onclick="JavaScript: openSearch(this);" value="<%=Search%>"  id="bReserv" name="bReserv" />
                            <div style="color: red;width: 80px;"><b  id="errorMsgReserve"></b></div>

                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=ClientName%></td>
                        <td width="70%"style="text-align:right;">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientName" style="float: right;"></b>
                        </td>
                    </tr>
                    <% if(metaMgr.getRealEstateWeb().equals(0)){ %>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>Building</td>
                        <td width="70%"style="text-align:right;">
                            <SELECT name='mainBuilding' id='mainBuilding' style="width:170px;" class="chosen-select-broker">
                                <option>----</option>
                                <%
                                    if (mainCatsTypesBuilding != null && !mainCatsTypesBuilding.isEmpty()) {
                                        for (WebBusinessObject WboBuilding : mainCatsTypesBuilding) {
                                            String productName = (String) WboBuilding.getAttribute("DESCRIPTION");
                                            String productId = (String) WboBuilding.getAttribute("CODE");%>
                                <option value='<%=productId%>'><%=productName%></option>

                                <%}
                                }%>
                            </select>
                        </td>
                    </tr>
                    <% } %>



                    <%
                        Vector getInstalmet = new Vector();
                        userId = "Radix";
                        //userId = (String) wbo.getAttribute("OPTION3");
                        String getAssetErpName = MetaDataMgr.getInstance().getAssetErpName().toString();
                        String getAssetErpPassword = MetaDataMgr.getInstance().getAssetErpPassword().toString();
                        String storeErpName = MetaDataMgr.getInstance().getStoreErpName().toString();
                        String storeErpPassword = MetaDataMgr.getInstance().getStoreErpPassword().toString();
                        String checkWeb = MetaDataMgr.getInstance().getRealEstateWeb().toString();

                        if(checkWeb.equals("1")){
                        getInstalmet = ProjectMgr.getInstance().getInstalmetWeb();
                        } else {
                        if (userId.equals(getAssetErpName)) {
                            getInstalmet = ProjectMgr.getInstance().getInstalmet(storeErpName);
                        } else if (userId.equals(getAssetErpPassword)) {
                            getInstalmet = ProjectMgr.getInstance().getInstalmet(storeErpPassword);
                        }
                        }
                    %>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>Payment Plan</td>
                        <td width="70%"style="text-align:right;">
                            <select id="brokerID" name="brokerID" style="width:170px;" class="chosen-select-broker">
                                <option value=""></option>
                                <sw:WBOOptionList wboList="<%=getInstalmet%>" displayAttribute="DESCRIPTION" valueAttribute="CODE" />
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=ReservationPreamble%></td>
                        <td width="70%"style="text-align:right;">
                            <input type="number" size="7" maxlength="7" id="budget" name="budget" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=PaymentSys%></td>
                        <td width="70%"style="text-align:right;">
                            <select name="paymentSystem" id="paymentSystem" style='width:170px;font-size:16px;'>
                                <OPTION value="1">Cash</OPTION>
                                <OPTION value="2">Cheques</OPTION>
                                <OPTION value="3">Bank Transfer</OPTION>
                                <OPTION value="4">Visa</OPTION>
                            </select>
                        </td>
                    </tr> 
                    <% if(metaMgr.getRealEstateWeb().equals(0)){ %>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">Receipt No</td>
                        <td width="70%"style="text-align:right;">
                            <input type="text" name="unitNotes" id="unitNotes" value="" style='width:170px;'/>
                        </td>
                    </tr>
                    <% } %>
                    <!--tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap><%=Broker%></td>
                        <td width="70%"style="text-align:right;">
                            <select id="sourceID" name="sourceID" style="width:170px;" class="chosen-select-broker">
                                <option value=""></option>
                                <option value="1">ترشيح</option>
                                <option value="2">عميل مباشر</option>
                                <option value="3">عميل غير مباشر</option>
                            </select>
                        </td>
                    </tr-->
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap><%=ReservationPeriod%></td>
                        <td width="70%"style="text-align:right;">
                            <input type="number" size="7" maxlength="7" id="period" name="period" style='width:170px;'
                                   <%=metaMgr.getReservationDefaultPeriod() != null && !"".equals(metaMgr.getReservationDefaultPeriod()) && !"0".equals(metaMgr.getReservationDefaultPeriod()) && !userPrevList.contains("EDIT_RESERVE_PERIOD") ? "readonly" : ""%>
                                   value="<%=metaMgr.getReservationDefaultPeriod() != null && !"".equals(metaMgr.getReservationDefaultPeriod()) && !"0".equals(metaMgr.getReservationDefaultPeriod()) ? metaMgr.getReservationDefaultPeriod() : ""%>"/>
                        </td>
                    </tr>


                    <tr style="display: none;">
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=PaymentPlace%></td>
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
                                <option><!%=noBranch%></option>
                                <!%}%>
                            </select-->
                        </td>
                    </tr>



                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input type="submit" value="<%=ReserveNow%>" onclick="javascript: reservedUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
        <div id="sellDialog" style="width: 40%;display: none;position: fixed;margin-left: auto;margin-right: auto" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeSellPopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table dir="<%=dir%>"  class="table " style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2"><%=buyUnit%></td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap><%=SalesOfficer%></td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: center;">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=unitC%></td>
                        <td width="70%"style="text-align:center;"><b id="sellPlace"></b>
                            <input type="hidden" id="unitIdSell" name="unitIdSell"/>
                            <input type="hidden" id="parentIdSell" name="parentIdSell"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">Client Name Old</td>
                        <td width="70%"style="text-align:center;"><b><%=clientWaiver%></b>
                            <input type="hidden" id="unitIdSell" name="unitIdSell"/>
                            <input type="hidden" id="parentIdSell" name="parentIdSell"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=ClientNo%></td>
                        <td width="70%"style="text-align:center;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientCodeSell"  style='width:170px;float: right;' onkeyup="getClient(this, 'Sell')"/>
                        </td>
                        <td>
                            <input type="button" onclick="JavaScript: openSearch(this);" name ="bSell" value="<%=Search%>"  />
                            <input type="hidden" id="treatType" name="treatType" value="0"/>
                            <div style="color: red;width: 80px;"><b  id="errorMsgSell"></b></div>

                            </div>
                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=ClientName%></td>
                        <td width="70%"style="text-align:right;">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientNameSell" style="float: right;"></b>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap><%=notes%></td>
                        <td width="70%"style="text-align:right;">
                            <textarea id="sellNotes" name="sellNotes" style="width: 250px; height: 100px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="clientIdSell" name="clientId"/>
                            <input type="submit" value="<%=buy%>" onclick="javascript: sellUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
        <script>
            var config = {
                '.chosen-select-broker': {no_results_text: 'No broker found with this name!', width: "170px"},
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            
            document.getElementById("idOfSaveButton").addEventListener("click", function(){
               location.reload();
            });

        </script>
        <script>
$(document).ready(function () {
    if (!$.fn.dataTable) {
        console.error('DataTables not loaded!');
        return;
    }

    var table = $('#clients').DataTable({
        orderCellsTop: true,
        fixedHeader: true,
        pageLength: 10,
        lengthMenu: [[10, 20, 50, 100, -1], [10, 20, 50, 100, "All"]],
        destroy: true,
        initComplete: function () {
            var api = this.api();
            var $thead = $(api.table().container()).find('thead');

            // إضافة صف البحث لو مش موجود
            if ($thead.find('tr').length === 1) {
                var $filterRow = $('<tr>').appendTo($thead);
                $thead.find('tr').first().find('th').each(function () {
                    $filterRow.append('<th><input type="text" placeholder="Search..." /></th>');
                });
            } else {
                $thead.find('tr:eq(1) th').each(function () {
                    if ($(this).find('input').length === 0) {
                        $(this).html('<input type="text" placeholder="Search..." />');
                    }
                });
            }
        }
    });

    // نحدد index عمود Unit Code (غيّره حسب ترتيبه الفعلي في الجدول)
    var unitCodeColIdx = 2; // مثلا لو العمود الثالث

    // البحث
    $('#clients').on('keyup change', 'thead tr:eq(1) input', function () {
        var $input = $(this);
        var $th = $input.closest('th');
        var colIdx = $th.index();
        var column = table.column(colIdx);
        var val = this.value;

        if (column && typeof column.search === 'function') {
            if (val) {
                if (colIdx === unitCodeColIdx) {
                    // لو العمود Unit Code → ends with
                    column.search(val + '$', true, false).draw();
                } else {
                    // باقي الأعمدة → contains
                    column.search(val).draw();
                }
            } else {
                column.search('').draw();
            }
        }
    });

    // كمان للـ FixedHeader نسخة
    $(document).on('keyup change', '.fixedHeader-floating thead tr:eq(1) input', function () {
        var colIdx = $(this).closest('th').index();
        var val = this.value;

        if (val) {
            if (colIdx === unitCodeColIdx) {
                table.column(colIdx).search(val + '$', true, false).draw();
            } else {
                table.column(colIdx).search(val).draw();
            }
        } else {
            table.column(colIdx).search('').draw();
        }
    });
});
</script>


    </BODY>
</HTML>     
