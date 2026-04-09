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
    Vector complexIssues=(Vector)request.getAttribute("complexIssues");
    WebBusinessObject cIssueWbo=new WebBusinessObject();
    
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList arrFailure = failureCodeMgr.getCashedTableAsBusObjects();
    UserMgr userMgr = UserMgr.getInstance();
    String issueId = (String) request.getAttribute("issueId");
    IssueMgr issueMgr=IssueMgr.getInstance();
    WebBusinessObject issueWbo=issueMgr.getOnSingleKey(issueId);
    String businessID=issueWbo.getAttribute("businessID").toString();
    String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);
    
    String filterName = (String) request.getAttribute("filter");
    
    String filterValue = (String) request.getAttribute("filterValue");
    String attachedEqFlag=(String) request.getAttribute("attachedEqFlag");
    String uID = (String) request.getAttribute("uID");
    AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
    
    String workShop = (String) request.getAttribute("workShop");
    
    /* added */
    
    AppConstants appCons = new AppConstants();
    WebIssue webIssue = null;
    
    String[] itemAtt = {"itemId","itemQuantity","itemPrice","totalCost", "note","cmplxIssueId"};
    String[] itemTitle = {"Part Name", "Quantity","Part Price","Total Cost", "Note","Maintenance Type Index"};
    
    
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
    String search,AddCode,add,isMainEq,AddName,addNew,tCost,code,name,price,count,cost,Mynote,del,scr,sBackToList,attachTask,maintTypes;
    String updateParts,selectMaintItems;
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
        sBackToList = "Back To Job Order";
        attachTask="Attach spare parts to task";
        isMainEq="Is Main Equipment";
        updateParts="Add / Update Equipment Spare Parts";
        maintTypes="Maintenance Types";
        selectMaintItems="Select Maintenance Type to add Spare Parts on it";
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
        sBackToList = "&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1609; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        attachTask="&#1585;&#1576;&#1591; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; <br> &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        isMainEq="&#1593;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1591;&#1585;&#1607;";
        updateParts="&#1575;&#1590;&#1575;&#1601;&#1577; / &#1578;&#1593;&#1583;&#1610;&#1604; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607;";
        maintTypes="&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        selectMaintItems="&#1575;&#1582;&#1578;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1604;&#1603;&#1609; &#1578;&#1590;&#1601; &#1593;&#1604;&#1610;&#1607; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
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
        function submitForm(attachedFlag)
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
      
        if(attachedFlag.match("attached")){
            coffee=document.forms[0].checkattachEq;
            txt="";
            for (i=0;i<coffee.length;++ i)
              {
              if (coffee[i].checked)
                {
                    txt=txt + "1!";
                }else
                {
                    txt=txt + "0!";
                }
              }
          
          if(coffee.length==undefined)
          {
                if(document.forms[0].checkattachEq.checked){
                       txt="1!";
                }else{
		       txt="0!";
		       }
	 }
        document.WORKSHOP_FORM.action = "<%=context%>/CompexIssueServlet?op=saveconfigPartsComplex&isDirectPrch=0&issueId=<%=issueId%>&page=general&attachedOn="+txt;
        document.WORKSHOP_FORM.submit();  
       
          
       }else
       {
        document.WORKSHOP_FORM.action = "<%=context%>/CompexIssueServlet?op=saveconfigPartsComplex&page=spareparts&isDirectPrch=0&issueId=<%=issueId%>";
        document.WORKSHOP_FORM.submit();  
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
      
  
    
    
     function addNew(test){
      
     
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
        
        if(test.match("attached")){
        var C7 = x.insertCell(6);
        var C8 = x.insertCell(7);
        var C9 = x.insertCell(8);
        var C10 = x.insertCell(9);
        }else
        {
        var C7 = x.insertCell(6);
        var C8 = x.insertCell(7);
        var C9 = x.insertCell(8);
        }
        
        
       
          
       
        
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
        C4.innerHTML = "<input type='text' name='price' ID='price' readonly>";
        C5.innerHTML = "<input type='text' name='cost' ID='cost' value='0.0' readonly>";
        C6.innerHTML = "<input type='text' name='maintTypeIndex' ID='maintTypeIndex' value='' readonly >";
        C7.innerHTML = "<input type='text' name='note' ID='note' value='Add your Note'>";
        
        if(test.match("attached")){
            C8.innerHTML = "<input type='checkbox' name='checkattachEq' ID='checkattachEq'>";
            C9.innerHTML = "<input type='checkbox' name='check' ID='check'>";
            C10.innerHTML = "<input type='hidden' name='Hid' ID='Hid'>";
        }else {
            C8.innerHTML = "<input type='checkbox' name='check' ID='check'>";
            C9.innerHTML = "<input type='hidden' name='Hid' ID='Hid'>";
        }
        
        
        
        
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
           var maintTypecell=document.getElementsByName('maintTypeIndex');
         
           nam[nowRow].value = name;
           pr[nowRow].value = price;
           c[nowRow].value ="0.0";
           id[nowRow].value=Mid;
           maintTypecell[nowRow].value=document.getElementById('maintType').value;
           
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
            lookAheadArray=itemNames;
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
    
    
    <script type="text/javascript">//<![CDATA[
    function sortTable2(col) {

    // Get the table section to sort.
    var tblEl = document.getElementById("planetData2");

    // Set up an array of reverse sort flags, if not done already.
    if (tblEl.reverseSort == null)
    tblEl.reverseSort = new Array();

    // If this column was the last one sorted, reverse its sort direction.
    if (col == tblEl.lastColumn)
    tblEl.reverseSort[col] = !tblEl.reverseSort[col];

    // Remember this column as the last one sorted.
    tblEl.lastColumn = col;

    // Set the table display style to "none" - necessary for Netscape 6 
    // browsers.
    var oldDsply = tblEl.style.display;
    tblEl.style.display = "none";

    // Sort the rows based on the content of the specified column using a
    // selection sort.

    var tmpEl;
    var i, j;
    var minVal, minIdx;
    var testVal;
    var cmp;

    for (i = 0; i < tblEl.rows.length - 1; i++) {

    // Assume the current row has the minimum value.
    minIdx = i;
    minVal = getTextValue(tblEl.rows[i].cells[col]);

    // Search the rows that follow the current one for a smaller value.
    for (j = i + 1; j < tblEl.rows.length; j++) {
    testVal = getTextValue(tblEl.rows[j].cells[col]);
    cmp = compareValues(minVal, testVal);
    // Reverse order?
    if (tblEl.reverseSort[col])
    cmp = -cmp;
    // If this row has a smaller value than the current minimum, remember its
    // position and update the current minimum value.
    if (cmp > 0) {
    minIdx = j;
    minVal = testVal;
    }
    }

    // By now, we have the row with the smallest value. Remove it from the
    // table and insert it before the current row.
    if (minIdx > i) {
    tmpEl = tblEl.removeChild(tblEl.rows[minIdx]);
    tblEl.insertBefore(tmpEl, tblEl.rows[i]);
    }
    }

    // Restore the table's display style.
    tblEl.style.display = oldDsply;

    return false;
    }

    //-----------------------------------------------------------------------------
    // Functions to get and compare values during a sort.
    //-----------------------------------------------------------------------------

    // This code is necessary for browsers that don't reflect the DOM constants
    // (like IE).
    if (document.ELEMENT_NODE == null) {
    document.ELEMENT_NODE = 1;
    document.TEXT_NODE = 3;
    }

    function getTextValue(el) {

    var i;
    var s;

    // Find and concatenate the values of all text nodes contained within the
    // element.
    s = "";
    for (i = 0; i < el.childNodes.length; i++)
    if (el.childNodes[i].nodeType == document.TEXT_NODE)
    s += el.childNodes[i].nodeValue;
    else if (el.childNodes[i].nodeType == document.ELEMENT_NODE &&
    el.childNodes[i].tagName == "BR")
    s += " ";
    else
    // Use recursion to get text within sub-elements.
    s += getTextValue(el.childNodes[i]);

    return normalizeString(s);
    }

    function compareValues(v1, v2) {

    var f1, f2;

    // If the values are numeric, convert them to floats.

    f1 = parseFloat(v1);
    f2 = parseFloat(v2);
    if (!isNaN(f1) && !isNaN(f2)) {
    v1 = f1;
    v2 = f2;
    }

    // Compare the two values.
    if (v1 == v2)
    return 0;
    if (v1 > v2)
    return 1
    return -1;
    }

    // Regular expressions for normalizing white space.
    var whtSpEnds = new RegExp("^\\s*|\\s*$", "g");
    var whtSpMult = new RegExp("\\s\\s+", "g");

    function normalizeString(s) {

    s = s.replace(whtSpMult, " ");  // Collapse any multiple whites space.
    s = s.replace(whtSpEnds, "");   // Remove leading or trailing white space.

    return s;
    }

    
    var row;
    var oldColor;
    function selectRow(tableRow){
        if(row != null)
        {
            var cells = row.cells;
            for (x in cells)
            {
                if(cells[x].style != null){
                    cells[x].style.backgroundColor = oldColor;
                }
            }
        }
        row = tableRow;
        var cells = tableRow.cells;
        for (x in cells)
        {
            if(cells[x].style != null){
                oldColor = cells[x].style.backgroundColor;
                cells[x].style.backgroundColor = 'yellow';
            }
        }
    }
    //]]>
    </script>
    
    
    <script src='silkworm_validate.js' type='text/javascript'></script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    
    
    <BODY>
        
        <FORM NAME="WORKSHOP_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="Button">
                <button  onclick="JavaScript: cancelForm();" class="button" style="width:125"><%=sBackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm('<%=attachedEqFlag%>');" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
                
            </DIV> 
            <fieldset style="border-color:blue">
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"><center> <%=attachTask%></center>
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>       
                
                <br>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <tr><td class="td">     
                            <input type=HIDDEN name=issueId value="<%=issueId%>" >
                            <input type=HIDDEN name=filterName value="<%=filterName%>" >
                            <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
                    <input type=HIDDEN name=issueTitle value="<%=issueTitle%>"> </td></tr>
                </TABLE>
                
                <BR>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="650">
                    <TR>
                        <TD CLASS="cell" bgcolor="darkgoldenrod" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=selectMaintItems%></B>                   
                        </TD>
                    </TR>
                </TABLE>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="400">
                    <TR>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:Right;font-size:16" WIDTH="200">
                            <b><%=maintTypes%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                            <SELECT name="maintType" STYLE="width:233;">
                                <%
                                for(int i=0;i<complexIssues.size();i++){
        cIssueWbo=new WebBusinessObject();
        cIssueWbo=(WebBusinessObject)complexIssues.get(i);
                                %>
                                <option value="<%=cIssueWbo.getAttribute("index").toString()%>">
                                <%=cIssueWbo.getAttribute("index").toString()%>&nbsp;&nbsp;/&nbsp;&nbsp; <%=businessID%>
                                <%}%>
                            </SELECT>
                        </TD>
                    </TR>
                </TABLE>
                
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
                            <input class="head" type="button" value="<%=add%>"  ONCLICK="JavaScript: addNew('<%=attachedEqFlag%>');d();">
                        </td>
                    </TR>
                    <TR>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="175">
                            <input type="radio" name="SelectOption" onClick="mod('name');"><b><%=AddName%></b>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                
                <input type="hidden" name="totale"  readonly ID="totale"  value="" maxlength="255" autocomplete="off">
                
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
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="50">
                            <b><%=price%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="100">
                            <b><%=cost%></b>
                        </TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="100">
                            <a href="" onclick="return sortTable2(6)"><b><%=maintTypes%></b></a>
                        </TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250">
                            <b><%=Mynote%></b>
                        </TD>
                        
                        <%if(attachedEqFlag.equalsIgnoreCase("attached")){%>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250">
                            <b> <%=isMainEq%></b>
                        </TD>    
                        <%}%>
                        
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="50">
                            <input type="button" class="cell" value="<%=del%> " onclick="JavaScript: Delete()">
                        </TD>                                                                       
                    </TR>  
                    
                    <tbody id="planetData2">
                        <%
                        
                        Enumeration e = itemList.elements();
                        String status = null;
                        
                        while(e.hasMoreElements()) {
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();
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
                            attName = itemAtt[2];
                            attValue = (String) wbo.getAttribute(attName);
                            
                            attValue = format.format(new Float(attValue));
                            %>
                            <TD> <input type="text" readonly name="price" id="price" value="<%=attValue%>">
                                
                                
                                
                            </TD>
                            <%
                            attName = itemAtt[3];
                            attValue = (String) wbo.getAttribute(attName);
                            
                            attValue = format.format(new Float(attValue));   
                            %>
                            <TD> <input type="text" readonly name="cost" id="cost" value="<%=attValue%>">
                                
                                
                                
                            </TD>
                            
                            <%
                            attName = itemAtt[5];
                            attValue = (String) wbo.getAttribute(attName);
                            %>
                            <TD> <input type="text"  name="maintTypeIndex" id="maintTypeIndex" value="<%=attValue%>" readonly> 
                                
                                <%
                                attName = itemAtt[4];
                                attValue = (String) wbo.getAttribute(attName);
                                %>
                                
                                <TD> <input type="text"  name="note" id="note" value=" <%=attValue%>">
                                
                                
                            </TD>
                            
                            <%
                            if(attachedEqFlag.equalsIgnoreCase("attached")) {
                                    if(wbo.getAttribute("attachedOn").equals("1")||wbo.getAttribute("attachedOn").equals("2")){%>
                            <TD> <input type="checkbox"  name="checkattachEq" id="checkattachEq" value="1" checked ></TD>
                            <%}else{%>
                            <TD> <input type="checkbox"  name="checkattachEq" id="checkattachEq" value="0" ></TD>
                            <%}
                            }%>
                            <TD> <input type="checkbox"  name="check" id="check" value="false">
                                
                                
                                
                            </TD>
                            <TD><input type="hidden" name="Hid" id="Hid" value="<%=(String) wbo.getAttribute(itemAtt[0])%>">
                            </TD>
                            
                            
                        </TR>
                        <%
                        }
                        
                        %>
                    </TBODY>
                </TABLE>
                <br><br>
                
            </FIELDSET>
        </FORM>
        <input type="hidden"  name="con" id="con" value="<%=iTotal%>">
        
    </BODY>
</HTML>     
