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
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        ArrayList<WebBusinessObject> clientFinancialList = (ArrayList<WebBusinessObject>) request.getAttribute("clientFinancialList");
        String connectionError = (String) request.getAttribute("connectionError");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, sTitle, errorMsg;
        if (stat.equals("En")) {
            dir = "LTR";
            errorMsg = "Error connecting to external database. Please contact administrator.";
            sTitle = "Financial Report";
        } else {
            dir = "RTL";
            errorMsg = "خطأ في اﻷتصال بقاعدة البيانات الخارجية. نرجو التواصل مع المسؤول.";
            sTitle = "الموقف المالي";
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
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function() {
                oTable = $('#details').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]

                }).fadeIn(2000);

            });
            function cancelForm() {
                self.close();
            }
        </script>
        <style>
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
                padding: 10px;
            }
            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
                padding: 10px;
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
                background-image:url(images/buttons/close2.png);
            }
            .submitBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/submit.png);
            }
        </style>
    </head>
    <BODY>
        <form name="CLIENT_UPDATE" action="<%=context%>/ClientServlet?op=UpdateClientData" METHOD="POST">
            <center>
                <input type="button" onclick="JavaScript:cancelForm()" class="closeBtn" style="margin-right: 2px;"></button>
            </center>
            <fieldset class="set" align="center" style="width: 95%;margin-bottom: 10px;">
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
                <%
                    if (connectionError != null) {
                %>
                <b style="color: blue">
                    <%=errorMsg%>
                </b>
                <%
                    }
                %>
                <br />
                <br />
                <%
                    if (clientWbo != null) {
                %>
                <center>
                    <table  border="0px" dir="<%=dir%>" class="table" style="width:50%;text-align: center;" >
                        <tr>
                            <td class="td titleTD">
                                كود العميل
                            </td>
                            <td class="td dataTD">
                                <%=clientWbo.getAttribute("clientNO") != null ? ((String) clientWbo.getAttribute("clientNO")).substring(1) : ""%>
                            </td>
                            <td class="td titleTD">
                                اسم العميل
                            </td>
                            <td class="td dataTD">
                                <%=clientWbo.getAttribute("name") != null ? clientWbo.getAttribute("name") : ""%>
                            </td>
                        </tr>
                    </table>
                </center>
                <br/>
                <br/>
                <table id="details" style="width: 100%;" dir="rtl">
                    <thead>
                        <tr>
                            <th>
                                الإستمارة
                            </th>
                            <th>
                                تاريخ الإستمارة
                            </th>
                            <th>
                                المرحلة
                            </th>
                            <th>
                                نوع الوحدة
                            </th>
                            <th>
                                رقم الوحدة
                            </th>
                            <th>
                                رقم المبنى
                            </th>
                            <th>
                                تاريخ التعاقد
                            </th>
                            <th>
                                مساحة المبانى
                            </th>
                            <th>
                                مساحة الأرض
                            </th>
                            <th>
                                المندوب
                            </th>
                            <th>
                                تاريخ الاستلام
                            </th>
                            <th>
                                دفعة الاستلام
                            </th>
                            <th>
                                الأقساط المتأخرة
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (clientFinancialList != null) {
                                for (WebBusinessObject clientFinancialWbo : clientFinancialList) {
                                    String reserveDate = "";
                                    String signDate = "";
                                    String submitDate = "";
                                    if (clientFinancialWbo.getAttribute("reserveFormDate") != null) {
                                        if (((String) clientFinancialWbo.getAttribute("reserveFormDate")).contains(" ")) {
                                            reserveDate = ((String) clientFinancialWbo.getAttribute("reserveFormDate")).split(" ")[0];
                                        } else {
                                            reserveDate = (String) clientFinancialWbo.getAttribute("reserveFormDate");
                                        }
                                    }
                                    if (clientFinancialWbo.getAttribute("dateSignContract") != null) {
                                        if (((String) clientFinancialWbo.getAttribute("dateSignContract")).contains(" ")) {
                                            signDate = ((String) clientFinancialWbo.getAttribute("dateSignContract")).split(" ")[0];
                                        } else {
                                            signDate = (String) clientFinancialWbo.getAttribute("dateSignContract");
                                        }
                                    }
                                    if (clientFinancialWbo.getAttribute("submitDate") != null) {
                                        if (((String) clientFinancialWbo.getAttribute("submitDate")).contains(" ")) {
                                            submitDate = ((String) clientFinancialWbo.getAttribute("submitDate")).split(" ")[0];
                                        } else {
                                            submitDate = (String) clientFinancialWbo.getAttribute("submitDate");
                                        }
                                    }
                        %>
                        <tr>
                            <td><%=clientFinancialWbo.getAttribute("formNo")%></td>
                            <td><%=reserveDate%></td>
                            <td><%=clientFinancialWbo.getAttribute("stageDescription")%></td>
                            <td><%=clientFinancialWbo.getAttribute("buildingTypeDescription")%></td>
                            <td><%=clientFinancialWbo.getAttribute("unitCode")%></td>
                            <td><%=clientFinancialWbo.getAttribute("buildingCode")%></td>
                            <td><%=signDate%></td>
                            <td><%=clientFinancialWbo.getAttribute("buildingArea")%></td>
                            <td><%=clientFinancialWbo.getAttribute("landArea")%></td>
                            <td><%=clientFinancialWbo.getAttribute("salesRepName")%></td>
                            <td><%=submitDate%></td>
                            <td><%=clientFinancialWbo.getAttribute("istlam")%></td>
                            <td><%=clientFinancialWbo.getAttribute("notPayed")%></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
                <br/>
                <br/>
                <%
                    }
                %>
            </fieldset>
        </form>
    </BODY>
</html>