<%-- 
    Document   : list_of_requests_item
    Created on : Jan 6, 2015, 4:36:21 PM
    Author     : walid
--%>

<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            List<WebBusinessObject> items = (List<WebBusinessObject>) request.getAttribute("items");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <script type="text/javascript">
            $(document).ready(function() {
                $("table[name='requests']").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                });
            });
        </script>
    </head>
    <body>
        <table name="requests" class="display" cellspacing="0" width="100%" dir="rtl">
            <thead>
                <tr>
                    <TH width="20%">&nbsp;</TH>
                    <TH width="30%">الكود</TH>
                    <TH width="50%">الاسم</TH>
                </tr>
            </thead> 
            <tbody>
                <%
                    int counter = 0;
                    for (WebBusinessObject item : items) {
                %>
                <tr style="cursor: pointer" onmouseover="this.className = ''" onmouseout="this.className = ''">
                    <td>
                        <input type="checkbox" value="<%=counter%>">
                        <input type="hidden" id="itemId<%=counter%>" value="<%=item.getAttribute("projectID")%>" />
                        <input type="hidden" id="itemCode<%=counter%>" value="<%=item.getAttribute("eqNO")%>" />
                        <input type="hidden" id="itemName<%=counter%>" value="<%=item.getAttribute("projectName")%>" />
                        <% String rateHour = item.getAttribute("optionThree") != null ? item.getAttribute("optionThree").toString() : "";%>
                        <input type="hidden" id="rateHour<%=counter%>" value="<%=rateHour%>" />
                        <% String quantity = item.getAttribute("optionOne") != null ? item.getAttribute("optionOne").toString() : "";%>
                        <input type="hidden" id="quantity<%=counter%>" value="<%=quantity%>" />
                    </td>
                    <td><%=item.getAttribute("eqNO")%></td>
                    <td><%=item.getAttribute("projectName")%></td>
                </tr>
                <% counter++; }%>
            </tbody>
        </table>
    </body>
</html>
