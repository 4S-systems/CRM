<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

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
            <FORM NAME="frm_My_Form" ACTION="TrackerLoginServlet" METHOD="POST">
                <TABLE ALIGN="CENTER" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD COLSPAN="2" ALIGN="CENTER">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD COLSPAN="2" ALIGN="CENTER">
                            <IMG height='200' width='700' SRC="images/pic_menu.jpg">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD>
                            &nbsp;
                        </TD>
                        <TD>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <TR>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                            <TR>
                                <TD WIDTH="702" HEIGHT="56" COLSPAN="3"><IMG SRC="images/index_top3.jpg"></TD>
                            </TR>
                            <TR>
                                <TD ALIGN="left" width="16" HEIGHT="138"><IMG SRC="images/index_right.jpg"></TD>
                                <TD CLASS="td" ALIGN="center" WIDTH="665"> 
                                    <TABLE ALIGN="Center" WIDTH="650">
                                        <TR>
                                            <TD ALIGN="Center" COLSPAN="6">
                                                <%
                                                String isValid = (String)request.getAttribute("loginResult");
                                                System.out.println("0000 "+isValid);
                                                if(isValid!=null && isValid.equals("invalid")) {
                                                %>
                                                <FONT color = 'red' SIZE="+1"><%=tGuide.getMessage("invalidinfo")%></Font><p>
                                                <%
                                                }
                                                %>
                                            </TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD>
                                                <LABEL FOR="userName">
                                                    <%=tGuide.getMessage("username")%>
                                                </LABEL>
                                                <INPUT TYPE="TEXT" NAME="userName" ID="userName" VALUE="">
                                                
                                                <LABEL FOR="str_Password">
                                                    <%=tGuide.getMessage("password")%>
                                                </LABEL>
                                                <INPUT TYPE="PASSWORD" NAME="password" ID="password" VALUE="">
                                                
                                                <LABEL FOR="str_GroupName">
                                                    <%=tGuide.getMessage("groupname")%>
                                                </LABEL>
                                                
                                                <SELECT name="groupName">
                                                    <sw:OptionList optionList='<%=groupMgr.getCashedTableAsArrayList()%>' scrollTo = ""/>
                                                </SELECT>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                <BUTTON  type=submit  ONMOUSEDOWN="JavaScript: Validate()" ><%=tGuide.getMessage("login")%></BUTTON>
                                            </TD>
                                        </TR>
                                    </TABLE>
                                    
                                </TD>
                                <TD ALIGN="left" width="16" HEIGHT="138"><IMG SRC="images/index_right_left.jpg"></TD>
                            </TR>
                            <TR>
                                <TD WIDTH="702" HEIGHT="29" COLSPAN="3"><IMG SRC="images/index_bottom.jpg"></TD>
                            </TR>
                        </TABLE>
                    </TR>
                    
                    
                    
                </TABLE>
            </FORM>
        </CENTER>
    </BODY>
</HTML>

