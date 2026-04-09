
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> messagesList = (ArrayList<WebBusinessObject>) request.getAttribute("messagesList");

    String stat = "Ar";
    String dir = null;
    String title;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "System Messages";
    } else {
        dir = "RTL";
        title = "رسائل النظام";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <link rel="stylesheet" type="text/css" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function () {
                $("#messages").dataTable({
                    "order": [[3, "desc"]],
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true,
                    "columnDefs": [{
                            "targets": 0,
                            "orderable": false
                        }]
                }).fadeIn(2000);
            });
            function getMessageForm(id) {
                var divTag = $("#divTag");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/SessionsServlet?op=getNewMessage&id=' + id,
                    data: {
                    },
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "أضافة رسالة جديدة",
                            show: "fade",
                            hide: "explode",
                            width: 660,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                'Close and Reload': function () {
                                    location.reload();
                                },
                                Save: function () {
                                    if (id === '') {
                                        saveNewMessage();
                                    } else {
                                        updateMessage();
                                    }
                                }
                            }
                        }).dialog('open');
                    }
                });
            }
            function saveNewMessage() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/SessionsServlet?op=saveNewMessage",
                    data: $("#MESSAGE_FORM").serialize(),
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        if (data.status === 'ok') {
                            alert("تم الحفظ بنجاح");
                            getMessageForm('');
                        } else {
                            alert("لم يتم الحفظ");
                        }
                    },
                    error: function () {
                    }
                });
            }
            function updateMessage() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/SessionsServlet?op=updateMessage",
                    data: $("#MESSAGE_FORM").serialize(),
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        if (data.status === 'ok') {
                            alert("تم الحفظ بنجاح");
                        } else {
                            alert("لم يتم الحفظ");
                        }
                    },
                    error: function () {
                    }
                });
            }
            function deleteMessage(id) {
                var r = confirm("حذف الرسالة, متأكد؟");
                if (r) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/SessionsServlet?op=deleteMessage",
                        data: { id: id },
                        success: function (jsonString) {
                            var data = $.parseJSON(jsonString);
                            if (data.status === 'ok') {
                                alert("تم الحذف بنجاح");
                                location.reload();
                            } else {
                                alert("لم يتم الحذف");
                            }
                        },
                        error: function () {
                        }
                    });
                }
            }
        </script>
        <style type="text/css">
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
        </style>
    </head>
    <body>
        <div id="divTag"></div>
        <form name="MESSAGE_FORM" method="post">
            <div style="width: 97%">
                <button type="button" class="button" style="float: left; margin-left: 1.5%; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px;" onclick="JavaScript: getMessageForm('');">رسالة جديدة</button>
            </div>
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <fieldset class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <% if (messagesList != null) {%>
                            <center>
                                <div style="width: 97%">
                                    <table class="display" id="messages" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th><b>الموضوع</b></th>
                                                <th><b>الرسالة</b></th>
                                                <th><b>التاريخ</b></th>
                                                <th><b>نوع التكرار</b></th>
                                                <th><b>فترة الظهور (د)</b></th>
                                                <th><b>الحالة</b></th>
                                                <th><b>النوع</b></th>
                                                <th><b>&nbsp;</b></th>
                                                <th><b>&nbsp;</b></th>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                for (WebBusinessObject wbo : messagesList) {
                                            %>
                                            <tr id="row">
                                                <td><b><%=wbo.getAttribute("option1") != null && !"UL".equals(wbo.getAttribute("option1")) ? wbo.getAttribute("option1") : "لا يوجد"%></b></td>
                                                <td><b><%=wbo.getAttribute("message")%></b></td>
                                                <td><b><%=((String) wbo.getAttribute("onDate")).substring(0, 16)%></b></td>
                                                <td><b><%=wbo.getAttribute("frequency")%></b></td>
                                                <td><b><%=wbo.getAttribute("period")%></b></td>
                                                <td><b><%=wbo.getAttribute("status").equals("1") ? "Active" : "Inactive"%></b></td>
                                                <td><b><%=wbo.getAttribute("option2") != null && !"UL".equals(wbo.getAttribute("option2")) ? wbo.getAttribute("option2") : "---"%></b></td>
                                                <td><a href="#" onclick="JavaScript: getMessageForm('<%=wbo.getAttribute("id")%>');">تعديل</a></td>
                                                <td><a href="#" onclick="JavaScript: deleteMessage('<%=wbo.getAttribute("id")%>');">حذف</a></td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <% }%>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
