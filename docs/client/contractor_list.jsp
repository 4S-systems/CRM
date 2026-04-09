<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            List<WebBusinessObject> contractorsList = (List<WebBusinessObject>) request.getAttribute("contractorsList");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript">
            $(document).ready(function () {
                $("table[name='contactors']").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                });
            });
        </script>
    </head>
    <body>
        <table name="contactors" class="display" cellspacing="0" width="100%" dir="rtl">
            <thead>
                <tr>
                    <th width="20%">&nbsp;</th>
                    <th width="50%">الاسم</th>
                </tr>
            </thead> 
            <tbody>
                <%
                    for (WebBusinessObject contactor : contractorsList) {
                %>
                <tr style="cursor: pointer" onmouseover="this.className = ''" onmouseout="this.className = ''">
                    <td>
                        <input type="radio" name="clientID" value="<%=contactor.getAttribute("id")%>" />
                    </td>
                    <td><%=contactor.getAttribute("name")%></td>
                </tr>
                <%}%>
            </tbody>
        </table>
    </body>
</html>