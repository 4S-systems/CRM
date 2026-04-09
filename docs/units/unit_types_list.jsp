<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] unitTypeAttributes = {"typeName"};
        String[] unitTypeListTitles = new String[5];
        int s = unitTypeAttributes.length;
        int t = s + 3;
        String status = (String) request.getAttribute("status");
        ArrayList<WebBusinessObject> unitTypesList = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        int flipper = 0;
        String bgColor = null;
        String bgColorm = null;
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String quickSummary, basicOperations, title, sSccess, sFail, cancel;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:center";
            cancel = "Cancel";
            quickSummary = "Quick Summary";
            basicOperations = "Basic Operations";
            unitTypeListTitles[0] = "Description";
            unitTypeListTitles[1] = "View";
            unitTypeListTitles[2] = "Edit";
            unitTypeListTitles[3] = "Delete";
            title = "Unit Types List";
            sSccess = "Deleted Successfully";
            sFail = "Fail To Delete";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:center";
            cancel = "إلغاء";
            quickSummary = "معلومات سريعة";
            basicOperations = "عمليات أساسية";
            unitTypeListTitles[0] = "الوصف";
            unitTypeListTitles[1] = "مشاهدة";
            unitTypeListTitles[2] = "تحرير";
            unitTypeListTitles[3] = "حذف";
            title = "عرض أنواع الوحدات";
            sSccess = "تم الحذف بنجاح";
            sFail = "لم يتم الحذف";
        }
    %>
    <head>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>

        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script language="javascript" type="text/javascript">
            var oTable;
            $(document).ready(function () {
                oTable = $('#unitTypes').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            function cancelForm() {
                document.UNIT_TYPE_FORM.action = "<%=context%>/main.jsp";
                document.UNIT_TYPE_FORM.submit();
            }
            function updateForm() {
                document.UNIT_TYPE_FORM.submit();
            }
        </script>
    </head>
    <body>
        <form name="UNIT_TYPE_FORM" id="UNIT_TYPE_FORM" method="POST">
            <div align="left" style="color:blue;">
                <button onclick="JavaScript: cancelForm();" class="button"><%=cancel%><img valign="bottom" src="images/cancel.gif"/></button>
            </div> 
            <br />
            <fieldset class="set" style="border-color: #006699; width: 90%">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color='white' size="+1"> <%=title%> </font><br/></td>
                    </tr>
                </table> 
                <br />
                <%if (status != null) {
                %>
                <table align="center" style="margin-left: auto; margin-right: auto;">
                    <tr>
                        <%if (status.equalsIgnoreCase("ok")) {%>
                        <td class="bar td">
                            <b><font color="blue" size="3"><%=sSccess%></font></b>
                        </td>
                        <%} else {%>
                        <td class="bar td">
                            <b><font color="red" size="3"><%=sFail%></font></b>
                        </td>
                        <%}%>
                    </tr>
                </table>
                <br>
                <%}%>
                <div style="width: 40%;margin-left: auto;margin-right: auto;">
                    <table id="unitTypes" align="<%=align%>" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0" style="border-right-width:1px;">
                        <thead>
                            <tr>
                                <th class="blueBorder blueHeaderTD" colspan="1" style="text-align:center;color:white;font-size:18px;">
                                    <b><%=quickSummary%></b>
                                </th>
                                <th class="blueBorder blueHeaderTD" colspan="3" style="text-align:center;color:white;font-size:18px;">
                                    <b><%=basicOperations%></b>
                                </th>
                            </tr>
                            <tr class="silver_header">
                                <%
                                    String columnWidth = new String("");
                                    String font = new String("");
                                    for (int i = 0; i < t; i++) {
                                        if (unitTypeListTitles[i].equalsIgnoreCase("")) {
                                            columnWidth = "1";
                                            font = "1";
                                        } else {
                                            columnWidth = "100";
                                            font = "12";
                                        }
                                %>                
                                <th nowrap class="silver_header" width="<%=columnWidth%>" style="border-width:0; font-size:<%=font%>;" nowrap>
                                    <b><%=unitTypeListTitles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject wbo : unitTypesList) {
                                    flipper++;
                                    if ((flipper % 2) == 1) {
                                        bgColor = "silver_odd";
                                        bgColorm = "silver_odd_main";
                                    } else {
                                        bgColor = "silver_even";
                                        bgColorm = "silver_even_main";
                                    }
                            %>
                            <tr>
                                <td class="<%=bgColorm%>" nowrap style="<%=style%>">
                                    <b> <%=(String) wbo.getAttribute("typeName")%> </b>
                                </td>
                                <td nowrap class="<%=bgColor%>" style="padding-left:10px;<%=style%>">
                                    <a href="<%=context%>/ProjectServlet?op=viewUnitType&id=<%=wbo.getAttribute("id")%>">
                                        <%= unitTypeListTitles[1]%>
                                    </a>
                                </td>
                                <td nowrap class="<%=bgColor%>" style="padding-left:10px;<%=style%>">
                                    <a href="<%=context%>/ProjectServlet?op=getUpdateUnitType&id=<%=wbo.getAttribute("id")%>">
                                        <%= unitTypeListTitles[2]%>
                                    </a>
                                </td>
                                <td nowrap class="<%=bgColor%>" style="padding-left:10px;<%=style%>">
                                    <a href="<%=context%>/ProjectServlet?op=confirmDeleteUnitType&id=<%=wbo.getAttribute("id")%>&typeName=<%=wbo.getAttribute("typeName")%>">
                                        <%= unitTypeListTitles[3]%>
                                    </a>
                                </td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>
                <br /><br />
            </fieldset>
        </form>
    </body>
</html>

