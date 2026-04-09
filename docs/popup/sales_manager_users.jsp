<%--<%@page import="com.sun.xml.internal.ws.api.ha.StickyFeature"%>--%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String messageFlag = (String) request.getAttribute("messageFlag");
        String stat = (String) request.getSession().getAttribute("currentMode");

//        String callId = (String) request.getAttribute("callId");
        String username = (String) request.getAttribute("username");

        Vector data = (Vector) request.getAttribute("data");
        String[] tableHeader = new String[4];

        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, sTitle, sCancel, sOk, message, create;
        String client_number, client_name, client_address, client_job, client_phone, client_mobile, client_ssn, client_city, client_mail, client_service, client_notes, working_status, TT;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            sTitle = "Search";
            sCancel = "Cancel";
            sOk = "Search";
            langCode = "Ar";

            client_name = "Client name";
            client_number = "Client number";
            client_address = "Client address";
            client_job = "Client job";
            client_phone = "Client phone";
            client_mobile = "Mobile Number";
            //  client_fax = "Fax";
            client_mail = "E-mail";
            client_city = "Client city";
            client_ssn = "Client Ssn";
            //  client_service = "Client service";
            client_notes = "Notes";
            tableHeader[0] = "id";
            tableHeader[1] = "username";
            tableHeader[2] = "email";
            tableHeader[3] = "full name";
            // sup_city = "Supplier city";
            working_status = "Working";
            TT = "Waiting Business Rule";
            create = "New Complaint";
            message = "";

        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            sTitle = "&#1576;&#1581;&#1579;";
            sCancel = tGuide.getMessage("cancel");
            sOk = "&#1576;&#1581;&#1579;";
            langCode = "En";

            client_name = "اسم العميل";
            client_number = "رقم العميل";
            client_address = "&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
            client_job = "المهنة";
            client_mobile = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1576;&#1575;&#1610;&#1604;";
            client_phone = "&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
            //client_fax = "&#1575;&#1604;&#1601;&#1575;&#1603;&#1587;";
            client_mail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
            client_city = "&#1575;&#1604;&#1605;&#1583;&#1610;&#1606;&#1607;";
            // client_service = "&#1575;&#1604;&#1582;&#1583;&#1605;&#1607; ";
            client_notes = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            client_ssn = "&#1575;&#1604;&#1585;&#1602;&#1605; &#1575;&#1604;&#1602;&#1608;&#1605;&#1609;";
            //sup_city = "Supplier city";
            working_status = "&#1606;&#1588;&#1591;";
            tableHeader[0] = "القسم";
            tableHeader[1] = "إسم المستخدم";
            tableHeader[2] = "الايميل";
            tableHeader[3] = "الإسم بالكامل";

            create = "ادخال مكالمه";
            message = "";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function test() {
            alert(document.getElementById("groupN").value);
        }
        function getClientInfo(searchBy) {
            var searchByValue = '';

            if (searchBy == 'username') {
                searchByValue = $("#username").val();

            }
            if ($.trim(searchByValue).length > 0) {
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForUsers&searchBy=" + searchBy;
                document.CLIENT_FORM.submit();
//                $("#username").val("");
            }


        }
        function salesManagerUsers() {
            var salesManagerUsersArray = $('#salesManagerUsers').find(':checkbox:checked');
            var salesDiv = window.opener.document.getElementById('salesUsers');
            var groupName, username, email, fullname;
            $(salesManagerUsersArray).each(function(index, object) {

                groupName = $(object).parent().parent().find('#groupName').val();
                username = $(object).parent().parent().find('#username').val();
                email = $(object).parent().parent().find('#email').val();
                fullname = $(object).parent().parent().find('#fullname').val();
                var table;
                salesDiv.innerHTML="<table id='salesTable'>\n\
       <tr></tr> \n\
\n\
</table>";
                var insertedTable= window.opener.document.getElementById('salesTable');
                row = insertedTable.insertRow();
                var cell0 = row.insertCell(0);
                cell0.width = "30%";
                cell0.innerHTML = groupName;
//                parentProductId = $(product).parent().find('#parentProductId').val();
//                productName = $(product).parent().find('#productName').val();
//                parentProductName = $(product).parent().find('#parentProductName').val();
//                row = insertedTable.insertRow();
//
//                var cell0 = row.insertCell(0);
//                cell0.width = "30%";
//                cell0.innerHTML = parentProductName;
//
//                var cell1 = row.insertCell(1);
//                cell1.innerHTML = productName;
//                var cell2 = row.insertCell(2);
//                cell2.width = "20%";
//                cell2.innerHTML = "<input type='text' maxlength='20' name='budget' id='budget'/>";
//                var cell3 = row.insertCell(3);
//                cell3.innerHTML = "<SELECT name='period' id='period'>فى خلال \n\
//          <OPTION>شهر</OPTION> <OPTION>شهرين</OPTION> \n\
//        <% for (int c = 3; c <= 10; c++) {%> \n\
//              <OPTION value='<%=c%>month'><%=c%>شهور</OPTION> \n\
//        <% }%><OPTION>سنة</OPTION</SELECT>";
//
//                var cell4 = row.insertCell(4);
//                cell4.innerHTML = " <SELECT name='paymentSystem' id='paymentSystem'>نظام الدفع\n\
//                  <OPTION>نقدى</OPTION>\n\
//                                <OPTION>تقسيط</OPTION>\n\
//                            </SELECT>";
//                var cell5 = row.insertCell(5);
//                cell5.innerHTML = "<SPAN><TEXTAREA cols='20' rows='1' name='notes' id='notes'></TEXTAREA></SPAN><input type='hidden' name='productId' id='productId' value='" + productId + "' />\n\
//    <input type='hidden' name='productCategoryName' id='productCategoryName' value='" + parentProductName + "' />\n\
//<input type='hidden' name='productName' id='parentProductId' value='" + parentProductId + "' />\n\
//            <input type='hidden' name='productName' id='productName' value='" + productName + "' />";
//                var cell6 = row.insertCell(6);
//
//                cell6.innerHTML = "<div type='button' class='save' id='save' name='save' onclick='saveProduct(this)'></div>";
//
//            });
            });
        }

    </SCRIPT>
    <style>
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">

            <BR>
            <div style="width: 100%;">
                <fieldset class="set" align="center" width="100%">
                    <legend align="center">
                        <table dir="<%=dir%>" align="center">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6">
                                    المبيعات
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </legend>

                    <%if (data != null && !data.isEmpty()) {
                    %>
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="90%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" id="salesManagerUsers">
                        <TR > 
                            <td></td>
                            <%
                                for (int i = 0; i < tableHeader.length; i++) {

                            %>

                            <TD class="blueBorder blueHeaderTD" style="font-size:18px;">
                                <B><%=tableHeader[i]%></B>
                            </TD>
                            <%
                                }
                            %>

                        </TR>

                        <%

                            Enumeration e = data.elements();

                            WebBusinessObject wbo = new WebBusinessObject();
                            while (e.hasMoreElements()) {

                                wbo = (WebBusinessObject) e.nextElement();
                        %>

                        <TR style="padding: 1px;">
                            <td>
                                <input type="checkbox" />
                            </TD>
                            <TD style="text-align:right;background: #f1f1f1;font-size: 14px;width: 13%;" >

                                <%if (wbo.getAttribute("groupName") != null) {%>
                                <b id="groupN"><%=wbo.getAttribute("groupName")%></b>
                                <input type="hidden" id="groupName" value="<%=wbo.getAttribute("groupName")%>" />
                                <%}
                                %>

                            </TD>

                            <TD style="text-align:right;background: #f1f1f1;font-size: 14px;">

                                <%if (wbo.getAttribute("username") != null) {%>
                                <b><%=wbo.getAttribute("username")%></b>
                                <input type="hidden" id="username" value="<%=wbo.getAttribute("username")%>" />
                                <%}%>

                            </TD>
                            <TD style="text-align:right;background: #f1f1f1;font-size: 14px;">

                                <%if (wbo.getAttribute("email") != null) {%>
                                <b><%=wbo.getAttribute("email")%></b>
                                <input type="hidden" id="email" value="<%=wbo.getAttribute("email")%>" />
                                <%}%>

                            </TD>
                            <TD style="text-align:right;background: #f1f1f1;font-size: 14px;">

                                <%if (wbo.getAttribute("fullname") != null) {%>
                                <b><%=wbo.getAttribute("fullname")%></b>
                                <input type="hidden" id="fullname" value="<%=wbo.getAttribute("fullname")%>" />
                                <%}%>

                            </TD>


                        </TR>


                        <%

                            }

                        %>
                        <TR>


                    </TABLE>
                    <% }%>    

                    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <TR>
                            <TD class="td">
                                &nbsp;
                            </TD>
                        </TR>
                    </TABLE>
                    <%
                        if (messageFlag != null) {
                    %>
                    <center>
                        <table  dir="<%=dir%>">
                            <tr>
                                <td class="td"  align="<%=align%>">
                                    <H4><font color="red"><%=message%></font></H4>
                                </td>
                            </tr>
                        </table>
                        <br><br>
                    </center>
                    <%
                        }
                    %>
                </FIELDSET>
            </div>
        </FORM>
        <input type="button" onclick="salesManagerUsers()" value="test"/>
    </BODY>
</HTML>     
