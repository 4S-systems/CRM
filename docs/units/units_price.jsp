<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <c:set var="loc" value="en" />
    <c:if test="${!empty sessionScope.currentMode}">
        <c:set var="loc" value="${sessionScope.currentMode}"></c:set>
    </c:if>
    <fmt:setLocale value="${loc}" />
    <fmt:setBundle basename="Languages.Units.Units" />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        String status = (String) request.getAttribute("status");
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
                document.UNIT_LIST_FORM.action = "<%=context%>/UnitServlet?op=saveUnitPrice";
                document.UNIT_LIST_FORM.submit();
            }
            function cancelForm()
            {
                document.UNIT_LIST_FORM.action = "<%=context%>/ProjectServlet?op=listBuildings";
                document.UNIT_LIST_FORM.submit();
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
             <table style="width:85% ;" align='center'>
                 <TR>
                    <TD style="width: 10%;; border: none">
                        <IMG class="img" style="cursor: pointer; padding-bottom: 95%;" width="30%" VALIGN="BOTTOM" onclick="JavaScript: cancelForm();" SRC="images/buttons/backBut.png" > 
                     </TD>
                     <TD style="width: 50%; border: none">
                                  <fieldset align=center class="set" style="width: 95%">
                <legend align="center">

                    <table dir='<fmt:message key="direction" />' align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                <fmt:message key="unitspricing" />
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                                <br/>
                                <button onclick="JavaScript: submitForm(); return false;" class="button">
                                    <fmt:message key="update" />
                                    <IMG HEIGHT="15" SRC="images/save.gif"></button>
                                <br/>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("Ok")) {
                %>  
                              <font size=4 color="black">
                              <fmt:message key="saved" />
                              </font> 
                            
                <%
                } else {%>
                                <font size=4 color="red" >
                                <fmt:message key="notsaved" />
                                </font> 
                        
                <%}
                    }

                %>
                <br/>
                <input type="hidden" name="buildingId" value="<%=buildingId%>"/>
                <div style="width:95%;margin-right: auto;margin-left: auto;">
                    <TABLE ALIGN="center" dir='<fmt:message key="direction" />' id="unitsList" style="width:100%;">
                        <thead>
                            <TR>
                                <th>
                                    <B>&nbsp;</B>
                                </th>
                                <Th>
                                    <B>&nbsp;</B>
                                </Th>
                                <Th>
                                    <B><fmt:message key="unit" /></B>
                                </Th>
                                
                                <Th>
                                    <B>س . م</B>
                                </Th>
                                <Th>
                                    <B><fmt:message key="area" /></B>
                                </Th>
                                <Th>
                                    <B>س . ش</B>
                                </Th>
                                <Th>
                                    <B>س. كلي</B>
                                </Th>
                                
                                <Th>
                                    <B> <fmt:message key="indate" /> </B>
                                </Th>
                                <Th>
                                    <B>    <fmt:message key="meterprice" /> </B>
                                </Th>
                            </TR>
                        </thead>
                        <tbody>
                            <%
                                int i = 0;
                                int counter = 0;
                                if (unitsList != null) {
                                    for (WebBusinessObject wbo : unitsList) {
                                        String unitName = (String) wbo.getAttribute("projectName");
                            %>
                            <TR>
                                <td>
                                    <B><%=counter + 1%></B>
                                </td>
                                <TD>
                                    <input type="checkbox" name="unitID" value="<%=wbo.getAttribute("projectID")%>"/>
                                </TD>
                                <TD>
                                    <%=unitName%>
                                </TD>

                                <td style="background-color: yellow">
                                    <label><%=wbo.getAttribute("minPrice") != null ? wbo.getAttribute("minPrice") : "---"%></label>
                                </td>
                                <TD style="background-color: yellow">
                                    <input type="number" name="maxPrice<%=wbo.getAttribute("projectID")%>" style="width: 50px;" value="<%=wbo.getAttribute("maxPrice") != null ? wbo.getAttribute("maxPrice") : "---"%>"/>
                                </TD>
                                <TD style="background-color: yellow">
                                    <%if (wbo.getAttribute("maxPrice") != null && wbo.getAttribute("minPrice") != null) {
                                            BigDecimal width = (BigDecimal) wbo.getAttribute("maxPrice");
                                            BigDecimal price = (BigDecimal) wbo.getAttribute("minPrice");

                                    %>
                                    <label><%=width.doubleValue() * price.doubleValue()%></label>
                                    <%} else {%>
                                    <label>---</label>
                                    <%}%>
                                </TD>
                                <TD style="background-color: yellow">
                                    <input type="number" name="option1<%=wbo.getAttribute("projectID")%>" style="width: 90px;" value="<%=wbo.getAttribute("totalPrice") != null ? wbo.getAttribute("totalPrice") : ""%>"/>
                                </TD>
                                <TD>
                                    <%
                                        String priceDateStr = "---";
                                        if (wbo.getAttribute("priceDate") != null) {
                                            String[] d = ((String) wbo.getAttribute("priceDate")).split(" ");
                                            priceDateStr = d[0];
                                        }
                                    %>
                                    <label><%=priceDateStr%></label>
                                </TD>
                                <TD>
                                    <input type="number" name="minPrice<%=wbo.getAttribute("projectID")%>" style="width: 100px;"  value="<%=wbo.getAttribute("minPrice") != null ? wbo.getAttribute("minPrice") : "---"%>"/>
                                </TD>
                                <%
                                            counter++;
                                        }
                                    }
                                %>
                            </TR>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
            </fieldset>
  
                     </TD>
                 </TR>
            </table>
         </FORM>
    </BODY>
</html>