<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            WebBusinessObject commentWbo = (WebBusinessObject) request.getAttribute("commentWbo");
        %>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script src="js/jquery/fileupload/jquery.form.js" ></script>
        <script type="text/javascript">
            function saveComplaintComment() {
                var commentId = $("#commentId").val();
                var comment = $("#comment").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=updateCommentAjax",
                    data: {
                        commentId: commentId,
                        comment: comment
                    }
                    ,
                    success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
                            alert("تم التعديل بنجاح");
                            closePopup();
                        } else if (eqpEmpInfo.status == 'no') {
                            alert("error");
                        }
                    }
                });
            }
        </script>
    </head>
    <body>
        <%
            if (commentWbo != null) {
        %>
        <form id="CommentForm" action="CommentsServlet?op=saveCommentPopup" method="post">
            <input type="hidden" name="commentId" id="commentId" value="<%=commentWbo.getAttribute("id")%>" />
            <table border="0px" style="width:100%;" class="table" dir="rtl">
                <tr>
                    <td style="font-size: 16px;font-weight: bold;width: 20%;" class="td">التعليق</td>
                    <td style="width: 80%;" >
                        <textarea  placeholder="" style="width: 100%;height: 80px;" id="comment" name="comment" >
                            <%=commentWbo.getAttribute("comment")%>
                        </textarea>
                    </td>
                </tr> 
            </table>
            <div style="text-align: center;margin-left: auto;margin-right: auto;">
                <input type="button" value="ألغاء" onclick="JavaScript: closePopup();"
                       style="width: 100px; height: 25px; float: left; font-weight: bolder; font-size: 13px;"/>
                <div style="width: 15px; float: left;">&nbsp;&nbsp;</div>
                <input type="button" value="تعديل" onclick="JavaScript: saveComplaintComment();"
                       style="width: 100px; height: 25px; float: left; font-weight: bolder; font-size: 13px;"/>
            </div>
            <div id="message"></div>
        </form>
        <%
        } else {
        %>
        <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;text-align: center;">لايوجد تعليق</div>
        <%
            }
        %>
    </body>
</html>