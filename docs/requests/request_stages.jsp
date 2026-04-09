<%-- 
    Document   : CommentHieraricy
    Created on : Dec 8, 2014, 1:49:28 PM
    Author     : crm32
--%>

<%@page import="com.silkworm.common.SecurityUser"%>
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
            WebBusinessObject issue = (WebBusinessObject) request.getAttribute("issue");
            WebBusinessObject clientComplaint = (WebBusinessObject) request.getAttribute("clientComplaint");
            WebBusinessObject projectWbo = (WebBusinessObject) request.getAttribute("projectWbo");
            WebBusinessObject engineerWbo = (WebBusinessObject) request.getAttribute("engineerWbo");
            String clientComplaintId = (String) clientComplaint.getAttribute("id");
            String currentStatus = (String) clientComplaint.getAttribute("currentStatus");
            String issueStatus = issue != null ? (String) issue.getAttribute("currentStatus") : "";
            String issueId = (String) issue.getAttribute("id");
            WebBusinessObject clientWbo = ClientMgr.getInstance().getOnSingleKey((String) issue.getAttribute("clientId"));
            String unitNumber = issue != null && issue.getAttribute("unitId") != null ? (String) issue.getAttribute("unitId") : null;
            String sourceName = UserMgr.getInstance().getByKeyColumnValue((String) issue.getAttribute("userId"), "key1");
            List<WebBusinessObject> requestedItems = RequestItemsDetailsMgr.getInstance().getByIssueId(issueId);
            WebBusinessObject formatted = DateAndTimeControl.getFormattedDateTime((String) issue.getAttribute("creationTime"), "Ar");
            String status = (String) request.getAttribute("status");
            String message = (String) request.getAttribute("message");
            String beginDate = request.getParameter("beginDate");
            String endDate = request.getParameter("endDate");
            boolean canAddComments = !CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED.equalsIgnoreCase(currentStatus) && !CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED.equalsIgnoreCase(currentStatus);
            String classStage1Div = "circle ", stage1Label = "1";
            String classStage2Div = "circle ", classStage2Spin = "bar ", stage2Label = "2";
            String classStage3Div = "circle ", classStage3Spin = "bar ", stage3Label = "3";
            String classStageFinishDiv = "circle ", classStageFinishSpin = "bar ", stageFinishLabel = "";
//            if (comments.isEmpty()) {
//                classStage1Div += "active";
//                classStage2Div += "active";
//                classStage3Div += "active";
//                classStageFinishDiv += "active";
//                classStage2Spin += "";
//                classStage3Spin += "";
//                classStageFinishSpin += "";
//            } else if (comments.size() == 1) {
//                stage1Label = "&#10003;";
//                classStage1Div += "done";
//                classStage2Div += "active";
//                classStage3Div += "";
//                classStageFinishDiv += "";
//                classStage2Spin += "active";
//                classStage3Spin += "";
//                classStageFinishSpin += "";
//            } else if (comments.size() == 2) {
//                stage1Label = "&#10003;";
//                stage2Label = "&#10003;";
//                classStage1Div += "done";
//                classStage2Div += "done";
//                classStage3Div += "active";
//                classStageFinishDiv += "";
//                classStage2Spin += "active";
//                classStage3Spin += "half";
//                classStageFinishSpin += "";
//            } else {
//                stage1Label = "&#10003;";
//                stage2Label = "&#10003;";
//                stage3Label = "&#10003;";
//                stageFinishLabel = "&#10003;";
//                classStage1Div += "done";
//                classStage2Div += "done";
//                classStage3Div += "done";
//                classStageFinishDiv += "done";
//                classStage2Spin += "active";
//                classStage3Spin += "active";
//                classStageFinishSpin += "active";
//            }
//            if (!canAddComments) {
//                stage1Label = "&#10003;";
//                stage2Label = "&#10003;";
//                stage3Label = "&#10003;";
//                stageFinishLabel = "&#10003;";
//                classStage1Div = "circle done";
//                classStage2Div = "circle done";
//                classStage3Div = "circle done";
//                classStageFinishDiv = "circle done";
//                classStage2Spin = "bar active";
//                classStage3Spin = "bar active";
//                classStageFinishSpin += " active";
//            }
            switch (comments.size())
            {
                case 0:
                    classStage1Div += "active";
                    classStage2Div += "active";
                    classStage3Div += "active";
                    classStageFinishDiv += "active";
                    break;
                case 1:
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED) && commentsQuality.isEmpty())
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
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED) && commentsQuality.isEmpty())
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
                    if (issueStatus.equals(CRMConstants.ISSUE_STATUS_REJECTED) && commentsQuality.isEmpty())
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
        %>

        <link rel="stylesheet" href="css/progress/style.css" />
        <link rel="stylesheet" href="css/scroller/jquery.simplyscroll.css" media="all" type="text/css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/scroller/jquery.simplyscroll.js"></script>
        <title>JSP Page</title>
        <script type="text/javascript">
            $(document).ready(function () {
                $("#scroller").simplyScroll({
                    customClass: 'vert',
                    orientation: 'vertical',
                    auto: false,
                    speed: 10
                });
                $('#scroller').css({height: '100px'});
            });

            function saveComment(accepted) {
                var comment = $("#comment").val();
                var numberOfComments = $("#numberOfComments").val();
                document.COMMENT_FORM.action = "<%=context%>/IssueServlet?op=saveRequestComments&issueId=<%=issueId%>&clientComplaintId=<%=clientComplaintId%>&comment=" + comment + "&accepted=" + accepted + "&numberOfComments=" + numberOfComments + "&clientComplaintType=<%=CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION%>";
                document.COMMENT_FORM.submit();
            }

            function saveRequestItems(index) {
                loading("block");
                var issueId = '<%=issueId%>';
                var projectId = $('#requestedItemId' + index).val();
                var quantity = $('#quantity' + index).val();
                var valid = $('#accepted' + index).val();
                var note = $('#note' + index).val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/RequestItemServlet?op=saveRequestItem',
                    data: {
                        issueId: issueId,
                        projectId: projectId,
                        quantity: quantity,
                        valid: valid,
                        note: note
                    },
                    success: function (data) {
                        var info = $.parseJSON(data);
                        if (info.status === "ok") {
                            $('#doneImg' + index).css("display", "none");
                            $('#updateImg' + index).css("display", "block");
                            $('#id' + index).val(info.id);
                        } else {
                            alert("لم يتم التسجيل");
                        }
                        loading("none");
                    }
                });
            }

            function updateRequestItems(index) {
                loading("block");
                var id = $('#id' + index).val();
                var quantity = $('#quantity' + index).val();
                var valid = $('#accepted' + index).val();
                var note = $('#note' + index).val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/RequestItemServlet?op=updateRequestItem',
                    data: {
                        id: id,
                        quantity: quantity,
                        valid: valid,
                        note: note
                    },
                    success: function (data) {
                        var info = $.parseJSON(data);
                        if (info.status === "ok") {

                        } else {
                            alert("لم يتم التعديل");
                        }
                        loading("none");
                    }
                });
            }

            function removeRequestItems(index) {
                loading("block");
                var id = $('#id' + index).val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/RequestItemServlet?op=deleteRequestItem',
                    data: {
                        id: id
                    },
                    success: function (data) {
                        var info = $.parseJSON(data);
                        if (info.status === "ok") {
                            $('#row' + index).fadeOut(1000, function () {
                                $(this).remove();
                            });
                            $('#numberOfRequestedItems').val($('#numberOfRequestedItems').val() - 1);
                        } else {
                        }
                        loading("none");
                    }
                });
            }

            function openRequestItemsDailog() {
                var divTag = $("<div></div>");
                var ids = "";
                $("input[name='requestedItemId']").each(function () {
                    ids += "," + this.value;
                });
                $.ajax({
                    type: "post",
                    url: '<%=context%>/RequestItemServlet?op=listRequestItems',
                    data: {
                        ids: ids
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "أضافة بنود أعمال",
                                    show: "fade",
                                    hide: "explode",
                                    width: 500,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            $(this).dialog('close');
                                        },
                                        Done: function () {
                                            var itemId, itemCode, itemName, className;
                                            var counter = $('#numberOfRequestedItems').val();
                                            $(this).find(':checkbox:checked').each(function () {
                                                itemId = $(divTag.html()).find('#itemId' + this.value).val();
                                                itemCode = $(divTag.html()).find('#itemCode' + this.value).val();
                                                itemName = $(divTag.html()).find('#itemName' + this.value).val();
                                                if (counter % 2 === 1) {
                                                    className = "silver_odd_main";
                                                } else {
                                                    className = "silver_even_main";
                                                }
                                                $('#requestedItems > tbody:last').append("<TR id=\"row" + counter + "\"></TR>");
                                                $('#row' + counter).append("<TD width=\"8%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><b><font size=\"2\" color=\"#000080\" style=\"text-align: center;\">" + itemCode + "</font></b></TD>")
                                                        .append("<TD width=\"34%\" class=\"silver_footer\" bgcolor=\"#808000\" STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\">" + itemName + "</font></b></TD>")
                                                        .append("<TD width=\"8%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><input type=\"hidden\" id=\"requestedItemId" + counter + "\" name=\"requestedItemId\" value=\"" + itemId + "\"/><input type=\"hidden\" id=\"id" + counter + "\" name=\"id\" /><input type=\"text\" id=\"quantity" + counter + "\" name=\"quantity\" value=\"1\" style=\"text-align: center; width: 100%\"/></TD>")
                                                        .append("<TD width=\"8%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><select id=\"accepted" + counter + "\" name=\"accepted\" style=\"width: 100%\"><option value=" + <%=CRMConstants.REQUEST_ITEM_ACCEPTED%> + ">مقبول</option><option value=" + <%=CRMConstants.REQUEST_ITEM_NOT_ACCEPTED%> + ">مرفوض</option></select></TD>")
                                                        .append("<TD width=\"30%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><input type=\"text\" id=\"note" + counter + "\" name=\"note\" value=\"\" style=\"width: 100%\"/></TD>")
                                                        .append("<TD width=\"6%\" STYLE=\"text-align: center; border-left-width: 0px\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><img id =\"doneImg" + counter + "\" src=\"images/icons/done.png\" onclick=\"saveRequestItems(" + counter + ");\" width=\"18\" height=\"18\" style=\"vertical-align: middle; cursor: hand\"/><img id=\"updateImg" + counter + "\" src=\"images/icons/edit.png\" onclick=\"updateRequestItems(" + counter + ");\" width=\"18\" height=\"18\" style=\"display: none; vertical-align: middle; cursor: hand\"/></TD>")
                                                        .append("<TD width=\"6%\" STYLE=\"text-align: center; border-left-width: 0px\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><img src=\"images/icons/delete_ready.png\" onclick=\"removeRequestItems(" + counter + ");\" width=\"18\" height=\"18\" style=\"vertical-align: middle; cursor: hand\"/></TD>");
                                                counter++;
                                            }
                                            )
                                            $('#numberOfRequestedItems').val(counter);
                                            $(this).dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    }
                });
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

            function backToList() {
                document.COMMENT_FORM.action = "<%=context%>/SearchServlet?op=getRequests&beginDate=<%=beginDate%>&endDate=<%=endDate%>";
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
                            function openUnitsDailog() {
                                var divTag = $("<div></div>");
                                var projectID = '<%=projectWbo.getAttribute("projectID")%>';
                                $.ajax({
                                    type: "post",
                                    url: '<%=context%>/UnitServlet?op=listUnitByProject',
                                    data: {
                                        projectID: projectID
                                    },
                                    success: function (data) {
                                        divTag.html(data)
                                                .dialog({
                                                    modal: true,
                                                    title: "تحديث وحدة",
                                                    show: "fade",
                                                    hide: "explode",
                                                    width: 500,
                                                    position: {
                                                        my: 'center',
                                                        at: 'center'
                                                    },
                                                    buttons: {
                                                        Cancel: function () {
                                                            $(this).dialog('close');
                                                        },
                                                        Done: function () {
                                                            $("#unitNo").html($('input:radio[name=unitName]:checked').val());
                                                            updateUnit('<%=issueId%>', $('input:radio[name=unitName]:checked').val());
                                                            $(this).dialog('close');
                                                        }
                                                    }
                                                }).dialog('open');
                                    }
                                });
                            }
                            function updateUnit(issueID, unitName) {
                                loading("block");
                                $.ajax({
                                    type: "post",
                                    url: '<%=context%>/ComplexIssueServlet?op=updateRequestExtraditionUnit',
                                    data: {
                                        issueID: issueID,
                                        unitName: unitName
                                    },
                                    success: function (data) {
                                        var info = $.parseJSON(data);
                                        if (info.status === "ok") {
                                            alert("تم التحديث بنجاح");
                                        } else {
                                            alert("لم يتم التحديث");
                                        }
                                        loading("none");
                                    }
                                });
                            }

                            function openContractorsDailog() {
                                var divTag = $("<div></div>");
                                var projectID = '<%=projectWbo.getAttribute("projectID")%>';
                                $.ajax({
                                    type: "post",
                                    url: '<%=context%>/IssueServlet?op=getUpdateContractorForm',
                                    data: {
                                        projectID: projectID
                                    },
                                    success: function (data) {
                                        divTag.html(data)
                                                .dialog({
                                                    modal: true,
                                                    title: "تحديث مقاول",
                                                    show: "fade",
                                                    hide: "explode",
                                                    width: 500,
                                                    position: {
                                                        my: 'center',
                                                        at: 'center'
                                                    },
                                                    buttons: {
                                                        Cancel: function () {
                                                            $(this).dialog('close');
                                                        },
                                                        Done: function () {
                                                            updateContractor('<%=issueId%>', $('input:radio[name=clientID]:checked').val());
                                                            $(this).dialog('close');
                                                        }
                                                    }
                                                }).dialog('open');
                                    }
                                });
                            }
                            function updateContractor(issueID, clientID) {
                                loading("block");
                                $.ajax({
                                    type: "post",
                                    url: '<%=context%>/ComplexIssueServlet?op=updateContractor',
                                    data: {
                                        issueID: issueID,
                                        clientID: clientID
                                    },
                                    success: function (data) {
                                        var info = $.parseJSON(data);
                                        if (info.status === "ok") {
                                            alert("تم التحديث بنجاح");
                                            $("#contractorName").html(info.contractorName);
                                        } else {
                                            alert("لم يتم التحديث");
                                        }
                                        loading("none");
                                    }
                                });
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
            .main_section {
                background: rgba(255,205,112,1);
                background: -moz-radial-gradient(center, ellipse cover, rgba(255,205,112,1) 0%, rgba(255,237,204,1) 100%);
                background: -webkit-gradient(radial, center center, 0px, center center, 100%, color-stop(0%, rgba(255,205,112,1)), color-stop(100%, rgba(255,237,204,1)));
                background: -webkit-radial-gradient(center, ellipse cover, rgba(255,205,112,1) 0%, rgba(255,237,204,1) 100%);
                background: -o-radial-gradient(center, ellipse cover, rgba(255,205,112,1) 0%, rgba(255,237,204,1) 100%);
                background: -ms-radial-gradient(center, ellipse cover, rgba(255,205,112,1) 0%, rgba(255,237,204,1) 100%);
                background: radial-gradient(ellipse at center, rgba(255,205,112,1) 0%, rgba(255,237,204,1) 100%);
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffcd70', endColorstr='#ffedcc', GradientType=1 );
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
        </style>
    </head>
    <body>
        <div name="divGallaryTag"></div>
        <div></div>
        <div align="left" style="color:blue; margin-left: 7.5%; margin-bottom: 10px">
            <a href="JavaScript: getRequestExtraditionReport();">
                <img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/>
            </a>
            <a href="JavaScript: openGallaryDialog('<%=issue.getAttribute("id")%>')">
                <img style="margin: 3px" src="images/icons/view-request.png" width="24" height="24"/>
            </a>
            <br />
        </div>
        <FIELDSET class="set" style="width:85%;border-color: #006699">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td class="titlebar" style="text-align: center">
                        <font color="#005599" size="4">(<%=clientComplaint.getAttribute("businessCompID")%>) طلب تسليم</font>
                    </td>
                </tr>
            </table>
            <br />
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
                            <span class="title">انتهاء</span>
                        </div>
                    </div>
                    <br />
                    <br />
                    <table  align="right" dir="rtl" STYLE="width: 95%; margin-right: 2.5%" CELLPADDING="0" CELLSPACING="0">
                        <tr>
                            <TD nowrap CLASS="main_section" STYLE="text-align: right; padding-right: 10px; width: 35%">
                                <blockquote style="width: 100%">
                                    <p style="padding-top: 5px">
                                        <strong>المتابعة الرئيسية:  </strong>
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
                                                <label id="contractorName"><%=clientWbo.getAttribute("name")%></label>
                                                <button type="button" id="contractorUpdate" onclick="openContractorsDailog();" style="width: 70px; margin-bottom: 5px; margin-left: 4px; float: left;">تحديث&ensp;</button>
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
                                        <%
                                            if (unitNumber != null)
                                            {
                                        %>
                                        <tr>
                                            <TD nowrap style="border-width: 0px; font-size: 14px; font-weight: bold; width: 15%; text-align: right">
                                                رقم الوحدة:
                                            </TD>
                                            <TD nowrap style="border-width: 0px;font-size: 14px; font-weight: bold; text-align: right">
                                                <label id="unitNo"><%=unitNumber%></label>
                                                <button type="button" id="unitSearch" onclick="openUnitsDailog();" style="width: 70px; margin-bottom: 5px; margin-left: 4px; float: left;">تحديث&ensp;</button>
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
                            <TD nowrap CLASS="excelentCell" STYLE="text-align: right; width: 65%">
                                <table  align="left" dir="rtl" STYLE="width: 93%; padding-left: 2px" CELLPADDING="0" CELLSPACING="0">
                                    <thead>
                                        <tr>
                                            <td class="blueBorder blueHeaderTD" width="8%">كود</td>
                                            <td class="blueBorder blueHeaderTD" width="34%">أسم</td>
                                            <td class="blueBorder blueHeaderTD" width="8%">كمية</td>
                                            <td class="blueBorder blueHeaderTD" width="8%">موافق</td>
                                            <td class="blueBorder blueHeaderTD" width="30%">تعليق</td>
                                            <td class="blueBorder blueHeaderTD" width="12%"></td>
                                        </tr>
                                    </thead>
                                </table>
                                <ul id="scroller" style="width: 100%; height: auto; text-align: left">
                                    <table id="requestedItems" align="left" dir="rtl" STYLE="width: 93%; padding-left: 4px" CELLPADDING="0" CELLSPACING="0">
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
                                                <TD width="8%" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                                                    <b><font size="2" color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("itemCode")%></font></b>
                                                </TD>
                                                <TD width="34%" class="silver_footer" bgcolor="#808000" STYLE="text-align:center; color:black; font-size:14px; height: 25px">
                                                    <b><font color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("itemName")%></font></b>
                                                </TD>
                                                <TD width="8%" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                                                    <input type="hidden" id="id<%=counter%>" name="id" value="<%=requestedItem.getAttribute("id")%>"/>
                                                    <input type="hidden" id="requestedItemId<%=counter%>" name="requestedItemId" value="<%=requestedItem.getAttribute("projectId")%>"/>
                                                    <input type="text" id="quantity<%=counter%>" name="quantity" value="<%=requestedItem.getAttribute("quantity")%>" style="text-align: center;width: 100%"
                                                           <%=canAddComments ? "" : "readonly"%>/>
                                                </TD>
                                                <TD width="8%" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                                                    <select id="accepted<%=counter%>" name="accepted" style="width: 100%" <%=canAddComments ? "" : "disabled"%>>
                                                        <option value="<%=CRMConstants.REQUEST_ITEM_ACCEPTED%>" <%if (CRMConstants.REQUEST_ITEM_ACCEPTED.equalsIgnoreCase((String) requestedItem.getAttribute("valid")))
                                                            {%>selected=""<%}%>>مقبول</option>
                                                        <option value="<%=CRMConstants.REQUEST_ITEM_NOT_ACCEPTED%>" <%if (CRMConstants.REQUEST_ITEM_NOT_ACCEPTED.equalsIgnoreCase((String) requestedItem.getAttribute("valid")))
                                                            {%>selected=""<%}%>>مرفوض</option>
                                                    </select>
                                                </TD>
                                                <TD width="30%" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                                                    <input type="text" id="note<%=counter%>" name="note" value="<%=note%>" style="width: 100%"
                                                           <%=canAddComments ? "" : "readonly"%>/>
                                                </TD>
                                                <TD width="6%" STYLE="text-align: center; border-left-width: 0px" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                                                    <img id="updateImg<%=counter%>" src="images/icons/edit.png" onclick="updateRequestItems(<%=counter%>);" width="18" height="18"
                                                         style="vertical-align: middle; cursor: hand; display: <%=canAddComments ? "" : "none"%>" />
                                                </TD>
                                                <TD width="6%" STYLE="text-align: center; border-left-width: 0px" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                                                    <img src="images/icons/delete_ready.png" onclick="removeRequestItems(<%=counter%>);" width="18" height="18"
                                                         style="vertical-align: middle; cursor: hand; display: <%=canAddComments ? "" : "none"%>" />
                                                </TD>
                                            </tr>
                                            <% counter++;
                                                }%>
                                        </tbody>
                                    </table>
                                </ul>
                                <br />
                                <br />
                                <button type="button" onclick="openRequestItemsDailog();" style="float: left; width: 150px; margin-bottom: 5px; margin-left: 4px; display: <%=canAddComments ? "" : "none"%>">أضافة بند عمل&ensp;<img src="images/short_cut_icon.png" alt="" height="18" width="18" /></button>
                                <div id="loading" class="container" style="float: right; margin-right: 4px; margin-bottom: 5px; display: none">
                                    <div class="contentBar">
                                        <div id="block_1" class="barlittle"></div>
                                        <div id="block_2" class="barlittle"></div>
                                        <div id="block_3" class="barlittle"></div>
                                        <div id="block_4" class="barlittle"></div>
                                        <div id="block_5" class="barlittle"></div>
                                    </div>
                                </div>
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
                            <TD nowrap colspan="3" CLASS="excelentCell" STYLE="text-align: right; padding-right: 10px">
                                <div class="progress" style="float: right; width: 10%;">
                                    <div class="<%=commentClass%>">
                                        <span class="label"><%=++numberOfComments%></span>
                                    </div>
                                </div>
                                <div style="float: left; width: 90%;">
                                    <blockquote>
                                        <p style="padding-top: 5px">
                                            <strong>التعليق: </strong>
                                            <br>
                                            <br>
                                        <font color="<%=fontColor%>" style="padding-right: 30px"><pre style="width : 900px; word-wrap:break-word; font-weight: lighter;"><%=value%></pre></font>
                                        </p>
                                    </blockquote>
                                    <br>
                                    <blockquote>
                                        <p>
                                            <strong>فى تاريخ </strong>
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

                        <%if ((comments.size() < CRMConstants.ISSUE_NUMBER_OF_COMMENTS) && canAddComments)
                            {%>
                        <tr>
                            <TD nowrap colspan="3" CLASS="excelentCell" STYLE="text-align: right; padding-right: 10px">
                                <% if (securityUser.getUserId().equalsIgnoreCase((String) clientComplaint.getAttribute("currentOwnerId")))
                                    {%>
                                <div class="progress" style="float: right; width: 10%;">
                                    <div class="circle done">
                                        <span class="label"><%=++numberOfComments%></span>
                                    </div>
                                </div>
                                <div style="float: left; width: 90%;">
                                    <blockquote>
                                        <p style="padding-top: 5px">
                                            <strong>التعليق: </strong>
                                            <br>
                                            <br>
                                            <textarea id="comment" name="comment" style="padding-right: 1%; width: 98%" rows="8"></textarea>
                                        </p>
                                        <br>
                                        <button class="" onclick="saveComment('no');" style="float: contour; width: 150px; height: 30px; font-size: 16px;">رفض&ensp;<img src="images/icons/delete_ready.png" alt="" height="16" width="16" /></button>
                                        &ensp;
                                        &ensp;
                                        <button class="" onclick="saveComment('yes');" style="float: contour; width: 150px; height: 30px; font-size: 16px">قبول&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18" /></button>
                                        &ensp;
                                        &ensp;
                                        <!--button class="" onclick="saveComment('yes_with_note');" style="float: contour; width: 150px; height: 30px; font-size: 16px">مقبول بملاحظات&ensp;<img src="images/icons/accept-with-note.png" alt="" height="18" width="18" /></button-->
                                    </blockquote>
                                    <br>
                                </div>
                                <%}
                                else
                                {%>
                                <p style="padding-top: 5px">
                        <center>
                            <strong style="font-size: 18px; color: red"> ليس لديك صلاحية أضافة تعليق على هذا الطلب </strong>
                        </center>
                        </p>
                        <%}%>
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
    </body>
</html>
