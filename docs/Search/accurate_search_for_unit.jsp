<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%>
<!DOCTYPE html>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Units.Units"/>
    <%
        ArrayList<WebBusinessObject> areaList = (ArrayList<WebBusinessObject>) request.getAttribute("areaList");
        String areaID = (String) request.getAttribute("areaID") != null ? (String) request.getAttribute("areaID") : "";
        ArrayList<WebBusinessObject> projectList = request.getAttribute("projectList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("projectList") : new ArrayList<WebBusinessObject>();
        String projectID = (String) request.getAttribute("projectID") != null ? (String) request.getAttribute("projectID") : "";
        String unitArea = (String) request.getAttribute("unitArea") != null ? (String) request.getAttribute("unitArea") : "";
        String description = (String) request.getAttribute("description") != null ? (String) request.getAttribute("description") : "";
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> unitList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script src="js/select2.min.js"></script>
        <script type="text/javascript" src="jquery-multiSelect/jquery.multiselect.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <link href="js/select2.min.css" rel="stylesheet">
        <link rel="stylesheet" href="jquery-multiSelect/jquery.multiselect.css">
        <link rel="stylesheet" type="text/css" href="js/jquery.dataTables.css">
        <script  type="text/javascript">
            $(document).ready(function () {
                $("#areaID").select2();
                $("#projectID").select2();
                $("#units").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[1, "asc"]],
                });
            });

            function viewProject() {
                document.unitsearchForm.action = "<%=context%>/SearchServlet?op=accSrchUnit&areaIDRes=" + $("#areaID").val();
                document.unitsearchForm.submit();
            }

            function unitSearch() {
                if ($("#areaID").val() === '') {
                    alert("<fmt:message key="regionMsg"/>");
                    return;
                }
                document.unitsearchForm.submit();
            }
            function getProjectMeterPrice() {
                var projectID = $("#projectID").val();
                var meterPriceTitle = '<fmt:message key="priceTip"/>: ';
                if(projectID !== 'all') {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ProjectServlet?op=getProjectAccountingByID",
                        data: {
                            projectID: projectID
                        },
                        success: function(jsonString) {
                            var data = $.parseJSON(jsonString);
                            if (data.status === 'ok') {
                                if(data.meterPrice === '0' || data.meterPrice === '') {
                                    meterPriceTitle += '<fmt:message key="none"/>';
                                } else {
                                    meterPriceTitle += data.meterPrice;
                                }
                                $("#meterPriceDiv").html("");
                            } else if (data.status === 'fail') {
                                meterPriceTitle += '<fmt:message key="none"/>';
                            }
                            $("#meterPriceDiv").html(meterPriceTitle);
                        }
                    });
                } else {
                    $("#meterPriceDiv").html("");
                }
            }
        </script>
        <style type="text/css">
            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
                height: 2px;
            }
        </style>
    </head>
    <body>
        <form name="unitsearchForm" method="POST" action="<%=context%>/SearchServlet?op=accSrchUnit&search=true">
            <fieldset align=center class="set" style="border-color: #006699; width: 80%;">
                <legend align="center">
                    <font color="#005599" size="5">
                    <fmt:message key="accurateUnitSearch"/>
                    </font>
                </legend>
                <table class="table" align="center" style="width: 80%;" dir=<fmt:message key="direction"/>>
                    <tr>
                        <td class="blueHeaderTD" style="font-size: 18px; border: none; padding: 10px;">
                            <b>
                                <font size="3" color="white"><fmt:message key="region"/>
                            </b>
                        </td>
                        </div>
                        <td style="text-align: center; padding: 10px;" colspan="3">
                            <select name="areaID" id="areaID" style="width:100%; height: 100%; font-size: larger; text-align-last:center;" onchange="viewProject();">
                                <option value="">
                                    <fmt:message key="choose"/>
                                </option>
                                <option value="all" <%="all".equals(areaID) ? "selected" : ""%>>
                                    <fmt:message key="all"/>
                                </option>
                                <sw:WBOOptionList wboList="<%=areaList%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=areaID%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueHeaderTD" style="font-size: 18px; padding: 10px;">
                            <b>
                                <font size="3" color="white"><fmt:message key="project"/>
                            </b>
                        </td>
                        <td style="text-align: center; padding: 10px;" colspan="3">
                            <select name="projectID" id="projectID" style="width: 100%; height: 100%; font-size: larger; text-align-last:center;" class="js-example-basic-multiple js-states form-control"
                                    onchange="JavaScript: getProjectMeterPrice();">
                                <option value="all">
                                    <fmt:message key="all"/>
                                </option>
                                <sw:WBOOptionList wboList="<%=projectList%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                            <div id="meterPriceDiv" style="width: 100%; text-align: center; height: 15px; font-size: 11px; font-weight: bolder; color: red; padding-top: 5px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueHeaderTD" style="font-size: 18px; width: 5%; padding: 10px;">
                            <b>
                                <font size="3" color="white"><fmt:message key="unitArea"/>
                            </b>
                        </td>
                        <td style="text-align: center; width: 10%; padding: 10px;">
                            <select name="unitArea" id="unitArea" style="width:100%; height: 100%; font-size: larger; text-align-last:center;">
                                <option value="all">
                                    <fmt:message key="allSpaces"/>
                                </option>
                                <option value="100" <%=unitArea.equals("100") ? "selected" : ""%>>
                                    100
                                </option>
                                <option value="100-120" <%=unitArea.equals("100-120") ? "selected" : ""%>>
                                    100-120
                                </option>
                                <option value="120-160" <%=unitArea.equals("120-160") ? "selected" : ""%>>
                                    120-160
                                </option>
                                <option value="160-220" <%=unitArea.equals("160-220") ? "selected" : ""%>>
                                    160-220
                                </option>
                                <option value="220" <%=unitArea.equals("220") ? "selected" : ""%>>
                                    <fmt:message key="moreThan"/> 220
                                </option>
                            </select>
                        </td>
                        <td class="blueHeaderTD" style="font-size: 18px; width: 5%; padding: 10px;">
                            <b>
                                <font size="3" color="white"><fmt:message key="inDescription"/>
                            </b>
                        </td>
                        <td style="text-align: center; width: 10%; padding: 10px;">
                            <input type="text" id="description" name="description" value="<%=description%>"
                                   style="width:100%; height: 100%; font-size: larger; text-align-last:center;"/>
                        </td>
                    </tr>  
                </table>
                <center>
                    <div class="button" style="width: 25%; text-align: center; margin: 20px;" onclick="unitSearch();">
                        <span >
                            <fmt:message key="search"/>
                        </span>
                    </div>
                </center>
            </fieldset>
        </form>
        <%if (unitList != null) {%>
        <br/>
        <div style="width: 90%;margin-right: auto;margin-left: auto;" id="showUnits" dir="<fmt:message key="direction"/>">
            <table width="100%" id="units">
                <thead>
                    <tr>
                        <th style="color: #005599 !important; font-weight: bold;"><b> <fmt:message key="owner"/> </b></th>
                        <th style="color: #005599 !important; font-weight: bold;"><b> <fmt:message key="clientMob"/> </b></th>
                        <th style="color: #005599 !important; font-weight: bold;"><b> <fmt:message key="unit"/> </b></th>
                        <th style="color: #005599 !important; font-weight: bold;"><b> <fmt:message key="project"/> </b></th>
                        <th style="color: #005599 !important; font-weight: bold;"><b> <fmt:message key="region"/> </b></th>
                        <th style="color: #005599 !important; font-weight: bold;"><b> <fmt:message key="area"/> </b></th>
                        <th style="color: #005599 !important; font-weight: bold;"><b> <fmt:message key="desc"/> </b></th>
                    </tr>
                </thead>
                <tbody>  
                    <%
                        WebBusinessObject wbo = new WebBusinessObject();
                        for (int i = 0; i < unitList.size(); i++) {
                            wbo = unitList.get(i);
                    %>
                    <tr style="cursor: pointer" id="row">
                        <td nowrap>
                            <b>
                                <%=wbo.getAttribute("clientName")%>
                            </b>
                        </td>
                        <td nowrap>
                            <b>
                                <%=wbo.getAttribute("clientMobile")%>
                            </b>
                        </td>
                        <td nowrap>
                            <b>
                                <%=wbo.getAttribute("unitName")%>
                            </b>
                        </td>
                        <td nowrap>
                            <b>
                                <%=wbo.getAttribute("projectName")%>
                            </b>
                        </td>
                        <td nowrap>
                            <b>
                                <%=wbo.getAttribute("regionName")%>
                            </b>
                        </td>
                        <td nowrap>
                            <b>
                                <%=wbo.getAttribute("area")%>
                            </b>
                        </td>
                        <td>
                            <b>
                                <%=wbo.getAttribute("projectDesc")%>
                            </b>
                        </td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <br/>
            <br/>
        </div>
        <script type="text/javascript">
            getProjectMeterPrice();
        </script>
        <%}%>
    </body>
</html>
