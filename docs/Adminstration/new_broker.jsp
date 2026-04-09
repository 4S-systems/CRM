
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String status = (String) request.getAttribute("status");
    if (status == null) {
        status = "";
    }
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String fStatus, noChnl, save, cancel, sEmail, sTitle, success, fullName, commercialRegister, taxCardNo, authorizedPerson,
            companyAddress, recordDate, mobile;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:left";
        sTitle = "New User";
        cancel = "Cancel";
        save = "Save";
        sEmail = "Email Address";
        fStatus = "Fail To Create Group";
        noChnl="No Broker Communication Channel ,contact administraiton";
        
        success = "Saved Successfully";
        fullName = "Name";
        commercialRegister = "Commercial Register";
        taxCardNo = "Tax Card Number";
        authorizedPerson = "Authorized Person";
        companyAddress = "Company Address";
        recordDate = "Record Date";
        mobile = "Mobile";
    } else {
        align = "right";
        dir = "RTL";
        style = "text-align:Right";
        sTitle = "وسيط جديد";
        cancel = "إنهاء";
        save = "حفظ";
        noChnl="No Broker Communication Channel ,contact administraiton";
        sEmail = "البريد الإلكتروني";
        fStatus = "لم يتم الحفظ";
        success = "تم الحفظ بنجاح";
        fullName = "الاسم";
        commercialRegister = "السجل التجاري";
        taxCardNo = "رقم البطاقة الضربية";
        authorizedPerson = "من له حق التوقيع ";
        companyAddress = "عنوان الشركة ";
        recordDate = "تاريخ السجل التجاري ";
        mobile = "رقم الموبايل";
    }
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="CSS.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css" />
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script language="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#recordDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd" 
                });
            });
            function submitForm() {
                if (!validateData("req", this.BROKER_FORM.fullName, "Please, enter Name ...")) {
                    this.BROKER_FORM.fullName.focus();
                } else {
                    document.BROKER_FORM.action = "<%=context%>/UsersServlet?op=getBrokerForm";
                    document.BROKER_FORM.submit();
                }
            }

            function cancelForm() {
                document.BROKER_FORM.action = "main.jsp";
                document.BROKER_FORM.submit();
            }
        </script>
        <style>
            .backgroundTable {
                text-align: <%=align%>;
                padding-<%=align%>: 15px;
                padding-bottom: 5px;
                padding-top: 5px;
            }
        </style>
    </head>
    <body onload="document.BROKER_FORM.fullName.focus();">
        <form action="" name="BROKER_FORM" method="POST">
            <div align="center" style="color: blue; padding-left: 5%; padding-bottom: 10px;">
                <button onclick="cancelForm()" class="button"><%=cancel%></button>
                &ensp;
                <input type="button" onclick="JavaScript: submitForm();" value="<%=save%>" class="button" />
            </div>
            <center>
                <fieldset class="set" style="width: 90%; border-color: #006699;">
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=sTitle%></font>
                            </td>
                        </tr>
                    </table>
                    <%
                        if (status.equalsIgnoreCase("noChnl")) {
                    %>
                    <br/>
                    <table align="center" dir="<%=dir%>" style="margin-left: auto; margin-right: auto;">
                        <tr>
                            <td class="td">
                                <font size="3" color="red"><%=noChnl%></font>
                            </td>
                        </tr>
                    </table>
                        <%
                        }else if (status.equalsIgnoreCase("fail")) {
                    %>  
                    
                    <br/>
                    <table align="center" dir="<%=dir%>" style="margin-left: auto; margin-right: auto;">
                        <tr>
                            <td class="td">
                                <font size="3" color="red"><%=fStatus%></font>
                            </td>
                        </tr>
                    </table>
                    <% } else if (status.equalsIgnoreCase("ok")) {%>
                    <br/>
                    <table align="center" dir="<%=dir%>" style="margin-left: auto; margin-right: auto;">
                        <tr>
                            <td class="td">
                                <font size="3" color="blue"><%=success%></font>
                            </td>
                        </tr>
                    </table>
                    <% }%>
                    <br/>
                    <table class="backgroundTable" width="60%" cellpadding="0" cellspacing="8" align="center" dir="<%=dir%>">
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=fullName%> *</b>
                            </td>
                            <td class='backgroundTable' width="65%">
                                <input type="text" name="fullName" ID="fullName" size="33" value="" maxlength="255" style="width: 400px; color: black; font-weight: bold; font-size: 12px;" />
                            </td>
                        </tr>
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sEmail%></b>
                            </td>
                            <td class='backgroundTable' width="65%">
                                <input type="text" name="email" ID="email" size="33" value="" maxlength="255" style="width: 400px; color: black; font-weight: bold; font-size: 12px;" />
                            </td>
                        </tr>
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b><%=commercialRegister%></b>
                            </td>
                            <td class='backgroundTable'>
                                <input type="text" id="commercialRegister" name="commercialRegister" value="" style="width: 200px;"/>
                            </td>
                        </tr>
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b><%=taxCardNo%></b>
                            </td>
                            <td class='backgroundTable'>
                                <input type="text" id="taxCardNumber" name="taxCardNumber" value="" style="width: 200px;"/>
                            </td>
                        </tr>
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b><%=recordDate%></b>
                            </td>
                            <td class='backgroundTable'>
                                <input type="text"  name="recordDate" id="recordDate" size="33" value="" style="width: 200px;" readonly/>
                            </td>
                        </tr>
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b><%=authorizedPerson%></b>
                            </td>
                            <td class='backgroundTable'>
                                <input type="text" name="authorizedPerson" id="authorizedPerson" value="" style="width: 200px;"/>
                            </td>
                        </tr>
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b><%=companyAddress%></b>
                            </td>
                            <td class='backgroundTable'>
                                <textarea name="companyAddress" id ="companyAddress" style="width: 200px;"></textarea> 
                            </td>
                        </tr>
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b><%=mobile%></b>
                            </td>
                            <td class='backgroundTable'>
                                <input type="text"  name="phoneNumber" id="phoneNumber" size="33" value="" style="width: 200px;"/>
                            </td>
                        </tr>
                        <tr>
                            <td class='blueBorder blueHeaderTD'>
                                <b>No. of Sales</b>
                            </td>
                            <td class='backgroundTable'>
                                <input type="text"  name="noSales" id="noSales" size="33" value="" style="width: 200px;"/>
                            </td>
                        </tr>
                    </table>
                    <br />
                </fieldset>
            </center>
        </form>
    </body>
</html>