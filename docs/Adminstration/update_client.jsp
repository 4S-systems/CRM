<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        String status = (String) request.getAttribute("Status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        WebBusinessObject supplierWBO = (WebBusinessObject) request.getAttribute("clientWbo");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status;
        String client_number, save, client_name, client_address, client_job, client_phone, client_fax, client_city, client_mail, client_service, client_notes, working_status, TT, title_3;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label;
        String fStatus;
        String sStatus;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";

            client_name = "Client name";
            client_number = "Client number";
            client_address = "Client address";
            client_job = "Client job";
            client_phone = "Client phone";
            client_fax = "Fax";
            client_mail = "E-mail";
            client_city = "Client city";
            client_service = "Client service";
            client_notes = "Notes";
            // sup_city = "Supplier city";
            working_status = "Working";
            TT = "Update Status";
            save = "Save";

            title_1 = "Delete supplier";
            title_2 = "All information are needed";
            cancel_button_label = "Back To List ";
            save_button_label = "Save ";
            langCode = "Ar";
            title_3 = "Update Client";
            sStatus = "Supplier Updated Successfully";
            fStatus = "Fail To Update This Supplier";
        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:right";
            lang = "English";

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";

            client_name = "اسم العميل";
            client_number = "رقم العميل";
            client_address = "&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
            client_job = "&#1575;&#1604;&#1606;&#1588;&#1575;&#1591;";
            client_phone = "&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
            client_fax = "&#1575;&#1604;&#1601;&#1575;&#1603;&#1587;";
            client_mail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
            client_city = "&#1575;&#1604;&#1605;&#1583;&#1610;&#1606;&#1607;";
            client_service = "&#1575;&#1604;&#1582;&#1583;&#1605;&#1607; ";
            client_notes = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            //sup_city = "Supplier city";
            working_status = "&#1610;&#1593;&#1605;&#1604;";


            title_1 = " &#1581;&#1584;&#1601; &#1605;&#1608;&#1585;&#1583;";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            langCode = "En";
            TT = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            title_3 = "تحديث بيانات عميل";
            save = "&#1587;&#1580;&#1604; ";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";

        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="js/validator.js"></script>
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {




            if (!validateData2("req", this.SUPPLIER_FORM.name) || !validateData2("minlength=3", this.SUPPLIER_FORM.name)) {
                this.SUPPLIER_FORM.name.focus();
                var x = this.SUPPLIER_FORM.name;
                if ($("#name").val() == "") {
                    $(x).css("background-color", "#FF9191");
                    $("#naMsg").show();
                    $("#naMsg").text("إسم العميل مطلوب");
                }
                else if (!validateData2("minlength=3", this.SUPPLIER_FORM.name)) {
                    $(x).css("background-color", "#FF9191");
                    $("#naMsg").show();
                    $("#naMsg").text("الإسم اقل من 3 حروف");
                }
                else {
                    $(x).css("background-color", "");
                    $("#naMsg").hide();
                    $("#naMsg").html("");
                }
                return false;
            }
            else if (!validateData2("req", this.SUPPLIER_FORM.clientSsn) || !validateData2("numeric", this.SUPPLIER_FORM.clientSsn)) {
                this.SUPPLIER_FORM.clientSsn.focus();
                var x = this.SUPPLIER_FORM.clientSsn;
                if ($("#clientSsn").val() == "") {

                    $(x).css("background-color", "#FF9191");
                    $("#ssnMsg").show();
                    $("#ssnMsg").text("الرقم القومى مطلوب");
                    return false;
                }
                else if (!validateData2("numeric", this.SUPPLIER_FORM.clientSsn)) {
                    $(x).css("background-color", "#FF9191");
                    $("#ssnMsg").show();
                    $("#ssnMsg").text("ارقام فقط");
                    return false;

                } 
                else {
                    $(x).css("background-color", "");
                    $("#ssnMsg").hide();
                    $("#ssnMsg").html("");

                }

                //                return ;
            }
            else if (!validateData2("req", this.SUPPLIER_FORM.mobile) || !validateData2("numeric", this.SUPPLIER_FORM.mobile)) {
                this.SUPPLIER_FORM.mobile.focus();
                var x = this.SUPPLIER_FORM.mobile;
                if ($("#mobile").val() == "") {
                    $(x).css("background-color", "#FF9191");
                    $("#moMsg").show();
                    $("#moMsg").text("رقم الموبايل مطلوب");

                }
                else if (!validateData2("numeric", this.SUPPLIER_FORM.mobile)) {
                    $(x).css("background-color", "#FF9191");
                    $("#moMsg").show();
                    $("#moMsg").text("ارقام فقط");

            
                }
                else {
                    $(x).css("background-color", "");
                    $("#moMsg").hide();
                    $("#moMsg").html("");

                }
                return false;
            }
            //            if ($("#phone").length > 0) {
            else if (!validateData2("numeric", this.SUPPLIER_FORM.phone)) {
                this.SUPPLIER_FORM.phone.focus();
                var x = this.SUPPLIER_FORM.phone;
                if (!validateData2("numeric", this.SUPPLIER_FORM.phone)) {
                    $(x).css("background-color", "#FF9191");

                    $("#telMsg").show();
                    $("#telMsg").text("ارقام فقط");

                }
                else {
                    $(x).css("background-color", "");
                    $("#telMsg").hide();
                    $("#telMsg").html("");

                    return true;
                }

                //                }

            }
            else if (!validateData2("email", this.SUPPLIER_FORM.email)) {
                this.SUPPLIER_FORM.email.focus();
                var x = this.SUPPLIER_FORM.email;
                if (!validateData2("email", this.SUPPLIER_FORM.email)) {


                    $(x).css("background-color", "#FF9191");
                    $("#mailMsg").show();
                    $("#mailMsg").html("بريد إلكترونى غير صحيح <br><font style='color:#005599;font-size:10px;'>For Example: youmail@yahoo.com</font>");
                } else {

                    $(x).css("background-color", "");
                    $("#mailMsg").hide();
                    $("#mailMsg").html("");
                    return true;
                }
                //                }

            }
            else {
                document.SUPPLIER_FORM.action = "<%=context%>/ClientServlet?op=UpdateClient";
                document.SUPPLIER_FORM.submit();

            }

        }


        function IsNumeric(sText)
        {
            var ValidChars = "0123456789.";
            var IsNumber = true;
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
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
                return (true)
            }
            return (false)
        }

        function clearValue(no) {
            document.getElementById('Quantity' + no).value = '0';
            total();
        }

        function cancelForm()
        {
            document.SUPPLIER_FORM.action = "<%=context%>/ClientServlet?op=ListClients";
            document.SUPPLIER_FORM.submit();
        }
        function isNumber(evt) {
            var iKeyCode = (evt.which) ? evt.which : evt.keyCode
            if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
                return false;

            return true;

        }
        function isNumber2(evt) {
            var iKeyCode = (evt.which) ? evt.which : evt.keyCode
            if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {

                $("#numberMsg").show();
                $("#numberMsg").text("أرقام فقط");
                return false;
            } else {
                $("#numberMsg").hide();
            }

        }
        function checkName(obj) {

            if ($("#clientName").val() == "") {
                $("#naMsg").show();
                $("#naMsg").text("إسم العميل مطلوب");
            } else {
                var x = this.SUPPLIER_FORM.name;
                $(x).css("background-color", "");
                $("#naMsg").hide();
                $("#naMsg").html("");
            }
        }
        function checkMobile(obj) {
            if ($(obj).val() == "") {
                $("#moMsg").show();
                $("#moMsg").text("رقم الموبايل مطلوب");
            }
            else if (!validateData2("numeric", this.SUPPLIER_FORM.mobile)) {
                $("#moMsg").show();
                $("#moMsg").text("ارقام فقط");
            }
            else {
                var x = this.SUPPLIER_FORM.mobile;
                $(x).css("background-color", "");
                $("#moMsg").hide();
                $("#moMsg").html("");
            }

        }

        function checkTel(obj) {

            if (!validateData2("numeric", this.SUPPLIER_FORM.phone)) {
                $("#telMsg").show();
                $("#telMsg").text("ارقام فقط");
            } else {
                var x = this.SUPPLIER_FORM.phone;
                $(x).css("background-color", "");
                $("#telMsg").hide();
                $("#telMsg").html("");
            }

        }
        function checkSsn(obj, evt) {

            if (!validateData2("numeric", this.SUPPLIER_FORM.clientSsn)) {
                isNumber(evt)
                $("#ssnMsg").show();
                $("#ssnMsg").text("ارقام فقط");

            }
           

            else {
                var x = this.SUPPLIER_FORM.clientSsn;
                $(x).css("background-color", "");
                $("#ssnMsg").hide();
                $("#ssnMsg").html("");
            }

        }
        function checkSalary(obj) {

            if (!validateData2("numeric", this.SUPPLIER_FORM.salary)) {
                $("#salaryMsg").show();
                $("#salaryMsg").text("ارقام فقط");
            } else {
                var x = this.SUPPLIER_FORM.salary;
                $(x).css("background-color", "");
                $("#salaryMsg").hide();
                $("#salaryMsg").html("");
            }

        }
        function checkMail(obj) {

            if (!validateData2("email", this.SUPPLIER_FORM.email)) {
                $("#mailMsg").show();
                $("#mailMsg").html("بريد إلكترونى غير صحيح <br><font style='color:#005599;font-size:10px;'>For Example: youmail@yahoo.com</font>");
            } else {
                var x = this.SUPPLIER_FORM.email;
                $(x).css("background-color", "");
                $("#mailMsg").hide();
                $("#mailMsg").html("");
            }

        }

    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <STYLE type="text/css">
        #moMsg,#telMsg,#naMsg,#salaryMsg,#mailMsg,#ssnMsg,#numberMsg{
            font-size: 14px;
            display: none;
            color: red;
            margin: 0px;
        }
    </style>
    <BODY>
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button    onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/save.gif"></button>
        </DIV> 
        <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>" class="blueBorder" width="100%">
                    <tr>

                        <td style="text-align:center;border-color: #006699; width:100%;" class="blueBorder blueHeaderTD">
                            <FONT color='white' SIZE="+1"><%=title_3%>                
                            </font>

                        </td>
                    </tr>
                </table>
            </legend>

            <FORM NAME="SUPPLIER_FORM" METHOD="POST">
                <input type="hidden" name="code" id="code" value="<%=supplierWBO.getAttribute("code").toString()%>"/>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
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
                } else {%>
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
                <br>
                <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0"  width="96%;" style="margin:auto;">
                    <tr>
                        <td style="border: none;width: 50%;">
                            <table style="float: right;border: 0px;"border="0px" width="100%" >
                                <%
                                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                                            && connectByRealEstate.equals("0")) {
                                %>
                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="clientNO">
                                            <p><b><%=client_number%><font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <b><font color="red" size="3" ><%=supplierWBO.getAttribute("clientNO")%>/</font><font color="blue" size="3" ><%=supplierWBO.getAttribute("clientNoByDate")%></font></b>
                                        <input type="hidden" name="clientNO" id="clientNO" value="<%=supplierWBO.getAttribute("clientNO")%>" />
                                    </TD>
                                </TR>
                                <% } else {%>
                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="clientNO">
                                            <p><b><%=client_number%><font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <b><font color="red" size="3" ><%=supplierWBO.getAttribute("code")%></font></b>
                                        <input type="hidden" name="clientNO" id="clientNO" value="<%=supplierWBO.getAttribute("code")%>" />
                                    </TD>
                                </TR>
                                <%}%>
                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="name">
                                            <p><b>إسم العميل<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>

                                        <input type="TEXT"  name="name" ID="name" size="25" value="<%=supplierWBO.getAttribute("name").toString()%>" maxlength="255" onkeyup="checkName(this)" onmousedown="checkName(this)">
                                        <p id="naMsg"></P>
                                    </TD>
                                </TR>

                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="name">
                                            <p><b>إسم الزوج/الزوجة<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>




                                        <% if (supplierWBO.getAttribute("partner") != null && !(supplierWBO.getAttribute("partner").equals(""))) {%>
                                        <input type="TEXT" name="partner" ID="partner" size="25" value="<%=supplierWBO.getAttribute("partner").toString()%>" maxlength="255">
                                        <%} else {%>
                                        <input type="TEXT"  name="partner" size="25" ID="partner"  value="" maxlength="255">
                                        <%}%>
                                    </TD>
                                </TR>

                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="gender">
                                            <p><b>النوع<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>

                                    <td style="<%=style%>" class='td'>
                                        <span><input type="radio" name="gender" value="ذكر" id="gender" <% if (supplierWBO.getAttribute("gender").equals("ذكر")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>ذكر</b></font></span>
                                        <span><input type="radio" name="gender" value="أنثى" id="gender" <% if (supplierWBO.getAttribute("gender").equals("أنثى")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>أنثى</b></font></span>
                                    </td>
                                </TR>

                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="supplierNO">
                                            <p><b>الحالة الاجتماعية<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>

                                    <td style="<%=style%>" class='td'>
                                        <span><input type="radio" name="matiral_status" value="أعزب" id="matiral_status" <% if (supplierWBO.getAttribute("matiralStatus").equals("أعزب")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>أعزب</b></font></span>
                                        <span><input type="radio" name="matiral_status" value="متزوج" id="matiral_status"<% if (supplierWBO.getAttribute("matiralStatus").equals("متزوج")) {%> checked="true" <%}%> />  <font size="3" color="#005599"><b>متزوج</b></font></span>
                                        <span><input type="radio" name="matiral_status" value="مطلق" id="matiral_status" <% if (supplierWBO.getAttribute("matiralStatus").equals("مطلق")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>مطلق</b></font></span>

                                    </td>

                                </TR>
                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="clientSsn">
                                            <p><b>الرقم القومى<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>

                                        <% if (supplierWBO.getAttribute("clientSsn") != null && !(supplierWBO.getAttribute("clientSsn").equals(""))) {%>

                                        <input type="TEXT" style="width:120px" name="clientSsn" id="clientSsn" size="14" value="<%=supplierWBO.getAttribute("clientSsn").toString()%>" maxlength="14" onkeyup="checkSsn(this)" onmousedown="checkSsn(this)" onkeypress="javascript:return isNumber(event)">
                                        <p id="ssnMsg"></P>
                                            <%} else {%>
                                        <input type="TEXT" style="width:120px" name="clientSsn" id="clientSsn" size="14" value="" maxlength="14" onkeyup="checkSsn(this)" onmousedown="checkSsn(this)" onkeypress="javascript:return isNumber(event)">
                                        <p id="ssnMsg"></P>
                                            <%}%>

                                    </TD>
                                </TR>
                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="supplierNO">
                                            <p><b>رقم الموبايل<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <% if (supplierWBO.getAttribute("mobile") != null && !(supplierWBO.getAttribute("mobile").equals(""))) {%>

                                        <input type="TEXT" style="width:120px;" name="mobile" ID="mobile" size="11" value="<%=supplierWBO.getAttribute("mobile").toString()%>" maxlength="11" onkeyup="checkMobile(this)" onmousedown="checkMobile(this)">
                                        <p id="moMsg"></p>
                                        <%} else {%>

                                        <input type="TEXT" style="width:120px;" name="mobile" ID="mobile" size="11" value="" maxlength="11" onkeyup="checkMobile(this)" onmousedown="checkMobile(this)">
                                        <p id="moMsg"></p>
                                        <%}%>
                                    </TD>
                                </TR>

                            </TABLE>
                        </TD>
                        <td style="border: none;width: 50%;">
                            <TABLE style="width: 100%;">
                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="supplierNO">
                                            <p><b>التليفون<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <%
                                            String phone = supplierWBO.getAttribute("phone").toString();
                                            if (phone.equals(" ")) {%>
                                        <input type="TEXT" style="width:120px" name="phone" ID="phone" size="11" value="" maxlength="15" onkeyup="checkTel(this)">
                                        <p id="telMsg" ></p>
                                        <%} else {%>
                                        <input type="TEXT" style="width:120px" name="phone" ID="phone" size="11" value="<%=phone%>" maxlength="15" onkeyup="checkTel(this)">
                                        <p id="telMsg" ></p>
                                        <%}%>
                                    </TD>
                                </TR>

                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="supplierNO">
                                            <p><b>الدخل الإجمالى<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <% if (supplierWBO.getAttribute("salary") != null && !(supplierWBO.getAttribute("salary").equals(""))) {%>


                                        <input type="TEXT" style="width:80px" name="salary" ID="salary" size="10" value="<%=supplierWBO.getAttribute("salary").toString()%>" maxlength="10" onkeyup="checkSalary(this)" onmousedown="checkSalary(this)" >
                                        <p id="salaryMsg"></p>
                                        <%} else {%>
                                        <input type="TEXT" style="width:80px" name="salary" ID="salary" size="10" value="" maxlength="10" onkeyup="checkSalary(this)" onmousedown="checkSalary(this)" >
                                        <p id="salaryMsg"></p>
                                        <%}%>
                                    </TD>
                                </TR>

                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="supplierNO">
                                            <p><b>العنوان<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <% if (supplierWBO.getAttribute("address") != null && !(supplierWBO.getAttribute("address").equals("null"))) {%>   
                                        <textarea style="width:230px;" rows="3" ID="address" name="address"><%=supplierWBO.getAttribute("address")%></textarea>
                                        <%} else {%>
                                          <textarea style="width:230px;" rows="3" ID="address" name="address"></textarea>
                                        <%}%>
                                    </TD>
                                </TR>

                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="email">
                                            <p><b>البريد الإلكترونى<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <% if (supplierWBO.getAttribute("email") != null && !(supplierWBO.getAttribute("email").equals("null"))) {%>    

                                        <input type="TEXT" style="width:230px" name="email" ID="email" size="33" value="<%=supplierWBO.getAttribute("email").toString()%>" maxlength="100" onkeyup="checkMail(this.value)">
                                        <p id="mailMsg" ></p>
                                        <%} else {%>
                                        <input type="TEXT" style="width:230px" name="email" ID="email" size="33" value="" maxlength="100" onkeyup="checkMail(this.value)">
                                        <p id="mailMsg" ></p>
                                        <%}%>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="28%" >
                                        <LABEL FOR="age">
                                            <p><b>الفئة العمرية<font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>

                                    <td style="<%=style%>" class='td'>
                                        <span><input type="radio" name="age" value="20-30" id="age" <% if (supplierWBO.getAttribute("age").equals("20-30")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>20-30</b></font></span>
                                        <span><input type="radio" name="age" value="30-40" id="age" <% if (supplierWBO.getAttribute("age").equals("30-40")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>30-40</b></font></span>
                                        <span><input type="radio" name="age" value="40-50" id="age" <% if (supplierWBO.getAttribute("age").equals("40-50")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>40-50</b></font></span>
                                        <span><input type="radio" name="age" value="50-60" id="age" <% if (supplierWBO.getAttribute("age").equals("50-60")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>50-60</b></font></span>

                                    </td>
                                </TR>


                                <tr >
                                    <td  colspan="2" width="100%">


                                </tr>
                                <input type="hidden" name="clientID" value="<%=supplierWBO.getAttribute("id").toString()%>">
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>
            </FORM>
        </FIELDSET>
    </BODY>
</HTML>     
