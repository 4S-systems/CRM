<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<String> userCampaignIDsList = (ArrayList<String>) request.getAttribute("userCampaignIDsList");
        ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
        ArrayList<WebBusinessObject> brokersList = (ArrayList<WebBusinessObject>) request.getAttribute("brokersList");
        String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, brokerName, userName;
        if (stat.equals("En")) {
            dir = "LTR";
            brokerName = "Broker";
            userName = "User";
        } else {
            dir = "RTL";
            brokerName = "الوسيط";
            userName = "الموظف";
        }
    %>
    <head>
        <script type="text/javascript">
            $(document).ready(function () {
                $('#brokers').dataTable({
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    bJQueryUI: true,
                    "bPaginate": true,
                    "bProcessing": true,
                    "bFilter": true
                }).fadeIn(2000);
            });
        </script>
    </head>
    <body>
        <table class="blueBorder" align="center" dir="<%=dir%>" width="90%" style="border-width: 1px; border-color: white; display: block;">
            <tr>
                <td class="ui-dialog-titlebar ui-widget-header" style="width: 50%;">
                    <b>
                        <%=userName%>
                    </b>
                </td>
                <td class="td" style="width: 50%;">
                    <select id="userID" name="userID" class="chosen-select-user"
                            onchange="JavaScript: popupAddUserBrokers($(this).val());">
                        <sw:WBOOptionList displayAttribute="fullName" valueAttribute="userId" wboList="<%=usersList%>" scrollToValue="<%=userID%>" />
                    </select>
                </td>
            </tr>
            <tr>
                <td class="ui-dialog-titlebar ui-widget-header" style="width: 50%;">
                    <b><%=brokerName%></b>
                </td>
                <td class="td" style="width: 50%;">
                    <select id="brokerID" name="brokerID" class="chosen-select-user" multiple>
                        <%
                            if (brokersList != null) {
                                for (WebBusinessObject brokerWbo : brokersList) {
                        %>
                        <option value="<%=brokerWbo.getAttribute("id")%>" <%=userCampaignIDsList.contains((String) brokerWbo.getAttribute("id")) ? "selected" : ""%>>
                            <%=brokerWbo.getAttribute("campaignTitle")%>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </td>
            </tr>
        </table>
        <br/><br/>
    </body>
</html>