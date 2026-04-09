<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        Calendar cal = Calendar.getInstance();
        String nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        String meetingDate;
        if (request.getAttribute("fromDate") != null) {
            fromDateVal = (String) request.getAttribute("fromDate");
        }
        String toDateVal = nowTime;
        cal.add(Calendar.MONTH, 1);
        nowTime = sdf.format(cal.getTime());
        if (request.getAttribute("toDate") != null) {
            toDateVal = (String) request.getAttribute("toDate");
        }

        String total = (String) request.getAttribute("total");
        String resultJson = (String) request.getAttribute("resultJson");

        String stat = "Ar";
        String dir = null;
        String PN;
        if (stat.equals("En")) {
            dir = "LTR";
            PN = "Appointments Number";
            meetingDate="Meeting Date";
        } else {
            dir = "RTL";
            PN = "عدد المقابلات";
            meetingDate="تاريخ المقابله";
        }

        String rprtType = request.getAttribute("rprtType") != null ? (String) request.getAttribute("rprtType") : "" ;
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "" ;
        String userId = (String) request.getAttribute("userID");
        boolean isFull = "full".equalsIgnoreCase((String) request.getAttribute("displayType"));
    %>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

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
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>

        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            jQuery.browser = {};
            (function () {
                jQuery.browser.msie = false;
                jQuery.browser.version = 0;
                if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
                    jQuery.browser.msie = true;
                    jQuery.browser.version = RegExp.$1;
                }
            })();
            $(document).ready(function () {
                var data = <%=resultJson%>;
                console.log(" data = " + data);
                var table = $('#applointments').DataTable({
                    columns: [
                        {
                            title: 'اسم العميل',
                            name: 'clientName'
                        }
                        ,
                        {
                            title: 'اسم الموظف',
                            name: 'empName'
                        }
                        ,
                        {
                            title: 'تاريخ تحديد المقابلة',
                            name: 'creationTime'
                        }
                        ,
                        {
                            title: 'تاريخ المقابلة',
                            name: 'appointmentTime'
                        },
                        {
                            title: ' الفرع ',
                            name: 'appointmentPlace'
                        },
                        {
                            title: 'تعليق المقابلة',
                            name: 'COMMENT'
                        }
                        ,
                        {
                            title: 'حالة المقابلة',
                            name: 'option9'
                        },
                <%
                    if (isFull) {
                %>
                        {
                            title: 'أخر تعليق',
                            name: 'COMMENT_DESC'
                        },
                        {
                            title: 'بتاريخ',
                            name: 'commentTime'
                        },
                <%
                    }
                %>
                        {
                            title: '',
                            name: ''
                        }
                    ],
                    data: data,
                    rowsGroup: [
                        'clientName:name'
                    ],
                    "columnDefs": [
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                <%
                    if (isFull) {
                %>
                        {"width": "10%", "targets": 0},
                        {"width": "10%", "targets": 0},
                <%
                    }
                %>
                        {
                            "width": "2%",
                            "targets": -1,
                            "data": null,
                            "defaultContent": "<a target='_blanck' id='goTo'><img src='images/client_details.jpg'/></a>"
                            <%
                                if (isFull) {
                            %>
                                + "<a target='_blanck' id='comment'><img style='height:25px;' src='images/dialogs/comment_public.ico' title='Comment'></a>"
                            <%
                                }
                            %>
                        }
                    ],
                    pageLength: '20',
                    "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                        $('#goTo', nRow).attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + aData[<%=isFull ? "9" : "7"%>]);
                <%
                    if (isFull) {
                %>
                        $('#comment', nRow).attr("href", "JavaScript: popupAddComment(" + aData[9] + ");");
                <%
                    }
                %>
                    }
                });
            });
            $(function () {
                $("#endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });

                $("#beginDate").datepicker({
                    minDate: "-d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
            });
            function popupAddComment(clientID) {
                $(".submenu").hide();
                $(".button_commen").attr('id', '0');
                $("#commMsg").hide();
                $("#addCommentArea").val("");
                $("#clientId").val(clientID)
                $('#add_comments').css("display", "block");
                $('#add_comments').bPopup({
                    easing: 'easeInOutSine',
                    speed: 400,
                    transition: 'slideDown'
                });
            }

            function saveComment(obj) {
                var clientId = $("#clientId").val();
                var type = $(obj).parent().parent().parent().find($("#commentType")).val();
                var comment = $("#addCommentArea").val();
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
                    }, success: function (jsonString) {
                        location.reload();
                    }
                });
            }
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }
        </script>
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
        </style>
    </head>

    <body>
        <% if (total != null) {%>
        <div style="width: 100%; text-align: center;"> <b> <font size="3" color="red"> <%=PN%> : <%=total%> </font></b></div> 
        <br/>
        <%
            if (!isFull) {
        %>
        <div align="left" STYLE="color:blue; margin-left: 50px;">
            <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
        </div>
        <%
        } else {
        %>
        <div id="add_comments"  style="width: 400px ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;"><!--class="popup_appointment" -->
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

                    <input type="hidden" id="commentType" name="commentType" value="0"/>
                    <input type="hidden" id="businessObjectType" value="1"/>
                    <input type="hidden" id="clientId" value=""/>

                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="addCommentArea" name="addCommentArea" > </textarea>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                    <input type="button" value="حفظ"   onclick="saveComment(this)" id="saveComm"class="login-submit"/>
                </div>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
                    تم إضافة التعليق
                </div>
            </div>
        </div>
        <form name="details_form" style="margin-left: auto; margin-right: auto;">
            <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                   style="border-width:1px;border-color:white;display: block;">
                <tr class="head">
                    <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                        <b><font size=3 color="white">من تاريخ</font></b>
                    </td>
                    <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                        <b><font size=3 color="white">إلي تاريخ</font></b>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                        <input id="beginDate" name="beginDate" type="text" title="<%=meetingDate%>" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                        <input type="hidden" name="appointmentType" value="<%=request.getAttribute("appointmentType") != null ? request.getAttribute("appointmentType") : ""%>"/>
                        <input type="hidden" name="displayType" value="<%=request.getAttribute("displayType") != null ? request.getAttribute("displayType") : ""%>"/>
                        <input type="hidden" name="op" value="ViewAppointmentStat"/>
                        <br/><br/>
                    </td>
                    <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                        <input id="endDate" name="endDate" title="<%=meetingDate%>" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                        <br/><br/>
                    </td>
                </tr>
                <tr class="head">
                    <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" colspan="2">
                        <b><font size=3 color="white">الأدارة</font></b>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle" colspan="2">
                        <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 300px;">
                            <option value="all">الكل</option>
                            <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle" colspan="2">
                        <button type="submit" class="button" style="width: 170px;">بحث<img height="15" src="images/search.gif"/></button>
                        <br/>
                        <br/>
                    </td>
                </tr>
            </table>
        </form>
        <%
            }
        %>

        <br/><br/>
        <%
            if(resultJson !=  null){
        %>
            <div id="result" style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE WIDTH="100%" ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" id="applointments">                    
                </table>
            </div>
        <%
            }
        %>
        <br/><br/>
        <%}%>
    </body>
</html>