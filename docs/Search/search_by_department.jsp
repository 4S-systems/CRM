<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
    
<HTML>
    <%
    UserMgr userMgr = UserMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sSearchTitle, sAttachingStatus,group,shift,ReceivedBY;
    ArrayList arrDep = departmentMgr.getCashedTableAsBusObjects();
    
    // get current date
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
    String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime=sdf.format(cal.getTime());
    
    //Define language setting
    String cMode = (String) request.getSession().getAttribute("currentMode");

    
    String selectEq,beginDate,endDate,seach,cancel,title;
    
    if (stat.equals("En")) {
        selectEq="Select Equipment Name";
        beginDate="Begin Date";
        endDate="End Date";
        seach="Search";
        cancel="Cancel";
        title="Search About Future Plan";
    }else{
        selectEq="&#1571;&#1582;&#1578;&#1585;&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577;";
        beginDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1582;&#1591;&#1607;";
        endDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1582;&#1591;&#1607;";
        seach="&#1576;&#1581;&#1579;";
        cancel="&#1573;&#1606;&#1607;&#1575;&#1569;";
        title="&#1576;&#1581;&#1579; &#1593;&#1606; &#1582;&#1591;&#1607; &#1605;&#1587;&#1578;&#1602;&#1576;&#1604;&#1610;&#1607;";
    }
    
    
    if(stat.equals("En")){
        align="center";        
        beginDate="Begin Date";
        endDate="End Date";
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
        ReceivedBY="Required By";
    }else{
        beginDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1582;&#1591;&#1607;";
        endDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1582;&#1591;&#1607;";
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
        ReceivedBY="&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1591;&#1575;&#1604;&#1576;&#1577;";
       
      
        }
    
   
    
    String searchByShift = "searchByShift";
    String back = "new";
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>
 <style>
            .header
            {
            background: #2B6FBB url(images/gradienu.gif);
            color: #ffffff;
            height:30;
            font: bold 18px Times New Roman;
            }
            .tRow
            {
         /* background: #BDD5F1 url(images/gradient.gif) repeat-x top left;*/
            background: #ABCDEF;
            color: #083E76;
            font: bold 14px black Times New Roman;
            }
            
            .tRow2
            {
            /* background: #BDD5F1 url(images/gradient.gif) repeat-x top left;*/
            background: White;
            color: black;
            font: bold 14px Times New Roman;
            }
            .bar
            {
            background: #BDD5F1 url(images/gradient.gif) repeat-x top left;
            color: balck;
            font: 16px Times New Roman;
            height:25;
            border-style: solid;
            border-width: 1px 1px 0px 0px;
            border-color:black;
            }
            td{
            border-right-width:1px;
            }
        </style>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    var dp_cal1; 
   var dp_cal2; 
  
  window.onload = function (){
        
   	    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
   	    dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
        
        
     }
        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=SearchByResultDepartment";  
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
                            <LABEL FOR="assign_to">
                                <p><b><font color="#003399"><%=ReceivedBY%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                            <SELECT name="receivedby" id="receivedby" style="width:230px">
                                <sw:WBOOptionList wboList='<%=arrDep%>' displayAttribute = "departmentName" valueAttribute="departmentID"/>
                            </SELECT>
                            
                        </TD>         
                </TABLE>
                <INPUT TYPE="hidden" name="filterValue" value="">
                   <TABLE ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="500">
                    <TR>
                        
                        <TD CLASS="bar" STYLE="text-align:center;color:black" WIDTH="50%">
                            <b><%=beginDate%></b>
                        </TD>
                        <TD CLASS="bar" STYLE="border-left-WIDTH: 1;text-align:center;color:black;" WIDTH="50%">
                            <b><%=endDate%></b>
                        </TD>
                    </TR>
                    
                    <TR>                    
                        <TD CLASS="tRow2" style="text-align:right;" valign="MIDDLE" >
                            <input id="beginDate" name="beginDate" type="text" readonly value="<%=nowTime%>" ><img src="images/showcalendar.gif" >
                        </TD>
                        <td CLASS="tRow2" style="text-align:right" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" >
                        </td>
                    </TR>
                    
                    <tr>
                        <br><br>
                        <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                            <button  onclick="JavaScript: submitForm();"   STYLE="font-size:15;font-weight:bold; ">  <%=seach%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>          
                            <button  onclick="JavaScript: cancelForm();" STYLE="font-size:15;font-weight:bold; "><%=cancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                        </TD>
                    </tr>
                </table>
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
                    