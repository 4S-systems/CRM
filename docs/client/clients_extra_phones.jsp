<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");

        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String align, xAlign, code, name, mobile, dir, title;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            code = "Client Code";
            name = "Name";
            mobile = "Mobile";
            title = "Clients with Extra Phone No.";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            code = "كود العميل";
            name = "الاسم";
            mobile = "رقم الموبايل";
            title = "عملاء مع هواتف إضافية";
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>

        <script type="text/javascript" language="javascript">
            var oTable;
            $(document).ready(function () {
                $("#clients").css("display", "none");
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
    </head>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="#005599" size="4">
                        <%=title%>
                        </font>
                    </td>
                </tr>
            </table>
            <br/>
            <br/>
            <form name="CLIENTS_FORM" action="" method="POST">
                <div style="width: 80%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
                    <table align="center" dir="<%=dir%>" width="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=code%></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=name%></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=mobile%></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject wbo : clientsList) {
                            %>
                            <tr style="cursor: pointer;" id="row">
                                <td>
                                    <a target="details" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                        <%=wbo.getAttribute("clientNO")%>
                                    </a>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("name")%>
                                    <a target="details" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" />
                                    </a>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("mobile") != null ? wbo.getAttribute("mobile") : ""%>
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