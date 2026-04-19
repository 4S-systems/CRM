<%-- 
    Document   : client_class_with_project
    Created on : Apr 4, 2018, 10:00:20 AM
    Author     : fatma
--%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
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
        String[] clientsAttributes = {"clientNO", "name", "creationTime", "classTitle", "mobile"};
        String[] clientsListTitles = new String[5];
        int s = clientsAttributes.length;
        int t = s + 0;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        ArrayList<WebBusinessObject> projectList = (ArrayList<WebBusinessObject>) request.getAttribute("projectList");
        String projectID = (String) request.getAttribute("projectID");
        
        String hashTag = "";
        if (request.getAttribute("hashTag") != null) {
            hashTag = (String) request.getAttribute("hashTag");
        }
    
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, xAlign, fromDate, toDate, display, classification, clntCom, com, dir, fApp, Src, appDate, appTyp, projectStr;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client No.";
            clientsListTitles[1] = "Client Name";
            clientsListTitles[2] = "Creation Time";
            clientsListTitles[3] = "Class";
            clientsListTitles[4] = "Mobile";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            classification = "Classification";
            clntCom = "Client Notes";
            com = "Note";
            fApp = "First Appointment";
            Src = "Source";
            appDate = "Appointment Date";
            appTyp = "Appointment Type";
            projectStr = " Projects ";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "رقم العميل";
            clientsListTitles[1] = "اسم العميل";
            clientsListTitles[2] = "تاريخ التسجيل";
            clientsListTitles[3] = "التصنيف";
            clientsListTitles[4] = "موبايل";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            classification = "التصنيف";
            clntCom = " ملاحظة العميل";
            com = "الملاحظه";
            fApp = "اول متابعه";
            Src = "المتابع";
            appDate = "تاريخ المتابعة";
            appTyp = "نوع المتابعة";
            projectStr = " المشاريع ";
        }
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
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
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        
        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[2, "asc"]]
                }).fadeIn(2000);
                
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                try {
                    $(".clientRate").msDropDown();
                } catch (e) {
                    alert(e.message);
                }
                
                $("#projectID").select2();
            });
            
            
            $(function(){
                $("[title]").tooltip({
                    position: {
                        my: "left top",
                        at: "right+5 top-5"
                    }
                });
            });
            
            function popupShowComments(id) {
                var url = "<%=context%>/CommentsServlet?op=showClientComments&clientId=" + id + "&objectType=1&random=" + (new Date()).getTime();
                jQuery('#show_comments').load(url);
                $('#show_comments').css("display", "block");
                $('#show_comments').bPopup();
            }
            
            function changeClientRate(clientID, obj) {
                var rateID = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=changeClientRate",
                    data: {
                        rateID: rateID,
                        clientID: clientID
                    }, success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            $("#classTitle" + clientID).html($("#clientRate" + clientID + " option:selected").text());
                            alert("تم التقييم");
                        } else {
                            alert("خطأ لم يتم التقييم");
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
                $('#add_comments').bPopup({
                    easing: 'easeInOutSine',
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
                    }, success: function (jsonString) {
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
            
            function exportToExcel() {
                if(checkSpace()){
                    var toDate = $("#toDate").val();
                    var fromDate = $("#fromDate").val();
                    var clientRate = $("#clientRate").val();
                    var url = "<%=context%>/ClientServlet?op=getClientClassExcel&toDate=" + toDate + "&fromDate=" + fromDate + "&mainClientRate=" + clientRate + "&projectID=" + $("#projectID option:selected").val() + "&hashTag=" + $("#hashTag").val();
                    window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=500, height=500");
                } else {
                    alert(" Enter Hashtag Without White Space ");
                }
            }
            
            function popupClientAppointments(clientID) {
                var divTag = $("#appointments");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/AppointmentServlet?op=getClientAppointments',
                    data: {
                        clientID: clientID
                    }, success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "متابعات العميل",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                                my: 'center',
                                at: 'center'
                            }, buttons: {
                                'Close': function () {
                                    $(this).dialog('close');
                                }
                            }
                        }).dialog('open');
                        
                        $('#clientAppointmentsPopup').dataTable({
                            bJQueryUI: true,
                            "bPaginate": false,
                            "bProcessing": true,
                            "aaSorting": [[ 1, "desc" ]],
                            "bFilter": false
                        }).fadeIn(2000);
                    }, error: function (data) {
                        alert(data);
                    }
                });
            }

            function getFollowupCounts(clientId, obj) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=appointmentsCountAjax",
                    data: {
                        clientId: clientId
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).attr("title", "عدد المتابعات: " + info.count);
                    }
                });
            }
            
            function showClientComm (obj, description) {
                $(obj).tooltip({
                    content: function () {
                        return "<table class='appointment_table' border='0' dir='<%=dir%>'>\n\
                                    <tr>\n\
                                        <td class='appointment_header' colspan='2'><%=clntCom%></td>\n\
                                    </tr>\n\
                                    <tr>\n\
                                        <td class='appointment_title'><%=com%></td>\n\
                                        <td class='appointment_data'>" + description + "</td>\n\
                                    </tr>\n\
                                </table>";
                    }
                });
            }
            
            function showFirstAppointment(obj, clientID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/AppointmentServlet?op=getFirstAppointmentAjax",
                    data: {
                        clientID: clientID
                    }, success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).tooltip({
                            content: function () {
                                return "<table class='appointment_table' border='0' dir='<%=dir%>'><tr><td class='appointment_header' colspan='2'><%=fApp%></td></tr>\n\
                                <tr><td class='appointment_title'><%=Src%></td><td class='appointment_data'>" + info.appointmentBy + "</td></tr>\n\
                                <tr><td class='appointment_title' nowrap><%=appDate%></td><td class='appointment_data'>" + info.appointmentDate + "</td></tr>\n\
                                <tr><td class='appointment_title' nowrap><%=appTyp%></td><td class='appointment_data'>" + info.appointmentType + "</td></tr>\n\
                                <tr><td class='appointment_title'><%=com%></td><td class='appointment_data'>" + info.comment + "</td></tr>\n\
                                </table>";
                            }
                        });
                    }
                });
            }
            
            function checkSpace(){
                return !($('#hashTag').val().indexOf(' ')>=0);
            }
            
            function submitForm(){
                if(checkSpace()){
                    document.CLASSIFICATION_FORM.action = "<%=context%>/ClientServlet?op=getClientClassWithProject";
                    document.CLASSIFICATION_FORM.submit();
                } else {
                    alert(" Enter Hashtag Without White Space ");
                }
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
            
            #hideANDseek{
                display: none;
            }       
            
            .appointment_table {
                padding: 10px 20px;
                color: white;
                border-radius: 20px;
                font: bold 16px "Helvetica Neue", Sans-Serif;
                box-shadow: 0 0 7px black;
            }
            
            .appointment_header {
                background-color: #d18080;
                padding: 5px;
            }
            
            .appointment_title {
                background-color: #abc0e5;
                padding: 5px;
            }
            
            .appointment_data {
                background-color: white;
                padding: 5px;
            }
            
            .login-input {
                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #27272A;
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
            
            .ddlabel {
                float: left;
            }
            
            .fnone {
                margin-right: 5px;
            }
            
            .ddChild, .ddTitle {
                text-align: right;
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
            
            .ahmed-gamal {
                width:40px;
                height: 40px;
                float:right;
                margin: 0px;
                padding: 0px;
            }
            
            .icon {
                vertical-align: middle;
            }
            
            .confirmed {
                background-color: #EBB462;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
        </style>
    </HEAD>
    
    <body>
        <div id="show_comments"   style="width: 50% !important;display: none;position: fixed ;">
        </div>
        
        <div id="add_comments" style="width: 30%; margin-right: auto; margin-left: auto; display: none; position: fixed; top: 0%;"><!--class="popup_appointment" -->
            <div style="clear: both; margin-left: 88%; margin-bottom: -38px; z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                            -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                            -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <%
                        if (metaMgr.getShowCommentType().equalsIgnoreCase("1")) {
                    %>
                            <tr>
                                <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;">
                                    نوع التعليق
                                </td>
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
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">
                            التعليق
                        </td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%; height: 80px;" id="commentAreaForSave" name="commentAreaForSave" > </textarea>
                            
                            <input type="hidden" id="clientId" value="1"/>
                        </td>
                    </tr> 
                </table>
                    
                <div style="text-align: center; margin-left: auto; margin-right: auto; clear: both" > 
                    <input type="button" value="حفظ"   onclick="saveComment(this)" id="saveComm"class="login-submit"/>
                </div>
                    
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                    
                <div style="margin: 0 auto; display: none; width: 90%; text-align: center; color: white; font-size: 16px; font-weight: bold" id="commMsg">
                    تم إضافة التعليق
                </div>
            </div>  
        </div>
                    
        <div id="appointments" style="display: none;"></div>
        
        <b style="float: <%=xAlign%>; font-size: 16px; color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">
            Clients' Classification تصنيف العملاء
        </b>
            
        <fieldset align=center class="set" style="width: 90%">
            <form name="CLASSIFICATION_FORM" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="<%=dir%>" id="code" cellpadding="0" cellspacing="0" style="width: 50%;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 50%;" colspan="3">
                            <b>
                                <font size=3 color="white">
                                     <%=fromDate%>
                            </b>
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;" colspan="3">
                            <b>
                                <font size=3 color="white">
                                     <%=toDate%> 
                            </b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td bgcolor="#dedede" valign="middle" style="width: 50%;" colspan="3">
                            <input type="text" style="width: 90%;" id="fromDate" name="fromDate" size="20" maxlength="100" title=" Sent Time " readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        
                        <td bgcolor="#dedede" valign="middle" style="width: 50%;" colspan="3">
                            <input type="text" style="width:90%;" id="toDate" name="toDate" size="20" maxlength="100" readonly="true" title=" Sent Time "
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;" colspan="3">
                            <b>
                                <font size=3 color="white">
                                     <%=classification%> 
                            </b>
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;" colspan="3">
                            <b>
                                <font size=3 color="white">
                                     <%=projectStr%> 
                            </b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td bgcolor="#dedede" valign="middle" style="width: 50%;" colspan="3">
                            <select class="clientRate" name="mainClientRate" id="clientRate" style="width: 90%; direction: <%=dir%>;">
                                <option value="">All</option>
                                <option value="1" <%="1".equals(request.getAttribute("mainClientRate")) ? "selected" : ""%>>UnRated</option>
                                <%
                                    for (WebBusinessObject rateWbo : ratesList) {
                                %>
                                        <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateWbo.getAttribute("projectID").equals(request.getAttribute("mainClientRate")) ? "selected" : ""%>  data-image="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><%=rateWbo.getAttribute("projectName")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                        
                        <td bgcolor="#dedede" valign="middle" style="width: 50%;" colspan="3">
                            <select style="font-size: 14px;font-weight: bold; width: 90%;" id="projectID" name="projectID" class="">
                                <option value="">All</option>
                                <sw:WBOOptionList wboList='<%=projectList%>' displayAttribute = "projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;" colspan="3">
                            <b>
                                <font size=3 color="white">
                                     Hash Tag 
                            </b>
                        </td>
                        
                        <td bgcolor="#dedede" valign="middle" style="width: 50%;" colspan="3">
                            <input id="hashTag" name="hashTag" type="text" value="<%=hashTag%>" style="width: 90%; background-color: #FAFFAD;" onkeypress="javascript:return checkSpace();" placeholder="Enter Without Space"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="<%=userPrevList.contains("EXCEL") ? "2" : "3"%>">
                            <input type="button" value="<%=display%>" class="button" style="margin: 10px; width: 75%;" onClick="submitForm()"/>
                            <input type="hidden" name="op" value="getClientClass">
                        </td>
                        
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <center>
                                <div class="ahmed-gamal" align="" style="width: 90%; border: none; padding: 2px;" id="view">
                                    <a href="JavaScript: openInNewWindow('<%=context%>/ReportsServletThree?op=clientRateReport');">
                                        <image src="images/pie-chart.png" title=" إحصائيات جميع العملاء " style="height: 35px;" align="center"/>
                                    </a>                 
                                </div>
                            </center>
                        </td>
                        
                        <td bgcolor="#dedede" valign="middle" style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;">
                            <input type="button" value="Excel" class="button" style="margin: 10px; width: 75%;" onclick="exportToExcel()" title="Export to Excel"/>
                        </td>
                    </tr>
                </table>
                            
                <br/>

                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    
                    <!--
                    <button type="button" style="color: #000;font-size:15;margin-top: 20px;font-weight:bold;"
                            onclick="JavaScript: exportToExcel();" title="Export to Excel">Excel &nbsp; &nbsp;<img height="15" src="images/icons/excel.png" />
                    </button>
                    -->
                    
                    <br/>
                    <br/>
                    
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                               <%-- <th></th>--%>
                                <th>
                                    <B> Know Us From </B>
                                </th>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                        <th>
                                            <B>
                                                 <%=clientsListTitles[i]%> 
                                            </B>
                                        </th>
                                <%
                                    }
                                %>
                                <th>
                                    <B>
                                         Last Appointment Date 
                                    </B>
                                </th>
                                
                                <th>
                                    <B>
                                         Last Appointment Comment 
                                    </B>
                                </th>
                                
                                <th style="display: <%=userPrevList.contains("VIEW_COMMENTS") ? "" : "none"%>;">
                                </th>
                                
                                <th style="display: <%=userPrevList.contains("ADD_COMMENT") ? "" : "none"%>;">
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
                                    
                                    if(description == null || description.isEmpty()){
                                        description = "لا يوجد تعليق";
                                    }
                            %>
                                    <tr>
                                       <%-- <td style="text-align:right;">
                                            <%
                                                if (privilegesList.contains("BATCH_EVALUATION")) {
                                            %>
                                            <select class="clientRate" name="clientRate" id="clientRate<%=clientWbo.getAttribute("id")%>" style="width: 200px; direction: rtl;"
                                                    onchange="JavaScript: changeClientRate('<%=clientWbo.getAttribute("id")%>', this);">
                                                <option value="">Select Client Rate</option>
                                                <%
                                                    for (WebBusinessObject rateWbo : ratesList) {
                                                %>
                                                <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateWbo.getAttribute("projectID").equals(clientWbo.getAttribute("rateID")) ? "selected" : ""%>  data-image="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><%=rateWbo.getAttribute("projectName")%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <%
                                            } else {
                                                if (clientWbo != null && clientWbo.getAttribute("rateID") != null) {
                                            %>
                                            <%=clientWbo.getAttribute("classTitle")%> <img src="images/msdropdown/<%="UL".equals(clientWbo.getAttribute("imageName")) ? "black" : clientWbo.getAttribute("imageName")%>.png" style="float: left;"/>
                                            <%
                                            }
                                                }
                                            %>
                                        </td>--%>
                                        <td>
                                            <div>
                                                <b title="seasonName" dir="ltr" style="cursor: hand; float: right;">
                                                     <%=clientWbo.getAttribute("seasonName")%> 
                                                </b>
                                            </div>
                                        </td>
                                        
                                        <td  width="13%" class="confirmed">
                                             <%=attValue%> 
                                            <img src="images/icons/info.png" title="<%=description%>"  onmouseover="showClientComm(this,'<%=description%>');" style="float: left; height: 23px; cursor: hand;"/>
                                            <img src="images/dialogs/Fa.png" title="<%=clientWbo.getAttribute("id")%>"  onmouseover="showFirstAppointment(this,'<%=clientWbo.getAttribute("id")%>');" style="float: left; height: 25px; cursor: hand;"/>
                                        </td>
                                        <%
                                            for (int i = 1; i < s; i++) {
                                                attName = clientsAttributes[i];
                                                attValue = clientWbo.getAttribute(attName) != null ? (String) clientWbo.getAttribute(attName) : "";
                                        %>
                                                <td>
                                                    <div style="float: right;">
                                                        <b id="<%=attName%><%=clientWbo.getAttribute("id")%>">
                                                             <%=attValue%> 
                                                        </b>
                                                    </div>
                                                    <%
                                                        if (i == 1) {
                                                    %>
                                                            <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&amp;clientId=<%=clientWbo.getAttribute("id")%>');">
                                                                <img class="icon" src="images/client_details.jpg" width="23" height="23" style="float: left;"
                                                                     onmouseover="JavaScript: getFollowupCounts('<%=clientWbo.getAttribute("id")%>', this);"/>
                                                            </a>
                                                            
                                                            <a href="JavaScript: openInNewWindow('<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=clientWbo.getAttribute("id")%>&clientType=30-40');">
                                                                <img class="icon" src="images/icons/control.png" height="23" style="float: left;"/>
                                                            </a>
                                                                
                                                            <a href="JavaScript: popupClientAppointments('<%=clientWbo.getAttribute("id")%>');">
                                                                <img class="icon" src="images/icons/calendar-256.png" height="23" style="float: left;" title="Client Appointments"/>
                                                            </a>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                        <%
                                            }
                                        %>
                                        
                                        <td>
                                            <b>
                                                 <%=clientWbo.getAttribute("appDate").toString().split(" ")[0]%> 
                                            </b>
                                        </td>

                                        <td>
                                           <b>
                                                <%=clientWbo.getAttribute("lstAppCom")%> 
                                           </b>
                                        </td>
                                        
                                        <td style="display: <%=userPrevList.contains("VIEW_COMMENTS") ? "" : "none"%>;"><img src="images/icons/view_comments.jpg" style="width: 30px; cursor: hand;" title="View Comments"
                                                 onclick="JavaScript: popupShowComments('<%=clientWbo.getAttribute("id")%>');"/></td>
                                        <td style="display: <%=userPrevList.contains("ADD_COMMENT") ? "" : "none"%>;"><img src="images/icons/add-comment.png" style="width: 30px; cursor: hand;" title="New Comment"
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