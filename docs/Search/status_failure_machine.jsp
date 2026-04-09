<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<HTML>
<%
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

//get session logged user and his trades
WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

// get current date and Time
Calendar cal = Calendar.getInstance();
String jDateFormat=user.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());

String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;

    String eqName , beginDate,endDate,searchS,searchE ,cancel,title;
    // searchS = SearchSchedual
    // searchE = SearchEmergency
    if (stat.equals("En")) {
        eqName="Category Equipment Name";
        beginDate="Begin Date";
        endDate="End Date";
        searchS="Search for Scheduled Failure";
        searchE = "Search for Emergency Failure";
        cancel="Cancel";
        title="Search About Failure in Equipment Material";
    }else{
        eqName="&#1575;&#1587;&#1605; &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577";
        beginDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577";
        endDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577";
        searchS="&#1576;&#1581;&#1579; &#1571;&#1593;&#1591;&#1575;&#1604; &#1605;&#1580;&#1583;&#1608;&#1604;&#1577";
        searchE = "&#1576;&#1581;&#1579; &#1571;&#1593;&#1591;&#1575;&#1604; &#1591;&#1575;&#1585;&#1574;&#1577";
        cancel=tGuide.getMessage("cancel");
        title="&#1576;&#1581;&#1579; &#1593;&#1606; &#1571;&#1593;&#1591;&#1575;&#1604; &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577";
    }
%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Doc Viewer- Select Project and Status</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

          var dp_cal1,dp_cal12;      
         window.onload = function () {
   	    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
            dp_cal12  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
          };
    
    function submitForm()
    {    
        if (compareDate())
        {
            document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=ResultFailureMachine";
            document.ISSUE_FORM.submit();
        } else {
            alert('End Date must be greater than or equal Begin Date');
        }
    }
    function submitEMGForm()
    {    
        if (compareDate())
        {
            document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=ResultEMGFailureMachine";
            document.ISSUE_FORM.submit();
        } else {
            alert('End Date must be greater than or equal Begin Date');
        }
    }
     
     function cancelForm()
    {    
        document.ISSUE_FORM.action = "<%=context%>/main.jsp;";
        document.ISSUE_FORM.submit();  
    }
    
    function compareDate()
    {
        return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
    }
    
</SCRIPT>
<BODY>


<FORM NAME="ISSUE_FORM" METHOD="POST">



<table align="center" width="80%">
    <tr><td class="td">
        <fieldset >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        <td class="td">  
                            <IMG WIDTH="80" HEIGHT="80" SRC="images/Search.png">
                        </td>
                        <td class="td">
                            <font color="blue" size="6"> <%=title%>
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                <TR>
                    <TD class="silver_header" STYLE="border-left-WIDTH: 0;text-align:center;">
                        <LABEL FOR="unitNamelbl">
                            <p><b><font size=3 ><%= eqName%></font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <%
                    ArrayList arrayList = new ArrayList();
                    //maintainableMgr.cashData();
                    arrayList = maintainableMgr.getCategoryAsBusObjects();
                    %>
                    <td class="silver_odd" STYLE="border-left-WIDTH: 0;text-align:center;">
                        <SELECT name="unitName" id="unitName" STYLE="width:230px">
                            <sw:WBOOptionList wboList='<%=arrayList%>' displayAttribute = "unitName" valueAttribute="id"/>
                        </SELECT>
                    </td>
                </tr>
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <TR>
                    
                    <TD  class="silver_header" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b><font size=3 > <%=beginDate%></b>
                    </TD>
                    <TD   class="silver_header"  STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b> <font size=3 > <%=endDate%> </b>
                    </TD>
                </TR>
                
                <TR>
                    
                    <TD class="silver_odd" style="text-align:right" bgcolor="#F0D5E2"  valign="MIDDLE" >
                        <%
                        String url = request.getRequestURL().toString();
                        String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                        Calendar c = Calendar.getInstance();
                        %>
                        <input id="beginDate" name="beginDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                        <br><br>
                    </TD>
                    
                    <td  class="silver_odd"  style="text-align:right" valign="middle">
                        <input id="endDate" name="endDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                        <br><br>
                    </td>
                    
                </TR>
                
                <tr>
                    <br><br>
                    <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                    <button  onclick="JavaScript: submitForm();"   STYLE="background:#f3f3f3;font-size:15;font-weight:bold; ">  <%=searchS%>  <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                    <button  onclick="JavaScript: submitEMGForm();"   STYLE="background:#f3f3f3;font-size:15;font-weight:bold; ">  <%=searchE%>  <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        <button  onclick="JavaScript: cancelForm();" STYLE="background:#f3f3f3;font-size:15;font-weight:bold; "><%=cancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                        
                    </TD>
                </tr>
            </table>
            
        </fieldset>
        
</tr></td ></table>
</FORM>
</BODY>
</HTML>     
