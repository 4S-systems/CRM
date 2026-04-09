<%@page import="java.math.BigDecimal"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String fromDate = (String) request.getAttribute("fromDate");
        String toDate = (String) request.getAttribute("toDate");
        String clientType = request.getAttribute("clientType") != null ? (String) request.getAttribute("clientType") : "";

        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");

        String stat = (String) request.getSession().getAttribute("currentMode");
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
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
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
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

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

            function getResults() {
                document.stat_form.submit();
            }
        </script>
    </head>

    <body>
        <fieldset class="set" style="width:95%; border-color: #006699;">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="#005599" size="4">عملائي الدوليين والمحليين</font>
                    </td>
                </tr>
            </table>
            <br/>
            <form name="stat_form" method="POST">
                <table align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                    <tr>
                        <td width="8%" style="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            عرض 
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            من تاريخ :
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="margin: 5px; width: 100px;" readonly />
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            الى تاريخ :
                        </td>
                        <td width="15%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="margin: 5px; width: 100px;" readonly />
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            نوع العميل :
                        </td>
                        <td width="15%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <select name="clientType" id="clientType" style="width: 150px;">
                                <option value="1" <%="1".equals(clientType) ? "selected" : ""%>>International</option>
                                <option value="0" <%="0".equals(clientType) ? "selected" : ""%>>Local</option>
                            </select>
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <button style="width: 100px" type="button" onclick="javascript: getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </td>
                    </tr>
                </table>
            </form>

            <br/>

            <%if (data != null) {%>
            <div style="width: 75%;margin-right: auto;margin-left: auto;" id="showResults">
                <table align="<%=align%>" dir="<%=dir%>" width="100%" id="clients">
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold; width: 10%;">رقم العميل</th>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold; width: 30%;">اسم العميل</th>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold; width: 20%;">التليفون</th>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold; width: 20%;">المحمول</th>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold; width: 20%;">الدولي</th>
                        </tr>
                    <thead>
                    <tbody >  
                        <%
                            for (WebBusinessObject wbo : data) {
                        %>
                        <tr>
                            <td style="width: 10%;">
                                <%=wbo.getAttribute("clientNO")%>
                            </td>
                            <td style="width: 45%;">
                                <%=wbo.getAttribute("name")%>
                                <a target="_blanck" style="float: <%=xAlign%>;" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                    <img src="images/client_details.jpg" width="30" title="تفاصيل"/>
                                </a>
                            </td>
                            <td style="width: 15%;">
                                <%=wbo.getAttribute("phone") != null && !"UL".equals(wbo.getAttribute("phone")) ? wbo.getAttribute("phone") : ""%>
                            </td>
                            <td style="background-color: #fed198; width: 15%;">
                                <%=wbo.getAttribute("mobile") != null && !"UL".equals(wbo.getAttribute("mobile")) ? wbo.getAttribute("mobile") : ""%>
                            </td>
                            <td style="background-color: #c5fdbe; width: 15%;">
                                <%=wbo.getAttribute("interPhone") != null && !"UL".equals(wbo.getAttribute("interPhone")) ? wbo.getAttribute("interPhone") : ""%>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <%}%>
            <br/>
        </fieldset>
    </body>
</html>