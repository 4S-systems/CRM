<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String jsonText = (String) request.getAttribute("jsonText");
String unitName = (String) request.getAttribute("unitName");
String cMode= (String) request.getSession().getAttribute("currentMode");

String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel, pageTitle , pageTitleTip;

if(stat.equals("En")){

    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Mean Time Between Failure for Equipment <br><center>'<font color='red' size='3'>" + unitName + "</font>'</center>";
    save=" Excel Sheet";
    cancel="Back To List";
    pageTitle="RPT-STAT-SITE-1";
    pageTitleTip="Site Status Report ";
} else {

    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit=" متوسط الوقت بين الأعطال للمعدة<center>'<font color='red' size='3'>" + unitName + "</font>'</center><br>";
    save="&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
    cancel="&#1593;&#1608;&#1583;&#1607;";
    pageTitle="RPT-STAT-SITE-1";
    pageTitleTip="&#1575;&#1581;&#1589;&#1575;&#1574;&#1610;&#1575;&#1578; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1591;&#1576;&#1602;&#1575; &#1604;&#1604;&#1605;&#1608;&#1602;&#1593;";
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

        /* preparing step line chart */
        
        Highcharts.setOptions({
            global: {
                useUTC: false
            }
        });
        
        var stateTypeArr = new Array();
        stateTypeArr[1] = "Out of Work";
        stateTypeArr[2] = "Working";

        $(function() {

            new Highcharts.Chart({

                chart: {
                    renderTo: "container",
                    reflow: false,
                                zoomType: 'x'
                },

                title: {
                    text: null
                },

                legend: {
                    enabled: false
                },

                plotOptions: {
                    series: {
                        step: true,
                        marker: {
                            enabled: false,
                            states: {
                                hover: {
                                    enabled: true
                                }
                            }
                        }
                    }
                },

                xAxis: {
                    title: {
                        text: "time",
                        margin: 20
                    },
                    type: 'datetime',
                    dateTimeLabelFormats: {
                        second: '%H:%M:%S',
                        minute: '%H:%M',
                        hour: '%H:%M',
                        day: '%e. %b',
                        week: '%e. %b',
                        month: '%b \'%y',
                        year: '%Y'

                    },
                    tickInterval: 2629743830    // #milliseconds in a month
                },

                yAxis: {
                    min: 1,
                    gridLineWidth: 0,
                    title: {
                        text: "status",
                        margin: 20
                    },
                    labels: {
                        align: 'right',
                        formatter: function() {
                            return stateTypeArr[this.value];
                        },
                        x: -20,
                        y: 3
                    }
                },

                tooltip: {
                    formatter: function() {
                        return '<b>' + Highcharts.dateFormat("%B %e, %Y", this.x) + ': </b>' + stateTypeArr
        [this.y];
                    }
                },

                series: [{
                    type: 'area',
                    data: <%=jsonText%>
                }]
            });
        });
        /* -preparing pie chart */

    </script>

</HEAD>
<script language="javascript" type="text/javascript">
          function changePage(url){
                window.navigate(url);
            }

            function reloadAE(nextMode){

       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            {
                req = new XMLHttpRequest();
            }
               else if (window.ActiveXObject)
            {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post",url,true);
            req.onreadystatechange =  callbackFillreload;
            req.send(null);

      }

     function cancelForm()
        {
            document.Stat.action = "<%=context%>/SearchServlet?op=Projects";
            document.Stat.submit();
        }

       function callbackFillreload(){
         if (req.readyState==4)
            {
               if (req.status == 200)
                {
                     window.location.reload();
                }
            }
       }
</script>


<BODY>

  <script type="text/javascript" src="js/wz_tooltip.js"></script>
<FORM name="Stat" action="post">
  <DIV align="left" STYLE="color:blue;">
    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
    <!--button    onclick="changePage('<%=context%>/SearchServlet?op=ExcelProjectStcs&projectName=<%//=request.getParameter("projectName")%>')" class="button"><%=save%> <img src="<%=context%>/images/xlsicon.gif"></button-->
<!-- <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>-->

</DIV>
<br><br>
<FIELDSET align=center class="set" >
<legend align="center">

    <table dir=" <%=dir%>" align="<%=align%>">
        <tr>

            <td class="td">
                <font color="blue" size="5"><%=tit%></font>
            </td>
        </tr>
    </table>
</legend >


    <div dir="left">
        <table>
            <tr>
                <td>
                    <font color="#FF385C" size="3">
                        <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=pageTitleTip%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                    </font>
                </td>
            </tr>
        </table>
    </div>

<br><br>
<CENTER>

    <div id="container" style="width: 800px; height: 200px; margin: 0 auto"></div>
    <br><br>

</CENTER>

    </FIELDSET>

 </FORM>
</BODY>

</HTML>
