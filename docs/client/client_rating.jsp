<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"clientNO", "name", "statusName", "mobile"};
        String[] clientsListTitles = new String[4];
        int s = clientsAttributes.length;
        int t = s + 0;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client No.";
            clientsListTitles[1] = "Client Name";
            clientsListTitles[2] = "Status";
            clientsListTitles[3] = "Mobile";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "رقم العميل";
            clientsListTitles[1] = "اسم العميل";
            clientsListTitles[2] = "الحالة";
            clientsListTitles[3] = "موبايل";
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[2, "asc"]]

                }).fadeIn(2000);
            });
            function popupShowComments(id) {
                var url = "<%=context%>/CommentsServlet?op=showClientComments&clientId=" + id + "&objectType=1&random=" + (new Date()).getTime();
                jQuery('#show_comments').load(url);
                $('#show_comments').css("display", "block");
                $('#show_comments').bPopup();
            }
            function updateClientStatus(id) {
                var d = new Date();
                var statusDate = d.getUTCFullYear() + "/" + (d.getUTCMonth() + 1) + "/" + d.getUTCDate() + " " + d.getUTCHours() + ":" + d.getUTCMinutes();
                var statuses = new Array();
                statuses[0] = "12";
                statuses[1] = "13";
                statuses[2] = "14";
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=updateClientStatus",
                    data: {
                        comment: "Rating Change",
                        clientId: id,
                        statusDate: statusDate,
                        newStatusCode: statuses[($("#" + id).val() - 1)]
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status !== 'ok') {
                        }
                    }
                });

            }
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }
            function popupAddComment(obj, clientId) {
                $("#clientId").val(clientId);
                $("#commentAreaForSave").val("");
                $("#commentType").val("0")
                $("#commMsg").hide();
                $('#add_comments').css("display", "block");
                $('#add_comments').bPopup({easing: 'easeInOutSine',
                    speed: 400,
                    transition: 'slideDown'});
            }
            function saveComment(obj) {
                var clientId = $("#clientId").val();
                var type = $("#commentType").val();
                var comment = $("#commentAreaForSave").val();
                var businessObjectType = $(obj).parent().parent().parent().find($("#businessObjectType")).val();
                $(obj).parent().parent().parent().parent().find("#progress").show();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=saveComment",
                    data: {
                        clientId: clientId,
                        type: type,
                        comment: comment,
                        businessObjectType: businessObjectType
                    },
                    success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status === 'ok') {
                            $(obj).parent().parent().parent().parent().find("#commMsg").show();
                            $(obj).parent().parent().parent().parent().find("#progress").hide();
                            $('#add_comments').css("display", "none");
                            $('#add_comments').bPopup().close();
                        } else if (eqpEmpInfo.status === 'no') {
                            $(obj).parent().parent().parent().parent().find("#progress").show();
                        }
                    }
                });
            }
        </script>
        <style type="text/css">
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
                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
            }
            .remove__{
                width:20px;
                height:20px;
                background-image:url(images/icons/remove1.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
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
                color: #ffffff;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #cc0000;
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .login-input {
                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #000;
                font-size: 13px;
                cursor: auto;
                text-shadow: 0 1px black;
                background: #2b3e5d;
                border: 1px solid #ffffff;
                border-top-color: #0d1827;
                border-radius: 4px;
                background: rgb(249,252,247); /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
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
        </style>
    </HEAD>
    <body>
        <div id="show_comments"   style="width: 50% !important;display: none;position: fixed ;">
        </div>
        <div id="add_comments"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;"><!--class="popup_appointment" -->
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <%
                        if (metaMgr.getShowCommentType().equalsIgnoreCase("1")) {
                    %>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">نوع التعليق</td>
                        <td style="width: 70%;" >
                            <select style="float: right;width: 30%; font-size: 14px;" id="commentType">
                                <option value="0">عام</option>
                                <option value="1">خاص</option>
                            </select>
                            <input type="hidden" id="businessObjectType" value="1"/>
                        </td>
                    </tr>
                    <%
                    } else {
                    %>
                    <input type="hidden" id="commentType" name="commentType" value="0"/>
                    <input type="hidden" id="businessObjectType" value="1"/>
                    <%
                        }
                    %>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="commentAreaForSave" name="commentAreaForSave" > </textarea>
                            <input type="hidden" id="clientId" value="1"/>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                    <input type="button" value="حفظ"   onclick="saveComment(this)" id="saveComm"class="login-submit"/></div>                             </form>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
                    تم إضافة التعليق
                </div>
            </div>  
        </div>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Clients' Rating تقييم العملاء</b>
        <fieldset align=center class="set" style="width: 90%">
            <form name="CALLING_PLAN_FORM" action="<%=context%>/ClientServlet?op=generateCallingPlan" method="POST">
                <br/>
                <div style="width: 60%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <th>

                                </th>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th>
                                    <B><%=clientsListTitles[i]%></B>
                                </th>
                                <%
                                    }
                                %>
                                <th>

                                </th>
                                <th>

                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                String description;
                                for (WebBusinessObject clientWbo : clientsList) {
                                    attName = clientsAttributes[0];
                                    attValue = (String) clientWbo.getAttribute(attName);
                                    description = (String) clientWbo.getAttribute("description");
                            %>
                            <tr>
                                <td>
                                    <select id="<%=clientWbo.getAttribute("id")%>" name="rating">
                                        <option value="1" <%="12".equals(clientWbo.getAttribute("currentStatus")) ? "selected=\"selected\"" : ""%>>1</option>
                                        <option value="2" <%="13".equals(clientWbo.getAttribute("currentStatus")) ? "selected=\"selected\"" : ""%>>2</option>
                                        <option value="3" <%="14".equals(clientWbo.getAttribute("currentStatus")) ? "selected=\"selected\"" : ""%>>3</option>
                                    </select>
                                    <div class="rateit" data-rateit-backingfld="#<%=clientWbo.getAttribute("id")%>" data-rateit-resetable="false"></div>
                                </td>
                                <td>
                                    <div>
                                        <b title="<%=description%>" dir="ltr" style="cursor: hand; float: right;"><%=attValue%></b>
                                    </div>
                                    <img src="images/icons/info.png" title="<%=description%>" style="float: left; height: 30px; cursor: hand;"/>
                                </td>
                                <%
                                    for (int i = 1; i < s; i++) {
                                        attName = clientsAttributes[i];
                                        attValue = (String) clientWbo.getAttribute(attName);
                                %>
                                <td>
                                    <div style="float: right;">
                                        <b dir="ltr"><%=attValue%></b>
                                    </div>
                                    <%
                                        if (i == 1) {
                                    %>
                                    <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&amp;clientId=<%=clientWbo.getAttribute("id")%>');">
                                        <img src="images/client_details.jpg" width="30" style="float: left;"/>
                                    </a>
                                    <%
                                        }
                                    %>
                                </td>
                                <%
                                    }
                                %>
                                <td><img src="images/icons/view_comments.jpg" style="width: 30px; cursor: hand;" title="View Comments"
                                         onclick="JavaScript: popupShowComments('<%=clientWbo.getAttribute("id")%>');"</td>
                                <td><img src="images/icons/add-comment.png" style="width: 30px; cursor: hand;" title="New Comment"
                                         onclick="JavaScript: popupAddComment(this, '<%=clientWbo.getAttribute("id")%>')"/></td>
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
        <script type="text/javascript">
            var tooltipvalues = ['Lead', 'Opportunity', 'Contact'];
            $(".rateit").bind('over', function (event, value) {
                $(this).attr('title', tooltipvalues[value - 1]);
            });
            $(".rateit").bind('rated', function (event, value) {
                updateClientStatus($(this).attr("data-rateit-backingfld").substring(1));
            });
        </script>
    </body>
</html>
