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
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();


                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

                //Vector issueCountsVec = (Vector) request.getAttribute("issueCountsVec");
                WebBusinessObject wbo = null;
                //Enumeration e = issueCountsVec.elements();
                int totalSchedulesCount = (Integer) request.getAttribute("totalSchedulesCount");
                String jsonText = (String) request.getAttribute("jsonText");
                String unitName = (String) request.getAttribute("unitName");

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode, title, save, cancel, TT, schedulesCountStr, siteStr, schedulesCount, Percent, pageTitle, pageTitleTip;
                pageTitle = "JO-SITE-DSTRB-101";

                if (stat.equals("En")) {

                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    title = "Total Time Between Failure and Work";
                    save = " Excel Sheet";
                    cancel = "Back To List";
                    TT = "Unit Name ";
                    siteStr = "Site";
                    schedulesCountStr = "Schedule Count";
                    Percent = "Percent";
                } else {

                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    langCode = "En";
                    title = "إجمالي الوقت بين الفشل والعمل";
                    save = "&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
                    cancel = "&#1593;&#1608;&#1583;&#1607;";
                    TT = "إسم المعدة ";
                    siteStr = "الموقع";
                    schedulesCountStr = "عدد الجداول";
                    Percent = "&#1575;&#1604;&#1606;&#1587;&#1576;&#1577;";
                }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Equipment Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="js/exporting.js"></script>

        <script type="text/javascript">
            $(function () {
                var charti;
                $(document).ready(function() {
                    charti = new Highcharts.Chart({
                        chart: {
                            renderTo: 'container',
                            type: 'pie',
                            plotBackgroundColor: null,
                            plotBorderWidth: null,
                            plotShadow: false
                        },
                        title: {
                            text: null
                        },
                        tooltip: {
                            formatter: function() {
                                return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage, 2) +' %';
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
                                        return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage, 2) +' %';
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
            });
        </script>
    </HEAD>

    <BODY>

        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM name="Stat" action="post">
            <fieldset class="set" style="border-color: #006699; width: 95%">
                    <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><Font color='white' SIZE="+1"><%=title%></Font><BR></TD>
                        </TR>
                    </table>

                <BR>
                <center> <font size="3" dir="<%=dir%>" color="red"><b> <%=TT%> : <%=unitName%></b> </font></center>
                <br><br>
                <CENTER>
                    <div id="container" style="width: 320px; height: 300px; margin: 0 auto;"></div>

                    <%--<TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
                        <TR  bgcolor="#C8D8F8">
                            <TD>
                                <%=siteStr%>
                            </TD>
                            <TD>
                                <%=schedulesCountStr%>
                            </TD>
                        </TR>
                        <%
                                    while (e.hasMoreElements()) {
                                        wbo = (WebBusinessObject) e.nextElement();
                        %>
                        <TR>
                            <TD>
                                <%=wbo.getAttribute("projectName")%>
                            </TD>
                            <TD>
                                <%=wbo.getAttribute("issueCount")%>
                            </TD>
                        </TR>
                        <%
                                    }
                        %>
                    </TABLE>--%>
                    <BR>
                    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
                        <TR>
                            <TD CLASS="td">
                                &nbsp;
                            </TD>
                        </TR>
                    </TABLE>
                </CENTER>

            </fieldset>

        </FORM>
    </BODY>

</HTML>
