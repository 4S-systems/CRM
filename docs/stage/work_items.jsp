<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            List<WebBusinessObject> items = (List<WebBusinessObject>) request.getAttribute("items");
            Map<String, String> categoryMap = (HashMap<String, String>) request.getAttribute("categoryMap");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript">
            $(document).ready(function () {
                $("table[name='workItems']").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[3, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 3,
                            "visible": false
                        }], "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(3, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111;" colspan="2">نوع بند العمل</td> <td class="" style="font-size: 16px; color: #a41111;" colspan="2"> <b style="color: black;">' + group + ' </b> </td> <td class="" style="font-size: 16px; color: #a41111;" colspan="1" >&nbsp;</td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                });
            });
        </script>
    </head>
    <body>
        <form name="WORK_ITEM_FORM" id="PRICE_FORM" method="post">
            <table id="workItems" name="workItems" class="display" cellspacing="0" width="100%" dir="rtl">
                <thead>
                    <tr>
                        <th width="15%">&nbsp;</th>
                        <th width="15%">الكود</th>
                        <th width="30%">الاسم</th>
                        <th width="5%">نوع بند العمل</th>
                        <th width="15%">الكمية</th>
                        <th width="20%">ملاحظات</th>
                    </tr>
                </thead> 
                <tbody>
                    <%
                        for (WebBusinessObject item : items) {
                    %>
                    <tr style="cursor: pointer" onmouseover="this.className = ''" onmouseout="this.className = ''">
                        <td>
                            <input type="checkbox" name="itemID" value="<%=item.getAttribute("projectID")%>" />
                        </td>
                        <td><%=item.getAttribute("eqNO")%></td>
                        <td><%=item.getAttribute("projectName")%></td>
                        <td><%=categoryMap.containsKey((String) item.getAttribute("optionOne")) ? categoryMap.get((String) item.getAttribute("optionOne")) : "غير مصنف"%></td>
                        <td><input type="number" min="1" value="1" id="quantity<%=item.getAttribute("projectID")%>" name="quantity<%=item.getAttribute("projectID")%>"
                                   style="width: 50px;"/></td>
                        <td><input type="text" name="note<%=item.getAttribute("projectID")%>" /></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </form>
    </body>
</html>
