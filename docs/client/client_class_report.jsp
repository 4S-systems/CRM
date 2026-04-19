<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
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
        String[] clientsAttributes = {"clientName", "mobile","interPhone", "clientCreationTime", "mct", "diffDays", "ratedBy", "rateName","KNOWN_US_FROM","campaign_title","englishname","COMMENT"};
        String[] clientsListTitles = new String[13];
	
	String[] unRClientsAttributes = {"clientName", "mobile","interPhone", "sender_name" ,"full_name","englishname", "clientCreationTime"};
	String[] unRClientsListTitles = new String[7];
	
	String clsUncls = request.getAttribute("clsUncls") != null ? (String) request.getAttribute("clsUncls") : "";
	int s = 0, t = 0;
        String smry = request.getAttribute("smry") != null ? (String) request.getAttribute("smry") : "1";
	if(clsUncls != null && (clsUncls.equals("cls") || clsUncls.equals("all"))){
	    s = clientsAttributes.length;
	    t = s;
	} else if(clsUncls != null && clsUncls.equals("uncls")){
	    s = unRClientsAttributes.length;
	    t = s;
            smry = "0";
	}
        
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");
        ArrayList<WebBusinessObject> employees = (ArrayList<WebBusinessObject>) request.getAttribute("employees");
        ArrayList<WebBusinessObject> employeeList = (ArrayList<WebBusinessObject>) request.getAttribute("employeeList");
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        
        ArrayList<WebBusinessObject> dataList = (ArrayList<WebBusinessObject>) request.getAttribute("dataList");
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        
        if (employees == null) {
            employees = new ArrayList<>();
        }
        
        ArrayList<WebBusinessObject> typesList = (ArrayList<WebBusinessObject>) request.getAttribute("typesList");
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        
        String campaignID = request.getAttribute("campaignID") != null ? (String) request.getAttribute("campaignID") : "";
        String rateID = request.getAttribute("rateID") != null ? (String) request.getAttribute("rateID") : "";
        String employeeID = request.getAttribute("employeeID") != null ? (String) request.getAttribute("employeeID") : "";
        String type = request.getAttribute("type") != null ? (String) request.getAttribute("type") : "عميل جديد";
        String dateType = request.getAttribute("dateType") != null ? (String) request.getAttribute("dateType") : "registration";
	
        String jsonText = (String) request.getAttribute("jsonText");
	String res = (String) request.getAttribute("res");
	
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, display, campaign, all, employeeName, clsStr, unclsStr, typeOfRequest, ratedDate,
                unratedDate, dir, lstRtTm, registrationDate, ratingDate, smryStr, dtls, clsfctn, ttl,
                proj, dstrbutMsg, dstrbutErrMsg, fAppTm, totalStr;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Client Mobile";
            clientsListTitles[2] = "International No";
            clientsListTitles[3] = "Creation Time";
            clientsListTitles[4] = " First Classification Time";
            clientsListTitles[5] = "Difference Day(s)";
            clientsListTitles[6] = "Classified By";
            clientsListTitles[7] = "Classification";
            clientsListTitles[8] = "Know Us";
            clientsListTitles[9] = "Campagine / Broker";
            clientsListTitles[10] = "Source";
            clientsListTitles[11] = "COMMENT";
	    clientsListTitles[12] = "Department";
                    
	    unRClientsListTitles[0] = "Client Name";
            unRClientsListTitles[1] = "Client Mobile";
            unRClientsListTitles[2] = "International No";
            unRClientsListTitles[3] = "Sender";
            unRClientsListTitles[4] = "Responsible";
            unRClientsListTitles[5] = "Know Us";
            unRClientsListTitles[6] = "Creation Time";
	    
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            campaign = "Campaign";
            all = "All";
            employeeName = "Employee";
	    clsStr = " Rated Clients ";
	    unclsStr = " Unrated Clients ";
            typeOfRequest = "Type of Request";
            
            ratedDate = "Classification Date ";
            unratedDate = "Registration Date";
	    
	    lstRtTm = " Last Rating Time ";
            registrationDate = "Registration Date";
            ratingDate = "Rating Date";
            
            smryStr = " Summery ";
            dtls = " Detailes ";
            clsfctn = " Classification ";
            ttl = " Total ";
            proj = "Project";
            dstrbutMsg = " Distribution Has Been Done ";
            dstrbutErrMsg = " Distribution Failed ";
            fAppTm = "First Future Appointment Date";
            
            totalStr = " Total ";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "الموبايل";
            clientsListTitles[2] = "الرقم الدولى";
            clientsListTitles[3] = "تاريخ التسجيل";
            clientsListTitles[4] = " تاريخ التصنيف الأول ";
            clientsListTitles[5] = "الفارق بالأيام";
            clientsListTitles[6] = "التصنيف بواسطة";
            clientsListTitles[7] = "التصنيف";
            clientsListTitles[8] = "عرفتنا";
            clientsListTitles[8] = "حملة / وسيط";
            clientsListTitles[9] = "مصدر";
            clientsListTitles[10] = "Department";
	    clientsListTitles[11] = "COMMENT";

	    unRClientsListTitles[0] = "اسم العميل";
            unRClientsListTitles[1] = "الموبايل";
            unRClientsListTitles[2] = "الرقم الدولى";
            unRClientsListTitles[3] = "المرسل";
            unRClientsListTitles[4] = "المسئول";
            unRClientsListTitles[5] = "المسئول";
            unRClientsListTitles[6] = "تاريخ التسجيل";
	    
            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            display = "أعرض التقرير";
            campaign = "الحملة";
            all = "الكل";
            employeeName = "الموظف";
	    clsStr = " عملاء مصنفين ";
	    unclsStr =  " عملاء غير مصنفيين ";
            typeOfRequest = "نوع الطلب";
            ratedDate = " تاريخ التقييم";
            unratedDate = " تاريخ التسجيل";
	    
	    lstRtTm = " تاريخ أخر تصنيف ";
            registrationDate = "تاريخ التسجيل";
            ratingDate = "تاريخ التصنيف";
            
            smryStr = " الملخص ";
            dtls = " التفاصيل ";
            clsfctn = " التصنيف ";
            ttl = " الإجمالى ";
            proj = "المشروع";
            dstrbutMsg = " تم التوزيع ";
            dstrbutErrMsg = " لم يتم التوزيع ";
            fAppTm = "تاريخ اول متابعه مستقبليه";
            totalStr = " الإجمالى ";
        }
        
	WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

	GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        
        String projectID = "";
        if (request.getAttribute("projectID") != null) {
            projectID = (String) request.getAttribute("projectID");
        }
    
	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
        
        int total = 0;
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
		var clsUncls = '<%=clsUncls%>';
		if(clsUncls != "null" && clsUncls != ""){
		  $("#" + clsUncls).prop("checked", true);
		  showClass(clsUncls);
		}
                
                var str;
                if(clsUncls != null && clsUncls != "null" && (clsUncls == "" || clsUncls == "cls" || clsUncls == "all")){
		  str = '<%=ratedDate%>';
                  $("#toDate").attr("title", str);
                  $("#fromDate").attr("title", str);
		} else if(clsUncls != null && clsUncls != "null" && clsUncls == "uncls"){
		  str = '<%=unratedDate%>';
                  $("#toDate").attr("title", str);
                  $("#fromDate").attr("title", str);
		}
                
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                    iDisplayStart: 0,
                     iDisplayLength: 20,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[1, "asc"]],
                    "columnDefs": [ {
                        "targets": 0,
                        "orderable": false
                    } ],

                }).fadeIn(2000);
                
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                $('#smryTbl').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                }).fadeIn(2000);
            });
            
            function exportToExcel() {
                var toDate = $("#toDate").val();
                var fromDate = $("#fromDate").val();
                var campaignID = $("#campaignID").val();
                var projectID = $("#projectID").val();
                var rateID = $("#rateID").val();
                var type = $("#type").val();
                var departmentID = $("#departmentID option:selected").val();
                //console.log("projectID "+ projectID);
                var dateType = $("input[name='dateType']:checked").val();
                var rprtType = $("input[name='smry']:checked").val();
                if(rateID === null) {
                    rateID = '';
                }
                var url = "<%=context%>/ReportsServletThree?op=clientClassificationExcel&toDate=" + toDate + "&fromDate=" + fromDate + "&campaignID=" + campaignID + "&rateID=" + rateID + "&employeeID=<%=employeeID%>&clsUncls=" + $("#valRUrC").val()
                        + "&type=" + type + "&dateType=" + dateType+"&departmentID="+ departmentID+"&projectID="+ projectID + "&rprtType=" + rprtType;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }

            /* preparing pie chart */
            var chart;
            $(document).ready(function () {
		
		<%
                    if(clsUncls != null && (clsUncls.equals("cls") || clsUncls.equals("all"))){
                %>
                        chart = new Highcharts.Chart({
                            chart: {
                                renderTo: 'testContainer',
                                plotBackgroundColor: null,
                                plotBorderWidth: null,
                                plotShadow: false
                            },
                            title: {
                                text: null
                            },
                            tooltip: {
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            },
                            plotOptions: {
                                pie: {
                                    allowPointSelect: true,
                                    cursor: 'pointer',
                                    dataLabels: {
                                        enabled: true,
                                        color: '#000000',
                                        connectorColor: '#000000',
                                        formatter: function () {
                                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                        }
                                    }
                                }
                            },
                            series: [{
                                    type: 'pie',
                                    data: <%=jsonText%>
                                }]
                        });
		<% 
                    } else if(clsUncls != null && clsUncls.equals("uncls")){
                %>
                        chart = new Highcharts.Chart({
                            chart: {
                                renderTo: 'testContainer',
                                plotBackgroundColor: null,
                                plotBorderWidth: null,
                                plotShadow: false
                            },
                            title: {
                                text: null
                            },
                            tooltip: {
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            },
                            plotOptions: {
                                pie: {
                                    allowPointSelect: true,
                                    cursor: 'pointer',
                                    dataLabels: {
                                        enabled: true,
                                        color: '#000000',
                                        connectorColor: '#000000',
                                        formatter: function () {
                                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                        }
                                    }
                                }
                            },
                            series: [{
                                    type: 'pie',
                                    data: <%=res%>
                                }]
                        });
		<%
                    }
                %>
            });
            
            /* -preparing pie chart */
            function redirectComplaint(id, disType) {
                var employeeId = document.getElementById('employeeId' + id);
                hideAllIcon(id);
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=redirectClientComplaint",
                    data: {
                        clientID: id,
                        employeeId: employeeId.value,
                        ticketType: '<%=CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER%>',
                        comment: 'Redirect Order',
                        subject: disType,
                        notes: 'أنهاء تلقائي'
                    }, success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            $("#icon" + id).css("display", "block");
                            $("#loading" + id).css("display", "none");
                        }
                    }, error: function (jsonString) {
                        alert(jsonString);
                    }
                });
            }
            
            function hideAllIcon(id) {
                $("#employeeId" + id).css("display", "none");
                $("#button" + id).css("display", "none");
                $("#icon" + id).css("display", "block");
            }
            
            function selectAllChecks(obj) {
                $("input[name='clientID']").prop('checked', $(obj).is(':checked'));
            }
            
            function openRedirectPopup(){
                var checkLength = $("input[name='clientID']:checked").length;
                if(checkLength < 1){
                    alert( " إختر عميل " );
                } else if(checkLength > 20){
                    alert( "لا يمكن أختيار أكثر من 20 عملاء في المرة الواحدة" );
                } else {
                    $("#redirectClientBtn").show();
                    $('#redirectClient').show();
                    $('#redirectClient').bPopup({
                        easing: 'easeInOutSine', //uses jQuery easing plugin
                        speed: 400,
                        transition: 'slideDown'
                    });
                }
            }
            
            function redirectClients() {
                if($("#employeeIDPopup").val() === '') {
                    alert("You must select an employee to redirect to it");
                    return;
                }
                var clientIDs = $("input[name='clientID']:checked");
                var types = new Array();
                var ids = new Array();
                $.each(clientIDs, function () {
                    types.push($("#complaintType" + $(this).val()).val());
                    ids.push($(this).val());
                });
                $("#redirectClientBtn").hide();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=redirectClients",
                    data: {
                        clientID: ids.toString(),
                        employeeId: $("#employeeIDPopup").val(),
                        ticketType: '<%=CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER%>',
                        comment: 'Redirect Order',
                        subject: $("#typePopup").val(),
                        notes: 'أنهاء تلقائي'
                    }, success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            var msg = '<%=dstrbutMsg%>';
                            alert(msg);
                            //location.reload();
                            document.CLASSIFICATION_FORM.action = '<%=context%>/ReportsServletThree?op=clientClassificationReport';
                            document.CLASSIFICATION_FORM.submit();
                        }
                    }, error: function (jsonString) {
                        var msg = '<%=dstrbutErrMsg%>';
                        alert(msg);
                        //alert(jsonString);
                    }
                });
            }
            
            function getFutureAppointment(clientID, obj) {
//                $.ajax({
//                    type: "post",
//                    url: "<%=context%>/AppointmentServlet?op=getFutureAppointment",
//                    data: {
//                        clientID: clientID
//                    }, success: function (jsonString) {
//                        var info = $.parseJSON(jsonString);
//                        if (info.status === 'Ok') {
//                            var d = info.appointmentDate;
//                            if (d.length > 10) {
//                                d = d.substring(0, 10);
//                            }
//                            var title = (info.option2 === 'call' ? "مكالمة" : "مقابلة") + " بتاريخ: " + d + "\n";
//                            title += "التعليق: " + info.comment;
//                            $(obj).attr("title", title);
//                        } else {
//                            $(obj).attr("title", "لا يوجد");
//                        }
//                    }, error: function (jsonString) {
//                        alert(jsonString);
//                    }
//                });
            }
	    
	    function showClass(str){
                 var strT;
                 
		if(str == 'cls'){
		    $("#clssTrStr").show();
		    $("#clssTrSlc").show();
		    $("#dateRow").show();
                    $("#smryTR").show();
		    $("#valRUrC").val(str);
                    
                    strT = '<%=ratedDate%>';
                  $("#toDate").attr("title", strT);
                  $("#fromDate").attr("title", strT);
		} else if(str == 'uncls'){
		    $("#clssTrStr").hide();
		    $("#clssTrSlc").hide();
                    $("#nclssTrStr").attr("colspan", "4");
		    $("#nclssTrSlc").attr("colspan", "4");
                    $("#smryTR").hide();
		    $("#dateRow").hide();
		    $("#valRUrC").val(str);
                    
                    strT = '<%=unratedDate%>';
                  $("#toDate").attr("title", strT);
                  $("#fromDate").attr("title", strT);
		} else if(str == 'all'){
		    $("#clssTrStr").show();
		    $("#clssTrSlc").show();
		    $("#dateRow").show();
                    $("#smryTR").show();
		    $("#valRUrC").val(str);
                    
                    strT = '<%=ratedDate%>';
                  $("#toDate").attr("title", strT);
                  $("#fromDate").attr("title", strT);
		}
	    }
            
            function getEmployees(obj, isReload) {
                var departmentID = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=getEmployeesList",
                    data: {
                        departmentID: departmentID
                    },
                    success: function (jsonString) {
                        try {
                            var output = [];
                            output.push('<option value="">' + '<%=all%>' + '</option>');
                            var createdBy = $("#employeeID");
                            $(createdBy).html("");
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                            }
                            createdBy.html(output.join(''));
                            if (isReload) {
                                $("#employeeID").val('<%=employeeID%>');
                            }
                        } catch (err) {
                        }
                    }
                });
            }
            
            function getProjects(obj) {
                var campaignID = $("#campaignID").val();
                //console.log("campaignID "+ campaignID);
                $.ajax({
                    type: "post",
                    url: '<%=context%>/CampaignServlet?op=getProjectsAjax',
                    data: {
                        campaignID: campaignID
                    },
                    success: function (dataStr) {
                        console.log("dataStr "+ dataStr);
                        var result = $.parseJSON(dataStr);
                        var options = [];
                        options.push("<option value=''>", "الكل", "</option>");
                        try {
                            $.each(result, function () {
                                if (this.projectName) {
                                    options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                                }
                            });
                        } catch (err) {
                        }
                        $("#projectID").html(options.join(''));
                    }
                });
            }
            
            function popupBookmark() {
                if ($("input[name='clientID']:checked").length > 0 && $("input[name='clientID']:checked").length < 11) {
                    $('#bookmarkDiv').bPopup();
                    $('#bookmarkDiv').css("display", "block");
                } else if($("input[name='clientID']:checked").length > 10) {
                    alert("لا يمكن أختيار أكثر من 10 عملاء في المرة الواحدة");
                } else {
                    alert("أختر علي اﻷقل عميل واحد");
                }
            }
            function bookmarkClients(obj) {
                $(obj).attr("disabled", "true");
                var clientIDs = "";
                var note = "";
                var title = "";
                var ids = [];
                clientIDs = $("input[name='clientID']:checked");
                note = $("#bookmarkNote").val();
                title = $("#bookmarkTitle").val();
                $(clientIDs).each(function(index, obj) {
                    var temp = $(obj).val().split(",");
                    ids.push(temp[0]);
                });
                $.ajax({
                    type: "post",
                    url: "<%=context%>/BookmarkServlet?op=bookmarkMultiClientsAjax",
                    data: {
                        ids: ids.join(),
                        title: title,
                        note: note
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("تم التسجيل بنجاح");
                            $(obj).removeAttr("disabled");
                            $("input[name='clientID']:checked").prop('checked', false);
                            $("#bookmarkDiv").bPopup().close();
                        } else if (info.status === 'error') {
                            alert("لم يتم التسجيل");
                            $(obj).removeAttr("disabled");
                            $("#bookmarkDiv").bPopup().close();
                        }
                    }
                });
                return false;
            }
            function popupAddComment() {
                if ($("input[name='clientID']:checked").length > 0 && $("input[name='clientID']:checked").length < 11) {
                    $("#commMsg").hide();
                    $('#add_comments').css("display", "block");
                    $('#add_comments').bPopup();
                } else if($("input[name='clientID']:checked").length > 10) {
                    alert("لا يمكن أختيار أكثر من 10 عملاء في المرة الواحدة");
                } else {
                    alert("أختر علي اﻷقل عميل واحد");
                }
            }
            function saveComment(obj) {
                var ids = [];
                var clientIDs = $("input[name='clientID']:checked");
                $(clientIDs).each(function(index, obj) {
                    var temp = $(obj).val().split(",");
                    ids.push(temp[0]);
                });
                var type = $("#commentType").val();
                var comment = $("#addCommentArea").val();
                var businessObjectType = $("#businessObjectType").val();
                var title = $("#commentTitlePopup").val();
                comment = title !== '' ? title + " " + comment : comment;
                title = title !== '' ? title : "UL";
                $("#progress").show();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=saveMultiCommentsAjax",
                    data: {
                        ids: ids.join(),
                        type: type,
                        comment: comment,
                        businessObjectType: businessObjectType,
                        option2: title
                    }, success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status === 'ok') {
                            alert("تم التسجيل بنجاح");
                            $(obj).removeAttr("disabled");
                            $("input[name='clientID']:checked").prop('checked', false);
                            $("#commMsg").show();
                            $("#progress").hide();
                            $('#add_comments').css("display", "none");
                            $('#add_comments').bPopup().close();
                        } else if (eqpEmpInfo.status === 'no') {
                            alert("لم يتم التسجيل");
                            $(obj).removeAttr("disabled");
                            $("#progress").show();
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
            .bookmark_button{
                width:135px;
                height:40px;
                float: right;
                margin: 0px;
                /*margin-right: 90px;*/
                border: none;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-top: 3px;
                background-position: right top ;
                /*display: inline-block;*/
                background-color: transparent;
                background-image:url(images/buttons/bookmarked.png);
            }
        </style>
    </HEAD>
    <body>
	<input type="hidden" id="valRUrC">
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Clients' Classification Report تقرير تصنيف العملاء</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="CLASSIFICATION_FORM" action="<%=context%>/ReportsServletThree?op=clientClassificationReport" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="<%=dir%>" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;" >
                    <tr>
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
			    <input type="radio" name="clsUncls" id="cls" value="cls" onchange="showClass('cls')">
			</td>
			
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				<%=clsStr%>
			    </font>
			</td>
			
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
			    <input type="radio" name="clsUncls" value="uncls" onchange="showClass('uncls')" id="uncls">
			</td>
                        
                        <td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				<%=unclsStr%>
			    </font>
			</td>
		    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
			    <input type="radio" name="clsUncls" id="all" value="all" onchange="showClass('all')" checked>
			</td>
			
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				All
			    </font>
			</td>
			
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
			</td>
                        
                        <td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
			    </font>
			</td>
                    </tr>
                    <tr id="dateRow">
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
                            <input type="radio" name="dateType" value="rating" <%="rating".equals(dateType) ? "checked" : ""%>/>
			</td>
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				<%=ratingDate%>
			    </font>
			</td>
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
			    <input type="radio" name="dateType" value="registration" <%="registration".equals(dateType) ? "checked" : ""%>/>
			</td>
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				<%=registrationDate%>
			    </font>
			</td>
		    </tr>
                    
                    <tr id="smryTR">
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
                            <input type="radio" name="smry" value="1" <%="1".equals(smry) ? "checked" : ""%>/>
			</td>
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				<%=smryStr%>
			    </font>
			</td>
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
			    <input type="radio" name="smry" value="0" <%="0".equals(smry) ? "checked" : ""%>/>
			</td>
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				<%=dtls%>
			    </font>
			</td>
		    </tr>
		    
		    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="2">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="2">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>" title="<%=ratedDate%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>" title="<%=ratedDate%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=1.5 color="white">Source</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=1.5 color="white"><%=proj%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select name="campaignID" id="campaignID" style="width: 300px;" class="chosen-select-campaign"
                                    onchange="JavaScript: getProjects(this);">
                                <option value=""></option>
                                <option value="1">Nomination</option>
                                <option value="2">Direct Client</option>
                                <option value="3">Indirect client</option>

                            </select>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select name="projectID" id="projectID" style="width: 300px;">
                                <option value="" > All Projects </option>
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr id="">
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2" id="clssTrStr">
                            <b><font size=3 color="white"><%=clientsListTitles[7]%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2" id="nclssTrStr" >
                            <b><font size=3 color="white"><%=clientsListTitles[8]%></b>
                        </td>
                    </tr>
                    <tr id="">
                        <td bgcolor="#dedede" valign="middle" id="clssTrSlc" colspan="2">
                            <select name="rateID" id="rateID" style="width: 300px;" class="chosen-select-rate" multiple>
                                <%
                                for (WebBusinessObject rateWbo : ratesList) {
                                %>
                                <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateID.contains((String) rateWbo.getAttribute("projectID")) ? "selected" : ""%> ><%=rateWbo.getAttribute("projectName")%></option>
                                <%
                                }
                                %>
                            </select>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="2" id="nclssTrSlc">
                            <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 300px;"
                                        onchange="getEmployees(this, false);">
                                <%if (privilegesList.contains("SHOW_ALL_CLIENT")) {%>
                                <option value="all">All</OPTION>
                                <% } %>
                                <% if( departments != null) { %>
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"><%=typeOfRequest%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"><%=employeeName%></b>
                        </td>
                    </tr>
                    <tr>
                        
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select name="type" id="type" style="width: 300px; font-size: 18px;">
				<option value=""> <%=all%> </option>
                                <sw:WBOOptionList wboList="<%=typesList%>" displayAttribute="projectName" valueAttribute="projectName" scrollToValue="<%=type%>"/>
                            </select>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select name="employeeID" id="employeeID" style="width: 300px; font-size: 18px;">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList="<%=employeeList%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=employeeID%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="<%=userPrevList.contains("EXCEL") ? "2" : "4"%>" style="width: 50%;">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px; width: 50%;"/>
                        </td>
                        
                        <td bgcolor="#dedede" valign="middle" colspan="2" style="width: 50%; display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;">
                            <button type="button" class="button" style="color: #27272A;font-size:15px;font-weight:bold; width: 50%; height: 30px; vertical-align: top;"
                                onclick="JavaScript: exportToExcel();" title="Export to Excel">Excel &nbsp; &nbsp;<img height="15" src="images/icons/excel.png" />
                            </button>
                        </TD>
                    </tr>
                </table>
                <br/>
                <br/>
                <%
                    if (clientsList != null) {
                %>
                <div id="testContainer" style="width: 600px; height: 300px; margin: 0 auto"></div>
                <br/>
                
                <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <%
                        if(smry != null && smry.equals("0")){
                            if (privilegesList.contains("DISTRIBUTE_CLIENT")) {
                    %>
                            <button type="button" style="color: #27272A;font-size:15;font-weight:bold; width: 150px; height: 30px; vertical-align: top;"
                                    onclick="JavaScript: openRedirectPopup();" title="توزيع">توزيع &nbsp;&nbsp;<img src="images/icons/forward.png" width="15" height="15" />
                            </button>
                    <%
                            }
                    %>
                            <button type="button" style="color: #27272A;font-size:15;font-weight:bold; width: 150px; height: 30px; vertical-align: top;"
                                    onclick="JavaScript: popupBookmark();" title="علامة">علامة &nbsp;&nbsp;<img src="images/bookmarks.png" width="15" height="15" />
                            </button>
                            <button type="button" style="color: #27272A;font-size:15;font-weight:bold; width: 150px; height: 30px; vertical-align: top;"
                                    onclick="JavaScript: popupAddComment();" title="تعليق">تعليق &nbsp;&nbsp;<img src="css/images/comment.png" width="20" height="20" />
                            </button>
                            <br/>
                            <br/>
                            <table align="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                                <thead>
                                    <tr>
                                        <th>
                                            <input type="checkbox" id="selectAll" onclick="JavaScript: selectAllChecks(this);" />
                                        </th>

                                        <th>
                                        </th>
                                        <%
                                            if(clsUncls != null && (clsUncls.equals("cls") || clsUncls.equals("all"))){
                                                for (int i = 0; i < t; i++) {
                                        %>                
                                                    <th>

                                                        <b><%=clientsListTitles[i]%></b>
                                                    </th>
                                                    
                                        <%
                                                }
                                            } else if(clsUncls != null && clsUncls.equals("uncls")){
                                                for (int i = 0; i < t; i++) {
                                        %>                
                                                    <th>

                                                        <b><%=unRClientsListTitles[i]%></b>
                                                    </th>
                                        <%
                                                }
                                            } 
                                        %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        String callFunction;
                                        for (WebBusinessObject clientWbo : clientsList) {
                                    %>
                                    <tr title="<%=lstRtTm%>:  <%=clientWbo.getAttribute("creationTime")%>           
                                              <%=fAppTm%>:  <%=clientWbo.getAttribute("fna")%>">
                                        <td>
                                            <input type="checkbox" name="clientID" value="<%=clientWbo.getAttribute("clientID")%>"/>
                                            <input type="hidden" id="complaintType<%=clientWbo.getAttribute("clientID")%>" name="complaintType"
                                                   value="<%=clientWbo.getAttribute("distributionType")%>"/>
                                        </td>

                                        <td>
                                            <a target="blanck" href="<%=context%>/ClientServlet?op=clientDetails&issueID=<%=clientWbo.getAttribute("issueID")%>&clientId=<%=clientWbo.getAttribute("clientID")%>">
                                                <img src="images/client_details.jpg" width="30" style="float: left;">
                                            </a>
                                        </td>

                                        <%
                                            if(clsUncls != null && (clsUncls.equals("cls") || clsUncls.equals("all"))){
                                                for (int i = 0; i < s; i++) {
                                                    attName = clientsAttributes[i];
                                                    //clientCreationTime
                                                    if(attName != null && attName.equals("clientCreationTime")){
                                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim().split(" ")[0] : "";
                                                    } else if(attName != null && attName.equals("mct")){
                                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim().split(" ")[0] : "";
                                                    } else {
                                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";
                                                    }
                                                    
                                                    if (i == s - 1) {
                                                        callFunction = " onmouseover=\"JavaScript: getFutureAppointment('" + clientWbo.getAttribute("clientID") + "', this);\"";
                                                    } else {
                                                        callFunction = "";
                                                    }
                                        %>
                                        <td>
                                            <div>
                                                <b<%=callFunction%>><%=attValue%></b>
                                                <%
                                                    if (i == 6 && clientWbo.getAttribute("color") != null) {
                                                %>
                                                <% if(!clientWbo.getAttribute("color").equals("")){ %>
                                                <img src="images/msdropdown/<%=clientWbo.getAttribute("color")%>.png" style="float: <%=xAlign%>; width: 20px; height: 20px;"/>
                                                <% } else { %>
                                                <P>----</p>
                                                <% } %>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </td>
                                        <%
                                                }
                                            } else if(clsUncls != null && clsUncls.equals("uncls")){
                                                for (int i = 0; i < s; i++) {
                                                    attName = unRClientsAttributes[i];
                                                    if(attName != null && attName.equals("clientCreationTime")){
                                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim().split(" ")[0] : "";
                                                    } else {
                                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";
                                                    }
                                                    
                                                    if (i == s - 1) {
                                                        callFunction = " onmouseover=\"JavaScript: getFutureAppointment('" + clientWbo.getAttribute("clientID") + "', this);\"";
                                                    } else {
                                                        callFunction = "";
                                                    }
                                        %>
                                        <td>
                                            <div>
                                                <b<%=callFunction%>><%=attValue%></b>
                                                <%
                                                    if (i == 6 && clientWbo.getAttribute("color") != null) {
                                                %>
                                                <img src="images/msdropdown/<%=clientWbo.getAttribute("color")%>.png" style="float: <%=xAlign%>;"/>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </td>
                                        <%
                                                }
                                            }
                                        %>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                <%
                    } else if(smry != null && smry.equals("1") && dataList != null){
                %>
                <center><div style="width: 30%; padding: 2%;">
                        <table align="<%=align%>" dir="<%=dir%>" id="smryTbl" style="width:100%;">
                            <thead>
                                <tr>
                                    <th>
                                         <%=clsfctn%> 
                                    </th>

                                    <th>
                                         <%=ttl%> 
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (WebBusinessObject wbo : dataList) {
                                %>
                                <tr>
                                    <td>
                                         <%=wbo.getAttribute("rateName")%> <img src="images/msdropdown/<%=wbo.getAttribute("color")%>.png" style="float: <%=xAlign%>;"/>
                                    </td>

                                    <td>
                                         <%=wbo.getAttribute("clientCount")%> 
                                    </td>
                                </tr>
                                <%
                                        total += Integer.parseInt(wbo.getAttribute("clientCount").toString());
                                    }
                                %>
                            </tbody>
                            <TFOOT>
                                <tr>
                                    <td>
                                         <%=totalStr%> 
                                    </td>

                                    <td>
                                         <%=total%> 
                                    </td>
                                </tr>
                            </TFOOT>
                        </table></div></center>
                <%
                    }
                %>
                </div>
                <%
                    }
                %>
                <br/><br/>
            </form>
        </fieldset>
        <div id="redirectClient" style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 500px;">
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
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الموظف</td>
                            <td style="width: 70%;">
                                <select name="employeeIDPopup" id="employeeIDPopup" style="width: 200px;">
                                    <option value="">أختر</option>
                                    <sw:WBOOptionList wboList="<%=employees%>" displayAttribute="fullName" valueAttribute="userId" />
                                </select>
                            </td>
                        </tr> 
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">نوع الطلب</td>
                            <td style="width: 70%;">
                                <select name="typePopup" id="typePopup" style="width: 200px; font-size: 18px;">
                                    <sw:WBOOptionList wboList="<%=typesList%>" displayAttribute="projectName" valueAttribute="projectName"/>
                                </select>
                            </td>
                        </tr> 
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="توزيع" onclick="JavaScript: redirectClients();" id="redirectClientBtn" class="login-submit"/></div>
                
            </div>
        </div>
        <div id="bookmarkDiv"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
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
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">العنوان</td>
                        <td style="width: 70%; text-align: left;" >
                            <select id="bookmarkTitle" name="bookmarkTitle" style="width: 100%;">
                                <option value=""></option>
                                <option value="Hot Client">Hot Client</option>
                                <option value="Unit & Project data missing">Unit & Project data missing</option>
                                <option value="No Payment Plan">No Payment Plan</option>
                                <option value="Poor Client Communication">Poor Client Communication</option>
                                <option value="Visit Support">Visit Support</option>
                                <option value="Other">Other</option>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التفاصيل</td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="bookmarkNote" > </textarea>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" >
                    <input type="button"  onclick="JavaScript: bookmarkClients(this);" class="bookmark_button" style="float: none !important;"/>
                </div>
            </div>  
        </div>
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
                    <tr>
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;">العنوان</td>
                        <td style="width: 70%;" >
                            <select id="commentTitlePopup" name="commentTitlePopup" style="width: 100%;">
                                <option value=""></option>
                                <option value="العميل سجل مرة أخري برجاء التواصل">العميل سجل مرة أخري برجاء التواصل</option>
                                <option value="Hot Client">Hot Client</option>
                                <option value="Unit & Project data missing">Unit & Project data missing</option>
                                <option value="No Payment Plan">No Payment Plan</option>
                                <option value="Poor Client Communication">Poor Client Communication</option>
                                <option value="Visit Support">Visit Support</option>
                                <option value="Other">Other</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="addCommentArea" name="addCommentArea" > </textarea>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                    <input type="button" value="حفظ"   onclick="saveComment(this)" id="saveComm"class="login-submit"/></div></form>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
                    تم إضافة التعليق
                </div>
            </div>  
        </div>
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
                '.chosen-select-rate': {no_results_text: 'No classification found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            getEmployees($("#departmentID"), true);
        </script>
    </body>
</html>
