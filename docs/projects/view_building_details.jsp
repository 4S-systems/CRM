<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />
    <head>
        <link rel="stylesheet" href="css/demo_table.css">    
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jquery.carouFredSel-6.2.0.js"></script>
        <script type="text/javascript" src="js/jquery.transit.min.js"></script>
        <script type="text/javascript" src="js/jquery.mousewheel.min.js"></script>
        <link rel="stylesheet" href="css/jquery-ui.css"/>
    </head>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        HttpSession s = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject buildingWbo = (WebBusinessObject) request.getAttribute("buildingWbo");
        WebBusinessObject projectWbo = (WebBusinessObject) request.getAttribute("projectWbo");
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        ArrayList<WebBusinessObject> customersList = (ArrayList<WebBusinessObject>) request.getAttribute("customersList");
        ArrayList<WebBusinessObject> garagesList = (ArrayList<WebBusinessObject>) request.getAttribute("garagesList");
//        String statusName = (String) statusWbo.getAttribute("statusName");
//        if (statusWbo != null && statusWbo.getAttribute("statusName") != null) {
//            if (statusName.equalsIgnoreCase("8")) {
//                unitStatusImage = "available_house.JPG";
//                unitStatusTtile = "متاحة";
//            } else if (statusName.equalsIgnoreCase("9")) {
//                unitStatusImage = "reserved_house.JPG";
//                unitStatusTtile = "محجوزة";
//            } else if (statusName.equalsIgnoreCase("10")) {
//                unitStatusImage = "house.JPG";
//                unitStatusTtile = "مباعة";
//            } else if (statusName.equalsIgnoreCase("33")) {
//                unitStatusImage = "reserved_house.JPG";
//                unitStatusTtile = "حجز مرتجع";
//            }
//        }
        String stat = (String) request.getSession().getAttribute("currentMode");
        Vector imagePath = (Vector) request.getAttribute("imagePath");
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        ArrayList<WebBusinessObject> prevList = securityUser.getComplaintMenuBtn();
        boolean displayEdit = false;
        for (WebBusinessObject prevWbo : prevList) {
            if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("EDIT_NAME")) {
                displayEdit = true;
            }
        }

        String cancel_button_label;
        String align = null;
        String dir = null;
        String style = null, title;
        if (stat.equals("En")) {
            align = "center";
            dir = "Ltr";
            style = "text-align:left";
            title = "View Building Details";
            cancel_button_label = "Cancel ";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "عرض تفاصيل العمارة";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
        }
    %>
    <script type="text/javascript">
        $(function () {
            $("#foo").carouFredSel({
                auto: false,
                transition: true,
                mousewheel: true,
                prev: "#foo_prev",
                next: "#foo_next"
            });
        });
        $(document).ready(function () {
            $('#customersList').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[10], [10]],
                iDisplayLength: 10,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
            })

            //-------------Recycle bin -------------
            $("#recyclebin").draggable({axis: "y"});
            $("#recyclebin").droppable({
                accept: ".su_cont_left",
                activeClass: "recyclebinactive",
                hoverClass: "recyclebinactive",
                drop: function (event, ui) {
                    dropToRrcycleSellGarage(event);
                    $("#recyclebin").addClass("recyclebinfill");
                }
            });
        });

        function cancelForm()
        {
            document.UNIT_FORM.action = "<%=context%>/ProjectServlet?op=listBuildings";
            document.UNIT_FORM.submit();
        }
        function editProject(editType) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=editProjectByAjax",
                data: {
                    projectID: '<%=buildingWbo.getAttribute("projectID")%>',
                    editType: editType,
                    projectName: $("#nameEdit").val()
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        alert("تم التحديث بنجاح");
                        if (editType == 'name') {
                            $("#nameCell").html($("#nameEdit").val());
                            //                            $("#edit_name").hide();
                        }
                    } else if (info.status == 'faild') {
                        alert("لم يتم التحديث");
                    }
                    closeOverlay();
                }
            });
        }
        var divID;
        $(function () {
            centerDiv("edit_name");
            centerDiv("attachDialog");
            centerDiv("sellDialog");
        });
        function closePopup(formID) {
            $("#" + formID).hide();
            $('#overlay').hide();
        }
        function showEditName() {
            divID = "edit_name";
            centerDiv("edit_name");
            $('#overlay').show();
            $('#edit_name').css("display", "block");
            $('#edit_name').dialog();
        }
        function closeOverlay() {
            $("#" + divID).hide();
            $("#overlay").hide();
        }
        function centerDiv(div) {
            $("#" + div).css("position", "fixed");
            $("#" + div).css("top", Math.max(0, (($(window).height() - $("#" + div).outerHeight()) / 2) +
                    $(window).scrollTop()) + "px");
            $("#" + div).css("left", Math.max(0, (($(window).width() - $("#" + div).outerWidth()) / 2) +
                    $(window).scrollLeft()) + "px");
        }

        function popupAttach(obj, projectId) {
            divID = "attachDialog";
            centerDiv("attachDialog");
            $('#overlay').show();
            $("#attachInfo").html("");
            $("#projectId").val(projectId);
            count = 1;
            $("#addFile2").removeAttr("disabled");
            $("#counter2").val("0");
            $("#listFile2").html("");
            $('#attachDialog').show();
            $("#attachDialog").css("display", "block");
            $('#attachDialog').dialog();
        }

        function addFiles2(obj) {
            if ((count * 1) == 4) {
                $("#addFile2").removeAttr("disabled");
            }

            if (count >= 1 & count <= 4) {
                $("#listFile2").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
                $("#counter2").val(count);
                count = Number(count * 1 + 1)

            } else {
                $("#addFile2").attr("disabled", true);
            }
        }

        function sendFilesByAjax(obj) {
            $("#attachForm").submit(function (e)
            {
                $(obj).parent().find("#progressx").css("display", "block");
                var formObj = $(this);
                var formURL = formObj.attr("action");
                var formData = new FormData(this);
                $.ajax({
                    url: formURL,
                    type: 'POST',
                    data: formData,
                    mimeType: "multipart/form-data",
                    contentType: false,
                    cache: false,
                    processData: false,
                    success: function (data, textStatus, jqXHR)
                    {
                        $("#progressx").html('');
                        $("#progressx").css("display", "none");
                    },
                    complete: function (response)
                    {
                        $("#attachInfo").html("<font color='white'>تم رفع الملفات</font>");
                        location.reload();
                    },
                    error: function ()
                    {
                        $("#attachInfo").html("<font color='red'>لم يتم رفع الملفات</font>");
                    }
                });
                e.preventDefault(); //Prevent Default action. 
                e.unbind();
            });

        }

        function viewDocuments(parentId) {
            var url = '<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId + '';
            var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }

        function openGallaryDialog(projectId) {
            var url = '<%=context%>/UnitDocReaderServlet?op=viewProjectMasterPlan&projectId=' + projectId + '';
            var wind = window.open(url, "عرض خرائط المشروع", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }
        function popupSell(proId, busObjId, projectName) {
            divID = "sellDialog";
            $('#overlay').show();
            $("#sellPlace").html(projectName);
            $("#unitIdSell").val(proId);
            $("#parentIdSell").val(busObjId);
            $('#sellDialog').css("display", "block");
            $('#sellDialog').dialog();
        }
        function closeSellPopup(obj) {
            $("#sellDialog").bPopup().close();
            $("#sellDialog").css("display", "none");
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
                success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
                        closePopup("sellDialog");
                        $("#clientIdSell").val("");
                        $("#clientCodeSell").val("");
                        $("#unitIdSell").val("");
                        $("#parentIdSell").val("");
                        $("#sellPlace").html("");
                        $("#clientNameSell").html("");
                    } else if (eqpEmpInfo.status == 'no') {
                        alert("error");
                    }
                }
            });
        }
        function getClient(obj) {
            var clientNumber = $("#clientCodeSell").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=getClientNameByNo",
                data: {
                    clientNumber: clientNumber
                },
                success: function (jsonString) {
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
        function allowDrop(ev) {
            ev.preventDefault();
        }
        function drag(ev, customerID, customerName) {
            ev.dataTransfer.setData("customerID", customerID);
            ev.dataTransfer.setData("customerName", customerName);
        }
        function dragToRecycle(ev, garageID, obj) {
            ev.dataTransfer.setData("garageID", garageID);
            ev.dataTransfer.setData("dragableElement", $(obj).attr('id'));
        }

        function dropSellGarage(ev, unitId, parentId, obj) {
            ev.preventDefault();
            var clientId = ev.dataTransfer.getData("customerID");
            var customerName = ev.dataTransfer.getData("customerName");
            var budget = "0";
            var period = "UL";
            var paymentSystem = "UL";
            var paymentPlace = "UL";
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
                success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status === 'ok') {
                        alert("تم البيع");
                        $(obj).css("background-color", "#b2e2b9");
                        $(obj).prop('title', $(obj).prop('title') + "\n" + customerName);
                        $(obj).prop('ondrop', null).off('drop');
                        $(obj).on('click', alertSoldOut);
                    } else if (eqpEmpInfo.status === 'no') {
                        alert("error");
                    }
                }
            });
        }

        function dropToRrcycleSellGarage(ev) {
            ev.preventDefault();
            var garageID = ev.dataTransfer.getData("garageID", garageID);
            var dragableElement = ev.dataTransfer.getData("dragableElement", dragableElement);
            
            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=deleteSellUnits",
                data: {
                    garageID: garageID
                },
                success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status === 'ok') {
                        alert("الوحدة غير مباعة");
//                        alert(dragableElement);
                        $("#"+dragableElement).css("background-color", "#ffffff");
                        $("#"+dragableElement).prop('ondrop', null).off('drop');
                    } else if (eqpEmpInfo.status === 'no') {
                        alert("error");
                    }
                }
            });
        }

        function alertSoldOut() {
            alert("تم البيع");
        }
        
        function alertSoldOff() {
            alert("الوحدة غير مباعة");
        }
    </script>
    <style type="text/css">
        .image_carousel {
            padding: 15px 0 15px 40px;
            width: 100%;
            height: 100%;
            position: relative;
        }
        .image_carousel img {
            border: 1px solid #ccc;
            background-color: white;
            padding: 9px;
            margin: 7px;
            display: block;
            float: left;
        }
        a.prev {
            background: url(images/miscellaneous_sprite.png) no-repeat transparent;
            width: 45px;
            height: 50px;
            display: block;
            position: absolute;
            top: -40px;
        }
        a.prev {			
            left: 15px;
            background-position: 0 0; }
        a.prev:hover {		background-position: 0 -50px; }

        a.prev span {
            display: none;
        }
        .clearfix {
            float: none;
            clear: both;
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
        .smallDialog {
            width: 320px;
            display: none;
            position: fixed;
            z-index: 1000;
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
        .toolBox {
            width:45px;
            height: 40px;
            float:right;
            margin: 0px;
            padding: 0px;
            border: 1px solid black;
        }
        .toolBox a img {
            width: 40px important;
            height: 40px important;
            float: right;
            margin: 0px;
            padding: 0px;
            text-align: right;
        }
        .cont_left {
            float: left;
            height: 100%;
            width: 70px;
        }
        .recyclebin {
            background-image: url(img/recycle_empty.png);
            height: 70px;
            width: 70px;
            background-repeat: no-repeat;
            background-position: center center;
        }
        .su_cont_left {
            float: left;
            height: 30px;
            width: 30px;
            background-image: url(img/active_file.gif);
            background-repeat: no-repeat;
            background-position: center center;
        }
        .recyclebinactive {
            background-image: url(img/active_recycle.png);
            height: 70px;
            width: 70px;
            background-repeat: no-repeat;
            background-position: center center;	
        }
        .recyclebinfill {
            background-image: url(img/recycle_fill.png);
            height: 70px;
            width: 70px;
            background-repeat: no-repeat;
            background-position: center center;	
        }
    </style>
    <body>
        <div id="attachDialog" class="smallDialog">
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closePopup('attachDialog')"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <form id="attachForm" action="<%=context%>/UnitDocWriterServlet?op=saveMultiFiles" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable>إرفاق رسم هندسي</lable>
                        <input type="button" id="addFile2" onclick="addFiles2(this)" value="+" />

                        <input id="counter2" value="" type="hidden" name="counter"/>
                        <input id="projectId" name="projectId" value="" type="hidden" />
                        </td>
                        <td style="text-align:right;width: 70%;" id="listFile2"> 
                        </td>
                        </tr>
                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="status"></div>
                    <div id="attachInfo" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <input type="submit" value="تحميل"  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendFilesByAjax(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
        <div id="sellDialog" style="width: 35%;display: none;position: fixed;margin-left: auto;margin-right: auto; z-index: 1000;" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closePopup('sellDialog')"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">بيع جراج</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول المبيعات</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                            <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">كود الجراج</td>
                        <td width="70%" style="text-align:right;"><b id="sellPlace"></b>
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
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
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
        <FORM NAME="UNIT_FORM" id="new_location_type_Form" METHOD="POST">
            <div id="units_list" style="width: 700px !important;display: none; z-index: 10000; top: 50px; left: 350px; position: fixed;"></div>
            <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

            </div>
            <div id="edit_name" class="smallDialog">
                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup('edit_name')"/>
                </div>
                <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                    <table  border="0px"  style="width:100%;"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                رقم العمارة
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="TEXT" style="width:180px" ID="nameEdit" size="33" value="<%=buildingWbo.getAttribute("projectName")%>"/>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value="حفظ" onclick="editProject('name')" id="editName" class="login-submit"/>
                    </div>                           
                </div>
            </div>
            
                 <TABLE style="width:85% ">
                
                <TR>
                    <TD style="width: 10%;border: none ; padding-bottom: 75%">
                        <IMG class="img" style="cursor: pointer" width="50%" VALIGN="BOTTOM" onclick="JavaScript: cancelForm();" SRC="images/buttons/backBut.png" > 
                          
                    </TD>
                    <TD style="width: 90%; border: none">
                        
                         <fieldset class="set" style="border-color: #006699; width: 100%; min-height: 400px;">
                <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=title%> </FONT><BR></TD>
                    </TR>
                </TABLE> 
                <br />
                <table  border="0px" dir=<fmt:message key="direction"/> align="center" class="table" style="width:30%;text-align: center;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                    <tr> 
                        <td class="td" colspan="2" style="text-align: center;">
                            <div class="toolBox" style="padding: 2px 2px 2px 0px;">
                                <image onclick="JavaScript: popupAttach(this, '<%=buildingWbo.getAttribute("projectID")%>');"
                                       src="images/icons/Attach.png" title='<fmt:message key="attach" />'
                                         alt='<fmt:message key="attach" />' 
                                       style="cursor: hand;"/>
                            </div>
                            <div class="toolBox" style="padding: 2px 2px 2px 0px; border-right-width: 0px;">
                                <image onclick="JavaScript: viewDocuments('<%=buildingWbo.getAttribute("projectID")%>');"
                                       src="images/unit.png"  title='<fmt:message key="showbuildingfiles" />' 
                                         alt='<fmt:message key="showbuildingfiles" />'
                                       style="cursor: hand;"/>
                            </div>
                            <div class="toolBox" style="padding: 2px 2px 2px 0px; border-right-width: 0px;">
                                <image onclick="JavaScript: openGallaryDialog('<%=projectWbo != null ? projectWbo.getAttribute("projectID") : ""%>');"
                                       src="images/master_plan.png"  title='<fmt:message key="showmaps" />' 
                                         alt='<fmt:message key="showmaps" />'  
                                       style="cursor: hand; height: 40px;"/>
                            </div>
                        </td>
                    </tr>
                </table>
                <br />
                <br />
                <table border="0" align="center" style="width: 90%;">
                    <tr>
                        <td style="width: 600px; vertical-align: top;">
                            <table style="width: 100%;">
                                <tr>
                                    <td style="width: 40%;"  >
                                        <img src="images/edit.png" width="50" align="left" onclick="JavaScript: showEditName();"
                                             style="display: <%=displayEdit ? "" : "none"%>;" />
                                        <b><font color="red" size="3" id="nameCell">
                                            <%=buildingWbo.getAttribute("projectName")%>
                                            </font>
                                        </b>
                                    </td>
                                    <td bgcolor="#CCCCCC" style="width: 10%;">
                                        <b><font size="2" color="black"><fmt:message key="appartmentno" />  </b>
                                    </td>
                               
                                <%
                                    if (projectWbo != null) {
                                %>
                              
                                    <td style="width: 40%;"  >
                                        <b>
                                            <font color="red" size="3">
                                            <%=projectWbo.getAttribute("projectName")%>
                                            </font>
                                        </b>
                                    </td>
                                    <td bgcolor="#CCCCCC" style="width: 10%;">
                                        <b><font size="2" color="black"> <fmt:message key="project" /></b>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </td>
                       
                    </tr>
                    <tr>
                         <td style="width: 70%;">
                            <% if (imagePath.size() > 0) {
                            %>
                            <div class="image_carousel">
                                <div id="foo">
                                    <%for (int i = 0; i < imagePath.size(); i++) {%>
                                    <img src="<%=imagePath.get(i)%>" width="600" height="600"/>
                                    <%}%>
                                </div>
                                <div class="clearfix"></div>
                                <a class="prev" id="foo_prev" href="#"><span>Previous</span></a>
                                <a class="next" id="foo_next" href="#"><span>Next</span></a>
                            </div>
                            <% } else {
                            %>
                            <b style="font-size: large;">لا يوجد صور للوحدة السكنية</b>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <%
                                if (garagesList != null && !garagesList.isEmpty()) {
                                    int colNo = 3;
                                    int no = 0;
                            %>
                            <br/>

                            <img id="yasmin" src="img/recycle_empty.png" title="recycle" ondrop="JavaScript: dropToRrcycleSellGarage(event)" ondragover="allowDrop(event)"/>
                            
                            

                            <table style="margin: auto; float: left; margin-left: 200px;">
                                <%
                                    for (int i = 0; i < garagesList.size(); i++) {
                                        WebBusinessObject garageWbo = garagesList.get(i);
                                        String garageStatus = (String) garageWbo.getAttribute("currentStatus");
                                        String imageTitle = (String) garageWbo.getAttribute("projectName");
                                        if (garageWbo.getAttribute("clientName") != null) {
                                            imageTitle += "\n" + garageWbo.getAttribute("clientName");
                                        }
                                        no = i % colNo;
                                        if (i == 0) {
                                %>
                                <tr>
                                    <td>
                                        <%
                                        } else if (i % colNo == 0) {
                                        %>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%
                                        } else if (i % colNo > 0) {
                                        %>
                                    </td>
                                    <td>
                                        <%
                                            }
                                        %>
                                        <img id="<%=garageWbo.getAttribute("projectID")%>" src="images/garage-icon.png" title="<%=imageTitle%>"
                                             style="height: 80px; cursor: hand; background-color: <%=garageStatus != null && garageStatus.equals("8") ? "" : "#b2e2b9"%>;"
                                             <%=garageStatus != null && garageStatus.equals("8") ? "ondrop=\"JavaScript: dropSellGarage(event, '" + garageWbo.getAttribute("projectID") + "', '" + garageWbo.getAttribute("mainProjId") + "', this)\"" : ""%>
                                             ondragover="allowDrop(event)"
                                             <%=garageStatus != null && garageStatus.equals("8") ? "" : "onclick=\"alert('تم البيع');\""%> 
                                             <%=garageStatus != null && garageStatus.equals("10") ? "ondragStart=\"JavaScript:dragToRecycle(event,'"+ garageWbo.getAttribute("projectID") +"',this)\"" : ""%>/> 
                                        <%--popupSell('" + garageWbo.getAttribute("projectID") + "', '" + garageWbo.getAttribute("mainProjId") + "', '" + garageWbo.getAttribute("projectName") + "')--%>
                                        <%
                                            if (i == garagesList.size() - 1) {
                                                for (int j = 1; j < colNo - no; j++) {
                                        %>
                                    </td>
                                    <td>
                                        &nbsp;
                                        <%
                                            }
                                        %>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                                <%
                                    }
                                %>
                            </table>
                            <%
                                if (customersList != null) {
                            %>
                            <div style="width: 40%; float: right; margin-right: 100px; margin-bottom: 20px;">
                                <table id="customersList" style="margin: auto; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th colspan="2" style="font-size: 16px; color: red;">تخصيص الجراجات للسكان</th>
                                        </tr>
                                        <tr>
                                            <th>&nbsp;</th>
                                            <th>اسم الساكن</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (WebBusinessObject customerWbo : customersList) {
                                        %>
                                        <tr>
                                            <td><img src="images/icons/purchase.png" style="width: 40px;" draggable="true"
                                                     ondragstart="JavaScript: drag(event, '<%=customerWbo.getAttribute("id")%>', '<%=customerWbo.getAttribute("name")%>')"/></td>
                                            <td><%=customerWbo.getAttribute("name")%></td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                            <br/>
                            <br/>
                            <%
                                }
                            %>
                            <br/>                           
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
            </fieldset>
                    </TD>
                             </table>
                            
           
        </FORM>
    </body>
</html>