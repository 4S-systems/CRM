<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.MaintainableMgr;"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();

ArrayList equipments=(ArrayList)request.getAttribute("data");
String status=(String)request.getAttribute("status");

WebBusinessObject wbo = null;
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;
String eqName,name, modelNo,serialNo,subTitle,enginNo,manufacturer,typeOfRate,desc,eqStatus,title,save_button_label,cancel_button_label,typeOfOperation,noOfHours;
String sTitle, sCancel, sOk, sSearchTitle, sSearchStatus, AddCode, AddName,tit,alert;
if(stat.equals("En")){
    
    align="Left";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    sTitle="Equipment Status Report";
    sCancel="Cancel";
    sOk="Generate Report";
    langCode="Ar";
    AddCode="Select by Number";
    AddName="Select by Name";
    tit="Select Equipment";
    sSearchTitle = "Select by Number";
    sSearchStatus = "There is no equipment with this number";
    alert="You Must Select Vaild Equipment";
}else{
    
    align="Right";
    dir="LTR";
    langCode = "En";
    style="text-align:right";
    lang="English";
    sTitle = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1581;&#1575;&#1604;&#1607; &#1605;&#1593;&#1583;&#1607;";
    sCancel = tGuide.getMessage("cancel");
    sOk="&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
    langCode="En";
    AddCode="&#1575;&#1582;&#1578;&#1610;&#1575;&#1585; &nbsp;&#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
    AddName="&#1575;&#1582;&#1578;&#1610;&#1575;&#1585; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
    sSearchTitle = "&#1575;&#1582;&#1578;&#1610;&#1575;&#1585; &nbsp;&#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
    tit="&#1575;&#1582;&#1578;&#1585; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    sSearchStatus = "&#1605;&#1593;&#1583;&#1607; &#1576;&#1607;&#1584;&#1575; &#1575;&#1604;&#1585;&#1602;&#1605; &#1594;&#1610;&#1585; &#1605;&#1608;&#1580;&#1608;&#1583;&#1607;";
    alert="&#1605;&#1606; &#1601;&#1590;&#1604;&#1603; &#1575;&#1582;&#1578;&#1585; &#1605;&#1593;&#1583;&#1607; &#1605;&#1608;&#1580;&#1608;&#1583;&#1607;";
    
}
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>
    
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
        init("equipmentId");
     
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
        var url = "<%=context%>/TaskServlet?op=listEq";
        
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
        var dd=document.getElementById('equipmentId');
        dd.value="";
    }
    
    function d(){
        var dd=document.getElementById('equipmentId');
        dd.value="Auto Select Code";
    }
    
    function addNew(){
        var TDName=document.getElementsByName('equipmentId');
     
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
        var TDNAME = document.getElementById('equipmentId');
    
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
        if(document.getElementById('equipmentId').value==""||document.getElementById('equipmentId').value=="Auto Select Code"){
            alert("You Must Select Or write code or name of Equipment");
            document.getElementById('equipmentId').focus()
            document.getElementById('equipmentId').value=""
        }else{
            if(nowMode=="name"){
            var name=document.getElementById('equipmentId').value;
            for(var i=0;i<lookAheadArray.length;i++){ 
                if(lookAheadArray[i]==name){
                        document.getElementById('equipmentId').value=itemsCode[i];
                        break;
                        }
                    }
                }

               document.USERS_FORM.action = "<%=context%>/EquipmentServlet?op=eqStatusReport";
               document.USERS_FORM.submit();
           }
        }
        function checkKey(e){
            if(e.keyCode == 13){
                submitForm();
            }
        }
        
         function cancelForm()
        {    
           document.USERS_FORM.action = "main.jsp";
            document.USERS_FORM.submit();
        }
    
                                       </SCRIPT>
    
    
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="USERS_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>
            <button  onclick="JavaScript: submitForm();" class="button"><%=sOk%> <IMG HEIGHT="15" SRC="images/search.gif"></button>
            <BR>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                <%if(status!=null){%>
                <center>
                    <font color="red" size="4">
                        <%=alert%>
                    </font>
                </center>
                <br>
                <%}%>
                
                <TABLE ALIGN="CENTER" DIR="<%=dir%>" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;">
                    
                    <TR>
                        <TD CLASS="cell" ALIGN="<%=align%>" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('name');"><b><%=AddName%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99cccc" ROWSPAN="2" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ID="data">
                            <font size="2"><b><%=tit%></b></font>
                            <input type="text" dir="ltr" autocomplete="off" value="Auto Select Code" onkeydown="JavaScript: checkKey(event);" ONCLICK="JavaScript: f();" id="equipmentId" name="equipmentId">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD CLASS="cell" ALIGN="<%=align%>" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('code');" checked><b><%=AddCode%></b>                   
                        </TD>
                        
                    </TR>
                    
                </TABLE>
                
                
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class="td">
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
            </FIELDSET>
            
        </FORM>
    </BODY>
    
</HTML>     
