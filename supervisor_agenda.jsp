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



        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
    </head>
    <STYLE type="text/css" >
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
    </style>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getDefaultRefreshPageInterval();

        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();

        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        String weeksNo = logos.get("weeksNo").toString();
        String showCalendar = metaMgr.getShowCalendar();
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
        String lang, langCode, sLaterJobOrder, sLaterClosedJobOrder, emgIssue, input, output, closedIssue, removed, help, tell, schIssue, printJobOrdersStr;

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

    <script language="javascript" type="text/javascript">
        function limitText(limitField, limitCount, limitNum) {
            clearAlert()
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
            var url = "<%=context%>/ClientServlet?op=show3&cach=" + (new Date()).getTime();
            jQuery('#con1').load(url);
            setInterval(
            function() {
                var url = "<%=context%>/ClientServlet?op=show3&cach=" + (new Date()).getTime();
                jQuery('#con1').load(url);
            }, <%=interval%>); // refresh every 10000 milliseconds


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
            //            document.getElementById("con6").style.display = 'none';
            document.getElementById("con1").style.display = 'block';
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con5").style.display = 'none';
                        document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <%}
            }%>
                    document.getElementById("con4").style.display = 'none';
                    document.getElementById("con3").style.display = 'none';
                    document.getElementById("con2").style.display = 'none';
                    document.getElementById("con7").style.display = 'none';
                    //            document.getElementById("con8").style.display = 'none';
                    document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';

                    //            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
         
                    document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    //            document.getElementById("div8").style.backgroundImage = 'url(images/buttonbg.jpg)';
                }

                function showDev2() {
                    //            document.getElementById("con6").style.display = 'none';
                    document.getElementById("con2").style.display = 'block';
          
                    document.getElementById("con4").style.display = 'none';
                    document.getElementById("con3").style.display = 'none';
                    document.getElementById("con7").style.display = 'none';
                    //            document.getElementById("con8").style.display = 'none';
                    document.getElementById("con1").style.display = 'none';
                    document.getElementById("div2").style.backgroundImage = 'url(images/activeBtn2.jpg)';

                    //            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con5").style.display = 'none';
                        document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <%}
            }%>
                    document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    //            document.getElementById("div8").style.backgroundImage = 'url(images/buttonbg.jpg)';
                }
                function showDev3() {
                    //            var url = "<%=context%>/ClientServlet?op=show2&cach=" + (new Date()).getTime();
                    //             jQuery('#con3').load(url);

                    //            document.getElementById("con6").style.display = 'none';
                    document.getElementById("con3").style.display = 'block';
          
                    document.getElementById("con4").style.display = 'none';
                    document.getElementById("con7").style.display = 'none';
                    document.getElementById("con2").style.display = 'none';
                    //            document.getElementById("con8").style.display = 'none';
                    document.getElementById("con1").style.display = 'none';
                    document.getElementById("div3").style.backgroundImage = 'url(images/activeBtn2.jpg)';

                    //            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con5").style.display = 'none';
                        document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <%}
            }%>
                    document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    //            document.getElementById("div8").style.backgroundImage = 'url(images/buttonbg.jpg)';
                }
                function showDev4() {
                    //            document.getElementById("con6").style.display = 'none';
                    document.getElementById("con4").style.display = 'block';
        
                    document.getElementById("con7").style.display = 'none';
                    document.getElementById("con3").style.display = 'none';
                    //            document.getElementById("con8").style.display = 'none';
                    document.getElementById("con2").style.display = 'none';
                    document.getElementById("con1").style.display = 'none';
                    document.getElementById("div4").style.backgroundImage = 'url(images/activeBtn2.jpg)';

                    //            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con5").style.display = 'none';
                        document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <%}
            }%>
                    document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    //            document.getElementById("div8").style.backgroundImage = 'url(images/buttonbg.jpg)';
                }
      
                function showDev7() {

                    //            document.getElementById("con6").style.display = 'none';
                    document.getElementById("con7").style.display = 'block';
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con5").style.display = 'none';
                        document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        <%}
            }%>
                    document.getElementById("con4").style.display = 'none';
                    document.getElementById("con3").style.display = 'none';
                    document.getElementById("con2").style.display = 'none';
                    document.getElementById("con1").style.display = 'none';
                    //            document.getElementById("con8").style.display = 'none';
                    document.getElementById("div7").style.backgroundImage = 'url(images/activeBtn2.jpg)';

                    //            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
           
                    document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
                }
                function showDev5() {

                    //            document.getElementById("con6").style.display = 'none';
          
            
            
           
        <% if (showCalendar != null && !showCalendar.equals("")) {
                if (showCalendar.equals("0")) {%>
                        document.getElementById("con5").style.display = 'block';
                        document.getElementById("div5").style.backgroundImage = 'url(images/activeBtn2.jpg)';
        <%}
            }%>
                        
                    document.getElementById("con4").style.display = 'none';
                    document.getElementById("con7").style.display = 'none';
            
                    document.getElementById("con3").style.display = 'none';
                    document.getElementById("con2").style.display = 'none';
                    document.getElementById("con1").style.display = 'none';
                    //            document.getElementById("con8").style.display = 'none';
                    document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';

                    //            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            
                    document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
                    document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
                }
    
                function close_Alert(obj){
             
                    $(obj).parent().parent().parent().window('close');
                }
                function printJobOrders() {
                    var url = 'PDFReportServlet?op=printWeeklyJobOrders';
                    openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");

                }
                function showSubMenu(obj){
       
                    var checked=$("#incomingMsg").find(':checkbox:checked');
                    if($(checked).length>1){
                        $("#completeRemove").css("display", "block");
                        $("#completeMove").css("display", "block");
                        $("#multiBookmark").css("display", "block");
                        $("#simpleRemove").css("display", "none");
                        $("#simpleMove").css("display", "none");
                        $("#view").css("display", "none");
                
                    }else{
                        $("#completeRemove").css("display", "none");
                        $("#multiBookmark").css("display", "none");
                        $("#completeMove").css("display", "none");
                        $("#simpleRemove").css("display", "block");
                        $("#simpleMove").css("display", "block");
                        $("#view").css("display", "block");
                    }
                }
        
                //        $("#insertBookmark").click(function() {
                //            alert("dkfhdjh")
                //            var x=$(this).parent().parent().parent().find("#notes").val();
                //               
                //            saveBookmark(x);
                //
                //        });
        
                function sendBookMark(){
             
                    var x=$("#bookmark").find("#notes").val();
             
                    saveBookmark(x);

                }
                function popupCloseO(obj) {
                    $('#closeNote').bPopup();
          
                    $('#closeNote').css("display", "block");

                }
                function clearAlert(){
                    $("#emptyNote").text("");
                }
                function saveBookmark(obj) {
                    //            $(element).parent().attr("id", "bookmarkDiv");
           
                    var compId = $("#businessCompId").val();
                    var note = obj
         
                    if(note.length>0){
             
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/IssueServlet?op=saveBookmark",
                            data: {compId: compId,
                                note: note
                   
                            },
                            success: function(jsonString) {
                                var info = $.parseJSON(jsonString);

                                if (info.status == 'ok') {
                        
                                    $('#bookmark').window('close');
                                    $("#bookmarkDiv").find("#bookmarkImg").attr("class","tt");
                                    $("#bookmarkDiv").find(".tt").attr("src", "images/icons/bookmark_selected.png");
                                    $("#bookmarkDiv").find("#bookmarkImg").attr("onclick","deleteBookmark("+info.bookmarkId+",this)");
                                    //                         $("#bookmarkDiv").find("#bookmarkImg").attr("onclick","deleteBookmark()");
                                    $("#bookmarkDiv").find(".tt").attr("onmouseover", "Tip('" + note+ "', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')");
                                    $("#bookmarkDiv").find(".tt").attr("onMouseOut", "UnTip()");
                                    $("#incomingMsg").find(".case:checkbox:checked").attr("checked",false);
                                    $("#bookmarkDiv").attr("id", "");
                                    $("#notes").val("");
                                    $("#businessCompId").val();

                                }else{alert("error occur")}
                            }
                        });  }else{
                        $("#emptyNote").text("من فضلك أدخل الملاحظات")
                    }
                }
                function ale(fff){
                    alert(fff)
                }
                function mark(obj, element) {

                    //        alert($(element).attr("class"));
                    //        if($(element).attr("class")==obj){alert("dfndjkfhdj")}
                    $('#bookmark').window('open');
                    $("#businessCompId").val(obj);
                    $("#emptyNote").text("");
                    $(element).parent().attr("id", "bookmarkDiv");
                    $("#bookmark").find("#notes").html('');
                    $("#bookmark").find("#notes").val('');
           
         
          

                }
                function deleteBookmark(element,obj) {
     
                    var bookmarkId = element;
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
                                var val=$(obj).attr("class").valueOf();
                        
                                $(obj).attr("onclick","mark("+val+",this)");
                                $(obj).attr("onMouseOver", "UnTip()");

                                $(obj).attr("src", "images/icons/bookmark_uns.png").fadeIn(1000);

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

        <div >
            <center>
                <!--                <div align="left" STYLE="color:blue;padding-left: 20px">
                                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                                    <input style="width:200px;" type="button" value="<%=sLaterJobOrder%>" onclick="showLaterOrders()" class="button">
                                    <input style="width:200px;" type="button" value="<%=sLaterClosedJobOrder%>" onclick="showLaterClosedOrders()" class="button">
                                    <input style="width:200px;" type="button" value="<%=printJobOrdersStr%>" onclick="printJobOrders()" class="button">            
                                </div>-->

                <div style="border:0px solid gray; width:100%; margin:auto; padding: 10px;margin-bottom: 0px;">


                    <ul id="tabs" class="shadetabs" style="margin-bottom: 0px;margin-right: 21px; ">
                        <% if (showCalendar != null && !showCalendar.equals("")) {
                                if (showCalendar.equals("0")) {%>
                        <li ><a id="div5" style="height: 30px;"href="javascript:showDev5();" ><SPAN style="display: inline-block;padding: 2px;"><%=help%><IMG src="images/icons/ideaa.png" width="22px" height="22px" onclick="javascript:showDev5();"></SPAN></a></li>
                                    <%}
                                        }%>
                        <li style="border-bottom: none;"><a id="div4" style="height: 30px;"href="javascript:showDev4();" ><SPAN style="display: inline-block;padding: 2px;"><%=removed%><IMG src="images/icons/trash.png" width="22px" height="22px" onclick="javascript:showDev4();"></SPAN></a></li>
                        <li style="border-bottom: none;"><a id="div7" style="height: 30px;"href="javascript:showDev7();" ><SPAN style="display: inline-block;padding: 2px;">منهى<IMG src="images/icons/trash.png" width="22px" height="22px" onclick="javascript:showDev7();"></SPAN></a></li>
                        <li style="border-bottom: none;"><a id="div3"  style="height: 30px;"href="javascript:showDev3();" ><SPAN style="display: inline-block;padding: 2px;"><%=closedIssue%><IMG src="images/icons/closedIssue.png" width="22px" height="22px"  onclick="javascript:showDev3();"></SPAN></a></li>
                        <li style="border-bottom: none;"><a id="div2"  style="height: 30px;"href="javascript:showDev2();" ><SPAN style="display: inline-block;padding: 2px;"><%=output%><IMG src="images/icons/out.png" width="22px" height="22px"onclick="javascript:showDev2();"></SPAN></a></li>
                        <li style="border-bottom: none;"><a id="div1"  style="height: 30px;"href="javascript:showDev1();" ><SPAN style="display: inline-block;padding: 2px;"><%=input%><IMG src="images/icons/in.png"width="22px" height="22px"onclick="javascript:showDev1();" ></SPAN></a></li>
                    </ul>
                    <div  dir="rtl" id="con1" style="display:block;border:0px solid gray; width:96%; margin-top: -2px;">
                        <jsp:include page="supervisor_agenda_emg.jsp" flush="true" ></jsp:include>
                    </div>
                    <div  dir="rtl" id="con2" style="display:none;border:0px solid gray; width:96%;margin-top: -2px;">
                        <jsp:include page="supervisor_agenda_outbox.jsp" flush="true"></jsp:include>

                    </div>
                    <div  dir="rtl" id="con3" style="display:none;border:0px solid gray; width:96%; margin-top: -2px;">
                        <jsp:include page="supervisor_agenda_closed.jsp" flush="true" ></jsp:include>
                    </div>
                    <div  dir="rtl" id="con4" style="display:none;border:0px solid gray; width:96%;margin-top: -2px;">
                        <jsp:include page="supervisor_agenda_cancel.jsp" flush="true"></jsp:include>

                    </div>
                    <div  dir="rtl" id="con7" style="display:none;border:0px solid gray; width:96%;margin-top: -2px; ">
                        <jsp:include page="supervisor_agenda_finish.jsp" flush="true"></jsp:include>

                    </div>
                    <% if (showCalendar != null && !showCalendar.equals("")) {
                            if (showCalendar.equals("0")) {%>
                    <div  dir="rtl" id="con5" style="display:none;border:0px solid gray; width:96%;margin: 0px; ">
                        <jsp:include page="calendar.jsp" flush="true"></jsp:include>
                    </div>
                    <%}
                        }%>
                    <br>

                </div>
            </center>
        </div>
        <input type="hidden" id="businessCompId" />
        <input type="hidden" id="divImg" />

        <div id="bookmark" class="easyui-window" data-options="modal:true,closed:true" title="bookmark" style="width:500px;height:auto;padding:10px;text-align: right;overflow: no-display;display: none">
            <div style="">

                <table class="table" style="width:100%;border: none;margin-right: auto;margin-left: auto;margin-bottom: 0px;" dir="rtl" id="data">


                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">ملاحظات</label></TD>
                        <td style="width: 60%;"><form name="myForm">

                                <TEXTAREA name="limitedtextarea" cols="40" rows="5" name="notes" id="notes" maxlength="100"
                                          onKeyDown="limitText(this.form.limitedtextarea, this.form.countdown, 100);" 
                                          onKeyUp="limitText(this.form.limitedtextarea, this.form.countdown, 100);"></TEXTAREA>
                                <b id="emptyNote" style="color: red;font-weight:bold;text-align: right;float: right;margin-top: 5px;"></b>

                        </td>
                    </tr>


                    <input type="hidden" id="mm" />

                </table>
                <div style="width: 70%;text-align: left;margin-left: 10px;margin-top: 0px;font-weight: bold">
                    <font size="1">(الحد الأقصى للحروف :100)
                    عدد الحروف المتبقية <input readonly type="text" name="countdown" size="3" value="100"> حرف </font></form></TD>
                </div>

                <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0 0;">

                    <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:close_Alert(this)">إلغاء</a>
                    <a class="easyui-linkbutton" data-options="name:'removeOk',iconCls:'icon-ok'" id="insertBookmark" onclick="sendBookMark(this)"href="javascript:void(0)">حفظ</a>
                    <a class="easyui-linkbutton" data-options="name:'removeOk',iconCls:'icon-ok'" id="multiMark" onclick="saveMultiBookmark(this)"href="javascript:void(0)" style="display:none;">حفظ</a>
                </div>
            </div>

        </div>

    </BODY>
</HTML>