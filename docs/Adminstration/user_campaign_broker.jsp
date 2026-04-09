<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String[] userAttributes = {"creationTime", "campaignTitle", "userName"};
            String[] userListTitles = new String[3];
            int s = userAttributes.length;
            int t = s;
            String attName = null;
            String attValue = null;
            ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
            String stat = (String) request.getSession().getAttribute("currentMode");
            String align, dir, style, title, failMsg, chkMsg, dltErrMsg;
            if (stat.equals("En")) {
                align = "center";
                dir = "LTR";
                style = "text-align:left";
                userListTitles[0] = "Date";
                userListTitles[1] = "Broker";
                userListTitles[2] = "User Name";
                title = "Management of Brokers";
                failMsg = "Fail to Save";
                chkMsg = " Choose Brokers to be ramoved";
                dltErrMsg = "Fail to Remove";
            } else {
                align = "center";
                dir = "RTL";
                style = "text-align:Right";
                userListTitles[0] = "في تاريخ";
                userListTitles[1] = "الوسيط";
                userListTitles[2] = "اسم المستخدم";
                title = "أدارة شؤون الوسطاء";
                failMsg = "لم يتم الحفظ";
                chkMsg = "إختر الوسطاء التى تريد حذفها";
                dltErrMsg = "لم يتم الحذف";
            }
        %>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        
        <script type="text/javascript" language="javascript" src="js/jquery-1.12.4.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
            jQuery.browser = {};
            (function () {
                jQuery.browser.msie = false;
                jQuery.browser.version = 0;
                if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
                    jQuery.browser.msie = true;
                    jQuery.browser.version = RegExp.$1;
                }
            })();
            var oTable;
            $(document).ready(function () {
                oTable = $('#users').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    "order": [[2, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 2,
                            "visible": false
                        }, {
                            "targets": [0, 1],
                            "orderable": false
                        }], "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(2, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111; text-align: <%=dir%>;" colspan="1"><%=userListTitles[2]%></td> <td class="" style="font-size: 16px; color: #a41111; text-align: <%=dir%>; background-color: lightgray;" colspan="1"> <b style="color: black;">' + group + ' </b> </td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });
            function popupAddUserBrokers(userID) {
                var divTag = $("#newUserBroker");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/UsersServlet?op=getUserBrokerForm',
                    data: {
                        userID: userID
                    }, success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "تحديد مدير وسطاء",
                            show: "fade",
                            hide: "explode",
                            width: 450,
                            height: 400,
                            position: {
                                my: 'center',
                                at: 'center'
                            }, buttons: {
                                Save: function () {
                                    saveUserBrokers();
                                },
                                Close: function () {
                                    $("#newUserBroker").dialog("destroy").dialog("close");
                                }
                            }
                        }).dialog('open');
                        var config = {
                            '.chosen-select-user': {no_results_text: 'No data found with this name!', width: "300px"}
                        };
                        for (var selector in config) {
                            $(selector).chosen(config[selector]);
                        }
                    }, error: function (data) {
                        alert(data);
                    }
                });

            }
            function saveUserBrokers() {
                $.ajax({
                    type: 'POST',
                    url: "<%=context%>/UsersServlet?op=saveUserBrokersAjax",
                    data: {
                        userID: $("#userID").val(),
                        brokerID: "" + $("#brokerID").val() + ""
                    }, success: function (data) {
                        var jsonString = $.parseJSON(data);
                        if (jsonString.status === 'ok') {
                            location.reload();
                        } else {
                            alert('<%=failMsg%>');
                        }
                    }
                });
            }
            function removeUserBrokers() {
                var clntCmpCkBx = [];
                $("input[name=clntCmpCkBx]:checked").each(function () {
                    clntCmpCkBx.push($(this).val());
                });

                if (clntCmpCkBx.length <= 0) {
                    alert('<%=chkMsg%>');
                } else {
                    $.ajax({
                        type: 'POST',
                        url: "<%=context%>/UsersServlet?op=removeUserBrokers",
                        data: {
                            clntCmpIDs: clntCmpCkBx.join()
                        }, success: function (data) {
                            var jsonString = $.parseJSON(data);
                            if (jsonString.status === 'ok') {
                                location.reload();
                            } else {
                                alert('<%=dltErrMsg%>');
                            }
                        }
                    });
                }
            }
        </script>
        <style>
        </style>
    </head>
    <body>
        <div id="newUserBroker" style="display: none; text-align: center;"></div>
        <a href="JavaScript: popupAddUserBrokers('');"><img src="images/icons/add.png"/></a>
        <fieldset align=center class="set" style="width: 80%;">
            <legend align="center">
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6"><%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <div style="width: 70%; margin-left: auto; margin-right: auto;">
                <table align="<%=align%>" dir="<%=dir%>" style="width: 100%;" id="users">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>
                            <th >
                                <b><%=userListTitles[i]%></b>
                            </th>
                            <%
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (WebBusinessObject wbo : usersList) {
                        %>
                        <tr>
                            <%
                                for (int i = 0; i < s; i++) {
                                    attName = userAttributes[i];
                                    attValue = wbo.getAttribute(attName) != null ? (String) wbo.getAttribute(attName) : "";
                                    if (i == 0 && attValue.length() > 10) {
                                        attValue = attValue.substring(0, 10);
                                    }
                            %>
                            <td>
                                <b> <%=attValue%> </b>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <br/><br/>
        </fieldset>
        <br/><br/>
    </body>
</html>
