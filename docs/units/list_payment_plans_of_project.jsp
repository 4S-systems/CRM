<%-- 
    Document   : list_payment_plans_of_project
    Created on : Jul 24, 2018, 11:03:52 AM
    Author     : walid
--%>

<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.docviewer.common.*,com.docviewer.business_objects.*,java.math.*,com.silkworm.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.sw.constants.*,java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8" %>
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

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE><fmt:message key="listdocs" />  </TITLE>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
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

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </HEAD>
    <script type="text/javascript">
        $(document).ready(function() {
            $('#indextable').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
            })
        });
        //          
    </script>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        FileMgr fileMgr = FileMgr.getInstance();
        WebBusinessObject fileDescriptor = null;
        String context = metaMgr.getContext();
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String resVal, firstPay, fAfter, paymentSys,month, title, planTit;
        if (stat.equals("En")) {
            dir = "LTR";
           resVal = "Reservation Value"; 
           firstPay = "First Payment";
           fAfter = "After";
           paymentSys = "Installment System";
           month = "Month/s";
           title = "Payment Plans";
           planTit = "Plan Title";
        } else {
            dir = "RTL";
            resVal = "دفعة الحجز";
            firstPay = "الدفعة اﻷولى";
            fAfter = "بعد";
            paymentSys = "نظام التقسيط";
            month = "شهر";
            title = "أنظمة الدفع للمشروع";
            planTit = "عنوان الخطة";
        }
        ArrayList<WebBusinessObject> PaymentPlamsLst = (ArrayList<WebBusinessObject>) request.getAttribute("PaymentPlamsLst");
    %>
    <body>
        <fieldset align=center class="set">
            <legend align="center">

                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>

                        <td class="td">
                            <font color="blue" size="6"><%=title%>
                            </font>
                        </td>
                    </tr>
                </table>

            </legend >
        
            <br>   
            <table id="indextable" ALIGN="center" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="width: 100%;text-align: center">
                <thead>
                    <TR>
                        <TD><B><%=planTit%></B></TD>
                        <TD><B><%=resVal%></B></TD>
                        <TD><B><%=firstPay%></B></TD>
                        <TD><B><%=paymentSys%></B></TD>
                    </TR>  
                </thead>
                <tbody >

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
                                <B><%=doc.getAttribute("downAMT")%> % <%=fAfter%> <%=doc.getAttribute("downDate")%> <%=month%></B>
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
                                <B><%=insSys%> <%=fAfter%> <%=doc.getAttribute("insMon")%> <%=month%></B>
                            </DIV>
                        </TD>
                    </TR>
                        <%}}%>
                </tbody>
            </table>
        </FIELDSET>
    </body>
</html>
