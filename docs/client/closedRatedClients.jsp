<%-- 
    Document   : closedRatedClients
    Created on : Apr 2, 2018, 1:37:58 PM
    Author     : fatma
--%>

<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> clsdRtClntLst = request.getAttribute("clsdRtClntLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("clsdRtClntLst") : null;
    String duration = request.getAttribute("duration") != null ? (String) request.getAttribute("duration") : "";
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String frm, all, oneDay, oneWeek, twoWeeks, threeWeeks, fourWeeks, twoMonth, year, shw, clntNm, clntMb, ClntIntrnPhn, clntCrtnDt,
            source, rspns, alert, lstRtDateStr, dir;
    if(stat.equals("En")){
        frm = " From ";
        all = " All ";
        oneDay = " A Day ";
        oneWeek = " A Week ";
        twoWeeks = " 2 Weeks ";
        threeWeeks = " 3 Weeks ";
        fourWeeks = " 4 Weeks ";
        twoMonth = " 2 Months ";
        year = " A Year ";
        shw = " Show ";
        clntNm = " Client Name ";
        clntMb = " Mobile ";
        ClntIntrnPhn = " International No. ";
        clntCrtnDt = " Creation Date ";
        source = " Source ";
        rspns = " Responsible ";
        alert = " Alert ";
        lstRtDateStr = " Last Classification Date ";
        
        dir = "ltr";
    } else{
        frm = " من ";
        all = " الكل ";
        oneDay = " يوم ";
        oneWeek = " إسبوع ";
        twoWeeks = " إسبوعان ";
        threeWeeks = " 3 أسابيع ";
        fourWeeks = " 4 أسابيع ";
        twoMonth = " شهرين ";
        year = " سنة ";
        shw = " إعرض ";
        clntNm = " إسم العميل ";
        clntMb = " الموبايل ";
        ClntIntrnPhn = " الرقم الدولى ";
        clntCrtnDt = " تاريخ التسجيل ";
        source = " المصدر ";
        rspns = " المسؤل ";
        alert = " تنبيه ";
        lstRtDateStr = " تاريخ أخر تصنيف ";
        
        dir = "rtl";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Closed Clients </title>
    </head>
    
    <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        
    <script src="js/select2.min.js"></script>
    <link href="js/select2.min.css" rel="stylesheet">
    
    <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
    <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
    <link rel="stylesheet" href="css/demo_table.css">
        
    <script>
        $(document).ready(function () {
            $("#duration").select2();
            
            $("#clsdRtClntsTbl").dataTable({
                "bJQueryUI": true,
                "destroy": true,
                "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                iDisplayLength: 50,
            }).fadeIn(2000);
        });
        
        function redirectComplaint(clientId, employeeId) {
            hideAllIcon(clientId);
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=redirectClientComplaint2",
                data: {
                    clientID: clientId,
                    employeeId: employeeId,
                    ticketType: '<%=CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER%>',
                    comment: 'Redirect Order',
                    subject: 'عميل مهم - تواصل فورا',
                    notes: 'عميل مهم - تواصل فورا'
                }, success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status === 'ok') {
                        $("#icon" + id).css("display", "block");
                        $("#loading" + id).css("display", "none");
                    }
                }, error: function (jsonString) {
                    alert(jsonString);
                }
            });
        }
        
        function hideAllIcon(id) {
            $("#button" + id).css("display", "none");
            $("#icon" + id).css("display", "block");
        }
        
        function submitForm(){
            document.closedClients.action = "<%=context%>/ClientServlet?op=getClosedRatedClients";
            document.closedClients.submit();
        }
    </script>
    
    <body>
        <fieldset class="set" align="center" style="width: 95%;">
            <form name="closedClients" id="closedClients" method="post">
                <table class="blueBorder" align="center" dir="<%=dir%>" width="50%" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 33%;">
                             <%=frm%> 
                        </td>

                        <td bgcolor="#dedede" valign="middle" style="width: 34%;" title="<%=lstRtDateStr%>">
                            <select style="width: 90%;" id="duration" name="duration">
                                <option value="" <%=duration.equalsIgnoreCase("") ? "selected" : ""%>> <%=all%> </option>
                                <option value="oneDay" <%=duration.equalsIgnoreCase("oneDay") ? "selected" : ""%>> <%=oneDay%> </option>
                                <option value="oneWeek" <%=duration.equalsIgnoreCase("oneWeek") ? "selected" : ""%>> <%=oneWeek%> </option>
                                <option value="twoWeeks" <%=duration.equalsIgnoreCase("twoWeeks") ? "selected" : ""%>> <%=twoWeeks%> </option>
                                <option value="threeWeeks" <%=duration.equalsIgnoreCase("threeWeeks") ? "selected" : ""%>> <%=threeWeeks%> </option>
                                <option value="fourWeeks" <%=duration.equalsIgnoreCase("fourWeeks") ? "selected" : ""%>> <%=fourWeeks%> </option>
                                <option value="twoMonth" <%=duration.equalsIgnoreCase("twoMonth") ? "selected" : ""%>> <%=twoMonth%> </option>
                                <option value="year" <%=duration.equalsIgnoreCase("year") ? "selected" : ""%>> <%=year%> </option>
                            </select>
                        </td>

                        <td bgcolor="#dedede" valign="middle" style="width: 33%;">
                            <input type="button" class="button" value="<%=shw%>" style="width: 75%;" onclick="submitForm();">
                        </td>
                    </tr>
                </table>

                <center>
                    <div style="width: 95%; padding-bottom: 5%; padding-top: 5%;">
                        <TABLE id="clsdRtClntsTbl" ALIGN="center" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                            <thead>                
                                <tr>
                                    <th STYLE="text-align:center; font-size: 14px; width: 16%;">
                                        <b>
                                             <%=clntNm%> 
                                        </b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px; width: 16%;">
                                        <b>
                                             <%=clntMb%> 
                                        </b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px; width: 14%;">
                                        <b>
                                             <%=ClntIntrnPhn%> 
                                        </b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px; width: 14%;">
                                        <b>
                                             <%=clntCrtnDt%> 
                                        </b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px; width: 14%;">
                                        <b>
                                             <%=source%> 
                                        </b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px; width: 14%;">
                                        <b>
                                             <%=rspns%>  
                                        </b>
                                    </th>

                                    <th STYLE="text-align: center; color: white; font-size: 14px; width: 7%;">
                                    </th>

                                    <th STYLE="text-align: center; color: white; font-size: 14px; width: 7%;">
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    for (WebBusinessObject clsdRtClntWbo : clsdRtClntLst) {
                                %>
                                    <tr style="cursor: pointer">
                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>
                                                <b>
                                                    <%=clsdRtClntWbo.getAttribute("name")%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                           
                                                <b>
                                                    <%=clsdRtClntWbo.getAttribute("mobile") != null && !clsdRtClntWbo.getAttribute("mobile").toString().equalsIgnoreCase("UL") ? clsdRtClntWbo.getAttribute("mobile") : ""%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                   
                                                <b>
                                                    <%=clsdRtClntWbo.getAttribute("interPhone") != null && !clsdRtClntWbo.getAttribute("interPhone").toString().equalsIgnoreCase("UL") ? clsdRtClntWbo.getAttribute("interPhone") : ""%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                   
                                                <b>
                                                    <%=clsdRtClntWbo.getAttribute("creationTime") != null ? clsdRtClntWbo.getAttribute("creationTime").toString().split(" ")[0] : ""%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center">
                                            <DIV>                   
                                                <b>
                                                    <%=clsdRtClntWbo.getAttribute("sourceName") != null ? clsdRtClntWbo.getAttribute("sourceName") : ""%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                           
                                                <b>
                                                    <%=clsdRtClntWbo.getAttribute("responsibleName") != null ? clsdRtClntWbo.getAttribute("responsibleName") : ""%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center;" nowrap>
                                            <a target="blanck" href="<%=context%>/ClientServlet?op=clientDetails&issueID=<%=clsdRtClntWbo.getAttribute("issueID")%>&clientId=<%=clsdRtClntWbo.getAttribute("id")%>">
                                                <img src="images/client_details.jpg" width="30" style="float: left;">
                                            </a>
                                        </TD>

                                        <TD STYLE="text-align: center;" nowrap>
                                            <button type="button" id="button<%=clsdRtClntWbo.getAttribute("id")%>" onclick="JavaScript: redirectComplaint('<%=clsdRtClntWbo.getAttribute("id")%>', '<%=clsdRtClntWbo.getAttribute("responsibleID")%>');" style="margin-bottom: 5px;"><%=alert%><img src="images/icons/forward.png" width="15" height="15" /></button>
                                            <img id="icon<%=clsdRtClntWbo.getAttribute("id")%>" src="images/icons/done.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; display: none;"/>
                                            <img id="loading<%=clsdRtClntWbo.getAttribute("id")%>" src="images/icons/loading.gif" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; display: none"/>
                                        </TD>
                                    </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </center>
            </form>
        </fieldset>
    </body>
</html>