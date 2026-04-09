<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
        }
    %>
    <head>
        <script language="JavaScript" type="text/javascript">
            $(document).ready(function () {
                $('#clientCampaignList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(500);
            });
        </script>
        <style>
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
        <table id="clientCampaignList" cellpadding="4" cellspacing="2" style="border:none;" align="center" dir="<%=dir%>">
            <thead>
                <tr>
                    <th>
                        كود الحملة
                    </th>
                    <th>
                        عنوان الحملة
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (WebBusinessObject wbo : campaignsList) {
                        String campaignTitle = (String) wbo.getAttribute("option1");
                        String campaignCode = (String) wbo.getAttribute("option2");
                %>
                <tr>
                    <td>
                        <%=campaignCode%>
                    </td>
                    <td>
                        <%=campaignTitle%>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </body>
</html>