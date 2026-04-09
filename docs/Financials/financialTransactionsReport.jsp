<%-- 
    Document   : financialTransactionsReport
    Created on : Jul 11, 2018, 10:51:03 AM
    Author     : fatma
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal.add(Calendar.DAY_OF_MONTH, -3);
    String beDate = request.getAttribute("beginDate") != null ? (String) request.getAttribute("beginDate") : sdf.format(cal.getTime());
    String eDate = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : nowTime;
    
    ArrayList<WebBusinessObject> finTrnsLst = request.getAttribute("finTrnsLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("finTrnsLst"): null;
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir, title, beginDate,excel,  endDate, search;
    if (stat.equals("En")) {
        dir = "ltr";
        
        title = " Financial Transactions Report ";
        beginDate = " From Date ";
        endDate = " To Date ";
        search = " Search ";
        excel="Excel";

    } else {
        dir = "rtl";
        
        title = " تقرير الحركات المحاسبية ";
        beginDate = " من تاريخ ";
        endDate = " إلى تاريخ ";
        search = " بحث ";
         excel="اكسيل";

    }
    
    double amount = 0;
    DecimalFormat formatter = new DecimalFormat("#,###.000");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Financial Transactions Report</title>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/media/css/jquery.dataTables.css">
        <link rel="stylesheet" type="text/css" href="css/buttons.dataTables.min.css"/>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        
        <link rel="stylesheet" href="css/demo_table.css">
              <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="js/buttons.flash.min.js"></script>
        
        <style>
	    .button2{
                font-size: 15px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                line-height: 20px;
                width: 150px;
                height: 30px;
                text-decoration: none;
                display: inline-block;
                margin: 4px 2px;
                -webkit-transition-duration: 0.4s;
                transition-duration: 0.8s;
                cursor: pointer;
                border-radius: 12px;
                border: 1px solid #008CBA;
                padding-left:2%;
                text-align: center;
            }

            .button2:hover {
                background-color: #afdded;
                padding-top: 0px;
            }
            
            *>*{
                vertical-align: middle;
            }
        </style>
        
        <script LANGUAGE="JavaScript" type="text/javascript">
            $(document).ready(function(){
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: "D",
                    dateFormat: "yy/mm/dd"
                });
                
                $('#finTrans').DataTable( {
                   bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });
            
            function exportToExcel() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                var accountID=$("#accountID").val();
                var url = "<%=context%>/FinancialServlet?op=financialTransactionReport&beginDate="+ beginDate + "&endDate="+ endDate+"&accountID="+accountID;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }
        </script>
    </head>
    <body>
        <form NAME="financialTransactionsReportForm" METHOD="POST" action="<%=context%>/FinancialServlet?op=financialTransactionsReport">
            <fieldset class="set" style="width: 95%; padding-bottom: 20px;">
                <legend align="center">
                    <font color="blue" size="6">
                        <%=title%>
                    </font>
                </legend>
                    
                <table align="center" style="direction: <%=dir%>; width: 50%;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width: 33%;">
                            <font size=3 color="white">
                                 <%=beginDate%> 
                        </td>

                        <td class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width: 33%;">
                            <font size=3 color="white">
                                 <%=endDate%> 
                        </td>

                        <td bgcolor="#F7F6F6" style="width: 34%; border: none;" valign="middle" rowspan="2">
                            <button class="button" style="width: 50%; font-size: 15px; font-weight:bold;">
                                 <%=search%> 
                                 <IMG HEIGHT="15" SRC="images/search.gif" > 
                            </button> 
                                   <br/>
                                 <br/>
                              <button class="button" type="button" style="width: 50%; font-size: 15px; font-weight:bold;"
                                onclick="exportToExcel()">
                                 <%=excel%> 
                            </button>
                        </td>
                    </tr>

                    <tr>
                        <td style="text-align: center; border: none;" bgcolor="#F7F6F6" valign="MIDDLE" >
                            <input id="beginDate" name="beginDate" type="text" value="<%=beDate != null && !beDate.isEmpty() ? beDate : ""%>" style="width: 75%;" readonly />
                            <img src="images/showcalendar.gif" > 
                        </td>

                        <td bgcolor="#F7F6F6" style="text-align: center; border: none;" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=eDate != null && !eDate.isEmpty() ? eDate : ""%>" style="width: 75%;" readonly />
                            <img src="images/showcalendar.gif" >
                        </td>
                    </tr>
                </table>
                            
                <div style="width: 95%; padding-top: 2%;" class="tabsS" id="sentJO">
                    <table class="display" id="finTrans" align="center" cellpadding="0" cellspacing="0" style="direction: <%=dir%>;">
                        <thead>
                            <tr>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                     مسلسل المستند 
                                </th>  
                                
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                     رقم المستند 
                                </th>
                                
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         تاريخ المستند 
                                    </b>
                                </th>

                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         القيد المحاسبى 
                                    </b>
                                </th>

                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                        نوع الحركة المحاسبية 
                                    </b>
                                </th>

                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         الغرض 
                                    </b>
                                </th>

                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         قيمة الحركة 
                                    </b>
                                </th>
                                
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         صافى الحركة 
                                    </b>
                                </th>

                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         نوع الدائن 
                                    </b>
                                </th>
                                
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         الدائن 
                                    </b>
                                </th>
                                
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         نوع المدين
                                    </b>
                                </th>
                                
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                         المدين 
                                    </b>
                                </th>
                                
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 16%;">
                                    <b>
                                         ملاحظات 
                                    </b>
                                </th>
                            </tr>
                        </thead> 
                        <tbody  id="">  
                        <%
                            double totalValue = 0, totalNet = 0;
                            for (WebBusinessObject finTrnsWbo : finTrnsLst) {
                                
                        %>
                            <tr style="padding: 1px;">
                                <td>
                                     <%=finTrnsWbo.getAttribute("documentNo") != null ? finTrnsWbo.getAttribute("documentNo") : ""%>
                                </td>
                                
                                <td>
                                     <%=finTrnsWbo.getAttribute("documentCode") != null ? finTrnsWbo.getAttribute("documentCode") : ""%>
                                </td>
                                
                                <td>
                                     <%=finTrnsWbo.getAttribute("documentDate") != null ? finTrnsWbo.getAttribute("documentDate").toString().split(" ")[0] : ""%>
                                </td>
                                
                                <td>
                                     <%=finTrnsWbo.getAttribute("transactionCode") != null ? finTrnsWbo.getAttribute("transactionCode") : ""%>
                                </td>
                                
                                <td>
                                     <%=finTrnsWbo.getAttribute("finTrnsTyp") != null ? finTrnsWbo.getAttribute("finTrnsTyp") : ""%>
                                </td>
                                
                                <td>
                                     <%=finTrnsWbo.getAttribute("purpose") != null ? finTrnsWbo.getAttribute("purpose") : ""%>
                                </td>
                                
                                <td>
                                    <%
                                        amount = Double.parseDouble(finTrnsWbo.getAttribute("transValue").toString());
                                        totalValue += amount;
                                    %>
                                    <%=finTrnsWbo.getAttribute("transValue") != null ? formatter.format(amount) : ""%>
                                </td>
                                
                                <td>
                                    <%
                                        amount = Double.parseDouble(finTrnsWbo.getAttribute("transNetValue").toString());
                                        totalNet += amount;
                                    %>
                                    <%=finTrnsWbo.getAttribute("transNetValue") != null ? formatter.format(amount) : ""%>
                                </td>
                                
                                <td>
                                     <%=stat.equals("En") ? finTrnsWbo.getAttribute("srcEnDesc") != null ? finTrnsWbo.getAttribute("srcEnDesc") : "" : finTrnsWbo.getAttribute("srcArDesc") != null ? finTrnsWbo.getAttribute("srcArDesc") : ""%>
                                </td>
                                
                                <td>
                                     <%=finTrnsWbo.getAttribute("srcNm") != null ? finTrnsWbo.getAttribute("srcNm") : ""%>
                                </td>
                                
                                <td>
                                     <%=stat.equals("En") ? finTrnsWbo.getAttribute("dstEnDsc") != null ? finTrnsWbo.getAttribute("dstEnDsc") : "" : finTrnsWbo.getAttribute("dstArDesc") != null ? finTrnsWbo.getAttribute("dstArDesc") : ""%>
                                </td>
                                
                                <td>
                                     <%=finTrnsWbo.getAttribute("dstNm") != null ? finTrnsWbo.getAttribute("dstNm") : ""%>
                                </td>
                                
                                <td>
                                     <%=finTrnsWbo.getAttribute("note") != null ? finTrnsWbo.getAttribute("note") : ""%>
                                </td>
                                
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
<!--                        <tfoot>
                            <tr style="font-size: 16px;">
                                <th colspan="5">&nbsp;</th>
                                <th>إجمالي</th>
                                <th><%=formatter.format(totalValue)%></th>
                                <th><%=formatter.format(totalNet)%></th>
                                <th colspan="5">&nbsp;</th>
                            </tr>
                        </tfoot>-->
                    </table>
                </div>
            </fieldset>
        </form>
    </body>
</html>
