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

        String appoitmentsJson = (String) request.getAttribute("jsonData");
        String userName = (String) request.getAttribute("userName");

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
            $(document).ready(function () {
                var data = <%=appoitmentsJson%>;
                console.log( " data = " + data);
                var table = $('#clients').DataTable({
                    columns: [
                        {
                            title: 'اسم العميل',
                            name: 'clientName',
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
                        },
                        {
                            title: 'المكالمات الغير ناجحة',
                            name: 'not answred',
                        },
                        {
                            title: '',
                            name: '',
                        }
                    ],
                    data: data,
                    aLengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
                    rowsGroup: [
                        'clientName:name'
                    ],
                    "columnDefs": [
                        { "width": "40%", "targets": 0 },
                        { "width": "10%", "targets": 0 },
                        { "width": "10%", "targets": 0 },
                        { "width": "10%", "targets": 0 },
                        { "width": "10%", "targets": 0 },
                        { "width": "10%", "targets": 0 },
                        {
                            "width": "10%",
                            "targets": -1,
                            "data": null,
                            "defaultContent": "<a target='_blanck' id='goTo'><img src='images/client_details.jpg'/></a>"
                        }
                    ],
                    
                    "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                        if (aData[1] == "0" && aData[3] == "0" && aData[5] == "0"){
                            $('td', nRow).css('background-color', '#ff8566');   //red
                        } 
                        
                        $('#goTo', nRow).attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + aData[6]);
                    }
                });
            });
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
                <br/>

                <div align="left" STYLE="color:blue; margin-left: 50px;">
                    <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
                </div>

                <br/><br/>

                <b><font size="3" >اسم الموظف</font></b> : <b><font size="3" color="red"><%=userName%></font></b> 

                <br/><br/>

                <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE WIDTH="100%" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" id="clients">                    
                    </table>
                </div>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>



