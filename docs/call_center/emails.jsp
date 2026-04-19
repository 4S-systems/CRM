<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
//    String status = (String) request.getAttribute("Status");
    //  String Name = (String) request.getAttribute("mainName");
    // Vector brands = new Vector();
    // brands = (Vector) request.getAttribute("brands");

    // String doubleName = (String) request.getAttribute("name");
    Vector<WebBusinessObject> mainCatsTypes = new Vector();

    String usrEmail = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
    
    HttpSession s = request.getSession();


    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");






//    Vector dataUnit = (Vector) request.getAttribute("dataUnit");
//    Vector<WebBusinessObject> paymentPlace = new Vector();
//    paymentPlace = (Vector) request.getAttribute("paymentPlace");
//    mainCatsTypes = (Vector) request.getAttribute("data");
//    String doubleName = (String) request.getAttribute("name");
//    Vector brands = new Vector();
//    brands = (Vector) request.getAttribute("brands");
//    String Name = (String) request.getAttribute("mainName");
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String[] tableHeader = new String[6];


    String message = null;
    String lang, langCode, title, Show, mainData, EquipmentRow, selectMain, link1, link2, link3, link4, link5, M1, M2, Dupname, unit;
    String open, add, deleteProjectLabel, geographicLoc,from,direction, updateProject, attachedImage, unitCategoryId = "";
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1410;    ";
        langCode = "Ar";
        title = "Equipment Tree";
        Show = "Show Tree";
        unit = "unit";
        EquipmentRow = "Equipment Categories";
        selectMain = "Select Main Type";
        link1 = "Equipment Details";
        link2 = "Last Job Order";
        link3 = "Schedules";
        link4 = "Equipment Plan";
        link5 = "Related Parts";
        tableHeader[0] = "id";
        tableHeader[1] = "username";
        tableHeader[2] = "email";
        tableHeader[3] = "full name";
        M1 = "The Saving Successed";
        M2 = "The Saving Successed Faild";
        Dupname = "Name is Duplicated Change it";
        open = "Main Information ";
        add = "New sub Project";
        deleteProjectLabel = "Delete Project";
        geographicLoc = "Geographic Location";
        updateProject = "Update Location";
        attachedImage = "Attached image";
        from = "From";
        direction = "left";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        title = "المنتجات";
        unit = "&#1573;&#1587;&#1405; &#1575;&#1404;&#1408;&#1581;&#1583;&#1577;";
        Show = "&#1576;&#1581;&#1579;";
        EquipmentRow = " &#1575;&#1404;&#1406;&#1408;&#1593; &#1575;&#1404;&#1575;&#1587;&#1575;&#1587;&#1410;";
        selectMain = "&#1571;&#1582;&#1578;&#1585; &#1406;&#1408;&#1593; &#1585;&#1574;&#1410;&#1587;&#1410;";
        link1 = "&#1578;&#1401;&#1575;&#1589;&#1410;&#1404; &#1575;&#1404;&#1405;&#1593;&#1583;&#1407;";
        link2 = "&#1593;&#1585;&#1590; &#1571;&#1582;&#1585; &#1571;&#1405;&#1585; &#1588;&#1594;&#1404;";
        link3 = "&#1575;&#1404;&#1580;&#1583;&#1575;&#1408;&#1404;";
        link4 = "&#1575;&#1404;&#1582;&#1591;&#1407;";
        link5 = "&#1402;&#1591;&#1593; &#1575;&#1404;&#1594;&#1410;&#1575;&#1585;";
        M1 = "&#1578;&#1405; &#1575;&#1404;&#1578;&#1587;&#1580;&#1410;&#1404; &#1576;&#1406;&#1580;&#1575;&#1581; ";
        tableHeader[0] = "كود الوحدة";
        tableHeader[1] = "م-الوحدة";
        tableHeader[2] = "وصف الوحدة";
        tableHeader[3] = "م-الحديقة";
        tableHeader[4] = "الحالة";
        tableHeader[5] = "";
        open = "المعلومات الأساسية";
        add = "موقع فرعي جديد";
        deleteProjectLabel = "حذف الموقع";
        geographicLoc = "الموقع الجغرافى";
        updateProject = "تحديث الموقع";
        attachedImage = "الصور المرفقة";
        M2 = "&#1404;&#1405; &#1410;&#1578;&#1405; &#1575;&#1404;&#1578;&#1587;&#1580;&#1410;&#1404;";
        from = "من";
        direction = "left";
        Dupname = "&#1407;&#1584;&#1575; &#1575;&#1404;&#1575;&#1587;&#1405; &#1587;&#1580;&#1404; &#1405;&#1406; &#1402;&#1576;&#1404; &#1410;&#1580;&#1576; &#1578;&#1587;&#1580;&#1410;&#1404; &#1575;&#1587;&#1405; &#1570;&#1582;&#1585;";
    }

    ArrayList treeMenu = metaMgr.getTreeMenu();
    if (treeMenu.get(0) == null) {
        System.out.println("jkdshfljksahdfjklshdlkjfsdh kjlg");

    }
%>
<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="treemenu/page_style.css" />
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css">
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css">
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                changeContent();
            });
            function getDetails(proId) {
                window.navigate('<%=context%>/IssueServlet?op=showProduct&proId=' + proId);
            }
            function view(projectId) {
                //                var proId=$(this).parent().parent().find("#proId").val();

                window.navigate('<%=context%>/ProjectServlet?op=showImage&projectId=' + projectId);
            }
            function isNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)){
                    alert("أرقام فقط")
                    return false;
                }
    
                return true;
            }
            function getAttached(id)
            {
                //                $("#images").html('<img src="images/Loading2.gif"> loading ...');
                $('#images').html('<iframe id="frame" src="<%=context%>/ProjectServlet?op=showImage&projectId=' + id + ' " width="100%" height="400" ></iframe>');
                $('#images').bPopup();
                //                alert(id);
                //                $.ajax({
                //                    type: "POST",
                //                    url: "<%--=context--%>/ProjectServlet",
                //                    data: "op=showImage&projectId="+id,
                //                    success: function(msg){
                //                        $('#images').html('<iframe src="<%=context%>/ProjectServlet?op=showImage&projectId='+id+' " width="100%" height="500" scrolling="no"></iframe>');
                // 
                //                    }
                //                });

            }


            function popup(obj) {

                $(obj).bind('click', function(e) {
                    e.preventDefault();
                    //                    alert($(this).parent().parent().find("#msg").html());
                    //                    alert($(this).parent().parent().find("#proId").val());
                    $('#sms_content').bPopup();
                    $('#sms_content').css("display", "block");
                    $("#reservedPlace").html($(this).parent().parent().find("#msg").html());
                    $("#unitId").val($(this).parent().parent().find("#proId").val());
                    $("#issueId").val($(this).parent().parent().find("#busObjId").val());
                    //                    alert($("#unitId").val());

                });
            }
            function getSubProduct(mainProductId) {
                if (mainProductId == null || mainProductId == "") {

                } else {
                    document.getElementById('subProduct').innerHTML = "";
                    $("#showBtn").removeAttr("disabled");
                    $("#subProduct").removeAttr("disabled");
                    var url = "<%=context%>/ProjectServlet?op=getSubProject&mainProductId=" + mainProductId;
                    if (window.XMLHttpRequest) {
                        req = new XMLHttpRequest();
                    } else if (window.ActiveXObject) {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("Post", url, true);
                    req.onreadystatechange = callbackFillMainCategory;
                    req.send(null);
                }
            }

            function callbackFillMainCategory() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        var resultData = document.getElementById('subProduct');
                        var result = req.responseText;
                        //                        alert(result);
                        if (result != "") {
                            var data = result.split("<element>");
                            var idAndName = "";

                            for (var i = 0; i < data.length; i++) {
                                idAndName = data[i].split("<subelement>");

                                resultData.options[resultData.options.length] = new Option(idAndName[1], idAndName[0]);
                            }
                        } else {
                            //                            alert("Not Found Brands For this Main Category ...")
                        }
                    }
                }
            }
            function changeMode(name) {
                if (document.getElementById(name).style.display == 'none') {
                    document.getElementById(name).style.display = 'block';
                } else {
                    document.getElementById(name).style.display = 'none';
                }
            }

            function reloadAE(nextMode) {

                var url = "<%=context%>/ajaxGetItrmName?key=" + nextMode;
                if (window.XMLHttpRequest)
                {
                    req = new XMLHttpRequest();
                }
                else if (window.ActiveXObject)
                {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                req.open("Post", url, true);
                req.onreadystatechange = callbackFillreload;
                req.send(null);

            }
            function sendMailss()
            {
                var status = $("#status").val();
                if ($("#status").val() == "ok" || $("#for").val() == "allClient" || $("#for").val() == "searchClient") {
                    var clientNumber = $("#errorMsg").val();
                    var file = $("#file").val();
                    var fileName = document.getElementById("file1").value;
                    fileExt = "noFiles";
                    var fileTitle = "noTitle";

                    if (fileName.length > 0)
                    {

                        var fileExtPos = fileName.lastIndexOf('.');
                        var fileTitlePos = fileName.lastIndexOf('\\');

                        fileExt = fileName.substr(fileExtPos + 1);

                        fileTitle = fileName.substring(fileTitlePos + 1, fileExtPos);

                        document.getElementById("fileExtension").value = fileExt;

                        document.getElementById("docTitle").value = fileTitle;

                    }
                    var fromTyp = $("input[name=from]:checked").val();

                    document.emailForm.action = "<%=context%>/EmailServlet?op=sendMail&fileExtension=" + fileExt+ "&fromTyp=" + fromTyp;
                    document.emailForm.submit();

                } else {
                    alert("عميل غير موجود");
                    return false;
                }

            }
            function submitForm2()
            {

                var unitCategory = $("#unitCategoryId").val();

                document.MainType_Form.action = "<%=context%>/SearchServlet?op=SearchForUnits&unitCategory=" + unitCategory;

                document.MainType_Form.submit();
            }
            function changeContent() {
                var x;
                if ($("#for").val() == "client") {

                    $("#clientNo").show();
                    $("#clientNa").show();
                    $("#toMails").hide();
                    $("#searchBtn").hide();
                    $("#email").html("");
                } else if ($("#for").val() == "allClient") {
                    $("#clientNo").hide();
                    $("#clientNa").hide();
                    $("#toMails").hide();
                    $("#searchBtn").hide();
                    $("#email").html("رسالة الى العملاء");

                    $("#clientID").val("");

                    $("#errorMsg").html("");
                    $("#save").css("background-position", "bottom");
                    $("#clientName").html("");
                    //                    $("#email").html("");
                } else if ($("#for").val() == "searchClient") {
                    $("#clientNo").hide();
                    $("#clientNa").hide();
                    $("#toMails").show();
                    $("#searchBtn").show();
                    $("#email").html("");

                    $("#clientID").val("");

                    $("#errorMsg").html("");
                    $("#save").css("background-position", "bottom");
                    $("#clientName").html("");
                    //                    $("#email").html("");
                }
            }
            function sendMail() {
                var to = $("#email").text();
                var from = document.getElementById("from").value;
                var subject = document.getElementById("subject").value;
                var message = document.getElementById("message").value;
                var file = document.getElementById("file").value;

                //                alert(to);
                //                alert(from);
                //                alert(subject);
                //                alert(message)

                $.ajax({
                    type: "post",
                    url: "<%=context%>/EmailServlet",
                    data: {
                        to: to,
                        from: from,
                        subject: subject,
                        message: message,
                        file: file

                    },
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        //                        alert(jsonString);
                        //                        alert(eqpEmpInfo);
                        if (eqpEmpInfo.status == 'sent') {

                        }
                        if (eqpEmpInfo.status == 'error') {

                        }

                    }
                });

                //                document.MainType_Form.action = "<%=context%>/ProjectServlet?op=saveAvailableUnits";


            }

            function saveOrder(obj) {
                //        alert('order');
                //            $("#clientID").keydown(function() {
                var clientNumber = $(obj).val();
               
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientNumber",
                    data: {
                        clientNumber: clientNumber
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'Ok') {
                            if(info.email != '') {
                                $("#status").val("ok");
                                $("#clientName").html(info.clientName);
                                $("#email").html(info.email);
                                $("#to").val(info.email);
                                $("#errorMsg").html("");
                                $("#clientID").html("");
                                $("#save").css("background-position", "top");
                            } else {
                                $("#errorMsg").html("لا يوجد بريد ألكتروني لهذا العميل");
                                $("#clientName").html(info.clientName);
                                $("#to").val("");
                                $("#save").css("background-position", "bottom");
                                $("#email").html("");
                            }
                        } else if (info.status == 'No') {

                            $("#errorMsg").html("هذا الرقم غير صحيح");
                            $("#to").val("");
                            $("#save").css("background-position", "bottom");
                            $("#clientName").html("");
                            $("#email").html("");
                        }
                    }
                });
                //            });
            }
            function selectAllItems() {
                $('#toMails option').prop('selected', true);
            }
            function receiveEmail() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/EmailServlet?op=receiveEmail",
                    data: {
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("Done");
                        } else if (info.status === 'noMessage') {
                            alert("No New Messages was Found.");
                        } else {
                            alert("Fail");
                        }
                    }
                });
            }
        </script>

        <style >
            a{
                color:blue;
                background-color: transparent;
                text-decoration: none;
                font-size:12px;
                font-weight:bold;
            }
            #frame{
                background-color: #dfdfdf;
                margin: auto;
            }
            #open, #email, #save,#delete,#insert{
                font-size: 12px;
                font-weight: bold;
            }
            .save {
                /*                margin-right: 100px;*/
                width:20px;
                height:20px;
                background-image:url(images/icons/check1.png);
                background-repeat: no-repeat;
                cursor: pointer;


            }
            .close {
                float: right;
                clear: both;
                width:24px;
                height:24px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/close.png);

            }
            .popup_content{ 

                border: none;

                direction:rtl;
                padding:0px;
                margin-top: 10px;
                /*border: 1px solid tomato;*/
                /*background-color: #dfdfdf;*/
                margin-bottom: 5px;

                font:Verdana, Geneva, sans-serif;
                font-size:18px;
                font-weight:bold;
                /*display: none;*/
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
        </style>

    </head>

    <body>
        <input type="button" value="Receive Email" onclick="JavaScript: receiveEmail();" />

        <div id="sms_content" class="popup_content" >
            <!--<form name="email_form">-->
            <%
                String status = (String) request.getAttribute("status");
                if ("ok".equals(status)) {
            %>
            <div style="margin-left: auto;margin-right: auto;color: green;">تم الإرسال بنجاح</div>
            <%}%>
            <%
                if ("error".equals(status)) {
            %>
            <div style="margin-left: auto;margin-right: auto;color: red;">لم يتم الإرسال</div>
            <%}%>

        </div>  

        <div class="login" style="width: 50%;;margin: auto auto;text-align: center">
            <form method="post"  name="emailForm" enctype="multipart/form-data" >
                <table  class="table" style="width: 100%;border: none;margin-left: auto;margin-right: auto;" cellpadding="5" cellspacing="4">
                    <tr align="center" align="center">
                        <td  style="color:#27272A; font-size: 18px;font-weight: bold;width:100% ;border: none;background-color: #f1f1f1;" colspan="3">رسائل إلكترونية</td>
                    <input type="hidden" value="Customer Service" id="from" />
                    </tr>

                    <tr >
                        <td style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">بريد إلكترونى</td>
                        <td width="50%" style="text-align:right;border: none"colspan="2">
                            <select id="for" name="for" onchange="changeContent()" style="font-size: 14px;font-family: arial;">
                                <option value="client">لعميل</option>
                                <option value="allClient">لجميع العملاء</option>
                                <option value="searchClient">بعض العملاء</option>
                            </select>
                            <input type="button" id="searchBtn" onclick="window.open('<%=context%>/ClientServlet?op=getClientsWithDetails&forPopup=true', '_blank', 'status=1,scrollbars=1,width=1100,height=600')" value="بحث"/>
                        </td>
                    </tr>
                    <tr id="clientNo">
                        <td  style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">رقم العميل</td>
                        <td width="70%"style="text-align:right;border: none;"colspan="2">
                            <div style="width: 100%;">

                                <input type="text" size="14" maxlength="20" id="clientID" style="float: right; " onkeyup="saveOrder(this)"  onkeypress="javascript:return isNumber(event)"/>

                                <div id='save' class='save' style='background-position: bottom;display: inline-block'></div>
                                <br/>
                                <div style="color: #f9f9f9; width: 150px; display: inline-block;"><b  id="errorMsg"></b></div>
                                <input type="hidden" id="status" />

                            </div>
                        </td>
                    </tr>
                    <tr id="clientNa">
                        <td  style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">إسم العميل</td>
                        <td width="40%"style="text-align:right;border: none"colspan="2">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientName" style="float: right;"></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#000080; font-size: 14px; width: 30%; font-weight: bold;border: none">من</td>
                         
                        <td style=" border: none;width:30% ">
                            <%=metaMgr.getEmailAddress()%> <input type="radio" value="comEmail" id="from" name="from" style="width: 7%;" onclick="getpassword('comEmail');" checked/> 
                        </td>

                        <td style="border: none;width:30% ">	
                            <%
                                if(usrEmail != null && !usrEmail.isEmpty()){
                            %>
                                   <%=usrEmail%> <input type="radio" value="usrEmail" id="from" name="from" style="width: 7%;" onclick="getpassword('usrEmail');"/>  
                            <%
                                }
                            %>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">إلى</td>
                        <td width="40%"style="text-align:right;border: none"colspan="2">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="email" style="float: right;" name="email"></b>
                            <input type="hidden" id="to" name="to" />
                            <select multiple="true" name="toMails" id="toMails" style="width: 250px;">
                                
                            </select>
                        </td>
                    </tr>



                    <tr>
                        <td  style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">موضوع الرسالة</td>
                        <td style="text-align:right;border: none"colspan="2">
                            <input type="text" size="60" maxlength="60" id="subject" name="subject" style="width: 250px;"/>
                        </td>
                    </tr>
                    <tr>
                        <td  style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">محتوى الرسالة</td>
                        <td style="border: none; text-align:right;"colspan="2">

                            <textarea placeholder="محتوى الرسالة" rows="5" cols="40" name="message" id="message" style="color: #27272A;border: none"></textarea>
                        </td>
                    </tr> 
                    <tr>
                        <td  style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">المرفقات</td>
                        <td style="<%=style%>" class="td"colspan="2">
                            <!--<input type="checkbox" id="checkImage" onclick="JavaScript: changeImageState(this);">-->

                            <input type="file" name="file1"  id="file1" onchange="JavaScript: changePic();">
                            <input type="hidden" name="fileName" id="fileName" value="">
                            <input type="file" name="file2"  id="file2" onchange="JavaScript: changePic();">
                            <input type="file" name="file3"  id="file3" onchange="JavaScript: changePic();">
                            <input type="hidden" name="docType" value="">
                            <input type="hidden" name="docTitle" value="Employee File" id="docTitle">
                            <input type="hidden" name="description" value="Employee File">
                            <input type="hidden" name="faceValue" value="0">
                            <input type="hidden" name="fileExtension" value="" id="fileExtension">
                            <%
                                Calendar c = Calendar.getInstance();
                                Integer iMonth = new Integer(c.get(c.MONTH));
                                int month = iMonth.intValue() + 1;
                                iMonth = new Integer(month);
                            %>
                            <input type="hidden" name="docDate" value="<%=iMonth.toString() + "/" + c.get(c.DATE) + "/" + c.get(c.YEAR)%>">
                            <input type="hidden" name="configType" value="1">
                        </td>
                    </tr>

                    <tr >
                        <td colspan="2" style="border: none"colspan="3" > 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input type="button" value="إرسال" onclick="sendMailss()" />
                        </td>

                    </tr>
                </table>

            </form>

        </div>
    </body>
</html>
