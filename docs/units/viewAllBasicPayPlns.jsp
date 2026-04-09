<%-- 
    Document   : viewAllBasicPayPlns
    Created on : Aug 5, 2018, 10:11:17 AM
    Author     : walid
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>

    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Units.Units"  />

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">   
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
         <%
            ArrayList<WebBusinessObject> PaymentPlamsLst = (ArrayList<WebBusinessObject>) request.getAttribute("PaymentPlamsLst");
            String saveC=(String) request.getAttribute("saveC");
            String savemsg;
        %>
        <script  type="text/javascript">
            $(document).ready(function () {
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });
        </script>
    </head>
    <body>
        <form name="selectClientForm" method="POST">            
            <fieldset class="set" style="border-color: #006699; width: 95%; margin-bottom: 10px;">
                <legend align="center">

                    <table dir=" <fmt:message key="dir"/>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6"><fmt:message key="title2"/>
                                </font>
                            </td>
                        </tr>
                    </table>

                </legend >
                 
                <div>
                <%  if (saveC != null && saveC.equals("yes")) { 
                %>
              
                <font size="6px" color="green"><fmt:message key="smsg"/></font>
                
               <% } else if (saveC !=null && saveC.equals("no")) { %>
                <font size="6px" color="red"><fmt:message key="fmsg"/></font>
               <% } %>
               </div>
                <br> 
                <div style="width: 100%;">
                    <table id="indextable" ALIGN="center" dir="<fmt:message key="dir"/>" STYLE="width: 100%; text-align: center">
                        <thead>
                            <TR>
                                <TD><B><fmt:message key="planTit"/></B></TD>
                                <TD><B><fmt:message key="resVal"/></B></TD>
                                <TD><B><fmt:message key="firstPay"/></B></TD>
                                <TD><B><fmt:message key="fPAfter"/></B></TD>
                                <TD><B><fmt:message key="paymentSys"/> </B></TD>
                                <TD><B><fmt:message key="fAfter"/></B></TD>
                                <TD><B><fmt:message key="installment"/> </B></TD>
                                <TD><B><fmt:message key="yearlySys"/> </B></TD>
                                <TD><B><fmt:message key="yearlySysInsVal"/> </B></TD>
                                <TD><B><fmt:message key="dur"/> </B></TD>
                                <TD><B><fmt:message key="project"/> </B></TD>
                                <TD><B><fmt:message key="createdBy"/> </B></TD>
                                <TD><B><fmt:message key="creationTime"/> </B></TD>
                            </TR>  
                        </thead>
                        <tbody>

                            <%
                                if (null != PaymentPlamsLst) {

                                    for(int i=0; i<PaymentPlamsLst.size(); i++) {
                                        WebBusinessObject doc = (WebBusinessObject) PaymentPlamsLst.get(i);
                            %>
                            <TR >
                                <TD >
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("planTitle")%></B>
                                    </DIV>
                                </TD>

                                <TD >
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("rsrvAMT")%> %</B>
                                    </DIV>
                                </TD>

                                <TD>
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("downAMT")%> %</B>
                                    </DIV>
                                </TD>

                                <TD>
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("downDate")%> <fmt:message key="month"/></B>
                                    </DIV>
                                </TD>

                                <TD>
                                    <DIV ID="links">
                                        <%
                                            String insSys = null ;
                                            if(doc.getAttribute("insSys") != null && doc.getAttribute("insSys").equals("1")){
                                                insSys = "Monthly";
                                            } else if(doc.getAttribute("insSys") != null && doc.getAttribute("insSys").equals("3")){
                                                insSys = "Quarterly";
                                            } else if(doc.getAttribute("insSys") != null && doc.getAttribute("insSys").equals("6")){
                                                insSys = "Biannual";
                                            } else if(doc.getAttribute("insSys") != null && doc.getAttribute("insSys").equals("12")){
                                                insSys = "Annual";
                                            }
                                        %>
                                        <B><%=insSys%></B>
                                    </DIV>
                                </TD>

                                <TD>
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("insMon")%> <fmt:message key="month"/> </B>
                                    </DIV>
                                </TD>
                                
                                <TD>
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("insAMT")%></B>
                                    </DIV>
                                </TD>
                                
                                <TD>
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("yearInsTyp")%> </B>
                                    </DIV>
                                </TD>
                                
                                <TD>
                                    <DIV ID="links">
                                        <%
                                            if(doc.getAttribute("yearInsTyp").equals("---")){
                                        %>
                                        <B>---</B>
                                        <%
                                            } else {
                                        %>
                                            <B><%=doc.getAttribute("yearInsVal") != null && doc.getAttribute("yearInsVal") != "0" && doc.getAttribute("yearInsVal") != "---" ? doc.getAttribute("yearInsVal").toString()+" %" : "---"%></B>
                                        <%
                                            }
                                        %>
                                        
                                    </DIV>
                                </TD>
                                
                                <TD>
                                    <DIV ID="links">
                                        <%
                                            if(doc.getAttribute("yearInsTyp").equals("---")){
                                        %>
                                        <B>---</B>
                                        <%
                                            } else {
                                        %>
                                            <B><%=doc.getAttribute("yearMinInsVal") != null && doc.getAttribute("yearMinInsVal") != "0" && doc.getAttribute("yearMinInsVal") != "---" ? doc.getAttribute("yearMinInsVal") : "---"%></B> <fmt:message key="year"/>
                                        <%
                                            }
                                        %>
                                        
                                    </DIV>
                                </TD>
                                
                                <TD>
                                    <DIV ID="links">
                                        <B> <%=doc.getAttribute("projectNM")%> </B>
                                    </DIV>
                                </TD>
                                
                                <TD>
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("createdBy")%></B>
                                    </DIV>
                                </TD>
                                
                                <TD>
                                    <DIV ID="links">
                                        <B><%=doc.getAttribute("creationTime").toString().split(" ")[0]%></B>
                                    </DIV>
                                </TD>
                            </TR>
                                <%}}%>
                        </tbody>
                    </table>
                </div>
            </FIELDSET>
        </form>
    </body>
</html>
