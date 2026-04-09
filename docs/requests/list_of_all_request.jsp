<%-- 
    Document   : list_of_all_request
    Created on : Jan 8, 2015, 1:15:56 PM
    Author     : walid
--%>

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
            ArrayList<WebBusinessObject> arrayOfRequests = (ArrayList<WebBusinessObject>) request.getAttribute("data");
            String issueID = (String) request.getAttribute("issueID");
            String shownOnly = (String) request.getAttribute("shownOnly");
            String singleSelect = (String) request.getAttribute("singleSelect");
        %>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script>
            $(document).ready(function() {
                $("table[name='requests']").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });
            function selectAll(obj) {
                $("input[name='selectForMapping']").prop('checked', $(obj).is(':checked'));
            }
        </script>
        <style type="text/css">
            /* loading progress bar*/
            .container {width: 100px; margin: 0 auto; overflow: hidden;}
            .contentBar {width:100px; margin:0 auto; padding-top:0px; padding-bottom:0px;}
            .barlittle {
                background-color:#2187e7;  
                background-image: -moz-linear-gradient(45deg, #2187e7 25%, #a0eaff); 
                background-image: -webkit-linear-gradient(45deg, #2187e7 25%, #a0eaff);
                border-left:1px solid #111; border-top:1px solid #111; border-right:1px solid #333; border-bottom:1px solid #333; 
                width:10px;
                height:10px;
                float:left;
                margin-left:5px;
                opacity:0.1;
                -moz-transform:scale(0.7);
                -webkit-transform:scale(0.7);
                -moz-animation:move 1s infinite linear;
                -webkit-animation:move 1s infinite linear;
            }
            #block_1{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            #block_2{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_3{
                -moz-animation-delay: .2s;
                -webkit-animation-delay: .2s;
            }
            #block_4{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_5{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            @-moz-keyframes move{
                0%{-moz-transform: scale(1.2);opacity:1;}
                100%{-moz-transform: scale(0.7);opacity:0.1;}
            }
            @-webkit-keyframes move{
                0%{-webkit-transform: scale(1.2);opacity:1;}
                100%{-webkit-transform: scale(0.7);opacity:0.1;}
            }
        </style>
    </head>
    <body>
        <table name="requests" dir="rtl" style="width: 100%">
            <thead>
                <tr>
                    <td style="width: 5%"></td>
                    <%
                    if (shownOnly == null) {
                        if(singleSelect != null && singleSelect.equals("true")) {
                    %>
                    <td style="width: 5%">&nbsp;</td>
                    <%
                        } else {
                    %>
                    <td style="width: 5%"><input type="checkbox" id="toggleAll" name="toggleAll" onclick="JavaScript: selectAll(this)" /></td>
                        <%
                        }    
                    }
                        %>
                    <td style="width: 12%">رقم المتابعة</td>
                    <td style="width: 25%">أسم المقاول</td>
                    <td style="width: 12%">كود الطلب</td>
                    <td style="width: 25%">المسئول</td>
                    <td style="width: 25%">حالة الطلب</td>
                    <td style="width: 25%">تاريخ الطلب</td>
                    <td style="width: 25%">ملاحظات</td>
                    <td style="width: 16%">عدد التعليقات</td>
                    <%
                        if (shownOnly != null) {
                    %>
                    <td style="width: 5%">&nbsp;</td>
                    <%
                        }
                    %>
                </tr>
            </thead>
            <tbody>
                <%
                    String compStyle = "";
                    for (int i = 0; i < arrayOfRequests.size(); i++) {
                        WebBusinessObject wbo = arrayOfRequests.get(i);
                        String fullName = (String) wbo.getAttribute("currentOwner");
                        if (fullName == null) {
                            fullName = "---";
                        }
                %>
                <tr>
                    <td><%=i + 1%></td>
                    <%
                    if (shownOnly == null) {
                        if(singleSelect != null && singleSelect.equals("true")) {
                    %>
                    <td><input id="selectForMapping" name="selectForLink" value="<%=wbo.getAttribute("issue_id")%>" type="radio"/></td>
                    <%
                        } else {
                    %>
                    <td><input id="selectForMapping" name="selectForMapping" value="<%=wbo.getAttribute("issue_id")%>" type="checkbox"/></td>
                    <%
                        }
                    }
                    %>
                    <td  style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                        <a href="#">
                            <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font>
                        </a>
                    </td>
                    <td>
                        <b><%=wbo.getAttribute("customerName")%></b>
                    </td>
                    <td>
                        <b><%=wbo.getAttribute("businessCompId")%></b>
                    </td> 
                    <td><b><%=fullName%></b></td>
                    <td style="background-color: #D4EAFF;"><b><%=wbo.getAttribute("statusName")%></b></td>
                    <td nowrap>
                        <b><%=wbo.getAttribute("entryDate") != null ? wbo.getAttribute("entryDate").toString().substring(0, 16) : "---"%></b>
                    </td>
                    <td>
                        <b><%=wbo.getAttribute("statusNote") != null ? wbo.getAttribute("statusNote") : "لا يوجد"%></b>
                    </td> 
                    <td>
                        <b><%=wbo.getAttribute("comments")%></b>
                    </td>
                    <%
                        if (shownOnly != null) {
                    %>
                    <td style="width: 5%"><a href="JavaScript: deleteRelation('<%=wbo.getAttribute("issue_id")%>')">حذف</td>
                    <%
                        }
                    %>
                </tr>
                <%}%>
            </tbody>
        </table>
        <div id="loading" class="container" style="float: left; margin-left: 0px; margin-bottom: 5px; margin-top: 15px; display: none">
            <div class="contentBar">
                <div id="block_1" class="barlittle"></div>
                <div id="block_2" class="barlittle"></div>
                <div id="block_3" class="barlittle"></div>
                <div id="block_4" class="barlittle"></div>
                <div id="block_5" class="barlittle"></div>
            </div>
        </div>
    </body>
</html>
