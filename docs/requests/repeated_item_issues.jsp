<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            ArrayList<WebBusinessObject> issues = (ArrayList<WebBusinessObject>) request.getAttribute("issues");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <script type="text/javascript">
            $(document).ready(function () {
                $("table[name='issues']").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                });
            });
        </script>
    </head>
    <body>
        <table name="issues" class="display" cellspacing="0" width="100%" dir="rtl">
            <thead>
                <tr>
                    <th width="20%">رقم المتابعة</th>
                    <th width="30%">المقاول</th>
                </tr>
            </thead> 
            <tbody>
                <%
                    for (WebBusinessObject wbo : issues) {
                %>
                <tr style="cursor: pointer" onmouseover="this.className = ''" onmouseout="this.className = ''">
                    <td><font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDByDate")%></font></td>
                    <td><%=wbo.getAttribute("contractorName")%></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </body>
</html>
