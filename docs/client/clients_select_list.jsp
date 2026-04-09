<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
            String stat = (String) request.getSession().getAttribute("currentMode");
            String clientNo, clientName, dir, align;
            if (stat.equals("En")) {
                dir = "ltr";
                align = "left";
                clientNo = "Client No.";
                clientName = "Name";
            } else {
                dir = "rtl";
                align = "ltr";
                clientNo = "رقم العميل";
                clientName = "الاسم";
            }
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <script type="text/javascript">
            $(document).ready(function () {
                $("table[name='requests']").dataTable({
                    "destroy": true
                });
            });
        </script>
    </head>
    <body>
        <table name="requests" class="display" cellspacing="0" width="100%" dir="<%=dir%>">
            <thead>
                <tr>
                    <TH width="10%">&nbsp;</TH>
                    <TH width="30%"><%=clientNo%></TH>
                    <TH width="20%"><%=clientName%></TH>
                </tr>
            </thead> 
            <tbody>
                <%
                    if (clientsList != null && !clientsList.isEmpty()) {
                        for (WebBusinessObject clientWbo : clientsList) {
                %>
                <tr style="cursor: pointer;" onmouseover="this.className = ''" onmouseout="this.className = ''">
                    <td style=" text-align: center;">
                        <input type="radio" value="<%=clientWbo.getAttribute("id")%>" name="clientListID">
                        <input type="hidden" id="clientName<%=clientWbo.getAttribute("id")%>" value="<%=clientWbo.getAttribute("name")%>" />
                        <input type="hidden" id="clientNo<%=clientWbo.getAttribute("id")%>" value="<%=clientWbo.getAttribute("clientNO")%>" />
                        <input type="hidden" id="clientRegion<%=clientWbo.getAttribute("id")%>" value="<%=clientWbo.getAttribute("region")!= null ? clientWbo.getAttribute("region") : ""%>" />
                        <input type="hidden" id="clientMobile<%=clientWbo.getAttribute("id")%>" value="<%=clientWbo.getAttribute("mobile") != null ? clientWbo.getAttribute("mobile") : ""%>" />
                        <input type="hidden" id="clientAddress<%=clientWbo.getAttribute("id")%>" value="<%=clientWbo.getAttribute("address") != null ? clientWbo.getAttribute("address") : ""%>" />
                    </td>
                    <td style=" text-align: <%=align%>;"><%=clientWbo.getAttribute("clientNO")%></td>
                    <td style=" text-align: <%=align%>;"><%=clientWbo.getAttribute("name")%></td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </body>
</html>
