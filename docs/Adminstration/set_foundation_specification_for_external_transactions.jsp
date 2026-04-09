<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>



<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">

    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String status = (String) request.getAttribute("status");

        String context = metaMgr.getContext();
        ArrayList ERPTransactionsList = (ArrayList) request.getAttribute("ERPTransactions");

        String update = (String) request.getAttribute("update");

        String dismissId = "", dismissTrnsCode = "", dismissFromSide = "", dismissFromCode = "", dismissToSide = "", dismissToCode = "";
        String returnId = "", returnTrnsCode = "", returnFromSide = "", returnFromCode = "", returnToSide = "", returnToCode = "";
        String retConsId = "", retConsTrnsCode = "", retConsFromSide = "", retConsFromCode = "", retConsToSide = "", retConsToCode = "";

        if (update.equals("yes")) {

            WebBusinessObject dismissWbo = (WebBusinessObject) request.getAttribute("dismissWbo");
            if (dismissWbo != null) {
                dismissId = (String) dismissWbo.getAttribute("id");
                dismissTrnsCode = (String) dismissWbo.getAttribute("transType");
                dismissFromSide = (String) dismissWbo.getAttribute("fromSide");
                dismissFromCode = (String) dismissWbo.getAttribute("fromCode");
                dismissToSide = (String) dismissWbo.getAttribute("toSide");
                dismissToCode = (String) dismissWbo.getAttribute("toCode");
            }
            WebBusinessObject returnWbo = (WebBusinessObject) request.getAttribute("returnWbo");
            if (returnWbo != null) {
                returnId = (String) returnWbo.getAttribute("id");
                returnTrnsCode = (String) returnWbo.getAttribute("transType");
                returnFromSide = (String) returnWbo.getAttribute("fromSide");
                returnFromCode = (String) returnWbo.getAttribute("fromCode");
                returnToSide = (String) returnWbo.getAttribute("toSide");
                returnToCode = (String) returnWbo.getAttribute("toCode");
            }
            WebBusinessObject consWbo = (WebBusinessObject) request.getAttribute("consWbo");
            if (consWbo != null) {
                retConsId = (String) consWbo.getAttribute("id");
                retConsTrnsCode = (String) consWbo.getAttribute("transType");
                retConsFromSide = (String) consWbo.getAttribute("fromSide");
                retConsFromCode = (String) consWbo.getAttribute("fromCode");
                retConsToSide = (String) consWbo.getAttribute("toSide");
                retConsToCode = (String) consWbo.getAttribute("toCode");
            }
        }

        String cMode = (String) request.getSession().getAttribute("currentMode");

        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, dismissRequest, returnRequest, from, to,
                save, Titel, store, department, consStore, returnedConsumption,search;



        String sSccess, sFail;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            save = "Save";
            Titel = "Foundation Specification for External Transactions";
            store = "Store";
            department = "Department";
            dismissRequest = "Dismiss Request";
            returnRequest = "Return Request";
            from = "From";
            to = "To";
            sSccess = "Specs was save successfully";
            sFail = "Failed to save";
            returnedConsumption = "Returned Consumption";
            consStore = "Consumption Store";
            search = "Search";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            save = "&#1587;&#1580;&#1604; ";
            Titel = "&#1605;&#1608;&#1575;&#1589;&#1601;&#1577; &#1575;&#1604;&#1573;&#1606;&#1588;&#1575;&#1569; &#1604;&#1604;&#1581;&#1585;&#1603;&#1575;&#1578; &#1575;&#1604;&#1582;&#1575;&#1585;&#1580;&#1610;&#1577;";
            store = "&#1605;&#1582;&#1586;&#1606;";
            department = "&#1573;&#1583;&#1575;&#1585;&#1577;";
            dismissRequest = "&#1591;&#1604;&#1576; &#1575;&#1604;&#1589;&#1585;&#1601;";
            returnRequest = "&#1591;&#1604;&#1576; &#1575;&#1604;&#1573;&#1585;&#1578;&#1580;&#1575;&#1593;";
            from = "&#1605;&#1606;";
            to = "&#1573;&#1604;&#1609;";
            sSccess = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
            sFail = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            returnedConsumption = "&#1573;&#1585;&#1578;&#1580;&#1575;&#1593; &#1605;&#1587;&#1578;&#1607;&#1604;&#1603;";
            consStore = "&#1605;&#1582;&#1586;&#1606; &#1605;&#1587;&#1578;&#1607;&#1604;&#1603;&#1575;&#1578;";
            search="&#1576;&#1581;&#1579;";
        }

    %>


    <HEAD>
        <title>Create New Equipment Schedule</title>

        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/headers.css" />
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
        <link rel="stylesheet" type="text/css" href="Button.css">
        <link rel="STYLESHEET" type="text/css" href="css/dhtmlxcombo.css">

        <script type="text/javascript" src="js/dhtmlxcommon.js"></script>
        <script type="text/javascript"  src="js/dhtmlxcombo.js"></script>
        <script src='ChangeLanj.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            var count = 0;
            var itemsCode;
            var itemNames;
            var nowMode="code";
            var priorty=0;

            function submitForm() {
                
                
                var typeCodeFound = true;

                if(document.getElementById('dismiss_from_side').value!='store'
                    && document.getElementById('dismiss_from_code').value == '') {
                    typeCodeFound = false;
                    document.SPECIFICATION_FORM.dismiss_from_code.focus();
                } else if(document.getElementById('dismiss_to_side').value!='store'
                    && document.getElementById('dismiss_to_code').value == '') {
                    typeCodeFound = false;
                    document.SPECIFICATION_FORM.dismiss_to_code.focus();
                } else if(document.getElementById('return_from_side').value!='store'
                    && document.getElementById('return_from_code').value == '0') {
                    document.SPECIFICATION_FORM.return_from_code.focus();
                    typeCodeFound = false;
                    
                } else if(document.getElementById('return_to_side').value!='store'
                    && document.getElementById('return_to_code').value == '0') {
                    document.SPECIFICATION_FORM.return_to_code.focus();
                    typeCodeFound = false;
                    
                } else if(document.getElementById('ret_cons_from_side').value!='store'
                    && document.getElementById('ret_cons_from_code').value == '0') {
                    document.SPECIFICATION_FORM.ret_cons_from_code.focus();
                    typeCodeFound = false;
                    
                } else if(document.getElementById('ret_cons_to_side').value!='store'
                    && document.getElementById('ret_cons_to_code').value == '0') {
                    document.SPECIFICATION_FORM.ret_cons_to_code.focus();
                    typeCodeFound = false;
                    
                }
                    
                if(!typeCodeFound) {
                    alert("code was not found");

                } else {
                    document.SPECIFICATION_FORM.action = "<%=context%>/TransactionServlet?op=saveFoundationSpecificationForExternalTransactionsForm&update=<%=update%>";
                    document.SPECIFICATION_FORM.submit();

                }

            }

            function cancelForm(url) {
                window.navigate(url);
            }

            function toggleTextField(comp) {
                
                var compName = comp.getAttribute("name");
                var compValue = comp.getAttribute("value");
                var textFieldName;
                var buttonId;
                switch (compName)
                {
                    case "dismiss_from_side":
                        textFieldName = "dismiss_from_code";
                        buttonId="dismissFrom";
                        break;
                    case "dismiss_to_side":
                        textFieldName = "dismiss_to_code";
                        buttonId="dismissTo";
                        break;
                    case "return_from_side":
                        textFieldName = "return_from_code";
                        buttonId="returnFrom";
                        break;
                    case "return_to_side":
                        textFieldName = "return_to_code";
                        buttonId="returnTo";
                        break;
                    case "ret_cons_from_side":
                        textFieldName = "ret_cons_from_code";
                        buttonId="usedFrom";
                        break;
                    default:
                        textFieldName = "ret_cons_to_code";
                        buttonId="usedTo";
                }
                
                if(compValue == "store") {
                    document.getElementById(textFieldName).style.display = "none";
                    document.getElementById(textFieldName).value = '';
                    document.getElementById(buttonId).style.display = "none";
                    document.getElementById(buttonId).value = '';
                } else {
                    document.getElementById(textFieldName).style.display = "block";
                    document.getElementById(textFieldName).focus();
                    document.getElementById(buttonId).style.display = "block";
                    document.getElementById(buttonId).value=document.getElementById("search").value;
                    document.getElementById(buttonId).focus();
                }
                
            }

            function changeMode(name) {
                if(document.getElementById(name).style.display == 'none'){
                    document.getElementById(name).style.display = 'block';
                } else {
                    document.getElementById(name).style.display = 'none';
                }
            }

            function checkDismissFromCode() {

                var typeCode = document.getElementById('dismiss_from_code').value;

                // clear select form and selected Form
                document.getElementById('dismiss_from_code_hidden').value = "0";

                if(typeCode != '') {

                    var url = "<%=context%>/ajaxServlet?op=checkTypeCode&type=dep&typeCode=" + typeCode;
                    if (window.XMLHttpRequest) {
                        req = new XMLHttpRequest();
                    }
                    else if (window.ActiveXObject) {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("POST",url,true);
                    req.onreadystatechange = callbackDismissFromCode;
                    req.send(null);

                }
            }

            function callbackDismissFromCode(){
                if (req.readyState==4) {
                    if (req.status == 200) {
                        // write in response 0 or 1
                        document.getElementById('dismiss_from_code_hidden').value = req.responseText;

                        if(req.responseText == "0") {
                            alert("code was not found");
                            document.SPECIFICATION_FORM.dismiss_from_code.focus();
                        }
                    }
                }
            }

            function checkDismissToCode() {
                var typeCode = document.getElementById('dismiss_to_code').value;
                // clear select form and selected Form
                document.getElementById('dismiss_to_code_hidden').value = "0";

                if(typeCode != '') {
                    var url = "<%=context%>/ajaxServlet?op=checkTypeCode&type=dep&typeCode=" + typeCode;
                    if (window.XMLHttpRequest) {
                        req = new XMLHttpRequest();
                    }
                    else if (window.ActiveXObject) {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("POST",url,true);
                    req.onreadystatechange = callbackDismissToCode;
                    req.send(null);
                }
            }

            function callbackDismissToCode(){
                if (req.readyState==4) {
                    if (req.status == 200) {
                        // write in response 0 or 1
                        document.getElementById('dismiss_to_code_hidden').value = req.responseText;

                        if(req.responseText == "0") {
                            alert("code was not found");
                            document.SPECIFICATION_FORM.dismiss_to_code.focus();
                            
                        }
                    }
                }
            }

            function checkReturnFromCode() {
                var typeCode = document.getElementById('return_from_code').value;
                // clear select form and selected Form
                document.getElementById('return_from_code_hidden').value = "0";

                if(typeCode != '') {
                    var url = "<%=context%>/ajaxServlet?op=checkTypeCode&type=dep&typeCode=" + typeCode;
                    if (window.XMLHttpRequest) {
                        req = new XMLHttpRequest();
                    }
                    else if (window.ActiveXObject) {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("POST",url,true);
                    req.onreadystatechange = callbackReturnFromCode;
                    req.send(null);
                }
            }

            function callbackReturnFromCode(){
                if (req.readyState==4) {
                    if (req.status == 200) {
                        // write in response 0 or 1
                        document.getElementById('return_from_code_hidden').value = req.responseText;

                        if(req.responseText == "0") {
                            alert("code was not found");
                            document.SPECIFICATION_FORM.return_from_code.focus();
                            
                        }
                    }
                }
            }

            function checkReturnToCode() {
                var typeCode = document.getElementById('return_to_code').value;
                // clear select form and selected Form
                document.getElementById('return_to_code_hidden').value = "0";

                if(typeCode != '') {
                    var url = "<%=context%>/ajaxServlet?op=checkTypeCode&type=dep&typeCode=" + typeCode;
                    if (window.XMLHttpRequest) {
                        req = new XMLHttpRequest();
                    }
                    else if (window.ActiveXObject) {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("POST",url,true);
                    req.onreadystatechange = callbackReturnToCode;
                    req.send(null);
                }
            }

            function callbackReturnToCode(){
                if (req.readyState==4) {
                    if (req.status == 200) {
                        // write in response 0 or 1
                        document.getElementById('return_to_code_hidden').value = req.responseText;

                        if(req.responseText == "0") {
                            alert("code was not found");
                            document.SPECIFICATION_FORM.return_to_code.focus();
                            
                        }
                    }
                }
            }

            function checkRetConsFromCode() {
                var typeCode = document.getElementById('ret_cons_from_code').value;
                var typeSide = document.getElementById('ret_cons_from_side').value;
                var url;

                // clear select form and selected Form
                document.getElementById('ret_cons_from_code_hidden').value = "0";

                if(typeCode != '') {

                    if(typeSide == 'department') {
                        url = "<%=context%>/ajaxServlet?op=checkTypeCode&type=dep&typeCode=" + typeCode;

                    } else {
                        url = "<%=context%>/ajaxServlet?op=checkTypeCode&type=store&typeCode=" + typeCode;

                    }
                   
                    if (window.XMLHttpRequest) {
                        req = new XMLHttpRequest();
                    }
                    else if (window.ActiveXObject) {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("POST",url,true);
                    req.onreadystatechange = callbackRetConsFromCode;
                    req.send(null);
                }
            }

            function callbackRetConsFromCode(){
                if (req.readyState==4) {
                    if (req.status == 200) {
                        // write in response 0 or 1
                        document.getElementById('ret_cons_from_code_hidden').value = req.responseText;
                        var t=setTimeout("5+6",1500);
                        if(req.responseText == "0") {
                            alert("code was not found");
                            document.SPECIFICATION_FORM.ret_cons_from_code.focus();

                        }
                    }
                }
            }

            function checkRetConsToCode() {
                var typeCode = document.getElementById('ret_cons_to_code').value;
                var typeSide = document.getElementById('ret_cons_to_side').value;
                var url;
                
                // clear select form and selected Form
                document.getElementById('ret_cons_to_code_hidden').value = "0";

                if(typeCode != '') {

                    if(typeSide == 'department') {
                        url = "<%=context%>/ajaxServlet?op=checkTypeCode&type=dep&typeCode=" + typeCode;

                    } else {
                        url = "<%=context%>/ajaxServlet?op=checkTypeCode&type=store&typeCode=" + typeCode;

                    }
                    
                    if (window.XMLHttpRequest) {
                        req = new XMLHttpRequest();
                    }
                    else if (window.ActiveXObject) {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("POST",url,true);
                    req.onreadystatechange = callbackRetConsToCode;
                    req.send(null);
                }
            }

            function callbackRetConsToCode(){
                if (req.readyState==4) {
                    if (req.status == 200) {
                        // write in response 0 or 1
                        
                        document.getElementById('ret_cons_to_code_hidden').value = req.responseText;
                        var t=setTimeout("5+6",1500);
                        if(req.responseText == "0") {
                            alert("code was not found");
                            document.SPECIFICATION_FORM.ret_cons_to_code.focus();

                        }
                    }
                }
            }

            function openWindow(url) {
            
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=400");
            }
            function getFormDetails() {
            
                //var stores = document.getElementById('stores').value;
                openWindow('ReportsServlet?op=getFormDetails&formCode=STR-INTEG-2');
            }
             function openWindowDest(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
            }


            function getDismissFrom()
                {   var type ;
                    if(document.getElementById('dismiss_from_side').value=='department'){
                        type=6;
                    }else if(document.getElementById('dismiss_from_side').value=='consStore'){
                        type=4;
                    }
                    var sCode = 'dismiss_from_code';
                    openWindowDest('TransactionServlet?op=listDest&type='+type+'&sCode='+sCode+'&formName=SPECIFICATION_FORM');
                    }
            function getDismissTo()
            {   var type ;
                if(document.getElementById('dismiss_to_side').value=='department'){
                    type=6;
                }else if(document.getElementById('dismiss_to_side').value=='consStore'){
                    type=4;
                }
                var sCode = 'dismiss_to_code';
                openWindowDest('TransactionServlet?op=listDest&type='+type+'&sCode='+sCode+'&formName=SPECIFICATION_FORM');
                }
            function getReturnFrom()
                {   var type ;
                    if(document.getElementById('return_from_side').value=='department'){
                        type=6;
                    }else if(document.getElementById('return_from_side').value=='consStore'){
                        type=4;
                    }
                    var sCode = 'return_from_code';
                    openWindowDest('TransactionServlet?op=listDest&type='+type+'&sCode='+sCode+'&formName=SPECIFICATION_FORM');
                    }
            function getReturnTo()
            {   var type ;
                if(document.getElementById('return_to_side').value=='department'){
                    type=6;
                }else if(document.getElementById('return_to_side').value=='consStore'){
                    type=4;
                }
                var sCode = 'return_to_code';
                openWindowDest('TransactionServlet?op=listDest&type='+type+'&sCode='+sCode+'&formName=SPECIFICATION_FORM');
                }

            

            function getUsedFrom()
                {   var type ;
                    if(document.getElementById('ret_cons_from_side').value=='department'){
                        type=6;
                    }else if(document.getElementById('ret_cons_from_side').value=='consStore'){
                        type=4;
                    }
                    var sCode = 'ret_cons_from_code';
                    openWindowDest('TransactionServlet?op=listDest&type='+type+'&sCode='+sCode+'&formName=SPECIFICATION_FORM');
                    }

            function getUsedTo()
                {   var type ;
                    if(document.getElementById('ret_cons_to_side').value=='department'){
                        type=6;
                    }else if(document.getElementById('ret_cons_to_side').value=='consStore'){
                        type=4;
                    }
                    var sCode = 'ret_cons_to_code';
                    openWindowDest('TransactionServlet?op=listDest&type='+type+'&sCode='+sCode+'&formName=SPECIFICATION_FORM');
                    }
               
        </SCRIPT>
    </HEAD>

    <BODY>
        <FORM action=""  name="SPECIFICATION_FORM" method="post">
            <DIV align="left" STYLE="color:blue;padding-left: 5%">
                <input type="hidden" id="search" name="search" value="<%=search%>">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save%></button>
                <input type="button" name="formDetails" class="button" onclick="getFormDetails()" value="Form Details" />
            </DIV>
            <br>
            <center>
                <fieldset class="set" style="width:90%;border-color: #006699;">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=Titel%></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>

                    <%if (status != null) {%>
                    <table width="50%" align="center">
                        <tr>
                            <%if (status.equalsIgnoreCase("ok")) {%>
                            <td class="bar">
                                <b><font color="blue" size="3"><%=sSccess%></font></b>
                            </td>
                            <%} else {%>
                            <td class="bar">
                                <b><font color="red" size="3"><%=sFail%></font></b>
                            </td>
                            <%}%>
                        </tr>
                    </table>
                    <br>
                    <%}%>

                    <TABLE class="backgroundTable" width="95%" ALIGN="<%=align%>" DIR="<%=dir%>" cellpadding="0" cellspacing="8" ID="MainTable2">

                        <TR>

                            <TD class="backgroundHeader" style="<%=style%>;width:15%">
                                <p><b style="margin-left: 5px;margin-right: 5px;font-weight: bold"><%=dismissRequest%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;width:15%;color:white; font-size:14px; border-width:0px;">
                                <SELECT name="dismissTrnsCode" ID="dismissTrnsCode" STYLE="z-index:-1;color: black; font-weight: bold; font-size: 12px;">
                                    <sw:OptionsList listAsArrayList="<%=ERPTransactionsList%>" displayAttribute = "trnsDesc" valueAttribute="trnsCode" scrollTo="<%=dismissTrnsCode%>"/>
                                </SELECT>
                            </TD>

                            <TD class="backgroundHeader" style="<%=style%>;width:10%">
                                <p><b style="<%=style%>;margin-left: 5px;margin-right: 5px;font-weight: bold"><%=from%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;color:white; font-size:14px; border-width:0px;width:15%;">
                                <SELECT NAME="dismiss_from_side" ID="dismiss_from_side" style="width:100%;color: black; font-weight: bold; font-size: 12px" onchange="toggleTextField(this);">
                                    <OPTION VALUE="store"><%=store%>
                                    <OPTION VALUE="department" <%if (dismissFromSide != null && dismissFromSide.equals("department")) {%> SELECTED <%}%>><%=department%>
                                </SELECT>
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input type="TEXT" readonly name="dismiss_from_code" ID="dismiss_from_code" size="5" value="<%=dismissFromCode%>" maxlength="5" style="<%=style%>;width:100%;color: black; font-weight: bold; font-size: 12px;<%if (dismissFromCode.equals("")) {%> display: none; <%}%>">
                                <INPUT TYPE="hidden" name="dismiss_from_code_hidden" value="">
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input id="dismissFrom" type="button" value="<%=search%>" <%if (dismissFromCode.equals("")) {%> style="display: none;" <%}%> onclick="javascript:getDismissFrom();">
                            </TD>
                            <TD class="backgroundHeader" style="<%=style%>;width:10%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=to%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;color:white; font-size:14px; border-width:0px;width:15%">
                                <SELECT NAME="dismiss_to_side" ID="dismiss_to_side" style="width:100%;color: black; font-weight: bold; font-size: 12px" onchange="toggleTextField(this);">
                                    <OPTION VALUE="store"><%=store%>
                                    <OPTION VALUE="department" <%if (dismissToSide != null && dismissToSide.equals("department")) {%> SELECTED <%}%>><%=department%>
                                </SELECT>
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input type="TEXT" readonly name="dismiss_to_code" ID="dismiss_to_code" size="5" value="<%=dismissToCode%>" maxlength="5" style="<%=style%>;width:100%;color: black; font-weight: bold; font-size: 12px;<%if (dismissToCode.equals("")) {%> display: none; <%}%>">
                                <INPUT TYPE="hidden" name="dismiss_to_code_hidden" value="">
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input id="dismissTo" type="button" value="<%=search%>" <%if (dismissToCode.equals("")) {%> style="display: none;" <%}%> onclick="javascript:getDismissTo();">
                            </TD>
                        </TR>

                        <TR>

                            <TD class="backgroundHeader" style="<%=style%>;width:15%">
                                <p><b style="margin-left: 5px;margin-right: 5px;font-weight: bold"><%=returnRequest%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;width:15%;color:white; font-size:14px; border-width:0px;">
                                <SELECT name="returnTrnsCode" ID="returnTrnsCode" STYLE="z-index:-1;color: black; font-weight: bold; font-size: 12px;">
                                    <sw:OptionsList listAsArrayList='<%=ERPTransactionsList%>' displayAttribute = "trnsDesc" valueAttribute="trnsCode" scrollTo="<%=returnTrnsCode%>"/>
                                </SELECT>
                            </TD>

                            <TD class="backgroundHeader" style="<%=style%>;width:10%">
                                <p><b style="<%=style%>;margin-left: 5px;margin-right: 5px;font-weight: bold"><%=from%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;color:white; font-size:14px; border-width:0px;width:15%">
                                <SELECT NAME="return_from_side" ID="return_from_side" style="width:100%;color: black; font-weight: bold; font-size: 12px" onchange="toggleTextField(this);">
                                    <OPTION VALUE="store"><%=store%>
                                    <OPTION VALUE="department" <%if (returnFromSide != null && returnFromSide.equals("department")) {%> SELECTED <%}%>><%=department%>
                                </SELECT>
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <INPUT type="TEXT" readonly name="return_from_code" ID="return_from_code" size="5" value="<%=returnFromCode%>" maxlength="5" style="<%=style%>;width:100%;color: black; font-weight: bold; font-size: 12px;<%if (returnFromCode.equals("")) {%> display: none; <%}%>">
                                <INPUT TYPE="hidden" name="return_from_code_hidden" value="">
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input id="returnFrom" type="button" value="<%=search%>" <%if (returnFromCode.equals("")) {%> style="display: none;" <%}%> onclick="javascript:getReturnFrom();">
                            </TD>
                            <TD class="backgroundHeader" style="<%=style%>;width:10%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=to%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;color:white; font-size:14px; border-width:0px;width:15%">
                                <SELECT NAME="return_to_side" ID="return_to_side" style="width:100%;color: black; font-weight: bold; font-size: 12px" onchange="toggleTextField(this);">
                                    <OPTION VALUE="store"><%=store%>
                                    <OPTION VALUE="department" <%if (returnToSide != null && returnToSide.equals("department")) {%> SELECTED <%}%>><%=department%>
                                </SELECT>
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input type="TEXT" readonly name="return_to_code" ID="return_to_code" size="5" value="<%=returnToCode%>" maxlength="5" style="<%=style%>;width:100%;color: black; font-weight: bold; font-size: 12px;<%if (returnToCode.equals("")) {%> display: none; <%}%>">
                                <INPUT TYPE="hidden" name="return_to_code_hidden" value="">
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input id="returnTo" type="button" value="<%=search%>" <%if (returnToCode.equals("")) {%> style="display: none;" <%}%> onclick="javascript:getReturnTo();">
                            </TD>
                        </TR>

                        <TR>

                            <TD class="backgroundHeader" style="<%=style%>;width:15%">
                                <p><b style="margin-left: 5px;margin-right: 5px;font-weight: bold"><%=returnedConsumption%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;width:15%;color:white; font-size:14px; border-width:0px;">
                                <SELECT name="retConsTrnsCode" ID="retConsTrnsCode" STYLE="z-index:-1;color: black; font-weight: bold; font-size: 12px;">
                                    <sw:OptionsList listAsArrayList='<%=ERPTransactionsList%>' displayAttribute = "trnsDesc" valueAttribute="trnsCode" scrollTo="<%=retConsTrnsCode%>"/>
                                </SELECT>
                            </TD>

                            <TD class="backgroundHeader" style="<%=style%>;width:10%">
                                <p><b style="<%=style%>;margin-left: 5px;margin-right: 5px;font-weight: bold"><%=from%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;color:white; font-size:14px; border-width:0px;width:15%">
                                <SELECT NAME="ret_cons_from_side" ID="ret_cons_from_side" style="width:100%;color: black; font-weight: bold; font-size: 12px" onchange="toggleTextField(this);">
                                    <OPTION VALUE="store"><%=store%>
                                    <OPTION VALUE="department" <%if (retConsFromSide != null && retConsFromSide.equals("department")) {%> SELECTED <%}%>><%=department%>
                                    <OPTION VALUE="consStore" <%if (retConsFromSide != null && retConsFromSide.equals("consStore")) {%> SELECTED <%}%>><%=consStore%>
                                </SELECT>
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <INPUT type="TEXT" readonly name="ret_cons_from_code" ID="ret_cons_from_code" size="5" value="<%=retConsFromCode%>" maxlength="5" style="<%=style%>;width:100%;color: black; font-weight: bold; font-size: 12px;<%if (retConsFromCode.equals("")) {%> display: none; <%}%>">
                                <INPUT TYPE="hidden" name="ret_cons_from_code_hidden" value="">
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input id="usedFrom" type="button" value="<%=search%>" <%if (retConsFromCode.equals("")) {%> style="display: none;" <%}%> onclick="javascript:getUsedFrom();">
                            </TD>
                            <TD class="backgroundHeader" style="<%=style%>;width:10%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=to%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>;color:white; font-size:14px; border-width:0px;width:15%">
                                <SELECT NAME="ret_cons_to_side" ID="ret_cons_to_side" style="width:100%;color: black; font-weight: bold; font-size: 12px" onchange="toggleTextField(this);">
                                    <OPTION VALUE="store"><%=store%>
                                    <OPTION VALUE="department" <%if (retConsToSide != null && retConsToSide.equals("department")) {%> SELECTED <%}%>><%=department%>
                                    <OPTION VALUE="consStore" <%if (retConsToSide != null && retConsToSide.equals("consStore")) {%> SELECTED <%}%>><%=consStore%>
                                </SELECT>
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <INPUT type="TEXT" readonly name="ret_cons_to_code" ID="ret_cons_to_code" size="5" value="<%=retConsToCode%>" maxlength="5" style="<%=style%>;width:100%;color: black; font-weight: bold; font-size: 12px;<%if (retConsToCode.equals("")) {%> display: none; <%}%>">
                                <INPUT TYPE="hidden" name="ret_cons_to_code_hidden" value="">                                
                            </TD>
                            <TD STYLE="<%=style%>;width:10%;color:white; font-size:14px; border-width:0px" >
                                <input id="usedTo" type="button" value="<%=search%>" <%if (retConsToCode.equals("")) {%> style="display: none;" <%}%> onclick="javascript:getUsedTo();">
                            </TD>
                        </TR>

                        <INPUT TYPE="hidden" name="dismissId" value="<%=dismissId%>">
                        <INPUT TYPE="hidden" name="returnId" value="<%=returnId%>">
                        <INPUT TYPE="hidden" name="retConsId" value="<%=retConsId%>">

                    </TABLE>

                    <br>
                </fieldset>
            </center>

            <input type="hidden" name="nRows" id="nRows" value="">
        </FORM>
    </BODY>
</HTML>