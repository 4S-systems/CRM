<%-- 
    Document   : FinancialTransactionRprt
    Created on : Sep 16, 2018, 3:53:49 PM
    Author     : walid
--%>

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
        ArrayList<WebBusinessObject> kindsList = (ArrayList<WebBusinessObject>)request.getAttribute("kindsList");
          ArrayList<LiteWebBusinessObject> invoicesList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("invoicesList");
        ArrayList<WebBusinessObject> transactionsList = (ArrayList<WebBusinessObject>) request.getAttribute("transactionsList");
          String align = null;

      String style = null;
      String inDate, invoiceNo, contractor1,amount, transactionNo, invoices, transactions, total;

        String stat = (String) request.getSession().getAttribute("currentMode");
        contractor1= (String)request.getAttribute("contractor"); 
        String finanTrans, units, search, clients, vUnits,vClients, docNo, docCod, docDate,
             tit1,tit2,TransTyp, transVal, debtor,Remainingtotal, creditor, unit, notes, source, dir,
                fromDate, toDate, contractor,totalM,actualTRa,payInvoice,paidInvoice,invoDetails;
        if (stat.equals("En")) {
            dir = "LTR";
            fromDate = "From Date";
            toDate = "To Date";
            payInvoice="Pay Invoice";
            actualTRa=" Actual Transaction";
            finanTrans = "Client's Statement Of Account";
            units = "Units";
            paidInvoice="this invoice is paid before";
            search = "Search";
            clients = "Clients";
            vUnits = "View Units";
            vClients = "View Clients";
            docNo = "Document No";
            invoDetails="Invoice Details";
            docCod = "Document Code";
            docDate = "Document Date";
            TransTyp = "Transaction Type";
            transVal = "Transaction Value";
            debtor = "Debtor";
            creditor = "Creditor";
            unit = "Unit";
            totalM="Total Value";
            notes = "Notes";
            source = "Created By";
            contractor = "Client";
            align = "center";
             style = "text-align:left";
             inDate = "In Date";
            invoiceNo = "Unit Code";
            amount = "Amount";
            transactionNo = "Transaction No.";
            invoices = "Premiums";
            transactions = "Transactions";
            total = "Total";
            tit1="what he has";
            tit2="what he took";
            Remainingtotal = "Remaining Total";
        } else {
            dir = "RTL";
            fromDate = "من تاريخ";
            toDate = "إلى تاريخ";
            finanTrans = "كشف حساب العميل";
            units = "الوحدات";
            search = "بحث";
            paidInvoice="هذه الفاتوره مدفوعه مسبقا";
            clients = "العملاء";
            vUnits = "عرض الوحدات";
            vClients = "عرض العملاء";
            actualTRa="الحركات الفعليه  ";
            docNo = "رقم المستند";
            docCod = "كود المستند";
            payInvoice="ادفع الفاتوره";
            docDate = "تاريخ المستند";
            TransTyp = "نوع الحركة";
            invoDetails="تفاصيل الفاتوره"; 
            transVal = "قيمة الحركة";
            debtor = "المدين";
            creditor = "دائن";
            unit = "الوحدة";
            totalM="اجمالي الحساب";
            notes = "ملاحظات";
            source = "المصدر";
            contractor = "العميل";
             align = "center";
            style = "text-align:Right";
           inDate = "في تاريخ";
           invoiceNo = "كود الوحده";
           amount ="القيمه المستحقه";
           transactionNo = "رقم الحركة";
           invoices = "اﻷقساط";
           transactions = "الحركات";
           total = "أجمالي";
            tit1="ما له";
            tit2="ما تم صرفه";
            Remainingtotal="القيمة الباقيه";
            }
            
            ArrayList<WebBusinessObject> finanTransLst = (ArrayList<WebBusinessObject>) request.getAttribute("finanTransLst");
        %>
        <script  type="text/javascript">
            
            $(document).ready(function () {
                $("#fromDate,#toDate").datepicker({
                   
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
                
                $("#paidImg").click(function(){
              alert("this invoice is paid before");
                  });
            });
            
            $(function () {
                $("#invoices,#transactions").DataTable({
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
                var contractor = $("#contractor option:selected").val();
                document.finanTransaction.action = "<%=context%>/FinancialServlet?op=clientStatOfAcc&fromDate="+fromDate + "&toDate=" + toDate+"&contractor="+contractor;
                document.finanTransaction.submit();

            } 
            
            var divAttachmentTag;
            function openAttachmentDialog(businessObjectId, objectType) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
                    data: {
                        businessObjectId: businessObjectId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "ارفاق مستندات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 480,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divAttachmentTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
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
            
            function showAttachedFiles(businessObjectId) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=viewDocuments',
                    data: {
                        businessObjectId: businessObjectId
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: false,
                                    title: "مشاهدة المستندات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 700,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divAttachmentTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
            
            function openGalleryDialog(businessObjectId) {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getGalleryDialog',
                    data: {
                        businessObjectId: businessObjectId,
                        objectType: 'financials'
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "عرض الصور",
                                    show: "fade",
                                    hide: "explode",
                                    width: 950,
                                    dialogClass: 'no-close',
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            divTag.dialog('destroy').close();
                                        },
                                        Done: function () {
                                            divTag.dialog('destroy').close();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
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
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=finanTrans%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block; margin-left: auto; margin-right: auto;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=fromDate%></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=toDate%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                    
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;" colspan="2">
                            <b><font size=3 color="white"><%=contractor%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle" colspan="2">
                            <div>
                                <%
                                    if (kindsList.size() > 0 && kindsList != null) {
                                %>
                                        <select style="width: 325px;height: 30px; font-weight: bold; font-size: 13px;" id="contractor" name="contractor">
                                            <sw:WBOOptionList displayAttribute="name" valueAttribute="id" wboList="<%=kindsList%>" scrollToValue="<%=contractor1%>"  />
                                        </select>
                                <% } else {%>
                                <select style="width: 100%;height: 30px; font-weight: bold; font-size: 13px;" id="contractor" name="contractor">
                                    <option>لاشئ</option>
                                </select>
                                <%}%>
                            </div>  
                             
                            
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle" colspan="2">
                            <button type="submit" style="width: 30%; height: 90%;color: #27272A; font-size:15; font-weight:bold; margin: 5px;" onclick="JavaScript: submitForm();" class="button"><%=search%><img height="15" src="images/search.gif"/></button>
                           
                        </td>
                      
                    </tr>
                </table>
                <br/>
                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                     <div style="width: 47%; margin-left: auto; margin-right: auto; float: right;">
                     
                <table id="invoices" class="display" id="pathPrice" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th colspan="6"  bgcolor="#FFCC99" class="silver_header" style="font-size: 17px; font-weight: bolder;"><%=invoices%></th>
                        </tr>
                        <tr>
                            <th style="font-weight: bolder;"><%=inDate%></th>
                              <th style="font-weight: bolder;"><%=amount%></th>
                             <th style="font-weight: bolder;"><%=invoiceNo%></th>
                             
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            DecimalFormat df = new DecimalFormat("0.000");
                            double invoiceTotal = 0;
                             if (invoicesList != null) {
                                for (LiteWebBusinessObject invoiceWbo : invoicesList) {
                                    invoiceTotal += "UL".equals(invoiceWbo.getAttribute("total")) ? 0 : (Double.parseDouble((String) invoiceWbo.getAttribute("total")));
                         %>
                        <tr id="row">
                            <td style="">
                                <%=((String) invoiceWbo.getAttribute("inDate")) %>
                            </td>
                            
                            <td style="">
                                <%="UL".equals(invoiceWbo.getAttribute("total")) ? "0.000" : df.format(Double.parseDouble((String) invoiceWbo.getAttribute("total")))%>
                            </td>
                             
                            <td style="">
                                <%=invoiceWbo.getAttribute("businessID")%>
                            </td>
                           
                           
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                    <tfoot>
                        <tr>
                            
                            <th style="font-size: 14px; font-weight: bolder; " ><%=total%></th>
                            <th style="font-size: 14px; font-weight: bolder;"><%=df.format(invoiceTotal)%></th>
                            <th style="font-size: 14px; font-weight: bolder;" colspan="1">&emsp;</th>

                            <input id="invoiceTotal" name="invoiceTotal" type="hidden" value="<%=df.format(invoiceTotal)%>"/></th>
                              
                          
                        </tr>
                    </tfoot>
                </table>
            </div>
            <div style="width: 47%; margin-left: auto; margin-right: auto; float: left;">
                
                      <table id="transactions" class="display" id="pathPrice" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th align="center" bgcolor="#FFCC99" class="silver_header" colspan="3" style="font-size: 17px; font-weight: bolder;"><%=transactions%></th>
                        </tr>
                        <tr>
                            <th style="font-weight: bolder;"><%=inDate%></th>
                            <th style="font-weight: bolder;"><%=amount%></th>
                            <th style="font-weight: bolder;"><%=transactionNo%></th>
                            
                        </tr> 
                    </thead>
                    <tbody>
                        <%
                            double transactionTotal = 0;
                            if (transactionsList != null) {
                                for (WebBusinessObject transactionWbo : transactionsList) {
                                    transactionTotal += Double.parseDouble((String) transactionWbo.getAttribute("transValue"));
                        %>
                        <tr id="row">
                            <td style="">
                                <%=((String) transactionWbo.getAttribute("documentDate")).substring(0, 10)%>
                            </td>
                            
                            <td style="">
                                <%=df.format(Double.parseDouble((String) transactionWbo.getAttribute("transValue")))%>
                            </td>
                            <td style="">
                                <%=transactionWbo.getAttribute("documentNo")%>
                            </td>
                            
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                    <tfoot>
                        <tr>
           
                            <th style="font-size: 14px; font-weight: bolder;"><%=total%></th>
                            <th style="font-size: 14px; font-weight: bolder;"><%=df.format(transactionTotal)%>
                             <input id="transactionTotal" name="transactionTotal" type="hidden" value="<%=df.format(transactionTotal)%>"/></th>
                                        <th>&nbsp;</th>
                        </tr>
                    </tfoot>
                </table>
                                      
            </div>
                                        
                                        <div style="width: 47%; margin-left: auto; margin-right: auto;padding-top: 20px;  ">
                                        
            <table id="totalTr" class="display" id="pathPrice" align="center" dir="<%=dir%>" width="20%" cellpadding="0" cellspacing="0"   >
              
                  <thead>
                      <tr>
                          <th style="font-weight: bolder;font-size: 14px;border:none" class="blueHeaderTD"><%=totalM%></th>
                          <th style="font-weight: bolder;font-size: 14px;background-color: #C3C6C8;border:none"><%=df.format(invoiceTotal-transactionTotal)%></th>
                  
                    </tr>
              </thead>
              
          </table>
         </div>
                </div>        
            </fieldset>
        </form>
    </body>
</html>
