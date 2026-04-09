<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String status = (String) request.getAttribute("status");
        String context = metaMgr.getContext();
        ArrayList<String> elementsList = (ArrayList<String>) request.getAttribute("elementsList");
        AutomationConfigurationMgr automationConfigurationMgr = AutomationConfigurationMgr.getCurrentInstance();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, update, successMsg, failMsg;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Automation Configuration";
            update = "Update";
            successMsg = "Saved Successfully";
            failMsg = "Fail To Save";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "Automation Configuration";
            update = "تحديث";
            successMsg = "تم الحفظ بنجاح";
            failMsg = "لم يتم الحفظ";
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript">
            function submitForm() {
                document.CONFIGURATION_FORM.action = "<%=context%>/ApplicationConfigurationServlet?op=saveAutomationConfiguration&save=true";
                document.CONFIGURATION_FORM.submit();
            }
        </script>
        <style>
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
    </head>
    <body>
        <form name="CONFIGURATION_FORM" method="post"> 
            <div align="left" style="color:blue;">
                <button type="button" onclick="JavaScript: submitForm();" class="button" id="submitButton"
                        style="margin-left: 100px;"><%=update%><img alt="" height="15" src="images/save.gif"></button>
            </div>
            <br/>
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <table dir="<%=dir%>" style="margin-left: auto; margin-right: auto;">
                    <tr>                 
                        <td class="td">
                            <%    if (null != status) {
                                    if (status.equalsIgnoreCase("ok")) {
                            %>
                            <font size="4" color="black"><%=successMsg%></font> 
                            <%
                            } else {
                            %>
                            <font size="4" color="red" ><%=failMsg%></font> 
                            <%}
                                }
                            %>&nbsp;
                        </td>        
                    </tr>
                </table>
                <br/>
                <table class="blueBorder" dir="ltr" align="center" width="550" cellpadding="0" cellspacing="0" style="">
                    <%
                        for (String elementName : elementsList) {
                    %>
                    <tr>
                        <td style="text-align:center;border-color: #006699;" class="blueBorder blueHeaderTD" colspan="2"
                            title="<%=automationConfigurationMgr.getElementDescription(elementName)%>">
                            <font color='white' size="+1"><%=automationConfigurationMgr.getElementTitle(elementName)%></font>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699;" class="blueBorder blueHeaderTD">
                            <b>Interval</b>
                        </td>
                        <td style="padding-left: 20px; padding-right: 20px; text-align: left;">
                            <input type="number" style="width: 180px;" name="<%=elementName%>" value="<%=automationConfigurationMgr.getElementInterval(elementName)%>"/>
                            &nbsp; <%=automationConfigurationMgr.getElementType(elementName)%>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699; background-image: url(images/thbg.jpg); background-size: 100%;" class="blueBorder blueHeaderTD">
                            <b>Description</b>
                        </td>
                        <td style="padding-left: 20px; padding-right: 20px; text-align: left;">
                            <textarea rows="5" style="width: 180px;" name="<%=elementName%>Desc"><%=automationConfigurationMgr.getElementDescription(elementName)%></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #ffffff;" width="100%" colspan="4">&nbsp;</td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD" colspan="2"
                            title="<%=automationConfigurationMgr.getElementDescription("appointment-notification-alarm")%>">
                            <font color='white' size="+1"><%=automationConfigurationMgr.getElementTitle("appointment-notification-alarm")%></font>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699;" class="blueBorder blueHeaderTD">
                            <b>Alarm Delay Interval</b>
                        </td>
                        <td style="padding-left: 20px; padding-right: 20px; text-align: left;">
                            <input type="number" style="width: 180px;" name="alarm-delay-interval" value="<%=automationConfigurationMgr.getAlarmDelayInterval()%>"/>
                            &nbsp; <%=automationConfigurationMgr.getAlarmDelayType()%>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699;" class="blueBorder blueHeaderTD" nowrap>
                            <b>Appointment Remaining Time</b>
                        </td>
                        <td style="padding-left: 20px; padding-right: 20px; text-align: left;">
                            <input type="number" style="width: 180px;" name="appointment-remaining-time" value="<%=automationConfigurationMgr.getAppointmentRemainingTime()%>"/>
                            &nbsp; <%=automationConfigurationMgr.getAppointmentRemainingType()%>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699; background-image: url(images/thbg.jpg); background-size: 100%;" class="blueBorder blueHeaderTD">
                            <b>Description</b>
                        </td>
                        <td style="padding-left: 20px; padding-right: 20px; text-align: left;">
                            <textarea rows="5" style="width: 180px;" name="appointment-notification-alarm-desc"><%=automationConfigurationMgr.getElementDescription("appointment-notification-alarm")%></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #ffffff;" width="100%" colspan="4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD" colspan="2"
                            title="<%=automationConfigurationMgr.getElementDescription("sla-notification-alarm")%>">
                            <font color='white' size="+1"><%=automationConfigurationMgr.getElementTitle("sla-notification-alarm")%></font>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699;" class="blueBorder blueHeaderTD">
                            <b>Alarm Delay Interval</b>
                        </td>
                        <td style="padding-left: 20px; padding-right: 20px; text-align: left;">
                            <input type="number" style="width: 180px;" name="sla-alarm-delay-interval" value="<%=automationConfigurationMgr.getSLAAlarmDelayInterval()%>"/>
                            &nbsp; <%=automationConfigurationMgr.getSLAAlarmDelayType()%>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699;" class="blueBorder blueHeaderTD" nowrap>
                            <b>SLA Remaining Time</b>
                        </td>
                        <td style="padding-left: 20px; padding-right: 20px; text-align: left;">
                            <input type="number" style="width: 180px;" name="sla-remaining-time" value="<%=automationConfigurationMgr.getSLARemainingTime()%>"/>
                            &nbsp; <%=automationConfigurationMgr.getSLARemainingType()%>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #006699; background-image: url(images/thbg.jpg); background-size: 100%;" class="blueBorder blueHeaderTD">
                            <b>Description</b>
                        </td>
                        <td style="padding-left: 20px; padding-right: 20px; text-align: left;">
                            <textarea rows="5" style="width: 180px;" name="sla-notification-alarm-desc"><%=automationConfigurationMgr.getElementDescription("sla-notification-alarm")%></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;border-color: #ffffff;" width="100%" colspan="4">&nbsp;</td>
                    </tr>
                </table>
                <br/>
            </fieldset>
        </form>
    </body>
</html>     
