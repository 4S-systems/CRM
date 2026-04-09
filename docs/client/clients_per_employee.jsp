<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        Calendar calendar = Calendar.getInstance();

        String context = metaMgr.getContext();

        DateFormat sqlDateParser = new SimpleDateFormat("yyyy/MM/dd");

        Map<String, ArrayList<WebBusinessObject>> dataResult = (HashMap<String, ArrayList<WebBusinessObject>>) request.getAttribute("dataResult");
        Map<String, WebBusinessObject> employeeResult = (HashMap<String, WebBusinessObject>) request.getAttribute("employeeResult");
        ArrayList<WebBusinessObject> groupsList = (ArrayList<WebBusinessObject>) request.getAttribute("groupsList");
        ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");

        String toDate = sqlDateParser.format(calendar.getTime());
        calendar.add(Calendar.MONTH, -1);
        String fromDate = sqlDateParser.format(calendar.getTime());
        if (request.getAttribute("fromDate") != null) {
            fromDate = (String) request.getAttribute("fromDate");
        }
        if (request.getAttribute("toDate") != null) {
            toDate = (String) request.getAttribute("toDate");
        }
        String groupID = "";
        if (request.getAttribute("groupID") != null) {
            groupID = (String) request.getAttribute("groupID");
        }
        String reportType = "brief";
        if (request.getAttribute("reportType") != null) {
            reportType = (String) request.getAttribute("reportType");
        }
        String interCode = request.getAttribute("interCode") != null ? (String) request.getAttribute("interCode") : "";
        String sourceID = request.getAttribute("sourceID") != null ? (String) request.getAttribute("sourceID") : "";

        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, complaintNo, customerName;
        if (stat.equals("En")) {
            dir = "LTR";
            complaintNo = "Order No.";
            customerName = "Customer name";
        } else {
            dir = "RTL";
            complaintNo = "المتابعة العامة";
            customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        }
    %>
    <head>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>  
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.position.js"></script>  
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
        </script>
        <script language="JavaScript" type="text/javascript">
            function submitform()
            {
                document.within_form.submit();
            }
            var dp_cal1, dp_cal2;
            window.onload = function () {
                dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('fromDate'));
                dp_cal2 = new Epoch('epoch_popup', 'popup', document.getElementById('toDate'));
                $("#fromDate").attr('readonly', true);
                $("#toDate").attr('readonly', true);
            };
            
            function getPDF(){
                var repType = $('input[name=reportType]:checked').val();
                $("#pdf").attr("href", "<%=context%>/ClientServlet?op=employeeWorkPDF&fromDate="+$("#fromDate").val()+"&toDate="+$("#toDate").val()+"&groupID="+$("#groupID").val()+"&reportType="+repType);              
            }
            
            function popupClientStatistics(userID, userName) {
                openInNewWindow('<%=context%>/AppointmentServlet?op=viewUserClientStatistics&beginDate=<%=fromDate%>&endDate=<%=toDate%>&userID=' + userID + "&userName=" + userName);
            }
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }
        </script>
        <script src='ChangeLang.js' type='text/javascript'></script>
    </head>
    <body>
    <center>
        <div id="appointments" style="display: none;">
        </div>
        <fieldset class="set" style="width:96%; height: auto;">
            <form name="within_form" id="within_form">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">العملاء بالموظفين</font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table align="center" dir="rtl" width="570" cellspacing="2" cellpadding="1">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <b><font size=3 color="white">من تاريخ</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <b> <font size=3 color="white">ألي تاريخ</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle" >
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>"><img src="images/showcalendar.gif" readonly /> 
                            <input type="hidden" name="op" value="getClientsPerEmployee"/>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>"><img src="images/showcalendar.gif" readonly /> 
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">المجموعة</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">الكود الدولي</b>
                        </td>
                    </tr>
                    <tr>

                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <%if (groupsList.size() > 0 && groupsList != null) {%>
                            <select style="width: 50%; font-weight: bold; font-size: 13px;" id="groupID" name="groupID">
                                <sw:WBOOptionList displayAttribute="groupName" valueAttribute="groupID" wboList="<%=groupsList%>" scrollToValue='<%=groupID%>' />
                            </select>
                            <% } else {%>
                            <select style="width: 50%; font-weight: bold; font-size: 13px;" id="groupID" name="groupID">
                                <option>لاشئ</option>
                            </select>
                            <%}%>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <select id="interCode" name="interCode" style="font-size: 14px;font-weight: bold; width: 180px;" >
                                <option value="">الكل</option>
                                <option value="00974" <%="00974".equals(interCode) ? "selected" : ""%>>00974</option>
                                <option value="00971" <%="00971".equals(interCode) ? "selected" : ""%>>00971</option>
                                <option value="00966" <%="00966".equals(interCode) ? "selected" : ""%>>00966</option>
                                <option value="00965" <%="00965".equals(interCode) ? "selected" : ""%>>00965</option>
                                <option value="00973" <%="00973".equals(interCode) ? "selected" : ""%>>00973</option>
                                <option value="00968" <%="00968".equals(interCode) ? "selected" : ""%>>00968</option>
                                <option value="00213" <%="00213".equals(interCode) ? "selected" : ""%>>00213</option>
                                <option value="00964" <%="00964".equals(interCode) ? "selected" : ""%>>00964</option>
                                <option value="00967" <%="00967".equals(interCode) ? "selected" : ""%>>00967</option>
                                <option value="00963" <%="00963".equals(interCode) ? "selected" : ""%>>00963</option>
                                <option value="00961" <%="00961".equals(interCode) ? "selected" : ""%>>00961</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">المصدر</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">نوع التقرير</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <select style="width: 50%; font-weight: bold; font-size: 13px;" id="sourceID" name="sourceID">
                                <option value="">الكل</option>
                                <sw:WBOOptionList displayAttribute="fullName" valueAttribute="userId" wboList="<%=usersList%>" scrollToValue='<%=sourceID%>' />
                            </select>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input type="radio" name="reportType" value="brief" <%=reportType.equals("brief") ? "checked" : ""%>/>ملخص
                            <input type="radio" name="reportType" value="detail" <%=reportType.equals("detail") ? "checked" : ""%>/>تفصيلي
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="middle">
                            <button type="submit" STYLE="color: #000;font-size:15px; margin: 2px;font-weight:bold; ">Search<img height="15" src="images/search.gif" /></button>  
                        </td>
                        <td style="text-align:center" bgcolor="#dedede"  valign="middle">
                            <a id="pdf" onclick="javaScript: getPDF()">
                                <img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/>
                            </a>
                        </td>
                    </tr>
                </table>
                <br/>
            </form>
            <%
                if (employeeResult != null) {
            %>
            <table align="center" dir="rtl" width="95%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                <tbody>  
                    <%
                        Set<String> keys = employeeResult.keySet();
                        for (String userID : keys) {
                            WebBusinessObject userWbo = employeeResult.get(userID);
                            ArrayList<WebBusinessObject> clientsList = dataResult.get(userID);
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" colspan="2"><b>اسم الموظف</b></td>
                        <td><b style="cursor: hand;" onclick="JavaScript: popupClientStatistics('<%=userID%>', '<%=userWbo.getAttribute("fullName")%>')"><%=userWbo.getAttribute("fullName")%></b></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>أجمالي العملاء</b></td>
                        <td><b><%=clientsList.size()%></b></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>أجمالي الحجوزات</b></td>
                        <td><b><%=userWbo.getAttribute("totalReservation") != null ? userWbo.getAttribute("totalReservation") : "لا يوجد"%></b></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>أجمالي المبيعات</b></td>
                        <td><b><%=userWbo.getAttribute("totalConfirmed") != null ? userWbo.getAttribute("totalConfirmed") : "لا يوجد"%></b></td>
                    </tr>
                    <%
                        if (reportType.equals("detail")) {
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b> كود اﻷدارة</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></span></td>
                        <td colspan="2" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>رقم الموبايل</b></span></td>
                        <td colspan="2" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>الدولي</b></span></td>
                        <td colspan="1" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>المصدر</b></span></td>
                        <td colspan="1" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>حالة الحجز</b></span></td>
                    </tr>
                    <%
                        int counter = 0;
                        String clazz;
                        String reservationStatus;
                        if (clientsList != null && !clientsList.isEmpty()) {
                            for (WebBusinessObject wbo : clientsList) {
                                reservationStatus = "";
                                if ((counter % 2) == 1) {
                                    clazz = "silver_odd_main";
                                } else {
                                    clazz = "silver_even_main";
                                }
                                counter++;
                                String compStyle = "";
                    %>
                    <tr class="<%=clazz%>">
                        <% WebBusinessObject clientCompWbo = null;
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                            if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                                compStyle = "comp";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                                compStyle = "query";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("5")) {
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("6")) {
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("7")) {
                                compStyle = "order";
                            }
                            if (wbo.getAttribute("totalConfirmed") != null && !wbo.getAttribute("totalConfirmed").equals("0")) {
                                reservationStatus = "تم البيع";
                            } else if (wbo.getAttribute("totalReservation") != null && !wbo.getAttribute("totalReservation").equals("0")) {
                                reservationStatus = "تم الحجز";
                            }
                        %>
                        <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>&currentOwnerId=<%=wbo.getAttribute("currentOwnerId")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                            </a>
                            <input type="hidden" id="issue_id" value="<%=wbo.getAttribute("issue_id")%>" />
                            <input type="hidden" id="comp_Id" value="<%=wbo.getAttribute("clientComId")%>" />
                            <input type="hidden" id="receip_id" value="<%=wbo.getAttribute("receipId")%>" />
                            <input type="hidden" id="sender_id" value="<%=wbo.getAttribute("senderId")%>" />
                        </td>
                        <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <font color="green"><%=clientCompWbo.getAttribute("businessCompID")%></font>
                        </td>
                        <td><b><%=wbo.getAttribute("customerName").toString()%></b>
                            <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                            </a>
                        </td>
                        <td colspan="2"><% String mobile = null;
                            if (wbo.getAttribute("clientMobile") == null || wbo.getAttribute("clientMobile").equals(" ") || wbo.getAttribute("clientMobile").equals("")) {
                                mobile = "--------";
                            } else {
                                mobile = (String) wbo.getAttribute("clientMobile");
                            }%><b><%=mobile%></b>
                        </td>
                        <td colspan="2" nowrap><b><%=wbo.getAttribute("interPhone") != null && !"UL".equals(wbo.getAttribute("interPhone")) ? wbo.getAttribute("interPhone") : "---"%></b></td>
                        <td colspan="1" nowrap><b><%=wbo.getAttribute("senderName")%></b></td>
                        <td colspan="1" nowrap><b><%=reservationStatus%></b></td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="10"><b>لايوجد عملاء</b></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    <tr>
                        <td colspan="10" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>&nbsp;</b></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <br />
            <%
                }
            %>
        </fieldset>
    </center>
</body>
</html>