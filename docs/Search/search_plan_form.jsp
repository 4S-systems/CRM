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
    
    // get current date
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
    String jDateFormat = loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    
    //Define language setting
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    
    String selectEq,beginDate,endDate,seach,cancel,title,calenderTip,beginDateMsg,endDateMsg;
    
    if (stat.equals("En")) {
        selectEq="Select Equipment Name";
        beginDate="Begin Date";
        endDate="End Date";
        seach="Search";
        cancel="Cancel";
        title="Search About Future Plan";
        calenderTip = "click inside text box to open calender window";
        endDateMsg = "End Date must be less than or equal today";
        beginDateMsg = "Begin Date must be less than or equal today";
        
    } else {
        selectEq="&#1571;&#1582;&#1578;&#1585;&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577;";
        beginDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1582;&#1591;&#1607;";
        endDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1582;&#1591;&#1607;";
        seach="&#1576;&#1581;&#1579;";
        cancel="&#1573;&#1606;&#1607;&#1575;&#1569;";
        title="&#1576;&#1581;&#1579; &#1593;&#1606; &#1582;&#1591;&#1607; &#1605;&#1587;&#1578;&#1602;&#1576;&#1604;&#1610;&#1607;";
        calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
        endDateMsg = "\u062A\u0627\u0631\u064A\u062E \u0646\u0647\u0627\u064A\u0629 \u0627\u0644\u062E\u0637\u0629 \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
        beginDateMsg = "\u062A\u0627\u0631\u064A\u062E \u0628\u062F\u0627\u064A\u0629 \u0627\u0644\u062E\u0637\u0629 \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Search Future Plan</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">
        
        <script type="text/javascript">
            $(document).ready(function() {

                var dates = $( "#beginDate, #endDate" ).datepicker({
                    defaultDate: "+1w",
                    changeMonth: true,
                    changeYear : true,
                    minDate    : "+d",
                    dateFormat : "yy/mm/dd",
                    numberOfMonths: 1,
                    showAnim   : 'drop',
                    onSelect: function( selectedDate ) {
                        var option = this.id == "beginDate" ? "minDate" : "maxDate",
                        instance = $( this ).data( "datepicker" ),
                        date = $.datepicker.parseDate(
                        instance.settings.dateFormat ||
                            $.datepicker._defaults.dateFormat,
                        selectedDate, instance.settings );
                        dates.not( this ).datepicker( "option", option, date );

                        dates.not( "#beginDate" ).datepicker( "option", "minDate", date );

                    }
                });

            });
        </script>
        
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
        
    </HEAD>
    
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
   var dp_cal1; 
   var dp_cal2;      
        //window.onload = function () {
        //};
    var count = 0;
    var itemsCode;
    var itemNames;
    var nowMode="name";
    
    var lookAheadArray = null;
    var suggestionDiv = null;
    var cursor;
    var inputTextField;
    var debugPane = null;
    var urlbase = '<%=context%>';
    
    window.onload = function (){

        init("unitId");        
        var pr=document.getElementsByName('con');
        count=pr[0].value;
        alert(count);
     }
     
     function init (field) {
         inputTextField = document.getElementById(field);
         cursor = -1;
         fillArrayWithAllUsernames();
         inputTextField.onkeyup = function (inEvent) {
             if (!inEvent) {
                 inEvent = window.event;
             }    
             keyUpHandler(inEvent);
         }

        inputTextField.onkeydown = function (inEvent) {
            if (!inEvent){
                inEvent = window.event;
            }
            keyDownHandler(inEvent);
        }
        
        inputTextField.onblur = function () {
            hideSuggestions();
        }

        createDiv();
    }

    function fillArrayWithAllUsernames(){ 
        var url = "<%=context%>/SearchServlet?op=listEq";
        
        if (window.XMLHttpRequest) { 
            req = new XMLHttpRequest(); 
        } else if (window.ActiveXObject) { 
            req = new ActiveXObject("Microsoft.XMLHTTP"); 
        } 
        
        req.open("Post",url,true); 
        req.onreadystatechange =  callbackFilltaskcode;
        req.send(null);
    } 
    
    function callbackFilltaskcode() { 
        if (req.readyState==4) { 
            if (req.status == 200) { 
                var result= req.responseText;
                var arr=result.split('&#');
                
                itemsCode=arr[0].split('!=');
                lookAheadArray =itemsCode;
                itemNames= arr[1].split('!=');
                nowMode="name";
            } 
        } 
    }
    
    function createDiv(){
        suggestionDiv = document.createElement("div");
        suggestionDiv.style.zIndex = "1000";
        suggestionDiv.style.opacity ="1.0";
        suggestionDiv.style.repeat = "repeat";
        suggestionDiv.style.filter = "alpha(opacity=80)";
        suggestionDiv.className = "suggestions";
        suggestionDiv.style.visibility = "hidden";
        suggestionDiv.style.width = inputTextField.offsetWidth;
        suggestionDiv.style.backgroundColor = "#CFC8A4";
        suggestionDiv.style.autocomplete = "off";
        suggestionDiv.style.backgroundImage = "url(transparent50.png)";
        //when the user clicks on the a suggestion, get the text (innerHTML)
        //and place it into a inputTextField
        
        suggestionDiv.onmouseup = function() {
            inputTextField.focus();
        }
        
        suggestionDiv.onmouseover = function(inputEvent) {
            inputEvent = inputEvent || window.event;
            sugTarget = inputEvent.target || inputEvent.srcElement;
            highlightSuggestion(sugTarget);
        }
        
        suggestionDiv.onmousedown = function(inputEvent) {
            inputEvent = inputEvent || window.event;
            sugTarget = inputEvent.target || inputEvent.srcElement;
            inputTextField.value = sugTarget.firstChild.nodeValue;
            lookupUsername(inputTextField.value);
            hideSuggestions();
        }
        
        document.body.appendChild(suggestionDiv);
    }
    
    function f(){
        var dd=document.getElementById('unitId');
        dd.value="";
    }
    
    function d(){
        var dd=document.getElementById('unitId');
        dd.value="Auto Select Name";
    }
    
    function addNew(){
        var TDName=document.getElementsByName('unitId');
     
        if(TDName[0].value==""){
            alert("please fill the name field frist ");
            return;
        }
     
        if(isFound(TDName[0].value)){
            alert(" that item is exist already in the table");
            return;
        }
        
        count++;     
        
        var x = document.getElementById('listTable').insertRow();
        var C1 = x.insertCell(0);
        var C2 = x.insertCell(1);
        var C3 = x.insertCell(2);
        var C4 = x.insertCell(3);
        var C5 = x.insertCell(4);
        var C6 = x.insertCell(5);
        
        C1.borderWidth = "3px";
        C1.borderColor="white";
        C1.id = "codeTask";
        C1.bgColor = "powderblue";
        
        C2.borderWidth = "1px";
        C2.id = "descEn";
        C2.bgColor = "powderblue";
        
        C3.borderWidth = "1px";
        C3.id = "trade";
        C3.bgColor = "powderblue";
        
        C4.borderWidth = "1px";
        C4.id = "EHours";
        C4.bgColor = "powderblue";
        
        C5.borderWidth = "1px";
        C5.bgColor = "powderblue";
        
        C6.borderWidth = "1px";
        C6.bgColor = "powderblue";
        
        var me=count-1;

        C5.innerHTML = "<INPUT TYPE='text' name='desc' ID='desc' SIZE='35'>";
        C6.innerHTML = "<input type='checkbox' name='check' ID='check'>"+"<input type='hidden' name='id' ID='id'>";    

        set();
    }
    
    function set(){
        var x=count-1;
        var code = document.getElementsByName('codeTask');
        var TDNAME = document.getElementById('unitId');
    
        if(nowMode=="name"){
            for(var i=0;i<lookAheadArray.length;i++){ 
                if(lookAheadArray[i]==TDNAME.value){
                    if(isFound(itemsCode[i])){
                        alert(" that item is exist already in the table");
                        count--;
                        document.getElementById('listTable').deleteRow(count+1);
                        return;
                    }
                    
                    TDNAME.value=itemsCode[i];
                    break;
                }
            }
        }    
         
        code[x].innerHTML= TDNAME.value;
        
        TDNAME.value="";
        nowRow=x;
       
        var url = "<%=context%>/TaskServlet?op=code&value="+code[x].innerHTML;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest( );
        } else if (window.ActiveXObject) {
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
        req.open("Get",url,true);
        req.onreadystatechange = callback;
        req.send(null);
    }
    
    function callback( ){
        if (req.readyState==4) {
            if (req.status == 200) {
                var result= req.responseText;
                var arr=result.split('!=');
                var name=arr[1];
                var desc=arr[0];
                var s=arr[2];
                var hour=arr[3];
                var trade=arr[4];
          
                if(name==" ")
                    noCodeFound();
                else {
                    var pr=document.getElementsByName('codeTask');
                    var nam=document.getElementsByName('descEn');
                    var id=document.getElementsByName('id');
                    var hours=document.getElementsByName('EHours'); 
                    var jop=document.getElementsByName('trade'); 
                    
                    nam[nowRow].innerHTML = name;
                    pr[nowRow].innerHTML = desc;
                    id[nowRow].value=s;
                    hours[nowRow].innerHTML=hour;
                    jop[nowRow].innerHTML=trade;
                }
            }
        }
    }
    
    function isFound(x){
        var code=document.getElementsByName('codeTask');

        for(i=0;i<count;i++){
            if(x == (code[i].innerHTML).replace(" ", "")){
                return true;
            }
        }
        
        return false;
    }
    
    function noCodeFound( ) {
        alert(" not found code");
        var tbl = document.getElementById('listTable');
        tbl.deleteRow(count--);
    }
    
    function Delete() {
        var tbl = document.getElementById('listTable');
        var check=document.getElementsByName('check');
        
        for(var i=0;i<count;i++){
            if(check[i].checked==true){
                tbl.deleteRow(i+1);
                i--;
                count--;
            }   
        }
    }
     
    function IsNumeric(sText)
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;

        for (i = 0; i < sText.length && IsNumber == true; i++) { 
            Char = sText.charAt(i); 
            if (ValidChars.indexOf(Char) == -1) {
                IsNumber = false;
            }
        }
        
        return IsNumber;
    }
    
    function keyDownHandler(inEvent ){
        switch(inEvent.keyCode) {
            /* up arrow */
            case 38: 
                if (suggestionDiv.childNodes.length > 0 && cursor > 0) {
                    var highlightNode = suggestionDiv.childNodes[--cursor];
                    highlightSuggestion(highlightNode);
                    inputTextField.value = highlightNode.firstChild.nodeValue;   
                }
                break;
            
            /* Down arrow */
            case 40: 
                if (suggestionDiv.childNodes.length > 0 && cursor < suggestionDiv.childNodes.length-1) {
                    var newNode = suggestionDiv.childNodes[++cursor];
                    highlightSuggestion(newNode);
                    inputTextField.value = newNode.firstChild.nodeValue; 
                }
                break;
                
            /* Enter key = 13 */
                case 13: 
                    var lookupName = inputTextField.value;
                    hideSuggestions();
                    lookupUsername(lookupName);
                    break;
        }
    } 
    
    function keyUpHandler(inEvent) {
        var potentials = new Array();
        var enteredText = inputTextField.value;
        var iKeyCode = inEvent.keyCode;

        if (iKeyCode == 32 || iKeyCode == 8 || ( 45 < iKeyCode && iKeyCode < 112) || iKeyCode > 123) /*keys to consider*/{
            if (enteredText.length > 0){
                for (var i=0; i < lookAheadArray.length; i++) { 
                    if (lookAheadArray[i].indexOf(enteredText) == 0) {
                        potentials.push(lookAheadArray[i]);
                    } 
                }
                
                showSuggestions(potentials);
            }
            
            if (potentials.length > 0) {
                if (iKeyCode != 46 && iKeyCode != 8) {
                    typeAhead(potentials[0]);
                }
                
                showSuggestions(potentials);
            } else {
                hideSuggestions();
            }
        }
    }
    
    function hideSuggestions () {
        suggestionDiv.style.visibility = "hidden";
    }

    function highlightSuggestion(suggestionNode) {
        for (var i=0; i < suggestionDiv.childNodes.length; i++) {
            var sNode = suggestionDiv.childNodes[i];
            
            if (sNode == suggestionNode) {
                sNode.className = "current"
            } else if (sNode.className == "current") {
                sNode.className = "";
            }
        }
    }
    
    function selectRange(start , end ) {
        if (inputTextField.createTextRange) {
            var sRange = inputTextField.createTextRange(); 
            sRange.moveStart("character", start); 
            sRange.moveEnd("character", end - inputTextField.value.length);      
            sRange.select();
        } else if (inputTextField.setSelectionRange) {
            inputTextField.setSelectionRange(start, end);
        }     
        
        inputTextField.focus();      
    } 

    function showSuggestions(suggestions) {
        var sDiv = null;    
        suggestionDiv.innerHTML = "";  

        for (i=0; i < suggestions.length; i++) {
            sDiv = document.createElement("div");
            sDiv.appendChild(document.createTextNode(suggestions[i]));
            suggestionDiv.appendChild(sDiv);
        }

        suggestionDiv.style.top = (210+inputTextField.offsetTop+inputTextField.offsetHeight+document.getElementById("code").offsetTop+document.getElementById("data").offsetTop) + "px";
        suggestionDiv.style.left = (10+inputTextField.offsetLeft+document.getElementById("code").offsetLeft+document.getElementById("data").offsetLeft) + "px";
        suggestionDiv.style.visibility = "visible";
    }

    function typeAhead(suggestion) {
        if (inputTextField.createTextRange || inputTextField.setSelectionRange){
            var iLen = inputTextField.value.length; 
            inputTextField.value = suggestion; 
            selectRange(iLen, suggestion.length);
        }
    }
    
    function reloadAE(nextMode){
        var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
        
        if (window.XMLHttpRequest){ 
            req = new XMLHttpRequest(); 
        } else if (window.ActiveXObject) { 
            req = new ActiveXObject("Microsoft.XMLHTTP"); 
        } 
        
        req.open("Post",url,true); 
        req.onreadystatechange =  callbackFillreload;
        req.send(null);
    }

    function callbackFillreload(){
        if (req.readyState==4) { 
            if (req.status == 200) { 
                window.location.reload();
            }
        }
    }
    
    function mod(mode){
        if(mode=="code"){
            lookAheadArray =itemsCode;
            nowMode="code";
        } else {
            lookAheadArray =itemNames;
            nowMode="name";
        }
    } 
    
      
    function checkCodeTask(){       
        if(document.getElementById('codeTask').innerHTML != ""){
            var codeTasks = document.getElementsByName('codeTask');
            
            for(i = 0; i < codeTasks.length; i++){
                if(codeTasks[i].innerHTML == ""){
                    return false;
                }
            }
        } else if(this.SCHDULE_FORM.codeTask.checkCodeTask == ""){
            return false;
        }
        
        return true;
    }
    
    function checkDescEn(){
        if(document.getElementById('descEn').innerHTML != ""){
            var descEns = document.getElementById('descEn');
            
            for(i = 0; i < descEns.length; i++){
                if(descEns[i].innerHTML == ""){
                    return false;
                }
            }
        } else if(document.getElementById('descEn').innerHTML == ""){
            return false;
        }
        
        return true;
    }
    
    function checkNotes(){
        var notesArr = document.getElementsByName('desc');
        
        for(i=0; i<notesArr.length; i++){
            if(notesArr[i].value =="" || notesArr[i].value =="null")
                notesArr[i].value = "No Notes";
        }
    }
        
    function submitForm()
    {  
        var name = document.getElementById('unitId').value;
        for(var i=0;i<lookAheadArray.length;i++) { 
            if(lookAheadArray[i] == name) {
                document.getElementById('unitId').value=itemNames[i];
                break;
            }
        }

        if(Date.parse(document.getElementById("beginDate").value) < Date.parse('<%=nowTime%>')){
            alert('<%=beginDateMsg%>');
            document.SEARCH_MAINTENANCE_FORM.beginDate.focus();
            return false;
        } else if(Date.parse(document.getElementById("endDate").value) < Date.parse('<%=nowTime%>')){
            alert('<%=endDateMsg%>');
            document.SEARCH_MAINTENANCE_FORM.endDate.focus();
            return false;
        } else {
            var url="<%=context%>/SearchServlet?op=searchPlanResult";
            document.ISSUE_FORM.action = url;
            document.ISSUE_FORM.submit();
            
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

        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            <fieldset >
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            <td class="td">  
                                <IMG WIDTH="80" HEIGHT="80" SRC="images/Search.png">
                            </td>
                            <td class="td">
                                <font color="blue" size="6"> <%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                
                <TABLE ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="500" STYLE="border-width:1px;border-color:black;">
                    
                    <TR>
                        <TD CLASS="header" STYLE="text-align:center" COLSPAN="2">
                            <b><%=title%></b>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD CLASS="tRow2" STYLE="text-align:center" WIDTH="50%">
                            <b><%=selectEq%></b>
                        </TD>
                        
                        <TD CLASS="tRow2" STYLE="text-align:center;" ID="data">                        
                            <input type="text" dir="rtl" autocomplete="off" value="All" onkeydown="JavaScript: checkKey(event);" ONCLICK="JavaScript: f();" id="unitId" name="unitId">
                        </TD>
                    </TR>
                </TABLE>
                
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
                        <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                            <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                        </TD>
                        <TD  style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                            <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                        </TD>
                    </TR>
                    
                    <tr>
                        <br><br>
                        <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                            <button  onclick="JavaScript: submitForm();"   STYLE="font-size:15;font-weight:bold; ">  <%=seach%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>          
                            <button  onclick="JavaScript: cancelForm();" STYLE="font-size:15;font-weight:bold; "><%=cancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                        </TD>
                    </tr>
                </TABLE>
                
            </fieldset>
            
        </FORM>
    </BODY>
</HTML>     
