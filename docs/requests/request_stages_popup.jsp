<%-- 
    Document   : CommentHieraricy
    Created on : Dec 8, 2014, 1:49:28 PM
    Author     : crm32
--%>

<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.tracker.db_access.RequestItemsDetailsMgr"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            List<WebBusinessObject> commentsQuality = (List<WebBusinessObject>) request.getAttribute("comments2");
            List<WebBusinessObject> comments = (List<WebBusinessObject>) request.getAttribute("comments");
            List<WebBusinessObject> commentsReplayProjectManager = (List<WebBusinessObject>) request.getAttribute("comments3");
            ArrayList<WebBusinessObject> dependOnIssuesList = (ArrayList<WebBusinessObject>) request.getAttribute("dependOnIssuesList");
            WebBusinessObject dependWbo = (WebBusinessObject) request.getAttribute("dependWbo");
            WebBusinessObject issue = (WebBusinessObject) request.getAttribute("issue");
            WebBusinessObject clientComplaint = (WebBusinessObject) request.getAttribute("clientComplaint");
            String businessCompID = "";
            if (clientComplaint == null)
            {
                clientComplaint = new WebBusinessObject();
            }
            else
            {
                businessCompID = (String) clientComplaint.getAttribute("businessCompID");
            }
            String clientComplaintId = (String) clientComplaint.getAttribute("id");
            WebBusinessObject clientComplaintQ = (WebBusinessObject) request.getAttribute("clientComplaintQ");
            if (businessCompID.isEmpty())
            {
                String[] tempArr = ((String) clientComplaintQ.getAttribute("businessCompID")).split("-");
                if (tempArr.length > 1)
                {
                    businessCompID = "PJM-" + (Integer.parseInt(tempArr[1]) - 1) + "*";
                }
            }
            WebBusinessObject projectWbo = (WebBusinessObject) request.getAttribute("projectWbo");
            WebBusinessObject engineerWbo = (WebBusinessObject) request.getAttribute("engineerWbo");
            String projectID = (String) request.getAttribute("projectID");
            WebBusinessObject source = (WebBusinessObject) request.getAttribute("source");
            String sourceId = "", sourceName = "";
            if (source != null)
            {
                sourceId = (String) source.getAttribute("userId");
                sourceName = (String) source.getAttribute("fullName");
            }
            String clientComplaintQId = clientComplaintQ != null ? (String) clientComplaintQ.getAttribute("id") : "";
            String currentStatus = clientComplaintQ != null ? (String) clientComplaintQ.getAttribute("currentStatus") : "";
            String issueStatus = issue != null ? (String) issue.getAttribute("currentStatus") : "";
            String unitNumber = issue != null && issue.getAttribute("unitId") != null ? (String) issue.getAttribute("unitId") : null;
            boolean canAddComments = !CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED.equalsIgnoreCase(currentStatus);
            String issueId = (String) issue.getAttribute("id");
            WebBusinessObject clientWbo = ClientMgr.getInstance().getOnSingleKey((String) issue.getAttribute("clientId"));
            String complaintSourceName = UserMgr.getInstance().getByKeyColumnValue((String) issue.getAttribute("userId"), "key3");
            List<WebBusinessObject> requestedItems = RequestItemsDetailsMgr.getInstance().getByIssueId(issueId);
            WebBusinessObject formatted = DateAndTimeControl.getFormattedDateTime((String) issue.getAttribute("creationTime"), "Ar");
            WebBusinessObject managerWbo = (WebBusinessObject) request.getAttribute("managerWbo");
            WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
            String status = (String) request.getAttribute("status");
            String message = (String) request.getAttribute("message");
            String beginDate = request.getParameter("beginDate");
            String endDate = request.getParameter("endDate");
            String classStage1Div = "circle ", stage1Label = "1";
            String classStage2Div = "circle ", classStage2Spin = "bar ", stage2Label = "2";
            String classStage3Div = "circle ", classStage3Spin = "bar ", stage3Label = "3";
            String classStageFinishDiv = "circle ", classStageFinishSpin = "bar ", stageFinishLabel = "";
            switch (commentsQuality.size())
            {
                case 0:
                    classStage1Div += "active";
                    classStage2Div += "active";
                    classStage3Div += "active";
                    classStageFinishDiv += "active";
                    break;
                case 1:
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED))
                    {
                        stage1Label = "&#10005;";
                        classStage1Div += "reject";
                        classStage2Div += "active";
                    }
                    else
                    {
                        stage1Label = "&#10003;";
                        stageFinishLabel = "&#10003;";
                        classStage1Div += "done";
                        classStageFinishDiv += "done";
                        classStage3Spin += "active";
                        classStageFinishSpin += "active";
                    }
                    classStage2Spin += "active";
                    break;
                case 2:
                    stage1Label = "&#10005;";
                    classStage1Div += "reject";
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED))
                    {
                        stage2Label = "&#10005;";
                        classStage2Div += "reject";
                        classStage3Div += "active";
                        classStage3Spin += "half";
                    }
                    else
                    {
                        stage2Label = "&#10003;";
                        stageFinishLabel = "&#10003;";
                        classStage2Div += "done";
                        classStageFinishDiv += "done";
                        classStage3Spin += "active";
                        classStageFinishSpin += "active";
                    }
                    classStage2Spin += "active";
                    break;
                case 3:
                    stage1Label = "&#10005;";
                    stage2Label = "&#10005;";
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED))
                    {
                        stage3Label = "&#10005;";
                        stageFinishLabel = "&#10005;";
                        classStage3Div += "reject";
                        classStageFinishDiv += "reject";
                    }
                    else
                    {
                        stage3Label = "&#10003;";
                        stageFinishLabel = "&#10003;";
                        classStage3Div += "done";
                        classStageFinishDiv += "done";
                    }
                    classStage1Div += "reject";
                    classStage2Div += "reject";
                    classStage2Spin += "active";
                    classStage3Spin += "active";
                    classStageFinishSpin += "active";
                    break;
            }

            String classStage1Div1 = "circle ", stage1Label1 = "1";
            String classStage2Div1 = "circle ", classStage2Spin1 = "bar ", stage2Label1 = "2";
            String classStage3Div1 = "circle ", classStage3Spin1 = "bar ", stage3Label1 = "3";
            String classStageFinishDiv1 = "circle ", classStageFinishSpin1 = "bar ", stageFinishLabel1 = "";
            switch (comments.size())
            {
                case 0:
                    classStage1Div1 += "active";
                    classStage2Div1 += "active";
                    classStage3Div1 += "active";
                    classStageFinishDiv1 += "active";
                    break;
                case 1:
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED) && commentsQuality.isEmpty())
                    {
                        stage1Label1 = "&#10005;";
                        classStage1Div1 += "reject";
                        classStage2Div1 += "active";
                    }
                    else
                    {
                        stage1Label1 = "&#10003;";
                        stageFinishLabel1 = "&#10003;";
                        classStage1Div1 += "done";
                        classStageFinishDiv1 += "done";
                        classStage3Spin1 += "active";
                        classStageFinishSpin1 += "active";
                    }
                    classStage2Spin1 += "active";
                    break;
                case 2:
                    stage1Label1 = "&#10005;";
                    classStage1Div1 += "reject";
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED) && commentsQuality.isEmpty())
                    {
                        stage2Label1 = "&#10005;";
                        classStage2Div1 += "reject";
                        classStage3Div1 += "active";
                        classStage3Spin1 += "half";
                    }
                    else
                    {
                        stage2Label1 = "&#10003;";
                        stageFinishLabel1 = "&#10003;";
                        classStage2Div1 += "done";
                        classStageFinishDiv1 += "done";
                        classStage3Spin1 += "active";
                        classStageFinishSpin1 += "active";
                    }
                    classStage2Spin1 += "active";
                    break;
                case 3:
                    stage1Label1 = "&#10005;";
                    stage2Label1 = "&#10005;";
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED) && commentsQuality.isEmpty())
                    {
                        stage3Label1 = "&#10005;";
                        stageFinishLabel1 = "&#10005;";
                        classStage3Div1 += "reject";
                        classStageFinishDiv1 += "reject";
                    }
                    else
                    {
                        stage3Label1 = "&#10003;";
                        stageFinishLabel1 = "&#10003;";
                        classStage3Div1 += "done";
                        classStageFinishDiv1 += "done";
                    }
                    classStage1Div1 += "reject";
                    classStage2Div1 += "reject";
                    classStage2Spin1 += "active";
                    classStage3Spin1 += "active";
                    classStageFinishSpin1 += "active";
                    break;
            }

            List<WebBusinessObject> commentsOfQualityAndReplayProjectManager = new ArrayList<WebBusinessObject>();
            int i = 0, j = 0;
            while ((i < commentsQuality.size()) && (j < commentsReplayProjectManager.size()))
            {
                commentsOfQualityAndReplayProjectManager.add(commentsQuality.get(i));
                commentsOfQualityAndReplayProjectManager.add(commentsReplayProjectManager.get(j));
                i++;
                j++;
            }
            while (i < commentsQuality.size())
            {
                commentsOfQualityAndReplayProjectManager.add(commentsQuality.get(i));
                i++;
            }
            while (j < commentsReplayProjectManager.size())
            {
                commentsOfQualityAndReplayProjectManager.add(commentsReplayProjectManager.get(j));
                j++;
            }
        %>

        <link rel="stylesheet" href="css/progress/style.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css" />
        <link REL="stylesheet" TYPE="text/css" HREF="css/Button.css" />
        <title>طلب تسليم</title>
        <script type="text/javascript">
            $(function () {
                $("#accordion").accordion({
                    collapsible: true,
                    heightStyle: "fill"
                });
            });

            function closeWindow() {
                self.close();
            }

            function saveComment(accepted) {
                var comment = $("#comment").val();
                var numberOfComments = $("#numberOfComments").val();
                //document.COMMENT_FORM.action = "<%//=context%>/IssueServlet?op=saveRequestCommentsForQaulity&issueId=<%//=issueId%>&clientComplaintId=<%//=clientComplaintQId%>&projectID=<%//=projectID%>&comment=" + comment + "&accepted=" + accepted + "&numberOfComments=" + numberOfComments + "&clientComplaintType=<%//=CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY%>";
                document.COMMENT_FORM.action = "<%=context%>/IssueServlet?op=saveIssueCommentForQA&issueId=<%=issueId%>&comment=" + comment + "&accepted=" + accepted + "&numberOfComments=" + numberOfComments;
                document.COMMENT_FORM.submit();
                $(".commentButton").attr("disabled", true);
            }

            function saveCommentReplayProjectManager() {
                var comment = $("#comment").val();
                document.COMMENT_FORM.action = "<%=context%>/IssueServlet?op=saveCommentReplayProjectManager&issueId=<%=issueId%>&clientComplaintId=<%=clientComplaintId%>&clientComplaintQId=<%=clientComplaintQId%>&comment=" + comment + "&clientComplaintType=<%=CRMConstants.COMMENT_TYPE_ID_PROJECT_MANAGER%>";
                document.COMMENT_FORM.submit();
            }

            function getRequestExtraditionReport() {
                var url = "<%=context%>/IssueServlet?op=getRequestExtraditionReport&issueId=<%=issueId%>";
                        window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
                    }

                    var divGallaryTag;
                    function openGallaryDialog(issueId) {
                        loading("block");
                        divGallaryTag = $("div[name='divGallaryTag']");
                        $.ajax({
                            type: "post",
                            url: '<%=context%>/FileUploadServlet?op=getAllIssueGallaryDialog',
                            data: {
                                businessObjectId: issueId
                            },
                            success: function (data) {
                                divGallaryTag.html(data)
                                        .dialog({
                                            modal: true,
                                            title: "غرض الرسومات الهندسية",
                                            show: "fade",
                                            hide: "explode",
                                            width: 950,
                                            position: {
                                                my: 'center',
                                                at: 'center'
                                            },
                                            buttons: {
                                                Cancel: function () {
                                                    divGallaryTag.dialog('close');
                                                },
                                                Done: function () {
                                                    divGallaryTag.dialog('close');
                                                }
                                            }
                                        })
                                        .dialog('open');
                            },
                            error: function (data) {
                                alert(data);
                            }
                        });
                        loading("none");
                    }

                    function loading(val) {
                        if (val === "none") {
                            $('#loading').fadeOut(2000, function () {
                                $('#loading').css("display", val);
                            });
                        } else {
                            $('#loading').fadeIn("fast", function () {
                                $('#loading').css("display", val);
                            });
                        }
                    }

                    function reject() {
                        document.REJECT_FORM.action = "<%=context%>/IssueServlet?op=rejectRequestByManager&issueId=<%=issueId%>&clientComplaintId=<%=clientComplaint.getAttribute("id")%>&clientComplaintType=<%=CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION%>";
                                document.REJECT_FORM.submit();
                            }
                            function changeComment() {
                                $("#comment").val($("#commentList").val());
                            }
                    function openInParent(issueID) {
                        var url = "<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=" + issueID;
                        self.opener.location.replace(url,"_self");
                        alwaysLowered = true; // Bring the Parent window in front & hide the current one
                    }
        </script>

        <style type="text/css">  
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            .vert { /* wider than clip to position buttons to side */
                margin-left: 2px;
                margin-right: 2px;
                width: 100%;
                height: auto;
            }

            .vert .simply-scroll-clip {
                width: 100%;
                height: auto;
            }

            // loading progress bar
            .container {width: 100px; margin: 0 auto; overflow: hidden;}
            .contentBar {width:100px; margin:0 auto; padding-top:0px; padding-bottom:0px;}
            .barlittle {
                background-color:#2187e7;  
                background-image: -moz-linear-gradient(45deg, #2187e7 25%, #a0eaff); 
                background-image: -webkit-linear-gradient(45deg, #2187e7 25%, #a0eaff);
                border-left:1px solid #111; border-top:1px solid #111; border-right:1px solid #333; border-bottom:1px solid #333; 
                width:10px;
                height:10px;
                float:left;
                margin-left:5px;
                opacity:0.1;
                -moz-transform:scale(0.7);
                -webkit-transform:scale(0.7);
                -moz-animation:move 1s infinite linear;
                -webkit-animation:move 1s infinite linear;
            }
            #block_1{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            #block_2{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_3{
                -moz-animation-delay: .2s;
                -webkit-animation-delay: .2s;
            }
            #block_4{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_5{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            @-moz-keyframes move{
                0%{-moz-transform: scale(1.2);opacity:1;}
                100%{-moz-transform: scale(0.7);opacity:0.1;}
            }
            @-webkit-keyframes move{
                0%{-webkit-transform: scale(1.2);opacity:1;}
                100%{-webkit-transform: scale(0.7);opacity:0.1;}
            }
            .headerTitle {
                font-size: 20px;
                color: darkred;
                text-align: right;
                padding-right: 20px;
                text-wrap: none;
            }
            .headerNumber {
                font-size: 17px;
                color: blue;
                text-align: right;
                text-wrap: none;
            }
            button.btnEnable
            {
                width: 20%;
                margin: 5px;
                height: 15%;
                font-size: large;
                font-family: serif;
                background: #6699FF;
            }
            button.btnUpdate
            {
                width: 22%;
                margin: 5px;
                height: 15%;
                font-size: large;
                font-family: serif;
                background: #6699FF;
            }
        </style>
        <script>
            function toggleSelect()
            {
                var checked = document.getElementById("checkAllWorkItems").checked;
                var checkBoxes = document.getElementsByName("itemCheckBox");
                for (var i = 0; i < checkBoxes.length; i++)
                {
                    checkBoxes[i].checked = checked;
                }
            }
            function enableEditing()
            {
                if (isChecked())
                {
                    document.getElementById("checkAllWorkItems").disabled = true;
                    document.getElementById("btnUbdate").hidden = false;
                    var checkBoxes = document.getElementsByName("itemCheckBox");
                    for (var i = 0; i < checkBoxes.length; i++)
                    {
                        if (checkBoxes[i].checked)
                        {
                            document.getElementById("quantity" + i).readOnly = false;
                            document.getElementById("accepted" + i).disabled = false;
                            document.getElementById("note" + i).readOnly = false;
                        }
                        checkBoxes[i].disabled = true;
                    }
                }
                else
                {
                    alert("أختر بند عمل اولا");
                }
            }
            function updateSelected()
            {
                if (isChecked())
                {
                    if (validateAllValues())
                    {
                        var checkBoxes = document.getElementsByName("itemCheckBox");
                        var data = [];
                        var workItemId;
                        var quntity;
                        var acceptedStatus;
                        var note;
                        var temp;
                        for (var i = 0; i < checkBoxes.length; i++)
                        {
                            if (checkBoxes[i].checked)
                            {
                                workItemId = document.getElementById("id" + i).value;
                                //alert(workItemId);
                                quntity = document.getElementById("quantity" + i).value;
                                //alert(quntity);
                                acceptedStatus = document.getElementById("accepted" + i).value;
                                note = document.getElementById("note" + i).value;
                                temp = workItemId + ";" + quntity + ";" + acceptedStatus + ";" + note;
                                data.push(temp);
                            }
                        }
                        var strData = JSON.stringify(data, replaceToUpper);
                        $.ajax({
                            type: "post",
                            url: '<%=context%>/IssueServlet?op=updateDelivryWorkItems',
                            data: {
                                issueWorkList: strData
                            },
                            success: function ()
                            {
                                if (isChecked())
                                {
                                    document.getElementById("btnUbdate").hidden = true;
                                    document.getElementById("checkAllWorkItems").disabled = false;
                                    var checkBoxes = document.getElementsByName("itemCheckBox");
                                    for (var i = 0; i < checkBoxes.length; i++)
                                    {
                                        if (checkBoxes[i].checked)
                                        {
                                            checkBoxes[i].checked = false;
                                            document.getElementById("quantity" + i).readOnly = true;
                                            document.getElementById("accepted" + i).disabled = true;
                                            document.getElementById("note" + i).readOnly = true;
                                        }
                                        checkBoxes[i].disabled = false;
                                    }
                                }
                                alert("عملية تسجيل ناجحه");
                            },
                            error: function ()
                            {
                                alert("فشلت عملية التحديــث");
                            }
                        });
                    }
                }

            }

            function validateAllValues()
            {
                var z = true;
                var values = document.getElementsByName("quantity");
                for (var i = 0; i < values.length; i++)
                {
                    if (isNaN(values[i].value))
                    {
                        z = false;
                        values[i].style.borderColor = "red";
                    }
                    else
                    {
                        values[i].style.borderColor = "";
                    }
                }
                if (z === false)
                {
                    alert("غير مسموح يإدخال غير الأرقام");
                }
                return z;
            }
            function isChecked()
            {
                var checkBoxes = document.getElementsByName("itemCheckBox");
                for (var i = 0; i < checkBoxes.length; i++)
                {
                    if (checkBoxes[i].checked)
                    {
                        return true;
                    }
                }
                return false;
            }

            function replaceToUpper(key, value)
            {
                return value.toString();
            }
        </script>
    </head>
    <body>
        <div name="divGallaryTag"></div>
    <center id="site-body-container" style="height: auto;">
        <br/>
        <div align="left" style="color:blue; margin-left: 7.5%; margin-bottom: 10px">
            <button onclick="JavaScript: closeWindow();" style="float: left; width: 150px; font-size: larger;">إغلاق الشاشة&ensp;<img src="images/cancel.png" alt="" height="18" /></button>
            <a href="JavaScript: getRequestExtraditionReport();">
                <img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24" title="طباعة"/>
            </a>
            <a href="JavaScript: openGallaryDialog('<%=issue.getAttribute("id")%>')">
                <img style="margin: 3px" src="images/icons/view-request.png" width="24" height="24" title="عرض الصور"/>
            </a>
            <%
                if (CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED.equals(clientComplaint.getAttribute("currentStatus"))
                        && managerWbo != null && managerWbo.getAttribute("userId") != null
                        && managerWbo.getAttribute("userId").equals(loggedUser.getAttribute("userId")))
                {
            %>
            <a href="JavaScript: reject()">
                <img style="margin: 3px" src="images/icons/delete_ready.png" width="24" height="24" title="رفض الطلب"/>
            </a>
            <form name="REJECT_FORM" method="POST">
            </form>
            <%
                }
            %>
            <br />
            <div id="loading" class="container" style="display: none">
                <div class="contentBar">
                    <div id="block_1" class="barlittle"></div>
                    <div id="block_2" class="barlittle"></div>
                    <div id="block_3" class="barlittle"></div>
                    <div id="block_4" class="barlittle"></div>
                    <div id="block_5" class="barlittle"></div>
                </div>
            </div>
        </div>
        <br/>
        <div id="accordion" style="width: 95%">
            <h3>(<%=businessCompID%>) تعليقات طلب التسليم</h3>
            <div style="height: auto">
                <FIELDSET class="set" style="width:95%;border-color: #006699">
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td class="titlebar" style="text-align: center">
                                <font color="#005599" size="4">طلب تسليم</font>
                            </td>
                        </tr>
                    </table>
                    <input type="hidden" id="endDate" name="endDate" value="<%=endDate%>" />
                    <input type="hidden" id="endDate" name="beginDate" value="<%=beginDate%>" />
                    <div>
                        <br />
                        <br />
                        <div class="progress" style="direction: rtl;width: 95%; margin-right: 2.5%">
                            <div class="<%=classStage1Div1%>">
                                <span class="label"><%=stage1Label1%></span>
                                <span class="title">مراجعة 1</span>
                            </div>
                            <span class="<%=classStage2Spin1%>"></span>
                            <div class="<%=classStage2Div1%>">
                                <span class="label"><%=stage2Label1%></span>
                                <span class="title">مراجعة 2</span>
                            </div>
                            <span class="<%=classStage3Spin1%>"></span>
                            <div class="<%=classStage3Div1%>">
                                <span class="label"><%=stage3Label1%></span>
                                <span class="title">مراجعة 3</span>
                            </div>
                            <span class="<%=classStageFinishSpin1%>"></span>
                            <div class="<%=classStageFinishDiv1%>">
                                <span class="label"><%=stageFinishLabel1%></span>
                                <span class="title">أنتهاء</span>
                            </div>
                        </div>
                        <br />
                        <br />
                        <table  align="right" dir="rtl" STYLE="width: 95%; margin-right: 2.5%" CELLPADDING="0" CELLSPACING="0">
                            <tr>
                                <TD nowrap CLASS="panelInfo" STYLE="text-align: right; padding-right: 10px; width: 25%">
                                    <blockquote style="width: 100%">
                                        <p style="padding-top: 5px">
                                            <strong style="font-size: 20px">المتابعة الرئيسية:  </strong>
                                            <br />
                                        <hr style="border-color: #C3C6C8; width: 50%; margin-top: 5px"/>
                                        <br>
                                        <table  align="right" dir="rtl" STYLE="width: 96%; padding-right: 4%; border-width: 0px; padding-bottom: 5px" CELLPADDING="0" CELLSPACING="0">
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 20%; text-align: right">
                                                    رقم المتابعة:
                                                </TD>
                                                <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right; width: 30%">
                                                    <font color="red"><%=issue.getAttribute("businessID")%></font><font color="blue">/<%=issue.getAttribute("businessIDbyDate")%></font>
                                                </TD>
                                            </tr>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                    المقاول:
                                                </TD>
                                                <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                    <%=clientWbo.getAttribute("name")%>
                                                </TD>
                                            </tr>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                    الموضوع:
                                                </TD>
                                                <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                    <%=issue.getAttribute("issueTitle")%>
                                                </TD>
                                            </tr>
                                            <%
                                                if (projectWbo != null)
                                                {
                                            %>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                    المشروع:
                                                </TD>
                                                <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                    <%=projectWbo.getAttribute("projectName")%>
                                                </TD>
                                            </tr>
                                            <%
                                                }
                                                if (engineerWbo != null)
                                                {
                                            %>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                    المهندس المسؤول:
                                                </TD>
                                                <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                    <%=engineerWbo.getAttribute("fullName")%>
                                                </TD>
                                            </tr>
                                            <%
                                                }
                                            %>
                                            <tr>
                                                <TD colspan="4" nowrap style="border-width: 0px;">
                                                    <hr style="border-color: #C3C6C8; width: 100%; margin-top: 5px"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 20%; text-align: right">
                                                    المصدر:
                                                </TD>
                                                <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right; width: 30%">
                                                    <%=complaintSourceName%>
                                                </TD>
                                            </tr>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                    التاريخ:
                                                </TD>
                                                <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                    <font color="red"><%=formatted.getAttribute("day")%></font><b><%=((String) formatted.getAttribute("time")).length() > 9 ? " - " + ((String) formatted.getAttribute("time")).substring(0, 10) : ""%></b>
                                                </TD>
                                            </tr>
                                            <%
                                                if (unitNumber != null)
                                                {
                                            %>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                    رقم الوحدة:
                                                </TD>
                                                <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                    <%=unitNumber%>
                                                </TD>
                                            </tr>
                                            <%
                                                }
                                                if (dependOnIssuesList != null && !dependOnIssuesList.isEmpty()) {
                                            %>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right; vertical-align: top;">
                                                    معتمدات أضافية:
                                                    <br/>
                                                    <img src="images/hand_left.png"/>
                                                </TD>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; text-align: right">
                                                    <%
                                                        for (WebBusinessObject dependOnWbo : dependOnIssuesList) {
                                                    %>
                                                    <a href="JavaScript: openInParent('<%=dependOnWbo.getAttribute("id")%>');" style="font-size: 14px;"><font color="red"><%=dependOnWbo.getAttribute("businessID")%></font><font color="blue">/<%=dependOnWbo.getAttribute("businessIDbyDate")%></font></a><br/>
                                                    <%
                                                        }
                                                    %>
                                                </TD>
                                            </tr>
                                            <%
                                                }
                                                if (dependWbo != null) {
                                            %>
                                            <tr>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right; vertical-align: top;">
                                                    <%="1".equals(dependWbo.getAttribute("option1")) ? "أعادة ل" : "تكملة ل"%>:
                                                    <br/>
                                                    <img src="images/hand_left.png"/>
                                                </TD>
                                                <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; text-align: right">
                                                    <a href="JavaScript: openInParent('<%=dependWbo.getAttribute("id")%>');" style="font-size: 14px;"><font color="red"><%=dependWbo.getAttribute("businessID")%></font><font color="blue">/<%=dependWbo.getAttribute("businessIDbyDate")%></font></a>
                                                </TD>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </table>
                                        </p>
                                    </blockquote>
                                </TD>
                                <TD BGCOLOR="#DDDD00" nowrap CLASS="silver_even" style="border-width: 0px; width: 1%">
                                    &ensp;
                                </TD>
                                <TD nowrap CLASS="panelInfo2" STYLE="text-align: right; width: 74%; vertical-align: top;">
                                    <table id="requestedItems" align="left" dir="rtl" STYLE="width: 99%; padding-left: .5%; margin-top: 0.5%" CELLPADDING="0" CELLSPACING="0">
                                        <thead>
                                            <tr>
                                                <td class="blueBorder blueHeaderTD" width="10%">
                                                    <input type="checkbox" name="allItemCheckBox" id="checkAllWorkItems" onchange="javascript:toggleSelect()" />
                                                </td>
                                                <td class="blueBorder blueHeaderTD" width="10%">كود</td>
                                                <td class="blueBorder blueHeaderTD" width="40%">اسم</td>
                                                <td class="blueBorder blueHeaderTD" width="9%">كمية</td>
                                                <td class="blueBorder blueHeaderTD" width="9%">موافق</td>
                                                <td class="blueBorder blueHeaderTD" width="32%">تعليق</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int counter = 0;
                                                String bgColorm, note;
                                                for (WebBusinessObject requestedItem : requestedItems)
                                                {
                                                    if ((counter % 2) == 1)
                                                    {
                                                        bgColorm = "silver_odd_main";
                                                    }
                                                    else
                                                    {
                                                        bgColorm = "silver_even_main";
                                                    }
                                                    note = (String) requestedItem.getAttribute("note");
                                                    if (note == null)
                                                    {
                                                        note = "";
                                                    }
                                            %>
                                            <tr id="row<%=counter%>">
                                                <td STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                                                    <input type="checkbox" name="itemCheckBox" id="itemCheckBox<%=counter%>" />
                                                </td>
                                                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                                                    <b><font size="2" color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("itemCode")%></font></b>
                                                </TD>
                                                <TD class="silver_footer" bgcolor="#808000" STYLE="text-align:center; color:black; font-size:14px; height: 25px">
                                                    <b><font color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("itemName")%></font></b>
                                                </TD>
                                                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                                                    <input type="hidden" id="id<%=counter%>" name="id" value="<%=requestedItem.getAttribute("id")%>"/>
                                                    <input type="hidden" id="requestedItemId<%=counter%>" name="requestedItemId" value="<%=requestedItem.getAttribute("projectId")%>"/>
                                                    <input type="text" id="quantity<%=counter%>" name="quantity" value="<%=requestedItem.getAttribute("quantity")%>" style="text-align: center;width: 100%"
                                                           readOnly  />
                                                </TD>
                                                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                                                    <select id="accepted<%=counter%>" name="accepted" style="width: 100%" disabled >
                                                        <option value="<%=CRMConstants.REQUEST_ITEM_ACCEPTED%>" <%if (CRMConstants.REQUEST_ITEM_ACCEPTED.equalsIgnoreCase((String) requestedItem.getAttribute("valid")))
                                                            {%>selected=""<%}%>>مقبول</option>
                                                        <option value="<%=CRMConstants.REQUEST_ITEM_NOT_ACCEPTED%>" <%if (CRMConstants.REQUEST_ITEM_NOT_ACCEPTED.equalsIgnoreCase((String) requestedItem.getAttribute("valid")))
                                                            {%>selected=""<%}%>>مرفوض</option>
                                                    </select>
                                                </TD>
                                                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                                                    <input type="text" id="note<%=counter%>" name="note" value="<%=note%>" style="width: 100%"
                                                           readOnly/>
                                                </TD>
                                            </tr>
                                            <% counter++;
                                                }%>
                                        <div style="text-align: center">
                                            <button class="btnEnable" name=enableEdit id="btnEdit" onclick="javascript:enableEditing()">تعديـل بنود الاعمـال</button>
                                            <button class="btnUpdate" hidden="=true" name=ubdateEnabled id="btnUbdate" onclick="javascript:updateSelected()">تحديـث بنود الاعمـال</button>
                                        </div>
                                        </tbody>
                                    </table>
                                </TD>
                            </tr>
                            <tr>
                                <TD colspan="3" BGCOLOR="#DDDD00" nowrap CLASS="silver_even" style="border-width: 0px;">
                                    &ensp;
                                </td>
                            </tr>
                            <%
                                WebBusinessObject wbo;
                                String value, fontColor;
                                String commentClass;
                                int numberOfComments = 0;
                                for (WebBusinessObject comment : comments)
                                {
                                    commentClass = "circle ";
                                    fontColor = "black";
                                    if (numberOfComments < comments.size() - 1)
                                    {
                                        commentClass += "reject";
                                    }
                                    else
                                    {
                                        if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED) && commentsQuality.isEmpty())
                                        {
                                            commentClass += "reject";
                                        }
                                        else
                                        {
                                            commentClass += "done";
                                        }
                                    }
                                    value = (String) comment.getAttribute("comment");
                                    if (value == null || value.isEmpty())
                                    {
                                        value = "لايوجد تعليق";
                                        fontColor = "gray";
                                    }
                                    wbo = DateAndTimeControl.getFormattedDateTime((String) comment.getAttribute("creationTime"), "Ar");
                            %>
                            <tr>
                                <TD nowrap colspan="3" CLASS="commentBg1" STYLE="text-align: right; padding-right: 10px">
                                    <div class="progress" style="float: right; width: 10%;">
                                        <div class="<%=commentClass%>">
                                            <span class="label"><%=++numberOfComments%></span>
                                        </div>
                                    </div>
                                    <div style="float: left; width: 90%;">
                                        <blockquote>
                                            <p style="padding-top: 5px">
                                                <strong style="font-size: 18px">التعليق: </strong>
                                                <br>
                                                <br>
                                            <font color="<%=fontColor%>" style="padding-right: 30px"><pre style="width : 700px; word-wrap:break-word; font-weight: lighter;"><%=value%></pre></font>
                                            </p>
                                        </blockquote>
                                        <br>
                                        <blockquote>
                                            <p>
                                                <strong style="font-size: 18px">فى تاريخ </strong>
                                                <br>
                                                <br>
                                                <font color="red">&ensp;<%=wbo.getAttribute("day")%>&ensp;-&ensp;</font><b><%=wbo.getAttribute("time")%></b>
                                            </p>
                                        </blockquote>
                                        <br>
                                    </div>
                                </td>                    
                            </tr>
                            <tr>
                                <TD colspan="3" BGCOLOR="#DDDD00" nowrap CLASS="silver_even" style="border-width: 0px;">
                                    &ensp;
                                </td>
                            </tr>
                            <% }%>
                        </table>
                    </div>
                </fieldset>
            </div>
            <%
                if (clientComplaintQ != null)
                {
            %>
            <h3>(<%=clientComplaintQ.getAttribute("businessCompID")%>) تعليقات طلب تسليم الجودة</h3>
            <div style="height: auto">
                <FIELDSET class="set" style="width:95%;border-color: #006699">
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td class="titlebar" style="text-align: center">
                                <font color="#005599" size="4">تسليم جودة</font>
                            </td>
                        </tr>
                    </table>
                    <form name="COMMENT_FORM" method="POST">
                        <input type="hidden" id="endDate" name="endDate" value="<%=endDate%>" />
                        <input type="hidden" id="endDate" name="beginDate" value="<%=beginDate%>" />
                        <div>
                            <%if (status != null && status.equals("OK"))
                                {%>
                            <br>
                            <table align="center" dir="ltr" WIDTH="70%">
                                <tr>
                                    <td class="backgroundHeader">
                                        <font size="3" color="blue">تم الحفظ بنجاح</font>
                                    </td>
                                </tr>
                            </table>
                            <%}
                            else if (status != null && status.equals("Failed"))
                            {%>
                            <br>
                            <table align="center" dir="ltr" WIDTH="70%">
                                <tr>
                                    <td class="backgroundHeader">
                                        <font size="3" color="red">لم يتم الحفظ</font>
                                    </td>
                                </tr>
                            </table>
                            <%}%>
                            <% if (message != null)
                                {%>
                            <br>
                            <table align="center" dir="ltr" WIDTH="70%">
                                <tr>
                                    <td class="backgroundHeader">
                                        <font size="3" color="red"><%=message%></font>
                                    </td>
                                </tr>
                            </table>
                            <% }%>
                            <br />
                            <br />
                            <div class="progress" style="direction: rtl;width: 95%; margin-right: 2.5%">
                                <div class="<%=classStage1Div%>">
                                    <span class="label"><%=stage1Label%></span>
                                    <span class="title">مراجعة 1</span>
                                </div>
                                <span class="<%=classStage2Spin%>"></span>
                                <div class="<%=classStage2Div%>">
                                    <span class="label"><%=stage2Label%></span>
                                    <span class="title">مراجعة 2</span>
                                </div>
                                <span class="<%=classStage3Spin%>"></span>
                                <div class="<%=classStage3Div%>">
                                    <span class="label"><%=stage3Label%></span>
                                    <span class="title">مراجعة 3</span>
                                </div>
                                <span class="<%=classStageFinishSpin%>"></span>
                                <div class="<%=classStageFinishDiv%>">
                                    <span class="label"><%=stageFinishLabel%></span>
                                    <span class="title">أنتهاء</span>
                                </div>
                            </div>
                            <br />
                            <br />
                            <table  align="right" dir="rtl" STYLE="width: 95%; margin-right: 2.5%" CELLPADDING="0" CELLSPACING="0">
                                <tr>
                                    <TD nowrap CLASS="panelInfo" STYLE="text-align: right; padding-right: 10px; width: 25%">
                                        <blockquote style="width: 100%">
                                            <p style="padding-top: 5px">
                                                <strong style="font-size: 20px">المتابعة الرئيسية:  </strong>
                                                <br />
                                            <hr style="border-color: #C3C6C8; width: 50%; margin-top: 5px"/>
                                            <br>
                                            <table  align="center" dir="rtl" STYLE="width: 96%; padding-right: 4%; border-width: 0px; padding-bottom: 5px" CELLPADDING="0" CELLSPACING="0">
                                                <tr>
                                                    <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 20%; text-align: right">
                                                        رقم المتابعة:
                                                    </TD>
                                                    <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right; width: 30%">
                                                        <font color="red"><%=issue.getAttribute("businessID")%></font><font color="blue">/<%=issue.getAttribute("businessIDbyDate")%></font>
                                                    </TD>
                                                </tr>
                                                <%
                                                    if (projectWbo != null)
                                                    {
                                                %>
                                                <tr>
                                                    <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                        المشروع:
                                                    </TD>
                                                    <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                        <%=projectWbo.getAttribute("projectName")%>
                                                    </TD>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                                <tr>
                                                    <TD colspan="4" nowrap style="border-width: 0px;">
                                                        <hr style="border-color: #C3C6C8; width: 100%; margin-top: 5px"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 20%; text-align: right">
                                                        المصدر:
                                                    </TD>
                                                    <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right; width: 30%">
                                                        <%=sourceName%>
                                                    </TD>
                                                </tr>
                                                <tr>
                                                    <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                        التاريخ:
                                                    </TD>
                                                    <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                        <font color="red"><%=formatted.getAttribute("day")%></font><b><%=((String) formatted.getAttribute("time")).length() > 9 ? " - " + ((String) formatted.getAttribute("time")).substring(0, 10) : ""%></b>
                                                    </TD>
                                                </tr>
                                            </table>
                                            </p>
                                        </blockquote>
                                    </TD>
                                </tr>
                                <tr>
                                    <TD BGCOLOR="#DDDD00" nowrap CLASS="silver_even" style="border-width: 0px;">
                                        &ensp;
                                    </td>
                                </tr>
                                <%
                                    numberOfComments = 0;
                                    String className = "commentBg1", lastCommentType = "replay";;
                                    for (WebBusinessObject comment : commentsOfQualityAndReplayProjectManager)
                                    {
                                        commentClass = "circle ";
                                        fontColor = "black";
                                        if (numberOfComments < commentsQuality.size() - 1)
                                        {
                                            commentClass += "reject";
                                        }
                                        else
                                        {
                                            if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED))
                                            {
                                                commentClass += "reject";
                                            }
                                            else
                                            {
                                                commentClass += "done";
                                            }
                                        }
                                        value = (String) comment.getAttribute("comment");
                                        if (value == null || value.isEmpty())
                                        {
                                            value = "لايوجد تعليق";
                                            fontColor = "gray";
                                        }
                                        wbo = DateAndTimeControl.getFormattedDateTime((String) comment.getAttribute("creationTime"), "Ar");

                                        className = "commentBg1";
                                        lastCommentType = "-1".equalsIgnoreCase((String) comment.getAttribute("option1")) ? "replay" : "not-replay";
                                        if ("-1".equalsIgnoreCase((String) comment.getAttribute("option1")))
                                        {
                                            className = "commentBg2";
                                        }
                                        else
                                        {
                                            numberOfComments++;
                                        }
                                %>
                                <tr>
                                    <TD nowrap CLASS="<%=className%>" STYLE="text-align: right; padding-right: 10px">
                                        <%if (!"-1".equalsIgnoreCase((String) comment.getAttribute("option1")))
                                            {%>
                                        <div class="progress" style="float: right; width: 10%;">
                                            <div class="<%=commentClass%>">
                                                <span class="label"><%=numberOfComments%></span>
                                            </div>
                                        </div>
                                        <% }
                                        else
                                        {%>
                                        <p style="padding-top: 5px">
                                            <strong style="font-size: 18px">رد المصدر :  </strong>
                                            <strong style="font-size: 18px"><%=sourceName%></strong>
                                        </p>
                                        <% }%>
                                        <div style="float: left; width: 90%;">
                                            <blockquote>
                                                <p style="padding-top: 5px">
                                                    <strong style="font-size: 18px">التعليق: </strong>
                                                    <br>
                                                    <br>
                                                <font color="<%=fontColor%>" style="padding-right: 30px"><pre style="width : 900px; word-wrap:break-word; font-weight: lighter;"><%=value%></pre></font>
                                                </p>
                                            </blockquote>
                                            <br>
                                            <blockquote>
                                                <p>
                                                    <strong style="font-size: 18px">فى تاريخ </strong>
                                                    <br>
                                                    <br>
                                                    <font color="red">&ensp;<%=wbo.getAttribute("day")%>&ensp;-&ensp;</font><b><%=wbo.getAttribute("time")%></b>
                                                </p>
                                            </blockquote>
                                            <br>
                                        </div>
                                    </td>                    
                                </tr>
                                <tr>
                                    <TD colspan="3" BGCOLOR="#DDDD00" nowrap CLASS="silver_even" style="border-width: 0px;">
                                        &ensp;
                                    </td>
                                </tr>
                                <% } %>

                                <%
                                    className = "replay".equalsIgnoreCase(lastCommentType) ? "commentBg1" : "commentBg2";
                                    if (commentsQuality.size() < CRMConstants.ISSUE_NUMBER_OF_COMMENTS && canAddComments)
                                    {
                                %>
                                <tr>
                                    <TD nowrap CLASS="<%=className%>" STYLE="text-align: right; padding-right: 10px">
                                        <%if ("replay".equalsIgnoreCase(lastCommentType) && securityUser.getUserId().equalsIgnoreCase((String) clientComplaintQ.getAttribute("currentOwnerId")))
                                            {%>
                                        <div class="progress" style="float: right; width: 10%;">
                                            <div class="circle done">
                                                <span class="label"><%=++numberOfComments%></span>
                                            </div>
                                        </div>
                                        <%}
                                        else if (!"replay".equalsIgnoreCase(lastCommentType) && securityUser.getUserId().equalsIgnoreCase(sourceId))
                                        {%>
                                        <p style="padding-top: 5px">
                                            <strong style="font-size: 18px">رد المصدر :  </strong>
                                            <strong style="font-size: 18px"><%=sourceName%></strong>
                                        </p>
                                        <%}
                                        else if ("replay".equalsIgnoreCase(lastCommentType) && !securityUser.getUserId().equalsIgnoreCase((String) clientComplaintQ.getAttribute("currentOwnerId")))
                                        {%>
                                        <p style="padding-top: 5px">
                                <center>
                                    <strong style="font-size: 18px; color: red"> ليس لديك صلاحية أضافة تعليق على هذا الطلب </strong>
                                </center>
                                </p>
                                <% }
                                else
                                {%>
                                <p style="padding-top: 5px">
                                <center>
                                    <strong style="font-size: 18px">المصدر : </strong>
                                    <strong style="font-size: 18px"><%=sourceName%></strong>
                                    <strong style="font-size: 18px"> لم يرد بعد </strong>
                                </center>
                                </p>
                                <% } %>
                                <%if (!currentStatus.equals("7") && "replay".equalsIgnoreCase(lastCommentType) && securityUser.getUserId().equalsIgnoreCase((String) clientComplaintQ.getAttribute("currentOwnerId")))
                                    {%>
                                <div style="float: left; width: 80%;">
                                    <blockquote>
                                        <p style="padding-top: 5px">
                                            <strong style="font-size: 18px">التعليق: </strong>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <select id="commentList" onchange="JavaScript: changeComment();">
                                                <option></option>
                                                <option>نسبة اﻷنجاز 0%</option>
                                                <option>نسبة اﻷنجاز 5%</option>
                                                <option>نسبة اﻷنجاز 10%</option>
                                                <option>نسبة اﻷنجاز 15%</option>
                                                <option>نسبة اﻷنجاز 20%</option>
                                                <option>نسبة اﻷنجاز 25%</option>
                                                <option>نسبة اﻷنجاز 30%</option>
                                                <option>نسبة اﻷنجاز 35%</option>
                                                <option>نسبة اﻷنجاز 40%</option>
                                                <option>نسبة اﻷنجاز 45%</option>
                                                <option>نسبة اﻷنجاز 50%</option>
                                                <option>نسبة اﻷنجاز 55%</option>
                                                <option>نسبة اﻷنجاز 60%</option>
                                                <option>نسبة اﻷنجاز 65%</option>
                                                <option>نسبة اﻷنجاز 70%</option>
                                                <option>نسبة اﻷنجاز 75%</option>
                                                <option>نسبة اﻷنجاز 80%</option>
                                                <option>نسبة اﻷنجاز 85%</option>
                                                <option>نسبة اﻷنجاز 90%</option>
                                                <option>نسبة اﻷنجاز 95%</option>
                                                <option>نسبة اﻷنجاز 100%</option>
                                            </select>
                                            <br>
                                            <br>
                                            <textarea id="comment" name="comment" style="padding-right: 1%; width: 98%" rows="8"></textarea>
                                        </p>
                                        <br>
                                        <button class="commentButton" onclick="saveComment('yes');" style="float: contour; width: 150px; height: 30px; font-size: 16px">قبول&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18" /></button>
                                        &ensp;
                                        &ensp;
                                        <%
                                        if (!currentStatus.equals("6")) {
                                        %>
                                        <button class="commentButton" onclick="saveComment('yes_with_note');" style="float: contour; width: 150px; height: 30px; font-size: 16px">مقبول بملاحظات&ensp;<img src="images/icons/accept-with-note.png" alt="" height="18" width="18" /></button>
                                        &ensp;
                                        &ensp;
                                        <button class="commentButton" onclick="saveComment('no');" style="float: contour; width: 150px; height: 30px; font-size: 16px;">رفض&ensp;<img src="images/icons/delete_ready.png" alt="" height="16" width="16" /></button>
                                        &ensp;
                                        &ensp;
                                        <button class="commentButton" onclick="saveComment('totalyNo');" style="float: contour; width: 150px; height: 30px; font-size: 16px">مرفوض نهائيا&ensp;<img src="images/icons/delete_ready.png" alt="" height="18" width="18" /></button>
                                        <%
                                        }
                                        %>
                                    </blockquote>
                                    <br>
                                </div>        
                                <% }
                                else if (!"replay".equalsIgnoreCase(lastCommentType) && securityUser.getUserId().equalsIgnoreCase(sourceId))
                                {%>
                                <div style="float: left; width: 90%;">
                                    <blockquote>
                                        <p style="padding-top: 5px">
                                            <strong style="font-size: 18px">التعليق: </strong>
                                            <br>
                                            <br>
                                            <textarea id="comment" name="comment" style="padding-right: 1%; width: 98%" rows="8"></textarea>
                                        </p>
                                        <br>
                                        <button class="" onclick="saveCommentReplayProjectManager();" style="float: contour; width: 150px; height: 30px; font-size: 16px;">حفظ الرد&ensp;<img src="images/icons/replay.png" alt="" height="16" width="16" /></button>
                                    </blockquote>
                                    <br>
                                </div>
                                <% }%>
                                </td>                    
                                </tr>
                                <tr>
                                    <TD colspan="3" BGCOLOR="#DDDD00" nowrap CLASS="silver_even" style="border-width: 0px;">
                                        &ensp;
                                    </td>
                                </tr>
                                <%}%>
                            </table>
                        </div>
                        <input type="hidden" id="numberOfRequestedItems" value="<%=counter%>" />
                        <input type="hidden" id="numberOfComments" value="<%=numberOfComments%>" />
                    </form>
                </fieldset>
            </div>
            <%
                }
            %>
            <br />
        </div>
    </center>
</body>
</html>
