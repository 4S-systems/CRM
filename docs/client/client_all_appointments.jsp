<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
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
                        Notes
                    </th>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">
                        Date
                    </th>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">
                        Agent
                    </th>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">
                        Call Status
                    </th>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">
                        Result
                    </th>
                    <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">
                        Time
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    String note, currentStatus, color, src;
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    Calendar c = Calendar.getInstance();
                    c.add(Calendar.DAY_OF_MONTH, -1);
                    for (WebBusinessObject appointmentWbo : appointmentsList) {
                        String creationTime = (String) appointmentWbo.getAttribute("creationTime");
                        if (creationTime != null && creationTime.length() > 16) {
                            creationTime = creationTime.substring(0, creationTime.lastIndexOf(":"));
                        }
                        note = (appointmentWbo.getAttribute("note") != null && !appointmentWbo.getAttribute("note").toString().equalsIgnoreCase("UL")) ? (String) appointmentWbo.getAttribute("note") : "لا يوجد";
                        currentStatus = appointmentWbo.getAttribute("currentStatus") != null ? (String) appointmentWbo.getAttribute("currentStatus") : "";
                        switch (note) {
                            case "INSTANCE-FOLLOW-UP":
                                note = "متابعة مباشرة";
                                break;
                            case "meeting":
                                note = "تحديد مقابلة مستقبلية ";
                                break;
                            case "Follow":
                            case "FOLLOW":
                                note = "تحديد مكالمة مستقبلية ";
                                break;
                            case "Waiting":
                            note = " Waiting ";
                                break;
                        }
                        switch (currentStatus) {
                            case "25": // اهملت
                                color = "background-color: #FF988A;"; // red
                                src = "images/icons/calendar_circle_red.png";
                                break;
                            case "29": // متابعة مباشرة
                                color = "background-color: #d6f4fe;"; // blue
                                src = "images/icons/calendar_circle_blue.png";
                                break;
                            case "24": // معتنى بها
                                color = "background-color: #A4FFD2;"; // green
                                src = "images/icons/calendar_circle_green.png";
                                break;
                            case "23": // مفتوحة
                                if (sdf.parse(creationTime).before(c.getTime())) {
                                    color = "background-color: #FF988A;"; // red
                                    src = "images/icons/calendar_circle_red.png";
                                } else {
                                    color = "background-color: #F0FF9B;"; // yellow
                                    src = "images/icons/calendar_circle_yellow.png";
                                }
                                break;
                            case "26": // تمت بنجاح
                                color = "";
                                src = "images/icons/bookmarks.png";
                                break;
                            default:
                                color = "";
                                src = "";
                        }
                %>
                <tr style="<%=color%>">
                    <td>
                        <textarea style="background-color: yellow;" cols="30" rows="5">
                            <%=appointmentWbo.getAttribute("comment") != null && !"UL".equals(appointmentWbo.getAttribute("comment")) ? appointmentWbo.getAttribute("comment") : ""%>
                        </textarea>
                            <img src="<%=src%>" style="width: 25px;"/>
                    </td>
                    <td>
                        <%=creationTime%>
                    </td>
                    <td>
                        <%=appointmentWbo.getAttribute("createdByName")%>
                    </td>
                    <td>
                        <%=appointmentWbo.getAttribute("option9") != null && !"UL".equals(appointmentWbo.getAttribute("option9")) ? appointmentWbo.getAttribute("option9") : ""%>
                        <%
                            if("attended".equals(appointmentWbo.getAttribute("option9")) && "meeting".equals(appointmentWbo.getAttribute("option2"))) {
                        %>
                        <img src="images/icons/star.png"/>
                        <%
                            }
                        %>
                    </td>
                    <td>
                        <%=note%>
                    </td>
                    <td>
                        <%=appointmentWbo.getAttribute("option8") != null && !"UL".equals(appointmentWbo.getAttribute("option8")) ? appointmentWbo.getAttribute("option8") : ""%>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </body>
</html>
