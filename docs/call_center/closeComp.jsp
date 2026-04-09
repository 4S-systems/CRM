<%@page import="com.silkworm.persistence.relational.Row"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.util.DateAndTimeControl,com.workFlowTasks.common.*,com.workFlowTasks.db_access.*"%>
<%@ page import="com.tracker.business_objects.WebIssue,com.tracker.engine.*,com.workFlowTasks.common.WFTaskConstants,com.tracker.db_access.*" %>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr,com.workFlowTasks.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<HTML>


    <%
        String status = (String) request.getAttribute("status");
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        VisitQualMgr visitQualMgr = VisitQualMgr.getInstance();

        String businessObjectId = (String) request.getAttribute("businessObjectId");
        String objectType = (String) request.getAttribute("objectType");




        String issueID = (String) request.getAttribute("issueId");
        String compID = (String) request.getAttribute("compId");
        String status_code = (String) request.getAttribute("statusCode");
        String object_type = (String) request.getAttribute("object_type");
        String sess = (String) request.getAttribute("s");















        WebBusinessObject wfTaskWbo = new WebBusinessObject();
        WFTaskMgr wFTaskMgr = WFTaskMgr.getInstance();
        wFTaskMgr.setUser(loggedUser);

        ArrayList userList = (ArrayList) request.getAttribute("userList");

        String filterName = (String) request.getAttribute("filterName");
        String filterValue = (String) request.getAttribute("filterValue");
        String count = (String) request.getAttribute("count");
        // get current date
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String nowDate = sdf.format(cal.getTime());

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;
        String saving_status, Dupname;
        String title_1, title_2;
        String save_button_label;
        String fStatus;
        String sStatus;
        String absalign = "";
        String attachedFileTask;
        String selectFromList, noUsers;
        String taskType, userName, addOp, attachFile, addNotes, notes, TaskData, altIm,
                currentStatus, sNotify, sAll, back_button_label,
                closeTicket, confirmClose, fileTypeError;

        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";

            title_1 = "View Ticket";
            save_button_label = "Add Comment";
            langCode = "Ar";
            sStatus = "Save Successfully";
            fStatus = "Fail To Save";

            //orderDate="Max Review Date";

            taskType = "Ticket Type";
            userName = "Created By";

            addOp = "Additional Operations";
            attachFile = "Attach Filefli";
            addNotes = "Updating Ticket";
            notes = "Notes";

            TaskData = "Ticket Data";
            currentStatus = "Current Status";
            altIm = "remark here if you want to attach File";
            absalign = "Left";
            sNotify = "Notify";
            sAll = "All";
            back_button_label = "Back";
            attachedFileTask = "Attached File";
            closeTicket = "Close Ticket";
            selectFromList = "select from List";
            noUsers = "No One ";
            confirmClose = "Ticket has been closed";
            fileTypeError = "Incorrect Type File";

        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";

            title_1 = "&#1591;&#1604;&#1576; &#1573;&#1610;&#1590;&#1575;&#1581;";
            save_button_label = "&#1571;&#1590;&#1601; &#1575;&#1604;&#1578;&#1593;&#1604;&#1610;&#1602;";
            langCode = "En";
            sStatus = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
            fStatus = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";


            // orderDate="&#1571;&#1602;&#1600;&#1589;&#1609; &#1605;&#1600;&#1610;&#1600;&#1593;&#1600;&#1575;&#1583; &#1604;&#1604;&#1600;&#1605;&#1600;&#1585;&#1575;&#1580;&#1600;&#1593;&#1600;&#1607;";

            taskType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1591;&#1604;&#1576;";
            userName = "&#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";

            addOp = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1610;&#1607;";
            attachFile = "&#1575;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
            addNotes = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1605;&#1593;&#1575;&#1605;&#1604;&#1577;";
            notes = " &#1575;&#1604;&#1608;&#1589;&#1601;";

            TaskData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1591;&#1604;&#1576;";
            currentStatus = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1593;&#1575;&#1605;&#1604;&#1577; &#1581;&#1575;&#1604;&#1610;&#1575;&#1611;";
            altIm = "&#1575;&#1582;&#1578;&#1575;&#1585; &#1575;&#1604;&#1605;&#1585;&#1576;&#1593;&nbsp; &#1575;&#1584;&#1575;&#1603;&#1606;&#1578; &#1578;&#1585;&#1610;&#1583; &#1575;&#1606; &#1578;&#1585;&#1601;&#1602; &#1605;&#1604;&#1601; &#1576;&#1607;&#1584;&#1577; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; <Br>&#1575;&#1608;&#1575;&#1578;&#1585;&#1603;&#1577; &#1582;&#1575;&#1604;&#1610;&#1575;&#1575;&#1584;&#1575;&#1603;&#1606;&#1578; &#1604;&#1575;&#1578;&#1585;&#1610;&#1583; &#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1604;&#1601;";
            absalign = "Right";
            sNotify = "&#1573;&#1593;&#1604;&#1575;&#1605;";
            sAll = "&#1575;&#1604;&#1603;&#1604;";
            back_button_label = "&#1585;&#1580;&#1608;&#1593; ";
            attachedFileTask = "&#1575;&#1604;&#1605;&#1604;&#1601; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;";
            closeTicket = "&#1573;&#1594;&#1604;&#1575;&#1602; &#1575;&#1604;&#1605;&#1593;&#1575;&#1605;&#1604;&#1577;";
            selectFromList = "&#1571;&#1582;&#1578;&#1575;&#1585; &#1605;&#1606; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
            noUsers = "&#1604;&#1575; &#1571;&#1581;&#1583; ";
            confirmClose = "&#1578;&#1605; &#1573;&#1594;&#1604;&#1575;&#1602; &#1575;&#1604;&#1605;&#1607;&#1605;&#1577;";
            fileTypeError = "&#1582;&#1591;&#1571; &#1601;&#1609; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;";

        }

        String errorTypeFile = (String) request.getAttribute("errorTypeFile");
        String arName = (String) request.getAttribute("arName");
        String enName = (String) request.getAttribute("enName");
        String taskTypeSelect = (String) request.getAttribute("taskType");
        String departmentSelect = (String) request.getAttribute("department");

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>add new Ticket</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />

        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function closeCompplaint()
        {
            //            window.navigator("ComplaintEmployeeServlet?op=closeCompOperation");
            document.TASK_FORM.action = "<%=context%>/ComplaintEmployeeServlet?op=closeCompOperation";
            document.TASK_FORM.submit();
        }
    </SCRIPT>
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <BODY style="background-color: #FFF9DF;">
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>



        <FORM NAME="TASK_FORM" id="TASK_FORM" METHOD="POST" >
            <div style="width: 100%;margin: auto">
                <input type="hidden" name="issueId" id="issueId" value="<%=issueID%>" />
                <input type="hidden" name="compId" id="compId"value="<%=compID%>" />
                <input type="hidden" name="status_code" id="status_code"value="<%=status_code%>" />
                <input type="hidden" name="object_type" id="object_type" value="<%=object_type%>" />

                <TABLE dir="rtl" width="50%;">
                    <tr>
                        <td style="width: 30%;">ملاحظات الإغلاق</TD>
                        <td><TEXTAREA cols="40" rows="6" name="notes"></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td colspan="2"> <input type="button"  onclick="JavaScript:closeCompplaint();" class="button_close" value="حفظ"></TD>
                    </tr>
                </TABLE>
            </DIV>
        </FORM>
    </BODY>
</HTML>     
