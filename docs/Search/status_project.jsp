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
        String op = (String) request.getAttribute("op");
        System.out.println("op---------------------" + op);
        String ts = (String) request.getAttribute("ts");
        System.out.println("ts---------------------" + ts);
        System.out.println("target op is " + op);

        //get session logged user and his trades
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        // get current date
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowTime = sdf.format(cal.getTime());

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

        String title, eqName, status, beginDate, endDate, search, cancel, fromJob, toJob, others, ftTitle, eqCode;

        if (stat.equals("En")) {
            title = "Search for Job Order";
            eqName = "Equipment Name";
            status = "Status";
            beginDate = "Begin Date";
            endDate = "End Date";
            search = "Search";
            cancel = "Cancel";
            fromJob = "From Job Order";
            toJob = "To Job Order";
            others = "Others";
            ftTitle = "From Job Order To Job Order";
            eqCode = "Equipment Code";
        } else {
            title = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604";
            eqName = "&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577";
            status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1607";
            beginDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577";
            endDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577";
            search = "&#1576;&#1581;&#1579";
            cancel = tGuide.getMessage("cancel");
            fromJob = "&#1605;&#1606; &#1585;&#1602;&#1605; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604;";
            toJob = "&#1575;&#1604;&#1609; &#1585;&#1602;&#1605; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604;";
            others = "&#1571;&#1582;&#1585;&#1610;";
            ftTitle = "&#1605;&#1606; &#1585;&#1602;&#1605; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604; &#1575;&#1604;&#1609; &#1585;&#1602;&#1605; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604;";
            eqCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        }

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">

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


            var dp_cal1,dp_cal12;
            window.onload = function (){
                dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
                init("projectName");
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
                var dd=document.getElementById('projectName');
                dd.value="";
            }

            function d(){
                var dd=document.getElementById('projectName');
                dd.value="Auto Select Name";
            }

            function addNew(){
                var TDName=document.getElementsByName('projectName');

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
                var TDNAME = document.getElementById('projectName');

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
        if(document.getElementById("Other").checked){
            var name=document.getElementById('projectName').value;
            for(var i=0;i<lookAheadArray.length;i++){
                if(lookAheadArray[i]==name){
                    document.getElementById('projectName').value=itemNames[i];
                    break;
                }
            }
            if (compareDate())
            {
                document.ISSUE_FORM.action = "<%=context%>/<%=ts%>?op=<%=op%>";
                document.ISSUE_FORM.submit();
            } else {
                alert('End Date must be greater than or equal Begin Date');
            }
        }
        else
        {
            var from = document.getElementById("fJob").value;
            var to = document.getElementById("tJob").value;
            if(!IsNumericInt("fJob") || from=="")
            {
                return false
            }
            if(to == ""){
                to = from;
                document.getElementById("tJob").value = to;
            }
            if(!IsNumericInt("tJob"))
            {
                return false;
            }
            if(parseInt(from) > parseInt(to)){
                alert("from must be less than to");
                return false;
            }
            document.FROM_TO_FORM.action = "<%=context%>/SearchServlet?op=StatusProjectList";
            document.FROM_TO_FORM.submit();
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
    function showHide(id){
        var divUnit = document.getElementById('code');
        var divUnit2 = document.getElementById('code2');
        var divMainType = document.getElementById('fromTo');
        if(id == 'ft'){
            divMainType.style.display = "block";
            divUnit.style.display = "none";
            divUnit2.style.display="none"
            document.getElementById("fJob").focus();
        }else{
            divUnit.style.display = "block";
            divUnit2.style.display = "block";
            divMainType.style.display = "none";
        }
    }
        </script>
    </HEAD>
    <BODY>
        <table align="center" width="80%">
            <tr><td class="td">
                    <fieldset align="center" class="set" style="">
                        <table class="blueBorder" dir="RTL" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                            <tr>
                                <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"><%=title%></FONT><BR></td>
                            </tr>
                        </table>
                        <br>
                        <br>
                        <div align="right" style="width: 89%" dir="rtl">
                            <font size="3"><input checked type="radio" value="Other" name="choice" id="Other" onclick="showHide(this.id)"><%=others%></font>
                        </div>
                        <br>
                        <FORM NAME="ISSUE_FORM" METHOD="POST">
                            <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                                <TR class="head">
                                    <TD class="blueHeaderTD" STYLE="text-align:center" WIDTH="50%">
                                        <LABEL FOR="Project_Name">
                                            <b> <font size=3 color="white"><%= eqName%></font></b>
                                        </LABEL>
                                    </TD>
                                    <TD class="blueHeaderTD" STYLE="text-align:center" WIDTH="50%">
                                        <LABEL FOR="statusName">
                                            <b><font size=3 color="white"> <%= status%></font></b>
                                        </LABEL>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD CLASS="cell" bgcolor="#EEEEEE" ROWSPAN="2" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ID="data">
                                        <input type="text" dir="ltr" autocomplete="off" value="All" onkeydown="JavaScript: checkKey(event);" ONCLICK="JavaScript: f();" id="projectName" name="projectName">
                                    </TD>
                                    <TD class="cell" STYLE="text-align:center;border-width:1px;border-color:white;" bgcolor="#EEEEEE">
                                        <SELECT name="statusName">
                                            <option value="ALL">ALL</option>
                                            <option value="Schedule">Schedule</option>
                                            <option value="Canceled">Canceled</option>
                                            <option value="Assigned">Assigned</option>
                                            <option value="Rejected">Rejected</option>
                                            <option value="Onhold">Onhold</option>
                                            <option value="Finished">Finished</option>
                                        </SELECT>
                                    </TD>
                                </TR>
                            </TABLE>
                            <TABLE class="blueBorder" id="code2" ALIGN="center" DIR="RTL" WIDTH=650 CELLSPACING=2 CELLPADDING=1 STYLE="border-width:1px;border-color:white;display: block;">
                                <TR class="head">
                                    <TD class="blueHeaderTD" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" WIDTH="50%">
                                        <b><font size=3 color="white"><%= beginDate%></font> </b>
                                    </TD>
                                    <TD class="blueHeaderTD" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" WIDTH="50%">
                                        <b> <font size=3 color="white"><%= endDate%></font></b>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" bgcolor="#EEEEEE"  valign="MIDDLE" >
                                        <%
                                            String url = request.getRequestURL().toString();
                                            String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" >
                                        <br><br>
                                    </TD>
                                    <td STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;"  bgcolor="#EEEEEE"  style="text-align:right" valign="middle">
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" >
                                        <br><br>
                                    </td>
                                </TR>
                            </TABLE>
                        </FORM>
                        <br>
                        <br>
                        <br>
                        <div align="right" style="width: 89%;" dir="rtl">
                            <font size="3"><input type="radio" value="Other" name="choice" id="ft" onclick="showHide(this.id)"><%=ftTitle%></font>
                        </div>
                        <br>
                        <form name="FROM_TO_FORM" method="post">
                            <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="fromTo" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: none" >
                                <TR>
                                    <TD class="blueHeaderTD" STYLE="text-align:center"  BGCOLOR="#cc6699" WIDTH="50%">

                                        <LABEL FOR="fromOrder">
                                            <p><b> <font size=3 color="white"><%=fromJob%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD class="blueHeaderTD" STYLE="text-align:center"  BGCOLOR="#cc6699" WIDTH="50%">
                                        <LABEL FOR="toOrder">
                                            <p><b><font size=3 color="white"> <%=toJob%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD CLASS="cell" bgcolor="#EEEEEE" ROWSPAN="2" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;">
                                        <input type="text" dir="ltr" id="fJob" name="fromJob" >
                                    </TD>
                                    <TD STYLE="text-align:center" bgcolor="#EEEEEE" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;">
                                        <input type="text" dir="ltr" id="tJob" name="toJob" >
                                        <input type="hidden" name="statusName" value="FromTo">
                                    </TD>
                                </TR>
                            </TABLE>
                        </form>
                        <br>
                        <div align="center">
                            <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                            <button  onclick="JavaScript: submitForm();" class="button">   <%= search%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        </div>
                        <br>
                    </fieldset>
                </td>
            </tr>
        </table>
    </BODY>
</HTML>
