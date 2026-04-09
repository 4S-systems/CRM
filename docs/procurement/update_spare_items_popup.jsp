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
    WebBusinessObject issueProject = (WebBusinessObject) request.getAttribute("issueProject");
    WebBusinessObject requestedBy = (WebBusinessObject) request.getAttribute("requestedBy");
    WebBusinessObject department = (WebBusinessObject) request.getAttribute("department");
    ArrayList<WebBusinessObject> requestedItems = new ArrayList<>((List<WebBusinessObject>) request.getAttribute("requestedItems"));
    ArrayList<WebBusinessObject> contractorsList = (ArrayList<WebBusinessObject>) request.getAttribute("contractorsList");
    String issueID = (String) request.getAttribute("issueID");
    Map<String, String> typesMap = new HashMap<>();
    typesMap.put("1", "عام");
    typesMap.put("2", "أمر تشغيل");
    typesMap.put("3", "أمر شغل صيانة");
    typesMap.put("3", "مشروع");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, dir, unavailable, negotiated, closeButton;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Rating Items for Procurement Request ";
        unavailable = "Unavailable";
        negotiated = "Negotiated";
        closeButton = "Close";
    } else {
        dir = "RTL";
        title = "تقييم الأصناف لطلب الشراء رقم ";
        unavailable = "غير متاح";
        negotiated = "تم التفاوض";
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
                if (nextStatus === '<%=CRMConstants.SPARE_ITEM_NEGOTIATED%>') {
                    if (!validateData("req", document.ITEM_FORM.vendorID, "من فضلك اختر المورد...")) {
                        $("#vendorID").focus();
                        return;
                    } else if (!validateData("req", document.ITEM_FORM.paymentType, "من فضلك اختر طريقة الدفع...")) {
                        $("#paymentType").focus();
                        return;
                    }
                    var items = $('.items:checked');
                    for (i = 0; i < items.length; i++) {
                        if ($("#price" + items[i].value).val() === '') {
                            alert("يجب أدخال السعر ...");
                            $("#price" + items[i].value).focus();
                            return;
                        }
                    }
                }
                if ($('.items:checked').length === 0) {
                    alert("يجب أختيار صنف واحد علي الأقل ...");
                } else {
                    document.ITEM_FORM.action = "<%=context%>/SpareItemServlet?op=getUpdateItemsPopup&issueID=<%=issueID%>&nextStatus=" + nextStatus;
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
                <button type="button" onclick="JavaScript: save('<%=CRMConstants.SPARE_ITEM_UNAVAILABLE%>');" class="button"><%=unavailable%> <img height="25" valign="middle" src="images/icons/stop.png"/></button>
                <button type="button" onclick="JavaScript: save('<%=CRMConstants.SPARE_ITEM_NEGOTIATED%>');
                        return false;" class="button"><%=negotiated%> <img height="30" valign="middle" src="images/icons/negotiation.png"/></button>
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
                            <font color="#005599" size="4"><%=title%> <font color="red"><%=issue.getAttribute("businessID")%></font><font color="blue">/<%=issue.getAttribute("businessIDbyDate")%></font></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table align="center" dir="rtl" style=" padding-left: .5%; margin-top: 0.5%" cellpadding="0" cellspacing="0">
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
                            <select name="vendorID" id="vendorID" style="width: 250px;">
                                <option value="">أختر</option>
                                <sw:WBOOptionList wboList="<%=contractorsList%>" displayAttribute="name" valueAttribute="id"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black; width: 170px;" class="excelentCell formInputTag">
                            <p><b>طريقة الدفع</b>&nbsp;
                        </td>
                        <td style="text-align: right;" class='td' colspan="3">
                            <select name="paymentType" id="paymentType" style="width: 250px;">
                                <option value="">أختر</option>
                                <option value="1">دفع مباشر</option>
                                <option value="2">دفع أجل</option>
                            </select>
                        </td>
                    </tr>
                </table>
                <br/>
                <table id="requestedItems" align="center" dir="rtl" style="width: 85%; padding-left: .5%; margin-top: 0.5%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <td class="blueBorder blueHeaderTD"><input type="checkbox" name="allItems" id="allItems" onchange="JavaScript: selectAll(this);"/></td>
                            <td class="blueBorder blueHeaderTD">الكود</td>
                            <td class="blueBorder blueHeaderTD">الصنف</td>
                            <td class="blueBorder blueHeaderTD">الكمية</td>
                            <td class="blueBorder blueHeaderTD">السعر</td>
                            <td class="blueBorder blueHeaderTD">تعليق</td>
                            <td class="blueBorder blueHeaderTD">الحالة</td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int counter = 0;
                            String bgColorm, note, statusVal;
                            Map<String, String> statuesesMap = new HashMap<>();
                            statuesesMap.put(CRMConstants.SPARE_ITEM_REQUESTED, "مطلوب");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_UNAVAILABLE, "غير متاح");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_IN_THE_WAY, "في الطريق");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_DELIVERED, "تم الأستلام");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_NEGOTIATED, "تم التفاوض");
                            statuesesMap.put(CRMConstants.SPARE_ITEM_PAID, "تم الدفع");
                            for (WebBusinessObject requestedItem : requestedItems) {
                                bgColorm = "silver_odd_main";
                                if ((counter % 2) == 1) {
                                    bgColorm = "silver_odd_main";
                                } else {
                                    bgColorm = "silver_even_main";
                                }
                                note = (String) requestedItem.getAttribute("note");
                                if (note == null) {
                                    note = "";
                                }
                                statusVal = requestedItem.getAttribute("option3") != null ? (String) requestedItem.getAttribute("option3") : "";
                        %>
                        <tr id="row<%=counter%>">
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <input type="checkbox" name="itemID" class="items" value="<%=requestedItem.getAttribute("id")%>"
                                       <%=statusVal.equals(CRMConstants.SPARE_ITEM_REQUESTED) ? "" : "disabled"%>/>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <b><font size="2" color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("itemCode")%></font></b>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <b><font color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("itemName")%></font></b>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <b><font color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("quantity")%></font></b>
                                <input type="hidden" name="quantity<%=requestedItem.getAttribute("id")%>" value="<%=requestedItem.getAttribute("quantity")%>"/>
                                <input type="hidden" name="spare<%=requestedItem.getAttribute("id")%>" value="<%=requestedItem.getAttribute("projectId")%>"/>
                            </td>
                            <td style="text-align:center; color:black; font-size:14px; height: 25px" class="<%=bgColorm%>">
                                <input type="number" name="price<%=requestedItem.getAttribute("id")%>" id="price<%=requestedItem.getAttribute("id")%>" style="width: 100px;"
                                       value="<%=requestedItem.getAttribute("option4") != null && !"UL".equals(requestedItem.getAttribute("option4")) ? requestedItem.getAttribute("option4") : ""%>"/>
                            </td>
                            <td style="text-align: center" bgcolor="#DDDD00" nowrap class="<%=bgColorm%>">
                                <textarea name="note<%=requestedItem.getAttribute("id")%>" id="note<%=requestedItem.getAttribute("id")%>" rows="2" cols="40"><%=note%></textarea>
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
