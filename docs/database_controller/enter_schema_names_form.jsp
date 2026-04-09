<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Enter Schema Names Form</title>
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");

        String lang, langCode, cancel, execute, dir, title, bank, units;

        if (stat.equals("En")) {
            lang = "&#1593;&#1585;&#1576;&#1610;";
            langCode = "Ar";
            dir = "LTR";
            cancel = "Cancel";
            execute = "Execute";
            title = "Enter Names Schema In Views";
            bank = "Bank";
            units = "Units";
        } else {
            lang = "Enbankish";
            langCode = "En";
            dir = "RTL";
            cancel = "&#1575;&#1604;&#1600;&#1594;&#1600;&#1575;&#1569;";
            execute = "&#1578;&#1600;&#1606;&#1600;&#1601;&#1600;&#1610;&#1600;&#1584;";
            title = "&#1571;&#1583;&#1582;&#1600;&#1604; &#1571;&#1587;&#1600;&#1605;&#1600;&#1575;&#1569; &#1602;&#1600;&#1608;&#1575;&#1593;&#1600;&#1583; &#1575;&#1604;&#1600;&#1576;&#1600;&#1610;&#1600;&#1575;&#1606;&#1600;&#1575;&#1578;";
            bank = "&#1575;&#1604;&#1576;&#1606;&#1608;&#1603;";
            units = "&#1575;&#1604;&#1608;&#1581;&#1583;&#1575;&#1578;";
        }
        WebBusinessObject unitsDBWbo = (WebBusinessObject) request.getAttribute("unitsDBWbo");
        WebBusinessObject bankDBWbo = (WebBusinessObject) request.getAttribute("bankDBWbo");
    %>

    <link rel="stylesheet" href="css/blueStyle.css" />
    <link rel="stylesheet" href="css/CSS.css" />
    <script type="text/javascript" src="js/ChangeLang.js"></script>

    <script type="text/javascript">
        var selectedId;
        function submitForm() {
            if(validateForm()) {
                document.ENTER_SCHEMA_NAMES_FORM.action = "<%=context%>/DatabaseControllerServlet?op=recreateAllView";
                document.ENTER_SCHEMA_NAMES_FORM.submit();
            }
        }
        
        function cancelForm() {
            document.ENTER_SCHEMA_NAMES_FORM.action = "<%=context%>/main.jsp";
            document.ENTER_SCHEMA_NAMES_FORM.submit();
        }

        function validateSchema(id) {
            selectedId = id;
            var ownerNameTemp = document.getElementById(id).value;
            var ownerName = ownerNameTemp.toUpperCase();
            setCheckFalse(id);
            setCheckImageFalse(id);
            if(!isDublicate(ownerNameTemp)) {
                validate(ownerName);
            }
        }
        
        function validate(ownerName){
            var url = "<%=context%>/ajaxServlet?op=isSchemaFound&ownerName=" + ownerName;
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
//            if(document.getElementById('bank_check').value == "0") {
//                alert("User Name : " + document.getElementById('bank').value + " Not Found in Service or you Entered before ...");
//                setCheckImageFalse('bank');
//                document.getElementById('bank').focus();
//                return false;
//            } else if(document.getElementById('units_check').value == "0") {
//                alert("User Name : " + document.getElementById('units').value + " Not Found in Service or you Entered before ...");
//                setCheckImageFalse('units');
//                document.getElementById('units').focus();
//                return false;
//            }
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
    </script>
    <style type="text/css">
        .lableStyle {
            text-align: center;
            font-weight: bold;
            color: black;
            font-size: 18px;
        }
        .inputStyle {
            text-align: center;
            font-weight: bold;
            color: black;
            font-size: 14px;
        }
    </style>
    <body onload="document.ENTER_SCHEMA_NAMES_FORM.units.focus();">
        <form action="" name="ENTER_SCHEMA_NAMES_FORM" method="post" >
            <DIV align="left" STYLE="color:blue;padding-left: 12.5%">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%></button>
                &ensp;
                <button  onclick="JavaScript:submitForm();" class="button"> <%=execute%></button>
            </DIV>
            <br>
            <center>
                <fieldset class="set" style="width:75%;border-color: #006699;" >
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <table border="0" cellpadding="0" cellspacing="0" width="60%" dir="<%=dir%>" align="center">
                        <tr>
                            <td style="border-width: 0px" width="100%" colspan="3">
                                &ensp;
                            </td>
                        </tr>
                        <tr>
                            <td style="border-width: 0px" class="lableStyle" width="40%">
                                <%=units%>
                            </td>
                            <td style="border-width: 0px" class="inputStyle" width="50%">
                                <%  String unitsSchema = "";
                                    if (unitsDBWbo != null && !unitsDBWbo.equals("")) {
                                        unitsSchema = (String) unitsDBWbo.getAttribute("userName");
                                    }
                                %>
                                <input readonly type="text" id="units" name="units" value="<%=unitsSchema%>" style="width: 100%" class="inputStyle"/>

                            </td>
                            <td style="border-width: 0px" width="10%">
                                <% if (unitsDBWbo != null && !unitsDBWbo.equals("") && unitsDBWbo.getAttribute("valid").equals("1")) {%>
                                <input type="hidden" id="units_check" name="units_check" value="1" />
                                <img src="images/ok_white.png" alt="" align="middle" id="units_img" name="units_img" style="display: block;" />
                                <%} else {%>
                                <input type="hidden" id="units_check" name="units_check" value="0" />
                                <img src="images/cancel_white.png" alt="" align="middle" id="units_img" name="units_img" style="display: block;" />
                                <%}%>
                            </td>
                        </tr>
                        <tr>
                            <td style="border-width: 0px" class="lableStyle" width="40%">
                                <%=bank%>
                            </td>
                            <td style="border-width: 0px" class="inputStyle" width="50%">
                                <%  String bankSchema = "";
                                    if (bankDBWbo != null && !bankDBWbo.equals("")) {
                                        bankSchema = (String) bankDBWbo.getAttribute("userName");
                                    }
                                %>
                                <input readonly type="text" id="bank" name="bank" style="width: 100%" value="<%=bankSchema%>" class="inputStyle"/>

                            </td>
                            <td style="border-width: 0px" width="10%">
                                <% if (bankDBWbo != null && !bankDBWbo.equals("") && bankDBWbo.getAttribute("valid").equals("1")) {%>
                                <input type="hidden" id="bank_check" name="bank_check" value="1" />
                                <img src="images/ok_white.png" alt="" align="middle" id="bank_img" name="bank_img" style="display: block;" />
                                <%} else {%>
                                <input type="hidden" id="bank_check" name="bank_check" value="0" />
                                <img src="images/cancel_white.png" alt="" align="middle" id="bank_img" name="bank_img" style="display: block;" />
                                <%}%>
                            </td>
                        </tr>
                        <tr>
                            <td style="border-width: 0px" width="100%" colspan="3">
                                &ensp;
                            </td>
                        </tr>
                    </table>
                    <br>
                </fieldset>
            </center>
        </form>
    </body>

</HTML>




