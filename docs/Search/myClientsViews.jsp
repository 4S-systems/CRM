<%-- 
    Document   : myClientsViews
    Created on : Aug 14, 2018, 9:54:18 AM
    Author     : walid
--%>

<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
		
        ArrayList<WebBusinessObject> clntsViewsLst = (ArrayList<WebBusinessObject>) request.getAttribute("clntsViewsLst");
        String fromDateVal = (String) request.getAttribute("beDate");
        String toDateVal = (String) request.getAttribute("enDate");
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, title, unit, fromDate, toDate, search, client,
                project, area, price, CT, mobile, mail;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "My Clients Views";
            unit = "Unit";
            fromDate = "From Date";
            toDate = "To Date";
            search = "Search";
            client = "Client";
            project = "Project";
            area = "Area";
            price = "Price";
            CT = "Creation Time";
            mobile = "Mobile";
            mail = "Email";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "معاينات عملائى";
            unit = "الوحدة";
            fromDate = "من تاريخ";
            toDate = "إلى تاريخ";
            search = "بحث";
            client = "العميل";
            project = "المشروع";
            area = "المساحة";
            price = "السعر";
            CT = "تاريخ التسجيل";
            mobile = "رقم الموبايل";
            mail = "الإيميل";
        }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                oTable = $('#views').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 0,
                            "visible": false
                        }, {
                            "targets": [1, 2, 3, 4, 5],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(0, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
				    '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="1"><%=unit%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="4">'
				    + group + '</td></tr>'
				);
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
                 $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
            });
        </script>
        <style>  
            .canceled {
                background-color: #ffa722;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .confirmed {
                background-color: #e1efbb;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .onhold {
                background-color: #369bd7;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }

            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            #products
            {
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }
            #products tr
            {
                padding: 5px;
            }
            #products td
            {  
                font-size: 12px;
                font-weight: bold;
            }
            #products select
            {                
                font-size: 12px;
                font-weight: bold;
            }

        </style>
    </head>
    <body>
        <FORM NAME="VIEWS_LIST_FORM" METHOD="POST" action="<%=context%>/SearchServlet?op=myClientsViews">
            <FIELDSET class="set" style="width:98%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block; margin-left: auto; margin-right: auto;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=fromDate%></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=toDate%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle" colspan="2">
                            <button type="submit" class="button"><%=search%><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                </table>
                <br/>
                <div style="width:99%;margin-right: auto;margin-left: auto;">
                    <TABLE ALIGN="center" dir="<%=dir%>" id="views" style="width:100%;">
                        <thead>
                            <TR>
                                <Th>
                                    <B><%=unit%></B>
                                </Th>
                                <Th>
                                    <B><%=client%></B>
                                </Th>
                                
                                <Th>
                                    <B><%=mobile%></B>
                                </Th>
                                <th>
                                    <B>
                                        <%=mail%>
                                    </B>
                                </th>
                                <Th>
                                    <B><%=project%></B>
                                </Th>
                                <th>
                                    <B>
                                        <%=CT%>
                                    </B>
                                </th>
                            </TR>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject wbo : clntsViewsLst) {
                            %>
                            <TR>
                                <TD>
                                    <b><%=wbo.getAttribute("unit")%></b>
                                </TD>
                                <TD>
                                    <B><%=wbo.getAttribute("clientName")%></B>
                                </TD>
                                <td>
                                    <B><%=wbo.getAttribute("mobile")%></B>
                                </td>
                                <TD>
                                    <B><%=wbo.getAttribute("mail") != null ? wbo.getAttribute("mail") : ""%></B>
                                </TD>
                                <td>
                                    <B><%=wbo.getAttribute("project")%></B>
                                </td>
                                <td>
                                    <B><%=wbo.getAttribute("creationTime").toString().split(" ")[0]%></B>
                                </td>
                            </TR>
                            <% }%>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
            </fieldset>
        </form>
    </body>
</html>
