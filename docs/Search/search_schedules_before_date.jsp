<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
    
<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    // get current date
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String jDateFormat = "yyyy-MM-dd hh:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());

    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sSearchTitle;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Search";
        sCancel="Cancel";
        sOk="Search";
        langCode="Ar";
        sSearchTitle = "Search Schedules Before Date";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle = "&#1576;&#1581;&#1579;";
        sCancel = tGuide.getMessage("cancel");
        sOk="&#1576;&#1581;&#1579;";
        langCode="En";
        sSearchTitle = "بحث عن جداول صيانة قبل تاريخ";
    }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">

        <script type="text/javascript">
            $(document).ready(function() {

                $("#beforeDate").datetimepicker({
                    maxDate    : "+d",
                    changeMonth: true,
                    changeYear : true,
                    timeFormat:'hh:mm',
                    dateFormat : 'yy-mm-dd'
                });

            });

        </script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=searchSchedulesBeforeDate";
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
            <FIELDSET class="set" align="center">
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
                <TABLE ALIGN="center"  DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD STYLE="text-align:right" class='td'>
                            <LABEL FOR="Project_Name">
                                <p><b><%=sSearchTitle%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input readonly id="beforeDate" name="beforeDate" type="text" value="<%=nowTime%>" dir="ltr" STYLE="<%=style%>"/>
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
                    