<%-- 
    Document   : appOfClientClassOfComChan
    Created on : Aug 29, 2018, 3:10:01 PM
    Author     : walid
--%>

<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> rates = (ArrayList<WebBusinessObject>) request.getAttribute("rates");
    ArrayList<WebBusinessObject> comChannels = (ArrayList<WebBusinessObject>) request.getAttribute("comChannels");
    ArrayList<WebBusinessObject> groups = (ArrayList<WebBusinessObject>) request.getAttribute("groups");
    String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";
    
    ArrayList<WebBusinessObject> appointmentsLst = (ArrayList<WebBusinessObject>) request.getAttribute("appointmentsLst");
    Calendar c = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String toDate = sdf.format(c.getTime());
    if (request.getAttribute("toDate") != null) {
        toDate = (String) request.getAttribute("toDate");
    }
    c.add(Calendar.MONTH, -1);
    String fromDate = sdf.format(c.getTime());
    if (request.getAttribute("fromDate") != null) {
        fromDate = (String) request.getAttribute("fromDate");
    }
    String sRate = (String) request.getAttribute("sRate");
    String sChannel = (String) request.getAttribute("sChannel");
    String callStatus = (String) request.getAttribute("callStatus");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = "center";
    String dir = null;
    String style = null, lang, langCode, title, fromDateStr, toDateStr, callTyp, rate,comCha,
            clientNm, clientMob, clientInterNo, email, appTyp, clntRate, comChnl, createdBy, appTime,
            noGroup, grop;

    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        title = " Appointments of Classified Clients";
        fromDateStr = " From Date ";
        toDateStr = " To Date ";
        callTyp = "Appointment Status";
        rate = "Rate";
        comCha = "Comm.Channels";
        clientNm = "Client Name";
        clientMob = "Mobile";
        clientInterNo = "International No.";
        email = "Email";
        appTyp = "Appointment Type";
        clntRate = "Classification";
        comChnl = "Communication Channel";
        createdBy = "Created By";
        appTime = "Appointment Time";
        noGroup = "No Groups";
        grop = "Groups";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        title = "متابعات العملاء المصنفين";
        fromDateStr = " من تاريخ ";
        toDateStr = " إلى تاريخ ";
        callTyp = "حالة المتابعة";
        rate = "التصنيف";
        comCha = "قنوات الإتصال";
        clientNm = "إسم العميل";
        clientMob = "رقم الموبايل";
        clientInterNo = "الرقم الدولى";
        email = "الإيميل";
        appTyp = "نوع المتابعة";
        clntRate = "التصنيف";
        comChnl = "قناة الإتصال";
        createdBy = "بواسطة";
        appTime = "تاريخ المتابعة";
        noGroup = "لا يوجد مجموعات";
        grop = "المجموعات";
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Channel Distribution</title>
        
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
            $(document).ready(function () {
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });

                $('#appointLst').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
                
                $("#callStatus").select2();
                $("#sRate").select2();
                $("#sChannel").select2();
                $("#groupID").select2();
            });
            
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }
            function exportToExcel() {
                document.SEARCH_APP_FORM.action = "<%=context%>/ProjectServlet?op=appOfClientClassExcel";
                document.SEARCH_APP_FORM.submit();
            }
            
        </script>
        
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            
            .img:hover{
                cursor: pointer ;
            }

            #mydiv {
                text-align:center;
            }
        </style>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_APP_FORM" action="<%=context%>/ProjectServlet?op=appOfClientClass" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"> <%=title%> </font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR="<%=dir%>" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"> <%=fromDateStr%> </b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b> <font size=3 color="white"> <%=toDateStr%> </b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b> <font size=3 color="white"> <%=grop%> </b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" readonly />
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" readonly />
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <select id="groupID" name="groupID" style="font-size: 14px; width: 100%">
                                <%if (groups != null && !groups.isEmpty()){%>
                                    <sw:WBOOptionList wboList="<%=groups%>" displayAttribute="groupName" valueAttribute="group_id" scrollToValue="<%=groupID%>" />
                                <%} else {%>
                                    <option><%=noGroup%></option>
                                <%}%>
                            </select>
                        </TD>
                        
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" >
                            <b><font size=3 color="white"> <%=callTyp%> </b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b> <font size=3 color="white"> <%=rate%> </b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b> <font size=3 color="white"> <%=comCha%> </b>
                        </td>
                    </tr>
                    <tr>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <select id="callStatus" name="callStatus" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="Javascript: callStatusChange();">
                                <option value="answered" <%=callStatus != null && callStatus.equals("answered") ? "selected" : "selected"%> >answered</option>
                                <option value="not answered" <%=callStatus != null && callStatus.equals("not answered") ? "selected" : "none"%>>not answered</option>
                                <option value="Wrong Number" <%=callStatus != null && callStatus.equals("Wrong Number") ? "selected" : "none"%>>Wrong Number</option>
                                <option value="Unreachable" <%=callStatus != null && callStatus.equals("Unreachable") ? "selected" : "none"%>>Unreachable</option>
                            </select>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <select name="sRate" id="sRate" style="width: 300px;">
                                <option value="" > All </option>
                                <sw:WBOOptionList wboList='<%=rates%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=sRate%>"/>
                            </select>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle" colspan="3">
                            <select name="sChannel" id="sChannel" style="width: 300px;">
                                <option value="" > All </option>
                                <sw:WBOOptionList wboList='<%=comChannels%>' displayAttribute="englishName" valueAttribute="id" scrollToValue="<%=sChannel%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" colspan="3">
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #000;font-size:15px;margin: 10px;font-weight:bold; width: 180px; "> Generate Report <IMG SRC="images/search.gif" ></button>  
                            <button style="width: 100px" type="button" onclick="javascript: exportToExcel();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">Excel</b>&ensp;<img src="images/icons/excel.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </td>
                    </tr>
                </table>
                <br/>
                <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <table id="appointLst"  align="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;" >
                        <thead>
                            <tr>
                                <th STYLE="text-align:center; font-size:14px"><b><%=clientNm%></b></th>
                                <th STYLE="text-align:center; font-size:14px"><b><%=clientMob%></b></th>
                                <th STYLE="text-align:center; font-size:14px"><b><%=clientInterNo%></b></th>
                                <th STYLE="text-align:center; font-size:14px"><b><%=email%></b></th>
                                <th STYLE="text-align:center; font-size:14px"><b><%=clntRate%></b></th>
                                <th STYLE="text-align:center; font-size:14px"><b><%=comChnl%></b></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if(appointmentsLst != null && appointmentsLst.size() != 0){
                                    String callFunction;
                                    for (WebBusinessObject Wbo : appointmentsLst) {
                            %>
                                <tr>
                                    <TD STYLE="text-align: center; width: 5%" nowrap>
                                        <DIV>                   
                                            <%=(String) Wbo.getAttribute("name")%>
                                            <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId='+<%=Wbo.getAttribute("id")%>);"><img src="images/client_details.jpg" width="30" style="float: left;"></a>
                                        </DIV>
                                    </TD>
                                    <TD STYLE="text-align: center; width: 5%" nowrap>
                                        <DIV>                   
                                            <%=(String) Wbo.getAttribute("mobile")%>
                                        </DIV>
                                    </TD>
                                    <TD STYLE="text-align: center; width: 5%" nowrap>
                                        <DIV>                   
                                            <%=(String) Wbo.getAttribute("interPhone")%>
                                        </DIV>
                                    </TD>
                                    <TD STYLE="text-align: center; width: 5%" nowrap>
                                        <DIV>                   
                                            <%=(String) Wbo.getAttribute("email")%>
                                        </DIV>
                                    </TD>
                                    <TD STYLE="text-align: center; width: 5%" nowrap>
                                        <DIV>                   
                                            <%=(String) Wbo.getAttribute("rateNm")%>
                                        </DIV>
                                    </TD>
                                    <TD STYLE="text-align: center; width: 5%" nowrap>
                                        <DIV>                   
                                            <%=(String) Wbo.getAttribute("comChannel")%>
                                        </DIV>
                                    </TD>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <%
                        }
                    %>
                </div>   
            </form>
        </fieldset>
    </body>
</html>
