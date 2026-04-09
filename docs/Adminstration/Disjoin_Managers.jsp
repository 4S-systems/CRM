<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> arrayOfManagers = (ArrayList<WebBusinessObject>) request.getAttribute("managers");
        String[] header = {"", "اسم المدير", "عدد المرؤوسين"};

    %>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function() {
                oTable = $('#managers').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });

            function disJoinManagers() {

                for (var i = 0; i < <%=arrayOfManagers.size()%>; i++) {
                    var clientDeleted = $("#disjoin" + i + ":checked").val();
                    if (clientDeleted === "on") {
                        var managerID = $("#userid" + i).val();
                        $.ajax({
                            type: 'POST',
                            url: "<%=context%>/EmployeeServlet?op=disjoinMgr",
                            data: {managerID: managerID},
                            success: function(jsonSting) {

                            }
                        });
                    }
                }
                document.location.reload();
            }
            function closePopup (obj){
             $(obj).bPopup().close();
//             $('#show_emp').css("display", "none");
//             $('#show_emp').bPopup().close();
            }
            function getEmployeesByManagerCode (obj){
            var managerID = $("#userid"+obj).val();
            
            var url = "<%=context%>/EmployeeServlet?op=getEmployeeUnderManager&managerID=" +managerID;
            jQuery('#show_emp').load(url);
            $('#show_emp').show();
            $('#show_emp').css("display", "block");
            $('#show_emp').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
            }
        </script>
    </head>
    <body>
         <div id="show_emp"   style="width: 30%;display: none;position: fixed;margin-left: auto;margin-right: auto">
        </div>
        <fieldset align=center class="set" style="width: 90%">
            <legend>
                <table>
                    <tr>
                        <td>
                            <font color="blue" size="6">
                            عرض المديرين 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <br>
            <center> <b> <font size="3" color="red"> 
                    عدد المديرين: <%=arrayOfManagers.size()%>
                    </font></b>
            </center> 
            <input type="button" onclick="disJoinManagers();" value="DisJoin Managers"/>
            <br>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="center" dir="rtl" id="managers" style="width:100%;">
                    <thead>
                        <%
                            for (int i = 0; i < header.length; i++) {
                        %>
                    <th>
                        <B><%=header[i]%></B>
                    </th>
                    <%}%>
                    </thead>
                    <tbody>

                        <%
                            WebBusinessObject wbo;
                            for (int k = 0; k < arrayOfManagers.size(); k++) {
                                wbo = arrayOfManagers.get(k);
                        %>
                        <tr>
                            <td>
                                <input type="checkbox" id="disjoin<%=k%>" name="disjoin<%=k%>" />
                            </td>
                            <td>
                                <div>
                                    <b><%=wbo.getAttribute("username")%></b>
                                    <input type="hidden" id="userid<%=k%>" name="userid<%=k%>" value=<%=wbo.getAttribute("userid")%> >
                                </div>
                            </td>

                            <td>
                                <div>
                                    <a onclick="getEmployeesByManagerCode(<%=k%>);"><b><%=wbo.getAttribute("managerCount")%></b></a> 
                                </div>
                            </td>

                        </tr>
                        <%}%>
                    </tbody>
                </table>
            </div>
        </fieldset>
    </body>
</html>
