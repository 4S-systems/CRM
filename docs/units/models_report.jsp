<%@page import="java.text.DecimalFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String[] tableHeaderList = {"أسم المشروع", "كود النموذج", "أسم النموذج", "المساحة", "عدد الوحدات", "المتاحة", "المحجوزة", "المباعة", "نسبة المبيعات"};
            ArrayList<WebBusinessObject> modelsList = (ArrayList<WebBusinessObject>) request.getAttribute("modelsList");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function() {
                oTable = $('#units').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });

            function openPopup(obj) {
                var url = obj;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=800,height=400");
            }
        </script>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <legend>
                <table>
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            تقرير النماذج السكنية 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <br>
            <center> <b> <font size="3" color="red"> 
                    عدد النماذج السكنية : <%=modelsList.size()%>
                    </font></b></center> 
            <br>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="center" dir="rtl" id="units" style="width:100%;">
                    <thead>
                    <th>
                        <B>&nbsp;</B>
                    </th>
                    <%
                        for (int i = 0; i < tableHeaderList.length; i++) {
                    %>
                    <th>
                        <B><%=tableHeaderList[i]%></B>
                    </th>
                    <%}%>
                    </thead>
                    <tbody>
                        <%
                            WebBusinessObject wbo;
                            DecimalFormat df = new DecimalFormat("##.##");
                            for (int k = 0; k < modelsList.size(); k++) {
                                wbo = modelsList.get(k);
                        %>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <div>
                                    <b><%=wbo.getAttribute("optionOne") != null && !((String) wbo.getAttribute("optionOne")).equalsIgnoreCase("UL") ? wbo.getAttribute("optionOne") : wbo.getAttribute("Project_Name")%></b>  
                                </div>
                            </td>
                            <td>
                                <div>
                                    <b><%=wbo.getAttribute("Model_Code")%></b>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <b><%=wbo.getAttribute("Model_Name")%></b>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <b><%=wbo.getAttribute("totalArea") != null ? wbo.getAttribute("totalArea") : "---"%></b>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <b><%=wbo.getAttribute("totalCount") != null ? wbo.getAttribute("totalCount") : "0"%></b>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <b style="color: green;"><%=wbo.getAttribute("availableCount") != null ? wbo.getAttribute("availableCount") : "0"%></b>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <b style="color: red;"><%=wbo.getAttribute("reservedCount") != null ? wbo.getAttribute("reservedCount") : "0"%></b>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <b style="color: blue;"><%=wbo.getAttribute("soldCount") != null ? wbo.getAttribute("soldCount") : "0"%></b>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <b><%=wbo.getAttribute("totalCount") != null && wbo.getAttribute("soldCount") != null ? df.format(((BigDecimal) wbo.getAttribute("soldCount")).doubleValue() / ((BigDecimal) wbo.getAttribute("totalCount")).doubleValue()) : "0.00"%> %</b>
                                </div>
                            </td>
                        </tr>
                        <%}%>
                    </tbody>
                </TABLE>
                <br />
            </div>
        </fieldset>
    </body>
</html>
