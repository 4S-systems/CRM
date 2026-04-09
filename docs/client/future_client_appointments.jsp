<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
    <head>
        <%
            ArrayList<WebBusinessObject> appointmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("appointments");
            String stat = "Ar";
            String align = "center";
            String dir = null;
            String style = null;
            if (stat.equals("En")) {
                align = "left";
                dir = "LTR";
                style = "text-align:right";
            } else {
                dir = "RTL";
                align = "right";
                style = "text-align:Right";
            }
        %>
        <style>
        </style>
        <script type="text/javascript">
            $(document).ready(function () {
            });
        </script>
    </head>
    <body>
        <table id="clientAppointmentsPopup" style="width: 100%; margin: auto;" cellpadding="0" cellspacing="0" dir="<%=dir%>">
            <thead>
                <tr>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px;">
                        ملاحظات
                    </th>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">
                        تاريخ المقابلة
                    </th>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">
                        تاريخ الجدولة
                    </th>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">
                        الموظف
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    String currentStatus, color, appointmentDate, creationTime;
                    for (WebBusinessObject appointmentWbo : appointmentsList) {
                        appointmentDate = (String) appointmentWbo.getAttribute("appointmentDate");
                        if (appointmentDate != null && appointmentDate.length() > 16) {
                            appointmentDate = appointmentDate.substring(0, appointmentDate.lastIndexOf(":"));
                        }
                        creationTime = (String) appointmentWbo.getAttribute("creationTime");
                        if (creationTime != null && creationTime.length() > 19) {
                            creationTime = creationTime.substring(0, 19);
                        }
                        currentStatus = appointmentWbo.getAttribute("currentStatus") != null ? (String) appointmentWbo.getAttribute("currentStatus") : "";
                        switch (currentStatus) {
                            case "25": // اهملت
                                color = "background-color: #FF988A;"; // red
                                break;
                            case "29": // متابعة مباشرة
                                color = "background-color: #d6f4fe;"; // blue
                                break;
                            case "24": // معتنى بها
                                color = "background-color: #A4FFD2;"; // green
                                break;
                            case "23": // مفتوحة
                                color = "background-color: #F0FF9B;"; // yellow
                                break;
                            case "26": // تمت بنجاح
                                color = "";
                                break;
                            default:
                                color = "";
                        }
                %>
                <tr style="<%=color%>">
                    <td>
                        <textarea style="background-color: yellow;" cols="20" rows="5">
                            <%=appointmentWbo.getAttribute("comment") != null && !"UL".equals(appointmentWbo.getAttribute("comment")) ? appointmentWbo.getAttribute("comment") : ""%>
                        </textarea>
                    </td>
                    <td>
                        <%=appointmentDate%>
                    </td>
                    <td>
                        <%=creationTime%>
                    </td>
                    <td>
                        <%=appointmentWbo.getAttribute("createdByName")%>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </body>
</html>
