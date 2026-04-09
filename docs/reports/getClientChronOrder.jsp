<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> Clients = (ArrayList<WebBusinessObject>) request.getAttribute("clientsLst");
    
    String beginDate = "";
    if (request.getAttribute("beginDate") != null) {
        beginDate = (String) request.getAttribute("beginDate");
    }
    String endDate = "";
    if (request.getAttribute("endDate") != null) {
        endDate = (String) request.getAttribute("endDate");
    }
    
    ArrayList<WebBusinessObject> employeesLst = (ArrayList<WebBusinessObject>) request.getAttribute("employeesLst");
    String empId = (String)request.getAttribute("empId");
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, fromDate, toDate, search, num, clntNm, mob, interPh, creationTime, customizationDate,
            distributionDate, classificationDate, employee;
    if (stat.equals("En")) {
        title = "Client Chronological Order";
        fromDate = "From Date";
        toDate = "To Date";
        search = "Search";
        num = "No.";
        clntNm = "Client";
        mob = "Mobile";
        interPh = "International Phone";
        creationTime = "Registraction Time";
        customizationDate = "Customization Date";
        distributionDate = "Distribution Date";
        classificationDate = "Classification Date";
        employee = "Employee";
    } else {
        title = "الترتيب الزمنى للعميل";
        fromDate = "من تاريخ";
        toDate = "إلى تاريخ";
        search = "بحث";
        num = "م";
        clntNm = "العميل";
        mob = "الموبايل";
        interPh = "الرقم الدولى";
        creationTime = "تاريخ تسجيل العميل";
        customizationDate = "تاريخ التخصيص";
        distributionDate = "تاريخ التوزيع";
        classificationDate = "تاريخ التصنيف";
        employee = "الموظف المخصص إليه";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        
        <script>
            $(document).ready(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
                
                $("#showLockedClientsTbl").dataTable({
                        bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
                
            });
                        
            function search(){
                var sBeginDate = $("#beginDate").val();
                var sEndDate = $("#endDate").val();
                var empId = $("#empId option:selected").val();
                document.LOCKED_CLIENT_FORM.action = "<%=context%>/AppointmentServlet?op=getClientChronOrder&beginDate=" + sBeginDate + "&endDate=" + sEndDate+ "&empId=" + empId;
                document.LOCKED_CLIENT_FORM.submit();
            }
                
        </script>
        
        <style type="text/css">
            .titlebar {
                /*background-image: url(images/title_bar.png);*/
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
                background-color: #3399ff;
            }
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
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="white" size="4">
                            <%=title%>
                        </font>
                    </td>
                </tr>
            </table>
            
            <br>
            
            <form name="LOCKED_CLIENT_FORM" method="POST">
                
                <br>
                
                <table ALIGN="center" DIR="RTL" WIDTH="70%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" WIDTH="30%">
                            <b>
                                <font size=3 color="white"><%=fromDate%>
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;"WIDTH="30%">
                            <b>
                                <font size=3 color="white"><%=toDate%>
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;"WIDTH="30%">
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>" readonly>
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" readonly>
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle" rowspan="4">
                            <input type="button" class="button" value=" <%=search%> "  onclick="search();" style="width: 50%">
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" WIDTH="30%" colspan="2">
                            <b>
                                <font size=3 color="white"><%=employee%>
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" colspan="2">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="empId" id="empId" >
				<option value="" selected> إختر موظف </option>
                                <sw:WBOOptionList wboList='<%=employeesLst%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=empId%>"/>
                            </select>
                        </td>
                    </tr>
                </table>
                <br>
                <%
                    if(Clients != null && Clients.size() > 0){
                %>
                    <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showLockedClients">
                        <TABLE style="display" id="showLockedClientsTbl" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                            <thead>                
                                <tr>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=num%></b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=clntNm%></b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=mob%></b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=interPh%></b>
                                    </th>
                                    
                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=creationTime%></b>
                                    </th>
                                    
                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=customizationDate%></b>
                                    </th>
                                    
                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=distributionDate%></b>
                                    </th>
                                    
                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=classificationDate%></b>
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    int counter = 0;
                                    String clazz = "";
                                    String color = "";
                                    for (WebBusinessObject ClientsWbo : Clients) {
                                        counter++;
                                        
                                        if(ClientsWbo.getAttribute("creationTime") != null && ClientsWbo.getAttribute("classificationDate") != null
                                                && ClientsWbo.getAttribute("classificationDate") != "" && ClientsWbo.getAttribute("creationTime").toString().split(" ")[0].equalsIgnoreCase(ClientsWbo.getAttribute("classificationDate").toString().split(" ")[0])){   
                                            color = "#cce0ff";
                                        } else {
                                            color = "";
                                        }
                                %>

                                        <tr class="<%=clazz%>" style="cursor: pointer; background-color: <%=color%>" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                                            <TD STYLE="text-align: center; width: 5%" nowrap>
                                                <DIV>                   
                                                    <b><%=counter%></b>
                                                </DIV>
                                            </TD>

                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("name")%>
                                                    </b>
                                                    <a target="blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=ClientsWbo.getAttribute("id")%>">
                                                        <img src="images/client_details.jpg" width="30" style="float: left;">
                                                    </a>
                                                </DIV>
                                            </TD>

                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                   
                                                    <b>
                                                        <%=(ClientsWbo.getAttribute("mobile") != null ? ClientsWbo.getAttribute("mobile") : "")%>
                                                    </b>
                                                </DIV>
                                            </TD>

                                            <TD STYLE="text-align: center">
                                                <DIV>                   
                                                    <b>
                                                        <%=(ClientsWbo.getAttribute("interPhone") != null) ? ClientsWbo.getAttribute("interPhone") : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>

                                            
                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("creationTime") != null ? ClientsWbo.getAttribute("creationTime").toString().split(" ")[0] : ""%>
                                                    </b>
                                                    <b style="color: red">
                                                        <%=ClientsWbo.getAttribute("creationTime") != null ? ClientsWbo.getAttribute("creationTime").toString().split(" ")[1].substring(0,5) : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>
                                            
                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("customizationDate") != null ? ClientsWbo.getAttribute("customizationDate").toString().split(" ")[0] : ""%>
                                                    </b>
                                                    <b style="color: red">
                                                        <%=ClientsWbo.getAttribute("customizationDate") != null ? ClientsWbo.getAttribute("customizationDate").toString().split(" ")[1].substring(0,5) : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>
                                            
                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("distributionDate") != null ? ClientsWbo.getAttribute("distributionDate").toString().split(" ")[0] : ""%>
                                                    </b>
                                                    <b style="color: red">
                                                        <%=ClientsWbo.getAttribute("distributionDate") != null ? ClientsWbo.getAttribute("distributionDate").toString().split(" ")[1].substring(0,5) : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>
                                            
                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("classificationDate") != null ? ClientsWbo.getAttribute("classificationDate").toString().split(" ")[0] : ""%>
                                                    </b>
                                                    <b style="color: red">
                                                        <%=ClientsWbo.getAttribute("classificationDate") != null ? ClientsWbo.getAttribute("classificationDate").toString().split(" ")[1].substring(0,5) : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>
                                        </tr>
                                    <%} color = "";%>
                                </tbody>
                            </table>
                        </div>
                        <%
                            }
                        %>
                </form>
            </table>
        </fieldset>
    </body>
</html>