<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%

String status = (String) request.getAttribute("Status");
String issueId = (String) request.getAttribute("issueId");
String filterName = request.getParameter("filterName");
String filterValue = request.getParameter("filterValue");
String message;
String backTo=(String)request.getAttribute("backTo");

Vector reasons=(Vector)request.getAttribute("reasons");

/******Get Paln Data*********/
String beginDate=(String)request.getSession().getAttribute("beginDate");
String endDate=(String)request.getSession().getAttribute("endDate");
String planUnitId=(String)request.getSession().getAttribute("planUnitId");
String planType=(String)request.getSession().getAttribute("planType");

String align=null;
String dir=null;
String style=null;
String lang,langCode, BackToList,save, title,M,M2,labor,no,delayReason,del,previousReasons,NoprevReasons;

no="&#1575;&#1604;&#1585;&#1602;&#1605;";
delayReason="&#1575;&#1604;&#1587;&#1576;&#1576;";
del="&#1581;&#1584;&#1601;";
labor="&#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
M2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
M="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
align="center";
dir="RTL";
style="text-align:right";
lang="   English    ";
langCode="En";
BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577;";
save = " &#1575;&#1590;&#1575;&#1601;&#1577; ";
title = "&#1575;&#1590;&#1601; &#1587;&#1576;&#1576; &#1578;&#1571;&#1582;&#1610;&#1585;";
previousReasons="&#1571;&#1587;&#1576;&#1575;&#1576; &#1575;&#1604;&#1578;&#1575;&#1582;&#1610;&#1585; &#1575;&#1604;&#1605;&#1590;&#1575;&#1601;&#1607;";
NoprevReasons="&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1571;&#1587;&#1576;&#1575;&#1576; &#1578;&#1571;&#1582;&#1610;&#1585; &#1587;&#1575;&#1576;&#1602;&#1607;";
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm(){    
       
//        document.COMPLAINT_FORM.action = "Delayed_issue.jsp";
        var backTo="<%=backTo%>";
        if(backTo=="tree"){
            document.COMPLAINT_FORM.action = "left_menu.jsp";
        }else{
            document.COMPLAINT_FORM.action = "SearchServlet?op=ListLateJO&unitId=<%=planUnitId%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>";
        }
        document.COMPLAINT_FORM.submit();  
    }
    
    function submitForm(){
        
          document.COMPLAINT_FORM.action = "EquipmentServlet?op=saveDelayReasons&issueId=<%=issueId%>";
          document.COMPLAINT_FORM.submit();
       
     }
     
    
  var count=0;   
function insRow()
{
count++;

var x=document.getElementById('listTable').insertRow(1);
var y=x.insertCell(0);
var z=x.insertCell(1);
var w=x.insertCell(2);

w.innerHTML="<input type='checkbox' name='check' ID='check'>";
z.innerHTML="<input type='text' name='reason' size='60' ID='reason'>";
y.innerHTML=count;



}

    function Delete() {
        var tbl = document.getElementById('listTable');
        var check=document.getElementsByName('check');
        
        for(var i=0;i<=count;i++){
            if(check[i].checked==true){
                tbl.deleteRow(i+1);
                count--;
                          }   
        }
        
       
    }

</script>



</script>

<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Add Delay Reasons</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
        <link rel="stylesheet" type="text/css" href="css/headers.css" />
    </head>
    
    <BODY>
        <CENTER>
            <FORM NAME="COMPLAINT_FORM"  METHOD="POST">
                <DIV align="left" STYLE="color:blue;">
                    <button  onclick="cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
                    <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
                </DIV>
                
                <fieldset class="set">
                    <legend align="center">
                        <table dir=" <%=dir%>" align="<%=align%>">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6"><%=title%> </font>
                                </td>
                            </tr>
                        </table>
                    </legend>
                    <br>
                    
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" ID="code" CELLPADDING="0" CELLSPACING="0" width="800" STYLE="border-width:1px;border-color:white;">
                        
                        <% if(null!=status){
    if(status.equals("ok")){
                        %>
                        <tr>
                            <td class="bar" colspan="3">
                                <B><FONT FACE="tahoma" color='red'>   <%=M%></FONT></b>
                            </td>
                        </tr>
                        <%}else{%>
                        <tr>
                            <td class="bar" colspan="3">
                                <B><FONT FACE="tahoma" color='red'>  <%=M2%></FONT></b>
                            </td>
                        </tr>
                        
                        <%}
                        }%>
                        
                        
                        <TR CLASS="header" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ROWSPAN="2">   
                            <td align="right" width="35%">
                                <center>
                                    <input type="button" value=" &#1575;&#1590;&#1601; "  ONCLICK="JavaScript: insRow();">
                                </center>
                            </td>
                            <td width="35%">
                                &nbsp;
                            </td>
                            <td align="left" width="35%">
                                <center>
                                    <input type="button" style="width:50" value="&#1605;&#1587;&#1581;" onclick="JavaScript: Delete()">
                                </center>
                            </td>
                            
                        </TR>
                        
                    </TABLE>
                    
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" id="listTable" width="800" CELLPADDING="0" CELLSPACING="1" STYLE="border-width:1px;border-color:white">
                        <TR>
                            <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="75">
                                <b><%=no%></b>
                            </TD>
                            <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                                <b><%=delayReason%> </b>
                            </TD>
                            <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                                <b><%=del%></b>
                            </TD>
                            
                        </TR>
                    </TABLE>
                    
                    <br><hr width="800" size="3" color="black">
                    <%if(reasons.size()>0){
                    WebBusinessObject reasonWbo=new WebBusinessObject();
                    String className="tRow";
                    %>
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" width="800" CELLPADDING="0" CELLSPACING="1" STYLE="border-width:1px;border-color:black">
                        <TR>
                            <TD CLASS="header" COLSPAN="3" STYLE="text-align:center;border-width:1px;border-color:white" >
                                <b><%=previousReasons%></b>
                            </TD>
                        </TR>
                        <%for(int i=0;i<reasons.size();i++){
                        reasonWbo=(WebBusinessObject)reasons.get(i);
                        if((i%2)==1){
                        className="tRow2";
                        }else{
                        className="tRow";
                        }
                        %>
                        
                        <TR>
                            <TD CLASS="<%=className%>" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="75">
                                <b><%=i+1%></b>
                            </TD>
                            <TD CLASS="<%=className%>" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                                <b>
                                    <%=reasonWbo.getAttribute("reason").toString()%> 
                                </b>
                            </TD>
                            <TD CLASS="<%=className%>" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                                <b><%=reasonWbo.getAttribute("creationTime").toString()%> </b>
                            </TD>
                            
                        </TR>
                        
                        <%}%>
                    </TABLE>
                    <br>                   
                    <%}else{%>
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" width="800" CELLPADDING="0" CELLSPACING="1" STYLE="border-width:1px;border-color:black">
                        <TR>
                            <TD CLASS="header" COLSPAN="3" STYLE="text-align:center;border-width:1px;border-color:white" >
                                <b><%=NoprevReasons%></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <%}%>
                    <input type="hidden" name="backTo" id="backTo" value="<%=backTo%>">
                    
                </fieldset>
            </form>
        </center>
    </body>
</html>