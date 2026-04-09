<%@page import="java.util.List"%>
<%@page import="flexjson.JSONSerializer"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<!DOCTYPE HTML>
<html>
    <%
        MetaDataMgr metaMgr =  MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");
        String ratingCategories = (String) request.getAttribute("ratingCategories");
        String resultsJson = (String) request.getAttribute("resultsJson");
        
        String id = (String) request.getAttribute("id");
        String searchBy = (String) request.getAttribute("searchBy");

        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, yTitle, grp, print, fromDate, toDate, div, dip, dateTit;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Client Employee Rates";
            yTitle= "Clients Number";
            grp = "Groups";
            print = "View";
            fromDate = "From Date";
            toDate = "To Date";
            div = "By Division";
            dip = "By Department";
            dateTit = "Rating Date";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title  = "احصائيات نسب العملاء بالنسبة للعاملين";
            yTitle= "اعداد العملاء";
            grp = "المجموعات";
            print = "عرض";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            div = "بالمجموعه";
            dip = "بالقسم";
            dateTit = "تاريخ التصنيف";
        }
        
        ArrayList<WebBusinessObject> usrGroups = (ArrayList<WebBusinessObject>) request.getAttribute("usrGroups");
        List<WebBusinessObject> departments = (List<WebBusinessObject>) request.getAttribute("departments");
        String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";
    %>

    <head>  
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" language="javascript">
            var chart;
            var chartCount;
            
            $(document).ready(function () {
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                var searchBy = '<%=searchBy%>';
                if(searchBy === "byGroup"){
                    $("#grpID option[value=<%=id%>]").attr('selected', 'selected');
                } else {
                    $("#departmentId option[value=<%=id%>]").attr('selected', 'selected');
                }
            });

            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        type: 'column'
                    },
                    title: {
                        text: $('#title').val()
                    },
                    xAxis: {
                        categories: <%=ratingCategories%>
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: $('#yTitle').val()
                        }
                    },
                    tooltip: {
                        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                        footerFormat: '</table>',
                        shared: true,
                        useHTML: true
                    },
                    plotOptions: {
                        column: {
                            pointPadding: 0.2,
                            borderWidth: 0
                        }
                    },
                    series: <%=resultsJson%>
                });
            });
            
            function showChart(){
                var fromDate = $("#fromDate").val();
                var toDate = $("#toDate").val();
                var id = $("#departmentId").val();
                var name = $("#departmentId option:selected").text();
                var searchBy = "byDepartment";
                if (document.getElementById('searchByGroup').checked == true) {
                    id = $("#grpID").val();
                    name = $("#grpID option:selected").text();
                    searchBy = "byGroup";
                }
                //var groupID = $("#grpID").val();
                this.document.location.href = "<%=context%>/ReportsServletThree?op=clientEmployeeBarChartReport&groupID="+ id + "&searchBy=" + searchBy + "&fromDate=" + fromDate + "&toDate=" + toDate;
            }
            
            function switchSearch() {
            if (document.getElementById('searchByDepartment').checked == true) {
                document.getElementById('searchByGroup').checked = false;
                $("#departmentId").removeAttr('disabled');
                $("#grpID").attr('disabled', 'disabled');
            } else {
                document.getElementById('searchByDepartment').checked = false;
                $("#grpID").removeAttr('disabled');
                $("#departmentId").attr('disabled', 'disabled');
            }
        }
        </script>
    </head>
    <body>
        <input type="hidden" value="<%=title%>" id="title">
        <input type="hidden" value="<%=yTitle%>" id="yTitle">
        
        <FIELDSET class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <TABLE class="blueBorder" ALIGN="center" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="65%" STYLE="border-width:1px;border-color:white;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px;" id="fromDate" name="fromDate" size="20" maxlength="100" title="<%=dateTit%>" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>" />
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true" title=" <%=dateTit%>"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    <TR>
                        <TD style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" colspan="1">
                            <ul style="padding-top: 10px; font-weight: bold; font-size: 16px; color: blue; list-style-type: none;">
                                <li>
                                    <input type="radio" id="searchByDepartment" name="searchBy" onchange="switchSearch();" style="margin-right: 75px;">
                                    <%=dip%>
                                    <ul>
                                        <select style="width: 50%; font-weight: bold; font-size: 13px; margin-right: 75px;" id="departmentId" name="departmentId">
                                            <sw:WBOOptionList displayAttribute="projectName" valueAttribute="projectID" wboList="<%=departments%>" scrollToValue='<%=request.getParameter("departmentId")%>' />
                                        </select>
                                    </ul>
                                </li>
                            </ul>
                        </TD>
                        <TD style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" colspan="1">
                            <ul style="padding-top: 10px; font-weight: bold; font-size: 16px; color: blue; list-style-type: none;">
                                <li>
                                    <input type="radio" id="searchByGroup" name="searchBy" onchange="switchSearch();" style="margin-right: 75px;"/>
                                    <%=div%>
                                    <ul>
                                        <select style="width: 50%; font-weight: bold; font-size: 13px;margin-right: 75px;" disabled="disabled" id="grpID" name="grpID">
                                            <sw:WBOOptionList displayAttribute="groupName" valueAttribute="group_id" wboList="<%=usrGroups%>" scrollToValue='<%=request.getParameter("group_id")%>' />
                                        </select>
                                    </ul>
                                </li>
                            </ul>
                        </TD>
                    </TR>
                    <TR>
                        <td  bgcolor="#dedede"  style="text-align:center; padding-bottom: 5px; padding-top: 5px" valign="middle" colspan="2">
                            <button  onclick="showChart()" STYLE="color: #000;font-size:15px;font-weight:bold;height: 35px"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        </td>
                    </TR>
                </TABLE>
        </fieldset>
        <%--<table ALIGN="center" DIR="center" WIDTH="25%" CELLSPACING=2 CELLPADDING=1>
            <tr>
                <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                    <input type="text" value="<%=grp%>" id="grpTitle" style="background: url(../images/thbg.jpg); width: 100%; text-align: center; border: none; color: white;" readonly>
                </td>
                <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                    <div id="grpDiv">
                        <select id="grpID" name="grpID" style="font-size: 14px; width: 90%" onchange="showChart()">
                            <option value=""> Choose Group </option>
                           <sw:WBOOptionList wboList="<%=usrGroups%>" displayAttribute="groupName" valueAttribute="group_id" scrollToValue="<%=groupID%>"/>
                        </select>
                    </DIV>
            </tr>
        </table>--%>
        <div id="container" style="height: 300px; width: 100%;">
        </div>
    </body>
</html>