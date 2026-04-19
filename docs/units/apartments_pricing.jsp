<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Units.Units"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] apartmentAttributes = {"projectName"};
        int s = apartmentAttributes.length;
        int t = s + 8;
        String attName = null;
        String attValue = null;
        String status = (String) request.getAttribute("status");
        String statusUpdate = (String) request.getAttribute("statusUpdate");
        ArrayList<WebBusinessObject> apartmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("apartmentsList");
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        String projectID = request.getAttribute("projectID") != null ? (String) request.getAttribute("projectID") : "";
        String unitStatusVal = (String) request.getAttribute("unitStatus");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String viewUnit;
        if (stat.equals("En")) {
            viewUnit = "View";
        } else {
            viewUnit = "عرض";
        }
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css" />
        <link rel="stylesheet" href="css/demo_table.css" />
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css" />
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css" />
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css" />
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css" />

        <script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#apartments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });

            function deleteSelectedUnits() {
                var checkboxes = document.getElementsByName('deleteThis');
                var vals = "";
                for (var i = 0, n = checkboxes.length; i < n; i++) {
                    if (checkboxes[i].checked)
                    {
                        vals += "," + checkboxes[i].value;
                    }
                }
                var url = "<%=context%>/UnitServlet?op=ConfirmDeleteMoreApartment&apartmentSelected=" + vals;
                window.location.href = url;
            }

            function updateSelectedUnits() {
                document.UNIT_LIST_FORM.action = "<%=context%>/UnitServlet?op=saveApartmentPrice";
                document.UNIT_LIST_FORM.submit();
            }

            function viewGallery(unitID, modelID) {
                var url = '<%=context%>/UnitDocReaderServlet?op=unitDocGallery&unitID=' + unitID + '&modelID=' + modelID;
                var wind = window.open(url, '<fmt:message key="listdocs" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }

            function viewDocuments(parentId) {
                var url = '<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId + '';
                var wind = window.open(url, '<fmt:message key="listdocs" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }

            function popupAttach(obj, projectId) {
                $("#attachInfo").html("");
                $("#projectId").val(projectId);
                count = 1;
                $("#addFile2").removeAttr("disabled");
                $("#counter2").val("0");
                $("#listFile2").html("");
                $('#attachDialog').show();
                $("#attachDialog").css("display", "block");
                $('#attachDialog').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }

            function addFiles2(obj) {
                if ((count * 1) === 4) {
                    $("#addFile2").removeAttr("disabled");
                }
                if (count >= 1 & count <= 4) {
                    $("#listFile2").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
                    $("#counter2").val(count);
                    count = Number(count * 1 + 1);
                } else {
                    $("#addFile2").attr("disabled", true);
                }
            }

            function sendFilesByAjax(obj) {
                $("#attachForm").submit(function (e) {
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
                        success: function (data, textStatus, jqXHR) {
                            $("#progressx").html('');
                            $("#progressx").css("display", "none");
                        },
                        complete: function (response) {
                            $("#attachInfo").html("<font color='white'> '<fmt:message key="filesuploaded" />'    </font>");

                        },
                        error: function () {
                            $("#attachInfo").html("<font color='red'> '<fmt:message key="filesnotuploaded" />'       </font>");
                        }
                    });
                    e.preventDefault(); //Prevent Default action. 
                    e.unbind();
                });
            }

            function closeAttachPopup(obj) {
                $("#attachDialog").bPopup().close();
                $("#attachDialog").css("display", "none");
            }

            function changeTotalPrice(id) {
                if (parseInt($("#meterPrice" + id).html()) && parseInt($("#unitArea" + id).val())) {
                    $("#totalPrice" + id).html(parseInt($("#meterPrice" + id).html()) * parseInt($("#unitArea" + id).val()));
                } else {
                    $("#totalPrice" + id).html("---");
                }
                changeMeterPrice(id);
            }

            function changeMeterPrice(id) {
                if (parseInt($("#unitPrice" + id).val()) && parseInt($("#unitArea" + id).val())) {
                    $("#meterUnitPrice" + id).html((parseInt($("#unitPrice" + id).val()) / parseInt($("#unitArea" + id).val())).toFixed(0));
                } else {
                    $("#meterUnitPrice" + id).html("---");
                }
                if ($("#addonPrice" + id).html() !== '') {
                    $("#totalUnitPrice" + id).html(parseInt($("#unitPrice" + id).val()) + parseInt($("#addonPrice" + id).html()));
                } else {
                    $("#totalUnitPrice" + id).html($("#unitPrice" + id).val());

                }
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
                color: #27272A;
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
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
    </head>
    <body>
        <form name="UNIT_LIST_FORM" method="post">
            <fieldset align=center class="set" style="width: 85%; border-color: #006699;">
                <legend align="center">
                    <font color="#005599" size="5">
                    <fmt:message key="unitspricing" />
                    </font>
                </legend>
                <br/>
                <div style="margin-left: auto; margin-right: auto; width: 570px;">
                    <table algin="center" dir="rtl" width="570" cellpadding="2" cellspacing="1">
                        <tr>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                <b>
                                    <font size=3 color="white">
                                    <fmt:message key="unitStatus" /> 
                                    </font>
                                </b>
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                <b>
                                    <font size=3 color="white">
                                    <fmt:message key="project" /> 
                                    </font>
                                </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center" bgcolor="#dedede" valign="middle">
                                <select name="unitStatus" id="unitStatus">
                                    <option value="8" <%="8".equals(unitStatusVal) ? "selected" : ""%>><fmt:message key="available" /></option>
                                    <option value="9" <%="9".equals(unitStatusVal) ? "selected" : ""%>><fmt:message key="reserved" /></option>
                                    <option value="10" <%="10".equals(unitStatusVal) ? "selected" : ""%>><fmt:message key="sold" /></option>
                                </select>
                            </td>
                            <td style="text-align:center" bgcolor="#dedede" valign="middle">
                                <select name="projectID" id="projectID">
                                    <option value="">الكل</option>
                                    <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center" class="td" colspan="2">
                                <button type="submit" style="color: #27272A; font-size: 15px; margin-top: 20px; font-weight: bold;">
                                    <fmt:message key="search"/><img height="15" src="images/search.gif" ></button>
                            </td>
                        </tr>
                    </table>
                    <br/>
                </div>
                <center> <b> <font size="3" color="red"> <fmt:message key="unitsno" /> : <%=apartmentsList.size()%> </font></b></center> 
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
                            <b><font color="blue" size="3">

                                <fmt:message key="deleteddone" />'
                                </font></b>
                        </td>
                        <%
                        } else {
                        %>
                        <td class="bar">
                            <b><font color="red" size="3">
                                <fmt:message key="deletednotdone" />'
                                </font></b>
                        </td>
                        <%
                            }
                        %>
                    </tr>
                </table>
                <br />
                <%
                    }
                    if (statusUpdate != null) {
                %>
                <table width="50%" align="center">
                    <tr>
                        <%
                            if (statusUpdate.equalsIgnoreCase("ok")) {
                        %>
                        <td class="bar">
                            <b>
                                <font color="blue" size="3">
                                <fmt:message key="updateddone" />
                                </font>
                            </b>
                        </td>
                        <%
                        } else {
                        %>
                        <td class="bar">
                            <b>
                                <font color="red" size="3">
                                <fmt:message key="updatenotdone" />'
                                </font>
                            </b>
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
                <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <table align="center" dir='<fmt:message key="direction" />' id="apartments" style="width:100%;">
                        <thead>
                            <tr>
                                <th rowspan="1"><b>#</b></th>
                                <th rowspan="1"><b></b></th>
                                <th rowspan="1"><b><fmt:message key="floor" /></b></th>
                                <th rowspan="1"><b><fmt:message key="unit" /></b></th>
                                <th rowspan="1"><b><fmt:message key="unitArea" /></b></th>
                                <th rowspan="1"><b><fmt:message key="gardenArea" /></b></th>
                                <th rowspan="1"><b><fmt:message key="terraceArea" /></b></th>
                                <th rowspan="1"><b><fmt:message key="addonPrice" /></b></th>
                                <th rowspan="1"><b><fmt:message key="meterprice" /><br /><fmt:message key="forProject"/></b></th>
                                <th rowspan="1"><b><fmt:message key="meterprice" /><br /><fmt:message key="forUnit"/></b></th>
                                <th rowspan="1"><b><fmt:message key="unitprice" /></b></th>
                                <th rowspan="1"><b><fmt:message key="price" /></b></th>
                                <th rowspan="1"><b></b></th>
                                <th rowspan="1"><b></b></th>
                                <th rowspan="1">
                                    <%
                                        if (userPrevList.contains("DELETE_UNIT")) {
                                    %>
                                    <input type="button" id="deleteSelected" name="deleteSelected" value='<fmt:message key="delete"/>' onclick="deleteSelectedUnits()" />
                                    <%
                                        }
                                    %>
                                    <input type="button" id="updateSelected" name="updateSelected" value='<fmt:message key="update"/>' onclick="updateSelectedUnits()" />
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int counter = 1;
                                String area, price;
                                for (WebBusinessObject apartmentWbo : apartmentsList) {
                            %>
                            <tr>
                                <%                                for (int i = 0; i < s; i++) {
                                        attName = apartmentAttributes[i];
                                        attValue = (String) apartmentWbo.getAttribute(attName);
                                %>
                                <td>
                                    <%=counter%>
                                </td>
                                <td nowrap>
                                    &nbsp;
                                    <img onclick="JavaScript: popupAttach(this, '<%=apartmentWbo.getAttribute("projectID")%>');"
                                         width="19px" height="19px" src="images/icons/Attach.png"  title='<fmt:message key="attach" />'
                                         alt='<fmt:message key="attach" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img onclick="JavaScript: viewDocuments('<%=apartmentWbo.getAttribute("projectID")%>');"
                                         width="19px" height="19px" src="images/unit_doc.png"  title='<fmt:message key="showunitfiles" />'
                                         alt='<fmt:message key="showunitfiles" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img onclick="JavaScript: viewDocuments('<%=apartmentWbo.getAttribute("Model_Code")%>');"
                                         width="19px" height="19px" src="images/model.png" title='<fmt:message key="showmodelfiles" />'
                                         alt='<fmt:message key="showmodelfiles" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img onclick="JavaScript: viewGallery('<%=apartmentWbo.getAttribute("projectID")%>', '<%=apartmentWbo.getAttribute("Model_Code")%>');"
                                         width="25px" height="25px" src="images/gallery.png" title='<fmt:message key="showimages" />' 
                                         alt='<fmt:message key="showimages" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                </td>
                                <td>
                                    <div>
                                        <b><%=apartmentWbo.getAttribute("levelName") != null ? apartmentWbo.getAttribute("levelName") : ""%></b>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b><%=attValue%></b>
                                    </div>
                                </td>
                                <%
                                    }
                                    area = apartmentWbo.getAttribute("area") != null && !"".equals(apartmentWbo.getAttribute("area")) ? (String) apartmentWbo.getAttribute("area") : "0";
                                    price = apartmentWbo.getAttribute("price") != null && !"".equals(apartmentWbo.getAttribute("price")) ? (String) apartmentWbo.getAttribute("price") : "0";
                                    String UniStatus = "", color = "";
                                    String unitStatus = (String) apartmentWbo.getAttribute("statusName");
                                    String disabled = "disabled";
                                    if (unitStatus != null) {
                                        if (unitStatus.equalsIgnoreCase("8")) {
                                            UniStatus = "available";
                                            color = "green";
                                            disabled = "";
                                        } else if (unitStatus.equalsIgnoreCase("9")) {
                                            UniStatus = "reserved";
                                            color = "red";
                                        } else if (unitStatus.equalsIgnoreCase("10")) {
                                            UniStatus = "sold";
                                            color = "blue";
                                        } else if (unitStatus.equalsIgnoreCase("33")) {
                                            UniStatus = "reserved";
                                            color = "purple";
                                        } else if (unitStatus.equalsIgnoreCase("28")) {
                                            UniStatus = "hidden";
                                            color = "lightblue";
                                        }
                                    }
                                %>
                                <td>
                                    <%
                                        if (unitStatus.equalsIgnoreCase("8")) {
                                    %>
                                    <input type="number" id="unitArea<%=apartmentWbo.getAttribute("projectID")%>" name="unitArea<%=apartmentWbo.getAttribute("projectID")%>"
                                           value="<%=apartmentWbo.getAttribute("area")%>" style="width: 50px;"
                                           onchange="JavaScript: changeTotalPrice('<%=apartmentWbo.getAttribute("projectID")%>');" />
                                    <%
                                    } else {
                                    %>
                                    <div>
                                        <b><%=apartmentWbo.getAttribute("area") != null ? apartmentWbo.getAttribute("area") : "---"%></b>
                                    </div>
                                    <%
                                        }
                                    %>
                                </td><td>
                                    <div>
                                        <b><%="Garden".equalsIgnoreCase((String) apartmentWbo.getAttribute("addonName")) ? apartmentWbo.getAttribute("addonArea") : ""%></b>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b><%="Roof".equalsIgnoreCase((String) apartmentWbo.getAttribute("addonName")) ? apartmentWbo.getAttribute("addonArea") : ""%></b>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b id="addonPrice<%=apartmentWbo.getAttribute("projectID")%>"><%=apartmentWbo.getAttribute("addonPrice") != null ? apartmentWbo.getAttribute("addonPrice") : ""%></b>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b id="meterPrice<%=apartmentWbo.getAttribute("projectID")%>"><%=apartmentWbo.getAttribute("meterPrice") != null ? apartmentWbo.getAttribute("meterPrice") : "---"%></b>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b id="meterUnitPrice<%=apartmentWbo.getAttribute("projectID")%>"><%=!area.equals("0") && !price.equals("0") ? Integer.valueOf(price) / Integer.valueOf(area) : "0"%></b>
                                    </div>
                                </td>
                                <td>
                                    <%
                                        if (unitStatus.equalsIgnoreCase("8")) {
                                    %>
                                    <input type="number" id="unitPrice<%=apartmentWbo.getAttribute("projectID")%>" name="unitPrice<%=apartmentWbo.getAttribute("projectID")%>"
                                           value="<%=apartmentWbo.getAttribute("price")%>" style="width: 90px;"
                                           onchange="JavaScript: changeMeterPrice('<%=apartmentWbo.getAttribute("projectID")%>');"/>
                                    <%
                                    } else {
                                    %>
                                    <div>
                                        <b><%=apartmentWbo.getAttribute("price") != null ? apartmentWbo.getAttribute("price") : "---"%></b>
                                    </div>
                                    <%
                                        }
                                    %>
                                </td>
                                <td>
                                    <div>
                                        <b id="totalUnitPrice<%=apartmentWbo.getAttribute("projectID")%>"><%=apartmentWbo.getAttribute("price") != null && apartmentWbo.getAttribute("addonPrice") != null ? Integer.valueOf((String) apartmentWbo.getAttribute("price")) + Integer.valueOf((String) apartmentWbo.getAttribute("addonPrice")) : apartmentWbo.getAttribute("price") != null ? apartmentWbo.getAttribute("price") : "0"%></b>
                                    </div>
                                </td>
                                <td>
                                    <b style="color: <%=color%>"><fmt:message key="<%=UniStatus%>" /></b>
                                </td>
                                <td nowrap>
                                    <div>
                                        <b><a href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=apartmentWbo.getAttribute("projectID")%>&fromPage=listApartment"><%=viewUnit%></a></b>
                                    </div>
                                </td>
                                <td>
                                    <%
                                        if (unitStatus.equalsIgnoreCase("8")) {
                                    %>
                                    <input class="apartmentCheckbox" type="checkbox" id="deleteThis" name="deleteThis" value="<%=apartmentWbo.getAttribute("projectID")%><!><%=apartmentWbo.getAttribute("projectName")%>" <%=disabled%>/>
                                    <%
                                        }
                                    %>&nbsp;
                                </td>
                            </tr>
                            <%
                                    counter++;
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <br/><br/>
            </fieldset>
        </form>
        <div id="attachDialog"  style="width: 30%;display: none;position: fixed;margin-left: auto;margin-right: auto">
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeAttachPopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <form id="attachForm" action="<%=context%>/UnitDocWriterServlet?op=saveMultiFiles" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable> <fmt:message key="attach" />    </lable>
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
                    <input type="submit" value='<fmt:message key="upload" />'  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendFilesByAjax(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
    </body>
</html>