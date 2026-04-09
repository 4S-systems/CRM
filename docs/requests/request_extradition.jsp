<%-- 
    Document   : CommentHieraricy
    Created on : Dec 8, 2014, 1:49:28 PM
    Author     : crm32
--%>

<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String clientId = (String) request.getAttribute("clientId");
            WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");
            String status = (String) request.getAttribute("status");
            String message = (String) request.getAttribute("message");
            ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
            ArrayList<WebBusinessObject> engineersList = (ArrayList<WebBusinessObject>) request.getAttribute("engineersList");
            String projectID = (String) request.getAttribute("projectID");
            Calendar calendar = Calendar.getInstance();
            String jDateFormat = "yyyy/MM/dd";
            SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
            String now = sdf.format(calendar.getTime());
            String engineerID = "";
            if (request.getAttribute("engineerID") != null) {
                engineerID = (String) request.getAttribute("engineerID");
            }

            WebBusinessObject formatted = DateAndTimeControl.getFormattedDateTime(DateAndTimeControl.getOracleDateTimeNowAsString(), "Ar");
            
            // for depend
            WebBusinessObject issueDependOnWbo = (WebBusinessObject) request.getAttribute("issueDependOnWbo");
            ArrayList<WebBusinessObject> itemsDependOnList = (ArrayList<WebBusinessObject>) request.getAttribute("itemsDependOnList");
            String projectDepenedOnID = (String) request.getAttribute("projectDepenedOnID");
            if(projectDepenedOnID != null) {
                projectID = projectDepenedOnID;
            }
            String engineerDepenedOnID = (String) request.getAttribute("engineerDepenedOnID");
            if(engineerDepenedOnID != null) {
                engineerID = engineerDepenedOnID;
            }
            String unitNo = "";
            String businessID = "";
            String dependOnID = "";
            if(issueDependOnWbo != null) {
                unitNo = (String) issueDependOnWbo.getAttribute("unitId");
                businessID = (String) issueDependOnWbo.getAttribute("businessID");
                dependOnID = (String) issueDependOnWbo.getAttribute("id");
            }
            //
        %>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <title>JSP Page</title>
        <script type="text/javascript">
            $(function() {
                $("#deliveryDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    showOn: "button",
                    buttonImage: "images/icons/calendar-icon.png",
                    buttonImageOnly: true,
                    buttonText: "Select date"
                });
            });
            function saveComment(accepted) {
                if (!validateData("req", document.COMMENT_FORM.projectID, "من فضلك اختار المشروع...")) {
                    $("#projectID").focus();
                } else if (document.getElementById('row0') === null) {
                    alert("يجب اختيار بند عمل واحد على الأقل...");
                    $("#btnRequestItems").click();
                } else if (!validateData("req", document.COMMENT_FORM.unitNo, "من فضلك ادخل رقم الوحدة...")) {
                    $("#unitNo").focus();
                } else if (!validateData("req", document.COMMENT_FORM.comments, "من فضلك ادخل التعليق...")) {
                    $("#comments").focus();
                } else {
                    var finishComment = "";
                    if (accepted === "ok") {
                        finishComment = $("#finishComment").val()
                    }
                    document.COMMENT_FORM.action = "<%=context%>/IssueServlet?op=saveCommentHierarchy&clientId=<%=clientId%>&finishComment=" + finishComment + "&clientComplaintType=<%=CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION%>&note=internal&callType=internal&accepted=" + accepted;
                    document.COMMENT_FORM.submit();
                }
            }

            function openAcceptedDailog(accepted) {
                var divTag = $("#acceptedDailog");
                divTag.dialog({
                    modal: true,
                    title: 'التعليق',
                    show: "blind",
                    hide: "explode",
                    width: 500,
                    position: {
                        my: 'center',
                        at: 'center'
                    },
                    buttons: {
                        Cancel: function() {
                            $(this).dialog('close');
                        },
                        Done: function() {
                            saveComment(accepted);
                        }
                    }

                }).dialog('open');
            }

            function openRequestItemsDailog() {
                var divTag = $("<div></div>");
                var ids = "";
                $("input[name='requestedItemId']").each(function() {
                    ids += "," + this.value;
                });
                $.ajax({
                    type: "post",
                    url: '<%=context%>/RequestItemServlet?op=listRequestItems',
                    data: {
                        ids: ids
                    },
                    success: function(data) {
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
                                        Cancel: function() {
                                            $(this).dialog('close');
                                        },
                                        Done: function() {
                                            var itemId, itemCode, itemName, className;
                                            var counter = $('#numberOfRequestedItems').val();
                                            $(this).find(':checkbox:checked').each(function() {
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
                                                        .append("<TD width=\"35%\" class=\"silver_footer\" bgcolor=\"#808000\" STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\">" + itemName + "</font></b></TD>")
                                                        .append("<TD width=\"11%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><input type=\"hidden\" id=\"requestedItemId" + counter + "\" name=\"requestedItemId\" value=\"" + itemId + "\"/><input type=\"hidden\" id=\"id" + counter + "\" name=\"id\" /><input type=\"text\" id=\"quantity" + counter + "\" name=\"quantity\" value=\"1\" style=\"text-align: center; width: 100%\"/></TD>")
                                                        .append("<TD width=\"11%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><select id=\"valid" + counter + "\" name=\"valid\" style=\"width: 100%\"><option value=" + <%=CRMConstants.REQUEST_ITEM_ACCEPTED%> + ">مقبول</option><option value=" + <%=CRMConstants.REQUEST_ITEM_NOT_ACCEPTED%> + ">مرفوض</option></select></TD>")
                                                        .append("<TD width=\"25%\" STYLE=\"text-align: center; border-left-width: 0px\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><input type=\"text\" id=\"requestedItemNote" + counter + "\" name=\"requestedItemNote\" value=\"\" style=\"width: 100%\"/></TD>")
                                                        .append("<TD width=\"10%\" STYLE=\"text-align: center; border-left-width: 0px\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><input type=\"button\" class=\"button-remove\" id=\"remove" + counter + "\" name=\"remove\" onclick=\"JavaScript: removeRow('" + counter + "')\" /></TD>");
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
            function removeRow(rowNo) {
                $("#row" + rowNo).remove();
                var counter = $('#numberOfRequestedItems').val();
                for(var i = rowNo; i < counter; i++){
                    $("#row"+i).attr("id", "row" + (i - 1));
                    $("#requestedItemId"+i).attr("id", "requestedItemId" + (i - 1));
                    $("#id"+i).attr("id", "id" + (i - 1));
                    $("#quantity"+i).attr("id", "quantity" + (i - 1));
                    $("#valid"+i).attr("id", "valid" + (i - 1));
                    $("#requestedItemNote"+i).attr("id", "requestedItemNote" + (i - 1));
                    $("#remove"+i).attr('onclick', 'JavaScript: removeRow("' + (i - 1) + '")');
                    $("#remove"+i).attr("id", "remove" + (i - 1));
                }
                $('#numberOfRequestedItems').val(--counter);
            }
            function openUnitsDailog() {
                var divTag = $("<div></div>");
                var projectID = $("#projectID").val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/UnitServlet?op=listUnitByProject',
                    data: {
                        projectID: projectID
                    },
                    success: function(data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "بحث عن وحدة",
                                    show: "fade",
                                    hide: "explode",
                                    width: 500,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function() {
                                            $(this).dialog('close');
                                        },
                                        Done: function() {
                                            $("#unitNo").val($('input:radio[name=unitName]:checked').val());
                                            $(this).dialog('close');
                                        }
                                    }
                                }).dialog('open');
                    }
                });
            }
            function clearUnitName() {
                $("#unitNo").val('');
            }
            function linkToIssue(issueID, customerID) {
                var divTag = $('<div></div>');
                $.ajax({
                    type: "post",
                    url: "<%=context%>/SearchServlet?op=getAllValidRequests&singleSelect=true&issueID=" + issueID + "&customerID=" + customerID,
                    success: function(data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "أختيار طلب تسليم",
                                    show: "fade",
                                    hide: "explode",
                                    width: 1100,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function() {
                                            location.href = "<%=context%>/IssueServlet?op=openCommentHierariecy&clientId=" + customerID;
                                            $(this).dialog('close');
                                        },
                                        Done: function() {
                                            loading("block");
                                            var id = $('input[name=selectForLink]:checked').val();
                                            if(!isNaN(id)) {
                                                location.href = "<%=context%>/IssueServlet?op=openCommentHierariecy&clientId=" + customerID + "&dependOnID=" + id;
                                            }
                                            $(this).dialog('close');
                                        }
                                    }
                                }).dialog("open");
                    }
                });
            }
            function loading(val) {
                if (val === "none") {
                    $('#loading').fadeOut(2000, function() {
                        $('#loading').css("display", val);
                    });
                } else {
                    $('#loading').fadeIn("fast", function() {
                        $('#loading').css("display", val);
                    });
                }
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
        input.button-remove {
            background-image: url(images/icons/remove.png); /* 32px x 32px */
            background-color: transparent; /* make the button transparent */
            background-repeat: no-repeat;  /* make the background image appear only once */
            background-position: 0px 0px;  /* equivalent to 'top left' */
            background-size: 27px 27px;
            border: none;           /* assuming we don't want any borders */
            cursor: pointer;        /* make the cursor like hovering over an <a> element */
            height: 27px;           /* make this the size of your image */
            padding-left: 27px;     /* make text start to the right of the image */
            vertical-align: middle; /* align the text vertically centered */
        }
        </style>
    </head>
    <body>
        <div></div>
        <div align="left" style="color:blue; margin-left: 2.5%">
            <!--button type="button" onclick="saveComment('no');" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px;">رفض&ensp;<img src="images/icons/delete_ready.png" alt="" height="16" width="16" /></button-->
            <button type="button" onclick="saveComment('yes');" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">حفظ&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18" /></button>
            <!--button type="button" onclick="saveComment('yes_with_note');" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">مقبول بملاحظات&ensp;<img src="images/icons/accept-with-note.png" alt="" height="18" width="18" /></button-->
        </div>
        <br>
        <br>
        <div id="acceptedDailog" style="width: 40%;display: none;">
            <div class="login" style="width:100%;margin-left: auto;margin-right: auto;">
                <TABLE class="backgroundTable" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="RIGHT" DIR="rtl">
                    <tr>
                        <td style="width: 30%;" class="backgroundHeader"><font color="black" size="3">ملاحظات القبول: </font></TD>
                        <td style="width: 70%;"><TEXTAREA cols="40" rows="5" name="finishComment" id="finishComment" style="width: 100%"></TEXTAREA></TD>
                    </TR>
                </table>
            </div>
        </div>
        <FIELDSET class="set" style="width:95%;border-color: #006699">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td class="titlebar" style="text-align: center">
                        <font color="#005599" size="4">تسليم جودة</font>
                    </td>
                </tr>
            </table>
            <form name="COMMENT_FORM" method="post" enctype="multipart/form-data">
                <%if (status != null && status.equals("OK")) {%>
                    <br>
                    <table align="center" dir="ltr" WIDTH="70%">
                        <tr>
                            <td class="backgroundHeader">
                                <font size="3" color="blue">تم الحفظ بنجاح</font>
                            </td>
                        </tr>
                    </table>
                <%} else if (status != null && status.equals("Failed")) {%>
                    <br>
                    <table align="center" dir="ltr" WIDTH="70%">
                        <tr>
                            <td class="backgroundHeader">
                                <font size="3" color="red">لم يتم الحفظ</font>
                            </td>
                        </tr>
                    </table>
                <%}%>
                <% if (message != null) {%>
                    <br>
                    <table align="center" dir="ltr" WIDTH="70%">
                        <tr>
                            <td class="backgroundHeader">
                                <font size="3" color="red"><%=message%></font>
                            </td>
                        </tr>
                    </table>
                <% }%>
                    <br>
                    <div style="float: right; width: 39%">
                    <table id="" class="excelentCell" align="RIGHT" dir="rtl" width="100%" CELLPADDING="0" CELLSPACING="0" style="margin-right: 5px; margin-bottom: 5px">
                        <thead>
                            <tr>
                                <td style="font-size: 16px; font-weight: bold; border-width: 0px; padding-bottom: 3px; padding-top: 3px"><font color="#005599">المعلومات الأساسية</font></td>
                            </tr>
                        </thead>
                    </table>
                    <TABLE class="excelentCell" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="RIGHT" DIR="rtl" style="margin-right: 5px; margin-bottom: 5px">
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none;width: 25%" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">المقاول:</font>
                            </td>
                            <td style="text-align:Right; padding-right: 5px; border: none">
                                <label><font color="black" size="3"> <%=client.getAttribute("name")%> </font></label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">المشروع :</font>
                            </td>
                            <td style="border: none;text-align: right">
                                <select style="font-size: 14px;font-weight: bold; width: 180px;" id="projectID" name="projectID" 
                                        onchange="JavaScript: clearUnitName();">
                                    <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">المهندس المسؤول :</font>
                            </td>
                            <td style="border: none;text-align: right">
                                <select style="font-size: 14px;font-weight: bold; width: 180px;" id="engineerID" name="engineerID" >
                                    <sw:WBOOptionList wboList='<%=engineersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=engineerID%>"/>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">التاريخ :</font>
                            </td>
                            <td style="border: none;text-align: right">
                                <input id="deliveryDate" readonly name="deliveryDate" type="text" style="width: 150px" value="<%=now%>" />                 
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">رقم الوحدة:</font>
                            </td>
                            <td style="border: none;text-align: right" >
                                <input type="text" id="unitNo" name="unitNo" style="width: 180px" readonly="true" value="<%=unitNo%>" />
                                <button type="button" id="unitSearch" onclick="openUnitsDailog();" style="width: 70px; margin-bottom: 5px; margin-left: 4px">بحث&ensp;</button>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="silver_footer">
                                <font color="black" size="3"> المراجعة الاولى:</font>
                            </td>
                            <td style="text-align:Right; border: none">
                                <textarea id="comments" name="comments" style="width: 95%" rows="3" cols="40" maxlength="2000"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">اﻷعتماد علي طلب تسليم:</font>
                            </td>
                            <td style="border: none;text-align: right" >
                                <input type="text" id="dependOnNo" name="dependOnNo" style="width: 180px; color: red; font-weight: bold;" readonly="true" value="<%=businessID%>" />
                                <input type="hidden" name="dependOnID" value="<%=dependOnID%>"/>
                                <button type="button" id="issueSearch" onclick="linkToIssue(null, '<%=client.getAttribute("id")%>');" style="width: 70px; margin-bottom: 5px; margin-left: 4px">بحث&ensp;</button>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">نوع اﻷعتماد:</font>
                            </td>
                            <td style="border: none;text-align: right" >
                                <select id="dependType" name="dependType" style="font-size: 14px;font-weight: bold; width: 180px;">
                                    <option value="1">أعادة</option>
                                    <option value="2">تكملة</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                    </div>
                    <table id="" class="excelentCell" align="left" dir="rtl" width="59%" CELLPADDING="0" CELLSPACING="0" style="margin-left: 5px; margin-bottom: 5px">
                        <thead>
                            <tr>
                                <td style="font-size: 16px; font-weight: bold; border-width: 0px; padding-bottom: 3px; padding-top: 3px"><font color="#005599">بنود الأعمال</font></td>
                            </tr>
                        </thead>
                    </table>
                    <table id="requestedItems" class="excelentCell" align="left" dir="rtl" width="59%" CELLPADDING="0" CELLSPACING="0" style="margin-left: 5px; margin-bottom: 5px">
                        <thead>
                            <tr>
                                <td class="blueBorder blueHeaderTD" width="8%">كود</td>
                                <td class="blueBorder blueHeaderTD" width="35%">أسم</td>
                                <td class="blueBorder blueHeaderTD" width="11%">كمية</td>
                                <td class="blueBorder blueHeaderTD" width="11%">موافق</td>
                                <td class="blueBorder blueHeaderTD" width="25%">تعليق</td>
                                <td class="blueBorder blueHeaderTD" width="10%">&nbsp;</td>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int counter = 0;
                                if (itemsDependOnList != null) {
                                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                                    WebBusinessObject itemWbo;
                                    for (WebBusinessObject requestItemWbo : itemsDependOnList) {
                                        itemWbo = projectMgr.getOnSingleKey((String) requestItemWbo.getAttribute("projectId"));
                                        if (itemWbo != null) {
                            %>
                            <tr id="row<%=counter%>">
                                <td width="8%" style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                    <b><font size="2" color="#000080" style="text-align: center;"><%=itemWbo.getAttribute("eqNO")%></font></b>
                                </td>
                                <td width="35%" class="silver_footer" bgcolor="#808000" style="text-align:center; color:black; font-size:14px; height: 25px">
                                    <b><font color="#000080" style="text-align: center;"><%=itemWbo.getAttribute("projectName")%></font></b>
                                </td>
                                <td width="11%" style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                    <input type="hidden" id="requestedItemId<%=counter%>" name="requestedItemId" value="<%=itemWbo.getAttribute("projectID")%>">
                                    <input type="hidden" id="id<%=counter%>" name="id">
                                    <input type="text" id="quantity<%=counter%>" name="quantity" value="1" style="text-align: center; width: 100%">
                                </td>
                                <td width="11%" style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                    <select id="valid<%=counter%>" name="valid" style="width: 100%">
                                        <option value="1">مقبول</option>
                                        <option value="0">مرفوض</option>
                                    </select>
                                </td>
                                <td width="25%" style="text-align: center; border-left-width: 0px" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                    <input type="text" id="requestedItemNote<%=counter%>" name="requestedItemNote" value="" style="width: 100%">
                                </td>
                                <td width="10%" style="text-align: center; border-left-width: 0px" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                    <input type="button" class="button-remove" id="remove<%=counter%>" name="remove" onclick="JavaScript: removeRow('<%=counter%>')">
                                </td>
                            </tr>
                            <%
                                            counter++;
                                        }
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    <button type="button" id="btnRequestItems" onclick="openRequestItemsDailog();" style="float: left; width: 150px; margin-bottom: 5px; margin-left: 4px">أضافة بند عمل&ensp;<img src="images/short_cut_icon.png" alt="" height="18" width="18" /></button>
                    <table id="" class="excelentCell" align="left" dir="rtl" width="59%" CELLPADDING="0" CELLSPACING="0" style="float: bottom; margin-left: 5px; margin-bottom: 5px">
                        <thead>
                            <tr>
                                <td style="font-size: 16px; font-weight: bold; border-width: 0px;"><img src="images/icons/attachment.png" alt="" height="24" width="24" />&ensp;<font color="#005599">إرفاق ملف</font></td>
                            </tr>
                        </thead>
                    </table>
                    <table id="" class="excelentCell" align="left" dir="rtl" width="59%" CELLPADDING="0" CELLSPACING="0" style="float: bottom; margin-left: 5px; margin-bottom: 5px">
                        <thead>
                            <tr>
                                <td style="font-size: 16px; font-weight: bold; border-width: 0px;"><input type="file" name="file1" style="height: 25px" id="file1"></td>
                            </tr>
                        </thead>
                    </table>

                <input type="hidden" id="numberOfRequestedItems" value="<%=counter%>" />
            </form>
        </fieldset>
    </body>
</html>
