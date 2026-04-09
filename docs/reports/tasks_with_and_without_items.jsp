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
                int totalTasks = (Integer) request.getAttribute("totalTasks");
                String jsonText = (String) request.getAttribute("jsonText");

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode, title, save, cancel, TT, schedulesCountStr, siteStr, schedulesCount, Percent, pageTitle, pageTitleTip;
                pageTitle = "";

                if (stat.equals("En")) {

                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    title = "Job Order Distribution";
                    save = " Excel Sheet";
                    cancel = "Back To List";
                    TT = "Total Schedules ";
                    siteStr = "Site";
                    schedulesCountStr = "Tasks Count";
                    Percent = "Percent";
                    pageTitleTip = "Job Order Distribution According to Site";
                } else {

                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    langCode = "En";
                    title = "رسم بياني يبن بنود الصيانة التي يوجد عليها قطع غيار أم لا";
                    save = "&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
                    cancel = "&#1593;&#1608;&#1583;&#1607;";
                    TT = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604; ";
                    siteStr = "الموقع";
                    schedulesCountStr = "عدد بنود الصيانة";
                    Percent = "&#1575;&#1604;&#1606;&#1587;&#1576;&#1577;";
                    pageTitleTip = "&#1578;&#1608;&#1586;&#1610;&#1593; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1591;&#1576;&#1602;&#1575;&#1611; &#1604;&#1604;&#1605;&#1608;&#1602;&#1593;";
                }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Equipment Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>

        <script type="text/javascript">


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
                            name: 'Browser share',
                            data: <%=jsonText%>
                        }]
                });
            });
        </script>
    </HEAD>

    <BODY>

        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM name="Stat" action="post">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            </DIV>
            <br><br>
            <FIELDSET align=center class="set" >
                <legend align="center">
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend >

                <div dir="left">
                    <table>
                        <tr>
                            <td>
                                <font color="#FF385C" size="3">
                                    <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=title%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                                </font>
                            </td>
                        </tr>
                    </table>
                </div>

                <BR>
                <center> <font size="3" color="red"><b> <%=TT%> : <%=totalTasks%></b> </font></center>
                <br><br>
                <CENTER>
                    <div id="container" style="min-width: 400px; height: 400px; margin: 0 auto; overflow: scroll;"></div>
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
