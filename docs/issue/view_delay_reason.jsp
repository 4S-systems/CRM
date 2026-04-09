<%@page contentType="text/html"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*, com.maintenance.db_access.*"%>
<%@page pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%

String issueId = (String) request.getAttribute("issueId");
Vector reasons=new Vector();
WebBusinessObject wbo=new WebBusinessObject();
reasons=(Vector) request.getAttribute("delayReasons");

String message;

String align=null;
String dir=null;
String style=null;
String lang,langCode, BackToList,save, title,M,M2,labor,no,delayReason,del;

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
title = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1571;&#1587;&#1576;&#1575;&#1576; &#1575;&#1604;&#1578;&#1571;&#1582;&#1610;&#1585;</span></p>";

%>


<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm(){    
       
      //  document.COMPLAINT_FORM.action = "/docs/issue/Delayed_issue.jsp";
      document.COMPLAINT_FORM.action = "left_menu.jsp";
        document.COMPLAINT_FORM.submit();  
    }
    
</script>

<html>
    <head>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Delay Reasons</title>
    </head>
    <body>
        <FORM NAME="COMPLAINT_FORM"  METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <button  onclick="cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
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
                <%if(reasons.size()<=0)
                {%>
                <table width="70%" border="0">
                    <tr >
                        <td align="center">
                            <font color="red" size="4" ><b>&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1575;&#1587;&#1576;&#1575;&#1576; &#1575;&#1604;&#1578;&#1571;&#1582;&#1610;&#1585;</b></font>
                        </td>
                    </tr>
                </table>
                <%}else{%>
                <table ALIGN="<%=align%>" DIR="<%=dir%>" id="listTable" width="700" CELLPADDING="0" CELLSPACING="1" >
                    <tr bgcolor="#99bbbb" >
                        <td style="width: 10%"  >
                            <center>
                                <font size="4" ><b>&#1605;</b></font>
                            </center>
                        </td>
                        <td style="width: 90%" >
                            <center>
                                <font size="4"><b>&#1575;&#1587;&#1576;&#1575;&#1576; &#1575;&#1604;&#1578;&#1571;&#1582;&#1610;&#1585;</b></font>
                            </center>
                        </td>
                    </tr>
                    <% for(int i=0;i<reasons.size();i++){%>
                    <tr>
                        <TD STYLE="text-align:center;font-size:14;border-width:1px;" WIDTH="10%">
                            <center>
                                <font color="black"> <b>    <%=i%></b></font>
                            </center>
                        </td>
                        <TD STYLE="text-align:center;width:90%; font-size:14;border-width:1px;" WIDTH="90%">
                            <%
                            wbo=(WebBusinessObject)reasons.get(i);%>
                            
                            <font color="black"> <b>  <%=wbo.getAttribute("reason")%></b></font>
                        </td>
                    </tr>
                    <%}%>
                </table>
                <%}%>
                <br>
                <br>
            </fieldset>
        </form>
        
    </body>
</html>
