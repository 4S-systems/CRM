<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String clientId = CRMConstants.COMPANY_CLIENT_ID;
            String status = (String) request.getAttribute("status");
            String message = (String) request.getAttribute("message");
            Calendar calendar = Calendar.getInstance();
            String jDateFormat = "yyyy/MM/dd";
            SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
            String now = sdf.format(calendar.getTime());
            
            String busID = request.getAttribute("busID") != null ? (String) request.getAttribute("busID") : "";
            
            ArrayList<WebBusinessObject> sprLst = request.getAttribute("sprLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("sprLst") : null;
        %>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <title>JSP Page</title>
        <script type="text/javascript">
            $(function () {
                $("#deliveryDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    buttonImageOnly: true,
                    buttonText: "Select date"
                });
            });
            function saveComment(accepted) {
                if (!validateData("req", document.PROCUREMENT_FORM.requestType, "من فضلك اختر النوع...")) {
                    $("#requestType").focus();
                } else if ($("#requestType").val() !== '1' && $("#requestCode").val() === '') {
                    alert("يجب أدخال الكود ...");
                    $("#requestCode").focus();
                } else if ($("#requestType").val() !== '1' && !validateData("num", document.PROCUREMENT_FORM.requestCode, "من فضلك أدخل رقم صحيح ...")) {
                    $("#requestCode").focus();
                } else if (document.getElementById('row0') === null) {
                    alert("يجب اختيار صنف واحد على الأقل...");
                    $("#btnRequestItems").click();
                } else {
                    document.PROCUREMENT_FORM.action = "<%=context%>/SpareItemServlet?op=saveProcurement&clientId=<%=clientId%>&clientComplaintType=<%=CRMConstants.CLIENT_COMPLAINT_TYPE_PROCUREMENT%>&note=internal&callType=internal&accepted=" + accepted;
                    document.PROCUREMENT_FORM.submit();
                }
            }
            function openRequestItemsDailog() {
                var divTag = $("<div></div>");
                var ids = "";
                $("input[name='requestedItemId']").each(function () {
                    ids += "," + this.value;
                });
                $.ajax({
                    type: "post",
                    url: '<%=context%>/SpareItemServlet?op=listSpareItems',
                    data: {
                        ids: ids
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "أضافة صنف",
                                    show: "fade",
                                    hide: "explode",
                                    width: 500,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            $(this).dialog('destroy').dialog('close');
                                        },
                                        Done: function () {
                                            var itemId, itemCode, itemName, className;
                                            var counter = $('#numberOfRequestedItems').val();
                                            $(this).find(':checkbox:checked').each(function () {
                                                itemId = $(divTag.html()).find('#itemId' + this.value).val();
                                                itemCode = $(divTag.html()).find('#itemCode' + this.value).val();
                                                itemName = $(divTag.html()).find('#itemName' + this.value).val();
                                                if (counter % 2 === 1) {
                                                    className = "silver_odd_main";
                                                } else {
                                                    className = "silver_even_main";
                                                }
                                                $('#requestedItems > tbody:last').append("<TR id=\"row" + counter + "\"></TR>");
                                                $('#row' + counter).append("<TD width=\"8%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><b><font size=\"2\" color=\"#000080\" style=\"text-align: center;\">" + itemCode + "</font></b></TD>")
                                                        .append("<TD width=\"35%\" class=\"silver_footer\" bgcolor=\"#808000\" STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\">" + itemName + "</font></b></TD>")
                                                        .append("<TD width=\"11%\" STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><input type=\"hidden\" id=\"requestedItemId" + counter + "\" name=\"requestedItemId\" value=\"" + itemId + "\"/><input type=\"hidden\" id=\"id" + counter + "\" name=\"id\" /><input type=\"text\" id=\"quantity" + counter + "\" name=\"quantity\" value=\"1\" style=\"text-align: center; width: 100%\"/></TD>");
                                                counter++;
                                            }
                                            );
                                            $('#numberOfRequestedItems').val(counter);
                                            $(this).dialog('destroy').dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    }
                });
            }
            function removeRow(rowNo) {
                $("#row" + rowNo).remove();
                var counter = $('#numberOfRequestedItems').val();
                for (var i = rowNo; i < counter; i++) {
                    $("#row" + i).attr("id", "row" + (i - 1));
                    $("#requestedItemId" + i).attr("id", "requestedItemId" + (i - 1));
                    $("#id" + i).attr("id", "id" + (i - 1));
                    $("#quantity" + i).attr("id", "quantity" + (i - 1));
                    $("#valid" + i).attr("id", "valid" + (i - 1));
                    $("#requestedItemNote" + i).attr("id", "requestedItemNote" + (i - 1));
                    $("#remove" + i).attr('onclick', 'JavaScript: removeRow("' + (i - 1) + '")');
                    $("#remove" + i).attr("id", "remove" + (i - 1));
                }
                $('#numberOfRequestedItems').val(--counter);
            }
            function clearUnitName() {
                $("#unitNo").val('');
            }
            function loading(val) {
                if (val === "none") {
                    $('#loading').fadeOut(2000, function () {
                        $('#loading').css("display", val);
                    });
                } else {
                    $('#loading').fadeIn("fast", function () {
                        $('#loading').css("display", val);
                    });
                }
            }
        </script>

        <style type="text/css">  
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            input.button-remove {
                background-image: url(images/icons/remove.png); /* 32px x 32px */
                background-color: transparent; /* make the button transparent */
                background-repeat: no-repeat;  /* make the background image appear only once */
                background-position: 0px 0px;  /* equivalent to 'top left' */
                background-size: 27px 27px;
                border: none;           /* assuming we don't want any borders */
                cursor: pointer;        /* make the cursor like hovering over an <a> element */
                height: 27px;           /* make this the size of your image */
                padding-left: 27px;     /* make text start to the right of the image */
                vertical-align: middle; /* align the text vertically centered */
            }
        </style>
    </head>
    <body>
        <div></div>
        <fieldset class="set" style="width:95%;border-color: #006699">
            <div align="left" style="color:blue; margin-left: 2.5%">
                <button type="button" onclick="saveComment('yes');" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">حفظ&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18" /></button>
            </div>
            <br/>
            <br/>
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td class="titlebar" style="text-align: center">
                        <font color="#005599" size="4">طلب شراء</font>&nbsp;<img width="40" height="40" src="images/icons/procurement.png" style="vertical-align: middle;"/> 
                    </td>
                </tr>
            </table>
            <form name="PROCUREMENT_FORM" method="post">
                <%if (status != null && status.equals("OK")) {%>
                <br>
                <table align="center" dir="ltr" WIDTH="70%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="blue">تم الحفظ بنجاح</font>
                        </td>
                    </tr>
                </table>
                <%} else if (status != null && status.equals("Failed")) {%>
                <br>
                <table align="center" dir="ltr" WIDTH="70%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="red">لم يتم الحفظ</font>
                        </td>
                    </tr>
                </table>
                <%}%>
                <% if (message != null) {%>
                <br>
                <table align="center" dir="ltr" WIDTH="70%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="red"><%=message%></font>
                        </td>
                    </tr>
                </table>
                <% }%>
                <br>
                <div style="float: right; width: 39%">
                    <table id="" class="excelentCell" align="RIGHT" dir="rtl" width="100%" CELLPADDING="0" CELLSPACING="0" style="margin-right: 5px; margin-bottom: 5px">
                        <thead>
                            <tr>
                                <td style="font-size: 16px; font-weight: bold; border-width: 0px; padding-bottom: 3px; padding-top: 3px"><font color="#005599">المعلومات الأساسية</font></td>
                            </tr>
                        </thead>
                    </table>
                    <table class="excelentCell" width="100%" cellpadding="0" cellspacing="8" align="right" dir="rtl" style="margin-right: 5px; margin-bottom: 5px">
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">التاريخ :</font>
                            </td>
                            <td style="border: none;text-align: right">
                                <input id="deliveryDate" readonly name="deliveryDate" type="text" style="width: 150px;" value="<%=now%>" />                 
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">النوع :</font>
                            </td>
                            <td style="border: none;text-align: right">
                                <select name="requestType" id="requestType" style="width: 150px;">
                                    <option value="">أختر</option>
                                    <option value="1">عام</option>
                                    <option value="2">أمر تشغيل</option>
                                    <option value="3">أمر شغل صيانة</option>
                                    <option value="4">مشروع</option>
                                </select>                 
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">الكود :</font>
                            </td>
                            <td style="border: none;text-align: right">
                                <input id="requestCode" name="requestCode" type="number" style="width: 150px;" value="<%=busID%>"/>                 
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:Right; padding-right: 5px; border: none;" class="blueBorder blueHeaderTD">
                                <font color="black" size="3">ملاحظات :</font>
                            </td>
                            <td style="border: none;text-align: right">
                                <textarea id="notes" name="notes" style="width: 150px;" rows="5"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <table id="" class="excelentCell" align="left" dir="rtl" width="59%" CELLPADDING="0" CELLSPACING="0" style="margin-left: 5px; margin-bottom: 5px">
                    <thead>
                        <tr>
                            <td style="font-size: 16px; font-weight: bold; border-width: 0px; padding-bottom: 3px; padding-top: 3px"><font color="#005599">الأصناف المطلوبة</font></td>
                        </tr>
                    </thead>
                </table>
                <%if(sprLst == null){%>
                    <button type="button" id="btnRequestItems" onclick="openRequestItemsDailog();" style="float: left; width: 150px; margin-bottom: 5px; margin-left: 4px;">أضافة أصناف&ensp;<img src="images/icons/add_item.png" alt="" height="18" width="18" /></button>
                <%}%>    
                <table id="requestedItems" class="excelentCell" align="left" dir="rtl" width="59%" CELLPADDING="0" CELLSPACING="0" style="margin-left: 5px; margin-bottom: 5px">
                    <thead>
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="8%">كود</td>
                            <td class="blueBorder blueHeaderTD" width="35%">الصنف</td>
                            <td class="blueBorder blueHeaderTD" width="11%">كمية</td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int counter = 0;
                            if(sprLst != null && !sprLst.isEmpty()){
                                String className = new String();
                                WebBusinessObject sprWbo = new WebBusinessObject();
                                
                                for(int index=0; index<sprLst.size(); index++){
                                    sprWbo = sprLst.get(index);
                                
                                    if (counter % 2 == 1) {
                                        className = "silver_odd_main";
                                    } else {
                                        className = "silver_even_main";
                                    }
                        %>
                                    <TR id="row<%=counter%>">
                                        <TD width="8%" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=className%>" >
                                            <b>
                                                <font size="2" color="#000080" style="text-align: center;">
                                                     <%=sprWbo.getAttribute("eqNO")%> 
                                                <font>
                                            </b>
                                        </TD>
                                        
                                        <TD width="35%" class="silver_footer" bgcolor="#808000" STYLE="text-align:center; color:black; font-size:14px; height: 25px">
                                            <b>
                                                <font color="#000080" style="text-align: center;">
                                                     <%=sprWbo.getAttribute("projectName")%> 
                                                </font>
                                            </b>
                                        </TD>
                                        
                                        <TD width="11%" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=className%>">
                                            <input type="hidden" id="requestedItemId<%=counter%>" name="requestedItemId" value="<%=sprWbo.getAttribute("projectID")%>"/>
                                            <input type="hidden" id="id<%=counter%>" name="id"/>
                                            <input type="text" id="quantity<%=counter%>" name="quantity" value="1" style="text-align: center; width: 100%"/>
                                        </TD>
                                    </TR>
                        <%
                                    counter++;
                                }
                            }
                        %>
                    </tbody>
                </table>
                <input type="hidden" id="numberOfRequestedItems" value="<%=counter%>" />
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
            </form>
        </fieldset>
    </body>
</html>
