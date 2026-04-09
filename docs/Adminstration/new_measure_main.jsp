<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.util.*,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("Status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    
    WebBusinessObject taskWbo = (WebBusinessObject) request.getAttribute("taskWbo");
    
    ArrayList mainTypesList=(ArrayList)request.getAttribute("mainTypes");
    ArrayList tradeList=(ArrayList)request.getAttribute("tradeList");
    ArrayList tasktypeList =(ArrayList)request.getAttribute("tasktypeList");
    ArrayList empTitleList =(ArrayList)request.getAttribute("empTitleList");
    DateAndTimeControl dateAndTime = new DateAndTimeControl();

    String context = metaMgr.getContext();
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String[] taskAttributes = {"title", "name"};
    String[] taksListTitles = new String[2];
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    int s = taskAttributes.length;
    int t = s;
    int iTotal = 0;
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    
    ArrayList JobZiseList = new ArrayList();
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status,Dupname;
    String code, code_name;
    String title_1,title_2;
    String cancel_button_label;
    String fStatus;
    String sStatus;
    String save_button_label,Jops,EstimatedHours,Houre,PN, sPerviousItems,tradeName,taskType,Category,JobZise,eng_Desc;
    
    String search,AddCode,AddName,addNew,tCost,itemCode,name,price,count,cost,Mynote,del,scr,add,totCost;
    String updateParts,alert;
    String sMinute,sHour,sDay;
    String maxValue,minValue,frequency,sWeek,sMonth,sYear;
    String actionByMinValue,actionByMaxValue;
    String jobOredr,stopMachine,callPartner;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        code="Code";
        code_name="Arabic Description";
        title_1="New Measure";
        Jops="Reqiured Jop";
        EstimatedHours="Expected Duration";
        Houre="  Minute ";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        Dupname = "Name is Duplicated Chane it";
        taksListTitles[0]="Maintenance Item Code";
        taksListTitles[1]="Arabic Description";
        PN="Maintenance Item No.";
        sPerviousItems = "Pervious Maintenance Items";
        tradeName="Trade Name";
        taskType="Type Of Task";
        Category="Main Category";
        sStatus="Maintenance Item Saved Successfully";
        fStatus="Fail To Save Maintenance Item ";
        
        JobZiseList.add("Large");
        JobZiseList.add("medium");
        JobZiseList.add("small");
        JobZise = "Working size";
        eng_Desc="English Description";
        
        add="   Add   ";
        search="Auto search";
        AddCode="  Add using Part Code  ";
        AddName="  Add using Part Name  ";
        addNew="Add new part";
        tCost = "Cost of Task for ( <font color=\"red\">Hour</font> )";
        itemCode="Code";
        name="Name";
        price="Price";
        count="Quntity";
        cost="Total Price";
        Mynote="Note";
        del="Delete";
        scr="images/arrow1.swf";
        updateParts="Add Spare Parts on Maintenance Item";
        alert="You must have at leaset one Main Type Category, one Reqiured Jop, one Type Of Task, one Trade";
        sMinute = "Minute";
        sHour = "Hour";
        sDay = "Day";
        totCost="Total Cost";
        maxValue="Max Value";
        minValue="Min Value";
        frequency="Frequency";
        sWeek="Week";
        sMonth="Month";
        sYear="Year";
        actionByMinValue="Action by min value";
        actionByMaxValue="Action by max value";
        jobOredr="Create job order";
        stopMachine="Stop machine";
        callPartner="Call Partner";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        code="&#1575;&#1604;&#1603;&#1608;&#1583;";
        code_name="&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1593;&#1585;&#1576;&#1609;";
        Jops="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607; ";
        EstimatedHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1583;&#1602;&#1575;&#1574;&#1602;";
        Houre="   &#1583;&#1602;&#1600;&#1600;&#1610;&#1600;&#1600;&#1602;&#1600;&#1600;&#1607; ";
        title_1="&#1605;&#1602;&#1610;&#1575;&#1587; &#1580;&#1583;&#1610;&#1583;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604;";
        langCode="En";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        taksListTitles[0]="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        taksListTitles[1]="&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1593;&#1585;&#1576;&#1609;";
        PN=" &#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        sPerviousItems = "&#1575;&#1604;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602; &#1573;&#1583;&#1582;&#1575;&#1604;&#1607;&#1575;";
        tradeName="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        Category=" &#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1609; ";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        JobZiseList.add("&#1603;&#1576;&#1610;&#1585;");
        JobZiseList.add("&#1605;&#1578;&#1608;&#1587;&#1591;");
        JobZiseList.add("&#1576;&#1587;&#1610;&#1591;");
        JobZise = "&#1581;&#1580;&#1605; &#1575;&#1604;&#1593;&#1605;&#1604;";
        eng_Desc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
        add="  &#1571;&#1590;&#1601;  ";
        search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
        AddCode="   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;   ";
        AddName="   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;   ";
        addNew="  &#1571;&#1590;&#1601; &#1602;&#1591;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1607; ";
        tCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1576;&#1606;&#1583; &#1604;&#1604;&#1600;&#1600; ( <font color=\"red\">&#1587;&#1575;&#1593;&#1577;</font> )";
        itemCode="&#1575;&#1604;&#1603;&#1608;&#1583;";
        name="&#1575;&#1604;&#1573;&#1587;&#1605;";
        price="&#1575;&#1604;&#1587;&#1593;&#1585; ";
        count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
        cost=" &#1575;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
        Mynote="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        del="&#1581;&#1584;&#1601; ";
        scr="images/arrow2.swf";
        updateParts="&#1575;&#1590;&#1575;&#1601;&#1607; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        alert="&#1610;&#1580;&#1576; &#1575;&#1606; &#1578;&#1578;&#1571;&#1603;&#1583; &#1605;&#1606; &#1575;&#1606;&#1607; &#1610;&#1608;&#1580;&#1583; &#1593;&#1604;&#1609; &#1575;&#1604;&#1571;&#1602;&#1604; &#1606;&#1608;&#1593; &#1605;&#1593;&#1583;&#1607; &#1571;&#1587;&#1575;&#1587;&#1609; &#1608;&#1575;&#1581;&#1583; &#1608; &#1605;&#1580;&#1605;&#1608;&#1593;&#1607; &#1601;&#1606;&#1610;&#1607; &#1608;&#1575;&#1581;&#1583;&#1607; &#1608;&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607; &#1608;&#1606;&#1608;&#1593; &#1589;&#1610;&#1575;&#1606;&#1607; &#1608;&#1575;&#1581;&#1583;";
        sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
        sHour = "&#1587;&#1575;&#1593;&#1577;";
        sDay = "&#1610;&#1608;&#1605;";
        totCost="\u062A\u0643\u0644\u0641\u0629 \u0627\u0644\u0639\u0645\u0627\u0644\u0647";
        maxValue="&#1575;&#1604;&#1602;&#1610;&#1605;&#1577; &#1575;&#1604;&#1602;&#1589;&#1608;&#1609;";
        minValue="&#1575;&#1604;&#1602;&#1610;&#1605;&#1577; &#1575;&#1604;&#1583;&#1606;&#1610;&#1575;";
        frequency="&#1605;&#1593;&#1583;&#1604; &#1575;&#1604;&#1578;&#1603;&#1585;&#1575;&#1585;";
        sWeek="&#1571;&#1587;&#1576;&#1608;&#1593;";
        sMonth="&#1588;&#1607;&#1585;";
        sYear="&#1587;&#1606;&#1577;";
        actionByMinValue="&#1573;&#1580;&#1585;&#1575;&#1569; &#1593;&#1606;&#1583; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1602;&#1589;&#1608;&#1609;";
        actionByMaxValue="&#1573;&#1580;&#1585;&#1575;&#1569; &#1593;&#1606;&#1583; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1583;&#1606;&#1610;&#1575;";
        jobOredr="&#1573;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        stopMachine="&#1573;&#1610;&#1602;&#1575;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        callPartner="&#1575;&#1604;&#1575;&#1578;&#1589;&#1575;&#1604; &#1576;&#1575;&#1604;&#1608;&#1603;&#1610;&#1604;";
    }
    String doubleName = (String) request.getAttribute("name");
    
    ArrayList hoursJob = new ArrayList();
    String hour = null;
    for(float i=0; i<60.5; i+=0.5){
        hour=new Float(i).toString();
        hoursJob.add(hour);
    }
    hoursJob.remove(0);
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Failure Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css\headers.css">        
        
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        var empty="";
        
        function submitForm()
        {
            if (!validateData("req", this.ITEM_FORM.title, "Please, enter Code.") || !validateData("minlength=3", this.ITEM_FORM.title, "Please, enter a valid Code.")){
                this.ITEM_FORM.title.focus();
            } else if (!validateData("req", this.ITEM_FORM.description, "Please, enter Code Name.") || !validateData("minlength=3", this.ITEM_FORM.description, "Please, enter a valid Code Name.")){
                this.ITEM_FORM.description.focus(); 
            //} else if (!validateData("req", this.ITEM_FORM.executionHrs, "Please, enter Expected Duration.")){
           //     this.ITEM_FORM.executionHrs.focus();
            } else if (!validateData("req", this.ITEM_FORM.empTitle, "Please, enter Employee Title.")){
                 this.ITEM_FORM.empTitle.focus(); 
            } else if (!validateData("req", this.ITEM_FORM.tradeName, "Please, enter Trade Name.")){
                this.ITEM_FORM.tradeName.focus(); 
            } else if (!validateData("req", this.ITEM_FORM.taskType, "Please, enter Task Type.")){
                this.ITEM_FORM.taskType.focus(); 
            }else if(!checkDateTime()){
                    alert("Put time to maintenance item");
                    this.ITEM_FORM.minute.focus();
            }  else if(!checkCost()) {
                return;
            } else {
                document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=saveMeasure";
                document.ITEM_FORM.submit();
            }
        }

        function checkCost() {

        if(document.getElementById('costHour').value == null || document.getElementById('costHour').value == '' || document.getElementById('costHour').value =='00' || document.getElementById('costHour').value =='0') {
            alert("Must Enter Cost of Task for Hour ...");
            document.getElementById('costHour').focus();
            return false;
        }
        return true;
    }
    
    function cancelForm()
    {    
        document.ITEM_FORM.action = "main.jsp";
        document.ITEM_FORM.submit();  
    }
    
     function IsNumeric()
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;
        
        sText=document.getElementById('executionHrs').value;
        
        for (i = 0; i < sText.length && IsNumber == true; i++) 
        { 
            Char = sText.charAt(i);
            
            if (ValidChars.indexOf(Char) == -1) 
            {
                IsNumber = false;
            }
        }
        return IsNumber;

    }
    
    function checkTime()
        {
          checkMinsLabel = document.getElementById("executionHrs").value;
          if(parseInt(checkMinsLabel) <= 0 || checkMinsLabel.indexOf("-")>=0)
          {
          alert("Time must be positive and more than zero");
          document.getElementById("executionHrs").value='';
          }
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
    
    function calcTotCost(){
        var costHour=document.getElementById('costHour').value;
        //alert('---1'+costHour);
        var day=document.getElementById('day').value;
        //alert('---2'+day);
        var hour=document.getElementById('hour').value;
        //alert('---3'+hour);
        var minute=document.getElementById('minute').value;
        //alert('---4'+minute);
        var totalCost=((day*24)+(hour*1)+(minute/60))*costHour;
        //alert('---5'+totalCost);
        document.getElementById('totalCost').value=totalCost;
    }
    
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="ITEM_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <%
            if(null!=doubleName) {
            %>
            <table dir="<%=dir%>" align="<%=align%>" width="400">
                <tr>
                    <td class="bar" style="height:30;">
                        <center>
                            <font size="3" color="black" ><%=Dupname%></font>
                        </center>
                    </td>
            </tr> </table>
            <%}%>    
            <%
            if(null!=status) {
        if(status.equalsIgnoreCase("ok")){
            %>  
            <tr>
                <table align="<%=align%>" dir=<%=dir%> width="400">
                    <tr>                    
                        <td class="bar">
                            <center>
                                <font size="3" color="black" ><%=sStatus%></FONT> 
                            </center>
                        </td>                    
                </tr> </table>
            </tr>
            <%
            }else{%>
            <tr>
                <table align="<%=align%>" dir=<%=dir%> width="400">
                    <tr>                    
                        <td class="bar">
                            <center>
                                <font size="3" color="red" ><%=fStatus%></font> 
                            </center>
                        </td>                    
                </tr> </table>
            </tr>
            <%}}%>
            
            
            <table align="<%=align%>" dir=<%=dir%>>
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                    
                </TR>
            </table>
            <br>
            
            <%if(mainTypesList!=null || tasktypeList !=null || empTitleList !=null){
            if(mainTypesList.size()>0 || tasktypeList.size()>0 || empTitleList.size()>0){
            
            %>
            
            <TABLE ALIGN="<%=align%>"  DIR="<%=dir%>" border="0" width="80%" ID="MainTable0">
                
                <TR>
                    <TD NOWRAP STYLE="<%=style%>" CLASS="bar" WIDTH="15%" BGCOLOR="#dcdcdc">
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=code%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    
                    <TD STYLE="<%=style%>" CLASS="td">
                        <%if(status!=null && status.equalsIgnoreCase("ok")){%>
                        <input type="TEXT" name="title" ID="title" size="24" value="<%=(String)taskWbo.getAttribute("title")%>" maxlength="255">
                        <%}else{%>
                        <input type="TEXT" name="title" ID="title" size="24" value="" maxlength="255">
                        <%}%>
                    </TD>
                    
                    <TD STYLE="<%=style%>" class='td' >
                        &nbsp;
                    </TD>
                    
                    <TD NOWRAP STYLE="<%=style%>" class='bar' WIDTH="15%" BGCOLOR="#dcdcdc">
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=frequency%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>                    
                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                        <SELECT name="empTitle" id="empTitle" style="width:180px">
                            <option value="1"><%=sHour%></option>
                            <option value="2"><%=sDay%></option>
                            <option value="3"><%=sWeek%></option>
                            <option value="4"><%=sMonth%></option>
                            <option value="5"><%=sYear%></option>
                        </SELECT>
                    </TD>
                </TR>
                
                <TR>
                    
                    <TD NOWRAP STYLE="<%=style%>" class='bar' BGCOLOR="#dcdcdc">
                        <LABEL FOR="Category">
                            <p><b><%=Category%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                        <SELECT name="mainTypeId" id="mainTypeId" style="width:180px">
                            <%if(status!=null && status.equalsIgnoreCase("ok")){
                                String mainTypeName = (String)taskWbo.getAttribute("mainTypeName");
                            %>
                            <sw:WBOOptionList wboList='<%=mainTypesList%>' displayAttribute = "typeName" scrollTo="<%mainTypeName%>" valueAttribute="id" />
                            <%}else{%>
                            <sw:WBOOptionList wboList='<%=mainTypesList%>' displayAttribute = "typeName" valueAttribute="id"/>
                            <%}%>
                        </SELECT>
                        
                    </TD>
                    
                    <TD STYLE="<%=style%>" class='td' >
                        &nbsp;
                    </TD>                    
                    
                    <TD NOWRAP STYLE="<%=style%>" class='bar'  BGCOLOR="#dcdcdc">
                        <LABEL FOR="assign_to">
                            <p><b><%=tradeName%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                        <SELECT name="tradeName" id="tradeName" style="width:180px">
                            <%if(status!=null && status.equalsIgnoreCase("ok")){
                            String  tradeTypeName = (String)taskWbo.getAttribute("tradeName");
                            %>
                            <sw:WBOOptionList wboList='<%=tradeList%>' scrollTo="<%=tradeTypeName%>" displayAttribute = "tradeName" valueAttribute="tradeId"/>
                            <%}else{%>
                            <sw:WBOOptionList wboList='<%=tradeList%>' displayAttribute = "tradeName" valueAttribute="tradeId"/>
                            <%}%>
                        </SELECT>

                    </TD>
                    
                </TR>
                
                <tr>
                    <input type="hidden" name="jobzise" ID="jobzise" value="<%=JobZiseList.get(0).toString()%>">
                    <TD STYLE="<%=style%>" WIDTH="5%"  class="bar">
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=maxValue%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" CLASS="td" WIDTH="10%">
                        <%if(status!=null && status.equalsIgnoreCase("ok")){%>
                            <input type="text" maxlength="5" name="costHour" id="costHour" value="<%=(String)taskWbo.getAttribute("costHour")%>" style="width:40px" ONBLUR="IsNumeric(this.id);">
                        <%}else{%>
                            <input type="text" maxlength="5" name="costHour" id="costHour" style="width:40px"  ONBLUR="IsNumeric(this.id);">
                        <%}%>


                    </TD>
                    
                    <TD STYLE="<%=style%>" class='td' >
                        &nbsp;
                    </TD>
                    
                    <TD STYLE="<%=style%>" WIDTH="5%"  class="bar">
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=minValue%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" CLASS="td" WIDTH="10%">
                        <%if(status!=null && status.equalsIgnoreCase("ok")){%>
                            <input type="text" maxlength="5" name="costHour" id="costHour" value="<%=(String)taskWbo.getAttribute("costHour")%>" style="width:40px" ONBLUR="IsNumeric(this.id);">
                        <%}else{%>
                            <input type="text" maxlength="5" name="costHour" id="costHour" style="width:40px"  ONBLUR="IsNumeric(this.id);">
                        <%}%>


                    </TD>
                </tr>
                
                <TR>
                   <TD NOWRAP STYLE="<%=style%>" class='bar' WIDTH="15%" BGCOLOR="#dcdcdc">
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=actionByMaxValue%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                        <SELECT name="empTitle" id="empTitle" style="width:180px">
                            <option value="1"><%=jobOredr%></option>
                            <option value="2"><%=stopMachine%></option>
                            <option value="3"><%=callPartner%></option>
                        </SELECT>
                    </TD>

                    <TD STYLE="<%=style%>" class='td' >
                        &nbsp;
                    </TD>

                    <TD NOWRAP STYLE="<%=style%>" class='bar' WIDTH="15%" BGCOLOR="#dcdcdc">
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=actionByMinValue%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                        <SELECT name="empTitle" id="empTitle" style="width:180px">
                            <option value="1"><%=jobOredr%></option>
                            <option value="2"><%=stopMachine%></option>
                            <option value="3"><%=callPartner%></option>
                        </SELECT>
                    </TD>
                </TR>

                <TR>
                    <TD  NOWRAP STYLE="<%=style%>" class='bar'  BGCOLOR="#dcdcdc">
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=eng_Desc%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"  class='td'>
                        <%if(status!=null && status.equalsIgnoreCase("ok")){%>
                        <textarea name="engDesc" id="engDesc" style="width:180;height:40;"><%=(String)taskWbo.getAttribute("engDesc")%></textarea>
                        <%}else{%>
                        <textarea name="engDesc" id="engDesc" style="width:180;height:40;"></textarea>
                        <%}%>
                    </TD>
                    
                    <td width="2%" CLASS="td">&nbsp;</td>
                    
                    <TD NOWRAP STYLE="<%=style%>" CLASS="bar" WIDTH="5%"  BGCOLOR="#dcdcdc">
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=code_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" CLASS="td" WIDTH="10%">
                        <%if(status!=null && status.equalsIgnoreCase("ok")){%>
                        <textarea name="description" id="description" style="width:180;height:40;"><%=(String)taskWbo.getAttribute("name")%></textarea>
                        <%}else{%>
                        <textarea name="description" id="description" style="width:180;height:40;"></textarea>
                        <%}%>
                    </TD>
                </TR>
                
            </TABLE>
            
            <%}else{%>
            <TABLE ALIGN="<%=align%>"  DIR="<%=dir%>" border="0" width="80%" ID="MainTable0">
                <tr>
                    <td width="i00%" class="td">
                        <font color="red" size="3">
                            <%=alert%>
                        </font>                        
                    </td>
                </tr>
            </TABLE>
            <%}%>
            
            <%}else{%>
            <TABLE ALIGN="<%=align%>"  DIR="<%=dir%>" border="0" width="80%" ID="MainTable0">
                <tr>
                    <td width="i00%" class="td">
                        <font color="red" size="3">
                            <%=alert%>
                        </font>                        
                    </td>
                </tr>
            </TABLE>
            <%}%>
        </FORM>
    </BODY>
</HTML>     
