<%@page import="com.silkworm.Exceptions.NoUserInSessionException"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String[] apartmentAttributes = {"projectName"};
        String[] apartmentListTitles = new String[4];
        int s = apartmentAttributes.length;
        int t = s + 3;
        String attName = null;
        String attValue = null;
        String status = (String) request.getAttribute("status");
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ArrayList<WebBusinessObject> apartmentsList = new ArrayList<WebBusinessObject>();
        Vector<WebBusinessObject> paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
        WebBusinessObject departmentWbo;
        if (managerWbo != null) {
            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
        } else {
            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
        }
        if (departmentWbo != null) {
            apartmentsList = new ArrayList<WebBusinessObject>(projectMgr.getAvailableUnitsFromProject((String) departmentWbo.getAttribute("projectID")));
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String apartmentsNo, title, sSccess, sFail, viewUnit;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            apartmentListTitles[0] = "";
            apartmentListTitles[1] = "Site Name";
            apartmentListTitles[2] = "Status";
            apartmentListTitles[3] = "";
            apartmentsNo = "Apartments No.";
            title = "Apartments List";
            sSccess = "Building Deleted Successfully";
            sFail = "Fail To Delete Building";
            viewUnit = "View Apartment";
        } else {
            align = "center";
            dir = "RTL";
            apartmentListTitles[0] = "";
            apartmentListTitles[1] = "الوحدة";
            apartmentListTitles[2] = "الحالة";
            apartmentListTitles[3] = "";
            apartmentsNo = "عدد الوحدات";
            title = "عرض الوحدات";
            sSccess = "تم حذف المبني بنجاح";
            sFail = "لم يتم الحذف";
            viewUnit = "عرض الوحدة";
        }
    %>
    <HEAD>
        <TITLE>Buildings List</TITLE>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function() {
                oTable = $('#apartments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            function changeStatus(id, oldStatus, newStatus, type) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=changeApartmentStatusByAjax",
                    data: {
                        id: id,
                        oldStatus: oldStatus,
                        newStatus: newStatus
                    }
                    ,
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("تم تغيير الحالة");
                            $("#currentStatus" + id).html(info.currentStatusName);
                            if (type == 'hide') {
                                $("#reserve" + id).attr("disabled", "disabled");
                                $("#sell" + id).attr("disabled", "disabled");
                                $("#hide" + id).attr("disabled", "disabled");
                                $("#show" + id).removeAttr("disabled");
                                $("#status" + id).html("غير معروضة");
                                $("#status" + id).css("color", "black");
                            } else if (type == 'show') {
                                $("#reserve" + id).removeAttr("disabled");
                                $("#sell" + id).removeAttr("disabled");
                                $("#hide" + id).removeAttr("disabled");
                                $("#show" + id).attr("disabled", "disabled");
                                $("#status" + id).html("متاحة");
                                $("#status" + id).css("color", "green");
                            }
                        } else if (info.status == 'faild') {
                            alert("لم يتم تغيير الحالة");
                        }
                    }
                });
            }
            function reservedUnit() {
                var clientId = $("#clientId").val();
                var unitId = document.getElementById("unitId").value;
                var budget = document.getElementById("budget").value;
                var period = document.getElementById("period").value;
                var paymentSystem = document.getElementById("paymentSystem").value;
                var paymentPlace = document.getElementById("paymentPlace").value;
                var parentId = document.getElementById("parentId").value;
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=saveAvailableUnits",
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
                    success: function(jsonString) {
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
                            $("#paymentPlace").val("");
                            $("#parentId").val("");
                            $("#reservedPlace").html("");
                            $("#clientNameReserve").html("");
                            $("#status" + unitId).html("محجوزة");
                            $("#status" + unitId).css("color", "red");
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
                        issueId: parentId

                    },
                    success: function(jsonString) {
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
                            $("#reserve" + unitId).attr("disabled", "disabled");
                            $("#sell" + unitId).attr("disabled", "disabled");
                            $("#hide" + unitId).attr("disabled", "disabled");
                            $("#show" + unitId).attr("disabled", "disabled");
                            $("#status" + unitId).html("مباعة");
                            $("#status" + unitId).css("color", "blue");
                        } else if (eqpEmpInfo.status == 'no') {
                            alert("error");
                        }
                    }
                });
            }
            function popup(proId, busObjId, projectName) {
                $('#reserveDialog').bPopup({modal: false});
                $('#reserveDialog').css("display", "block");
                $("#reservedPlace").html(projectName);
                $("#unitId").val(proId);
                $("#parentId").val(busObjId);
            }
            function popupSell(proId, busObjId, projectName) {
                $('#sellDialog').bPopup({modal: false});
                $('#sellDialog').css("display", "block");
                $("#sellPlace").html(projectName);
                $("#unitIdSell").val(proId);
                $("#parentIdSell").val(busObjId);
            }
            function closeSellPopup(obj) {
                $("#sellDialog").bPopup().close();
                $("#sellDialog").css("display", "none");
            }
            function closeReservePopup(obj) {
                $("#reserveDialog").bPopup().close();
                $("#reserveDialog").css("display", "none");
            }
            function getClient(obj) {
                var clientNumber = $("#clientCodeSell").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientNameByNo",
                    data: {
                        clientNumber: clientNumber
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            $("#clientNameSell").html(info.name);
                            $("#errorMsgSell").html("");
                            $("#clientIdSell").val(info.id);
                        } else if (info.status == 'No') {
                            $("#errorMsgSell").html("هذا الرقم غير صحيح");
                            $("#clientNameSell").html("");
                        }
                    }
                });
            }
            function saveOrder(obj) {
                var clientNumber = $("#clientCode").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientNameByNo",
                    data: {
                        clientNumber: clientNumber
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            $("#clientNameReserve").html(info.name);
                            $("#errorMsgReserve").html("");
                            $("#clientId").val(info.id);

                        } else if (info.status == 'No') {
                            $("#errorMsgReserve").html("هذا الرقم غير صحيح");
                            $("#clientNameReserve").html("");
                        }
                    }
                });

            }
        </script>
        <style type="text/css">
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
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
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
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: #ffffff;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #cc0000;
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .login-input {
                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #000;
                font-size: 13px;
                cursor: auto;
                text-shadow: 0 1px black;
                background: #2b3e5d;
                border: 1px solid #ffffff;
                border-top-color: #0d1827;
                border-radius: 4px;
                background: rgb(249,252,247); /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
        </style>
    </HEAD>
    <body>
        <fieldset class="set" style="width:96%;" >
            <br>
            <div style="width: 100%; text-align: center;"> <b> <font size="3" color="red"> <%=apartmentsNo%> : <%=apartmentsList.size()%> </font></b></div> 
            <br/>
            <%
                if (status != null) {
            %>
            <table width="50%" align="center">
                <tr>
                    <%
                        if (status.equalsIgnoreCase("ok")) {
                    %>
                    <td class="bar">
                        <b><font color="blue" size="3"><%=sSccess%></font></b>
                    </td>
                    <%
                    } else {
                    %>
                    <td class="bar">
                        <b><font color="red" size="3"><%=sFail%></font></b>
                    </td>
                    <%
                        }
                    %>
                </tr>
            </table>
            <br>
            <%
                }
            %>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="apartments" style="width:100%;">
                    <thead>
                        <tr>
                          
                            <%
                                for (int i = 0; i < t; i++) {
                            %>                
                            <th>
                                <B><%=apartmentListTitles[i]%></B>
                            </th>
                            <%
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (int x=0;x<apartmentsList.size();x++) {
                                WebBusinessObject apartmentWbo =  apartmentsList.get(x);
                        %>
                        <tr>
                            <td>
                                <%=x+1%>
                            </td>
                            <%                                for (int i = 0; i < s; i++) {
                                    attName = apartmentAttributes[i];
                                    attValue = (String) apartmentWbo.getAttribute(attName);
                            %>
                            <td>
                                <div>
                                    <b><%=attValue%></b>
                                </div>
                            </td>
                            <%
                                }
                            %>
                            <td>
                                <%
                                    String sUniStatus = "", color = "";
                                    String unitStatus = (String) apartmentWbo.getAttribute("statusName");
                                    if (unitStatus != null) {
                                        if (unitStatus.equalsIgnoreCase("8")) {
                                            sUniStatus = "متاحة";
                                            color = "green";
                                        } else if (unitStatus.equalsIgnoreCase("9")) {
                                            sUniStatus = "محجوزة";
                                            color = "red";
                                        } else if (unitStatus.equalsIgnoreCase("10")) {
                                            sUniStatus = "مباعة";
                                            color = "blue";
                                        } else if (unitStatus.equalsIgnoreCase("28")) {
                                            sUniStatus = "غير معروضة";
                                            color = "black";
                                        }
                                    }%>
                                <b style="color: <%=color%>" id="status<%=apartmentWbo.getAttribute("projectID")%>"><%=sUniStatus%></b>
                            </td>
                            <td>
                                <input type="button" id="reserve<%=apartmentWbo.getAttribute("projectID")%>" value="حجز"
                                       onclick="JavaScript: popup('<%=apartmentWbo.getAttribute("projectID")%>', '<%=apartmentWbo.getAttribute("mainProjId")%>', '<%=apartmentWbo.getAttribute("projectName")%>');"
                                       <%=unitStatus.equalsIgnoreCase("8") || unitStatus.equalsIgnoreCase("9") ? "" : "disabled"%> />
                                <input type="button" id="sell<%=apartmentWbo.getAttribute("projectID")%>" value="بيع"
                                       onclick="JavaScript: popupSell('<%=apartmentWbo.getAttribute("projectID")%>', '<%=apartmentWbo.getAttribute("mainProjId")%>', '<%=apartmentWbo.getAttribute("projectName")%>');"
                                       <%=unitStatus.equalsIgnoreCase("8") || unitStatus.equalsIgnoreCase("9") ? "" : "disabled"%> />
                                <input type="button" id="hide<%=apartmentWbo.getAttribute("projectID")%>" value="أخفاء"
                                       onclick="JavaScript: changeStatus('<%=apartmentWbo.getAttribute("projectID")%>', '<%=unitStatus%>', '28', 'hide')"
                                       <%=unitStatus.equalsIgnoreCase("8") ? "" : "disabled"%> />
                                <input type="button" id="show<%=apartmentWbo.getAttribute("projectID")%>" value="أظهار"
                                       onclick="JavaScript: changeStatus('<%=apartmentWbo.getAttribute("projectID")%>', '<%=unitStatus%>', '8', 'show')"
                                       <%=unitStatus.equalsIgnoreCase("28") ? "" : "disabled"%> />
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <br/><br/>
        </fieldset>
        <div id="reserveDialog" style="width: 35%;display: none;position: fixed;margin-left: auto;margin-right: auto" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeReservePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">حجز وحدة</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول المبيعات</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">كود الوحدة</td>
                        <td width="70%"style="text-align:right;"><b id="reservedPlace"></b>
                            <input type="hidden" id="unitId" name="unitId"/>
                            <input type="hidden" id="parentId" name="parentId"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">رقم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientCode"  style='width:170px;float: right;' onkeyup="saveOrder(this)"/>

                                <div style="color: red;width: 80px;"><b  id="errorMsgReserve"></b></div>

                            </div>
                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">إسم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <b id="clientNameReserve" style="float: right;"></b>
                        </td>
                    </tr>



                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مدة الحجز (بالساعة)</td>
                        <td width="70%"style="text-align:right;">
                            <input type="number" size="7" maxlength="7" id="period" name="period" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">مقدم الحجز</td>
                        <td width="70%"style="text-align:right;">
                            <input type="number" size="7" maxlength="7" id="budget" name="budget" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">نظام الدفع</td>
                        <td width="70%"style="text-align:right;">
                            <select name="paymentSystem" id="paymentSystem" style='width:170px;font-size:16px;'>
                                <option value="فورى">فورى</option>
                                <option value="تقسيط">تقسيط</option>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">مكان الدفع</td>
                        <td width="70%"style="text-align:right;">
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
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input type="submit" value="حجز الأن" onclick="javascript: reservedUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
        <div id="sellDialog" style="width: 35%;display: none;position: fixed;margin-left: auto;margin-right: auto" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeSellPopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">بيع وحدة</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول المبيعات</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">كود الوحدة</td>
                        <td width="70%"style="text-align:right;"><b id="sellPlace"></b>
                            <input type="hidden" id="unitIdSell" name="unitIdSell"/>
                            <input type="hidden" id="parentIdSell" name="parentIdSell"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">رقم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <div style="width: 100%;">

                                <input type="number" size="7" maxlength="7" id="clientCodeSell"  style='width:170px;float: right;' onkeyup="getClient(this)"/>

                                <div style="color: red;width: 80px;"><b  id="errorMsgSell"></b></div>

                            </div>
                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">إسم العميل</td>
                        <td width="70%"style="text-align:right;">
                            <b id="clientNameSell" style="float: right;"></b>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="clientIdSell" name="clientId"/>
                            <input type="submit" value="بيع" onclick="javascript: sellUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
    </body>
</html>
