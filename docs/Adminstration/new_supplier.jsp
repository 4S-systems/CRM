<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <% 
    String status = (String) request.getAttribute("Status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String sup_number, sup_name, sup_address, sup_job, sup_phone, sup_fax, sup_city, sup_mail, sup_service, sup_notes, working_status;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    String fStatus;
    String sStatus;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        sup_name = "Supplier name";
        sup_number = "Supplier number";
        sup_address = "Supplier address";
        sup_job = "Supplier job";
        sup_phone = "Supplier phone";
        sup_fax = "Fax";
        sup_mail = "E-mail";
        sup_city = "Supplier city";
        sup_service = "Supplier service";
        sup_notes = "Notes";
        // sup_city = "Supplier city";
        working_status = "Working";
        
        
        title_1="New External Supplier";
        //title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        sStatus="Supplier Saved Successfully";
        fStatus="Fail To Save This Supplier";
        langCode="Ar";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        sup_name = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        sup_number = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        sup_address = "&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        sup_job = "&#1575;&#1604;&#1606;&#1588;&#1575;&#1591;";
        sup_phone = "&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
        sup_fax = "&#1575;&#1604;&#1601;&#1575;&#1603;&#1587;";
        sup_mail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
        sup_city = "&#1575;&#1604;&#1605;&#1583;&#1610;&#1606;&#1607;";
        sup_service = "&#1575;&#1604;&#1582;&#1583;&#1605;&#1607; ";
        sup_notes = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        //sup_city = "Supplier city";
        working_status = "&#1606;&#1588;&#1591;";
        
        
        title_1="&#1605;&#1608;&#1585;&#1583; &#1582;&#1575;&#1585;&#1580;&#1609; &#1580;&#1583;&#1610;&#1583;";
        //title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        
        langCode="En";
    }
    
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Employee</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="autosuggest.css">
    </HEAD>
    
    <script language="JavaScript">
        window.onload = function () {
        init("supplierNO");
        }
    </script>
    <script>
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
        var theBody = document.getElementsByTagName('body')[0];
theBody.appendChild(suggestionDiv); 
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

        suggestionDiv.style.top =(240+inputTextField.offsetTop+inputTextField.offsetHeight+document.getElementById("CellData").offsetTop+document.getElementById("MainTable").offsetTop) + "px";
        
        suggestionDiv.style.left = (60+inputTextField.offsetLeft+document.getElementById("CellData").offsetLeft+document.getElementById("MainTable").offsetLeft) + "px";
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
       
        var url = urlbase+"/SupplierServlet?op=SuppNoList";
        if (window.ActiveXObject)
        { 
        req = new ActiveXObject("Microsoft.XMLHTTP"); 
        } 
        else if (window.XMLHttpRequest)
        { 
        req = new XMLHttpRequest();
        } 
        req.open("Get",url,true); 
        req.onreadystatechange =  callbackFillUsernames;
        req.send(null);
        } 


        function callbackFillUsernames()
        { 
        if (req.readyState==4)
        { 
        if (req.status == 200)
        { 
        populateUsernames();
        } 
        } 
        } 

        function populateUsernames()
        {
        
        var nameString = req.responseText;
        var nameArray = nameString.split(',');

        lookAheadArray = nameArray;
       
        }

        /*
        * lookupUsername gets the customer information from the database
        */
        function lookupUsername(foundname){ 

        var username = document.getElementById("ajax_username");
        var url = urlbase+"/lookup?username=" + escape(foundname)+"&type="+ escape("2"); 
       
        if (window.XMLHttpRequest){ 
        req = new XMLHttpRequest(); 
        } 
        else if (window.ActiveXObject){ 
        req = new ActiveXObject("Microsoft.XMLHTTP"); 
        } 
        req.open("Get",url,true); 
        req.onreadystatechange = callbackLookupUser; 
        req.send(null);
        }     

        function callbackLookupUser(){ 
        if (req.readyState==4){ 
        if (req.status == 200){ 
        populateCustomerInfo();
        } 
        } 
        }
        
        
    </script>
    <!--script src='silkworm_validate.js' type='text/javascript'></script-->
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            if (!validateData("req", this.SUPPLIER_FORM.supplierNO, "Please, enter Supplier Number.") || !validateData("alphanumeric", this.SUPPLIER_FORM.supplierNO, "Please, enter a valid Supplier Number.")){
                this.SUPPLIER_FORM.supplierNO.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.supplierName, "Please, enter Supplier Name.") || !validateData("minlength=3", this.SUPPLIER_FORM.supplierName, "Please, enter a valid Supplier Name.")){
                this.SUPPLIER_FORM.supplierName.focus();
            } else if(!validateData("numeric", this.SUPPLIER_FORM.phone, "Please, enter a valid Phone Number.")){
                this.SUPPLIER_FORM.phone.focus();
            } else if(!validateData("numeric", this.SUPPLIER_FORM.fax, "Please, enter a valid Fax Number.")){
                this.SUPPLIER_FORM.fax.focus();
            } else if(!validateData("email", this.SUPPLIER_FORM.email, "Please, enter a valid Supplier Email.")){
                this.SUPPLIER_FORM.email.focus();
            } else{
                document.SUPPLIER_FORM.action = "<%=context%>/SupplierServlet?op=SaveSupplier";
                document.SUPPLIER_FORM.submit();  
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
    
    function checkEmail(email) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            return (true)
        }
            return (false)
    }
    
    function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
    
     function cancelForm()
        {    
        document.SUPPLIER_FORM.action = "main.jsp";
        document.SUPPLIER_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        
        
        
        <FORM NAME="SUPPLIER_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            <%
            if(null!=status) {
        if(status.equalsIgnoreCase("ok")){
            %>  
            <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="black"><%=sStatus%></font> 
                        </td>                    
                </tr> </table>
            </tr>
            <%
            }else{%>
            <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                </tr> </table>
            </tr>
            <%}
            }
            
            %>
            
            <!--table align="<%//=align%>" dir=<%//=dir%>>
            <TR COLSPAN="2" ALIGN="<%//=align%>">
            <TD STYLE="<%//=style%>" class='td'>
            <FONT color='red' size='+1'><%//=title_2%></FONT> 
                    </TD>
                   
                </TR>
            </table-->
            <br><br>
            
            <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0" id="MainTable">
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="supplierNO2">
                            <p><b><%=sup_number%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD  STYLE="<%=style%>"class='td' id="CellData">
                        <input type="TEXT" style="width:230px" name="supplierNO" ID="supplierNO" size="33" value="" maxlength="255" autocomplete="off">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="supplierName">
                            <p><b><%=sup_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" style="width:230px" name="supplierName" ID="supplierName" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="address">
                            <p><b><%=sup_address%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" style="width:230px" name="address" ID="address" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="designation">
                            <p><b><%=sup_job%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" style="width:230px" name="designation" ID="designation" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD  STYLE="<%=style%>" class='td'>
                        <LABEL FOR="phone">
                            <p><b><%=sup_phone%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD  STYLE="<%=style%>" class='td'>
                        <input type="TEXT" style="width:230px" name="phone" ID="phone" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>"class='td'>
                        <LABEL FOR="fax">
                            <p><b><%=sup_fax%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        
                        <input type="TEXT" style="width:230px" name="fax" ID="fax" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="city">
                            <p><b><%=sup_city%></b>&nbsp;
                        </LABEL>
                    </td>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" style="width:230px" name="city" ID="city" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="email">
                            <p><b><%=sup_mail%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" style="width:230px" name="email" ID="email" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="service">
                            <p><b><%=sup_service%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" style="width:230px" name="service" ID="service" size="33" value="" maxlength="255">
                    </TD>
                    
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="note">
                            <p><b><%=sup_notes%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <TEXTAREA style="width:230px" name="note" ID="note" COLS="25" ROWS="5"></textarea>
                    </TD>
                    
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="isActive">
                            <p><b><%=working_status%></b>
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <INPUT TYPE="CHECKBOX" name="isActive" ID="isActive" CHECKED>
                        </TD>
                    
                </TR>
                
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
