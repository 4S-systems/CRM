<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();

            int iTotal = 0;
            Vector data = (Vector) request.getAttribute("data");

            String stat = "Ar";
            String align = "center";
            String dir = null;
            String style = null, lang, langCode;

            if (stat.equals("En")) {
                align = "left";
                dir = "LTR";
                style = "text-align:right";
                lang = "&#1593;&#1585;&#1576;&#1610;";
                langCode = "Ar";
            } else {
                dir = "RTL";
                align = "right";
                style = "text-align:Right";
                lang = "English";
                langCode = "En";
            }
        %>
        <TITLE>System Users List</TITLE>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

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
        </style>
    </HEAD>
    <script type="text/javascript">
        var oTable;
        var clients = new Array();
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
        

        var divAttachmentsTag;
        function openAttachmentDialog(clientId) {
            loading("block");
            divAttachmentsTag = $("div[name='divAttachmentsTag']");
            $.ajax({
                type: "post",
                url: '<%=context%>/SeasonServlet?op=getClientContracts',
                data: {
                    clientID: clientId
                },
                success: function (data) {
                    divAttachmentsTag.html(data)
                            .dialog({
                                modal: true,
                                title: "عرض  الملفات",
                                show: "fade",
                                hide: "explode",
                                width: 1000,
                                position: {
                                    my: 'center',
                                    at: 'center'
                                },
                                buttons: {
                                    Cancel: function () {
                                        divAttachmentsTag.dialog('close');
                                    },
                                    Done: function () {
                                        divAttachmentsTag.dialog('close');
                                    }
                                }
                            })
                            .dialog('open');
                },
                error: function (data) {
                    alert('Data Error = ' + data);
                }
            });
            loading("none");
        }

        function loading(val) {
            if (val === "none") {
                $('#loading').fadeOut(2000, function () {
                    $('#loading').css("display", val);
                });
            } else {
                $('#loading').fadeIn("fast", function () {
                    $('#loading').css("display", val);
                });
            }
        }
    </script>

    <body>

        <div name="divAttachmentsTag"></div>

        <div id="loading" class="container" style="display: none">
            <div class="contentBar">
                <div id="block_1" class="barlittle"></div>
                <div id="block_2" class="barlittle"></div>
                <div id="block_3" class="barlittle"></div>
                <div id="block_4" class="barlittle"></div>
                <div id="block_5" class="barlittle"></div>
            </div>
        </div>

        <div style="width: 100%;margin-left: auto;margin-right: auto;">
            <TABLE class="blueBorder" id="clients" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                <thead>
                    <TR>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%"><b>#</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>كود العميل</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><b>اسم العميل</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%"><b>رقم التليفون</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="20%"><b>البريد الاكتروني</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="20%"><b>الملفات</b></TH>
                    </TR>
                </thead>  

                <tbody  id="planetData2">
                    <%
                        if (data != null && data.size() > 0) {
                            for (int i = 0; i < data.size(); i++) {
                                iTotal++;
                                WebBusinessObject wbo = (WebBusinessObject) data.get(i);
                    %>
                    <TR style="padding: 1px;">
                        <TD>
                            <%=iTotal%>
                        </td>

                        <TD>
                            <%=wbo.getAttribute("clientNo")%>
                        </td>

                        <TD>
                            <%=wbo.getAttribute("clientName")%>
                        </td>

                        <%if (wbo.getAttribute("mobile") == null || wbo.getAttribute("mobile").toString().equals("")) {%>
                        <TD>
                            ---
                        </td>
                        <%} else {%>
                        <TD>
                            <%=wbo.getAttribute("mobile")%>
                        </td>
                        <%}%>

                        <%if (wbo.getAttribute("email") == null || wbo.getAttribute("email").toString().equals("")) {%>
                        <TD>
                            ---
                        </td>
                        <%} else {%>
                        <TD>
                            <%=wbo.getAttribute("email")%>
                        </td>
                        <%}%>

                        <TD>
                            <a href="JavaScript: openAttachmentDialog('<%=wbo.getAttribute("clientID")%>');">
                                <img style="margin: 3px" src="images/contract_icon.jpg" width="24" height="24"/>
                            </a>
                        </TD>
                    </TR>
                    <%
                            }
                        }%>
                </tbody>
            </TABLE>
        </div>
    </body>
</html>
