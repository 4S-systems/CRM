<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, title, clientNo, clientName, mobileNo, interPhoneNo, owner, source, noneDistributed;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            title = "Clients with Invalid Mobile No.";
            clientNo = "Client No.";
            clientName = "Client Name";
            mobileNo = "Mobile";
            interPhoneNo = "Inter. Phone No.";
            owner = "Owner";
            source = "Source";
            noneDistributed = "None Distributed";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            title = "عملاء بأرقام محمول غير صحيحة";
            clientNo = "رقم العميل";
            clientName = "اسم العميل";
            mobileNo = "المحمول";
            interPhoneNo = "الرقم الدولى";
            owner = "المسؤول";
            source = "المصدر";
            noneDistributed = "غير موزع";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="js/rateit/rateit.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <script type="text/javascript" language="javascript">
            $(document).ready(function () {
                $("#clients").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[4, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 4,
                            "visible": false
                        }, {
                            "targets": [0, 1, 2, 3, 5],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(4, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="2"><%=owner%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="2">'
                                        + group + '</td><td class="blueBorder blueBodyTD" colspan="1"></td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });
            
            function informOwner(clientID, userID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=informUserAjax",
                    data: {
                        userID: userID,
                        clientId: clientID,
                        type: '0',
                        businessObjectType: '1',
                        comment: 'Mobile number for this client is invalid, Please review.'
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("Inform successfully sent.");
                        } else {
                            alert("Fail to send.");
                        }
                    }, error: function (jsonString) {
                        alert(jsonString);
                    }
                });
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
    </head>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <form name="CLIENTS_FORM" action="" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <div style="width: 99%; margin-left: auto; margin-right: auto;">
                    <table class="display" id="clients" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><%=clientNo%></th>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b><%=clientName%></b></th>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b><%=mobileNo%></b></th>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b><%=interPhoneNo%></b></th>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b><%=owner%></b></th>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b><%=source%></b></th>
                            </tr>
                        </thead> 
                        <tbody>
                            <%
                                String mobile, interPhone;
                                for (WebBusinessObject wbo : clientsList) {
                                    mobile = (wbo.getAttribute("mobile") != null && !wbo.getAttribute("mobile").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("mobile") : "";
                                    interPhone = (wbo.getAttribute("interPhone") != null && !wbo.getAttribute("interPhone").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("interPhone") : "";
                            %>
                            <tr id="row">
                                <td><b><%=wbo.getAttribute("clientNO")%></b></td>
                                <td><b><%=wbo.getAttribute("name")%></b>
                                    <a target="blank" style="float: <%=xAlign%>;" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>"><img style="width: 30px;" src="images/client_details.jpg"/></a>
                                </td>
                                <td><b><%=mobile%></b>
                                    <a target="blank" style="float: <%=xAlign%>;" href="JavaScript: informOwner('<%=wbo.getAttribute("id")%>', '<%=wbo.getAttribute("currentOwnerID") == null ? wbo.getAttribute("createdBy") : wbo.getAttribute("currentOwnerID")%>');"><img style="width: 25px;" src="images/icons/inform.png" title="Inform <%=wbo.getAttribute("currentOwnerID") == null ? "Source" : "Owner"%>"/></a>
                                </td>
                                <td><b><%=interPhone%></b></td>
                                <td><b><%=wbo.getAttribute("currentOwnerName") != null ? wbo.getAttribute("currentOwnerName") : noneDistributed%></b></td>
                                <td><b><%=wbo.getAttribute("createdByName")%></b></td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>