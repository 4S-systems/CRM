<%-- 
    Document   : deleteUnit
    Created on : Nov 13, 2017, 2:42:26 PM
    Author     : fatma
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
	
    ArrayList<WebBusinessObject> unitLst = request.getAttribute("unitLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("unitLst") : null;
    ArrayList<WebBusinessObject> projctLst = request.getAttribute("unitLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("projctLst") : null;
    
    String status = request.getAttribute("status") != null ? (String) request.getAttribute("status") : "";
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String delDn, nDelDn, dir, project, all;
    if (stat.equals("En")) {
	delDn = " Units Has Been Updated ";
	nDelDn = " Units Not Update ";
	dir = "LTR";
	project = " Project ";
	all = " All ";
    } else {
	delDn = " تم تحديث الوحدات ";
	nDelDn = " لم يتم تحديث الوحدات ";
	dir = "RTL";
	project = " مشروع ";
	all = " الكل ";
    }
%>

<!DOCTYPE html>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Units.Units"  />

    <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
    <script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.js"></script>
    
    <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    <link rel="stylesheet" href="css/demo_table.css">
    
    <script src="js/select2.min.js"></script>
    <link href="js/select2.min.css" rel="stylesheet">
    
    <script>
	$(document).ready(function() {
            $('#apartments').dataTable({
		bJQueryUI: true,
		sPaginationType: "full_numbers",
		"aLengthMenu": [[5, 10, 25, 50, 100, -1], [5, 10, 25, 50, 100, "All"]],
		iDisplayLength: 25,
		iDisplayStart: 0,
		"bPaginate": true,
		"bProcessing": true,
	    }).fadeIn(2000);
	    
	    $("#mainPrj").select2();
	    
	    <%
		if(status != null && status.equals("ok")){
	    %>
		    $("#nDelDn").hide();
		    $("#delDn").fadeIn();
	    <%
		status = "";
		} else if(status != null && status.equals("fail")){
	    %>
		    $("#delDn").hide();
		    $("#nDelDn").fadeIn();
	    <%
		status = "";
		} else {
	    %>
		    $("#delDn").hide();
		    $("#nDelDn").hide();
	    <%
		}
	    %>
        });
	
function deleteSelectedUnits(action) {
    var vals = [];
    var status = [];

    $('#deleteThis:checked').each(function () {
        var checkboxValue = $(this).val();
        vals.push(checkboxValue);
        
        // Check if the status is equal to "10" before pushing it to the status array
        if ($("#status" + checkboxValue).val() === "10") {
            status.push($("#projectName" + checkboxValue).val());
        }
    });

    // Check if any checkbox with id 'deleteThis' is checked and status is not empty
    if ($('#deleteThis:checked').length > 0 && status.length > 0) {
        if (window.confirm(" سيتم إيقاف بيع الوحدات التالية " + status.join(", "))) {
            var url = "<%=context%>/UnitServlet?op=deleteUnit&del=1&vals=" + vals + "&action=" + action;
            window.location.href = url;
        }
    } else {
        var url = "<%=context%>/UnitServlet?op=deleteUnit&del=1&vals=" + vals + "&action=" + action;
        window.location.href = url;
    }
}
	
	function getUnits(){
	console.log(" mainPrj = " + $("#mainPrj option:selected").val());
	    document.projectsFilter.action = "<%=context%>/UnitServlet?op=deleteUnit&mainPrj=" + $("#mainPrj option:selected").val();
	    document.projectsFilter.submit();
	}
    </script>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Delete Units </title>
    </head>
    <body>
	<fieldset align=center class="set" style="width: 80%; border-color: #006699;">
            <legend align="center">
                <font color="#005599" size="5">
		    <fmt:message key="delUnits" />
		</font>
            </legend>
		
	    
	    <label id="delDn" style="font-size: 25px; font-weight: bold; color: green; display: none;">
		 <%=delDn%> 
	    </label>
	    
	    <label id="nDelDn" style="font-size: 25px; font-weight: bold; color: red; display: none;">
		 <%=nDelDn%> 
	    </label>
	    
	    <form name="projectsFilter" method="post">
		 <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="50%">
		    <tr>
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
			    <b>
				<font size=3 color="white">
				     <%=project%> 
			    </b>
			</td>

			<TD style="text-align: center;" bgcolor="#dedede" valign="MIDDLE" WIDTH="50%">
			    <select style="font-size: 14px; font-weight: bold; width: 90%;" id="mainPrj" name="mainPrj" onchange="getUnits();">
				<option value="" selected> <%=all%> </option>
				<%
				    for (WebBusinessObject prjWbo : projctLst) {
				%>
					<option value="<%=prjWbo.getAttribute("projectID")%>" <%=prjWbo.getAttribute("projectID").equals(request.getAttribute("mainPrj")) ? "selected" : ""%>> <%=prjWbo.getAttribute("projectName")%> </option>
				<%
				    }
				%>
			    </select>
			</TD>
		 </table>
	    </form>
		
	    <div style="width: 80%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
                <TABLE ALIGN="center" dir='<fmt:message key="direction" />' id="apartments" style="width:100%;">
                    <thead>
                        <tr>
			    <TH style="width: 8%;">
				<B>
				      
				</B>
			     </TH>
			     
			    <TH style="width: 17%;">
				<B>
				     <fmt:message key="project" /> 
				</B>
			    </TH>
			    
                            <TH style="width: 16%;">
				<B>
				     <fmt:message key="unit" /> 
				</B>
			    </TH>
			    
                            <TH style="width: 15%;">
				<B>
				     <fmt:message key="commstate" /> 
				</B>
			    </TH>
			    
			    <TH style="width: 15%;">
				<B>
				     Status
				</B>
			    </TH>
			    
			    <TH style="width: 15%;">
				<B>
				     <fmt:message key="CreationTime" /> 
				</B>
			    </TH>
			    
                            <TH style="width: 15%;">
                                <img id="lockButton" src="images/icons/stop.png" alt="Lock" width="30" height="30" style="cursor: pointer;" onclick="deleteSelectedUnits('lock')" title="Lock" />
                                 <img id="unlockButton" src="images/icons/done.png" alt="Lock" width="30" height="30" style="cursor: pointer;" onclick="deleteSelectedUnits('unlock')" title="UnLock" />
                            </TH>
                        </tr>
                    </thead>
		    
                    <tbody>
                        <%
                            int counter = 1;
                            for (WebBusinessObject unitWbo : unitLst) {
                        %>
				<tr>
				    <td>
					 <%=counter%> 
				    </td>
				    
				    <td>
					<div>
					    <b>
						 <%=unitWbo.getAttribute("prjNm")%> 
					    </b>
					</div>
				    </td>
				    
				    <td>
					<div>
					    <b>
						 <%=unitWbo.getAttribute("projectName")%> 
					    </b>
					</div>
				    </td>
				    
				    <td>
					<%
					    String color = "";
					    String unitStatus = (String) unitWbo.getAttribute("statusID");
					    if (unitStatus != null) {
						if (unitStatus.equalsIgnoreCase("8")) {
						    color = "green";
						} else if (unitStatus.equalsIgnoreCase("9")) {
						    color = "red";
						} else if (unitStatus.equalsIgnoreCase("10")) {
						    color = "blue";
						} else if (unitStatus.equalsIgnoreCase("33")) {
						    color = "purple";
						} else if (unitStatus.equalsIgnoreCase("28")) {
						    color = "lightblue";
						}
					    }
					%>
					<b style="color: <%=color%>">
					    <%
						if (stat.equals("En")) {
				            %>
						     <%=unitWbo.getAttribute("statusNameEn")%> 
				            <%
						} else {
					    %>
						     <%=unitWbo.getAttribute("statusNameAr")%> 
					    <%
						}
					    %>
					</b>
				    </td>
				    
				    <td>
					<div>
					    <b>
                                               <% if (unitWbo.getAttribute("newCode").equals("Y")) { %>
						    Lock
					       <% } else if (unitWbo.getAttribute("newCode").equals("N")) { %>
						    UnLock
						<% } else { %>
						    -----
                                                <% } %> 
					    </b>
					</div>
				    </td>
				    
				    <td>
					<div>
					    <b>
						 <%=unitWbo.getAttribute("creationTime")%> 
					    </b>
					</div>
				    </td>
				    
				    <td>
					 <input class="apartmentCheckbox" type="checkbox" id="deleteThis" name="deleteThis" value="<%=unitWbo.getAttribute("projectID")%>"/>
					 <input type="hidden" id="status<%=unitWbo.getAttribute("projectID")%>" name="status" value="<%=unitWbo.getAttribute("statusID")%>"/>
					 <input type="hidden" id="projectName<%=unitWbo.getAttribute("projectID")%>" name="projectName" value="<%=unitWbo.getAttribute("projectName")%>"/>
				    </td>
				</tr>
                        <%
                                counter++;
                            }
                        %>
                    </tbody>
                </table>
            </div>
	</fieldset>
    </body>
</html>