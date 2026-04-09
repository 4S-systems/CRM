<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
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
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> buildingsList = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        String stat = (String) request.getSession().getAttribute("currentMode");
        if (stat.equals("En")) {
        } else {
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#buildings').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            function generateGarages(buildingNo, projectID) {
                var garageNo = $("#garageNo" + buildingNo).val();
                if (garageNo !== '') {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ProjectServlet?op=generateBuildingGaragesAjax",
                        data: {
                            projectID: projectID,
                            garageNo: $("#garageNo" + buildingNo).val(),
                            buildingNo: buildingNo
                        }, success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                alert("<fmt:message key="garageGeneratedMsg"/>");
                            } else if (info.status === 'no') {
                                alert("<fmt:message key="failToGenerateMsg" />");
                            }
                        }
                    });
                } else {
                    alert("<fmt:message key="garageNoRequiresMsg"/>");
                    $("#garageNo" + buildingNo).focus();
                }
            }
        </script>
        <style type="text/css">
        </style>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 65%; border-color: #006699;">
            <legend align="center">
                <font color="#005599" size="5">
                <fmt:message key="addGarages" />
                </font>
            </legend>
            <br/>
            <div style="width: 75%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <table align="center" dir=<fmt:message key="direction"/> id="buildings" style="width:100%;">
                    <thead>
                        <tr>           
                            <th>
                                <b><fmt:message key="building" /></b>
                            </th>
                            <th>
                                <b><fmt:message key="garages" /></b>
                            </th>
                            <th>
                                <b>&nbsp;</b>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (WebBusinessObject buildingWbo : buildingsList) {
                        %>
                        <tr>
                            <td>
                                <b><%=buildingWbo.getAttribute("buildingNo")%></b>
                            </td>
                            <td>
                                <input type="number" min="1" name="garageNo" id="garageNo<%=buildingWbo.getAttribute("buildingNo")%>" style="width: 50px;" />
                            </td>
                            <td>
                                <a href="JavaScript: generateGarages('<%=buildingWbo.getAttribute("buildingNo")%>', '<%=buildingWbo.getAttribute("mainProjId")%>')">
                                    <img src="images/garage-icon.png" style="width: 50px;" title="Generate Garages" />
                                </a>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <br />
            </div>
        </fieldset>
    </body>
</html>
