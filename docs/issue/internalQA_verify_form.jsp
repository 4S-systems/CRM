<%@ page contentType="text/html; charset=utf-8" %>
<%@page import="com.SpareParts.db_access.UsedSparePartsMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.business_objects.*,com.tracker.common.*, java.util.*"%>
<%@ page import="com.tracker.common.AppConstants,com.maintenance.db_access.*,java.text.DecimalFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.contractor.db_access.MaintainableMgr,com.silkworm.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    UserMgr userMgr = UserMgr.getInstance();
    FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    MaintenanceItemMgr itemMgr = MaintenanceItemMgr.getInstance();
    ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
    Calendar c = Calendar.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();

    String context = metaMgr.getContext();
    int used =0;    
    int returned=0;
    boolean draw = false;
    String issueId = (String) request.getAttribute("issueId");
    String issueTitle = (String) request.getAttribute("issueTitle");
    String direction = (String) request.getAttribute(AppConstants.DIRECTION);
    String scheduleID = (String) request.getAttribute("scheduleID");

    WebBusinessObject wbounitSchedule = unitScheduleMgr.getOnSingleKey(scheduleID);
    WebBusinessObject webIssue = issueMgr.getOnSingleKey(issueId);
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(webIssue.getAttribute("unitId").toString());
    Vector items = (Vector) request.getAttribute("items");
    Vector quantifiedItems = (Vector) request.getAttribute("quantifiedItems");

    String expectedEDate = (String) webIssue.getAttribute("expectedEndDate");
    expectedEDate = expectedEDate.replaceAll("-", "/");

//StatusProjectList
    String expectedEDatef = (String) request.getAttribute("actualBeginDate");
    String filterName = (String) request.getAttribute("actualBeginDate");
    String filterValue = (String) request.getAttribute("filterValue");
    String projectname = (String) request.getAttribute("projectName");
    WebBusinessObject wboItem = null;
    WebBusinessObject wbo = null;
    WebBusinessObject wboIssue = IssueMgr.getInstance().getOnSingleKey(issueId);
    WebBusinessObject wboFcode = failureCodeMgr.getOnSingleKey(wboIssue.getAttribute("failureCode").toString());

    String failureCode = wboFcode.getAttribute("title").toString();

    int indx1, indx2;
    indx1 = indx2 = 10;
    for (int i = 0; i < filterValue.length(); i++) {
        char ch = filterValue.charAt(i);
        if (ch == '>') {
            indx1 = i;
            System.out.println(i + " lolo");
        }

        if (ch == '<') {
            indx2 = i;
            System.out.println(i + " lolo");
            String temp = filterValue.substring(indx1 + 1, indx2);
            projectname = temp;
        }
    }

    ArrayList hoursJob = new ArrayList();
    String hour = null;
    for (float i = 0; i < 60.5; i += 0.5) {
        hour = new Float(i).toString();
        hoursJob.add(hour);
    }
    hoursJob.remove(0);

    ArrayList hoursAL = new ArrayList();
//String hour = null;
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
    String attName = null;
    String attValue = null;
    String addToURL = "";

// get current date and Time
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String jDateFormat = loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat tempsdfTime = new SimpleDateFormat("MMMM dd, yyyy HH:mm:ss a");
    String nowDate = sdf.format(cal.getTime());
    String nowTime = sdfTime.format(cal.getTime());
    String hr = nowTime.substring(nowTime.length() - 8, nowTime.length() - 6);
    String min = nowTime.substring(nowTime.length() - 5, nowTime.length() - 3);


    Date parsedDate = new Date();
    String lastDateM = "";
    try {
        parsedDate = tempsdfTime.parse(expectedEDatef);
        sdfTime.format(parsedDate);
        java.sql.Timestamp timestamp = new java.sql.Timestamp(parsedDate.getTime());
        lastDateM = String.valueOf(timestamp.getTime());
    } catch (Exception E) {
        lastDateM = "0";
    }
  
    if (request.getAttribute("case") != null) {
        addToURL = "&title=" + (String) request.getAttribute("title") + "&unitName=" + (String) request.getAttribute("unitName");
        filterName = "StatusProjctListTitle";
    }

    String CancelForm = "op=" + filterName + "&filterValue=" + filterValue + "&projectName=" + projectname;
    CancelForm += addToURL;
    CancelForm = CancelForm.replace(' ', '+');

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;

    String align = null;
    String dir = null;
    String style = null;
    String endTask, lang, cancel, langCode, BackToList, save, AllRequired, title, Fcode, CauseDes, TakenAction,
            prevention, actualTime, cellAlign, JONumber, Time;
    String search, AddCode, add, AddName, addNew, tCost, code, name, price, count, cost, Mynote, del, scr, sOnLine,
            sHour, actualDate, updateParts, eqpName, calenderTip, eqpStatus, working, outOfWorking, explainReasons;
    String addTaskNote, addSpareParts;
    String sMinutes, sHours, sDays;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        Time = "Time";
        calenderTip = "click inside text box to opn calender window";

        style = "text-align:left";
        add = "   Add   ";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        endTask = "Job order Clouser";
        BackToList = "Back to list";
        save = " Save ";
        AllRequired = "(*) All data must be filled";
        title = "Schedule title";
        Fcode = "Failure code";
        CauseDes = "Cause description";
        TakenAction = "Action taken";
        prevention = "Prevention should be taken ";
        search = "Auto search";
        actualTime = "Actual finish time";
        AddCode = "Add using Part Code";
        AddName = "Add using Part Name";
        addNew = "Add new part";
        tCost = "Total cost  ";
        code = "Code";
        name = "Name";
        price = "Price";
        count = "countity";
        cost = "Total Price";
        Mynote = "Note";
        del = "Delete";
        scr = "images/arrow1.swf";
        sOnLine = "Equipment Status : On Line?";
        sHour = "Minute(s)";
        actualDate = "Actual Finish Date";
        updateParts = "Add / Update Schedule Spare Parts";
        eqpName = "For equipment";
        cellAlign = "left";
        JONumber = "Job Order Number";

        eqpStatus = "Equipment Status";
        working = "Working";
        outOfWorking = "Out Of Working";
        explainReasons = "Write How you solved the problem";
        addTaskNote = "You must add maintenance item";
        sMinutes = "Minute";
        sHours = "Hour";
        sDays = "Day";
        addSpareParts = "You must add spare parts";
    } else {
        add = "  &#1571;&#1590;&#1601;  ";
        align = "center";
        Time = "&#1608;&#1602;&#1578; &#1573;&#1606;&#1607;&#1575;&#1569; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";

        dir = "RTL";
        calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";

        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cellAlign = "right";
        endTask = "&#1573;&#1606;&#1607;&#1575;&#1569; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";

        BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; ";
        AllRequired = " &#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
        title = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        Fcode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604; ";
        CauseDes = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1587;&#1576;&#1576;";
        TakenAction = "&#1591;&#1585;&#1610;&#1602;&#1607; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;";
        prevention = "&#1603;&#1610;&#1601;&#1610;&#1607; &#1575;&#1604;&#1581;&#1605;&#1575;&#1610;&#1607; ";
        actualTime = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
        search = "&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
        AddCode = "&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
        AddName = "&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
        addNew = "  &#1571;&#1590;&#1601; &#1602;&#1591;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1607; ";
        tCost = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;   ";
        code = "&#1575;&#1604;&#1603;&#1608;&#1583;";
        name = "&#1575;&#1604;&#1573;&#1587;&#1605;";
        price = "&#1575;&#1604;&#1587;&#1593;&#1585; ";
        count = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
        cost = " &#1575;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
        Mynote = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        del = "&#1581;&#1584;&#1601; ";
        scr = "images/arrow2.swf";
        sOnLine = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; : &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1577; &#1567;";
        sHour = "&#1576;&#1575;&#1604;&#1600;&#1600;&#1583;&#1602;&#1600;&#1600;&#1610;&#1600;&#1602;&#1600;&#1600;&#1607;";
        actualDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1575;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
        updateParts = "&#1575;&#1590;&#1575;&#1601;&#1577; / &#1578;&#1593;&#1583;&#1610;&#1604; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
        eqpName = "&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577;";
        JONumber = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";

        eqpStatus = "&#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;";
        working = "&#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
        outOfWorking = "&#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
        explainReasons = "&#1571;&#1590;&#1601; &#1588;&#1585;&#1581; &#1603;&#1610;&#1601; &#1578;&#1593;&#1575;&#1605;&#1604;&#1578; &#1605;&#1593; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1607;";
        addTaskNote = "&#1610;&#1580;&#1576; &#1573;&#1590;&#1575;&#1601;&#1577; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1571;&#1608;&#1604;&#1575;&#1611;";
        sMinutes = "&#1583;&#1602;&#1610;&#1602;&#1577;";
        sHours = "&#1587;&#1575;&#1593;&#1577;";
        sDays = "&#1610;&#1608;&#1605;";
        addSpareParts = "&#1610;&#1580;&#1576; &#1573;&#1590;&#1575;&#1601;&#1577; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1602;&#1576;&#1604; &#1575;&#1604;&#1573;&#1594;&#1604;&#1575;&#1602;";
    }
    Vector checkTasksVec = new Vector();
    checkTasksVec = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
    String externalType = (String)request.getAttribute("externalType");
    ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
    WebBusinessObject externalWbo = externalJobMgr.getOnSingleKey("key2", issueId);

    String actualBeginDate = issueMgr.getActualBeginDateFormat(issueId);
    actualBeginDate = actualBeginDate.substring(0, 10);
    actualBeginDate = actualBeginDate.replaceAll("-", "/");
%>
<HEAD>
    <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <link rel="stylesheet" type="text/css" href="autosuggest.css"/>
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <link rel="stylesheet" type="text/css" href="css/headers.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>


</HEAD>


<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    
    var dp_cal1;      
    window.onload = function () {
        dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('actualEndDate'));
    };
          
    var count=0;

    function compareDate()
    {
        return Date.parse(document.getElementById("actualEndDate").value) >= Date.parse(document.getElementById("actualBeginDate").value) ;
    }
    function submitForm(){

        if (!compareDate()){
            if(<%=stat.equals("En")%>){
                alert('Actual End Date ('+document.getElementById('actualEndDate').value+') must be greater than Actual Begin Date (' + document.getElementById("actualBeginDate").value + ')');
            }else{
                alert('\u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0625\u063A\u0644\u0627\u0642 '+document.getElementById('actualEndDate').value+' \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A ' + document.getElementById("actualBeginDate").value);
            }
            document.getElementById('actualEndDate').focus();
            return false;
        }
        /*if(!getDateAsDateTime()){
            return;
        }else */if(document.getElementById('actionTaken').value=="") {
            alert("Plase Enetr Action taken");
            return;
        }  if(document.getElementById('actionTaken').value=="") {
            alert("Plase Enetr Action taken");
            return;
        } else if(document.getElementById('causeDescription').value=="") {
            alert("Plase Enetr Cause Description taken");
        } else if(!checkDateTime()){
            alert("Put time to maintenance item");
            this.ISSUE_FORM.minutes.focus();
            return;
        }
        var used = document.getElementById('used').value;
        var returned = document.getElementById('returned').value;
        if(parseInt(used) > parseInt(returned)){
            var value = confirm('Issue Parts Used '+ used + ' And Returned ' + returned + ' Are you sure you want to close it ?');
            if(value == true){
                document.ISSUE_FORM.action = "<%=context%>/ProgressingIssueServlet?op=SaveinternalGetQAVerifyForm&filterName=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=projectname%>";
                document.ISSUE_FORM.submit();
            }
        } else {
            document.ISSUE_FORM.action = "<%=context%>/ProgressingIssueServlet?op=SaveinternalGetQAVerifyForm&filterName=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=projectname%>";
            document.ISSUE_FORM.submit();
        }
    }
        
   
    function cancelForm()
    {    
        document.ISSUE_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.ISSUE_FORM.submit();  
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

        valMinute=document.getElementById('minutes').value;
        if(parseInt(valMinute) > 59)
        {
            IsNumber = false;
            alert("Minutes should be not more than 59");
            document.getElementById('minutes').value='';
            document.getElementById('minutes').focus();
        }
        valHour=document.getElementById('hours').value;
        if(parseInt(valHour) > 23)
        {
            IsNumber = false;
            alert("Hours should be not more than 23");
            document.getElementById('hours').value='';
            document.getElementById('hours').focus();
        }
        return IsNumber;

    }



    function checkDateTime()
    {
        var count=0;

        if (document.getElementById('minutes').value != null && document.getElementById('minutes').value != '' && document.getElementById('minutes').value !='00' && document.getElementById('minutes').value !='0')
        {
            count = count+1;
        }else if(document.getElementById('hours').value != null && document.getElementById('hours').value != '' && document.getElementById('hours').value !='00' && document.getElementById('hours').value !='0')
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
                
    function getDateAsDateTime(){
                
        var date = document.getElementById("actualEndDate").value;
        date += " 15:00:00";
        var lastDate = '<%=lastDateM%>';
        if(Number(Date.parse(date)) < Number(lastDate)){
            alert(" تارخ البدايةالفعلى  أكبر من تاريخ الانتهاء");
            
            return false;
        }else{
               return true;
        }
    }
 
</SCRIPT>
<script src='silkworm_validate.js' type='text/javascript'></script>
<script src='ChangeLang.js' type='text/javascript'></script>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css"/>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>   
    </HEAD>

    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>

    <center>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <br>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')"  class="Button">
                <button  onclick="JavaScript: cancelForm();" class="Button"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                
                
                <button  onclick="JavaScript:  submitForm();"  class="Button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
                
            </DIV>
            <br>

            <%
                if (request.getAttribute("case") != null) {
            %>
            <INPUT TYPE="HIDDEN" NAME="case" VALUE="<%=(String) request.getAttribute("case")%>">
            <INPUT TYPE="HIDDEN" NAME="title" VALUE="<%=(String) request.getAttribute("title")%>">
            <INPUT TYPE="HIDDEN" NAME="unitName" VALUE="<%=(String) request.getAttribute("unitName")%>">
            <%
                }
            %>

            <fieldset class="set">
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"> <%=endTask%> </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                
                <% if(externalType == null){
                  if (checkTasksVec.size() > 0  ) {
                    draw=true;
                        for (int i = 0; i < quantifiedItems.size(); i++) {
                            WebBusinessObject temp = (WebBusinessObject) quantifiedItems.get(i);
                            if (itemMgr.getOnSingleKey(temp.getAttribute("itemId").toString()).getAttribute("returnable").equals("1")) {
                                try {
                                    used += Integer.parseInt(temp.getAttribute("itemQuantity").toString());
                                } catch (Exception ex) {
                                }
                            }
                        }

                         returned = UsedSparePartsMgr.getInstance().getUsedItemsQuantityForIssue(scheduleID);
                  }
                else
                {
                      draw=false;
                }
                }
                else
                {
                draw = true ;
                }
        
    
                %>
                
                <%if(draw == true ){%>
                <input type="hidden" value="<%=returned%>" id="returned" />
                <input type="hidden" value="<%=used%>" id="used" />
                <table ALIGN="CENTER" WIDTH="90%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        <td align="<%=align%>" width="70%" style="border-width:0px;">
                            <table ALIGN="<%=align%>" WIDTH="100%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">

                                <tr>
                                    <td width="35%" class="bar" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;" >
                                        <b><font size="3" color="black"><%=eqpName%></font></b>
                                    </td>
                                    <td style="<%=style%>;padding-<%=cellAlign%>:25;border-right-width:0px">
                                        <b><font size="3" color="red"><%=wboTemp.getAttribute("unitName").toString()%></font></b>
                                    </td>
                                </tr>

                                <tr>
                                    <td  bgcolor="#CCCCCC" class="bar" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;" >
                                        <b><font size="3" color="black"><%=JONumber%></font></b>
                                    </td>
                                    <td  style="<%=style%>;padding-<%=cellAlign%>:25;border-right-width:0px">
                                        <b><font size="3" color="red">
                                            <%=webIssue.getAttribute("businessID").toString()%>/<%=webIssue.getAttribute("businessIDbyDate").toString()%>
                                            </font></b>
                                    </td>
                                </tr>

                                <tr>
                                    <td  bgcolor="#CCCCCC" class="bar" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;" >
                                        <b><font size="3" color="black">
                                            <%=eqpStatus%>&nbsp;
                                            </font></b>
                                    </td>
                                    <td STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;">
                                        <b><font size="3" color="black">
                                            <%if (wboTemp.getAttribute("equipmentStatus").toString().equals("1")) {%>
                                            <%=working%>
                                            <%} else {%>
                                            <%=outOfWorking%>                                        
                                            <%}%>
                                            </font></b>
                                    </td>
                                </tr>

                                <tr>
                                    <td  bgcolor="#CCCCCC" class="bar" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;" >
                                        <b><font size="3" color="black">
                                            <%=sOnLine%>&nbsp;
                                            </font></b>
                                    </td>
                                    <td STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;border-width:0px;">
                                        <b><font size="3" color="black">
                                            <%if (wboTemp.getAttribute("equipmentStatus").toString().equals("1")) {%>
                                            <input type="checkbox" id="changeState" disabled name="changeState">
                                            <%} else {%>
                                            <input type="checkbox" id="changeState" name="changeState" checked>                                        
                                            <%}%>
                                            </font></b>
                                    </td>
                                </tr>

                                <tr>
                                    <td  bgcolor="#CCCCCC" class="bar" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;">
                                        <b><font size="3" color="black">
                                            <%=actualTime%><font color="#FF0000">*</font>&nbsp;
                                            </font></b>
                                    </td>
                                    <td STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;border-width:0px;">
                                        <table  DIR="<%=dir%>">
                                            <tr>
                                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sMinutes%></b></font></td>
                                                <td ><font color="red"><b><%=sHours%></b></font></td>
                                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sDays%></b></font></td>
                                            </tr>
                                            <tr>
                                                <td style="border-right-width:1px;border-left-width:1px"><input style="width:20px;" type="text" name="minutes" id="minutes" maxlength="2" ONBLUR="IsNumeric(this.id);"></td>
                                                <td ><input style="width:20px;" type="text" name="hours" id="hours" maxlength="2" ONBLUR="IsNumeric(this.id);"></td>
                                                <td  style="border-right-width:1px;border-left-width:1px"><input style="width:20px;" type="text" name="day" id="day" maxlength="2" ONBLUR="IsNumeric(this.id);"></td>
                                            </tr>

                                        </table>
                                        <!--b><font size="3" color="black">
                                            <input type="text" name="actual_finish_time" id="actual_finish_time" value="10">
                                        <%--    
                                    <select name="actual_finish_time" id="actual_finish_time" style="width:200">
                                            <sw//:OptionList optionList='<%=hoursJob%>' scrollTo = "" />
                                        </select>
                                        --%>
                                        <font color="red" size="2"><b> <%=sHour%></b></FONT>
                                </font></b-->
                                    </td>
                                </tr>

                                <tr>
                                    <td bgcolor="#CCCCCC" class="bar" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;">
                                        <b><font size="3" color="black"><%=Time%></font></b>
                                    </td>
                                    <td ALIGN="<%=align%>" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;border-width:0px;">
                                        <select name="minute" style="width:96">
                                            <sw:OptionList optionList='<%=minutesAL%>' scrollTo = "<%=min%>"/>
                                        </select>
                                        <font color="red"><b>:</b></font>
                                        <select name="hour" style="width:96">
                                            <sw:OptionList optionList='<%=hoursAL%>' scrollTo = "<%=hr%>"/>
                                        </select>
                                        <font color="red"> <b>  HH : MM </b></font>
                                    </td>
                                </tr>

                                <tr>
                                    <td bgcolor="#CCCCCC" class="bar" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;">
                                        <b><font size="3" color="black">
                                            <%=actualDate%><font color="#FF0000">*</font>&nbsp;
                                            </font></b>      
                                    </td>

                                    <td ALIGN="<%=align%>" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;border-width:0px;">
                                        <input id="actualEndDate" name="actualEndDate" size="28" type="text" value="<%=expectedEDate%>"><img src="images/showcalendar.gif" >
                                        <input id="actualBeginDate" name="actualBeginDate" type="hidden" value="<%=actualBeginDate%>" />
                                    </td>

                                </tr>

                                <tr>
                                    <td bgcolor="#CCCCCC" class="bar" STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;">
                                        <b><font size="3" color="black">
                                            <%=TakenAction%><font color="#FF0000">*</font>&nbsp;
                                            </font></b>     
                                    </td>
                                    <td STYLE="<%=style%>;padding-<%=cellAlign%>:25;height:30;" ALIGN="<%=align%>" class='td' ID="assignNote">
                                        <TEXTAREA rows="3" STYLE="width:100%" name="actionTaken" ID="actionTaken"><%=explainReasons%></TEXTAREA>
                                    </td>
                                </tr>

                            </table>

                            <input type=HIDDEN name="startDate" value = "<%=(String) webIssue.getAttribute("expectedBeginDate")%>" >
                            <input type="hidden" name="workerNote" value="Finished Task">
                            <input type="hidden" name="causeDescription" id="causeDescription" value="Finished Task">
                            <input type=HIDDEN name="issueId" value = "<%=issueId%>" >
                            <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
                            <input type=HIDDEN name=filterName value="<%=filterName%>" >
                            <input type=HIDDEN name="<%=AppConstants.DIRECTION%>" value="<%=direction%>" >
                        </td>

                        <td class="td" align="right" style="text-align:center;border-width:0px;">
                            <table ALIGN="RIGHT" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                <tr>
                                    <td class="td" style="text-align:center;border-width:0px;">
                                        <div style="OVERFLOW: auto; display:block; WIDTH: 150px; HEIGHT: 150px;" id="imageDiv">
                                            <%if (wboTemp.getAttribute("equipmentStatus").toString().equals("1")) {%>
                                            <img src="images/workingEq.gif" alt="Working Equipment">
                                            <%} else {%>
                                            <img src="images/stoppedEq.gif" alt="Out Of Working Equipment">
                                            <%}%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>

                    </tr>
                </table>
                                        <%}
                
                
               else {
                %>
                <br>

                <table ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        <td nowrap>
                            <font size="3" color="red"><b> <%=addTaskNote%></b></font>
                        </td>
                    </tr>
                </table>

                <% }%>
                <br>
                <table align="<%=align%>" id="HiddenitemTable">
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
                <br>
            </fieldset>
        </FORM>
    </center>
    </BODY>
</HTML>