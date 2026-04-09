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

    Vector<WebBusinessObject> jobs = new Vector();
    jobs = (Vector) request.getAttribute("jobs");
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
    String open, add, deleteProjectLabel, geographicLoc, updateProject, attachedImage, unitCategoryId = "";
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
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
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        title = "المنتجات";
        unit = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
        Show = "&#1576;&#1581;&#1579;";
        EquipmentRow = " &#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;";
        selectMain = "&#1571;&#1582;&#1578;&#1585; &#1606;&#1608;&#1593; &#1585;&#1574;&#1610;&#1587;&#1610;";
        link1 = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        link2 = "&#1593;&#1585;&#1590; &#1571;&#1582;&#1585; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        link3 = "&#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
        link4 = "&#1575;&#1604;&#1582;&#1591;&#1607;";
        link5 = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        M1 = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
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
        M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
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
            function getDetails(proId) {
                window.navigate('<%=context%>/IssueServlet?op=showProduct&proId=' + proId);
            }
            function view(projectId) {
                //                var proId=$(this).parent().parent().find("#proId").val();

                window.navigate('<%=context%>/ProjectServlet?op=showImage&projectId=' + projectId);
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
                if ($("#status").val() == "ok" || $("#for").val() == "allClient") {
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

                    document.emailForm.action = "<%=context%>/EmailServlet?op=sendMail&fileExtension=" + fileExt;
                    document.emailForm.submit();

                } else {
                    alert("عميل غير موجود");
                    return false;
                }

            }
            function printReport2(obj) {

                document.emailForm.action = "<%=context%>/ReportsServlet?op=customer2";
                document.emailForm.submit();

            }
            function printReport3(obj) {
                document.emailForm.action = "<%=context%>/ReportsServlet?op=clientAgeGroupReport";
                document.emailForm.submit();

            }
            function printReport4(obj) {

                document.emailForm.action = "<%=context%>/ReportsServlet?op=getClientsReportByJob";
                document.emailForm.submit();

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
                    $("#email").html("");
                }
                if ($("#for").val() == "allClient") {
                    $("#clientNo").hide();
                    $("#clientNa").hide();
                    $("#email").html("رسالة الى العملاء");

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
                var clientNumber = $("#clientID").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientName",
                    data: {
                        clientNumber: clientNumber
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'Ok') {


                            //                            alert(jsonString);
                            $("#status").val("ok");
                            $("#clientName").html(info.clientName);
                            $("#email").html(info.email);
                            $("#to").val(info.email);
                            $("#errorMsg").html("");
                            $("#clientID").html("");
                            $("#save").css("background-position", "top");
                            //                            $("#clientId").val(info.clientId);
                            //                            alert($("#clientId").val());

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
            var dp_cal1, dp_cal12;
            window.onload = function() {
                dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('beginDate'));
                dp_cal12 = new Epoch('epoch_popup', 'popup', document.getElementById('endDate'));
            };

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
        </style>

    </head>

    <body>

        <div class="popup_content">
            <!--<form name="email_form">-->

            <form method="post"  name="emailForm">
                <table  border="0px"  style="width:40%;">

                    <tr >
                        <td width="20%" style="color: #000;border: none;" class="excelentCell formInputTag">من تاريخ</td>
                        <td  style="text-align:right;background: #f1f1f1">
                            <input id="beginDate" name="beginDate" type="text" ><img src="images/showcalendar.gif" > 
                        </td>
                        <td style="text-align:right;background: #f1f1f1">

                    <center> <a href="#" onclick="printReport2(this)"style="text-align: center;">عرض التقرير</a></center>
                    </td>
                    </tr>
                    <tr >
                        <td width="20%" style="color: #000;border: none;" class="excelentCell formInputTag">الفئة العمرية</td>
                        <td style="text-align:right; font-weight: bold; font-size: 12px; color: black;" class="excelentCell formInputTag" >
                            <div style="display: block;clear: both;">
                                <input type="radio" name="age" value="20-30" id="age" checked="true"/>  <font size="2" color="#005599"><b>20-30</b></font>
                                <input type="radio" name="age" value="30-40" id="age" />  <font size="2" color="#005599"><b>30-40</b></font>
                            </div>
                            <div style="display: block;clear: both;">
                                <span><input type="radio" name="age" value="40-50" id="age" />  <font size="2" color="#005599"><b>40-50</b></font></span>
                                <span><input type="radio" name="age" value="50-60" id="age" />  <font size="2" color="#005599"><b>50-60</b></font></span>
                            </div>
                        </td>
                        <td style="text-align:right;background: #f1f1f1">

                    <center> <a href="#" onclick="printReport3(this)"style="text-align: center;">عرض التقرير</a></center>
                    </td>
                    </tr>
                    <tr>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="20%">
                            <LABEL FOR="job">
                                <p><b>المهنة<font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </td>
                        <td style="text-align:right; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" >
                            <SELECT name="job" id="job" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">
                                <%  if (jobs != null && !jobs.isEmpty()) {%>

                                <OPTION value="all">---الكل---</OPTION>
                                    <%

                                        for (WebBusinessObject wbo2 : jobs) {%>
                                <OPTION value="<%=wbo2.getAttribute("tradeName")%>"><%=wbo2.getAttribute("tradeName")%></OPTION>

                                <%
                                        }


                                    }
                                %>
                            </SELECT>
                        </td>
                        <td style="text-align:right;background: #f1f1f1">

                    <center> <a href="#" onclick="printReport4(this)"style="text-align: center;">عرض التقرير</a></center>
                    </td>
                    </tr>
                </table>

            </form>
        </div>  

    </body>
</html>
