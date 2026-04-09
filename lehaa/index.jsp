<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%//???@ page errorPage="ErrorPage.jsp" isErrorPage="false"%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
   function Validate() 
   {
      document.frm_My_Form.submit();
   }
</SCRIPT>

<HTML>
<HEAD>
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html  charset=UTF-8">
    <TITLE>Document Viewer System - Silkworm</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" SRC="Library.js" TYPE="text/javascript">
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
</SCRIPT>

<style>
    td
    {
    border:0;
    }
    .tableright
    {
    text-align:center;
    }
    .error
    {
    color:red;
    font-weight:bold;
    }
</style>

<%
GroupMgr groupMgr = null;
// TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
try {
    groupMgr = GroupMgr.getInstance();
} catch(java.lang.NullPointerException np) {
    System.out.println("Null Pointer Exception  ");
} 
%>
<BODY ONLOAD="document.frm_My_Form.userName.focus();">
<CENTER>
  
    
    <table dir="rtl" width=100% height=100% bordercolor=green>
    <tr>
    <td width=20% bgcolor="green"> </td>
    <td valign="center" width=60%>
    <br>
    <FORM NAME="frm_My_Form" ACTION="TrackerLoginServlet" METHOD="POST">
        <TABLE DIR="RTL" BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD COLSPAN="2" ALIGN="CENTER">
                    <IMG height='200' width='700' SRC="images/pic_menu.jpg">
                </TD>
            </TR>
            <TR>
            
            <TD CLASS="td" ALIGN="center" WIDTH="665"> 
            
            <fieldset> <legend align="center" ><IMG SRC="images/index_top3.jpg"> </LEGEND>
                <TABLE ALIGN="Center" WIDTH="650">
                    <TR>
                        <TD ALIGN="Center" COLSPAN="6">
                            <%
                            String isValid = (String)request.getAttribute("loginResult");
                            System.out.println("0000 "+isValid);
                            if(isValid!=null && isValid.equals("invalid")) {
                            %>
                            <FONT color = 'red' SIZE="+1">&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1582;&#1575;&#1591;&#1574;&#1607;</Font><p>
                            <%
                            }
                            %>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD>
                            <LABEL FOR="userName">
                                <font size=3> <b>&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; </b>
                            </LABEL>
                            <INPUT TYPE="TEXT" NAME="userName" ID="userName" VALUE="">
                            
                            <LABEL FOR="str_Password">
                                <b>&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585; </b>
                            </LABEL>
                            <INPUT TYPE="PASSWORD" NAME="password" ID="password" VALUE="">
                            
                            <LABEL FOR="str_GroupName">
                                <b> &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1607; </b>
                            </LABEL>
                            
                            <SELECT name="groupID">
                                <sw:WBOOptionList wboList='<%=groupMgr.getCashedTableAsBusObjects()%>' displayAttribute="groupName" valueAttribute="groupID" scrollTo = ""/>
                            </SELECT>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <br><br>
                            <button  type=submit STYLE="background:green; " ONMOUSEDOWN="JavaScript: Validate()" > <font color="white" ><b> &nbsp;&nbsp;&nbsp; &#1583;&#1582;&#1608;&#1604;&nbsp;&nbsp;&nbsp; </b></font> </BUTTON>
                        </TD>
                    </TR>
                </TABLE>
            </fieldset>
        </table>
        <td bgcolor="green"> </td>
        
    </FORM>
</CENTER>
</tr>
</table>
</BODY>
</HTML>

