<%-- 
    Document   : projectNBHood
    Created on : Jun 14, 2017, 11:26:37 AM
    Author     : java3
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%>
<!DOCTYPE html>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Projects.Projects"/>
    
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        
        ArrayList<WebBusinessObject> areaLst = (ArrayList<WebBusinessObject>) request.getAttribute("areaLst");
        String areaID = request.getAttribute("projectID") != null ? (String) request.getAttribute("areaID") : "";
        
        ArrayList<WebBusinessObject> prjLst = (ArrayList<WebBusinessObject>) request.getAttribute("projectList");
    %>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
       
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <link rel="stylesheet" type="text/css" href="js/jquery.dataTables.css">
        
        <style type="text/css">
            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
        
        <script  type="text/javascript">
            $(document).ready(function () {
                $("#areaID").select2();
                
                $("#projcts").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "iDisplayLength": -1,
                    "bSort": false
                }).fadeIn(2000);
            });
            
            function isChecked() {
                var isChecked = false;
                $("input[name='prjID']").each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                    }
                });
                return isChecked;
            }
            
            function addPrj() {
                if (!isChecked()) {
                    alert('<fmt:message key="selectPrjMsg" />');
                    return false;
                } else {
                    document.prjForm.action = "<%=context%>/ProjectServlet?op=addProjectNB&save=true";
                    document.prjForm.submit();
                }
            }
            
            function selectAll(obj) {
                $("input[name='prjID']").prop('checked', $(obj).is(':checked'));
            }
        </script>
    </head>
    <body>
        <form name="prjForm" method="POST">
            <fieldset align=center class="set" style="border-color: #006699; width: 80%;">
                <legend align="center">
                    <font color="#005599" size="5">
                        <fmt:message key="prjArea"/>
                        </font>
                </legend>
                
                <table align="center" style="width: 60%;" dir=<fmt:message key="direction"/>>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size: 18px; border: none; width: 10%;">
                            <b>
                                <font size="3" color="white"><fmt:message key="area"/>
                            </b>
                        </td>
                        
                        <td style="text-align: center; border: none; width: 25%;">
                            <select name="areaID" id="areaID" style="width:100%; height: 100%; font-size: larger; text-align-last:center;">
                                <sw:WBOOptionList wboList="<%=areaLst%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=areaID%>"/>
                            </select>
                        </td>
                        
                        <td style="border: none; width: 10%; text-align: right;">
                            <button type="button" class="button" style="width: 100%;" onclick="addPrj();">
                                 <fmt:message key="add"/>
                             </button>
                        </td>
                    </tr>
                </table>
                
                <div style="width: 60%; margin-top: 10px; margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <table align="center" dir=<fmt:message key="direction" /> id="projcts" style="width:100%;">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" name="allPrj" id="allPrj" onclick="selectAll(this);"/>
                                </th>
                                
                                <th>
                                    <B>
                                        <fmt:message key="projects" />
                                    </B>
                                </th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <%
                                for (WebBusinessObject prjWbo : prjLst) {
                            %>
                            <tr>
                            
                            <td style="text-align: center">
                                <input type="checkbox" name="prjID" value="<%=prjWbo.getAttribute("projectID")%>"/>
                            </td>
                            
                            <%
                                String prjName = prjWbo.getAttribute("projectName") != null ?  (String) prjWbo.getAttribute("projectName") : "" ;
                            %>
                            <td>
                                <b>
                                    <%=prjName%>
                                </b>
                            </td>
                            
                            </tr>
                            <%}%>
                        </tbody>
                    </table>             
                </div>
            </fieldset>
       </form>
    </body>
</html>
