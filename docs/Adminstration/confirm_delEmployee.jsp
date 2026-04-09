<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String employeeId = (String) request.getAttribute("employeeId");
    String employeeName = (String) request.getAttribute("employeeName");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    boolean canDelete = (Boolean) request.getAttribute("canDelete");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String lang, langCode, tit, save, cancel, tit1, RU, EMP;
    
    if(stat.equals("En")) {
        align="center";
        dir="LTR";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Delete Employee - <font color=#F3D596>Are you Sure ?</font>";
        tit1="Delete Employee";
        save="Delete";
        cancel="Back To List";
        RU="Cannot Delete This Employee Because Linked With Maintenance Items";
        EMP="Employee Name";
    } else {
        align="center";
        dir="RTL";
        lang="English";
        langCode="En";
        tit="  &#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1605;&#1600;&#1600;&#1600;&#1600;&#1608;&#1592;&#1600;&#1600;&#1600;&#1600;&#1601; - <font color=#F3D596>&#1607;&#1600;&#1600;&#1604; &#1571;&#1606;&#1600;&#1600;&#1578; &#1605;&#1600;&#1600;&#1578;&#1600;&#1600;&#1571;&#1603;&#1600;&#1600;&#1600;&#1600;&#1583; &#1567;</font>";
        tit1="&#1581;&#1600;&#1600;&#1600;&#1584;&#1601; &#1605;&#1600;&#1600;&#1600;&#1600;&#1608;&#1592;&#1600;&#1600;&#1600;&#1600;&#1601;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        RU="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1607;&#1584;&#1575; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1604;&#1571;&#1606;&#1607; &#1605;&#1585;&#1578;&#1576;&#1591; &#1605;&#1593; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">

    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm() {
      document.DELETE_EMPLOYEE_FORM.action = "<%=context%>/EmployeeServlet?op=Delete&employeeId=<%=employeeId%>&employeeName=<%=employeeName%>";
      document.DELETE_EMPLOYEE_FORM.submit();
   }
  
   function cancelForm() {
        document.DELETE_EMPLOYEE_FORM.action = "<%=context%>/EmployeeServlet?op=ListEmployee";
        document.DELETE_EMPLOYEE_FORM.submit();
    }
        
    </SCRIPT>
    
    <BODY>
        <FORM action="" NAME="DELETE_EMPLOYEE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="cancelForm()" class="button"><%=cancel%></button>
                <% if(canDelete) { %>
                    &ensp;
                    <button onclick="submitForm()" class="button"><%=save%></button>
                <% } %>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699; width: 90%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1">
                                <% if(canDelete) { %>
                                    <%=tit%>
                                <% } else  { %>
                                    <%=tit1%>
                                <% } %>
                                </FONT>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <% if(canDelete) { %>
                    <TABLE class="backgroundTable" ALIGN="center" DIR="<%=dir%>" CELLPADDING="5" CELLSPACING="5" BORDER="0" width="90%">
                        <TR>
                            <TD STYLE="text-align: center" class='backgroundHeader' width="40%">
                                <p><b><%=EMP%></b></p>
                            </TD>
                            <TD align="center" class='backgroundHeader' width="60%">
                                <input style="width: 95%; font-weight: bold; color: black;" readonly type="TEXT" name="employeeName" value="<%=employeeName%>" ID="<%=employeeName%>" size="33"  maxlength="50">
                                <input type="HIDDEN" name="techId" value="<%=employeeId%>">
                            </TD>
                        </TR>
                    </TABLE>
                    <% } else  { %>
                    <TABLE class="blueBorder" cellspacing="0" cellpadding="0" align="<%=align%>" dir="<%=dir%>" width="90%">
                        <TR>
                            <TD class="backgroundTable">
                                <b><font size=4 color='red'><%=RU%></font></b>
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
