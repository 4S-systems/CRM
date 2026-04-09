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

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String lang, langCode, sCancel,search,bDate,eDate,sTitle,pageTitle,pageTitleTip;
if(stat.equals("En")){
            bDate="from";
            eDate="to";
            lang="   &#1593;&#1585;&#1576;&#1610;    ";
            sCancel="Cancel";
            langCode="Ar";
            search="Search";
            sTitle="Search for job orders";
            pageTitle="RPT-STAT-SUCS-PLAN-8";
            pageTitleTip="Ration Success Plan Report";

} else {
            bDate="&#1605;&#1606;";
            eDate="&#1575;&#1604;&#1609;";
            lang="English";
            sCancel = "&#1593;&#1608;&#1583;&#1607;";
            langCode="En";
            search="&#1576;&#1581;&#1579;";
            sTitle=" &#1576;&#1581;&#1579; &#1593;&#1606; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
             pageTitle="RPT-STAT-SUCS-PLAN-8";
             pageTitleTip="&#1593;&#1585;&#1590; &#1576;&#1610;&#1575;&#1606; &#1578;&#1582;&#1591;&#1610;&#1591; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";

}

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

//get session logged user and his trades
WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser"); 

// get current date and Time
Calendar cal = Calendar.getInstance();
String jDateFormat=user.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());

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
            document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=RatioSuccessResult";
            document.ISSUE_FORM.submit();
        } else {
            alert('End Date must be greater than or equal Begin Date');
        }
    }
     function cancelForm()
    {    
        document.ISSUE_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
        document.ISSUE_FORM.submit();  
    }
    
    function compareDate()
    {
        return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
    }
    
</SCRIPT>
<BODY>
  <script type="text/javascript" src="js/wz_tooltip.js"></script>

<FORM NAME="ISSUE_FORM" METHOD="POST">

<input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
 <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button> <br>


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
                            <font color="blue" size="6"> <%=sTitle%>
                                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>

                              <div dir="left">
                            <table>
                                <tr>
                                    <td>
                                        <font color="#FF385C" size="3">
                                            <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=pageTitleTip%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                                        </font>
                                    </td>
                                </tr>
                            </table>
           </div>


            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                <TR>
                    
                    <TD  BGCOLOR="#cc6699" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b><font size=3 color="white"> <%=bDate%></b>
                    </TD>
                    <TD   BGCOLOR="#cc6699"  STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b> <font size=3 color="white"> <%=eDate%></b>
                    </TD>
                </TR>
                <TR>
                    
                    <TD style="text-align:right" bgcolor="#F0D5E2"  valign="MIDDLE" >
                        <%
                        String url = request.getRequestURL().toString();
                        String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                        Calendar c = Calendar.getInstance();
                        %>
 
                        <input id="beginDate" name="beginDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                        <br><br>
                    </TD>
                    
                    <td  bgcolor="#F0D5E2"  style="text-align:right" valign="middle">
 
                        <input id="bendDate" name="endDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                        <br><br>
                    </td>
                    
                </TR>
                
                <tr>
                    <br><br>
                    <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                          <button  onclick="JavaScript: submitForm();"   STYLE="background:#cc6699;font-size: 15;color:white;font-weight:bold; "><%=search%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                          <button  onclick="JavaScript: cancelForm();" STYLE="background:#cc6699;font-size: 15;color:white;font-weight:bold; "><%=sCancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>

                    </TD>
                </tr>
            </table>
            
        </fieldset>
        
</tr></td ></table>
</FORM>
</BODY>
</HTML>     
