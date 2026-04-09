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

String dataStr = (String) request.getAttribute("data");
String categoriesStr = (String) request.getAttribute("categories");

/* handling spacing between bars */
int itemsPerPage = 5;
String dataSizeStr = (String) request.getAttribute("dataSize");

int containerHeight = 0;
if(dataSizeStr != null) {
    int dataSizeInt = Integer.parseInt(dataSizeStr);
    

    if(dataSizeInt < itemsPerPage) {
        if(dataSizeInt == 1) {
            containerHeight = 100;
        } else {
            containerHeight = dataSizeInt * 50;
        }
        
    } else {
        double divResult = dataSizeInt / itemsPerPage;
        int divRem = dataSizeInt % itemsPerPage;
        double multiplyBy = Math.floor(divResult);
        
        containerHeight = ((int) multiplyBy) * 250;   // container height is fixed at 250px

        if(divRem > 0) {
            containerHeight += divRem * 50; // 50 is the assigned share for each bar when container height is 250px
        }
    }

}
/* -handling spacing between bars */


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,title, pageTitle , pageTitleTip;
pageTitle="MAINT-ITEM-NUM-100";

if(stat.equals("En")){

    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    title="Diagram of Maintenance Items Number";
    pageTitleTip="Diagram of Maintenance Items Number Created in Specified Durations";
    
} else {

    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    title="رسم بيانى لعدد بنود الصيانة";
    pageTitleTip="رسم بيانى لعدد بنود الصيانة خلال مدة معينة";
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

        /* preparing bar chart */
        var categories = <%=categoriesStr%>;
        var data = <%=dataStr%>;
        var bar;

        var chart;
        $(document).ready(function() {
            chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'container',
                    type: 'bar'
                },
                legend: {
                    enabled: false
                },
                
                title: {
                    text: null
                },

                tooltip: {
                    formatter: function() {
                        return '<b>' + this.x + ':</b> ' + this.y;
                    }
                },

                plotOptions: {
                    series: {
                        pointWidth: 20,
                        dataLabels: {
                            enabled: true
                            
                        }
                    }
                },
                
                xAxis: {
                    categories: <%=categoriesStr%>
                },

                 yAxis: {
                    title: {
                        text: null
                    }
                },
                
                series: [{
                        data: <%=dataStr%>
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

        function callbackFillreload() {
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

<br><br>
<CENTER>

    <div id="container" style="width: 500px; height: <%=containerHeight%>px"></div>
    <br><br>

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
