<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        String status = (String) request.getAttribute("Status");
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd hh:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        String errorExtConn = (String) request.getAttribute("errorExtConn");
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        Vector<WebBusinessObject> regions = new Vector();
        regions = (Vector) request.getAttribute("regions");
        ArrayList<WebBusinessObject> regionsList = new ArrayList<WebBusinessObject>(regions);
        Vector tradeV = new Vector();
        tradeV = (Vector) request.getAttribute("tradeV");
        ArrayList<WebBusinessObject> tradeList = new ArrayList<WebBusinessObject>(tradeV);

        String region = "";
        String job = "";
        if (clientWbo != null) {
            if (clientWbo.getAttribute("region") != null) {
                region = (String) clientWbo.getAttribute("region");
            }
            if (clientWbo.getAttribute("job") != null) {
                job = (String) clientWbo.getAttribute("job");
            }
        }

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String arName;
        String client_number, client_name, regionName, client_address, client_phone, client_mobile, client_mail, working_status;
        String title_1, fStatus, sStatus, msgErrorExtConn;
        if (stat.equals("En")) {
            align = "center";
            dir = "Ltr";
            style = "text-align:left";
            arName = "arabic title";
            client_name = "Client name";
            client_number = "Client number";
            client_address = "Client address";
            client_phone = "Client phone";
            client_mobile = "Mobile";
            client_mail = "E-mail";
            working_status = "Working";
            title_1 = "View/Update Client";
            sStatus = "Client Updated Successfully";
            fStatus = "Fail To Update This Client";
            regionName = "Region Arabic Name";
            msgErrorExtConn = "Connection fail by Realstate";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            arName = "المهنة";
            client_name = "إسم المقاول";
            client_number = "كود المقاول";
            client_address = "&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
            client_phone = "&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
            client_mobile = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1576;&#1575;&#1610;&#1604;";
            client_mail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
            working_status = "&#1606;&#1588;&#1591;";
            title_1 = "مشاهدة/تعديل مقاول";
            fStatus = "لم يتم تعديل هذا المقاول";
            sStatus = "تم التعديل بنجاح";
            regionName = "المنطقة";
            msgErrorExtConn = "فشل الاتصال بقاعدة بيانات العقارت";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>new Client</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
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
        $(function() {
            $("#appDate1").datetimepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                timeFormat: 'hh:mm',
                dateFormat: 'yy/mm/dd'
            });
        });
        function checkNumber(obj) {
            if ($(obj).val() == "") {
                $("#numberMsg").show();
                $("#numberMsg").text("كود المقاول مطلوب");
            }
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
                    success: function(jsonString) {
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
        function checkMobile(obj) {
            var phone = $("#phone").val();
            var mobile = $("#mobile").val();
            if (!validateData2("numeric", this.CLIEN_FORM.mobile)) {
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
        $(function() {
            $("#ClientNo").val("");
        })
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
            var mobile = $("#mobile").val();
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
        function showDialog(url) {
            $("#divv").load(url);
            $("#divv").dialog({
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
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.Status == 'Ok') {
                        $("#job").append("<option value='" + info.code + "'" + ">" + info.name + "</option>");
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
                url: "<%=context%>/ClientServlet?op=saveRegion",
                data: {
                    regionNameAr: regionNameAr
                },
                success: function(jsonString) {
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
            var name = $("#name").val();
            if (name.length > 0) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientName",
                    data: {
                        clientName: name
                    },
                    success: function(jsonString) {
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
                success: function(jsonString) {
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
        function submitForm()
        {
            if (!validateData2("req", this.CLIEN_FORM.name) || !validateData2("minlength=3", this.CLIEN_FORM.name)) {
                this.CLIEN_FORM.name.focus();
                if ($("#name").val() == "") {
                    $("#naMsg").show();
                    $("#naMsg").text("إسم المقاول مطلوب");
                }
                else if (!validateData2("minlength=3", this.CLIEN_FORM.name)) {
                    $("#naMsg").show();
                    $("#naMsg").text("الإسم اقل من 3 حروف");
                }
                else {
                    $("#naMsg").hide();
                    $("#naMsg").html("");
                }
                return false;
            }
            if (!validateData2("numeric", this.CLIEN_FORM.mobile)) {
                this.CLIEN_FORM.mobile.focus();
                if (!validateData2("numeric", this.CLIEN_FORM.mobile)) {
                    $("#moMsg").show();
                    $("#moMsg").text("ارقام فقط");
                }
                else {
                    $("#moMsg").hide();
                    $("#moMsg").html("");
                }
                return false;
            }
            else {
                document.CLIEN_FORM.action = "<%=context%>/ClientServlet?op=updateContractor";
                document.CLIEN_FORM.submit();
            }
        }
        function cancelForm()
        {
            document.CLIEN_FORM.action = "main.jsp";
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
    <BODY>
        <div id="add_campaigns" style="width: 40% !important;display: none;"></div>
        <input id="compID" type="hidden" />
        <input id="issueID" type="hidden" />
        <FORM NAME="CLIEN_FORM" METHOD="POST">
            <DIV style="color:blue;margin-bottom: 30px;width: 100%;">
                <div style="margin-left: auto;margin-right: auto;">
                    <button  onclick="JavaScript:cancelForm();" class="closeBtn" style="margin-right: 2px;"></button>
                    <input  type="button" onclick="submitForm()"  id='submitBtn' class="submitBtn" value="" style="display: inline-block;"/>
                </div>
            </DIV> 
            <div id="divv">
            </div>
            <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 20px;border-radius: 5px;">
                <table dir="<%=dir%>" align="<%=align%>" class="blueBorder" width="100%">
                    <tr>
                        <td style="text-align:center;border-color: #006699; width:100%;" class="blueBorder blueHeaderTD">
                            <FONT color='white' SIZE="+1"><%=title_1%>                
                            </font>
                        </td>
                    </tr>
                </table>
                <% if (errorExtConn != null && !errorExtConn.equals("") && errorExtConn.equals("1")) {%>
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr><td class="td">
                            <font size="4" color="red"> <%=msgErrorExtConn%> </font>
                        </td></tr> 
                </table>
                <% }%> 
                <%
                    if (status != null) {
                        if (status.equalsIgnoreCase("ok")) {
                            if (clientWbo != null) {
                %>  
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" >تم تعديل المقاول</font> 
                        </td>                    
                    </tr> 
                </table>
                <%}
                    } else {%>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>
                    <%}
                        }
                    %>
                <table style="margin-bottom: 20px;background: #f9f9f9;display: block;" ALIGN="center"  dir="<%=dir%>" border="0" width="100%" id="saveClient">
                    <tr style="display: none" id="regsuccess">                    
                        <td class="td" colspan="2" style="text-align: center;" >
                            <font size=3 color="black"><%=sStatus%></font> 
                        </td>                    
                    </tr>
                    <tr>
                        <td style="width: 50%;border: 0px;margin-top: 0px;padding: 0px;">
                            <table style=" margin: 0px;">
                                <%
                                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                                            && connectByRealEstate.equals("0")) {
                                %>
                                <tr id="numberRow" class="numberRow">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="supplierNO2">
                                            <p><b style="color: #0000FF;"><%=client_number%><font color="#FF0000">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>"  class='TD' >
                                        <input type="TEXT" style="width:40%;" name="clientNO" ID="clientNO" size="33" maxlength="10" class="clientNumber" autocomplete="off"
                                               readonly="true" value="<%=clientWbo.getAttribute("clientNO")%>"> 
                                        <input type="hidden" name="clientID" id="clientID" value="<%=clientWbo.getAttribute("id")%>" />
                                        <input type="hidden" name="saveInRealState" id="saveInRealState" value="false" />
                                        <div id="warning"style="margin-right: 25px;display: none;width: 16px;height: 16px; background-image: url(images/warning.png);background-repeat: no-repeat;"></DIV>
                                        <div id="ok"style="margin-right: 25px;display: none;width: 16px;height: 16px; background-image: url(images/ok2.png);background-repeat: no-repeat;"></DIV>
                                        <LABEL id="MSG" ></LABEL>
                                        <p id="numberMsg"></p>
                                    </td>
                                </tr>
                                <%}%>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="name" >
                                            <p><b style=""><%=client_name%><font color="#FF0000">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:230px;background-color: #FFFF66;" name="name" ID="name" size="33"
                                               value="<%=clientWbo != null && clientWbo.getAttribute("name") != null ? clientWbo.getAttribute("name") : ""%>"
                                               maxlength="255" onkeyup="checkName(this)" onmousedown="checkName(this)">
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
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="region">
                                            <p><b>المنطقه<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <SELECT name="region" id="region" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">
                                            <OPTION value="000"> ---إختر---</OPTION>
                                                <sw:WBOOptionList wboList="<%=regionsList%>" displayAttribute="name" valueAttribute="code" scrollToValue="<%=region%>" />
                                        </SELECT>
                                        <input type="button" value="إضافة منطقه" id="insertRegion" onclick="regionPopup(this)"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="nationality">
                                            <p><b>نوع النشاط<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <SELECT name="job" id="job" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">
                                            <OPTION value="000"> ---إختر---</OPTION>
                                            <sw:WBOOptionList wboList="<%=tradeList%>" displayAttribute="tradeName" valueAttribute="tradeId" scrollToValue="<%=job%>" />
                                        </SELECT>
                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="mobile">
                                            <p><b style=""><%=client_mobile%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:120px;" name="mobile" ID="mobile" size="11" onkeyup="javascript:return checkMobile(this, event)" onmouseout="javascript:return checkMobile(this, event)"
                                               <%
                                                   if (clientWbo != null) {
                                                       if (clientWbo.getAttribute("mobile") != null) {%>  value="<%=((String) clientWbo.getAttribute("mobile")).trim()%>" <%} else {%>
                                               value=""
                                               <%}
                                                   }
                                               %>
                                               maxlength="11" >
                                        <input type="TEXT" style="width:50px;" name="internationalM" ID="internationalM" size="5" >
                                        <p id="moMsg"></p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="border: 0px;">
                            <table style="margin-top: 0px;">
                                <script>
                                </script>
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag"  width="35%">
                                        <LABEL FOR="phone">
                                            <p><b><%=client_phone%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:120px" name="phone" ID="phone" size="11" onkeyup="javascript:return checkTel(this, event)" onmouseout="javascript:return checkTel(this, event)"
                                               <%
                                                   if (clientWbo != null) {
                                                       if (clientWbo.getAttribute("phone") != null) {%>  value="<%=((String) clientWbo.getAttribute("phone")).trim()%>" <%} else {%>
                                               value=""
                                               <%}
                                                   }
                                               %>
                                               maxlength="15" onkeyup="checkTel(this)">
                                        <input type="TEXT" style="width:50px;" name="internationalP" ID="internationalP" size="5" >
                                        <p id="telMsg" ></p>
                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="address">
                                            <p><b><%=client_address%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <textarea style="width:230px;" rows="3" ID="address" name="address"><%=clientWbo != null && clientWbo.getAttribute("address") != null ? clientWbo.getAttribute("address") : ""%></textarea>
                                    </td>
                                </tr>
                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="email">
                                            <p><b><%=client_mail%></b>&nbsp;
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
                                               maxlength="255" onkeyup="checkMail(this.value)">
                                        <p id="mailMsg" ></p>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag " width="35%">
                                        <LABEL FOR="isActive">
                                            <p><b><%=working_status%></b>
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <INPUT TYPE="CHECKBOX" name="isActive" ID="isActive" value="0" <%=clientWbo != null && clientWbo.getAttribute("isActive") != null && clientWbo.getAttribute("isActive").equals("1") ? "checked" : ""%>/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
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
                                <%=regionName%>
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
        </FORM>
    </BODY>
</HTML>     
