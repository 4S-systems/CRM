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
        ArrayList<WebBusinessObject> locationTypesList = (ArrayList) request.getAttribute("locationTypesList");
        String alreadyExist = (String) request.getAttribute("alreadyExist");
        String status = (String) request.getAttribute("Status");
        String projId = (String) request.getAttribute("projId");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
 %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />

        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/validator.js' type='text/javascript'></script>
        <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm()
            {
                if (!validateData("req", this.HOUSING_UNIT_FORM.location_type_code, '<fmt:message key="error1" />')) {
                    this.HOUSING_UNIT_FORM.location_type_code.focus();
                } else if (!validateData("req", this.HOUSING_UNIT_FORM.mainProduct,    '<fmt:message key="error2" />')) {
                    this.HOUSING_UNIT_FORM.mainProduct.focus();
                } else if (!validateData("req", this.HOUSING_UNIT_FORM.models, '<fmt:message key="error3" />')) {
                    this.HOUSING_UNIT_FORM.models.focus();
                } else if (!validateData("req", this.HOUSING_UNIT_FORM.unitNo, '<fmt:message key="error4" />')) {
                    this.HOUSING_UNIT_FORM.unitNo.focus();
                } else if (!validateData("req", this.HOUSING_UNIT_FORM.option_one, '<fmt:message key="error5" />')) {
                    this.HOUSING_UNIT_FORM.option_one.focus();
                } else if (!validateData("req", this.HOUSING_UNIT_FORM.option_two, '<fmt:message key="error6" />')) {
                    this.HOUSING_UNIT_FORM.option_two.focus();
                } else {
                    document.HOUSING_UNIT_FORM.action = "<%=context%>/ProjectServlet?op=saveBuildingByFlats";
                    document.HOUSING_UNIT_FORM.submit();
                }
            }

            function sendData(id) {
                $.ajax({
                    url: "<%=context%>/ProjectServlet",
                    dataType: 'json',
                    data: "op=ajaxGetCode&code=" + id,
                    success: function(data) {
                        $('#unitProject').val(data['eqNo']);
                    }
                });
            }

            function cancelForm()
            {
                window.close();
            }


            function getModels(mainProductId) {
                $('#unitProject').val('');
                $('#unitModel').val('');
                $.ajax({
                    url: "<%=context%>/ProjectServlet",
                    dataType: 'json',
                    data: "op=ajaxGetCode&code=" + mainProductId,
                    success: function (data, textStatus, jqXHR){
                    console.log(textStatus);
                    console.log(data);
                    $('#unitProject').val(data['eqNo']);
                    },
                            error: function (jqXHR, textStatus, errorThrown) {
        console.log("Error");                
        console.log(textStatus);
                    }
                });
                if (mainProductId == null || mainProductId == "") {

                } else {
                    document.getElementById('models').innerHTML = "";
                    $("#showBtn").removeAttr("disabled");
                    $("#models").removeAttr("disabled");
                    var url = "<%=context%>/ProjectServlet?op=getModels&mainProductId=" + mainProductId;
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
                        var models = document.getElementById('models');
                        var result = req.responseText;
                        if (result != "") {
                            var data = result.split("<element>");
                            var idAndName = "";
                            for (var i = 0; i < data.length; i++) {
                                idAndName = data[i].split("<subelement>");
                                models.options[models.options.length] = new Option(idAndName[1], idAndName[0]);
                                if (i == 0) {
                                    $('#unitModel').val(idAndName[1]);
                                }
                            }
                        } else {
                        }
                    }
                }
            }

            function changeModel(obj) {
                $('#unitModel').val(obj.options[obj.selectedIndex].innerHTML);
            }

            function generateUnits() {
                var id =<%=projId%>;
                if (id != null) {
                    document.HOUSING_UNIT_FORM.action = "<%=context%>/ProjectServlet?op=getViewUnits&projectId=" + id;
                    document.HOUSING_UNIT_FORM.submit();
                }
            }

        </SCRIPT>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
        <style>
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
    </HEAD>

    <BODY>
        <input type="hidden" dir=<fmt:message key="direction" /> name="isMngmntStn" ID="isMngmntStn" size="3" value="isMngmntStn" maxlength="3">
        <FORM NAME="HOUSING_UNIT_FORM" id="HOUSING_UNIT_FORM" METHOD="POST">
            <CENTER>
               <FIELDSET class="set" style="width:50%;border-color: #006699" >
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td width="100%" class="titlebar">
                                <font color="#005599" size="4">
                                <fmt:message key="newbuilding" />
                                </font>
                            </td>
                        </tr>
                    </table>
                    <% if (alreadyExist != null && alreadyExist.equalsIgnoreCase("ok")) {%>
                    <br />
                    <div align="center" style="color: blue">
                        <p dir=<fmt:message key="direction" /> align="divAlign" style="color: red; background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b>
                                <fmt:message key="apartmentexistsexist" />
                            </b></p>
                    </div>
                    <% }%>
                    <table align="center" dir=<fmt:message key="direction" />>
                        <%  if (null != status && status.equalsIgnoreCase("Ok")) {%>
                        <tr>
                            <td>
                                <table align="center" dir=<fmt:message key="direction" />>
                                    <tr>
                                        <td class="td">
                                            <font size=4 color="black">
                                            <fmt:message key="saved" /></font>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <% } else if (null != status) {%>
                        <tr>
                            <td>
                                <table align="center" dir=<fmt:message key="direction" />>
                                    <tr>
                                        <td class="td">
                                            <font size=4 color="red" >
                                            <fmt:message key="notsaved" /><
                                            </font>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <% }%>
                    </table>
                    <br />
                    <TABLE class="backgroundTable" width="80%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR=<fmt:message key="direction" />>
                        <TR>
                            <TD style="text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">
                                        <fmt:message key="project" />
                                    </b></p>
                                <input style="width:100%;font-size:14px;font-weight: bold" type="hidden" dir=<fmt:message key="direction" /> name="location_type_code" ID="location_type_code" size="20" value="<%=request.getAttribute("location_type_code").toString()%>" maxlength="20">
                            </TD>
                            <TD colspan="2" class="backgroundTable" >
                                <SELECT name='mainProduct' id='mainProduct' style='width:100%;font-size:16px;' onchange="getModels(this.value)">
                                    <option value="" style="color: blue">----</option>
                                    <%
                                        for (WebBusinessObject Wbo : locationTypesList) {
                                            String productName = (String) Wbo.getAttribute("projectName");
                                            String productId = (String) Wbo.getAttribute("projectID");
                                    %>
                                    <option value='<%=productId%>'><b id="projectN"><%=productName%></b></option>
                                    <% }%>
                                </select>

                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">
                                        <fmt:message key="model" />
                                    </b></p>
                            </TD>
                            <TD colspan="2" class="backgroundTable" >
                                <select id="models" style='width:100%;font-size:14px;' name="models" onchange="changeModel(this)">
                                    <OPTION style="color: blue">
                                        <fmt:message key="choose" />
                                    </OPTION>
                                </SELECT>
                            </TD>
                        </TR>
                        <TR>
                            <TD class="backgroundTable" style="width: 25%"></TD>
                            <TD class="backgroundTable" style="width: 25%; text-align: center; font-weight: bold; color: blue; font-size: 14px">
                                <fmt:message key="project" />
                            </TD>
                            <TD class="backgroundTable" style="width: 25%; text-align: center; font-weight: bold; color: blue; font-size: 14px">
                                <fmt:message key="model1" />
                            </TD>
                            <TD class="backgroundTable" style="width: 25%; text-align: center; font-weight: bold; color: blue; font-size: 14px">
                                <fmt:message key="appartmentno" />
                            </TD>
                        </TR>
                        <TR>
                            <TD   style="width: 25%; text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">
                                        <fmt:message key="apartmentcode" />
                                    </b></p>
                            </TD>
                            <TD class="backgroundTable" style="width: 25%">
                                <input type="TEXT" style="width: 100%; text-align: center" name="unitProject" dir=<fmt:message key="direction" /> ID="unitProject"  value=''  size="15" maxlength="255" readonly="readonly">
                            </TD>
                            <TD class="backgroundTable" style="width: 25%" nowrap>
                                -&ensp;<input type="TEXT" style="width: 90%; text-align: center" name="unitModel" dir=<fmt:message key="direction" /> ID="unitModel"  value=''  size="15" maxlength="255" readonly="readonly">
                            </TD>
                            <TD class="backgroundTable" style="width: 25%; text-align: center" nowrap>
                                -&ensp;<input type="TEXT" style="width: 90%;text-align: center" dir=<fmt:message key="direction" /> name="unitNo" ID="unitNo" size="3" value="">
                            </TD>
                        </TR>
                        <TR>
                            <TD  style="width: 25%; text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"> 
                                        <fmt:message key="floors" />
                                    </b></p>
                            </TD>
                            <TD class="backgroundTable" style="width: 25%">
                                <input type="TEXT" style="width: 100%" dir=<fmt:message key="direction" /> name="option_one" ID="option_one" size="3" value="" maxlength="3"/>
                            </TD>
                            <TD    style="width: 25% ; text-align : <fmt:message key="textalign" />" class="backgroundHeader">
                                <fmt:message key="totalarea" />
                            </TD>
                            <TD class="backgroundTable" style="width: 25%">
                                <input type="TEXT" style="width: 100%" dir=<fmt:message key="direction" /> name="totalArea" ID="totalArea" size="4" value="" maxlength="4"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD   style="width: 25% ; text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"> 
                                        <fmt:message key="apartments" />
                                    </b></p>
                            </TD>
                            <TD class="backgroundTable" style="width: 25%">
                                <input style="width: 100%" type="TEXT" dir=<fmt:message key="direction" /> name="option_two" ID="option_two" size="3" value="" maxlength="3"/>
                            </TD>
                            <TD    style="width: 25% ; text-align : <fmt:message key="textalign" />" class="backgroundHeader"> <fmt:message key="buildarea" /> </TD>
                            <TD class="backgroundTable" style="width: 25%">
                                <input style="width: 100%" type="TEXT" dir=<fmt:message key="direction" /> name="netArea" ID="netArea" size="4" value="" maxlength="4"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD  style="width: 25% ; text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"> <fmt:message key="garages" />   </b></p>
                            </TD>
                            <TD class="backgroundTable" style="width: 25%">
                                <input style="width: 100%" type="TEXT" dir=<fmt:message key="direction" /> name="garage" ID="garage" size="3" value="" maxlength="3"/>
                            </TD>
                            <TD class="backgroundTable" style="width: 25%"></TD>
                            <TD class="backgroundTable" style="width: 25%"></TD>
                        </TR>
                        <TR>
                            <TD   style="width: 25% ; text-align : <fmt:message key="textalign" />" class="backgroundHeader" id="CellData">
                                <p><b style="margin-left: 5px;padding-left: 5px;font-weight: bold"><fmt:message key="elevators" /></b></p>
                            </TD>
                            <TD class="backgroundTable" style="width: 25%">
                                <input type="checkbox" name="elevator" ID="elevator" value="1" style="float: center;"/>
                            </TD>
                            <TD  style="width: 25% ; text-align : <fmt:message key="textalign" />" class="backgroundHeader"><fmt:message key="garden" /></TD>
                            <TD class="backgroundTable" style="width: 25%">
                                <input type="checkbox" name="garden" ID="garden" value="1" style="float: center;"/>
                            </TD>
                        </TR>
                    </TABLE>
                 
            <br />
                </fieldset>
                               <br />
                     <DIV align="center" STYLE="color:blue; width:50%">
                <button  onclick="JavaScript: cancelForm();" class="button">
                    <fmt:message key="cancle" />
                    <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript: submitForm();
                        return false;" class="button">
                        <fmt:message key="save" />
                        <IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            </CENTER>
        </FORM>
        <script type="text/javascript">
            $(function() {
                $("#unitProject").val(jQuery("#mainProjectId option:first-child").html());
            })
        </script>
    </BODY>

</HTML>