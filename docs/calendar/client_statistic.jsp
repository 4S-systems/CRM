<%@page import="java.text.DecimalFormat"%>
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

        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        ArrayList<WebBusinessObject> campaigns = (ArrayList<WebBusinessObject>) request.getAttribute("campaigns");
        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        String ratingCategories = (String) request.getAttribute("ratingCategories");

        String departmentID = (String) request.getAttribute("departmentID");
        String campaignID = (String) request.getAttribute("campaignID");
        String bDate = (String) request.getAttribute("beginDate");
        String eDate = (String) request.getAttribute("endDate");

        String jsonText = (String) request.getAttribute("jsonText");

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowDate = sdf.format(cal.getTime());
        DecimalFormat df = new DecimalFormat("0.00");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, title;
        String dir = null;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            title = "Call Center Statistics";
        } else {
            align = "center";
            dir = "RTL";
            title = "تحليل نسب مكالمات العملاء";
        }

        ArrayList<WebBusinessObject> projectsList = request.getAttribute("projectsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("projectsList") : null;

        String projectID = "";
        if (request.getAttribute("projectID") != null) {
            projectID = (String) request.getAttribute("projectID");
        }
    %>

    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" href="jquery-multiSelect/jquery.multiselect.css"/>

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
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    buttonImageOnly: true,
                    buttonText: "Select date"
                });
                $('#employees').dataTable({
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

        <script language="javascript" type="text/javascript">
            function getResults() {
                var depratmentID = $("#departmentID").val();
                var campaignId = $("#campaignId").val();
                var projectID = $("#projectID").val();
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if(!campaignId) {
                    campaignId = "";
                }
                document.stat_form.action = "<%=context%>/AppointmentServlet?op=getClientStatistics&depratmentID=" + depratmentID + "&campaignId=" + campaignId + "&beginDate=" + beginDate + "&endDate=" + endDate + "&projectID" + projectID;
                document.stat_form.submit();
            }
        </script>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 98%">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="#005599" size="4"> <%=title%> </font>
                    </td>
                </tr>
            </table>
            <br/>
            <form name="stat_form" method="post">  
                <table align="<%=align%>" dir="<%=dir%>" width="98%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4;">
                    <tr>
                        <td style="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <div> 
                                عرض خلال 
                            </div>
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            من تاريخ :
                        </td>
                        <td style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <input id="beginDate" name="beginDate" type="text" value="<%=bDate != null ? bDate : nowDate%>" style="margin: 5px; width: 100px;" />
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            الى تاريخ :
                        </td>
                        <td style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <input id="endDate" name="endDate" type="text" value="<%=eDate != null ? eDate : nowDate%>" style="margin: 5px; width: 100px;" />
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            الأدارة :
                        </td>
                        <td style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <select id="departmentID" name="departmentID" style="font-size: 14px; width: 100px">
                                <%if (departments != null && !departments.isEmpty()) {%>
                                <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                <%} else {%>
                                <option>لا توجد اداره</option>
                                <%}%>
                            </select>
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            الحملة :
                        </td>
                        <td style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <select id="campaignId" name="campaignId" style="font-size: 14px; width: 100%" multiple="multiple" class="chosen-select-campaign">
                                <%
                                    for (WebBusinessObject campaignWbo : campaigns) {
                                %>
                                <option value="<%=campaignWbo.getAttribute("id")%>" <%=campaignID != null && campaignID.contains((String) campaignWbo.getAttribute("id")) ? "selected" : ""%>><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            المشروع :
                        </td>
                        <td style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <select style="font-size: 14px; width: 100%;" id="projectID" name="projectID" >
                                <option value="">الكل</option>
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </td>
                    </tr>
                </table>
                <br/><br/>
                <%
                    if (data != null && data.size() > 0) {
                %>
                <div id="container" style="height: 300px; width: 70%; margin-left: auto; margin-right: auto;"></div>
                <script language="JavaScript">
                    var chart;
                    $(document).ready(function () {
                        chart = new Highcharts.Chart({
                            chart: {
                                renderTo: 'container',
                                type: 'column'
                            },
                            title: {
                                text: 'مكالمات العملاء'
                            },
                            xAxis: {
                                categories: ["Answering Clients","Not Answering Clients"]
                            },
                            yAxis: {
                                min: 0,
                                title: {
                                    text: 'عدد العملاء'
                                }
                            },
                            tooltip: {
                                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                        '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                                footerFormat: '</table>',
                                shared: true,
                                useHTML: true
                            },
                            plotOptions: {
                                column: {
                                    pointPadding: 0.2,
                                    borderWidth: 0
                                }
                            },
                            series: <%=jsonText%>
                        });
                    });
                </script>
                <br/>
                <br/>
                <div style="width: 70%;margin-right: auto;margin-left: auto;">
                    <table align="<%=align%>" dir="<%=dir%>" width="100%" id="employees" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">اسم الموظف</th>
                                <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Answered</th>
                                <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Not Answered</th>
                                <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Total Calls</th>
                                <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Answered Calls Presentage</th>
                            </tr>
                        <thead>
                        <tbody >  
                            <%
                                for (WebBusinessObject wbo : data) {
                            %>
                            <tr>
                                <td>
                                    <b><%=wbo.getAttribute("userName")%></b>
                                </td>
                                <td>
                                    <b><a target="blank" href="<%=context%>/AppointmentServlet?op=showStatResultDetails&type=Answered&beginDate=<%=bDate%>&endDate=<%=eDate%>&departmentID=null&campaignID=<%=campaignID != null && !campaignID.isEmpty() ? campaignID : "0"%>&userID=<%=wbo.getAttribute("userID")%>&projectID=<%=projectID%>"><%=wbo.getAttribute("answered")%></a></b>
                                </td>
                                <td>
                                    <b><a target="blank" href="<%=context%>/AppointmentServlet?op=showStatResultDetails&type=Not_Answered&beginDate=<%=bDate%>&endDate=<%=eDate%>&departmentID=null&campaignID=<%=campaignID != null && !campaignID.isEmpty() ? campaignID : "0"%>&userID=<%=wbo.getAttribute("userID")%>&projectID=<%=projectID%>"><%=wbo.getAttribute("notAnswered")%></a></b>
                                </td>
                                <td>
                                    <b><%= new Integer(wbo.getAttribute("notAnswered").toString()) + new Integer(wbo.getAttribute("answered").toString()) %></b>
                                </td>
                                <td>
                                    <b><%= df.format(Double.parseDouble(wbo.getAttribute("answered").toString()) / (Double.parseDouble(wbo.getAttribute("notAnswered").toString()) + Double.parseDouble(wbo.getAttribute("answered").toString())) * 100) %> %</b>
                                </td>
                                
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <%
                    }
                %>
            </form>    
            <script>
                var config = {
                    '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
                };
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
            </script>
        </fieldset>
    </body>
</html>