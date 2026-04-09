<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>


    <%
    String status = (String) request.getAttribute("Status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.MILESTONE_FORM.action = "<%=context%>/MilestoneServlet?op=create";
        document.MILESTONE_FORM.submit();  
        }

    </SCRIPT>
   
    <BODY>
        <left>
        <FORM NAME="MILESTONE_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("addnewmilestone")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        <A HREF="<%=context%>/main.jsp">
                            <%=tGuide.getMessage("cancel")%>
                        </A>
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif">
                        <IMG VALIGN="BOTTOM" HEIGHT="15" WIDTH="1" SRC="images/line.gif">
                        <IMG SRC="images/save.gif">                        
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("savemilestone")%>
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <%    if(null!=status)
     {

            %>

            <table> 
                <tr><td>
                </td></tr>
                <tr><td  align=center>  <H2><%=tGuide.getMessage("milestonesavingstatus")%> : <%=status%></td></tr></H2>
            </table>
            <%
            }
            %>
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <TR COLSPAN="2" ALIGN="CENTER">
                    <TD class='td'>
                        <FONT color='red' size='+1'><%=tGuide.getMessage("allfieldsrequired")%></FONT> 
                    </TD>
                </TR>

                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Milestone_Name">
                            <p><b><font color="#FF0000">*</font><%=tGuide.getMessage("milestonename")%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="milestone_name" ID="milestone_name" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                <tr>
                    <TD class='td'>
                        <LABEL FOR="EXPECTED_E_DATE">
                            <p><b><font color="#FF0000">*</font><%=tGuide.getMessage("expectedenddate")%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <td align=left class="td">
                        <SELECT name="endMonth" size=1>
                            <sw:OptionList optionList='<%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<%=TimeServices.getCurrentMonth()%>"/>
                        </SELECT>
                        <SELECT name="endDay" size=1>
                            <sw:OptionList optionList='<%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<%=TimeServices.getCurrentDay()%>"/>
                        </SELECT>
                        <SELECT name="endYear" size=1>
                            <sw:OptionList optionList='<%= DateAndTimeConstants.getYearList()%>' scrollTo="<%=TimeServices.getCurrentYear()%>"/>
                        </SELECT>
                    </td>
                </tr>
          
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><font color="#FF0000">*</font><%=tGuide.getMessage("milestonedesc")%> </b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <TEXTAREA rows="5" name="milestone_desc" cols="25"></TEXTAREA>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    