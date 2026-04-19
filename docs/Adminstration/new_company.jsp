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
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />   
    <%

        String status = (String) request.getAttribute("Status");

        String autoPilotMessage = (String) request.getAttribute("autoPilotMessage");
        String defaultCampaign = "";
        CampaignMgr campaignMgr = CampaignMgr.getInstance();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        if (securityUser != null && securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()) {
            defaultCampaign = securityUser.getDefaultCampaign();
            WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(defaultCampaign);
            if (campaignWbo != null) {
                defaultCampaign = (String) campaignWbo.getAttribute("campaignTitle");
            }
        }

        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd hh:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String entryDate = (String) request.getAttribute("entryDate");
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        String errorExtConn = (String) request.getAttribute("errorExtConn");
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        ArrayList<WebBusinessObject> seasonsList = (ArrayList<WebBusinessObject>) request.getAttribute("seasonsList");
        //----
        Vector<WebBusinessObject> regions = new Vector();
        regions = (Vector) request.getAttribute("regions");
        ArrayList<WebBusinessObject> regionsList = new ArrayList<WebBusinessObject>(regions);
        ArrayList<WebBusinessObject> tradeList = (ArrayList<WebBusinessObject>) request.getAttribute("tradeList");

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        Vector<WebBusinessObject> jobs = new Vector();
        jobs = (Vector) request.getAttribute("jobs");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = "center";

        String lang, langCode, style;
        String arName;

        String title_1;
        String automated;
        String fStatus;
        String msgErrorExtConn;
        String job_code, client_name, client_number, client_address, client_job, client_phone,
                client_mobile, land_phone, client_mail, knowUs, client_Marital_Status, client_gender,
                client_ssn, client_total_salary, client_city, client_notes, working_status, age,
                add, contact_person, taxNo, partner, products, recordNo, activityType;
        String dir;
        String regionName, choose, regionTitle, inter_phone, ActivityTitle, business_size, small, medium, big, activityName;
        if (stat.equals("En")) {

            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            arName = "arabic title";
            style = "text-align:left";

            title_1 = "New Company";
            fStatus = "Fail To Save This Client";
            langCode = "Ar";
            automated = "Automated";
            msgErrorExtConn = "Connection fail by Realstate";
            job_code = "job code";
            client_name = "name";
            client_number = "number";
            client_address = "client Describtion";
            client_job = "job";
            client_phone = "Client Website";
            client_mobile = "Mobile";
            land_phone = "Ground Phone";
            client_mail = "E-mail";
            choose = "Choose";
            knowUs = "Communication Through";
            client_Marital_Status = "Marital Status";
            client_gender = "Client Gender";
            client_ssn = "Social Security Number";
            client_total_salary = "Client Total Salary";
            client_city = "Client city";
            //            client_service = "Client service";
            client_notes = "Notes";
            // sup_city = "Supplier city";
            working_status = "Working";
            age = "age";
            add = "Add";

            contact_person = "Contact Person";
            taxNo = "Tax No.";
            partner = "partner";
            products = "products";
            recordNo = "Record No.";
            title_1 = "New Company";
            regionName = "Region Arabic Name";
            ActivityTitle = "Add Activity";
            fStatus = "Fail To Save This Client";
            langCode = "Ar";
            dir = "Ltr";
            activityName = "Activity";
            business_size = "Business size";
            msgErrorExtConn = "Connection fail by Realstate";
            regionTitle = "Add Region";
            inter_phone = "international";
            activityType = "Activity Type";
            small = "Small";
            medium = "medium";
            big = "large";
        } else {
            activityType = "نوع النشاط";
            style = "text-align:Right";
            lang = "English";
            arName = "المهنة";
            fStatus = "لم يتم تسجيل هذا الشركة";
            ActivityTitle = "اضافة نشاط";
            automated = "&#1578;&#1604;&#1602;&#1575;&#1574;&#1609;";
            langCode = "En";
            msgErrorExtConn = "فشل الاتصال بقاعدة بيانات العقارت";
            job_code = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1607;&#1606;&#1577;";
            client_name = "الاسم ";
            client_number = "الكود ";
            client_address = "وصف العميل";
            client_job = "المهنة";
            knowUs = "طريقة التواصل";
            client_phone = "موقع العميل الألكترونى";
            client_mobile = "رقم الهاتف";
            client_mail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
            client_city = "&#1575;&#1604;&#1605;&#1583;&#1610;&#1606;&#1607;";
            //            client_service = "&#1575;&#1604;&#1582;&#1583;&#1605;&#1607; ";
            client_notes = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            client_Marital_Status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1575;&#1580;&#1578;&#1605;&#1575;&#1593;&#1610;&#1577;";
            client_gender = "&#1575;&#1604;&#1606;&#1608;&#1593;";
            client_ssn = "&#1575;&#1604;&#1585;&#1602;&#1605; &#1575;&#1604;&#1602;&#1608;&#1605;&#1609;";
            client_total_salary = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1609; &#1575;&#1604;&#1583;&#1582;&#1604;";
            age = "الفئة العمرية";
            add = "اضافة";
            //sup_city = "Supplier city";
            working_status = "&#1606;&#1588;&#1591;";
            partner = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1586;&#1608;&#1580;/&#1575;&#1604;&#1586;&#1608;&#1580;&#1577;";
            products = "&#1575;&#1604;&#1605;&#1606;&#1578;&#1580;&#1575;&#1578;";
            taxNo = "الرقم الضريبي";
            title_1 = "اضافة شركة";
            //title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            fStatus = "لم يتم تسجيل هذا العميل";
            automated = "&#1578;&#1604;&#1602;&#1575;&#1574;&#1609;";
            recordNo = "رقم السجل";
            activityName = "النشاط";

            langCode = "En";
            contact_person = "الشخص الذي يمكن التواصل معه";
            dir = "RTL";
            regionName = "المنطقة";
            choose = "اختر";
            land_phone = "الخط اﻷرضي";
            regionTitle = "إضافة منطقه";
            inter_phone = "الرقم الدولي";
            business_size = "حجم اﻷعمال";
            small = "صغير";
            medium = "متوسط";
            big = "كبير";
        }

        Vector mainProducts = (Vector) request.getAttribute("mainProducts");
        WebBusinessObject mainProjectWbo;
        String mainProductId = null;
        String mainProductName = null;

        String departmentMgrId = (String) request.getAttribute("departmentMgrId");
        String departmentMgrName = (String) request.getAttribute("departmentMgrName");
        List<WebBusinessObject> campaigns = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle("16", "key4"));
        campaigns.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));


    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>new Client</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">

        <link rel="stylesheet" href="jquery-multiSelect/jquery.multiselect.css">
        <link rel="stylesheet" href="css/chosen.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.8.9.custom.min.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <link rel="stylesheet" href="css/CSS.css">

        <link rel="stylesheet" type="text/css" href="js/jquery.dataTables.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
    </HEAD>
    <style>
        textarea{resize:none;}
    </style>

    <SCRIPT  TYPE="text/javascript">
        $(function () {
            $("#appDate1").datetimepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                timeFormat: 'hh:mm',
                dateFormat: 'yy/mm/dd'
            });
        });
        $(function () {
            $(".projectsTbl").dataTable({
                bJQueryUI: true,
                "aLengthMenu": [[10, -1], ["10", "All"]],
                iDisplayLength: 10
            });
        });
        function checkNumber(obj) {
            if ($(obj).val() == "") {
                $("#numberMsg").show();
                $("#numberMsg").text("كود الشركة مطلوب");
            } else {
                $("#numberMsg").hide();
                $("#numberMsg").html("");
            }
            var clientNumber = $(".clientNumber").val();

            if (clientNumber.length > 0) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientNumber",
                    data: {
                        clientNumber: clientNumber
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'No') {

                            $("#MSG").css("color", "green");
                            $("#MSG").css(" text-align", "left");
                            $("#MSG").text(" متاح")
                            $("#MSG").removeClass("error");
                            $("#warning").css("display", "none");
                            $("#ok").css("display", "inline")

                        } else if (info.status == 'Ok') {
                            $("#MSG").css("color", "red");
                            $("#MSG").text(" محجوز");
                            $("#MSG").addClass("error");
                            $("#warning").css("display", "inline")
                            $("#ok").css("display", "none");
                        }
                    }
                });
            } else {
                $("#MSG").text("");
                $("#warning").css("display", "none");
                $("#ok").css("display", "none");
            }
        }

        function isNumber(evt) {
            var iKeyCode = (evt.which) ? evt.which : evt.keyCode
            if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                alert("أرقام فقط");
                return false;
            }

            return true;
        }
        function checkName(obj) {
            $("#naMsg").hide();
            $("#naMsg").html("");
        }
        function activityPopup(obj) {
            $("#activityForm").find("#msg").text("");
            $('#activityForm').css("display", "block");
            $('#activityForm').bPopup({easing: 'easeOutBack', //uses jQuery easing plugin
                speed: 700,
                transition: 'slideDown', follow: [false, false]});

        }

        function checkMobile(obj) {
            var phone = $("#phone").val();

            var mobile = $("#clientMobile").val();

            if (!validateData2("numeric", this.CLIEN_FORM.clientMobile)) {
                $("#moMsg").show();
                $("#moMsg").text("ارقام فقط");

            } else if ((mobile > 0 & phone > 0) & (mobile == phone)) {

                $("#moMsg").show();
                $("#moMsg").text("الرقم مكرر");
            } else {
                $("#moMsg").hide();
                $("#moMsg").html("");
                $("#moMsg").text("");
            }

        }
        $(function () {
            $("#ClientNo").val("");

        })

        function checkClientNo(obj) {
            if (!validateData2("numeric", this.CLIEN_FORM.ClientNo)) {
                $("#numberMsg").show();
                $("#numberMsg").text("ارقام فقط");
            } else {
                $("#numberMsg").hide();
                $("#numberMsg").html("");
            }
        }
        function checkTel(obj) {
            var phone = $("#phone").val();

            var mobile = $("#clientMobile").val();
            if (!validateData2("numeric", this.CLIEN_FORM.phone)) {
                $("#telMsg").show();
                $("#telMsg").text("ارقام فقط");
            } else if ((mobile > 0 & phone > 0) & (mobile == phone)) {

                $("#telMsg").show();
                $("#telMsg").text("الرقم مكرر");
            } else {
                $("#telMsg").hide();
                $("#telMsg").html("");
            }

        }
        function checkSsn(obj) {

            if (!validateData2("numeric", this.CLIEN_FORM.clientSsn)) {
                $("#ssnMsg").show();
                $("#ssnMsg").text("ارقام فقط");
            } else {
                $("#ssnMsg").hide();
                $("#ssnMsg").html("");
            }

        }
        function totalCost(obj, evt) {


            var iKeyCode = (evt.which) ? evt.which : evt.keyCode
            if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                alert("أرقام فقط");
                return false;
            } else {


                var price = $(obj).parent().parent().find("#notes").val();

                var mount = $(obj).parent().parent().find("#budget").val();

                var total_cost = (price * 1) * (mount * 1);

                $(obj).parent().parent().find("#totalCostForProducts").val(total_cost);
            }


            return true;
        }

        function checkSalary(obj) {

            if (!validateData2("numeric", this.CLIEN_FORM.clientSalary)) {
                $("#salaryMsg").show();
                $("#salaryMsg").text("ارقام فقط");
            } else {
                $("#salaryMsg").hide();
                $("#salaryMsg").html("");
            }

        }
        function checkMail(obj) {

            if (!validateData2("email", this.CLIEN_FORM.email)) {
                $("#mailMsg").show();
                $("#mailMsg").html("بريد إلكترونى غير صحيح <br><font style='color:#005599;font-size:10px;'>For Example: youmail@yahoo.com</font>");
            } else {
                $("#mailMsg").hide();
                $("#mailMsg").html("");
            }

        }
        function  getDataInPopup(url) {
            var wind = window.open(url, "testname", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=450, height=300");
            wind.focus();
            $()
        }
        function addActivity(obj) {

            //            var code = $('#regionCode').val();
            var activityNameAr = $('#activityNameAr').val();
            //            var regionNameEn = $('#regionNameEn').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=saveNewActivity",
                data: {
                    //                    code: code,
                    activityNameAr: activityNameAr
                            //                    regionNameEn: regionNameEn
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.Status == 'Ok') {
                        $("#job").append("<option value='" + info.code + "'" + ">" + info.name + "</option>");
                        //                        $('#regionCode').val("");
                        $('#activityNameAr').val("");
                        //                        $('#regionNameEn').val("");
                        $(obj).parent().parent().parent().find('#msg').text("تم التسجيل بنجاح");

                    } else if (info.Status == 'No') {
                        $(obj).parent().parent().parent().find('#msg').text("لم يتم التسجيل");

                        //                        $('#regionCode').val("");
                        $('#activityNameAr').val("");
                        //  $('#regionNameEn').val("");
                    }
                }
            });
        }
        function popupSeason() {
            $('#seasonCode').val("");
            $('#seasonName').val("");
            $('#seasonForm').css("display", "block");
            $("#seasonMsg").text("");
            $('#seasonForm').bPopup({easing: 'easeOutBack',
                speed: 700,
                transition: 'slideDown', follow: [false, false]});
        }

        function showDialog(url) {  //load content and open dialog
            $("#divv").load(url);
            $("#divv").dialog({//create dialog, but keep it closed

                height: 300,
                width: 350,
                modal: true
            });
        }
        function openWindowTasks(url, dir, pro)
        {

            window.open(url, dir, pro);
        }
        function popup(obj) {
            $('#jobCode').val("");
            $('#jobNameAr').val("");
            $('#jobNameEn').val("");
            $('#jobForm').css("display", "block");
            $("#jobForm").find("#msg").text("");
            $('#jobForm').bPopup({easing: 'easeOutBack', //uses jQuery easing plugin
                speed: 700,
                transition: 'slideDown', follow: [false, false]});


        }

        function regionPopup(obj) {
            $("#regionForm").find("#msg").text("");
            $('#regionForm').css("display", "block");
            $('#regionForm').bPopup({easing: 'easeOutBack', //uses jQuery easing plugin
                speed: 700,
                transition: 'slideDown', follow: [false, false]});

        }

        function addJob(obj) {
            var jobNameAr = $('#jobNameAr').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=saveJob",
                data: {
                    jobNameAr: jobNameAr
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.Status == 'Ok') {
                        $("#jobTitle").append("<option value='" + info.code + "'" + ">" + info.name + "</option>");
                        $('#jobNameAr').val("");
                        $(obj).parent().parent().parent().find('#msg').text("تم التسجيل بنجاح");

                    } else if (info.Status == 'No') {
                        $(obj).parent().parent().parent().find('#msg').text("لم يتم التسجيل");
                        $('#jobNameAr').val("");
                    }
                }
            });
        }

        function addRegion(obj) {
            var regionNameAr = $('#regionNameAr').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=saveRegionN",
                data: {
                    regionNameAr: regionNameAr
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.Status == 'Ok') {
                        $("#region").append("<option value='" + info.code + "'" + ">" + info.name + "</option>");
                        $('#regionNameAr').val("");
                        $(obj).parent().parent().parent().find('#msg').text("تم التسجيل بنجاح");

                    } else if (info.Status == 'No') {
                        $(obj).parent().parent().parent().find('#msg').text("لم يتم التسجيل");
                        $('#regionNameAr').val("");
                    }
                }
            });
        }
        function campaign() {

            var url = "<%=context%>/SeasonServlet?op=showSeason";
            jQuery('#add_campaigns').load(url);
            $('#add_campaigns').bPopup();

        }
        function checkClientName(obj) {
            var clientName = $("#clientName").val();
            if (clientName.length > 0) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientName",
                    data: {
                        clientName: clientName
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'No') {
                            $("#nameMSG").css("color", "green");
                            $("#nameMSG").css(" text-align", "left");
                            $("#nameMSG").text(" متاح")
                            $("#nameMSG").removeClass("error");
                            $("#nameWarning").css("display", "none");
                            $("#nameOk").css("display", "inline")

                        } else if (info.status == 'Ok') {
                            $("#nameMSG").css("color", "red");
                            $("#nameMSG").css("font-size", "12px");
                            $("#nameMSG").text(" محجوز");
                            $("#nameMSG").addClass("error");
                            $("#nameWarning").css("display", "inline")
                            $("#nameOk").css("display", "none");

                        }
                    }
                });
            } else {
                $("#nameMSG").text("");
                $("#nameWarning").css("display", "none");
                $("#nameOk").css("display", "none");
            }

        }
        function recordCall2(obj) {
            var clientId = $("#clientId").val();
            var call_status = $(obj).parent().parent().parent().parent().find('#call_status:checked').val();
            var entryDate = $("#callerDiv").find('#appDate1').val();
            var note = $(obj).parent().parent().parent().parent().find('#note:checked').val();

            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=recordCall",
                data: {
                    clientId: clientId,
                    call_status: call_status,
                    entryDate: entryDate,
                    note: note
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);


                    if (info.result == 'success') {
                        $(obj).parent().parent().find("#callerNumber").css("display", "block");
                        $(obj).parent().parent().find("#callerNumber").html("رقم المتابعة : " + "<font style='color:#f9f9f9'>" + info.businessId + "</font>");
                        $(obj).css("display", "none");
                        $("#recordCall").css("display", "none");
                        $("#seasonBtn").css("display", "inline-block");
                        $("#productsBtn").css("display", "inline-block");
                        $("#compID").val(info.issueId);

                        $("#callNo").text(info.businessId);
                        var row = "<tr><td >رقم المتابعة</td><td style='text-align:right;font-size:14px;'>" + info.businessId + "<input type='hidden' id='businessId' value='" + info.businessId + "'</td></tr>";
                        $("#clientInf").append(row);
                        $(obj).parent().parent().parent().parent().parent().parent().parent().bPopup().close();//or you can use display none


                    }
                }
            });
        }
        function editClient() {
            $(".hide").css("display", "block");
            $(".show").css("display", "none");
        }
        function getTasks()
        {
            var dir = "_blank";
            var pro = "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=550,height=500";
            openWindowTasks('ProjectServlet?op=getProduct', dir, pro);
        }
        function getRecord()
        {
            $("#callerNumber").css("display", "none");
            $("#callerBtn").css("display", "block");
            $("#callerDiv").bPopup();
        }
        function closePopup(obj) {

            $(obj).parent().parent().bPopup().close();


        }
        function distribution(obj)
        {

            getDataInPopup('ComplaintEmployeeServlet?op=getEmpsByGroup&formName=CLIEN_FORM&selectionType=multi&complaintId=' + $("#compID").val());



        }
        function  getDataInPopup(url) {
            var wind = window.open(url, "testname", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=650, height=600");
            wind.focus();
        }
        function redirectCustomer()
        {
            openWindowTasks("UsersServlet?op=SalesManagerUsers");
        }
        function disableClientNO(checkBox) {
            if (!checkBox.checked) {
                document.getElementById("clientNO").disabled = false
            } else {
                document.getElementById("clientNO").value = ""
                document.getElementById("clientNO").disabled = true
                $("#msg").text("");
            }
        }



        function submitForm()
        {

            if ($("#numberRow").attr("class") == "numberRow") {
                var automatedClientNo = document.getElementById('automatedClientNo');
                if (!automatedClientNo.checked && !validateData2("req", this.CLIEN_FORM.clientNO) || !validateData2("numeric", this.CLIEN_FORM.clientNO)) {

                    this.CLIEN_FORM.clientNO.focus();
                    if (!validateData2("req", this.CLIEN_FORM.clientNO)) {
                        $("#numberMsg").show();
                        $("#numberMsg").text("كود الشركة مطلوب");

                        return false;
                    } else {
                        $("#numberMsg").hide();
                        $("#numberMsg").html("");
                    }
                    if (!validateData2("numeric", this.CLIEN_FORM.clientNO)) {
                        $("#numberMsg").show();
                        $("#numberMsg").text("أرقام فقط");

                        return false;
                    } else {
                        $("#numberMsg").hide();
                        $("#numberMsg").html("");
                    }
                    return false;
                }
                if ($("#MSG").attr("class") == "error") {
                    alert("هذا الشركة مسجل مسبقا")
                    return false;
                }


            } else {
                var automatedClientNo = document.getElementById('automatedClientNo');
                if (automatedClientNo.checked)
                {

                } else if (!validateData2("req", this.CLIEN_FORM.clientNO) || !validateData2("numeric", this.CLIEN_FORM.clientNO)) {

                    this.CLIEN_FORM.clientNO.focus();
                    if (!validateData2("req", this.CLIEN_FORM.clientNO)) {
                        $("#numberMsg").show();
                        $("#numberMsg").text("رقم الشركة مطلوب");

                        return false;
                    } else {
                        $("#numberMsg").hide();
                        $("#numberMsg").html("");
                    }
                    if (!validateData2("numeric", this.CLIEN_FORM.clientNO)) {
                        $("#numberMsg").show();
                        $("#numberMsg").text("أرقام فقط");

                        return false;
                    } else {
                        $("#numberMsg").hide();
                        $("#numberMsg").html("");
                    }
                    return false;
                }
                if ($("#MSG").attr("class") == "error") {
                    alert("هذا الشركة مسجل مسبقا")
                    return false;
                }

            }

            if (!validateData2("req", this.CLIEN_FORM.clientName) || !validateData2("minlength=3", this.CLIEN_FORM.clientName)) {
                this.CLIEN_FORM.clientName.focus();

                if ($("#clientName").val() == "") {
                    $("#naMsg").show();
                    $("#naMsg").text("إسم الشركة مطلوب");
                } else if (!validateData2("minlength=3", this.CLIEN_FORM.clientName)) {
                    $("#naMsg").show();
                    $("#naMsg").text("الإسم اقل من 3 حروف");
                } else {
                    $("#naMsg").hide();
                    $("#naMsg").html("");
                }
                return false;
            }
            if ($("#nameMSG").attr("class") == "error") {
                alert("هذا الشركة مسجل مسبقا")
                return false;
            }
            if (!validateData2("req", this.CLIEN_FORM.clientMobile)) {
                alert('من فضلك ادخل رقم الهاتف')
                return false;
            }

            if (!validateData2("req", this.CLIEN_FORM.email)) {
                alert('من فضلك ادخل البريد الإلكترونى')
                return false;
            }
            if (!validateData2("req", this.CLIEN_FORM.knowUsThrough)) {
                alert('من فضلك اختر طريقة التواصل')
                return false;
            }
            if (!validateData2("numeric", this.CLIEN_FORM.clientMobile)) {
                this.CLIEN_FORM.clientMobile.focus();
                if (!validateData2("numeric", this.CLIEN_FORM.clientMobile)) {
                    $("#moMsg").show();
                    $("#moMsg").text("ارقام فقط");

                } else {
                    $("#moMsg").hide();
                    $("#moMsg").html("");

                }
                return false;
            } else {
                document.CLIEN_FORM.action = "<%=context%>/ClientServlet?op=saveCompany";
                document.CLIEN_FORM.submit();

            }
        }

        function isNumber2(evt) {
            var iKeyCode = (evt.which) ? evt.which : evt.keyCode
            if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {

                $("#numberMsg").show();
                $("#numberMsg").text("أرقام فقط");
                return false;
            } else {
                $("#numberMsg").hide();
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
                    IsNumber = false;
                }
            }
            return IsNumber;

        }

        function checkEmail(email) {
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
                return (true)
            }
            return (false)
        }

        function clearValue(no) {
            document.getElementById('Quantity' + no).value = '0';
            total();
        }

        function cancelForm()
        {
            document.CLIEN_FORM.action = "main.jsp";
            document.CLIEN_FORM.submit();
        }
        function removeRow(obj) {

            $(obj).parent().parent().remove();
        }

        function saveProduct(obj) {

            var notes = $(obj).parent().parent().find('#notes').val();
            var budget = $(obj).parent().parent().find('#budget').val();
            var productName = $(obj).parent().parent().find('#productName').val();
            var productCategoryName = $(obj).parent().parent().find('#productCategoryName').val();
            var productId = $(obj).parent().parent().find('#productId').val();
            var product_category_id = $(obj).parent().parent().find('#parentProductId').val();
            var period = $(obj).parent().parent().find('#period').val();
            var paymentSystem = $(obj).parent().parent().find('#paymentSystem').val();
            var empId = $(obj).parent().parent().find('#employeeId').val();

            var departmentMgrId = $(obj).parent().parent().find('#departmentMgrId').val();
            //            alert(departmentMgrId);
            var clientId = $("#clientId").val();
            var businessId = $("#businessId").val();
            var issueId = $("#compID").val();

            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=saveClientProduct",
                data: {
                    clientId: clientId,
                    productId: productId,
                    productCategoryId: product_category_id,
                    productName: productName,
                    productCategoryName: productCategoryName,
                    paymentSystem: paymentSystem,
                    period: period,
                    budget: budget,
                    notes: notes,
                    businessId: businessId,
                    empId: empId,
                    issueId: issueId,
                    mgrId: departmentMgrId


                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.distributionStatus == 'Ok') {
                        $(obj).html("");
                        $(obj).css("background-position", "top");


                    }
                }
            });
        }

        function saveSeason(obj) {

            var seasonNotes = $(obj).parent().parent().find('#seasonNotes').val();
            var seasonId = $(obj).parent().parent().find('#seasonId').val();
            var seasonName = $(obj).parent().parent().find('#seasonName').val();
            var clientId = $("#clientId").val();

            $.ajax({
                type: "post",
                url: "<%=context%>/SeasonServlet?op=saveClientSeason",
                data: {
                    clientId: clientId,
                    seasonId: seasonId,
                    seasonName: seasonName,
                    seasonNotes: seasonNotes

                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);


                    if (info.status == 'Ok') {

                        // change update icon state
                        $(obj).html("");
                        $(obj).css("background-position", "top");

                    }
                }
            });
        }

        function addSeason() {
            var code = $('#seasonCode').val();
            var name = $('#seasonName').val();
            if (code === null || code === '') {
                alert("Insert Code");
                $('#seasonCode').focus();
            } else if (name === null || name === '') {
                alert("Insert Name");
                $('#seasonName').focus();
            } else {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveSeason",
                    data: {
                        code: code,
                        arabic_name: name,
                        english_name: name,
                        display: '1'
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            $("#knowUsThrough").append("<option value='" + info.id + "'" + ">" + info.name + "</option>");
                            $('#seasonCode').val("");
                            $('#seasonName').val("");
                            alert("تم التسجيل بنجاح");
                        } else if (info.status === 'fail') {
                            alert("لم يتم التسجيل");
                        }
                    }
                });
            }
        }
        function attachDegree() {
            var clientId = document.getElementById("clientId").value;
            document.CLIEN_FORM.action = "<%=context%>/ClientServlet?op=attachGradesToCustomer&clientId=" + clientId;
            document.CLIEN_FORM.submit();
        }
    </SCRIPT>

    <STYLE>
        #products_table{
            width: 100%;
            margin-top: 20px;
        }
        #products_table th{
            padding: 5px;
            font-size: 16px;
            background:#f1f1f1;
            font-family: arial;


        }
        #projectsTbl{
            width: 100%;
            margin-top: 20px;
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
        .login {
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
        #products_table td{
            font-size: 12px;
            border: none;
        }
        #season_table{
            width: 100%;
            margin-top: 20px;
        }
        #season_table th{
            padding: 5px;
            font-size: 16px;
            background:#f1f1f1;
            font-family: arial;
        }
        #season_table td{
            font-size: 12px;
            border: none;
        }
        /*        .closex {
                    float: right;
                    clear: both;
                    width:24px;
                    height:24px;
                    margin: 4px;
                    background: transparent;
                    background-repeat: no-repeat;
                    cursor: pointer;
                    background-image:url(images/icons/Close.png);
        
                }*/
        label{
            font-size: 14px;
            font-family: arial;
        }

        .popup_content{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: white;
            margin-bottom: 5px;
            width: 300px;
            height: 300px;


            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;}
        .save {
            width:40px;
            height:32px;
            background-image:url(images/icons/check.png);
            background-position: bottom;
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .save__ {
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            background-position: bottom;
            margin-right: auto;
            margin-left: auto;
            cursor: pointer;
        }
        .distribution{

            width:32px;
            height:32px;
            background-image:url(images/icons/status.png);
            background-position: bottom;
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .remove {
            width:40px;
            height:32px;
            background-image:url(images/icons/remove.png);
            background-position: bottom;
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .hide{display: none;text-align: right;}
        .show{display: block;}
        .businessNumTitle{
            background-color: #0088cc;
            color:white;

            font-size: 16px;
        }
        .businessNum{

            color: green;
            font-size: 16px;
        }
        .button_record{
            width:145px;
            height:31px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
        .button_products{
            width:145px;
            height:31px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/products.png);
        }

        .seasonsBtn{
            width:145px;
            height:31px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/vote.png);
        }

        .degreeBtn{
            width:145px;
            height:31px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/grade.png);
        }
        .closeBtn{
            width:145px;
            height:31px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/close2.png);
        }
        .submitBtn{
            width:145px;
            height:31px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/submit.png);
        }
        #moMsg,#telMsg,#naMsg,#salaryMsg,#mailMsg,#ssnMsg,#numberMsg{
            font-size: 14px;
            display: none;
            color: red;
            margin: 0px;
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
        .remove__{
            width:20px;
            height:20px;
            background-image:url(images/icons/remove1.png);
            background-position: bottom;
            background-repeat: no-repeat;
            cursor: pointer;
            margin-right: auto;
            margin-left: auto;
        }
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY >
        <div id="add_campaigns" style="width: 40% !important;display: none;"></div>
        <input id="compID" type="hidden" />
        <input id="issueID" type="hidden" />
        <FORM NAME="CLIEN_FORM" METHOD="POST">


            <!-- take call number -->

            <div id="callerDiv" style="width: 35%;display: none;position: absolute;">
                <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -100;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
                </div>

                <!--<h1>رسالة قصيرة</h1>-->
                <div class="login" style="width: 90%;float: left; direction: <fmt:message key="direction"/>">

                    <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;" >


                        <tr>
                            <td width="30%"  style="color: #27272A;">نوع الإتصال </td>
                            <td style="text-align:right;">
                                <input name="note" type="radio" value="مكالمة" checked="" id="note">
                                <label><img src="images/dialogs/phone.png" alt="phone" width="24px">مكالمة </label>
                                <input name="note" type="radio" value="مقابلة" id="note" style="margin-right: 10px;">
                                <label><img src="images/dialogs/handshake.png" alt="meeting" width="24px"> مقابلة</label>
                            </td>

                        </tr>

                        <tr>
                            <td width="30%"  style="color: #27272A;">إتجاة المكالمة/المقابة</td>
                            <td style="text-align:right;">
                                <input  name="call_status" type="radio" value="incoming" checked id="call_status" />
                                <label>واردة</label>
                                <input name="call_status" type="radio" value="out_call" id="call_status" style="margin-right: 10px;"/>
                                <label>صادرة</label>
                            </td>

                        </tr>
                        <tr>
                            <td  style="color: #27272A;">التاريخ</td>
                            <td dir=<fmt:message key="direction"/> style="text-align:<fmt:message key="align"/>"> 
                                <input name="entryDate" id="appDate1" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">

                                <div id="callerNumber" style="color: #27272A;width: 50%;margin-left: auto;margin-right: auto;text-align: center;display: none;clear: both;">

                                </div>
                                <div id="callerBtn" style="margin-left: auto;margin-right: auto;text-align:center;">  
                                    <!--<input name="save_info" type="button" onclick="JavaScript:  submitForm();" id ="save_info" value="تسجيل المكالمة" class="btn btn-large btn-success" />-->
                                    <input  name="save_info" type="button" onclick="recordCall2(this);" id ="save_info"class="button_record"/>
                                </div>



                            </td>

                        </tr>
                        <tr>
                            <td colspan="2"></td>
                        </tr>

                    </table>
                </div>
            </div>            
            <!--end call number--> 






            <DIV style="color:blue;margin-bottom: 30px;width: 100%;">
                <!--<input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">-->
                <div style="margin-left: auto;margin-right: auto;">
                   <!-- <img src="images/active_campaign.jpg" height="31px;" width="200px;" id="defaultCampaign" style="display: <%=!defaultCampaign.isEmpty() ? "" : "none"%>" title="Campaign Name: <%=defaultCampaign%>"/>-->
                    <button  onclick="JavaScript:cancelForm();" class="closeBtn" style="margin-right: 2px;"></button>
                    <input  type="button" onclick="submitForm()" id='submitBtn' class="submitBtn" value="" style="display: inline-block;"/>
                    <input  type="button" onclick="getTasks()" id="productsBtn"  style="display: none;margin-right: 5px;" class="button_products"/>
                    <input  id="recordCall" type="button" onclick="getRecord();" class="button_record" style="display: none;margin-right: 5px;" value=""/>
                    <input  type="button" onclick="campaign()"  id="seasonBtn" class="seasonsBtn" style="display: none;margin-right: 5px;" value=""/>
                </div>
            </DIV> 
            <div id="divv">

            </div>
            <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 20px;border-radius: 5px;">

                <table dir=<fmt:message key="direction"/> align="<%=align%>" class="blueBorder" width="100%">
                    <tr>

                        <td style="text-align:center;border-color: #006699; width:100%;" class="blueBorder blueHeaderTD">
                            <FONT color='white' SIZE="+1"><%=title_1%>                
                            </font>

                        </td>
                    </tr>
                </table>
                <br/>
                <% if (autoPilotMessage != null && autoPilotMessage.equalsIgnoreCase("ok")) {%>
                <br>
                <table align="<%=align%>" dir=<fmt:message key="direction"/> WIDTH="70%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="blue">Save Company Complete</font>
                        </td>
                    </tr>
                </table>
                <% } %>

                <% if (errorExtConn != null && !errorExtConn.equals("") && errorExtConn.equals("1")) {%>
                <table  dir=<fmt:message key="direction"/> align="<%=align%>">
                    <tr><td class="td">
                            <font size="4" color="red"> <%=msgErrorExtConn%> </font>
                        </td></tr> 
                </table>
                <% }%> 
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                            if (clientWbo != null) {
                %>  
                <STYLE>
                    .productsBtn{
                        display: block;
                    }
                </style>
                <script type="text/javascript">
                    $(function () {
                        //            $("#productsBtn").css("display", "inline-block");
                        $("#saveClient").css("display", "block");
                        $("#clientInfo").css("display", "block");
                        $("#submitBtn").css("display", "none");
                        $("#degreeBtn").css("display", "none");
                        //            $("#redirectCust").css("display", "inline-block");
                    });

                </script>
                <div id="caller_number" style="width: 50%;margin-left: auto;margin-right: auto;text-align: center;display: none;"></div>

                <%}
                } else if (status.equalsIgnoreCase("error")) {%>

                <table align="<%=align%>"  dir=<fmt:message key="direction"/>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" >كود الشركة مسجل مسبقا</font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%
                } else {%>

                <table align="<%=align%>"  dir=<fmt:message key="direction"/>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>

                <%}
                    }
                %>

                <TABLE id="products_table" style="display: none;direction: <fmt:message key="direction"/>;">
                    <THEAD>
                        <tr>
                            <th>مسئولى المبيعات</th>
                            <th >التصنيف</th>
                            <th >المنتج </th> 

                            <th>فى خلال</th>
                            <th>نظام الدفع</th>
                            <!--                            <th>الكمية</th>-->
                            <th>الميزانية</th>
                            <!--                            <th>الإجمالى</th>-->
                            <th></th>
                            <th></th>
                        </tr>
                    </THEAD>

                </TABLE>



                <table style="margin-bottom: 20px;margin-left: -200px; border-color: #006699;display: block;"  ALIGN="center"   dir="<%=dir%>" border="0" width="100%" id="saveClient">




                    <tr>
                        <td style="width: 50%;border: 0px;margin-top: 0px;padding: 0px;">


                            <table cellpadding="5px" cellspacing="5px" style=" margin: 0px;">
                                <%
                                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                                            && connectByRealEstate.equals("0")) {
                                %>
                                <tr id="numberRow" class="numberRow">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">

                                        <LABEL FOR="supplierNO2">
                                            <p><b style="color: white;"><%=client_number%><font color="white">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>"  class='TD' >
                                        <!--onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''"-->
                                        <input  type="TEXT" style="width:40%;" name="clientNO" ID="clientNO" size="33"  maxlength="10" class="clientNumber" onkeyup="checkNumber(this)"autocomplete="off"  onkeypress="javascript:return isNumber(event)" disabled="true"> 
                                        <input  type="checkbox" name="automatedClientNo" id="automatedClientNo" onclick="javascript: disableClientNO(this);" checked="true">
                                        <input type="hidden" name="saveInRealState" id="saveInRealState" value="false" />
                                        <INPUT TYPE="hidden" name="isSup" ID="isSup" value="100">
                                        <INPUT TYPE="hidden" name="nationality" ID="nationality" value="UL">  
                                        <INPUT TYPE="hidden" name="matiralStatus" ID="matiralStatus" value="UL">
                                        <INPUT TYPE="hidden" name="clientBranch" ID="clientBranch" value="UL">

                                        <font size="3" color="#005599"><b><%=automated%></b></font>
                                        <div id="warning"style="margin-right: 25px;display: none;width: 16px;height: 16px; background-image: url(images/warning.png);background-repeat: no-repeat;"></DIV>
                                        <div id="ok"style="margin-right: 25px;display: none;width: 16px;height: 16px; background-image: url(images/ok2.png);background-repeat: no-repeat;"></DIV>
                                        <LABEL id="MSG" ></LABEL>
                                        <p id="numberMsg"></p>
                                    </td>
                                </tr>
                                <%} else {%>
                                <tr id="numberRow" class="">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">

                                        <LABEL FOR="supplierNO2">
                                            <p><b style="color: #0000FF;"><%=client_number%><font color="white">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>"  class='TD' >
                                        <!--onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''"-->
                                        <%if (clientWbo != null) {

                                        %>
                                        <input  type="TEXT" style="border: 1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px" name="clientNO" value="<%=clientWbo.getAttribute("clientNO")%>" ID="clientNO" size="33"  maxlength="10" class="clientNumber" autocomplete="off"  onkeypress="javascript: checkClientNo(this);" > 
                                        <input  type="checkbox" name="automatedClientNo" id="automatedClientNo" onclick="javascript: disableClientNO(this);" onkeyup="checkClientNo(this)" onmousedown="checkClientNo(this)" >
                                        <%} else {%>
                                        <input  type="TEXT" style="width:40%;" name="clientNO" ID="clientNO" size="33"  maxlength="10" class="clientNumber" autocomplete="off"  onkeypress="javascript: checkClientNo(this)" disabled="true"> 
                                        <input  type="checkbox" name="automatedClientNo" id="automatedClientNo" onclick="javascript: disableClientNO(this);" onkeyup="checkClientNo(this)" onmousedown="checkClientNo(this)" checked="true">
                                        <%}%>
                                        <input type="hidden" name="saveInRealState" id="saveInRealState" value="true" />
                                        <font size="3" color="#005599"><b><%=automated%></b></font>

                                        <LABEL id="MSG" ></LABEL>
                                        <p id="numberMsg"></p>
                                    </td>
                                </tr>

                                <%
                                    }%>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                        <LABEL FOR="clientName" >
                                            <p><b style=""><%=client_name%><font color="white">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <input type="TEXT" style="border: 1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px" name="clientName" ID="clientName" size="33" onmouseout="checkClientName(this)" onblur="checkClientName(this)" value="" maxlength="255" onkeyup="checkName(this)" onmousedown="checkName(this)">
                                        <p id="naMsg"></P>
                                        <div id="nameWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                            <IMG src="url(images/warning.png)" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                                        </DIV>
                                        <div id="nameOk"style="display: none;width: 20px;height: 20px;border: none;">
                                            <IMG src="url(images/warning.png)" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                                        </DIV>
                                        <LABEL id="nameMSG" ></LABEL>

                                    </td>
                                </tr>


                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                        <!--    client mobile number Instead of fax -->
                                        <LABEL FOR="clientMobile">
                                            <p><b style=""><%=client_mobile%></b><font color="white">*</font>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:240px;direction:rtl" name="clientMobile" ID="clientMobile" size="11"  onkeyup="checkMobile(this)" onmouseout="javascript:return checkClientMobile(this)" onkeypress="JavaScript: return isNumber(event, this)" value=""  maxlength="11" >
                                        <p id="moMsg"></p>
                                        <div id="mobWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                            <IMG src="" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                                        </DIV>
                                        <div id="mobOk"style="display: none;width: 20px;height: 20px;border: none;">
                                            <IMG src="" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                                        </DIV>
                                        <LABEL id="mobMSG" ></LABEL>
                                        <a id="existmobClient" class="linkbtn" style="display: none" href="#">exist</a>
                                        <input type="hidden" maxlength="3" style="width:50px; background-color: #FFFF66;" name="internationalM" ID="internationalM" size="5" onkeypress="JavaScript: return isNumber(event, this)" onkeyup="checkClientMobile(this)">
                                    </td>
                                </tr>

                                <table style="margin-top: 0px;" cellpadding="5px" cellspacing="5px" >
                                    <tr>
                                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                            <LABEL FOR="region">
                                                <p><b><%=regionName%><font color="white"></font></b>&nbsp;
                                            </LABEL>
                                        </td>
                                        <td style="<%=style%>"class='td'>
                                            <SELECT name="region" id="region" style="width: 60%; font-weight: bold; font-size: 15px; padding: 2px 2px 2px 2px; background-color: white; ">
                                                <OPTION value="000"> <%=choose%></OPTION>
                                                    <sw:WBOOptionList wboList="<%=regionsList%>" displayAttribute="name" valueAttribute="code"  />
                                            </SELECT>
                                            <input type="button" value="<%=regionTitle%>" id="insertRegion" onclick="regionPopup(this)"/>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                            <!--    client mobile number Instead of fax -->
                                            <LABEL FOR="clientMobile">
                                                <p><b style=""><%=taxNo%></b>&nbsp;
                                            </LABEL>
                                        </td>
                                        <td style="<%=style%>" class='td'>
                                            <input type="TEXT" style="width:240px;direction:rtl" name="interNum" maxlength="15" ID="interNum" size="15" onkeyup="javascript:return checkClientInterPhone(this)" onmouseout="checkClientInterPhone(this)" onkeypress="JavaScript: return isNumber(event, this)" 

                                                   value=""

                                                   >
                                            <div id="interWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                                <IMG src="" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                                            </DIV>
                                            <div id="interOk"style="display: none;width: 20px;height: 20px;border: none;">
                                                <IMG src="" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                                            </DIV>
                                            <LABEL id="interMSG" style="display :inline" ></LABEL>
                                            <a id="existinterClient" class="linkbtn" style="display: none" href="#">exist</a>
                                        </td>
                                    </tr>  

                                    <tr>
                                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                            <!--    client mobile number Instead of fax -->
                                            <LABEL FOR="clientMobile">
                                                <p><b style=""><%=land_phone%></b>&nbsp;
                                            </LABEL>
                                        </td>
                                        <td style="<%=style%>" class='td'>
                                            <input type="TEXT" style="width:240px;direction:rtl" name="phone" ID="phone" size="11" onkeyup="javascript:return checkTel(this, event)" onmouseout="javascript:return checkTel(this, event)" value="" maxlength="11" >
                                            <p id="telMsg"></p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                            <!--    client mobile number Instead of fax -->
                                            <LABEL FOR="clientMobile">
                                                <p><b style=""><%=contact_person%></b>&nbsp;
                                            </LABEL>
                                        </td>
                                        <td style="<%=style%>" class='td'>
                                            <input type="TEXT" style="width:240px;direction:rtl" name="kindred" ID="kindred" value="">

                                        </td>
                                    </tr>





                                </table>
                        </td>
                        <td style="border: 0px;">
                            <table  style="margin-top: 0px;" cellpadding="5px" cellspacing="5px">
                                <script>

                                </script>



                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                        <LABEL FOR="email">
                                            <p><b><%=client_mail%>*</b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" style="border: 1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px;width:240px;" name="email" ID="email" value="" maxlength="255" onkeyup="checkMail(this.value)">
                                        <p id="mailMsg" ></p>
                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                        <LABEL>
                                            <p><b style=""><%=knowUs%> <font style="color: white;">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>;" class='td'>
                                        <select name="knowUsThrough" id="knowUsThrough" style="font-weight: bold; font-size: 16px; width: 240px; direction: rtl;">
                                            <option value=""> </option>
                                            <%
                                                for (WebBusinessObject seasonWbo : seasonsList) {
                                            %>
                                            <option value="<%=seasonWbo.getAttribute("id")%>"><%=seasonWbo.getAttribute("arabicName")%></option>
                                            <%
                                                }
                                            %>

                                        </select>
                                        <input type="button" class="btn-gemy" style="display: <%=userPrevList.contains("ADD_METHOD") ? "" : "none"%>;" onclick="JavaScript: popupSeason();" value="<%=add%>">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD" width="35%">
                                        <LABEL FOR="nationality">
                                            <p><b><%=activityType%><font color="white"></font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <SELECT name="jobTitle" id="jobTitle" style="width: 60%; font-weight: bold; font-size: 15px; padding: 2px 2px 2px 2px; background-color: white; ">
                                            <!--<SELECT name="nationality" id="nationality" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">-->

                                            <OPTION value="000"> ---إختر---</OPTION>
                                                <sw:WBOOptionList wboList="<%=tradeList%>" displayAttribute="tradeName" valueAttribute="tradeId"  />
                                        </SELECT>
                                        <input type="button" value="<%=ActivityTitle%>" id="insertActivity" onclick="activityPopup(this)"/>

                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                        <!--    client mobile number Instead of fax -->
                                        <LABEL FOR="clientMobile">
                                            <p><b style=""><%=business_size%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="radio" name="gender" value="small" >&nbsp; <b style="font-size:16px;"><%=small%></b> 
                                        <input type="radio" name="gender" value="medium" checked="true">&nbsp; <b style="font-size:16px;"><%=medium%></b> 
                                        <input type="radio" name="gender" value="large" >&nbsp; <b style="font-size:16px;"><%=big%></b> 
                                    </td>
                                </tr>  
                                <tr  >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"   width="35%">
                                        <LABEL FOR="phone">
                                            <p><b><%=recordNo%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>" class='td'>
                                        <input type="TEXT" style="border: 1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px;width:240px;" name="workOut" ID="workOut" value="">

                                        <p id="mailMsg1" ></p>

                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: white;" class="blueHeaderTD"  width="35%">
                                        <LABEL FOR="address">
                                            <p><b><%=client_address%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="hidden" style="width:230px" name="address" ID="address" size="33" value="UL" maxlength="255">
                                        <textarea style="border: 1px solid silver;border-radius: 5px;width:240px; padding-left: 10px"   rows="3" ID="description" name="description"></TEXTAREA>

                                      
                                                
                                    </td>
                                </tr>



                                </table>

                            </td>
                        </tr>

                    </table>
                       <TABLE style="width: 100%">
                         <tr>
                            <td   style="width: 20%; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                            <LABEL FOR="matiralStatus" >
                                <p><b><fmt:message key="campgin"/></b>&nbsp;
                            </LABEL>
                            <br/>
                        </td>     
                        <td  style="width: 70%; padding: 5px" >
                            <select name="campaigns" id="campaigns" style="width: 100%;" multiple="multiple" class="chosen-select-campaign"  data-rel="chosen">
                                <%
                                    for (WebBusinessObject campaignWbo : campaigns) {
                                %>
                                <option value="<%=campaignWbo.getAttribute("id")%>" <%=defaultCampaign.equals(campaignWbo.getAttribute("campaignTitle")) ? "selected" : ""%>><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                <%
                                    }
                                %>
                            </select>
                             </Td>
                          </tr>
                    
                </table>
                              

 <div id="jobForm"  style="width: 30%;height: 200px;display: none;position: fixed;">

            
          
            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 86%;margin-bottom: 10px;margin-left: auto;margin-right: auto">
                <table class="" style="width:100%;text-align: right;border: none;" class="table" >

                <tr align="center" align="center">
                    <td colspan="2" style="font-size:14px;border: none;"><b style="color: #f9f9f9;font-size: 14px;"id="msg"></b></td>
                </tr>
                <tr >
                    <td  ALIGN="<%=align%>" style="border: none;">
                                    <%=arName%>
                    </td>
                    <td width="200" style="border:0px;text-align: right;">
                        <input type="TEXT" style="width:150px;float: right;" name="jobNameAr" ID="jobNameAr" size="50" value="" maxlength="50">
                    </td>
                </tr>
                <tr >

                    <td colspan="2" style="text-align:center;border: none;">
                        <input style="margin-top: 5px;"type="button"  value="إضافة" onclick="addJob(this)">
                    </td>
                </tr>
            </table>
            </div>
        </div>
                    
<div id="regionForm"  style="width: 30%;height: 200px;display: none;position:fixed;">

          
            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
    
            <div class="login" style="width: 86%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table class="table" style="width:100%;text-align: right;border: none;" >
            
                <tr align="center" align="center">
                    <td colspan="2"  style="font-size:14px;border: none"><b style="color: #f9f9f9;font-size: 14px;"id="msg"></b></td>
                </tr>
                <tr >
                    <td ALIGN="<%=align%>" style="border: none">
                                    <fmt:message key="region"/>
                    </td>
                    <td width="200" style="border:0px;text-align: right;">
                        <input type="TEXT" style="width:150px;" name="regionNameAr" ID="regionNameAr" size="50" value="" maxlength="50">
                    </td>
                </tr>
                <tr>

                    <td colspan="2" style="text-align:center;border: none">
                        <input type="button"  value="إضافة" onclick="addRegion(this)" style="margin-top: 5px;">
                    </td>
                </tr>
            </table>
            </div>
        </div>
                      <div id="seasonForm"  style="width: 30%;height: 200px;display: block;position: fixed;">
                    <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
                        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
                    </div>
                    <div class="login" style="width: 86%;margin-bottom: 10px;margin-left: auto;margin-right: auto">
                        <table class="" style="width:100%;text-align: right;border: none;" class="table" >
                            <tr align="center" align="center">
                                <td colspan="2" style="font-size:14px; border: none;">
                                    <b style="color: #f9f9f9;font-size: 14px;" id="seasonMsg"></b></td>
                            </tr>
                            <tr>
                                <td  ALIGN="<%=align%>" style="border: none;"><fmt:message key="seasonCode" /></td>
                                <td width="200" style="border:0px;text-align: right;">
                                    <input type="text" style="width: 80px; float: right;" name="seasonCode" ID="seasonCode" size="50" value="" maxlength="50" />
                                </td>
                            </tr>
                            <tr>
                                <td  ALIGN="<%=align%>" style="border: none;"><fmt:message key="seasonName" /></td>
                                <td width="200" style="border:0px;text-align: right;">
                                    <input type="text" style="width:150px;float: right;" name="seasonName" ID="seasonName" size="50" value="" maxlength="50" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align:center;border: none;">
                                    <input style="margin-top: 5px;"type="button" value="<%=add%>" onclick="addSeason()" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                                <div id="activityForm"  style="width: 30%;height: 200px;display: none;position:fixed;">

          
            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
    
            <div class="login" style="width: 86%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table class="table" style="width:100%;text-align: right;border: none;" >
            
                <tr align="center" align="center">
                    <td colspan="2"  style="font-size:14px;border: none"><b style="color: #f9f9f9;font-size: 14px;"id="msg"></b></td>
                </tr>
                <tr >
                    <td ALIGN="<%=align%>" style="border: none">
                                    <%=activityName%>
                    </td>
                    <td width="200" style="border:0px;text-align: right;">
                        <input type="TEXT" style="width:150px;" name="activityNameAr" ID="activityNameAr" size="50" value="" maxlength="50">
                    </td>
                </tr>
                <tr>

                    <td colspan="2" style="text-align:center;border: none">
                        <input type="button"  value="إضافة" onclick="addActivity(this)" style="margin-top: 5px;">
                    </td>
                </tr>
            </table>
            </div>
        </div>
 </fieldset>
                        
        </FORM>
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </BODY>
</HTML>     
