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

        List<WebBusinessObject> departments = (List) request.getAttribute("departments");
        List<WebBusinessObject> loads = (List) request.getAttribute("loads");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        int a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;

        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, groupByStr, print, title;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            groupByStr = "&#1575;&#1604;&#1602;&#1587;&#1605; ";
            title = "Employees Load";
            print = "get report";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            groupByStr = "&#1575;&#1604;&#1602;&#1587;&#1605; ";
            title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1581;&#1605;&#1575;&#1604; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;&#1610;&#1606;";
            print = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; ";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Employees Load</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript">
            var oTable;
            $(document).ready(function() {
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
            /* preparing pie chart */
            var chart;
            $(document).ready(function() {
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
                        formatter: function() {
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
                                formatter: function() {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            }
                        }
                    },
                    series: [{
                            type: 'pie',
//                            data: 
                        }]
                });
            });
            /* -preparing pie chart */

        </script>

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
            document.EmployeesLoads.action = "<%=context%>/ReportsServlet?op=employeesLoadReport&departmentId=" + $("#departmentId").val();
            document.EmployeesLoads.submit();
        }

        function cancelForm() {
            document.Stat.action = "<%=context%>/SearchServlet?op=Projects";
            document.Stat.submit();
        }

        function callbackFillreload() {
            if (req.readyState == 4)
            {
                if (req.status == 200)
                {
                    window.location.reload();
                }
            }
        }
    </script>
    <style>

        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
        #row:hover{
            background-color: #EEEEEE;
        }
        .client_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addclient.png);
        }
        .company_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addCompany.png);
        }
        .enter_call {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
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

    <BODY>
        <FORM name="EmployeesLoads" method="post">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            </DIV>  
            <br>
            <FIELDSET class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                    <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> <%=groupByStr%></b>
                        </TD>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">

                        </TD>
                    </TR>
                    <TR>

                        <TD style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" >
                            <select style="width: 50%; height: 50%;" id="departmentId" name="departmentId" onchange="submitForm()">
                                <option value="">اختر القسم .....</option>
                                <sw:WBOOptionList displayAttribute="projectName" valueAttribute="projectID" wboList="<%=departments%>" scrollToValue='<%=request.getParameter("departmentId")%>' />
                            </select>
                        </TD>

                        <td  bgcolor="#dedede"  style="text-align:right" valign="middle">
                            <button  onclick="JavaScript: submitForm();"   STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; "><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                            <br><br>
                        </td>

                    </TR>
                </TABLE>

                <br>
                <% if (loads != null && loads.size() > 0) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الموظف</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">إستلام</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">مرسل</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">علم</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">تم التوزيع</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">تم الرفض</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">تم الانهاء</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">تم الاغلاق</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">الكل</th>
                            </tr>
                        <thead>
                        <tbody>
                            <% for (WebBusinessObject wbo_ : loads) {
                                    int totalRow = 0; %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <%if (wbo_.getAttribute("currentOwnerFullName") != null) {%>
                                    <b><%=wbo_.getAttribute("currentOwnerFullName")%></b>
                                    <% }%>
                                </TD>

                                <TD>
                                    <%if (wbo_.getAttribute("1") != null) {
                                            totalRow += Integer.valueOf((String) wbo_.getAttribute("1"));
                                            a += Integer.valueOf((String) wbo_.getAttribute("1"));
                                    %>
                                    <b><%=wbo_.getAttribute("1")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo_.getAttribute("2") != null) {
                                            totalRow += Integer.valueOf((String) wbo_.getAttribute("2"));
                                            b += Integer.valueOf((String) wbo_.getAttribute("2"));
                                    %>
                                    <b><%=wbo_.getAttribute("2")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo_.getAttribute("3") != null) {
                                            totalRow += Integer.valueOf((String) wbo_.getAttribute("3"));
                                            c += Integer.valueOf((String) wbo_.getAttribute("3"));
                                    %>
                                    <b><%=wbo_.getAttribute("3")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo_.getAttribute("4") != null) {
                                            totalRow += Integer.valueOf((String) wbo_.getAttribute("4"));
                                            d += Integer.valueOf((String) wbo_.getAttribute("4"));
                                    %>
                                    <b><%=wbo_.getAttribute("4")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo_.getAttribute("5") != null) {
                                            totalRow += Integer.valueOf((String) wbo_.getAttribute("5"));
                                            e += Integer.valueOf((String) wbo_.getAttribute("5"));
                                    %>
                                    <b><%=wbo_.getAttribute("5")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo_.getAttribute("6") != null) {
                                            totalRow += Integer.valueOf((String) wbo_.getAttribute("6"));
                                            f += Integer.valueOf((String) wbo_.getAttribute("6"));
                                    %>
                                    <b><%=wbo_.getAttribute("6")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo_.getAttribute("7") != null) {
                                            totalRow += Integer.valueOf((String) wbo_.getAttribute("7"));
                                            g += Integer.valueOf((String) wbo_.getAttribute("7"));
                                    %>
                                    <b><%=wbo_.getAttribute("7")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}
                                        h += totalRow;%>
                                </TD>
                                <TD>
                                    <b><%=totalRow%></b>
                                </TD>

                            </tr>
                            <% }%>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <b>الكل</b>
                                </TD>
                                <TD>
                                    <b><%=a%></b>
                                </TD>
                                <TD>
                                    <b><%=b%></b>
                                </TD>
                                <TD>
                                    <b><%=c%></b>
                                </TD>
                                <TD>
                                    <b><%=d%></b>
                                </TD>
                                <TD>
                                    <b><%=e%></b>
                                </TD>
                                <TD>
                                    <b><%=f%></b>
                                </TD>
                                <TD>
                                    <b><%=g%></b>
                                </TD>
                                <TD>
                                    <b><%=h%></b>
                                </TD>
                            </tr>
                        </tbody>  
                    </TABLE>
                </div>
                <%}%>
                <br/>
            </FIELDSET>

        </FORM>
    </BODY>
</HTML>     
