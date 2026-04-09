<%-- 
    Document   : lstEmpAppCmnt
    Created on : Apr 12, 2018, 12:16:41 PM
    Author     : fatma
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String fromDate = "";
    if (request.getAttribute("fromDate") != null) {
        fromDate = (String) request.getAttribute("fromDate");
    }
    String toDate = "";
    if (request.getAttribute("toDate") != null) {
        toDate = (String) request.getAttribute("toDate");
    }
    
    SimpleDateFormat oldFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat nwFormat = new SimpleDateFormat("yyyy/MM/dd");
    Date ftDate = new Date();
    ftDate = oldFormat.parse(fromDate);
    fromDate = nwFormat.format(ftDate);

    ftDate = oldFormat.parse(toDate);
    toDate = nwFormat.format(ftDate);
    
    String createdBy = (String) request.getAttribute("createdBy");
    
    ArrayList<WebBusinessObject> clients= (ArrayList<WebBusinessObject>) request.getAttribute("clients");

    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, fromD, toD, srch, clntNo, clntNm, clntMb, clntMl, clntDt, appDt, empNm, app, cllSt, cllRslt, sysDurtn, actualDurtn,
            appCmnt;
    if(stat.equals("En")){
        title = " Appointment Comments ";
        fromD = " From Date ";
        toD = " To Date ";
        srch = " Search ";
        clntNo = " Client No. ";
        clntNm = " Client Name ";
        clntMb = " Mobile ";
        clntMl = " Email ";
        clntDt = " Registiration Date ";
        appDt = " Appointment Date ";
        empNm = " Employee ";
        app = " Appointment ";
        cllSt = " Call Status ";
        cllRslt = " Result ";
        sysDurtn = " System Duration ";
        actualDurtn = " Actual Duration ";
        appCmnt = " Comment ";
    } else {
        title = " التعليقات على المتابعات ";
        fromD = " من تاريخ ";
        toD = " إلى تاريخ ";
        srch = " بحث ";
        clntNo = " رقم العميل ";
        clntNm = " إسم العميل ";
        clntMb = " رقم الموبايل ";
        clntMl = " البريد الإلكترونى ";
        clntDt = " تاريخ التسجيل ";
        appDt = " تاريخ المتابعة ";
        empNm = " الموظف ";
        app = " المتابعة ";
        cllSt = " حالة المكالمة ";
        cllRslt = " النتيجة ";
        sysDurtn = " مدة النظام ";
        actualDurtn = " المدة الفعلية ";
        appCmnt = " التعليق ";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <link href="js/select2.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" language="javascript" src="js/select2.min.js"></script>
        
        <script type="text/javascript">
            $(document).ready(function(){
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
                
                $("#appCmntTbl").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    //"order": [[ 8, "asc" ]],
                    "order": [[ 0, "asc" ]],
                    "columnDefs": [
                        {
                            "targets": [0, 1],
                            "visible": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        //api.column(8, {page: 'current'}).data().each(function (group, i) {
                        api.column(0, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                    '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray;" colspan="2">'
                                    + group + '</td>'
                                );
                                last = group;
                            }
                        });
                        
                        api.column(1, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                    '<td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray;"  colspan="6">'
                                    + group + '</td></tr>'
                                );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });
        </script>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/AppointmentServlet?op=lstEmpAppCmnt" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                        
                <table ALIGN="center" DIR="RTL" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=fromD%></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b> <font size=3 color="white"><%=toD%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="margin: 10px;"/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" />
                        </td>
                    </tr>
                    
                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" colspan="2">
                            <input id="createdBy" name="createdBy" type="hidden" value="<%=createdBy%>" />
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #000;font-size:15px;margin: 10px;font-weight:bold; width: 120px; "><%=srch%><IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                        </td>
                    </tr>
                </table>
                
                <div>
                    <TABLE style="display" id="appCmntTbl" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                        <thead>
                            <tr>
                                <th STYLE="text-align:center; font-size:14px">
                                     <%=clntNo%> 
                                </th>
                                <th STYLE="text-align:center; font-size:14px">
                                     <%=clntNm%> 
                                </th>
                                <th STYLE="text-align:center; font-size:14px">
                                     <%=appDt%> 
                                </th>
                                <th STYLE="text-align:center; font-size:14px">
                                     <%=empNm%> 
                                </th>
                                <th STYLE="text-align:center; font-size:14px">
                                     <%=app%> 
                                </th>
                                <th STYLE="text-align:center; font-size:14px">
                                     <%=cllSt%> 
                                </th>
                                <th STYLE="text-align:center; font-size:14px">
                                     <%=cllRslt%> 
                                </th>
                                <th STYLE="text-align:center; font-size:14px">
                                     <%=appCmnt%> 
                                </th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <%
                                for(WebBusinessObject empAppCmntWbo : clients){
                            %>
                                    <tr>
                                        <TD STYLE="text-align: center" nowrap>
                                             <%=empAppCmntWbo.getAttribute("clientNo") != null && !empAppCmntWbo.getAttribute("clientNo").toString().equalsIgnoreCase("UL") ? empAppCmntWbo.getAttribute("clientNo") : ""%> 
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                             <%=empAppCmntWbo.getAttribute("clientName") != null && !empAppCmntWbo.getAttribute("clientName").toString().equalsIgnoreCase("UL") ? empAppCmntWbo.getAttribute("clientName") : ""%> 
                                             <a target="blank" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=empAppCmntWbo.getAttribute("clientId")%>"><img src="images/client_details.jpg" width="30" style="float: left;"></a>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <%=empAppCmntWbo.getAttribute("appointmentDate") != null && !empAppCmntWbo.getAttribute("appointmentDate").toString().equalsIgnoreCase("UL") ? empAppCmntWbo.getAttribute("appointmentDate").toString().split(" ")[0] : ""%> 
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                             <%=empAppCmntWbo.getAttribute("userName") != null && !empAppCmntWbo.getAttribute("userName").toString().equalsIgnoreCase("UL") ? empAppCmntWbo.getAttribute("userName") : ""%> 
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                             <%=empAppCmntWbo.getAttribute("currentStatusName") != null && !empAppCmntWbo.getAttribute("currentStatusName").toString().equalsIgnoreCase("UL") ? empAppCmntWbo.getAttribute("currentStatusName") : ""%> 
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                             <%=empAppCmntWbo.getAttribute("option9") != null && !empAppCmntWbo.getAttribute("option9").toString().equalsIgnoreCase("UL") ? empAppCmntWbo.getAttribute("option9") : ""%> 
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                                <%=empAppCmntWbo.getAttribute("note") != null && !empAppCmntWbo.getAttribute("note").toString().equalsIgnoreCase("UL") ? empAppCmntWbo.getAttribute("note") : ""%> 
                                        </TD>
                                        
                                        <TD STYLE="text-align: center; width: 500px;">
                                            <%=empAppCmntWbo.getAttribute("comment") != null && !empAppCmntWbo.getAttribute("comment").toString().equalsIgnoreCase("UL") ? empAppCmntWbo.getAttribute("comment") : ""%> 
                                        </TD>
                                    </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </form>
        </fieldset>
    </body>
</html>
