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
    String save_button_label, dataExists, complaintsDeleted;
    if(stat.equals("En")){
        
        dataExists="Can not delete, emplyee has some issues";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        sUserName="User Name";
        sTitle="Delete User - Are You Sure?";
        cancel_button_label="Back to List";
        save_button_label="Delete";
        langCode="Ar";
        complaintsDeleted = "Complaints Deleted Successfully";
    }else{
        dataExists="لا يمكن الحذف, المستخدم مرتبط ببعض الطلبات";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sUserName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sTitle="&#1581;&#1584;&#1601; &#1605;&#1587;&#1578;&#1582;&#1583;&#1605; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        save_button_label="&#1573;&#1581;&#1584;&#1601;";
        langCode="En";
        complaintsDeleted = "تم حذف الطلبات بنجاح";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.ISSUE_FORM.action = "<%=context%>/UsersServlet?op=Delete&userId=<%=userId%>&userName=<%=userName%>";
      document.ISSUE_FORM.submit();  
   }

   function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
        document.ISSUE_FORM.submit();  
        }
        
    function deleteSelectedComplaints()
    {    
       document.ISSUE_FORM.action = "<%=context%>/UsersServlet?op=deleteSelectedComplaints&userId=<%=userId%>&userName=<%=userName%>";
       document.ISSUE_FORM.submit();  
    }
        
    function selectAll(obj) {
        $("input[name='issueID']").prop('checked', $(obj).is(':checked'));
    }
    </SCRIPT>
    
    <BODY>
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/del.gif"></button>
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
                        if (status.equalsIgnoreCase("dataExists")) {
                %>
                <table width="50%" align="center">
                    <tr>
                        <td class="bar td" style="text-align: center;">
                            <b><font color="red" size="3"><%=dataExists%></font></b>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                } else if (status.equalsIgnoreCase("complaintsDeleted")) {
                %>
                <table width="50%" align="center">
                    <tr>
                        <td class="bar td" style="text-align: center;">
                            <b><font color="red" size="3"><%=complaintsDeleted%></font></b>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                        }
                    }
                %>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><%=sUserName%><font color="#FF0000"> </font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="userName" value="<%=userName%>" ID="<%=userName%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    <input  type="HIDDEN" name="userId" value="<%=userId%>">
                </TABLE>
                <BR><BR>
                <%
                    if (status != null && (status.equalsIgnoreCase("dataExists") || status.equalsIgnoreCase("complaintsDeleted"))) {
                %>
                <table width="80%" align="center" dir="<%=dir%>">
                    <tr>
                        <td class="td" STYLE="text-align:center; color:white; font-size:14px" colspan="3"><span></span></td>
                        <td class="td" STYLE="text-align:center; color:white; font-size:14px" colspan="2">
                            <button onclick="JavaScript: deleteSelectedComplaints();" class="button" style="width: 170px;">حذف الطلبات</button>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><input type="checkbox" name="selectAllChk" value="" onchange="JavaScript: selectAll(this)"/></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><img src="images/icons/Numbers.png" width="20" height="20" /><b> رقم المتابعة</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b> كود اﻷدارة</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><img src="images/icons/client.png" width="20" height="20" /><b> اسم العميل</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>المصدر</b></span></td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>المسؤول</b></span></td>
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
                            <input type="checkbox" name="issueID" value="<%=wbo.getAttribute("issue_id")%>"/>
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
                    </tr>
                    <%
                            }
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" colspan="5">
                            إجمالي
                        </td>
                        <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" nowrap><%=issuesList.size()%></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
                <br/><br/>
                <%
                    }
                %>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
