<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String businessObjectId = request.getParameter("businessObjectId");
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
                var clientId = $("#businessObjectId").val();
                var type = $("#type").val();
                var comment = $("#comment").val();
                var businessObjectType = $("#businessObjectType").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=saveComment",
                    data: {
                        clientId: clientId,
                        type: type,
                        comment: comment,
                        businessObjectType: businessObjectType
                    }
                    ,
                    success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
                            alert("تم التسجيل بنجاح");
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
        <form id="CommentForm" action="CommentsServlet?op=saveCommentPopup" method="post">
            <input type="hidden" name="businessObjectId" id="businessObjectId" value="<%=businessObjectId%>" />
            <input type="hidden" name="type" id="type" value="0" />
            <input type="hidden" name="businessObjectType" id="businessObjectType" value="2" />
            <table border="0px" style="width:100%;" class="table" dir="rtl">
                <tr>
                    <td style="font-size: 16px;font-weight: bold;width: 20%;" class="td">التعليق</td>
                    <td style="width: 80%;" >
                        <textarea  placeholder="" style="width: 100%;height: 80px;" id="comment" name="comment" >
                        </textarea>
                    </td>
                </tr> 
            </table>
            <div style="text-align: center;margin-left: auto;margin-right: auto;">
                <input type="button" value="ألغاء" onclick="JavaScript: closePopup();"
                       style="width: 100px; height: 25px; float: left; font-weight: bolder; font-size: 13px;"/>
                <div style="width: 15px; float: left;">&nbsp;&nbsp;</div>
                <input type="button" value="حفظ" onclick="JavaScript: saveComplaintComment();"
                       style="width: 100px; height: 25px; float: left; font-weight: bolder; font-size: 13px;"/>
            </div>
            <div id="message"></div>
        </form>
    </body>
</html>