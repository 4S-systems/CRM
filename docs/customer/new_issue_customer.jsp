<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.util.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
DepartmentMgr deptMgr = DepartmentMgr.getInstance();

String source=(String)request.getAttribute("source");

String context = metaMgr.getContext();

//get session logged user and his trades
WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
Vector userTradeList = (Vector) user.getAttribute("vecTradeList");
ArrayList tradesAL = new ArrayList();
for (int i = 0; i < userTradeList.size(); i++) {
    WebBusinessObject tradeWbo = (WebBusinessObject) userTradeList.get(i);
    tradesAL.add(tradeWbo);
}

//Get request data
WebBusinessObject eqpWbo = (WebBusinessObject) request.getAttribute("currentEqp");
WebBusinessObject currenEquip = null;
String jobOrderNumber = request.getAttribute("JONo").toString();

String unitName=eqpWbo.getAttribute("unitName").toString();

//define variables
ArrayList eqpsList = new ArrayList();

//set page defualts
//get system equipments
Vector eqpsVec = (Vector) request.getAttribute("equipments");

if(eqpsVec != null && eqpsVec.size()>0){
    for (int i = 0; i < eqpsVec.size(); i++) {
        WebBusinessObject wbo = (WebBusinessObject) eqpsVec.elementAt(i);
        eqpsList.add(wbo);
    }
}

//define JO work size
ArrayList JobZiseList = new ArrayList();

//get system departments
ArrayList deptAL = deptMgr.getCashedTableAsBusObjects();

//get system urgency
ArrayList urrgencyAL = urgencyMgr.getCashedTableAsBusObjects();

//get unitId after reload from pupo to select Equip
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
String unitId = request.getParameter("unitId");
String equipName = "";
String rateType = "mustSelectEquip";
if(unitId != null){
    currenEquip = maintainableMgr.getOnSingleKey(unitId);
    rateType = (String) currenEquip.getAttribute("rateType");
    equipName = (String) currenEquip.getAttribute("unitName");
}else{
    unitId = "";
}

// get current date
Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String nowDate=sdf.format(cal.getTime());
String nowTime=sdfTime.format(cal.getTime());
String hr=nowTime.substring(nowTime.length()-8,nowTime.length()-6);
String min=nowTime.substring(nowTime.length()-5,nowTime.length()-3);

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

String []shifts=new String[4];
//Define language setting
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align = null;
String dir = null;
String style = null;
String cellAlign = null;
String lang, langCode, cancel, save, Titel, JOReq, MUnit, ReceivedBY,shift,
        checkboxTip,backToEqp,Time,calenderTip, eqpSiteEntryDate, eBDate, eEDate, pDesc,
        selectDesc, noData,trade,estematedDuration,hourStr,update,name,Lread,Date,LastDate,LastEReading,cominte;
String sMinute,sHour,sDay,search;
String haveNotGenerate;
if (stat.equals("En")) {
    LastEReading = "Last Equipment Reading";
    name="Equipment Name";
    Lread="No.of Kilometers For working to date";
    Date="Last Reading";
    LastDate="Date For Last Reading";
    Time="Reporting Time";
    calenderTip="click inside text box to opn calender window";
    checkboxTip="Check to write description now or un check to <br>write many fields of description later";
    align = "center";
    cellAlign = "left";
    dir = "LTR";
    style = "text-align:left";
    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
    langCode = "Ar";
    
    JobZiseList.add("Large");
    JobZiseList.add("medium");
    JobZiseList.add("small");
    
    cancel = "Back to main page";
    save = "Save Job Order";
    Titel = "New Regular Job Order ";
    JOReq = "Job order requirments";
    MUnit = "Equipment Name";
    ReceivedBY = "Required By";
    eqpSiteEntryDate = "Reporting Date";
    eBDate = "Expected Begin Date";
    eEDate = "Expected End Date";
    pDesc = "Problem Description";
    selectDesc = "Describe the problem";
    noData = "No Data are available for one or more of those fields:";
    backToEqp="Back To Equipment";
    trade="Work Order Trade";
    shift="Shift";
    shifts[0]="Shift 1";
    shifts[1]="Shift 2";
    shifts[2]="shift 3";
    shifts[3]="Daylight";
    estematedDuration="Expected Duration";
    hourStr="Minutes";
    sMinute = "Minute";
    sHour = "Hour";
    sDay = "Day";
    search="Search";
    update= "Update Counter of Equipment";
    cominte="Note";
    haveNotGenerate="Unauthorized user to activate the scheduling because branch of equipment is different from the user's location";
} else{
    checkboxTip="&#1575;&#1582;&#1578;&#1575;&#1585; &#1575;&#1604;&#1605;&#1585;&#1576;&#1593; &#1581;&#1578;&#1609; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1603;&#1578;&#1575;&#1576;&#1607; &#1608;&#1589;&#1601; &#1575;&#1604;&#1575;&#1606; &#1575;&#1608; &#1575;&#1578;&#1585;&#1603;&#1607; <br> &nbsp;&#1582;&#1575;&#1604;&#1610;&#1575; &#1608;&#1575;&#1590;&#1601; &#1575;&#1604;&#1593;&#1583;&#1610;&#1583; &#1605;&#1606; &#1575;&#1604;&#1608;&#1589;&#1601; &#1601;&#1610;&#1605;&#1575; &#1576;&#1593;&#1583; ";
    calenderTip="&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
    Time="&#1608;&#1602;&#1578; &#1575;&#1604;&#1573;&#1576;&#1604;&#1575;&#1594;";
    align = "center";
    cellAlign = "right";
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    
    JobZiseList.add("&#1603;&#1576;&#1610;&#1585;");
    JobZiseList.add("&#1605;&#1578;&#1608;&#1587;&#1591;");
    JobZiseList.add("&#1576;&#1587;&#1610;&#1591;");
    
    cancel = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1575;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    Titel = " &nbsp;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1593;&#1575;&#1583;&#1609;";
    save = " &#1578;&#1587;&#1580;&#1610;&#1604; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    JOReq = "&#1605;&#1578;&#1591;&#1604;&#1576;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    MUnit = "&#1575;&#1604;&#1608;&#1581;&#1583;&#1607; &#1575;&#1604;&#1605;&#1589;&#1575;&#1606;&#1607;";
    ReceivedBY = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1591;&#1575;&#1604;&#1576;&#1577;";
    eqpSiteEntryDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1576;&#1604;&#1575;&#1594;";
    eBDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    eEDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    pDesc = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1607;";
    selectDesc = "&#1575;&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;";
    noData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;:";
    backToEqp="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;";
    trade="&#1606;&#1608;&#1593; &#1575;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;";
    shift="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607;";
    shifts[0]="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 1";
    shifts[1]="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 2";
    shifts[2]="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 3";
    shifts[3]="&#1606;&#1607;&#1575;&#1585;&#1609;";
    estematedDuration="&#1605;&#1583;&#1607; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1607;";
    hourStr="&#1583;&#1602;&#1600;&#1600;&#1600;&#1600;&#1610;&#1600;&#1600;&#1600;&#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1607;";
    sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
    sHour = "&#1587;&#1575;&#1593;&#1577;";
    sDay = "&#1610;&#1608;&#1605;";
    search="&#1576;&#1581;&#1579;";
    haveNotGenerate ="&#1594;&#1610;&#1585; &#1605;&#1589;&#1585;&#1581; &#1604;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1578;&#1601;&#1593;&#1610;&#1604; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;&#1577; &#1604;&#1571;&#1606; &#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1610;&#1582;&#1578;&#1604;&#1601; &#1593;&#1606; &#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";

    update = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    cominte="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    LastEReading="&#1571;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1607; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607;";
    Lread="&#1575;&#1604;&#1601;&#1585;&#1602; &#1576;&#1610;&#1606; &#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1578;&#1610;&#1606; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607;";
    Date="&#1571;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1575;&#1577; &#1604;&#1604;&#1593;&#1583;&#1575;&#1583;";
    name=" &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; ";
    LastDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1571;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;";
}
SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
String authUser = securityUser.getSearchBy();
String userId = securityUser.getUserId();
String branchIdForUser = securityUser.getSiteId();
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <%-----------------------------------------%>
        <script src="js/dhtmlxcommon.js"></script>
        <script src="js/dhtmlxcombo.js"></script>
        <link rel="STYLESHEET" type="text/css" href="css/dhtmlxcombo.css">
        <%-----------------------------------------%>
    </HEAD>
    
    <script src='js/silkworm_validate.js' type='text/javascript'></script>
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <script type="text/javascript" src="js/epoch_classes.js"></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        var dp_cal1, dp_cal2, dp_cal3;      
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('popup_container1'));
            dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('popup_container2'));
            dp_cal3  = new Epoch('epoch_popup','popup',document.getElementById('popup_container3'));
        };
        
        function cancelForm(){    
            document.ISSUE_FORM.action = "<%=context%>/main.jsp";
            document.ISSUE_FORM.submit();  
        }
         function  backToEquipment(eqpID){
            var eqp="&equipmentID=";            
            var temp=eqp+eqpID;            
            var url="<%=context%>/UnitDocReaderServlet?op=ViewImages"+temp;
            document.ISSUE_FORM.action = url;
            
            document.ISSUE_FORM.submit();  
        }
       function inputChange(){
           document.getElementById('unitId').value = "";
       }
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
        
        function openDesc(checkBox){
            if(checkBox.checked){
                document.getElementById("issueDesc").disabled = false
            } else {
                document.getElementById("issueDesc").value = ""
                document.getElementById("issueDesc").disabled = true
            }
        }
        
        function submitForm()
        { 
            if(!validateData("req", document.ISSUE_FORM.unitId, "Must Select Equpmint From Search...")){
                document.ISSUE_FORM.btnSearch.focus();
            } else if(!compareDate(document.getElementById("popup_container1").value,document.getElementById("popup_container2").value)){
                alert('(Expected Begin Date) must be less than or equle to (Site Entry Date)');
            } else if(!compareDate(document.getElementById("popup_container2").value,document.getElementById("popup_container3").value)){
                alert('(Expected End Date) must be greater than or equle to (Expected Begin Date)');
            }else if (document.getElementById("desc").checked && !validateData("req", this.ISSUE_FORM.issueDesc, "Please, enter Description.")){
                this.ISSUE_FORM.issueDesc.focus();
            }else if(!checkDateTime()){
                    alert("Put time to maintenance item");
                    this.ISSUE_FORM.minute.focus();
            }else{
                if(document.getElementById("desc").checked){
                
                    document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=create";
                        
                } else {
                    document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=create&issueDesc=No Description";
                }
                if(document.getElementById('updateEquip').checked){
                    if(!validateData("req", document.ISSUE_FORM.current_Reading, "Must Enter Read of Counter...") || !validateData("num", document.ISSUE_FORM.current_Reading, "Must Enter Number")){
                        this.document.ISSUE_FORM.current_Reading.focus();
                    }else if(parseInt(document.getElementById('totalCount').value) >= parseInt(document.getElementById('current_Reading').value)){
                        alert("Error In Reading Must be Larger than " +  document.getElementById('totalCount').value);
                        this.document.ISSUE_FORM.current_Reading.focus();
                    }
                    else{
                    document.ISSUE_FORM.submit();  
                    }
                }
                else{
                    document.ISSUE_FORM.submit();  
                }
                
            }
        }
        
        function reloadPage(){   
        
            document.ISSUE_FORM.action = "<%=context%>/ScheduleServlet?op=no&source=page";
            document.ISSUE_FORM.submit();
        }
        
        function compareDate(date1,date2){
            return Date.parse(date1) <= Date.parse(date2);
        }

         function hideTip() {
          if ( typeof Tooltip == "undefined" || !Tooltip.ready ) return;
          Tooltip.hide();
        }

         function IsNumeric(id)
    {
        var ValidChars = "0123456789";
        var IsNumber=true;
        var Char;
        var valMinute;
        var valHour;
        sText=document.getElementById(id).value;

        for (i = 0; i < sText.length && IsNumber == true; i++)
        {
            Char = sText.charAt(i);

            if (ValidChars.indexOf(Char) == -1)
            {
                IsNumber = false;
                alert("Time must be positive integer and more than zero");
                document.getElementById(id).value='';
                document.getElementById(id).focus();
            }
        }

        valMinute=document.getElementById('minute').value;
        if(parseInt(valMinute) > 59)
            {
                IsNumber = false;
                alert("Minutes should be not more than 59");
                document.getElementById('minute').value='';
                document.getElementById('minute').focus();
            }
        valHour=document.getElementById('hour').value;
        if(parseInt(valHour) > 23)
            {
                IsNumber = false;
                alert("Hours should be not more than 23");
                document.getElementById('hour').value='';
                document.getElementById('hour').focus();
            }
        return IsNumber;

    }



   function checkDateTime()
    {
        var count=0;

        if (document.getElementById('minute').value != null && document.getElementById('minute').value != '' && document.getElementById('minute').value !='00' && document.getElementById('minute').value !='0')
            {
            count = count+1;
        }else if(document.getElementById('hour').value != null && document.getElementById('hour').value != '' && document.getElementById('hour').value !='00' && document.getElementById('hour').value !='0')
            {
            count = count+1;
        }else if(document.getElementById('day').value != null && document.getElementById('day').value != '' && document.getElementById('day').value !='00' && document.getElementById('day').value !='0')
        {
            count = count+1;
        }
        if(count>0){
            return true;
        }else{
            return false;
        }
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
                openWindow('ReportsServlet?op=listEquipmentBySite&unitName='+res+'&formName='+formName +'&reload=ok&reloadUrl=ScheduleServlet?any=0');
            }
            function openWindow(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=400");
            }
            
    function showCounter(){
                if(document.getElementById('updateEquip').checked){
                    document.getElementById('tableReading').style.display = "block";
                    document.ISSUE_FORM.current_Reading.focus();
                }else{
                    document.getElementById('tableReading').style.display = "none";
                }
            }
    </SCRIPT>
    
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        
        <center>
            <FORM NAME="ISSUE_FORM" ID="ISSUE_FORM" METHOD="POST">
                <DIV align="left" STYLE="color:blue;">
                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                    <%
                    if(source.equalsIgnoreCase("viewImages")) {
                    %>
                    <%
                    String id=eqpWbo.getAttribute("id").toString();
                    %>
                    <button onclick="JavaScript: backToEquipment('<%=id%>');" class="button" style="width:170"> <%=backToEqp%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"></button>                    
                    <%}else{%>
                    <button onclick="JavaScript: cancelForm();" class="button" style="width:170"> <%=cancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"></button>
                    <%}%>
                    
                    
                    <%
                    if(source.equalsIgnoreCase("viewImages")) {
                    %>
                    <%
                    if (deptAL.size() > 0 && urrgencyAL.size() > 0 && tradesAL.size() > 0) {
                    %>
                    <% if(authUser.equals("all") || userId.equals("1")){ %>
                            <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                        <% } else {
                            if(branchIdForUser.equals(eqpWbo.getAttribute("site"))){
                        %>
                        <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>

                            <% } else { %>
                             &nbsp;&nbsp;
                            <% } %>
                        <% } %>
                    
                    <%
                    }
                    } else {
                    %>
                    <%
                    if (eqpsList.size() > 0 && deptAL.size() > 0 && urrgencyAL.size() > 0 && tradesAL.size() > 0) {
                    %>
                    <% if(authUser.equals("all") || userId.equals("1")){ %>
                            <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                        <% } else {
                            if(branchIdForUser.equals(eqpWbo.getAttribute("site"))){
                        %>
                        <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>

                            <% } else { %>
                             &nbsp;&nbsp;
                            <% } %>
                        <% } %>
                    
                    <%
                    }
                    %>
                    <%
                    }
                    %>
                </DIV>
                <br>
                
                <fieldset class="set" style="width:95%">
                    <legend align="center">
                        <table ALIGN="<%=align%>" dir="<%=dir%>">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6"><%=Titel%></font>
                                </td>
                            </tr>
                        </table>
                    </legend>
                    <br>
                    <%
                    if ((eqpsList.size() <= 0 || deptAL.size() <= 0 || urrgencyAL.size() <= 0 || tradesAL.size() <= 0) && !source.equalsIgnoreCase("viewImages")) {
                    %>
                        <table border="0" width="600" cellpadding="0" dir="<%=dir%>" >
                            <TR CLASS="head">
                                <TD class="td" COLSPAN="6">
                                    <CENTER><B><Font FACE="tahoma"><B><%=noData%>&nbsp;</B></Font></B></CENTER>
                                </TD>
                            </TR>
                            <TR>
                                <TD CLASS="shaded">
                                    <Font FACE="tahoma"><B>Equipments</B></Font><br>
                                </TD>
                                <TD CLASS="shaded">
                                    <Font FACE="tahoma"><B>Working Trade</B></Font><br>
                                </TD>
                                <TD CLASS="shaded">
                                    <Font FACE="tahoma"><B>Departments</B></Font><br>
                                </TD>
                                <TD CLASS="shaded">
                                    <Font FACE="tahoma"><B>Urgency Levels</B></Font><br>
                                </TD>
                            </TR>
                        </table>
                    <%
                    } else {
                    %>
                    <table border="0" ALIGN="<%=align%>" dir="<%=dir%>" width="95%">
                        <% if(authUser.equals("all")){ %>
                            &nbsp;&nbsp;
                        <% } else {
                            if(branchIdForUser.equals(eqpWbo.getAttribute("site")) || userId.equals("1") || authUser.equals("all")){
                        %>
                            &nbsp;&nbsp;
                            <% } else { %>
                            <center>
                            <tr>
                            <td colspan="4" >
                                <font color="red" size="3"><b><%=haveNotGenerate%></b></font>
                            </td>
                        </tr>
                            </center>
                            <% } %>
                        <% } %>
                        <tr>
                            <td colspan="4" bgcolor="#006699">
                                <font color="#FFFFFF" size="5"><b><%=JOReq%></b></font>
                            </td>
                        </tr>
                        
                        <tr>
                            <%
                            if(source.equalsIgnoreCase("viewImages")) {
                            %>
                            <input type="hidden" name="unitName" value="<%=eqpWbo.getAttribute("id").toString()%>">                          
                            <%}else{%>
                            <td width="30%" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=MUnit%></font></b></td>
                             <td bgcolor="#EEEEEE" STYLE="text-align:center;color:white;font-size:14px;height:40px;border-width:0px" >
                                   <input type="text" dir="ltr" onchange="javascript:inputChange();" name="unitName" ID="unitName" value="<%=equipName%>">
                                   <input type="button" name="btnSearch" id="btnSearch" style="width:70px" onclick="JavaScript:getEquipment();" value="<%=search%>">
                                   <input type="hidden" dir="ltr"  class="head"  name="unitId" ID="unitId" value="<%=unitId%>">
                             </td>
                            <%}%>                            
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=eqpSiteEntryDate%></font></b></td>
                            <td width="270" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <input id="popup_container1" name="siteEntryDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10">
                                <b><font size="3" color="black" ><%=estematedDuration%></font></b>
                            </td>
                            <td width="200" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <table ALIGN="<%=align%>" DIR="<%=dir%>">
                                    <tr>
                                        <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sMinute%></b></font></td>
                                        <td ><font color="red"><b><%=sHour%></b></font></td>
                                        <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sDay%></b></font></td>
                                    </tr>
                                    <tr>
                                        <td width="5%" style="border-right-width:1px;border-left-width:1px"><input style="width:20px;" type="text" name="minute" id="minute" maxlength="2" ONBLUR="IsNumeric(this.id);"></td>
                                        <td width="5%"><input style="width:20px;" type="text" name="hour" id="hour" maxlength="2" ONBLUR="IsNumeric(this.id);"></td>
                                        <td width="5%" style="border-right-width:1px;border-left-width:1px"><input style="width:20px;" type="text" name="day" id="day" maxlength="2" ONBLUR="IsNumeric(this.id);"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=pDesc%></font></b></td>
                            <td ALIGN="<%=align%>" colspan="3" valign="middel" style="border:0px; text-align:<%=cellAlign%>">
                                <input type="checkbox" name="desc" id="desc" onclick="javascript: openDesc(this);" onmouseover="Tip('<%=checkboxTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'Enetr Description help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()"><%=selectDesc%><br>
                                <TEXTAREA rows="3" name="issueDesc" id="issueDesc" cols="60" DISABLED ></TEXTAREA>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                &ensp;
                            </td>
                        </tr>
                        <%if(!unitId.equals("")){%>
                        <tr>
                            <td colspan="4" bgcolor="#006699" style="height:35px">
                                <input type="checkbox" name="updateEquip" id="updateEquip" checked style="width:30px" onclick="javascript:showCounter()" />
                                <font color="#FFFFFF" size="5"><b>
                                        <%=update%>
                                </b></font>
                            </td>
                        </tr>
                        <tr  align="center">
                            <td colspan="4" ALIGN="center" style="border:0px;text-align:center">
                                <div id="tableReading" style="width:100%" >
                                    <TABLE DIR="<%=dir%>" ALIGN="center" width="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" STYLE="border-right-WIDTH:1px;">
                                        <TR CLASS="head" STYLE="background-color:#4863A0">
                                            <TD CLASS="firstname" STYLE="border-top-WIDTH:1 solid black; font-size:18;font-weight:bold;height:30;color:white;text-align:center">
                                                <b>  <%=update%><br> </b>
                                            </TD>
                                            <TD CLASS="firstname" STYLE="border-top-WIDTH:1 solid black; font-size:18;font-weight:bold;color:white;text-align:center">
                                               <b>  <%=Lread%></b>
                                            </TD>
                                            <TD CLASS="firstname" STYLE="border-top-WIDTH:1 solid black; font-size:18;font-weight:bold;color:white;text-align:center">
                                               <b> <%=Date%></b>
                                            </TD>
                                            <TD CLASS="firstname" STYLE="<%=style%>; border-top-WIDTH:1 solid black; font-size:18;font-weight:bold;color:white;text-align:center">
                                                <b> <%=LastDate%></b>
                                            </TD>
                                        </TR>
                                        <%
                                        AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
                                        WebBusinessObject averageWbo = averageUnitMgr.getOnSingleKey1(unitId);
                                        String lastReadingDate;
                                        if(averageWbo != null){
                                            lastReadingDate = (String) averageWbo.getAttribute("entry_Time");
                                            Date d = Calendar.getInstance().getTime();
                                            String test = new String(lastReadingDate);
                                            int year,mon,day,actual,current,diff;
                                            Long l = new Long(test);
                                            long sl = l.longValue();
                                            actual = new Integer((String)averageWbo.getAttribute("acual_Reading")).intValue();
                                            current = new Integer((String)averageWbo.getAttribute("current_Reading")).intValue();
                                            diff = current - actual;
                                            d.setTime(sl);
                                            lastReadingDate = d.toString();
                                            year=d.getYear()+1900;
                                            mon=d.getMonth()+1;
                                            day=d.getDate();
                                            lastReadingDate = day+" / "+mon+" / "+year;
                                        %>
                                        <TR BGCOLOR="aliceblue" STYLE="width:40px" CLASS="head" ALIGN="CENTER">
                                            <TD CLASS="act_sub_heading" WIDTH="40%" STYLE="text-align:center;" ALIGN="CENTER" ROWSPAN="2">
                                                <TABLE DIR="<%=dir%>" ALIGN="center" width="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" STYLE="border-right-WIDTH:1px;">
                                                    <TR>
                                                    <TD STYLE="border:0px" ALIGN="<%=cellAlign%>">
                                                        <font color="balck" size="3" style="font-weight:bold"><%=LastEReading%></font>
                                                    </TD>
                                                    <TD STYLE="border:0px" ALIGN="<%=cellAlign%>">
                                                        <input style="width:150;" align="<%=cellAlign%>" type="text" name="current_Reading" id="current_Reading" />
                                                    </TD>
                                                    </TR>
                                                    <TR>
                                                    <TD STYLE="border:0px" ALIGN="<%=cellAlign%>">
                                                        <font color="balck" size="3" style="font-weight:bold"><%=cominte%></font>
                                                    </TD>
                                                    <TD STYLE="border:0px" ALIGN="<%=cellAlign%>">
                                                        <TEXTAREA type="TEXT" name="description" ID="description" STYLE="width:230px" ROWS="5" maxlength="255"></TEXTAREA>
                                                    </TD>
                                                    </TR>
                                                </TABLE>
                                            </TD>
                                            <TD CLASS="act_sub_heading" WIDTH="15%" STYLE="text-align:center;">
                                                <font color="black"><b>  <%=diff%></b></font>
                                            </TD>
                                            <TD CLASS="act_sub_heading" WIDTH="15%" STYLE="text-align:center;">
                                                <font color="black"><b>   <%=current%></b></font>
                                                <input type="hidden" name = "totalCount" id="total" value="<%=current%>">
                                            </TD>
                                            <TD CLASS="act_sub_heading" WIDTH="30%" STYLE="text-align:center;">
                                                    <font color="black"><b>   <%=lastReadingDate%></b></font>
                                            </TD>
                                        </TR>
                                        <%
                                        }
                                        %>
                                        <TR>
                                            <td colspan="3" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                                &ensp;
                                            </td>
                                        </TR>
                                    </TABLE>
                                </div>
                            </td>
                            
                        </tr>
                        <%}%>
                    </table>
                    
                    <!--HIdden Values!-->
                    <%
                        WebBusinessObject temp=new WebBusinessObject();
                        temp=(WebBusinessObject)urrgencyAL.get(0);
                        WebBusinessObject tradeWbo=new WebBusinessObject();
                        tradeWbo=(WebBusinessObject)tradesAL.get(0);
                        String tradeId=tradeWbo.getAttribute("tradeId").toString();
                    %>
                    <input TYPE="hidden" name="sequence" value="<%=jobOrderNumber%>">
                    <input type="hidden" name="equipName" value="<%=unitName%>">
                    <input type="hidden" name="m" value="<%=min%>">
                    <input type="hidden" name="h" value="<%=hr%>">
                    <input type="hidden" name="beginDate" value="<%=nowDate%>">
                    <input type="hidden" name="endDate" value="<%=nowDate%>">
                    <input type="hidden" name="shift" value="1">
                    <input type="hidden" name="urgencyName" value="<%=(String)temp.getAttribute("urgencyName")%>"> 
                    <input type="hidden" name="jobzise" value="<%=(String)JobZiseList.get(0)%>">
                    <input type="hidden" name="trade" value="<%=tradeId%>">
                    <input type="hidden" name="receivedby" value="1">
                    <%}%>
                    <br>
                    <DIV align="left" STYLE="color:blue;">
                        <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                        <%
                        if(source.equalsIgnoreCase("viewImages")) {
                        %>
                        <%
                        String id=eqpWbo.getAttribute("id").toString();
                        %>
                        <button onclick="JavaScript: backToEquipment('<%=id%>');" class="button" style="width:170"> <%=backToEqp%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"></button>                    
                        <%}else{%>
                        <button onclick="JavaScript: cancelForm();" class="button" style="width:170"> <%=cancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"></button>
                        <%}%>
                        
                        
                        <%
                        if(source.equalsIgnoreCase("viewImages")) {
                        %>
                        <%
                        if (deptAL.size() > 0 && urrgencyAL.size() > 0 && tradesAL.size() > 0) {
                        %>
                        <% if(authUser.equals("all") || userId.equals("1")){ %>
                            <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                        <% } else {
                            if(branchIdForUser.equals(eqpWbo.getAttribute("site"))){
                        %>
                        <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>

                            <% } else { %>
                             &nbsp;&nbsp;
                            <% } %>
                        <% } %>
                        
                        <%
                        }
                        } else {
                        %>
                        <%
                        if (eqpsList.size() > 0 && deptAL.size() > 0 && urrgencyAL.size() > 0 && tradesAL.size() > 0) {
                        %>
                        <% if(authUser.equals("all") || userId.equals("1")){ %>
                            <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                        <% } else {
                            if(branchIdForUser.equals(eqpWbo.getAttribute("site"))){
                        %>
                            <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                            <% } else { %>
                            &nbsp;&nbsp;
                            <% } %>
                        <% } %>
                        
                        <%
                        }
                        %>
                        <%
                        }
                        %>
                    </DIV>
                    <br>
                </fieldset>
                
            </FORM>
        </center>
    </BODY>
</html>