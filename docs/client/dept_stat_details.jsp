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
        String stat = (String) request.getSession().getAttribute("currentMode");

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowDate = sdf.format(cal.getTime());

        String deptsJson = (String) request.getAttribute("deptsJson");

        String align = null, xAlign;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
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
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>

        <script type="text/javascript" language="javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            $(document).ready(function () {
                var data = <%=deptsJson%>;
                console.log(" data = " + data);
                var table = $('#clients').DataTable({
                    columns: [
                        {
                            title: 'الادارة',
                            name: 'project_name',
                        },
                        {
                            title: 'اسم الموظف',
                            name: 'full_name',
                        },
                        {
                            title: 'عدد المكالمات',
                            name: 'call',
                        }
                        ,
                        {
                            title: 'وقت المكالمات',
                            name: 'call_duration'
                        },
                        {
                            title: 'عدد المقابلات',
                            name: 'meeting',
                        }
                        ,
                        {
                            title: 'وقت المقابلات',
                            name: 'meeting_duration',
                        }
                    ],
                    data: data,
                    rowsGroup: [
                        'project_name:name'
                    ],
                    "columnDefs": [
                        {"width": "30%", "targets": 0},
                        {"width": "30%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0}
                    ],
                    pageLength: '20'
                });
            });

            function getResults() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();

                document.CLIENTS_FORM.action = "<%=context%>/AppointmentServlet?op=ViewDeptStatDetails&beginDate=" + beginDate + "&endDate=" + endDate;
                document.CLIENTS_FORM.submit();
            }
        </script>
        <style type="text/css">
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
    </HEAD>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <form name="CLIENTS_FORM" action="" method="POST">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="50%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                    <TR>
                        <TD  STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <DIV> 
                                عرض خلال 
                            </DIV>
                        </TD>
                        <TD  STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            من تاريخ :
                        </TD>
                        <TD  STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="beginDate" name="beginDate" type="text" value="<%=nowDate%>" style="margin: 5px;" />
                        </TD>
                        <TD  STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            الى تاريخ :
                        </TD>
                        <TD  STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="endDate" name="endDate" type="text" value="<%=nowDate%>" style="margin: 5px;" />
                        </TD>

                        <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </TD>
                    </tr>
                </table>

                <br/>

                <div id="result" style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE WIDTH="100%" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" id="clients">                    
                    </table>
                </div>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>



