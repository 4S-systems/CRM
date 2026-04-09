<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    Vector<WebBusinessObject> mainCatsTypes = new Vector();

    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

    Vector dataUnit = (Vector) request.getAttribute("dataUnit");
    Vector<WebBusinessObject> paymentPlace = new Vector();
    paymentPlace = (Vector) request.getAttribute("paymentPlace");
    mainCatsTypes = (Vector) request.getAttribute("data");
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String[] tableHeader = new String[6];

    String title, Show, unit, unitCategoryId = "";
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        title = "Equipment Tree";
        Show = "Show Tree";
        unit = "unit";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        title = "بحث عن وحده سكنيه";
        unit = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
        Show = "&#1576;&#1581;&#1579;";
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
                window.navigate('<%=context%>/ProjectServlet?op=showImage&projectId=' + projectId);
            }
            function getAttached(id)
            {
                $('#images').html('<iframe id="frame" src="<%=context%>/ProjectServlet?op=showImage&projectId=' + id + ' " width="100%" height="400" ></iframe>');
                $('#images').bPopup({modal:false});
            }

            function popup(obj) {

                $(obj).bind('click', function(e) {
                    e.preventDefault();
                    $('#sms_content').bPopup({modal:false});
                    $('#sms_content').css("display", "block");
                    $("#reservedPlace").html($(this).parent().parent().find("#msg").html());
                    $("#unitId").val($(this).parent().parent().find("#proId").val());
                    $("#issueId").val($(this).parent().parent().find("#busObjId").val());
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
                        if (result != "") {
                            var data = result.split("<element>");
                            var idAndName = "";

                            for (var i = 0; i < data.length; i++) {
                                idAndName = data[i].split("<subelement>");

                                resultData.options[resultData.options.length] = new Option(idAndName[1], idAndName[0]);
                            }
                        } else {
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
                document.MainType_Form.action = "<%=context%>/SearchServlet?op=SearchForSingleUnits&unitCategory=" + unitCategory;
                document.MainType_Form.submit();
            }
            function submitForm2()
            {
                var unitCategory = $("#unitCategoryId").val();
                document.MainType_Form.action = "<%=context%>/SearchServlet?op=SearchForSingleUnits&unitCategory=" + unitCategory;
                document.MainType_Form.submit();
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
                        if (eqpEmpInfo.status == 'ok') {
                            submitForm2();
                        } else if (eqpEmpInfo.status == 'no') {

                            alert("error");
                        }
                    }
                });
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
                            $("#clientName").html(info.clientName);
                            $("#errorMsg").html("");

                            $("#save").css("background-position", "top");
                            $("#clientId").val(info.clientId);

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
                            <img src="images/house.JPG"></img>
                        </TD>
                    </TR>
                    <tr ><td colspan="2" style="border: none"></td></tr>
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


                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%">
                            <B><%=tableHeader[0]%></B>

                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                            
                        </TH>

                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                            <B><%=tableHeader[1]%></B>

                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                            <B>رقم الوحدة</B>

                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                            <B><%=tableHeader[4]%></B>

                        </TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="3%">
                            <B><%=tableHeader[5]%></B>
                        </TH>
                        <!--TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="3%">
                            <B></B>
                        </TH-->



                    </tr>
                    <tbody  id="planetData2">  


                        <%

                            Enumeration e = dataUnit.elements();

                            WebBusinessObject wbo = new WebBusinessObject();

                            while (e.hasMoreElements()) {

                                wbo = (WebBusinessObject) e.nextElement();
                        %>

                        <tr style="padding: 1px;">

                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" width="10%">

                                <%if (wbo.getAttribute("projectName") != null) {%>
                                <b id="msg"><%=wbo.getAttribute("projectName")%></b>
                                <input type="hidden" id="proId" value="<%=wbo.getAttribute("projectID")%>"/>
                                <input type="hidden" id="busObjId" value="<%=wbo.getAttribute("busObjId")%>"/>
                                <%} else {%>
                                <b></b>
                                <%}%>

                            </TD>
                            <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;" width="5%">
<img src="images/house.JPG"/>
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
                            <!--TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding: 5px; font-size: 12px;width: 3%" >
                                <input type="button" value="مشاهدة" id="reservedBtn" onclick="getAttached(<%=wbo.getAttribute("projectID")%>)" />
                            </TD-->

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
                        <td width="30%" style="color: #000;border: none;" class="excelentCell formInputTag">مسئول المبيعات</td>
                        <td width="70%" style="text-align:right;background: #f1f1f1">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #000;" class="excelentCell formInputTag">كود الوحدة</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1"><b id="reservedPlace"></b>
                            <input type="hidden" id="unitId" name="unitId"/>
                            <input type="hidden" id="issueId" name="issueId"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #000;" class="excelentCell formInputTag">رقم العميل</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientID" style="float: right;" onkeyup="saveOrder(this)"/>
                                <div id='save' class='save' style='background-position: bottom;' ></div>
                                <div style="color: red;width: 80px;"><b  id="errorMsg"></b></div>

                            </div>
                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color: #000;" class="excelentCell formInputTag">إسم العميل</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="clientName" style="float: right;"></b>
                        </td>
                    </tr>



                    <tr>
                        <td width="30%" style="color: #000;" class="excelentCell formInputTag">مدة الحجز (بالساعة)</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <input type="number" size="7" maxlength="7" id="period" name="period"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #000;" class="excelentCell formInputTag">مقدم الحجز</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <input type="number" size="7" maxlength="7" id="budget" name="budget"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color: #000;" class="excelentCell formInputTag">نظام الدفع</td>
                        <td width="70%"style="text-align:right;background: #f1f1f1">
                            <select name="paymentSystem" id="paymentSystem">
                                <option value="فورى">فورى</option>
                                <option value="تقسيط">تقسيط</option>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td width="30%" style="color: #000;" class="excelentCell formInputTag">مكان الدفع</td>
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
                        <td colspan="2" style="color: #000;" class="excelentCell formInputTag"> 
                            <input type="text" id="clientId" name="clientId"/>
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
