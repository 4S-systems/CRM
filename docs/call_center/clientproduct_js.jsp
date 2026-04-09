 
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        %>
        <script>
               function sendMailByAjax() {
        $("#progressx").css("display", "block");
        $("#progressx").show();
        $("#emailStatus").html("");
        $("#progressx").css("display", "block");
        var formData = new FormData($("#emailForm")[0]);
        var obj = $("#listFile");
        $.each($(obj).find("input[type='file']"), function (i, tag) {
            $.each($(tag)[0].files, function (i, file) {
                formData.append(tag.name, file);
            });
        });
        formData.append("to", $("#emailTo").val());
        formData.append("subject", $("#subj").val());
        formData.append("counter", $("#emailCounter").val());
        formData.append("message", $("#msgContent").val());
        $.ajax({
            url: '<%=context%>/EmailServlet?op=sendByAjax',
            type: 'POST',
            data: formData,
            async: false,
            success: function (data) {
                var result = $.parseJSON(data);
                $("#progressx").html('');
                $("#progressx").css("display", "none");
                if (result.status == 'ok') {
                    $("#emailStatus").html("<font color='white'>تم أرسال الرسالة</font>");
                } else if (result.status == 'error') {
                    $("#emailStatus").html("<font color='red'>لم يتم أرسال الرسالة</font>");
                }
            },
            error: function ()
            {
                $("#emailStatus").html("<font color='red'>لم يتم أرسال الرسالة</font>");
            },
            cache: false,
            contentType: false,
            processData: false
        });
        return false;
    }
       function submitClientFile() {
        $("#attachForm").find("#progressx").css("display", "block");
        $("#progressx2").show();
        $("#attachMessage").html("");
        $("#progressx2").css("display", "block");
        var formData = new FormData($("#attachForm")[0]);

        $.ajax({
            url: '<%=context%>/EmailServlet?op=attachFile',
            type: 'POST',
            data: formData,
            async: false,
            success: function (data) {
                var result = $.parseJSON(data);
                $("#progressx2").html('');
                $("#progressx2").css("display", "none");
                if (result.status == 'success') {
                    $("#attachMessage").html("<font color='white'>تم رفع الملفات</font>");
                } else if (result.status == 'failed') {
                    $("#attachMessage").html("<font color='red'>لم يتم رفع الملفات</font>");
                }
            },
            error: function ()
            {
                $("#attachMessage").html("<font color='red'>لم يتم رفع الملفات</font>");
            },
            cache: false,
            contentType: false,
            processData: false
        });

        return false;
    }
    
        </script>
            
    </head>
    <body>
       
    </body>
</html>
