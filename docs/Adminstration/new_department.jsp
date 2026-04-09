<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<HTML>
<%
String status = (String) request.getAttribute("Status");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status,Dupname;
String dept_name_label=null;
String dept_desc_label=null;
String title_1,title_2;
String cancel_button_label;
String save_button_label;
String fStatus;
String sStatus;

if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    dept_name_label="Department name";
    dept_desc_label="Department decription";
    title_1="Adding a new department";
    title_2="All information are needed";
    cancel_button_label="Cancel ";
    save_button_label="Save ";
    langCode="Ar";
    Dupname = "Name is Duplicated Chane it";
    sStatus="Department Saved Successfully";
    fStatus="Fail To Save Department";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    dept_name_label="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1587;&#1605; ";
    dept_desc_label=" &#1608;&#1589;&#1601; &#1575;&#1604;&#1602;&#1587;&#1605;";
    title_1="&#1602;&#1587;&#1605; &#1580;&#1583;&#1610;&#1583;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
    sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
    fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
}
String doubleName = (String) request.getAttribute("name");
%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>DebugTracker-add new department</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
            if (!validateData("req", this.DEPARTMENT_FORM.department_name, "Please, enter Department Name.") || !validateData("minlength=3", this.DEPARTMENT_FORM.department_name, "Please, enter a valid Department Name.")){
                this.DEPARTMENT_FORM.department_name.focus();
            }else if (!validateData("req", this.DEPARTMENT_FORM.department_desc, "Please, enter Department Description.")){
                this.DEPARTMENT_FORM.department_desc.focus();
            }  else{
                document.DEPARTMENT_FORM.action = "<%=context%>/DepartmentServlet?op=create";
                document.DEPARTMENT_FORM.submit();  
            } 
        }
         function cancelForm()
        {    
        document.DEPARTMENT_FORM.action = "main.jsp";
        document.DEPARTMENT_FORM.submit();  
        }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<BODY>

<FORM NAME="DEPARTMENT_FORM" METHOD="POST">
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
    <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
</DIV> 
<fieldset class="set" align="center">
<legend align="center">
    <table dir="<%=dir%>" align="center">
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=title_1%>                
                </font>
                
            </td>
        </tr>
    </table>
</legend>


<%
if(null!=doubleName) {

%>

<table dir="<%=dir%>" align="<%=align%>">
    <tr>
        <td class="td">
            <font size=4 > <%=Dupname%> </font> 
        </td>
        
</tr> </table>
<%

}

%>    
<table align="<%=align%>" dir=<%=dir%>>
    
    <tr>
    
    </TD>
    <%    if(null!=status) {
    if(status.equalsIgnoreCase("ok")){
    %>  
    <tr>
        <table align="<%=align%>" dir=<%=dir%>>
            <tr>                    
                <td class="td">
                    <font size=4 color="black"><%=sStatus%></font> 
                </td>                    
        </tr> </table>
    </tr>
    <%
    }else{%>
    <tr>
        <table align="<%=align%>" dir=<%=dir%>>
            <tr>                    
                <td class="td">
                    <font size=4 color="red" ><%=fStatus%></font> 
                </td>                    
        </tr> </table>
    </tr>
    <%}
    }
    %>
    <tr>
        <table align="<%=align%>" dir=<%=dir%>>
            <TR COLSPAN="2" ALIGN="<%=align%>">
                <TD STYLE="<%=style%>" class='td'>
                    <FONT color='red' size='+1'><%=title_2%></FONT> 
                </TD>
        </TR></table>
    </tr>
</table>
<%    if(null!=status) {

%>
<br><br>
<%
}
%>

<TABLE ALIGN="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">
    
    
    <TR>
        
        <TD  STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Department_Name">
                <p><b> <%=dept_name_label %><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <td class='td'><b>:</b></td>
        
        <TD STYLE="<%=style%>" class='td'>
            <input type="TEXT" dir="<%=dir%>" name="department_name" ID="department_name" size="32" value="" maxlength="255">
        </TD>
        
        <td class='td'></td><td class='td'></td>
    </TR>
    
    <TR>
        
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Department_Desc">
                <p><b><%=dept_desc_label%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>   
        <td class='td'><b>:</b></td>
        <TD STYLE="<%=style%>" class='td'>
            <TEXTAREA rows="5" dir="<%=dir%>" name="department_desc" ID="department_desc" cols="26"></TEXTAREA>
        </TD>
        <td class='td'></td><td class='td'></td>
    </TR>
</TABLE>
<br><br>
</FORM>
</BODY>
</HTML>     
