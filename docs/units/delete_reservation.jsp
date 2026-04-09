<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String id = (String) request.getAttribute("id");
            String unitName = (String) request.getAttribute("unitName");
            String clientName = (String) request.getAttribute("clientName");
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
            function deleteReservation() {
                var id = $("#id").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=deleteReservationByAjax",
                    data: {
                        id: id
                    }
                    ,
                    success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
                            alert("تم الحذف بنجاح");
                            closePopup();
                            location.reload();
                        } else if (eqpEmpInfo.status == 'no') {
                            alert("خطأ لم يتم الحذف");
                            closePopup();
                        }
                    }
                });
            }
        </script>
    </head>
    <body>
        <form id="ReservationForm" action="UnitServlet?op=deleteReservationByAjax" method="post">
            <input type="hidden" name="id" id="id" value="<%=id%>" />
            <table border="0px" style="width:100%;" class="table" dir="rtl">
                <tr>
                    <td style="font-size: 16px;font-weight: bold;width: 20%;" class="td" nowrap>كود الوحدة</td>
                    <td style="width: 80%;" nowrap>
                        <%=unitName%>
                    </td>
                </tr> 
                <tr>
                    <td style="font-size: 16px;font-weight: bold;width: 20%;" class="td" nowrap>العميل</td>
                    <td style="width: 80%;" nowrap>
                        <%=clientName%>
                    </td>
                </tr> 
            </table>
            <div style="text-align: center;margin-left: auto;margin-right: auto;">
                <input type="button" value="ألغاء" onclick="JavaScript: closePopup();"
                       style="width: 100px; height: 25px; float: left; font-weight: bolder; font-size: 13px;"/>
                <div style="width: 15px; float: left;">&nbsp;&nbsp;</div>
                <input type="button" value="حذف" onclick="JavaScript: deleteReservation();"
                       style="width: 100px; height: 25px; float: left; font-weight: bolder; font-size: 13px;"/>
            </div>
            <div id="message"></div>
        </form>
    </body>
</html>