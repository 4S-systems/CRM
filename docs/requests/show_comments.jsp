<%@page import="java.sql.Timestamp"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <head>
        <title></title>
    </head>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        HttpSession s = request.getSession();
        Vector<WebBusinessObject> comments = (Vector) request.getAttribute("comments");
        WebBusinessObject loggedUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String loggedUserId = (String) loggedUser.getAttribute("userId");

        UserMgr userMgr = UserMgr.getInstance();
    %>

    <script type="text/javascript">
        function removeComment(obj) {
            var commentId = $(obj).parent().parent().find("#commentId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=removeComment",
                data: {
                    commentId: commentId
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        $(obj).parent().parent().parent().remove();
                        $(obj).parent().parent().parent().find("#hr").hide();
                        $(obj).parent().parent().parent().parent().find("#hr").hide();
                        $(obj).parent().parent().parent().parent().parent().find("#hr").hide();
                    }
                }
            });
        }

        function editData(obj) {
            $(obj).parent().parent().parent().find("#commentText").css("display", "none");
            $(obj).parent().parent().parent().find("#commentArea").css("display", "block");
            $(obj).parent().find(".updateComment").attr("id", "updateComment");
            $(obj).parent().find("#updateComment").css("display", "block");
            $(obj).parent().find("#updateComment").css("background-position", "bottom");
        }

        function updateComment(obj) {
            if ($(obj).attr("id") === "updateComment") {
                var commentId = $(obj).parent().parent().find("#commentId").val();
                var comment = $(obj).parent().parent().parent().find("#commentArea").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=updateComment",
                    data: {
                        commentId: commentId,
                        comment: comment
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            $(obj).parent().parent().parent().find("#commentText").html(info.comment);
                            $(obj).parent().parent().parent().find("#commentText").css("display", "block");
                            $(obj).parent().parent().parent().find("#commentArea").css("display", "none");
                            $(obj).css("background-position", "top");
                            $(obj).removeAttr("id");
                        }
                    }
                });
            }
        }
    </script>
    <body>
        <% if (comments != null && !comments.isEmpty()) { %>
        <table  border="0px"  style="width:100%;"  class="blueBorder" id="showComment">
            <%
                String ownerComment, type, createdBy, comment, commentId;
                for (WebBusinessObject wbo : comments) {
                    ownerComment = (String) wbo.getAttribute("createdBy");
                    type = (String) wbo.getAttribute("type");
                    String commentType = null;
                    String fieldColor = null;
                    if (type.equals("0")) {
                        commentType = "تعليق عام";

                    } else if (type.equals("1")) {
                        commentType = "تعليق خاص";
                        fieldColor = "yellow";
                    } else if (type.equals("2")) {
                        commentType = "تعليق قناة";
                        fieldColor = "#B0B0B0 ";
                    }
                    createdBy = userMgr.getByKeyColumnValue(ownerComment, "key3");

                    comment = "";
                    if (wbo.getAttribute("comment") != null) {
                        comment = (String) wbo.getAttribute("comment");
                    }
                    commentId = (String) wbo.getAttribute("id");
                    if (loggedUserId.equals(ownerComment)) {
            %>
            <tr style="width: 100%; border-width: 0px">
                <td style="width: 100%; border-width: 0px" >
                    <div  style="float: left;text-align: left;width: 30%;clear: both;margin-bottom: 5px; border-width: 0px">
                        <div style="width: 100%;float: left; display: block;">
                            <div  id="removeComment" class="removeComment" onclick="removeComment(this)">
                                <input type="hidden" value="<%=commentId%>" id="commentId">
                            </div>
                            <div  id="editData" class="editComment" onclick="editData(this)" ></div>
                            <div id="updateComment" class="updateComment"  onclick="updateComment(this)" > 
                            </div> 
                        </div>
                    </div>
                    <% }%>
                    <table style="width:100%" dir="rtl">
                        <tbody>
                            <tr>
                                <td style="width:2%" class="td">
                                    <img src="images/dialogs/comment_channel.png" height="80px" style="display: <%=type.equals("2") ? "block" : "none"%>; text-align:center;"/>
                                    <img src="images/dialogs/comment_private.png" height="80px" style="display: <%=type.equals("1") ? "block" : "none"%>; text-align:center;"/>
                                    <img src="images/dialogs/comment_public.ico" height="80px" style="display: <%=type.equals("0") ? "block" : "none"%>; text-align:center;"/>
                                </td>
                                <td class="td">
                                    <div style="text-align: right;clear: both;display: block;">
                                        <div style="float: right;width: 100%;text-align: left;">
                                            <b style="font-size: 14px;font-weight: bold;padding:15px"><%=commentType%> </b>
                                            <br>
                                            <b style="font-size: 14px;font-weight: bold;">On <%=wbo.getAttribute("creationTime").toString().substring(0, wbo.getAttribute("creationTime").toString().length() - 5)%></b>
                                            <br>
                                            <b style="font-size: 14px;font-weight: bold;padding:15px"><%=createdBy%> Said </b>
                                        </div>
                                        <div style="text-align: center;">
                                            <textarea  readonly="true" disabled="true"placeholder="" style="height: 70px;width: 65%;float: none;background-color: <%=fieldColor%>;font-size: 17px;font-weight: bold;" id="commentText"><%=comment%></textarea>
                                            <textarea  style="height: 70px;display:none;width: 65%;float: none" id="commentArea" cols="" maxlength="150"><%=comment%></textarea>
                                        </div>
                                    </div> 
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <br/>
                    <hr style="width: 100%;clear: both;">
                </td>
            </tr> 
            <% } %>
        </table>
        <% } else { %>
        <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;text-align: center;">لاتوجد تعليقات للمشاهدة</div>
        <% }%>
    </body>
</html>