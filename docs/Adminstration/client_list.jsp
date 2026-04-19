<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Departments List</TITLE>
        <link rel="stylesheet" href="css/demo_table.css">
        <link rel="stylesheet" href="css/jquery-ui.css">
        <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script type="text/javascript" src="js/handlebars.js" ></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="treemenu/page_style.css" />
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script> 
        <script type="text/javascript"  src="js/jqueryForm.js"></script>
        <style type="text/css">
            .remove{

                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);

            }
            #showHide{
                /*background: #0066cc;*/
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
                /*height:20px;*/
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
                /*display: none;*/
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                /*        width:30%;*/
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

                /*margin: 3px -22px 0 0;*/
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
                /*left: 0px;*/
                /*        z-index: 1000;*/
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
                /*left: 0px;*/
                /*        z-index: 1000;*/
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
                /*        background-color: #dedede;*/
                margin-left: auto;
                margin-right: auto;
                margin-bottom: 5px;
                color:#005599;
                /*            height:600px;*/
                width:98%;
                /*position:absolute;*/
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
                /**/
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
                /**/
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
                /*        background-position: top right;*/
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
                /*        background-position: top right;*/
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

                /*position:absolute;*/

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

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        //AppConstants appCons = new AppConstants();

        String[] supplierAttributes = {"name"};
        String[] supplierListTitles = new String[4];
        UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
        int s = supplierAttributes.length;
        int t = s + 3;
        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;



        Vector supplierList = new Vector();

        List clintsList = (ArrayList) request.getAttribute("data");

        ArrayList<WebBusinessObject> clientStatusList = (ArrayList<WebBusinessObject>) request.getAttribute("clientStatusList");
        ArrayList<WebBusinessObject> areaList = (ArrayList<WebBusinessObject>) request.getAttribute("areaList");
        ArrayList<WebBusinessObject> projectList = (ArrayList<WebBusinessObject>) request.getAttribute("projectList");
        ArrayList<WebBusinessObject> jobList = (ArrayList<WebBusinessObject>) request.getAttribute("jobList");
        String selectedStatus = "";
        if (request.getAttribute("selectedStatus") != null) {
            selectedStatus = (String) request.getAttribute("selectedStatus");
        }
        String selectedProject = "";
        if (request.getAttribute("selectedProject") != null) {
            selectedProject = (String) request.getAttribute("selectedProject");
        }
        String selectedArea = "";
        if (request.getAttribute("selectedArea") != null) {
            selectedArea = (String) request.getAttribute("selectedArea");
        }
        String selectedJob = "";
        if (request.getAttribute("selectedJob") != null) {
            selectedJob = (String) request.getAttribute("selectedJob");
        }
        
        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;
        String bgColorm = null;

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String action = "delete";

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel, TT, IG, AS, QS, BO, CD, PN, NAS, PL;
        String attachDoc, viewAttach, noviewAttach;
        String clientStatus, clientProject, clientArea, clientJob;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "Delete Schedule - Are you Sure ?";
            save = "Delete";
            cancel = "Back To List";
            TT = "Task Title ";
            IG = "Indicators guide ";
            AS = "Active Site by Equipment";
            NAS = "Non Active Site";
            QS = "Quick Summary";
            BO = "Basic Operations";
            supplierListTitles[0] = "Client Name";
            supplierListTitles[1] = "View";
            supplierListTitles[2] = "Edit";
            supplierListTitles[3] = "Delete";
            CD = "Can't Delete Site";
            PN = "Clients  No.";
            PL = "Clients Report";
            attachDoc = "Attach document";
            viewAttach = "View attachments";
            noviewAttach = "No attached documents";
            clientStatus = "Client Status";
            clientProject = "Project";
            clientArea = "Area";
            clientJob = "Job";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            tit = " &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
            save = " &#1573;&#1581;&#1584;&#1601;";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            IG = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
            AS = "&#1605;&#1608;&#1602;&#1593; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            NAS = "&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            QS = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            BO = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
            supplierListTitles[0] = "اسم العميل";
            supplierListTitles[1] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            supplierListTitles[2] = "&#1578;&#1581;&#1585;&#1610;&#1585;";
            supplierListTitles[3] = "&#1581;&#1584;&#1601;";
            CD = " &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            PN = "عدد العملاء";
            PL = "تقرير العملاء";
            attachDoc = "&#1571;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
            viewAttach = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
            noviewAttach = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
            clientStatus = "حالة العميل";
            clientProject = "المشروع";
            clientArea = "المنطقة";
            clientJob = "الوظيفة";
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
    %>
    <script  type="text/javascript">


        function reloadAE(nextMode) {

            var url = "<%=context%>/ajaxGetItrmName?key=" + nextMode;
            if (window.XMLHttpRequest)
            {
                req = new XMLHttpRequest();
            }
            else if (window.ActiveXObject)
            {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post", url, true);
            req.onreadystatechange = callbackFillreload;
            req.send(null);

        }

        function callbackFillreload() {
            if (req.readyState == 4)
            {
                if (req.status == 200)
                {
                    window.location.reload();
                }
            }
        }

        function changeMode(name) {
            if (document.getElementById(name).style.display == 'none') {
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
        function openDoc() {

        }

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
//            $.ajax({
//                type: "post",
//                url: "<%=context%>/ReportsServlet?op=exportClientsToExcel",
//                data: {
//                },
//                success: function(jsonString) {
//                    var info = $.parseJSON(jsonString);
//                    if (info.status == 'ok') {
//                      
//                    }
//                }
//            });
            var url = "<%=context%>/ReportsServlet?op=exportClientsToExcel";
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
        function createBookmark(obj) {
            var title = $(obj).parent().parent().parent().find('#title').val();
            var details = $(obj).parent().parent().parent().find('#details').val();
            var clientId = $(obj).parent().parent().parent().find('#clientId').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/BookmarkServlet?op=CreateAjax&issueId=" + clientId + "&issueType=CLIENT",
                data: {
                    issueId: clientId,
                    issueTitle: title,
                    bookmarkText: details
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        $("#bookmarkImg" + clientId).prop("title", details);
                        $("#createMsg").show();
                        $("#saveBookmark").hide();
                        $("#bookmarked" + clientId).removeAttr("onclick");
                        $("#bookmarked" + clientId).click(function(){
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
    </script>
    <body>
        <fieldset align=center class="set" style="width: 80%;padding: 10px;">
            <LEGEND style="font-size: 20px;">تقرير العملاء</LEGEND>
            </br>
            <form id="client_form" action="<%=context%>/ClientServlet" method="post">
                <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                    <TR>

                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="33%">
                            <b><font size=3 color="white"><%=clientStatus%></b>
                        </TD>
                        <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="33%">
                            <b> <font size=3 color="white"><%=clientProject%></b>
                        </TD>
                    </TR>
                    <TR>

                        <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                            <select style="font-size: 14px;font-weight: bold;" id="clientStatus" name="clientStatus" >
                                <option value="all">الكل</option>
                                <sw:WBOOptionList wboList='<%=clientStatusList%>' displayAttribute = "arDesc" valueAttribute="id" scrollToValue="<%=selectedStatus%>"/>
                            </select>
                            <input type="hidden" name="op" value="ListClients"/>
                        </TD>

                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <select style="font-size: 14px;font-weight: bold;" id="clientProject" name="clientProject">
                                <option value="all">الكل</option>
                                <sw:WBOOptionList wboList='<%=projectList%>' displayAttribute = "projectName" valueAttribute="projectID" scrollToValue="<%=selectedProject%>"/>
                            </select>
                        </td>
                    </TR>
                    <TR>
                        <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="33%">
                            <b> <font size=3 color="white"><%=clientArea%></b>
                        </TD>
                        <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="33%">
                            <b> <font size=3 color="white"><%=clientJob%></b>
                        </TD>
                    </TR>
                    <TR>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <select style="font-size: 14px;font-weight: bold;" id="clientArea" name="clientArea">
                                <option value="all">الكل</option>
                                <sw:WBOOptionList wboList='<%=areaList%>' displayAttribute = "projectName" valueAttribute="projectID" scrollToValue="<%=selectedArea%>"/>
                            </select>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <select style="font-size: 14px;font-weight: bold;" id="clientJob" name="clientJob">
                                <option value="all">الكل</option>
                                <sw:WBOOptionList wboList='<%=jobList%>' displayAttribute = "tradeName" valueAttribute="tradeId" scrollToValue="<%=selectedJob%>"/>
                            </select>
                        </td>
                    </TR>
                    <tr>
                        <TD STYLE="text-align:center" CLASS="td" colspan="2">  
                            <button type="submit" STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                            &nbsp;&nbsp;
                            <button type="button" STYLE="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; "
                                    onclick="exportToExcel()">Excel<IMG HEIGHT="15" SRC="images/search.gif" >
                            </button>  
 
                        </td>
                    </tr>
                </table>
            </form>
            </br>
            <table id="clients" style="width: 100%;" dir="rtl">

                <THEAD>
                    <TR >
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                        </th>
                        
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <B>رقم العميل</B>
                        </th>

                        <%
                            String columnColor = new String("");
                            String columnWidth = new String("");
                            String font = new String("");
                            for (int i = 0; i < t; i++) {
                                if (i == 2) {
                                } else {
                        %>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <B><%=supplierListTitles[i]%></B>
                        </th>
                        <%
                                }
                            }
                        %>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <B><%=attachDoc%></B>
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <B><%=viewAttach%></B>
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                        </th>
                    </TR>
                </THEAD>
                <tbody>
                  <% for (int x=0;x<clintsList.size();x++){
                      WebBusinessObject wboClient = new WebBusinessObject();
                      wboClient = (WebBusinessObject) clintsList.get(x);
                      String clientNo = (String)wboClient.getAttribute("clientNO") ;
                      String age = "UL";
                      try{
                          age = wboClient.getAttribute("age").toString();
                      }catch(Exception ex){
                          
                      }
                  %>  
                
                    
                    <tr>
                        
                        <TD>
                            <a id="bookmarked<%=wboClient.getAttribute("id")%>" href="JavaScript: deleteBookmark(this,'<%=wboClient.getAttribute("markID")%>','<%=wboClient.getAttribute("id")%>');"
                               style="display: <%=wboClient.getAttribute("markID") != null?"block":"none"%>">
                                <image id="bookmarkImg<%=wboClient.getAttribute("id")%>" value="" width="19px" height="19px" src="images/icons/bookmark_selected.png" style="margin: -4px 0"
                                     title="<%=wboClient.getAttribute("bookmarkText") != null?wboClient.getAttribute("bookmarkText"):""%>"/>
                            </a>
                               <a id="unbookmarked<%=wboClient.getAttribute("id")%>" href="JavaScript: popupCreateBookmark(this,'<%=wboClient.getAttribute("id")%>');"
                               style="display: <%=wboClient.getAttribute("markID") == null?"block":"none"%>">
                                <image id="unbookmarkImg<%=wboClient.getAttribute("id")%>" value="" width="19px" height="19px" src="images/icons/bookmark_uns.png" style="margin: -4px 0" />
                            </a>
                        </TD>

                        <TD>
                            <%--  --%>
                            <A  HREF="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wboClient.getAttribute("id").toString()%>&clientType=<%=age%>" style="color: #27272A" >
                                <%=clientNo%>

                            </A>

                        </TD>

                        <TD >
                            <%-- HREF="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wboClient.getAttribute("id").toString()%>&clientType=<%=wboClient.getAttribute("age").toString()%>"--%>
                            <A  HREF="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wboClient.getAttribute("id").toString()%>&clientType=<%=age%>" style="color: #27272A" >
                                <%=wboClient.getAttribute("name").toString()%>
                            </A>

                        </TD>
                        <TD >
                            <DIV ID="links">
                                <%--HREF="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wboClient.getAttribute("id").toString()%>&clientType=<%=wboClient.getAttribute("age").toString()%>" --%>
                                <A HREF="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wboClient.getAttribute("id").toString()%>&clientType=<%=age%>" >
                                    <%=supplierListTitles[1]%> 
                                </A>
                            </DIV>
                        </TD>

                        <!--                        <TD >
                                                    <DIV ID="links">
                                                        <A HREF="<%=context%>/ClientServlet?op=GetUpdateForm&clientID={{id}}">
                        <%=supplierListTitles[2]%>
                    </A>
                </DIV>
            </TD>-->
                        <TD >
                            <DIV ID="links">
                                <% if (metaMgr.getCandelete().equals("1")) {%>
                                <A HREF="<%=context%>/ClientServlet?op=ConfirmDeleteClient&clientID=<%=wboClient.getAttribute("id").toString()%>&clientName=<%=wboClient.getAttribute("name").toString()%>&clientNo=<%=wboClient.getAttribute("clientNO").toString()%>">
                                    <%=supplierListTitles[3]%>
                                </A>
                                <input type="hidden" class="clientId" value="{{id}}" />
                                <input type="hidden" class="clientName" value="{{name}}" />
                                <input type="hidden" class="clientNo" value="{{clientNO}}" />
                                <% } else {%>
                                ****
                                <% }%>
                            </DIV>
                        </TD>
                        <TD>
                            <DIV ID="links">
                                <A HREF="<%=context%>/UnitDocWriterServlet?op=attachCustomerFile&equipmentID=<%=wboClient.getAttribute("id").toString()%>&type=client">
                                    <%=attachDoc%>
                                </A>
                            </DIV>
                        </TD>
                        <TD  >
                            <DIV ID="links">
                                <A HREF="<%=context%>/UnitDocReaderServlet?op=ListDoc&equipmentID=<%=wboClient.getAttribute("id")%>&type=client">
                                    <%=viewAttach%>
                                </A>
                            </DIV>
                        </TD>

                        <TD>
                            <a href="report.pdf" id="openDoc">الموقف المالى</a>

                        </TD>


                    </tr>
                    <%}%>
                    
                    
                    </tbody>
                </table>

                <br><br>


                </filedset>
                
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
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="حفظ"   onclick="JavaScript: createBookmark(this);" id="saveBookmark"class="login-submit"/></div>                             </form>
                <!--<div style="clear: both;display: none"></div>-->
                <div id="progressBookmark" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="createMsg">
                    تم إضافة العلامة
                </div>
            </div>  
        </div>
        <script type="text/javascript">
            
            
                    var oTable;
                    var users = new Array();
                    $(document).ready(function() {
    
                        //                if ($("#tblData").attr("class") == "blueBorder") {
                        //                    $("#tblData").bPopup();
                        //                }
              
                        //            $("#clients").css("display", "none");
                        oTable = $('#clients').dataTable({
                            bJQueryUI: true,
                            sPaginationType: "full_numbers",
                            "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                            iDisplayLength: 25,
                            iDisplayStart: 0,
                            "bPaginate": true,
                            "bProcessing": true,
                            "aaSorting": [[ 0, "asc" ]]
    
                        }).fadeIn(2000);
    
                    });
                </script>
    </body>
</html>
