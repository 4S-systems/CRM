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
            String[] userAttributes = {"fullName", "campaignTitle", "CommercialRegister", "TaxCardNumber", "AuthorizedPerson", "RecordDate", "phoneNumber"};
            String[] userListTitles = new String[11];
            int s = userAttributes.length;
            int t = s +4;
            String attName = null;
            String attValue = null;
            String ClientNo, ReservationsNO;
            Map<String, String> brokerClientsCount = (HashMap<String, String>) request.getAttribute("brokerClientsCount");
            Map<String, String> brokerSoldCount = (HashMap<String, String>) request.getAttribute("brokerSoldCount");
            ArrayList<WebBusinessObject> brokersList = (ArrayList<WebBusinessObject>) request.getAttribute("brokersList");
            String stat = (String) request.getSession().getAttribute("currentMode");
            String align, dir, style, title;
            if (stat.equals("En")) {
                align = "center";
                dir = "LTR";
                style = "text-align:left";
                userListTitles[0] = "Broker Name";
                userListTitles[1] = "Contract";
                userListTitles[2] = "Commercial Record";
                userListTitles[3] = "Tax Card No.";
                userListTitles[4] = "Authorized Person";
                userListTitles[5] = "Record Date";
                userListTitles[6] = "Mobile Number";
                userListTitles[7] = "Broker Clients";
                userListTitles[8] = "Broker Sales";
                userListTitles[9] = "Edit";
                userListTitles[10] = "Delete";
                ClientNo = "Has no clients";
                ReservationsNO = "Has no sales";
                title = "Brokers Statistics";
            } else {
                align = "center";
                dir = "RTL";
                style = "text-align:Right";
                userListTitles[0] = "اسم الوسيط";
                userListTitles[1] = "التعاقد";
                userListTitles[2] = "السجل التجاري";
                userListTitles[3] = "رقم البطاقة الضريبية";
                userListTitles[4] = "من له حق التوقيع";
                userListTitles[5] = "تاريخ السجل التجاري";
                userListTitles[6] = "رقم الهاتف";
                userListTitles[7] = "عملاء الوسيط";
                userListTitles[8] = "مبيعات الوسيط";
                userListTitles[9] = "تعديل";
                userListTitles[10] = "حذف";
                ClientNo = "ليس لديه عملاء";
                ReservationsNO = "ليس لديه مبيعات ";
                title = "أحصائيات الوسطاء";
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
            function deleteBroker(id, name) {
                var r = confirm('Delete Broker, are you sure?');
                if (r) {
                    $.ajax({
                        type: 'POST',
                        url: "<%=context%>/UsersServlet?op=deleteBroker",
                        data: {
                            brokerID: id,
                            brokerName: name
                        }, success: function (data) {
                            var jsonString = $.parseJSON(data);
                            if (jsonString.status === 'ok') {
                                location.reload();
                            } else {
                                alert('Cannot delete Broker');
                            }
                        }
                    });
                }
            }

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
            <div style="width: 85%; margin-left: auto; margin-right: auto;">
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
                                    if (i == 5 && attValue.length() > 10) {
                                        attValue = attValue.substring(0, 10);
                                    } else if (i == 6 && attValue.equals("UL")) {
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
                                <%
                                    if (brokerClientsCount.containsKey((String) wbo.getAttribute("campaignID"))) {
                                %>
                                <a href="<%=context%>/CampaignServlet?op=listCampaignClients&campaignId=<%=wbo.getAttribute("campaignID")%>">
                                    <%=brokerClientsCount.get((String) wbo.getAttribute("campaignID"))%>
                                </a>
                                <%} else {%>
                                <%=ClientNo%>
                                <% } %>
                            </td>
                            <td>
                                <% if (brokerSoldCount.containsKey((String) wbo.getAttribute("campaignID"))) {
                                         String broker_id = (String) brokersList.get(j).getAttribute("userID");%>
                                <a href="<%=context%>/ClientServlet?op=getCampaignSoldClients&campaignID=<%=wbo.getAttribute("campaignID")%>">
                                    <%= brokerSoldCount.get((String) wbo.getAttribute("campaignID"))%>
                                </a>
                                <%} else {%>
                                <%=ReservationsNO%>
                                <% }%>

                            </td>
                            <td>
                                <a href="<%=context%>/UsersServlet?op=mediatorInformation&userId=<%=wbo.getAttribute("userID")%>">
                                    <%=userListTitles[9]%>
                                </a> 
                            </td>
                            <td>
                                <% if (brokerClientsCount.containsKey((String) wbo.getAttribute("campaignID"))
                                             && brokerSoldCount.containsKey((String) wbo.getAttribute("campaignID"))) {%>
                                <a href="JavaScript: alert('you can not delete this broker as he has clients and Reservations');" >
                                    <%=userListTitles[10]%>
                                </a>
                                <% } else if (brokerClientsCount.containsKey((String) wbo.getAttribute("campaignID"))) {%>

                                <a href="JavaScript: alert('you can not delete this broker as he has clients');" >
                                    <%=userListTitles[10]%>
                                </a>
                                <%  } else if (brokerSoldCount.containsKey((String) wbo.getAttribute("campaignID"))) {%>
                                <a href="JavaScript: alert('you can not delete this broker as he has Reservations');" >
                                    <%=userListTitles[10]%>
                                </a>
                                <% } else {%>
                                <a href="JavaScript: deleteBroker('<%=wbo.getAttribute("userID")%>', '<%=wbo.getAttribute("fullName")%>')" >
                                    <%=userListTitles[10]%>
                                </a>
                                <% } %>
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
