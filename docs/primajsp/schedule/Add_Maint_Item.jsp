<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<html>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="0">
<head>
    <title>Create New Schedule</title>
    <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</head>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr unitMgr  = MaintainableMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();

String context = metaMgr.getContext();

String message;
String schId = (String) request.getAttribute("schId");
int lessPrio=0;

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,AllRequired,pri, BackToList,save, AddCode,AddName,saving,TC,TN,TH,TJ,TaskDesc,M,M2,tit,add,del,title,scr,search;
String CancelForm=context+"/ScheduleServlet?op=CancelBindMaintanbleItems&schId="+schId;
if(session.getAttribute("urlBackToView")!=null)
    CancelForm=context+"/ScheduleServlet?"+(String)session.getAttribute("urlBackToView");
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    BackToList = "Cancel";
    save = "    Save   ";
    AllRequired="(*) All Data Must Be Filled";
    TC="Maintenance Item Code";
    TN="Maintenance Item  Name";
    TH="Estimated Time";
    TJ="Trade";
    TaskDesc="Description";
    M="Data Had Been Saved Successfully";
    M2="Saving Failed ";
    tit="Maintenance Item ";
    add="Add";
    del="delete";
    pri="order";
    
    title="Add Maintenance Item";
    scr="images/arrow1.swf";
    search="Auto Search";
    AddCode="Add using Part Code";
    AddName="Add using Part Name";
    
}else{
    
    align="center";
    dir="RTL";
    style="text-align:right";
    lang="   English    ";
    langCode="En";
    pri="&#1575;&#1604;&#1578;&#1585;&#1578;&#1610;&#1576;";
    AddCode="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
    AddName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
    BackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    save = " &#1585;&#1576;&#1591; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; ";
    AllRequired=" &#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
    TC="&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    TN="&#1573;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
    TH="&#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1607;";
    TJ="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    TaskDesc="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    M="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
    M2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    tit="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    add="&#1571;&#1590;&#1601;";
    del="&#1581;&#1584;&#1601;";
    title="&#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; ";
    scr="images/arrow2.swf";
    search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
}

WebBusinessObject wboTrade = new WebBusinessObject();

%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    var count = 0;
    var itemsCode;
    var itemNames;
    var nowMode="code";
    var priorty=0;
    function submitForm(){   
        if(count==0){
            alert("you can't submit that form with out select at least one task Code ");
        return;
        }
        if (!checkCodeTask()){
            alert ("Enter Task Code");
        } else if (!checkDescEn()){
            alert ("Enter English Description");
        //} else if (!checkDescAr()){
        //    alert ("Enter Arabic Description");
        } else {
            document.SCHDULE_FORM.action = "<%=context%>/ScheduleServlet?op=BindMaintanbleItems&schId=<%=schId%>";
            document.SCHDULE_FORM.submit();
        }
    }
    
    function checkCodeTask(){
        if(this.SCHDULE_FORM.codeTask.value != ""){
            var codeTasks = this.SCHDULE_FORM.codeTask;
            for(i = 0; i < codeTasks.length; i++){
                if(codeTasks[i].value == ""){
                    codeTasks[i].focus();
                    return false;
                }
            }
        } else if(this.SCHDULE_FORM.codeTask.value == ""){
            this.SCHDULE_FORM.codeTask.focus();
            return false;
        }
        return true;
    }
    
    function checkDescEn(){
        if(this.SCHDULE_FORM.descEn.value != ""){
            var descEns = this.SCHDULE_FORM.descEn;
            for(i = 0; i < descEns.length; i++){
                if(descEns[i].value == ""){
                    descEns[i].focus();
                    return false;
                }
            }
        } else if(this.SCHDULE_FORM.descEn.value == ""){
            this.SCHDULE_FORM.descEn.focus();
            return false;
        }
        return true;
    }
    
    function checkDescAr(){
        if(this.SCHDULE_FORM.descAr.value != ""){
            var descArs = this.SCHDULE_FORM.descAr;
            for(i = 0; i < descArs.length; i++){
                if(descArs[i].value == ""){
                    descArs[i].focus();
                    return false;
                }
            }
        } else if(this.SCHDULE_FORM.descAr.value == ""){
            this.SCHDULE_FORM.descAr.focus();
            return false;
        }
        return true;
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
        checNumeric();
      }
      
      function noCodeFound( ) {

         alert(" not found code");
           var tbl = document.getElementById('listTable');
           tbl.deleteRow(count--);
       }
    
      function isFound(x){
        var code=document.getElementsByName('codeTask');
        for(var i=0;i<count;i++){
            if(x==code[i].value)
                return true;
        }
        return false;
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
        var C7 = x.insertCell(6);
        var C8 = x.insertCell(7);
       
        
        C1.borderWidth = "1px";
        C2.borderWidth = "1px";
     
        C4.borderWidth = "1px";
        C5.borderWidth = "1px";
        C6.borderWidth = "1px";
        C7.borderWidth = "1px";
        C8.borderWidth = "1px";
        
        var me=count-1;
        
        
        C1.innerHTML = "<input   type='hidden' name='id' ID='id'>";
        C2.innerHTML = "<input  readonly size=12 type='text' name='codeTask' ID='codeTask'>";
       C3.innerHTML = "<input  readonly size=12 type='text' name='descEn' ID='descEn'>";
      
        C4.innerHTML ="<input  readonly size=20 type='text' name='Jop' ID='Jop' >";
        
        C5.innerHTML =  "<textarea    name='desc' ID='desc' cols='40' rows='2'></textarea>";
        C6.innerHTML =  "<input  type='text' size=2   name='priority' ID='priority'  onblur='checkNum(this);' >";
        C7.innerHTML = "<input type='checkbox' name='check' ID='check'>";
       C8.innerHTML =  "<input  type='hidden' name='EHours' ID='EHours' value='0' >";
               set();
        
    }
    
    function checkNum(x){
    
        if(x.value*1 > priorty*1+1){
            alert("order  "+x.value+"must be between 1 and "+(priorty*1+1));
                x.value=priorty;
                return;
            }
            if(x.value*1 > priorty*1)
                priorty=x.value;

    }
    function getPri(){
    
        return priorty;
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
         

      code[x].value= TDNAME.value;
     
      TDNAME.value="";
      nowRow=x;
       
     var url = "<%=context%>/TaskServlet?op=code&value="+code[x].value;
    if (window.XMLHttpRequest) {
        req = new XMLHttpRequest( );
    }
    else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }
    req.open("Get",url,true);
    req.onreadystatechange = callback;
    req.send(null);
   
    
    }
    
    function callback( ) {
  if (req.readyState==4) {
        if (req.status == 200) {
       
          var result= req.responseText;
          
          var arr=result.split('!=');
          var name=arr[1];
          var desc=arr[0];
          var s=arr[2];
          var hour=arr[3];
          var Jop=arr[4];
          
          if(name==" ")
             noCodeFound();
          
          else {
          
           var pr=document.getElementsByName('codeTask');
           var nam=document.getElementsByName('descEn');
           var id=document.getElementsByName('id');
           var hours=document.getElementsByName('EHours'); 
           var jop=document.getElementsByName('Jop'); 
           var pri=document.getElementsByName('priority'); 
           nam[nowRow].value = name;
           pr[nowRow].value = desc;
           id[nowRow].value=s;
          hours[nowRow].value=hour;
          jop[nowRow].value=Jop;
          pri[nowRow].value=getPri();
         
          }
        }
    }

}
    function IsNumeric(sText)
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;

 
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
    
    
    
    window.onload = function () {
          init("codecell");
           var pr=document.getElementsByName('con');
           count=pr[0].value;
           var temp=document.getElementsByName('lessPrio');
        priorty=temp[0].value;
        }
   
    
        var lookAheadArray = null;
        var suggestionDiv = null;
        var cursor;
        var inputTextField;
        var debugPane = null;
        var urlbase = '<%=context%>'; 

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
            suggestionDiv.onmouseup = function() 
            {
                inputTextField.focus();
            }
            suggestionDiv.onmouseover = function(inputEvent) 
            {
                inputEvent = inputEvent || window.event;
                sugTarget = inputEvent.target || inputEvent.srcElement;
                highlightSuggestion(sugTarget);
            }
            suggestionDiv.onmousedown = function(inputEvent) 
            {
                inputEvent = inputEvent || window.event;
                sugTarget = inputEvent.target || inputEvent.srcElement;
                inputTextField.value = sugTarget.firstChild.nodeValue;
                lookupUsername(inputTextField.value);
                hideSuggestions();
            }
            document.body.appendChild(suggestionDiv);
        }

        function keyDownHandler(inEvent ){

            switch(inEvent.keyCode) {
                /* up arrow */
                case 38: 
                    if (suggestionDiv.childNodes.length > 0 && cursor > 0) 
                    {
                        var highlightNode = suggestionDiv.childNodes[--cursor];
                        highlightSuggestion(highlightNode);
                           inputTextField.value = highlightNode.firstChild.nodeValue;   
                    }
                break;
                /* Down arrow */
                case 40: 
                     if (suggestionDiv.childNodes.length > 0 && cursor < suggestionDiv.childNodes.length-1) 
                     {
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

            if (iKeyCode == 32 || iKeyCode == 8 || ( 45 < iKeyCode && iKeyCode < 112) || iKeyCode > 123) /*keys to consider*/
            {
                if (enteredText.length > 0){
                    for (var i=0; i < lookAheadArray.length; i++) { 
                        if (lookAheadArray[i].indexOf(enteredText) == 0) 
                        {
                            potentials.push(lookAheadArray[i]);

                        } 
                    }
                        showSuggestions(potentials);
                }
                if (potentials.length > 0) 
                {
                    if (iKeyCode != 46 && iKeyCode != 8) 
                    {
                        typeAhead(potentials[0]);
                    }
                    showSuggestions(potentials);
                } 
                else 
                {
                    hideSuggestions();
                   }
            }
        }

        function hideSuggestions () 
        {
            suggestionDiv.style.visibility = "hidden";
        }

        function highlightSuggestion(suggestionNode) 
        {
            for (var i=0; i < suggestionDiv.childNodes.length; i++) 
            {
                var sNode = suggestionDiv.childNodes[i];
                if (sNode == suggestionNode) 
                {
                    sNode.className = "current"
                } 
                else if (sNode.className == "current") 
                {
                    sNode.className = "";
                }
            }
        }

        function init (field) 
        {
           inputTextField = document.getElementById(field);
           cursor = -1;
            fillArrayWithAllUsernames();
            inputTextField.onkeyup = function (inEvent) 
            {

                if (!inEvent) 
                {
                    inEvent = window.event;
                }    
                keyUpHandler(inEvent);
            }

            inputTextField.onkeydown = function (inEvent) 
            {
                if (!inEvent) 
                {
                    inEvent = window.event;
                }    
                keyDownHandler(inEvent);
            }
            inputTextField.onblur = function () 
            {
                hideSuggestions();
            }

            createDiv();
        }

        function selectRange(start , end ) 
        {
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

        function showSuggestions(suggestions) 
        {
            var sDiv = null;
            
            suggestionDiv.innerHTML = "";  

            for (i=0; i < suggestions.length; i++) 
            {
            
                sDiv = document.createElement("div");
                sDiv.appendChild(document.createTextNode(suggestions[i]));
                suggestionDiv.appendChild(sDiv);
            }

            suggestionDiv.style.top = (210+inputTextField.offsetTop+inputTextField.offsetHeight+document.getElementById("code").offsetTop+document.getElementById("data").offsetTop) + "px";
            suggestionDiv.style.left = (10+inputTextField.offsetLeft+document.getElementById("code").offsetLeft+document.getElementById("data").offsetLeft) + "px";
            suggestionDiv.style.visibility = "visible";
        }


        function typeAhead(suggestion) 
        {
            if (inputTextField.createTextRange || inputTextField.setSelectionRange)
            {
                var iLen = inputTextField.value.length; 
                inputTextField.value = suggestion; 
                selectRange(iLen, suggestion.length);
            }
        }

        function fillArrayWithAllUsernames()
        { 
           var url = "<%=context%>/TaskServlet?op=list";
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFilltaskcode;
            req.send(null);
        } 


        function callbackFilltaskcode()
        { 
            if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                
                   var result= req.responseText;
                 var arr=result.split('&#');
                
                 itemsCode=arr[0].split('!=');
                 lookAheadArray =itemsCode;
                 itemNames= arr[1].split('!=');
                 nowMode="code";
              
                } 
               } 
        } 
    function f()
    {
       var dd=document.getElementById('codecell');
 
       dd.value="";
    }
    function d()
    {
    var dd=document.getElementById('codecell');
       dd.value="Auto Select Code";
       }
    function reloadAE(nextMode){
      
       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFillreload;
            req.send(null);
      
      }

       function callbackFillreload(){
         if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                     window.location.reload();
                }
            }
       }
       
        function mod(mode){
        if(mode=="code"){
          lookAheadArray =itemsCode;
          nowMode="code";
          }
          else{
            lookAheadArray =itemNames;
            nowMode="name";
            }
            
      
      } 
      
   function cancelForm()
        {    
       
        window.navigate("<%=CancelForm%>");
        }
                                   </SCRIPT>
<script src='silkworm_validate.js' type='text/javascript'></script>


<link rel="stylesheet" type="text/css" href="autosuggest.css" />


<BODY>

<FORM NAME="SCHDULE_FORM" METHOD="POST">
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
    <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
</DIV> 

<fieldset >
<legend align="center">
    
    <table dir=" <%=dir%>" align="<%=align%>">
        <tr>
            <td class="td">
                <font color="blue" size="6">  <%=title%>
                </font>
            </td>
        </tr>
        
    </table>
</legend >

<br><br><br>

<TABLE ALIGN="<%=align%>" DIR="<%=dir%>" border="0" ID="code">

<tr>
    <td class="head" ><input type="radio" name="SelectOption" onClick="mod('code');"checked><b>&nbsp;&nbsp;<%=AddCode%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
    <td class="head"><input type="radio" name="SelectOption" onClick="mod('name');"><b>&nbsp;&nbsp;<%=AddName%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
</tr>
<tr>
<TD CLASS="head"  > <%=tit%> <b> <font size="3"></font></b></TD> 

<TD CLASS="head"  COLSPAN="1" id="data">
    <input type="text" dir="ltr"  class="head" autocomplete="off" value="Auto Select Code" ONCLICK="JavaScript: f();"  name="codecell" ID="codecell">
</TD>
<TD colspan="1" CLASS="head"  WIDTH="15%">
    <b>   <input class="head" type="button" value=" <%=add%> "  ONCLICK="JavaScript: addNew();"></b> </input>
</TD>

<TD CLASS="td">
    <embed src="<%=scr%>" quality="high" bgcolor="#ffffff" width="90" height="25" name="arrow2" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash"/>
</TD>
<TD CLASS="td" COLSPAN="2"  STYLE="<%=style%>">
    <%=search%>
</TD>
</tr>
</table>
<br><br>


<TABLE ALIGN="<%=align%>" DIR="<%=dir%>"  border="0"   ID="listTable">
    
    <TR>
        <td></td>
        <TD CLASS="head"  > <b><%=TC%></b></TD>
        <TD CLASS="head" ><b><%=TN%> </b></TD>        
        <TD CLASS="head" ><b><%=TJ%> </b></TD>
        <!--TD CLASS="head" ><b><%=TH%> </b></TD-->
        <TD CLASS="head" ><b><%=TaskDesc%> </b></TD>
        <TD CLASS="head" ><b><%=pri%> </b></TD>
        
        <TD  WIDTH=5% CLASS="head" >
            <input type="button" CLASS="head" value=" <%=del%> " onclick="JavaScript: Delete()">
        </TD>
        
        <%
        ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
        TaskMgr taskMgr=TaskMgr.getInstance();
        Vector items= scheduleTasksMgr.getOnArbitraryKey(schId,"key1");
        %>
        <td>
            <input type="hidden" name="con" id="con" value="<%=items.size()%>">
        </td>
    </TR>
    <%
    for(int i=0;i<items.size();i++){
            WebBusinessObject web=( WebBusinessObject)items.get(i);
            
            WebBusinessObject web2=taskMgr.getOnSingleKey((String)web.getAttribute("codeTask"));
            if(Integer.parseInt((String)web.getAttribute("priority"))>lessPrio)
                lessPrio=Integer.parseInt((String)web.getAttribute("priority"));
            wboTrade = tradeMgr.getOnSingleKey((String)web2.getAttribute("trade").toString());
    %>
    <tr>
        <td><input   type='hidden' name='id' ID='id' value='<%=(String)web2.getAttribute("id")%>'></td>
        <td><input  readonly size=12 type='text' name='codeTask' ID='codeTask' value='<%=(String)web2.getAttribute("title")%>'></td>
        <td><input  readonly size=12 type='text' name='descEn' ID='descEn' value='<%=(String)web2.getAttribute("name")%>'></td>
        
        <td><input  readonly size=20 type='text' name='Jop' ID='Jop' value='<%=(String)wboTrade.getAttribute("tradeName")%>'></td>
        <!--td--><input  type='hidden' name='EHours' ID='EHours' value='0'><!--/td-->
        <td><textarea    name='desc' ID='desc' cols='40' rows='2'><%=(String)web.getAttribute("desc")%></textarea></td>
        <td><input  type='text' size=2   name='priority' ID='priority' value='<%=(String)web.getAttribute("priority")%>' onblur="checkNum(this);"><t/d>
        <td><input type='checkbox' name='check' ID='check'></td>
    </tr>
    <%}%>
    <input type="hidden" name="lessPrio" id="lessPrio" value="<%=lessPrio%>">
</TABLE>
</FORM>
</BODY>
</html>