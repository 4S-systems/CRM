<%-- 
    Document   : residential_model_list
    Created on : Sep 16, 2014, 12:57:01 PM
    Author     : walid
--%>

<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />
 
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
         ArrayList<WebBusinessObject> allResidential = (ArrayList<WebBusinessObject>)request.getAttribute("allResidentials");
        
	    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
	    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	    Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
	    ArrayList<String> userPrevList = new ArrayList<String>();
	    WebBusinessObject wboPrev;
	    for (int i = 0; i < groupPrev.size(); i++) {
		wboPrev = (WebBusinessObject) groupPrev.get(i);
		userPrevList.add((String) wboPrev.getAttribute("prevCode"));
	    }
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><fmt:message key="viewresmodels" /></title>
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
                oTable = $('#units').dataTable({
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
        <fieldset align=center class="set" style="width: 70%; border-color: #006699;">
            <legend>
                 <font color="#005599" size="5">
                            <fmt:message key="viewresmodels" />
                            </font>
                        
            </legend>
            
            <br>
            <center> <b> <font size="3" color="red"> 
                    <fmt:message key="resmodelsno" /> : <%=allResidential.size()%>
                    </font></b></center> 
            <br>
            <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="center"dir="<fmt:message key="direction" />" id="units" style="width:100%;">
                    <thead>
                    <th>
                         <B>&nbsp;</B>
                    </th>
                    <th><B><fmt:message key="projectname" /></B></th>
                    <th><B><fmt:message key="modelname" /></B></th>
                    <th><B><fmt:message key="modelcode" /></B></th>
                    <th><B><fmt:message key="area" /></B></th>
                    <th><B><fmt:message key="totalphotos" /> </B></th>
		    <th style="display: <%=userPrevList.contains("EDIT_APARTMENT_MODEL") ? "" : "none"%>;"><B><fmt:message key="editMdl" /> </B></th>
                    <th><B></B></th>
                    </thead>
                    <tbody>
                       
                        <%
                        WebBusinessObject wbo ;
                        for(int k=0;k<allResidential.size();k++){
                            wbo = allResidential.get(k);
                            
                        %>
                         <tr>
                             <td>
                                 <%=k+1%>
                             </td>
                             <td>
                                 <div>
                                     <b><%=wbo.getAttribute("optionOne") != null && !((String) wbo.getAttribute("optionOne")).equalsIgnoreCase("UL") ? wbo.getAttribute("optionOne") : wbo.getAttribute("Project_Name")%></b>  
                                 </div>
                             </td>
                             
                             <td>
                                 <div>
                                   <b> <%=wbo.getAttribute("Model_Code")%> </b> 
                                 </div>
                             </td>
                             <td>
                                 <div>
                                   <b> <%=wbo.getAttribute("Model_Name")%> </b> 
                                 </div>
                             </td>
                             <td>
                                 <div>
                                     <b><%=wbo.getAttribute("totalArea") != null ? wbo.getAttribute("totalArea") : "---"%></b>
                                 </div>
                             </td>
                             <td>
                                 <div>
                                     <b><%=wbo.getAttribute("countImages")%></b>
                                 </div>
                             </td>
			     
			     <td style="display: <%=userPrevList.contains("EDIT_APARTMENT_MODEL") ? "" : "none"%>;">
                                 <div>
                                   <b><a href="<%=context%>/UnitServlet?op=viewResidentialModel&id=<%=wbo.getAttribute("Model_ID")%>"> <fmt:message key="editMdl" /> </b> 
                                 </div>
                             </td>
                             
                             <td>
                                   
                                     <img onclick="JavaScript:openPopup('<%=context%>'+'/UnitDocWriterServlet?op=attach&projId='+'<%=wbo.getAttribute("Model_ID")%>'+'&type=tree');"
                                         width="19px" height="19px" src="images/icons/Attach.png" title='<fmt:message key="attachfile" />'
                                         alt='<fmt:message key="attachfile" />' style="margin: -4px 0; cursor: pointer; display: <%=userPrevList.contains("ATTACH_FILES") ? "" : "none"%>;"/>
                                    &nbsp;
                                     
                                     
                                      <img onclick="JavaScript:openPopup('<%=context%>'+'/UnitDocReaderServlet?op=ListAttachedDocs&projId='+'<%=wbo.getAttribute("Model_ID")%>')"
                                         width="19px" height="19px" src="images/unit_doc.png" title='<fmt:message key="listdocs" />' 
                                         alt='<fmt:message key="listdocs" />' style="margin: -4px 0; cursor: pointer; display: <%=userPrevList.contains("VIEW_ATTACHED_FILES") ? "" : "none"%>;"/>
                                    &nbsp;
                                    
                                    
                                    
                                    <img   onclick="JavaScript:openPopup('<%=context%>'+'/UnitDocReaderServlet?op=unitDocGallery&unitID='+'<%=wbo.getAttribute("Model_ID")%>');"
                                         width="25px" height="25px" src="images/gallery.png" title='<fmt:message key="showimages" />' alt='<fmt:message key="showimages" />'
                                         style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                             <%
                                 if (metaMgr.canDelete()) {
                             %>
                                     
                                         
                                         <img  width="15px" height="15px" src="images/icons/Close.png" title='<fmt:message key="delete" />' alt='<fmt:message key="delete" />'
                                         style="margin: -4px 0; cursor: pointer;  display: <%=userPrevList.contains("DELETE_APPARTMENT_UNIT") ? "" : "none"%>;"
                                          onclick="window.open('<%=context%>/UnitServlet?op=confirmDeleteModel&modelID=<%=wbo.getAttribute("Model_ID")%>&modelName=<%=wbo.getAttribute("Model_Name")%>','_self');" 
                                          />
                                         
                                         
                                         
                                  &nbsp;
                             <%
                                 }
                             %>
                             
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
