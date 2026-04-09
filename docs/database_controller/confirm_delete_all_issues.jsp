<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>


<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    long numberOfEmergencyIssue = (Long) request.getAttribute("numberOfEmergencyIssue");
    long numberOfNotEmergencyIssue = (Long) request.getAttribute("numberOfNotEmergencyIssue");
    long numberOfIssues = numberOfEmergencyIssue + numberOfNotEmergencyIssue;
    long zeroLong = 0;
    
    String status = (String) request.getAttribute("status");
    if(status == null) status = "";

    String stat= (String) request.getSession().getAttribute("currentMode");
    String align;
    String dir=null;
    String style=null;
    String lang, langCode, title_1, title_2, cancel_button_label, save_button_label, sStatus, hint, fStatus, issueEmg, issueNotEmg, issueAll, notFoundIssues;
    if(stat.equals("En")) {
        langCode="Ar";
        align="left";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        title_1 = "Delete All Job Orders - <font color=#F3D596>Are you Sure ?</font>";
        title_2 = "Delete All Job Orders";
        cancel_button_label="Cancel";
        save_button_label="Delete";
        sStatus = "Delete Complete";
        hint = "<font color=blue>Hint : </font>Will Be Delete Of All Job Orders Linked By This Equipment";
        fStatus = "Delete Not Complete";
        issueEmg = "Number Of Job Orders Emergency";
        issueNotEmg = "Number Of Job Orders Schedule";
        issueAll = "Number Of All Job Orders";
        notFoundIssues = "Not Found Job Orders";
    } else {
        langCode="En";
        align="right";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        title_1 = "&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1571;&#1608;&#1575;&#1605;&#1600;&#1600;&#1600;&#1600;&#1585; &#1575;&#1604;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1588;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1604; - <font color=#F3D596>&#1607;&#1600;&#1600;&#1604; &#1571;&#1606;&#1600;&#1600;&#1578; &#1605;&#1600;&#1600;&#1578;&#1600;&#1600;&#1571;&#1603;&#1600;&#1600;&#1600;&#1600;&#1583; &#1567;</font>";
        title_2 = "&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1571;&#1608;&#1575;&#1605;&#1600;&#1600;&#1600;&#1600;&#1585; &#1575;&#1604;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1588;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1604;";
        cancel_button_label="&#1573;&#1604;&#1594;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1569;";
        save_button_label="&#1573;&#1581;&#1600;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601;";
        sStatus = "&#1578;&#1605;&#1600;&#1600;&#1600;&#1600;&#1578; &#1593;&#1605;&#1600;&#1600;&#1600;&#1600;&#1604;&#1610;&#1600;&#1600;&#1600;&#1600;&#1577; &#1575;&#1604;&#1605;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1581;";
        hint = "<font color=blue>&#1605;&#1600;&#1600;&#1600;&#1600;&#1604;&#1575;&#1581;&#1592;&#1600;&#1600;&#1600;&#1577; : </font>&#1573;&#1584;&#1575; &#1578;&#1605; &#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1571;&#1608;&#1575;&#1605;&#1600;&#1600;&#1600;&#1600;&#1585; &#1575;&#1604;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1588;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1604;  &#1601;&#1604;&#1575; &#1610;&#1605;&#1600;&#1600;&#1603;&#1606; &#1575;&#1587;&#1600;&#1600;&#1600;&#1600;&#1578;&#1585;&#1580;&#1593;&#1607;  &#1605;&#1600;&#1600;&#1600;&#1600;&#1585;&#1607; &#1575;&#1582;&#1600;&#1600;&#1600;&#1600;&#1585;&#1609;";
        issueEmg = "&#1593;&#1600;&#1600;&#1600;&#1583;&#1583; &#1571;&#1608;&#1575;&#1605;&#1600;&#1600;&#1585; &#1575;&#1604;&#1588;&#1600;&#1600;&#1600;&#1600;&#1594;&#1604; &#1575;&#1604;&#1593;&#1600;&#1600;&#1600;&#1575;&#1583;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577;";
        issueNotEmg = "&#1593;&#1600;&#1600;&#1600;&#1583;&#1583; &#1571;&#1608;&#1575;&#1605;&#1600;&#1600;&#1585; &#1575;&#1604;&#1588;&#1600;&#1600;&#1600;&#1600;&#1594;&#1604; &#1575;&#1604;&#1605;&#1580;&#1600;&#1600;&#1600;&#1600;&#1583;&#1608;&#1604;&#1600;&#1600;&#1600;&#1577;";
        issueAll = "&#1593;&#1600;&#1600;&#1600;&#1583;&#1583; &#1571;&#1608;&#1575;&#1605;&#1600;&#1600;&#1585; &#1575;&#1604;&#1588;&#1600;&#1600;&#1600;&#1600;&#1594;&#1604; &#1575;&#1604;&#1603;&#1600;&#1600;&#1600;&#1604;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577;";
                sStatus = "&#1578;&#1605;&#1600;&#1600;&#1600;&#1600;&#1578; &#1593;&#1605;&#1600;&#1600;&#1600;&#1600;&#1604;&#1610;&#1600;&#1600;&#1600;&#1600;&#1577; &#1575;&#1604;&#1605;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1581;";
fStatus = "&#1604;&#1605; &#1610;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1581;";
        notFoundIssues = "&#1604;&#1575; &#1578;&#1600;&#1600;&#1600;&#1600;&#1608;&#1580;&#1600;&#1600;&#1600;&#1600;&#1583; &#1571;&#1608;&#1575;&#1605;&#1600;&#1600;&#1600;&#1600;&#1585; &#1578;&#1588;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1594;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1604;";
    }
%>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="0">

   <HEAD>
      <TITLE>Document Viewer - Confirm Deletion</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>

   <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
       function submitForm() {
           document.PROJECT_DEL_FORM.action = "<%=context%>/DatabaseControllerServlet?op=deleteAllIssues";
           document.PROJECT_DEL_FORM.submit();
       }

       function cancelForm() {
           document.PROJECT_DEL_FORM.action = "<%=context%>/main.jsp";
           document.PROJECT_DEL_FORM.submit();
       }
   </SCRIPT>

   <BODY>
       <FORM action=""  NAME="PROJECT_DEL_FORM" METHOD="POST">
           <DIV align="left" STYLE="color:blue;padding-bottom: 10px; padding-top: 10px; padding-left: 5%">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%></button>
                <% if(numberOfIssues > zeroLong) { %>
                    &ensp;
                    <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%></button>
                <% } %>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699; width: 90%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1">
                                        <%=title_1%>
                                </FONT>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>

                    <% if(!status.equals("")) { %>
                    <table class="blueBorder" dir="rtl" align="center" width="90%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                                <center>
                                    <% if(status.equals("ok")) { %>
                                        <font color="blue" STYLE="font-weight: bold" size="3"><%=sStatus%></font>
                                    <% } else { %>
                                        <font color="red" STYLE="font-weight: bold" size="3"><%=fStatus%></font>
                                    <% } %>
                                </center>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <% } %>
                    <% if(numberOfIssues > zeroLong) { %>
                    <TABLE class="backgroundTable" ALIGN="center" DIR="<%=dir%>" CELLPADDING="5" CELLSPACING="5" width="90%">
                        <TR>
                            <TD STYLE="text-align: center" class='backgroundHeader' width="40%">
                                <p><b><%=issueEmg%></b></p>
                            </TD>
                            <TD align="center" class='backgroundHeader' width="60%">
                                <input style="width: 95%; font-weight: bold; color: black; padding-<%=align%>: 10px" readonly type="TEXT" name="numberOfEmergencyIssue" value="<%=numberOfEmergencyIssue%>" ID="<%=numberOfEmergencyIssue%>">
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="text-align: center" class='backgroundHeader' width="40%">
                                <p><b><%=issueNotEmg%></b></p>
                            </TD>
                            <TD align="center" class='backgroundHeader' width="60%">
                                <input style="width: 95%; font-weight: bold; color: black; padding-<%=align%>: 10px" readonly type="TEXT" name="numberOfNotEmergencyIssue" value="<%=numberOfNotEmergencyIssue%>" ID="<%=numberOfNotEmergencyIssue%>">
                            </TD>
                        </TR>
                    </TABLE>
                    <hr style="width: 90%; color: black; height: 2px; padding: 0px" />
                    <TABLE class="backgroundTable" style="padding: 0px" ALIGN="center" DIR="<%=dir%>" CELLPADDING="5" CELLSPACING="5" width="90%">
                        <TR>
                            <TD STYLE="text-align: center" class='backgroundHeader' width="40%">
                                <p><b><%=issueAll%></b></p>
                            </TD>
                            <TD align="center" class='backgroundHeader' width="60%">
                                <input style="width: 95%; font-weight: bold; color: black; padding-<%=align%>: 10px" readonly type="TEXT" name="numberOfIssues" value="<%=numberOfIssues%>" ID="<%=numberOfIssues%>">
                            </TD>
                        </TR>
                    </TABLE>
                    <div align="<%=align%>" style="margin-<%=align%>: 5%;color: blue; margin-bottom: 10px; margin-top: 10px">
                        <p dir="<%=dir%>" align="<%=align%>" style="background-color: #E6E6FA;width:95%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px;text-align: <%=align%>"><b><font color="red"><%=hint%></font></b></p>
                    </div>
                    <% } else { %>
                    <TABLE class="blueBorder" dir="rtl" align="center" width="90%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                                <p><b><font color="red"><%=notFoundIssues%></font></b></p>
                            </TD>
                        </TR>
                    </TABLE>
                    <% } %>
                    <BR>
                </FIELDSET>
            </CENTER>
       </FORM>
   </BODY>
</HTML>     
                    