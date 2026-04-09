<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr unitMgr = MaintainableMgr.getInstance();
ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
ConfigureCategoryMgr configureCategoryMgr = ConfigureCategoryMgr.getInstance();
MaintenanceItemMgr itemMgr = MaintenanceItemMgr.getInstance();

String context = metaMgr.getContext();

String[] itemsAttributes = {"itemDesc", "itemPrice"};
String[] itemsListTitles = {"Code &#1575;&#1604;&#1603;&#1608;&#1583;","Item Name &#1573;&#1587;&#1605; &#1575;&#1604;&#1580;&#1586;&#1569;", "Price &#1575;&#1604;&#1587;&#1593;&#1585;", "Quantity &#1575;&#1604;&#1603;&#1605;&#1610;&#1607;", "Total Item Cost &#1587;&#1593;&#1585; &#1603;&#1604; &#1575;&#1604;&#1571;&#1580;&#1586;&#1575;&#1569;", "Notes &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;"};

int s = itemsAttributes.length;
int t = s+4;

String attName = null;
String attValue = null;

String configure = "configure";
String scheduleId = (String) request.getAttribute("scheduleId");
String scheduleTitle = (String) request.getAttribute("scheduleTitle");
String categoryId ="";
String   url="";

categoryId = (String) request.getAttribute("categoryId");
if(categoryId!=null)
    url="op=createSchedule&unitCats="+categoryId;

if(request.getAttribute("url")!=null){
    url=(String)request.getAttribute("url");
}
WebBusinessObject wboItem = null;
WebBusinessObject wbo = ScheduleMgr.getInstance().getOnSingleKey(scheduleId);
String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,BackToList,save,attachTask,title,Categ;
String search,AddCode,AddName,addNew,tCost,code,name,price,count,cost,Mynote,del,scr,add;
String updateParts;
if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    BackToList = "Back to list";
    save = " Save ";
    attachTask="Attach spare parts to task";
    title="Schedule title";
    Categ="Equipment Category";
    add="   Add   ";
    search="Auto search";
    AddCode="  Add using Part Code  ";
    AddName="  Add using Part Name  ";
    addNew="Add new part";
    tCost="Total cost  ";
    code="Code";
    name="Name";
    price="Price";
    count="Quntity";
    cost="Total Price";
    Mynote="Note";
    del="Delete";
    scr="images/arrow1.swf";
    updateParts="Add / Update Schedule Spare Parts";
}else{
    align="center";
    dir="RTL";
    add="  &#1571;&#1590;&#1601;  ";
    style="text-align:Right";
    lang="English";
    langCode="En";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    save = " &#1587;&#1580;&#1604;  ";
    attachTask="&#1585;&#1576;&#1591; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1576;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    title="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    Categ="&#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;  ";
    search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
    AddCode="   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;   ";
    AddName="   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;   ";
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
    updateParts="&#1575;&#1590;&#1575;&#1601;&#1577; / &#1578;&#1593;&#1583;&#1610;&#1604; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
}
String sTempPage = new String("");
if(request.getParameter("page") != null){
    sTempPage = "&page=" + request.getParameter("page");
}
%>

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
      
        var c=document.getElementsByName('cost');
        var p=document.getElementsByName('price');
        var id=document.getElementsByName('code');
        var not=document.getElementsByName('note');

        for(var i=0;i<count;i++){
            var x = document.getElementById('HiddenitemTable').insertRow();
       
            var C2 = x.insertCell(0);
            var C3 = x.insertCell(1);
            var C4 = x.insertCell(2);
            var C5 = x.insertCell(3);
            var C6 = x.insertCell(4);
       
            C2.innerHTML = "<input type='hidden' name='Hnote' ID='Hnote' value="+not[i].value+">";
            C3.innerHTML = "<input type='hidden' name='Hprice' ID='Hprice' value='0'>";
            C4.innerHTML = "<input type='hidden' name='Hqun' ID='Hqun'  value="+q[i].value +">";
            C5.innerHTML = "<input type='hidden' name='Hcost' ID='Hcost' value='0'>";
            C6.innerHTML = "<input type='hidden' name='Hcode' ID='Hcode' value="+id[i].innerHTML +">";
        }
        
        document.CONFIG_SCHDULE_FORM.action = "<%=context%>/ScheduleServlet?op=SaveconfigMainTypeHourly&scheduleId=<%=scheduleId%>&status=<%=configure%>&Cat_id=<%=categoryId%><%=sTempPage%>";
        document.CONFIG_SCHDULE_FORM.submit();
        
    }
        
    function checNumeric() {
        var q=document.getElementsByName('qun');
        var c=document.getElementsByName('cost');
        var p=document.getElementsByName('price');
        var total=0.0;
      
        for(var x=0;x<count;x++){
            var price=p[x].innerHTML;
            var check=q[x].value;
            
            if(IsNumeric(check)){
                total+=check*price;
                c[x].innerHTML=check*price;
            } else {
                q[x].value="0";
                c[x].innerHTML="0.0";
            }
        }
      
        var tot = document.getElementById('tdPTotal');
        tot.value = total.toFixed(2);
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
            if(x==code[i].innerHTML) 
                return true;
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
       // var C6 = x.insertCell(5);
       // var C7 = x.insertCell(6);

        C1.borderWidth = "1px";
        C1.id = "code";
        C1.bgColor = "#FFE391";
        
        C2.borderWidth = "1px";
        C2.id = "name1";
        C2.bgColor = "#FFE391";
         
        C3.borderWidth = "1px";
        C3.bgColor = "#FFE391";
        
      
        
        C4.borderWidth = "1px";
        C4.bgColor = "#FFE391";
        
        C5.borderWidth = "1px";
        C5.bgColor = "#FFE391";
        
      
        
        var me=count-1;

        C3.innerHTML = "<input type='text' name='qun' ID='qun'  onblur='checNumeric()' size='4' maxlength='5' >" + "<input type='hidden' name='price' ID='price' value='0.0'>" + "<input type='hidden' name='cost' ID='cost' value='0.0'>";
        C4.innerHTML = "<input type='text' name='note' ID='note' value='Add your Note' size='25'>";
        C5.innerHTML = "<input type='checkbox' name='check' ID='check'>" + "<input type='hidden' name='Hid' ID='Hid'>" + "<input type='hidden' name='des' ID='des'>" + "<input type='hidden' name='cat' ID='cat'>";
       
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
       
        code[x].innerHTML= TDNAME[0].value;
      
        TDNAME[0].value="";
        nowRow=x;

        var url = "<%=context%>/ajaxGetItrmName?key=" + code[x].innerHTML;
             
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest( );
        } else if (window.ActiveXObject) {
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
              //var price=arr[1];
              var Mid=arr[2];
              var des1=arr[3];
              var cat1=arr[4];
              
              if(name==" ")
                 noCodeFound();
              else {
                //  var pr=document.getElementsByName('price');
                  var nam=document.getElementsByName('name1');
                 // var c=document.getElementsByName('cost');
                  var id=document.getElementsByName('Hid');
                  var des=document.getElementsByName('des');
                  var cat=document.getElementsByName('cat');
         
                  nam[nowRow].innerHTML = name;
                 // pr[nowRow].innerHTML = price;
                 // c[nowRow].innerHTML ="0.0";
                  id[nowRow].value=Mid;
                  des[nowRow].value=des1;
                  cat[nowRow].value=cat1;
         
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

            suggestionDiv.style.top = (300+inputTextField.offsetTop+inputTextField.offsetHeight+document.getElementById("CellData").offsetTop+document.getElementById("tab").offsetTop) + "px";
           
            suggestionDiv.style.left = (-110+inputTextField.offsetLeft+document.getElementById("CellData").offsetLeft+document.getElementById("tab").offsetLeft) + "px";
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
        var url = document.getElementById('url').value
        <% 
        String sTemp = "op=";
        if(request.getParameter("page") == null) {%>
        document.CONFIG_SCHDULE_FORM.action = "<%=context%>/ScheduleServlet?"+url;
        <% } else {
            String sPage = request.getParameter("page");
            
            if(sPage.equalsIgnoreCase("createSchedule")){
                sTemp = sTemp + sPage + "&unitCats=non";
            } else if(sPage.equalsIgnoreCase("createEqpSchedule")){
                sTemp = sTemp + sPage + "&unit=non";
            } else if(sPage.equalsIgnoreCase("saveSchedule")){
                sTemp = sTemp + "DisplySavedSchedule&source=cat&scheduleId=" + scheduleId;
            } if(sPage.equalsIgnoreCase("saveEqpSchedule")){
                sTemp = sTemp + "DisplySavedSchedule&source=eqp&scheduleId=" + scheduleId;
            }
            
    %>
        document.CONFIG_SCHDULE_FORM.action = "<%=context%>/ScheduleServlet?<%=sTemp%>";
        <% } %>
        document.CONFIG_SCHDULE_FORM.submit();  
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
<link rel="stylesheet" type="text/css" href="Button.css" />

<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <head>
        <title>Schedule Spare Part Configuration</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </head>
    
    <BODY>
        <center>
        <FORM NAME="CONFIG_SCHDULE_FORM" METHOD="POST">
            <input type="hidden" name="url" value="<%=url%>">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript: submitForm();" class="button"><%=save%> <IMG VALIGN="BOTTOM"   SRC="images/save.gif"> </button> 
            </DIV>
            <br>
            
            <fieldset  class="set">
                <legend align="center">
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=attachTask%></font>
                            </td>
                        </tr>
                    </table>
                </legend >
                <br>
                
                <table align="<%=align%>" id="HiddenitemTable">
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="650">
                    <TR>
                        <TD CLASS="cell" bgcolor="darkgoldenrod" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=updateParts%></B>                   
                        </TD>
                    </TR>
                </TABLE>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="650">
                    <TR>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('code');"checked><b><%=AddCode%></b>                   
                        </TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" ROWSPAN="2" id="CellData" WIDTH="300">
                            <font size="2"><b><%=addNew%></b></font>
                            <input type="text" dir="ltr"  class="head" autocomplete="off" value="Auto Select " ONCLICK="JavaScript: f();"  name="TDName" ID="TDName">
                        </TD>
                        <td CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" ROWSPAN="2">
                            <input class="head" type="button" value="<%=add%>"  ONCLICK="JavaScript: addNew();d();">
                        </td>
                    </TR>
                    <TR>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('name');"><b><%=AddName%></b>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" id="itemTable" WIDTH="900" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:0px;">
                    <TR>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="150">
                            <b><%=code%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250">
                            <b><%=name%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="50">
                            <b><%=count%></b>
                        </TD>
                        <!--TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="50">
                        <b><%=price%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="100">
                        <b><%=cost%></b>
                        </TD-->
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250">
                            <b><%=Mynote%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="50">
                            <input type="button" class="cell" value="<%=del%> " onclick="JavaScript: Delete()">
                        </TD>
                    </TR>
                    
                    <%
                    ConfigureMainTypeMgr cinfiged=ConfigureMainTypeMgr.getInstance();
                    Vector stored=cinfiged.getOnArbitraryKey(scheduleId,"key1");
                    MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                    %>
                    <input type="hidden" name="con" id="con" value="<%=stored.size()%>">
                    <%
                    for(int i=0;i<stored.size();i++){
                        WebBusinessObject web=(WebBusinessObject)stored.get(i);
                        WebBusinessObject web2= maintenanceItemMgr.getOnSingleKey((String)web.getAttribute("itemId"));                    
                    %>
                    <TR>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14" ID="code">
                            <%=(String)web2.getAttribute("itemCode")%>
                        </TD>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14" ID='name1'>
                            <%=(String)web2.getAttribute("itemDscrptn")%>
                        </TD>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14">
                            <input type='text' name='qun' ID='qun'  value='<%=(String)web.getAttribute("itemQuantity")%>' onblur='checNumeric()' size="4" maxlength="5">
                        </TD>
                        <!--TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14" ID='price'>
                        <%=(String)web2.getAttribute("itemUnitPrice")%>
                        </TD>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14" ID='cost'>
                        <%=(String)web.getAttribute("totalCost")%>
                        </TD-->
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14">
                            <input type='text' name='note' ID='note' value='<%=(String)web.getAttribute("note")%>' size="25">
                        </TD>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14">
                            <input type='checkbox' name='check' ID='check'>
                            <input type='hidden' name='Hid' ID='Hid' value='<%=(String)web2.getAttribute("itemCode")%>'>
                            <input type='hidden' name='des' ID='des' value='<%=(String)web2.getAttribute("itemDscrptn")%>'>
                            <input type='hidden' name='cat' ID='cat' value='<%=(String)web2.getAttribute("categoryName")%>'>
                        </TD>
                    </TR>
                    <%}%>
                </TABLE>
                <br>
            </fieldset>
        </form>
    </BODY>
</html>