<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        Calendar c = Calendar.getInstance();
        String beginDate;
        if (request.getAttribute("beginDate") != null) {
            beginDate = (String) request.getAttribute("beginDate");
        } else {
            beginDate = sdf.format(c.getTime());
        }
        c.add(Calendar.MONTH, 1);
        String endDate;
        if (request.getAttribute("endDate") != null) {
            endDate = (String) request.getAttribute("endDate");
        } else {
            endDate = sdf.format(c.getTime());
        }
        String status = (String) request.getAttribute("status");
        ArrayList<WebBusinessObject> inspectionsList = (ArrayList<WebBusinessObject>) request.getAttribute("inspectionsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign;
        String dir = null;
        String clientsNo, title, savePlan, period, dateMsg, planTitle;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsNo = "Clients No.";
            title = "Quality Plan";
            savePlan = "Save";
            period = "Follow in";
            dateMsg = "\"From Date must be greater than or equal \"To Date\"";
            planTitle = "Plan Title";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsNo = "عدد العملاء";
            title = "تخطيط الجودة";
            savePlan = "حفظ";
            period = "متابعة كل";
            dateMsg = "\"ألي تاريخ\" يجب أن يكون أكبر من أو يساوي \"من تاريخ\"";
            planTitle = "عنوان الخطة";
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            function submitForm() {
                if (!compareDate()) {
                    alert('<%=dateMsg%>');
                } else if (!validateData("req", this.CALLING_PLAN_FORM.frequencyRate, "أدخل معدل التكرار") ||
                        !validateData("numeric", this.CALLING_PLAN_FORM.frequencyRate, "أدخل رقم صحيح")) {
                    this.CALLING_PLAN_FORM.frequencyRate.focus();
                } else if (!validateData("req", this.CALLING_PLAN_FORM.planTitle, "أدخل عنوان الخطة")) {
                    this.CALLING_PLAN_FORM.planTitle.focus();
                } else {
                    document.CALLING_PLAN_FORM.submit();
                }
            }
            function compareDate() {
                return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
            }
        </script>
        <style type="text/css">
        </style>
    </HEAD>
    <body>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Quality Planning تخطيط الجودة</b>
        <fieldset align=center class="set" style="width: 90%">
            <%
                if ("ok".equalsIgnoreCase(status)) {
            %>
            <table style="margin-left: auto; margin-right: auto;">
                <tr>
                    <td class="td"> 
                        <b>
                            <font size="4" style="color: green;">
                            تم الحفظ بنجاح برقم </font>
                            <font size="4" style="color: red;">
                            <%=request.getAttribute("planCode")%>
                            </font>
                        </b>
                    </td>
                </tr>
            </table>
            <br/>
            <%
            } else if ("no".equalsIgnoreCase(status)) {
            %>
            <table style="margin-left: auto; margin-right: auto;">
                <tr>
                    <td class="td"> 
                        <b>
                            <font size="4" style="color: green;">
                            لم يتم الحفظ
                            </font>
                        </b>
                    </td>
                </tr>
            </table>
            <br/>
            <%
                }
            %>
            <form name="CALLING_PLAN_FORM" action="<%=context%>/IssueServlet?op=createQualityPlan" method="POST">
                <br/>
                <img src="images/quality-plan.jpg" style="float: <%=xAlign%>; width: 250px; margin-<%=xAlign%>: 150px;"/>
                <table ALIGN="center" DIR="RTL" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white">بداية الخطة</b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                            <b> <font size=3 color="white">نهاية الخطة</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>" style="margin: 5px;" readonly />
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" style="margin: 5px;" readonly />
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b> <font size=3 color="white">العمل المطلوب</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b> <font size=3 color="white"><%=period%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <select name="requestedTitle" id="requestedTitle" style="width:230px; font-size: 14px;">
                                <option value="">أختر</option>
                                <sw:WBOOptionList wboList="<%=inspectionsList%>" displayAttribute="projectName" valueAttribute="projectName"/>
                            </select>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <input type="number" style="width: 100px;" name="frequencyRate" ID="frequencyRate" size="20" value="" maxlength="255"/>
                            <select style="width: 150px; font-size: 15px; font-weight: bold;" name="frequencyType" ID="frequencyType">
                                <option value="1">أسبوع</option>
                                <option value="2">شهر</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b> <font size=3 color="white"><%=planTitle%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede"  style="text-align:center" valign="middle" colspan="2">
                            <input type="text" style="width: 400px;" name="planTitle" ID="planTitle" size="20" value="" maxlength="255"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" colspan="2">  
                            <button type="button" onclick="JavaScript: submitForm();" style="color: #27272A;font-size:15px;margin: 5px;font-weight:bold; width: 100px;"><%=savePlan%></button>
                        </td>
                    </tr>
                </table>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>
