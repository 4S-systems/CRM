<%-- 
    Document   : frstLstApp
    Created on : Feb 21, 2018, 2:32:10 PM
    Author     : fatma
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  

<%
    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    String context = metaDataMgr.getContext();
    
    String timeFormat = "yyyy-MM-dd";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    Calendar cal = Calendar.getInstance();
    String nowTime = sdf.format(cal.getTime());
    String tdtVl = request.getAttribute("tdtVl") != null ? (String) request.getAttribute("tdtVl") : nowTime;
    String frmDtVl = request.getAttribute("frmDtVl") != null ? (String) request.getAttribute("frmDtVl") : nowTime;
    String departs,all;
     ArrayList<WebBusinessObject> employeeList = (ArrayList<WebBusinessObject>) request.getAttribute("employeeList");
     ArrayList<WebBusinessObject> employees = (ArrayList<WebBusinessObject>) request.getAttribute("employees");
    ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
    String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
    String employeeID = request.getAttribute("employeeID") != null ? (String) request.getAttribute("employeeID") : "";

    ArrayList<WebBusinessObject> clntLst = request.getAttribute("clntLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("clntLst") : null;
        if (employees == null) {
            employees = new ArrayList<>();
        } 
    String stat = (String) request.getSession().getAttribute("currentMode");
    String frmDt, tDt, shw, clntNm, frstAppDt, lstAppDt,Employee, difBtwnDt, clntEntDt, lstAppBy, rate, lstCmnt, cmp, knwUsFrm, dir;
    if(stat.equals("En")){
        frmDt = " From Date ";
        tDt = " To Date ";
        shw = " Show ";
        clntNm = " Client Name ";
        frstAppDt = " First Call Date ";
        lstAppDt = " Last Call Date ";
        difBtwnDt = " Difference ( Days ) ";
        clntEntDt = " Client Entry Date ";
        lstAppBy = " Last Call By ";
        rate = " Rate ";
        lstCmnt = " Last Comment ";
        cmp = " Campaign ";
        knwUsFrm = " Know Us From ";
        departs="Departments";
         all="all";
         Employee="Employee";
        
        dir = "ltr";
    } else {
        frmDt = " من تاريخ ";
        tDt = " إلى تاريخ ";
        shw = " إعرض ";
        clntNm = " إسم العميل ";
        frstAppDt = " تاريخ أول مكالمة ";
        lstAppDt = " تاريخ أخر مكالمة ";
        difBtwnDt = " الفارق ( بالأيام ) ";
        clntEntDt = " تاريخ إدخال العميل ";
        lstAppBy = " أخر مكالمة بواسطة ";
        rate = " التصنيف ";
        lstCmnt = " أخر تعليق ";
        cmp = " الحملة ";
        knwUsFrm = " عرفتنا عن طريق ";
        departs="الاداره"; 
        Employee="الموظف";
        all="الكل";
        dir = "rtl";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> First And Last Client Appointment </title>
        
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <script>
            $(document).ready(function(){
              $("#departmentID").val('<%=departmentID %>');
                $("#frmDt, #tDt").datepicker({
                    maxDate: "d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                $('#clients').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    iDisplayLength: 100,
                    "order": [[0, "asc"]]
                }).fadeIn(2000);
            });
    
            function getEmployees(obj) {
               var departmentID = $(obj).val();
               
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=getEmployeesList",
                    data: {
                        departmentID: departmentID
                    },
                    success: function (jsonString) {
                        try {
                            var output = [];
                            output.push('<option value="">' + '<%=all%>' + '</option>');
                            var createdBy = $("#employeeID");
                            $(createdBy).html("");
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                            }
                            createdBy.html(output.join(''));
                        } catch (err) {
                        }
                    }
                });
            }
                     
            function getFrstLstClntApp(){
                document.frstLstClntApp.action = "<%=context%>/ClientServlet?op=frstLstApp";
                document.frstLstClntApp.submit();
            }
            
            function exportToExcel() {
                var url = "<%=context%>/ClientServlet?op=frstLstAppExcel&frmDt=" + $("#frmDt").val() + "&tDt=" + $("#tDt").val();
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=350, height=350");
            }
        </script>
    </head>
    
    <body>
        <fieldset align=center class="set" style="width: 90%;">
            <form name="frstLstClntApp" method="POST">
                <table class="blueBorder" align="center" dir="<%=dir%>" style="border-width: 1px; border-color: white; width: 50%; padding-bottom: 5%;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;">
                            <font size=3 color="white" style="font-weight: bold;">
                                 <%=frmDt%> 
                            </font>
                        </td>

                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;">
                            <font size=3 color="white" style="font-weight: bold;">
                                 <%=tDt%> 
                            </font>
                        </td>
                    </tr>

                    <tr>
                        <td bgcolor="#dedede" valign="middle" style="font-size:18px; width: 50%;">
                            <input type="text" id="frmDt" name="frmDt" value="<%=frmDtVl%>" style="width: 50%;" title=" <%=clntEntDt%> " readonly>
                        </td>

                        <td bgcolor="#dedede" valign="middle" style="font-size:18px; width: 50%;">
                            <input type="text" id="tDt" name="tDt" value="<%=tdtVl%>" style="width: 50%;" title=" <%=clntEntDt%> " readonly>
                        </td>
                    </tr>

                    <tr>
                        <td bgcolor="#dedede" valign="middle" style="font-size:18px; width: 50%;">
                            <input type="button" class="button" id="submt" name="submt" value="<%=shw%>" style="width: 25%; margin-bottom: 2.5%; margin-top: 2.5%;" onclick="getFrstLstClntApp();">
                        </td>
                        
                        <td bgcolor="#dedede" valign="middle" style="font-size:18px; width: 50%;">
                            <input type="button" class="button" id="excel" name="excel" value="Excel" style="width: 25%; margin-bottom: 2.5%; margin-top: 2.5%;" onclick="exportToExcel();">
                        </td>
                    </tr>
                </table>
                <br/>
                        <table class="blueBorder" align="center" dir="<%=dir%>" style="border-width: 1px; border-color: white; width: 50%; padding-bottom: 5%;">
                            <tr>
                                  <td  class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;">

                                    <p><%=departs%></p>
                                </td>
                          <td  bgcolor="#dedede" valign="middle" colspan="2" id="nclssTrSlc">
                            <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 300px;"
                                        onchange="getEmployees(this);">
                                <option ></option>
                                <% if( departments != null) { %>
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID"  />
                                <% } %>
                            </select>
                        </td>
                            </tr>
                             <tr>
                                 <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;"><p><%=Employee %></p></td>
                            <td  class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;">
                                <select name="employeeID" id="employeeID" style="width: 300px; font-size: 18px;">
                            </select>
                            </td>
                        </tr> 
                        </table>
                <center>
                    <div style="width: 90%; padding-top: 5%;" align="center">
                        <table id="clients" style="width: 100%; direction: <%=dir%>;">
                            <thead>
                                <tr>
                                    <th style="width: 10%;">
                                        <font size=3 style="font-weight: bold;">
                                             <%=clntNm%> 
                                        </font>
                                    </th>
                                    
                                    <th style="width: 10%;">
                                    </th>

                                    <th style="width: 10%;">
                                        <font size=3 style="font-weight: bold;">
                                             <%=frstAppDt%> 
                                        </font>
                                    </th>

                                    <th style="width: 10%;">
                                        <font size=3 style="font-weight: bold;">
                                             <%=lstAppDt%> 
                                        </font>
                                    </th>

                                    <th style="width: 10%;">
                                        <font size=3 style="font-weight: bold;">
                                             <%=lstAppBy%> 
                                        </font>
                                    </th>
                                    
                                    <th style="width: 10%;">
                                        <font size=3 style="font-weight: bold;">
                                             <%=cmp%> 
                                        </font>
                                    </th>
                                    
                                    <th style="width: 10%;">
                                        <font size=3 style="font-weight: bold;">
                                             <%=rate%> 
                                        </font>
                                    </th>
                                    
                                    <th style="width: 10%;">
                                        <font size=3 style="font-weight: bold;">
                                             <%=knwUsFrm%> 
                                        </font>
                                    </th>
                                    
                                    <th style="width: 20%;">
                                        <font size=3 style="font-weight: bold;">
                                             <%=lstCmnt%> 
                                        </font>
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    for (WebBusinessObject clntWbo : clntLst) {
                                %>
                                        <tr>
                                            <td>
                                                 <%=clntWbo.getAttribute("clntNm") != null ? clntWbo.getAttribute("clntNm") : ""%> 
                                            </td>
                                            
                                            <td>
                                                <a target="blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clntWbo.getAttribute("clntID")%>">
                                                    <img src="images/client_details.jpg" width="30" align="center">
                                                </a>
                                            </td>

                                            <td>
                                                <%=clntWbo.getAttribute("frstDt") != null ? clntWbo.getAttribute("frstDt").toString().split(" ")[0] : ""%> 
                                            </td>

                                            <td>
                                                 <%=clntWbo.getAttribute("lstDt") != null ? clntWbo.getAttribute("lstDt").toString().split(" ")[0] : ""%> 
                                            </td>
                                            
                                            <td>
                                                 <%=clntWbo.getAttribute("fullNm") != null ? clntWbo.getAttribute("fullNm") : ""%> 
                                            </td>
                                            
                                            <td>
                                                 <%=clntWbo.getAttribute("campaign") != null ? clntWbo.getAttribute("campaign") : ""%> 
                                            </td>
                                            
                                            <td>
                                                 <%=clntWbo.getAttribute("rate") != null ? clntWbo.getAttribute("rate") : ""%> 
                                            </td>
                                            
                                            <td>
                                                 <%=clntWbo.getAttribute("englishNm") != null ? clntWbo.getAttribute("englishNm") : ""%> 
                                            </td>
                                            
                                            <td>
                                                 <%=clntWbo.getAttribute("lstCmnt") != null ? clntWbo.getAttribute("lstCmnt") : ""%> 
                                            </td>
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