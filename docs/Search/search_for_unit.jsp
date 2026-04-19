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
    String status = (String) request.getAttribute("Status");
    //  String Name = (String) request.getAttribute("mainName");
    // Vector brands = new Vector();
    // brands = (Vector) request.getAttribute("brands");

    // String doubleName = (String) request.getAttribute("name");
    Vector<WebBusinessObject> mainCatsTypes = new Vector();


    HttpSession s = request.getSession();


    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");






    Vector dataUnit = (Vector) request.getAttribute("dataUnit");
    Vector<WebBusinessObject> paymentPlace = new Vector();
    paymentPlace = (Vector) request.getAttribute("paymentPlace");
    mainCatsTypes = (Vector) request.getAttribute("data");
    String doubleName = (String) request.getAttribute("name");
    Vector brands = new Vector();
    brands = (Vector) request.getAttribute("brands");
    String Name = (String) request.getAttribute("mainName");
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

        <script type="text/javascript">
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
                $('#images').bPopup({modal:false});
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
                    $('#sms_content').bPopup({modal:false});
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
            function reservedUnit() {

                ////                alert($("#unitCategoryId").val());
                //                var id = document.getElementById("subProduct").value;
                //                var unitDes = $("#unitDes").val();
                //                alert('<%=unitCategoryId%>');
                //                var unitCategory = $("#subProduct").val();
                //                alert(unitCategory);




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
            function getUnits() {

                var unitDes = $("#unitDes").val();

                var unitCategory = $("#subProduct").val();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/SearchServlet?op=SearchForUnits",
                    data: {
                        unitDes: unitDes,
                        unitCategory: unitCategory

                    },
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);


                    }
                });

            }
            function saveOrder(obj) {


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
                            $("#clientName").html(info.clientName);
                            $("#errorMsg").html("");

                            $("#save").css("background-position", "top");
                            $("#clientId").val(info.clientId);
                            //                            alert($("#clientId").val());

                        } else if (info.status == 'No') {

                            $("#errorMsg").html("هذا الرقم غير صحيح");
                            $("#save").css("background-position", "bottom");
                            $("#clientName").html("");
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
        </style>

    </head>

    <body>

        <form name="MainType_Form" method="post">

            <fieldset class="set" style="width:100%;border-color: #006699;" >
                <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%></font></TD>
                    </TR>
                </TABLE>
                <br>

                <table ID="tableSearch" class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="3" CELLSPACING="1" width="50%">
                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;font-size:15px;">
                            <font  SIZE="2" COLOR="#F3D596"><b>نوع الإستثمار</b></font>
                        </TD>

                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;color:#000000;font-size:15px;background-color: #EDEDED;text-align: right;"id="CellData" >
                            <SELECT name='mainProduct' id='mainProduct' style='width:170px;font-size:16px;' onchange="getSubProduct(this.value)">
                                <option>----</option>
                                <%for (WebBusinessObject Wbo : mainCatsTypes) {
                                        String productName = (String) Wbo.getAttribute("projectName");
                                        String productId = (String) Wbo.getAttribute("projectID");%>
                                <option value='<%=productId%>'><b id="projectN"><%=productName%></b></option>

                                <%}%>
                            </select>
                        </TD>
                    </TR>
                    <tr><td colspan="3" style="height: 5px;"></td></tr>
                    <TR rowspan="2">
                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;font-size:17px;">
                            <font  SIZE="2" COLOR="#F3D596"><b>الفنة</b></font>
                        </TD>

                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;color:#000000;font-size:15px;background-color: #EDEDED;text-align: right;"  >
                            <SELECT name='subProduct' id='subProduct' style='width:170px;font-size:16px;' disabled="disabled">
                                <option>----</option>
                            </select>
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL>
                                <p><b><%=unit%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>

                            <input type="TEXT"  id="unitDes" name="unitDes" />

                        </TD>
                    </TR>
                    <tr ><td colspan="3"></td></tr>
                    <tr>
                        <td colspan="2" style="border: none;">
                            <button id="showBtn" onclick="JavaScript:submitForm();" class="button" style="width:100px " disabled="disabled"> <%=Show%></button>
                        </td>
                    </tr>
                </table>
                <%if (dataUnit != null && !dataUnit.isEmpty()) {
                        unitCategoryId = (String) request.getAttribute("unitCategoryId");
                %>
                <input type="hidden" id="unitCategoryId" name="unitCategoryId" value="<%=unitCategoryId%>" />
                <TABLE class="blueBorder"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="90%" CELLPADDING="0" cellspacing="0" style="margin-top: 15px;">
                    <tr >


                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="20%">
                            <B><%=tableHeader[0]%></B>

                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="3%">
                            <B><%=tableHeader[2]%></B>

                        </TH>

                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                            <B><%=tableHeader[1]%></B>

                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                            <B><%=tableHeader[3]%></B>

                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                            <B><%=tableHeader[4]%></B>

                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="3%">
                            <B><%=tableHeader[5]%></B>
                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="3%">
                            <B></B>
                        </TH>



                    </tr>
                    <tbody  id="planetData2">  


                        <%

                            Enumeration e = dataUnit.elements();

                            WebBusinessObject wbo = new WebBusinessObject();

                            while (e.hasMoreElements()) {

                                wbo = (WebBusinessObject) e.nextElement();
                        %>

                        <tr style="padding: 1px;">

                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" width="20%">

                                <%if (wbo.getAttribute("projectName") != null) {%>
                                <b id="msg"><%=wbo.getAttribute("projectName")%></b>
                                <input type="hidden" id="proId" value="<%=wbo.getAttribute("projectID")%>"/>
                                <input type="hidden" id="busObjId" value="<%=wbo.getAttribute("busObjId")%>"/>
                                <%} else {%>
                                <b></b>
                                <%}%>

                            </TD>
                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" width="20%">

                                <%if (wbo.getAttribute("projectDesc") != null) {%>
                                <b><%=wbo.getAttribute("projectDesc")%></b>
                                <%} else {%>
                                <b></b>
                                <%}%>
                            </TD>
                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" width="5%">

                                <%if (wbo.getAttribute("coordinate") != null) {%>
                                <b><%=wbo.getAttribute("coordinate")%></b>
                                <%} else {%>
                                <b></b>
                                <%}%>

                            </TD>

                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" width="5%">

                                <%if (wbo.getAttribute("optionThree") != null) {%>
                                <b><%=wbo.getAttribute("optionThree")%></b>
                                <%} else {%>
                                <b></b>
                                <%}%>

                            </TD>
                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; cursor: pointer;font-size: 12px;" width="3%" onclick="getDetails(<%=wbo.getAttribute("projectID")%>)">

                                <%
                                    String UniStatus = "", color = "";
                                    String unitStatus = (String) wbo.getAttribute("statusName");
                                    if (wbo.getAttribute("statusName") != null) {


                                        if (unitStatus.equalsIgnoreCase("8")) {
                                            UniStatus = "متاحة";
                                            color = "green";
                                        } else if (unitStatus.equalsIgnoreCase("9")) {
                                            UniStatus = "محجوزة";
                                            color = "red";
                                        } else if (unitStatus.equalsIgnoreCase("10")) {
                                            UniStatus = "مباعة";
                                            color = "blue";
                                        }
                                    }%>
                                <b style="color: <%=color%>"><%=UniStatus%></b>

                            </TD>
                            <%if (unitStatus.equalsIgnoreCase("8")) {%>
                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;width: 3%" >
                                <input type="button" value="حجز" id="reservedBtn" onclick="popup(this)" />
                            </TD>
                            <%} else {%>
                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;width: 3%">

                            </TD>
                            <%}%>
                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;width: 3%" >
                                <input type="button" value="مشاهدة" id="reservedBtn" onclick="getAttached(<%=wbo.getAttribute("projectID")%>)" />
                            </TD>

                            <!--<TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" >-->
                            <!--                                <div id='save' class='save' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='saveOrder(this)'></div>
                            
                                                        </TD>
                                                        <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" >
                                                            <div id='save' class='save' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='saveOrder(this)'></div>
                            
                                                        </TD>-->
                        </tr>


                        <%                            }

                        %>

                    </tbody>

                </TABLE>
                <% }%> 

            </fieldset>
            <div id="sms_content" class="popup_content" >
                <!--<form name="email_form">-->

                <table align="right" border="0px"  style="width:600px;" class="table" >
                    <tr align="center" align="center">
                        <td colspan="2"  class="blueBorder blueHeaderTD" style="font-size:18px;">حجز وحدة</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #27272A;border: none;" class="excelentCell formInputTag">مسئول المبيعات</td>
                        <td width="70%" style="text-align:right;background: #f1f1f1">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #27272A;" class="excelentCell formInputTag">كود الوحدة</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1"><b id="reservedPlace"></b>
                            <input type="hidden" id="unitId" name="unitId"/>
                            <input type="hidden" id="issueId" name="issueId"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #27272A;" class="excelentCell formInputTag">رقم العميل</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientID" style="float: right;" onkeyup="saveOrder(this)"/>
                                <div id='save' class='save' style='background-position: bottom;' ></div>
                                <div style="color: red;width: 80px;"><b  id="errorMsg"></b></div>

                            </div>
                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color: #27272A;" class="excelentCell formInputTag">إسم العميل</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientName" style="float: right;"></b>
                        </td>
                    </tr>



                    <tr>
                        <td width="30%" style="color: #27272A;" class="excelentCell formInputTag">مدة الحجز (بالساعة)</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <input type="number" size="7" maxlength="7" id="period" name="period"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #27272A;" class="excelentCell formInputTag">مقدم الحجز</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <input type="number" size="7" maxlength="7" id="budget" name="budget"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #27272A;" class="excelentCell formInputTag">نظام الدفع</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <select name="paymentSystem" id="paymentSystem">
                                <option value="فورى">فورى</option>
                                <option value="تقسيط">تقسيط</option>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td width="30%" style="color: #27272A;" class="excelentCell formInputTag">مكان الدفع</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <!--                            <input type="text" size="30" id="paymentPlace" name="paymentPlace" maxlength="30" width="200"/>-->
                            <SELECT name='paymentPlace' id='paymentPlace' style='width:170px;font-size:16px;'>
                                <%if (paymentPlace != null && !paymentPlace.isEmpty()) {

                                %>
                                <%for (WebBusinessObject Wbo : paymentPlace) {
                                        String productName = (String) Wbo.getAttribute("projectName");
                                        String productId = (String) Wbo.getAttribute("projectID");%>
                                <option value='<%=productName%>'><%=productName%></option>

                                <%}
                                } else {%>
                                <option>لم يتم العثور على فروع</option>
                                <%}%>
                            </select>
                        </td>
                    </tr>



                    <tr>
                        <td colspan="2" style="color: #27272A;" class="excelentCell formInputTag"> 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input type="submit" value="حجز الأن" onclick="javascript: reservedUnit(this)"/>
                        </td>

                    </tr>
                </table>

                <!--            </form>-->
            </div>  
        </form>

        <div id="images"style="width: 40%;"></div>
    </body>
</html>
