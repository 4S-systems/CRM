<%-- 
    Document   : addBranchEqp
    Created on : Jul 14, 2012, 11:57:34 AM
    Author     : ahmed mohsen
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String status = (String) request.getAttribute("status");
            String message = null;
            String M1, M2 = "";
            M1 = "تم التسجيل بنجاح";
            M2 = "لم يتم التسجيل";
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Branch Equipment</title>
        <script type="text/javascript" src="js/jquery-1.2.6.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                $("tr:odd").css("background-color", "#BFBAB0");

            });
            function submitForm(){
                document.attchEqp.action="<%=context%>/ProjectServlet?op=SaveNewLocation&mainProjectId=<%=(String) request.getAttribute("mainProjectId")%>&backTo=projTree";
                document.attchEqp.submit();
                window.opener.document.location.reload();
                window.close();
            }
        </script>
        <style type="text/css">
            fieldset {
                float: left;
                clear: both;
                width: 100%;
                margin: 0 0 1.5em 0;
                padding: 0;
                border: 2px solid #BFBAB0;
                background-color: #F2EFE9;
            }
            legend {
                position: relative;
                font-size:90%;
                text-align:center;
            }
            table{
                margin: 2 em;
                border: 0px;
            }
            button{
                height: 30px;
                width: 70px;
                border: 5 groove sandybrown;
            }
        </style>
    </head>
    <body>
        <fieldset >
            <legend>
                Attach Branch Equipment
            </legend>
            <%
                        if (null != status) {
                            if (status.equalsIgnoreCase("ok")) {
                                message = M1;
                            } else {
                                if (status.equalsIgnoreCase("1062")) {
                                    message = M2;
                                } else {
                                    message = M2;
                                }
                            }
            %>
            <font color="red" size="+1" style="text-align: center"><%=message%></font>
            <%}%>
            <form name="attchEqp" method="post">
                <table  cellpadding="5" cellspacing="5">
                    <tr>
                        <td> Asset No / رقم الماكينه </td>
                        <td> <input type="text" name="assetNo" ></td>
                    </tr>
                    <tr>
                        <td> Equipment Name / إسم المعده </td>
                        <td> <input type="text" name="eqpName" ></td>
                    </tr>
                    <tr>
                        <td> Status / الحاله </td>
                        <td> <input type="text" name="status" ></td>
                    </tr>

                </table>
                <button onclick="submitForm()"> حفظ </button>
            </form>
        </fieldset>
    </body>
</html>
