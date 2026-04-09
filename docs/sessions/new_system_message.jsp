<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%
    String stat = (String) request.getSession().getAttribute("currentMode");
    WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
    String id = wbo != null ? (String) wbo.getAttribute("id") : null;
    String message, onDate, frequency, period, status, title, messageType;
    if (wbo != null) {
        message = (String) wbo.getAttribute("message");
        onDate = ((String) wbo.getAttribute("onDate")).substring(0, 16).replaceAll("-", "/");
        frequency = (String) wbo.getAttribute("frequency");
        period = (String) wbo.getAttribute("period");
        status = (String) wbo.getAttribute("status");
        title = wbo.getAttribute("option1") != null ? (String) wbo.getAttribute("option1") : "";
        messageType = wbo.getAttribute("option2") != null ? (String) wbo.getAttribute("option2") : "";
    } else {
        message = "";
        onDate = "";
        frequency = "";
        period = "";
        status = "";
        title = "";
        messageType = "";
    }

    String dir = null;
    if (stat.equals("En")) {
        dir = "LTR";
    } else {
        dir = "RTL";
    }
%>
<html>
    <head>
        <script language="JavaScript" type="text/javascript">
            $(function () {
                $("#onDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: 0,
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm"
                });
            });
        </script>
        <style>
            .ui-datepicker {
                font-size: x-small;
            }
            .silver_header {
                background-size: auto 100%;
                color: black;
            }
        </style>
    </head>
    <body>
        <form name="MESSAGE_FORM" id="MESSAGE_FORM" method="post">
            <center>
                <table style="margin-bottom: 20px; margin-top: 20px" ALIGN="center"  dir="<%=dir%>" border="0" width="90%" cellpadding="4" cellspacing="2" >
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px;">
                            نوع التكرار
                        </td>
                        <td class="td" style="text-align: right; border-top: 0px;">
                            <select class="chosen-select" name="frequency" id="frequency" required="true" style="width: 230px; font-size: 16px;">
                                <option value=""></option>
                                <option value="once" <%=frequency.equals("once") ? "selected" : ""%>>Once</option>
                                <option value="daily" <%=frequency.equals("daily") ? "selected" : ""%>>Daily</option>
                                <option value="monthly" <%=frequency.equals("monthly") ? "selected" : ""%>>Monthly</option>
                            </select>
                            <%
                                if (wbo != null) {
                            %>
                            <input type="hidden" id="id" name="id" value="<%=id%>"/>
                            <%
                                }
                            %>
                        </td>
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px;">
                            الحالة
                        </td>
                        <td class="td" style="text-align: right; border-top: 0px;">
                            <table dir="<%=dir%>" border="0" cellpadding="0" cellspacing="0" >
                                <tr>
                                    <td class="td" style="width: 5px;">
                                        <input type="radio" id="active" name="status" value="1" <%=!status.equals("0") ? "checked" : ""%>/>
                                    </td>
                                    <td class="td" style="width: 15px;">
                                        Active
                                    </td>
                                    <td class="td" style="width: 5px;">
                                        <input type="radio" id="inactive" name="status" value="0" <%=status.equals("0") ? "checked" : ""%>/>
                                    </td>
                                    <td class="td" style="width: 15px;">
                                        Inactive
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px;">
                            فترة الظهور (د)
                        </td>
                        <td class="td" style="text-align: right; border-top: 0px;">
                            <input type="number" name="period" id="period" value="<%=period%>" required="true" style="width: 130px; font-size: 16px;"/>
                        </td>
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px;">
                            التاريخ
                        </td>
                        <td class="td" style="text-align: right; border-top: 0px;">
                            <input type="text" name="onDate" id="onDate" value="<%=onDate%>" required="true" readonly style="width: 130px; font-size: 16px;"/>
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px;">
                            الموضوع
                        </td>
                        <td class="td" style="text-align: right; border-top: 0px;">
                            <select id="title" name="title" style="width: 130px; font-size: 16px;">
                                <option value=""></option>
                                <option value="تنبيه" <%=title.equals("تنبيه") ? "selected" : ""%>>تنبيه</option>
                                <option value="Database Backup" <%=title.equals("Database Backup") ? "selected" : ""%>>Database Backup</option>
                                <option value="System Restart" <%=title.equals("System Restart") ? "selected" : ""%>>System Restart</option>
                                <option value="Unpaid Account" <%=title.equals("Unpaid Account") ? "selected" : ""%>>Unpaid Account</option>
                            </select>
                        </td>
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px;">
                            النوع
                        </td>
                        <td class="td" style="text-align: right; border-top: 0px;">
                            <select id="messageType" name="messageType" style="width: 130px; font-size: 16px;">
                                <option value=""></option>
                                <option value="إستكمال بيانات العملاء" <%=messageType.equals("إستكمال بيانات العملاء") ? "selected" : ""%>>إستكمال بيانات العملاء</option>
                                <option value="database" <%=messageType.equals("database") ? "selected" : ""%>>Database</option>
                                <option value="alert" <%=messageType.equals("alert") ? "selected" : ""%>>Overload</option>
                                <option value="fatal" <%=messageType.equals("fatal") ? "selected" : ""%>>Fatal</option>
                                <option value="info" <%=messageType.equals("info") ? "selected" : ""%>>Info</option>
                            </select>
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px;">
                            الرسالة
                        </td>
                        <td class="td" style="text-align: right; border-top: 0px;" colspan="3">
                            <textarea name="message" id="message" required="true" style="width: 350px; font-size: 16px; height: 100px; max-height: 100px; min-height: 100px; max-width: 350px; min-width: 350px;"><%=message%></textarea>
                        </td>
                    </tr>
                </table>
            </center>
        </form>
        <style>
            .td{width: 40%;}
            .td2{width: 10%;}
        </style>
    </body>
</html>