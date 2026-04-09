<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
    
<HTML>
    <%
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
    
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String op = (String) request.getAttribute("op");
    String ts = (String) request.getAttribute("ts");
    System.out.println("target op is " + op );

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Select Site</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=<%=op%>";
        document.ISSUE_FORM.submit();  
        }

    </SCRIPT>
    <BODY>
      
      
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle"  STYLE="border-left-WIDTH: 1;text-align:left;">
                        <b> Select the Site</b>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                    
                        <A HREF="<%=context%>/main.jsp;">
                            <b> Cancel</b>
                            <IMG SRC="images/cancel.gif">
                        </A>
               
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            <IMG SRC="images/search.gif">
                            <b> View</b>   
                        </A>
                    </TD>
                </TR>
            </TABLE>

            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR>
                <TD class="td" >
                    &nbsp;
                </TD>
            </TR>
            </table>       

            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        <LABEL FOR="Project_Name">
                            <p><b>Site Name<font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <SELECT name="projectName">
                            <sw:WBOOptionList wboList='<%=projectMgr.getCashedTableAsBusObjects()%>' displayAttribute = "projectName" valueAttribute="projectName"/>
                        </SELECT>
                    </TD>
                </TR>                         
            </TABLE>
            <INPUT TYPE="hidden" name="filterValue" value="">
       
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR>
                <TD class="td">
                    &nbsp;
                </TD>
            </TR>
            </table>
            <%
            if(op.equalsIgnoreCase("StatusReport")) {
            %>
            <TABLE WIDTH=570 CELLSPACING=2 CELLPADDING=1>
            <TR>
               
                <TD CLASS="datetitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    <b>Begin Date</b>
                </TD>
                <TD CLASS="datetitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    <b> End Date </b>
                </TD>
            </TR>
            <TR>
                <TD valign=top class="td">
                    <TABLE CELLSPACING=1 CELLPADDING=1 WIDTH=100% border=0>

                    

                        <tr>
                            <td align=left class="td">

                                <SELECT name="startMonth" size=1>
                                    <sw:OptionList optionList='<%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<%=TimeServices.getCurrentMonth()%>"/>
                                </SELECT>

                                <SELECT name="startDay" size=1 >
                                    <sw:OptionList optionList='<%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<%=TimeServices.getCurrentDay()%>"/>/>
                                </SELECT>

                                <SELECT name="startYear" size=1>
                                    <sw:OptionList optionList='<%= DateAndTimeConstants.getYearList()%>' scrollTo="<%=TimeServices.getCurrentYear()%>"/>
                                </SELECT>
                            </td>
                        </tr>
               
                    </TABLE>
                </TD>
  
                <TD valign=top class="td">
                    <TABLE >
                        <tr>
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
           
                    </TABLE>
                </TD>
            </TR>
            </table>
            <%
            }
            %>
        </FORM>
    </BODY>
</HTML>     
                    