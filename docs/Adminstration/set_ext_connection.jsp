<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<HTML>


    <%
        String status = (String) request.getAttribute("Status");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");



        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status, Dupname;
        String project_name_label = null;
        String project_location_label = null;
        String project_desc_label = null;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label;
        String fStatus;
        String sStatus;
        String hostName, serviceName, userName, password, unitsType, dbType, bankType;
        String host, service, user, dPassword;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            project_name_label = "Trade name";
            project_location_label = "Trade number";
            project_desc_label = "Location decription";
            title_1 = "Set External Database";
            title_2 = "All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            langCode = "Ar";
            Dupname = "Name is Duplicated Chane it";
            sStatus = "Group Saved Successfully";
            fStatus = "Fail To Save Group";
            dbType = "Database type";
            hostName = "Host name";
            serviceName = "Service name";
            userName = "User name";
            password = "password";
            unitsType = "Units";
            bankType = "Units 2";
        } else {


            /*if(status.equalsIgnoreCase("ok"))
            status="";*/
            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            project_name_label = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
            project_location_label = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
            project_desc_label = " &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            title_1 = "&#1578;&#1593;&#1610;&#1610;&#1606; &#1602;&#1608;&#1575;&#1593;&#1583; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1582;&#1575;&#1585;&#1580;&#1610;&#1577;";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            langCode = "En";
            Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            dbType = "&#1602;&#1575;&#1593;&#1583;&#1577; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
            hostName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1582;&#1575;&#1583;&#1605;";
            serviceName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1582;&#1583;&#1605;&#1577;";
            userName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
            password = "&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1587;&#1585;";
            unitsType = "&#1575;&#1604;&#1608;&#1581;&#1583;&#1575;&#1578;";
            bankType = "&#1575;&#1604;&#1608;&#1581;&#1583;&#1575;&#1578; 2";
        }
        String dataBaseUrl = (String) request.getAttribute("arrDatabase");
        String[] arrUrl = dataBaseUrl.split(":");
        String doubleName = (String) request.getAttribute("name");
        WebBusinessObject unitDBWbo = (WebBusinessObject) request.getAttribute("unitDBWbo");
        WebBusinessObject bankDBWbo = (WebBusinessObject) request.getAttribute("bankDBWbo");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

    </HEAD>
    <script src='silkworm_validate.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function validateSchema(id) {
            selectedId = id;
            var ownerNameTemp = document.getElementById(id).value;
            var ownerName = ownerNameTemp.toUpperCase();
            var hostTemp = document.getElementById("hostName_"+id).value;
            var serviceTemp = document.getElementById("serviceName_"+id).value;
            var passwordTemp = document.getElementById("password_"+id).value;
            setCheckFalse(id);
            setCheckImageFalse(id);
            if(!isDublicate(ownerNameTemp,passwordTemp)) {
                validate(ownerName,passwordTemp,hostTemp,serviceTemp);
            }
        }
        function validateConnection(id) {
            var sId= id.split("_");
            var ownerNameTemp = document.getElementById(sId[1]).value;
            var ownerName = ownerNameTemp.toUpperCase();
            var hostTemp = document.getElementById("hostName_"+sId[1]).value;
            var serviceTemp = document.getElementById("serviceName_"+sId[1]).value;
            var passwordTemp = document.getElementById("password_"+sId[1]).value;
            setCheckFalse(sId[1]);
            setCheckImageFalse(sId[1]);
            if(!isDublicate(ownerNameTemp)) {
                validate(ownerName,passwordTemp,hostTemp,serviceTemp);
            }
        }
        
        
        function validate(ownerName,passwordTemp,hostTemp,serviceTemp){
            var url = "<%=context%>/ajaxServlet?op=isSchemaFound&ownerName=" + ownerName+"&password="+passwordTemp+"&hostName="+hostTemp+"&serviceName="+serviceTemp;
            if (window.XMLHttpRequest) {
                req = new XMLHttpRequest();
            } else if (window.ActiveXObject) {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post",url,true);
            req.onreadystatechange =  callbackValidate;
            req.send(null);
        }

        function callbackValidate(){
            if (req.readyState==4) {
                if (req.status == 200) {
                    var responseResult = req.responseText;
                    if(responseResult == "yes") {
                        setCheckTrue(selectedId);
                        setCheckImageTrue(selectedId);
                    } else {
                        setCheckFalse(selectedId);
                        setCheckImageFalse(selectedId);
                    }
                }
            }
        }

        function setCheckFalse(id) {
            document.getElementById(id + '_check').value = "0";
        }

        function setCheckTrue(id) {
            document.getElementById(id + '_check').value = "1";
        }

        function setCheckImageFalse(id) {
            document.getElementById(id + '_img').style.display = "block";
            document.getElementById(id + '_img').src = "images/cancel_white.png";
        }

        function setCheckImageTrue(id) {
            document.getElementById(id + '_img').style.display = "block";
            document.getElementById(id + '_img').src = "images/ok_white.png";
        }

        function validateForm() {
            if(document.getElementById('bank_check').value == "0") {
                alert("User Name : " + document.getElementById('bank').value + " Not Found in Service or you Entered before ...");
                setCheckImageFalse('bank');
                document.getElementById('bank').focus();
                return false;
            } else if(document.getElementById('units_check').value == "0") {
                alert("User Name : " + document.getElementById('units').value + " Not Found in Service or you Entered before ...");
                setCheckImageFalse('units');
                document.getElementById('units').focus();
                return false;
            }
            return true;
        }

        function isDublicate(schemaName) {
            var count = 0;
            if(document.getElementById('bank').value == schemaName) {
                count++;
            }
            if(document.getElementById('units').value == schemaName) {
                count++;
            }
            if(count > 1) {
                return true;
            }
            return false;
        }
        
        function submitForm()
        {
            if (!validateData("req", this.PROJECT_FORM.hostName_units, "Please, enter host for store.")){
                this.PROJECT_FORM.hostName_units.focus();
            }else if (!validateData("req", this.PROJECT_FORM.serviceName_units, "Please, enter service for store.")){
                this.PROJECT_FORM.serviceName_units.focus();
            }else if (!validateData("req", this.PROJECT_FORM.units, "Please, enter user for store.")){
                this.PROJECT_FORM.units.focus();
            }else if (!validateData("req", this.PROJECT_FORM.password_units, "Please, enter password for store.")){
                this.PROJECT_FORM.password_units.focus();
            }else if (!validateData("req", this.PROJECT_FORM.hostName_bank, "Please, enter host for asset.")){
                this.PROJECT_FORM.hostName_bank.focus();
            }else if (!validateData("req", this.PROJECT_FORM.serviceName_bank, "Please, enter service for asset.")){
                this.PROJECT_FORM.serviceName_bank.focus();
            }else if (!validateData("req", this.PROJECT_FORM.bank, "Please, enter user for asset.")){
                this.PROJECT_FORM.bank.focus();
            }else if (!validateData("req", this.PROJECT_FORM.password_bank, "Please, enter password for asset.")){
                this.PROJECT_FORM.password_bank.focus();
            } else{
                document.PROJECT_FORM.action = "<%=context%>/DatabaseControllerServlet?op=saveExtDBConnection";
                document.PROJECT_FORM.submit();  
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
    
        function clearValue(no){
            document.getElementById('Quantity' + no).value = '0';
            total();
        }
    
        function cancelForm()
        {    
            document.PROJECT_FORM.action = "main.jsp";
            document.PROJECT_FORM.submit();  
        }
    </SCRIPT>

    <script src='ChangeLang.js' type='text/javascript'></script>


    <BODY>

        <FORM NAME="PROJECT_FORM" METHOD="POST">

            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 


            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6">    <%=title_1%>                
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend>


                <br>
                <table align="<%=align%>" dir="<%=dir%>">
                    <TR style="background-color:#5c9ccc ;">
                        <TD STYLE="<%=style%>;text-align: center;" class='td'>
                            <b><font size="3" color="white"><%=dbType%></font></b>&nbsp;
                        </TD>
                        <TD STYLE="<%=style%>;text-align: center;" class='td'>
                            <b><font size="3" color="white"><%=hostName%></font></b>&nbsp;
                        </TD>
                        <TD STYLE="<%=style%>;text-align: center;" class='td'>
                            <b><font size="3" color="white"><%=serviceName%></font></b>&nbsp;
                        </TD>
                        <TD STYLE="<%=style%>;text-align: center;" class='td'>
                            <b><font size="3" color="white"><%=userName%></font></b>&nbsp;
                        </TD>
                        <TD STYLE="<%=style%>;text-align: center;" class='td'>
                            <b><font size="3" color="white"><%=password%></font></b>&nbsp;
                        </TD>

                    </TR>
                    <TR style="background-color: #848687;color: #ffffff;">
                        <TD STYLE="<%=style%>" class='td'>
                            <b><font size="3" color="white"><%=unitsType%></font></b>&nbsp;
                            <input type="hidden" name="dbType" id="dbType" value="units"/>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input readonly type="TEXT" name="hostName" id="hostName_units" size="20" value="<%=arrUrl[0]%>">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input readonly type="TEXT" name="serviceName" id="serviceName_units" size="20" value="<%=arrUrl[2]%>">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <%if (unitDBWbo != null && !unitDBWbo.equals("")) {
                                    user = unitDBWbo.getAttribute("userName").toString();
                                } else {
                                    user = "";
                                }
                            %>
                            <input type="TEXT" name="userName" id="units" size="20" value="<%=user%>"
                                   onblur="JavaScript:validateSchema(this.id);"
                                   onchange="JavaScript:validateSchema(this.id);">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <%if (unitDBWbo != null && !unitDBWbo.equals("")) {
                                    dPassword = unitDBWbo.getAttribute("password").toString();
                                } else {
                                    dPassword = "";
                                }
                            %>
                            <input type="password" name="password" id="password_units" size="20" value="<%=dPassword%>"
                                   onblur="JavaScript:validateConnection(this.id);"
                                   onchange="JavaScript:validateConnection(this.id);"
                                   >
                        </TD>
                        <td STYLE="<%=style%>;background-color: #ffffff;" class='td'>
                            <% if (unitDBWbo != null && !unitDBWbo.equals("") && unitDBWbo.getAttribute("valid").equals("1")) {%>
                            <input type="hidden" id="units_check" name="units_check" value="1" />
                            <img src="images/ok_white.png" alt="" align="middle" id="units_img" name="units_img" style="display: block;" />
                            <%} else {%>
                            <input type="hidden" id="units_check" name="units_check" value="0" />
                            <img src="images/cancel_white.png" alt="" align="middle" id="units_img" name="units_img" style="display: block;" />
                            <%}%>
                        </td>
                    </TR>
                    <TR style="background-color: #848687;color: #ffffff;">
                        <TD STYLE="<%=style%>" class='td'>
                           <b><font size="3" color="white"><%=bankType%></font></b>&nbsp;
                           <input type="hidden" name="dbType" id="dbType" value="bank"/>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input readonly type="TEXT" name="hostName" id="hostName_bank" size="20" value="<%=arrUrl[0]%>">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input readonly type="TEXT" name="serviceName" id="serviceName_bank" size="20" value="<%=arrUrl[2]%>">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <%if(bankDBWbo!=null && !bankDBWbo.equals("")){
                                user= bankDBWbo.getAttribute("userName").toString();
                                }else{
                                user="";
                                }
                             %>
                            <input type="TEXT" name="userName" id="bank" size="20" value="<%=user%>"
                                   onblur="JavaScript:validateSchema(this.id);"
                                   onchange="JavaScript:validateSchema(this.id);"
                                   >
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <%if(bankDBWbo!=null && !bankDBWbo.equals("")){
                                dPassword= bankDBWbo.getAttribute("password").toString();
                                }else{
                                dPassword="";
                                }
                             %>
                           <input type="password" name="password" id="password_bank" size="20" value="<%=dPassword%>"
                                   onblur="JavaScript:validateConnection(this.id);"
                                   onchange="JavaScript:validateConnection(this.id);"
                                  >
                        </TD>
                        <td STYLE="<%=style%>;background-color: #ffffff;" class='td'>
                            <% if(bankDBWbo!=null && !bankDBWbo.equals("") && bankDBWbo.getAttribute("valid").equals("1")){ %>
                                <input type="hidden" id="bank_check" name="bank_check" value="1" />
                                <img src="images/ok_white.png" alt="" align="middle" id="bank_img" name="bank_img" style="display: block;" />
                            <%}else{%>
                                <input type="hidden" id="bank_check" name="bank_check" value="0" />
                                <img src="images/cancel_white.png" alt="" align="middle" id="bank_img" name="bank_img" style="display: block;" />
                            <%}%>
                        </td>
                    </TR>
                    <TR>

                </TABLE>
                <br><br><br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
