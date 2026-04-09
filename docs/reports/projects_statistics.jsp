<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
<%
ProjectMgr projectMgr = ProjectMgr.getInstance();
IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
//String op = (String) request.getAttribute("op");
String ts = (String) request.getAttribute("ts");
//System.out.println("target op is " + op );

Vector  projectStatusList = (Vector) request.getAttribute("data");
WebBusinessObject wbo = null;

WebBusinessObject projectWbo = projectMgr.getOnSingleKey(request.getParameter("projectName"));
String projectName = request.getParameter("projectName");

Enumeration e = projectStatusList.elements();
Enumeration eTotal = projectStatusList.elements();
Double iTemp = new Double(0);
int iTotal = 0;
request.getSession().setAttribute("data", projectStatusList);

String jsonText = (String) request.getAttribute("jsonText");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,S,Total,Percent , pageTitle , pageTitleTip;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    if(projectName.equalsIgnoreCase("All")) {
        tit="Status Statistics for All Sites";
    } else {
        tit="Site Status Statistics for Site '<font color='red' size='6'>" + projectWbo.getAttribute("projectName") + "</font>'";
    }
    
    save=" Excel Sheet";
    cancel="Back To List";
    TT="Total Schedules ";
    S="Status";
    Total="Total";
    Percent="Percent";
    pageTitle="RPT-STAT-SITE-1";
    pageTitleTip="Site Status Report ";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";

    if(projectName.equalsIgnoreCase("All")) {
        tit="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1577; &#1604;&#1580;&#1605;&#1610;&#1593; &#1575;&#1604;&#1605;&#1608;&#1575;&#1602;&#1593;";

    } else {
        tit="'<font color='red' size='6'>" + projectWbo.getAttribute("projectName") + "</font>' &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1577; &#1604;&#1604;&#1605;&#1608;&#1602;&#1593;";

    }

    save="&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
    cancel="&#1593;&#1608;&#1583;&#1607;";
    TT="&#1593;&#1583;&#1583; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604; ";
    S="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    Total="&#1575;&#1604;&#1593;&#1583;&#1583; &#1575;&#1604;&#1603;&#1604;&#1610;";
    Percent="&#1575;&#1604;&#1606;&#1587;&#1576;&#1577;";
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
                        return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
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
                                return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
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
                <font color="blue" size="6"><%=tit%></font>
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

                                        

<%
while(eTotal.hasMoreElements()) {
    wbo = (WebBusinessObject) eTotal.nextElement();
    iTemp = new Double((String) wbo.getAttribute("total"));
    iTotal = iTotal + iTemp.intValue();
}
%>

<BR>
<center> <font size="3" color="red"><b> <%=TT%> : <%=iTotal%></b> </font></center>
<br><br>
<CENTER>

    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
    <br><br>
    
    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
        <TR  bgcolor="#C8D8F8">
            <TD>
                <%=S%>
            </TD>
            <TD>
                <%=Total%>
            </TD>
            <TD>
                <%=Percent%> %
            </TD>
        </TR>
        <%
        String sLabels = new String("");
        String sValues = new String("");
        while(e.hasMoreElements()) {
            wbo = (WebBusinessObject) e.nextElement();
            sLabels = sLabels + " " + wbo.getAttribute("currentStatus").toString();
        %>
        <TR>
            <TD>
                <%=wbo.getAttribute("currentStatus")%>
            </TD>
            <TD>
                <%
                iTemp = new Double((String) wbo.getAttribute("total"));
                sValues = sValues + " " + iTemp.toString();
                %>
                <%=iTemp.intValue()%>
            </TD>
            <TD>
                <%=Math.round((iTemp.doubleValue()/iTotal) * 100)%>
            </TD>
        </TR>      
        <%
        }
        %>
    </TABLE>
    <%
    if(sLabels.length() > 0){
    %>
    <BR><BR>
    <%
    if(request.getAttribute("chart").toString().equalsIgnoreCase("pie")){
           %><%--
    <APPLET ALIGN="<%=align%>" CODE="SmallSecPieJApplet.class" width=550 height=275 ARCHIVE="docs/ChartDirector.jar">
        <PARAM NAME="labels" VALUE="<%=sLabels%>">
        <PARAM NAME="values" VALUE="<%=sValues%>">
    </APPLET>--%>
    <%
    } else {
    %>
    <APPLET ALIGN="<%=align%>" CODE="softLightBarJApplet.class" width=600 height=375 ARCHIVE="docs/ChartDirector.jar">
        <PARAM NAME="labels" VALUE="<%=sLabels%>">
        <PARAM NAME="values" VALUE="<%=sValues%>">
    </APPLET>
    <%
    }
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
