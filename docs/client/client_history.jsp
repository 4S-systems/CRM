<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"name", "phone", "mobile", "email", "slaesmanName", "closedByName"};
        String[] clientsListTitles = new String[7];
        int s = clientsAttributes.length;
        int t = s + 1;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String clientsNo, title;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            clientsListTitles[0] = "ID";
            clientsListTitles[1] = "Client Name";
            clientsListTitles[2] = "Phone";
            clientsListTitles[3] = "Mobile";
            clientsListTitles[4] = "Email";
            clientsListTitles[5] = "Salesman";
            clientsListTitles[6] = "Closed by";
            clientsNo = "Clients No.";
            title = "Client's History";
        } else {
            align = "center";
            dir = "RTL";
            clientsListTitles[0] = "رقم المتابعة";
            clientsListTitles[1] = "اسم العميل";
            clientsListTitles[2] = "هاتف";
            clientsListTitles[3] = "موبايل";
            clientsListTitles[4] = "البريد اﻷلكتروني";
            clientsListTitles[5] = "مسؤول المبيعات";
            clientsListTitles[6] = "أغلق بواسطة";
            clientsNo = "عدد العملاء";
            title = "تاريخ العميل";
        }
    %>
    <HEAD>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                var url = "<%=context%>/ClientServlet?op=getClientHistory&num=<%=request.getAttribute("num")%>&projectID=&searchType=searchByPhone";
                $("#historyDiv").html("");
                $("#historyDiv").html("Loading ...");
                jQuery('#historyDiv').load(url);
            });
        </script>
        <style type="text/css">

        </style>
    </HEAD>
    <body>
        <div align="left" STYLE="color:blue; margin-left: 50px;">
            <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
        </div>
        <br/><br/>
        <fieldset align=center class="set" style="width: 90%">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            <%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <br/>
            <div style="width: 100%; text-align: center;" id="historyDiv">
                &nbsp;
            </div>
            <br/><br/>
        </fieldset>
    </body>
</html>
