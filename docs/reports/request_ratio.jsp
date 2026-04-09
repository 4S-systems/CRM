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
Vector temp = new Vector();
//Vector complaintCountsVec = (Vector) request.getAttribute("complaintCountsVec");
Enumeration e ;
WebBusinessObject wbo = null;
// e = complaintCountsVec.elements();
int totalComplaintsCount;
if(request.getAttribute("totalComplaintsCount")!=null){
 totalComplaintsCount = (Integer) request.getAttribute("totalComplaintsCount");
}
else {
    totalComplaintsCount=0;
}
 String jsonText = (String) request.getAttribute("jsonText");
String projectName = (String) request.getAttribute("projectName");

 
 
 
 
String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,title,save,cancel,TT,complaintsCountStr,departmentStr,schedulesCount,Percent , pageTitle , pageTitleTip;
pageTitle="" ;
String msg="" ;
String project="";

if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    title="Request Distribution Rates";
    save=" Excel Sheet";
    cancel="Back To List";
    TT="Total Requests ";
    departmentStr="Department";
    complaintsCountStr="Requests Count";
    Percent="Percent";
    pageTitleTip="Requests Distribution Rates According to Department";
    project="Department Name";
} else {
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    title="&#1606;&#1587;&#1576; &#1578;&#1608;&#1586;&#1610;&#1593; &#1575;&#1604;&#1591;&#1604;&#1576;&#1575;&#1578; ";
    save="&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
    cancel="&#1593;&#1608;&#1583;&#1607;";
    TT="&#1593;&#1583;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;&#1575;&#1578; ";
    departmentStr="الإدارة";
    complaintsCountStr="&#1593;&#1583;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;&#1575;&#1578; ";
    Percent="&#1575;&#1604;&#1606;&#1587;&#1576;&#1577;";
    pageTitleTip="نسب توزيع  الطلبات طبقاً للإدارة";
    msg="&#1607;&#1584;&#1607; &#1575;&#1604;&#1575;&#1583;&#1575;&#1585;&#1607; &#1604;&#1575; &#1578;&#1581;&#1578;&#1608;&#1610; &#1591;&#1604;&#1576;&#1575;&#1578; ";
    project="&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1587;&#1605;";
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
</script>

            
<BODY>

  <script type="text/javascript" src="js/wz_tooltip.js"></script>
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
<center> <font size="3" color="red"><b> <%=project%> : <%=projectName%></b> </font></center>
        <%if(totalComplaintsCount!=0){%>
<center> <font size="3" color="red"><b> <%=TT%> : <%=totalComplaintsCount%></b> </font></center>
<br><br>

    <%}%>
<CENTER>
    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
    <br><br>
   <%if(request.getAttribute("complaintCountsVec")!=null){
        
        Vector complaintCountsVec = (Vector) request.getAttribute("complaintCountsVec");
            %>
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
          e = complaintCountsVec.elements();
               while(e.hasMoreElements()) {
               wbo = (WebBusinessObject) e.nextElement();
        %>
        <TR>
            <TD>
                <%=wbo.getAttribute("type_name")%>
            </TD>
            <TD>
                <%=wbo.getAttribute("request_count")%>
            </TD>
        </TR>      
         
        <%
            }}
else
{%>

     <font color="blue" size="6"><%=msg%></font>
<%}%>
       
  
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
