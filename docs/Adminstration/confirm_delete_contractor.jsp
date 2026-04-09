<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String fromPage = (String) request.getAttribute("fromPage");
        if(fromPage == null) {
            fromPage = "";
        }
        String clientID = (String) request.getAttribute("clientId");
        String clientName = (String) request.getAttribute("clientName");
        String clientNo = (String) request.getAttribute("clientNo");
        boolean canDelete = (Boolean) request.getAttribute("canDelete");
        String status = (String) request.getAttribute("status");
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;
        String client_number, save, client_name, TT;
        String title_1, title_2;
        String cancel_button_label;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            client_name = "Contractor name";
            client_number = "Contractor number";
            title_1 = "Delete client";
            title_2 = " Are you Sure That Yoy Want To Delete This Contractor?";
            cancel_button_label = "Back To List ";
            langCode = "Ar";
            save = "Delete";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            save = " &#1573;&#1581;&#1584;&#1601;";
            client_name = "اسم المقاول";
            client_number = "رقم المقاول";
            title_1 = "&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1605;&#1600;&#1600;&#1600;&#1600;&#1608;&#1585;&#1583;";
            title_2 = "هل أنت متأكد من حذف هذا المقاول؟";
            cancel_button_label = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            langCode = "En";
        }

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <script language="javascript" type='text/javascript'>
        function submitForm() {
            document.DELETE_SUPPLIER_FORM.action = "<%=context%>/ClientServlet?op=deleteContractor&clientId=<%=clientID%>&clientName=<%=clientName%>&clientNo=<%=clientNo%>&fromPage=<%=fromPage%>";
            document.DELETE_SUPPLIER_FORM.submit();
        }

        function cancelForm() {
            document.DELETE_SUPPLIER_FORM.action = "<%=context%>/ClientServlet?op=getContractorsList";
            document.DELETE_SUPPLIER_FORM.submit();
        }
    </script>
    <BODY>
        <FORM action=""  NAME="DELETE_SUPPLIER_FORM" METHOD="POST">
            <%
            String navURL = "/ClientServlet?op=getContractorsList";
            %>
            <%if(clientWbo.getAttribute("code")!=null){%>
            <input type="hidden" name="code" id="code" value="<%=clientWbo.getAttribute("code").toString()%>"/>
            <%}%>
            <DIV align="left" STYLE="color:blue; padding-bottom: 10px; padding-left: 5%">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%></button>
                <% if (canDelete) {%>
                &ensp;
                <button onclick="submitForm()" class="button"><%=save%></button>
                <% }%>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699; width: 90%">

                    <BR>
                    <% if (canDelete) {%>
                    <%
                        if (status != null) {

                            if (status.equalsIgnoreCase("error")) {
                    %>

                    <SCRIPT type="text/javascript">
        alert("المقاول مرتبط بحركات");
                    </script>
                    <%} else if (status.equalsIgnoreCase("ok")) {%>
                    <SCRIPT type="text/javascript">
                        alert("تم حذف المقاول");
                        $("#info").css("display", "none");
                        window.location.href = "<%=context + navURL%>";
                    </script>
                    <%}
                        }
                    %>
                                        <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1">
                                <% if (canDelete) {%>
                                <%=title_2%>
                                <% } else {%>
                                <%=title_1%>
                                <% }%>
                                </FONT>
                            </TD>
                        </TR>
                    </TABLE>
                    <TABLE class="backgroundTable" CELLPADDING="0" CELLSPACING="5" width="60%" BORDER="0" ALIGN="<%=align%>" DIR="<%=dir%>" id="info">
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px;" class='backgroundHeader' width="30%">
                                <p><b><%=client_number%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="supplierNO" ID="supplierNO" value="<%=clientNo%>">
                                <input type="hidden" name="clientId" ID="clientId" value="<%=clientID%>">
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=client_name%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="supplierName" ID="supplierName" value="<%=clientName%>">
                            </TD>
                        </TR>
                    </TABLE>
                    <% }%>
                    <BR>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>     
