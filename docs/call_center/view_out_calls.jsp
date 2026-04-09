<%@page import="java.text.DateFormat"%>
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
        String[] callsAttributes = {"name", "mobile", "callDate", "userName"};
        String[] callsListTitles = new String[5];
        int s = callsAttributes.length;
        int t = s + 1;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> callsList = (ArrayList<WebBusinessObject>) request.getAttribute("callsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String callsNo, title, sat, sun, mon, tue, wed, thu, fri, today;
        String sDate, sTime = null;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            callsListTitles[0] = "#";
            callsListTitles[1] = "Client";
            callsListTitles[2] = "Mobile";
            callsListTitles[3] = "Date";
            callsListTitles[4] = "Employee";
            callsNo = "Calls No.";
            title = "Out Calls";
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            today = "Today";
        } else {
            align = "center";
            dir = "RTL";
            callsListTitles[0] = "#";
            callsListTitles[1] = "العميل";
            callsListTitles[2] = "الموبايل";
            callsListTitles[3] = "التاريخ";
            callsListTitles[4] = "الموظف";
            callsNo = "عدد المكالمات";
            title = "المكالمات الصادرة";
            sat = "السبت";
            sun = "اﻷحد";
            mon = "اﻷثنين";
            tue = "الثلاثاء";
            wed = "اﻷربعاء";
            thu = "الخميس";
            fri = "الجمعة";
            today = "اليوم";
        }
    %>
    <HEAD>
        <TITLE>Buildings List</TITLE>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
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
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#apartments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
        </script>
        <style type="text/css">
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
            }
            .remove__{
                width:20px;
                height:20px;
                background-image:url(images/icons/remove1.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
            }
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: #ffffff;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #cc0000;
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .login-input {
                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #000;
                font-size: 13px;
                cursor: auto;
                text-shadow: 0 1px black;
                background: #2b3e5d;
                border: 1px solid #ffffff;
                border-top-color: #0d1827;
                border-radius: 4px;
                background: rgb(249,252,247); /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
        </style>
    </HEAD>
    <body>
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
            <br/>
            <center> <b> <font size="3" color="red"> <%=callsNo%> : <%=callsList.size()%> </font></b></center> 
            <br/>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="apartments" style="width:100%;">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>                
                            <th>
                                <B><%=callsListTitles[i]%></B>
                            </th>
                            <%
                                }
                            %>
                            <th>
                                &nbsp;
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int counter = 1;
                            for (WebBusinessObject callWbo : callsList) {
                        %>
                        <tr>
                            <td>
                                <%=counter%>
                            </td>
                            <%
                                for (int i = 0; i < s; i++) {
                                    attName = callsAttributes[i];
                                    attValue = (String) callWbo.getAttribute(attName);
                                    if (i == 2) {
                                        Calendar c = Calendar.getInstance();
                                        DateFormat formatter;
                                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                                        String[] arrDate = attValue.split(" ");
                                        Date date = new Date();
                                        sDate = arrDate[0];
                                        sTime = arrDate[1];
                                        String[] arrTime = sTime.split(":");
                                        sTime = arrTime[0] + ":" + arrTime[1];
                                        sDate = sDate.replace("-", "/");
                                        arrDate = sDate.split("/");
                                        sDate = arrDate[0] + "/" + arrDate[1] + "/" + arrDate[2];
                                        c.setTime((Date) formatter.parse(sDate));
                                        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                                        String currentDate = formatter.format(date);
                                        String sDay = null;
                                        if (dayOfWeek == 7) {
                                            sDay = sat;
                                        } else if (dayOfWeek == 1) {
                                            sDay = sun;
                                        } else if (dayOfWeek == 2) {
                                            sDay = mon;
                                        } else if (dayOfWeek == 3) {
                                            sDay = tue;
                                        } else if (dayOfWeek == 4) {
                                            sDay = wed;
                                        } else if (dayOfWeek == 5) {
                                            sDay = thu;
                                        } else if (dayOfWeek == 6) {
                                            sDay = fri;
                                        }
                                        if (currentDate.equals(sDate)) {
                                            attValue = "<font color='red'>" + today + " - </font><b>" + sTime + "</b>";
                                        } else {
                                            attValue = "<font color='red'>" + sDay + " - </font><b>" + sDate + " " + sTime + "</b>";
                                        }
                                    }
                            %>

                            <td>
                                <div>
                                    <b><%=attValue%></b>
                                </div>
                            </td>
                            <%
                                }
                            %>
                            <td>
                                <a href="<%=context%>/CallCenterServlet?op=playFile&fileName=<%=callWbo.getAttribute("fileName")%>&mobile=<%=callWbo.getAttribute("mobile")%>"><img src="images/call_center/play_sound.jpg" style="height: 25px;"/></a>
                            </td>
                        </tr>
                        <%
                                counter++;
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <br/><br/>
        </fieldset>
    </body>
</html>
