<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        String status = (String) request.getAttribute("Status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        LiteWebBusinessObject scheduleWbo = (LiteWebBusinessObject) request.getAttribute("scheduleWbo");
        LiteWebBusinessObject contractWbo = (LiteWebBusinessObject) request.getAttribute("contractWbo");
        ArrayList<LiteWebBusinessObject> typesList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("typesList");
        String fromDateVal = "", toDateVal = "", quantityVal = "", frequencyTypeVal = "", frequencyRateVal = "", typeVal = "";
        if (null != scheduleWbo) {
            fromDateVal = scheduleWbo.getAttribute("fromDate") != null ? (String) scheduleWbo.getAttribute("fromDate") : "";
            fromDateVal = fromDateVal.replaceAll("-", "/").substring(0, 10);
            toDateVal = scheduleWbo.getAttribute("toDate") != null ? (String) scheduleWbo.getAttribute("toDate") : "";
            toDateVal = toDateVal.replaceAll("-", "/").substring(0, 10);
            frequencyTypeVal = scheduleWbo.getAttribute("frequencyType") != null ? (String) scheduleWbo.getAttribute("frequencyType") : "";
            frequencyRateVal = scheduleWbo.getAttribute("frequencyRate") != null ? (String) scheduleWbo.getAttribute("frequencyRate") : "";
            typeVal = scheduleWbo.getAttribute("scheduleType") != null ? (String) scheduleWbo.getAttribute("scheduleType") : "";
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;
        String title;
        String cancelButtonLabel;
        String saveButtonLabel;
        String fStatus;
        String sStatus;
        String selectStr, contractNumber, scheduleTitle, toDate, fromDate, frequencyType, frequencyRate, type, day, week, month, year;

        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            title = "Update Contract's Scheduling";
            cancelButtonLabel = "Cancel ";
            saveButtonLabel = "Save ";
            langCode = "Ar";
            sStatus = "Schedule Saved Successfully";
            fStatus = "Fail To Save This Schedule";
            selectStr = "Select";
            contractNumber = "Contract Number";
            fromDate = "From Date";
            toDate = "To Date";
            scheduleTitle = "Title";
            frequencyType = "Frequency Type";
            frequencyRate = "Frequency Rate";
            type = "Type";
            day = "Day";
            week = "Week";
            month = "Month";
            year = "Year";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            title = "تعديل جدولة عقد";
            cancelButtonLabel = "خروج";
            saveButtonLabel = "حفظ ";
            langCode = "En";
            fStatus = "لم يتم تسجيل هذه الجدولة";
            sStatus = "تم تسجيل الجدولة بنجاح";
            selectStr = "أختار";
            contractNumber = "رقم العقد";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            scheduleTitle = "عنوان الجدول";
            frequencyType = "نوع التكرار";
            frequencyRate = "معدل التكرار";
            type = "النوع";
            day = "يوم";
            week = "اسبوع";
            month = "شهر";
            year = "سنة";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" type="text/css" href="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css"/>
        <script src='validator.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS.css"/>
        <link rel="stylesheet" type="text/css" href="Button.css"/>
        <link rel="stylesheet" type="text/css" href="css\headers.css"/>        
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">
        <script src="js/jquery.bpopup.min.js"></script>
        <script src='silkworm_validate.js' type='text/javascript'></script>
        <script language="JavaScript" type="text/javascript">
            $(document).ready(function () {
                $("#fromDate").datepicker({
                    dateFormat: "yy/mm/dd",
                    timeFormat: 'hh:mm:ss',
                    onSelect: function () {
                        var date2 = $('#fromDate').datepicker('getDate');
                        $('#toDate').datepicker('option', 'minDate', date2);
                    }
                });
                $('#toDate').datepicker({
                    dateFormat: "yy/mm/dd",
                    onClose: function () {
                        var dt1 = $('#fromDate').datepicker('getDate');
                        var dt2 = $('#toDate').datepicker('getDate');
                        //check to prevent a user from entering a date below date of dt1
                        if (dt2 <= dt1) {
                            var minDate = $('#toDate').datepicker('option', 'minDate');
                            $('#toDate').datepicker('setDate', minDate);
                        }
                    }
                });
            });
            function submitForm() {
                if (!validateData("req", this.SCHEDULE_FORM.frequencyRate, "Please, enter Frequency Rate.") ||
                        !validateData("numeric", this.SCHEDULE_FORM.frequencyRate, "Please, enter a valid Frequency Rate.")) {
                    this.SCHEDULE_FORM.frequencyRate.focus();
                } else {
                    document.SCHEDULE_FORM.action = "<%=context%>/ContractsServlet?op=updateContractSchedule&scheduleID=" + "<%=scheduleWbo.getAttribute("id")%>";
                    document.SCHEDULE_FORM.submit();
                }
            }

            function cancelForm()
            {
                document.SCHEDULE_FORM.action = "<%=context%>/ContractsServlet?op=viewContractSchedules";
                document.SCHEDULE_FORM.submit();
            }
        </script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <style>
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
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
        </style>
    </head>
    <body>
        <div name="divTag" id="divTag" style="width: 80% !important;display: none;position: fixed;">
        </div>
        <form name="SCHEDULE_FORM" id="SCHEDULE_FORM" method="POST" >
            <div align="left" STYLE="color:blue;">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancelButtonLabel%><img valign="bottom" src="images/cancel.gif"> </button>
                <button type="button" onclick="JavaScript: submitForm();" class="button"><%=saveButtonLabel%><img height="15" src="images/save.gif"></button>
            </div>
            <br/><br/>
            <fieldset class="set" align="center" style="width: 700px;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                            <%=title%>
                            </font>
                        </td>
                    </tr>
                </table>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>  
                <tr>
                <table align="center" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="green"><%=sStatus%></font>
                        </td>                    
                    </tr> </table>
                </tr>
                <% } else {%>
                <tr>
                <table align="center" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font>
                        </td>                    
                    </tr> </table>
                </tr>
                <%}
                    }
                %>
                <br/>
                <br/>
                <div style="width: 90%; border: 2px inset #CCCCC;display: block;margin-right: auto;margin-left: auto; margin-bottom: 7px;">
                    <table style="width: 95%;"align="center" dir="<%=dir%>">
                        <tr>
                            <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px">
                                <b><%=contractNumber%></b>
                            </td>
                            <td class="td2" style="text-align: <%=align%>; font-size:14px; font-weight: bold; height: 25px; padding: 5px">
                                <b><%=contractWbo != null ? contractWbo.getAttribute("contractNumber") : ""%></b>
                                <input type="hidden" id='contractID' name='contractID' value="<%=contractWbo != null ? contractWbo.getAttribute("id") : ""%>"/>
                            </td>
                        </tr>
                        <tr>  
                            <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px">
                                <b>&nbsp; <%=scheduleTitle%>&nbsp;  </b>
                            </td>
                            <td class="td2" style="text-align: <%=align%>; font-size:14px; font-weight: bold; height: 25px; padding: 5px">
                                <input type="text" style="width: 200px;" name="scheduleTitle" ID="scheduleTitle" size="20" value="<%=scheduleWbo.getAttribute("scheduleTitle")%>" maxlength="255"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px">
                                <b style="font-size: 15px;font-weight: bold;">&nbsp; <%=fromDate%>&nbsp; </b>
                            </td>
                            <td class="td2" style="text-align: <%=align%>; font-size:14px; font-weight: bold; height: 25px; padding: 5px">
                                <input type="text" style="width: 140px;" name="fromDate" ID="fromDate" readonly size="20" value="<%=fromDateVal%>" maxlength="255" onchange="calTime(this)"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px">
                                <b style="font-size: 15px;font-weight: bold;">&nbsp; <%=toDate%>&nbsp; </b>
                            </td>
                            <td class="td2" style="text-align: <%=align%>; font-size:14px; font-weight: bold; height: 25px; padding: 5px">
                                <input type="text" style="width: 140px;" name="toDate" ID="toDate" readonly size="20" value="<%=toDateVal%>" maxlength="255"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px">
                                <b style="font-size: 15px;font-weight: bold;">&nbsp; <%=frequencyType%>&nbsp; </b>
                            </td>
                            <td class="td2" style="text-align: <%=align%>; font-size:14px; font-weight: bold; height: 25px; padding: 5px">
                                <select style="width: 200px; font-size: 15px; font-weight: bold;" name="frequencyType" ID="frequencyType">
                                    <option value='1' <%=("1").equals(frequencyTypeVal) ? "selected" : ""%>><%=day%></option>
                                    <option value='2' <%=("2").equals(frequencyTypeVal) ? "selected" : ""%>><%=week%></option>
                                    <option value='3' <%=("3").equals(frequencyTypeVal) ? "selected" : ""%>><%=month%></option>
                                    <option value='4' <%=("4").equals(frequencyTypeVal) ? "selected" : ""%>><%=year%></option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px">
                                <b style="font-size: 15px;font-weight: bold;">&nbsp; <%=frequencyRate%>&nbsp; </b>
                            </td>
                            <td class="td2" style="text-align: <%=align%>; font-size:14px; font-weight: bold; height: 25px; padding: 5px">
                                <input type="number" style="width: 200px;" name="frequencyRate" ID="frequencyRate" size="20" value="<%=frequencyRateVal%>" maxlength="255"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px">
                                <b><%=type%></b>
                            </td>
                            <td class="td2" style="text-align: <%=align%>; font-size:14px; font-weight: bold; height: 25px; padding: 5px">
                                <select class="blackFont fontInput" name="scheduleType" id="scheduleType" style="width: 200px; font-size: large;">
                                    <sw:WBOOptionList wboList='<%=typesList%>' displayAttribute ="projectName" valueAttribute="projectID" scrollToValue="<%=typeVal%>"/>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <br/><br/>
                </div>
            </fieldset>
        </form>
    </body>
</html>
