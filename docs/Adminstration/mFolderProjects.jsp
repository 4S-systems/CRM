<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="js/jquery-1.10.2.js" ></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            ArrayList<WebBusinessObject> arrayOfClientComplaints = (ArrayList<WebBusinessObject>) request.getAttribute("clientComplaints");
            Calendar c = Calendar.getInstance();
            String sDate, sTime, fullName = null;

            String sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            String sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            String mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            String tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            String wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            String thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            String fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            String noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        %>
    </head>
    <script LANGUAGE="JavaScript" TYPE="text/javascript">
//        $(document).ready(function() {
//            $('#indextable').dataTable({
//                bJQueryUI: true,
//                sPaginationType: "full_numbers",
//                "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
//                iDisplayLength: 20,
//                iDisplayStart: 0,
//                "bPaginate": true,
//                "bProcessing": true,
//                "aaSorting": [[10, "asc"]]
//            }).show();
//        });
    </script>
    <body>
        <table class="blueBorder"  id="indextable" align="center" DIR="RTL" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: block;">
            <thead>
                <TR>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 25px" width="10%"><SPAN><b>رقم المتابعة</b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 25px" width="10%"><SPAN><b>اسم العميل / الشركة</b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 25px" width="10%"><SPAN><b> اسم المصدر</b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 25px" width="10%"><b>الحالة</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 25px" width="10%"><b>تاريخ الحالة</b></TH>
                </TR>
            </thead> 
            <tbody  id="planetData2">  
                <%
                    WebBusinessObject wbo = new WebBusinessObject();
                    for (int i = 0; i < arrayOfClientComplaints.size(); i++) {
                        wbo = (WebBusinessObject) arrayOfClientComplaints.get(i);
                %>

                <TR style="padding: 1px;">
                    <TD  style="cursor: pointer" onmouseout="this.className = ''">
                        <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=wbo.getAttribute("issueId")%>"<b><font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDByDate")%></font></b></a>
                    </TD>
                    <TD>
                        <b><%=wbo.getAttribute("clientName")%></b>
                    </TD>
                    <TD>
                        <b><%=wbo.getAttribute("createdByName")%></b>
                    </TD>
                    <TD>
                        <b><%=wbo.getAttribute("statusArName")%></b>
                    </TD>
                            <%  c = Calendar.getInstance();
                                DateFormat formatter;
                                formatter = new SimpleDateFormat("dd/MM/yyyy");
                                String[] arrDate = wbo.getAttribute("creationTime").toString().split(" ");
                                Date date = new Date();
                                sDate = arrDate[0];
                                sTime = arrDate[1];
                                String[] arrTime = sTime.split(":");
                                sTime = arrTime[0] + ":" + arrTime[1];
                                sDate = sDate.replace("-", "/");
                                arrDate = sDate.split("/");
                                sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                                c.setTime((Date) formatter.parse(sDate));
                                int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                                String currentDate = formatter.format(date);
                                String sDay = null;
                                if (dayOfWeek == 7) {
                                    sDay = sat;
                                } else if (dayOfWeek == 1) {
                                    sDay = sun;
                                } else if (dayOfWeek == 2) {
                                    sDay = mon;
                                } else if (dayOfWeek == 3) {
                                    sDay = tue;
                                } else if (dayOfWeek == 4) {
                                    sDay = wed;
                                } else if (dayOfWeek == 5) {
                                    sDay = thu;
                                } else if (dayOfWeek == 6) {
                                    sDay = fri;
                                }
                            %>
                            <%if (currentDate.equals(sDate)) {%>
                    <TD nowrap  ><font color="red">Today - </font><b><%=sTime%></b></TD>
                            <%} else {%>

                    <TD nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                            <%}%>
                </TR>
                <%
                    }

                %>
            </tbody>
        </table>
    </body>
</html>
