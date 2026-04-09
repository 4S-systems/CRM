<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html>

<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">    

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        String fromDate = (String) request.getAttribute("fromDate");
        String toDate = (String) request.getAttribute("toDate");

        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        String resultJson = (String) request.getAttribute("resultJson");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String view,Managment,FromDate,ToDate,DisplayThrough ;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            view = "View";
            Managment = "Managment";
            FromDate = "From Date";        
            ToDate ="To Date";
            DisplayThrough ="Display Through";
        } else {
            align = "center";
            dir = "RTL";
            view = "عرض";
            Managment = "الأدارة :";
            FromDate = "من تاريخ :";        
            ToDate ="الى تاريخ :";
            DisplayThrough ="عرض خلال";
        }
    %>
    <head>
        <TITLE>System Users List</TITLE>
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
        <style>
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
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
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
            .img:hover{
                cursor: pointer ;
            }

            #mydiv {
                text-align:center;
            }
        </style>

        <script type="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            $(document).ready(function () {
                var data = <%=resultJson%>;
                var table = $('#clients').DataTable({
                    columns: [
                        {
                            title: 'الموظف',
                            name: 'full_name'
                        },
                        {
                            title: 'اسم العميل',
                            name: 'Name'
                        },
                        {
                            title: 'عدد المكالمات',
                            name: 'call'
                        }
                        ,
                        {
                            title: 'وقت المكالمات',
                            name: 'call_duration'
                        },
                        {
                            title: 'عدد المقابلات',
                            name: 'meeting'
                        }
                        ,
                        {
                            title: 'وقت المقابلات',
                            name: 'meeting_duration'
                        },
                        {
                            title: '',
                            name: ''
                        }
                    ],
                    data: data,
                    rowsGroup: [
                        'full_name:name'
                    ],
                    "columnDefs": [
                        {"width": "25%", "targets": 0},
                        {"width": "25%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {
                            "width": "10%",
                            "targets": -1,
                            "data": null,
                            "defaultContent": "<a target='_blanck' id='goTo'><img src='images/client_details.jpg'/></a>"
                        }
                    ],
                    "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                        $('#goTo', nRow).attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + aData[6]);
                    }
                });
            });

            function getResults() {
                $("#Emplyee").css("display", "");
                $("#showResults").val("show");

                var depratmentID = $("#departmentID").val();
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();

                document.stat_form.action = "<%=context%>/AppointmentServlet?op=viewCallCenterStatisticsByClient&depratmentID=" + depratmentID + "&beginDate=" + beginDate + "&endDate=" + endDate;
                document.stat_form.submit();
            }
        </script>
    </head>

    <body>
        <FORM NAME="stat_form" METHOD="POST">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                <TR>
                    <TD width="8%" STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            <%=DisplayThrough%>  
                        </DIV>
                    </TD>
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                         <%=FromDate%>
                    </TD>
                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="beginDate" name="beginDate" type="text" value="<%=fromDate%>" style="margin: 5px;" />
                    </TD>
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                          <%=ToDate%>
                    </TD>
                    <TD width="15%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="endDate" name="endDate" type="text" value="<%=toDate%>" style="margin: 5px;" />
                    </TD>
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <%=Managment%>
                    </TD>
                    <TD width="23%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <select id="departmentID" name="departmentID" style="font-size: 14px; width: 100%">
                            <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                        </select>
                    </TD>
                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle"><%=view%></b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                    </TD>
                </tr>
            </table>
        </form>

        <br/>

        <%if (data != null && data.size() > 0) {%>
        <div id="result" style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
            <TABLE WIDTH="100%" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" id="clients">                    
            </table>
        </div>
        <%}%>
    </body>
</html>
