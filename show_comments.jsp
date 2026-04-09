<%@page import="java.sql.Timestamp"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Issue.clientProduct" />
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
        ResourceBundle mybundle = ResourceBundle.getBundle("Languages.Issue.clientProduct");
        
        
    %>

    <script type="text/javascript">
        function removeComment(obj) {
            var commentId = $(obj).parent().parent().find("#commentId").val();
            var r = confirm('<fmt:message key="deleteMsg"/>');
            if(r) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=removeComment",
                    data: {
                        commentId: commentId
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            $(obj).parent().parent().parent().remove();
                            $(obj).parent().parent().parent().find("#hr").hide();
                            $(obj).parent().parent().parent().parent().find("#hr").hide();
                            $(obj).parent().parent().parent().parent().parent().find("#hr").hide();
                        }
                    }
                });
            }
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
                    success: function(jsonString) {
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

        <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>
        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: 300px;">
            <table  border="0px"  style="width:100%;"  class="blueBorder" id="showComment">
                <%
                    String ownerComment, type, createdBy, comment, commentId;
                    for (WebBusinessObject wbo : comments) {
                        ownerComment = (String) wbo.getAttribute("createdBy");
                        type = (String) wbo.getAttribute("type");
                        String commentType = null;
                        String fieldColor = null;
                        if (type == null || type.equals("0")) {
                            commentType =mybundle.getString("public");

                        } else if (type.equals("1")) {
                            commentType =mybundle.getString("public");
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
                        <table style="width:100%">
                            <tbody>
                                <tr>
                                    <td style="width:2%">
                                        <img src="images/dialogs/comment_channel.png" height="80px" style="display: <%=type != null && type.equals("2") ? "block" : "none"%>; text-align:center;"/>
                                        <img src="images/dialogs/comment_private.png" height="80px" style="display: <%=type != null && type.equals("1") ? "block" : "none"%>; text-align:center;"/>
                                        <img src="images/dialogs/comment_public.ico" height="80px" style="display: <%=type == null || type.equals("0") ? "block" : "none"%>; text-align:center;"/>
                                    </td>
                                    <td>
                                        <div style="text-align: right;clear: both;display: block;">
                                            <div style="float: right;width: 100%;color: white;text-align: left;">
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
        </div>
        <% } else { %>
        <div style="clear: both;margin-left: 68%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
        </div>
        <div class="login" style="width: 40%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
            <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;"><fmt:message key="nocomments"/></div>
        </div>
        <% }%>
    </body>
</html>