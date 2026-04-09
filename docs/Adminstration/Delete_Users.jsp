<%-- 
    Document   : Delete_Users
    Created on : Sep 27, 2014, 11:02:15 AM
    Author     : time
--%>

<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            Vector arrayOfUsers = (Vector) request.getAttribute("users");
            String[] header = {"<input type=\"checkbox\" id=\"toggle\" name=\"toggle\" onchange=\"markAllEmp()\" />","أسم المستخدم"};
        %>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
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
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            
            function markAllEmp (){
               var isChecked = $("#toggle").val();
               var count =0;
                for(var k=0 ; k < <%=arrayOfUsers.size()%>; k++ ){
                    var empName = $("#username"+k);
                    if(empName === "admin"){
                    }else{
                        if(isChecked === "on"){
                            if($("#disjoin"+k).attr("disabled") == true){
                                $("#disjoin"+k).attr("checked",false); 
                            } else{
                                $("#disjoin"+k).attr("checked",true);
                            }
                        } else if(isChecked === "off") {
                            $("#disjoin"+k).attr("checked",false);
                        }
//                    document.getElementById("#disjoin"+k).checked = true;
                    }
                    count++;
                }
                console.log("count "+ count);
                if(isChecked === "off"){
                    $("#toggle").val("on");
                } else {
                   $("#toggle").val("off"); 
                }
            }
            
            function disJoinEmployees() {
                for (var i = 0; i < <%=arrayOfUsers.size()%>; i++) {
                    var clientDeleted = $("#disjoin" + i + ":checked").val();
                    if (clientDeleted === "on") {
                        var empID = $("#userid" + i).val();
                        $.ajax({
                            type: 'POST',
                            url: "<%=context%>/EmployeeServlet?op=disjoinEmp",
                            data: {empID: empID},
                            success: function(jsonSting) {

                            }
                        });
                    }
                }
                document.location.reload();
            }
            
            function deleteRequests(userId){    
                $.ajax({
                    type: 'POST',
                    url: "<%=context%>/DatabaseControllerServlet?op=deleteRequestsAjax",
                    data: {userId: userId},
                    success: function(jsonSting) {

                    }
                });
                document.location.reload();  
            }
        </script>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <legend>
                <table>
                    <tr>
                        <td>
                            <font color="blue" size="6">
                            عرض الموظفين 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <center> 
                <b>
                    <font size="3" color="red"> 
                    عدد الموظفين     <%=arrayOfUsers.size()%>
                    </font>
                </b>
            </center> 
            <input type="button" onclick="disJoinEmployees();" value="DisJoin Employees"/>
            <br>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="center" dir="rtl" id="managers" style="width:100%;">
                    <thead>
                        <%
                    for(int i=0;i<header.length;i++){
                    %>
                    <th>
                        <B>
                            <!--<input type="checkbox" id="toggle" name="toggle" onchange="markAllEmp()" />-->
                            <%=header[i]%>
                        </B>
                    </th>
                    <%}%>
                    </thead>
                    <tbody>
                       
                        <%
                        WebBusinessObject wbo ;
                        for(int k=0;k<arrayOfUsers.size();k++){
                            wbo = (WebBusinessObject)arrayOfUsers.get(k);
                        %>
                        <tr>
                            <td>
                                <% if (wbo.getAttribute("userName").equals("admin")){%>
                                    <b>***</b>
                                <%}else{%>
                                    <%if(wbo.getAttribute("status") == "1"){%>
                                        <input type="checkbox" id="disjoin<%=k%>" name="disjoin<%=k%>" disabled="true" style="margin-right:140px; " />
                                        <input type="button" id="delReqs" name="delReqs" value="Delete All Requests" style="float:left; margin-left: 5px;" onclick="deleteRequests(<%=wbo.getAttribute("userId")%>)"/>
                                    <%} else {%>
                                        <input type="checkbox" id="disjoin<%=k%>" name="disjoin<%=k%>" />
                                    <%}%>
                                <%}%>
                            </td>
                            <td>
                                <div>
                                    <b id="username<%=k%>"><%=wbo.getAttribute("userName")%></b>
                                    <input type="hidden" id="userid<%=k%>" name="userid<%=k%>" value=<%=wbo.getAttribute("userId")%> >
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
