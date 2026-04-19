<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.clients.servlets.ClientServlet"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.db_access.AlertMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>


        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />

        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" href="css/crmStyle.css"/>
       
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
    </head>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.employee_agenda.employee_agenda"  />

    <%
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ClientMgr clientMgr = ClientMgr.getInstance();
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        String attName = null;
        String attValue = null;
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getDefaultRefreshPageInterval();
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String toDate1 = sdf.format(c.getTime());
        c.add(Calendar.MONTH, -5);
        String fromDate1 = sdf.format(c.getTime());
        String[] clientsAttributes = {"name", "clientNO", "creationTime", "classTitle", "mobile"};
        String[] clientsListTitles = new String[5];
        int s = clientsAttributes.length;
        int t = s + 0;
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");

        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        ClientComplaintsMgr.getInstance().updateClientComplaintsType();

        //
        ArrayList<WebBusinessObject> ratesList = new ArrayList<WebBusinessObject>();
        try {
            ratesList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
        } catch (Exception ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        //
        //
        ArrayList<WebBusinessObject> typesList = new ArrayList<WebBusinessObject>();
        try {
            typesList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("RQ-TYPE", "key4"));
        } catch (Exception ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);

        }

        //
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String fromD = request.getParameter("fromDate") == null ? fromDate1 : request.getParameter("fromDate");
        String toD = request.getParameter("toDate") == null ? toDate1 : request.getParameter("toDate");
        String type = request.getParameter("type") == null ? "" : request.getParameter("type");

        ArrayList<WebBusinessObject> clientsList = new ArrayList<WebBusinessObject>();
        try {
            clientsList = clientMgr.getCustomersClassification((String) loggedUser.getAttribute("userId"),
                    new Timestamp(sdf.parse(fromD).getTime()), new Timestamp(sdf.parse(toD).getTime()), request.getParameter("mainClientRate") == null ? "2" : request.getParameter("mainClientRate"),
                    null, null, request.getParameter("type"), request.getParameter("campaignID"));
            for (WebBusinessObject clientTempWbo : clientsList) {
                clientTempWbo.setAttribute("creationTime", ((String) clientTempWbo.getAttribute("creationTime")).substring(0, 16));
            }
        } catch (ParseException ex) {
            request.setAttribute("clientsList", new ArrayList<WebBusinessObject>());
        }
        request.setAttribute("fromDate", fromD);
        request.setAttribute("toDate", toD);
        request.setAttribute("mainClientRate", request.getParameter("mainClientRate") == null ? "1" : request.getParameter("mainClientRate"));

        //
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }
        //

        Map<String, String> selectedTabMap = securityUser.getSelectedTab();
        String selectedTab = selectedTabMap.get(CRMConstants.SELECTED_TAB_EMPLOYEE_AGENDA_KEY);
        if (selectedTab == null) {
            selectedTab = "1";
            securityUser.getSelectedTab().put(CRMConstants.SELECTED_TAB_EMPLOYEE_AGENDA_KEY, selectedTab);
        }

        AlertMgr alertMgr = AlertMgr.getInstance();
        String count = alertMgr.getUnReadCommentsAlertCount((String) loggedUser.getAttribute("userId"));

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign,sAlign, display, classification, clntCom, com;
        String dir = null, fApp, Src, appDate, clientC, dirM, LastA, LastC, appTyp, distType, all, fromDate, toDate, campaign;
        String localWhatsapp, interWhatsapp, knowUs, whatsapp;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            sAlign = "left";
            dir = "LTR";
            dirM = "RTL";
            clientC = "Clients' Classification";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display";
            classification = "Classification";
            clntCom = "Client Notes";
            com = "Note";
            LastA = "Last Appointment Date ";
            LastC = "Call";
            fApp = "First Appointment";
            Src = "Source";
            appDate = "Appointment Date";
            appTyp = "Appointment Type";
            distType = "Distribution Type";
            all = "All";
            campaign = "Campaign";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Client No.";
            clientsListTitles[2] = "Creation Time";
            clientsListTitles[3] = "Class";
            clientsListTitles[4] = "Mobile";
            localWhatsapp = "Local Whatsapp";
            interWhatsapp = "International Whatsapp";
            knowUs = "Channel";
            whatsapp = "Whatsapp";
        } else {
            align = "center";
            xAlign = "left";
            sAlign = "right";
            dir = "RTL";
            dirM = "LTR";
            clientC = "";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض ";
            classification = "التصنيف";
            clntCom = " ملاحظة العميل";
            com = "الملاحظه";
            fApp = "اول متابعه";
            Src = "المتابع";
            appDate = "تاريخ المتابعة";
            appTyp = "نوع المتابعة";
            distType = "نوع التوزيع";
            all = "الكل";
            LastA = "اخر تاريخ للمقابله";
            LastC = "مكالمة";
            campaign = "الحملة";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "رقم العميل";
            clientsListTitles[2] = "تاريخ التسجيل";
            clientsListTitles[3] = "التصنيف";
            clientsListTitles[4] = "موبايل";
            localWhatsapp = "واتساب محلى ";
            interWhatsapp = "واتساب دولى";
            knowUs = " عن طريق";
            whatsapp = "واتساب";
        }

    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">


        $(document).ready(function () {
            var oTable;


            $('#clients1').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[-1], ["All"]],
                iDisplayLength: -1,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true,
            }).fadeIn(2000);


            // Get the current date
            var currentDate = new Date();

            // Calculate the date 5 months ago
            currentDate.setMonth(currentDate.getMonth() - 5);

            // Format the date as 'yy-mm-dd'
            var formattedDate = $.datepicker.formatDate('yy-mm-dd', currentDate);

            // Set the fromDate input field value
            $("#fromDate").val(formattedDate);

            // Initialize datepicker for fromDate with the desired options
            $("#fromDate").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy-mm-dd'
            });

            // Initialize datepicker for toDate with the desired options
            $("#toDate").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy-mm-dd'
            });

            try {
                $(".clientRate").msDropDown();
                $(".campaign").msDropDown();
            } catch (e) {
                alert(e.message);
            }
        });


        $(function () {
            $("[title]").tooltip({
                position: {
                    my: "left top",
                    at: "right+5 top-5"
                }
            });
        });
        $(function () {
            /*if (document.getElementById("selectedTab").value == "2") {
             showDev2();
             } else */if (document.getElementById("selectedTab").value === "3") {
                showDev3();
            } else if (document.getElementById("selectedTab").value === "4") {
                showDev4();
            } else if (document.getElementById("selectedTab").value === "5") {
                showDev5();
            } else if (document.getElementById("selectedTab").value === "6") {
                showDev6();
            } else if (document.getElementById("selectedTab").value === "7") {
                showDev7();
            } else {
                showDev1();
            }
        });
        ///////

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
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status === 'ok') {
                        $("#classTitle" + clientID).html($("#clientRate" + clientID + " option:selected").text());
//                            alert("تم التقييم");
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

        function popupClientAppointments(clientID) {
            var divTag = $("#appointments");
            $.ajax({
                type: "post",
                url: '<%=context%>/AppointmentServlet?op=getClientAppointments',
                data: {
                    clientID: clientID
                },
                success: function (data) {
                    divTag.html(data).dialog({
                        modal: true,
                        title: "متابعات العميل",
                        show: "fade",
                        hide: "explode",
                        width: 950,
                        position: {
                            my: 'center',
                            at: 'center'
                        },
                        buttons: {
                            'Close': function () {
                                $(this).dialog('close');
                            }
                        }
                    }).dialog('open');
                    var oTable = $('#clientAppointmentsPopup').dataTable({
                        bJQueryUI: true,
                        "bPaginate": false,
                        "bProcessing": true,
                        "aaSorting": [[1, "desc"]],
                        "bFilter": false,
                        "bProcessing": true,
                    }).fadeIn(2000);
                    oTable.destroy();
                },
                error: function (data) {
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
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    $(obj).attr("title", "عدد المتابعات: " + info.count);
                }
            });
        }


        function showClientComm(obj, description) {
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

        function closePopup(obj) {
            $(obj).parent().parent().bPopup().close();
        }
        


        /////

        function showFirstAppointment(obj, clientID) {
            $.ajax({
                type: "post",
                url: "<%=context%>/AppointmentServlet?op=getFirstAppointmentAjax",
                data: {
                    clientID: clientID
                },
                success: function (jsonString) {
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

        //


        //

        function showDev1() {
            setSeletedTab("1");
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con8").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con1").style.display = 'block';
//            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
     document.querySelectorAll("#tabs a").forEach(a => a.classList.remove("active"));
  document.getElementById("div1").classList.add("active");
        }





        function showDev4() {
            setSeletedTab("4");
            document.getElementById("con4").style.display = 'block';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con8").style.display = 'none';
//            document.getElementById("div4").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div8").style.backgroundImage = 'url(images/buttonbg.jpg)';

        }
        function showDev5() {
            setSeletedTab("5");
            document.getElementById("con5").style.display = 'block';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con8").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
//            document.getElementById("con2").style.display = 'none';
//            document.getElementById("con1").style.display = 'none';
//            document.getElementById("div5").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div8").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function showDev6() {
            setSeletedTab("6");
            document.getElementById("con6").style.display = 'block';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con8").style.display = 'none';
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
//            document.getElementById("div6").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div8").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function showDev7() {
            setSeletedTab("7");
            document.getElementById("con7").style.display = 'block';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con8").style.display = 'none';
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
//            document.getElementById("div7").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div8").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        function showDev8() {
            setSeletedTab("8");
            document.getElementById("con8").style.display = 'block';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';

//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
//            document.getElementById("div8").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            // document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function setSeletedTab(seletedTab) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ajaxServlet?op=setSeletedTab",
                data: {
                    seletedTab: seletedTab,
                    forPage: '<%=CRMConstants.SELECTED_TAB_EMPLOYEE_AGENDA_KEY%>'
                }
            });
        }

        function changeCommentCounts(clientId, obj) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=appointmentsCountAjax",
                data: {
                    clientId: clientId
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    $(obj).attr("title", "عدد المتابعات: " + info.count);
                }
            });
        }
        function viewRequest(issueId, clientComplaintId) {
            var url = '<%=context%>/IssueServlet?op=requestComments&issueId=' + issueId + '&clientComplaintId=' + clientComplaintId + '&showPopup=true';
            var wind = window.open(url, "", "toolbar=no,height=" + screen.height + ",width=" + screen.width + ", location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no,navigationbar=no");
            wind.focus();
        }


        function openInNewWindow(url) {
            var win = window.open(url, '_blank');
            win.focus();
        }
    </SCRIPT>
    <style>
          #tabs {

    list-style: none;
    padding: 0;
    margin: 0 0 0px 0;
    display: flex;
    gap: 4px;
    justify-content: center;
    align-items: center;

        }
        #tabs li{ display: inline-block; }
        #tabs li a{
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            padding: 8px 14px;
            margin: 0;
            font-size: 15px;
            font-weight: 600;
                color: #27272a;
            background: #eeeeee;
            border: 1px solid transparent;
            border-radius: 8px 8px 0 0;
            transition: background-color .18s ease, transform .12s ease;
        }
        #tabs li a:hover{
            background-color: rgba(3,105,161,0.08);
      
            transform: translateY(-1px);
        }
        /* match JS that sets backgroundImage to activeBtn2.jpg */
        #tabs li a.active {
            background: #27272A;
            color: #fff !important;
            border-color: rgba(0,0,0,0.06);
            box-shadow: 0 6px 18px rgba(37,99,235,0.12);
        }
        /* smaller screens wrap */
        @media (max-width:640px){
            #tabs{ flex-wrap: wrap; gap:6px; }
            #tabs li a{ padding: 8px 10px; font-size: 14px; }
        }

        .popup_{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 30%;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }
        .popup_conten{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 30%;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }

        .urgent{
            background-image: url(images/redBgt.png);
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
        #hideANDseek{ display: none;}          
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
            color: black;
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
      .button-N{
          font-family: "Google Sans", sans-serif !important;
   font-size: 16px;
    font-weight: 600;
    width: 120px !important;
    text-decoration: none;
    cursor: pointer;
    border-radius: 10px;
    border: none !important;
    color: #ffffff;
    background: #27272A;
    box-shadow: 0 5px 12px rgba(0, 0, 0, 0.35);
    transition: all 0.2s ease;
          padding: 8px;
}



        .button-N:hover {
       background-color: #323235;
    box-shadow: 0 10px 24px rgba(0, 0, 0, 0.45);
    transform: translateY(-2px);

}

        .crm-tabs  {
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  padding: 10px 18px;
  color: #111827;
  font-weight: 600;
  transition: 0.25s;
}

.crm-tabs:hover {
  background: #e0e7ff;
}

.crm-tabs.active {
  background: #2563eb;
  color: white;
  border-color: #2563eb;
}

.td-table{

    font-size: 13px;
    color: black;
    text-align: center;
    font-weight: bold;
   padding: 8px; 
   background-color:#fafafa;
}
.input-st{
        width: 190px;
    padding: 7px;
    border-radius: 6px;
    border: 1px solid #bbbbbb;
    margin: 2px 0;
    background-color: #ffffff !important;
}
.drop-dowen-N{
        width: 250px;
    font-size: 18px;
    padding: 4px 6px;
    border-radius: 5px;
    margin: 2px;
}
table.dataTable thead th,
table.dataTable thead td,
table.dataTable tfoot th,
table.dataTable tfoot td {
  padding: 4px 5px !important;
  color: black !important; 
}
    </style>
    <BODY>

        <!--b style="float: <!%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<!%=xAlign%>: 80px;">Clients' Classification تصنيف العملاء</b-->


        <input type="hidden" id="selectedTab" name="selectedTab" value="<%=selectedTab%>"/>
        <div >
            <center>
                <div style="border:0px solid gray; width:100%; margin:auto; padding: 10px;margin-bottom: 0px;">
                    <ul id="tabs" style="direction: <%=dirM%>">
                        <%if (userPrevList.contains("SHOW_HOMEPPAGE_TABS")) {%>
                        <li ><a id="div4"  class="crm-tab" style="height: 35px;"href="javascript:showDev4();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="search"/></SPAN></a></li>
                        <%}%>            
                        <li class="crm-tab" style="<%=Integer.parseInt(count) > 0 ? "" : "display: none;"%>" ><a id="div7" class="urgent" style="height: 35px;"href="javascript:showDev7();" ><SPAN style="display: inline-block; padding: 2px; color: red;"> <fmt:message key="activeComments"/> &nbsp; <label class="login" style="width: 25px; height: 20px; margin: 0px; padding: 0px; background: #FF5733; float: <%=sAlign%>;"> <%=count%> </label> </SPAN></a></li>
                        <li class="crm-tab" ><a id="div8"  style="height: 35px;"href="javascript:showDev8();" ><SPAN style="display: inline-block; padding: 2px;">Upcoming Calls</SPAN></a></li>
                        <li class="crm-tab"><a id="div5" class="crm-tab" style="height: 35px;"href="javascript:showDev5();" ><SPAN style="display: inline-block;padding: 2px;">Past Calls</SPAN></a></li>
                        <li class="crm-tab"><a id="div6" class="crm-tab" style="height: 35px;"href="javascript:showDev6();" ><SPAN style="display: inline-block; padding: 2px;">Today Calls</SPAN></a></li>             
                        
                        <li><a id="div1" class="crm-tab"  style="height: 35px;"href="javascript:showDev1();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="input"/></SPAN></a></li>
                        
                    </ul>
                    <div dir=<fmt:message key="direction"/> id="con1" style="display:block;border:0px solid gray; width:96%; margin: 0px;">
                        <div id="show_comments"   style="width: 50% !important;display: none;position: fixed ;">
                        </div>
                        <div id="appointments" style="display: none;"></div>

                        <fieldset align=center class="set" style="width: 90%">

                            <form name="CLASSIFICATION_FORM" action="<%=context%>/main.jsp" method="POST" style="margin: 0px 0px -85px">
                                <br/>
                                <input type="hidden" id="selectedTab" name="selectedTab" value="<%=selectedTab%>"/>

                                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="2" cellspacing="0" width="650" style="border-width: 1px; border-color: #dcdcdc; display: block;direction: <%=dir%>" >
                                    <tr>
                                        <td class=" blueHeaderTD" style="font-size:18px; border-right:1px solid #c1c1c1; " width="325px">
                                            <b><font size=3 > <%=fromDate%></b>
                                        </td>
                                        <td class=" blueHeaderTD" style="font-size:18px;" width="325px">
                                            <b><font size=3 > <%=toDate%></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="td-table" valign="middle">
                                            <input type="text" class="input-st" id="fromDate" name="fromDate" size="20" maxlength="100" title=" Sent Time " readonly="true"
                                                   value="<%=request.getAttribute("fromDate") == null ? fromDate1 : request.getAttribute("fromDate")%>"/> 

                                        </td>
                                        <td  class="td-table" valign="middle">
                                            <input type="text" class="input-st" id="toDate" name="toDate" size="20" maxlength="100" readonly="true" title=" Sent Time "
                                                   value="<%=request.getAttribute("toDate") == null ? toDate1 : request.getAttribute("toDate")%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class=" blueHeaderTD" style="font-size:18px; border-right:1px solid #c1c1c1;">
                                            <b><font size=3 ><%=classification%></b>
                                        </td>
                                        <td class=" blueHeaderTD" style="font-size:18px;">
                                            <b><font size=3 ><%=distType%></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td  class="td-table" valign="middle">
                                            <select class="clientRate" name="mainClientRate" id="clientRate" style="width: 200px; direction: rtl;">
                                                <option value="2" <%="2".equals(request.getAttribute("mainClientRate")) ? "selected" : ""%>>All</option>
                                                <option value="1" >UnRated</option>
                                                <%
                                                    for (WebBusinessObject rateWbo : ratesList) {
                                                %>
                                                <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateWbo.getAttribute("projectID").equals(request.getAttribute("mainClientRate")) ? "selected" : ""%>  data-image="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><%=rateWbo.getAttribute("projectName")%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>

                                        <td  class="td-table" valign="middle" colspan="2">
                                            <select name="type"  id="type" class="drop-dowen-N" style=" font-size: 18px;">
                                                <option value=""> <%=all%> </option>
                                                <sw:WBOOptionList  wboList="<%=typesList%>" displayAttribute="projectName" valueAttribute="projectName" scrollToValue="<%=type%>"/>

                                            </select>
                                        </td>

                                    </tr>

                                    <tr>
                                        <td  class="td-table" valign="middle" colspan="2">
                                            <input type="submit" value="<%=display%>" class="button-N" style="margin: 16px;"/>
                                            <input type="hidden" name="op" value="getClientClassM">
                                        </td>
                                    </tr>
                                </table>
                                <br/>

                                <br/><br/>
                            </form>
                            <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">

                                <!--
                                <button type="button" style="color: #000;font-size:15;margin-top: 20px;font-weight:bold;"
                                        onclick="JavaScript: exportToExcel();" title="Export to Excel">Excel &nbsp; &nbsp;<img height="15" src="images/icons/excel.png" />
                                </button>
                                -->

                                <br/>
                                <br/>
                                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="clients1" style="width:100%; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.20);">
                                    <thead>
                                        <tr>
                                            <th><%=clientsListTitles[3]%></th>
                                                <%
                                                    for (int i = 0; i < t; i++) {
                                                        if (i != 3) {
                                                %>                
                                            <th>
                                                <B><%=clientsListTitles[i]%></B>
                                            </th>
                                            <%
                                                    }
                                                }
                                            %>
                                            <th>
                                                <B> <%=knowUs%> </B>
                                            </th>
                                            <th>
                                                <B><%=LastA%></B>
                                            </th>
                                            <th>
                                                <B>Upcoming Call</B>
                                            </th>
                                            <th>

                                                <B><%=LastC%></B>
                                            </th>
                                            <th style="display: <%=userPrevList.contains("VIEW_COMMENTS") ? "" : "none"%>;">

                                            </th>
                                            <!--th style="display: <%=userPrevList.contains("ADD_COMMENT") ? "" : "none"%>;">

                                            </th-->
                                            <th>
                                                <%=whatsapp%>
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
                                                if (description == null || description.isEmpty()) {
                                                    description = "لا يوجد تعليق";
                                                }
                                                String interPhone = "";
                                                if (clientWbo.getAttribute("interphone") != null) {
                                                    interPhone = clientWbo.getAttribute("interphone").toString();
                                                    if (!interPhone.isEmpty()) {
                                                        interPhone.substring(2);
                                                    } else {
                                                        interPhone = "";
                                                    }
                                                }
                                        %>
                                        <tr>
                                            <td style="text-align:right;width: 15%">
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
                                            </td>
                                            <td  width="13%">
                                                <%=attValue%>
                                                <img src="images/icons/info.png" title="<%=description%>"  onmouseover="showClientComm(this, '<%=description%>');" style="float: left; height: 23px; cursor: hand;"/>
                                                <img src="images/dialogs/Fa.png" title="<%=clientWbo.getAttribute("id")%>"  onmouseover="showFirstAppointment(this, '<%=clientWbo.getAttribute("id")%>');" style="display:none;float: left; height: 25px; cursor: hand;"/>
                                            </td>
                                            <%
                                                for (int i = 1; i < s; i++) {
                                                    if (i != 3) {
                                                        attName = clientsAttributes[i];
                                                        attValue = clientWbo.getAttribute(attName) != null ? (String) clientWbo.getAttribute(attName) : "";

                                            %>
                                            <td class="<%=i == 1 ? "confirmed" : ""%>" nowrap width="25%">
                                                <div style="float: <%=sAlign%>;width:60%">
                                                    <b id="<%=attName%><%=clientWbo.getAttribute("id")%>"><%=attValue%></b>
                                                </div>
                                                <%
                                                    if (i == 1) {
                                                %>
                                                <a target="_SELF" href="<%=context%>/ClientServlet?op=clientDetails&amp;clientId=<%=clientWbo.getAttribute("id")%>">
                                                    <img class="icon" src="images/client_details.jpg" width="23" height="23" style="float: left;" />
                                                         <!--onmouseover="JavaScript: getFollowupCounts('<%=clientWbo.getAttribute("id")%>', this);"--> 
                                                </a>
                                                <!--a href="JavaScript: openInNewWindow('<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=clientWbo.getAttribute("id")%>&clientType=30-40');">
                                                    <img class="icon" src="images/icons/control.png" height="23" style="float: left;"/>
                                                </a-->
                                                <a href="JavaScript: popupClientAppointments('<%=clientWbo.getAttribute("id")%>');">
                                                    <img class="icon" src="images/icons/calendar-256.png" height="23" style="float: left;" />
                                                </a>
                                                <%
                                                    }
                                                %>
                                            </td>
                                            <%
                                                    }
                                                }
                                            %>
                                            <td  width="10%">
                                                <div>
                                                    <b title="seasonName" dir="ltr" style="text-align: center;cursor: hand;"><%=clientWbo.getAttribute("seasonName")%></b>
                                                </div>
                                            </td>
                                            <td>
                                                <b><%=clientWbo.getAttribute("appDate").toString().split(" ")[0]%></b>
                                            </td>
                                            <%
                                            String appoDate = clientWbo.getAttribute("appointment_date").toString().split(" ")[0];
                                            String color = null;
                                            if(appoDate.equals("---")){
                                            appDate = "---";
		                             } else {
                                            String appointmentDateStr = clientWbo.getAttribute("appointment_date").toString().split(" ")[0];
                                            SimpleDateFormat sdfK = new SimpleDateFormat("yyyy-MM-dd");
                                            Date appointmentDate = sdfK.parse(appointmentDateStr);
                                            Date today = new Date();
                                            color = appointmentDate.compareTo(today) <= 0 ? "lightpink" : "white";
                                            appoDate = clientWbo.getAttribute("appointment_date").toString().split(" ")[0];                                            
}%>
                                                
                                                <td style="background: <%= color %>;">
                                                <b><%=appoDate%></b>
                                            </td>
                                             <td>
                                                <a href="<%=context%>/ClientServlet?op=ViewClientMenu&clientNo=<%=clientWbo.getAttribute("clientNO")%>&clientID=<%=clientWbo.getAttribute("id")%>&button=directCall" ><img style="height:35px;" src="images/icons/follow_up.png" title="Direct Call"></a>
                                            </td>
                                            <td style="display: <%=userPrevList.contains("VIEW_COMMENTS") ? "" : "none"%>;"><img src="images/icons/view_comments.jpg" style="width: 26px; cursor: hand;" title="View Comments"
                                                                                                                                 onclick="JavaScript: popupShowComments('<%=clientWbo.getAttribute("id")%>');"/></td>
                                            <!--td style="display: <%=userPrevList.contains("ADD_COMMENT") ? "" : "none"%>;"><img src="images/icons/add-comment.png" style="width: 30px; cursor: hand;" title="New Comment"
                                                                                                                               onclick="JavaScript: popupAddComment(this, '<%=clientWbo.getAttribute("id")%>')"/></td-->
                                            <td width="10%">
                                                <b><a href="https://web.whatsapp.com/send?phone=2<%=clientWbo.getAttribute("mobile")%>" target="_blank" title="<%=localWhatsapp%>"><img width="26px" src="images/whatsappIcon.png"/></a></b>
                                                        <%if (!interPhone.isEmpty()) {%>
                                                <b><a href="https://web.whatsapp.com/send?phone=<%=interPhone%>" target="_blank" title="<%=interWhatsapp%>"><img width="26px" src="images/whatsappIcon2.png"/></a></b>

                                                <%}%>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </fieldset>

                        <script type="text/javascript">
                            var tooltipvalues = ['Lead', 'Opportunity', 'Contact'];
                            $(".rateit").bind('over', function (event, value) {
                                $(this).attr('title', tooltipvalues[value - 1]);
                            });
                            $(".rateit").bind('rated', function (event, value) {
                                updateClientStatus($(this).attr("data-rateit-backingfld").substring(1));
                            });
                            var config = {
                                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'}
                            };
                            for (var selector in config) {
                                $(selector).chosen(config[selector]);
                            }
                        </script>


                    </div>

                    <div  dir=<fmt:message key="direction"/> id="con5" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="appointment_notifications.jsp" flush="true"></jsp:include>
                        </div>
                        <div  dir=<fmt:message key="direction"/> id="con8" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="appointment_infuture.jsp" flush="true"></jsp:include>
                        </div>

                        <div  dir=<fmt:message key="direction"/> id="con6" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="comments_notifications.jsp" flush="true"></jsp:include>
                        </div>
                        <div  dir=<fmt:message key="direction"/> id="con7" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="active_comments.jsp" flush="true"></jsp:include>
                        </div>

                        <div  dir=<fmt:message key="direction"/> id="con4" style="display:block;border:0px solid gray; width:100%; margin: 0px; " >
                        <%--<jsp:include page="/docs/sales/search_my_clients.jsp" flush="true"></jsp:include>--%>
                        <jsp:include page="/docs/sales/search_my_clients2.jsp" flush="true"></jsp:include>
                        </div>
                        <br>
                        <br>
                        <br>
                    </div>
                </center>
            </div>
        <script language="JavaScript" type="text/javascript">
            $(document).ready(function () {
                $(".fromToDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
            });
        </script>
    </BODY>
</HTML>