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
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
String ts = (String) request.getAttribute("ts");

//get session logged user and his trades
WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

// get current date
Calendar cal = Calendar.getInstance();
String jDateFormat=user.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowTime=sdf.format(cal.getTime());

String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String title ,eqName,beginDate ,endDate,search,cancel,pageTitle,pageTitleTip;

    if (stat.equals("En")) {
        title = "Search for Job Order";
        eqName = "Equipment Name";
        beginDate="Begin Date";
        endDate="End Date";
        search="Search";
        cancel="Cancel";
        pageTitle="RPT-EQP-OPRTNG-12";
        pageTitleTip="View Operation Report";

        }
        else
            {
        title = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604";
        eqName = "&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577";
        beginDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577";
        endDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577";
        search="&#1576;&#1581;&#1579";
        cancel="&#1593;&#1608;&#1583;&#1607;";
        pageTitle="RPT-EQP-OPRTNG-12";
        pageTitleTip="&#1593;&#1585;&#1590; &#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1578;&#1588;&#1594;&#1610;&#1604;";
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
    var count = 0;
    var dp_cal1,dp_cal12;
    
    window.onload = function (){
        dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
        dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
     }

    function submitForm(){
        if(!validateData("req", document.ISSUE_FORM.unitId, "Must Select Equipment ..")){
            
        }else if (compareDate()){
            var varUnitId = document.getElementById('unitId').value;
            var varUnitName = document.getElementById('unitName').value;
            var varBeginDate = document.getElementById('beginDate').value;
            var varEndDate = document.getElementById('endDate').value;
            var url = "HoursWorkingEquipmentServlet?op=listOperatingReport&unitId=" + varUnitId + "&unitName=" + varUnitName + "&beginDate=" + varBeginDate + "&endDate=" + varEndDate;
            openWindow(url, "1024", "800");
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

    function textChange(){
        document.getElementById('unitId').value = "";
    }

    function getEquipment()
        {
            var formName = document.getElementById('ISSUE_FORM').getAttribute("name");
            var name = document.getElementById('unitName').value
            var res = ""
            for (i=0;i < name.length; i++) {
            res += name.charCodeAt(i) + ',';
                }
            res = res.substr(0, res.length - 1);
            openWindow('HoursWorkingEquipmentServlet?op=listEquipmentBySite&unitName='+res+'&formName='+formName + '&typeOfRate=all',"750","400");
        }
    function openWindow(url,width,height)
        {
            window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=" + width + ", height=" + height);
        }

</SCRIPT>



<BODY>
 <script type="text/javascript" src="js/wz_tooltip.js"></script>

<FORM NAME="ISSUE_FORM" ID="ISSUE_FORM" METHOD="POST">


<div dir="LTR" id="divDutton">

                        <button  onclick="JavaScript: cancelForm();" style="width:80px"><%=cancel%></button>


                </div>
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
                            <font color="blue" size="6"><%=title%></font>
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

            <TABLE ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;">
                <TR>
                    <TD STYLE="text-align:center"  BGCOLOR="#437C17" WIDTH="50%">
                        <LABEL FOR="Project_Name">
                            <p><b> <font size=3 color="white"><%=eqName%><font color="#FF0000"></font></b>&nbsp;
                        </LABEL>
                    </TD>
                </TR>
                <TR>
                    <TD CLASS="cell" bgcolor="#8BB381" ROWSPAN="2" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;padding-bottom:10px;padding-top:10px" ID="data">
                        <input type="text" dir="ltr" id="unitName" name="unitName" style="width:200px" onchange="JavaScript:textChange()" />
                        <input type="hidden" id="unitId" name="unitId" />
                        <input type="button" style="width:75px" dir="ltr" id="search" name="search" value="<%=search%>" onclick="JavaScript:getEquipment()" />
                    </TD>
                </TR>
            </TABLE>


            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                <TR>
                    <TD  BGCOLOR="#437C17" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b><font size=3 color="white"><%= beginDate%> </b>
                    </TD>
                    <TD   BGCOLOR="#437C17"  STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b> <font size=3 color="white"><%= endDate%> </b>
                    </TD>
                </TR>
                <TR>
                    <TD style="text-align:right;padding-left:10px;padding-right:10px" bgcolor="#8BB381"  valign="MIDDLE" ALIGN="CENTER" >
                        <input id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" readonly ><img src="images/showcalendar.gif" >
                        <br><br>
                    </TD>

                    <td  bgcolor="#8BB381"  style="text-align:right;padding-left:10px;padding-right:10px" valign="middle" align="center">
                        <input id="endDate" style="vertical-align:middle;" name="endDate" align="middle" type="text" value="<%=nowTime%>" readonly ><img src="images/showcalendar.gif" >
                        <br><br>
                    </td>

                </TR>
                <tr>
                    <br><br>
                    <TD STYLE="text-align:center" CLASS="td" colspan="3">
                        <button  onclick="JavaScript: submitForm();"   STYLE="background:#8BB381;font-size:15;color:white;font-weight:bold; ">   <%= search%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        <button  onclick="JavaScript: cancelForm();" STYLE="background:#8BB381;font-size:15;color:white;font-weight:bold; "> <%=cancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                    </TD>
                </tr>
            </TABLE>
        </fieldset>

</td></tr></table>
</FORM>
</BODY>
</HTML>
