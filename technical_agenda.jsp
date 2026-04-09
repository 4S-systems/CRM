<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8" %>

<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <!--        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>-->
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <!--<script type="text/javascript" src="js/wz_tooltip.js"></script>-->
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String showCalendar = metaMgr.getShowCalendar();
        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
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
            help = "اليوميات";
            tell = "&#1608;&#1575;&#1585;&#1583; &#1604;&#1604;&#1593;&#1604;&#1605;";


        }
    %>



    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function() {
            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
        })
        function showLaterOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Schedule';

            window.navigate('<%=context%>/SearchServlet?op=StatusProjectList&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function showLaterClosedOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Finished';

            window.navigate('<%=context%>/SearchServlet?op=getJobOrdersByLateClosed&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function showDev1() {
            //            document.getElementById("con4").style.display = 'none';
            
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con3").style.display = 'none';
        <%}
            }%>

           
                    document.getElementById("con2").style.display = 'none';
                    document.getElementById("con1").style.display = 'block';
                    document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
                    //            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <%}
            }%>
                 


                }

                function showDev2() {
                    //            document.getElementById("con4").style.display = 'none';
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con3").style.display = 'none';
        <%}
            }%>
                    document.getElementById("con2").style.display = 'block';
                    document.getElementById("con1").style.display = 'none';
                    document.getElementById("div2").style.backgroundImage = 'url(images/activeBtn2.jpg)';
                    //            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <%}
            }%>

                }
                function showDev3() {
                    //            document.getElementById("con4").style.display = 'none';
                   
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con3").style.display = 'block';
        <%}
            }%>
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("div3").style.backgroundImage = 'url(images/activeBtn2.jpg)';
        <%}
            }%>
                    document.getElementById("con2").style.display = 'none';
                    document.getElementById("con1").style.display = 'none';
                 
                    //            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
                }


                function printJobOrders() {
                    var url = 'PDFReportServlet?op=printWeeklyJobOrders';
                    openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");

                }
                function mark(obj, element) {

                    $(element).parent().attr("id", "bookmarkDiv");
                    $("#notes").val("");
                    $("#businessCompId").val(obj);
                    alert($("#businessCompId").val());
                    $('#bookmark').window('open');
                    $('#bookmark').css("display", "block");
                    $("#insertBookmark").bind("click", function() {
                        saveBookmark(obj);

                    });

                }

                function saveBookmark(obj) {
                    //            $(element).parent().attr("id", "bookmarkDiv");
                    var compId = $("#businessCompId").val();
                    alert(compId)
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
    </style>
    <BODY>     

        <div >
            <center>

                <div style="border:0px solid gray; width:100%; margin:auto; padding: 10px;margin-bottom: 0px;">
                    <ul id="tabs" class="shadetabs" style="margin-right:21px;margin-bottom: 0px;">
                        <% if (showCalendar != null && !showCalendar.equals("")) {
                                if (showCalendar.equals("0")) {%>
                        <li ><a id="div3" style="height: 30px;"href="javascript:showDev3();" ><SPAN style="display: inline-block;padding: 2px;"><%=help%><IMG src="images/icons/ideaa.png" width="22px" height="22px" onclick="javascript:showDev3();"></SPAN></a></li>
                                    <%}
                                        }%>


                        <!--<li ><a id="div4" style="height: 30px;"href="javascript:showDev4();" ><SPAN style="display: inline-block;padding: 2px;"><%=tell%><IMG src="images/icons/sound.png" width="22px" height="22px" onclick="javascript:showDev4();"></SPAN></a></li>-->

                        <li ><a id="div2"  style="height: 30px;"href="javascript:showDev2();" ><SPAN style="display: inline-block;padding: 2px;"><%=output%><IMG src="images/icons/out.png" width="22px" height="22px"onclick="javascript:showDev2();"></SPAN></a></li>
                        <li ><a id="div1"  style="height: 30px;"href="javascript:showDev1();" ><SPAN style="display: inline-block;padding: 2px;"><%=input%><IMG src="images/icons/in.png"width="22px" height="22px"onclick="javascript:showDev1();" ></SPAN></a></li>
                    </ul>
                    <div  dir="rtl" id="con1" style="display:block;border:0px solid gray; width:96%; margin: 0px; ">
                        <jsp:include page="technical_agenda_details.jsp" flush="true"></jsp:include>
                    </div>
                    <div  dir="rtl" id="con2" style="display:none;border:0px solid gray; width:96%;margin: 0px; ">
                        <jsp:include page="technical_agenda_details_outbox.jsp" flush="true"></jsp:include>
                    </div>
                    <% if (showCalendar != null && !showCalendar.equals("")) {
                            if (showCalendar.equals("0")) {%>
                    <div  dir="rtl" id="con3" style="display:none;border:0px solid gray; width:96%;margin: 0px; ">
                        <jsp:include page="calendar.jsp" flush="true"></jsp:include>
                    </div>
                    <%}
                        }%>

                    <br>
                    <br>


                </div>
            </center>
        </div>

    </BODY>
</HTML>