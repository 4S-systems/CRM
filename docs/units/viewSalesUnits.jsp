<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getDefaultRefreshPageInterval();
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        String fromDateVal = (String) request.getAttribute("fromDate");
        String toDateVal = (String) request.getAttribute("toDate");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, title, fromDate, toDate, search;
        String cancelButtonLabel, unitCode, registrationDate, clientNm, createdBy, creationTime, area, price,
                details, date, print, month, total, model;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "Sales Units";
            cancelButtonLabel = "Cancel ";
            fromDate = "From Date";
            toDate = "To Date";
            search = "Search";
            unitCode = "Unit Code";
            registrationDate = "Client Registration Date";
            clientNm = "Client Name";
            createdBy = "Effected By";
            creationTime = "Selling Time";
            area = "Area";
            price = "Price";
            details = "Client Details";
            date = "Selling Date";
            print = "Print";
            month = "Month";
            total = "Total of Manth ";
            model = "Model";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "عرض المبيعات";
            cancelButtonLabel = "إنهاء ";
            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            search = "بحث";
            unitCode = "كود الوحده";
            registrationDate = "تاريخ تسجيل العميل";
            clientNm = "اسم العميل";
            createdBy = "القائم بالبيع";
            creationTime = "تاريخ البيع";
            area = "المساحه";
            price = "السعر";
            details = "تفاصيل العميل";
            date = "تاريخ البيع";
            print = "طباعة";
            month = "الشهر";
            total = "أجمالي شهر ";
            model = "النموذج";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    %>
    <head>
        <%--<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" href="css/CSS.css"/>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/loading/loading.js"></script>
        <script type="text/javascript" src="js/loading/spin.js"></script>
        <script type="text/javascript" src="js/loading/spin.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>--%>

        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function () {


                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });

                $('#unitsList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "order": [[5, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 5,
                            "visible": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        var lastMonth = null;
                        var total = 0;
                        var length = rows.length;
                        api.column(5, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                lastMonth = last;
                                if (last !== null) {
                                    $(rows).eq(i).before('<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: darkgray;" colspan="4">&nbsp;</td>\n\
                                        <td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: darkgray;" colspan="2"><%=total%>(' + lastMonth + ')</td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="2">'
                                            + total.toLocaleString() + '</td></tr>'
                                            );
                                }
                                total = 0;
                                $(rows).eq(i).before('<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="2"><%=month%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="2">'
                                        + group + '</td><td class="blueBorder blueBodyTD" colspan="4"></td></tr>'
                                        );
                                last = group;
                            }
                            total += parseInt(rows[i].children[6].innerText);
                            if (i === (length - 1)) {
                                $(rows).eq(i).after('<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: darkgray;" colspan="4">&nbsp;</td>\n\
                                    <td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: darkgray; nowrap" colspan="2"><%=total%>(' + group + ')</td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="2">'
                                        + total.toLocaleString() + '</td></tr>'
                                        );
                            }
                        });
                    }
                }).show();
            });

            function hideHeaderFooter() {
                $(".fg-toolbar").hide();
            }
            function showHeaderFooter() {
                $(".fg-toolbar").show();
            }

            function cancelForm()
            {
                document.url = "<%=context%>/main.jsp";
            }
            function navigateToClient(clientId) {
                location.href = "<%=context%>/ClientServlet?op=clientDetails&clientId=" + clientId;
            }
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=500");
            }
        </SCRIPT>
        <style>  
            .canceled {
                background-color: #ffa722;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .confirmed {
                background-color: #e1efbb;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .onhold {
                background-color: #369bd7;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }

            .titlebar {
                height: 30px;
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
            #products
            {
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }
            #products tr
            {
                padding: 5px;
            }
            #products td
            {  
                font-size: 12px;
                font-weight: bold;
            }
            #products select
            {                
                font-size: 12px;
                font-weight: bold;
            }

        </style>
    </head>


    <BODY>
        <FORM NAME="UNIT_LIST_FORM" METHOD="POST">
            <%--<DIV align="left" STYLE="color:blue; margin-left: 1%">
                <button onclick="JavaScript: cancelForm();" class="button"><%=cancelButtonLabel%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
            </DIV>--%>
            <br />
            <FIELDSET class="set" style="width:98%;border-color: #006699" id="fieldset">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <form name="UNIT_LIST_FORM" method="post">
                    <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                           style="border-width:1px;border-color:white;display: block; margin-left: auto; margin-right: auto;">
                        <tr class="head">
                            <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                                <b><font size=3 color="white"><%=fromDate%></font></b>
                            </td>
                            <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                                <b><font size=3 color="white"><%=toDate%></font></b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                                <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" readonly title="<%=date%>"/><img src="images/showcalendar.gif"/>
                                <br/><br/>
                            </td>
                            <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                                <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly title="<%=date%>"/><img src="images/showcalendar.gif"/>
                                <br/><br/>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle" colspan="2">
                                <button type="submit" class="button"><%=search%><img height="15" src="images/search.gif"/></button>
                                <br/>
                                <br/>
                            </td>
                        </tr>
                    </table>
                </form>
                <br/>
                <div align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px; padding-top: 10px; vertical-align: top;">
                    <button type="button" value="" onclick="JavaScript: hideHeaderFooter(); printDiv('printArea'); showHeaderFooter();" class="button" style="float: bottom; width: 40px;"><img style="height:25px;" src="images/icons/printer.png" title="<%=print%>"/></button>
                </div>
                <div id="printArea" style="width:100%;margin-right: auto;margin-left: auto;">
                    <TABLE ALIGN="center" dir="<%=dir%>" id="unitsList"id="printArea" style="width:100%;">
                        <thead>
                            <TR>
                                <Th>
                                    <B><%=unitCode%></B>
                                </Th>
                                <Th>
                                    <B><%=clientNm%></B>
                                </Th>
                                <Th>
                                    <B><%=createdBy%></B>
                                </Th>
                                <th>
                                    <B><%=registrationDate%></B>
                                </th>
                                <th>
                                    <B><%=creationTime%></B>
                                </th>
                                <th>
                                    <B><%=month%></B>
                                </th>
                                <th>
                                    <B>
                                        <%=area%> 
                                    </B>
                                </th>
                                <th>
                                    <B>
                                        <%=price%>
                                    </B>
                                </th>
                            </TR>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject wbo : unitsList) {
                            %>
                            <TR>
                                <TD id="<%=wbo.getAttribute("id")%>">
                                    <a target="blank" href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=wbo.getAttribute("projectId")%>">
                                        <b><%=wbo.getAttribute("unit")%></b>
                                    </a>
                                    <%--
                                    <a href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=wbo.getAttribute("projectId")%>&searchBy=<%=request.getAttribute("searchBy")%>&searchValue=<%=request.getAttribute("searchValue")%>&ownerID=<%=wbo.getAttribute("ownerID")%>">
                                        <b><%=wbo.getAttribute("projectName")%></b>
                                    </a>
                                    --%>
                                </TD>
                                <TD>
                                    <a target="blank" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientId")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="<%=details%>">
                                            <b><%=wbo.getAttribute("clientName")%></b>
                                    </a>
                                </TD>
                                <TD>
                                    <B><%=wbo.getAttribute("createdByName")%></B>
                                </TD>
                                <TD>
                                    <B><%=wbo.getAttribute("registrationDate").toString().split(" ")[0]%></B>
                                </TD>
                                <TD>
                                    <B><%=wbo.getAttribute("creationTime").toString().split(" ")[0]%></B>
                                </TD>
                                <TD>
                                    <B><%=wbo.getAttribute("creationTime").toString().substring(0, 7)%></B>
                                </TD>
                                <TD>
                                    <B><%=wbo.getAttribute("area")%></B>
                                </TD>
                                <TD>
                                    <B><%=wbo.getAttribute("price")%></B>
                                </TD>

                            </TR>
                            <% }%>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
            </fieldset>
        </FORM>
    </BODY>
</html>