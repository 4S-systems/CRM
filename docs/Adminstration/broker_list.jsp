<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>

<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String[] userAttributes = {"fullName", "CommercialRegister", "TaxCardNumber", "AuthorizedPerson", "RecordDate", "phoneNumber","NOSALES"};
            String[] userListTitles = new String[9];
            int s = userAttributes.length;
            int t = s + 2;
            String attName = null;
            String attValue = null;
            ArrayList<WebBusinessObject> brokersList = (ArrayList<WebBusinessObject>) request.getAttribute("brokersList");
            String stat = (String) request.getSession().getAttribute("currentMode");
            String align, dir, style, title;
            if (stat.equals("En")) {
                align = "center";
                dir = "LTR";
                style = "text-align:left";
                userListTitles[0] = "Broker Name";
                userListTitles[1] = "Commercial Record";
                userListTitles[2] = "Tax Card No.";
                userListTitles[3] = "Authorized Person";
                userListTitles[4] = "Record Date";
                userListTitles[5] = "Mobile Number";
                userListTitles[6] = "No. of Sales";
                userListTitles[7] = "Edit";
                userListTitles[8] = "Delete";
                title = "Brokers List";

            } else {
                align = "center";
                dir = "RTL";
                style = "text-align:Right";
                userListTitles[0] = "اسم الوسيط";
                userListTitles[1] = "السجل التجاري";
                userListTitles[2] = "رقم البطاقة الضريبية";
                userListTitles[3] = "من له حق التوقيع";
                userListTitles[4] = "تاريخ السجل التجاري";
                userListTitles[5] = "رقم الهاتف";
                userListTitles[6] = "عدد السيلز";
                userListTitles[7] = "تعديل";
                userListTitles[8] = "حذف";
                title = "عرض الوسطاء";
            }
        %>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css" />
        <link rel="stylesheet" href="css/demo_table.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                oTable = $('#users').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[3, "asc"]]
                }).fadeIn(2000);
            });
        </script>
        <style>
        </style>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 100%;">
            <legend align="center">
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6"><%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <div style="width: 70%; margin-left: auto; margin-right: auto;">
                <table align="<%=align%>" dir="<%=dir%>" style="width: 100%;" id="users">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>
                            <th >
                                <b><%=userListTitles[i]%></b>
                            </th>
                            <%
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int j = 0;

                            for (WebBusinessObject wbo : brokersList) {
                        %>
                        <tr>
                            <%
                                for (int i = 0; i < s; i++) {
                                    attName = userAttributes[i];
                                    attValue = wbo.getAttribute(attName) != null ? (String) wbo.getAttribute(attName) : "";
                                    if (i == 4 && attValue.length() > 10) {
                                        attValue = attValue.substring(0, 10);
                                    } else if (i == 5 && attValue.equals("UL")) {
                                        attValue = "---";
                                    }
                            %>
                            <td>
                                <b> <%=attValue%> </b>
                            </td>
                            <%
                                }
                            %>
                            <td>
                                <a href="<%=context%>/UsersServlet?op=mediatorInformation&userId=<%=wbo.getAttribute("userId")%>">

                                    <%=userListTitles[7]%>
                                </a> 
                            </td>
                            <td>
                                <a href="<%=context%>/UsersServlet?op=mediatorInformation&userId=<%=wbo.getAttribute("userId")%>&delete=Delete&nameBrokerOld=<%=wbo.getAttribute("fullName")%>">

                                    <%=userListTitles[8]%>
                                </a> 
                            </td>
                        </tr>
                        <%
                                j++;
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <br/><br/>
        </fieldset>
    </body>
</html>
