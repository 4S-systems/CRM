<%-- 
    Document   : sparePartsList
    Created on : Sep 13, 2017, 4:26:01 PM
    Author     : fatma
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>

<c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
  <c:set var="loc" value="${sessionScope.currentMode}"/>
</c:if>

<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Projects.Projects"  />

<%
    ArrayList<WebBusinessObject> sprPrtLst = request.getAttribute("sprPrtLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("sprPrtLst") : null;
    int totalSprPrt = sprPrtLst.size();
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
%>
    
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Spare Parts </title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        
        <script>
            $(document).ready(function (){
                $("#sprPrtsTable").dataTable({
                     bJQueryUI: true,
                    "bPaginate": true,
                    "bProcessing": true,
                    "bFilter": true
                }).fadeIn(2000);
                
                $("#checkAll").change(function (){
                    var checkBoxes = document.getElementsByName("sprPrtcheck");
                    var checked = this.checked;
                    if (checked){
                        for (var i = 0; i < checkBoxes.length; i++){
                            checkBoxes[i].checked = true;
                        }
                    } else {
                        for (var i = 0; i < checkBoxes.length; i++){
                            checkBoxes[i].checked = false;
                        }
                    }
                });
            });
            
            function validateForm(){
                var checkBoxes = document.getElementsByName("sprPrtcheck");
                var checkBoxesindex = document.getElementsByName("sprPrtcheckIndex");
                var checkedNumber=0;
                for (var i = 0; i < checkBoxes.length; i++){
                    if (checkBoxes[i].checked === true){
                        checkBoxesindex[i].value="1";
                        checkedNumber++
                    }
                }
                
                if (checkedNumber <= 0){
                    alert(" Choose One Spare Part At Least ");
                    return false;
                } else {
                    return true;
                }
            }
        </script>
        
        <style>
            .silver_header{
                text-align: center;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <fieldset align="center" class="set" style="width: 80%;">
            <legend align="center">
                <font color="blue" size="6">
                    Spare Parts 
                </font>
            </legend>
             
            <center>
                <b>
                    <font size="3" color="red">
                         <fmt:message key="sprPrtNum" />: <%=totalSprPrt%> 
                    </font>
                </b>
            </center>
                    
            <form action="<%=context%>/ProjectServlet?op=getSparePartsList" name="updateSprPrtsForm" method="POST" onsubmit="return validateForm()">
                <div style="padding-left: 20%; padding-right: 20%; padding-bottom: 5%; padding-top: 5%;">
                    <input type="submit" class="button" value="Update" style="float: <fmt:message key="align" />; width: 10%; text-align: center;"/>
                </div>
                
                <div style="width: 80%; padding-right: 10%; padding-left: 10%;">
                    <table id="sprPrtsTable" align="center" style="direction: <fmt:message key="direction" />" width="100%">
                        <thead>
                            <TR>
                                <th class="silver_header" style="width: 20%;">
                                    <input type="checkbox" id="checkAll"/>
                                </th>
                                
                                <th class="silver_header" style="width: 20%;">
                                     <fmt:message key="code" /> 
                                </th>
                                
                                <th class="silver_header" style="width: 20%;">
                                     <fmt:message key="sprPrtName" /> 
                                </th>
                                
                                <th class="silver_header" style="width: 20%;">
                                     <fmt:message key="cst" /> 
                                </th>
                                
                                <th class="silver_header" style="width: 20%;">
                                     <fmt:message key="quantity" /> 
                                </th>
                            </TR>
                        </thead>

                        <tbody>

                            <%
                                for (int i = 0; i < sprPrtLst.size(); i++){
                                    WebBusinessObject sprPrtWBO = (WebBusinessObject) sprPrtLst.get(i);
                            %>
                                <tr id="row">
                                    <td style="text-align: center;" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                        <input type="hidden" name="sprPrtcheckIndex" value="0">
                                        <input type="checkbox" name="sprPrtcheck" id="sprPrtcheck<%=i%>" value="<%=sprPrtWBO.getAttribute("projectID")%>"/>
                                    </td>

                                    <td style="text-align: center;" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                         <%=sprPrtWBO.getAttribute("eqNO")%> 
                                    </td>

                                    <td style="text-align: center;" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                         <%=sprPrtWBO.getAttribute("projectName")%> 
                                    </td>

                                    <td style="text-align: center;" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                       <input type="number" name="value" id="value<%=i%>" value="<%=sprPrtWBO.getAttribute("optionThree")%>" style="text-align: center;" min="1"/>
                                    </td>
                                    
                                    <td style="text-align: center;" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                       <input type="number" name="quantity" id="quantity<%=i%>" value="<%=sprPrtWBO.getAttribute("optionOne")%>" style="text-align: center;" min="0"/>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </form>
         </fieldset>
    </body>
</html>
