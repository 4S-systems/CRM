<%-- 
    Document   : FinancialTransactionRprt
    Created on : Sep 16, 2018, 3:53:49 PM
    Author     : walid
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            String stat = (String) request.getSession().getAttribute("currentMode");
            String finanTrans, units, search, clients, vUnits,vClients, docNo, docCod, docDate,
                    TransTyp, transVal, debtor, creditor, unit, notes, source, dir, fromDate, toDate;
            if (stat.equals("En")) {
                dir = "LTR";
                fromDate = "From Date";
                toDate = "To Date";
                finanTrans = "Financial Transaction";
                units = "Units";
                search = "Search";
                clients = "Clients";
                vUnits = "View Units";
                vClients = "View Clients";
                docNo = "Document No";
                docCod = "Document Code";
                docDate = "Document Date";
                TransTyp = "Transaction Type";
                transVal = "Transaction Value";
                debtor = "Debtor";
                creditor = "Creditor";
                unit = "Unit";
                notes = "Notes";
                source = "Created By";
                
            } else {
                dir = "RTL";
                fromDate = "من تاريخ";
                toDate = "إلى تاريخ";
                finanTrans = "الحركات المحاسبية";
                units = "الوحدات";
                search = "بحث";
                clients = "العملاء";
                vUnits = "عرض الوحدات";
                vClients = "عرض العملاء";
                docNo = "رقم المستند";
                docCod = "كود المستند";
                docDate = "تاريخ المستند";
                TransTyp = "نوع الحركة";
                transVal = "قيمة الحركة";
                debtor = "المدين";
                creditor = "دائن";
                unit = "الوحدة";
                notes = "ملاحظات";
                source = "المصدر";
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
                
                $('#finanTrans').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[5, 10, -1], [5, 10, "All"]],
                    iDisplayLength: 5,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
                
            function submitForm(){
                var fromDate = $("#fromDate").val();
                var toDate = $("#toDate").val();
                document.finanTransaction.action = "<%=context%>/FinancialServlet?op=FinancialTransactionRprt&fromDate="+fromDate + "&toDate=" + toDate;
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
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle" colspan="2">
                            <button type="submit" onclick="JavaScript: submitForm();" class="button"><%=search%><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                </table>
                <br/>
                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="center" dir= <%=dir%> id="finanTrans" style="width:100%;">
                        <thead>
                            <tr>
                                <th>
                                    <B>
                                        <%=docNo%>
                                    </B>
                                </th>

                                <th>
                                    <B>
                                        <%=docCod%>
                                    </B>
                                </th>

                                <th>
                                    <B>
                                        <%=docDate%>
                                    </B>
                                </th>

                                <th>
                                    <B>
                                        <%=TransTyp%>
                                    </B>
                                </th>

                                <th>
                                    <B>
                                        <%=transVal%>
                                    </B>
                                </th>

                                <th>
                                    <B>
                                        <%=debtor%>
                                    </B>
                                </th>

                                <th>
                                    <B>
                                        <%=creditor%>
                                    </B>
                                </th>
                                
                                <th>
                                    <B>
                                        <%=unit%>
                                    </B>
                                </th>
                                
                                <th>
                                    <B>
                                        <%=notes%>
                                    </B>
                                </th>
                                
                                <th>
                                    <B>
                                        <%=source%>
                                    </B>
                                </th>
                                <th>
                                </th>
                            </tr>
                        </thead>
                        <%
                            if(finanTransLst !=null && finanTransLst.size() != 0){
                        %>
                        <tbody>
                            <% int counter = 1;
                                for (WebBusinessObject finanTransWbo : finanTransLst) {
                            %>
                            <tr>
                                <td style="width: 2%;">
                                    <%=finanTransWbo.getAttribute("documentNo")%>
                                </td>


                                <td>
                                    <%=finanTransWbo.getAttribute("documentCode")%>
                                </td>
                                <td>
                                    <%=finanTransWbo.getAttribute("documentDate").toString().substring(0,10)%>
                                </td>

                                <td>
                                    <%=finanTransWbo.getAttribute("TransTyp")%>
                                </td>

                                <td>
                                    <%=finanTransWbo.getAttribute("transValue")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("madeen")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("clientNm")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("UnitNm")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("note")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("createdByNm")%>
                                </td>
                                
                                <td>
                                    <a href="#">
                                        <img style="height:20px;" class="attach-icon" title="Attach File" onclick="JavaScript: openAttachmentDialog(<%=finanTransWbo.getAttribute("id")%>, 'financials');"/>
                                    </a>
                                    <a href="#">
                                        <img style="height:20px;" class="view-file-icon" title="View Files" onclick="JavaScript: showAttachedFiles(<%=finanTransWbo.getAttribute("id")%>);"/>
                                    </a>
                                    <a href="#">
                                        <img style="height:20px;" class="gallery-view-icon" title="View Gallery" onclick="JavaScript: openGalleryDialog(<%=finanTransWbo.getAttribute("id")%>);"/>
                                    </a>
                                </td>

                            </tr>
                            <%counter++;}}%>
                        </tbody>
                    </table>
                </div>        
            </fieldset>
        </form>
    </body>
</html>
