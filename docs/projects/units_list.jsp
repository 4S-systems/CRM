<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        ArrayList<WebBusinessObject> modelsList = (ArrayList<WebBusinessObject>) request.getAttribute("modelsList");
        String status= (String) request.getAttribute("status");
        String buildingId = (String) request.getAttribute("buildingId");
          
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            var oTable;
            $(document).ready(function() {
                oTable = $('#unitsList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            function submitForm()
            {
                if (!validateData("req", this.UNIT_LIST_FORM.modelID, "الرجاء أدخال نموذج سكني")) {
                    this.UNIT_LIST_FORM.modelID.focus();
                }
                else {
                    document.UNIT_LIST_FORM.action = "<%=context%>/ProjectServlet?op=saveUnitsModels";
                    document.UNIT_LIST_FORM.submit();
                }
            }
            function cancelForm()
            {
                document.UNIT_LIST_FORM.action = "<%=context%>/ProjectServlet?op=listBuildings";
                document.UNIT_LIST_FORM.submit();
            }
            
            function viewDocuments(parentId) {
            var url='<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId +'';
            var wind = window.open(url,"عرض المستندات","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }
        </SCRIPT>
        <style>
            #products
            {
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }
            #products tr
            {
                padding: 5px;
            }
            #products td
            {  
                font-size: 12px;
                font-weight: bold;
            }
            #products select
            {                
                font-size: 12px;
                font-weight: bold;
            }

        </style>

    </head>
    <BODY>
        <FORM NAME="UNIT_LIST_FORM" METHOD="POST">
           <TABLE style="width:85% ;" align='center'>
                 <TR>
                    <TD style="width: 10%; border: none">
                        <IMG class="img" style="cursor: pointer; padding-bottom: 95%;" width="40%" VALIGN="BOTTOM" onclick="JavaScript: cancelForm();" SRC="images/buttons/backBut.png" > 
                     </TD>
                     <TD style="width: 90%; border: none">
                         <fieldset align=center class="set" style="width: 90%">
                <legend align="center">

                    <table dir=<fmt:message key="direction"/> align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <fmt:message key="listunits" />
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("Ok")) {
                %>  
                              <font size=4 color="black">
                                <fmt:message key="saved"/>
                                </font> 
                                </br>
                            
                <%
                } else {%>
                                 <font size=4 color="red" >
                                    <fmt:message key="notsaved"/>
                                    </font> 
                                    </br>
                         
                <%}
                    }

                %>
                
                <input type="hidden" name="buildingId" value="<%=buildingId%>"/>
                <TABLE dir='<fmt:message key="direction" />' align="center">
                    <tr>
                        <td style="border: none ;  " >
                            <b style="font-size: medium; "><fmt:message key="unitmodel"/>   </b>
                        </td>
                        <td style="border: none ; width: 5%" ></td>
                        <td style="border: none">
                            <SELECT name="modelID" STYLE="text-align-last:center; width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitformCalls();">
                              <OPTION value=""></OPTION>
                                  <sw:WBOOptionList wboList="<%=modelsList%>" displayAttribute="projectName" valueAttribute="projectID"/>
                           </SELECT> 
                        </td>
                        <td style="border: none ; width: 5%" ></td>
                        <td style="border: none ; " >
                            <button onclick="JavaScript: submitForm(); return false;" class="button" style="width: 100%;">
                        <fmt:message key="update" />   
                     </button>
                        </td>
                      </tr>
                    
                </TABLE>
               
                 
                <br/>  
                <div style="width:90%;margin-right: auto;margin-left: auto;">
                    <TABLE ALIGN="center" dir='<fmt:message key="direction" />' id="unitsList" style="width:100%;">
                        <thead>
                            <TR>
                                <Th>
                                    <B>&nbsp;</B>
                                </Th>
                                <Th>
                                    <B><fmt:message key="unit" /></B>
                                </Th>
                                <Th>
                                    <B> <fmt:message key="unitmodel" /></B>
                                </Th>
                                <Th>
                                    <B> <fmt:message key="showattachments" />  </B>
                                </Th>
                                <Th>
                                    <B> <fmt:message key="status" /> </B>
                                </Th>
                                <Th>
                                    <B>&nbsp;</B>
                                </Th>
                            </TR>
                        </thead>
                        <tbody>
                            <%
    if (unitsList != null) {
            for (WebBusinessObject wbo : unitsList) {
                String unitName = (String) wbo.getAttribute("projectName");
                String unitStatusId = (String) wbo.getAttribute("statusName");
                String unitStatus = "";
                String color = "";
                String currentModel = "";
                if (wbo.getAttribute("statusName") != null) {
                    if (unitStatusId.equalsIgnoreCase("8")) {
                        unitStatus = "متاحة";
                        color = "green";
                    } else if (unitStatusId.equalsIgnoreCase("9")) {
                        unitStatus = "محجوزة";
                        color = "red";
                    } else if (unitStatusId.equalsIgnoreCase("10")) {
                        unitStatus = "مباعة";
                        color = "blue";
                    } else if (unitStatusId.equalsIgnoreCase("33")) {
                        unitStatus = "حجز مرتجع";
                        color = "purple";
                    }
                }
                if (wbo.getAttribute("eqNO") != null) {
                    if (!((String) wbo.getAttribute("eqNO")).equalsIgnoreCase("UL")) {
                        for (WebBusinessObject modelWbo : modelsList) {
                            if (((String) modelWbo.getAttribute("projectID")).equalsIgnoreCase(((String) wbo.getAttribute("eqNO")))) {
                                currentModel = (String) modelWbo.getAttribute("projectName");
                                break;
                            }
                        }
                    }
                }
                            %>
                            <TR>
                                <TD>
                                    <input type="checkbox" name="unitID" value="<%=wbo.getAttribute("projectID")%>"/>
                                </TD>
                                <TD>
                            <%=unitName%>
                                </TD>
                                <TD>
                            <%=currentModel%>
                                </TD>
                                <td>
                                    <img src="images/units/building.jpg" width="25" style="display: <%=((String) wbo.getAttribute("eqNO")).equalsIgnoreCase("UL") ? "none" : ""%>" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("eqNO")%>');"/>
                                </td>
                                <TD>
                                    <b style="color: <%=color%>;"><%=unitStatus%></b>
                                </TD>
                                <TD>
                                    <img src="images/available_house.JPG" width="25" style="display: <%=unitStatusId.equalsIgnoreCase("8") ? "" : "none"%>"/>
                                    <img src="images/reserved_house.JPG" width="25" style="display: <%=unitStatusId.equalsIgnoreCase("9") || unitStatusId.equalsIgnoreCase("33") ? "" : "none"%>"/>
                                    <img src="images/house.JPG" width="25" style="display: <%=unitStatusId.equalsIgnoreCase("10") ? "" : "none"%>"/>
                                </TD>
                                <%
                                        }
                                    }
                                %>
                            </TR>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
            </FIELDSET>
                         
                     </TD>
                 </TR>
           </TABLE>
               
       </FORM>
    </BODY>
</html>