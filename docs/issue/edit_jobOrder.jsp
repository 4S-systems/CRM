
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.util.*,com.silkworm.jsptags.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
MaintenanceMgr maintenanceMgr = MaintenanceMgr.getInstance();
IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
IssueMgr issueMgr = IssueMgr.getInstance();
EmployeeMgr empMgr = EmployeeMgr.getInstance();
FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
DepartmentMgr deptMgr = DepartmentMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
DriversHistoryMgr driversMgr = DriversHistoryMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
EquipmentStatusMgr equipmentStatusMgr =EquipmentStatusMgr.getInstance();
DateAndTimeControl dateAndTime = new DateAndTimeControl();

String issueId=(String)request.getAttribute("issueId");
String issueTitle=(String)request.getAttribute("issueTitle");
String filterName=(String)request.getAttribute("filterName");
String filterValue=(String)request.getAttribute("filterValue");
String issueState=(String)request.getAttribute("issueState");

WebBusinessObject myIssue = (WebBusinessObject) request.getAttribute("myIssue");

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
//WebBusinessObject eqpWbo = (WebBusinessObject) request.getAttribute("currentEqp");
//WebBusinessObject workingEmpWbo = (WebBusinessObject) request.getAttribute("currentEmp");
//String jobOrderNumber = request.getAttribute("JONo").toString();

//String unitName=eqpWbo.getAttribute("unitName").toString();

//define variables
ArrayList eqpsList = new ArrayList();

//set page defualts
//get system equipments
//Vector eqpsVec = (Vector) request.getAttribute("equipments");

//if(eqpsVec != null && eqpsVec.size()>0){
  //  for (int i = 0; i < eqpsVec.size(); i++) {
  //      WebBusinessObject wbo = (WebBusinessObject) eqpsVec.elementAt(i);
  //      eqpsList.add(wbo);
  //  }
//}

//define JO work size
ArrayList JobZiseList = new ArrayList();

//get system departments
ArrayList deptAL = deptMgr.getCashedTableAsBusObjects();

//get system urgency
ArrayList urrgencyAL = urgencyMgr.getCashedTableAsBusObjects();

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
String lang, langCode, cancel, save, Titel, JODetails, JONumber, workerEmp, eqpName, JOReq, MUnit, ReceivedBY,shift,
        WorkType,checkboxTip,backToEqp,Time,calenderTip,uLevel, JobZise, eqpSiteEntryDate, eBDate, eEDate, pDesc,
        selectDesc, noData,equipStatus,equipStatusMSG,trade,estematedDuration,hourStr;
String sMinute,sHour,sDay;
if (stat.equals("En")) {
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
    JODetails = "Job Order Details";
    JONumber = "Job Order Number";
    workerEmp = "Responsible Employee";
    eqpName = "For equipment";
    JOReq = "Job order requirments";
    MUnit = "Equipment Name";
    ReceivedBY = "Required By";
    WorkType = "Working trade";
    uLevel = "Urgency Level";
    JobZise = "Working size";
    eqpSiteEntryDate = "Reporting Date";
    eBDate = "Expected Begin Date";
    eEDate = "Expected End Date";
    pDesc = "Problem Description";
    selectDesc = "Describe the problem";
    noData = "No Data are available for one or more of those fields:";
    backToEqp="Back To Equipment";
    equipStatus="Equipment Status";
    equipStatusMSG="Machine out of service";
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
    JODetails = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    JONumber = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    workerEmp = "&#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1572;&#1604; &#1593;&#1606; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577;";
    eqpName = "&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577;";
    JOReq = "&#1605;&#1578;&#1591;&#1604;&#1576;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    MUnit = "&#1575;&#1604;&#1608;&#1581;&#1583;&#1607; &#1575;&#1604;&#1605;&#1589;&#1575;&#1606;&#1607;";
    ReceivedBY = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1591;&#1575;&#1604;&#1576;&#1577;";
    WorkType ="&#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1601;&#1606;&#1610; &#1604;&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    uLevel = "&#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1576;&#1607;";
    JobZise = "&#1581;&#1580;&#1605; &#1575;&#1604;&#1593;&#1605;&#1604;";
    eqpSiteEntryDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1576;&#1604;&#1575;&#1594;";
    eBDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    eEDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    pDesc = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1607;";
    selectDesc = "&#1575;&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;";
    noData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;:";
    backToEqp="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;";
    equipStatus = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577;";
    equipStatusMSG="&#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1577;";
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
}
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
           var trade= document.getElementById("trade").value;
           var shift= document.getElementById("shift").value;
          // var duration = document.getElementById("duration").value;
           var issueDesc = document.getElementById("issueDesc").value;
           // if(!compareDate(document.getElementById("popup_container1").value,document.getElementById("popup_container2").value)){
             //   alert('(Expected Begin Date) must be less than or equle to (Site Entry Date)');
           // } else if(!compareDate(document.getElementById("popup_container2").value,document.getElementById("popup_container3").value)){
             //   alert('(Expected End Date) must be greater than or equle to (Expected Begin Date)');
           // }
            if(!checkDateTime()){
                    alert("Put time to maintenance item");
                    this.ISSUE_FORM.minute.focus();
            }else if (document.getElementById("desc").checked && !validateData("req", this.ISSUE_FORM.issueDesc, "Please, enter Description.")){
                this.ISSUE_FORM.issueDesc.focus();
            }else{
                 if(document.getElementById("desc").checked){
                    document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=updateEdittingJobOrder&trade="+trade+"&shift="+shift+"&issueDesc="+issueDesc+"&issueId=<%=(String) myIssue.getAttribute("id")%>&issueTitle=<%=(String) myIssue.getAttribute("issueTitle")%>&issueState=<%=(String) myIssue.getAttribute("currentStatus")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>";
                 } else {
                    document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=updateEdittingJobOrder&issueDesc=No Description&trade="+trade+"&shift="+shift+"&issueId=<%=(String) myIssue.getAttribute("id")%>&issueTitle=<%=(String) myIssue.getAttribute("issueTitle")%>&issueState=<%=(String) myIssue.getAttribute("currentStatus")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>";
                 }
                
                document.ISSUE_FORM.submit();  
            }
        }
        
        function reloadPage(){   
        
            document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=updateJobOrder&issueId=<%=(String) myIssue.getAttribute("id")%>&issueTitle=<%=(String) myIssue.getAttribute("issueTitle")%>&issueState=<%=(String) myIssue.getAttribute("currentStatus")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>";
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
    </SCRIPT>
    
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        
        <center>
            <FORM NAME="ISSUE_FORM" METHOD="POST">
                <DIV align="left" STYLE="color:blue;">
                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                      <button onclick="JavaScript: cancelForm();" class="button" style="width:170"> <%=cancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"></button>
                      <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                </DIV>
                <br>
                
                <fieldset class="set">
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
                                       
                    <table border="0" ALIGN="<%=align%>" dir="<%=dir%>" width="800">
                        <tr>
                            <td colspan="4" bgcolor="#006699">
                                <font color="#FFFFFF" size="5"><b><%=JODetails%></b></font>
                            </td>
                        </tr>

                        <%--
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=ReceivedBY%></font></b></td>
                            <td width="200" ALIGN="<%=align%>" colspan="3" style="border:0px">
                                <SELECT name="receivedby" style="width:230px">
                                    <sw:WBOOptionList wboList='<%=deptAL%>' displayAttribute="departmentName" valueAttribute="departmentID"/>
                                </SELECT>
                            </td>
                        </tr>
                        --%>
                        <%--
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=uLevel%></font></b></td>
                            <td width="200" ALIGN="<%=align%>" colspan="3" style="border:0px">
                                <SELECT name="urgencyName" style="width:230px">
                                    <sw:WBOOptionList wboList='<%=urrgencyAL%>' displayAttribute="urgencyName" valueAttribute="urgencyName"/>
                                </SELECT>
                            </td>
                        </tr>
                        --%>
                        <%
                        WebBusinessObject temp=new WebBusinessObject();
                        temp=(WebBusinessObject)urrgencyAL.get(0);
                                
                        %>
                        <input type="hidden" name="urgencyName" id="urgencyName" value="<%=(String)temp.getAttribute("urgencyName")%>"> 
                        <input type="hidden" name="jobzise" ID="jobzise" value="<%=(String)JobZiseList.get(0)%>">
                        <%--
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=JobZise%></font></b></td>
                            <td width="200" ALIGN="<%=align%>" colspan="3" style="border:0px">
                                <select name="jobzise" ID="jobzise" style="width:230px">
                                    <sw:OptionList optionList='<%=JobZiseList%>' scrollTo = ""/>
                                </SELECT>
                            </td>
                        </tr>
                        --%>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10">
                            <b><font size="3" color="black"><%=trade%></font></b></td>
                            <td width="200" ALIGN="<%=align%>" colspan="3" style="border:0px">
                                <!--select name="trade" ID="trade" style="width:230px"-->
                                    <%
                                    WebBusinessObject tradeWbo=new WebBusinessObject();
                                   // for(int c=0;c<tradesAL.size();c++){
                                        tradeWbo=(WebBusinessObject)tradesAL.get(0);
                                        String tradeId=tradeWbo.getAttribute("tradeId").toString();
                                        String tradeName=tradeWbo.getAttribute("tradeName").toString();
                                    %>
                                    <input type="hidden" name="trade" id="trade" value="<%=tradeId%>">
                                    <input style="width:230px" type="text" readonly name="tradeName" id="tradeName" value="<%=tradeName%>">
                                    
                                    <%//}%>
                                    
                                <!--/SELECT-->
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10">
                                <b><font size="3" color="black"><%=shift%></font></b>
                            </td>
                            <td width="200" ALIGN="<%=align%>" colspan="3" style="border:0px">
                                <select name="shift" ID="shift" style="width:230px">
                                    <option value="1"><%=shifts[0]%>
                                    <option value="2"><%=shifts[1]%>
                                    <option value="3"><%=shifts[2]%>
                                    <option value="4"><%=shifts[3]%>
                                </SELECT>
                            </td>
                        </tr>
                        
                        <%--
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=eqpSiteEntryDate%></font></b></td>
                            <td width="270" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <input id="popup_container1" name="siteEntryDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()"> 
                            </td>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=Time%></font></b></td>
                            <td width="200" ALIGN="<%=align%>" style="border:0px" style="text-align:<%=cellAlign%>">
                                <select name="m">
                                    <sw:OptionList optionList='<%=minutesAL%>' scrollTo = "<%=min%>"/>
                                </select>
                                <font color="red"><b>:</b></font>
                                <select name="h">
                                    <sw:OptionList optionList='<%=hoursAL%>' scrollTo = "<%=hr%>"/>
                                </select>
                                <font color="red"> <b>  HH : MM </b></font>
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=eBDate%></font></b></td>
                            <td width="200" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <input id="popup_container2" name="beginDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()"> 
                            </td>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black" ><%=eEDate%></font></b></td>
                            <td width="200" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <input id="popup_container3" name="endDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                            </td>
                        </tr>
                         --%>
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
                                <!--input id="duration" name="duration" type="text">&nbsp;&nbsp;&nbsp;<B><font size="2" color="red"><%=hourStr%></font></b>
                            
                            <td colspan="2" style="border:0px;">&nbsp;</td-->
                        </td>
                        </tr>
                       
                        <tr>
                            <td width="250" bgcolor="#CCCCCC" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=pDesc%></font></b></td>
                            <td ALIGN="<%=align%>" colspan="3" valign="middel" style="border:0px; text-align:<%=cellAlign%>">
                                <input type="checkbox" name="desc" id="desc" onclick="javascript: openDesc(this);" onmouseover="Tip('<%=checkboxTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'Enetr Description help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()"><%=selectDesc%><br>
                                <TEXTAREA rows="3" name="issueDesc" id="issueDesc" cols="60" DISABLED ></TEXTAREA>
                            </td>
                        </tr>

                    </table>
                    
                    <!--HIdden Values
                    <INPUT TYPE="hidden" name="sequence" value="<%//=jobOrderNumber%>">
                    <input type="hidden" name="equipName" value="<%//=unitName%>">
                    !-->
                    
                </fieldset>
                
            </FORM>
        </center>
    </BODY>
</html>