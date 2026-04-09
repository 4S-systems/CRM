<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"option2", "option1", "creationTime"};
        String[] clientsListTitles = new String[4];
        int s = clientsAttributes.length;
        int t = s + 1;
        HashMap<String, String> statusMap = new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        ArrayList<WebBusinessObject> callingPlansList = (ArrayList<WebBusinessObject>) request.getAttribute("callingPlansList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String title;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            clientsListTitles[0] = "Code";
            clientsListTitles[1] = "Title";
            clientsListTitles[2] = "Date";
            clientsListTitles[3] = "Status";
            title = "My Campagins";
            statusMap.put("44", "Planned");
            statusMap.put("45", "Executed");
            statusMap.put("46", "Canceled");
        } else {
            align = "center";
            dir = "RTL";
            clientsListTitles[0] = "الكود";
            clientsListTitles[1] = "عنوان الحملة";
            clientsListTitles[2] = "في تاريخ";
            clientsListTitles[3] = "الحالة";
            title = "عرض حملاتي";
            statusMap.put("44", "مخطط");
            statusMap.put("45", "نفذ");
            statusMap.put("46", "ألغي");
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            function openAppointments(code, title, callingPlanID) {
                var divTag = $("#client_appointments");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/AppointmentServlet?op=getInternalAppointments',
                    data: {
                        callingPlanID: callingPlanID
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: title + " - " + code,
                                    show: "blind",
                                    hide: "explode",
                                    width: 1200,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Ok: function () {
                                            divTag.dialog('close');
                                        }
                                    }

                                })
                                .dialog('open');
                    }
                });
            }
        </script>
        <style type="text/css">
        </style>
    </HEAD>
    <body>
        <div id="client_appointments">&nbsp;</div>
        <fieldset align=center class="set" style="width: 90%">
            <legend align="center">

                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            <%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <form name="CALLING_PLAN_FORM" action="<%=context%>/ClientServlet?op=generateCallingPlan" method="POST">
                <div style="width: 50%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th>
                                    <B><%=clientsListTitles[i]%></B>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Date tempCreationTime;
                                for (WebBusinessObject clientWbo : callingPlansList) {
                                    sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
                                    tempCreationTime = sdf.parse((String) clientWbo.getAttribute("creationTime"));
                                    sdf.applyPattern("M/yyyy");
                            %>
                            <tr style="background-color: <%="1".equals(clientWbo.getAttribute("planFlag")) ? "#fbfdba" : ""%>;">
                                <td>
                                    <div>
                                        <a href="JavaScript: openAppointments('<%=clientWbo.getAttribute("option2")%>', '<%=clientWbo.getAttribute("option1")%>', '<%=clientWbo.getAttribute("id")%>');">
                                            <b style="color: red;"><%=clientWbo.getAttribute("option2")%></b><b style="color: blue;">/<%=sdf.format(tempCreationTime)%></b>
                                        </a>
                                        <a href="JavaScript: openAppointments('<%=clientWbo.getAttribute("option2")%>', '<%=clientWbo.getAttribute("option1")%>', '<%=clientWbo.getAttribute("id")%>');">
                                            <img src="images/icons/progress.png" style="height: 25px; float: left;"/>
                                        </a>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b><%=clientWbo.getAttribute("option1")%></b>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b><%=((String) clientWbo.getAttribute("creationTime")).replaceAll("-", "/").substring(0, 16)%></b>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <%=statusMap.containsKey((String) clientWbo.getAttribute("scheduleStatus")) ? statusMap.get((String) clientWbo.getAttribute("scheduleStatus")) : ""%>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>
