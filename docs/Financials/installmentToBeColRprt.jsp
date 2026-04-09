<%@page import="java.util.Vector"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Date"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        Calendar cal = Calendar.getInstance();
        //'MM-yy'
        //String jDateFormat = user.getAttribute("javaDateFormat").toString();
        String jDateFormat = "MM-yyyy";
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);

        String sBDate = (String) request.getAttribute("fromDate");
        String sEDate = (String) request.getAttribute("toDate");
        
        String startDate = null;
        String toDateValue = null;
        if (sEDate != null && !sEDate.equals("")) {
            toDateValue = sEDate;
        } else {
            toDateValue = sdf.format(cal.getTime());
        }
        if (sBDate != null && !sBDate.equals("")) {
            startDate = sBDate;
        } else {
            //cal.add(Calendar.MONTH, -1);
            startDate = sdf.format(cal.getTime());
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String Mtitle, Etitle, Atitle, fromDate, toDate, print, clientName, unitName, paymentAmount,
                paymentType, paymentDate;
        if (stat.equals("En")) {
            dir = "LTR";
            align = "center";
            Etitle = "View Installments That Need To Be Collected";
            fromDate = "Choose Month";
            print = "Search";
            clientName = "Client Name";
            unitName = "Unit";
            paymentAmount = "Payment Amount";
            paymentType = "Payment Type";
            paymentDate = "Payment Date";
        } else {
            dir = "RTL";
            align = "center";
            Etitle = " اﻷقساط المطلوب تحصيلها";
            fromDate = "إختار شهر";
            print = "بحث";
            clientName = "إسم العميل";
            unitName = "الوحدة";
            paymentAmount = "قيمة المبلغ المطلوب";
            paymentType = "النوع";
            paymentDate = "تاريخ الدفع";
        }
        ArrayList<WebBusinessObject> resultLst =  (ArrayList<WebBusinessObject>)request.getAttribute("resultLst");
        String fromD = (String)request.getAttribute("fromD");
    %>
     <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>

        <script type="text/javascript">
            $(document).ready(function () {
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true,
                    dateFormat: 'mm-yy',
                    minDate: 'today',
                    onClose: function(dateText, inst) { 
                        $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
                    }
                });

                oTable = $('#finanInst').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            
            function submitForm() {
                var fromD = $("#fromDate").val();
                document.EmployeesLoads.action = "<%=context%>/FinancialServlet?op=installmentToBeColRprt&fromD="+fromD;
                document.EmployeesLoads.submit();
            }

        </script>

        <style>
            .ui-datepicker-calendar {
                display: none;
            }
            table label {
                float: right;
            }

            td {
                border: none;
                padding-bottom: 10px;
            }
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }

            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataTD {
                background: #FFF
            }

            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
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
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
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

            .titleRow {
                background-color: orange;
            }

            .detailTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color: #FCC90D;
            }

            .dataDetailTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataDetailTD {
                background: #FFF19F
            }

            tr:nth-child(odd) td.dataDetailTD {
                background: #FFF19F
            }

            .login  h1 {
                font-size: 16px;
                font-weight: bold;

                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;

                margin-left: auto;
                margin-right: auto;
                text-height: 30px;

                color: black;

                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            
            .tbFStyle{
                background: silver;
                width: auto; 
                text-align: right; 
                margin-bottom: 10px !important; 
                margin-left: 135px; 
                margin-right: auto; 
                letter-spacing: 35px;
                border-radius: 10px;
                padding-right: 20px;
            }
            
            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }
        </style>
    </head>
    <body>
        <table border="0px" class="table tbFStyle" style="margin-top: -10px">
            <tr style="padding: 0px 0px 0px 50px;">
                <td class="td" style="text-align: center;">
                    <a title="Back" style="padding: 5px;">
                        <image style="height:42px;" src="images/icons/BACKNEWTO.png" onclick="window.history.go(-1);"/>
                    </a>
                </td>
            </tr>
        </table>
                    
        <form name="EmployeesLoads" method="post"> 
            <br/>
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                            <%=Etitle%>
                            </font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%" colspan="2">
                            <b><font size=3 color="white"><%=fromDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle" colspan="2">
                            <input id="fromDate" name="fromDate" type="text"  class="date-picker" readonly value="<%=fromD != null ? fromD : startDate%>"/><img src="images/showcalendar.gif"/> 
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="2" WIDTH="20%" colspan="2">
                            <button onclick="JavaScript: submitForm();" STYLE="color: #000;font-size:15px;font-weight:bold;height: 35px"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"/> </button>
                        </td>
                    </tr>
                </table>
                <br>
                <%
                    if(resultLst != null){
                %>
                <div style="width: 95%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="finanInst" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 20px; font-weight: bold; width: 9%;"><%=clientName%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;"><%=unitName%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;"> <%=paymentAmount%> </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;"><%=paymentType%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 9%;"><%=paymentDate%></th>
                            </tr>
                        <thead>
                        <tbody >  
                            <%
                                WebBusinessObject wbo = new WebBusinessObject();
                                for(int i=0; i<resultLst.size(); i++){

                                    wbo = resultLst.get(i);
                            %>

                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <b><%=wbo.getAttribute("clientName")%></b>
                                </TD>
                                <TD>
                                    <b><%=wbo.getAttribute("unitName")%></b>
                                </TD>

                                <TD>
                                    <b><%=wbo.getAttribute("paymentAmount")%></b>
                                </TD>

                                <TD>
                                    <b><%=wbo.getAttribute("paymentType")%></b>
                                </TD>
                                <TD>
                                    <b><%=wbo.getAttribute("paymentDate").toString().split(" ")[0]%></b>
                                </TD>
                            </tr>
                            <% } %>
                        </tbody>  

                    </TABLE>
                    <BR />
                </div>
                <%
                } else {%>   
                <%}%>
            </fieldset>
        </form>
    </body>
</html>
