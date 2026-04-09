<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            List<WebBusinessObject> unitsList = (List<WebBusinessObject>) request.getAttribute("unitsList");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript">
            $(document).ready(function () {
                $("table[name='units']").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                });
            });
        </script>
    </head>
    <body>
        <table name="units" class="display" cellspacing="0" width="100%" dir="rtl">
            <thead>
                <tr>
                    <th width="20%">&nbsp;</th>
                    <th width="50%">الاسم</th>
                </tr>
            </thead> 
            <tbody>
                <%
                    for (WebBusinessObject unit : unitsList) {
                %>
                <tr style="cursor: pointer" onmouseover="this.className = ''" onmouseout="this.className = ''">
                    <td>
                        <input type="radio" name="unitName" value="<%=unit.getAttribute("projectName")%>" />
                    </td>
                    <td><%=unit.getAttribute("projectName")%></td>
                </tr>
                <%}%>
            </tbody>
        </table>
    </body>
</html>