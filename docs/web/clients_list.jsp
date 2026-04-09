<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Clients List</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </HEAD>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String status = (String) request.getAttribute("status");
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String save, total, title, sSccess, sFail, sDeleted;
        String clientName, mobile, phone, email, creationTime;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            save = "Save";
            total = "Clients No.";
            title = "Upload Clients from Web";
            sSccess = "Clients Uploaded Successfully";
            sFail = "Fail To Upload Clients";
            clientName = "Client Name";
            mobile = "Mobile";
            phone = "Phone";
            email = "Email";
            creationTime = "Creation Time";
            sDeleted = "Clients Deleted Successfully";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            save = " حفظ";
            total = "عدد العملاء";
            title = "سحب عملاء الويب";
            sSccess = "تم سحب العملاء بنجاح";
            sFail = "خطأ في سحب العملاء";
            clientName = "اسم العميل";
            mobile = "الموبايل";
            phone = "التليفون";
            email = "البريد اﻷلكتروني";
            creationTime = "توقيت اﻷدخال";
            sDeleted = "تم حذف العملاء بنجاح";
        }
    %>

    <script type="text/javascript">
        var oTable;
        var users = new Array();
        $(document).ready(function() {
            oTable = $('#clients').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "الكل"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true,
                "aaSorting": [[5, "desc"]]
            }).fadeIn(2000);
        });
        function cancelForm()
        {
            document.CLIEN_FORM.action = "main.jsp";
            document.CLIEN_FORM.submit();
        }
        function submitForm()
        {
            document.CLIEN_FORM.action = "<%=context%>/ManageWebClientServlet?op=SaveSelectedClients";
            document.CLIEN_FORM.submit();
        }
        function deleteClients()
        {
            document.CLIEN_FORM.action = "<%=context%>/ManageWebClientServlet?op=DeleteSelectedClients";
            document.CLIEN_FORM.submit();
        }
        function selectAll(obj) {
            $("input[name='clientID']").prop('checked', $(obj).is(':checked'));
        }
    </script>
    <body>
        <form name="CLIEN_FORM" method="post">
            <div style="color:blue;margin-bottom: 30px;width: 100%;">
                <div style="margin-left: auto;margin-right: auto;direction: rtl">
                    <button onclick="JavaScript: cancelForm();" class="button">Back</button>
                    <button onclick="JavaScript: deleteClients();" class="button">Delete&nbsp;&nbsp;<IMG VALIGN="BOTTOM" SRC="images/cancel.png"> </button>
                    <button onclick="JavaScript: submitForm();return false;" class="button">Save&nbsp;&nbsp;<IMG HEIGHT="15" SRC="images/save.gif"></button>
                </div>
            </div> 
            <fieldset align=center class="set" style="width: 90%">
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
                <center> <b> <font size="3" color="red"> <%=total%> : <%=clientsList != null ? clientsList.size() : "0"%> </font></b></center> 
                <br>
                <%if (status != null) {
                %>
                <table width="50%" align="center">
                    <tr>
                        <%if (status.equalsIgnoreCase("ok")) {%>
                        <td class="bar td" style="text-align: center;">
                            <b><font color="blue" size="3"><%=sSccess%></font></b>
                        </td>
                        <%} else if(status.equalsIgnoreCase("deleted")) {%>
                        <td class="bar td" style="text-align: center;">
                            <b><font color="blue" size="3"><%=sDeleted%></font></b>
                        </td>
                        <%} else {%>
                        <td class="bar td" style="text-align: center;">
                            <b><font color="red" size="3"><%=sFail%></font></b>
                        </td>
                        <%}%>
                    </tr>
                </table>
                <br>
                <%}%>
                <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;display: none; ">
                        <thead>
                            <tr>            
                                <th>
                                    <input type="checkbox" name="checkAll" onchange="JavaScript: selectAll(this)"/>
                                </th>
                                <th>
                                    <b><%=clientName%></b>
                                </th>
                                <th>
                                    <b><%=mobile%></b>
                                </th>
                                <th>
                                    <b><%=phone%></b>
                                </th>
                                <th>
                                    <b><%=email%></b>
                                </th>
                                <th>
                                    <b><%=creationTime%></b>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (clientsList != null) {
                                    for (WebBusinessObject clientWbo : clientsList) {
                            %>
                            <tr>
                                <td>
                                    <input type="checkbox" name="clientID" value="<%=clientWbo.getAttribute("clientID")%>"/>
                                </td>
                                <td>
                                    <div>
                                        <b title="<%=clientWbo.getAttribute("description")%>"> <%=clientWbo.getAttribute("clientName")%> </b>
                                        <input type="hidden" name="clientName<%=clientWbo.getAttribute("clientID")%>"
                                               value="<%=clientWbo.getAttribute("clientName")%>"/>
                                        <input type="hidden" name="campaignID<%=clientWbo.getAttribute("clientID")%>"
                                               value="<%=clientWbo.getAttribute("campaignID")%>"/>
                                        <input type="hidden" name="sourceID<%=clientWbo.getAttribute("clientID")%>"
                                               value="<%=clientWbo.getAttribute("sourceID")%>"/>
                                        <input type="hidden" name="season<%=clientWbo.getAttribute("clientID")%>"
                                               value="<%=clientWbo.getAttribute("season")%>"/>
                                        <input type="hidden" name="description<%=clientWbo.getAttribute("clientID")%>"
                                               value="<%=clientWbo.getAttribute("description")%>"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b> <%=clientWbo.getAttribute("mobile")%> </b>
                                        <input type="hidden" name="mobile<%=clientWbo.getAttribute("clientID")%>"
                                               value="<%=clientWbo.getAttribute("mobile")%>"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b> <%=clientWbo.getAttribute("phone")%> </b>
                                        <input type="hidden" name="phone<%=clientWbo.getAttribute("clientID")%>"
                                               value="<%=clientWbo.getAttribute("phone")%>"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b> <%=clientWbo.getAttribute("email")%> </b>
                                        <input type="hidden" name="email<%=clientWbo.getAttribute("clientID")%>"
                                               value="<%=clientWbo.getAttribute("email")%>"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <b> <%=clientWbo.getAttribute("creationTime")%> </b>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    <br />
                </div> 
            </fieldset>
        </form>
    </body>
</html>
