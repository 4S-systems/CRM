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
        tableHeader[2] = "mobile";
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

        <script type="text/javascript">
            $(document).ready(function() {
                changeContent();
            });
            function getDetails(proId) {
                window.navigate('<%=context%>/IssueServlet?op=showProduct&proId=' + proId);
            }
            function view(projectId) {
                //                var proId=$(this).parent().parent().find("#proId").val();
                alert(projectId);
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
            function isNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)){
                    alert("أرقام فقط")
                    return false;
                }
    
                return true;
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
            function submitForm()
            {

                var unitCategory = $("#subProduct").val();

                document.MainType_Form.action = "<%=context%>/SearchServlet?op=SearchForUnits&unitCategory=" + unitCategory;

                document.MainType_Form.submit();
            }
            function submitForm2()
            {

                var unitCategory = $("#unitCategoryId").val();

                document.MainType_Form.action = "<%=context%>/SearchServlet?op=SearchForUnits&unitCategory=" + unitCategory;

                document.MainType_Form.submit();
            }
            function changeContent() {

                if ($("#for").val() == "client") {

                    $("#clientNo").show();
                    $("#clientNa").show();
                    $("#mobileR").show();
                    $("#mobile").html("");
                    $("#toMobiles").hide();
                    $("#searchBtn").hide();

                } else if ($("#for").val() == "allClient") {
                    $("#clientNo").hide();
                    $("#clientNa").hide();
                    $("#toMobiles").hide();
                    $("#searchBtn").hide();
                    $("#mobile").html("رسالة الى العملاء");

                    $("#clientID").val("");
                    $("#mobileR").hide();
                    $("#errorMsg").html("");
                    $("#save").css("background-position", "bottom");
                    $("#clientName").html("");
                    //                    $("#mobile").html("");
                } else if ($("#for").val() == "searchClient") {
                    $("#clientNo").hide();
                    $("#clientNa").hide();
                    $("#toMobiles").show();
                    $("#searchBtn").show();
                    $("#mobile").html("");

                    $("#clientID").val("");
                    $("#mobileR").hide();
                    $("#errorMsg").html("");
                    $("#save").css("background-position", "bottom");
                    $("#clientName").html("");
                    //                    $("#email").html("");
                }
            }
            function reservedUnit() {

                var clientId = $("#clientId").val();
                var unitId = document.getElementById("unitId").value;

                var unitCategoryId = document.getElementById("unitCategoryId").value;

                var budget = document.getElementById("budget").value;
                var period = document.getElementById("period").value;
                var paymentSystem = document.getElementById("paymentSystem").value;
                var paymentPlace = document.getElementById("paymentPlace").value;
                var issueId = document.getElementById("issueId").value;
                
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=saveAvailableUnits",
                    data: {
                        clientId: clientId,
                        unitId: unitId,
                        budget: budget,
                        period: period,
                        unitCategoryId: unitCategoryId,
                        paymentSystem: paymentSystem,
                        paymentPlace: paymentPlace,
                        issueId: issueId

                    },
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        //                        alert(jsonString);
                        //                        alert(eqpEmpInfo);
                        if (eqpEmpInfo.status == 'ok') {
                            submitForm2();
                        } else if (eqpEmpInfo.status == 'no') {

                            alert("error");
                        }


                    }
                });

                //                document.MainType_Form.action = "<%=context%>/ProjectServlet?op=saveAvailableUnits";


            }

            function saveOrder(obj) {
                //        alert('order');

                var clientNumber = $("#clientID").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientNumber",
                    data: {
                        clientNumber: clientNumber
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'Ok') {
                            if(info.mobile != '') {
                                $("#clientName").html(info.clientName);
                                $("#mobile").html(info.mobile);
                                $("#errorMsg").html("");
                                $("#clientID").html("");
                                $("#save").css("background-position", "top");
                            } else {
                                $("#errorMsg").html("لا يوجد رقم موبايل لهذا العميل");
                                $("#clientName").html(info.clientName);
                                $("#to").val("");
                                $("#save").css("background-position", "bottom");
                                $("#mobile").html("");
                            }

                        } else if (info.status == 'No') {

                            $("#errorMsg").html("هذا الرقم غير صحيح");
                            $("#save").css("background-position", "bottom");
                            $("#clientName").html("");
                            $("#mobile").html("");
                        }
                    }
                });

            }
            function selectAllItems() {
                $('#toMobiles option').prop('selected', true);
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
            #open, #mobile, #save,#delete,#insert{
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
            .dd{ 
                /*                border: 1px solid red;*/
                direction:rtl;
                padding:0px;
                margin-top: 10px;
                margin-bottom: 5px;
                margin-left: auto;
                margin-right: auto;


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

        <form name="Email_Form" method="post">

            <div class="login" style="width: 50%;;margin: auto auto;text-align: center">

                <table  border="0px"  style="width:90%;margin-left: auto;margin-right: auto;" class="table" cellpadding="5" cellspacing="4">
                    <tr align="center" align="center">
                        <td colspan="2"  style="color:#000; font-size: 18px;font-weight: bold;width: 100%;border: none;background-color: #f1f1f1;">رسائل قصيرة</td>
                    </tr>

                    <tr id="first">
                        <td style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">رسالة قصيرة</td>
                        <td width="50%" style="text-align:right;border: none">
                            <select id="for" name="for" onchange="changeContent()" style="font-size: 14px;font-family: arial;width: 100px;">
                                <option value="client">لعميل</option>
                                <option value="allClient">لجميع العملاء</option>
                                <option value="searchClient">بعض العملاء</option>
                            </select>
                            <input type="button" id="searchBtn" onclick="window.open('<%=context%>/ClientServlet?op=getClientsWithDetails&forPopup=true', '_blank', 'status=1,scrollbars=1,width=1100,height=600')" value="بحث"/>
                            <br/>
                            <select multiple="true" name="toMobiles" id="toMobiles" style="width: 260px; margin-top: 4px;">
                                
                            </select>
                        </td>
                    </tr>
                    <tr id="clientNo">
                        <td style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">رقم العميل</td>
                        <td width="50%" style="text-align:right;border: none">
                            <div style="width: 100%;">

                                <input type="text" size="12" maxlength="20" id="clientID" style="float: right;" onkeyup="saveOrder(this)" onkeypress="javascript:return isNumber(event)"/>
                                <div id='save' class='save' style='background-position: bottom;display: inline-block' ></div>
                                <br/>
                                <div style=" color: red;width: 150px;display: inline-block"><b  id="errorMsg"></b></div>

                            </div>
                        </td>


                    </tr>
                    <tr id="clientNa">
                        <td style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">إسم العميل</td>
                        <td width="50%" style="text-align:right;border: none">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientName" style="float: right;"></b>
                        </td>
                    </tr>
                    <tr id="mobileR">
                        <td style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">رقم الموبايل</td>
                        <td width="50%" style="text-align:right;border: none">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="mobile" style="float: right;"></b>
                        </td>
                    </tr>
                    </tr>
                    <tr>
                        <td style="color:#000080; font-size: 14px;font-weight: bold;width: 30%;border: none">محتوى الرسالة</td>
                        <td width="50%" style="text-align:right;border: none">

                            <textarea placeholder="محتوى الرسالة" rows="5" cols="30">
                            </textarea>
                        </td>

                    </tr> 




                    <tr>
                        <td colspan="2" style="border: none"> 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input type="submit" value="إرسال" onclick="javascript: reservedUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>  
        </form>


    </body>
</html>
