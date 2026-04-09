<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
EqStateTypeMgr eqStateTypeMgr = EqStateTypeMgr.getInstance();
EquipmentStatusMgr eqpStatusMgr = EquipmentStatusMgr.getInstance();

String context = metaMgr.getContext();
eqStateTypeMgr.cashData();

//Get request data
String status = (String) request.getAttribute("status");
String newStatus = (String) request.getAttribute("currentStatus");
String equipmentID = (String) request.getParameter("equipmentID");

//Get equipment data
WebBusinessObject eqWbo = maintainableMgr.getOnSingleKey(equipmentID);
String statusDate = eqWbo.getAttribute("statusDate").toString();
String displayDate = eqpStatusMgr.getStatusDateTime(equipmentID);

//get equipment current status
String eqpCurrentStatus = null;
WebBusinessObject statusWbo = eqStateTypeMgr.getOnSingleKey(eqWbo.getAttribute("equipmentStatus").toString());
eqpCurrentStatus = statusWbo.getAttribute("name").toString();

//Get equipment status type
if(newStatus.equals("1")){
    newStatus = new String("2");
} else {
    newStatus = new String("1");
}
WebBusinessObject wbo = eqStateTypeMgr.getOnSingleKey(newStatus);


//get session logged user and his trades
WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

// get current date
Calendar cal = Calendar.getInstance();
String jDateFormat=user.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowTime=sdf.format(cal.getTime());

//Build time arrays
ArrayList hoursAL = new ArrayList();
String hour = null;
for(int i=0; i<24; i++){
    if(i<= 9){
        hour  = "0"+new Integer(i).toString();
    } else {
        hour = new Integer(i).toString();
    }
    
    hoursAL.add(hour);
}

ArrayList minutesAL = new ArrayList();
String minute = null;
for(int i=0; i<60; i++){
    if(i<= 9){
        minute  = "0"+new Integer(i).toString();
    } else {
        minute = new Integer(i).toString();
    }
    minutesAL.add(minute);
}

String cMode= (String) request.getSession().getAttribute("currentMode");
String stat=cMode;
String align=null;
String dir=null;
String style=null;
String MS=null;
String MF=null;
String MWD=null;
String message=null;
String cellAlign = null;
String lang, langCode, back, save, changeStatus, basicData, eqpName,
        currentState, satType, stDate, calenderTip, inHour, note, saveStatus, toDate;

if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="&#1593;&#1585;&#1576;&#1610;";
    langCode="Ar";
    cellAlign = "left";
    
    back="Back";
    save="update";
    changeStatus="Change Equipment Working Status";
    basicData = "Basic Data";
    eqpName = "Equipment Name";
    currentState = "Current State";
    satType="New equipment status type";
    stDate="Starting Date";
    calenderTip="click inside text box to opn calender window";
    inHour="Starting Time";
    note="Note";
    MF = "Saving Failed";
    MS= "Data had been saved successfully";
    MWD = "Saving Failed - new status begin date should be greater than current status Date";
    toDate = "Working to date";
}else{
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    cellAlign="right";
    
    save="  &#1578;&#1581;&#1583;&#1610;&#1579;";
    back="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
    changeStatus = "&#1578;&#1594;&#1610;&#1610;&#1585; &#1581;&#1575;&#1604;&#1577; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    basicData = "&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
    eqpName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    currentState = "&#1581;&#1575;&#1604;&#1577; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1575;&#1604;&#1570;&#1606;";
    satType="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1580;&#1583;&#1610;&#1583;&#1577; &#1604;&#1604;&#1605;&#1593;&#1583;&#1577;";
    stDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;";
    calenderTip="&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
    inHour="&#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;";
    note="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    MS="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
    MF="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    MWD = "&#1582;&#1591;&#1571; &#1601;&#1610; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; - &#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1580;&#1583;&#1610;&#1583;&#1577; &#1604;&#1575; &#1576;&#1583; &#1571;&#1606; &#1610;&#1603;&#1608;&#1606; &#1571;&#1603;&#1576;&#1585; &#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;";
    toDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
}
%>

<script src='ChangeLang.js' type='text/javascript'></script>
<script type="text/javascript" src="js/epoch_classes.js"></script>
<script src='js/silkworm_validate.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        var dp_cal1;      
        window.onload = function () {
   	    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
        };
        
        function back(url){
             document.ISSUE_FORM.action = url;
            document.ISSUE_FORM.submit(); 

        }
        
        function submitForm(){ 

            if(document.getElementById("beginDate").value==""){
                alert("Please enter Begin Date in format '<%=jDateFormat%>'");
            } else if (!compareDate()){
                alert('new status begin date should be greater than current status Date');
            }else{
                document.ISSUE_FORM.action = "<%=context%>/EqStateTypeServlet?op=SaveStatus";
                document.ISSUE_FORM.submit();  
            }
        }
        
    function compareDate()
    {
        var lastStatusDate='<%=statusDate%>';
        var dateValue=lastStatusDate.replace(/-/g,"/");
        
        return Date.parse(document.getElementById("beginDate").value) >= Date.parse(dateValue);
    }
        
</SCRIPT>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    </HEAD>
    
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        
        <CENTER>
            <FORM NAME="ISSUE_FORM" METHOD="POST">
                <DIV align="left" STYLE="color:blue;">
                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                    <button onclick="back('<%=context%>/UnitDocReaderServlet?op=ViewImages&equipmentID=<%=equipmentID%>')" class="button"><%=back%><img src="images/leftarrow.gif"></button>
                    <button onclick="submitForm()" class="button"><%=save%><img src="images/save.gif"></button>
                </DIV>
                <br>
                
                <fieldset align="center" class="set" >
                    <legend align="center">
                        <table dir="<%=dir%>" align="center">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6"> <%=changeStatus%></font>
                                </td>
                            </tr>
                        </table>
                    </legend>
                    <br>
                    
                    
                    
                    <table border="0" ALIGN="<%=align%>" dir="<%=dir%>" width="500">
                     
                        <tr>
                            <td colspan="2" bgcolor="cornflowerblue">
                                <font color="#FFFFFF" size="5"><b><%=basicData%></b></font>
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="150" bgcolor="#CCCCCC" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=eqpName%></font></b></td>
                            <td style="border-right-width:1px"><b><font size="3" color="red"><%=(String) eqWbo.getAttribute("unitName")%></font></b></td>
                        </tr>
                        
                        <tr>
                            <td width="150" bgcolor="#CCCCCC" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=currentState%></font></b></td>
                            <td style="border-right-width:1px"><b><font size="3" color="red"><%=eqpCurrentStatus%></font></b></td>
                        </tr>
                        
                        <tr>
                            <td width="150" bgcolor="#CCCCCC" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=toDate%></font></b></td>
                            <td style="border-right-width:1px">
                                <b>
                                    <font size="3" color="red">
                                        <%=displayDate%>
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>
                    <br>
                    
                    <% 
                    if(null!=status) {
                    %>
                    <%
                    if(status.equalsIgnoreCase("ok")){
                        message = MS;
                    } else {
                        if(status.equalsIgnoreCase("wrong dates")){
                            message = MWD;
                        } else {
                            message = MF;
                        }
                    }
                    %>
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="500">
                        <TR BGCOLOR="#FFE391">
                            <TD STYLE="text-align:center;font-size:16" class="td" >
                                <B><FONT color='red'><%=message%></FONT></B>
                            </TD>
                        </TR>
                    </table>
                    <%
                    }
                    %>
                    
                    <table border="0" ALIGN="<%=align%>" dir="<%=dir%>" width="500">
                        <tr>
                            <td colspan="2" bgcolor="#006699">
                                <font color="#FFFFFF" size="5"><b><%=changeStatus%></b></font>
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=satType%></font></b></td>
                            <td ALIGN="<%=align%>" style="border:0px">
                                <input type="text" value="<%=(String) wbo.getAttribute("name")%>" name="name" id="name" readonly size="35">
                                <input type="hidden" value="<%=newStatus%>" name="stateID" id="stateID">
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=stDate%></font></b></td>
                            <td ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <input id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                                <B><Font COLOR="red"><%=jDateFormat%></FONT></B>
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=inHour%></font></b></td>
                            <td ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <select name="m">
                                    <sw:OptionList optionList='<%=minutesAL%>' scrollTo = ""/>
                                </select>
                                <font color="red"><b>:</b></font>
                                <select name="h">
                                    <sw:OptionList optionList='<%=hoursAL%>' scrollTo = ""/>
                                </select>
                                <font color="red"> <b>  HH : MM </b></font>
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=note%></font></b></td>
                            <td ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <TEXTAREA rows="3" name="note" cols="28"></TEXTAREA>
                            </td>
                        </tr>
                    </table>
                    
                    <input type="hidden" name="equipmentID" value="<%=equipmentID%>">
                    <input type="hidden" name="currentStatus" value="<%=newStatus%>">
                    <input type="hidden" name="statusDate" value="<%=statusDate%>">
                    <br>
                </fieldset>
            </FORM>
        </CENTER>
    </BODY>
</HTML>
