<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String beginDate = (String) request.getAttribute("beginDate");
        String endDate = (String) request.getAttribute("endDate");
        String type = (String) request.getAttribute("type");
        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, title;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            title = "Repeated Visits";
        } else {
            align = "center";
            dir = "RTL";
            title = "الزيارات المتكررة";
        }
    %>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link href="js/select2.min.css" rel="stylesheet" type="text/css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/select2.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <style>
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

            var oTable;
            $(document).ready(function () {
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
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                var type = $("#type").val();
                document.stat_form.action = "<%=context%>/AppointmentServlet?op=getRepeatedMeetingsClients&beginDate=" + beginDate + "&endDate=" + endDate + "&type=" + type;
                document.stat_form.submit();
            }
        </script>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 95%;">
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
            <form NAME="stat_form" METHOD="POST">
                <table align="<%=align%>" dir="<%=dir%>" width="50%" CELLPADDING="0" CELLSPACING="0" style="border: 2px solid #d3d5d4">
                    <TR>
                        <td width="8%" style="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <div> 
                                عرض 
                            </div>
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            من تاريخ :
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>" style="margin: 5px;" readonly />
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            إلى تاريخ :
                        </td>
                        <td width="15%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" style="margin: 5px;" readonly />
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            النوع:
                        </td>
                        <td width="15%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <select id="type" name="type" style="margin: 5px;">
                                <option value="repeated" <%="repeated".equals(type) ? "selected" : ""%>>زيارة متكررة</option>
                                <option value="first" <%="first".equals(type) ? "selected" : ""%>>أول زيارة</option>
                            </select>
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </td>
                    </tr>
                </table>
            </form>
            <br/>
            <%if (data != null) {%>
            <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showResults">
                <table align="<%=align%>" dir="<%=dir%>" width="100%" id="clients" style="">
                    <thead>
                        <tr>
                            <th style="width: 2%;">&nbsp;</th>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">اسم العميل</th>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"> تصنيف العميل </th>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"> تصنيف بواسطة</th>
                            <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">عدد الزيارات</th>
                        </tr>
                    <thead>
                    <tbody >  
                        <%
                            for (WebBusinessObject wbo : data) {
                        %>
                        <tr>
                            <td style="width: 2%;">
                                <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                    <img src="images/client_details.jpg" width="30" title="تفاصيل"/>
                                </a>
                            </td>
                            <td style="width: 20%;">
                                <%=wbo.getAttribute("name")%>
                            </td>
                            <td style="width: 10%;">
                                <%=wbo.getAttribute("rateName")%>
                            </td>
                            <td style="width: 20%;">
                                <%=wbo.getAttribute("ratedByName")%>
                            </td>
                            <td style="width: 10%;">
                                <%=wbo.getAttribute("meetingsCount")%>
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
            <br/>
        </fieldset>
    </body>
</html>