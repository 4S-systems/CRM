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
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
Vector failureCodeVectors = (Vector) request.getAttribute("failureCodeVectors");

Vector vecAllType = (Vector) failureCodeVectors.get(0);
Vector vecEmergencyType = (Vector) failureCodeVectors.get(1);
Vector vecExternalType = (Vector) failureCodeVectors.get(2);
WebBusinessObject wbo = null;

//WebBusinessObject projectWbo = projectMgr.getOnSingleKey(request.getParameter("projectName"));

//Enumeration e = failureCodeVectors.elements();
//Enumeration eTotal = failureCodeVectors.elements();
Double iTemp = new Double(0);
int iTotal = 0;
request.getSession().setAttribute("data", failureCodeVectors);

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,S,Total,Percent, sEmergency, sExternal,sCancel;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Failure Code Statistics";
    save=" Excel Sheet";
    cancel="Back To List";
    TT="Total Job Orders";
    S="Failure Code";
    Total="Total";
    Percent="Percent";
    sExternal = " for External";
    sEmergency = " for Emergency";
    sCancel="Cancel";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="&#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1575;&#1578; &#1571;&#1603;&#1608;&#1575;&#1583; &#1575;&#1604;&#1571;&#1593;&#1591;&#1575;&#1604;";
    save="&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1593;&#1583;&#1583; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    S="&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604;";
    Total="&#1575;&#1604;&#1593;&#1583;&#1583; &#1575;&#1604;&#1603;&#1604;&#1610;";
    Percent="&#1575;&#1604;&#1606;&#1587;&#1576;&#1577;";
    sExternal = "&#1575;&#1604;&#1582;&#1575;&#1585;&#1580;&#1610;";
    sEmergency = "&#1575;&#1604;&#1591;&#1575;&#1585;&#1574;";
    sCancel = tGuide.getMessage("cancel");
            
}
%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Equipment Statistics</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
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

       function callbackFillreload(){
         if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                     window.location.reload();
                }
            }
       }
        function cancelForm()
    {
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=FailureCodeChart";
        document.ISSUE_FORM.submit();
    }
</script>
<BODY>
<FORM NAME="ISSUE_FORM" METHOD="POST">
<DIV align="left" STYLE="color:blue;">
    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button> <br>

</DIV>  
<br><br>
<fieldset align=center class="set" >
<legend align="center">
    
    <table dir=" <%=dir%>" align="<%=align%>">
        <tr>
            
            <td class="td">
                <font color="blue" size="6"><%=tit%></font>
            </td>
        </tr>
    </table>
</legend >

<%
for(int i = 0; i < vecAllType.size(); i++){
    wbo = (WebBusinessObject) vecAllType.get(i);
    iTemp = new Double((String) wbo.getAttribute("total"));
    iTotal = iTotal + iTemp.intValue();
}
%>

<BR>
<center> <font size="3" color="red"><b> <%=TT%> : <%=iTotal%></b> </font></center>
<br><br>
<center>
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
        for(int i = 0; i < vecAllType.size(); i++){
            wbo = (WebBusinessObject) vecAllType.get(i);
            sLabels = sLabels + " " + wbo.getAttribute("failureCode").toString();
        %>
        <TR>
            <TD>
                <%=wbo.getAttribute("failureCode")%>
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
    <APPLET ALIGN="<%=align%>" CODE="SmallSecPieJApplet.class" width=550 height=257 ARCHIVE="docs/ChartDirector.jar">
        <PARAM NAME="title" VALUE="Failure Code Statistics">
        <PARAM NAME="labels" VALUE="<%=sLabels%>">
        <PARAM NAME="values" VALUE="<%=sValues%>">
    </APPLET>
    <%
    }
    %>
    <BR>
    <%
    iTotal = 0;
    
for(int i = 0; i < vecEmergencyType.size(); i++){
    wbo = (WebBusinessObject) vecEmergencyType.get(i);
    iTemp = new Double((String) wbo.getAttribute("total"));
    iTotal = iTotal + iTemp.intValue();
}
%>

<BR>
<center> <font size="3" color="red"><b> <%=TT%> <%=sEmergency%> : <%=iTotal%></b> </font></center>
<br><br>
<center>
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
        sLabels = new String("");
        sValues = new String("");
        for(int i = 0; i < vecEmergencyType.size(); i++){
            wbo = (WebBusinessObject) vecEmergencyType.get(i);
            sLabels = sLabels + " " + wbo.getAttribute("failureCode").toString();
        %>
        <TR>
            <TD>
                <%=wbo.getAttribute("failureCode")%>
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
    <APPLET ALIGN="<%=align%>" CODE="SmallSecPieJApplet.class" width=550 height=257 ARCHIVE="docs/ChartDirector.jar">
        <PARAM NAME="title" VALUE="Failure Code Statistics for Emergency Job Order">
        <PARAM NAME="labels" VALUE="<%=sLabels%>">
        <PARAM NAME="values" VALUE="<%=sValues%>">
    </APPLET>
    <%
    }
    %>
    <%
    iTotal = 0;
    
for(int i = 0; i < vecExternalType.size(); i++){
    wbo = (WebBusinessObject) vecExternalType.get(i);
    iTemp = new Double((String) wbo.getAttribute("total"));
    iTotal = iTotal + iTemp.intValue();
}
%>

<BR>
    <center> <font size="3" color="red"><b> <%=TT%> <%=sExternal%> : <%=iTotal%></b> </font></center>
<br><br>
<center>
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
        sLabels = new String("");
        sValues = new String("");
        for(int i = 0; i < vecExternalType.size(); i++){
            wbo = (WebBusinessObject) vecExternalType.get(i);
            sLabels = sLabels + " " + wbo.getAttribute("failureCode").toString();
        %>
        <TR>
            <TD>
                <%=wbo.getAttribute("failureCode")%>
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
    <APPLET ALIGN="<%=align%>" CODE="SmallSecPieJApplet.class" width=550 height=257 ARCHIVE="docs/ChartDirector.jar">
        <PARAM NAME="title" VALUE="Failure Code Statistics for External Job Order">
        <PARAM NAME="labels" VALUE="<%=sLabels%>">
        <PARAM NAME="values" VALUE="<%=sValues%>">
    </APPLET>
    <%
    }
    %>
    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
        <TR>
            <TD CLASS="td">
                &nbsp;
            </TD>
        </TR>
    </TABLE>
    </fielset>
</center>
</form>
</BODY>
</HTML>     
