<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> campaignClientsCounts = (ArrayList<WebBusinessObject>) request.getAttribute("campaignClientsCounts");
        ArrayList<String> campaignIDsList = (ArrayList<String>) request.getAttribute("campaignIDsList");
        int totalClientsCount = 0;
        if (request.getAttribute("totalClientsCount") != null) {
            totalClientsCount = (Integer) request.getAttribute("totalClientsCount");
        }
        String jsonText = (String) request.getAttribute("jsonText");
        String startDateVal = request.getAttribute("startDate") == null ? "" : (String) request.getAttribute("startDate");
        String endDateVal = request.getAttribute("endDate") == null ? "" : (String) request.getAttribute("endDate");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, clientsCountStr, campaignStr, startDate, endDate, display, RatesStr, source, responsible, view,
                soldCountStr, campaignEffective, campaignDate, expectedCountStr, details;
        int totalclients = 0;
        if (campaignClientsCounts != null) {
            totalclients = campaignClientsCounts.size();
        }
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Campaign Effectiveness";
            campaignStr = "Campaign";
            clientsCountStr = "Clients Count";
            startDate = "Start Date";
            endDate = "End Date";
            display = " Generate Report ";
            RatesStr = "Client Rates";
            source = "Source Statistics";
            responsible = "Responsible Statisitics";
            view = "View";
            soldCountStr = "Sold Count";
            campaignEffective = "Campaign Effectiveness";
            campaignDate = "Client Campaign Join Date";
            expectedCountStr = "Expected No.";
            details = "S.C. Details";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "كفاءة الحملة";
            campaignStr = "الحملة";
            clientsCountStr = "عدد العملاء";
            startDate = "من تاريخ";
            endDate = "ألي تاريخ";
            display = "أعرض التقرير";
            RatesStr = "توزيعة العملاء";
            source = "أحصائيات المصدر";
            responsible = "أحصائيات المسؤول";
            view = "أعرض";
            soldCountStr = "المبيعات";
            campaignEffective = "فاعلية الحملة";
            campaignDate = "تاريخ أنضمام العميل للحملة";
            expectedCountStr = "المتوقع";
            details = "تفاصيل ح ف";
        }

        String campaignType = request.getAttribute("campaignType") != null ? (String) request.getAttribute("campaignType") : "all";

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Equipment Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.8.9.custom.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                $("#clients").css("display", "none");
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            var totalselectedclients = 0;
            var actualtotalclients =<%=totalclients%>;
            var counter = 0;
            function toggle(source) {
                totalselectedclients = 0;
                counter = 0;
                $(".campaignschck").each(function () {
                    this.checked = source.checked;
                    totalselectedclients = Number(totalselectedclients) + Number(this.value);
                });
                if (!source.checked)
                {
                    totalselectedclients = 0;
                    counter = 0;
                }
                else {
                    counter = actualtotalclients;
                }

                $("#totalclients").text(totalselectedclients);

            }
            $(function () {
                $("#selectall").trigger('click');
                $(".campaignschck").click(function () {
                    if (this.checked)
                    {
                        counter++;
                        totalselectedclients = Number(totalselectedclients) + Number(this.value);
                    }
                    else
                    {
                        counter--;
                        totalselectedclients = Number(totalselectedclients) - Number(this.value);
                    }
                    $("#totalclients").text(totalselectedclients);
                    if (counter == 0) {
                        $("#selectall").prop("checked", false);
                    }
                    else if (counter == actualtotalclients) {
                        $("#selectall").prop("checked", true)
                    }
                    ;
                    ;
                });

                $("#startDate,#endDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            /* preparing pie chart */
            var chart;
            $(document).ready(function () {

                var id = $("#campaignTypeRadio").val();
                $("#" + id).prop("checked", true);

                $('input[type=radio][name=campaignType]').change(function () {
                    var campaignType = $('input[name=campaignType]:checked').val();
                    console.log("campaignType = " + campaignType);
                    document.Stat.action = "<%=context%>/ReportsServletThree?op=campaignClientsReport&campaignType=" + campaignType;
                    document.Stat.submit();
                });

                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    },
                    title: {
                        text: null
                    },
                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                        }
                    },
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            }
                        }
                    },
                    series: [{
                            type: 'pie',
                            data: <%=jsonText%>
                        }]
                });
            });
            /* -preparing pie chart */
        </script>
        <style>
            .fSize {
                font-size: 16px;
            }
            a.fSize:hover {
                font-size: 16px;
            }
        </style>
    </HEAD>
    <script language="javascript" type="text/javascript">
        function changePage(url) {
            window.navigate(url);
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
            document.Stat.action = "<%=context%>/ReportsServletThree?op=campaignClientsReport";
            document.Stat.submit();
        }
        function exportToExcel() {
            openInNewWindow("<%=context%>/ReportsServletThree?op=campaignClientsReport&excel=true&startDate="
                    + $("#startDate").val() + "&endDate=" + $("#endDate").val() + "&campaignType="
                    + $('input[name="campaignType"]:checked').val() + "&campaignTypeRadio=" + $("#campaignTypeRadio").val());
        }
        var divTag;
        function showChart(campaignID, type) {
            openInNewWindow("<%=context%>/ReportsServletThree?op=campaignUsersRatioReport&campaignID=" + campaignID + "&type=" + type + "&startDate=" + $("#startDate").val() + "&endDate=" + $("#endDate").val());
        }
        function openInNewWindow(url) {
            var win = window.open(url, '_blank');
            win.focus();
        }
    </script>
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <div id="usersRationDiv"></div>
        <FORM name="Stat" action="post">
            <FIELDSET align=center class="set" >
                <legend align="center"> 
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                    <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                            <b title="<%=campaignDate%>"><font size=3 color="white"> <%=startDate%></b>
                        </TD>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                            <b title="<%=campaignDate%>"><font size=3 color="white"> <%=endDate%></b>
                        </TD>
                    </TR>
                    <TR>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                                   value="<%=startDateVal%>" title="<%=campaignDate%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                                   value="<%=endDateVal%>" title="<%=campaignDate%>"/>
                        </td>
                    </TR>
                    <TR>
			<td  bgcolor="#dedede" valign="middle">
			    <DIV align="center" STYLE="color:blue; width: 100%;">
				<input type="button"  value="<%=display%>"  onclick="submitForm()" class="button" style="width: 50%;">
				<input type="hidden" name="op" value="campaignClientsReport">
			    </DIV>
			</TD>
			
                        <td  bgcolor="#dedede" valign="middle" style="height: 90px;">
                            <div style="text-align: left; width: 80%; margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                                <b> <font color="black" size="3"> All Campaign </font> </b> <input type="radio" name="campaignType" id="allCampaign" value="allCampaign" checked/><br/>
                                <b> <font color="black" size="3"> Active Campaign </font> </b><input type="radio" name="campaignType" id="activeCampaign" value="activeCampaign" /><br/>
                                <b> <font color="black" size="3"> Main Campaign </font> </b><input type="radio" name="campaignType" id="mainCampaign" value="mainCampaign" /> 
                                <input type="hidden" name="campaignTypeRadio" id="campaignTypeRadio" value="<%=campaignType%>" >
                            </div>
                        </td>
                    </TR>
                </TABLE>


                <BR>
                <center> <font size="3" color="red"><b> <%=clientsCountStr%> : <%=totalClientsCount%></b> </font></center>
                <br><br>
                <CENTER>
                    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
                    <br><br>
                    <%
                        if (campaignClientsCounts != null) {
                    %>
                    <!--button type="button" style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #000;font-size:15px;font-weight:bold; width: 150px; height: 30px; vertical-align: top;"
                            onclick="JavaScript: exportToExcel();" title="Export to Excel">Excel &nbsp; &nbsp;<img height="15" src="images/icons/excel.png" />
                    </button>
                    <br/-->
                    <br/>
                    <div style="width: 900px; margin-right: auto; margin-left: auto;">
                        <TABLE id="clients" width="100%" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="5" CELLSPACING="0">
                            <thead>
                                <TR  bgcolor="#C8D8F8">
                                    <th style="font-size: 20px;">
                                        <%=campaignStr%>
                                    </th>
                                    <th style="font-size: 20px;">
                                        <%=clientsCountStr%>
                                    </th>
                                    <%
                                        if(!campaignType.equals("mainCampaign")) {
                                    %>
                                    <th style="font-size: 20px;">
                                        <%=soldCountStr%>
                                    </th>
                                    <th style="font-size: 20px;">
                                        <%=campaignEffective%>
                                    </th>
                                    <th style="font-size: 20px;">
                                        <%=expectedCountStr%>
                                    </th>
                                    <th style="font-size: 20px;">
                                        <%=RatesStr%>
                                    </th>
                                    <th style="font-size: 20px;">
                                        <%=source%>
                                    </th>
                                    <th style="font-size: 20px;">
                                        <%=responsible%>
                                    </th>
                                    <%
                                        } else {
                                    %>
                                    <th style="font-size: 20px;">
                                        <%=details%>
                                    </th>
                                    <%
                                        }
                                    %>
                                </TR>
                            </thead>
                            <tbody>
                            <%
                                int totalSold = 0;
                                long expectedCount, totalExpected = 0;
                                DecimalFormat df = new DecimalFormat("#");
                                for (WebBusinessObject wbo : campaignClientsCounts) {
                                    if (campaignIDsList.contains((String) wbo.getAttribute("campaignID"))) {
                                        totalSold += Integer.valueOf(wbo.getAttribute("soldCount") + "");
                                        expectedCount = Long.valueOf(wbo.getAttribute("clientCount") + "") - Long.valueOf(wbo.getAttribute("soldCount") + "");
                                        totalExpected += expectedCount;
                            %>
                                <TR>
                                    <TD>
                                        <a class="fSize" href="<%=context%>/ClientServlet?op=getCampaignClients&campaignID=<%=wbo.getAttribute("campaignID")%>&beginDate=<%=startDateVal%>&endDate=<%=endDateVal%>"><%=wbo.getAttribute("campaignTitle")%></a>
                                    </TD>
                                    <TD>
                                        <a class="fSize" href="<%=context%>/ClientServlet?op=getCampaignClients&campaignID=<%=wbo.getAttribute("campaignID")%>&beginDate=<%=startDateVal%>&endDate=<%=endDateVal%>"><%=wbo.getAttribute("clientCount")%></a>
                                    </TD>
                                    <%
                                        if(!campaignType.equals("mainCampaign")) {
                                    %>
                                    <TD>
                                        <a class="fSize" href="<%=context%>/ClientServlet?op=getCampaignSoldClients&campaignID=<%=wbo.getAttribute("campaignID")%>&beginDate=<%=startDateVal%>&endDate=<%=endDateVal%>"><%=wbo.getAttribute("soldCount")%></a>
                                    </TD>
                                    <TD>
                                        <b class="fSize"><%=wbo.getAttribute("percent")%> %</b>
                                    </TD>
                                    <td>
                                        <a class="fSize" href="<%=context%>/ClientServlet?op=getCampaignNonSoldClients&campaignID=<%=wbo.getAttribute("campaignID")%>&beginDate=<%=startDateVal%>&endDate=<%=endDateVal%>"><%=expectedCount%></a>
                                    </td>
                                    <TD>
                                        <a class="fSize" href="<%=context%>/ClientServlet?op=getCampaignClientsRating&campaignID=<%=wbo.getAttribute("campaignID")%>&beginDate=<%=startDateVal%>&endDate=<%=endDateVal%>">Rating Statistics</a>
                                    </TD>
                                    <TD>
                                        <a class="fSize" href="#" onclick="JavaScript: showChart('<%=wbo.getAttribute("campaignID")%>', 'source');"><%=view%></a>
                                    </TD>
                                    <TD>
                                        <a class="fSize" href="#" onclick="JavaScript: showChart('<%=wbo.getAttribute("campaignID")%>', 'responsible');"><%=view%></a>
                                    </TD>
                                    <%
                                        } else {
                                    %>
                                    <td>
                                        <a class="fSize" target="detailsTab" href="<%=context%>/ReportsServletThree?op=getCampaignClientDetails&campaignID=<%=wbo.getAttribute("campaignID")%>&startDate=<%=startDateVal%>&endDate=<%=endDateVal%>"><%=expectedCount%></a>
                                    </td>
                                    <%
                                        }
                                    %>
                                </TR>      
                            <%
                                    }
                                }
                            %>
                            </tbody>
                            <tfoot>
                                <TR  bgcolor="#C8D8F8">
                                    <th colspan="1">Total Clients</th>
                                    <th colspan="1"> <%=totalSold + totalExpected%></th>
                                    <%
                                        if(!campaignType.equals("mainCampaign")) {
                                    %>
                                    <th colspan="1"> <%=totalSold%></th>
                                    <th colspan="1"> &nbsp;</th>
                                    <th colspan="1"> <%=totalExpected%></th>
                                    <th colspan="3"> </th>
                                    <%
                                        } else {
                                    %>
                                    <th colspan="1"> &nbsp;</th>
                                    <%
                                        }
                                    %>
                                </TR>
                            </tfoot>
                        </TABLE>
                    </div>
                    <%
                        }
                    %>
                    <BR>
                    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
                        <TR>
                            <TD CLASS="td">
                                &nbsp;
                            </TD>
                        </TR>
                    </TABLE>
                </CENTER>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
