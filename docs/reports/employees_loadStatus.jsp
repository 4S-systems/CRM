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
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, groupByStr, print, title, status;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            groupByStr = "&#1575;&#1604;&#1602;&#1587;&#1605; ";
            title = "Employees Load";
            print = "get report";
            status = "Status";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            groupByStr = "&#1575;&#1604;&#1602;&#1587;&#1605; ";
            title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1581;&#1605;&#1575;&#1604; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;&#1610;&#1606;";
            print = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; ";
            status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Employees Load</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>

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
            document.EmployeesLoads.action = "<%=context%>/ReportsServlet?op=employeesLoadStatusReport&departmentId=" + $("#departmentId").val() + "&statusId=" + $("#statusId").val();
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
        /* preparing bar chart */
            var chart;
            $(document).ready(function() {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        defaultSeriesType: 'bar'
                    },
                    title: {
                        text: 'الطلبات'
                    },
                    subtitle: {
                        text: ''
                    },
                    xAxis: {
                        labels: {
                            style: {
                                color: '#6D869F',
                                fontWeight: 'bold'
                            }
                        },
                        categories: [<% if (loads != null) {
                                for (int i = 0; i < loads.size(); i++) {
                                    WebBusinessObject wbo_ = loads.get(i);
                                    if (i > 0) {
                                        out.write(",");
                                    }
                                    out.write("'" + (String) wbo_.getAttribute("userName") + "'");
                                }
                            }%>],
                        title: {
                            text: null
                        }
                    },
                    yAxis: {
                        allowDecimals: false,
                        min: 0,
                        labels: {
                            style: {
                                fontWeight: 'bold'
                            }
                        },
                        title: {
                            text: 'عدد الطلبات',
                            align: 'high'
                        }
                    },
                    tooltip: {
                        formatter: function() {
                            return ' ' + 'طلبات' + ' ' + this.y + ' ';
                        }
                    },
                    plotOptions: {
                        bar: {
                            dataLabels: {
                                enabled: true
                            }
                        }
                    },
                    legend: {
                        layout: 'vertical',
                        align: 'right',
                        verticalAlign: 'top',
                        x: -100,
                        y: 100,
                        floating: true,
                        borderWidth: 1,
                        backgroundColor: '#FFFFFF',
                        shadow: true
                    },
                    credits: {
                        enabled: false
                    },
                    series: [{
                            name: 'الطلبات',
                            data: [<% if (loads != null) {
                                    for (int i = 0; i < loads.size(); i++) {
                                        WebBusinessObject wbo_ = loads.get(i);
                                        if (i > 0) {
                                            out.write(",");
                                        }
                                        out.write((String) wbo_.getAttribute("total"));
                                    }
                                }%>]
                        }]
                });
            });
            /* -preparing bar chart */
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
                            <b><font size=3 color="white"> <%=status%></b>
                        </TD>
                    </TR>
                    <TR>

                        <TD style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" >
                            <select style="width: 50%; height: 50%;" id="departmentId" name="departmentId">
                                <option value="">من فضلك اختر القسم</option>
                                <sw:WBOOptionList displayAttribute="projectName" valueAttribute="projectID" wboList="<%=departments%>" scrollToValue='<%=request.getParameter("departmentId")%>' />
                            </select>
                        </TD>

                        <td  bgcolor="#dedede"  style="text-align:right" valign="middle">
                            <select style="width: 50%; height: 50%;" id="statusId" name="statusId">
                                <option value="">من فضلك اختر الحاله</option>
                                <option value="1" <%=(request.getParameter("statusId")!= null && request.getParameter("statusId").equals("1")) ? "selected" : ""%>>إستلام</option>
                                <option value="2" <%=(request.getParameter("statusId")!= null && request.getParameter("statusId").equals("2")) ? "selected" : ""%>>مرسل</option>
                                <option value="3" <%=(request.getParameter("statusId")!= null && request.getParameter("statusId").equals("3")) ? "selected" : ""%>>علم</option>
                                <option value="4" <%=(request.getParameter("statusId")!= null && request.getParameter("statusId").equals("4")) ? "selected" : ""%>>تم التوزيع</option>
                                <option value="5" <%=(request.getParameter("statusId")!= null && request.getParameter("statusId").equals("5")) ? "selected" : ""%>>تم الرفض</option>
                                <option value="6" <%=(request.getParameter("statusId")!= null && request.getParameter("statusId").equals("6")) ? "selected" : ""%>>تم الانهاء</option>
                                <option value="7" <%=(request.getParameter("statusId")!= null && request.getParameter("statusId").equals("7")) ? "selected" : ""%>>تم الاغلاق</option>
                            </select>
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
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">العدد</th>
                            </tr>
                        <thead>
                        <tbody>
                            <% for (WebBusinessObject wbo_ : loads) { %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <%if (wbo_.getAttribute("userName") != null) {%>
                                    <b><%=wbo_.getAttribute("userName")%></b>
                                    <% }%>
                                </TD>

                                <TD>
                                    <%if (wbo_.getAttribute("total") != null) {%>
                                    <b><%=wbo_.getAttribute("total")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                            </tr>
                            <% }%>
                        </tbody>  
                    </TABLE>
                </div>
                <br/>
                <center><hr style="width: 85%" /></center>
                <div id="container" style="width: 100%; height: 50%; margin: 0 auto"></div>
                <br/>
                <center><hr style="width: 85%" /></center>
                <%} else {%>
                <br/>
                <b style="font-size: x-large; color: red;">لا يوجد بيانات</b>
                <br/>
                <br/>
                <%}%>
                <br/>
            </FIELDSET>

        </FORM>
    </BODY>
</HTML>     
