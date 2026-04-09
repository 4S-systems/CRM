<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page  pageEncoding="UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> stageItemsList = (ArrayList<WebBusinessObject>) request.getAttribute("stageItemsList");
        WebBusinessObject stageWbo = (WebBusinessObject) request.getAttribute("stageWbo");
        String stageID = (String) request.getAttribute("stageID");
        String projectID = (String) request.getAttribute("projectID");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String title, align, dir, style, workItemName, workItemCode, quantity, note, backButton, newWorkItems, qunatityMessage,
                delete, deleteConfirmMessage, itemType, notClassified;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            title = "Work Items for Stage ";
            workItemName = "Work Item";
            workItemCode = "Code";
            quantity = "Quantity";
            note = "Note";
            backButton = "Back to List";
            newWorkItems = "Add Work Items";
            qunatityMessage = "Enter Quantity";
            delete = "Delete";
            deleteConfirmMessage = "Delete, Are you sure?";
            itemType = "Work Item Category";
            notClassified = "Not Classified";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            title = "بنود أعمال للمرحلة ";
            workItemName = "بند العمل";
            workItemCode = "الكود";
            quantity = "الكمية";
            note = "ملاحظات";
            backButton = "العودة إلى القائمة";
            newWorkItems = "أضافة بنود أعمال";
            qunatityMessage = "أدخل الكمية";
            delete = "حذف";
            deleteConfirmMessage = "حذف, متأكد؟";
            itemType = "نوع بند العمل";
            notClassified = "غير مصنف";
        }
    %>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#stageItems").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[2, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 2,
                            "visible": false
                        }], "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(2, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111; text-align: <%=dir%>;" colspan="1"><%=itemType%></td> <td class="" style="font-size: 16px; color: #a41111; text-align: <%=dir%>;" colspan="2"> <b style="color: black;">' + group + ' </b> </td> <td class="" style="font-size: 16px; color: #a41111; text-align: <%=dir%>;" colspan="3" >&nbsp;</td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });
            var divTag;
            function openDefaultPrices() {
                divTag = $("#stageItemsForm");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/StageServlet?op=getWorkItems',
                    data: {
                        stageID: $("#stageID").val()
                    },
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "<%=newWorkItems%>",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                'Close': function () {
                                    divTag.dialog("destroy");
                                    divTag.html("");
                                },
                                Save: function () {
                                    saveNewForm();
                                }
                            }
                        }).dialog('open');
                    }
                });
            }
            function saveNewForm() {
                var id;
                var arrayid;
                var allPages = $("#workItems").dataTable().fnGetNodes();
                arrayid = $("input:checked", allPages);
                for (i = 0; i < arrayid.length; i++) {
                    id = arrayid[i].value;
                    if ($("#quantity" + id).val() === "" || parseInt($("#quantity" + id).val()) <= 0) {
                        alert("<%=qunatityMessage%>");
                        $("#quantity" + id).focus();
                        return false;
                    }
                }
                document.WORK_ITEM_FORM.action = "<%=context%>/StageServlet?op=getStageWorkItems&projectID=" + $("#projectID").val() + "&stageID=" + $("#stageID").val();
                document.WORK_ITEM_FORM.submit();
            }
            function backToStages() {
                document.STAGE_ITEM_FORM.action = "<%=context%>/ProjectServlet?op=getProjectsStages&projectID=" + $("#projectID").val();
                document.STAGE_ITEM_FORM.submit();
            }
            function deleteStageItem(id) {
                var r = confirm("<%=deleteConfirmMessage%>");
                if (r) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/StageServlet?op=deleteStageItem",
                        data: {
                            id: id
                        },
                        success: function (jsonString) {
                            var data = $.parseJSON(jsonString);
                            if (data.status === 'Ok') {
                                $("#row" + id).hide(1000, function () {
                                    $("#row" + id).remove();
                                });
                            }
                        }
                    });
                }
            }
        </script>
        <style>
            input{
                text-align: center;
            }
            .toolBox {
                width:55px;
                height: 55px;
                float:<%=align%>;
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
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div id="stageItemsForm"></div>
        <div align="left" STYLE="color:blue; padding-left: 2%; padding-bottom: 10px; padding-top: 10px">
            <button onclick="JavaScript: backToStages();" class="button"><%=backButton%></button>
        </div>
        <table border="0px" dir="<%=dir%>" class="table" style="width:700px;text-align: <%=align%>;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
            <tr>
                <td class="td" colspan="2" style="text-align: center;">
                    <div class="toolBox" style="padding: 2px 2px 2px 0px; border-<%=align%>-width: 1px;">
                        <a href="#" onclick="JavaScript: openDefaultPrices();"><img style="height:45px;" src="images/icons/add.png" title="<%=newWorkItems%>"/></a>
                    </div>
                </td>
            </tr>
        </table>
        <table align="center" width="80%">
            <tr>
                <td class="td">
                    <fieldset align="center" class="set" style="">
                        <table class="blueBorder" dir="RTL" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                            <tr>
                                <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color='white' size="+1"><%=title%> <%=stageWbo != null ? stageWbo.getAttribute("projectName") : ""%></font><br/></td>
                            </tr>
                        </table>
                        <br/>
                        <br/>
                        <form name="STAGE_ITEM_FORM" method="post">
                            <div style="width: 90%; margin-left: auto; margin-right: auto;">
                                <input type="hidden" id="stageID" name="stageID" value="<%=stageID%>"/>
                                <input type="hidden" id="projectID" name="projectID" value="<%=projectID%>"/>
                                <table class="display" id="stageItems" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th align="center" bgcolor="#FFCC99"class="silver_header"><%=workItemName%></th>
                                            <th align="center" bgcolor="#FFCC99"class="silver_header"><%=workItemCode%></th>
                                            <th align="center" bgcolor="#FFCC99"class="silver_header"><%=itemType%></th>
                                            <th align="center" bgcolor="#FFCC99"class="silver_header"><%=quantity%></th>
                                            <th align="center" bgcolor="#FFCC99"class="silver_header"><%=note%></th>
                                            <th align="center" bgcolor="#FFCC99"class="silver_header">&nbsp;</th>
                                            <th align="center" bgcolor="#FFCC99"class="silver_header">&nbsp;</th>
                                        </tr> 
                                    </thead>
                                    <tbody>
                                        <%
                                            if (stageItemsList != null) {
                                                String workItemCodeVal, workItemNameVal, quantityVal, noteVal, itemTypeVal;
                                                for (WebBusinessObject wbo : stageItemsList) {
                                                    workItemCodeVal = (String) wbo.getAttribute("workItemCode");
                                                    workItemNameVal = (String) wbo.getAttribute("workItemName");
                                                    quantityVal = (String) wbo.getAttribute("quantity");
                                                    noteVal = wbo.getAttribute("note") != null ? (String) wbo.getAttribute("note") : "";
                                                    itemTypeVal = wbo.getAttribute("categoryName") != null ? (String) wbo.getAttribute("categoryName") : notClassified;
                                        %>
                                        <tr id="row<%=wbo.getAttribute("id")%>">
                                            <td class="blueBorder blueBodyTD" style="<%=style%>; padding-<%=align%>: 5px; font-size: 12px">
                                                <%=workItemCodeVal%>
                                            </td>
                                            <td>
                                                <%=workItemNameVal%>
                                            </td>
                                            <td>
                                                <%=itemTypeVal%>
                                            </td>
                                            <td class="blueBorder blueBodyTD" style="<%=style%>; padding-<%=align%>: 5px; font-size: 12px">
                                                <%=quantityVal%>
                                            </td>
                                            <td class="blueBorder blueBodyTD" style="<%=style%>; padding-<%=align%>: 5px; font-size: 12px">
                                                <%=noteVal%>
                                            </td>
                                            <td class="blueBorder blueBodyTD" style="<%=style%>; padding-<%=align%>: 5px; font-size: 12px">
                                                <a href="#" onclick="JavaScript: deleteStageItem('<%=wbo.getAttribute("id")%>');"><%=delete%></a>
                                            </td>
                                            <td class="blueBorder blueBodyTD" style="font-size: 12px">
                                                <img src="images/icons/done.png" style="width: 20px; display: <%="done".equals(wbo.getAttribute("status")) ? "" : "none"%>;"/>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </form>
                        <br/>
                        <br/>
                    </fieldset>
                </td>
            </tr>
        </table>
    </body>
</html>