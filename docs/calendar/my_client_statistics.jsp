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
        CampaignMgr campMgr = CampaignMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> campaigns = (ArrayList<WebBusinessObject>) request.getAttribute("campaigns");
        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");

        String departmentID = (String) request.getAttribute("departmentID");
        String campaignID = (String) request.getAttribute("campaignID");
        String userID = (String) request.getAttribute("userID");

        String answered = "";
        String notAnswered = "";
        String campaignName = "";

        if (data != null && data.size() > 0) {
            WebBusinessObject wbo = (WebBusinessObject) data.get(0);
            if (wbo != null) {
                answered = wbo.getAttribute("Answered") + "";
                notAnswered = wbo.getAttribute("Not_Answered") + "";

                if (campaignID.equals("0")) {
                    campaignName = "كل الحملات";
                } else {
                    WebBusinessObject campaignWbo = campMgr.getOnSingleKey(campaignID);
                    campaignName = (String) campaignWbo.getAttribute("campaignTitle");
                }
            }
        }

        String bDate = (String) request.getAttribute("beginDate");
        String eDate = (String) request.getAttribute("endDate");

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowDate = sdf.format(cal.getTime());

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
        } else {
            align = "center";
            dir = "RTL";
        }
        
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        
        String projectID = "";
        if (request.getAttribute("projectID") != null) {
            projectID = (String) request.getAttribute("projectID");
        }
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
        </script>

        <script language="javascript" type="text/javascript">
            function getResults() {
                var campaignId = $("#campaignId").val();
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                document.stat_form.action = "<%=context%>/AppointmentServlet?op=viewMyClientStatistics&campaignId=" + campaignId + "&beginDate=" + beginDate + "&endDate=" + endDate;
                document.stat_form.submit();
            }

            function popupShowAppointment(value)
            {
                var deptID = <%=departmentID%>
                var campID = <%=campaignID%>;
                var beginDate = '2017/06/01'
                var endDate = '2017/06/08'

                divID = "show_appointment";
                var url = "<%=context%>/AppointmentServlet?op=showStatResultDetails&type=" + value + "&beginDate=" + beginDate + "&endDate=" + endDate + "&departmentID=" + deptID + "&campaignID=" + campID;
                $('#show_appointment').load(url);
                $('#overlay').show();
                $('#show_appointment').css("display", "block");
                $('#show_appointment').bPopup();
            }
            
            function getProjects(obj) {
                $.ajax({
                    type: "post",
                    url: '<%=context%>/CampaignServlet?op=getProjectsAjax',
                    data: {
                        campaignID: $(obj).val()
                    }, success: function (dataStr) {
                        var result = $.parseJSON(dataStr);
                        var options = [];
                        options.push("<option value=''>", "الكل", "</option>");
                        try {
                            $.each(result, function () {
                                if (this.projectName) {
                                    options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                                }
                            });
                        } catch (err) {
                        }
                        $("#projectID").html(options.join(''));
                    }
                });
            }
        </script>
    </head>
    <body>
        <FORM NAME="stat_form" METHOD="POST">  
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
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
                        <input id="beginDate" name="beginDate" type="text" value="<%=bDate != null ? bDate : nowDate%>" style="margin: 5px;" readonly />
                    </TD>
                    <TD STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        الى تاريخ :
                    </TD>
                    <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="endDate" name="endDate" type="text" value="<%=eDate != null ? eDate : nowDate%>" style="margin: 5px;" readonly />
                    </TD>
                    <TD STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        الحملة :
                    </TD>
                    <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <select id="campaignId" name="campaignId" style="font-size: 14px; width: 100%;" onchange="JavaScript: getProjects(this);">
                            <option value="0"> كل الحملات </option>
                            <sw:WBOOptionList wboList="<%=campaigns%>" displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>" />                         
                        </select>
                    </TD>
                    
                    <TD STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        المشروع :
                    </TD>
                    <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <select style="font-size: 14px; width: 100%;" id="projectID" name="projectID" >
                            <option value="">الكل</option>
                            <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                        </select>
                    </td>

                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                    </TD>
                </tr>
            </table>

            <br><br>

            <%if (data != null && data.size() > 0) {%>
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
                                        text: 'Call Center Statistics'
                                    },
                                    xAxis: {
                                        categories: ['Call Status']
                                    },
                                    labels: {
                                        items: [{
                                                style: {
                                                    left: '0px',
                                                    top: '0px',
                                                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
                                                }}]
                                    },
                                    series: [{type: 'column',
                                            name: 'Answered',
                                            data: [<%=answered%>]
                                        }, {type: 'column',
                                            name: 'Not Answered',
                                            data: [<%=notAnswered%>]
                                        }
                                    ]
                                });
                            });
                        </script>
                    </td>

                    <td style="width:40%">
                        الحملة: <font color="red"><%=campaignName%></font>

                        <br><br>

                        <TABLE ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="90%">
                            <TR  bgcolor="#C8D8F8">
                                <TD colspan="2">
                                    عدد العملاء
                                </TD>
                            </TR>
                            <TR  bgcolor="#C8D8F8">
                                <TD style="width:50%">
                                    Answered
                                </TD>
                                <TD style="width:50%">
                                    Not Answered
                                </TD>
                            </TR>
                            <%
                                WebBusinessObject wbo = (WebBusinessObject) data.get(0);
                            %>
                            <TR>
                                <TD>
                                    <%if (wbo.getAttribute("Answered").equals("0")) {%>
                                    <%=wbo.getAttribute("Answered")%>
                                    <%} else {%>
                                    <a target="blank" href="<%=context%>/AppointmentServlet?op=showStatResultDetails&type=Answered&beginDate=<%=bDate%>&endDate=<%=eDate%>&departmentID=<%=departmentID%>&campaignID=<%=campaignID%>&userID=<%=userID%>&projectID=<%=projectID%>"><%=wbo.getAttribute("Answered")%></a>
                                    <%}%>                                   
                                </TD>
                                <TD>
                                    <%if (wbo.getAttribute("Not_Answered").equals("0")) {%>
                                    <%=wbo.getAttribute("Not_Answered")%>                               
                                    <%} else {%>
                                    <a target="blank" href="<%=context%>/AppointmentServlet?op=showStatResultDetails&type=Not_Answered&beginDate=<%=bDate%>&endDate=<%=eDate%>&departmentID=<%=departmentID%>&campaignID=<%=campaignID%>&userID=<%=userID%>&projectID=<%=projectID%>"><%=wbo.getAttribute("Not_Answered")%></a>
                                    <%}%> 
                                </TD>
                            </TR>            
                        </TABLE>
                    </td>
                </tr>
            </table>
            <%}%>
        </form>
        <script>
            getProjects($("#campaignId"));
        </script>
    </body>
</html>