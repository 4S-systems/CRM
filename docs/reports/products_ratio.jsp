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

Vector complaintCountsVec = (Vector) request.getAttribute("productCountsVec");
WebBusinessObject wbo = null;
Enumeration e = complaintCountsVec.elements();
int totalComplaintsCount = (Integer) request.getAttribute("totalProductsCount");
String jsonText = (String) request.getAttribute("jsonText");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,title,save,cancel,TT,complaintsCountStr,departmentStr,schedulesCount,Percent , pageTitle , pageTitleTip, startDate, endDate, display;
pageTitle="";

if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    title="Customers' Wishes by Projects";
    save=" Excel Sheet";
    cancel="Back To List";
    TT="Total Complaints ";
    departmentStr="Department";
    complaintsCountStr="Complaint Count";
    Percent="Percent";
    pageTitleTip="Complaint Distribution Rates According to Department";
    startDate = "Start Date";
    endDate = "End Date";
    display = "Display";
} else {
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    title="رغبات العملاء للمشاريع";
    save="&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
    cancel="&#1593;&#1608;&#1583;&#1607;";
    TT="العملاء";
    departmentStr="اسم المشروع";
    complaintsCountStr="العملاء";
    Percent="&#1575;&#1604;&#1606;&#1587;&#1576;&#1577;";
    pageTitleTip="نسب توزيع العملاء طبقاً للمشروع";
    startDate = "من تاريخ";
    endDate = "ألي تاريخ";
    display = "أعرض التقرير";
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
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    
    <script type="text/javascript">
        $(function() {
            $("#startDate,#endDate").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy-mm-dd'
            });
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
                        return '<b>'+ this.point.name +'</b>: '+ '%'+Highcharts.numberFormat(this.percentage, 2);
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
                                return '<b>'+ this.point.name +'</b>: '+  '%'+ Highcharts.numberFormat(this.percentage, 2);
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

        function cancelForm() {
            document.Stat.action = "<%=context%>/SearchServlet?op=Projects";
            document.Stat.submit();
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
        function submitForm()
        {
            document.Stat.action = "<%=context%>/ReportsServletThree?op=productsRatio";
            document.Stat.submit();
        }
</script>

            
<BODY>

  <script type="text/javascript" src="js/wz_tooltip.js"></script>
<FORM name="Stat" action="post">
  <DIV align="left" STYLE="color:blue;">
    <input type="button"  value="<%=display%>"  onclick="submitForm()" class="button"/>
    <input type="hidden" name="op" value="productsRatio"/>
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
<TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
    <TR>
        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
            <b><font size=3 color="white"> <%=startDate%></b>
        </TD>
        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
            <b><font size=3 color="white"> <%=endDate%></b>
        </TD>
    </TR>
    <TR>
        <td  bgcolor="#dedede" valign="middle">
            <input type="TEXT" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                   value="<%=request.getAttribute("startDate") == null ? "" : request.getAttribute("startDate")%>"/>
        </td>
        <td  bgcolor="#dedede" valign="middle">
            <input type="TEXT" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                   value="<%=request.getAttribute("endDate") == null ? "" : request.getAttribute("endDate")%>"/>
        </td>
    </TR>
</TABLE>

<BR>
<center> <font size="3" color="red"><b> <%=TT%> : <%=totalComplaintsCount%></b> </font></center>
<br><br>
<CENTER>

    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
    <br><br>
    
    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
        <TR  bgcolor="#C8D8F8">
            <TD>
                <%=departmentStr%>
            </TD>
            <TD>
                <%=complaintsCountStr%>
            </TD>
        </TR>
        <%
            while(e.hasMoreElements()) {
                wbo = (WebBusinessObject) e.nextElement();
        %>
        <TR>
            <TD>
                <%=wbo.getAttribute("productName")%>
            </TD>
            <TD>
                <%=wbo.getAttribute("productCount")%>
            </TD>
        </TR>      
        <%
            }
        %>
    </TABLE>
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
