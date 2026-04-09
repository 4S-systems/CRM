<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>


<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String beginDate = request.getParameter("beginDate");
        String endDate = request.getParameter("endDate");
        String userName = request.getParameter("userName");

        ArrayList<WebBusinessObject> resultList = (ArrayList) request.getAttribute("resultList");

        String jsonTagTypeText = (String) request.getAttribute("jsonTagTypeText");

        String stat = "Ar";
        String dir = null;
        if (stat.equals("En")) {
            dir = "LTR";
        } else {
            dir = "RTL";
        }
    %>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

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
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            var chart;
            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'containerType',
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
                            center: ['50%'],
                            data: <%=jsonTagTypeText%>
                        }
                    ]
                });
            });
        </script>

    </head>

    <body>
        <% if (resultList != null && !resultList.isEmpty()) {%>
        <div style="width: 100%; text-align: center;"><font size="3"><b> الانواع الخاصة بالموظف : <font size="3" color="red"><%=userName%></font> في الفترة من  <font size="3" color="red"><%=beginDate%></font> الى <font size="3" color="red"><%=endDate%></font></b></font></div> 
        <br/>

        <div align="left" STYLE="color:blue; margin-left: 50px;">
            <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
        </div>

        <br/><br/>
    <CENTER>
        <div id="containerType" style="width: 1000px; height: 300px; margin: 0 auto"></div>
        <br>
        <TABLE width="400" ALIGN="center" DIR="<%=dir%>" style="border-style: none; border-width: 0; border-color: white;" CELLPADDING="0" CELLSPACING="0" border="0">
            <TR  bgcolor="#C8D8F8">   
                <TD>
                    Inbound
                </TD>
                <TD>
                    Visit
                </TD>
                <TD>
                    Outbound
                </TD>
                <TD>
                    Recycle_Data
                </TD>

            </TR>
            <%
                for (WebBusinessObject wbo : resultList) {
            %>
            <TR>
                <TD>
                    <%=wbo.getAttribute("Inbound")%>
                </TD>
                <TD>
                    <%=wbo.getAttribute("Visit")%>
                </TD>
                <TD>
                    <%=wbo.getAttribute("Outbound")%>
                </TD>
                <TD>
                    <%=wbo.getAttribute("Recycle_Data")%>
                </TD>
            </TR>      
            <%
                }
            %>                   
        </TABLE>
        <br>
    </center>
    <%} else {%>
    No Data Available
    <%}%>
</body>
</html>
