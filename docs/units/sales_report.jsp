<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> dataList = (ArrayList<WebBusinessObject>) request.getAttribute("dataList");
        String employeeNameTemp = "";;

        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, title, customerName, align, fromDate, toDate, display;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            title = "Sales Report";
            customerName = "Customer";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display";
        } else {
            align = "right";
            dir = "RTL";
            title = "تقرير المبيعات";
            customerName = "&#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
        }
    %>
    <head>
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css"/>
        <link REL="stylesheet" TYPE="text/css" HREF="css/Button.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" href="css/blueStyle.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
        </script>
        <script language="JavaScript" type="text/javascript">
            $(function () {
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function submitForm() {
                document.Stat.action = "<%=context%>/UnitServlet?op=getSalesReport";
                document.Stat.submit();
            }

            function getPDF() {
                var repType = $('input[name=reportType]:checked').val();
                $("#pdf").attr("href", "<%=context%>/ClientServlet?op=employeeWorkPDF&fromDate=" + $("#fromDate").val() + "&toDate=" + $("#toDate").val() + "&groupID=" + $("#groupID").val() + "&reportType=" + repType);
            }
        </script>
        <script src='ChangeLang.js' type='text/javascript'></script>
    </head>
    <body>
    <center>
        <br/><br/>
        <form name="Stat" action="post">
            <fieldset class="set" style="width:96%; height: auto;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table class="blueBorder" align="center" dir="RTL" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width:1px; border-color:white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td  class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="td" style="text-align: center;">
                            <input type="button" value="<%=display%>" onclick="submitForm()" class="button"/>
                            <input type="hidden" name="op" value="getSalesReport"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <table align="center" dir="rtl" width="95%" cellpadding="0" cellspacing="0" style="border: 1px solid #d3d5d4">
                    <tbody>  
                        <%
                            int counter = 0;
                            String clazz;
                            Date date;
                            boolean isFirst = true;
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            DecimalFormat decimalFormat = new DecimalFormat("###,###.##");
                            long total = 0L, tempUnitValue;
                            int serial = 1;
                            for (WebBusinessObject wbo : dataList) {
                                if (!employeeNameTemp.equals(wbo.getAttribute("createdByName"))) {
                                    employeeNameTemp = (String) wbo.getAttribute("createdByName");
                                    if (!isFirst) {
                        %>
                        <tr>
                            <td colspan="3" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>&nbsp;</b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>أجمالي</b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b><%=decimalFormat.format(total)%></b></td>
                        </tr>
                        <%
                                total = 0L;
                                serial = 1;
                            } else {
                                isFirst = false;
                            }
                        %>
                        <tr>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" colspan="2"><b>اسم الموظف</b></td>
                            <td style="text-align:<%=align%>; padding-<%=align%>: 20px;" colspan="3"><b><%=wbo.getAttribute("createdByName")%></b></td>
                        </tr>
                        <tr>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>#</b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>كود الوحدة</b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b> <%=customerName%></b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>تاريخ البيع</b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>قيمة الوحدة</b></span></td>
                        </tr>
                        <%
                            }
                            if ((counter % 2) == 1) {
                                clazz = "silver_odd_main";
                            } else {
                                clazz = "silver_even_main";
                            }
                            counter++;
                        %>
                        <tr class="<%=clazz%>">
                            <%
                                date = sdf.parse((String) wbo.getAttribute("reservationDate"));
                                tempUnitValue = wbo.getAttribute("unitValue") != null ? Long.parseLong((String) wbo.getAttribute("unitValue")) : 0L;
                                total += tempUnitValue;
                            %>
                            <td class="<%=clazz%>">
                                <b><%=serial%></b>
                            </td>
                            <td class="<%=clazz%>">
                                <b><%=wbo.getAttribute("projectName")%></b>
                            </td>
                            <td class="<%=clazz%>" style="cursor: pointer" onclick="JavaScript : navigateToClient('<%=wbo.getAttribute("clientId")%>')" nowrap>
                                <b><%=wbo.getAttribute("clientName")%></b>
                            </td>
                            <td class="<%=clazz%>" nowrap>
                                <b>
                                    <%=sdf.format(date)%>
                                </b>
                            </td>
                            <td class="<%=clazz%>" nowrap>
                                <b>
                                    <%=decimalFormat.format(tempUnitValue)%>
                                </b>
                            </td>
                        </tr>
                        <%
                                serial++;
                            }
                        %>
                        <tr>
                            <td colspan="3" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>&nbsp;</b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>أجمالي</b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b><%=decimalFormat.format(total)%></b></td>
                        </tr>
                    </tbody>
                </table>
                <br />
            </fieldset>
        </form>
        <br/><br/>
    </center>
</body>
</html>