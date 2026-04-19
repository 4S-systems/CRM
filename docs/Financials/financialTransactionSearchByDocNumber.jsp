 
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Units.Units"  />
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String fromDateVal = (String) request.getAttribute("fromDate");
        String toDateVal = (String) request.getAttribute("toDate");
        String align = null;
        String style = null;
        String title,ByDocu,BytransCode;
        String stat = (String) request.getSession().getAttribute("currentMode");
        String smry=(String) request.getParameter("smry")==null?"1":(String) request.getParameter("smry");
        String SearchNum=(String) request.getParameter("SearchNum")==null?" ":(String) request.getParameter("SearchNum");
        ArrayList<WebBusinessObject> dataLst = request.getAttribute("dataLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("dataLst") : null;

        String  fromDate,dir,  toDate,search,entrerNum ;
        String DocNum,TransNum,Date,TransValue,Debitor,Creditor,notes,TransType; 
        if (stat.equals("En")) {
            dir = "LTR";
            fromDate = "From Date";
            toDate = "To Date";
             search = "Search";
            align = "center";
             style = "text-align:left";
             title="Financial Transaction Search By Number" ;
             ByDocu="By Document Code";
             BytransCode="By Transaction Code";
             entrerNum="Enter The Number";
             DocNum="Document Code";
             TransNum="Transaction Code";
             Date="Transaction Date";
             TransType="Transaction Type";
             TransValue="Transaction Value";
             Debitor="Debitor";
             Creditor="Creditor";
             notes="notes";
             
        } else {
            dir = "RTL";
            fromDate = "من تاريخ";
            toDate = "إلى تاريخ";
            search = "بحث";
            align = "center";
            style = "text-align:Right";
            title="بحث عن الحركات المحاسبيه بالرقم";
            ByDocu="بكود المستند";
            BytransCode="بالقيد المحاسبى";
            entrerNum="ادخل الرقم";
            DocNum="كود المستند";
            TransNum="كود الحركه";
            Date="تاريخ الحركه";
            TransType="نوع الحركه";
            TransValue="قيمة الحركه";
            Debitor="مدين ";
            Creditor="دائن";
            notes="ملاحظات";
           
            }
            
            ArrayList<WebBusinessObject> finanTransLst = (ArrayList<WebBusinessObject>) request.getAttribute("finanTransLst");
        %>
        <script  type="text/javascript">
            
            $(document).ready(function () {
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
                
                
            });
            
            $(function () {
                $("#sTable").DataTable({
                   bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "bAutoWidth": true,
                    "aaSorting": [[0, "asc"]]
                });
            });
            
            function submitForm(){
                var fromDate = $("#fromDate").val();
                var toDate = $("#toDate").val();
                document.finanTransaction.action = "<%=context%>/FinancialServlet?op=financialTransactionSearchByDocNumber&fromDate="+fromDate + "&toDate=" + toDate;
                document.finanTransaction.submit();

            } 
            
           
            
            function exportToExcel() {
                var fromDate = $("#fromDate").val();
                var toDate = $("#toDate").val();
                var contractor=$("#contractor").val();
                var transactionTotal=$("#transactionTotal").val();
                var invoiceTotal=$("#invoiceTotal").val();
                var url = "<%=context%>/FinancialServlet?op=ContractorTransToExcel&fromDate="+ fromDate + "&toDate="+ toDate + "&contractor="+ contractor+ "&transactionTotal="+ transactionTotal + "&invoiceTotal="+ invoiceTotal  ;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }
          
            
        </script>
        <style>
            .attach-icon {
                content:url('images/attach.png');
            }
            
            .view-file-icon {
                content:url('images/Foldericon.png');
            }
            
            .gallery-view-icon {
                content:url('images/gallery.png');
            }
            .w2ui-grid .w2ui-grid-toolbar {
                padding: 14px 5px;
                height: 150px;
            }

            .w2ui-grid .w2ui-grid-header {
                padding: 14px;
                font-size: 20px;
                height: 150px;
            }
            
            .ui-dialog-titlebar-close {
                visibility: hidden;
            }
        </style>
    </head>
    <body>
        <div name="divAttachmentTag"></div>
        <FORM NAME="finanTransaction" METHOD="POST">
            <FIELDSET class="set" style="width:98%;border-color: #006699">
                <legend>
                    <font color="blue" size="5"> <%=title%> </font>
                </legend>
                <br/>
                <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block; margin-left: auto; margin-right: auto;">
                   
                     <tr id="smryTR">
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
                            <input type="radio" name="smry" value="1" <%="1".equals(smry) ? "checked" : ""%>/>
			</td>
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				<%=ByDocu%>
			    </font>
			</td>
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
			    <input type="radio" name="smry" value="0" <%="0".equals(smry) ? "checked" : ""%>/>
			</td>
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				<%=BytransCode%>
			    </font>
			</td>
		    </tr>
                    <tr class="head">
                        <td class="blueHeaderTD" colspan="2" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=fromDate%></font></b>
                        </td>
                        <td class="blueHeaderTD" colspan="2" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=toDate%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td colspan="2" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                          
                        </td>
                    </tr>
                    <tr>
                         <td class="blueHeaderTD" colspan="2" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=entrerNum%></font></b>
                        </td>
                         
                        <td colspan="2" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                         
                            <input id="SearchNum" name="SearchNum" type="text"  style="width: 100%;color: black;font-size: medium;text-align: center;align-content: center" value="<%=SearchNum%>" />
                       
                        </td>
                    </tr>
                   
                     
                    <tr>
                        <td bgcolor="#F7F6F6" style="text-align:center; width: 20%; height: 100%; border: none;" valign="middle" rowspan="2" colspan="4">
                            <button type="submit" style="width: 30%; height: 90%;color: #27272A; font-size:15; font-weight:bold; margin: 5px;" onclick="JavaScript: submitForm();" class="button"><%=search%><img height="15" src="images/search.gif"/></button>
                           
                        </td>
                         
                    </tr>
                </table>
                <br/>
                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                     <table class="display" id="sTable" align="center" cellpadding="0" cellspacing="0" style="direction: <%=dir%>;">
                        <thead>
                            <tr>
                                 <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%">
                                     <b>
                                       <%=DocNum%>
                                    </b>
                                </th>
                                <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%">
                                     <b>
                                        <%=TransNum%>
                                    </b>
                                </th>
                             
                                      <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="6%">
                                    <b>
                                        <%=Date%>
                                    </b>
                                </th>
                                <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%">
                                    <b>
                                        <%=TransType%>
                                    </b>
                                </th>

                                <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%">
                                    <b>
                                         <%=TransValue%>
                                     </b>
                                </th>

                                <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="14%">
                                    <b>
                                         <%=Creditor%>
                                     </b>
                                </th>

                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%">
                                    <b>
                                         <%=Debitor%>
                                     </b>
                                </th>
                                   <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%">
                                    <b>
                                         <%=notes%>
                                     </b>
                                </th>    
                                
                            </tr>
                        </thead> 

                        <tbody  id="planetData2">  
                            <%
                                if(dataLst != null && !dataLst.isEmpty()){
                                     for (WebBusinessObject wbo : dataLst) {
                               
                            %>
                             <tr style="padding: 1px; background-color: <%=wbo.getAttribute("trColor")%>;" title="Difference Between Calling Date And Registration Date = <%if(wbo.getAttribute("DiffDays") != null){%><%=wbo.getAttribute("DiffDays")%> Days<%}else{%> <%}%>">
                                            <td>
                                               <%=wbo.getAttribute("documentCode")%> 
                                             </td>
                                            
                                            <td nowrap>
                                                <b>
                                                     <%=wbo.getAttribute("transactionCode")%> 
                                                </b>
                                            </td>
                                             <td nowrap>
                                                <b>
                                                    <%=wbo.getAttribute("documentDate")%> 
                                                </b>
                                            </td>
                                             <td nowrap>
                                                <b>
                                                     <%=wbo.getAttribute("TRANSACTION_TYPE_NAME")%> 
                                                </b>
                                            </td>
                                            
                                            
                                             <td nowrap>
                                                <b>
                                                    <%=wbo.getAttribute("transValue")%> 
                                                </b>
                                            </td>
                                             <td nowrap>
                                                <b>
                                                     <%=wbo.getAttribute("SourceName")%>  
                                                </b>
                                            </td>
                                            
                                             <td nowrap>
                                                <b>
                                                     <%=wbo.getAttribute("DestName")%> 
                                                </b>
                                            </td>
                                            <td nowrap>
                                                <b>
                                                   <%=wbo.getAttribute("note")==null?"":wbo.getAttribute("note")%> 

                                                </b>
                                            </td>
                                        </tr>
                            <%}}%>
                        </tbody>
                    </table>
                </div>        
            </fieldset>
        </form>
    </body>
</html>
