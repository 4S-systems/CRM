<%@page import="com.maintenance.db_access.TradeMgr"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.clients.db_access.AppointmentMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.DistributedItemsMgr,java.util.*,java.text.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">    
    <%
        ArrayList units = (ArrayList) request.getAttribute("units");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = (Hashtable) session.getAttribute("logos");

        Calendar calendar = Calendar.getInstance();
        int currentDay = calendar.get(calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(calendar.YEAR);
        int currentMonth = calendar.get(calendar.MONTH);
        //AppConstants appCons = new AppConstants();
        String clientId = (String) request.getAttribute("clientId");
        String clientCompId = (String) request.getAttribute("clientCompId");
        String supervisor = (String) request.getAttribute("supervisor");
        ClientMgr clientMgr = ClientMgr.getInstance();

        WebBusinessObject clientWbo = new WebBusinessObject();
        clientWbo = clientMgr.getOnSingleKey(clientId);
        String clientName = "";
        if (clientWbo != null) {
            clientName = (String) clientWbo.getAttribute("name");
        }

        // String[] itemsAttributes = {"itemCode","itemDscrptn","itemPrice","itemQuantity"};
        String[] itemsAttributes = {"itemCode", "itemName", "itemPrice", "itemQuantity"};
        String[] itemsListTitles = new String[6];

        int s = itemsAttributes.length;
        int t = s + 1;
        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;

        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd HH:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());

        Vector itemsList = (Vector) request.getAttribute("data");

        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel, TT, IG, AS, QS, BO, CD, PN, NAS, PL, none, sCancel;
        String categoryName, sFrom, sTo, titleRow;
        int xAxis, yAxis;
        String finalReport;
        String viewSpareParts, viewLabor, pageTitle, pageTitleTip, viewMaintenanceItems;
        if (stat.equals("En")) {
            xAxis = 0;
            yAxis = 0;
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
            //QS="Quick Summary";
            //BO="Basic Operations";
            itemsListTitles[0] = "serial";
            itemsListTitles[1] = "itemCode";
            itemsListTitles[2] = "itemName";
            itemsListTitles[3] = "itemPrice";
            itemsListTitles[4] = "itemQuantity";
            CD = "Can't Delete Site";
            PN = "Items  No.";
            PL = "The monthly maintenance schedule according to the brand of Equipments";
            none = "NONE";
            sCancel = "Cancel";
            categoryName = "Brand of Machine";
            sFrom = "From";
            sTo = "To";
            titleRow = "Equipment / Date";
            finalReport = "Final Report";
            viewSpareParts = "View required spare parts";
            viewLabor = "View required labor";
            pageTitle = "RPT-RQUIRED-MNTHLY-JO-MAKE-MO-3";
            pageTitleTip = "Monthly Maintenance By Model Report";
            viewMaintenanceItems = "View Maintenance Items";
        } else {
            xAxis = 1100;
            yAxis = 0;
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
            //QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            //BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
            itemsListTitles[0] = "&#1605;&#1587;&#1604;&#1587;&#1604;";
            itemsListTitles[1] = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
            itemsListTitles[2] = "&#1575;&#1604;&#1575;&#1587;&#1605;";
            itemsListTitles[3] = "&#1587;&#1593;&#1585; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
            itemsListTitles[4] = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
            CD = "Can't Delete Site";
            PN = "&#1593;&#1583;&#1583; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            PL = "&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1588;&#1607;&#1585;&#1610;&#1577; &#1591;&#1576;&#1602;&#1575;&#1611; &#1604;&#1605;&#1575;&#1585;&#1603;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            none = "NONE";
            sCancel = tGuide.getMessage("cancel");
            categoryName = "&#1605;&#1575;&#1585;&#1603;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            sFrom = "&#1605;&#1606;";
            sTo = "&#1575;&#1604;&#1609;";
            titleRow = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1577;/ &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            finalReport = "&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
            viewSpareParts = "&#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;";
            viewLabor = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;";
            pageTitle = "RPT-RQUIRED-MNTHLY-JO-MAKE-MO-3";
            pageTitleTip = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1588;&#1607;&#1585;&#1610;&#1607; &#1591;&#1576;&#1602;&#1575; &#1604;&#1605;&#1575;&#1585;&#1603;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
            viewMaintenanceItems = "&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        }

//    WebBusinessObject categoryWbo = (WebBusinessObject) request.getAttribute("categoryWbo");
        Vector daysOfMonth = (Vector) request.getAttribute("daysOfMonth");
        Date beginDate = (Date) request.getAttribute("beginMonth");
        Date endDate = (Date) request.getAttribute("endMonth");
        Hashtable machinForJobList = new Hashtable();
        machinForJobList = (Hashtable) request.getAttribute("scheduleJobs");

        Vector machinList = (Vector) request.getAttribute("machinList");
//    Vector equipByCategory = (Vector) request.getAttribute("equipByCategory");

        String categoryId = (String) request.getAttribute("categoryId");
        String year = (String) request.getAttribute("year");
        String monthOfYear = (String) request.getAttribute("monthOfYear");

        int count = 0;
        int unitFlasg = 0;
    %>


    <head>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

    </head>
    <style type="text/css">
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

            -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
            -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
            box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
            -webkit-border-radius: 20px;
            -moz-border-radius: 20px;
            border-radius: 20px;
        }
        .login1{
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
            background-image: -webkit-gradient(
                linear,
                left top,
                left bottom,
                color-stop(1, #CCCCCC),
                color-stop(1, #EEF0ED),
                color-stop(1, #FFFFFF)
                );
            background-image: -o-linear-gradient(bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            background-image: -moz-linear-gradient(bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            background-image: -webkit-linear-gradient(bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            background-image: -ms-linear-gradient(bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            background-image: linear-gradient(to bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);}
        .save_app{
            width:20px;
            height:20px;
            background-image:url(images/icons/add_event.png);
            background-repeat: no-repeat;
            cursor: pointer;

            float:right;


        }
        .save_app2{
            width:32px;
            height:32px;
            background-image:url(images/icons/add_event.png);
            background-repeat: no-repeat;
            cursor: pointer;



        }
        .show_app{
            width:32px;
            height:32px;
            background-image:url(images/icons/show_event2.png);
            background-repeat: no-repeat;
            cursor: pointer;
            margin-left: auto;
            margin-right: auto;


        }
        .backColor{background: rgb(238,238,238); /* Old browsers */
                   background: -moz-linear-gradient(top,  rgba(238,238,238,1) 0%, rgba(204,204,204,1) 75%); /* FF3.6+ */
                   background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(238,238,238,1)), color-stop(75%,rgba(204,204,204,1))); /* Chrome,Safari4+ */
                   background: -webkit-linear-gradient(top,  rgba(238,238,238,1) 0%,rgba(204,204,204,1) 75%); /* Chrome10+,Safari5.1+ */
                   background: -o-linear-gradient(top,  rgba(238,238,238,1) 0%,rgba(204,204,204,1) 75%); /* Opera 11.10+ */
                   background: -ms-linear-gradient(top,  rgba(238,238,238,1) 0%,rgba(204,204,204,1) 75%); /* IE10+ */
                   background: linear-gradient(to bottom,  rgba(238,238,238,1) 0%,rgba(204,204,204,1) 75%); /* W3C */
                   filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#eeeeee', endColorstr='#cccccc',GradientType=0 ); /* IE6-9 */

        }
        #appointmentTable tbody tr.even:hover, #appointmentTable tbody tr.even td.highlighted {
            background-color: #ECFFB3;
        }

        #appointmentTable tbody tr.odd:hover, #appointmentTable tbody tr.odd td.highlighted {
            background-color: #E6FF99;
        }

        #appointmentTable tr.even:hover {
            background-color: #ECFFB3;
        }

        #appointmentTable tr.even:hover td.sorting_1 {
            background-color: #DDFF75;
        }

        #appointmentTable tr.even:hover td.sorting_2 {
            background-color: #E7FF9E;
        }

        #appointmentTable tr.even:hover td.sorting_3 {
            background-color: #E2FF89;
        }

        #appointmentTable tr.odd:hover {
            background-color: #E6FF99;
        }

        #appointmentTable tr.odd:hover td.sorting_1 {
            background-color: #D6FF5C;
        }

        #appointmentTable tr.odd:hover td.sorting_2 {
            background-color: #E0FF84;
        }

        #appointmentTable tr.odd:hover td.sorting_3 {
            background-color: #DBFF70;
        }
        .num{background: #ffc578; /* Old browsers */
             background: -moz-linear-gradient(top,  #ffc578 0%, #fb9d23 100%); /* FF3.6+ */
             background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ffc578), color-stop(100%,#fb9d23)); /* Chrome,Safari4+ */
             background: -webkit-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Chrome10+,Safari5.1+ */
             background: -o-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Opera 11.10+ */
             background: -ms-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* IE10+ */
             background: linear-gradient(to bottom,  #ffc578 0%,#fb9d23 100%); /* W3C */
             filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffc578', endColorstr='#fb9d23',GradientType=0 ); /* IE6-9 */
             font-weight: bold
        }
        #ta tr td{
            border: none
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
    </style>
    <SCRIPT LANGUAGE="JavaScript" SRC="Library.js" TYPE="text/javascript"></SCRIPT>
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" SRC="js/calendar.js" TYPE="text/javascript"></SCRIPT>
    <SCRIPT LANGUAGE="JavaScript" SRC="js/date-functions.js" TYPE="text/javascript"></SCRIPT>
    <SCRIPT LANGUAGE="JavaScript" SRC="js/datechooser.js" TYPE="text/javascript"></SCRIPT>
    <script src='js/silkworm_validate.js' type='text/javascript'></script>
    <script language="javascript" type="text/javascript">
$(function() {
    $("#users option[value='" + "fghfgf" + "']").prop("selected", true);
})
$(function() {
    //            alert(minDateS)
    //alert('mindate'+minDateS)
    $("#finishEndDate").datetimepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: "yy/mm/dd",
        timeFormat: "hh:mm:ss"
    });
});



$(function() {
    $("#appTime").timepicker({
        controlType: 'select'

    });
});
function popupShowAppointment(obj, userId) {

    $(".submenu1").hide();
    $(".button_pointment").attr('id', '0');
    var month = $("#currentMonth").val();
    var day = $(obj).parent().parent().find("#day").val();
    var pageType = $(obj).parent().find("#pageType").val();
    var year = $("#currentYear").val();
    var currentMonth = (month * 1) + 1;
    var date = year + "/" + currentMonth + "/" + day;
    var url = "<%=context%>/ClientServlet?op=userAppo&userId=" + userId + "&date=" + date + "&pageType=" + pageType;
    $('#show_appointment').load(url);
    $('#show_appointment').css("display", "block");

    $('#show_appointment').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
        speed: 400,
        transition: 'slideDown', modalColor: 'black'});


}
function popupShowClient(obj) {
    $(".hidex").css("display", "none");
    $(".showx").css("display", "block");
    var clientId = $(obj).find("#clientId").val();

    var url = "<%=context%>/ClientServlet?op=showClientInformation&clientId=" + clientId;
    $('#show_client_information').load(url);
    $('#show_client_information').css("display", "block");
    $('#show_client_information').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
        speed: 400,
        transition: 'slideDown', modalColor: 'black'});
}
var issueId, compID, client_id;
function popupFinishO(obj) {
    $("#finishMsg").hide();


    issueId = $(obj).parent().parent().parent().find("#issueId").val();

    compID = $(obj).parent().parent().parent().find("#compId").val();
    client_id = $(obj).parent().parent().parent().find("#clientId").val();

    $('#finish_Note').find("#notes").val("");
    $('#finish_Note').css("display", "block");
    $('#finish_Note').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
        speed: 400,
        transition: 'slideDown'});


}
function finishCom(obj) {
    var notes = $(obj).parent().parent().parent().find('#notes').val();
    var endDate = $(obj).parent().parent().parent().find('#finishEndDate').val();
    $.ajax({
        type: "post",
        url: "<%=context%>/ComplaintEmployeeServlet?op=finishComp&issueId=" + issueId + "&compId=" + compID,
        data: {
            notes: notes,
            clientId: <%=clientId%>,
            endDate: endDate
        },
        success: function(jsonString) {



            var info = $.parseJSON(jsonString);

            if (info.status == 'ok') {
                $("#finishMsg").show();
                $(obj).removeAttr("onclick");

            }
            else {


            }
        }
    });

}
function popupApp(obj) {


    $("#USERID").val($(obj).parent().parent().parent().find("#userID").val());
    $("#currentDay").val($(obj).parent().parent().find("#day").val());

    $("#appTitleMsg").css("color", "");
    $("#appTitleMsg").text("");

    //                $("#appTitle").val("");

    //        alert($(obj).parent().parent().find("#day").text());

    var month = $("#currentMonth").val();
    var day = $(obj).parent().parent().find("#day").text();
    var year = $("#currentYear").val();
    var currentMonth = (month * 1) + 1;
    var date = year + "/" + currentMonth + "/" + day;

    $("#appDate").val(date);
    $("#appNote").val("");
    $("#appMsg").hide();
    $(".submenu1").hide();
    $("#progress").hide();
    $("#appClientName").text("<%=clientName%>");
    $(".button_pointment").attr('id', '0');
    $('#appointment_content').css("display", "block");

    $('#appointment_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
        speed: 400,
        transition: 'slideDown'});



}
function popupApp2(obj) {

    if ($(obj).attr("id") === "active") {
        $(obj).removeAttr("id");
    }
    $(obj).attr("id", "active");


    $("#USERID").val($(obj).parent().parent().parent().find("#userID").val());
    $("#currentDay").val($(obj).parent().parent().find("#day").val());

    $("#appTitleMsg").css("color", "");
    $("#appTitleMsg").text("");

    //                $("#appTitle").val("");

    //        alert($(obj).parent().parent().find("#day").text());

    var month = $("#currentMonth").val();
    var day = $(obj).parent().parent().find("#day").text();
    var year = $("#currentYear").val();
    var currentMonth = (month * 1) + 1;
    var date = year + "/" + currentMonth + "/" + day;

    $("#appDate").val(date);
    $("#appNote").val("");
    $("#appMsg").hide();
    $(".submenu1").hide();
    $("#progress").hide();
    $("#appClientName").text("<%=clientName%>");
    $(".button_pointment").attr('id', '0');
    $('#appointment_content').css("display", "block");

    $('#appointment_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
        speed: 400,
        transition: 'slideDown'});

}
function closePopup(obj) {

    $(obj).parent().parent().bPopup().close();


}
function saveAppo(obj) {



    var clientId = $("#clientId").val();

    $("#appTitleMsg").css("color", "");
    $("#appTitleMsg").text("");

    var title = $(obj).parent().parent().find($("#appTitle")).val();

    var month = $("#currentMonth").val();
    var day = $("#currentDay").val();

    var year = $("#currentYear").val();
    var currentMonth = (month * 1) + 1;
    var date = year + "/" + currentMonth + "/" + day;

    var note = $(obj).parent().parent().parent().find($("#appNote")).val();
    var time = $(obj).parent().parent().parent().find($("#appTime")).val();

    $(obj).parent().parent().parent().parent().find("#progress").hide();
    var userId = $("#USERID").val();

    var clientCompId = $("#clientCompId").val();
    var supervisorId = $("#supervisorId").val();


    var unitId = $("#units").val();

    if (title.length > 0) {
        $(obj).parent().parent().parent().parent().find("#progress").show();
        $.ajax({
            type: "post",
            url: "<%=context%>/ClientServlet?op=saveAppointment",
            data: {
                clientIdx: clientId,
                title: title,
                date: date,
                note: note,
                type: "0",
                userId: userId,
                clientCompId: clientCompId,
                time: time,
                unitId: unitId,
                supervisorId: supervisorId
            },
            success: function(jsonString) {
                var eqpEmpInfo = $.parseJSON(jsonString);
                //                        alert(jsonString);
                //                        alert(eqpEmpInfo);
                if (eqpEmpInfo.status == 'ok') {
                    //                        alert("تم الحفظ");
                    $(obj).parent().parent().parent().parent().find("#appMsg").html("تم التسجيل بنجاح").show();
                    $(obj).parent().parent().parent().parent().find("#progress").hide();


                    if ($("#active").parent().parent().find("#div1")) {

                        $("#active").parent().parent().find("#div2").show();
                        $("#active").parent().parent().find("#div1").remove();
                    } else {


                    }
                } else if (eqpEmpInfo.status == 'no') {

                    $(obj).parent().parent().parent().parent().find("#progress").show();
                    $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();

                }
                else if (eqpEmpInfo.status == 'found') {

                    $(obj).parent().parent().parent().parent().find("#progress").show();
                    $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل").show();
                    alert("تمت الجدولة مسبقا")
                }


            }



        });
    } else {
        $("#appTitleMsg").css("color", "white");
        $("#appTitleMsg").text("أدخل عنوان المقابلة");

    }




}
function clientInformation(obj) {
    $(".hidex").css("display", "none");
    $(".showx").css("display", "block");
    $('#clientInformation').css("display", "block");
    $("#updateBtn").css("display", "none");
    $("#editBtn").css("display", "block");

    $('#clientInformation').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
        speed: 400,
        transition: 'slideDown'});
}
    </script>

    <script type="text/javascript">

        function get_Count(obj, value) {

            var month = $("#currentMonth").val();
            var day = value;
            var year = $("#currentYear").val();
            var currentMonth = (month * 1) + 1;
            var date = year + "/" + currentMonth + "/" + day;

            $("#appDate").val(date);

            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=userAppoNumber",
                data: {
                    userId: $(obj).parent().find("#userID").val(),
                    date: date

                },
                success: function(jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    //                        alert(jsonString);
                    //                        alert(eqpEmpInfo);

                    //                 
                    //                                                                               $(".save_app").html(eqpEmpInfo.number);
                    $(obj).find("#number").html(eqpEmpInfo.number).show();


                }
            });
        }
        function get_Count2(obj, value) {

            var month = $("#currentMonth").val();
            var day = value;
            var year = $("#currentYear").val();
            var currentMonth = (month * 1) + 1;
            var date = year + "/" + currentMonth + "/" + day;
            $("#appDate").val(date);

            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=userAppoNumber",
                data: {
                    userId: $(obj).parent().find("#userId").val(),
                    date: date

                },
                success: function(jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    //                        alert(jsonString);
                    //                        alert(eqpEmpInfo);

                    //                 
                    //                                                                               $(".save_app").html(eqpEmpInfo.number);
                    $(obj).parent().find("#number").html(eqpEmpInfo.number).show();


                }
            });
        }

    </script>
    <script language="javascript" type="text/javascript">
        function getSparePartsReport()
        {
            var url = "<%=context%>/ReportsServlet?op=getMonthlySprPartByTypeReport&categoryId=" +<%=categoryId%> + "&month=" +<%=monthOfYear%> + "&yearNo=" +<%=year%>;
            openWindow(url);
        }

        function getLaborReport()
        {
            var url = "<%=context%>/ReportsServlet?op=getMonthlyLaborByTypeReport&categoryId=" +<%=categoryId%> + "&month=" +<%=monthOfYear%> + "&yearNo=" +<%=year%>;
            openWindow(url);
        }

        function getMaintenanceItemsReport()
        {
            var url = "<%=context%>/ReportsServlet?op=getMonthlyMaintenanceItemsByTypeReport&categoryId=" +<%=categoryId%> + "&month=" +<%=monthOfYear%> + "&yearNo=" +<%=year%>;
            openWindow(url);
        }

        function openWindow(url)
        {
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=650");
        }

    </script>


    <body >
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="part_form" METHOD="POST">
            <div id="finish_Note"  style="width: 40%;display: none;position: fixed">

                <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup(this)"/>
                </div>

                <!--<h1>رسالة قصيرة</h1>-->
                <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                    <table  border="0px" id="ta" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >                



                        <tr>
                            <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإنهاء</label></TD>
                            <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                        </TR>
                        <tr>
                            <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                            <td style="width: 60%;">  <input name="finishEndDate" id="finishEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                        </TR>
                        <tr>
                            <td colspan="2" > <input type="button"  onclick="JavaScript:finishCom(this);" class="button_finis"></TD>
                        </tr>
                        <tr>
                            <td colspan="2" >
                                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="finishMsg">تم الإنهاء بنجاح</>
                            </td>
                        </tr>


                    </TABLE>
                </div>

            </div>


            <div id="show_appointment"  style="width: 80% !important;display: none;margin-left: auto;margin-right: auto;text-align: center;position: fixed ;">

            </div>
            <div id="appointment_content" style="width: 45% !important;display: none;position: fixed;text-align: center;">
                <!--<h1>تحديد مقابلة</h1>-->
                <div style="clear: both;margin-left:83%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup(this)"/>
                </div>

                <!--<h1>رسالة قصيرة</h1>-->
                <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;text-align: center">
                    <table class="table " style="width:100%;text-align: center;">

                        <tr >
                            <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >
                                إسم العميل                           
                            </td>
                            <td width="70%"style="text-align:right;">
                                <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                                <b id="appClientName"></b>
                                <input  type="hidden" id="appTitle" value="service"/>
                                <input type="hidden" id="appDate" value="" />
                                <label id="appTitleMsg"></label>
                            </td>
                        </tr>
                        <!--                            <tr>
                                                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">موضوع المقابلة</td>
                                                        <td  style="text-align:right;width: 70%;">
                        
                        
                                                            
                                                        </td>
                                                    </tr>-->
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الوقت</td>
                            <td  style="text-align:right;width: 70%;">

                                <input readonly="true" type="text" id="appTime" required="true"/>

                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">المنتج</td>
                            <td  style="text-align:right;width: 70%;">

                                <SELECT name="units" STYLE="width:150px;text-align: right; z-index:-1;" id="units">
                                    <sw:WBOOptionList wboList='<%=units%>' displayAttribute = "productName" valueAttribute="projectId"/>
                                </SELECT>
                            </td>
                        </tr>


                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الخدمة</td>
                            <td style="width: 70%;" >

                                <textarea  placeholder="" rows="6" style="width: 100%;resize: none" id="appNote" class="login-input"></textarea>
                            </td>

                        </tr> 

                    </table>

                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="submit" value="حفظ" onclick="javascript: saveAppo(this)" class="login-submit"/></div>
                    <div id="progress" style="display: none;">
                        <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                    </div>

                    <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg"></>
                    </div>
                </div>  
            </div>
            <div style="width: 98%;">


                <TABLE ALIGN="<%=align%>" dir="<%=dir%>"  CELLPADDING="3" CELLSPACING="1" style="width: 90%;">

                    <TR >
                        <td><b><font size="2" color="#000080">#</font></b></td>
                        <td><b><font size="1" color="#000080"><%=titleRow%></font></b></td>
                                <% for (int i = 0; i < daysOfMonth.size(); i++) {
                                        WebBusinessObject dateWbo = (WebBusinessObject) daysOfMonth.get(i);
                                %>
                        <TD HEIGHT="20%" bgcolor="#DBDBDB"  class="firstName" STYLE="border-WIDTH:0; font-size:15px;" >
                            <% String dayOfWeek = dateWbo.getAttribute("dayOfWeek").toString();
                                dayOfWeek = dayOfWeek.substring(0, 3);%>
                            <font size="1.5" color="red"><%=dayOfWeek%></font>
                            <br>
                            <font size="1.5"><B><%=i + 1%></B></font>
                        </TD>
                        <%
                            }
                        %>
                    </TR>  

                    <% String unitId = "";
                        int serial = 0;
                        for (int z = 0; z < machinList.size(); z++) {

                            WebBusinessObject unitWbo = (WebBusinessObject) machinList.get(z);

                    %>



                    <% if (!unitId.equals(unitWbo.getAttribute("userId").toString())) {%>
                    <TR>
                        <td ><b><font size="3" color="#000080"><%=serial + 1%></font></b></td>
                        <TD bgcolor="#DBDBDB"  CLASS="firstname"  STYLE="border-WIDTH:0; font-size:13px;" >
                            <%=unitWbo.getAttribute("userName")%>


                        </TD>
                        <%

                            int month = 0;
                            int y = 0;
                            int minDate = 0;
                            int maxDate = 0;
                            Calendar monthCal = Calendar.getInstance();
                            y = monthCal.getTime().getYear();
                            minDate = monthCal.getActualMinimum(monthCal.DATE);
                            maxDate = monthCal.getActualMaximum(monthCal.DATE);
                            Calendar eqpSchedulesCal = Calendar.getInstance();
                            java.sql.Date beginDate_ = new java.sql.Date(y, month, minDate);
                            java.sql.Date endDate_ = new java.sql.Date(y, month, maxDate);

                            HttpSession s_ = request.getSession();

                            Vector eqpSchedules = new Vector();
                            AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                            eqpSchedules = appointmentMgr.getAppointmentsDates(unitWbo.getAttribute("userId").toString(), beginDate_, endDate_);

                            Vector eqpSchedulesDays = new Vector();
                            String user_id = (String) unitWbo.getAttribute("userId").toString();
                            for (int i = 0; i < eqpSchedules.size(); i++) {

                                WebBusinessObject wbo_ = new WebBusinessObject();
                                wbo_ = (WebBusinessObject) eqpSchedules.elementAt(i);
                                java.sql.Date bDate = (java.sql.Date) wbo_.getAttribute("date");

                                eqpSchedulesCal.setTimeInMillis(bDate.getTime());
                                eqpSchedulesDays.addElement(new Integer(eqpSchedulesCal.getTime().getDate()));
                                System.out.println("Begin Date = " + bDate.toString());
                                System.out.println("Date day month is " + eqpSchedulesCal.getTime().getDate());
                            }
                            String cellValue = "";
                            Calendar periodicalCalendar = Calendar.getInstance();
                            y = periodicalCalendar.getTime().getYear() + 1900;

                            int date = 0;
                            int day = 0;
                            date = periodicalCalendar.getTime().getDate();

                            minDate = periodicalCalendar.getActualMinimum(Calendar.DATE);
                            maxDate = periodicalCalendar.getActualMaximum(Calendar.DATE);
                            periodicalCalendar.set(periodicalCalendar.WEEK_OF_MONTH, 1);
                            periodicalCalendar.set(periodicalCalendar.DATE, 1);
                            int startPeriodDay = 0;
                            boolean gotCell = false;
                            startPeriodDay = periodicalCalendar.getTime().getDay();
                            String[] dayName = {"Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
                            String startPeriodDayName = "";
                            for (int i = 0; i < daysOfMonth.size(); i++) {
                                if (startPeriodDay == 6) {
                                    startPeriodDayName = dayName[0];
                                } else {
                                    startPeriodDayName = dayName[startPeriodDay + 1];
                                }

                                if (minDate <= maxDate) {
                                    cellValue = new Integer(minDate).toString();
                                    minDate = minDate + 1;
                                } else {
                                    cellValue = "0";
                                }
                                int x;

                                x = Integer.parseInt(cellValue);
                                if (x >= currentDay) {

                        %>
                        <TD   STYLE="width: 10%;height:75px;background: rgb(178,225,255); /* Old browsers */
                              background: -moz-linear-gradient(top,  rgba(178,225,255,1) 0%, rgba(102,182,252,1) 100%); /* FF3.6+ */
                              background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(178,225,255,1)), color-stop(100%,rgba(102,182,252,1))); /* Chrome,Safari4+ */
                              background: -webkit-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Chrome10+,Safari5.1+ */
                              background: -o-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Opera 11.10+ */
                              background: -ms-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* IE10+ */
                              background: linear-gradient(to bottom,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* W3C */
                              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b2e1ff', endColorstr='#66b6fc',GradientType=0 ); /* IE6-9 */


                              " 

                              >


                            <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> 

                            <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count(this,<%=cellValue%>)">

                                <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                </div>
                            </div>
                            <input type="hidden" id="userID" value="<%=user_id%>" />
                            <input type="hidden" id="day" value="<%=cellValue%>" />
                            <div style="width: 100%;height: 55%;" onmouseover="get_Count2(this,<%=cellValue%>)">




                                <div class="save_app" onclick="popupApp(this)"></div>
                                <input type="hidden" id="pageType" value="1"/> 
                                <div class="show_app" onclick="popupShowAppointment(this,<%=user_id%>)"> </div>

                            </div>


                            <%} else {%>



                            <div style="width: 100%;margin-top: 0px;height: 45%;" >

                                <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                </div>
                                <!--<input  type="button" value="show" onclick="popupShowAppointment(this)"/>-->
                            </div>
                            <div style="width: 100%;height: 55%;" id="div1">
                                <div  class="save_app" onclick="popupApp2(this)" style="margin-left: auto;margin-right: auto;" ></div>

                            </div>
                            <input type="hidden" id="userID" value="<%=user_id%>" />
                            <input type="hidden" id="day" value="<%=cellValue%>" />
                            <div style="width: 100%;height: 55%;display: none" onmouseover="get_Count2(this,<%=cellValue%>)" id="div2">




                                <div class="save_app" onclick="popupApp(this)"></div>
                                <input type="hidden" id="pageType" value="1"/> 
                                <div class="show_app" onclick="popupShowAppointment(this,<%=user_id%>)"v> </div>

                            </div>

                            <%}%>

                        </TD>

                        <%} else {%>
                        <TD class="backColor" STYLE="height:75px;width:75px;" 
                        <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> background="images/schedule.jpg"<%} else {%> background="" <%}%>
                            >

                            <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> 

                            <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">

                                <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                </div>
                            </div>
                            <input type="hidden" id="userID" value="<%=user_id%>" />
                            <input type="hidden" id="day" value="<%=cellValue%>" />
                            <div style="width: 100%;height: 55%;margin-right: auto;margin-left: auto" onmouseover="get_Count2(this,<%=cellValue%>)">
                                <input type="hidden" id="pageType" value="1"/> 
                                <div  class="show_app" onclick="popupShowAppointment(this,<%=user_id%>)" onmouseover="get_Count2(this,<%=cellValue%>)"></div>

                            </div>


                            <%} else {%>
                            <input type="hidden" id="userID" value="<%=user_id%>" />
                            <input type="hidden" id="day" value="<%=cellValue%>" />
                            <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">


                            </div>
                            <div style="width: 100%;height: 55%;">
                                <!--<input type="button" value="adds" onclick="popupApp(this)"/>-->

                            </div>
                            <%}
                                }%>


                        </TD>
                        <!--                        <TD   STYLE=";height:75px;width:75px;background: rgb(178,225,255); /* Old browsers */
                                                      background: -moz-linear-gradient(top,  rgba(178,225,255,1) 0%, rgba(102,182,252,1) 100%); /* FF3.6+ */
                                                      background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(178,225,255,1)), color-stop(100%,rgba(102,182,252,1))); /* Chrome,Safari4+ */
                                                      background: -webkit-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Chrome10+,Safari5.1+ */
                                                      background: -o-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Opera 11.10+ */
                                                      background: -ms-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* IE10+ */
                                                      background: linear-gradient(to bottom,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* W3C */
                                                      filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b2e1ff', endColorstr='#66b6fc',GradientType=0 ); /* IE6-9 */
                        
                        
                                                      "
                        
                                                      >
                        
                        
                        
                        
                                                    <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count(this,<%=cellValue%>)">
                        <% String num = "";
                            String number = "";
                        %>
                        <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                        </div>
                    </div>

                    <input type="hidden" id="userID" value="<%=user_id%>" />
                    <input type="hidden" id="day" value="<%=cellValue%>" />

                    <div style="width: 100%;height: 55%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                        <div class="save_app" onclick="popupApp(this)"></div>
                        <input type="hidden" id="pageType" value="1"/> 
                        <div class="show_app" onclick="popupShowAppointment(this,<%=user_id%>)"> </div>


                    </div>

                </TD>-->
                        <% }%>
                    </TR>  
                    <% serial = serial + 1;%>
                    <%}%>
                    <% unitId = unitWbo.getAttribute("userId").toString();%>
                    <% }%>



                </TABLE>
            </div>
            <input type="hidden" value="<%=currentMonth%>" id="currentMonth"/>
            <input type="hidden" value="<%=currentYear%>" id="currentYear"/>
            <input type="hidden" value="" id="currentDay"/>
            <input type="hidden" value="<%=clientCompId%>" id="clientCompId"/>
            <input type="hidden" value="<%=clientId%>" id="clientId"/>
            <input type="hidden" value="" id="USERID"/>
            <input type="hidden" value="<%=supervisor%>" id="supervisorId"/>
            <% if (clientWbo != null) {%>
            <div id="clientInformation" style="width: 65%;display: none;position:fixed;
                 ">

                <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup(this)"/>
                </div>

                <!--<h1>رسالة قصيرة</h1>-->
                <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                    <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                        <!--<table align="right" width="30%" class="login" style="display: none;color: white" id="" cellpadding="3px;" cellspacing="3px;">-->
                        <%
                            //  if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            //     && connectByRealEstate.equals("1")) {
                        %>

                        <%//} else {%>
                        <tr >
                            <td style="width: 50%;">
                                <table style="">
                                    <tr>
                                        <td width="40%"style="color: #000;text-align: match-parent" >رقم العميل</td>
                                        <td style="text-align:right;border: none;">
                                            <label style="float: right;" id="clientNO"><%=clientWbo.getAttribute("clientNO").toString()%></label>
                                            <hr style="float: right;width: 70%;clear: both;" >
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="color: #000;" width="40%" >اسم العميل</td>
                                        <td style="text-align:right;"><label class="showx" id="clientName"><%=clientWbo.getAttribute("name")%></label>
                                            <hr style="float: right;width: 70%;" class="showx">
                                            <input type="text"  name="clientName" class="hidex" value="<%=clientWbo.getAttribute("name")%>"/>
                                            <input type="hidden" id="hideName" value="<%=clientWbo.getAttribute("name")%>" />
                                            <% String mail = "";
                                                if (clientWbo.getAttribute("email") != null) {
                                                    mail = (String) clientWbo.getAttribute("email");
                                                }
                                            %>
                                            <input type="hidden" id="hideEmail" value="<%=mail%>" />
                                            <input type="hidden" id="clientId" name="clientId" value="<%=clientWbo.getAttribute("id")%>"/>
                                        </td>

                                    </tr>
                                    <%if (clientWbo.getAttribute("partner") != null && !clientWbo.getAttribute("partner").equals("")) {
                                    %>
                                    <tr>
                                        <td style="color: #000;" width="40%" >إسم الزوجة/الزوج</td>
                                        <td style="text-align:right"><label id="partner"class="showx"><%=clientWbo.getAttribute("partner")%></label>
                                            <hr style="float: right;width: 70%;" class="showx">
                                            <input type="text"  name="partner" class="hidex" value="<%=clientWbo.getAttribute("partner")%>"/>
                                        </td>
                                    </tr>
                                    <%} else {%>
                                    <tr>
                                        <td style="color: #000;" width="40%" >إسم الزوجة/الزوج</td>
                                        <td style="text-align:right"><label id="partner"class="showx"><%=clientWbo.getAttribute("partner")%></label>
                                            <hr style="float: right;width: 70%;" class="showx">
                                            <input type="text"  name="partner" class="hidex" value=""/>
                                        </td>
                                    </tr>

                                    <%}%>
                                    <TR>
                                        <TD style="color: #000;width: 40%;"  width="40%">النوع</TD>

                                        <td style="<%=style%>;float: right;text-align: right" class='td'>
                                            <span><input type="radio" name="gender" value="ذكر"  <% if (clientWbo.getAttribute("gender").equals("ذكر")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>ذكر</b></font></span>
                                            <span><input type="radio"  name="gender" value="أنثى"  <% if (clientWbo.getAttribute("gender").equals("أنثى")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>أنثى</b></font></span>
                                        </td>
                                    </TR>
                                    <TR>
                                        <TD style="color: #000;width: 40%;"  width="40%">

                                            الحالة الإجتماعية
                                        </TD>

                                        <td style="<%=style%>" class='td'>
                                            <span><input type="radio" name="matiral_status" value="أعزب"  <% if (clientWbo.getAttribute("matiralStatus").equals("أعزب")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>أعزب</b></font></span>
                                            <span><input type="radio" name="matiral_status" value="متزوج" <% if (clientWbo.getAttribute("matiralStatus").equals("متزوج")) {%> checked="true" <%}%> />  <font size="3" color="#005599"><b>متزوج</b></font></span>
                                            <span><input type="radio" name="matiral_status" value="مطلق"  <% if (clientWbo.getAttribute("matiralStatus").equals("مطلق")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>مطلق</b></font></span>

                                        </td>

                                    </TR>
                                    <%if (clientWbo.getAttribute("clientSsn") != null && !clientWbo.getAttribute("clientSsn").equals("")) {
                                    %>
                                    <tr>
                                        <td style="color: #000;" width="40%" >الرقم القومى</td>
                                        <td style="text-align:right;"><label id="clientSsn" class="showx"><%=clientWbo.getAttribute("clientSsn")%></label>
                                            <hr style="float: right;width: 70%;" class="showx">

                                            <input type="text" name="clientSsn" class="hidex" value="<%=clientWbo.getAttribute("clientSsn")%>" onkeypress="javascript:return isNumber(event)"/>

                                        </td>
                                    </tr>
                                    <%} else {%>
                                    <tr>
                                        <td style="color: #000;" width="40%">الرقم القومى</td>
                                        <td style="text-align:right;"><label class="showx" id="clientSsn"></label>
                                            <hr style="float: right;width: 70%;" class="showx">
                                            <input type="text"  name="clientSsn" class="hidex" value="" onkeypress="javascript:return isNumber(event)"/>
                                        </td>
                                    </tr>
                                    <%}%>
                                    <tr>
                                        <td style="color: #000;width: 40%;"  width="40%">
                                            <LABEL FOR="job" style="color: #000;">
                                                المهنة
                                            </LABEL>
                                        </td>
                                        <td style="<%=style%>;float: right;text-align: right"class='td'>
                                            <%
                                                String jobName = "";
                                                if (clientWbo.getAttribute("job") != null & !clientWbo.getAttribute("job").equals("")) {
                                                    String jobCode = (String) clientWbo.getAttribute("job");
                                                    WebBusinessObject wbo5 = new WebBusinessObject();
                                                    TradeMgr tradeMgr = TradeMgr.getInstance();
                                                    wbo5 = tradeMgr.getOnSingleKey("key2", jobCode);
                                                    if (wbo5 != null) {

                                                        jobName = (String) wbo5.getAttribute("tradeName");
                                                    } else {
                                                        jobName = "لم يتم الإختيار";
                                                    }
                                                }
                                            %>


                                            <label class="showx" id="clientJob"><%=jobName%></label>



                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="width: 50%;">
                                <table>
                                    <%if (clientWbo.getAttribute("phone") != null && !clientWbo.getAttribute("phone").equals("")) {
                                    %>

                                    <tr>
                                        <td style="color: #000;" width="40%" >رقم التليفون</td>
                                        <td style="text-align:right;"><label class="showx" id="phone"><%=clientWbo.getAttribute("phone")%></label>
                                            <hr style="float: right;width: 70%;" class="showx">

                                            <input type="text"  name="phone" class="hidex" value="<%=clientWbo.getAttribute("phone")%>" onkeypress="javascript:return isNumber(event)"/>
                                        </td>
                                    </tr>
                                    <%} else {%>
                                    <tr>
                                        <td style="color: #000;" width="40%" >رقم التليفون</td>
                                        <td style="text-align:right;"><label class="showx" id="phone"></label>
                                            <hr style="float: right;width: 70%;" class="showx">
                                            <input type="text" name="phone" class="hidex" value="" onkeypress="javascript:return isNumber(event)"/>
                                        </td>
                                    </tr>
                                    <%}%>
                                    <tr>
                                        <td style="color: #000;" width="40%" >رقم الموبايل</td>
                                        <td style="text-align:right;"><label  class="showx" id="client_mobile"><%=clientWbo.getAttribute("mobile")%></label>
                                            <hr style="float: right;width: 70%;" class="showx">

                                            <input type="text"  name="client_mobile" class="hidex" value="<%=clientWbo.getAttribute("mobile")%>" onkeypress="javascript:return isNumber(event)"/>
                                        </td>
                                    </tr>
                                    <%if (clientWbo.getAttribute("address") != null && !clientWbo.getAttribute("address").equals("")) {
                                    %>
                                    <tr>
                                        <td style="color: #000;"  width="40%">العنوان</td>
                                        <td style="text-align:right;"><label class="showx" id="address"><%=clientWbo.getAttribute("address")%></label>
                                            <hr style="float: right;width: 70%;" class="showx">

                                            <input type="text"  name="address" class="hidex" value="<%=clientWbo.getAttribute("address")%>"/>
                                        </td>
                                    </tr>
                                    <%} else {%>
                                    <tr>
                                        <td style="color: #000;"  width="40%">العنوان</td>
                                        <td style="text-align:right;"><label class="showx"  id="address"></label>
                                            <hr style="float: right;width: 70%;" class="showx">
                                            <input type="text"  name="address" class="hidex" value=""/>
                                        </td>
                                    </tr>

                                    <%}%>
                                    <%if (clientWbo.getAttribute("email") != null && !clientWbo.getAttribute("email").equals("")) {
                                    %>
                                    <tr>
                                        <td style="color: #000;"  width="30%" >البريد الإلكترونى</td>
                                        <td style="text-align:right;"><label  class="showx"  id="email"><%=clientWbo.getAttribute("email")%></label>
                                            <hr style="float: right;width: 90%;" class="showx">

                                            <input type="text"  name="email" class="hidex" value="<%=clientWbo.getAttribute("email")%>"/>
                                        </td>
                                    </tr>
                                    <%} else {%>
                                    <tr>
                                        <td style="color: #000;"  width="30%" >البريد الإلكترونى</td>
                                        <td style="text-align:right;"><label  class="showx"  id="email"></label>
                                            <hr style="float: right;width: 90%;" class="showx">
                                            <input type="text"  name="email" class="hidex" value=""/>
                                        </td>
                                    </tr>
                                    <%}%>
                                    <!--
                                    --><tr>
                                        <td style="color: #000;"  width="40%" >يعمل بالخارج</td>

                                        <td style="text-align:right;">
                                            <span><input type="radio" name="workOut" value="1"  <% if (clientWbo.getAttribute("option1").equals("1")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">نعم</b></font></span>
                                            <span><input type="radio" name="workOut" value="0"  <% if (clientWbo.getAttribute("option1").equals("0")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">لا</b></font></span>
                                        </td>

                                    </tr>

                                    <tr>
                                        <td style="color: #000;width: 40%;"  width="40%" >أقارب بالخارج</td>
                                        <td style="text-align:right;">
                                            <span><input type="radio" name="kindred" value="1"  <% if (clientWbo.getAttribute("option2").equals("1")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">نعم</b></font></span>
                                            <span><input type="radio" name="kindred" value="0"  <% if (clientWbo.getAttribute("option2").equals("0")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">لا</b></font></span>
                                        </td>
                                    </tr>
                                    <TR>
                                        <TD style="color: #000;width: 40%;"  width="40%" >الفئة العمرية</TD>

                                        <td style="<%=style%>" class='td'>

                                            <span><input type="radio" name="age" value="20-30"  <% if (clientWbo.getAttribute("age").equals("20-30")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">20-30</b></font></span>
                                            <span><input type="radio" name="age" value="30-40"  <% if (clientWbo.getAttribute("age").equals("30-40")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">30-40</b></font></span>
                                            <span><input type="radio" name="age" value="40-50" <% if (clientWbo.getAttribute("age").equals("40-50")) {%> checked="true" <%}%>/>  <b  style="font-size: 11px;">40-50</b></font></span>
                                            <span><input type="radio" name="age" value="50-60"  <% if (clientWbo.getAttribute("age").equals("50-60")) {%> checked="true" <%}%>/>  <b  style="font-size: 11px;">50-60</b></font></span>

                                        </td>
                                    </TR>
                                </table>
                            </td>
                        </tr>



                        <%//}%>
                    </table>
                </div>
            </div>
            <%}%>
        </FORM>
    </body>
</html>
