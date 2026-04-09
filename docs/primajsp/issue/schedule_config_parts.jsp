<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>

<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.DecimalFormat"%>

<HTML>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
EmployeeMgr empMgr = EmployeeMgr.getInstance();
StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();

ProjectMgr projectMgr = ProjectMgr.getInstance();
FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
String context = metaMgr.getContext();
ArrayList arrFailure = failureCodeMgr.getCashedTableAsBusObjects();
UserMgr userMgr = UserMgr.getInstance();
String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);

String filterName = (String) request.getAttribute("filter");

String filterValue = (String) request.getAttribute("filterValue");
String uID = (String) request.getAttribute("uID");
System.out.println("filterValue IN JSP _______"+filterValue);
System.out.println("filterName IN JSP  _______"+filterName);
AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");

String workShop = (String) request.getAttribute("workShop");

/* added */

AppConstants appCons = new AppConstants();
WebIssue webIssue = null;

String[] itemAtt = appCons.getItemScheduleAttributes();
String[] itemTitle = appCons.getItemScheduleHeaders();


TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

Vector  itemList = (Vector) request.getAttribute("data");
System.out.println("Vector Count = "+itemList.size());



int s = itemAtt.length;
int t = s;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = new String("#FF00FF");
String bgColor = null;
int flipper = 0;



WebBusinessObject wbo = IssueMgr.getInstance().getOnSingleKey(issueId);
WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());
WebBusinessObject wboFcode = failureCodeMgr.getOnSingleKey(wbo.getAttribute("failureCode").toString());
String failureCode = wboFcode.getAttribute("title").toString();
/* end */
TechMgr techMgr = TechMgr.getInstance();


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String endTask,BackToList,save,lang,langCode,AllRequired,title,Fcode,site,M_Name,crew,ATask,print,actualTime;
String search,AddCode,add,AddName,addNew,tCost,code,name,price,count,cost,Mynote,del,scr,sBackToList,attachTask;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    endTask = "End that task";
    BackToList = "Back to list";
    save = "    Save   ";
    AllRequired="(*) All Data Must Be Filled";
    title="Schedule title";
    Fcode="Failure code";
    print="Print order";
    ATask="Assign task";
    site="Site";
    add="   Add   ";
    search="Auto search";
    M_Name="Machine name";
    crew="Assign to Crew Mission";
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
    sBackToList = "Cancel";
    attachTask="Attach spare parts to task";
    
}else{
    add="  &#1571;&#1590;&#1601;  ";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    endTask =  " &#1573;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; ";
   AllRequired="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
    title="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    Fcode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604; ";
    
    site=" &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    M_Name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1575;&#1604;&#1607;";
    
    print="&#1573;&#1591;&#1576;&#1593; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    ATask="&#1573;&#1587;&#1606;&#1575;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    crew="&#1578;&#1587;&#1606;&#1583; &#1573;&#1604;&#1609; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
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
    sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    attachTask="&#1585;&#1576;&#1591; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1576;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
   
    
}
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Agricultural Miantenance - work shop order</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
     
   var count=0;
        function submitForm()
        {    
          if(count==0){
    alert("you can't submite that form with out select at list one item ");
    return;
    }
    
     var q=document.getElementsByName('qun');
     
      for(var x=0;x<count;x++){
     
      var check=q[x].value;
      if(check == "0" || check=="" ){
            alert("enter the quantity more than zero or delete the un used row");
            return;
      }
     
      }
      
   
       document.WORKSHOP_FORM.action = "<%=context%>/AssignedIssueServlet?op=saveconfigParts&projectID=<%=wbo.getAttribute("projectName").toString()%>&assignNote=<%=failureCode%>&uID=<%=uID%>&filterName=StatusProjectListAll&filteValue=<%=filterValue%>";
       document.WORKSHOP_FORM.submit();  
       
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
        C3.borderWidth = "1px";
        C4.borderWidth = "1px";
        C5.borderWidth = "1px";
        C6.borderWidth = "1px";
        C7.borderWidth = "1px";
      
        var me=count-1;
        
        C1.innerHTML = "<input type='text'  name='code' ID='code' readonly value=' '>";
     
        C2.innerHTML = "<input type='text' name='name1' ID='name1' readonly>";
        C3.innerHTML = "<input type='text' name='qun' ID='qun'  onblur='checNumeric()'>";
        C4.innerHTML = "<input type='text' name='note' ID='note' value='Add your Note'>";
        C5.innerHTML = "<input type='checkbox' name='check' ID='check'>";
        C6.innerHTML = "<input type='hidden' name='price' ID='price' value='0.0'>";
        C7.innerHTML = "<input type='hidden' name='cost' ID='cost' value='0.0'>";
        C8.innerHTML = "<input type='hidden' name='Hid' ID='Hid'>";
        
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
                       document.getElementById('itemTable').deleteRow(count+3);
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

  
         alert(" not found code");
           var tbl = document.getElementById('itemTable');
       
       
            tbl.deleteRow(count--);
}

   
 window.onload = function () {
       
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
        document.WORKSHOP_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.WORKSHOP_FORM.submit();  
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

<FORM NAME="WORKSHOP_FORM" METHOD="POST">


<DIV align="left" STYLE="color:blue;">
    <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="Button">
    <button  onclick="JavaScript: cancelForm();" class="button"><%=sBackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
   <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
    
</DIV> 
<fieldset style="border-color:blue">
<legend align="center">
    <table dir="rtl" align="center">
        <tr>
            
            <td class="td">
                <font color="blue" size="6"> <%=attachTask%>                 
                </font>
                
            </td>
        </tr>
    </table>
</legend>       
<!--table align="<%//=align%>" >
    <TR COLSPAN="2" ALIGN="<%//=align%>">
        <TD STYLE="<%//=style%>" class='td'>
            <FONT color='red' size='+1'><%//=AllRequired%></FONT> 
        </TD>
    </TR>
</table-->
<br>

<TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
    
    <!--TR>
        <TD STYLE="<%//=style%>" class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><%//=title%><font color="#FF0000"> </font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%//=style%>"  class='td'>
            <input disabled type="TEXT"  name="maintenanceTitle" value="<%//=issueTitle%>" ID="<%//=issueTitle%>" size="33"  maxlength="50">
        </TD>
    </TR-->
    
    <!--TR>
        <TD STYLE="<%//=style%>"  class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><%//=site%><font color="#FF0000"> </font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%//=style%>"  class='td'>
            <input disabled type="TEXT" name="workShop" value="<%//=projectMgr.getOnSingleKey(wbo.getAttribute("projectName").toString()).getAttribute("projectName").toString()%>" ID="workShop" size="33"  maxlength="50">
        </TD>
    </TR-->
    
    
    <!--TR>
        <TD STYLE="<%//=style%>" class='td'>
            <LABEL FOR="ISSUE_TITLE">
                <p><b><%//=M_Name%><font color="#FF0000"> </font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%//=style%>" class='td'>
            <input disabled type="TEXT" name="machineName" value="<%//=wboTemp.getAttribute("unitName").toString()%>" ID="machineName" size="33"  maxlength="50">
        </TD>
    </TR-->
    
    <!--TR>
        <TD STYLE="<%//=style%>" class='td'>
            <LABEL FOR="assign_to">
                <p><b><%//=crew%><font color="#FF0000"></font></b>&nbsp;
            </LABEL>
        </TD>
        <%
        //ArrayList arrayCrewCodeList = new ArrayList();
       // crewMissionMgr.cashData();
      //  arrayCrewCodeList = crewMissionMgr.getCashedTableAsBusObjects();
        %>
        
        <TD STYLE="<%//=style%>" class='td'>
            <SELECT name="empName"  STYLE="width:230px;">
                <//sw:WBOOptionList wboList='<%//=arrayCrewCodeList%>' displayAttribute = "crewName" valueAttribute="crewID"/>
            </SELECT>
            <input type="hidden" name="assignToName" value="admin" size="33" maxlength="50"/><input type="hidden" name="assignTo" value="1">
        </TD>
    </TR-->
    
    <!--TR>
        <TD STYLE="<%//=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b><%//=Fcode%> </b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%//=style%>" class='td'>
            <SELECT name="failurecode" style="width:230px">
                <//sw:WBOOptionList wboList='<%//=arrFailure%>' displayAttribute = "title" valueAttribute="id" scrollTo="<%//=failureCode%>"/>
            </SELECT>
        </TD>
        <!--TD STYLE="<%//=style%>" class='td'>
            <input type="text" DISABLED size="33" name="assignNote" value="<//%=failureCode%>" ID="assignNote" cols="25">
        </TD-->
    <!--/TR-->
    <tr><td class="td">     
            <input type=HIDDEN name=issueId value="<%=issueId%>" >
            <input type=HIDDEN name=filterName value="<%=filterName%>" >
            <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
    <input type=HIDDEN name=issueTitle value="<%=issueTitle%>"> </td></tr>
</TABLE>

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
<br>

<TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="600" CELLPADDING="0" ID="itemTable" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    
    <!--TR>
        <TD CLASS="total" colspan="2" STYLE="<!%=style%>;padding-right:5;border-right-width:1;">
            <!%=tCost%>
        </TD>
        <TD STYLE="<!%=style%>"-->
            <input type="hidden" name="totale"  readonly ID="totale"  value="0.0" maxlength="255" autocomplete="off">
        <!--/TD>
        <TD>
            
        </TD>
        <TD></TD>
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
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <%=Mynote%>
            </TD> 
        <!--TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <%=price%>
            </TD> 
        <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <%=cost%>
            </TD--> 
        
        
        
        <TD CLASS="td">
            <input type="button" class="cell" value="<%=del%> " onclick="JavaScript: Delete()">
        </TD>                                                                           
    </TR>  
    
    <%
    
    Enumeration e = itemList.elements();
    String status = null;
    
    while(e.hasMoreElements()) {
        iTotal++;
        wbo = (WebBusinessObject) e.nextElement();
        //webIssue = (WebIssue) wbo;
        flipper++;
        if((flipper%2) == 1) {
            bgColor="#c8d8f8";
        } else {
            bgColor="white";
        }
        //  issueID = (String) wbo.getAttribute("id");
    %>
    
    <TR bgcolor="<%=bgColor%>">
        
        <%
        DecimalFormat format = new DecimalFormat("0.00");
        
        attName = itemAtt[0];
        attValue = (String) wbo.getAttribute(attName);
        
        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
        
        %>
        
        <TD><input type="text" readonly name="code" id="code" value="<%=maintenanceItemMgr.getOnSingleKey(attValue).getAttribute("itemCode").toString()%>">
            
        </TD>
        
        <TD><input type="text" readonly name="name1" id="name1" value="<%=maintenanceItemMgr.getOnSingleKey(attValue).getAttribute("itemDscrptn").toString()%>">
            
        </TD>
        <%
        attName = itemAtt[1];
        attValue = (String) wbo.getAttribute(attName);
        // attValue = format.format(new Float(attValue));
        %>
        
        <TD> <input type="text"  name="qun" id="qun" value="<%=attValue%>" onblur='checNumeric()'>
            
            
            
        </TD>
         <%
        attName = itemAtt[4];
        attValue = (String) wbo.getAttribute(attName);
        %>
        
        <TD> <input type="text"  name="note" id="note" value=" <%=attValue%>">
            
            
            
        </TD>
        
        <TD> <input type="checkbox"  name="check" id="check" value="false">
            
            
            
        </TD>
        <TD><input type="hidden" name="Hid" id="Hid" value="<%=(String) wbo.getAttribute(itemAtt[0])%>">
        </TD>
        
        <%
        attName = itemAtt[2];
        attValue = (String) wbo.getAttribute(attName);
        
        attValue = format.format(new Float(attValue));
        %>
        <!--TD--> <input type="hidden"  name="price" id="price" value="0.0">
            
            
            
        <!--/TD-->
        <%
        attName = itemAtt[3];
        attValue = (String) wbo.getAttribute(attName);
        
        attValue = format.format(new Float(attValue));   
        %>
        <!--TD--> <input type="hidden"  name="cost" id="cost" value="0.0">
            
            
            
        <!--/TD-->
        
       
        
    </TR>
    <%
    }
    
    %>
    
</TABLE>
<br><br>

</FIELDSET>
</FORM>
<input type="hidden"  name="con" id="con" value="<%=iTotal%>">

<!--/td>
            
            
            
</table-->
</BODY>
</HTML>     
