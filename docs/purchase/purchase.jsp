<%@page import="com.clients.db_access.ReservationMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ReservationMgr reservationMgr = ReservationMgr.getInstance();
        //ArrayList<WebBusinessObject> unitsList = reservationMgr.getAllSoldUnits();
        ArrayList<WebBusinessObject> unitsList = reservationMgr.getProjectsSoldUnits(request.getSession());
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, title;
        String cancelButtonLabel;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "Sold Units";
            cancelButtonLabel = "Cancel ";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "عرض المبيعات";
            cancelButtonLabel = "إنهاء ";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" href="css/CSS.css"/>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/loading/loading.js"></script>
        <script type="text/javascript" src="js/loading/spin.js"></script>
        <script type="text/javascript" src="js/loading/spin.min.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            var oTable;
            var users = new Array();
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
            function navigateToClient(clientId) {
                document.url = "<%=context%>/ClientServlet?op=clientDetails&clientId=" + clientId;
            }
            function changeStatus(id, newStatus, type, unitCurrentStatus) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=changeReservationStatusByAjax",
                    data: {
                        id: id,
                        newStatus: newStatus,
                        unitCurrentStatus: unitCurrentStatus
                    }
                    ,
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            if (type == 'retrieved') {
                                $("#action" + id).html("تم اﻷسترداد");
                                alert("تم اﻷسترداد");
                            }
                        } else {
                            alert("لم يتم تغيير الحالة");
                        }
                    }
                });
            }
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
            }
        </SCRIPT>
        <style>  
            .canceled {
                background-color: #ffa722;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .confirmed {
                background-color: #e1efbb;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .onhold {
                background-color: #369bd7;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }

            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
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
            <FIELDSET class="set" style="width:98%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <div style="width:99%;margin-right: auto;margin-left: auto;">
                    <TABLE ALIGN="center" dir="<%=dir%>" id="unitsList" style="width:100%;">
                        <thead>
                            <TR>
                                <Th>
                                    <B>كود الوحدة</B>
                                </Th>
                                <Th>
                                    <B>م. المبيعات</B>
                                </Th>
                                <Th>
                                    <B>العميل</B>
                                </Th>
                                <!--<Th>
                                    <B>مقدم الحجز</B>
                                </Th>-->
                                <Th>
                                    <B>مدة الحجز</B>
                                </Th>
                                <th>
                                    <B>
                                        تاريخ الحجز
                                    </B>
                                </th>
                                <th style="width: 80px">
                                    <B>
                                        أستماره الحجز
                                    </B>
                                </th>
                            </TR>
                        </thead>
                        <tbody>
                            <%
                                Date date;
                                String className;
                                float total = 0;
                                for (WebBusinessObject wbo : unitsList) {
                                    try {
                                        if (wbo.getAttribute("budget") != null) {
                                            total += Float.parseFloat((String) wbo.getAttribute("budget"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                                    date = sdf.parse((String) wbo.getAttribute("creationTime"));

                                    className = "";
                                    if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE) || wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {
                                        className = "canceled";
                                    } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CONFIRM)) {
                                        className = "confirmed";
                                    } else if (wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals(CRMConstants.UNIT_STATUS_ONHOLD)) {
                                        className = "onhold";
                                    }
                            %>
                            <TR>
                                <TD id="1<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <B><%=wbo.getAttribute("projectName")%></B>
                                </TD>
                                <TD id="2<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <B><%=wbo.getAttribute("createdByName")%></B>
                                </TD>
                                <td id="3<%=wbo.getAttribute("id")%>" class="<%=className%>" style="cursor: pointer" onclick= "JavaScript : navigateToClient('<%=wbo.getAttribute("clientId")%>')">
                                    <B><%=wbo.getAttribute("clientName")%></B>
                                </td>
                                <!--<TD id="4<%//=/wbo.getAttribute("id")%>" class="<%=className%>">
                                    <B><%//=wbo.getAttribute("budget")%></B>
                                </TD>-->
                                <TD id="5<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <B><%=wbo.getAttribute("period")%></B>
                                </TD>
                                <td id="7<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <B>
                                        <%=sdf.format(date)%>
                                    </B>
                                </td>
                                <td id="action<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <%
                                        if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE)) {
                                    %>
                                    <input type="button" value="تم اﻷسترداد" onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=CRMConstants.RESERVATION_STATUS_RETRIEVED%>', 'retrieved', '<%=wbo.getAttribute("unitCurrentStatus")%>')"/>
                                    <%
                                    } else {
                                    %>
                                    <a href="<%=context%>/UnitServlet?op=getUnitReservationPrint&clientCode=<%=wbo.getAttribute("clientId")%>&unitCode=<%=wbo.getAttribute("projectId")%>&id=<%=wbo.getAttribute("id")%> ">
                                        <img src="images/icons/pdf.png" height="20" title="PDF"/>
                                    </a>
                                    <a href="#" onclick="JavaScript: openWindow('<%=context%>/UnitDocReaderServlet?op=getUnitReservationPopup&clientCode=<%=wbo.getAttribute("clientId")%>&projectId=<%=wbo.getAttribute("projectId")%>');">
                                        <img src="images/htmlicon.gif" title="HTML"/>
                                    </a>
                                    <%
                                        }
                                    %>
                                </td>
                            </TR>
                            <% }%>
                            <tfoot>
                                <TR class="titlebar"style="font-size: 16px; font-weight: bold">
                                    <TD colspan="3" st>
                                        <B>إجمالي</B>
                                    </TD>
                                    <TD>
                                        <B><%=total%></B>
                                    </TD>
                                    <TD colspan="3">
                                        &nbsp;
                                    </TD>
                                </TR>
                            </tfoot>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
            </fieldset>
        </FORM>
    </BODY>
</html>