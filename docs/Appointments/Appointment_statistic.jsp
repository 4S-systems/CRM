<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String fromDate = (String) request.getAttribute("fromDate");
        String toDate = (String) request.getAttribute("toDate");

        WebBusinessObject data = (WebBusinessObject) request.getAttribute("data");
        ArrayList<WebBusinessObject> dataTotal = (ArrayList<WebBusinessObject>) request.getAttribute("dataTotal");
        String jsonText = (String) request.getAttribute("jsonText");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
        } else {
            align = "center";
            dir = "RTL";
        }
        
        String rprtType = request.getAttribute("rprtType") != null ? (String) request.getAttribute("rprtType") : "" ;
        String userId = (String) request.getAttribute("userID");
    %>

    <head>
        <title>Call Center Statistics</title>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    buttonImageOnly: true,
                    buttonText: "Select date"
                });
            });

            function getResults() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                var appointmentType = $("#appointmentType").val();
                
                var rprtType = "<%=rprtType%>";
                if(rprtType != null && rprtType == "myReport"){
                  document.stat_form.action = "<%=context%>/AppointmentServlet?op=myViewAppointmentStat&beginDate=" + beginDate + "&endDate=" + endDate + "&appointmentType=" + appointmentType + "&userId=" + <%=userId%>;
                } else {
                  document.stat_form.action = "<%=context%>/AppointmentServlet?op=ViewAppointmentStat&beginDate=" + beginDate + "&endDate=" + endDate + "&appointmentType=" + appointmentType + "&userId=" + <%=userId%>;
                }
               document.stat_form.submit();
            }
        </script>
    </head>
    <body>
        <input type="hidden" id="userID" name="userID" value="<%=userId%>">
        <FORM NAME="stat_form" METHOD="POST">  
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="50%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                <TR>
                    <TD STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            عرض خلال 
                        </DIV>
                    </TD>
                    <TD STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        من تاريخ :
                    </TD>
                    <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="beginDate" name="beginDate" type="text" value="<%=fromDate%>" style="margin: 5px;" />
                    </TD>
                    <TD STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        الى تاريخ :
                    </TD>
                    <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="endDate" name="endDate" type="text" value="<%=toDate%>" style="margin: 5px;" />
                    </TD>
                    <TD STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        نوع المقابلة :
                    </TD>
                    <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <select id="appointmentType" name="appointmentType" style="font-size: 14px; width: 100px;">
                            <option value="1">حالية</option>
                            <option value="2">مستقبلية</option>
                        </select>
                    </TD>
                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                    </TD>
                </tr>
            </table>

            <br><br>

            <%if (data != null) {%>
            <TABLE ALIGN="center" dir="left" WIDTH="80%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                <tr>
                    <td style="width:60%">
                        <div id="container" style="width: 80%; height: 400px; margin: 0 auto"></div>
                        <script language="JavaScript">
                            $(document).ready(function () {
                                chart = new Highcharts.Chart({
                                    chart: {
                                        renderTo: 'container',
                                        plotBackgroundColor: null,
                                        plotBorderWidth: null,
                                        plotShadow: false
                                    },
                                    title: {
                                        text: 'Appointment Statistics'
                                    },
                                    xAxis: {
                                        categories: ['Appointment Status']
                                    },
                                    labels: {
                                        items: [{
                                                style: {
                                                    left: '0px',
                                                    top: '0px',
                                                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
                                                }}]
                                    },
                                    series: <%=jsonText%>
                                });
                            });
                        </script>
                    </td>

                    <td style="width:40%">
                        <TABLE ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="95%">
                            <TR  bgcolor="#C8D8F8">
                                <TD style="width:25%">
                                    الحالة
                                </TD>
                                <TD style="width:50%">
                                    العدد
                                </TD>                                
                                <TD style="width:25%">
                                    العدد الكلي
                                </TD>
                            </TR>

                            <%WebBusinessObject temp = (WebBusinessObject) dataTotal.get(0);%>
                            <TR>
                                <TD style="width: 25%">
                                     المقابلات الفعلية 
                                </TD>
                                <TD style="width: 50%">
                                    <%=temp.getAttribute("Sccuess")%>
                                </TD>
                                <TD style="width: 25%">
                                    <a href="<%=context%>/AppointmentServlet?op=showAppointmentStatResult&type=26&beginDate=<%=fromDate%>&endDate=<%=toDate%>&total=<%=temp.getAttribute("Sccuess")%>&rprtType=<%=rprtType%>&userID=<%=userId%>"><%=temp.getAttribute("Sccuess")%></a>
                                </TD>
                            </TR>

                            <TR>
                                <TD rowspan="2">
                                     المقابلات المخططة 
                                </TD>
                                <TD>
                                    <TABLE ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="100%">
                                        <tr>
                                            <td>
                                                متابعة 
                                            </td>
                                            <td><a href="<%=context%>/AppointmentServlet?op=showAppointmentStatResult&type=24&beginDate=<%=fromDate%>&endDate=<%=toDate%>&total=<%=data.getAttribute("cared")%>&rprtType=<%=rprtType%>&userID=<%=userId%>"><%=data.getAttribute("cared")%></a></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                 مهملة 
                                            </td>
                                            <td><a href="<%=context%>/AppointmentServlet?op=showAppointmentStatResult&type=23,25,27&beginDate=<%=fromDate%>&endDate=<%=toDate%>&total=<%=data.getAttribute("notCared")%>&rprtType=<%=rprtType%>&userID=<%=userId%>"><%=data.getAttribute("notCared")%></a></td>
                                        </tr>
                                    </table>
                                </TD>
                                <TD TD rowspan="2">
                                    <a href="<%=context%>/AppointmentServlet?op=showAppointmentStatResult&type=23,24,25,27&beginDate=<%=fromDate%>&endDate=<%=toDate%>&total=<%=temp.getAttribute("Fail")%>&rprtType=<%=rprtType%>&userID=<%=userId%>"><%=Integer.parseInt(data.getAttribute("cared").toString()) + Integer.parseInt(data.getAttribute("notCared").toString())%></a>
                                </TD>
                            </TR> 
                        </TABLE>
                    </td>
                </tr>
            </table>
            <%}%>
        </form>
    </body>
</html>