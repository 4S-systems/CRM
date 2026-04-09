<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    
    <%
    String userId = (String) request.getAttribute("userId");
    String userName = (String) request.getAttribute("userName");
    String status = (String) request.getAttribute("status");
    ArrayList<WebBusinessObject> issuesList = (ArrayList<WebBusinessObject>) request.getAttribute("issuesList");
    ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
    for (int i = usersList.size() -1; i >=0; i--) {
        if(usersList.get(i).getAttribute("userId").equals(userId)) {
            usersList.remove(i);
            break;
        }
    }
    String fromDate =  (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");
    String currentStatus = request.getAttribute("currentStatus") != null ? (String) request.getAttribute("currentStatus") : "";
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String sTitle;
    String sUserName;
    String cancel_button_label;
    String complaintsMoved, fromDateStr, toDateStr, search, complaintStatus;
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        sUserName="User Name";
        sTitle="Move Complaints";
        cancel_button_label="Back to List";
        langCode="Ar";
        complaintsMoved = "Complaints Transfered Successfully";
        fromDateStr = "From Date";
        toDateStr = "To Date";
        search = "Search";
        complaintStatus = "Status";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sUserName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sTitle="نقل اﻷعمال";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        langCode="En";
        complaintsMoved = "تم نقل اﻷعمال بنجاح";
        fromDateStr = "من تاريخ";
        toDateStr = "إلي تاريخ";
        search = "بحث";
        complaintStatus = "الحالة";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function () {
            $("#fromDate, #toDate").datepicker({
                changeMonth: true,
                changeYear: true,
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
        });

   function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
        document.ISSUE_FORM.submit();  
        }
    
    function moveSelectedComplaints()
    {    
       document.ISSUE_FORM.action = "<%=context%>/UsersServlet?op=moveSelectedComplaints&userId=<%=userId%>&userName=<%=userName%>";
       document.ISSUE_FORM.submit();  
    }
        
    function selectAll(obj) {
        $("input[name='clientComplaintID']").prop('checked', $(obj).is(':checked'));
    }
    </SCRIPT>
    
    <BODY>
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button type="submit" class="button"><%=search%><img height="15" src="images/search.gif" /></button>
            </DIV>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6">    <%=sTitle%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                </table>
                <%
                    if (status != null) {
                        if (status.equalsIgnoreCase("complaintsMoved")) {
                %>
                <table width="50%" align="center">
                    <tr>
                        <td class="bar td" style="text-align: center;">
                            <b><font color="red" size="3"><%=complaintsMoved%></font></b>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                        }
                    }
                %>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0" width="500px">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=fromDateStr%></font></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=toDateStr%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="width: 180px;" readonly/>
                            <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="width: 180px;" readonly/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=sUserName%></font></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=complaintStatus%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <TD bgcolor="#dedede" style="text-align: center;">
                            <input disabled type="TEXT" name="userName" value="<%=userName%>" ID="<%=userName%>" size="33"  maxlength="50" style="width: 180px;"/>
                            <br/><br/>
                        </TD>
                        <td bgcolor="#dedede" style="text-align: center;">
                            <select name="currentStatus" id="currentStatus" style="width: 180px;">
                                <option value="">All</option>
                                <option value="1,2,3,4" <%=currentStatus.equals("1,2,3,4") ? "selected" : ""%>>Inbox</option>
                                <option value="6" <%=currentStatus.equals("6") ? "selected" : ""%>>Finished</option>
                                <option value="7" <%=currentStatus.equals("7") ? "selected" : ""%>>Closed</option>
                            </select>
                            <br/><br/>
                        </td>
                    </TR>
                    <input  type="HIDDEN" name="userId" value="<%=userId%>">
                </TABLE>
                <BR><BR>
                <table width="80%" align="center" dir="<%=dir%>">
                    <tr>
                        <td class="td" STYLE="text-align:center; color:white; font-size:14px" colspan="3"><span></span></td>
                        <td class="td" STYLE="text-align:center; color:white; font-size:14px" colspan="2">
                            <select style="width: 180px; font-weight: bold; font-size: 13px;" id="ownerID" name="ownerID">
                                <sw:WBOOptionList displayAttribute="fullName" valueAttribute="userId" wboList="<%=usersList%>" />
                            </select>
                            <button onclick="JavaScript: moveSelectedComplaints();" class="button" style="width: 170px;">نقل اﻷعمال</button>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><input type="checkbox" name="selectAllChk" value="" onchange="JavaScript: selectAll(this)"/></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><img src="images/icons/Numbers.png" width="20" height="20" /><b> رقم المتابعة</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b> كود اﻷدارة</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><img src="images/icons/client.png" width="20" height="20" /><b> اسم العميل</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>المصدر</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>المسؤول</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>الحالة</b></span></td>
                    </tr>
                    <%
                        int counter = 0;
                        String clazz;
                        if (issuesList != null && !issuesList.isEmpty()) {
                            for (WebBusinessObject wbo : issuesList) {
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
                        %>
                        <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <input type="checkbox" name="clientComplaintID" value="<%=wbo.getAttribute("clientComId")%>"/>
                        </td>
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
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                     onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                            </a>
                        </td>
                        <td nowrap><b><%=wbo.getAttribute("senderName")%></b></td>
                        <td nowrap><b><%=wbo.getAttribute("currentOwner")%></b></td>
                        <td nowrap><b><%=wbo.getAttribute("statusArName")%></b></td>
                    </tr>
                    <%
                            }
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" colspan="6">
                            إجمالي
                        </td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" nowrap><%=issuesList.size()%></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
                <br/><br/>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
