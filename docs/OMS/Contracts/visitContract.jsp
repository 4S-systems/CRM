<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.businessfw.hrs.db_access.EmployeeMgr"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    ArrayList<WebBusinessObject> clients = (ArrayList<WebBusinessObject>) request.getAttribute("clients");
    ArrayList<LiteWebBusinessObject> employees = (ArrayList<LiteWebBusinessObject>) request.getAttribute("employees");
    ArrayList<WebBusinessObject> workTypes = (ArrayList<WebBusinessObject>) request.getAttribute("workTypes");

    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, contractNumber, contractSupervisor, contractPeriod, from, tto, contactValue, note, uploadDocument, paymentType, cash, installment,
            newContract, save, clientName, addEmployee, contractName, contractRegistrationDate, day, week, month, year, visitCount, visitPrice, contractDetailes, contractCalcPeriod,
            auto, contractValue, contractItems, contractPeriodData, workType;
    String lang, langCode, align, dir, alignX;
    String employeeNo, employeeName, employeeRole, otherReq;

    String parentCategory = "";

    //Contract Dates
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    java.util.Date today = Calendar.getInstance().getTime();
    String beginInterval = sdf.format(today);
    String endInterval = sdf.format(today);
    if (stat.equals("En")) {
        dir = "LTR";
        align = "left";
        alignX = "right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        title = "New Visit Contract";
        contractNumber = "Contract Number";
        clientName = "Client Name";
        contractSupervisor = "Contract Supervisor";
        contractPeriod = "Contract Start Date";
        from = "from";
        tto = "to";
        contactValue = "Contract Value";
        note = "Notes";
        uploadDocument = "Upload Document";
        newContract = "New Contract";
        save = "Save";
        cash = "Cash";
        installment = "Installment";
        paymentType = "Payment Type";
        addEmployee = "Add Supervisor";
        employeeNo = "Supervisor No.";
        employeeName = "Name";
        employeeRole = "Role";
        contractName = "Contract Title";
        contractRegistrationDate = "Registration Date";
        day = "Day";
        week = "Week";
        month = "Month";
        year = "Year";
        visitCount = "Visit Number";
        visitPrice = "Visit Price";
        contractDetailes = "Contract Basic Inofrmation";
        contractCalcPeriod = "Contact Period";
        auto = "Auto";
        contractValue = "Contract Value";
        contractItems = "Contract Items";
        contractPeriodData = "Contract Period";
        workType = "Work Type";
        otherReq = "Other Requirments";
    } else {
        align = "right";
        alignX = "left";
        dir = "RTL";
        lang = "English";
        langCode = "En";
        title = "عقد زيارة جديد";
        contractNumber = "رقم العقد";
        clientName = "اسم العميل";
        contractSupervisor = "المشرف على العقد";
        contractPeriod = "بداية التعاقد";
        from = "من";
        tto = "إلى";
        contactValue = "قيمة التعاقد ";
        note = "ملاحظات";
        uploadDocument = "أرفاق مستند";
        newContract = "عقد جديد...";
        save = "حفــــــــظ";
        cash = "نقدا";
        installment = "تقسيط";
        paymentType = "طريقة الدفع";
        addEmployee = "أضافة مشرف";
        employeeNo = "رقم المشرف";
        employeeName = "الاسم";
        employeeRole = "الوظيفة";
        contractName = "عنوان العقد";
        contractRegistrationDate = "تاريخ تسجيل العقد";
        day = "يوم";
        week = "اسبوع";
        month = "شهر";
        year = "سنة";
        visitCount = "عدد الزيارات";
        visitPrice = "سعر الزيارة";
        contractDetailes = "بيانات العقد الاساسية";
        contractCalcPeriod = "مدة التعاقد";
        auto = "تلقائي";
        contractValue = "قيمة التعاقد";
        contractItems = "بنود التعاقد";
        contractPeriodData = "مدة التعاقد";
        workType = "نوع المكافحة";
        otherReq = "متطلبات أخرى";
    }
%>
<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">

    <head>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

        <style>
            #tabs li{
                display: inline;
            }
            #tabs li a{

                text-align:center;
                font:bold 15px;
                display:inline;
                text-decoration:none;
                padding-right:20px;
                padding-left:20px;
                padding-bottom:0;
                margin:0px;
                font-size: 15px;
                background-image:url(images/buttonbg.jpg);       
                background-repeat: repeat-x;
                background-position: bottom;
                color:#069;
                border-top-left-radius: 10px;
                border-top-right-radius: 10px;
            }
            #tabs li a:hover{
                background-color:#FFF;
                color:#069; 
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

            hr { 
                display: block;
                margin-top: 0.5em;
                margin-bottom: 0.5em;
                margin-left: auto;
                margin-right: auto;
                border-style: inset;
                border-width: 1px;
            }
        </style>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function () {
                $("#beginInterval, #endInterval").datepicker({
                    dateFormat: "yy/mm/dd"
                });
            });

            function getBrandByMainType(obj) {
                var mainCategoryType = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/EquipmentServletTwo?op=getCategoryList",
                    data: {
                        mainCategoryType: mainCategoryType
                    },
                    success: function (jsonString) {
                        try {
                            var output = [];
                            var parentCategory = $("#parentCategory");
                            $(parentCategory).html("");
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option value="' + item.id + '">' + item.unitName + '</option>');
                            }
                            output.push('<option value= 0">' + "---" + '</option>');
                            parentCategory.html(output.join(''));
                        } catch (err) {
                        }
                    }
                });
            }

            function saveContract() {
                var formData = new FormData($("#EQUIPMENT_FORM")[0]);
                $("#message").html("");
                var client = $("[name=client]").val();
                var contractNo = $("[name=contractNo]").val();
                var beginInterval = $("[name=beginInterval]").val();
                var endInterval = $("[name=contractEndDate]").val();
                var contractValue = $("[name=contractValue]").val();
                var paymentType = $("[name=paymentType]").val();
                var begin = new Date(beginInterval);
                var end = new Date(endInterval);
                var visitNo = $("#visitNo").val();
                var visitPrice = $("#visitPrice").val();

                if (!$("#automatedContractID").is(':checked') && contractNo === '') {
                    $("#message").html("أدخل رقم العقد");
                    $("#contractNo").focus();
                } else if (client === null) {
                    $("#message").html("أختر العميل");
                    $("#client").focus();
                } else if (contractValue === '') {
                    $("#message").html("أدخل قيمة التعاقد");
                    $("#contractValue").focus();
                } else if (!$.isNumeric(contractValue)) {
                    $("#message").html("قيمة التعاقد يجب أن تكون عددية");
                    $("#contractValue").focus();
                } else if (parseInt(contractValue) <= 0) {
                    $("#message").html("قيمة التعاقد غير صحيحة");
                    $("#contractValue").focus();
                } else if (paymentType === null) {
                    $("#message").html("أختر طريقة الدفع");
                } else if (!visitNo) {
                    $("#message").html("أدخل عدد الزيارات");
                    $("#visitNo").focus();
                } else if (!visitPrice) {
                    $("#message").html("أدخل سعر الزيارة");
                    $("#visitPrice").focus();
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ContractsServlet?op=saveVisitContract",
                        data: formData,
                        mimeType: "multipart/form-data",
                        contentType: false,
                        cache: false,
                        processData: false,
                        success: function (jsonString) {
                            try {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'ok') {
                                    $("#contractId").val(info.contractId);
                                    $("#btnSave").css("display", "none");
                                    $("#message").html("تم تسجيل العقد برقم " + info.contractNo + "<a href='<%=context%>/ContractsServlet?op=ViewContractDetails&contractId=" + info.contractId + "'><img src='images/icons/view.png' style='height: 30px;'/></a>");
                                    //showDetails();
                                } else if (info.status == 'duplicated') {
                                    $("#message").html("رقم العقد موجود من قبل");
                                } else {
                                    $("#message").html("لم يتم الحفظ");
                                }
                            } catch (err) {
                            }
                        },
                        error: function (jsonString) {
                            $("#message").html("لم يتم الحفظ");
                        }
                    });
                }
            }

            function saveContractDetails(rowId) {
                $("#message2").html("");
                var contractId = $("[name=contractId]").val();
                var mainTypeId = $("#mainTypeId" + rowId).val();
                var modelId = $("#modelId" + rowId).val();
                var minQuant = $("#minQuant" + rowId).val();
                var maxQuant = $("#maxQuant" + rowId).val();
                if (minQuant === '') {
                    minQuant = 0;
                }

                if (contractId === '') {
                    $("#message2").html("ادخل العقد اولا");
                } else if (mainTypeId === null) {
                    $("#message2").html("اختر النوع الرئيسى");
                } else if (maxQuant === '') {
                    $("#message2").html("ادخل الحد الاقصى");
                } else if (parseInt(minQuant) > parseInt(maxQuant)) {
                    $("#message2").html("يجب ان يكون الحد الاقص اكبر من الحد الادنى");
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ContractsServlet?op=saveContractDetails",
                        data: {
                            contractId: contractId,
                            mainTypeId: mainTypeId,
                            modelId: modelId,
                            minQuant: minQuant,
                            maxQuant: maxQuant
                        },
                        success: function (jsonString) {
                            try {
                                var info = $.parseJSON(jsonString);
                                if (info.status === 'ok') {
                                    $("#accept" + rowId).fadeOut(1000, function () {
                                        this.css("display", "none");
                                    });
                                    $("#" + rowId).fadeOut(1000, function () {
                                        this.css("display", "none");
                                    });
                                }
                            } catch (err) {
                            }
                        }
                    });
                }
            }

            function addContractRecord() {
                var trHTML = '';
                var rowCount = document.getElementById("equipments").rows.length;

                trHTML += '<tr id="row' + rowCount + '">\n\
                                <td STYLE="text-align:center;font-size:14px;ont-weight: bold; height: 25px; width:5px">' + rowCount + '</td>\n\
                                <td STYLE="text-align:center;font-size:14px;ont-weight: bold; height: 25px; width:25px">' + $("#mainCategoryType option:selected").text() +
                        '<input type="hidden" id="mainTypeId' + rowCount + '" name="mainTypeId" value="' + $("#mainCategoryType option:selected").val() + '"/>\n\
                                </td>\n\
                                <td STYLE="text-align:center;font-size:14px;ont-weight: bold; height: 25px; width:25px">' + $("#parentCategory option:selected").text() +
                        '<input type="hidden" id="modelId' + rowCount + '" name="modelId" value="' + $("#parentCategory option:selected").val() + '"/></td>\n\
                                <td STYLE="text-align:center;font-size:14px;ont-weight: bold; height: 25px; width:25px">\n\
                                    <input type="text" id="minQuant' + rowCount + '"  name="minQuant" size = "10"/></td><td STYLE="text-align:center;font-size:14px;ont-weight: bold; height: 25px; width:25px">\n\
                                    <input type="text" id="maxQuant' + rowCount + '"  name="maxQuant" size="10px"/></td><td STYLE="text-align:center;font-size:14px;ont-weight: bold; height: 25px; width:25px">\n\
                                    <a id="accept' + rowCount + '" onclick="JavaScript: saveContractDetails(' + rowCount + ');" size="30px" style="cursor: hand">\n\
                                        <img src="images/icons/done.png" width="20" hieght="20"/>\n\
                                    </a>&ensp;&ensp;\n\
                                    <a id="' + rowCount + '" onclick="JavaScript: deleteContractRecord(this);" size="30px" style="cursor: hand">\n\
                                        <img src="images/cancel.png"/>\n\
                                    </a>\n\
                                </td>\n\
                            </tr>';
                $('#equipments').append(trHTML);
            }

            function showDetails() {
                $('#details1').fadeIn(1000, function () {
                    this.css("display", "block");
                });
                $('#details2').fadeIn(1000, function () {
                    this.css("display", "block");
                });
                $('#details3').fadeIn(1000, function () {
                    this.css("display", "block");
                });
            }

            function deleteContractRecord(obj) {
                $('#row' + obj.id).fadeOut(1000, function () {
                    $(this).remove();
                });
            }
            function reloadAE(nextMode) {

                var url = "<%=context%>/ajaxGetItrmName?key=" + nextMode;
                if (window.XMLHttpRequest)
                {
                    req = new XMLHttpRequest();
                } else if (window.ActiveXObject)
                {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                req.open("Post", url, true);
                req.onreadystatechange = callbackFillreload;
                req.send(null);

            }
            function callbackFillreload() {
                if (req.readyState === 4)
                {
                    if (req.status === 200)
                    {
                        window.location.reload();
                    }
                }
            }

            function newContract() {
                document.EQUIPMENT_FORM.action = "<%=context%>/ContractsServlet?op=residenceContract";
                document.EQUIPMENT_FORM.submit();
//                var contractNo = $("#contractNo").val();
//                $.ajax({
//                    type: "post",
//                    url: "<%=context%>/ContractsServlet?op=saveTempContract",
//                    data: {
//                        contractNo: $("#contractNo").val(),
//                        automated: $("#automated").val(),
//                        contractName: $("#contractName").val(),
//                        client: $("#client").val(),
//                        employee: $("#employee").val(),
//                        contractRegDate: $("#contractRegDate").val(),
//                        contractUnit: $("#contractUnit").val(),
//                        unitNo: $("#unitNo").val(),
//                        notes: $("#notes").val(),
//                        contractValue: $("#contractValue").val(),
//                        paymentType: $("#paymentType").val(),
//                        beginInterval: $("#beginInterval").val(),
//                        contractEndDate: $("#cEDate").html(),
//                        contractType: $("#contractType").val()
//
//
//                    },
//                    success: function (jsonString) {
//                        alert('test');
//                    }
//                });
            }


            function openEmployeesDailog() {
                var divTag = $("<div></div>");
                var ids = "";
                $("input[name='employeeID']").each(function () {
                    ids += "," + this.value;
                });
                if ($("#employee").val() !== '') {
                    ids += "," + $("#employee").val();
                }
                $.ajax({
                    type: "post",
                    url: '<%=context%>/EmployeeServlet?op=listEmployees',
                    data: {
                        ids: ids
                    },
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "<%=addEmployee%>",
                            show: "fade",
                            hide: "explode",
                            width: 600,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                Cancel: function () {
                                    $(this).dialog('close');
                                },
                                Done: function () {
                                    var employeeID, employeeNo, employeeName, employeeRole, className;
                                    var counter = $('#noOfSelectedEmployee').val();
                                    $(this).find(':checkbox:checked').each(function () {
                                        employeeID = this.value;
                                        employeeNo = $(divTag.html()).find('#employeeNo' + this.value).val();
                                        employeeName = $(divTag.html()).find('#employeeName' + this.value).val();
                                        employeeRole = $(divTag.html()).find('#employeeRole' + this.value).val();
                                        counter++;
                                        if (counter % 2 === 1) {
                                            className = "silver_odd_main";
                                        } else {
                                            className = "silver_even_main";
                                        }
                                        $('#employees > tbody:last').append("<TR id=\"row" + counter + "\">");
                                        $('#row' + counter).append("<TD width=\"8%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><b><font size=\"2\" color=\"#000080\" style=\"text-align: center;\">" + employeeNo + "</font></b></TD>")
                                                .append("<TD width=\"25%\" class=" + className + " STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\">" + employeeName + "</font></b></TD>")
                                                .append("<TD width=\"25%\" class=" + className + " STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\"><input type=\"hidden\" id=\"employeeID" + counter + "\" name=\"employeeID\" value=\"" + employeeID + "\"/>" + employeeRole + "</TD>")
                                                .append("</TR>");
                                        $('#noOfSelectedEmployee').val(counter);
                                        getManagerEmployees($("#employeeID" + counter), false);
                                    });
                                    $(this).dialog('close');
                                }
                            }
                        }).dialog('open');
                    }
                });
            }
            function getManagerEmployees(obj, clearAll) {
                var managerID = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/EmployeeServlet?op=getManagerEmployeesAjax",
                    data: {
                        managerID: managerID
                    },
                    success: function (jsonString) {
                        try {
                            var counter;
                            if (clearAll) {
                                $("#employees").find("tr:gt(0)").remove();
                                counter = 0;
                                $('#noOfSelectedEmployee').val(counter);
                            } else {
                                counter = $('#noOfSelectedEmployee').val();
                            }
                            var employeeID, employeeNo, employeeName, employeeRole, className;
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                counter++;
                                var employee = info[i];
                                employeeID = employee.empId;
                                employeeNo = employee.empNO;
                                employeeName = employee.empName;
                                employeeRole = employee.typeAr;
                                if (counter % 2 === 1) {
                                    className = "silver_odd_main";
                                } else {
                                    className = "silver_even_main";
                                }
                                $('#employees > tbody:last').append("<TR id=\"row" + counter + "\">");
                                $('#row' + counter).append("<TD width=\"8%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><b><font size=\"2\" color=\"#000080\" style=\"text-align: center;\">" + employeeNo + "</font></b></TD>")
                                        .append("<TD width=\"25%\" class=" + className + " STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\">" + employeeName + "</font></b></TD>")
                                        .append("<TD width=\"25%\" class=" + className + " STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\"><input type=\"hidden\" id=\"employeeID" + counter + "\" name=\"employeeID\" value=\"" + employeeID + "\"/>" + employeeRole + "</TD>")
                                        .append("</TR>");
                            }
                            $('#noOfSelectedEmployee').val(counter);
                        } catch (err) {
                        }
                    }
                });
            }

            function closeOrderID(checkBox) {
                if (!checkBox.checked) {
                    document.getElementById("contractNo").value = "";
                    document.getElementById("contractNo").disabled = false;
                    $('input[name="automated"]').attr('value', 'no');
                } else {
                    document.getElementById("contractNo").value = "";
                    document.getElementById("contractNo").disabled = true;
                    $('input[name="automated"]').attr('value', 'yes');
                }
            }


            function calculateVisit() {
                if ($("#visitNo").val()) {
                    $("#contractValue").val(parseInt($("#visitPrice").val()) * parseInt($("#visitNo").val()));
                }
            }
            
            function calculateEndDate() {
                if ($("#period").val()) {
                    var calcInterval;
                    var beginDate = $("#beginInterval").val();
                    var interval = $("#period").val();
                    var intervalType = $("#periodType :selected").val();
                    var now = new Date();

                    now.setFullYear(parseInt(beginDate.substring(0, 4)), (parseInt(beginDate.substring(5, 7)) - 1), parseInt(beginDate.substring(8)));

                    if (intervalType == 1) {
                        now.setDate(now.getDate() + parseInt(interval));
                    }

                    if (intervalType == 2) {
                        calcInterval = parseInt(interval) * 7;
                        now.setDate(now.getDate() + calcInterval);
                    }

                    if (intervalType == 3) {
                        now.setMonth(now.getMonth() + parseInt(interval));
                    }

                    if (intervalType == 4) {
                        now.setYear(now.getFullYear() + parseInt(interval));
                    }

                    $("#cEDate").html(now.getFullYear() + "/" + (now.getMonth() + 1) + "/" + now.getDate());
                    $("#contractEndDate").val(now.getFullYear() + "/" + now.getMonth() + "/" + now.getDate());
                    $("#endInterval").val(now.getFullYear() + "/" + (now.getMonth() + 1) + "/" + now.getDate());
                }
            }
        </SCRIPT>
    </head>

    <BODY>
        <input type="hidden" id="contractId" name="contractId" value="" />
        <div style="width: 100%; text-align: center;">
            <div align="left" STYLE="color:blue; padding-left: 10%; padding-bottom: 10px; padding-top: 10px">
                <input type="button" value="<%=lang%>"onclick="reloadAE('<%=langCode%>')" class="button">
            </div>
            <fieldset class="set" style="width:80%; margin: auto;" >
                <table dir="<%=dir%>" class="blueBorder" align="<%=align%>"  align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                            <font size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>

                <div style="width: 60%; text-align: center; margin: auto;">
                    <form id="EQUIPMENT_FORM" name="EQUIPMENT_FORM" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="contractType" id="contractType" value="2"/>
                        <table class="display" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" >
                            <TR>
                                <td style="border: 0px" colspan="3">
                                    <div style="width: 100%; height: 20px; border-bottom: 1px solid black; text-align: center; vertical-align: middle">
                                        <span style="font-size: 20px; background-color: #F3F5F6; padding: 0 10px; color: red; vertical-align: middle">
                                            <%=contractDetailes%>
                                        </span>
                                    </div>
                                </td>
                                <TD class="td2" STYLE="text-align: <%=alignX%>; height: 25px; padding: 5px">
                                    <button type="button" id="btnNew" onclick="JavaScript: newContract();" style="width: 125px; font-size: 14px; font-weight: bold;"><%=newContract%> <img src="images/icons/add.png" width="20" hieght="20"/></button>
                                </td>
                            </tr>

                            <TR>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=contractNumber%></b></TD>
                                <TD class="td2" STYLE="text-align:<%=align%>;font-size:14px;ont-weight: bold; height: 25px; padding: 5px" nowrap>
                                    <input type="number"  style="width: 65%;" name="contractNo" ID="contractNo" size="20" value="" maxlength="255" />
                                    <input type="checkbox" name="automatedContractID" id="automatedContractID" onclick="javascript: closeOrderID(this);" ><b><font size="3" color="black">&nbsp;<%=auto%></font></b>
                                    <input type="hidden"  id='automated' name='automated'/>
                                </TD>
                                <td style="border: 0px"></td>
                            </tr>

                            <TR>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=contractName%></b></TD>
                                <TD class="td2" STYLE="text-align:<%=align%>;font-size:14px;ont-weight: bold; height: 25px; padding: 5px" colspan="3">
                                    <Input type='text' id='contractName' name='contractName' size="20" value="" maxlength="255" style="width: 42%;"/>
                                </TD>
                            </tr>

                            <TR>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=clientName%></b></TD>
                                <TD class="td2" STYLE="text-align:<%=align%>;font-size:14px;ont-weight: bold; height: 25px; padding: 5px" colspan="3">
                                    <select class="blackFont fontInput" name="client" id="client" style="width: 100%; font-size: large; font-weight: bold; padding: 2px 2px 2px 2px">
                                        <sw:WBOOptionList wboList='<%=clients%>' displayAttribute = "name" valueAttribute="id"/>
                                    </select>
                                </TD>
                            </tr>

                            <TR>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=contractSupervisor%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px" colspan="3">
                                    <select class="blackFont fontInput" name="employee" id="employee" style="width: 100%; font-size: large; font-weight: bold; padding: 2px 2px 2px 2px" onchange="JavaScript: getManagerEmployees(this, true);">
                                        <%for (int i = 0; i < employees.size(); i++) {
                                                LiteWebBusinessObject LWbo = (LiteWebBusinessObject) employees.get(i);
                                        %>
                                        <option value="<%=LWbo.getAttribute("empId")%>"><%=LWbo.getAttribute("empName")%></option>
                                        <%}%>
                                    </select>
                                </TD>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="4">
                                    <div style="width: 100%; height: 20px; border-bottom: 1px solid black; text-align: center; vertical-align: middle">
                                        <span style="font-size: 20px; background-color: #F3F5F6; padding: 0 10px; color: red; vertical-align: middle">
                                            <%=contractPeriodData%> 
                                        </span>
                                    </div>
                                </td>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="4">
                                </td>
                            </tr>

                            <TR>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=contractPeriod%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px"><input type="TEXT"  style="width: 100%;" name="beginInterval" ID="beginInterval" size="20" value="<%=beginInterval%>" maxlength="255"/></TD>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px; width:100px"><b><%=contractCalcPeriod%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px">
                                    <select class="blackFont fontInput" name="periodType" id="periodType" style="width: 40%; font-size: large; font-weight: bold; padding: 2px 2px 2px 2px"
                                            onchange="JavaScript: calculateEndDate();">
                                        <option value='1'><%=day%></option>
                                        <option value='2'><%=week%></option>
                                        <option value='3'><%=month%></option>
                                        <option value='4'><%=year%></option>
                                    </select>
                                    <input type="number"  name="period" ID="period" size="20" value="" maxlength="10" onblur="JavaScript: calculateEndDate();"
                                           style="width: 57%;"/></TD>
                            </tr>

                            <TR>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=contractRegistrationDate%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px">
                                    <Font color='red'><%=beginInterval%></Font>
                                    <input type="hidden"  id='contractRegDate' name='contractRegDate' value="<%=beginInterval%>"/>
                                    <input type="hidden"  id='contractEndDate' name='contractEndDate' value=""/>
                                    <input type="hidden"  id='endInterval' name='endInterval' value=""/>
                                </TD>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=tto%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px; color: red" id="cEDate">
                                </TD>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="4">
                                </td>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="4">
                                    <div style="width: 100%; height: 20px; border-bottom: 1px solid black; text-align: center; vertical-align: middle">
                                        <span style="font-size: 20px; background-color: #F3F5F6; padding: 0 10px; color: red; vertical-align: middle">
                                            <%=contractValue%> 
                                        </span>
                                    </div>
                                </td>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="4">
                                </td>
                            </tr>

                            <tr>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=contactValue%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px"><input type="number"  style="width: 100%;" name="contractValue" ID="contractValue" size="20" maxlength="255"/></TD>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=paymentType%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px">
                                    <select class="blackFont fontInput" name="paymentType" id="paymentType" style="width: 100%; font-size: large;">
                                        <option value="نقدا"><%=cash%></option>
                                        <option value="تقسيط"><%=installment%></option>
                                    </select>
                                </TD>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="4">
                                </td>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="4">
                                    <div style="width: 100%; height: 20px; border-bottom: 1px solid black; text-align: center; vertical-align: middle">
                                        <span style="font-size: 20px; background-color: #F3F5F6; padding: 0 10px; color: red; vertical-align: middle">
                                            <%=contractItems%> 
                                        </span>
                                    </div>
                                </td>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="4">
                                </td>
                            </tr>

                            <tr>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=visitCount%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px">
                                    <select class="blackFont fontInput" name="visitPeriodType" id="visitPeriodType" style="width: 40%; font-size: large; font-weight: bold; padding: 2px 2px 2px 2px">
                                        <option value='1'><%=day%></option>
                                        <option value='2'><%=week%></option>
                                        <option value='3'><%=month%></option>
                                        <option value='4'><%=year%></option>
                                    </select>
                                    <input type="number"  name="visitNo" ID="visitNo" size="20" value="" maxlength="10"
                                           style="width: 57%;"/>
                                </TD>
                                </TD>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=visitPrice%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px">
                                    <input type="number"  name="visitPrice" ID="visitPrice" size="20" value="" maxlength="10" style="width: 100%;" onblur="JavaScript: calculateVisit();"/></TD>
                                </TD>
                            </tr>

                            <tr>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=workType%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px">
                                    <select class="blackFont fontInput" name="workType" id="workType" style="width: 100%; font-size: large;">
                                        <sw:WBOOptionList wboList='<%=workTypes%>' displayAttribute = "projectName" valueAttribute="projectID"/>
                                    </select>
                                </TD>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=otherReq%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px">
                                    <select class="blackFont fontInput" name="otherReq" id="otherReq" style="width: 100%; font-size: large;">
                                        <option value="1">req1</option>
                                        <option value="2">req2</option>
                                        <option value="3">req3</option>
                                    </select>
                                </TD>
                            </tr>

                            <TR>
                                <TD class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px"><b><%=note%></b></TD>
                                <TD class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px; width: 100%" colspan="3">
                                    <textarea rows="2" cols="100" id="notes" name="notes" style="width: 100%"></textarea>
                                </TD>
                            </tr>
                            <tr>
                                <td nowrap class="silver_header td2 formInputTag boldFont" STYLE="text-align:center;ont-weight: bold; height: 25px">
                                    <%=uploadDocument%>
                                </td>
                                <td class="td2" STYLE="text-align:right;font-size:14px;ont-weight: bold; height: 25px; padding: 5px; width: 100%" colspan="3">
                                    <input type="file" size="60" id="contractFile" name="contractFile"/>
                                </td>
                            </tr>

                            <TR>
                                <td style="border: 0px" colspan="3"><b id="message" style="color: red; text-align: center; font-weight: bold; font-size: 16px"></b></td>
                                <TD class="td2" style="text-align: left; height: 25px; padding: 5px">
                                    <button type="button" id="btnSave" onclick="javascript:saveContract();"  width="200px" style="width: 100px; font-size: 14px; font-weight: bold"><%=save%><img src="images/icons/done.png" width="20" hieght="20"/></button>
                                </TD>
                            </tr>
                        </table>
                    </form>
                </div>
            </fieldset>
        </div>
    </body>
</html>