<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.business_objects.*,com.tracker.common.*, java.util.*"%>
<%@ page import="com.tracker.common.AppConstants,com.maintenance.db_access.*,java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>DebugTracker-add new Schedule</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
</HEAD>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
// tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");

String context= metaMgr.getContext();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;

String align=null;
String dir=null;
String style=null;
String endTask,lang,cancel,langCode,BackToList,save,AllRequired,title,Fcode,CauseDes,TakenAction,prevention,actualTime;
String search,AddCode,add,AddName,addNew,tCost,code,name,price,count,cost,Mynote,del,scr, sOnLine, sHour;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    add="   Add   ";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    endTask = "Task Clouser";
    BackToList = "Back to list";
    save = " Save ";
    AllRequired="(*) All data must be filled";
    title="Schedule title";
    Fcode="Failure code";
    CauseDes="Cause description";
    TakenAction="Action taken";
    prevention="Prevention should be taken ";
    search="Auto search";
    actualTime="Actual finish time";
    AddCode="Add using Part Code";
    AddName="Add using Part Name";
    addNew="Add new part";
    tCost="Total cost  ";
    code="Code";
    name="Name";
    price="Price";
    count="countity";
    cost="Total Price";
    Mynote="Note";
    del="Delete";
    scr="images/arrow1.swf";
    sOnLine = "On Line";
    sHour = "Hour(s)";
}else{
    add="  &#1571;&#1590;&#1601;  ";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    endTask =  " &#1573;&#1606;&#1607;&#1575;&#1569; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; ";
    AllRequired=" &#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
    title="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    Fcode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604; ";
    CauseDes="&#1608;&#1589;&#1601; &#1575;&#1604;&#1587;&#1576;&#1576;";
    TakenAction="&#1591;&#1585;&#1610;&#1602;&#1607; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;";
    prevention="&#1603;&#1610;&#1601;&#1610;&#1607; &#1575;&#1604;&#1581;&#1605;&#1575;&#1610;&#1607; ";
    actualTime="&#1608;&#1602;&#1578; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
    search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
    AddCode="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
    AddName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
    addNew="  &#1571;&#1590;&#1601; &#1602;&#1591;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1607; ";
    tCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;   ";
    code="&#1575;&#1604;&#1603;&#1608;&#1583;";
    name="&#1575;&#1604;&#1573;&#1587;&#1605;";
    price="&#1575;&#1604;&#1587;&#1593;&#1585; ";
    count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
    cost=" &#1575;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
    Mynote="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    del="&#1581;&#1584;&#1601; ";
    scr="images/arrow2.swf";
    sOnLine = "&#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1577;";
    sHour = "&#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1577;";
}

UserMgr userMgr = UserMgr.getInstance();
String issueId = (String) request.getAttribute("issueId");
String issueTitle = (String) request.getAttribute("issueTitle");
String direction = (String) request.getAttribute(AppConstants.DIRECTION);
//StatusProjectList
String filterName = (String) request.getAttribute("filterName");
String filterValue = (String) request.getAttribute("filterValue");
String projectname = (String) request.getParameter("projectName");
System.out.println(projectname+"amr07");
//AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");


int indx1, indx2;
indx1 = indx2 = 10;
for(int i=0;i<filterValue.length(); i++) {
    char ch = filterValue.charAt(i);
    
    
    
    if(ch == '>') {
        indx1 = i;
        System.out.println(i+" lolo");
    }
    if(ch == '<') {
        indx2 = i;
        System.out.println(i+" lolo");
        String temp = filterValue.substring(indx1+1, indx2);
        projectname = temp;
        
    }
    
}


System.out.println("Rashad hihi");


String attName = null;
String attValue = null;

FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
MaintenanceItemMgr itemMgr = MaintenanceItemMgr.getInstance();
WebBusinessObject wboItem = null;
String scheduleID = (String) request.getAttribute("scheduleID");

// get current date
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());

Vector items = (Vector) request.getAttribute("items");
Vector quantifiedItems = (Vector) request.getAttribute("quantifiedItems");
WebBusinessObject wbo = null;

WebBusinessObject wboIssue = IssueMgr.getInstance().getOnSingleKey(issueId);

WebBusinessObject wboFcode = failureCodeMgr.getOnSingleKey(wboIssue.getAttribute("failureCode").toString());
String failureCode = wboFcode.getAttribute("title").toString();
String addToURL="";
if(request.getAttribute("case")!=null){
    addToURL="&title="+(String)request.getAttribute("title")+"&unitName="+(String)request.getAttribute("unitName");
    filterName="StatusProjctListTitle";
}
String CancelForm="op="+filterName+"&filterValue="+filterValue+"&projectName="+projectname;
CancelForm+=addToURL;
CancelForm=CancelForm.replace(' ','+');
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
   var count=0;
        function submitForm()
        {
        
         var q=document.getElementsByName('qun');
     
      for(var x=0;x<count;x++){
     
      var check=q[x].value;
      if(check == "0" || check=="" ){
            alert("enter the quantity more than zero or delete the un used row");
            return;
      }
     
      }
         if ( !isNaN (this.ISSUE_FORM.actual_finish_time.value)&& this.ISSUE_FORM.actual_finish_time.value != "")
          {
          <%filterName="SaveStatus";%>
          
      document.ISSUE_FORM.action = "<%=context%>/ProgressingIssueServlet?op=saveStatus&filterValue=<%=filterValue%>&projectName=<%=projectname%>";
          document.ISSUE_FORM.submit(); 
          }
         else
          {
          alert ("Enter A numeric Value In The actual_finish_time Field ")
          }
        }
        
 
    function checNumeric() {
   
      var q=document.getElementsByName('qun');
      var c=document.getElementsByName('cost');
      var p=document.getElementsByName('price');
     
      var total=0.0;
      for(var x=0;x<count;x++){
       
      var price=p[x].value;
      var check=q[x].value;
      
      if(IsNumeric(check)){
            total+=check*price;
            c[x].value=check*price;
      }
      else {
      q[x].value="0";
      c[x].value="0.0";
      }
      
      }  
           var tot = document.getElementById('totale');
           
           tot.value = total.toFixed(2);;
           
       
       }
        
       function IsNumeric(sText)   {
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
       
   
    
    function isFound(x){
    var code=document.getElementsByName('code');
    for(var i=0;i<count;i++){
   
    if(x==code[i].value) return true;
    }
    return false;
    }
      
  
    
    
     function addNew(){
      
     
     var TDName=document.getElementsByName('TDName');
     if(TDName[0].value==""){
     alert("please fill the name field frist ");
     return;
     }
     
       if(isFound(TDName[0].value)){
     alert(" that item is exist already in the table");
     return;
     }
  
        count++;     
        var x = document.getElementById('itemTable').insertRow();
        
        var C2 = x.insertCell(0);
        var C3 = x.insertCell(1);
        var C4 = x.insertCell(2);
        var C5 = x.insertCell(3);
        var C6 = x.insertCell(4);
        var C7 = x.insertCell(5);
        var C8 = x.insertCell(6);
        var C9 = x.insertCell(7);
       
          
       
        
      
        C2.borderWidth = "1px";
        C3.borderWidth = "1px";
        C4.borderWidth = "1px";
        C5.borderWidth = "1px";
        C6.borderWidth = "1px";
        C7.borderWidth = "1px";
        C8.borderWidth = "1px";
        var me=count-1;
       
        
        C2.innerHTML = "<input type='text'  name='code' ID='code' readonly value=' '>"; 
        C3.innerHTML = "<input type='text' name='name1' ID='name1' readonly>";
        C4.innerHTML = "<input type='text' name='qun' ID='qun'  onblur='checNumeric()'>";
        C5.innerHTML = "<input type='text' name='note' ID='note' value='Add your Note'>";
        C6.innerHTML = "<input type='checkbox' name='check' ID='check'>";
        C7.innerHTML = "<input type='hidden' name='Hid' ID='Hid'>";
        C8.innerHTML = "<input type='hidden' name='price' ID='price' value='0.0' >";
        C9.innerHTML = "<input type='hidden' name='cost' ID='cost' value='0.0'>";
        
       set();
        
    }
    
    
     function Delete() {
         var tbl = document.getElementById('itemTable');
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
    
    function set(){
     
      var x=count-1;
      var code = document.getElementsByName('code');
      
       var TDNAME = document.getElementsByName('TDName');
        if(nowMode=="name"){
       
            for(var i=0;i<lookAheadArray.length;i++){ 
                 if(lookAheadArray[i]==TDNAME[0].value){
                    
                     if(isFound(itemsCode[i])){
                        alert(" that item is exist already in the table");
                       count--;
                       document.getElementById('itemTable').deleteRow(count+2);
                        return;
                      }
                       TDNAME[0].value=itemsCode[i];
                     break;
                
                 }
            }
       }    
      code[x].value= TDNAME[0].value;
      TDNAME[0].value="";
      
       nowRow=x;
     
   
     var url = "<%=context%>/ajaxGetItrmName?key=" + code[x].value;
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
          var arr=result.split(',');
          var name=arr[0];
          var price=arr[1];
          var Mid=arr[2];
          
          if(name==" ")
             noCodeFound();
          else {
          
           var pr=document.getElementsByName('price');
           var nam=document.getElementsByName('name1');
           var c=document.getElementsByName('cost');
           var id=document.getElementsByName('Hid');
           
         
           nam[nowRow].value = name;
           pr[nowRow].value = price;
           c[nowRow].value ="0.0";
           id[nowRow].value=Mid;
          
          }
        }
    }

  
}
function noCodeFound( ) {

  
         alert(" not found item ");
           var tbl = document.getElementById('itemTable');
       
       
            tbl.deleteRow(1+count--);
}

   var dp_cal1; 
 window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('actualEndDate'));
            init("TDName");
            var pr=document.getElementsByName('con');
            count=pr[0].value;
      
           checNumeric();
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
            suggestionDiv.style.backgroundColor = "white";
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

            suggestionDiv.style.top = (210+inputTextField.offsetTop+inputTextField.offsetHeight+document.getElementById("CellData").offsetTop+document.getElementById("tab").offsetTop) + "px";
           
            suggestionDiv.style.left = (10+inputTextField.offsetLeft+document.getElementById("CellData").offsetLeft+document.getElementById("tab").offsetLeft) + "px";
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
           var url = "<%=context%>/ajaxGetItrmName?key=aa";
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFillUsernames;
            req.send(null);
        } 


        function callbackFillUsernames()
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
        <% filterName = (String) request.getAttribute("filterName"); %>
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?<%=CancelForm%>";
        document.ISSUE_FORM.submit();  
        }
    function f()
    {
       var dd=document.getElementById('TDName');
       dd.value="";
    }
    function d()
    {
    var dd=document.getElementById('TDName');
       dd.value="Auto Select ";
       }                        
                                   </script>

<script src='silkworm_validate.js' type='text/javascript'></script>
<script src='ChangeLang.js' type='text/javascript'></script>


<link rel="stylesheet" type="text/css" href="autosuggest.css" />




<BODY>

<FORM NAME="ISSUE_FORM" METHOD="POST">

<%
if(request.getAttribute("case")!=null){
%>
<INPUT TYPE="HIDDEN" NAME="case" VALUE="<%=(String)request.getAttribute("case")%>">
<INPUT TYPE="HIDDEN" NAME="title" VALUE="<%=(String)request.getAttribute("title")%>">
<INPUT TYPE="HIDDEN" NAME="unitName" VALUE="<%=(String)request.getAttribute("unitName")%>">
<%

}
%>
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')"  class="Button">
    <button  onclick="JavaScript: cancelForm();" class="Button"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
    <button  onclick="JavaScript:  submitForm();"  class="Button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
    
    
</DIV>    

<fieldset >
    <legend align="center">
        <table dir="rtl" align="center">
            <tr>
                
                <td class="td">
                    <font color="blue" size="6"> <%=endTask%>                  
                    </font>
                    
                </td>
            </tr>
        </table>
    </legend>
    <table align="<%=align%>" >
        <TR COLSPAN="2" ALIGN="<%=align%>">
            <TD STYLE="<%=style%>" class='td'>
                <FONT color='red' size='+1'><%=AllRequired%></FONT> 
            </TD>
            
        </TR>
    </table>
    <br>
    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
        
        <TR>
            <TD CLASS="td" STYLE="<%=style%>">           
                <p><b><%=title%><font color="#FF0000"> </font></b>&nbsp;
                
            </TD>
            <TD CLASS="td" STYLE="<%=style%>" >
                <b><font color="red"> <%=issueTitle%></font> </b> 
            </TD>
        </TR>
        
        <TR>
            <TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="str_Function_Desc">
                    <p><b><%=Fcode%></b>&nbsp;
                </LABEL>
            </TD>
            <TD STYLE="<%=style%>" class='td'>
                <input type="text" DISABLED  size="32" name="assignNote" value="<%=failureCode%>" ID="assignNote" cols="25">
            </TD>
            <TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="str_Function_Desc">
                    <p><b><font color="#FF0000">*</font><%=CauseDes%>  </b>&nbsp;
                </LABEL>
            </TD>
            
            <TD STYLE="<%=style%>" class='td'>
                <TEXTAREA rows="3" name="causeDescription" cols="25"></TEXTAREA>
            </TD>
        </TR>
        <input type="hidden" name="workerNote" value="Finished Task">
        
        <TR>
            <TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="str_Function_Desc">
                    <p><b> <font color="#FF0000">*</font><%=TakenAction%> </b>&nbsp;
                </LABEL>
            </TD>
            <TD STYLE="<%=style%>" class='td'>
                <TEXTAREA rows="3" name="actionTaken" cols="25"></TEXTAREA>
            </TD>
            <%
            String url = request.getRequestURL().toString();
            String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
            Calendar c = Calendar.getInstance();
            %>
            <TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="EXPECTED_B_DATE">
                    <b><font color="#FF0000">*</font><font color="#003399"><!--%=eBDate%--></font></b>&nbsp;
                </LABEL>
            </TD>
            <td STYLE="<%=style%>"class="td">
                <input name="actualEndDate" id="actualEndDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                
            </td>
            <!--TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="str_Function_Desc">
                    <p><b> <font color="#FF0000">*</font><!%=prevention%></b>&nbsp;
                </LABEL>
            </TD>
            <TD STYLE="<!%=style%>" class='td'>
                <TEXTAREA rows="3" name="preventionTaken" cols="25"></TEXTAREA>
            </TD-->
            
        </TR>
        
        <TR>
            <TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="str_Function_Desc">
                    <p><b> <font color="#FF0000">*</font><%=actualTime%> </b>&nbsp;
                </LABEL>
            </TD>
            <TD STYLE="<%=style%>" class='td'>
                <input  type="text" size="5"  name="actual_finish_time"></input><FONT color='red'> <%=sHour%></FONT>
            </TD>
            <TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="str_Function_Desc">
                    <p><b><%=sOnLine%> </b>&nbsp;
                </LABEL>
            </TD>
            <TD STYLE="<%=style%>"  class='td'>
                <input type="checkbox" id="changeState" name="changeState" value="1">
            </TD>
        </TR>
    </TABLE>
    <input type=HIDDEN name="issueId" value = "<%=issueId%>" >
    <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
    <input type=HIDDEN name=filterName value="<%=filterName%>" >
    <input type=HIDDEN name="<%=AppConstants.DIRECTION%>" value="<%=direction%>" >
        
        <BR>
        
        <TABLE ALIGN="<%=align%>" DIR="<%=dir%>"  border="0" ID="tab">
        <tr>
            <td class="head" ><input type="radio" name="SelectOption" onClick="mod('code');"checked><b>&nbsp;&nbsp;<%=AddCode%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
            <td class="head"><input type="radio" name="SelectOption" onClick="mod('name');"><b>&nbsp;&nbsp;<%=AddName%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
        </tr>
        <tr>
        <TD CLASS="head"  >   <b> <font size="2"><b><%=addNew%></b></font></b></TD> 
        
        <TD CLASS="head"  COLSPAN="1" id="CellData">
            <input type="text" dir="ltr"  class="head" autocomplete="off" value="Auto Select " ONCLICK="JavaScript: f();"  name="TDName" ID="TDName">
        </TD>
        <TD colspan="1" CLASS="head"  WIDTH="15%">
    <b>   <input class="head" type="button" value="<%=add%>"  ONCLICK="JavaScript: addNew();d();"></b> </input>
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
    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="80%" CELLPADDING="0" ID="itemTable" CELLSPACING="0" STYLE="<%=style%>">
        
        <!--TR>
            
            <TD CLASS="total" colspan="2" STYLE="<!%=style%>;padding-right:5;border-right-width:1;">
                <!%=tCost%>
            </TD>
            <TD >
                <input type="TEXT" name="totale"  readonly ID="totale"  value="" maxlength="255" autocomplete="off">
            </TD>
            
        </TR-->
        <TR CLASS="head">
            
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                <%=code%>
                </TD> 
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                <%=name%>
                </TD> 
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                <%=count%>
                </TD> 
            <!--TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <%=price%>
                </TD> 
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <%=cost%>
                </TD--> 
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                <%=Mynote%>
                </TD>
            
            
            <TD CLASS="td">
                <input type="button" class="cell" value="<%=del%> " onclick="JavaScript: Delete()">
            </TD>
        </TR>  
        <%
        DecimalFormat format = new DecimalFormat("0.00");
        System.out.println("=========0=====================66> ");
        
        for(int j=0; j<quantifiedItems.size(); j++) {
            System.out.println("==============================66> "+j);
            
            int quantity = 0;
            float itemCost = 0f;
            String note =" ";
            
            
            WebBusinessObject wboTemp = new WebBusinessObject();
            
            wboTemp = (WebBusinessObject) quantifiedItems.get(j);
            quantity = new Integer(wboTemp.getAttribute("itemQuantity").toString()).intValue();
            Float temp = new Float(wboTemp.getAttribute("totalCost").toString());
            itemCost = new Float(format.format(temp)).floatValue();
            
            if(null != wboTemp.getAttribute("note").toString()){
                note = wboTemp.getAttribute("note").toString();
            }else {
                note = " ";
            }
            
            wboItem = (WebBusinessObject) itemMgr.getOnSingleKey(items.get(j).toString());
        %><tr>
            
            <TD><input type="text" readonly name="code" id="code" value="<%=wboItem.getAttribute("itemCode").toString()%>">
                
            </TD>
            <TD> <input type="text" readonly name="name1" id="name1" value="<%=wboItem.getAttribute("itemDscrptn").toString()%>"></TD>
            <!--TD><input type="text" readonly name="price" id="price" value="<%//=wboItem.getAttribute("itemUnitPrice").toString()%>"></TD-->
            <input type="hidden" name="price" id="price" value="0.0">
            <%
            ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
            WebBusinessObject wboTempo = itemUnitMgr.getOnSingleKey((String) wboItem.getAttribute("itemUnit"));
            %>
            
            <TD><input type="text"   name="qun" id="qun" value="<%=quantity%>" onblur="JavaScript: checNumeric()"></TD>
            
            <!--TD><input type="text"  readonly name="cost" id="cost" value="<%//=itemCost%>"></TD-->
            <input type="hidden"  name="cost" id="cost" value="0.0">
            <TD><input type="text"  name="note" id="note" value="<%=note%>"></TD>
            <TD >
            <input type='checkbox'  name='check' ID='check'></td>
            <td>
                <INPUT TYPE="hidden" NAME="Hid" ID="Hid" VALUE="<%=items.get(j).toString()%>">
            </TD>
            
        </TR>
        <%
        
        }
        %>
        
    </TABLE>
    <input type="hidden" id="con" name="con" value="<%=items.size()%>">
    <br><br>
    
</fieldset>
</FORM>
</BODY>
</HTML>     

