<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />

    <%
        ArrayList<WebBusinessObject> projects = (ArrayList) request.getAttribute("projects");
        ArrayList<WebBusinessObject> unitTypesList = (ArrayList<WebBusinessObject>) request.getAttribute("unitTypesList");
        ArrayList<WebBusinessObject> levelsList = (ArrayList<WebBusinessObject>) request.getAttribute("levelsList");
        ArrayList<WebBusinessObject> modelsList = request.getAttribute("modelsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("modelsList") : new ArrayList<WebBusinessObject>();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String status = (String) request.getAttribute("Status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
         
        String save_button_label;
        String fStatus;
        String sStatus, unitNo, unitDesc, unitType, unitArea, unitPrice, model, modelCodeRequiredMsg, modelNameRequiredMsg,
                levelCodeRequiredMsg, levelNameRequiredMsg, successMsg, failMessage, projectRequiredMsg;
        String mainProject;
        if (stat.equals("En")) {
                save_button_label = "Save ";
            sStatus = "Apartment Saved Successfully";
            fStatus = "Fail To Save This Apartment";
            unitNo = "Unit No.";
            unitDesc = "Unit Description";
            mainProject = "Project";
            unitType = "Unit Type";
            unitArea = "Unit Area";
            unitPrice = "Unit Price";
            model = "Model";
            modelCodeRequiredMsg = "Model Code is required";
            modelNameRequiredMsg = "Model Name is required";
            levelCodeRequiredMsg = "LevelCode is required";
            levelNameRequiredMsg = "Level Name is required";
            successMsg = "Saved Successfully";
            failMessage = "Fail to Save";
            projectRequiredMsg = "Project is required";
        } else {
                save_button_label = "تسجيل";
            fStatus = "لم يتم تسجيل الوحدة";
            sStatus = "تم أدخال الوحدة بنجاح";
            unitNo = "كود الوحدة";
            unitDesc = "الوصف";
            mainProject = "المشروع";
            unitType = "نوع الوحدة";
            unitArea = "المساحة";
            unitPrice = "السعر";
            model = "النموذج";
            modelCodeRequiredMsg = "مطلوب أدخال كود النموذج";
            modelNameRequiredMsg = "مطلوب أدخال اسم النموذج";
            levelCodeRequiredMsg = "مطلوب أدخال كود المستوي";
            levelNameRequiredMsg = "مطلوب أدخال اسم المستوي";
            successMsg = "تم الحفظ بنجاح";
            failMessage = "لم يتم الحفظ";
            projectRequiredMsg = "مطلوب أختيار المشروع";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <title>add new apartment</title>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/validator.js' type='text/javascript'></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery-ui.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            var meterPrice = 1;
            function submitForm()
            {
                if (!validateData("req", this.UNIT_FORM.projectID, '<fmt:message key="error2" />')) {
                    this.UNIT_FORM.projectID.focus();
                } else if (!validateData("req", this.UNIT_FORM.unitNo, "يجب أدخال رقم الوحده")) {
                    this.UNIT_FORM.unitNo.focus();
                } else {
                    document.UNIT_FORM.action = "<%=context%>/UnitServlet?op=saveNewApartment";
                    document.UNIT_FORM.submit();
                }
            }
            function cancelForm()
            {
                window.close();
            }
            function addLine() {
                $("#unitsTable").append("<tr><td style=\"border: none\"><img  title=\"إضافة وحدة سكنية\" src=\"images/buttons/addApartment.jpg\" onclick=\"addLine()\"/></td><td style=\'text-align : <fmt:message key="textalign" />\' style=\"width: 50%\" class=\"backgroundHeader\" id=\"CellData\"><p><b style=\"margin-left: 5px;padding-left: 5px;font-weight: bold\"><%=unitNo%></b></p></td><td class=\"backgroundTable\" style=\"width: 50%; text-align: center\"><input type=\"TEXT\" style=\"width: 90%;text-align: center\" dir=\'<fmt:message key="direction" />\' name=\"unitNo\" ID=\"unitNo\" size=\"8\" value=\"\" maxlength=\"8\"/></td><td style=\"border: none\"><img id=\"saveApartmentBut\" src=\"images/icons/notavailable.png\" onclick=\"saveApartment(this);\"/></td></tr><tr><td></td><td style=\"text-align : <fmt:message key="textalign" />\" style=\"width: 50%\" class=\"backgroundHeader\" id=\"CellData\"><p><b style=\"margin-left: 5px;padding-left: 5px;font-weight: bold\"><%=unitDesc%></b></p></td><td class=\"backgroundTable\" style=\"width: 50%; text-align: center\"><textarea style=\"width:90%;height:80px;\" id=\"unitDesc\" name=\"unitDesc\"></textarea></td></tr>");
            }
            function saveApartment(obj) {
                var apartCode = $(obj).parent().parent().find("#unitNo").val();
                var projectID = $("#projectID").val();
                var projectDesc = $("#unitDesc").val();
                var unitTypeID = $("#unitTypeID").val();
                var unitArea = $("#unitArea").val();
                var unitPrice = $("#unitPrice").val();
                var modelID = $("#modelID").val();
                var levelID = $("#levelID").val();
                
                if (projectID.length === 0) {
                    alert('<fmt:message key="error2" />');

                } else if (unitTypeID.length === 0) {
                    alert('<fmt:message key="unitTypeRequiredMsg" />');
                } else if (apartCode.length === 0) {
                    alert('<fmt:message key="error7" />');
                } else {
                    $.ajax({
                        url: "<%=context%>/UnitServlet?op=saveApartmentAsAjax",
                        data: {projectID: projectID, unitNo: apartCode, unitDesc:projectDesc, unitTypeID: unitTypeID, unitArea: unitArea, unitPrice: unitPrice, modelID: modelID, levelID: levelID},
                        type: 'POST',
                        dataType: 'Text',
                        success: function(data) {
                            if (data === 'OK') {
                                $(obj).attr("src", "images/Ok.png");
                                alert("Saved Successfully");
                            } else if (data === 'NO') {
                                alert("Fail to Save, please contact System Administrator");
                            } else if (data.indexOf('duplicate') > -1) {
                                $("#viewLink").attr("href", "<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=" + data.split("#")[1]);
                                $("#dialog").dialog();
                            }
                        }

                    });
                }

            }
            function getModels() {
                $("#modelID").html('');
                $.ajax({
                    url: "<%=context%>/UnitServlet?op=getModelsAjax",
                    dataType: 'json',
                    data: {
                        projectID: $("#projectID").val()
                    },
                    success: function(data) {
                        var options = [];
                        try {
                            $.each(data, function () {
                                options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                            });
                        } catch(err){
                        }
                        $("#modelID").html(options.join(''));
                    }
                });
            }

            function getProjectMeterPrice(obj) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=getProjectMeterPriceAjax",
                    data: {
                        projectID: $(obj).val()
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        meterPrice = info.meterPrice;
                        $("#meterPrice").html(meterPrice);
                        calculatePrice();
                    }
                });
            }
            
            function calculatePrice() {
                $("#unitPrice").val(parseFloat(meterPrice) * parseFloat($("#unitArea").val()));
            }
            
            var divTag;
            function openNewModel() {
                if ($("#projectID").val() === '') {
                    alert("<%=projectRequiredMsg%>");
                    $("#projectID").focus();
                } else {
                    divTag = $("#newForm");
                    $.ajax({
                        type: "post",
                        url: '<%=context%>/ProjectServlet?op=getModelForm',
                        data: {
                        },
                        success: function (data) {
                            divTag.html(data).dialog({
                                modal: true,
                                title: "نموذج جديد",
                                show: "fade",
                                hide: "explode",
                                width: 300,
                                position: {
                                    my: 'center',
                                    at: 'center'
                                },
                                buttons: {
                                    'Close and Reload': function () {
                                        location.reload();
                                    },
                                    Save: function () {
                                        saveNewModel();
                                    }
                                }
                            }).dialog('open');
                        }
                    });
                }
            }
            function saveNewModel() {
                var modelCode = $("#modelCode").val();
                var mainProjectID = $("#projectID").val();
                var locationType = $("#locationType").val();
                var modelName = $("#modelName").val();
                if (modelCode === '') {
                    alert("<%=modelCodeRequiredMsg%>");
                    $("#modelCode").focus();
                } else if (modelName === '') {
                    alert("<%=modelNameRequiredMsg%>");
                    $("#modelName").focus();
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ProjectServlet?op=saveModelAjax",
                        data: {
                            modelCode: modelCode,
                            mainProjectID: mainProjectID,
                            locationType: locationType,
                            modelName: modelName
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                alert("<%=successMsg%>");
                                openNewModel();
                            } else {
                                alert("<%=failMessage%>");
                            }
                        }
                    });
                }
            }
            function openNewLevel() {
                if ($("#projectID").val() === '') {
                    alert("<%=projectRequiredMsg%>");
                    $("#projectID").focus();
                } else {
                    divTag = $("#newForm");
                    $.ajax({
                        type: "post",
                        url: '<%=context%>/ProjectServlet?op=getLevelForm',
                        data: {
                        },
                        success: function (data) {
                            divTag.html(data).dialog({
                                modal: true,
                                title: "مستوي جديد",
                                show: "fade",
                                hide: "explode",
                                width: 300,
                                position: {
                                    my: 'center',
                                    at: 'center'
                                },
                                buttons: {
                                    'Close and Reload': function () {
                                        location.reload();
                                    },
                                    Save: function () {
                                        saveNewLevel();
                                    }
                                }
                            }).dialog('open');
                        }
                    });
                }
            }
            function saveNewLevel() {
                var levelCode = $("#levelCode").val();
                var mainProjectID = $("#projectID").val();
                var locationType = $("#locationType").val();
                var levelName = $("#levelName").val();
                if (levelCode === '') {
                    alert("<%=levelCodeRequiredMsg%>");
                    $("#levelCode").focus();
                } else if (levelName === '') {
                    alert("<%=levelNameRequiredMsg%>");
                    $("#levelName").focus();
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ProjectServlet?op=saveLevelAjax",
                        data: {
                            levelCode: levelCode,
                            mainProjectID: mainProjectID,
                            locationType: locationType,
                            levelName: levelName
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                alert("<%=successMsg%>");
                                openNewModel();
                            } else {
                                alert("<%=failMessage%>");
                            }
                        }
                    });
                }
            }
        </script>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
        <style>
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
    </head>
    <body>
        <div id="newForm"></div>
        <div id="dialog" title="Basic dialog" style="display: none; text-align: center;">
            <p>Duplicate Name Can't Save, you can view existing unit by clicking here</p><a href="" id="viewLink"><img src="images/icons/house.png" style="width: 50px; margin-left: auto; margin-right: auto;" title="View Unit"/></a>
        </div>
        <form NAME="UNIT_FORM" id="UNIT_FORM" METHOD="POST">
            <input type="hidden" dir=<fmt:message key="direction" /> name="isMngmntStn" ID="isMngmntStn" size="3" value="isMngmntStn" maxlength="3">
            <div align="left" STYLE="color:blue; margin-left: 7.5%">
                <button  onclick="JavaScript: submitForm();
                        return false;" style="display : none" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </div>
            <br />
            <center>
                <fieldset class="set" style="width:50%;border-color: #006699" >
                    <table align="center" width="100%" >
                        <tr>
                            <td width="100%" class="titlebar">
                                <font color="#005599" size="4"> <fmt:message key="newunit" />  </font>
                            </td>
                        </tr>
                    </table>
                    <table align="center" dir=<fmt:message key="direction" />>
                        <%  if (null != status && status.equalsIgnoreCase("Ok")) {%>
                        <tr>
                            <td class="td">
                                <font size=4 color="black"><%=sStatus%></font>
                            </td>
                        </tr>
                        <% } else if (null != status) {%>
                        <tr>
                            <td class="td">
                                <font size=4 color="red" ><%=fStatus%></font>
                            </td>
                        </tr>
                        <% }%>
                    </table>
                    <br />
                    <table id="unitsTable" class="backgroundTable" width="80%"   ALIGN="center" DIR=<fmt:message key="direction" />>
                        <tr>
                            <td style="text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=mainProject%></b></p>
                            </td>
                            <td class="backgroundTable" >
                                <select name='projectID' id='projectID' style='width:100%;font-size:16px;' onchange="JavaScript: /*getModels();*/ getProjectMeterPrice(this);">
                                    <option value="" style="color: blue">----</option>
                                    <%
                                        for (WebBusinessObject Wbo : projects) {
                                            String productName = (String) Wbo.getAttribute("projectName");
                                            String productId = (String) Wbo.getAttribute("projectID");
                                    %>
                                    <option value='<%=productId%>'><b id="projectN"><%=productName%></b></option>
                                    <% }%>
                                </select>
                            </td>
                            <td style="border: none"></td>
                        </tr>
                        <tr>
                            <td style="text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=model%></b></p>
                            </td>
                            <td class="backgroundTable" >
                                <select name='modelID' id='modelID' style='width:100%;font-size:16px;'>
                                    <option value=""></option>
                                    <sw:WBOOptionList wboList="<%=modelsList%>" displayAttribute="projectName" valueAttribute="projectID"/>
                                </select>
                            </td>
                            <td style="border: none"><a href="JavaScript: openNewModel();"><img src="images/icons/add.png" width="20px;"/></a></td>
                        </tr>
                        <tr>
                            <td style="text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=unitType%></b></p>
                            </td>
                            <td class="backgroundTable" >
                                <select name='unitTypeID' id='unitTypeID' style='width:100%;font-size:16px;'>
                                    <sw:WBOOptionList wboList="<%=unitTypesList%>" displayAttribute="typeName" valueAttribute="id"/>
                                </select>
                            </td>
                            <td style="border: none"></td>
                        </tr>
                        <tr>
                            <td style="text-align : <fmt:message key="textalign" />" style="width: 50%" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=unitNo%></b></p>
                            </td>
                            <td class="backgroundTable" style="width: 50%; text-align: center">
                                <input type="TEXT" style="width: 100%;text-align: center" dir=<fmt:message key="direction" /> name="unitNo" ID="unitNo" size="8" value="" maxlength="8"/>
                            </td>
                            <td style="border: none"><img id="saveApartmentBut" src="images/icons/notavailable.png" onclick="saveApartment(this);"/></td>
                        </tr>
                        <tr>
                            <td style="text-align : <fmt:message key="textalign" />" style="width: 50%" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=unitArea%></b></p>
                            </td>
                            <td class="backgroundTable" style="width: 50%; text-align: <fmt:message key="textalign" />;">
                                <input type="number" min="0" style="width: 30%;" dir="<fmt:message key="direction" />" name="unitArea" ID="unitArea" size="8" value="0" maxlength="8"
                                       onchange="JavaScript: calculatePrice();"/>
                            </td>
                            <td style="border: none"></td>
                        </tr>
                        <tr>
                            <td style="text-align : <fmt:message key="textalign" />" style="width: 50%" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=unitPrice%></b></p>
                            </td>
                            <td class="backgroundTable" style="width: 50%; text-align: <fmt:message key="textalign" />;">
                                <input type="number" min="0" style="width: 30%;" dir="<fmt:message key="direction" />" name="unitPrice" ID="unitPrice" size="8" value="0" maxlength="8"/>
                                <fmt:message key="meterprice"/>&nbsp;&nbsp;&nbsp;&nbsp;<b id="meterPrice">&nbsp;</b>
                            </td>
                            <td style="border: none"></td>
                        </tr>
                        <tr>
                            <td style="text-align : <fmt:message key="textalign" />" style="width: 50%" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><fmt:message key="level"/></b></p>
                            </td>
                            <td class="backgroundTable" style="width: 50%; text-align: <fmt:message key="textalign" />;">
                                <select style="width: 30%; font-size: 16px;" dir="<fmt:message key="direction" />" name="levelID" ID="levelID">
                                    <sw:WBOOptionList wboList="<%=levelsList%>" displayAttribute="projectName" valueAttribute="projectID"/>
                                </select>
                            </td>
                            <td style="border: none"><a href="JavaScript: openNewLevel();"><img src="images/icons/add.png" width="20px;"/></a></td>
                        </tr>
                        <tr>
                            <td style="text-align : <fmt:message key="textalign" />" style="width: 50%" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><%=unitDesc%></b></p>
                            </td>
                            <td class="backgroundTable" style="width: 50%; text-align: center">
                                <textarea style="width: 100%;height: 80px;" id="unitDesc" name="unitDesc">لايوجد</textarea>
                            </td>
                            <td style="border: none"></td>
                        </tr>
                    </table>
                    <br />
                </fieldset>
            </center>
        </form>
    </body>
</html>