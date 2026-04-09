<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tracker.db_access.RequestItemsDetailsMgr"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    WebBusinessObject issue = (WebBusinessObject) request.getAttribute("issue");
    WebBusinessObject storeTransactionWbo = (WebBusinessObject) request.getAttribute("storeTransactionWbo");
    WebBusinessObject vendorWbo = (WebBusinessObject) request.getAttribute("vendorWbo");
    WebBusinessObject issueProject = (WebBusinessObject) request.getAttribute("issueProject");
    WebBusinessObject requestedBy = (WebBusinessObject) request.getAttribute("requestedBy");
    WebBusinessObject department = (WebBusinessObject) request.getAttribute("department");
    ArrayList<WebBusinessObject> transactionDetails = new ArrayList<>((List<WebBusinessObject>) request.getAttribute("transactionDetails"));
    ArrayList<WebBusinessObject> storesList = (ArrayList<WebBusinessObject>) request.getAttribute("storesList");
    String issueID = (String) request.getAttribute("issueID");
    Map<String, String> typesMap = new HashMap<>();
    typesMap.put("1", "عام");
    typesMap.put("2", "أمر تشغيل");
    typesMap.put("3", "أمر شغل صيانة");
    typesMap.put("3", "مشروع");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, dir, delivered, canceled, closeButton;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Store Transaction No. ";
        delivered = "Delivered";
        canceled = "Cancel Procurement";
        closeButton = "Close";
    } else {
        dir = "RTL";
        title = "حركة مخزنية رقم ";
        delivered = "تم الأستلام";
        canceled = "ألغاء الشراء";
        closeButton = "أنهاء";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <style>
            button.btnSave {
                width: 20%;
                margin: 5px;
                height: 15%;
                font-size: large;
                font-family: serif;
            }
            select.workItemsSelect {
                width: 85px;
                height: inherit;
                font-size: 15px;
            }
            .toolBox {
                width:45px;
                height: 40px;
                float:right;
                margin: 0px;
                padding: 0px;
                border: 1px solid black;
            }
            .toolBox a img {
                width: 40px important;
                height: 40px important;
                float: right;
                margin: 0px;
                padding: 0px;
                text-align: right;
            }
        </style>
        <script>
            function save(nextStatus) {
                if (nextStatus === '<%=CRMConstants.SPARE_ITEM_DELIVERED%>') {
                    var items = $('.items:checked');
                    for (i = 0; i < items.length; i++) {
                        if ($("#quantity" + items[i].value).val() === '') {
                            alert("يجب أدخال الكمية ...");
                            $("#quantity" + items[i].value).focus();
                            return;
                        }
                        if ($("#price" + items[i].value).val() === '') {
                            alert("يجب أدخال السعر ...");
                            $("#price" + items[i].value).focus();
                            return;
                        }
                        if ($("#storeID" + items[i].value).val() === '') {
                            alert("يجب أختيار المخزن ...");
                            $("#storeID" + items[i].value).focus();
                            return;
                        }
                    }
                }
                if ($('.items:checked').length === 0) {
                    alert("يجب أختيار صنف واحد علي الأقل ...");
                    return;
                } else {
                    document.ITEM_FORM.action = "<%=context%>/SpareItemServlet?op=getUpdateTransDetails&transactionID=<%=storeTransactionWbo.getAttribute("id")%>&nextStatus=" + nextStatus;
                    document.ITEM_FORM.submit();
                }
            }
            var divAttachmentTag;
            function openAttachmentDialog(issueId, objectType) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
                    data: {
                        businessObjectId: issueId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "ارفاق عرض أسعار",
                                    show: "fade",
                                    hide: "explode",
                                    width: 800,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            divAttachmentTag.dialog('close');
                                        },
                                        Done: function () {
                                            divAttachmentTag.dialog('close');
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

            var divGallaryTag;
            function openGallaryDialog(issueId, objectType) {
                divGallaryTag = $("div[name='divGallaryTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getGallaryDialog',
                    data: {
                        businessObjectId: issueId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divGallaryTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "عرض الأسعار",
                                    show: "fade",
                                    hide: "explode",
                                    width: 950,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            divGallaryTag.dialog('close');
                                        },
                                        Done: function () {
                                            divGallaryTag.dialog('close');
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
            function viewDocuments(issueId) {
                var url = '<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=' + issueId + '';
                var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
            function selectAll(obj) {
                $('.items').attr('checked', $(obj).is(':checked'));
            }
            function cancelForm() {
                document.location.href = "<%=context%>/IssueServlet?op=homePage";
            }
        </script>
    </head>
    <body>
        <div name="divGallaryTag"></div>
        <div name="divAttachmentTag"></div>
        <form name="ITEM_FORM" id="ITEM_FORM" method="post">
            <input type="hidden" dir="<%=dir%>" name="isMngmntStn" ID="isMngmntStn" size="3" value="isMngmntStn" maxlength="3">
            <div align="left" style="color:blue; margin-left: 7.5%">
                <button type="button" onclick="JavaScript: cancelForm();" class="button"><%=closeButton%><img valign="bottom" src="images/cancel.gif"> </button>
                <button type="button" onclick="JavaScript: save('<%=CRMConstants.SPARE_ITEM_CANCELED%>');" class="button"><%=canceled%> <img height="25" valign="middle" src="images/icons/stop.png"/></button>
                <button type="button" onclick="JavaScript: save('<%=CRMConstants.SPARE_ITEM_DELIVERED%>');" class="button"><%=delivered%> <img height="25" valign="middle" src="images/icons/delivered.png"/></button>
            </div>
            <table  border="0px" dir="<%=dir%>" class="table" style="width:700px;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                <tr>
                    <td class="td" colspan="2" style="text-align: center;">
                        <div class="toolBox" style="padding: 2px 2px 2px 0px;">
                            <a href="#" onclick="JavaScript: openAttachmentDialog('<%=issueID%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>');"
                               title="ألحاق عرض أسعار">
                                <img style="margin: 3px" src="images/icons/attachment.png" width="39" height="39"/>
                            </a>
                        </div>
                        <div class="toolBox" style="padding: 2px 2px 2px 0px; border-right-width: 0px;">
                            <a href="#" onclick="JavaScript: openGallaryDialog('<%=issueID%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>');"
                               title="عروض الأسعار">
                                <img style="margin: 3px" src="images/icons/view-request.png" width="39" height="39"/>
                            </a>
                        </div>
                        <div class="toolBox" style="padding: 2px 2px 2px 0px; border-right-width: 0px;">
                            <a href="#" onclick="JavaScript: viewDocuments('<%=issueID%>');" title="عرض المرفقات">
                                <img style="margin: 3px" src="images/Foldericon.png" width="39" height="39"/>
                            </a>
                        </div>
                    </td>
                </tr>
            </table>
            <br />
            <fieldset class="set" style="width: 85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%> <font color="red"><%=storeTransactionWbo.getAttribute("transactionNo")%></font></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table align="center" dir="rtl" style=" padding-left: .5%; margin-top: 0.5%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black; width: 170px;" class="excelentCell formInputTag">
                            <p><b>رقم طلب الشراء</b>&nbsp;
                        </td>
                        <td style="text-align: right; width: 150px;" class='td' colspan="3">
                            <font color="red"><%=issue.getAttribute("businessID")%></font><font color="blue">/<%=issue.getAttribute("businessIDbyDate")%></font>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black; width: 170px;" class="excelentCell formInputTag">
                            <p><b>الموظف الطالب</b>&nbsp;
                        </td>
                        <td style="text-align: right; width: 150px;" class='td'>
                            <b><%=requestedBy.getAttribute("fullName")%></b>
                        </td>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black; width: 170px;" class="excelentCell formInputTag">
                            <p><b>الأدارة</b>&nbsp;
                        </td>
                        <td style="text-align: right; width: 150px;" class='td'>
                            <b><%=department != null ? department.getAttribute("projectName") : ""%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black; width: 170px;" class="excelentCell formInputTag">
                            <p><b>نوع الطلب</b>&nbsp;
                        </td>
                        <td style="text-align: right; width: 150px;" class='td'>
                            <b><%=issueProject != null && typesMap.containsKey(issueProject.getAttribute("projectID")) ? typesMap.get(issueProject.getAttribute("projectID")) : ""%></b>
                        </td>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black; width: 170px;" class="excelentCell formInputTag">
                            <p><b>الرقم</b>&nbsp;
                        </td>
                        <td style="text-align: right; width: 150px;" class='td'>
                            <b><%=issueProject != null && issueProject.getAttribute("option2") != null ? issueProject.getAttribute("option2") : ""%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black; width: 170px;" class="excelentCell formInputTag">
                            <p><b>المورد</b>&nbsp;
                        </td>
                        <td style="text-align: right;" class='td' colspan="3">
                            <%=vendorWbo != null ? vendorWbo.getAttribute("name") : ""%>
                        </td>
                    </tr>
                </table>
                <br/>
                <table id="transactionDetails" align="center" dir="rtl" style="width: 85%; padding-left: .5%; margin-top: 0.5%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <td class="blueBorder blueHeaderTD"><input type="checkbox" name="allItems" id="allItems" onchange="JavaScript: selectAll(this);"/></td>
                            <td class="blueBorder blueHeaderTD">الكود</td>
                            <td class="blueBorder blueHeaderTD">الصنف</td>
                            <td class="blueBorder blueHeaderTD">الكمية</td>
                            <td class="blueBorder blueHeaderTD">السعر</td>
                            <td class="blueBorder blueHeaderTD">تعليق</td>
                            <td class="blueBorder blueHeaderTD">المخزن</td>
                            <td class="blueBorder blueHeaderTD">مكان التخزين</td>
                            <td class="blueBorder blueHeaderTD">رقم اللوط</td>
                            <td class="blueBorder blueHeaderTD">الحالة</td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int counter = 0;
                            String bgColorm, note, statusVal, storeID;
                            Map<String, String> statuesesMap = new HashMap<>();
                            statuesesMap.put(CRMConstants.SPARE_ITEM_REQUESTED, "مطلوب");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_UNAVAILABLE, "غير متاح");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_IN_THE_WAY, "في الطريق");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_DELIVERED, "تم الأستلام");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_NEGOTIATED, "تم التفاوض");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_PAID, "تم الدفع");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_PENDING, "في الأنتظار");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_CANCELED, "ملغي");
                            for (WebBusinessObject detail : transactionDetails) {
                                bgColorm = "silver_odd_main";
                                if ((counter % 2) == 1) {
                                    bgColorm = "silver_odd_main";
                                } else {
                                    bgColorm = "silver_even_main";
                                }
                                note = (String) detail.getAttribute("note");
                                if (note == null) {
                                    note = "";
                                }
                                statusVal = detail.getAttribute("currentStatus") != null ? (String) detail.getAttribute("currentStatus") : "";
                                storeID = detail.getAttribute("storeID") != null ? (String) detail.getAttribute("storeID") : "";
                        %>
                        <tr id="row<%=counter%>">
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <input type="checkbox" name="itemID" class="items" value="<%=detail.getAttribute("id")%>"
                                       <%=statusVal.equals(CRMConstants.SPARE_ITEM_PENDING) ? "" : "disabled"%>/>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <b><font size="2" color="#000080" style="text-align: center;"><%=detail.getAttribute("itemCode")%></font></b>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <b><font color="#000080" style="text-align: center;"><%=detail.getAttribute("itemName")%></font></b>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <input type="number" name="quantity<%=detail.getAttribute("id")%>" id="quantity<%=detail.getAttribute("id")%>" value="<%=detail.getAttribute("quantity")%>" style="width: 100px; display: <%=statusVal.equals(CRMConstants.SPARE_ITEM_PENDING) ? "" : "none"%>;"/>
                                <b><font size="2" color="#000080" style="text-align: center; display: <%=statusVal.equals(CRMConstants.SPARE_ITEM_PENDING) ? "none" : ""%>;"><%=detail.getAttribute("quantity")%></font></b>
                                <input type="hidden" name="spare<%=detail.getAttribute("id")%>" value="<%=detail.getAttribute("itemID")%>"/>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <input type="number" name="price<%=detail.getAttribute("id")%>" id="price<%=detail.getAttribute("id")%>" style="width: 100px; display: <%=statusVal.equals(CRMConstants.SPARE_ITEM_PENDING) ? "" : "none"%>;"
                                       value="<%=detail.getAttribute("price") != null ? detail.getAttribute("price") : ""%>"/>
                                <b><font size="2" color="#000080" style="text-align: center; display: <%=statusVal.equals(CRMConstants.SPARE_ITEM_PENDING) ? "none" : ""%>;"><%=detail.getAttribute("price") != null ? detail.getAttribute("price") : ""%></font></b>
                            </td>
                            <td style="text-align: center" bgcolor="#DDDD00" nowrap class="<%=bgColorm%>">
                                <textarea name="note<%=detail.getAttribute("id")%>" id="note<%=detail.getAttribute("id")%>" rows="2" cols="40" style="display: <%=statusVal.equals(CRMConstants.SPARE_ITEM_PENDING) ? "" : "none"%>;"><%=note%></textarea>
                                <b><font size="2" color="#000080" style="text-align: center; display: <%=statusVal.equals(CRMConstants.SPARE_ITEM_PENDING) ? "none" : ""%>;"><%=note%></font></b>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <select name="storeID<%=detail.getAttribute("id")%>" id="storeID<%=detail.getAttribute("id")%>" style="width: 100px;">
                                    <option value="">أختر</option>
                                    <sw:WBOOptionList wboList="<%=storesList%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=storeID%>"/>
                                </select>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <input type="text" name="storePlace<%=detail.getAttribute("id")%>" id="storePlace<%=detail.getAttribute("id")%>" style="width: 100px;"
                                       value="<%=detail.getAttribute("storePlace") != null ? detail.getAttribute("storePlace") : ""%>"/>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <input type="number" name="packageNo<%=detail.getAttribute("id")%>" id="packageNo<%=detail.getAttribute("id")%>" style="width: 100px;"
                                       value="<%=detail.getAttribute("packageNo") != null && !"UL".equals(detail.getAttribute("packageNo")) ? detail.getAttribute("packageNo") : ""%>"/>
                            </td>
                            <td style="text-align: center" bgcolor="#DDDD00" nowrap class="<%=bgColorm%>">
                                <%=statusVal.isEmpty() ? "" : statuesesMap.get(statusVal)%>
                            </td>
                        </tr>
                        <% counter++;
                            }%>

                    </tbody>
                </table>
                <br/>
                <br/>
            </fieldset>
        </form>
    </body>
</html>
