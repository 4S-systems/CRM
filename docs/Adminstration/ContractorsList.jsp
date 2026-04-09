<%-- 
    Document   : ContractorsList
    Created on : Nov 18, 2014, 09:51:01 AM
    Author     : Haytham
--%>

<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
         String [] tableHeaderList = {"أسم المقاول","النشاط","مشاهدة","حذف"};
        ArrayList<WebBusinessObject> contractors = (ArrayList<WebBusinessObject>)request.getAttribute("contractors");
        
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
                oTable = $('#contractors').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            
            function openPopup(obj){
                var url =obj ;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=800,height=400");
            }
        </script>
        
    </head>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <legend>
                <table>
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            عرض المقاولين
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            
            <br>
            <center> <b> <font size="3" color="red"> 
                    عدد المقاولين : <%=contractors.size()%>
                    </font></b></center> 
            <br>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="center" dir="rtl" id="contractors" style="width:100%;">
                    <thead>
                    <th>
                         <B>&nbsp;</B>
                    </th>
                    <%
                    for(int i=0;i<tableHeaderList.length;i++){
                    %>
                    <th>
                        <B><%=tableHeaderList[i]%></B>
                    </th>
                    <%}%>
                    </thead>
                    <tbody>
                       
                        <%
                        WebBusinessObject wbo ;
                        for(int k=0;k<contractors.size();k++){
                            wbo =(WebBusinessObject)contractors.get(k);                            
                        %>
                         <tr>
                             <td>
                             </td>
                             <td>
                                 <div>
                                   <b><%=wbo.getAttribute("name")%></b>  
                                   <input type="hidden" id="contCode<%=k%>" name="contCode<%=k%>" value="<%=wbo.getAttribute("client_no")%>">
                                 </div>
                             </td>
                             
                             <td>
                                 <div>
                                   <b><%=wbo.getAttribute("job")%></b>
                                 </div>
                             </td>
                         
                             <td>
                                 <div>
                                     <b><a href="<%=context%>/ClientServlet?op=getUpdateContractorForm&clientID=<%=wbo.getAttribute("id")%>">مشاهدة
                                     &nbsp;/&nbsp; تعديل </a></b> 
                                 </div>
                             </td>
                             <td>
                                 <div>
                                     <b><a href="<%=context%>/ClientServlet?op=confirmDeleteContractor&clientID=<%=wbo.getAttribute("id")%>&clientName=<%=wbo.getAttribute("name")%>&clientNo=<%=wbo.getAttribute("name")%>"> حذف</a></b> 
                                 </div>
                             </td>
                        </tr>
                        <%}%>
                    </tbody>
                </TABLE>
                <br />
            </div>
        </fieldset>
    </body>
</html>
