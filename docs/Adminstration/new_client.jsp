
<%@page import="com.crm.db_access.EmployeesLoadsMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
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

        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd hh:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        String errorExtConn = (String) request.getAttribute("errorExtConn");

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();

        CampaignMgr campaignMgr = CampaignMgr.getInstance();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        List<WebBusinessObject> userProjects = null;
        String defaultCampaign = "";
        String campaignDirection = "";
        String callCenterMode = "";
        if (securityUser != null && securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()
                && !"-1".equals(securityUser.getDefaultCampaign())) {
            defaultCampaign = securityUser.getDefaultCampaign();

            WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(defaultCampaign);
            if (campaignWbo != null) {
                defaultCampaign = (String) campaignWbo.getAttribute("campaignTitle");
                campaignDirection = (String) campaignWbo.getAttribute("direction");
            }
        }
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        userProjects = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));
        callCenterMode = securityUser.getCallcenterMode();
        String autoPilotModeValue = autoPilotModeValue = securityUser.getDefaultNewClientDistribution();

//        List<WebBusinessObject> campaigns = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle("16", "key4"));
//        campaigns.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));
        
        ArrayList<WebBusinessObject> seasonsList = (ArrayList<WebBusinessObject>) request.getAttribute("seasonsList");

        String clientId = "";
        if (clientWbo != null) {
            clientId = (String) clientWbo.getAttribute("id");
        }
        String issueId = (String) request.getAttribute("issueId");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Vector<WebBusinessObject> jobs = new Vector();
        jobs = (Vector) request.getAttribute("jobs");
        Vector<WebBusinessObject> regions = new Vector();
        regions = (Vector) request.getAttribute("regions");
        //Privileges
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<>();
        /*for (WebBusinessObject wboTemp : prvType) {
         if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
         privilegesList.add((String) wboTemp.getAttribute("prevCode"));
         }
         }*/

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = "center";

        String style = null;
        String arName, regionName;
        String call_number, client_ssn, client_total_salary, regist;
        String interPhone;

        String automated;
        String fStatus;
        String sStatus, msgErrorExtConn, birthDate, search, add, back, area;
        if (stat.equals("En")) {

            call_number = "call number";
            style = "text-align:left";
            arName = "arabic title";
            client_ssn = "Social Security Number";
            client_total_salary = "Client Total Salary";
            sStatus = "Client Saved Successfully";
            fStatus = "Fail To Save This Client";
            automated = "Automated";
            regionName = "Region Arabic Name";
            msgErrorExtConn = "Connection fail by Realstate";
            birthDate = "Birth date";
            search = "Search";
            regist = "Registration";
            interPhone = "International Number";

            add = " Add Area ";
            back = "Cancel";
            area = "Area";
        } else {

            style = "text-align:Right";
            arName = "المهنة";
            client_ssn = "&#1575;&#1604;&#1585;&#1602;&#1605; &#1575;&#1604;&#1602;&#1608;&#1605;&#1609;";
            client_total_salary = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1609; &#1575;&#1604;&#1583;&#1582;&#1604;";
            call_number = "رقم المتابعة";
            fStatus = " لم يتم تسجيل هذا العميل , ربما يكون مسجل من قبل أو اتصل بإدارة الموقع";
            sStatus = "تم تسجيل العميل بنجاح";
            automated = "&#1578;&#1604;&#1602;&#1575;&#1574;&#1609;";
            regionName = "المنطقة";
            msgErrorExtConn = "فشل الاتصال بقاعدة بيانات العقارت";
            birthDate = "تاريخ الميلاد";
            search = "بحث";
            regist = "التسجيل";
            interPhone = "الرقم الدولي";
            add = " إضافة مناطق ";
            back = "عودة";
            area = "المناطق";
        }
        SimpleDateFormat dFormat = new SimpleDateFormat("yyyy/MM/dd");
        cal.add(Calendar.YEAR, -40);
        String nowDate = dFormat.format(cal.getTime());

        EmployeesLoadsMgr loadsMgr = EmployeesLoadsMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();
        List<WebBusinessObject> loads = new ArrayList<WebBusinessObject>();
        try {
            securityUser = (SecurityUser) session.getAttribute("securityUser");
            List<WebBusinessObject> employees;
            if (securityUser.isCanRunCampaignMode()) {
                employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
            } else {
                employees = userMgr.getUsersByProjectAndGroup(securityUser.getSiteId(), CRMConstants.SALES_MARKTING_GROUP_ID);
            }
            WebBusinessObject employee;
            String[] employeeIds = new String[employees.size() + 1];
            for (int i = 0; i < employees.size(); i++) {
                employee = employees.get(i);
                employeeIds[i] = (String) employee.getAttribute("userId");
            }
            employeeIds[employees.size()] = securityUser.getUserId();
            //loads = loadsMgr.employeesLoads(employeeIds);
        } catch (Exception ex) {
            System.out.println("loadsMgr Manager");
        }
        request.setAttribute("loads", loads);
        loads = (List<WebBusinessObject>) request.getAttribute("loads");
        ArrayList<WebBusinessObject> campaignsList = request.getAttribute("campaignsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList") : new ArrayList<WebBusinessObject>();
        ArrayList<WebBusinessObject> brokerList = request.getAttribute("brokerList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("brokerList") : new ArrayList<WebBusinessObject>();
        ArrayList<WebBusinessObject> sourceList = request.getAttribute("sourceList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("sourceList") : new ArrayList<WebBusinessObject>();
        WebBusinessObject mainProjectWbo;
        String mainProductId = null;
        String mainProductName = null;

        CampaignMgr campMgr = CampaignMgr.getInstance();
        ArrayList<WebBusinessObject> campaignsListSocial = new ArrayList<>(campMgr.getOnArbitraryDoubleKeyOracle("16", "key4","1", "key7"));

        String departmentMgrId = (String) request.getAttribute("departmentMgrId");
        String departmentMgrName = (String) request.getAttribute("departmentMgrName");
        List<WebBusinessObject> employees = (List<WebBusinessObject>) request.getAttribute("employees");

        Vector<WebBusinessObject> mainRegion = (Vector<WebBusinessObject>) request.getAttribute("mainRegion");
        WebBusinessObject rgnWbo = request.getAttribute("rgnWbo") != null ? (WebBusinessObject) request.getAttribute("rgnWbo") : null;

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        /*for (int i = 0; i < groupPrev.size(); i++) {
         wbo = (WebBusinessObject) groupPrev.get(i);
         userPrevList.add((String) wbo.getAttribute("prevCode"));
         }*/

        Vector mainProducts = new Vector();
        if (privilegesList.contains("CLIENT_PROJ_TBLE")) {
            mainProducts = (Vector) request.getAttribute("mainProducts");
        }

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

        <script type="text/javascript">

//            /* preparing bar chart */
//            var chart;
//            $(document).ready(function() {
//                
//            $("#campaignsselect").select2();
//                chart = new Highcharts.Chart({
//                    chart: {
//                        renderTo: 'container',
//                        defaultSeriesType: 'bar'
//                    },
//                    title: {
//                        text: 'أحمال الموظفين',
//                        style: {
//                            fontWeight: 'bolder'
//                        }
//                    },
//                    subtitle: {
//                        text: ''
//                    },
//                    xAxis: {
//                        labels: {
//                            style: {
//                                color: '#6D869F',
//                                fontWeight: 'bold'
//                            }
//                        },
//                        categories: [<!% if (loads != null) {
//                                for (int i = 0; i < loads.size(); i++) {
//                                    WebBusinessObject wbo_ = loads.get(i);
//                                    if (i > 0) {
//                                        out.write(",");
//                                    }
//                                    out.write("'" + (String) wbo_.getAttribute("currentOwnerFullName") + "'");
//                                }
//                            }%>//],
//                        title: {
//                            text: null
//                        }
//                    },
//                    yAxis: {
//                        allowDecimals: false,
//                        min: 0,
//                        labels: {
//                            style: {
//                                fontWeight: 'bold'
//                            }
//                        },
//                        title: {
//                            text: 'عدد الطلبات',
//                            align: 'high'
//                        }
//                    },
//                    tooltip: {
//                        formatter: function() {
//                            return ' ' + 'طلبات' + ' ' + this.y + ' ';
//                        }
//                    },
//                    plotOptions: {
//                        bar: {
//                            dataLabels: {
//                                enabled: true
//                            }
//                        }
//                    },
//                    legend: {
//                        layout: 'vertical',
//                        align: 'right',
//                        verticalAlign: 'middle',
//                        borderWidth: 0,
//                        backgroundColor: '#FFFFFF',
//                        shadow: true
//                    },
//                    credits: {
//                        enabled: false
//                    },
//                    series: [{
//                            name: 'الطلبات',
//                            data: [<!% if (loads != null) {
//                                    for (int i = 0; i < loads.size(); i++) {
//                                        WebBusinessObject wbo_ = loads.get(i);
//                                        if (i > 0) {
//                                            out.write(",");
//                                        }
//                                        out.write((String) wbo_.getAttribute("noTicket"));
//                                    }
//                                }%>//]
//                        }]
//                });
//            });
//            /* -preparing bar chart */

        </script>

        <!--<script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>-->
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
    <SCRIPT  TYPE="text/javascript">

            $(document).ready(function () {

                $(".chosen-select-region").chosen();

                $(".rgnTbl").dataTable({
                    bJQueryUI: true,
                    "aLengthMenu": [[10, 25, 50, 75, 100, -1], ["10", "25", "50", "75", "100", "All"]],
                    iDisplayLength: 10
                });
            });
            
             $(document).ready(function() {
    // Get the initial value from the radio button
    var initialValue = $("input[name='mobileNation']:checked").val();

    // Call mobileChange() with the initial value
    mobileChange(initialValue);
  });

            function mobileChange(val) {


                if (val === "1") {

                    $("label[for=interPhone]").html("<p><b style=''><%=interPhone%></b><font style='color: red;'>*</font></b>&nbsp;");
                    $("label[for=clientMobile]").html("<p><b style=''><fmt:message key='mobile' /></b>&nbsp;");

                    $("#clientMobile").closest("tr").hide();
                    $("#addreg").closest("tr").show();
                    $("#interPhone").closest("tr").show();
                    $("#phoneCount").closest("tr").show();


                } else if (val === "0") {
                    $("label[for=interPhone]").html("<p><b style=''><%=interPhone%></b></b>&nbsp;");
                    $("label[for=clientMobile]").html("<p><b style=''><fmt:message key='mobile' /><font style='color: red;'>*</font></b>&nbsp;");
                    $("#clientMobile").closest("tr").show();
                    $("#addreg").closest("tr").hide();
                    $("#interPhone").closest("tr").hide();
                    $("#phoneCount").closest("tr").hide();
                }

            }

            function isChecked() {
                var isChecked = false;
                $("input[name='rgn']").each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                    }
                });
                return isChecked;
            }

            function sendInfo() {
                var rgnID = $("input[name=rgn]:checked").val();
                if (!isChecked()) {
                    alert(' إختر منطقة ');
                    return false;
                } else {
                    //document.addingRegionForm.action= "<%=context%>/ClientServlet?op=GetClientForm&add=on&rgnID=" + rgnID;
                    //document.addingRegionForm.submit(); 
                }
            }

//            $(function() {
//                $("#productSelect").multiselect();
//            });
            $(function () {
                $("#birthDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd',
                    yearRange: "-100:+0"
                });

            });
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
                //        alert('order');
                //            $("#clientID").keydown(function() {
                if ($(obj).val() == "") {
                    $("#numberMsg").show();
                    $("#numberMsg").text("رقم العميل مطلوب");
                }
                //            else if (!validateData2("numeric", this.CLIEN_FORM.ClientNo)) {
                //                $("#numberMsg").show();
                //                $("#numberMsg").text("ارقام فقط");
                //            }
                else {
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
                                //                            alert(jsonString);
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
                //            });
            }

            function isNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    alert("أرقام فقط");
                    return false;
                }

                return true;
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
            function checkName(obj) {
                $("#naMsg").hide();
                $("#naMsg").html("");

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
                }
                else {
                    $("#moMsg").hide();
                    $("#moMsg").html("");
                    $("#moMsg").text("");
                }

            }
            function checkDailedPhone() {

                if (!validateData2("numeric", this.CLIEN_FORM.dialedNumber)) {
                    $("#dailedMSG").show();
                    $("#dailedMSG").text("ارقام فقط");
                }
            }
            $(function () {
                $("#ClientNo").val("");

            });

            function checkClientNo(obj) {

                if (!validateData2("numeric", this.CLIEN_FORM.ClientNo)) {
                    $("#numberMsg").show();
                    $("#numberMsg").text("ارقام فقط");
                }
                else {
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
                //alert("Message");
                var wind = window.open(url, "testname", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=450, height=300");
                wind.focus();
                $()
            }
            function showDialog(url) {  //load content and open dialog
                $("#divv").load(url);
                $("#divv").dialog({  //create dialog, but keep it closed

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
                $('#regionForm').css("display", "block");
                $('#regionForm').bPopup({easing: 'easeOutBack', //uses jQuery easing plugin
                    speed: 700,
                    transition: 'slideDown', follow: [false, false]});
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

            function popupRegions() {
                $('#addingRegionForm').css("display", "block");
                $("#addingRegionForm").find("#msg").text("");
                $('#addingRegionForm').bPopup({easing: 'easeOutBack',
                    speed: 700,
                    transition: 'slideDown', follow: [false, false]});
            }

            function addJob(obj) {
//                var code = $('#jobCode').val();
                var jobNameAr = $('#jobNameAr').val();
//                var jobNameEn = $('#jobNameEn').val();
//                var ttradeTypeId = $('#tradeType').val();
                if (jobNameAr == null || jobNameAr == '') {
                    alert("write arabic job name");
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=saveJob",
                        data: {
                            code: jobNameAr,
                            jobNameAr: jobNameAr,
                            jobNameEn: jobNameAr,
                            ttradeTypeId: 1
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);

                            if (info.Status == 'Ok') {
                                $("#job").append("<option value='" + info.code + "'" + ">" + info.name + "</option>");
                                $('#jobCode').val("");
                                $('#jobNameAr').val("");
                                $('#jobNameEn').val("");
                                $(obj).parent().parent().parent().find('#msg').text("تم التسجيل بنجاح");

                            } else if (info.Status == 'No') {
                                $(obj).parent().parent().parent().find('#msg').text("لم يتم التسجيل");
                                //                        $('#jobCode').val("");
//                            $('#jobNameAr').val("");
                                //                        $('#jobNameEn').val("");
                            }
                        }
                    });
                }
            }

            function addRegion(obj) {

                //            var code = $('#regionCode').val();
                var regionNameAr = $('#regionNameAr').val();
                //            var regionNameEn = $('#regionNameEn').val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveRegion",
                    data: {
                        //                    code: code,
                        regionNameAr: regionNameAr
                                //                    regionNameEn: regionNameEn
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.Status == 'Ok') {
                            $("#region").append("<option value='" + info.code + "'" + ">" + info.name + "</option>");
                            //                        $('#regionCode').val("");
                            $('#regionNameAr').val("");
                            //                        $('#regionNameEn').val("");
                            $(obj).parent().parent().parent().find('#msg').text("تم التسجيل بنجاح");

                        } else if (info.Status == 'No') {
                            $(obj).parent().parent().parent().find('#msg').text("لم يتم التسجيل");

                            //                        $('#regionCode').val("");
                            $('#regionNameAr').val("");
                            //  $('#regionNameEn').val("");
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
                                $("#dialedNumber").append("<option value='" + info.id + "'" + ">" + info.name + "</option>");
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
            function campaign() {
                var url = "<%=context%>/CampaignServlet?op=showCampaigns&clientId=<%=clientId%>";
                        jQuery('#add_campaigns').load(url);
                        $('#add_campaigns').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                            speed: 400,
                            position: [370, 70],
                            transition: 'slideDown'});
                    }
                    function checkClientPhone(obj) {
                        var clientPhone = $("#phone").val();
                        var clientLocalPhone = $("#localP").val();
                        var clientInternationPhone = $("#internationalP").val();
                        var phone = clientInternationPhone + clientLocalPhone + clientPhone;
                        if (clientPhone.length > 0) {
                            $.ajax({
                                type: "post",
                                url: "<%=context%>/ClientServlet?op=getClientPhone",
                                data: {
                                    phone: phone
                                },
                                success: function (jsonString) {
                                    var info = $.parseJSON(jsonString);
                                    if (info.status == 'No') {
                                        $("#telMSG").css("color", "green");
                                        $("#telMSG").css("text-align", "left");
                                        $("#telMSG").css("display", "inline");
                                        $("#telMSG").text("");
                                        $("#telMSG").removeClass("error");
                                        $("#telWarning").css("display", "none");
                                        $("#telOk").css("display", "inline");

                                        $("#submitBtn").removeAttr("disabled");
                                        $("#existphoneClient").css("display", "none");
                                    } else if (info.status == 'Ok') {
                                        $("#telMSG").css("color", "red");
                                        $("#telMSG").css("display", "inline");
                                        $("#telMSG").css("font-size", "12px");
                                        $("#telMSG").text(" محجوز");
                                        $("#telMSG").addClass("error");
                                        $("#telWarning").css("display", "inline");
                                        $("#telOk").css("display", "none");

                                        $("#submitBtn").attr("disabled", "true");
                                        $("#existphoneClient").css("display", "inline");
                                        $("#existphoneClient").text("View");
                                        $("#existphoneClient").attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + info.id);



                                    }
                                }
                            });
                        }
                        else
                        {
                            $("#existphoneClient").css("display", "none");
                            $("#telOk").css("display", "none");
                            $("#telWarning").css("display", "none");
                            $("#telMSG").text("");
                        }
                    }
                    function checkClientMobile(obj) {
                        var clientMob = $("#clientMobile").val();
                        var clientInternationMob = $("#internationalM").val();
                        var phone = clientInternationMob + clientMob;
                        if (clientMob.length > 0) {
                            $.ajax({
                                type: "post",
                                url: "<%=context%>/ClientServlet?op=getClientMobile",
                                data: {
                                    mobile: phone
                                },
                                success: function (jsonString) {
                                    var info = $.parseJSON(jsonString);
                                    if (info.status == 'No') {
                                        $("#mobMSG").css("color", "green");
                                        $("#mobMSG").css(" text-align", "left");
                                        $("#mobMSG").text("");
                                        $("#mobMSG").removeClass("error");
                                        $("#mobWarning").css("display", "none");
                                        $("#mobOk").css("display", "inline");
                                        $("#submitBtn").removeAttr("disabled");
                                        $("#existmobClient").css("display", "none");
                                    } else if (info.status == 'Ok') {
                                        $("#mobMSG").css("color", "red");
                                        $("#mobMSG").css("font-size", "12px");
                                        $("#mobMSG").text(" محجوز");
                                        $("#mobMSG").addClass("error");
                                        $("#mobMSG").css("display", "inline");
                                        $("#mobWarning").css("display", "inline");
                                        $("#mobOk").css("display", "none");
                                        $("#submitBtn").attr("disabled", "true");

                                        $("#existmobClient").css("display", "inline");
                                        $("#existmobClient").text("View");
        <%
            if (privilegesList.contains("EXISTS_CLIENT")) {
        %>
                                        $("#existmobClient").attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + info.id);
        <%
        } else {
        %>
                                        $("#existmobClient").attr("href", "JavaScript: showDetails(" + info.id + ");");
        <%
            }
        %>

                                    }
                                }
                            });
                        }
                        else
                        {
                            $("#existmobClient").css("display", "none");
                            $("#mobOk").css("display", "none");
                            $("#mobWarning").css("display", "none");
                            $("#mobMSG").text("");
                        }
                    }

                    function checkClientEmail(obj) {
                        var email = $("#email").val();

                        if (email != "" && email != " ") {
                            $.ajax({
                                type: "post",
                                url: "<%=context%>/ClientServlet?op=getClientMail",
                                data: {
                                    email: email
                                },
                                success: function (jsonString) {
                                    var info = $.parseJSON(jsonString);
                                    if (info.exist == 'false') {
                                        $("#mailMsg").css("color", "green");
                                        $("#mailMsg").css(" text-align", "left");
                                        $("#mailMsg").text("");
                                        $("#mailMsg").removeClass("error");
                                        $("#mailWarning").css("display", "none");
                                        $("#mailOk").css("display", "inline");
                                        $("#submitBtn").removeAttr("disabled");

                                    } else if (info.exist == 'true') {
                                        $("#mailMsg").css("color", "red");
                                        $("#mailMsg").css("font-size", "12px");
                                        $("#mailMsg").text(" محجوز");
                                        $("#mailMsg").addClass("error");
                                        $("#mailMsg").css("display", "inline");
                                        $("#mailWarning").css("display", "inline");
                                        $("#mailOk").css("display", "none");
                                        $("#submitBtn").attr("disabled", "true");




                                    }
                                }
                            });
                        }
                    }
                    function checkClientInterPhone(obj) {
                        var interPhone = $("#interPhone").val();
                        if (interPhone.length > 0) {
                            $.ajax({
                                type: "post",
                                url: "<%=context%>/ClientServlet?op=getClientInterPhone",
                                data: {
                                    interPhone: interPhone
                                },
                                success: function (jsonString) {
                                    var info = $.parseJSON(jsonString);
                                    if (info.status === 'No') {
                                        $("#interMSG").css("color", "green");
                                        $("#interMSG").css(" text-align", "left");
                                        $("#interMSG").text("");
                                        $("#interMSG").removeClass("error");
                                        $("#interWarning").css("display", "none");
                                        $("#interOk").css("display", "inline");
                                        $("#existinterClient").css("display", "none");

                                        $("#submitBtn").removeAttr("disabled");

                                    }
                                    else if (info.status === 'Ok') {
                                        $("#interMSG").css("color", "red");
                                        $("#interMSG").css("font-size", "12px");
                                        $("#interMSG").text(" محجوز");
                                        $("#interMSG").addClass("error");
                                        $("#interWarning").css("display", "inline");
                                        $("#interOk").css("display", "none");

                                        $("#submitBtn").attr("disabled", "true");
                                        $("#existinterClient").css("display", "inline");
                                        $("#existinterClient").text("View");
                                        $("#existinterClient").attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + info.id);

                                    }
                                }
                            });
                        }
                        else
                        {
                            $("#existinterClient").css("display", "none");
                            $("#interOk").css("display", "none");
                            $("#interWarning").css("display", "none");
                            $("#interMSG").text("");
                        }
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
                                        $("#nameMSG").text("")
                                        $("#nameMSG").removeClass("error");
                                        $("#nameWarning").css("display", "none");
                                        $("#nameOk").css("display", "inline")
                                        $("#existnameClient").css("display", "none");
                                    } else if (info.status == 'Ok') {
                                        $("#nameMSG").css("color", "red");
                                        $("#nameMSG").css("font-size", "12px");
                                        $("#nameMSG").text(" محجوز");
                                        $("#nameMSG").addClass("error");
                                        $("#nameWarning").css("display", "inline")
                                        $("#nameOk").css("display", "none");

                                        $("#existnameClient").css("display", "inline");
                                        $("#existnameClient").text("View");
                                        $("#existnameClient").attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + info.id);

                                    }
                                }
                            });
                        }
                        else {
                            $("#nameMSG").text("");
                            $("#nameWarning").css("display", "none");
                            $("#nameOk").css("display", "none");
                            $("#existnameClient").css("display", "none");
                        }

                    }
                    function recordCall2(obj) {
                        //            alert("fdlgjkdfl")
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
                                    $("#entryDate").val(entryDate);
                                    $(obj).parent().parent().find("#callerNumber").css("display", "block");
                                    $(obj).parent().parent().find("#callerNumber").html("رقم المتابعة : " + "<font style='color:#f9f9f9'>" + info.businessId + "</font>");
                                    $(obj).css("display", "none");
                                    $("#recordCall").css("display", "none");
                                    $("#seasonBtn").css("display", "inline-block");
                                    $("#productsBtn").css("display", "inline-block");
                                    $("#compID").val(info.issueId);

                                    $("#callNo").text(info.businessId);
//                                var row = "<tr><td >رقم المتابعة</td><td style='text-align:right;font-size:14px;'>" + info.businessId + "<input type='hidden' id='businessId' value='" + info.businessId + "'/></td></tr>";
                                    var row = "<td nowrap CLASS='silver_header' STYLE='border-width: 0px; white-space: nowrap;'>&nbsp;</td>";
                                    row += "<td width='100' STYLE='<%=style%>;' BGCOLOR='#DDDD00' nowrap  CLASS='silver_odd'><b><font size='2' color='black'><%=call_number%></font></b></td>";
                                    row += "<td width='200' style='border-right-width:0px;text-align: center;'><b id='callNo'><font size=3 color='blue'>" + info.businessId + "</font></b><input type='hidden' id='businessId' value='" + info.businessId + "'/></td>";
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
                    //        $(function(){
                    //            $("#automatedClientNo").attr("checked", true);
                    //            $("#numberMsg").text("");
                    //            document.getElementById("clientNO").disabled = true;
                    //        })

                    function submitForm() {
    if ($("#numberRow").attr("class") === "numberRow") {
        var automatedClientNo = document.getElementById('automatedClientNo');
        if (!automatedClientNo.checked && (!validateData2("req", this.CLIEN_FORM.clientNO) || !validateData2("numeric", this.CLIEN_FORM.clientNO))) {

            this.CLIEN_FORM.clientNO.focus();
            if (!validateData2("req", this.CLIEN_FORM.clientNO)) {
                $("#numberMsg").show().text("رقم العميل مطلوب");
                return false;
            } else {
                $("#numberMsg").hide().html("");
            }
            if (!validateData2("numeric", this.CLIEN_FORM.clientNO)) {
                $("#numberMsg").show().text("أرقام فقط");
                return false;
            } else {
                $("#numberMsg").hide().html("");
            }
            return false;
        }
    } else {
        var automatedClientNo = document.getElementById('automatedClientNo');
        if (!automatedClientNo.checked && (!validateData2("req", this.CLIEN_FORM.clientNO) || !validateData2("numeric", this.CLIEN_FORM.clientNO))) {
            this.CLIEN_FORM.clientNO.focus();
            if (!validateData2("req", this.CLIEN_FORM.clientNO)) {
                $("#numberMsg").show().text("رقم العميل مطلوب");
                return false;
            } else {
                $("#numberMsg").hide().html("");
            }
            if (!validateData2("numeric", this.CLIEN_FORM.clientNO)) {
                $("#numberMsg").show().text("أرقام فقط");
                return false;
            } else {
                $("#numberMsg").hide().html("");
            }
            return false;
        }
    }

    // التحقق من اسم العميل
    if (!validateData2("req", this.CLIEN_FORM.clientName) || !validateData2("minlength=3", this.CLIEN_FORM.clientName)) {
        this.CLIEN_FORM.clientName.focus();

        if ($("#clientName").val() == "") {
            $("#naMsg").show().text("إسم العميل مطلوب");
        } else if (!validateData2("minlength=3", this.CLIEN_FORM.clientName)) {
            $("#naMsg").show().text("الإسم اقل من 3 حروف");
        } else {
            $("#naMsg").hide().html("");
        }
        return false;
    }

    var dailedPhone = $("#dialedNumber").val();
    var phoneNo = $("#phone").val();
    var mobileNo = $("#clientMobile").val();
    var interPhone = $("#interPhone").val();
    var mobileNat0 = $("#mobileNation0").is(":checked");
    var mobileNat1 = $("#mobileNation1").is(":checked");

    if ((mobileNo === "" || mobileNo === " ") && mobileNat0 && !mobileNat1) {
        alert("يجب ادخال رقم الموبايل ");
        $("#clientMobile").focus();
        return false;
    }
    if ((interPhone === "" || interPhone === " ") && !mobileNat0 && mobileNat1) {
        alert("يجب ادخال الرقم الدولي ");
        $("#interPhone").focus();
        return false;
    }

    if (phoneNo === "" && mobileNo === "" && dailedPhone === "" && interPhone === "") {
        alert("يجب ادخال رقم تليفون واحد على الاقل");
        return false;
    } else {
        if (mobileNo.length > 0 && mobileNo.length < 11) {
            alert("يجب ادخال رقم الموبايل كامل او مسحه (11 رقم)");
            $("#clientMobile").focus();
            return false;
        }
        if (interPhone.length > 0 && interPhone.length < 5) {
            alert("يجب ادخال رقم التليفون الدولي كامل او مسحه (من 5 إلى 16 رقم)");
            $("#interPhone").focus();
            return false;
        }
    }

    if (!validateData2("numeric", this.CLIEN_FORM.clientMobile)) {
        this.CLIEN_FORM.clientMobile.focus();
        $("#moMsg").show().text("أرقام فقط");
        return false;
    } else {
        $("#moMsg").hide().html("");
    }

    // ✅ التحقق فقط من العناصر الظاهرة
    var dialedSelect = $("#dialedNumber");
    if (dialedSelect.is(":visible") && !validateData2("req", this.CLIEN_FORM.dialedNumber)) {
        this.CLIEN_FORM.dialedNumber.focus();
        alert("يجب أختيار طريقة معرفة العميل بالشركة");
        return false;
    }

    var campaignSelect = $("#campaignsselect");
    if (campaignSelect.is(":visible") && !validateData2("req", this.CLIEN_FORM.campaignsselect)) {
        this.CLIEN_FORM.campaignsselect.focus();
        alert("يجب أختيار حملة علي الأقل");
        return false;
    }

    if (mobileNat1 && !mobileNat0) {
        mobileNo = $("#interPhone").val();
        $("#clientMobile").val(mobileNo).change();
    }

    document.getElementById("submitBtn").style.display = "none";
    document.CLIEN_FORM.action = "<%=context%>/ClientServlet?op=SaveClient";
    document.CLIEN_FORM.submit();
}

// إظهار أو إخفاء الصفوف بناءً على القيمة المختارة
function showHideRows(selectedValue) {
    var isGhairMobasherSelected = selectedValue === "3";
    var campaignRow = document.querySelector('.campaignRow');
    var elementsToShowOrHide = document.querySelectorAll('.conditionalRow');

    if (isGhairMobasherSelected) {
        if (campaignRow) campaignRow.style.display = 'none';
        elementsToShowOrHide.forEach(function(element) {
            element.style.display = ''; // show
        });
    } else {
        if (campaignRow) campaignRow.style.display = '';
        elementsToShowOrHide.forEach(function(element) {
            element.style.display = 'none';
        });
    }
}

// استدعاء عند تحميل الصفحة لضبط الحالة الأولية
window.onload = function() {
    showHideRows(document.getElementById('dialedNumber').value);
};



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
                        var clientId = $("#clientId").val();
                        var businessId = $("#businessId").val();
                        var issueId = $("#compID").val();
                        var entryDate = $("#entryDate").val();

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
                                employeeId: empId,
                                issueId: issueId,
                                mgrId: departmentMgrId,
                                entryDate: entryDate

                            },
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'yes') {
                                    $(obj).html("");
                                    $(obj).css("background-position", "top");
                                    $(obj).removeAttr("onclick");
                                } else {
                                    alert("لم يتم الأرسال" + "\nMessage: " + info.message);
                                }
                            }
                        });
                        //            });

                    }

                    function saveSeason(obj) {

                        var seasonNotes = $(obj).parent().parent().find('#seasonNotes').val();
                        var seasonId = $(obj).parent().parent().find('#seasonId').val();
                        var seasonName = $(obj).parent().parent().find('#seasonName').val();
                        //            var seasonCode = $("#seasonCode").val();
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
                        //            });

                    }

                    function attachDegree() {
                        var clientId = document.getElementById("clientId").value;
                        document.CLIEN_FORM.action = "<%=context%>/ClientServlet?op=attachGradesToCustomer&clientId=" + clientId;
                        document.CLIEN_FORM.submit();
                    }

                    // run the currently selected effect
                    function runEffect() {
                        if (document.getElementById("effect").style.display == "none") {
                            document.getElementById("effect").style.display = "block";
                            document.getElementById("view_employee_loads").disabled = true;
                        } else {
                            document.getElementById("effect").style.display = "none";
                            document.getElementById("view_employee_loads").disabled = false;
                        }
                    }

                    $(function () {
                        runEffect();
                    });
                    var divTag;
                    function showDetails(clientID) {
                        divTag = $("#clientDetailsForm");
                        $.ajax({
                            type: "post",
                            url: '<%=context%>/ClientServlet?op=viewClientPopup',
                            data: {
                                clientID: clientID
                            },
                            success: function (data) {
                                divTag.html(data).dialog({
                                    modal: true,
                                    title: "تفاصيل العميل",
                                    show: "fade",
                                    hide: "explode",
                                    width: 1050,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        'Close': function () {
                                            $(this).dialog('close');
                                        }
                                    }
                                }).dialog('open');
                            },
                            error: function (data) {
                                alert(data);
                            }
                        });
                    }


                    function clearCampaignSuggest()
                    {
                        // $('#campaignsselect option:selected').prop("selected", false);
                        var collection = document.getElementById('campaignsselect').getElementsByTagName('option');

                        for (var i = 0; i < collection.length; i++) {
                            collection[i].selected = false;
                        }
                        $('#campaignsselect').trigger('chosen:updated');
                    }


                    function getCampaignsSuggest() {
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/CampaignServlet?op=getCampaignSuggest",
                            data: {
                                channelID: $("#dialedNumber").val()
                            },
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                $('#campaignsselect option:selected').removeAttr('selected');
                                $('#campaignsselect').trigger('chosen:updated');
                                if (info !== null) {
                                    for (i = 0; i < info.length; i++) {
                                        // $('#campaignsselect option[value='+info[i].id+']').prop('selected', true);
                                        var text = info[i].campaignTitle;
                                        var value = info[i].id;
                                        $('#campaignsselect').append('<option value=' + value + ' selected="selected"> ' + text + '</option>');
                                    }

                                }
                                $('#campaignsselect').trigger('chosen:updated');
                            }
                        });
                    }
    var countries = [
{name:"Afghanistan",code: "93" },
{name:"Åland Islands",code: "358" },
{name:"Albania",code: "355" },
{name:"Algeria",code: "213" },
{name:"American Samoa",code: "1" },
{name:"Andorra",code: "376" },
{name:"Angola",code: "244" },
{name:"Anguilla",code: "1" },
{name:"Antigua and Barbuda",code: "1" },
{name:"Argentina",code: "54" },
{name:"Armenia",code: "374" },
{name:"Aruba",code: "297" },
{name:"Australia",code: "61" },
{name:"Austria",code: "43" },
{name:"Azerbaijan",code: "994" },
{name:"Bahamas",code: "1" },
{name:"Bahrain",code: "973" },
{name:"Bangladesh",code: "880" },
{name:"Barbados",code: "1" },
{name:"Belarus",code: "375" },
{name:"Belgium",code: "32" },
{name:"Belize",code: "501" },
{name:"Benin",code: "229" },
{name:"Bermuda",code: "1" },
{name:"Bhutan",code: "975" },
{name:"Bolivia",code: "591" },
{name:"Bonaire,code: Sint Eustatius and Saba",code: "599" },
{name:"Bosnia and Herzegovina",code: "387" },
{name:"Botswana",code: "267" },
{name:"Brazil",code: "55" },
{name:"British Indian Ocean Territory",code: "246" },
{name:"British Virgin Islands",code: "1" },
{name:"Brunei",code: "673" },
{name:"Bulgaria",code: "359" },
{name:"Burkina Faso",code: "226" },
{name:"Burundi",code: "257" },
{name:"Cabo Verde",code: "238" },
{name:"Cambodia",code: "855" },
{name:"Cameroon",code: "237" },
{name:"Canada",code: "1" },
{name:"Caribbean",code: "0" },
{name:"Cayman Islands",code: "1" },
{name:"Central African Republic",code: "236" },
{name:"Chad",code: "235" },
{name:"Chile",code: "56" },
{name:"China",code: "86" },
{name:"Christmas Island",code: "61" },
{name:"Cocos (Keeling) Islands",code: "61" },
{name:"Colombia",code: "57" },
{name:"Comoros",code: "269" },
{name:"Congo",code: "242" },
{name:"Congo (DRC)",code: "243" },
{name:"Cook Islands",code: "682" },
{name:"Costa Rica",code: "506" },
{name:"Côte d’Ivoire",code: "225" },
{name:"Croatia",code: "385" },
{name:"Cuba",code: "53" },
{name:"Curaçao",code: "599" },
{name:"Cyprus",code: "357" },
{name:"Czechia",code: "420" },
{name:"Denmark",code: "45" },
{name:"Djibouti",code: "253" },
{name:"Dominica",code: "1" },
{name:"Dominican Republic",code: "1" },
{name:"Ecuador",code: "593" },
{name:"Egypt",code: "20" },
{name:"El Salvador",code: "503" },
{name:"Equatorial Guinea",code: "240" },
{name:"Eritrea",code: "291" },
{name:"Estonia",code: "372" },
{name:"Ethiopia",code: "251" },
{name:"Europe",code: "0" },
{name:"Falkland Islands",code: "500" },
{name:"Faroe Islands",code: "298" },
{name:"Fiji",code: "679" },
{name:"Finland",code: "358" },
{name:"France",code: "33" },
{name:"French Guiana",code: "594" },
{name:"French Polynesia",code: "689" },
{name:"Gabon",code: "241" },
{name:"Gambia",code: "220" },
{name:"Georgia",code: "995" },
{name:"Germany",code: "49" },
{name:"Ghana",code: "233" },
{name:"Gibraltar",code: "350" },
{name:"Greece",code: "30" },
{name:"Greenland",code: "299" },
{name:"Grenada",code: "1" },
{name:"Guadeloupe",code: "590" },
{name:"Guam",code: "1" },
{name:"Guatemala",code: "502" },
{name:"Guernsey",code: "44" },
{name:"Guinea",code: "224" },
{name:"Guinea-Bissau",code: "245" },
{name:"Guyana",code: "592" },
{name:"Haiti",code: "509" },
{name:"Honduras",code: "504" },
{name:"Hong Kong SAR",code: "852" },
{name:"Hungary",code: "36" },
{name:"Iceland",code: "354" },
{name:"India",code: "91" },
{name:"Indonesia",code: "62" },
{name:"Iran",code: "98" },
{name:"Iraq",code: "964" },
{name:"Ireland",code: "353" },
{name:"Isle of Man",code: "44" },
{name:"Israel",code: "972" },
{name:"Italy",code: "39" },
{name:"Jamaica",code: "1" },
{name:"Japan",code: "81" },
{name:"Jersey",code: "44" },
{name:"Jordan",code: "962" },
{name:"Kazakhstan",code: "07" },
{name:"Kenya",code: "254" },
{name:"Kiribati",code: "686" },
{name:"Korea",code: "82" },
{name:"Kosovo",code: "383" },
{name:"Kuwait",code: "965" },
{name:"Kyrgyzstan",code: "996" },
{name:"Laos",code: "856" },
{name:"Latin America",code: "0" },
{name:"Latvia",code: "371" },
{name:"Lebanon",code: "961" },
{name:"Lesotho",code: "266" },
{name:"Liberia",code: "231" },
{name:"Libya",code: "218" },
{name:"Liechtenstein",code: "423" },
{name:"Lithuania",code: "370" },
{name:"Luxembourg",code: "352" },
{name:"Macao SAR",code: "853" },
{name:"Macedonia,code: FYRO",code: "389" },
{name:"Madagascar",code: "261" },
{name:"Malawi",code: "265" },
{name:"Malaysia",code: "60" },
{name:"Maldives",code: "960" },
{name:"Mali",code: "223" },
{name:"Malta",code: "356" },
{name:"Marshall Islands",code: "692" },
{name:"Martinique",code: "596" },
{name:"Mauritania",code: "222" },
{name:"Mauritius",code: "230" },
{name:"Mayotte",code: "262" },
{name:"Mexico",code: "52" },
{name:"Micronesia",code: "691" },
{name:"Moldova",code: "373" },
{name:"Monaco",code: "377" },
{name:"Mongolia",code: "976" },
{name:"Montenegro",code: "382" },
{name:"Montserrat",code: "1" },
{name:"Morocco",code: "212" },
{name:"Mozambique",code: "258" },
{name:"Myanmar",code: "95" },
{name:"Namibia",code: "264" },
{name:"Nauru",code: "674" },
{name:"Nepal",code: "977" },
{name:"Netherlands",code: "31" },
{name:"New Caledonia",code: "687" },
{name:"New Zealand",code: "64" },
{name:"Nicaragua",code: "505" },
{name:"Niger",code: "227" },
{name:"Nigeria",code: "234" },
{name:"Niue",code: "683" },
{name:"Norfolk Island",code: "672" },
{name:"North Korea",code: "850" },
{name:"Northern Mariana Islands",code: "1" },
{name:"Norway",code: "47" },
{name:"Oman",code: "968" },
{name:"Pakistan",code: "92" },
{name:"Palau",code: "680" },
{name:"Palestinian Authority",code: "970" },
{name:"Panama",code: "507" },
{name:"Papua New Guinea",code: "675" },
{name:"Paraguay",code: "595" },
{name:"Peru",code: "51" },
{name:"Philippines",code: "63" },
{name:"Pitcairn Islands",code: "0" },
{name:"Poland",code: "48" },
{name:"Portugal",code: "351" },
{name:"Puerto Rico",code: "1" },
{name:"Qatar",code: "974" },
{name:"Réunion",code: "262" },
{name:"Romania",code: "40" },
{name:"Russia",code: "7" },
{name:"Rwanda",code: "250" },
{name:"Saint Barthélemy",code: "590" },
{name:"Saint Kitts and Nevis",code: "1" },
{name:"Saint Lucia",code: "1" },
{name:"Saint Martin",code: "590" },
{name:"Saint Pierre and Miquelon",code: "508" },
{name:"Saint Vincent and the Grenadines",code: "1" },
{name:"Samoa",code: "685" },
{name:"San Marino",code: "378" },
{name:"São Tomé and Príncipe",code: "239" },
{name:"Saudi Arabia",code: "966" },
{name:"Senegal",code: "221" },
{name:"Serbia",code: "381" },
{name:"Seychelles",code: "248" },
{name:"Sierra Leone",code: "232" },
{name:"Singapore",code: "65" },
{name:"Sint Maarten",code: "1" },
{name:"Slovakia",code: "421" },
{name:"Slovenia",code: "386" },
{name:"Solomon Islands",code: "677" },
{name:"Somalia",code: "252" },
{name:"South Africa",code: "27" },
{name:"South Sudan",code: "211" },
{name:"Spain",code: "34" },
{name:"Sri Lanka",code: "94" },
{name:"St Helena,code: Ascension,code: Tristan da Cunha",code: "290" },
{name:"Sudan",code: "249" },
{name:"Suriname",code: "597" },
{name:"Svalbard and Jan Mayen",code: "47" },
{name:"Swaziland",code: "268" },
{name:"Sweden",code: "46" },
{name:"Switzerland",code: "41" },
{name:"Syria",code: "963" },
{name:"Taiwan",code: "886" },
{name:"Tajikistan",code: "992" },
{name:"Tanzania",code: "255" },
{name:"Thailand",code: "66" },
{name:"Timor-Leste",code: "670" },
{name:"Togo",code: "228" },
{name:"Tokelau",code: "690" },
{name:"Tonga",code: "676" },
{name:"Trinidad and Tobago",code: "1" },
{name:"Tunisia",code: "216" },
{name:"Turkey",code: "90" },
{name:"Turkmenistan",code: "993" },
{name:"Turks and Caicos Islands",code: "1" },
{name:"Tuvalu",code: "688" },
{name:"U.S. Outlying Islands",code: "0" },
{name:"U.S. Virgin Islands",code: "1" },
{name:"Uganda",code: "256" },
{name:"Ukraine",code: "380" },
{name:"United Arab Emirates",code: "971" },
{name:"United Kingdom",code: "44" },
{name:"United States",code: "001" },
{name:"Uruguay",code: "598" },
{name:"Uzbekistan",code: "998" },
{name:"Vanuatu",code: "678" },
{name:"Vatican City",code: "39" },
{name:"Venezuela",code: "58" },
{name:"Vietnam",code: "84" },
{name:"Wallis and Futuna",code: "681" },
{name:"World",code: "0" },
{name:"Yemen",code: "967" },
{name:"Zambia",code: "260" },
{name:"Zimbabwe",code: "263" },  // يمكنك إضافة المزيد من الدول هنا
];

function getCountryName() {
  var phoneNumber = document.getElementById("phoneCount").value;
  var countryCode = phoneNumber; // استخراج رمز الدولة من الرقم

  var countryName = "غير معروف"; // اسم الدولة الافتراضي

  // البحث عن اسم الدولة بناءً على رمز الدولة
  for (var i = 0; i < countries.length; i++) {
    if (countries[i].code === countryCode) {
      countryName = countries[i].name;
      break;
    }
  }

  document.getElementById("addreg").value = countryName; // عرض اسم الدولة في حقل النص
}
    </SCRIPT>

    <STYLE>
        .ahmed-gamal {
            width:40px;
            height: 40px;
            float:right;

        }

        .ahmed-gamal a img {
            width: 40px important;
            height: 40px important;
            margin: 0px;
            padding: 0px;
            text-align: right;
        }

        textarea{resize:none;}
        .titlebar {
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
        #projectsTbl td{
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
        .view_employee_loads{
            width:200px;
            height:30px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/view_employee_loads.png);
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

        .btn-gemy {
            font-weight: bold;
            background: orange;
            border:none;
            padding:5px 10px;
            border-radius: 5px;
        }
        .p-gemy {
            float: right;
            margin-right: 30px;

        }

        .data-gemy {
            width: 500px;
        }


        .linkbtn:link{
            background-color: orange;
            color: red;
            font-weight: bold;

            font-weight: bold;
            font-size: 15px;
            padding:7px 7px;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
        }


        .linkbtn:hover, .linkbtn:active {
            text-decoration: underline;
            color: white;


        }
        .button2{
            font-family: "Script MT", cursive;
            font-size: 18px;
            font-style: normal;
            font-variant: normal;
            font-weight: 400;
            line-height: 20px;
            width: 134px;
            height: 32px;
            text-decoration: none;
            display: inline-block;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.8s;
            cursor: pointer;
            border-radius: 12px;
            border: 1px solid #008CBA;
            padding-left:2%;
            text-align: center;
        }


        .button2:hover {
            background-color: #afdded;
            padding-top: 0px;
        }
        
        .chosen-container{
            width: 100% !important;
        }
        .chosen-container-fahd{
            width: 100px !important;
        }
input[type="text"] {
    width: 230px;
    margin-right: 5px;
    background-color:whitesmoke;
    border: 2px solid #000;
    border-radius: 5px;
    font-size: 16px;
    color: #000;
    outline: none;
    transition: border-color 0.3s, background-color 0.3s;
}

input[type="text"]:focus {
    border-color: #555;
    background-color: #FFFACD;
}

input[type="text"]::placeholder {
    color: #666;
}s
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY >
        <div id="clientDetailsForm"></div>
        <div id="add_campaigns" style="width: 50% !important;display: none;"></div>
        <input id="compID" type="hidden" value="<%=issueId != null ? issueId : ""%>" />
        <input id="issueID" type="hidden" />
        <input type="hidden" id="entryDate" value="" />
        <FORM NAME="CLIEN_FORM" METHOD="POST">

            <div id="callerDiv" style="width: 50%; display: none; position: absolute;">
                <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -100;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
                </div>
                <div class="login" style="width: 100%;height:250px;float: left;">
                    <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;" >
                        <tr style="height:50px;">
                            <td width="30%" style="color: #000;text-align: right">نوع الإتصال </td>
                            <td style="text-align:right;">
                                <input name="note" type="radio" value="call" checked="" id="note">
                                <label><img src="images/dialogs/phone.png" alt="phone" width="24px">مكالمة </label>
                                <input name="note" type="radio" value="meeting" id="note" style="margin-right: 10px;">
                                <label><img src="images/dialogs/handshake.png" alt="meeting" width="24px"> مقابلة</label>
                                <input name="note" type="radio" value="internet" id="note" style="margin-right: 10px;">
                                <label> <img src="images/dialogs/internet-icon.png" alt="internet" width="24px"> أنترنت</label>
                            </td>
                        </tr>
                        <br>
                        <tr style="height:50px;">
                            <td width="30%"  style="color: #000;text-align: right">إتجاة المكالمة/المقابة</td>
                            <td style="text-align:right;">
                                <input  name="call_status" type="radio" value="incoming" <%=campaignDirection.equalsIgnoreCase("2") || campaignDirection.isEmpty() ? "checked" : ""%> id="call_status" />
                                <label><img src="images/dialogs/call-incoming.png" width="24px"/>واردة</label>
                                <input name="call_status" type="radio" value="out_call" <%=campaignDirection.equalsIgnoreCase("1") ? "checked" : ""%> id="call_status" style="margin-right: 10px;"/>
                                <label><img src="images/dialogs/call-outgoing.png" width="24px"/>صادرة</label>
                            </td>
                        </tr>

                        <tr style="height:50px;">
                            <td  style="color: #000;text-align: right">التاريخ</td>
                            <td dir="ltr" style="<%=style%>"> 
                                <input name="entryDate" id="appDate1" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/>
                            </td>
                        </tr>

                        <tr style="height:50px;">
                            <td colspan="2">
                                <div id="callerNumber" style="color: #000;width: 50%;margin-left: auto;margin-right: auto;text-align: center;display: none;clear: both;">
                                </div>
                                <div id="callerBtn" style="margin-left: auto;margin-right: auto;text-align:center;">  
                                    <input  name="save_info" type="button" onclick="recordCall2(this);" id ="save_info"class="button_record"/>
                                </div>
                            </td>
                        </tr>

                        <tr style="height:50px;">
                            <td colspan="2"></td>
                        </tr>
                    </table>
                </div>
            </div>        

            <DIV style="color:blue;margin-bottom: 5px; margin-top: 0px; width: 100%;display:inline-block">
                <table align="center" width="90%" cellpadding="0" cellspacing="0" style="border-width: 0px">
                    <tr>
                        <td style="width: 10%; border-width: 0px">
                            <%--
                            <img width="70px"  height="70px"  src="images/icons/plane_icon.png" id="autoPilotIcon" style="border: none;display: <%=!autoPilotModeValue.equals("-1") ? "" : "none"%>" title="<%if (!autoPilotModeValue.equals("-1")) {%>Auto-Pilot Mode<%}%>"/>
                            <br>
                            <%if (!autoPilotModeValue.equals("-1")) { %>
                            <b id="autoPilotLabel" style="font-weight: bold; font-size: 14px; color: blue">Auto-Pilot Mode</b><% }%>
                            --%>
                        </td>
                        <td style="border-width: 0px">
                            <input  type="button" onclick="getTasks()" id="productsBtn"  style="display: none;margin-right: 5px;" class="button_products"/>
                            <input  id="recordCall" type="button" onclick="getRecord();" class="button_record" style="display: none;margin-right: 5px;" value=""/>
                            <input  type="button" onclick="campaign()"  id="seasonBtn" class="seasonsBtn" style="display: none;margin-right: 5px;" value=""/>
                        </td>
                        <td style="width: 30%; border-width: 0px">
<!--                        <img width="70px"  height="70px"  src="images/icons/inpound-call.png" id="inboundCall" style="margin-left: 0px;border: none;display: <%=!callCenterMode.isEmpty() && callCenterMode.equals("2") ? "" : "none"%>" title="<%if (!callCenterMode.isEmpty() && callCenterMode.equals("2")) {%>Call Center Mode<%}%>"/>
                            <img width="70px"  height="70px"  src="images/icons/outpound-call.png" id="outboundCall" style="border: none;display: <%=!callCenterMode.isEmpty() && callCenterMode.equals("3") ? "" : "none"%>" title="<%if (!callCenterMode.isEmpty() && callCenterMode.equals("3")) {%>Call Center Mode<%}%>"/>
                            <img width="70px"  height="70px"  src="images/icons/inpound-call.png" id="inboundMeeting" style="border: none;display: <%=!callCenterMode.isEmpty() && callCenterMode.equals("4") ? "" : "none"%>" title="<%if (!callCenterMode.isEmpty() && callCenterMode.equals("4")) {%>Call Center Mode<%}%>"/>
                            <img width="70px"  height="70px"  src="images/icons/outpound-call.png" id="outboundMeeting" style="border: none;display: <%=!callCenterMode.isEmpty() && callCenterMode.equals("5") ? "" : "none"%>" title="<%if (!callCenterMode.isEmpty() && callCenterMode.equals("5")) {%>Call Center Mode<%}%>"/>
                            <img width="70px"  height="70px"  src="images/icons/outpound-call.png" id="outboundInternet" style="border: none;display: <%=!callCenterMode.isEmpty() && callCenterMode.equals("6") ? "" : "none"%>" title="<%if (!callCenterMode.isEmpty() && callCenterMode.equals("6")) {%>Call Center Mode<%}%>"/>-->
                            <div class="ahmed-gamal" style="width:60px; border:1px solid black; height:50px; float:right; padding: 2px;">
                                <a href="#" onclick="">
                                    <image id="inbound" style="height:35px;display: <%=!callCenterMode.isEmpty() && (callCenterMode.equals("2") || callCenterMode.equals("4")) ? "" : "none"%> ;" src="images/icons/inBound.png" title="<%if (!callCenterMode.isEmpty() && (callCenterMode.equals("2") || callCenterMode.equals("4"))) {%>Call Center Mode<%}%>" />
                                    <image id="outbound" style="height:35px;display: <%=!callCenterMode.isEmpty() && (callCenterMode.equals("3") || callCenterMode.equals("5") || callCenterMode.equals("6")) ? "" : "none"%> ;" src="images/icons/outBound.png" title="<%if (!callCenterMode.isEmpty() && (callCenterMode.equals("3") || callCenterMode.equals("5") || callCenterMode.equals("6"))) {%>Call Center Mode<%}%>" />
                                </a>
                            </div>
                            <div class="ahmed-gamal" style="width:60px; border:1px solid black; height:50px; padding: 2px 2px 2px 0px; " id="update">
                                <a href="#" onclick="">
                                    <image id="callDir" style="height:35px;display: <%=!callCenterMode.isEmpty() && (callCenterMode.equals("2") || callCenterMode.equals("3")) ? "" : "none"%> ;" src="images/dialogs/phone.png" title="<%if (!callCenterMode.isEmpty() && (callCenterMode.equals("2") || callCenterMode.equals("3"))) {%>Call Center Direction<%}%>" />
                                    <image id="meetDir" style="height:35px;display: <%=!callCenterMode.isEmpty() && (callCenterMode.equals("4") || callCenterMode.equals("5")) ? "" : "none"%> ;" src="images/dialogs/handshake.png" title="<%if (!callCenterMode.isEmpty() && (callCenterMode.equals("4") || callCenterMode.equals("5"))) {%>Call Center Direction<%}%>" />   
                                    <image id="interDir" style="height:35px;display: <%=!callCenterMode.isEmpty() && (callCenterMode.equals("6")) ? "" : "none"%> ;" src="images/dialogs/internet-icon.png" title="<%if (!callCenterMode.isEmpty() && (callCenterMode.equals("6"))) {%>Call Center Direction<%}%>" />   
                                </a>

                            </div>
                            <div class="ahmed-gamal" style="width:70px; border:1px solid black; height:50px; float:right; padding: 2px;" id="update">
                                <%if (securityUser.isCanRunAutoPilotMode()) {%>
                                <img width="70px"  height="50px"  src="images/icons/plane_icon.png" id="autoPilotIcon" style="border: none;display: <%=!autoPilotModeValue.equals("-1") ? "" : "none"%>" title="<%if (!autoPilotModeValue.equals("-1")) {%>Auto-Pilot Mode<%}%>"/>
                                <% } else {%>
                                <img width="70px"  height="50px"  src="images/icons/manual_pilot.png" id="autoPilotIcon" style="border: none;" title="Manual-Pilot Mode"/>
                                <%}%>
                                <br>
                            </div>
                        </td>
                    </tr>
                </table>
            </DIV> 

            <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">New Customer Registration</font>
                        </td>
                    </tr>
                </table>
                <% if (autoPilotMessage != null && autoPilotMessage.equalsIgnoreCase("ok")) {%>
                <br>
                <table align="<%=align%>" dir=<fmt:message key="direction"/> WIDTH="70%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="blue">Save Client Complete</font>
                        </td>
                    </tr>
                </table>
                <% } %>         
                <% if (errorExtConn != null && !errorExtConn.equals("") && errorExtConn.equals("1")) {%>
                <table dir=<fmt:message key="direction"/> align="<%=align%>">
                    <tr><td class="td">
                            <font size="4" color="red"> <%=msgErrorExtConn%> </font>
                        </td>
                    </tr> 
                </table>
                <% } %> 
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
                        $("#saveClient").css("display", "none");
                        $("#clientInfo").css("display", "block");
                        $("#submitBtn").css("display", "none");
                        $("#recordCall").css("display", "<%=issueId == null ? "inline-block" : "none"%>");
                        $("#seasonBtn").css("display", "<%=issueId != null ? "inline-block" : "none"%>");
                        $("#productsBtn").css("display", "<%=issueId != null ? "inline-block" : "none"%>");
                        $("#degreeBtn").css("display", "none");
                    });
                </script>
                <div id="caller_number" style="width: 50%;margin-left: auto;margin-right: auto;text-align: center;display: none;"></div>
                <br>
                <table id="clientInf"  align="<%=align%>" dir=<fmt:message key="direction"/> STYLE="border-right-WIDTH:1px;" CELLPADDING="0" CELLSPACING="0">
                    <tr>
                        <TD nowrap colspan="3" CLASS="silver_header" STYLE="text-align: center; border-width: 0px; white-space: nowrap;">
                            <font size=3 color="black"><%=sStatus%></font> 
                        </td>                    
                    </tr>
                    <tr id="callNumber" style="display: none;">
                        <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </TD>
                        <TD width="100" STYLE="<%=style%>;" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd" >
                            <b><font size="2" color="black"><%=call_number%></font></b>
                        </td>
                        <td width="200" style="border-right-width:0px;text-align: center;">
                            <b id="callNo"></b>
                        </td>
                    </tr>
                    <tr>
                        <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </TD>
                        <TD width="100" STYLE="<%=style%>; font-size: 12px; font-weight: bold" BGCOLOR="#DDDD00" nowrap  CLASS="silver_even" >
                            <b><font size="2" color="black"><fmt:message key="name"/></font></b>
                        </td>
                        <td width="200" style="border-right-width:0px;text-align: center;">
                            <b><font color="red" size="3"><%=clientWbo.getAttribute("code")%><!--/</font><font color="blue" size="3" ><%=clientWbo.getAttribute("clientNoByDate")%></font>--></b>
                        </td>
                    </tr>
                    <tr>
                        <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </TD>
                        <TD width="100" STYLE="<%=style%>; font-size: 12px; font-weight: bold" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd" >اسم العميل</td>
                        <td width="200" style="border-right-width:0px;text-align: center;background-color: #FFFF66;"><label class="show"><%=clientWbo.getAttribute("name")%></label>
                        </td>
                    <input type="hidden" id="clientId" name="clientId"  value="<%=clientWbo.getAttribute("id")%>"/>
                    </tr>
                    <%if (clientWbo.getAttribute("partner") == null) {
                        } else {%>
                    <tr>
                        <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </TD>
                        <TD width="100" STYLE="<%=style%>; font-size: 12px; font-weight: bold" BGCOLOR="#DDDD00" nowrap  CLASS="silver_even" >اسم العميل/الزوج</td>
                        <td width="200" style="border-right-width:0px;text-align: center;"><label><%=clientWbo.getAttribute("partner")%></label></td>
                    </tr>
                    <%}%>
                    <tr>
                        <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </TD>
                        <TD width="100" STYLE="<%=style%>; font-size: 12px; font-weight: bold" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd" >المهنة</td>
                        <td width="200" style="border-right-width:0px;text-align: center;background-color: #FFFF66;"><label><%=request.getAttribute("jobTitle")%></label></td>

                    </tr>
                    <%if (clientWbo.getAttribute("clientSsn") == null) {
                        } else {%>
                    <tr>
                        <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </TD>
                        <TD width="100" STYLE="<%=style%>; font-size: 12px; font-weight: bold" BGCOLOR="#DDDD00" nowrap  CLASS="silver_even" >الرقم القومى</td>
                        <td width="200" style="border-right-width:0px;text-align: center;"><label><%=clientWbo.getAttribute("clientSsn")%></label></td>
                    </tr>
                    <%}%>
                    <%if (clientWbo.getAttribute("phone").equals(" ")) {
                        } else {%>
                    <tr>
                        <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </TD>
                        <TD width="100" STYLE="<%=style%>; font-size: 12px; font-weight: bold" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd" >رقم التليفون</td>
                        <td width="200" style="border-right-width:0px;text-align: center;"><label><%=clientWbo.getAttribute("phone")%></label></td>
                    </tr>
                    <%}%>
                    <tr>
                        <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </TD>
                        <TD width="100" STYLE="<%=style%>; font-size: 12px; font-weight: bold font-size: 12px; font-weight: bold" BGCOLOR="#DDDD00" nowrap  CLASS="silver_even">رقم الموبايل</td>
                        <td width="200" style="border-right-width:0px;text-align: center;background-color: #FFFF66;"><label><%=clientWbo.getAttribute("mobile")%></label></td>
                    </tr>
                    <tr style="display: <%=issueId != null ? "" : "none"%>">
                        <td nowrap="" class="silver_header" style="border-width: 0px; white-space: nowrap;">
                            &nbsp;
                        </td>
                        <td width="100" style="text-align:Right;" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                            <b><font size="2" color="black"><%=call_number%></font></b>
                        </td>
                        <td width="200" style="border-right-width:0px;text-align: center;">
                            <b id="callNo"><font size="3" color="blue"><%=request.getAttribute("businessId")%></font></b>
                            <input type="hidden" id="businessId" value="<%=request.getAttribute("businessId")%>">
                        </td>
                    </tr>
                </table>
                <br>
                <%}
                } else if (status.equalsIgnoreCase("error")) {%>
                <table align="<%=align%>" dir=<fmt:message key="direction"/>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" >رقم العميل مسجل مسبقا</font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <% } else {%>
                <table align="<%=align%>" dir=<fmt:message key="direction"/>>
                    <tr>                    
                        <td class="td">
                            <font size=2 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>

                <%}
                    }
                %>

                <div id="salesUsers">
                </DIV>

                <table style="margin-bottom: 20px;background: #f9f9f9;display: block;" ALIGN="center"  dir=<fmt:message key="direction"/> border="0" width="100%" id="saveClient">
                    <tr>
                        <td style="width: 62.5%;border: 0px;margin-top: 0px;padding: 0px;">
                            <table style=" margin: 0px;">
                                <%
                                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                                            && connectByRealEstate.equals("0")) {

                                %>
                                <tr id="numberRow" class="numberRow">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">

                                        <LABEL FOR="supplierNO2">
                                            <p>
                                                <b style="color: #0000FF;">
                                                    <fmt:message key="number"/>
                                                </b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>"  class='TD' >
                                        <!--onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''"-->
                                        <input  type="TEXT" style="width:40%;" name="clientNO" ID="clientNO" size="33"  maxlength="10" class="clientNumber" onkeyup="checkNumber(this)"autocomplete="off"  onkeypress="javascript:return isNumber(event)" disabled="true" hidden="true" > 
                                        <input  type="checkbox" name="" id="" onclick="javascript: disableClientNO(this);" checked="checked" disabled="true">
                                        <input  type="checkbox" name="automatedClientNo" id="automatedClientNo"  checked="checked" hidden="true" />
                                        <input type="hidden" name="saveInRealState" id="saveInRealState" value="false" />
                                        <font size="3" color="#005599"><b><%=automated%></b></font>
                                        <div id="warning"style="margin-right: 25px;display: none;width: 16px;height: 16px; background-image: url(images/warning.png);background-repeat: no-repeat;"></DIV>
                                        <div id="ok"style="margin-right: 25px;display: none;width: 16px;height: 16px; background-image: url(images/ok2.png);background-repeat: no-repeat;"></DIV>
                                        <LABEL id="MSG" ></LABEL>
                                        <p id="numberMsg"></p>
                                    </td>
                                </tr>
                                <%} else {%>
                                <tr id="numberRow" class="">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">

                                        <LABEL FOR="supplierNO2">
                                            <p><b style="color: #0000FF;"><fmt:message key="number"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>"  class='TD' >
                                        <%if (clientWbo != null) {

                                        %>
                                        <input  type="TEXT" style="width:40%;" name="clientNO" value="<%=clientWbo.getAttribute("clientNO")%>" ID="clientNO" size="33"  maxlength="10" class="clientNumber" autocomplete="off"  onkeypress="javascript:return isNumber(event)" > 
                                        <input  type="checkbox" name="automatedClientNo" id="automatedClientNo" onclick="javascript: disableClientNO(this);" onkeyup="checkClientNo(this)" onmousedown="checkClientNo(this)" >
                                        <%} else {%>
                                        <input  type="TEXT" style="width:40%;" name="clientNO" ID="clientNO" size="33"  maxlength="10" class="clientNumber" autocomplete="off"  onkeypress="javascript:return isNumber(event)" disabled="true"> 
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
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="clientName" >
                                            <p><b style=""><fmt:message key="name"/> <font style="color: red;">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>

                                    <td style="<%=style%>"class='td'>

                                        <input  type="text" id="clientName" name="clientName" placeholder=<fmt:message key="name"/>

                                               <LABEL id="nameMSG" style="display: inline"></LABEL>

                                        <LABEL id="naMsg" style="display: inline"></LABEL>
                                        <a id="existnameClient" class="linkbtn" style="display: none" href="#">exist</a>
                                        
                                        <input type="text"  id="job" name="job" placeholder="Job" />

                                        <%-- <SELECT name="job" id="job" style="text-align:center;font-size: 13px;font-weight: bold; display: inline;">

                                            <%  if (jobs != null && !jobs.isEmpty()) {%>

                                            <OPTION value="000"> ---<fmt:message key="career"/>--</OPTION>
                                                <%

                                                    for (WebBusinessObject wbo2 : jobs) {%>
                                             <!--<input type="hidden" name="jod" id="jobCode" value="<%=wbo2.getAttribute("tradeId")%>" />-->
                                            <OPTION value="<%=wbo2.getAttribute("tradeId")%>"><%=wbo2.getAttribute("tradeName")%></OPTION>

                                            <%
                                                    }

                                                }
                                            %>
                                        </SELECT>--%> 
                                        <input type="button" class="btn-gemy" value="<fmt:message key="addjob"/>" id="insertJob" onclick="popup(this)" style="display: inline; display: <%=userPrevList.contains("ADD_CAREER") ? "" : "none"%>;"/>

                                    </td>
                                </tr>
                                
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="gender" >
                                            <p><b><fmt:message key="gender"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <span><input type="radio" name="gender" value="ذكر" id="gender"  checked="true"
                                                     />  <font size="3" color="#005599"><b><fmt:message key="male"/></b></font></span>
                                        <span><input type="radio" name="gender" value="أنثى" id="gender" 
                                                     />  <font size="3" color="#005599"><b><fmt:message key="female"/></b></font></span>
                                    </td>

                                </tr>
                                
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="nationality">
                                            <p><b><fmt:message key="nationality"/><font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <SELECT name="nationality" id="nationality" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">
                                            <OPTION value="000"> ---<fmt:message key="choose"/>---</OPTION>
                                            <OPTION value="مصري"><fmt:message key="egy"/></OPTION>
                                            <OPTION value="سعودي"><fmt:message key="saudi"/></OPTION>
                                            <OPTION value="أمريكي"><fmt:message key="american"/></OPTION>
                                            <OPTION value="بولندي"><fmt:message key="polish"/></OPTION>
                                        </SELECT>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td  style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">

                                        <LABEL>
                                            <p><b style=""><fmt:message key="Mobile"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>" class='td'>
                                        <input onchange="javascript:mobileChange(this.value)" id="mobileNation0" name="mobileNation" title="Mobile" value="0" checked type="radio"/><font size="3"  color="#005599"> <b><fmt:message key='localMobile' /></b></font>
                                        <input onchange="javascript:mobileChange(this.value)" id="mobileNation1" name="mobileNation" title="Inter-Mobile" value="1" type="radio"/><font size="3"  color="#005599"> <b><fmt:message key='interMobile' /></b></font>
                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <!--    client mobile number Instead of fax -->
                                        <LABEL FOR="clientMobile">
                                            <p><b style=""><fmt:message key="mobile"/> <font style="color: red;">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                            <input type="TEXT" name="clientMobile" ID="clientMobile" size="11" maxlength="11"  onkeyup="checkMobile(this)" onmouseout="javascript:return checkClientMobile(this)" onkeypress="JavaScript: return isNumber(event, this)"
                                               <%
                                                   if (clientWbo != null) {
                                                       if (clientWbo.getAttribute("clientMobile") != null) {%>  value="<%=clientWbo.getAttribute("clientMobile")%>" <%} else {%>
                                               value=""
                                               <%}
                                                   }
                                               %>

                                               maxlength="11" >  
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
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL for="interPhone">
                                            <p><b style=""><%=interPhone%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>

                                        <input type="text"  name="interPhone" ID="interPhone" size="16" maxlength="16" onkeyup="javascript:return checkClientInterPhone(this)" onmouseout="checkClientInterPhone(this)" onkeypress="JavaScript: return isNumber(event, this)" 
                                               value="<%=clientWbo != null && clientWbo.getAttribute("interPhone") != null ? clientWbo.getAttribute("interPhone") : ""%>" />

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
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag"  width="35%">
                                        <LABEL FOR="phone">
                                            <p><b>Whatsapp Phone</b>&nbsp;
                                        </LABEL>                                    </td>
                                    <td  style="<%=style%>" class='td'>
                                        <input type="TEXT" name="phone" ID="phone" size="11" maxlength="11" onkeyup="checkTel(this)" onmouseout="checkClientPhone(this)" onkeypress="JavaScript: return isNumber(event, this)"
                                               <%
                                                   if (clientWbo != null) {
                                                       if (clientWbo.getAttribute("phone") != null) {%>  value="<%=clientWbo.getAttribute("phone")%>" <%} else {%>
                                               value=""
                                               <%}
                                                   }
                                               %>
                                               maxlength="10" onkeyup="checkClientPhone(this)">  
                                        <input type="hidden"  name="localP" ID="localP" maxlength="3" size="5" onkeypress="JavaScript: return isNumber(event, this)" onkeyup="checkClientPhone(this)">
                                        <input type="hidden"  name="internationalP" ID="internationalP" maxlength="3" size="5" onkeypress="JavaScript: return isNumber(event, this)"onkeyup="checkClientPhone(this)" >  
                                        <div id="telWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                            <IMG src="" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                                        </DIV>
                                        <div id="telOk"style="display: none;width: 20px;height: 20px;border: none;">
                                            <IMG src="" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                                        </DIV>
                                        <LABEL id="telMSG" ></LABEL>
                                          <a id="existphoneClient" class="linkbtn" style="display: none" href="#">exist</a>

                                      
                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL>
                                            <p><b style=""><fmt:message key="knowus"/> <font style="color: red;">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>;" class='td'>
                                         <select name="dialedNumber" id="dialedNumber" onchange="showHideRows(this.value);" style="font-weight: bold; font-size: 16px; width: 170px; direction: rtl;">
                                            <option value=""><fmt:message key="select" /></option>
                                            <%
                                                for (WebBusinessObject seasonWbo : seasonsList) {
                                            %>
                                            <option value="<%=seasonWbo.getAttribute("id")%>"><%=seasonWbo.getAttribute("arabicName")%></option>
                                            <%
                                                }
                                            %>

                                        </select>
                                        <input type="button" class="btn-gemy" style="display: <%=userPrevList.contains("ADD_METHOD") ? "" : "none"%>;" onclick="JavaScript: popupSeason();" value="<fmt:message key="add" />">
                                    </td>
                                </tr>
                                

                                <tr style="">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="clientName" >
                                            <p><b style=""><%=birthDate%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td class="td" dir="ltr" style="<%=style%>">
                                        <input style=" width: 80px;" type="text" dir="LTR" name="birthDate" ID="birthDate" size="32" value="<%=nowDate%>" readonly />
                                    </td>
                                </tr>
                                <tr class="conditionalRow">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="clientName" id="message">
                                            <p><b><fmt:message key="wifehusband"/><font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <input type="TEXT" style="width:230px;" name="partner" ID="partner" size="33"  
                                               <%
                                                   if (clientWbo != null) {
                                                       if (clientWbo.getAttribute("partner") != null) {%>  value="<%=clientWbo.getAttribute("partner")%>" <%} else {%>
                                               value=""
                                               <%}
                                                   }
                                               %>
                                               maxlength="255">
                                    </td>
                                </tr>
                                <tr class="conditionalRow">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="matiralStatus" >
                                            <p><b><fmt:message key="phone"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" name="matiralStatus" ID="matiralStatus" size="10" maxlength="11" onkeyup="checkTel(this)" onmouseout="checkClientPhone(this)" onkeypress="JavaScript: return isNumber(event, this)"


                                    </td>
                                </tr>
                                <tr>
                                    <!--                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                                                            <LABEL FOR="job">
                                                                                <p><b>المهنة<font color="#FF0000"></font></b>&nbsp;
                                                                            </LABEL>
                                                                        </td>
                                                                        <td style="<%=style%>"class='td'>
                                                                            <SELECT name="job" id="job" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">
                                    <%  if (jobs != null && !jobs.isEmpty()) {%>

                                    <OPTION value="000"> ---إختر---</OPTION>
                                    <%

                                        for (WebBusinessObject wbo2 : jobs) {%>
                                 <input type="hidden" name="jod" id="jobCode" value="<%=wbo2.getAttribute("tradeId")%>" />
                                <OPTION value="<%=wbo2.getAttribute("tradeId")%>"><%=wbo2.getAttribute("tradeName")%></OPTION>

                                    <%
                                            }

                                        }
                                    %>
                                </SELECT>
                                <input type="button" value="إضافة مهنة" id="insertJob" onclick="popup(this)"/>

                            </td>-->
                                </tr>

                                

                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="matiralStatus" >
                                            <p><b><fmt:message key="branch"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <%
                                            for (int i = 0; i < userProjects.size(); i++) {

                                                WebBusinessObject obj = (WebBusinessObject) userProjects.get(i);
                                        %>

                                        <div><span><input type="radio" name="clientBranch" value="<%=obj.getAttribute("projectID")%>" id="clientBranch" checked="true" />
                                                <font size="4" color="#005599"><b><%=obj.getAttribute("projectName")%></b></font></span></div> 
                                                    <%}%>
                                        <div><span><input type="radio" name="clientBranch" value="UL" id="clientBranch"  />
                                                <font size="4" color="#005599"><b><fmt:message key="unspecified"/> </b></font></span></div> 
                                    </td>
                                </tr>

                                <tr style="display: none;">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="clientSsn" >
                                            <p><b><%=client_ssn%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>

                                        <input type="hidden" style="width:120px" name="clientSsn" id="clientSsn" size="14" 
                                               <%
                                                   if (clientWbo != null) {
                                                       if (clientWbo.getAttribute("clientSsn") != null) {%>  value="<%=clientWbo.getAttribute("clientSsn")%>" <%} else {%>
                                               value=""
                                               <%}
                                                   }
                                               %>
                                               maxlength="14" onkeyup="checkSsn(this)" onmousedown="checkSsn(this)" onkeypress="javascript:return isNumber(event)">
                                        <p id="ssnMsg"></P>
                                    </td>
                                </tr>
                                <%--
                                    <tr>
                                            <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                              <LABEL FOR="clientSsn" >
                                            <p><b>المنتجات</b>&nbsp;
                                        </LABEL>      
                                        </td>
                                                <td style="border-width: 0px;text-align: right">
                                                    <select id="productSelect" name="productSelect" size="5" multiple style="width:230px; font-weight: bold; font-size: 13px" onchange="addTasks(this)">
                                        
                                                        <%
                                                for (int x = 0; x < mainProducts.size(); x++) {
                                                    mainProjectWbo = (WebBusinessObject) mainProducts.get(x);
                                                    mainProductId = (String) mainProjectWbo.getAttribute("projectID");
                                                    mainProductName = (String) mainProjectWbo.getAttribute("projectName");

                                            %>
                                            <option id="projectName<%=x%>" value=<%=mainProductId%> <%if(mainProductId.equals(session.getAttribute("product"))){%> selected="true" <%}%> ><%=mainProductName%></option> 
                                            
                                            <%}%>
                                        <input type="hidden" id="productName" name="productName" value="">
                                        <input type="hidden" id="mainProject" name="mainProject" value="<%=mainProductId%>">
                                        <input type="hidden" id="parentProductName" name="parentProductName" value="<%=mainProductName%>">
                                        <input type="hidden" id="parentProductId" name="parentProductId" value="<%=mainProductId%>">
                                        </select>       
                                        </td>
                                </tr>
                                --%>
                            </table>
                        </td>
                        <td style="border: 0px;">
                            <TABLE id="clientexistmsg" style="display: none">

                                <TR>  <TD style="border: none">
                                        <a id="existClient" class="linkbtn" style="display: block" href="#">View Client</a>
                                    </TD>
                                    <TD style="border: none; padding-left: 10px">
                                        <LABEL id="erromsg" style="color: red; font-size: 15px; text-decoration: bold"><B>هذا العميل موجود</B></LABEL>
                                    </TD> 
                                </TR>

                            </TABLE>
                            <br/>
                            <br/>
                            <br/>
                            <br/>
                            <table style="margin-top: 0px;">
                                <%--
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL>
                                            <p><b>المنتجات</b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="border-width: 0px">
                                        <select id="productSelect" name="productSelect" size="5" multiple style="width:230px; font-weight: bold; font-size: 13px">
                                            <%
                                                for (int x = 0; x < mainProducts.size(); x++) {
                                                    mainProjectWbo = (WebBusinessObject) mainProducts.get(x);
                                                    mainProductId = (String) mainProjectWbo.getAttribute("projectID");
                                                    mainProductName = (String) mainProjectWbo.getAttribute("projectName");

                                            %>
                                            <option id="projectName<%=x%>" value=<%=mainProductId%> <%if(mainProductId.equals(session.getAttribute("product"))){%> selected="true" <%}%> ><%=mainProductName%></option> 
                                            <%}%>
                                        </select>       
                                    </td>         
                                </tr>
                                --%>
                                <tr >
                                    <!--                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                                                            <LABEL FOR="clientSalary" >
                                                                                <p><b><%=client_total_salary%></b>&nbsp;
                                                                            </LABEL>
                                                                        </td>
                                                                        <td style="<%=style%>" class='td'>
                                                                            <input type="TEXT" style="width:70px" name="clientSalary" ID="total_salary" size="7" 
                                    <%
                                        if (clientWbo != null) {
                                            if (clientWbo.getAttribute("clientSalary") != null) {%>  value="<%=clientWbo.getAttribute("clientSalary")%>" <%} else {%>
                                    value=""
                                    <%}
                                        }
                                    %>
                                    maxlength="7" onkeyup="checkSalary(this)" onmousedown="checkSalary(this)" onkeypress="javascript:return isNumber(event)">
                             <p id="salaryMsg"></p>
                         </td>-->
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="address">
                                            <p><b><fmt:message key="address"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <!--<textarea style="width:230px;" rows="3" ID="address" name="address"-->
                                        <%
                                            if (clientWbo != null) {
                                                if (clientWbo.getAttribute("address") != null) {%> 
                                        <textarea style="width:230px;" rows="3" ID="address" name="address">
                                            <%=clientWbo.getAttribute("address")%></TEXTAREA><%} else {%>
                                                
                                        <%}
                                        } else {
                                        %><textarea style="width:230px;" rows="3" ID="address" name="address"></TEXTAREA><%}%>
                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="email">
                                            <p><b><fmt:message key="mail"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:230px" name="email" ID="email" size="33" 
                                               <%
                                                   if (clientWbo != null) {
                                                       if (clientWbo.getAttribute("email") != null) {%>  value="<%=clientWbo.getAttribute("email")%>" <%} else {%>
                                               value=""
                                               <%}
                                                   }
                                               %>
                                               maxlength="255" onkeyup="checkMail(this.value)" onmouseout="javascript:return checkClientEmail(this)"><br/>
                                          <div id="mailWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                            <IMG src="" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                                        </DIV>
                                        <div id="mailOk"style="display: none;width: 20px;height: 20px;border: none;">
                                            <IMG src="" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                                        </DIV>
                                        <p id="mailMsg" ></p>
                                        <input type="hidden" name="age" value="30-40" id="age" />
                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="email">
                                            <p><b>National ID</b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:230px" name="passport" ID="passport" size="33" value="" /><br/>
                                    </td>
                                </tr>
                                <!--tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="workOut" >
                                            <p><b><1fmt:message key="workabroad"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="1<%=style%>" class='td'>
                                        <span><input type="radio" name="workOut" value="1" id="workOut" />  <font size="3" color="#005599"><b><fmt:message key="yes"/></b></font></span>
                                        <span><input type="radio" name="workOut" value="0" id="workOut" checked="true"/>  <font size="3" color="#005599"><b><fmt:message key="no"/></b></font></span>
                                    </td>
                                </tr-->
                                <!--tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="kindred" >
                                            <p><b><1fmt:message key="isrelativabroad"/></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="1<%=style%>" class='td'>
                                        <span><input type="radio" name="kindred" value="1" id="kindred"/>  <font size="3" color="#005599"><b><fmt:message key="yes"/></b></font></span>
                                        <span><input type="radio" name="kindred" value="0" id="kindred"  checked="true"/>  <font size="3" color="#005599"><b><fmt:message key="no"/></b></font></span>
                                    </td>
                                </tr-->
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <label for="description" >
                                            <p><b><fmt:message key="notes"/></b>&nbsp;
                                        </label>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <textarea id="description" name="description" cols="26" rows="10"></textarea>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>




                </table>
                <TABLE style="width: 100%">

                    <tr class="campaignRow">
                        <td   style="width: 20%; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                            <LABEL FOR="matiralStatus" >
                                <p><b><fmt:message key="campgin"/></b>&nbsp;
                            </LABEL>
                            <br/>
                        </td>     
                        <td  style="width: 70%; padding: 5px" >
                            <select name="campaignsselect" id="campaignsselect" style="width: 100%;" multiple="multiple" class="chosen-select-campaign"  data-rel="chosen">
                                <%
                                    for (WebBusinessObject campaignWbo : campaignsList) {
                                %>
                                <option value="<%=campaignWbo.getAttribute("id")%>"><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </Td>
                    </tr>
                    <tr class="conditionalRow">
                        <td   style="width: 20%; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                            <LABEL FOR="matiralStatus" >
                                <p><b>Broker</b>&nbsp;
                            </LABEL>
                            <br/>
                        </td>     
                        <td  style="width: 70%; padding: 5px" >
                            <select name="campaignsselect" id="campaignsselect" style="width: 100%;" multiple="multiple" class="chosen-select-campaign"  data-rel="chosen">
                                <%
                                    for (WebBusinessObject brokerWbo : brokerList) {
                                %>
                                <option value="<%=brokerWbo.getAttribute("id")%>"><%=brokerWbo.getAttribute("campaignTitle")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </Td>
                    </tr>
                </TABLE>
                <TABLE style="width: 100%">

                    <tr>
                        <td   style="width: 20%; text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                            <LABEL FOR="matiralStatus" >
                                <p><b>Source</b>&nbsp;
                            </LABEL>
                            <br/>
                        </td>     
                        <td  style="width: 70%; padding: 5px" >
                            <select name="sourceClient" id="sourceClient" style="width: 100%;" multiple="multiple" class="chosen-select-campaign"  data-rel="chosen">
                                <%
                                    for (WebBusinessObject sourceWbo : sourceList) {
                                %>
                                <option value="<%=sourceWbo.getAttribute("sourceID")%>"><%=sourceWbo.getAttribute("englishname")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </Td>
                    </tr>
                </TABLE>
                            <button  onclick="JavaScript:cancelForm();" class="button2" style="margin-right: 2px;"><%=back%></button>
                            <button  type="button" onclick="submitForm()" id='submitBtn' class="button2" value="" style="display: inline-block;"/><%=regist%></button>
                            
                            <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px; padding-top: 50px;">
                    <%if (privilegesList.contains("CLIENT_PROJ_TBLE")) {%>
                    <TABLE class="projectsTbl">
                        <THEAD>
                            <tr>
                                <th ><fmt:message key="projects"/></th>
                                <th style="direction: <fmt:message key="direction"/>"><fmt:message key="within"/></th>
                                <th><fmt:message key="payment"/></th>
                                <th><fmt:message key="area"/></th>
                            </tr>
                        </THEAD>
                        <tbody>
                            <%for (int x = 0; x < mainProducts.size(); x++) {
                                    mainProjectWbo = (WebBusinessObject) mainProducts.get(x);
                                    mainProductId = (String) mainProjectWbo.getAttribute("projectID");
                                    mainProductName = (String) mainProjectWbo.getAttribute("projectName");
                            %>     
                            <tr>
                                <td>
                                    <div style="text-align: center; direction: <fmt:message key="direction"/>">
                                        <input type="checkbox" id="productChecked" name="productChecked<%=x%>" <%=mainProductId.equals(securityUser.getDefaultProduct()) ? "checked" : ""%>><%=mainProductName%> 
                                        <input type="hidden" id="mainProductId<%=x%>" name="mainProductId<%=x%>" value=<%=mainProductId%> >
                                    </div>    
                                </td>
                                <td>
                                    <select name="roomsCount<%=x%>" id="roomsCount<%=x%>">
                                        <% for (int i = 1; i < 6; i++) {%>
                                        <OPTION value="<%=i%>"><%=i%></OPTION>
                                            <%}%>
                                    </select>
                                </td>
                                <td>
                                    <select name="paymentType<%=x%>" id="paymentType<%=x%>">
                                        <option value="نقدى"><fmt:message key="cash"/></option>
                                        <option value="تقسيط"><fmt:message key="installment"/></option> 
                                    </select>
                                </td>
                                <td>
                                    <select id="width<%=x%>" name="width<%=x%>" style="width:30%">
                                        <% ArrayList<WebBusinessObject> areas = (ArrayList<WebBusinessObject>) request.getAttribute(mainProductId);
                                            for (WebBusinessObject areaWbo : areas) {
                                        %>

                                        <option value="<%=areaWbo.getAttribute("area")%>"><%=areaWbo.getAttribute("area")%></OPTION>
                                            <%}%>
                                    </select>
                                </td>
                            </tr>
                            <%}%>


                        </tbody>
                    </TABLE>
                    <%}%>

                </DIV>
                <div id="jobForm"  style="width: 30%;height: 200px;display: block;position: fixed;">
                    <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
                        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
                    </div>
                    <div class="login" style="width: 86%;margin-bottom: 10px;margin-left: auto;margin-right: auto">
                        <table class="" style="width:100%;text-align: right;border: none;" class="table" >
                            <tr align="center" align="center">
                                <td colspan="2" style="font-size:14px;border: none;">
                                    <b style="color: #f9f9f9;font-size: 14px;"id="msg"></b></td>
                            </tr>

                            <tr >
                                <td  ALIGN="<%=align%>" style="border: none;"><%=arName%></td>
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
                                <td ALIGN="<%=align%>" style="border: none"><fmt:message key="city"/></td>
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
                                    <input style="margin-top: 5px;"type="button" value="<fmt:message key="add" />" onclick="addSeason()" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <br>
                <div id="viewEmployeeLoads" style="width: auto; height: auto; margin: 0 auto; display: none">
                    <input  name="view_employee_loads" type="button" onclick="javascript:runEffect();" id ="view_employee_loads"class="view_employee_loads"/>
                </div>
                <fieldset id="effect" class="set" style="border-color: #006699; width: 95%;margin-top: 20px;border-radius: 5px; display: block">
                    <img src="images/stat.png" width="40"/>
                    <div id="container" style="width: 100%; height: 50%; margin: 0 auto"></div>
                    <br/>
                </fieldset>
                <br>
            </fieldset>
        </FORM> 

        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
function selectOption() {
  var inputElement = document.getElementById("clientMobile");
  var inputVal = inputElement.value;
  
  var selectElement = document.getElementById("countryCode");
  var options = selectElement.options;
  
  for (var i = 0; i < options.length; i++) {
    if (options[i].value === inputVal) {
      selectElement.selectedIndex = i;
      break;
    }
  }
}

function showInput() {
      var selectedOption = document.getElementById("dialedNumber").value;
      var row = document.getElementById("myRow");
      var row2 = document.getElementById("myRow2");
      
      if (selectedOption === "1") {
       row.style.display = "table-row";
       row2.style.display = "table-row";
      } else if (selectedOption === "3"){
       row.style.display = "table-row";
       row2.style.display = "table-row";
      } else {
        row.style.display = "none";
        row2.style.display = "none";
      }
    }


        </script>
<script type="text/javascript">
    function showHideRows(selectedValue) {
    // لو القيمة المختارة هي "3" يعني غير مباشر
    var isGhairMobasherSelected = selectedValue === "3";
    
    // حدد الصفوف اللي بتتعامل معاها
    var campaignRow = document.querySelector('.campaignRow');
    var elementsToShowOrHide = document.querySelectorAll('.conditionalRow');
    
    // لو القيمة "غير مباشر" => اخفي campaignRow واظهر الباقي
    if (isGhairMobasherSelected) {
        if (campaignRow) campaignRow.style.display = 'none';
        elementsToShowOrHide.forEach(function(element) {
            element.style.display = ''; // show
        });
    } else {
        // لو القيمة مختلفة => اظهر campaignRow واخفِ العناصر الشرطية
        if (campaignRow) campaignRow.style.display = '';
        elementsToShowOrHide.forEach(function(element) {
            element.style.display = 'none';
        });
    }
}


    // Call the function on page load to ensure correct initial state
    window.onload = function() {
        showHideRows(document.getElementById('dialedNumber').value);
    };
</script>
    </BODY>
</HTML>