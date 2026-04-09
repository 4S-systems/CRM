<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
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

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar c = Calendar.getInstance();
        String buildingId = (String) request.getAttribute("buildingId");
        WebBusinessObject buildingWbo = (WebBusinessObject) request.getAttribute("buildingWbo");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, delete;

        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            delete = "Delete";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            delete = "حذف";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function deleteUnit(unitId, rowNo) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=deleteUnitByAjax",
                    data: {
                        unitId: unitId
                    }
                    ,
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("تم الحذف بنجاح");
                            $("#row" + rowNo).remove();
                        } else if (info.status == 'faild') {
                            alert("لم يتم الحذف");
                        }
                    }
                });
            }
            
            $(document).ready(function() {
                $('#unitsList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10], [10]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                })
            });
        </SCRIPT>
        <style>
            #products
            {
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }
            #products tr
            {
                padding: 5px;
            }
            #products td
            {  
                font-size: 12px;
                font-weight: bold;
            }
            #products select
            {                
                font-size: 12px;
                font-weight: bold;
            }

        </style>
    </head>
    <BODY>
        <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup('units_list')"/>
        </div>
        <div class="login" style="width: 90%;float: left;margin: 0px 0xp;">
            <input type="hidden" name="buildingId" value="<%=buildingId%>"/>
            <b style="font-size: x-large; color: black;"><%=buildingWbo.getAttribute("projectDesc") != null ? buildingWbo.getAttribute("projectDesc") : ""%></b>
            <TABLE  id="unitsList" CELLPADDING="4" style="width: 100%;" CELLSPACING="2" STYLE="border:none;" align="center"  DIR="<%=dir%>">
                <thead>
                    <tr>
                        <th nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold; width: 60%;">
                            <fmt:message key="unit"/>
                        </th>
                        <th nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold; width: 20%;">
                            <fmt:message key="status"/>
                        </th>
                        <th nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold; width: 20%;">
                            &nbsp;
                        </th>
                        <th nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold; width: 20%;">
                            &nbsp;
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int i = 0;
                        if (unitsList != null) {
                            for (WebBusinessObject wbo : unitsList) {
                                String unitName = (String) wbo.getAttribute("projectName");
                                String unitStatusId = (String) wbo.getAttribute("statusName");
                                String unitStatus = "";
                                String color = "";
                                if (wbo.getAttribute("statusName") != null) {
                                    if (unitStatusId.equalsIgnoreCase("8")) {
                                        unitStatus = "متاحة";
                                        color = "green";
                                    } else if (unitStatusId.equalsIgnoreCase("9")) {
                                        unitStatus = "محجوزة";
                                        color = "red";
                                    } else if (unitStatusId.equalsIgnoreCase("10")) {
                                        unitStatus = "مباعة";
                                        color = "blue";
                                    } else if (unitStatusId.equalsIgnoreCase("33")) {
                                        unitStatus = "حجز مرتجع";
                                        color = "purple";
                                    }
                                }
                    %>
                    <tr id="row<%=i%>">
                        <TD WIDTH="100%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                            <%=unitName%>
                        </TD>
                        <TD WIDTH="100%" STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;" nowrap>
                            <b style="color: <%=color%>;"><%=unitStatus%></b>
                        </TD>
                        <TD WIDTH="100%" STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;" nowrap>
                            <img src="images/available_house.JPG" width="25" style="display: <%=unitStatusId.equalsIgnoreCase("8") ? "" : "none"%>"/>
                            <img src="images/reserved_house.JPG" width="25" style="display: <%=unitStatusId.equalsIgnoreCase("9") || unitStatusId.equalsIgnoreCase("33") ? "" : "none"%>"/>
                            <img src="images/house.JPG" width="25" style="display: <%=unitStatusId.equalsIgnoreCase("10") ? "" : "none"%>"/>
                        </TD>
                        <TD WIDTH="100%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                            <a href="#" onclick="JavaScript: deleteUnit('<%=wbo.getAttribute("projectID")%>', '<%=i%>');"><%=delete%></a>
                        </TD>
                    </tr>
                    <%
                                i++;
                            }
                        }
                    %>
                </tbody>
            </TABLE>
        </div>
    </BODY>
</html>