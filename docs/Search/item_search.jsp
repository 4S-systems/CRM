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
String op = (String) request.getAttribute("op");
System.out.println("op---------------------"+op);
String ts = (String) request.getAttribute("ts");
System.out.println("ts---------------------"+ts);
System.out.println("target op is " + op );

//get session logged user and his trades
WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

// get current date
Calendar cal = Calendar.getInstance();
String jDateFormat=user.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowTime=sdf.format(cal.getTime());

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
            document.ISSUE_FORM.action = "<%=context%>/ItemsServlet?op=ItemsSearchResult";
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
                            <font color="blue" size="6"> &#1576;&#1581;&#1579; &#1593;&#1606; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;
                                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                <TR>
                    
                    <TD  BGCOLOR="#cc6699" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b><font size=3 color="white"> &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;</b>
                    </TD>
                    <TD   BGCOLOR="#cc6699"  STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b> <font size=3 color="white"> &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; </b>
                    </TD>
                </TR>
                <TR>
                    
                    <TD style="text-align:right" bgcolor="#F0D5E2"  valign="MIDDLE" >
                        
                        
                        <%
                        String url = request.getRequestURL().toString();
                        String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                        Calendar c = Calendar.getInstance();
                        %>
                        
                        
                        
                        <!--SELECT name="startMonth" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                    </SELECT>

                                    <SELECT name="startDay" size=1 >
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>/>
                                    </SELECT>

                                    <SELECT name="startYear" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                                    </SELECT-->
                        <input id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" >
                        
                        <br><br>
                    </TD>
                    
                    <td  bgcolor="#F0D5E2"  style="text-align:right" valign="middle">
                        <!--SELECT name="endMonth" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                    </SELECT>
                                    <SELECT name="endDay" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                                    </SELECT>
                                    <SELECT name="endYear" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                                    </SELECT-->
                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" >
                        
                        <br><br>
                    </td>
                    
                </TR>
                
                <tr>
                    <br><br>
                    <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                        <button  onclick="JavaScript: submitForm();"   STYLE="background:#cc6699;font-size: 15;color:white;font-weight:bold; ">  &#1576;&#1581;&#1579;  <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        <button  onclick="JavaScript: cancelForm();" STYLE="background:#cc6699;font-size: 15;color:white;font-weight:bold; "><%=tGuide.getMessage("cancel")%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                        
                    </TD>
                </tr>
            </table>
            
        </fieldset>
        
</tr></td ></table>
</FORM>
</BODY>
</HTML>     
