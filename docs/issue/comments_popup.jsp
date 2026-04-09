<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    HttpSession s = request.getSession();
    Vector<WebBusinessObject> comments = (Vector) request.getAttribute("comments");
    WebBusinessObject loggedUser = (WebBusinessObject) s.getAttribute("loggedUser");
    String loggedUserId = (String) loggedUser.getAttribute("userId");

    UserMgr userMgr = UserMgr.getInstance();
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Comments</title>
    </head>

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
        <table  class="blueBorder" id="showComment" align="center" DIR="RTL" style="width:100%;"  border="0px">
            <thead>
                <TR>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;"><b>التعليق</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;"><b>نوع التعليق</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;"><b>التاريخ</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;"><b>المصدر</b></TH>
                </TR>
            </thead>
            
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

            %>
            <tbody>
                <tr>
                    <td style="width:2%">
                        <b style="font-size: 14px;font-weight: bold;padding:15px"><%=comment%></b>
                    </td>
                    <td style="width:2%">
                        <b style="font-size: 14px;font-weight: bold;padding:15px"><%=commentType%> </b>
                    </td>
                    <td style="width:2%">
                        <b style="font-size: 14px;font-weight: bold;"><%=wbo.getAttribute("creationTime").toString().substring(0, wbo.getAttribute("creationTime").toString().length() - 5)%></b>
                    </td>
                    <td style="width:2%">
                        <b style="font-size: 14px;font-weight: bold;padding:15px"><%=createdBy%></b>
                    </td>
                </tr>
            </tbody>
            <%}%>
        </table>
        <% } else { %>
        <br>
    <center><b style="color: red; font-size: x-large;">لاتوجد تعليقات للمشاهدة</b></center>
        <% }%>
</body>
</html>
