<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.maintenance.db_access.TradeMgr"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        ArrayList<WebBusinessObject> emailsList = (ArrayList<WebBusinessObject>) request.getAttribute("emailsList");
        ArrayList<WebBusinessObject> phonesList = (ArrayList<WebBusinessObject>) request.getAttribute("phonesList");
        ArrayList<WebBusinessObject> datesList = (ArrayList<WebBusinessObject>) request.getAttribute("datesList");
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        String Status=(String) request.getAttribute("status1")==null?"0":(String) request.getAttribute("status1");
        String type1=(String) request.getAttribute("type1")==null?"0":(String) request.getAttribute("type1");

        String dir, saveFailMsg, sTitle, saveSuccessMsg,msg ,msg1;
        if (stat.equals("En")) {
            dir = "LTR";
            sTitle = "Client's Details";
            msg="this number is already exist";
            msg1="this Email is already exist";
        } else {
            dir = "RTL";
            sTitle = "تفاصيل عميل";
            msg="هذا الرقم موجود بالفعل";
            msg1="هذا البريد الالكترونى موجود بالفعل";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/silkworm_validate.js" type="text/javascript"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/validator.js" TYPE="text/javascript" />
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript">
            $(document).ready(
                    function()
            {
                var check='<%=Status%>';
                var type1='<%=type1%>';
                if (check=="exist")
                {
                    if(type1=="phone")
                    alert('<%=msg%>'); 
                   if(type1=="email")
                    alert('<%=msg1%>'); 
                }
                $("#birthDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            
            function InvalidEmailMsg(textbox) {
                if (textbox.value == '') {
                    textbox.setCustomValidity('مطلوب أدخال البريد اﻷلكتروني');
                }
                else if (textbox.validity.typeMismatch) {
                    textbox.setCustomValidity('مطلوب أدخال بريد ألكتروني صحيح  \n ex: userid@company.com');
                }
                else {
                    textbox.setCustomValidity('');
                }
                return true;
            }
            function InvalidPhoneMsg(textbox) {
                if (textbox.value.length < 8 && textbox.value.length > 0) {
                    textbox.setCustomValidity('مطلوب 8 أرقام علي اﻷقل');
                }
                else if (textbox.validity.badInput) {
                    textbox.setCustomValidity('مطلوب أدخال أرقام فقط');
                }
                else {
                    textbox.setCustomValidity('');
                }
                return true;
            }
            function isNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    alert("أرقام فقط")
                    return false;
                }
            }
            function cancelForm() {
                try {
                    opener.getClientInfo('');
                }
                catch(err) {
                }
                self.close();
            }
            function showAddEmail()
            {
                $('#add_email').css("display", "block");
                $('#add_email').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            function showAddPhone()
            {
                $('#add_phone').css("display", "block");
                $('#add_phone').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            function showAddDate() {
                $('#add_date').css("display", "block");
                $('#add_date').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }
//            function addEmail() {
//                var emailValue = $('#email').val();
//                $.ajax({
//                    type: "post",
//                    url: "<%=context%>/ClientServlet?op=addClientCommunication",
//                    data: {
//                        clientId: '<%=clientWbo.getAttribute("id")%>',
//                        type: 'email',
//                        value: emailValue
//                    },
//                    success: function(jsonString) {
//                        var info = $.parseJSON(jsonString);
//                        if (info.status == 'ok') {
//                            location.reload();
//                        }
//                        else {
//                        }
//                    }
//                });
//            }
            $("#email_form").submit(function() {
                var url = "<%=context%>/ClientServlet?op=addClientCommunication"; // the script where you handle the form input.
                $.ajax({
                    type: "POST",
                    url: url,
                    data: $("#email_form").serialize(), // serializes the form's elements.
                    success: function(data)
                    {
                    }
                });
                return false; // avoid to execute the actual submit of the form.
            });
            $("#phone_form").submit(function() {
                var url = "<%=context%>/ClientServlet?op=addClientCommunication"; // the script where you handle the form input.
                $.ajax({
                    type: "POST",
                    url: url,
                    data: $("#phone_form").serialize(), // serializes the form's elements.
                    success: function(data)
                    {
                       
                    }
                });
             //   return false; // avoid to execute the actual submit of the form.
            });
            
            
            
            function checkMail(obj) {

                if (!validateData2("email", this.email_form.email)) {
                    $("#mailMsg").show();
                    $("#mailMsg").html("بريد إلكترونى غير صحيح <br><font style='color:#005599;font-size:10px;'>For Example: youmail@yahoo.com</font>");
                } else {
                    $("#mailMsg").hide();
                    $("#mailMsg").html("");
                }

            }
            function removeEmail(emailId) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=deleteClientCommunication",
                    data: {
                        id: emailId
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            location.replace("<%=context%>/ClientServlet?op=viewClientCommunications&clientId=<%=clientWbo.getAttribute("id")%>");
                                            }
                                            else {
                                            }
                                        }
                                    });
                                }
                                function removePhone(phoneId) {
                                    $.ajax({
                                        type: "post",
                                        url: "<%=context%>/ClientServlet?op=deleteClientCommunication",
                                        data: {
                                            id: phoneId
                                        },
                                        success: function(jsonString) {
                                            var info = $.parseJSON(jsonString);
                                            if (info.status == 'ok') {
                                                location.replace("<%=context%>/ClientServlet?op=viewClientCommunications&clientId=<%=clientWbo.getAttribute("id")%>");
                                                                }
                                                                else {
                                                                }
                                                            }
                                                        });
                                                    }
        </script>
        <style>
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }
            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }
            tr:nth-child(even) td.dataTD {
                background: #FFF
            }
            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
            }
            .closeBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                /*background-image:url(images/buttons/close2.png);*/
            }
            #moMsg,#telMsg,#naMsg,#mailMsg{
                font-size: 14px;
                display: none;
                color: red;
                margin: 0px;
            }
            div.ui-datepicker{
                font-size:10px;
            }
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
    </head>
    <BODY>
       
        <div id="add_email"  style="width: 50% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <form id="email_form">
                    <table  border="0px"  style="width:100%;direction:ltr"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            Email    
                            </td>
                            <td style="width: 70%; text-align: right;" colspan="3">
                                <input type="email" style="width:180px" ID="email" name="value" value="" required maxlength="50"
                                       onkeyup="checkMail(this.value);" />
                                <p id="mailMsg" ></p>
                                <input type="hidden" value="email" name="type"/>
                                <input type="hidden" value="<%=clientWbo.getAttribute("id")%>" name="clientId"/>
                                <input type="hidden" value="addClientCommunication" name="op"/>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="submit" value="save" id="addEmail" class="login-submit"/>
                    </div>  
                </form>
            </div>
        </div>
        <div id="add_phone"  style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <form id="phone_form">
                    <table  border="0px"  style="width:100%;direction: ltr"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                Phone
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <input type="text" style="float: right; border: 1px solid silver;border-radius: 5px;height: 20px;padding-left: 10px; width: 90%;" ID="phone" name="value" value="" maxlength="15" required
                                       onblur="JavaScript: InvalidPhoneMsg(this);"
                                       onkeypress="javascript: return isNumber(event);"
                                       oninvalid="JavaScript: return InvalidPhoneMsg(this);"/>
                                <input type="hidden" value="phone" name="type"/>
                                <input type="hidden" value="<%=clientWbo.getAttribute("id")%>" name="clientId"/>
                                <input type="hidden" value="addClientCommunication" name="op"/>
                            </td>
                        </tr>
                                
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                        <input type="submit" value="save" id="addPhone" class="login-submit"/>
                    </div>      
                              
                </form>
            </div>
        </div>
        <div id="add_date"  style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <form id="phone_form">
                    <table  border="0px"  style="width:100%;direction:  ltr"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                Name
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <input type="text" style="float: right; border: 1px solid silver;border-radius: 5px;height: 20px;padding-left: 10px; width: 90%;" ID="name" name="name" value="" maxlength="15" required/>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                Birth Date
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <input type="text" style="float: right; border: 1px solid silver;border-radius: 5px;height: 20px;padding-left: 10px; width: 90%;" ID="birthDate" name="value" value="" maxlength="15" required readonly/>
                                <input type="hidden" value="date" name="type"/>
                                <input type="hidden" value="<%=clientWbo.getAttribute("id")%>" name="clientId"/>
                                <input type="hidden" value="addClientCommunication" name="op"/>
                            </td>
                        </tr>
                                
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                        <input type="submit" value="save" id="addPhone" class="login-submit"/>
                    </div>      
                              
                </form>
            </div>
        </div>
        <form name="CLIENT_UPDATE" action="" METHOD="POST">
            
                
            <center>
                <input type="button" onclick="JavaScript:cancelForm()" class="closeBtn" style="margin-right: 2px;"></button>
            </center>
            <fieldset class="set" align="center" width="100%" style="width: 95%;margin-bottom: 10px;">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <table  border="0px" dir="<%=dir%>" class="table" style="width:90%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                    <tr>
                        <td class="td titleTD" style="width: 40%; padding-left: 20px;">
                            Email
                            <img src="images/units/email.png" style="width: 30px;float: left; cursor: pointer;"
                                 onclick="JavaScript: showAddEmail();"/>
                        </td>
                        <td class="td titleTD" style="width: 30%; padding-left: 20px;">
                            Another Phone
                            <img src="images/dialogs/phone.png" style="width: 30px;float: left; cursor: pointer;"
                                 onclick="JavaScript: showAddPhone();"/>
                        </td>
                        <td class="td titleTD" style="width: 30%; padding-left: 20px;">
                            Family History
                            <img src="images/icons/calendar.png" style="width: 30px;float: left; cursor: pointer;"
                                 onclick="JavaScript: showAddDate();"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="td" style="vertical-align: top;">
                            <table width="100%">
                                <%
                                    if (emailsList != null && emailsList.size() > 0) {
                                        for (WebBusinessObject email : emailsList) {
                                %>
                                <tr>
                                    <td class="td dataTD" style="padding-left: 17px;">
                                        <%=email.getAttribute("communicationValue")%>
                                        <img src="images/icons/remove.png" style="width: 30px;float: left; cursor: pointer;"
                                             onclick="JavaScript: removeEmail('<%=email.getAttribute("id")%>')"/>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td class="td dataTD">
                                       No Data
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </td>
                        <td class="td" style="vertical-align: top;">
                            <table width="100%">
                                <%
                                    if (phonesList != null && phonesList.size() > 0) {
                                        for (WebBusinessObject phone : phonesList) {
                                %>
                                <tr>
                                    <td class="td dataTD" style="padding-left: 17px;">
                                        <%=phone.getAttribute("communicationValue")%>
                                        <img src="images/icons/remove.png" style="width: 30px;float: left; cursor: pointer;"
                                             onclick="JavaScript: removeEmail('<%=phone.getAttribute("id")%>')"/>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td class="td dataTD">
                                        No Data
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </td>
                        <td class="td" style="vertical-align: top;">
                            <table width="100%">
                                <%
                                    if (datesList != null && datesList.size() > 0) {
                                        for (WebBusinessObject dateWbo : datesList) {
                                %>
                                <tr>
                                    <td class="td dataTD" style="padding-left: 17px;">
                                        <%=dateWbo.getAttribute("option1") != null ? dateWbo.getAttribute("option1") : "لا يوجد اسم"%>
                                        <br/>
                                        <br/>
                                        <%=dateWbo.getAttribute("communicationValue")%>
                                        <img src="images/icons/remove.png" style="width: 30px;float: left; cursor: pointer;"
                                             onclick="JavaScript: removeEmail('<%=dateWbo.getAttribute("id")%>')"/>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td class="td dataTD">
                                        No Data
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </BODY>
</html>