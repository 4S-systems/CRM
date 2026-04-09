<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr unitMgr  = MaintainableMgr.getInstance();
IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
TaskMgr taskMgr = TaskMgr.getInstance();

String context = metaMgr.getContext();

String status = (String) request.getAttribute("Status");
String issueId = (String) request.getAttribute("issueId");
String filterName = request.getParameter("filterName");
String filterValue = request.getParameter("filterValue");
String message;

String cMode= (String) request.getSession().getAttribute("currentMode");
String stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,AllRequired, BackToList,save, AddCode,AddName,saving,TC,TN,TH,TJ,M,M2,tit,add,del,title,scr,search,updateItems,TaskDesc;

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
    TH="Execution Hours";
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
    TH="&#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1607;";
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
        init("codecell");
     
        var pr=document.getElementsByName('con');
        count=pr[0].value;
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
        var dd=document.getElementById('codecell');
        dd.value="";
    }
    
    function d(){
        var dd=document.getElementById('codecell');
        dd.value="Auto Select Code";
    }
    
    function addNew(){
        var TDName=document.getElementsByName('codecell');
     
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
        
        //C4.borderWidth = "1px";
        //C4.id = "EHours";
       // C4.bgColor = "powderblue";
        
        C4.borderWidth = "1px";
        C4.bgColor = "powderblue";
        
        C5.borderWidth = "1px";
        C5.bgColor = "powderblue";
        
        var me=count-1;

        C4.innerHTML = "<INPUT TYPE='text' name='desc' ID='desc' SIZE='35'>";
        C5.innerHTML = "<input type='checkbox' name='check' ID='check'>"+"<input type='hidden' name='id' ID='id'>"+"<input type='hidden' name='EHours' ID='EHours' value='0'>";    

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
               // var hour=arr[3];
                var trade=arr[4];
          
                if(name==" ")
                    noCodeFound();
                else {
                    var pr=document.getElementsByName('codeTask');
                    var nam=document.getElementsByName('descEn');
                    var id=document.getElementsByName('id');
                   // var hours=document.getElementsByName('EHours'); 
                    var jop=document.getElementsByName('trade'); 
                    
                    nam[nowRow].innerHTML = name;
                    pr[nowRow].innerHTML = desc;
                    id[nowRow].value=s;
                    //hours[nowRow].innerHTML=hour;
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
    
    function cancelForm(){    
        document.SCHDULE_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.SCHDULE_FORM.submit();  
    }
    
    function submitForm(){  
         if(count==0){
             alert("you can't submit that form with out select at least one task Code ");
         return;
         }
         
         if (!checkCodeTask()){
             alert ("Enter Task Code");
         } else if (!checkDescEn()){
             alert ("Enter English Description");
         } else {
             checkNotes();
             document.SCHDULE_FORM.action = "<%=context%>/IssueServlet?op=SaveTasks&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
             document.SCHDULE_FORM.submit();
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
</SCRIPT>
<script src='silkworm_validate.js' type='text/javascript'></script>




<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Add / Update Maintenance Tasks</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    </head>
    
    <BODY>
        <CENTER>
        <FORM NAME="SCHDULE_FORM" METHOD="POST">
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
                
                <% 
                if(null!=status) {
    if(status.equalsIgnoreCase("ok")){
        message  = M ;
    } else {
        message = M2 ;
    }
                %>   
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="650">
                    <TR BGCOLOR="#FFE391">
                        <TD STYLE="text-align:center"class="td">
                            <B><FONT FACE="tahoma" color='red'><%=message%></FONT></B>
                        </TD>
                    </TR>
                </table>
                <%
                }
                %>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;">
                    <TR>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16">
                            <B><%=updateItems%></B>                   
                        </TD>
                    </TR>
                </TABLE>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;">
                    <TR>
                        <TD CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('code');" checked><b><%=AddCode%></b>                   
                        </TD>
                        <TD CLASS="cell" bgcolor="#99cccc" ROWSPAN="2" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ID="data">
                            <font size="2"><b><%=tit%></b></font>
                            <input type="text" dir="ltr" autocomplete="off" value="Auto Select Code" ONCLICK="JavaScript: f();" name="codecell" ID="codecell">
                        </TD>
                        <td CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ROWSPAN="2">
                            <input class="head" type="button" value=" <%=add%> "  ONCLICK="JavaScript: addNew();d();">
                        </td>
                    </TR>
                    <TR>
                        <TD CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('name');"><b><%=AddName%></b>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" id="listTable" WIDTH="900" CELLPADDING="0" CELLSPACING="1" STYLE="border-width:1px;border-color:white">
                    <TR>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="75">
                            <b><%=TC%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                            <b><%=TN%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="150">
                            <b><%=TJ%></b>
                        </TD>
                        <!--TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="125">
                            <b><%//=TH%></b>
                        </TD-->
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="250">
                            <b><%=TaskDesc%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="50">
                            <input type="button" CLASS="head" value="<%=del%>" onclick="JavaScript: Delete()">
                        </TD>
                    </TR>
                    
                    <%
                    Vector items = issueTasksMgr.getOnArbitraryKey(issueId,"key1");
                    %>
                    <input type="hidden" name="con" id="con" value="<%=items.size()%>">
                    <%
                    for(int i=0;i<items.size();i++){
                        WebBusinessObject web=( WebBusinessObject)items.get(i);
                        WebBusinessObject web2=taskMgr.getOnSingleKey((String)web.getAttribute("codeTask"));
                        WebBusinessObject tradeWbo = tradeMgr.getOnSingleKey((String)web2.getAttribute("trade"));
                    %>
                    <TR>
                        <TD ID="codeTask">
                            <%=(String)web2.getAttribute("title").toString().trim()%>
                        </TD>
                        <TD ID="descEn">
                            <%=(String)web2.getAttribute("name")%>
                        </TD>
                        <TD ID="trade">
                            <%=tradeWbo.getAttribute("tradeName").toString()%>
                        </TD>
                        <!--TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" ID="EHours">
                            <%//=(String)web2.getAttribute("executionHrs")%>
                        </TD-->
                        <TD>
                            <INPUT TYPE="text" name='desc' ID='desc' VALUE="<%=(String)web.getAttribute("desc")%>" SIZE="35">
                        </TD>
                        <TD>
                            <input type='checkbox' name='check' ID='check'>
                            <input type='hidden' name='id' ID='id' value='<%=(String)web2.getAttribute("id")%>'>
                            <input type='hidden' name='EHours' ID='EHours' value='<%=(String)web2.getAttribute("executionHrs")%>'>
                        </TD>
                    </TR>
                    <%}%>
                </TABLE>
                <br>
            </fieldset>
        </FORM>
    </BODY>
</html>