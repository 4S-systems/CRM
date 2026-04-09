<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.maintenance.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr unitMgr  = MaintainableMgr.getInstance();
IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
TaskMgr taskMgr = TaskMgr.getInstance();
IssueMgr issueMgr = IssueMgr.getInstance();
String context = metaMgr.getContext();
UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
DateAndTimeControl dateAndTime = new DateAndTimeControl();

String status = (String) request.getAttribute("Status");
String issueId = (String) request.getAttribute("issueId");
String filterName = request.getParameter("filterName");
String filterValue = request.getParameter("filterValue");
String message;

WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
WebBusinessObject wbounitSchedule = unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());

Vector tasksVec = (Vector) request.getAttribute("issueTasks");
Vector executedTasksVec = (Vector) request.getAttribute("executedTasks");

String cMode= (String) request.getSession().getAttribute("currentMode");
String stat=cMode;
String align=null;
String dir=null;
String style=null;
String classStyle="tRow";
String lang,langCode,AllRequired,EqType,JS , BackToList,save, AddCode,AddName,saving,TC,TN,TH,TJ,M,M2,tit,add,del,title,scr,search,updateItems,TaskDesc,noLimitsize,eqpName,JONumber, JOData,
        unexecTableTitle ,executedTableTitle, noData,engDesc,searchSubName,searchByCode,searchTitleCode;
String cellAlign;
if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    BackToList = "Back";
    save = "    Save   ";
    AllRequired="(*) All Data Must Be Filled";
    TC="Task Code";
    TN="Task Name";
    TH="Execution Time";
    TJ="Required Trade";
    TaskDesc="Notes";
    M="Data Had Been Saved Successfully";
    M2="Saving Failed ";
    tit="Maintenance Task ";
    add="Add";
    del="delete";
    title="Add Maintenance tasks";
    scr="images/arrow1.swf";
    search="Auto Search";
    AddCode="Add using Task Code";
    AddName="Add using Task Name";
    updateItems="Add / Update Schedule Maintenance Tasks";
    JS="Job Size";
    EqType="Equipment Type";
    noLimitsize="No limited";
    eqpName="Machine Name";
    JONumber="Job order number";
    cellAlign = "left";
    JOData = "Job Order Data";
    unexecTableTitle = "Those tasks are not related to labors";
    executedTableTitle = "Those tasks are related to labors and can not be deleted or updated";
    noData = "No tasks are related to labores";
    engDesc="English Description";
    searchSubName="Search With Name or SubName";
    searchByCode="Search By Item Code";
    searchTitleCode="Seach About Maintenance Item By Code";
}else{
    align="center";
    dir="RTL";
    style="text-align:right";
    lang="   English    ";
    langCode="En";
    AddCode="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
    AddName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577;";
    save = " &#1585;&#1576;&#1591; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; ";
    AllRequired=" &#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
    TC="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
    TN="&#1573;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
    TH="&#1608;&#1602;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    TJ="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    TaskDesc="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    M="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
    M2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    tit="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    add="&#1571;&#1590;&#1601;";
    del="&#1581;&#1584;&#1601;";
    title="&#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; ";
    scr="images/arrow2.swf";
    search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
    updateItems="&#1575;&#1590;&#1575;&#1601;&#1577; / &#1578;&#1593;&#1583;&#1610;&#1604; &#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    JS="&#1581;&#1580;&#1605; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    EqType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    noLimitsize="&#1594;&#1610;&#1585; &#1605;&#1581;&#1583;&#1583;";
    eqpName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    JONumber="&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    cellAlign = "right";
    JOData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    unexecTableTitle = "&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1593;&#1605;&#1575;&#1604;&#1577;";
    executedTableTitle = "&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1593;&#1605;&#1575;&#1604;&#1577; - &#1604;&#1575;&#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601;&#1607;&#1575; &#1571;&#1608; &#1578;&#1593;&#1583;&#1610;&#1604;&#1607;&#1575;";
    noData = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1593;&#1605;&#1575;&#1604;&#1577;";
    engDesc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
    searchSubName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605; &#1575;&#1608; &#1576;&#1580;&#1586;&#1569; &#1605;&#1606; &#1575;&#1604;&#1575;&#1587;&#1605;";
    searchByCode="&#1576;&#1581;&#1579; &#1576;&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
    searchTitleCode="&#1576;&#1581;&#1579; &#1593;&#1606; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; &#1576;&#1575;&#1604;&#1603;&#1608;&#1583;";
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    var count = 0;
    var itemsCode;
    var itemNames;
    var nowMode="code";
    
    var lookAheadArray = null;
    var suggestionDiv = null;
    var cursor;
    var inputTextField;
    var debugPane = null;
    var urlbase = '<%=context%>';
    
    window.onload = function (){
        //init("codecell");
     
        var pr=document.getElementsByName('con');
        count=pr[0].value;
     }
     
     function init (field) {
         inputTextField = document.getElementById(field);
         alert(field);
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
        var url = "<%=context%>/TaskServlet?op=list";
        
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
                nowMode="code";
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
        suggestionDiv.style.height="300";
        suggestionDiv.style.backgroundColor = "#FFFFCC";
        suggestionDiv.style.autocomplete = "off";
        suggestionDiv.style.backgroundImage = "url(transparent50.png)";
        suggestionDiv.style.overflow="auto";

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
        var dd=document.getElementById('codecell');
        dd.value="";
    }
    
    function d(){
        var dd=document.getElementById('codecell');
        dd.value="Auto Select Code";
    }
    
    function addNew(){
        var TDName=document.getElementsByName('codecell');
        
        count=document.getElementById('nRows').value;
        
        if(TDName[0].value==""){
            alert("please fill the name field frist ");
            return;
        }

        if(isExecutedFound(TDName[0].value)){
            alert(" that item is exist already in executed tasks table");
            return;
        }
        
        if(isFound(TDName[0].value)){
            alert(" that item is exist already in the table");
            return;
        }
        
        count++;     
        
        var className="tRow";
        if((count%2)==1)
        {
            className="tRow";
        }else{
            className="tRow2";
        }
        
        document.getElementById('nRows').value=count;
        
        var x = document.getElementById('listTable').insertRow();
        var C1 = x.insertCell(0);
        var C2 = x.insertCell(1);
        var C3 = x.insertCell(2);
        var C4 = x.insertCell(3);
        var C5 = x.insertCell(4);
        var C6 = x.insertCell(5);
        var C7 = x.insertCell(6);
       // var C8 = x.insertCell(7);
        
        C1.borderWidth = "3px";
        C1.borderColor="white";
        C1.id = "codeTask";
        C1.bgColor = "powderblue";
        C1.className=className;
        
        C2.borderWidth = "1px";
        C2.id = "descEn";
        C2.bgColor = "powderblue";
        C2.className=className;
        
        C3.borderWidth = "1px";
        C3.id = "trade";
        C3.bgColor = "powderblue";
        C3.className=className;
                
      //  C4.borderWidth = "1px";
      //  C4.id = "eqType";
      //  C4.bgColor = "powderblue";
      // C4.className=className;
        
        C4.borderWidth = "1px";
        C4.id = "jobSize";
        C4.bgColor = "powderblue";
        C4.className=className;
        
        C5.borderWidth = "1px";
        C5.id = "EHours";
        C5.bgColor = "powderblue";
        C5.className=className;
        
        C6.borderWidth = "1px";
        C6.bgColor = "powderblue";
        C6.className=className;
        
        C7.borderWidth = "1px";
        C7.bgColor = "powderblue";
        C7.className=className;
  
        var me=count-1;

        C6.innerHTML = "<textarea name='desc' ID='desc' cols='20' rows='2'></textarea>";
        C7.innerHTML = "<input type='checkbox' name='check' ID='check'>"+"<input type='hidden' name='id' ID='id'>";    

        set();
    }
    
    function set(){
        var x=count-1;
        var code = document.getElementsByName('codeTask');
        var TDNAME = document.getElementById('codecell');
    
        if(nowMode=="name"){
            for(var i=0;i<lookAheadArray.length;i++){ 
                if(lookAheadArray[i]==TDNAME.value){
                    if(isFound(itemsCode[i])){
                        alert(" that item is exist already in the table");
                        count--;
                        document.getElementById('listTable').deleteRow(count+1);
                        
                        document.getElementById('nRows').value=count;
                        
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
                var job_size=arr[5];
                //var Eq_Type=arr[6];
                 
                alert(result);
                
                if(name==" ")
                    noCodeFound();
                else {
                    var pr=document.getElementsByName('codeTask');
                    var nam=document.getElementsByName('descEn');
                    var id=document.getElementsByName('id');
                    var hours=document.getElementsByName('EHours'); 
                    var jop=document.getElementsByName('trade');
                    var jopS=document.getElementsByName('jobSize');
                   // var EQT=document.getElementsByName('eqType');
                    
                    nam[nowRow].innerHTML = name;
                    pr[nowRow].innerHTML = desc;
                    id[nowRow].value=s;
                    //EQT[nowRow].innerHTML=Eq_Type;
                    jopS[nowRow].innerHTML=job_size;
                    hours[nowRow].innerHTML=hour;
                    jop[nowRow].innerHTML=trade;
                    
                    
                    
                }
            }
        }
    }
    
function isFound(x){
        var code=document.getElementsByName('codeTask');

        var temp1="";
        var temp2="";
        for(var i=0;i<count;i++){
            var t=code[i].innerHTML;
            t=t.replace(" ","");
            var z=x;
            temp1="";
            temp2="";
            for(n=0;n<t.length;n++){
                temp1+=t.charAt(n).charCodeAt();
            }
            for(c=0;c<z.length;c++){
                temp2+=z.charAt(c).charCodeAt();
            }

            if(temp1==temp2) 
                return true;
            }

        return false;
    }

    
    function isExecutedFound(x){
        var code=document.getElementsByName('executedCodeTask');

        for(i=0;i<document.getElementById('executedCon').value;i++){
            if(x == (code[i].innerHTML).replace(" ", "")){
                return true;
            }
        }
        
        return false;
    }
    
    function noCodeFound( ) {
        alert(" not found code");
        var tbl = document.getElementById('listTable');
        tbl.deleteRow(count+1);
        count=count-1;
        
        document.getElementById('nRows').value=count;
        
    }
    
    function Delete() {
        var tbl = document.getElementById('listTable');
        var check=document.getElementsByName('check');
        
        count=document.getElementById('nRows').value;
        
        for(var i=0;i<count;i++){
            if(check[i].checked==true){
                tbl.deleteRow(i+2);
                i--;
                count--;
                
                document.getElementById('nRows').value=count;
                
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
    
    function cancelForm(){    
        document.SCHDULE_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.SCHDULE_FORM.submit();  
    }
    
    function submitForm(){
        
        count=document.getElementById('nRows').value;
        
        if(count>0){
             if (!checkCodeTask()){
                alert ("Enter Task Code");
             } else if (!checkDescEn()){
                alert ("Enter English Description");
             } else {
                checkNotes();
                document.SCHDULE_FORM.action = "<%=context%>/IssueServlet?op=SaveTasks&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
                document.SCHDULE_FORM.submit();
              }
         }else{
            var r=confirm("Are You Sure You need to delete all Tasks")  
            if (r==true)
            {
                if (!checkCodeTask()){
                    alert ("Enter Task Code");
                } else if (!checkDescEn()){
                    alert ("Enter English Description");
                 } else {
                    checkNotes();
                    document.SCHDULE_FORM.action = "<%=context%>/IssueServlet?op=SaveTasks&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
                    document.SCHDULE_FORM.submit();
                }
            }else{
                alert("You must add at least one Task");
            }
        }
   }
    
    function checkCodeTask(){       
        if(document.getElementById('codeTask') != undefined){
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
        }
        
        return true;
    }
    
    function checkDescEn(){
        if(document.getElementById('descEn') != undefined){
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
                          </SCRIPT>

<script>
       <%--------------Popup window-------------------%> 
        function openWindowTasks(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
            }
        function getTasks()
            {
                var formName = document.getElementById('SCHDULE_FORM').getAttribute("name");
                var name = document.getElementById('taskName').value
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                count=document.getElementById('nRows').value;
                openWindowTasks('TaskServlet?op=listTasks&taskName='+res+'&formName='+formName+'&numRows='+count);
            }

         function getTasksByCode()
            {
                var formName = document.getElementById('SCHDULE_FORM').getAttribute("name");
                var name = document.getElementById('taskCode').value
                var res = ""
               for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                count=document.getElementById('nRows').value;
                openWindowTasks('TaskServlet?op=listTasksByCode&taskCode='+res+'&formName='+formName+'&numRows='+count);
               
            }
        <%---------------------------------%> 
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                  document.getElementById(name).style.display = 'block';
            }else {
                   document.getElementById(name).style.display = 'none';
            }
        }
        
</script>


<script src='silkworm_validate.js' type='text/javascript'></script>




<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Add / Update Maintenance Tasks</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
        <link rel="stylesheet" type="text/css" href="css/headers.css" />
    </head>
    
    <BODY>
        <CENTER>
        <FORM NAME="SCHDULE_FORM" METHOD="POST">
            
            <input type="hidden" name="nRows" id="nRows" value="<%=tasksVec.size()%>">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            
            <fieldset class="set">
                <legend align="center">
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="400">
                    <TR>
                        <TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" COLSPAN="2">
                            <B><%=JOData%></B>                   
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="tRow" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                            <b><%=JONumber%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                            <b><%=wboIssue.getAttribute("businessID").toString()%>/<%=wboIssue.getAttribute("businessIDbyDate").toString()%></b>                              
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="tRow" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                            <b><%=eqpName%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                            <b><%=wbounitSchedule.getAttribute("unitName").toString()%></b>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                
                <% 
                if(null!=status) {
                %>
                <%
                if(status.equalsIgnoreCase("ok")){
                    message  = M ;
                } else {
                    message = M2 ;
                }
                %>   
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="400">
                    <TR CLASS="bar">
                        <TD STYLE="text-align:center"class="td">
                            <B><FONT FACE="tahoma" color='red' size="3"><%=message%></FONT></B>
                        </TD>
                    </TR>
                </table>
                <br>
                <%
                }
                %>
                
                <table align="<%=align%>" border="0" width="93%">
                    <tr>
                        <td width="50%" STYLE="border:0px;">
                            <div STYLE="width:80%;border:2px solid gray;color:white;" class="header" align="<%=align%>">
                                <div ONCLICK="JavaScript: changeMode('menu1');" class="header" STYLE="width:100%;color:white;cursor:hand;font-size:16;">
                                    <b>
                                        <%=searchSubName%>
                                    </b>
                                    <img src="images/arrow_down.gif">
                                </div>
                                <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:block;text-align:right;border-top:2px solid gray;" ID="menu1">
                                    <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                        <tr>
                                            <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                                <button onclick="JavaScript:getTasks();" style="width:120"> <%=search%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>
                                            </td>
                                            <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                                <input type="text" name="taskName" id="taskName">
                                            </td>                                       
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    
                </table>
                <br>

                <table align="<%=align%>" border="0" width="93%">
                <tr>
                    <td width="50%" STYLE="border:0px;">
                        <div STYLE="width:80%;border:2px solid gray;color:white;" class="header" align="<%=align%>">
                            <div ONCLICK="JavaScript: changeMode('menu2');" class="header" STYLE="width:100%;color:white;cursor:hand;font-size:16;">
                                <b>
                                    <%=searchTitleCode%>
                                </b>
                                <img src="images/arrow_down.gif">
                            </div>
                            <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:block;text-align:right;border-top:2px solid gray;" ID="menu2">
                                <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                    <tr>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                            <button onclick="JavaScript:getTasksByCode();" style="width:120"> <%=search%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>
                                        </td>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                             <input type="text" name="taskCode" id="taskCode">
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            <br>
               <%-- 
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;">
                    <TR>
                        <TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16">
                            <B><%=updateItems%></B>                   
                        </TD>
                    </TR>
                </TABLE>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;">
                    <TR>
                        <TD CLASS="tRow" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('code');" checked><b><%=AddCode%></b>                   
                        </TD>
                        <TD CLASS="tRow" bgcolor="#99cccc" ROWSPAN="2" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ID="data">
                            <font size="2"><b><%=tit%></b></font>
                            <input type="text" dir="ltr" autocomplete="off" value="Auto Select Code" ONCLICK="JavaScript: f();" name="codecell" ID="codecell">
                        </TD>
                        <td CLASS="tRow" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ROWSPAN="2">
                            <input type="button" value=" <%=add%> " style="font-weight:bold;color:black;" ONCLICK="JavaScript: addNew();d();">
                        </td>
                    </TR>
                    <TR>
                        <TD CLASS="tRow" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('name');"><b><%=AddName%></b>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                --%>
                <table align="<%=align%>" border="0" width="95%">
                    <tr>
                        <td width="50%" STYLE="border:0px;">
                            <div STYLE="width:80%;border:2px solid gray;color:white;" class="header" align="<%=align%>">
                                <div ONCLICK="JavaScript: changeMode('menu3');" class="header" STYLE="width:100%;color:white;cursor:hand;font-size:16;">
                                    <b>
                                        <b><%=executedTableTitle%></b>
                                    </b>
                                    <img src="images/arrow_down.gif">
                                </div>
                                <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu3">
                                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="900" CELLPADDING="0" CELLSPACING="1" STYLE="border-width:1px;border-color:white">
                                        <TR>
                                            <TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                                                <b><%=TC%></b>
                                            </TD>
                                            <TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                                                <b><%=TN%></b>
                                            </TD>
                                            <TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="75">
                                                <b><%=TJ%></b>
                                            </TD>
                                            
                                            <!--TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="75">
                                                <b><%//=EqType%></b>
                                            </TD-->
                                           
                                            <TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="75">
                                                <b><%=TH%></b>
                                            </TD>
                                            <TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                                                <b><%=engDesc%></b>
                                            </TD>
                                            <TD CLASS="header" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                                                <b><%=TaskDesc%></b>
                                            </TD>
                                        </TR>
                                        
                                        <input type="hidden" name="executedCon" id="executedCon" value="<%=executedTasksVec.size()%>">
                                        <%if(executedTasksVec.size()>0){
                                        classStyle="tRow";
                                        %>
                                        
                                        <%
                                        for(int i=0;i<executedTasksVec.size();i++){
                                            WebBusinessObject web=( WebBusinessObject)executedTasksVec.get(i);
                                            WebBusinessObject webTasks = taskMgr.getOnSingleKey((String)web.getAttribute("codeTask"));
                                            WebBusinessObject webUnitType = unitMgr.getOnSingleKey((String)webTasks.getAttribute("parentUnit"));
                                            WebBusinessObject webIssue = issueMgr.getOnSingleKey(issueId);
                                            WebBusinessObject web2=taskMgr.getOnSingleKey((String)web.getAttribute("codeTask"));
                                            WebBusinessObject tradeWbo = tradeMgr.getOnSingleKey((String)web2.getAttribute("trade"));
                                            
                                            if((i%2)==1){
                                                classStyle="tRow";
                                            }else{
                                                classStyle="tRow2";
                                            }
                                        
                                        %>
                                        <TR>
                                            <TD CLASS="<%=classStyle%>" bgcolor="paleturquoise" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" ID="executedCodeTask">
                                                <%=(String)web2.getAttribute("title").toString().trim()%>
                                            </TD>
                                            <TD CLASS="<%=classStyle%>" bgcolor="paleturquoise" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white">
                                                <%=(String)web2.getAttribute("name")%>
                                            </TD>
                                            <TD CLASS="<%=classStyle%>" bgcolor="paleturquoise" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white">
                                                <%=tradeWbo.getAttribute("tradeName").toString()%>
                                            </TD>
                                            <!--TD CLASS="<%=classStyle%>" bgcolor="paleturquoise" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white">
                                                <%//=webUnitType.getAttribute("unitName").toString()%>
                                            </TD-->
            
                                            <TD CLASS="<%=classStyle%>" bgcolor="paleturquoise" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white">
                                                <%=(String)web2.getAttribute("executionHrs")%>
                                            </TD>
                                            
                                            <TD CLASS="<%=classStyle%>" bgcolor="paleturquoise" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white">
                                                <%if(web2.getAttribute("engDesc")!=null){%>
                                                <%=web2.getAttribute("engDesc").toString()%>
                                                <%}else{%>
                                                No Description
                                                <%}%>
                                            </TD>
                                            
                                            <TD CLASS="<%=classStyle%>" bgcolor="paleturquoise" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white">
                                                <textarea><%=(String)web.getAttribute("desc")%></textarea>
                                            </TD>
                                        </TR>
                                        <%
                                        }
                                        } else{
                                        %>
                                        <tr>
                                            <TD COLSPAN="8" CLASS="bar" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;color:blue">
                                                <b><%=noData%></b>
                                            </TD>
                                        </tr>
                                        <%}%>
                                    </TABLE>
                                </div>
                            </div>
                        </td>
                    </tr>
                    
                </table>
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" id="listTable" WIDTH="900" CELLPADDING="0" CELLSPACING="1" STYLE="border-width:1px;border-color:white">
                    <TR>
                        <TD CLASS="header" bgcolor="#99cccc" STYLE="text-align:center;font-size:18;color:white" COLSPAN="9">
                            <b><%=unexecTableTitle%></b>
                        </TD>    
                    </TR>
                    
                    <TR>
                        <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;color:black;border-width:1px;border-color:black" WIDTH="150">
                            <b><%=TC%></b>
                        </TD>
                        <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;color:black;border-width:1px;border-color:black" WIDTH="150">
                            <b><%=TN%></b>
                        </TD>
                        <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;color:black;border-width:1px;border-color:black" WIDTH="100">
                            <b><%=TJ%></b>
                        </TD>
                        
                        <!--TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;color:black;border-width:1px;border-color:black" WIDTH="100">
                            <b><%//=EqType%></b>
                        </TD-->
                        
                       
                        <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;color:black;border-width:1px;border-color:black" WIDTH="100">
                            <b><%=TH%></b>
                        </TD>
                        <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;color:black;border-width:1px;border-color:black" WIDTH="150">
                            <b><%=TaskDesc%></b>
                        </TD>
                        <TD CLASS="bar" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;color:black;border-width:1px;border-color:black" WIDTH="50">
                            <input type="button" value="<%=del%>" onclick="JavaScript: Delete()">
                        </TD>
                    </TR>
                    
                    <input type="hidden" name="con" id="con" value="<%=tasksVec.size()%>">
                    <%
                    for(int i=0;i<tasksVec.size();i++){
    classStyle="tRow";
                    %>
                    <%
                    WebBusinessObject web=( WebBusinessObject)tasksVec.get(i);
                    WebBusinessObject webTasks = taskMgr.getOnSingleKey((String)web.getAttribute("codeTask"));
                    WebBusinessObject webUnitType = unitMgr.getOnSingleKey((String)webTasks.getAttribute("parentUnit"));
                    WebBusinessObject webIssue = issueMgr.getOnSingleKey(issueId);
                    WebBusinessObject web2=taskMgr.getOnSingleKey((String)web.getAttribute("codeTask"));
                    WebBusinessObject tradeWbo = tradeMgr.getOnSingleKey((String)web2.getAttribute("trade"));
                    
                    if((i%2)==1){
                        classStyle="tRow";
                    }else{
                        classStyle="tRow2";
                    }
                    
                    %>
                    <TR>
                        <TD CLASS="<%=classStyle%>" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:black" ID="codeTask">
                            <%=(String)web2.getAttribute("title").toString().trim()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:black" ID="descEn">
                            <%=(String)web2.getAttribute("name")%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:black" ID="trade">
                            <%=tradeWbo.getAttribute("tradeName").toString()%>
                        </TD>
                        <!--TD CLASS="<%=classStyle%>" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:black" ID="eqType">
                            <%//=webUnitType.getAttribute("unitName").toString()%>
                        </TD-->
                        <%--<TD CLASS="<%=classStyle%>" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:black" ID="jobSize">
                            <%=webTasks.getAttribute("repairtype").toString()%>
                         </TD>--%>
                        
                        <TD CLASS="<%=classStyle%>" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:black" ID="EHours">
                            <% String timeDetails = null;
                                String exeHours = web2.getAttribute("executionHrs").toString();
                                Double execHr = 0.0;
                                int execIntHr = 0;
                                execHr = new Double(exeHours).doubleValue();
                                if(execHr<1){
                                    execHr =1.0;
                                    }
                                execIntHr = execHr.intValue();
                            timeDetails =dateAndTime.getDaysHourMinute(execIntHr);
                            %>
                            <%=timeDetails%>
                        </TD>
                        
                        
                        <TD CLASS="<%=classStyle%>" STYLE="text-align:center;font-size:14;border-width:1px;border-color:black">
                            <textarea cols="20" rows="2" name='desc' ID='desc'><%=(String)web.getAttribute("desc")%></textarea>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:black">
                            <input type='checkbox' name='check' ID='check'>
                            <input type='hidden' name='id' ID='id' value='<%=(String)web2.getAttribute("id")%>'>
                        </TD>
                    </TR>
                    <%}%>
                </TABLE>
                <br>
            </fieldset>
        </FORM>
    </BODY>
</html>