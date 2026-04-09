<%@page import="com.customization.common.CustomizeJOMgr"%>
<%@page import="javax.print.DocFlavor.STRING"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.util.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8" %>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    String status = (String) request.getAttribute("status");
    if (status == null) {
        status = "";
    }
    // temp code
    CustomizeJOMgr customizeJOMgr = CustomizeJOMgr.getInstance();
    /////////////////

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
    DepartmentMgr deptMgr = DepartmentMgr.getInstance();

    String source = (String) request.getAttribute("source");

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
    String unitName = "";

    if (eqpWbo != null) {
        unitName = (String) eqpWbo.getAttribute("unitName");
    }


    //define variables
    ArrayList eqpsList = new ArrayList();

    //set page defualts
    //get system equipments
    Vector eqpsVec = (Vector) request.getAttribute("equipments");

    if (eqpsVec != null && eqpsVec.size() > 0) {
        for (int i = 0; i < eqpsVec.size(); i++) {
            WebBusinessObject wbo = (WebBusinessObject) eqpsVec.elementAt(i);
            eqpsList.add(wbo);
        }
    }

    //define JO work size
    ArrayList JobZiseListAr = new ArrayList();
    ArrayList JobZiseListEn = new ArrayList();
    ArrayList tempp = new ArrayList();
    JobZiseListEn.add("Normal");
    JobZiseListEn.add("Major");
    
    JobZiseListAr.add("&#1593;&#1575;&#1583;&#1610;");
    JobZiseListAr.add("&#1593;&#1605;&#1585;&#1607;");

    
    //get system departments
    ArrayList deptAL = deptMgr.getCashedTableAsBusObjects();
    
    
    
    //get system urgency
    ArrayList urrgencyAL = urgencyMgr.getCashedTableAsBusObjects();

    //get unitId after reload from pupo to select Equip
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    String unitId = request.getParameter("unitName");
    String equipName = "";
    String rateType = "mustSelectEquip";

    String branchName = "-----";
    if (unitId != null) {
        currenEquip = maintainableMgr.getOnSingleKey(unitId);
        rateType = (String) currenEquip.getAttribute("rateType");
        equipName = (String) currenEquip.getAttribute("unitName");
        try {
            branchName = (String) projectMgr.getProjectsName(new String[]{(String) currenEquip.getAttribute("site")}).get(0);
        } catch (Exception E) {
        }
    } else {
        unitId = "";
    }

    // get current date
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String nowDate = sdf.format(cal.getTime());
    String nowTime = sdfTime.format(cal.getTime());
    String hr = nowTime.substring(nowTime.length() - 8, nowTime.length() - 6);
    String min = nowTime.substring(nowTime.length() - 5, nowTime.length() - 3);

    //Build time arrays
    ArrayList hoursAL = new ArrayList();
    String hour = null;
    for (int i = 0; i < 24; i++) {
        if (i <= 9) {
            hour = "0" + new Integer(i).toString();
        } else {
            hour = new Integer(i).toString();
        }

        hoursAL.add(hour);
    }

    ArrayList minutesAL = new ArrayList();
    String minute = null;
    for (int i = 0; i < 60; i++) {
        if (i <= 9) {
            minute = "0" + new Integer(i).toString();
        } else {
            minute = new Integer(i).toString();
        }
        minutesAL.add(minute);
    }

    String[] shifts = new String[4];
    //Define language setting
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String cellAlign = null;
    String lang, langCode, cancel, save, Titel, JOReq, MUnit, orderID, ReceivedBY, shift,
            checkboxTip, backToEqp, Time, calenderTip, eqpSiteEntryDate, eBDate, eEDate, pDesc,
            selectDesc, noData, trade, estematedDuration, hourStr, update, name, Lread, Date, LastDate, LastEReading, cominte;
    String sMinute, sHour, sDay, search;
    String haveNotGenerate, fStatus, automated;
    String dLocation , size;

    /* sticky form variables */
    String tOrderNum = request.getParameter("orderID");
    if (tOrderNum == null) {
        tOrderNum = "";
    }
    String tAutomatedOrderID = request.getParameter("automatedOrderID");
    if (tAutomatedOrderID == null) {
        tAutomatedOrderID = "";
    }
    String tReceivedby = request.getParameter("receivedby");
    if (tReceivedby == null) {
        tReceivedby = "";
    }
    ///////////////////////////////////////////////////////////////
    String departmentName = "";
    WebBusinessObject deptWBO = deptMgr.getOnSingleKey(tReceivedby);
    if (deptWBO != null) {
        departmentName = (String) deptWBO.getAttribute("departmentName");
    }
    ////////////////////////////////////////////////////////////////
    String tSiteEntryDate = request.getParameter("siteEntryDate");
    if (tSiteEntryDate == null) {
        tSiteEntryDate = "";
    }
    String tM = request.getParameter("m");
    if (tM == null) {
        tM = "";
    }
    String tH = request.getParameter("h");
    if (tH == null) {
        tH = "";
    }
    String tBeginDate = request.getParameter("beginDate");
    if (tBeginDate == null) {
        tBeginDate = "";
    }
    String tEndDate = request.getParameter("endDate");
    if (tEndDate == null) {
        tEndDate = "";
    }
    String tMinute = request.getParameter("minute");
    if (tMinute == null) {
        tMinute = "";
    }
    String tHour = request.getParameter("hour");
    if (tHour == null) {
        tHour = "";
    }
    String tDay = request.getParameter("day");
    if (tDay == null) {
        tDay = "";
    }
    String tDesc = request.getParameter("desc");
    if (tDesc == null) {
        tDesc = "";
    }
    String tIssueDesc = request.getParameter("issueDesc");
    if (tDesc.equals("")) {
        tIssueDesc = "";
    }
    String tCurrent_Reading = request.getParameter("current_Reading");
    if (tCurrent_Reading == null) {
        tCurrent_Reading = "";
    }
    String tDescription = request.getParameter("description");
    if (tDescription == null) {
        tDescription = "";
    }

    if (stat.equals("En")) {
        LastEReading = "Last Equipment Reading";
        name = "Equipment Name";
        Lread = "No.of Kilometers For working to date";
        Date = "Last Reading";
        LastDate = "Date For Last Reading";

        Time = "Reporting Time";
        calenderTip = "click inside text box to opn calender window";
        checkboxTip = "Check to write description now or un check to <br>write many fields of description later";
        align = "center";
        cellAlign = "left";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";

       

        cancel = "Back to main page";
        save = "Save Job Order";
        Titel = "New Regular Job Order ";
        JOReq = "Job order requirments";
        MUnit = "Equipment Name";
        ReceivedBY = "Required By";
        eqpSiteEntryDate = "Reporting Date";
        eBDate = "Expected Begin Date";
        eEDate = "Expected End Date";
        pDesc = "Complaint";
        selectDesc = "Enter Complaint";
        noData = "No Data are available for one or more of those fields:";
        backToEqp = "Back To Equipment";
        trade = "Work Order Trade";
        shift = "Shift";
        shifts[0] = "Shift 1";
        shifts[1] = "Shift 2";
        shifts[2] = "shift 3";
        shifts[3] = "Daylight";
        estematedDuration = "Expected Duration";
        hourStr = "Minutes";
        sMinute = "Minute";
        sHour = "Hour";
        sDay = "Day";
        search = "Search";
        update = "Update Counter of Equipment";
        cominte = "Note";
        haveNotGenerate = "Unauthorized user to activate the scheduling because branch of equipment is different from the user's location";
        orderID = "Job Order Number";
        fStatus = "Job Order Number Is Not Available";
        automated = "Automated";
        dLocation = "Branch";
        size ="Transaction Volume";
    } else {
        checkboxTip = "&#1575;&#1582;&#1578;&#1575;&#1585; &#1575;&#1604;&#1605;&#1585;&#1576;&#1593; &#1581;&#1578;&#1609; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1603;&#1578;&#1575;&#1576;&#1607; &#1608;&#1589;&#1601; &#1575;&#1604;&#1575;&#1606; &#1575;&#1608; &#1575;&#1578;&#1585;&#1603;&#1607; <br> &nbsp;&#1582;&#1575;&#1604;&#1610;&#1575; &#1608;&#1575;&#1590;&#1601; &#1575;&#1604;&#1593;&#1583;&#1610;&#1583; &#1605;&#1606; &#1575;&#1604;&#1608;&#1589;&#1601; &#1601;&#1610;&#1605;&#1575; &#1576;&#1593;&#1583; ";
        calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
        Time = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1573;&#1576;&#1604;&#1575;&#1594;";
        align = "center";
        cellAlign = "right";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";

     

        cancel = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1575;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        Titel = " &nbsp;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1593;&#1575;&#1583;&#1609;";
        save = " &#1578;&#1587;&#1580;&#1610;&#1604; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        JOReq = "&#1605;&#1578;&#1591;&#1604;&#1576;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        MUnit = "إسم المعدة";
        ReceivedBY = "القســـــــــــــــم";
        eqpSiteEntryDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1576;&#1604;&#1575;&#1594;";
        eBDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
        eEDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
        pDesc = "الشكوي";
        selectDesc = "أدخل شكوي";
        noData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;:";
        backToEqp = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;";
        trade = "&#1606;&#1608;&#1593; &#1575;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;";
        shift = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607;";
        shifts[0] = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 1";
        shifts[1] = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 2";
        shifts[2] = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 3";
        shifts[3] = "&#1606;&#1607;&#1575;&#1585;&#1609;";
        estematedDuration = "&#1605;&#1583;&#1607; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1607;";
        hourStr = "&#1583;&#1602;&#1600;&#1600;&#1600;&#1600;&#1610;&#1600;&#1600;&#1600;&#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1607;";
        sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
        sHour = "&#1587;&#1575;&#1593;&#1577;";
        sDay = "&#1610;&#1608;&#1605;";
        search = "&#1576;&#1581;&#1579;";
        haveNotGenerate = "&#1594;&#1610;&#1585; &#1605;&#1589;&#1585;&#1581; &#1604;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1578;&#1601;&#1593;&#1610;&#1604; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;&#1577; &#1604;&#1571;&#1606; &#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1610;&#1582;&#1578;&#1604;&#1601; &#1593;&#1606; &#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";

        update = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        cominte = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        LastEReading = "&#1571;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1607; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607;";
        Lread = "&#1575;&#1604;&#1601;&#1585;&#1602; &#1576;&#1610;&#1606; &#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1578;&#1610;&#1606; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607;";
        Date = "&#1571;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1575;&#1577; &#1604;&#1604;&#1593;&#1583;&#1575;&#1583;";
        name = " &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; ";
        LastDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1571;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;";
        orderID = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        fStatus = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1594;&#1610;&#1585; &#1605;&#1578;&#1575;&#1581;";
        automated = "&#1578;&#1604;&#1602;&#1575;&#1574;&#1609;";
        dLocation = "&#1575;&#1604;&#1601;&#1585;&#1593;";
        size="&#1581;&#1580;&#1605; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;";
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
        <TITLE>New Job Order</TITLE>
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        var dp_cal1, dp_cal2, dp_cal3;      
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('popup_container1'));
            dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('popup_container2'));
            dp_cal3  = new Epoch('epoch_popup','popup',document.getElementById('popup_container3'));
        };

        function submitForm() {
            var jobSize =  document.getElementById("Repair").value;
            if (!this.ISSUE_FORM.automatedOrderID.checked) {
                if (!validateData("req", this.ISSUE_FORM.orderID, "Please, enter job order number or check 'automated' to generate one")) {
                    this.ISSUE_FORM.orderID.focus();
                    return;
                }
            }
            if(!IsNumericInt("orderID")) {
                return false;
            }
            try{
                if(!validateData("req", document.ISSUE_FORM.unitId, "Must Select Equpmint From Search...")){
                    document.ISSUE_FORM.btnSearch.focus();
                    return false;
                }
            } catch(ex){
                alert("aaaaaaaaaaaaaa");
            }


            if(!compareDate(document.getElementById("popup_container1").value, document.getElementById("popup_container2").value)){
                alert('(Expected Begin Date) must be less than or equle to (Site Entry Date)');
            } else if(!compareDate(document.getElementById("popup_container2").value, document.getElementById("popup_container3").value)){
                alert('(Expected End Date) must be greater than or equle to (Expected Begin Date)');
            }else if (document.getElementById("desc").checked && !validateData("req", this.ISSUE_FORM.issueDesc, "Please, enter Description.")){
                this.ISSUE_FORM.issueDesc.focus();
            }else if(!checkDateTime()){
                alert("Put time to maintenance item");
                this.ISSUE_FORM.minute.focus();
            } else {
                if(document.getElementById("desc").checked){
                    document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=create&jobSize="+jobSize;
                } else {
                    document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=create&issueDesc=No Description&jobSize="+jobSize;
                }

                document.ISSUE_FORM.submit();
            }
        }
        
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

        function inputChange() {
            document.getElementById('unitId').value = "";
        }

        // to get branch for selected equipment
        function getBranchForSelectedEquipment() {
            var unitId = document.getElementById('unitId').value;

            if(unitId != "") {
                var url = "<%=context%>/ajaxServlet?op=getBranchForEquipment&unitId=" + unitId;
                if (window.XMLHttpRequest) {
                    req = new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                
                req.open("Post", url, true);
                req.onreadystatechange =  fillBranchForSelectedEquipment;
                req.send(null);
            }
        }

        function fillBranchForSelectedEquipment() {
            if (req.readyState == 4) {
                if (req.status == 200) {
                   document.getElementById("branchName").innerHTML = req.responseText;
                }
            }
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
        
        function reloadPage() {
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

        function IsNumeric(id) {
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

            valMinute = document.getElementById('minute').value;
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
        
        function getEquipment() {
            var formName = document.getElementById('ISSUE_FORM').getAttribute("name");
            var name = document.getElementById('unitName').value
            name = getASSCIChar(name);
            openWindow('SelectiveServlet?op=listEquipmentsAndViewEquipment&unitName=' + name + '&formName=' + formName);
        }

        function openWindow(url) {
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=400");
        }

        function closeOrderID(checkBox) {
            if(!checkBox.checked) {
                document.getElementById("orderID").disabled = false
            } else {
                document.getElementById("orderID").value = ""
                document.getElementById("orderID").disabled = true
            }
        }
    </SCRIPT>

    <BODY>
        <center>
            <FORM NAME="ISSUE_FORM" ID="ISSUE_FORM" METHOD="POST" action="">
                <DIV align="left" STYLE="color:blue; padding-left: 2.5%; padding-bottom: 10px">
                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                    <%
                        if (source.equalsIgnoreCase("viewImages")) {
                            String id = eqpWbo.getAttribute("id").toString();
                    %>
                    &ensp;
                    <button onclick="JavaScript: backToEquipment('<%=id%>');" class="button" style="width:170px"> <%=backToEqp%> <IMG alt=""  SRC="images/cancel.gif"></button>
                    <%} else {%>
                    &ensp;
                    <button onclick="JavaScript: cancelForm();" class="button" style="width:170px"> <%=cancel%> <IMG alt=""  SRC="images/cancel.gif"></button>
                        <%}
                            if (source.equalsIgnoreCase("viewImages")) {
                                if (deptAL.size() > 0 && urrgencyAL.size() > 0 && tradesAL.size() > 0) {
                        %>
                        <% if (authUser.equals("all") || userId.equals("1")) { %>
                    &ensp;
                    <button onclick="JavaScript:  submitForm();" class="button" style="width:170px"><%=save%><IMG alt=""  HEIGHT="15" SRC="images/save.gif"></button>
                        <% } else {
                            if (branchIdForUser.equals(eqpWbo.getAttribute("site"))) {
                        %>
                    &ensp;
                    <button onclick="JavaScript:  submitForm();" class="button" style="width:170px"><%=save%> alt="" <IMG HEIGHT="15" SRC="images/save.gif"></button>
                    <% } else { %>
                    &nbsp;&nbsp;
                    <% }
                            }
                        }
                    } else {
                        if (eqpsList.size() > 0 && deptAL.size() > 0 && urrgencyAL.size() > 0 && tradesAL.size() > 0) {
                    %>
                    <% if (authUser.equals("all") || userId.equals("1")) {%>
                    &ensp;
                    <button onclick="JavaScript:  submitForm();" class="button" style="width:170px"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                        <% } else {
                            if (branchIdForUser.equals(eqpWbo.getAttribute("site"))) {
                        %>
                    &ensp;
                    <button onclick="JavaScript:  submitForm();" class="button" style="width:170px"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                    <% } else {%>
                    &nbsp;&nbsp;
                    <% }
                                }
                            }
                        }
                    %>
                </DIV>
                <FIELDSET class="set" style="border-color: #006699; width: 95%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='#F3D596' SIZE="5"><%=Titel%></FONT>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <%
                        if (status != null) {
                            if (status.equalsIgnoreCase("duplicateOrderNumber")) {
                    %>
                    <TABLE class="blueBorder" align="<%=align%>" dir="<%=dir%>" width="50%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD class="blueHeaderTD blueBorder" style="text-align: center;background-color: #D7D7D7">
                                <font color="red"><%=fStatus%></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <%}
                        }
                        if ((eqpsList.size() <= 0 || deptAL.size() <= 0 || urrgencyAL.size() <= 0 || tradesAL.size() <= 0) && !source.equalsIgnoreCase("viewImages")) {
                    %>
                    <table border="0" width="600" cellpadding="0" dir="<%=dir%>" >
                        <TR CLASS="head">
                            <TD class="TD" COLSPAN="6">
                                <B><FONT FACE="tahoma"><B><%=noData%>&nbsp;</B></FONT></B>
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="shaded">
                                <FONT FACE="tahoma"><B>Equipments</B></FONT><br>
                            </TD>

                            <TD CLASS="shaded">
                                <FONT FACE="tahoma"><B>Working Trade</B></FONT><br>
                            </TD>

                            <TD CLASS="shaded">
                                <FONT FACE="tahoma"><B>Departments</B></FONT><br>
                            </TD>

                            <TD CLASS="shaded">
                                <FONT FACE="tahoma"><B>Urgency Levels</B></FONT><br>
                            </TD>
                        </TR>
                    </table>
                    <% } else { %>
                    <table border="0" ALIGN="<%=align%>" dir="<%=dir%>" width="95%">
                        <% if (authUser.equals("all")) {%>
                        &nbsp;&nbsp;
                        <% } else {
                            if (branchIdForUser.equals(eqpWbo.getAttribute("site")) || userId.equals("1") || authUser.equals("all")) {
                        %>
                        &nbsp;&nbsp;
                        <% } else {%>
                        <center>
                            <TR>
                                <TD colspan="4" >
                                    <font color="red" size="3"><b><%=haveNotGenerate%></b></font>
                                </TD>
                            </TR>
                        </center>
                        <% } } %>
                        <TR>
                            <TD class="backgroundHeader" style="height: 35px; border-color: #3b5998; border-width: 1px" colspan="4">
                                <font color="black" size="4"><b><%=JOReq%></b></font>
                            </TD>
                        </TR>
                        <TR>
                            <TD width="30%" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=orderID%></font></b></TD>
                            <TD bgcolor="#EEEEEE" ALIGN="<%=align%>" STYLE="<%=style%>;color:white;font-size:14;height:40;border-width:0px;width: 33%;" >
                                <input type="text" name="orderID" ID="orderID" <%if (tAutomatedOrderID.equals("")) {%> value="<%=tOrderNum%>" <%} else {%> disabled <%}%>>
                                <input type="checkbox" name="automatedOrderID" id="automatedOrderID" <%if (!tAutomatedOrderID.equals("")) {%> checked <%}%> onclick="javascript: closeOrderID(this);" ><b><font size="3" color="black"> <%=automated%></font></b>
                            </TD>

                            <TD width="20%" bgcolor="white" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; border-bottom-width: 0; border-top-width: 0; padding-<%=cellAlign%>:10"></TD>
                            <TD bgcolor="#E6E6FA" ALIGN="<%=align%>" STYLE="<%=style%>; padding-<%=cellAlign%>: 5px; color:white;font-size:14px;height:40px; border-color: #3b5998; border-width: 1px;width: 33%;" >
                                <b><font size="3" color="black"><%=dLocation%> : <font size="2"><b id="branchName" style="color: blue"><%=branchName%></b></font></font></b>
                            </TD>
                        </TR>
                        <TR>
                        <% if (source.equalsIgnoreCase("viewImages")) { %>
                        <input type="hidden" name="unitId" ID="unitId" value="<%=eqpWbo.getAttribute("id").toString()%>">
                        <% } else { %>
                        <TD width="30%" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=MUnit%></font></b></TD>
                        <TD bgcolor="#EEEEEE" STYLE="<%=style%>;color:white;font-size:14;height:40;border-width:0px" >
                            <input type="text" dir="ltr" onchange="javascript:inputChange();" onblur="javascript: getBranchForSelectedEquipment();" name="unitName" ID="unitName" value="<%=equipName%>">
                            <input type="button" name="btnSearch" id="btnSearch" style="width:70px" onclick="JavaScript:getEquipment();" value="<%=search%>">
                            <input type="hidden" dir="ltr"  class="head"  name="unitId" ID="unitId" value="<%=unitId%>">
                        </TD>
                         <% } %>
                        </TR>
                        <TR>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=ReceivedBY%></font></b></TD>
                            <TD width="200" ALIGN="<%=align%>" colspan="3" style="border:0px">
                                <SELECT name="receivedby" style="width:230px">
                                    <sw:WBOOptionList wboList='<%=deptAL%>' displayAttribute="departmentName" valueAttribute="departmentID" scrollTo="<%=departmentName%>" />
                                </SELECT>
                            </TD>
                        </TR>
                        <%
                            WebBusinessObject temp = new WebBusinessObject();
                            temp = (WebBusinessObject) urrgencyAL.get(0);

                        %>
                        <input type="hidden" name="urgencyName" id="urgencyName" value="<%=(String) temp.getAttribute("urgencyName")%>">
                        
                        <%if (customizeJOMgr.getCustomization("Trade").display()) {%>
                        <TR>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10">
                                <b><font size="3" color="black"><%=trade%></font></b></TD>
                            <TD width="200" ALIGN="<%=align%>" colspan="3" style="border:0px">
                                <%
                                    WebBusinessObject tradeWbo = new WebBusinessObject();
                                    tradeWbo = (WebBusinessObject) tradesAL.get(0);
                                    String tradeId = tradeWbo.getAttribute("tradeId").toString();
                                    String tradeName = tradeWbo.getAttribute("tradeName").toString();
                                %>
                                <input type="hidden" name="trade" id="trade" value="<%=tradeId%>">
                                <input type="text" style="width:230px" name="tradeName" id="tradeName" value="<%=tradeName%>" readonly>
                            </TD>
                        </TR>
                        <%} else {%>
                        <input type="hidden" name="trade" id="trade" value="<%=customizeJOMgr.getCustomization("Trade").getDefaultValue()%>">
                        <%}%>
                        <%if (customizeJOMgr.getCustomization("Shift").display()) {%>
                        <TR>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10">
                                <b><font size="3" color="black"><%=shift%></font></b>
                            </TD>
                            <TD width="200" ALIGN="<%=align%>" colspan="3" style="border:0px">
                                <SELECT name="shift" ID="shift" style="width:230px">
                                    <option value="1"><%=shifts[0]%>
                                    <option value="2"><%=shifts[1]%>
                                    <option value="3"><%=shifts[2]%>
                                    <option value="4"><%=shifts[3]%>
                                </SELECT>
                            </TD>
                        </TR>
                        <%} else {%>
                        <input type="hidden" name="shift" ID="shift" value="<%=customizeJOMgr.getCustomization("Shift").getDefaultValue()%>"/>
                        <%}%>
                        <TR>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=eqpSiteEntryDate%></font></b></TD>
                            <TD width="270" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <input id="popup_container1" name="siteEntryDate" type="text" <%if (!tSiteEntryDate.equals("")) {%> value="<%=tSiteEntryDate%>" <%} else {%> value="<%=nowDate%>" <%}%>><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                            </TD>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=Time%></font></b></TD>
                            <TD width="200" ALIGN="<%=align%>" style="border:0px" style="text-align:<%=cellAlign%>">
                                <select name="m">
                                    <%if (!tM.equals("")) {%>
                                    <sw:OptionList optionList='<%=minutesAL%>' scrollTo="<%=tM%>" />
                                    <%} else {%>
                                    <sw:OptionList optionList='<%=minutesAL%>' scrollTo = "<%=min%>" />
                                    <%}%>
                                </select>
                                <font color="red"><b>:</b></font>
                                <select name="h">
                                    <%if (!tH.equals("")) {%>
                                    <sw:OptionList optionList='<%=hoursAL%>' scrollTo="<%=tH%>" />
                                    <%} else {%>
                                    <sw:OptionList optionList='<%=hoursAL%>' scrollTo = "<%=hr%>" />
                                    <%}%>
                                </select>
                                <font color="red"> <b>  HH : MM </b></font>
                            </TD>
                        </TR>

                        <TR>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=eBDate%></font></b></TD>
                            <TD width="200" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <input id="popup_container2" name="beginDate" type="text" <%if (!tBeginDate.equals("")) {%> value="<%=tBeginDate%>" <%} else {%> value="<%=nowDate%>" <%}%> ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                            </TD>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black" ><%=eEDate%></font></b></TD>
                            <TD width="200" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <input id="popup_container3" name="endDate" type="text" <%if (!tEndDate.equals("")) {%> value="<%=tEndDate%>" <%} else {%> value="<%=nowDate%>" <%}%> ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()">
                            </TD>
                        </TR>

                        <TR>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10">
                                <b><font size="3" color="black" ><%=estematedDuration%></font></b>
                            </TD>
                            <TD width="200" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                <table ALIGN="<%=align%>" DIR="<%=dir%>">
                                    <TR>
                                        <TD style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sMinute%></b></font></TD>
                                        <TD ><font color="red"><b><%=sHour%></b></font></TD>
                                        <TD style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sDay%></b></font></TD>
                                    </TR>
                                    <TR>
                                        <TD width="5%" style="border-right-width:1px;border-left-width:1px"><input style="width:20px;" type="text" name="minute" id="minute" maxlength="2" value="<%=tMinute%>" ONBLUR="IsNumeric(this.id);"></TD>
                                        <TD width="5%"><input style="width:20px;" type="text" name="hour" id="hour" maxlength="2" value="<%=tHour%>" ONBLUR="IsNumeric(this.id);"></TD>
                                        <TD width="5%" style="border-right-width:1px;border-left-width:1px"><input style="width:20px;" type="text" name="day" id="day" maxlength="2" value="<%=tDay%>" ONBLUR="IsNumeric(this.id);"></TD>
                                    </TR>

                                </table>
                                        <!--input id="duration" name="duration" type="text">&nbsp;&nbsp;&nbsp;<B><font size="2" color="red"><%=hourStr%></font></b-->
                            </TD>

                        </TR>

                        <TR>
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=pDesc%></font></b></TD>
                            <TD ALIGN="<%=align%>" colspan="3" valign="middel" style="border:0px; text-align:<%=cellAlign%>">
                                <input type="checkbox" name="desc" id="desc" onclick="javascript: openDesc(this);" <%if (!tDesc.equals("")) {%> checked <%}%> onmouseover="Tip('<%=checkboxTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'Enetr Description help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()"><%=selectDesc%><br>
                                <TEXTAREA rows="3" name="issueDesc" id="issueDesc" cols="60" <%if (tDesc.equals("")) {%> disabled <%}%> ><%=tIssueDesc%></TEXTAREA>
                            </TD>
                        </TR>
                        
                        
                        
                        
                        
                        <TR>
                            
                            <TD width="250" class="backgroundTable" ALIGN="<%=align%>" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=size%></font></b></TD>
                           <TD width="200" ALIGN="<%=align%>" colspan="3" style="border:0px" value="<%=lang%>">
                                <SELECT name="Repair" style="width:230px">
                                   <%
                                  
                                   
                            if(lang.equalsIgnoreCase("En"))
                            {
                                   tempp = JobZiseListEn;                                                                            
                            }  else{
                                       
                                       tempp=JobZiseListAr;
                                   }
                            
                                    for(int i =0 ; i < tempp.size() ; i++){
                                      
                                   %>
                                   <option value="<%=JobZiseListEn.get(i)%>"><%=tempp.get(i)%></option>
                                     
                                   <%}%>
                                   
                                </SELECT>
                                    
                            </TD>
                        </TR>
                        
                        
                        
                        
                        <TR>
                            <TD colspan="4" ALIGN="<%=align%>" style="border:0px; text-align:<%=cellAlign%>">
                                &ensp;
                            </TD>
                        </TR>
                    </table>

                    <!--HIdden Values!-->
                    <INPUT TYPE="hidden" name="sequence" value="<%=jobOrderNumber%>">
                    <input type="hidden" name="equipName" value="<%=unitName%>">
                    <%}%>
                    <br>
                    <DIV align="left" STYLE="color:blue; padding-left: 5px">
                        <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                        <%
                            if (source.equalsIgnoreCase("viewImages")) {

                                String id = eqpWbo.getAttribute("id").toString();
                        %>
                        &ensp;
                        <button onclick="JavaScript: backToEquipment('<%=id%>');" class="button" style="width:170"> <%=backToEqp%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"></button>
                            <%} else {%>
                        &ensp;
                        <button onclick="JavaScript: cancelForm();" class="button" style="width:170"> <%=cancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"></button>
                            <% }
                                if (source.equalsIgnoreCase("viewImages")) {
                                    if (deptAL.size() > 0 && urrgencyAL.size() > 0 && tradesAL.size() > 0) {
                            %>
                            <% if (authUser.equals("all") || userId.equals("1")) {%>
                        &ensp;
                        <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                            <% } else {
                                if (branchIdForUser.equals(eqpWbo.getAttribute("site"))) {
                            %>
                        &ensp;
                        <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                        <% } else {%>
                        &nbsp;&nbsp;
                        <% }
                                }
                            }
                        } else {
                            if (eqpsList.size() > 0 && deptAL.size() > 0 && urrgencyAL.size() > 0 && tradesAL.size() > 0) {
                        %>
                        <% if (authUser.equals("all") || userId.equals("1")) {%>
                        &ensp;
                        <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                            <% } else {
                                if (branchIdForUser.equals(eqpWbo.getAttribute("site"))) {
                            %>
                        &ensp;
                        <button onclick="JavaScript:  submitForm();" class="button" style="width:170"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                            <% } else {%>
                        &nbsp;&nbsp;
                        <% }
                                    }
                                }
                            }
                        %>
                    </DIV>
                    <br>
                </FIELDSET>
            </FORM>
        </center>
    </BODY>
</html>