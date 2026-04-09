<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
    
<HTML>
    <%
    UserMgr userMgr = UserMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sSearchTitle, sAttachingStatus,group,shift;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Search";
        sCancel="Cancel";
        sOk="Search";
        langCode="Ar";
        sSearchTitle = "Search by Note";
        sAttachingStatus = "Attaching Status";
        group = "Group";
        shift = "Shift";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle = "&#1576;&#1581;&#1579;";
        sCancel = tGuide.getMessage("cancel");
        sOk="&#1576;&#1581;&#1579;";
        langCode="En";
        sSearchTitle = "&#1576;&#1581;&#1579; &#1576;&#1605;&#1604;&#1575;&#1581;&#1592;&#1607;";
        sAttachingStatus = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
        group= "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        shift = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1577;";
      
        }
    
    ArrayList groupList = new ArrayList();
    groupList.add("A");
    groupList.add("B");
    groupList.add("C");
    groupList.add("D");
    
    ArrayList ShiftList = new ArrayList();
    ShiftList.add("1");
    ShiftList.add("2");
    ShiftList.add("3");
    
    String searchByShift = "searchByShift";
    String back = "new";
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=SearchByShift&searchByShift="+document.getElementById('groupName').value +"/"+ document.getElementById('shiftNum').value;
        document.ISSUE_FORM.submit();  
        }
        function cancelForm()
        {    
            document.ISSUE_FORM.action = "main.jsp";
            document.ISSUE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>
            <button  onclick="JavaScript: submitForm();" class="button"><%=sOk%> <IMG HEIGHT="15" SRC="images/search.gif"></button>
            <BR>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="trade">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=group%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td' WIDTH="33">
                            <!--input type="TEXT" name="itemUnit" ID="itemUnit" size="33" value="" maxlength="255"-->
                            <select name="groupName" ID="groupName" style="width:230px">
                                <%
                                for(int i = 0; i < groupList.size(); i++){
                                %>
                                <option value="<%=groupList.get(i)%>"><%=groupList.get(i)%>
                                <%
                                }
                                %>
                            </select>
                        </TD>
                       
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="trade">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=shift%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td' WIDTH="33">
                            <!--input type="TEXT" name="itemUnit" ID="itemUnit" size="33" value="" maxlength="255"-->
                            <select name="shiftNum" ID="shiftNum" style="width:230px">
                                <%
                                for(int i = 0; i < ShiftList.size(); i++){
                                %>
                                <option value="<%=ShiftList.get(i)%>"><%=ShiftList.get(i)%>
                                <%
                                }
                                %>
                            </select>
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
                </TABLE>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
                    