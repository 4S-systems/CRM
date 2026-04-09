<%-- 
    Document   : ClientViewsInSpecificDay
    Created on : Aug 12, 2018, 11:58:54 AM
    Author     : walid
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        String date = (String)request.getAttribute("date");
        ArrayList<WebBusinessObject> paymentLst = (ArrayList<WebBusinessObject>) request.getAttribute("paymentLst");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String title,clientNM, unitNM, planTit, status, cT;
        if (stat.equals("En")) {
            dir = "LTR";
            align = "center";
            title = "Client Payment Plans In ";
            clientNM = "Client";
            unitNM = "Unit";
            planTit = "Plan Title";
            status  ="Status";
            cT = "Addition Time";
        } else {
            dir = "RTL";
            align = "center";
            title = "خطط دفع العميل فى تاريخ";
            clientNM = "العميل";
            unitNM = "الوحدة";
            planTit = "خطة الدفع";
            status = "الحالة";
            cT = "وقت الإضافة";
        }

    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript">
            $(document).ready(function () {
                oTable = $('#EmpRequests').dataTable({
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
        <style>
            table label {
                float: right;
            }

            td {
                border: none;
                padding-bottom: 10px;
            }
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }

            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataTD {
                background: #FFF
            }

            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
            }

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

            .titleRow {
                background-color: orange;
            }

            .detailTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color: #FCC90D;
            }

            .dataDetailTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataDetailTD {
                background: #FFF19F
            }

            tr:nth-child(odd) td.dataDetailTD {
                background: #FFF19F
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

                color: black;

                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            
            .tbFStyle{
                background: silver;
                width: auto; 
                text-align: right; 
                margin-bottom: 10px !important; 
                margin-left: 135px; 
                margin-right: auto; 
                letter-spacing: 35px;
                border-radius: 10px;
                padding-right: 20px;
            }
            
            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }
        </style>
    </head>
    <body>
        <fieldset class="set" style="width:85%;border-color: #006699">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                                <%=title%> :
                            </font>
                            <font color="red" size="4">
                                <%=date%>
                            </font>
                        </td>
                    </tr>
                </table>
                <br>
                <%
                    if (paymentLst != null) {
                %>
                <div style="width: 90%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table width="100%" id="EmpRequests" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=clientNM%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=unitNM%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=planTit%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=status%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=cT%></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (WebBusinessObject wbo : paymentLst) {
                            %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <b>
                                        <%=wbo.getAttribute("clientNm")%>
                                    </b>
                                </TD>
                                <TD>
                                    <b>
                                        <%=wbo.getAttribute("unitNm")%>
                                    </b>
                                </TD>
                                <TD>
                                    <%=wbo.getAttribute("planTitle") != null ? wbo.getAttribute("planTitle") : "---"%>
                                </TD>
                                <TD>
                                    <%=wbo.getAttribute("statusTit")%>
                                </TD>
                                <TD>
                                    <%=wbo.getAttribute("creationTime").toString().split(" ")[0]%>
                                </TD>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>            
                <br/>
        </fieldset>
    </body>
</html>
