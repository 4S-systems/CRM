<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    // get current date
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
    String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate=sdf.format(cal.getTime());
    
    String backTo=(String)request.getAttribute("backTo");
    
    /******Get Paln Data*********/
    String beginDate=(String)request.getSession().getAttribute("beginDate");
    String endDate=(String)request.getSession().getAttribute("endDate");
    String planUnitId=(String)request.getSession().getAttribute("planUnitId");
    String planType=(String)request.getSession().getAttribute("planType");
    
    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");
    
    String status = (String) request.getAttribute("Status");
    
    String issueId=(String) request.getAttribute("issueId");
    String blusUrl="";
    String message;
    String backUrl=context+"/SearchServlet?op=StatusProjectListAll&filterValue="+filterValue;
    if(session.getAttribute("case")!=null){
        blusUrl="&case=case39&unitName="+(String)session.getAttribute("unitName")+"&title="+(String)session.getAttribute("title");
        backUrl=context+"/SearchServlet?op=StatusProjctListTitle&filterValue="+filterValue+blusUrl;
    }
    
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String align,M1,M2, dir, style, lang, langCode, sTitle, sCancel, sSave;
    //if(cMode.equals("En")){
    //    align="center";
    //    dir="LTR";
    //    style="text-align:left";
    //    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    //    langCode="Ar";
    //    sTitle = "Update Begin and End Date for Task";
    //    sCancel = "Cancel";
    //    sSave = "Save Update";
    //} else {
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    M1="The Saving Successed";
    M2="The Saving Successed Faild";
    langCode="En";
    sTitle = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1577; &#1608;&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    sCancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    sSave = "&#1587;&#1580;&#1604; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579;";
    M1="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
    M2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    //}
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

    <HEAD>
        <TITLE>DebugTracker-Update Start and End Date for Schedule</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">

        <LINK rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">
        
    </HEAD>
    <script src='silkworm_validate.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    $(document).ready(function() {

        var dates = $( "#beginDate, #endDate" ).datepicker({
            defaultDate: "+1w",
            changeMonth: true,
            changeYear : true,
            dateFormat : "yy/mm/dd",
            numberOfMonths: 1,
            showAnim   : 'drop',
            onSelect: function( selectedDate ) {
                var option = this.id == "beginDate" ? "minDate" : "maxDate",
                instance = $( this ).data( "datepicker" ),
                date = $.datepicker.parseDate(
                instance.settings.dateFormat ||
                    $.datepicker._defaults.dateFormat,
                selectedDate, instance.settings );
                dates.not( this ).datepicker( "option", option, date );

                dates.not( "#beginDate" ).datepicker( "option", "minDate", date );

            }
        });

    });
            
    function submitForm()
    {    
        if (compareDate())
        {
            document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=UpdateJobIssueDate&issueId=<%=issueId%>&filterValue=<%=filterValue%>";
            document.ISSUE_FORM.submit();
        } else {
            alert('End Date must be greater than or equal Begin Date');
        }

    }

    function cancelForm(url)
    {    
        var backTo="<%=backTo%>";
        if(backTo=="lateJO"){
            var backURL="SearchServlet?op=ListLateJO&unitId=<%=planUnitId%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>";
            window.navigate(backURL);
        }else{
            window.navigate(url);
        }
    }

    function compareDate()
    {
        return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
    }

    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <!--input type="button" value="<!%=lang%>" onclick="reloadAE('<!%=langCode%>')" class="button"-->
                <button  onclick="JavaScript: cancelForm('<%=backUrl%>');" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=sSave%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <br>
            <fieldset align="center" class="set" >
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <% 
                if(null!=status) {
        if(status.equalsIgnoreCase("ok")){
            message  = M1;
        } else {
            message = M2;
        }
                %>
                <br><br>
                <table align="right" ><tr>
                        <td  CLASS="td" style="text-align:right">  <b><font size=4 ><%=message%> </font></b></td>
                        <td class="td">
                            <IMG VALIGN="BOTTOM" HEIGHT="20"  SRC="images/aro.JPG">
                        </td>
                </tr></table> 
                <br>
                <%
                }
                %>
                <br><br>
                <TABLE ALIGN="RIGHT" DIR="RTL" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    
                    
                    
                    <%
                    String url = request.getRequestURL().toString();
                    String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                    Calendar c = Calendar.getInstance();
                    if(request.getParameter("beginDate") != null){
                        String[] arDate = request.getParameter("beginDate").split("/");
                        TimeServices.setDate(arDate[0] + "-" + arDate[1] + "-" + arDate[2]);
                        c.setTimeInMillis(TimeServices.getDate());
                    }
                    %>
                    <tr>
                        <TD STYLE="text-align:right" class='td'>
                            <LABEL FOR="EXPECTED_B_DATE">
                                <b><font color="#003399">Expected Begin Date / &#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td STYLE="text-align:right" class="td">
                            <input name="beginDate" id="beginDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                        </td>
                    </tr>
                    
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    <%
                    if(request.getParameter("endDate") != null){
                        String[] arDate = request.getParameter("endDate").split("/");
                        TimeServices.setDate(arDate[0] + "-" + arDate[1] + "-" + arDate[2]);
                        c.setTimeInMillis(TimeServices.getDate());
                    }
                    %>
                    <tr>
                        <TD STYLE="text-align:right" class='td'>
                            <LABEL FOR="EXPECTED_E_DATE">
                                <p><b><font color="#003399">Expected End Date / &#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td STYLE="text-align:right" class="td">
                            <input name="endDate" id="endDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                        </td>
                    </tr>
                    <input type="hidden" name="issueId" value="<%=issueId%>">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <tr>
                        <TD STYLE="text-align:right" class='td'>
                            <LABEL FOR="reason">
                                <p><b><font color="#003399">Change Reason / &#1587;&#1576;&#1576; &#1575;&#1604;&#1578;&#1594;&#1610;&#1610;&#1585;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td STYLE="text-align:right" class="td">
                            <TEXTAREA rows="5" name="reason" ID="reason" cols="30"></TEXTAREA>
                        </td>
                    </tr>
                    <input type="hidden" name="issueId" value="<%=issueId%>">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
                <input type="hidden" name="backTo" id="backTo" value="<%=backTo%>">
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
