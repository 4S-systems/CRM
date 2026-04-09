<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        /* Stores Data */
        ArrayList allStores = (ArrayList) request.getAttribute("allStores");
        String selectedStore = (String) request.getAttribute("selectedStore");
        String selectedBranch = (String) request.getAttribute("selectedBranch");
        ArrayList itemFormForSelectedStore = (ArrayList) request.getAttribute("itemFormForSelectedStore");
        String selectedForm = (String) request.getAttribute("selectedForm");
        String status = (String) request.getAttribute("Status");
        if(status == null) status = "";

        WebBusinessObject taskWbo = new WebBusinessObject();
        Vector taskParts=new Vector();
        taskWbo = (WebBusinessObject) request.getAttribute("taskWbo");
        taskParts = (Vector) request.getAttribute("taskParts");
        WebBusinessObject itemWbo = new WebBusinessObject();
        itemWbo = (WebBusinessObject) request.getAttribute("itemWbo");
        
        String taskName = (String) taskWbo.getAttribute("title");
        String itemName = (String) itemWbo.getAttribute("itemDscrptn");
        String mainItemId = (String) itemWbo.getAttribute("itemCodeByItemForm");
        String taskId = (String) taskWbo.getAttribute("id");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String  stat = cMode;
        String align=null;
        String dir=null;
        String lang , langCode;
        String title_2;
        String cancel_button_label;
        String fStatus;
        String sStatus;
        String save_button_label;
        String AddCode, AddName, itemCode, name, price, count, cost, Mynote, del, updateParts1,updateParts2, classGroup, totalCost, setupStoreNote, storeAva, select, notFoundItemForm;

        if(stat.equals("En")) {
            align="center";
            dir="LTR";
            lang="   &#1593;&#1585;&#1576;&#1610;    ";
            title_2=taskName;
            cancel_button_label="Cancel ";
            save_button_label="Save ";
            langCode="Ar";
            sStatus="Maintenance Item Saved Successfully";
            fStatus="Fail To Save Maintenance Item ";
            select = "Select";
            storeAva = "Available Stroes";
            AddCode="  Add using Part Code  ";
            AddName="  Add using Part Name  ";
            itemCode="Code";
            name="Name";
            price="Price";
            count="Quntity";
            cost="Total Price";
            Mynote="Note";
            del="Delete";
            updateParts1="Add alternative Spare Parts to ";
            updateParts2=" on Maintenance Item";
            classGroup="Gorups of items";
            totalCost="Total cost of spare parts";
            setupStoreNote = "Should be prepared store for the program";
            notFoundItemForm = "Not Found Categories";
        } else {
            select = "&#1571;&#1582;&#1578;&#1575;&#1585;";
            align="center";
            dir="RTL";
            lang="English";
            title_2=taskName;
            cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label="&#1585;&#1576;&#1591; &#1575;&#1604;&#1576;&#1583;&#1575;&#1574;&#1604;";
            langCode="En";
            fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            storeAva = "&#1575;&#1604;&#1605;&#1600;&#1600;&#1582;&#1600;&#1600;&#1575;&#1586;&#1606; &#1575;&#1604;&#1605;&#1600;&#1600;&#1578;&#1575;&#1581;&#1600;&#1600;&#1577;";
            AddCode="   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;   ";
            AddName="   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;   ";
            itemCode="&#1575;&#1604;&#1603;&#1608;&#1583;";
            name="&#1575;&#1604;&#1573;&#1587;&#1605;";
            price="&#1575;&#1604;&#1587;&#1593;&#1585; ";
            count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
            cost=" &#1575;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
            Mynote="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            del="&#1581;&#1584;&#1601; ";
            updateParts1="&#1573;&#1590;&#1575;&#1601;&#1577; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1576;&#1583;&#1610;&#1604;&#1577; &#1604; ";
            updateParts2=" &#1593;&#1604;&#1609; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; ";
            classGroup="&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578; &#1575;&#1604;&#1571;&#1589;&#1606;&#1575;&#1601;";
            totalCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1609; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1604;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            setupStoreNote="&#1610;&#1580;&#1576; &#1573;&#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1604;&#1604;&#1576;&#1585;&#1606;&#1575;&#1605;&#1580;";
            notFoundItemForm = "\u0644\u0627 \u062A\u0648\u062C\u062F \u0627\u0635\u0646\u0627\u0641";
        }

        String storeNameAttribute = "storeName" + stat;
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Maintenance - add Parts</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
        window.onload = function () {
           checNumeric();
        }

        function submitForm() {
        
            checkNote();
            if(document.getElementsByName('check').length>0){
                if(checkQuantity()) {
                    document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=saveAlterItemParts&taskId=<%=taskId%>&mainItemId=<%=mainItemId%>";
                    document.ITEM_FORM.submit();
                }
            } else {
                alert("Must Add at least one part");
            }
        }
        
        function cancelForm() {
            document.ITEM_FORM.action = "main.jsp";
            document.ITEM_FORM.submit();
        }

        function checkQuantity(){
            var quns = document.getElementsByName('qun');
            for(var i = 0; i < quns.length; i++){
                if(!isRealQuantity(quns[i].value)){
                    quns[i].focus();
                    return false;
                }
            }

            return true;
        }

        function isRealQuantity(quantity){
            if(quantity == ""){
                alert("Must Enter Quantity ...");
                return false;
            } else if(quantity == "0"){
                alert("Must Quantity Large Than Zero ...");
                return false;
            } else if(!IsNumeric(quantity)){
                alert("Must Quantity Number ...");
                return false;
            }

            var intQuantity = new Number(quantity);
            if(intQuantity <= 0) {
                alert("Must Quantity Large Than Zero ");
                return false;
            }

            return true;
        }

        function checkNote() {
            var notes = document.getElementsByName('note');
            for(var i = 0; i < notes.length; i++){
                if(notes[i].value == ""){
                    notes[i].value = "No Note";
                }
            }
        }

        function changeSelectedForm(id) {
            document.getElementById('itemForm').value = document.getElementById(id).value;
        }

        function getItemForm(storeId) {
            // clear select form and selected Form
            document.getElementById('selectedStore').value = storeId;
            document.getElementById('selectedFormList').innerHTML = "";
            document.getElementById('itemForm').value = "";

            var url = "<%=context%>/ajaxServlet?op=getItemForm&storeId=" + storeId;
            if (window.XMLHttpRequest) {
                req = new XMLHttpRequest();
            }
            else if (window.ActiveXObject) {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("POST",url,true);
            req.onreadystatechange =  callbackFillItemForm;
            req.send(null);
        }

        function callbackFillItemForm(){
            if (req.readyState==4) {
                if (req.status == 200) {
                    var selectForm = document.getElementById('selectedFormList');
                    var selectedBranch = document.getElementById('selectedBranch');
                    var itemForm = document.getElementById('itemForm');

                    var allData = req.responseText;
                    var data = allData.split("<data>");
                    
                    selectedBranch.value = data[0];
                    var arrCodeDesc = data[1].split("<element>");

                    if(data[1] != "") {
                        for(var i=0; i < arrCodeDesc.length; i++) {
                            changeSearchPanel(false);

                            var temp = arrCodeDesc[i].split("<subelement>");
                            selectForm.options[selectForm.options.length] = new Option(temp[1], temp[0]);
                        }

                        // add active Form to text box
                        itemForm.value = selectForm.options[0].value;
                    } else {
                        changeSearchPanel(true);
                        selectForm.options[selectForm.options.length] = new Option('<%=notFoundItemForm%>', '-------');
                        itemForm.value = '---';
                    }
                }
            }
        }

        function changeSearchPanel(disabled) {
            document.getElementById('radioName').disabled = disabled;
            document.getElementById('radioCode').disabled = disabled;
            document.getElementById('spareName').disabled = disabled;
            document.getElementById('btnSearch').disabled = disabled;
        }

        function Delete() {
             var tbl = document.getElementById('itemTable');
             var check=document.getElementsByName('check');
             for(var i=0;i<check.length;i++){
                 if(check[i].checked==true){
                    tbl.deleteRow(i+1);
                    i--;
                }
            }
          checNumeric();
      }

        function getSpareParts() {
                var codeOrName = getCodeOrName();
                    var itemForm = document.getElementById('selectedFormList').value;
                    var codeValues = getCodes();
                    var storeCode =  document.getElementById('selectedStore').value;
                    var branchCode = document.getElementById('selectedBranch').value;
                    var formName = document.getElementById('ITEM_FORM').getAttribute("name");
                    var subCode = document.getElementById('spareName').value;

                    subCode = getASSCIChar(subCode);
                    
                    //count=document.getElementById('con').value;
                    openWindowParts('SelectiveServlet?op=selectMultiSpareParts&spareName='+subCode+'&formName='+formName+'&itemForm=' + itemForm + '&storeCode=' + storeCode + '&branchCode=' + branchCode + '&codeOrName=' + codeOrName + '&codes=' + codeValues + '&attachOn=task');
            }

            function getCodeOrName() {
                if(document.getElementById('radioCode').checked){
                    return document.getElementById('radioCode').value;
                } else{
                    return document.getElementById('radioName').value;
                }
            }

            function getCodes() {
                var codeValues = "";
                var codes = document.getElementsByName('code');
                if(codes != null){
                    for(var i = 0; i < codes.length; i++) {
                        codeValues = codeValues + codes[i].value + " ";
                    }
                }
                return codeValues;
            }

            function openWindowParts(url) {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=1000, height=600");
            }

            function getItemBalance(store, index) {
                var codes = document.getElementsByName('code');

                var itemCode = codes[index].value;
                var codeAndForm = itemCode.split("-");
                var itemForm = codeAndForm[0];
                itemCode = codeAndForm[1];

                openWindowParts("PopupServlet?op=getBalance&itemCode=" + itemCode + "&itemForm=" + itemForm + "&storeCode=" + store);
            }

            function checNumeric() {
                var q = document.getElementsByName('qun');
                var c = document.getElementsByName('cost');
                var p = document.getElementsByName('price');
                var length = document.getElementsByName('check').length;
                var total = 0.0;

                for(var x = 0; x < length; x++) {

                    var price=p[x].value;
                    var check=q[x].value;

                    if(IsNumeric(check)) {
                        total += check * price;
                        c[x].value = roundNumber(check * price, 2);
                    } else {
                        q[x].value = "0";
                        c[x].value = "0.0";
                    }
                }

                var tot = document.getElementById('total');
                tot.value = total.toFixed(2);
            }
    </SCRIPT>
    
    <BODY>
        
        <FORM action=""  NAME="ITEM_FORM" METHOD="POST">
            <input type="hidden" name="nRows" id="nRows" value="<%=taskParts.size()%>">
            <DIV align="left" STYLE="color:blue; padding-bottom: 10px; padding-left: 2.5%">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%></button>
                 <% if(allStores.size()>0) { %>
                &ensp;
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%></button>
                <% } %>
            </DIV>
            <CENTER>
                <FIELDSET class="set" STYLE="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" >
                        <TR>
                            <TD STYLE="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=updateParts1%>&ensp;<font color="white" size="4">-</font>&ensp;<%=itemName%>&ensp;<%=updateParts2%><font color="white" size="4">-</font>&ensp;<%=title_2%></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <% if(!status.equals("")) { %>
                    <BR>
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="95%" cellpadding="0" cellspacing="0" style="padding-bottom: 10%; padding-top: 10px">
                        <TR>
                            <%if(status.equals("OK")){%>
                            <TD width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                                <font color="blue" STYLE="font-weight: bold" size="3"><center><%=sStatus%></center></font>
                            </TD>
                            <%} else if(status.equals("No")){%>
                            <TD width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                                <font color="red" STYLE="font-weight: bold" size="3"><center><%=fStatus%></center></font>
                            </TD>
                            <%}%>
                        </TR>
                    </TABLE>
                    <% } %>
                    <BR>
                    <% if (allStores.size() > 0) { %>
                    <TABLE DIR="<%=dir%>" cellpadding="0" cellspacing="0" border="0" width="95%">
                        <TR>
                            <TD STYLE="border-width: 0px" width="50%">
                                <TABLE CLASS="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="100%">
                                    <TR>
                                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;font-size:16px;height: 35px" width="30%">
                                            <B><%=storeAva%></B>
                                        </TD>
                                        <TD CLASS="blueBorder" bgcolor="#D8D8D8" STYLE="text-align:center;color:white;font-size:16px;height: 35px" width="70%">
                                            <SELECT name="groupId" ID="groupId" STYLE="width:233px;text-align:center;font-size:14px;font-weight: bold" ONCHANGE="JavaScript:getItemForm(this.value);">
                                                <sw:WBOOptionList wboList="<%=allStores%>" displayAttribute = "<%=storeNameAttribute%>" valueAttribute="storeCode" scrollTo="<%=selectedStore%>" />
                                            </SELECT>
                                                <input type="text" id="selectedStore" name="selectedStore" value="<%=selectedStore%>" STYLE="text-align:center;font-size:14px;font-weight: bold;" size="7" readonly>
                                                <input type="hidden" id="selectedBranch" name="selectedBranch" value="<%=selectedBranch%>">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD CLASS="blueBorder blueHeaderTD"STYLE="text-align:center;font-size:16px;">
                                            <B><%=classGroup%></B>
                                        </TD>
                                        <TD CLASS="blueBorder" bgcolor="#D8D8D8">
                                            <SELECT name="selectedFormList" ID="selectedFormList"STYLE="width:233px;text-align:center;font-size:14px;font-weight: bold" ONCHANGE="javascript: changeSelectedForm(this.id)">
                                                <sw:WBOOptionList wboList="<%=itemFormForSelectedStore%>" displayAttribute = "formDesc" valueAttribute="codeForm" scrollTo="<%=selectedForm%>"/>
                                            </SELECT>
                                            <input id="itemForm" size="7" value="<%=selectedForm%>" STYLE="text-align:center;font-size:14px;font-weight: bold" readonly />
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                            <TD STYLE="border-width: 0px" width="1%">
                                &ensp;
                            </TD>
                            <TD STYLE="border-width: 0px" width="49%">
                                <TABLE ID="tableSearch" class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="100%" STYLE="height: 100%">
                                    <TR>
                                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;font-size:15px;">
                                            <input type="radio" id="radioCode" name="radioCodeOrName" value="code" checked><b><%=AddCode%></b>
                                        </TD>
                                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;color:#000000;font-size:15px;background-color: #EDEDED" ROWSPAN="2" id="CellData" colspan="2">
                                            <input type="text" dir="ltr" value="" name="spareName" ID="spareName" size="30" STYLE="text-align: center;">
                                            <input type="button" id="btnSearch" value="<%=select%>"  STYLE="text-align:center;font-size:14px;font-weight: bold;width: 70px" ONCLICK="JavaScript: getSpareParts();">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;font-size:15px;">
                                            <input type="radio" id="radioName" name="radioCodeOrName" value="name" ><b><%=AddName%></b>
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <TABLE CLASS="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" id="itemTable" WIDTH="95%" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD" WIDTH="18%">
                            <b><%=itemCode%></b>
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD" WIDTH="20%">
                            <b><%=name%></b>
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD" WIDTH="18%">
                            <b><%=count%></b>
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD" WIDTH="10%">
                            <b><%=price%></b>
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD" WIDTH="10%">
                            <b><%=cost%></b>
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD" WIDTH="16%">
                            <b><%=Mynote%></b>
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD" WIDTH="6%">
                            <input type="button" value="<%=del%>" STYLE="font-weight: bold;text-align:center;color:black;font-size:14px;width: 55px" onclick="JavaScript: Delete()"/>
                        </TD>
                    </TR>
                    <%
                    WebBusinessObject taskPartWbo = new WebBusinessObject();
                    for(int i=0;i<taskParts.size();i++){
                        taskPartWbo=new WebBusinessObject();
                        taskPartWbo=(WebBusinessObject)taskParts.get(i);
                    %>
                    <% if(taskPartWbo.getAttribute("mainItem").toString().equals("1")){
                        %>
                        <TR style="background: #ffff99;">
                        <% }else{%>
                        <TR>
                        <% } %>
                        <TD CLASS="blueBorder blackFont">
                            <a class='blackFont' href="JavaScript: getItemBalance('<%=taskPartWbo.getAttribute("storeCode")%>' ,'<%=i%>')" STYLE="color: blue"><%=taskPartWbo.getAttribute("itemId")%></a>
                            <input type="hidden" name="code" id="code" value="<%=taskPartWbo.getAttribute("itemId")%>" />
                        </TD>
                        <TD CLASS="blueBorder blackFont">
                            <input readonly type="text" name="name1" id="name1" style="width: 100%;font-size: 12px;color: black;text-align: center" value="<%=taskPartWbo.getAttribute("itemName")%>" />
                        </TD>
                        <TD CLASS="blueBorder blackFont">
                             <% if(taskPartWbo.getAttribute("mainItem").toString().equals("1")){
                                %>
                                <input readonly class='blackFont' type="text" name="qun" id="qun" STYLE="width: 100%;text-align: center" value="<%=taskPartWbo.getAttribute("itemQuantity")%>" onblur='checNumeric()' maxlength="10" size="10">
                            <% } else { %>
                                <input class='blackFont' type="text" name="qun" id="qun" STYLE="width: 100%;text-align: center" value="<%=taskPartWbo.getAttribute("itemQuantity")%>" onblur='checNumeric()' maxlength="10" size="10">
                            <% } %>
                        </TD>
                        <TD CLASS="blueBorder blackFont">
                            <input class='blackFont' type='text' style="width: 100%;font-size: 12px;color: black;text-align: center" name='price' ID='price'  value='<%=taskPartWbo.getAttribute("itemPrice")%>' readonly>
                        </TD>
                        <TD CLASS="blueBorder blackFont">
                            <input class='blackFont' type='text' style="width: 100%;font-size: 12px;color: black;text-align: center" name='cost' ID='cost'  value='<%=taskPartWbo.getAttribute("totalCost")%>' readonly>
                        </TD>
                        <TD CLASS="blueBorder blackFont">
                            <% if(taskPartWbo.getAttribute("mainItem").toString().equals("1")){
                                %>
                                <input readonly type="text" name="note" id="note" value="<%=taskPartWbo.getAttribute("note")%>" style="width: 100%;font-size: 12px;color: black;text-align: center" maxlength="190">
                                <% }else{%>
                                <input type="text" name="note" id="note" value="<%=taskPartWbo.getAttribute("note")%>" style="width: 100%;font-size: 12px;color: black;text-align: center" maxlength="190">
                                <% } %>
                        </TD>
                        <TD CLASS="blueBorder blackFont">
                            <input type='checkbox' name='check' ID='check'>
                            <input type='hidden' name='Hid' ID='Hid' value="<%=taskPartWbo.getAttribute("itemId")%>">
                            <input type='hidden' name='des' ID='des' value="<%=taskPartWbo.getAttribute("itemName")%>">
                            <input type='hidden' name='cat' ID='cat'>
                            <% if (taskPartWbo.getAttribute("branchCode") != null && !taskPartWbo.getAttribute("branchCode").equals("")) {%>
                            <input type="hidden" name="branch" id="branch" value="<%=(String) taskPartWbo.getAttribute("branchCode")%>">
                            <% } else {%>
                            <input type="hidden" name="branch" id="branch" value="none">
                            <% }%>

                            <% if (taskPartWbo.getAttribute("storeCode") != null && !taskPartWbo.getAttribute("storeCode").equals("")) {%>
                            <input type="hidden" name="store" id="store" value="<%=(String) taskPartWbo.getAttribute("storeCode")%>">
                            <% } else {%>
                            <input type="hidden" name="store" id="store" value="none">
                            <% }%>
                        </TD>
                    </TR>
                    <% } %>
                    </TABLE>
                    <BR>
                    <TABLE CLASS="blueBorder blackFont" ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="95%" CELLPADDING="0" CELLSPACING="0" >
                        <TR bgcolor="#E8E8FF">
                            <td CLASS="blueBorder blackFont" STYLE="height: 25px" width="65%" ><font size="3" color="black"><b><%=totalCost%></b></font></td>
                            <td CLASS="blueBorder blackFont" width="35%" ><font size="3"><b><input type="text" name="total"  readonly ID="total"  value="" maxlength="255" STYLE="width: 80%;text-align: center;font-weight: bold;color: black;font-size: 14px" ></b></font></td>
                        </TR>
                    </TABLE>
                    <% } else { %>
                    <TABLE class="blueBorder" cellspacing="0" cellpadding="0" align="<%=align%>" dir="<%=dir%>" width="90%">
                        <TR>
                            <TD class="backgroundTable">
                                <b><font size=4 color='red'><%=setupStoreNote%></font></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <% } %>
                    <BR>
                </FIELDSET>
            </CENTER>
            <!-- check found item form or not -->
            <SCRIPT type="text/javascript" >
                var selectForm = document.getElementById('selectedFormList');
                if(selectForm.options.length == 0) {
                    changeSearchPanel(true);
                    selectForm.options[selectForm.options.length] = new Option('<%=notFoundItemForm%>', '-------');
                    document.getElementById('itemForm').value = '---';
                }
            </SCRIPT>
        </FORM>
    </BODY>
</HTML>     
