<%-- 
    Document   : clientsProfileReport
    Created on : Apr 19, 2018, 12:25:10 PM
    Author     : shimaa
--%>

<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    
    ArrayList<WebBusinessObject> clientsLst = (ArrayList<WebBusinessObject>) request.getAttribute("clientsLst");
    
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1);
    int a = cal.get(Calendar.YEAR);
    int b = (cal.get(Calendar.MONTH)) + 1;
    int d = cal.get(Calendar.DATE);
    String prev = a + "/" + b + "/" + d;
    String age = "";
    int diffDays = 0;
    int diffMonths = 0;
    int diffYears = 0;

    

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = "center";
    String dir = null;
    String style = null;
    
    String title, beginDate, endDate, clients, gender, clntage, mobile, familyStatus, nokids,
            school, religion, profession, address, project, unit, price, area, generaldesc,
            name;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        title = "Clients Profile Report";
        beginDate = "From Date";
        endDate = "To Date";
        clients = "Clients Profile";
        gender = "Gender";
        clntage = "Age";
        mobile = "Mobile";
        familyStatus = "Marital Status";
        nokids = "# Of Kids";
        school = "School";
        religion = "Religion";
        profession = "Profession";
        address = "Region";
        project = "Project";
        unit = "Unit";
        price = "Price";
        area = "Area";
        generaldesc = "Description";
        name = "Name";
        
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:left";
        title = "ملفات العملاء الشخصية";
        beginDate = "من تاريخ";
        endDate = "الى تاريخ";
        clients = "بيانات العملاء";
        gender = "النوع";
        clntage = "العمر";
        mobile = "الموبايل";
        familyStatus = "الحالة الاجتماعية";
        nokids = "عدد الاطفال";
        school = "الدراسة";
        religion = "الديانة";
        profession = "التخصص";
        address = "المنطقة";
        project = "المشروع";
        unit = "الوحدة";
        price = "السعر";
        area = "المساحة";
        generaldesc = "وصف عام";
        name = "الاسم";
    }
    String sDate, sTime = null;
    
    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
    ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
%>
<!DOCTYPE html>

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

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function () {
            $("#beginDate, #endDate").datepicker({
                changeMonth: true,
                changeYear: true,
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
        });
        
        var oTable;
        $(document).ready(function() {
            $('#clients').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
            }).fadeIn(2000);
        });
        
        function getClients() {
            var beginDate = $("#beginDate").val();
            var endDate = $("#endDate").val();
            
            document.COMP_FORM.action = "<%=context%>/ReportsServletThree?op=clientsProfileReport&beginDate=" + beginDate + "&endDate=" + endDate;
            document.COMP_FORM.submit();
        }
        
        function exportToExcel() {
            var beginDate = $("#beginDate").val();
            var endDate = $("#endDate").val();
            var url = "<%=context%>/ReportsServletThree?op=exportClientsToExcel&beginDate="+beginDate+"&endDate="+endDate;
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
        }
    </script>
<html>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
    </head>
    <body>
        <FORM NAME="COMP_FORM" METHOD="POST">
                        <fieldset>
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%></font>
                                        </td>
                                    </tr>
                                </table>
                            </legend>

                            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                                <TR>
                                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </TD>
                                    <TD  class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </TD>
                                </TR>

                                <TR>
                                    <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <% if (beDate != null && !beDate.isEmpty()) {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" readonly/><img src="images/showcalendar.gif"> 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" readonly><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </TD>

                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" readonly><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" readonly><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </TR>
                                <tr>
                                    <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                                        <button  onclick="JavaScript: getClients();"   STYLE="color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                        <button type="button" STYLE="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; "
                                                onclick="exportToExcel()">Excel
                                        </button>
                                    </TD>
                                </tr>
                            </TABLE>
                            <br><br>
                            <%if(clientsLst != null ){%>
                        <div style="width: 98%;">
                            <TABLE  dir="<%=dir%>"  id="clients" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th style="color: #005599 !important;font: 5px;width:16%;"><%=name%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=gender%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=clntage%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=mobile%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=familyStatus%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=nokids%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=school%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=religion%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=profession%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=address%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=project%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=unit%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=price%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=area%></th>
                                        <th style="color: #005599 !important;font: 5px;width:6%;"><%=generaldesc%></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (WebBusinessObject wbo_ : clientsLst) {
                                    %>
                                    <tr>
                                        <TD style="width:16%;">
                                            <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo_.getAttribute("id")%>">
                                                <%=wbo_.getAttribute("name")%>
                                                <img src="images/client_details.jpg" width="30" style="float: left;">
                                            </a>
                                        </TD>

                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("gender")%>
                                        </TD>

                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("age") != null ? wbo_.getAttribute("age") : ""%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("mobile") != null && !"UL".equals(wbo_.getAttribute("mobile")) ? wbo_.getAttribute("mobile") : ""%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("matiralStatus")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("noOfKids") != null ? wbo_.getAttribute("noOfKids") : "لا يوجد"%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("school")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("religion")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("job")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("region")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("project")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("unit")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("price")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("area")%>
                                        </TD>
                                        <TD style="width:6%;">
                                            <%=wbo_.getAttribute("generalDesc")%>
                                        </TD>
                                    </tr>
                                    <%}%>
                                </tbody>
                            </TABLE>
                        </div>
                        <%}%>
                </fieldset>
        </form>
    </body>
</html>
