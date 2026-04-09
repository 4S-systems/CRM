<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>

        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
    </head>

    <%
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getDefaultRefreshPageInterval();
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();

        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        String weeksNo = logos.get("weeksNo").toString();

        int dayOfBack = new Integer(weeksNo).intValue() * 7;

        int dayOfWeekValue = weekCalendar.getTime().getDay();
        Calendar beginSecondWeekCalendar = Calendar.getInstance();
        Calendar endSecondWeekCalendar = Calendar.getInstance();
        beginSecondWeekCalendar = (Calendar) weekCalendar.clone();
        endSecondWeekCalendar = (Calendar) weekCalendar.clone();

        beginSecondWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue - dayOfBack);
        endSecondWeekCalendar.add(endWeekCalendar.DATE, -dayOfWeekValue);

        beginWeekCalendar = (Calendar) weekCalendar.clone();
        endWeekCalendar = (Calendar) weekCalendar.clone();

        beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
        endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);

        String stat = (String) request.getSession().getAttribute("currentMode");
        String lang, langCode, sLaterJobOrder, sLaterClosedJobOrder, emgIssue, input, output, closedIssue, removed, help, tell,
                schIssue, printJobOrdersStr;

        if (stat.equals("En")) {
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            sLaterJobOrder = "Delayed Job Orders";
            sLaterClosedJobOrder = "Delayed Closure";
            emgIssue = "Regular";
            schIssue = "Planned";
            printJobOrdersStr = "Print Job Orders";
            input = "input";
            output = "output";
            closedIssue = "closed issue";
            removed = "cancle";
            help = "for help";
            tell = "to tell";

        } else {
            lang = "English";
            langCode = "En";
            sLaterJobOrder = "&#1575;&#1604;&#1605;&#1578;&#1571;&#1582;&#1585;&#1575;&#1578; &#1593;&#1606; &#1575;&#1604;&#1576;&#1583;&#1569;";
            sLaterClosedJobOrder = "&#1575;&#1604;&#1605;&#1578;&#1571;&#1582;&#1585;&#1575;&#1578; &#1593;&#1606; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569;";
            emgIssue = "&#1593;&#1575;&#1583;&#1609;";
            schIssue = "&#1605;&#1580;&#1583;&#1608;&#1604;";
            printJobOrdersStr = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1591;&#1604;&#1576;&#1575;&#1578;";
            input = "&#1575;&#1604;&#1608;&#1575;&#1585;&#1583;";
            output = "&#1575;&#1604;&#1589;&#1575;&#1583;&#1585;";
            closedIssue = "&#1605;&#1594;&#1604;&#1602;";
            removed = "&#1605;&#1604;&#1594;&#1609;";
            help = "&#1608;&#1575;&#1585;&#1583; &#1604;&#1604;&#1605;&#1587;&#1575;&#1593;&#1583;&#1577;";
            tell = "&#1608;&#1575;&#1585;&#1583; &#1604;&#1604;&#1593;&#1604;&#1605;";

        }
    %>

    <script language="javascript" type="text/javascript">
        function limitText(limitField, limitCount, limitNum) {
            if (limitField.value.length > limitNum) {
                limitField.value = limitField.value.substring(0, limitNum);
            } else {
                limitCount.value = limitNum - limitField.value.length;
            }
        }

    </script>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function() {

            $("#select").click(function() {

                $(".cas").attr("checked", this.checked)
                if ($(".cas").attr("checked")) {

//                $("#actionBtn").toggle(1000);

                } else {

//                $("#actionBtn").css("display", "none");
                }
            });
            $(".cas").click(function() {

                if ($(".cas").length == $(".cas:checked").length) {
                    $("#select").attr("checked", "checked");

                } else {
                    $("#select").removeAttr("checked");
//                $("#selectAll").css("background","images/icons/mi.png");
                }
                if ($(".cas:checked").length > 0) {
//                $("#actionBtn").css("display", "block");

                } else {
//                $("#actionBtn").css("display", "none");

                }
            });


            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            var url = "<%=context%>/ClientServlet?op=show&cach=" + (new Date()).getTime();
            jQuery('#con1').load(url);
            setInterval(
                    function() {
                        var url = "<%=context%>/ClientServlet?op=show&cach=" + (new Date()).getTime();
                        jQuery('#con1').load(url);
                    }, <%=interval%>); // refresh every 10000 milliseconds


//            $("#tab").tabs();
//            $(".active").css("background-image","images/buttonbg.jpg");
        });




        function showLaterOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Schedule';

            window.navigate('<%=context%>/SearchServlet?op=StatusProjectList&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }
        function checkSize() {
            var x = document.getElementById('notes');
            return x.value.length <= 30;
        }
        function showLaterClosedOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Finished';

            window.navigate('<%=context%>/SearchServlet?op=getJobOrdersByLateClosed&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function showDev1() {
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con1").style.display = 'block';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';

            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function showDev2() {
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con2").style.display = 'block';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div2").style.backgroundImage = 'url(images/activeBtn2.jpg)';

            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        function showDev3() {
//            var url = "<%=context%>/ClientServlet?op=show2&cach=" + (new Date()).getTime();
//             jQuery('#con3').load(url);

            document.getElementById("con6").style.display = 'none';
            document.getElementById("con3").style.display = 'block';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div3").style.backgroundImage = 'url(images/activeBtn2.jpg)';

            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        function showDev4() {
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con4").style.display = 'block';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div4").style.backgroundImage = 'url(images/activeBtn2.jpg)';

            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        function showDev5() {
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con5").style.display = 'block';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div5").style.backgroundImage = 'url(images/activeBtn2.jpg)';

            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        function showDev6() {
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con6").style.display = 'block';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div6").style.backgroundImage = 'url(images/activeBtn2.jpg)';

            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        function showDev7() {

            document.getElementById("con6").style.display = 'none';
            document.getElementById("con7").style.display = 'block';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div7").style.backgroundImage = 'url(images/activeBtn2.jpg)';

            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function printJobOrders() {
            var url = 'PDFReportServlet?op=printWeeklyJobOrders';
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");

        }

        function mark(obj, element) {

            $(element).parent().attr("id", "bookmarkDiv");
            $("#notes").val("");
            $("#businessCompId").val(obj);
            $('#bookmark').bPopup();
            $('#bookmark').css("display", "block");
            $("#insertBookmark").bind("click", function() {
                saveBookmark();

            });

        }
        function popupCloseO(obj) {
            $('#closeNote').bPopup();
            $('#closeNote').css("display", "block");

        }
        function saveBookmark() {
//            $(element).parent().attr("id", "bookmarkDiv");
            var compId = $("#businessCompId").val();
            var note = $("#notes").val();
            var title = $("#title").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveBookmark",
                data: {compId: compId,
                    note: note,
                    title: title
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {

                        $('#bookmark').css("display", "none");

                        $("#bookmarkDiv").find("#bookmarkImg").attr("src", "images/icons/bookmark_selected.png");
                        $("#bookmarkDiv").find("#bookmarkImg").removeAttr("onclick");
//                         $("#bookmarkDiv").find("#bookmarkImg").attr("onclick","deleteBookmark()");
                        $("#bookmarkDiv").find("#bookmarkImg").attr("onmouseover", "Tip('" + $("#notes").val() + "', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')");
                        $("#bookmarkDiv").find("#bookmarkImg").attr("onMouseOut", "UnTip()");
                        $("#bookmarkDiv").attr("id", "");
                        $("#notes").val("");


                    }
                }
            });
        }
        function deleteBookmark(obj) {
            var bookmarkId = $(obj).val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=deleteBookmark",
                data: {
                    bookmarkId: bookmarkId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(obj).removeAttr("src");

                        $(obj).attr("onMouseOver", "UnTip()");

                        $(obj).attr("src", "images/icons/bookmark_uns.png");

                    }
                }
            });
        }
    </SCRIPT>
    <style>
        #tabs li{
            display: inline;
        }
        #tabs li a{

            text-align:center; font:bold 15px;
            display:inline;
            text-decoration:none;
            padding-right:20px;
            padding-left:20px;
            padding-bottom:0;
            margin:0px;
            font-size: 15px;
            background-image:url(images/buttonbg.jpg);       
            background-repeat: repeat-x;
            background-position: bottom;
            color:#069;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        #tabs li a:hover{
            background-color:#FFF;
            color:#069; 
        }
        .button_close{
            width:76px;
            height:35px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/close_.png);
        }

        .button_redirec{
            width:85px;
            height:40px;
            /*margin-right: 90px;*/
            border: none;
            background-repeat: no-repeat;
            cursor: pointer;

            background-position: right top ;
            /*display: inline-block;*/
            background-color: transparent;
            background-image:url(images/buttons/button2.png);
        }
        .button_remove{
            width:85px;
            height:40px;
            margin: 0px;

            /*margin-right: 90px;*/
            border: none;
            background-repeat: no-repeat;
            cursor: pointer;

            background-position: right top ;
            /*display: inline-block;*/
            background-color: transparent;
            background-image:url(images/buttons/button3.png);
        }
        .turn_off{
            width:85px;
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
            background-image:url(images/buttons/button5.png);
        }
        .save{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .remove{

            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);

        }
    </style>
    <BODY>     

        <div style="height: 200px;">

        </div>

    </BODY>
</HTML>