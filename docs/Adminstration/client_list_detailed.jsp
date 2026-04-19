<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <HEAD>
        <TITLE>System Departments List</TITLE>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="css/blueStyle.css"/>
        <link rel="stylesheet" href="css/Button.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
	        <script src="js/chosen.jquery.js" type="text/javascript"></script>

	<script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
	<link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
	
	<script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
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
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
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
            #showHide{
                border: none;
                padding: 10px;
                font-size: 16px;
                font-weight: bold;
                color: #0066cc;
                cursor: pointer;
                padding: 5px;
            }
            #dropDown{
                position: relative;
            }
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }
            .datepick {}
            .save {
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
            .silver_odd_main,.silver_even_main {
                text-align: center;
            }
            input { font-size: 18px; }
            textarea{
                resize:none;
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }
            #claim_division {
                width: 97%;
                display: none;
                margin:3px auto;
                border: 1px solid #999;
            }
            #order_division{
                width: 97%;
                display: none;
                margin:3px auto;
                border: 1px solid #999;
            }
            label{
                font:Verdana, Geneva, sans-serif;
                font-size:14px;
                font-weight:bold;
                color:#005599;
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
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
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
            .dropdown 
            {
                color: #555;
                width: 128px;
                position: relative;
                height: 17px;
                text-align:left;
            }
            .dropdown li a 
            {
                color: #555555;
                display: block;
                font-family: arial;
                font-weight: bold;
                padding: 6px 15px;
                cursor: pointer;
                text-decoration:none;
            }
            .dropdown li a:hover
            {
                background:#155FB0;
                color:yellow;
                text-decoration: none;
            }
            .submenux
            {
                background:#FFFFCC;
                position: absolute;
                top: 30px;
                left:0px;
                width: 120px;
                display: none;
                margin-left: 0px;;
                padding: 0px 0 5px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
            }
            .submenuxx
            {
                background:#FFFFCC;
                position: absolute;
                top: 30px;
                left:30px;
                width: 120px;
                display: none;
                margin-left: 0px;;
                padding: 0px 0 5px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
            }
            #call_center{
                direction:rtl;
                padding:0px;
                margin-top: 10px;
                margin-left: auto;
                margin-right: auto;
                margin-bottom: 5px;
                color:#005599;
                width:98%;
                border:1px solid #f1f1f1;
                font:Verdana, Geneva, sans-serif;
                font-size:18px;
                font-weight:bold;
            }
            #title{padding:10px;
                   margin:0px 10px;
                   height:30px;
                   width:95%;
                   clear: both;
                   text-align:center;
            }
            .text-success{
                font-family:Verdana, Geneva, sans-serif;
                font-size:24px;
                font-weight:bold;
            }
            #tableDATA th{
                font-size: 15px;
            }
            .save {
                width:32px;
                height:32px;
                background-image:url(images/icons/check.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
            .status{
                width:32px;
                height:32px;
                background-image:url(images/icons/status.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
            .remove {
                width:32px;
                height:32px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/remove.png);
            }
            .button_commx {
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/comm.png);
            }
            .button_attach{
                width:128px;
                height:27px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/attach.png);
            }
            .button_bookmar {
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/bookmark.png);
            }
            .button_redirec{
                width:132px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/redi.png);
            }

            .button_finis{
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/finish.png);
            }
            .button_clos {
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close.png);
            }
            .rejectedBtn{
                width:145px;
                height:40px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/button5.png);
            }
            .attach_button{
                width:145px;
                height:40px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/attachF.png);
            }
            .button_clientO{
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/clientO.png);
            }.managerBt{
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/manager.png);
            }
            .popup_conten{ 
                border: none;
                direction:rtl;
                padding:0px;
                margin-top: 10px;
                border: 1px solid tomato;
                background-color: #f1f1f1;
                margin-bottom: 5px;
                width: 300px;
                font:Verdana, Geneva, sans-serif;
                font-size:18px;
                font-weight:bold;
                display: none;
            }
            .ui-tooltip, .arrow:after {
                background: lightblue;
                border: 2px solid white;
            }
            .ui-tooltip {
                padding: 10px 20px;
                color: black;
                border-radius: 20px;
                font: bold 14px "Helvetica Neue", Sans-Serif;
                text-transform: uppercase;
                box-shadow: 0 0 7px black;
            }
            .arrow {
                width: 70px;
                height: 16px;
                overflow: hidden;
                position: absolute;
                left: 50%;
                margin-left: -35px;
                bottom: -16px;
            }
            .arrow.top {
                top: -16px;
                bottom: auto;
            }
            .arrow.left {
                left: 20%;
            }
            .arrow:after {
                content: "";
                position: absolute;
                left: 20px;
                top: -20px;
                width: 25px;
                height: 25px;
                box-shadow: 6px 5px 9px -9px black;
                -webkit-transform: rotate(45deg);
                -moz-transform: rotate(45deg);
                -ms-transform: rotate(45deg);
                -o-transform: rotate(45deg);
                tranform: rotate(45deg);
            }
            .arrow.top:after {
                bottom: -20px;
                top: auto;
            }
        </style>
    </HEAD>
    <%
	 ArrayList<WebBusinessObject> ratesList = request.getAttribute("ratesList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("ratesList") : null;
	String mainClientRate = request.getAttribute("mainClientRate") != null ? (String) request.getAttribute("mainClientRate") : "";
    
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] supplierListTitles = new String[4];
        List clintsList = (ArrayList) request.getAttribute("data");

        ArrayList<WebBusinessObject> clientStatusList = (ArrayList<WebBusinessObject>) request.getAttribute("clientStatusList");
        ArrayList<WebBusinessObject> areaList = (ArrayList<WebBusinessObject>) request.getAttribute("areaList");
        ArrayList<WebBusinessObject> projectList = (ArrayList<WebBusinessObject>) request.getAttribute("projectList");
        ArrayList<WebBusinessObject> jobList = (ArrayList<WebBusinessObject>) request.getAttribute("jobList");
        ArrayList<WebBusinessObject> groupsList = (ArrayList<WebBusinessObject>) request.getAttribute("groupsList");
        String selectedStatus = "";
        if (request.getAttribute("selectedStatus") != null) {
            selectedStatus = (String) request.getAttribute("selectedStatus");
//        } else if(request.getParameter("clientStatus") != null) {
//            selectedStatus = request.getParameter("clientStatus");
        }
        String selectedProject = "";
        if (request.getAttribute("selectedProject") != null) {
            selectedProject = (String) request.getAttribute("selectedProject");
//        } else if(request.getParameter("clientProject") != null) {
//            selectedProject = request.getParameter("clientProject");
        }
        String selectedArea = "";
        if (request.getAttribute("selectedArea") != null) {
            selectedArea = (String) request.getAttribute("selectedArea");
//        } else if(request.getParameter("clientArea") != null) {
//            selectedArea = request.getParameter("clientArea");
        }
        String selectedJob = "";
        if (request.getAttribute("selectedJob") != null) {
            selectedJob = (String) request.getAttribute("selectedJob");
//        } else if(request.getParameter("clientJob") != null) {
//            selectedJob = request.getParameter("clientJob");
        }
        String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String toDate = sdf.format(c.getTime());
        if (request.getAttribute("toDate") != null) {
            toDate = (String) request.getAttribute("toDate");
        }
        c.add(Calendar.DATE, -1);
        String fromDate = sdf.format(c.getTime());
        if (request.getAttribute("fromDate") != null) {
            fromDate = (String) request.getAttribute("fromDate");
        }
        String interCode = request.getAttribute("interCode") != null ? (String) request.getAttribute("interCode") : "";
        
        String forPopup =(String) request.getAttribute("forPopup");
        
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align, dir, style, addmail, save;
        String clientStatus, clientProject,DetailedCustomerReport,All,Search, clientArea, clientJob, fromDateTitle, toDateTitle, all, clntCls, group,
                interCodeStr;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            supplierListTitles[0] = "Client Name";
            supplierListTitles[1] = "View";
            supplierListTitles[2] = "Edit";
            supplierListTitles[3] = "Delete";
            clientStatus = "Client Status";
            clientProject = "Project";
            clientArea = "Area";
            clientJob = "Broker";
            fromDateTitle = "From Date";
            toDateTitle = "To Date";
	    addmail = " Add E-mail ";
	    save = " Save ";
	    all = " All ";
	    clntCls = " Classification ";
            group = "Group";
            DetailedCustomerReport = "Detailed Customer Report";
            Search = "Search";
            interCodeStr = "Broker";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            supplierListTitles[0] = "اسم العميل";
            supplierListTitles[1] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            supplierListTitles[2] = "&#1578;&#1581;&#1585;&#1610;&#1585;";
            supplierListTitles[3] = "&#1581;&#1584;&#1601;";
            clientStatus = "حالة العميل";
            clientProject = "المشروع";
            clientArea = "المنطقة";
            clientJob = "بروكر";
            fromDateTitle = "من تاريخ";
            toDateTitle = "إلي تاريخ";
	    addmail = " إضافة بريد إلكترونى ";
	    save = " حفظ ";
	    all = " الكل ";
	    clntCls = " التصنيف ";
            group = "المجموعة";
            DetailedCustomerReport = " تقرير العملاء المفصل";
            Search = "بحث";
            interCodeStr = "وسيط";
        }
        
	WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

	GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
	
	String up = request.getAttribute("up") != null ? (String) request.getAttribute("up") : "";
    
	
        String searchType = request.getAttribute("searchType") != null ? (String) request.getAttribute("searchType") : "";
    %>
    <script  type="text/javascript">
	
        /*function switchOnOFF(){
            var clntBrthDt=$("#clntBrthDt").val();
            var clntEmail=$("#clntEmail").val();
            if(clntBrthDt==="on"){
                //$("#clntEmail").val("off").change;
                 $("#clntEmail").prop("checked",false);
                
            }else if(clntEmail==="on"){
                //$("#clntBrthDt").val("off").change;
                 $("#clntBrthDt").prop("checked",false);
                
            }
        }*/
        
        function deleteBookmark(obj, bookmarkId, clientId) {
            $.ajax({
                type: "post",
                url: "<%=context%>/BookmarkServlet?op=DeleteAjax&key=" + bookmarkId,
                data: {
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        $('#bookmarked' + clientId).css("display", "none");
                        $('#unbookmarked' + clientId).css("display", "block");
                    }
                }
            });
        }
        function exportToExcel() {
       var searchType=$("input:radio[name=searchType]:checked").val();
            var url = "<%=context%>/ReportsServlet?op=exportClientsToExcel&fromDate=" + $("#fromDate").val()
                    + "&toDate=" + $("#toDate").val() + "&clientStatus=" + $("#clientStatus").val()+"&searchType=" +searchType
                    + "&clientProject=" + $("#clientProject").val()// + "&clientArea=" + $("#clientArea").val()
                    + "&clientJob=" + $("#clientJob").val() + "&groupID=" + $("#groupID").val() + "&interCode=" + $("#interCode").val();
            if ($("#clientStatus").val() === "12") {
                url += "&mainClientRate=" + $("#mainClientRate").val();
            }
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
        }
        function popupCreateBookmark(obj, clientId) {
            $("#createMsg").hide();
            $("#saveBookmark").show();
            $('#createBookmark').find("#title").val("");
            $('#createBookmark').find("#details").val("");
            $('#clientId').val(clientId);
            $('#createBookmark').css("display", "block");
            $('#createBookmark').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
        function closePopup(obj) {
            $(obj).bPopup().close();
        }
        function createBookmark(obj, clientId, clientName) {
            //var title = "UL";//$(obj).parent().parent().parent().find('#title').val();
            var details = "UL";//$(obj).parent().parent().parent().find('#details').val();
//            var clientId = $(obj).parent().parent().parent().find('#clientId').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/BookmarkServlet?op=CreateAjax&issueId=" + clientId + "&issueType=CLIENT",
                data: {
                    issueId: clientId,
                    issueTitle: clientName,
                    bookmarkText: details
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        $("#bookmarkImg" + clientId).prop("title", details);
                        $("#createMsg").show();
                        $("#saveBookmark").hide();
                        $("#bookmarked" + clientId).removeAttr("onclick");
                        $("#bookmarked" + clientId).click(function() {
                            deleteBookmark(this, info.bookmarkId, clientId);
                        });
                        $('#bookmarked' + clientId).css("display", "block");
                        $('#unbookmarked' + clientId).css("display", "none");
                    }
                    else {
                    }
                }
            });
        }
        function selectAll(obj) {
            $("input[name='clientID']").prop('checked', $(obj).is(':checked'));
        }
        function insertAllSelected() {
            // For Email
            var mailsList = $("[name='toMails']", window.opener.document);
            var checkList = $("[name='clientID']:checked");
            if(mailsList != 'undefined') {
                checkList.each(function(){
                    var clientID = this.value;
                    if($("#email" + clientID).val() != '') {
                        if($("#toMails option[value='"+ $("#email" + clientID).val() +"']", window.opener.document).length == 0){
                            mailsList.append("<option value='" + $("#email" + clientID).val() + "'>" + $("#email" + clientID).val() + "</option>");
                        }
                    }
                });
                opener.selectAllItems();
            }
            // For SMS
            var mobilesList = $("[name='toMobiles']", window.opener.document);
            if(mobilesList != 'undefined') {
                checkList.each(function(){
                    var clientID = this.value;
                    if($("#mobile" + clientID).val() != '') {
                        if($("#toMobiles option[value='"+ $("#mobile" + clientID).val() +"']", window.opener.document).length == 0){
                            mobilesList.append("<option value='" + $("#mobile" + clientID).val() + "'>" + $("#mobile" + clientID).val() + "</option>");
                        }
                    }
                });
                opener.selectAllItems();
            }
        }
        $(function() {
            $("#fromDate, #toDate").datepicker({
                changeMonth: true,
                changeYear: true,
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
	    
	    try {
		$("#mainClientRate").msDropDown();
	    } catch (e) {
		alert(e.message);
	    }
	    
	    if($("#clientStatus option:selected").val() == "12"){
		    $("#clsTR").fadeIn();
		} else {
		    $("#clsTR").hide();
		}
        });
	
	function chngMail(clntID){
		$("#updateMail").bPopup();
		$('#updateMail').css("display", "block");
		
		$("#nwClntEmail").val(clntID);
	    }
	    
	    function closePopup(){
		$("#updateMail").bPopup().close();
	    }
	    
	    function validateEmail(email){
		var re = /\S+@\S+\.\S+/;
		return re.test(email);
	    }
	    
	    function upMail(){
		var email = $("#nwEmail").val();
		
		if(validateEmail(email)){
		    document.client_update.action = "<%=context%>/ClientServlet?op=getClientsWithDetails&up=1&nwEmail=" + $("#nwEmail").val() + "&nwClntEmail=" + $("#nwClntEmail").val();
		    document.client_update.submit();
		} else {
		    alert(" Please, Edit E-mail Format To urmail@yahoo.com ");
		}
	    }
	    
	    function getClassification(){
		if($("#clientStatus option:selected").val() == "12"){
		    $("#clsTR").fadeIn();
		} else {
		    $("#clsTR").hide();
		}
	    }
    </script>
    <body>
	<form name="client_update" id="client_update" method="post">
        <fieldset align=center class="set" style="width: 95%;padding: 10px;">
            <LEGEND style="font-size: 20px;">
                <span  style="display: <%=forPopup != null && forPopup.equals("true") ? "none" : ""%>;"><%=DetailedCustomerReport%></span>
                <span  style="display: <%=forPopup != null && forPopup.equals("true") ? "" : "none"%>;">أختيار العملاء</span>
            </LEGEND>
	    
	    <%
		if (up.equals("1")) {
	    %>
		<div style="margin-left: auto;margin-right: auto;color: green;"> تم التعديل بنجاح </div>
	    <%
		} else if (up.equals("0")) {
	    %>
		<div style="margin-left: auto;margin-right: auto;color: red;">لم يتم التعديل</div>
	    <%
		}
	    %>
		    
            </br>
            <form id="client_form" action="<%=context%>/ClientServlet" method="post">
                <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=fromDateTitle%></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><%=toDateTitle%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="width: 180px;" readonly/>
                            <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="width: 180px;" readonly/>
                            <br/><br/>
                        </td>
                    </tr>
                    <!--TR>

                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="33%">
                            <b><font size=3 color="white"><1%=clientStatus%></b>
                        </TD>
                        <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="33%">
                            <b> <font size=3 color="white"><1%=clientProject%></b>
                        </TD>
                    </TR>
                    <TR>
                        <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                            <select style="font-size: 14px;font-weight: bold; width: 180px;" id="clientStatus" name="clientStatus" onchange="getClassification()">
                                <option value="all" selected><1%=all%></option>
                                <1sw:WBOOptionList wboList='<1%=clientStatusList%>' displayAttribute = "arDesc" valueAttribute="id" scrollToValue="<1%=selectedStatus%>"/>
                            </select>
                            <input type="hidden" name="op" value="getClientsWithDetails"/>
                            <input type="hidden" name="<1%=forPopup != null && forPopup.equals("true") ? "forPopup" : "forFull"%>" value="true"/>
                        </TD>

                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <select style="font-size: 14px;font-weight: bold; width: 180px;" id="clientProject" name="clientProject">
                                <option value="all"><1%=all%></option>
                                <1sw:WBOOptionList wboList='<1%=projectList%>' displayAttribute = "projectName" valueAttribute="projectID" scrollToValue="<1%=selectedProject%>"/>
                            </select>
                        </td>
                    </TR>
		    <TR style="display: none;" id="clsTR">

                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
			    <font size=3 color="white"> <1%=clntCls%> </b>
			</TD>
			<td bgcolor="#dedede" style="text-align:center" valign="middle" WIDTH="50%">
			    <select style="font-size: 14px; font-weight: bold; width: 90%;" id="mainClientRate" name="mainClientRate">
				    <option value="" selected> <1%=all%> </option>
				    <1%
					for (WebBusinessObject rateWbo : ratesList) {
				    %1>
					    <option value="<1%=rateWbo.getAttribute("projectID")%>" <1%=rateWbo.getAttribute("projectID").equals(request.getAttribute("mainClientRate")) ? "selected" : ""%>  data-image="images/msdropdown/<1%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><1%=rateWbo.getAttribute("projectName")%> </option>
				    <1%
					}
				    %>
				</select>
			</td>
		    </TR>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <font size=3 color="white"> <1%=interCodeStr%> </b>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle" width="50%">
                            <select id="interCode" name="interCode" style="font-size: 14px;font-weight: bold; width: 180px;" >
                                <option value="">الكل</option>
                                <option value="00974" <1%="00974".equals(interCode) ? "selected" : ""%>>00974</option>
                                <option value="00971" <1%="00971".equals(interCode) ? "selected" : ""%>>00971</option>
                                <option value="00966" <1%="00966".equals(interCode) ? "selected" : ""%>>00966</option>
                                <option value="00965" <1%="00965".equals(interCode) ? "selected" : ""%>>00965</option>
                                <option value="00973" <1%="00973".equals(interCode) ? "selected" : ""%>>00973</option>
                                <option value="00968" <1%="00968".equals(interCode) ? "selected" : ""%>>00968</option>
                                <option value="00213" <1%="00213".equals(interCode) ? "selected" : ""%>>00213</option>
                                <option value="00964" <1%="00964".equals(interCode) ? "selected" : ""%>>00964</option>
                                <option value="00967" <1%="00967".equals(interCode) ? "selected" : ""%>>00967</option>
                                <option value="00963" <1%="00963".equals(interCode) ? "selected" : ""%>>00963</option>
                                <option value="00961" <1%="00961".equals(interCode) ? "selected" : ""%>>00961</option>
                            </select>
                        </td>
                    </tr-->
                    <TR>
                        <!--TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="33%">
                            <b> <font size=3 color="white"><%=clientArea%></b>
                        </TD-->
                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b> <font size=3 color="white"><%=clientJob%></b>
                        </TD>
                        <!--TD class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="">
                            <b> <font size=3 color="white"><%=group%></b>
                        </TD-->
                    </TR>
                    <TR>                        
                        <td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="2">
                            <select style="font-size: 14px;font-weight: bold; width: 280px;" id="clientJob" name="clientJob" class="chosen-select-campaign">
                                <option value="all"><%=all%></option>
                                <sw:WBOOptionList wboList='<%=jobList%>' displayAttribute = "campaignTitle" valueAttribute="id" scrollToValue="<%=selectedJob%>"/>
                            </select>
                        </td>
                        <!--td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="">
                            <select style="font-size: 14px;font-weight: bold; width: 180px;" id="groupID" name="groupID" multiple required="true">
                                <option value="all" <1%=groupID.contains("all") ? "selected" : ""%>><1%=all%></option>
                                <1%
                                    for (WebBusinessObject groupWbo : groupsList) {
                                %>
                                <option value="<1%=groupWbo.getAttribute("groupID")%>" <1%=groupID.contains((String) groupWbo.getAttribute("groupID")) ? "selected" : ""%>><1%=groupWbo.getAttribute("groupName")%> </option>
                                <1%
                                    }
                                %>
                            </select>
                        </td-->
                    </TR>
		    <!--tr>
			<td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="2">
                            <input type="radio" id="searchType" name="searchType" value=""<%if(searchType.equals("")){%> checked <%}%> />General Search
                            <br></br>
                            <INPUT type="radio" id="searchType" name="searchType" value="birthday" onclick="onoff();" title="Get Clients Their Birthday This Month" <%if(searchType.equals("birthday")){%> checked <%}%>> Search By Birth Month Regardless
                            <br></br>
                            <INPUT type="radio" id="searchType" name="searchType" value="email" onclick="onoff();" title="Get Clients whom have Emails" <%if(searchType.equals("email")){%> checked <%}%>> Search By Email Regardless
                        </td>
		    </tr-->
                    <tr>
                        <TD STYLE="text-align:center" CLASS="td" colspan="2">  
                            <button type="submit" STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; "><%=Search%><IMG HEIGHT="15" SRC="images/search.gif" ></button>
                            &nbsp;&nbsp;
                            <button type="button" STYLE="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; display: <%=forPopup != null && forPopup.equals("true") ? "none" : ""%>;"
                                    onclick="exportToExcel()">Excel<IMG HEIGHT="15" style="margin-right: 2px; margin-top: 1px;" SRC="images/icons/excel.png" />
                            </button>  
                        </td>
                    </tr>
                </table>
            </form>
            </br>
            <input type="button" onclick="insertAllSelected();" value="أضافة كل العملاء المختارين"
                   style="display: <%=forPopup != null && forPopup.equals("true") ? "" : "none"%>;"/>
            <%
                if(clintsList != null && clintsList.size()!= 0){ 
            %>
            <table id="clients" style="width: 100%;" dir="<%=dir%>">
                <THEAD>
                    <TR >
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Client No
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Client Name
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Mobile 
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Address 
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Client SSN
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Responsible 
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Broker
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Introduced us through
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Status
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            DESCRIPTION
                        </th>
                    </TR>
                </THEAD>
                <tbody>
                    <% for (int x = 0; x < clintsList.size(); x++) {
                            WebBusinessObject wboClient = new WebBusinessObject();
                            wboClient = (WebBusinessObject) clintsList.get(x);
                            //String clientNo = (String) wboClient.getAttribute("clientNO");
                            //String creationTime = (String) wboClient.getAttribute("creationTime");
                            //if (creationTime != null) {
                            //    creationTime = creationTime.substring(0, creationTime.lastIndexOf(":"));
                            //} else {
                            //    creationTime = "";
                            //}
                            //String age = "UL";
//                            String birthDate = "";
//                            if(wboClient.getAttribute("birthDate") != null && ((String) wboClient.getAttribute("birthDate")).contains(" ")) {
//                                birthDate = ((String) wboClient.getAttribute("birthDate")).split(" ")[0];
//                            }
                            //String createdbyName="-";
                            //if(wboClient.getAttribute("createdBy")!=null){
                            //    UserGroupMgr ugroup=UserGroupMgr.getInstance();
                            //    WebBusinessObject uWbo =ugroup.getOnSingleKey("key6", wboClient.getAttribute("createdBy").toString());
                            // createdbyName= uWbo.getAttribute("userName").toString();
                            //        }
                            
                           // try {
                           //     age = wboClient.getAttribute("age").toString();
                           // } catch (Exception ex) {
                           // }
                    %>
                    <tr>
                        <TD>
                            <%=wboClient.getAttribute("client_no")%> 
                        </TD>
                        <td nowrap> 
                            <%=wboClient.getAttribute("name")%> 
                        </td>
                        <tD>
                            <%=wboClient.getAttribute("mobile")%> 
                        </tD>
                        <tD>
                            <%=wboClient.getAttribute("address")%> 
                        </tD>
                        <tD>
                            <%=wboClient.getAttribute("clientssn")%> 
                        </tD>
                        <tD>
                            <%=wboClient.getAttribute("full_name")%> 
                        </tD>
                        <td nowrap>
                            <%=wboClient.getAttribute("campaign_title")%> 
                        </td>
                        <td nowrap>
                            <%=wboClient.getAttribute("englishname")%> 
                        </td>
                        <tD nowrap>
                            <%=wboClient.getAttribute("case_en")%> 
                        </tD>
			<td nowrap>
                            <%=wboClient.getAttribute("description")%> 
			</td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
                <%}%>
            <br/><br/>
        </fieldset>
        <div id="createBookmark"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">ملخص</td>
                        <td style="width: 70%; text-align: left;" >
                            <input type="text" name="title" id="title" value=""/>
                        </td>
                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">تفاصيل</td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="details" > </textarea>
                            <input name="clientId" id="clientId" value="ttt" type="hidden"/>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="حفظ"   onclick="JavaScript: createBookmark(this);" id="saveBookmark"class="login-submit"/></div>
                <div id="progressBookmark" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="createMsg">
                    تم إضافة العلامة
                </div>
            </div>  
        </div>
		
		
		
	<div id="updateMail"  style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
		<div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
		    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
										    -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
										    -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup()"/>
		</div>

		<div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
		    <table  border="0px"  style="width:100%;" class="table">
			<tr>
			    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 40%;">
				<input class="set" type="email" id="nwEmail" name="nwEmail" placeholder=" Add E-mail With Format ahmed@yahoo.com">
				<input type="hidden" id="nwClntEmail" name="nwClntEmail">
			    </td>
			</tr>
		    </table>
		    <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" class="button2 set" value=" <%=save%>"   onclick="upMail();" id="saveClient"class="login-submit"/></div> 
		    <div id="progressClient" style="display: none;">
			<img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
		    </div>
		    <div style="margin: 0 auto;width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold; display: none;" id="createClientMsg">
			تم إضافة البريد الإلكترونى
		    </div>
		</div>
	    </div>
		</FORM>
			    
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            $(document).ready(function() {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[1, "asc"]],
                    "columnDefs": [ {
                        "targets": 0,
                        "orderable": false
                    } ]
                }).fadeIn(2000);

            });var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
                '.chosen-select-rate': {no_results_text: 'No classification found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>
