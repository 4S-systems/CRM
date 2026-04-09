<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Campaigns.Campaigns"  />
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
 
        %>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }
            .odd_main {
                border-right:.5px solid #D9E6EC;
                border-bottom:0px solid #D9E6EC;
                padding: 3px;
                border-top:0px solid #D9E6EC;
                font-size: 12px;
                word-wrap: break-word;
                background-color: #e3e3e3;
            }
            .even_main {
                border-right:.5px solid #D9E6EC;
                border-bottom:0px solid #D9E6EC;
                padding: 3px;
                border-top:0px solid #D9E6EC;
                font-size: 12px;
                word-wrap: break-word;
                background-color: #f3f3f3;
            }
        </style>
        <script>
            var oTable;
            $(document).ready(function () {
                oTable = $('#appointments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            function deleteAppointment(id) {
                var r = confirm("هل تريد حذف المتابعة");
                if (r) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/AppointmentServlet?op=deleteAppointmentAjax",
                        data: {
                            appointmentID: id
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                                alert('<fmt:message key="donedeleted" />');
                                $("#row" + id).hide(1000, function () {
                                    $("#row" + id).remove();
                                });
                            } else {
                                alert('<fmt:message key="faildeleted" />');
                            }
                        }
                    });
                }
            }
        </script>
    </head>
    <body>
        <div style="width: 90%;margin-left: auto;margin-right: auto;">
            <table ALIGN="center" dir=<fmt:message key="direction" /> width="100%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                <tr>
                    <td style="text-align: center; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                        الدليل: 
                    </td>
                    <td style="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE)%>" width="20" height="20" style="vertical-align: middle"/>
                        تمت بنجاح
                    </td>
                    <td style="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN)%>" width="20" height="20" style="vertical-align: middle"/>
                        مستقبلية
                    </td>
                    <td style="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED)%>" width="20" height="20" style="vertical-align: middle"/>
                        معتنى بها
                    </td>
                    <td style="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP)%>" width="20" height="20" style="vertical-align: middle"/>
                        متابعة مباشرة
                    </td>
                    <td style="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED)%>" width="20" height="20" style="vertical-align: middle"/>
                        اهملت 
                    </td>
                </tr>
            </table>
            <br/>
            <br/>
            <table class="blueBorder" id="appointments" align="center" dir=<fmt:message key="direction" /> width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px" width="30%"><b><fmt:message key="clientname" /> </b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px" width="15%"><b><fmt:message key="phone" /> </b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px" width="15%"><b><fmt:message key="mobile" />  </b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px" width="15%"><b><fmt:message key="date" />  </b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px" width="20%"><b><fmt:message key="comment" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px" width="5%"><b>&nbsp;</b></th>
                    </tr>
                </thead>  
                <tbody  id="planetData2">
                    <%
                        if (data != null && data.size() > 0) {
                            String appointmentDate;
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                            Date today = new Date();
                            Date tempDate;
                            for (WebBusinessObject wbo : data) {
                                appointmentDate = (String) wbo.getAttribute("appointmentDate");
                                tempDate = sdf.parse(appointmentDate);
                                if(appointmentDate != null) {
                                    appointmentDate = appointmentDate.replaceAll("-", "/").substring(0, 10);
                                } else {
                                    appointmentDate = "";
                                }
                    %>
                    <tr style="padding: 1px;" id="row<%=wbo.getAttribute("id")%>">
                        <td>
                            <a href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wbo.getAttribute("clientId")%>&clientType=30-40"><%=wbo.getAttribute("clientName")%></a>
                            <img src="images/icons/<%=tempDate.getTime() - today.getTime() >= -(1000 * 60 * 60 * 24) ? CRMConstants.APPOINTMENT_STATUS_IMAGES.get((String) wbo.getAttribute("currentStatus")) : CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED)%>"
                                 width="20" height="20" style="vertical-align: middle; float: left;"/>
                        </td>
                        <td>
                            <%=wbo.getAttribute("clientMobile")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("clientPhone")%>
                        </td>
                        <td>
                            <%=appointmentDate%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("comment")%>
                        </td>
                        <td>
                            <%
                                if (CRMConstants.APPOINTMENT_STATUS_OPEN.equals(wbo.getAttribute("currentStatus"))) {
                            %>
                            <a href="JavaScript: deleteAppointment('<%=wbo.getAttribute("id")%>')">
                            <fmt:message key="delete" />
                            </a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>
