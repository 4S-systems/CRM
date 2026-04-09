<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Campaigns.Campaigns"  />
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE></TITLE>
        
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
    </HEAD>
    
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] shippingMfstAttributes = {"campaignTitle", "fromDate", "toDate", "cost", "objective"};
        String[] shippingMfstTitles = new String[10];
        
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String toDate = sdf.format(c.getTime());
        if (request.getAttribute("toDate") != null) {
            toDate = (String) request.getAttribute("toDate");
        }
        c.add(Calendar.MONTH, -1);
        String fromDate = sdf.format(c.getTime());
        if (request.getAttribute("fromDate") != null) {
            fromDate = (String) request.getAttribute("fromDate");
        }
        String statusID = "";
        if (request.getAttribute("statusID") != null) {
            statusID = (String) request.getAttribute("statusID");
        }
        String departmentID = "";
        if (request.getAttribute("departmentID") != null) {
            departmentID = (String) request.getAttribute("departmentID");
        }
        String checkVal = "";
        if (request.getAttribute("mainOnly") != null) {
            checkVal = (String) request.getAttribute("mainOnly");
        }
        
        int s = shippingMfstAttributes.length;
        int t = s + 6;
        int iTotal = 0;
        int totalCost = 0;

        String attName = null;
        String attValue = null;

        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        HashMap<String, ArrayList> campaignToolsList = (HashMap<String, ArrayList>) request.getAttribute("campaignToolsList");
        HashMap<String, Integer> campaignClientsList = (HashMap<String, Integer>) request.getAttribute("campaignClientsList");
        ArrayList<WebBusinessObject> statusesList = (ArrayList<WebBusinessObject>) request.getAttribute("statusesList");
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");

        int flipper = 0;
        String bgColor = null;

        String stat = (String) request.getSession().getAttribute("currentMode");
        
        String deleteMsg,align,reason,notes,dir, fromDateStr, toDateStr, crtnDate, shw, status, all, department, mainOnly;
        if (stat.equals("En")) {
            shippingMfstTitles[0] = "Campaign Code";
            shippingMfstTitles[1] = "From Date";
            shippingMfstTitles[2] = "To Date";
            shippingMfstTitles[3] = "Approximate Cost";
            shippingMfstTitles[4] = "Calls Targeted";
            shippingMfstTitles[5] = "Clients";
            shippingMfstTitles[6] = "View";
            shippingMfstTitles[7] = "Delete";
            shippingMfstTitles[8] = "Status";
            shippingMfstTitles[9] = "";
           deleteMsg = "Delete Campaign, Are you sure?";
           align="left";
           reason="Reason";
           notes="Notes";
           dir="ltr";
           
           fromDateStr = "From Date";
           toDateStr = "To Date";
           crtnDate = " Campaign Creation Date ";
           shw = " Show ";
           status = "Status";
           all = "All";
           department = "Department";
           mainOnly = "Main Only";
        } else {
            shippingMfstTitles[0] = "كود الحملة";
            shippingMfstTitles[1] = "من تاريخ";
            shippingMfstTitles[2] = "ألي تاريخ";
            shippingMfstTitles[3] = "التكلفة التقريبية";
            shippingMfstTitles[4] = "المكالمات المستهدفة";
            shippingMfstTitles[5] = "العملاء";
            shippingMfstTitles[6] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            shippingMfstTitles[7] = "&#1581;&#1584;&#1601;";
            shippingMfstTitles[8] = "الحالة";
            shippingMfstTitles[9] = "";
            deleteMsg = "حذف الحملة. متأكد؟";
           align="right";
            reason="السبب";
           notes="ملاحظات";
           dir="rtl";
           
           fromDateStr = "من تاريخ";
           toDateStr = "إلي تاريخ";
           crtnDate = "تاريخ إدخال الحملة ";
           shw = " إعرض ";
           status = "الحالة";
           all = "الكل";
           department = "الأدارة";
           mainOnly = "الرئيسية فقط";
        }
    %>
    <STYLE>
        .ui-dialog .ui-dialog-buttonpane { 
            text-align: center;
        }
    
        .ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset { 
            float: none;
        }
        
        .ui-dialog-title{
            text-align: center;
        }
    </style>
    
    <script language="javascript" type="text/javascript">
        
        function deleteCamp(campID){
            $.ajax({
                type: "post",
                url: "<%=context%>/CampaignServlet?op=deleteMainCampaign",
                data: {
                    campID: campID
                }, success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        alert("Campaign Has Been Deleted.");
                        location.reload();
                    } else if (info.status == 'faild') {
                        alert("Campaign Not Deleted.");
                        location.reload();
                    } else if (info.status == 'cannot') {
                        alert("You Can't Delete This Campaign It Has Sub Campaigns Delete Them First.");
                        location.reload();
                    }
                    else{
                    }
                }
            });
            console.log(campID);
        }
        
        $(document).ready(function(){
            $("#fromDate, #toDate").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy-mm-dd'
            });
            $('#campaigns').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": false

                }).fadeIn(2000);
        });
        
        var status_id;
        var status_oldStatus;
        var status_newStatus;
        var status_type;
        
       function back(url){
            document.CAMPAIGN_FORM.action = url;
            document.CAMPAIGN_FORM.submit();
        }
        
        function confirmDelete(id) {
            var r = confirm("<%=deleteMsg%>");
            if (r == true) {
                window.location.replace('<%=context%>/CampaignServlet?op=deleteCampaign&id=' + id);
            }
        }
        
        function changeStatus2(id, oldStatus, newStatus, type){
            $.ajax({
                type: "post",
                url: "<%=context%>/CampaignServlet?op=changeCampaignStatusByAjax",
                data: {
                    id: id,
                    oldStatus : oldStatus,
                    newStatus : newStatus,
                }, success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        alert("تم تغيير الحالة");
                        /*$("#change_status_result_dialog").dialog("open");
                        $("#dialog_msg").text("تم تغيير الحالة");*/
                        $("#currentStatus" + id).html(info.currentStatusName);
                        if (type == 'active') {
                            $("#active" + id).attr("disabled", "disabled");
                            $("#onhold" + id).removeAttr("disabled");
                            $("#cancel" + id).attr("disabled", "disabled");
                            $("#finish" + id).removeAttr("disabled");
                        } else if (type == 'onhold') {
                            $("#active" + id).removeAttr("disabled");
                            $("#onhold" + id).attr("disabled", "disabled");
                            $("#cancel" + id).removeAttr("disabled");
                            $("#finish" + id).attr("disabled", "disabled");
                        } else if (type == 'cancel' || type == 'finish') {
                            $("#active" + id).attr("disabled", "disabled");
                            $("#onhold" + id).attr("disabled", "disabled");
                            $("#cancel" + id).attr("disabled", "disabled");
                            $("#finish" + id).attr("disabled", "disabled");
                        }
                        $("#change_status_dialog").dialog("close");
                    } else if (info.status == 'faild') {
                        /*$("#dialog_msg").text("لم يتم تغيير الحالة");
                        $("#change_status_result_dialog").dialog("open");*/
                        alert("لم يتم تغيير الحالة");
                    } else if (info.status == 'date out of range') {
                        /*$("#dialog_msg").text("Can not activate, out of Campaign's dates");
                        $("#change_status_result_dialog").dialog("open");*/
                        alert("Can not activate, out of Campaign's dates");
                    }
                }
            });
        }
       
        function open_change_status_dialog(id, oldStatus, newStatus, type) {
            status_id=id;
            status_oldStatus=oldStatus;
            status_type=type;
            status_newStatus=newStatus;
            $("#cause_text").val("");
            var change_status_tittle;
            if(newStatus == 16) {
                change_status_tittle="Activate Campaign";
                $("#cause_option_tr").hide();
            } else if(newStatus == 17) {
                change_status_tittle="Hold Campaign";
                $("#cause_option_tr").show();
            } else if(newStatus == 18) {
                change_status_tittle="Finish Campaign";
                $("#cause_option_tr").hide();
            } else if(newStatus == 19) {
                change_status_tittle="Cancel Campaign";
                $("#cause_option_tr").show();
            }
            
            $('#change_status_dialog').dialog('option', 'title', change_status_tittle);
            $("#change_status_dialog").dialog('open');
        }
        
        $(function (){
           // $( "#cause_option" ).selectmenu();
            $("#change_status_result_dialog").dialog({
                autoOpen: false,
                resizable: false,
                height: "auto",
                width: 300,
                modal: true,
                open: function(event, ui) {
                    $(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                }, buttons: {
                    OK : function (){
                        $( this ).dialog( "close" );
                    }
                }
            });
            
            $("#change_status_dialog").dialog({
                autoOpen: false,
                resizable: false,
                height: "auto",
                width: 400,
                modal: true,
                buttons: {
                    Cancle: function() {
                        $( this ).dialog( "close" );
                    }, OK : function (){
                        changestatus();
                    }
                }
            });

            function changestatus(){
                var cause_option_selected;
                if(status_newStatus == 16) {
                    cause_option_selected="";
                } else if(status_newStatus == 17) {
                    cause_option_selected=$("#cause_option").val()+" - ";
                } else if(status_newStatus == 18) {
                    cause_option_selected="";
                } else if(status_newStatus == 19) {
                    cause_option_selected=$("#cause_option").val()+" - ";
                }
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=changeCampaignStatusByAjax",
                    data: {
                        id: status_id,
                        oldStatus : status_oldStatus,
                        newStatus : status_newStatus,
                        notes : cause_option_selected+$("#cause_text").val()
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("تم تغيير الحالة");
                            /*$("#change_status_result_dialog").dialog("open");
                            $("#dialog_msg").text("تم تغيير الحالة");*/
                            $("#currentStatus" + status_id).html(info.currentStatusName);
                            if (status_type == 'active') {
                                $("#active" + status_id).attr("disabled", "disabled");
                                $("#onhold" + status_id).removeAttr("disabled");
                                $("#cancel" + status_id).attr("disabled", "disabled");
                                $("#finish" + status_id).removeAttr("disabled");
                            } else if (status_type == 'onhold') {
                                $("#active" + status_id).removeAttr("disabled");
                                $("#onhold" + status_id).attr("disabled", "disabled");
                                $("#cancel" + status_id).removeAttr("disabled");
                                $("#finish" + status_id).attr("disabled", "disabled");
                            } else if (status_type == 'cancel' || status_type == 'finish') {
                                $("#active" + status_id).attr("disabled", "disabled");
                                $("#onhold" + status_id).attr("disabled", "disabled");
                                $("#cancel" + status_id).attr("disabled", "disabled");
                                $("#finish" + status_id).attr("disabled", "disabled");
                            }
                            $("#change_status_dialog").dialog("close");
                        } else if (info.status == 'faild') {
                            /*$("#dialog_msg").text("لم يتم تغيير الحالة");
                            $("#change_status_result_dialog").dialog("open");*/
                            alert("لم يتم تغيير الحالة");
                        } else if (info.status == 'date out of range') {
                            /*$("#dialog_msg").text("Can not activate, out of Campaign's dates");
                            $("#change_status_result_dialog").dialog("open");*/
                            alert("Can not activate, out of Campaign's dates");
                        }
                    }
                });
            }
        });
        
        function getCampaigns(){
            document.campaignForm.action = "<%=context%>/CampaignServlet?op=listCampaigns";
            document.campaignForm.submit();
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
        
        function openGalleryDialog(businessObjectId, objectType) {
            var divTag = $("<div></div>");
            $.ajax({
                type: "post",
                url: '<%=context%>/FileUploadServlet?op=getGalleryDialog',
                data: {
                    businessObjectId: businessObjectId,
                    objectType: objectType
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
    
     <body>
         <div name="divAttachmentTag"></div>
        <fieldset align=center class="set" style="width: 90%;">
            <legend align="center">
                <table dir=<fmt:message key="direction"/> align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                                 <fmt:message key="campaigns"/> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            
            <form id="campaignForm" name="campaignForm" method="post">
                <table class="blueBorder" align="center" dir="<%=dir%>" style="border-width: 1px; border-color: white; width: 30%;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <b>
                                <font size=3 color="white">
                                     <%=fromDateStr%> 
                            </b>
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <b>
                                <font size=3 color="white">
                                     <%=toDateStr%>
                            </b>
                        </td>
                    </tr>

                    <tr>
                        <td bgcolor="#dedede" valign="middle" width="50%">
                            <input type="text" style="width: 90%;" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? fromDate : request.getAttribute("fromDate")%>" title="<%=crtnDate%>"/>
                        </td>

                        <td bgcolor="#dedede" valign="middle" width="50%">
                            <input type="text" style="width: 90%;" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? toDate : request.getAttribute("toDate")%>" title="<%=crtnDate%>"/>
                        </td>
                    </tr>

                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b>
                                <font size=3 color="white">
                                <%=department%>
                            </b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b>
                                <font size=3 color="white">
                                <%=status%>
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <select id="departmentID" name="departmentID" style="width: 150px;">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                            </select>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <select id="statusID" name="statusID" style="width: 150px;">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList="<%=statusesList%>" displayAttribute="typeNameEn" valueAttribute="statusTypeID" scrollToValue="<%=statusID%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="checkbox" name="mainOnly" id="mainOnly" value="1" <%=checkVal.equals("1") ? "checked" : ""%> /> <%=mainOnly%>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="button" class="button" style="width: 200px;" value="<%=shw%>" onclick="getCampaigns();"/>
                        </td>
                    </tr>
                </table>
            </form>
            
            <TABLE id="campaigns" ALIGN="center" dir="<fmt:message key="direction" />" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-width: 1px;">
                <THEAD>
                    <TR>
                        <TH nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                        </TH>

                        <%
                            String columnColor = new String("");
                            String columnWidth = new String("");
                            String font = new String("");
                            for (int i = 0; i < t - 1; i++) {
                                if (i == 0) {
                                    columnColor = "#9B9B00";
                                } else {
                                    columnColor = "#7EBB00";
                                }
                                if (shippingMfstTitles[i].equalsIgnoreCase("")) {
                                    columnWidth = "1";
                                    columnColor = "black";
                                    font = "1";
                                } else {
                                    columnWidth = "150";
                                    font = "12";
                                }
                        %>
                                <TH nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH: 0; font-size: <%=font%>; white-space: nowrap;" >
                                    <B>
                                         <%=shippingMfstTitles[i]%> 
                                    </B>
                                </TH>
                        <%
                            }
                        %>
                        <TH nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH: 0; font-size: <%=font%>; white-space: nowrap;" >
                        </TH>
                        <th nowrap class="silver_header" width="<%=columnWidth%>" bgcolor="<%=columnColor%>" style="border-width: 0; font-size: <%=font%>; white-space: nowrap;" >
                        </th>
                    </TR>
                </THEAD>
                <TBODY>
                <%
                    if (campaignsList != null) {
                        List<WebBusinessObject> tools;
                        StringBuilder toolsTitle, clientsTitle;
                        String campaignId;
                        int clientsNumber;
                        for (WebBusinessObject wbo : campaignsList) {
                            campaignId = (String) wbo.getAttribute("id");
                            tools = new ArrayList<WebBusinessObject>();
                            toolsTitle = new StringBuilder("Tools");
                            if (campaignsList != null) {
                                tools = campaignToolsList.get(campaignId);

                                if (tools != null) {
                                    for (WebBusinessObject wboTool : tools) {
                                        toolsTitle.append("\n" + (String) wboTool.getAttribute("arabicName"));

                                    }
                                }
                            }
                            clientsTitle = new StringBuilder("Number of Clients: ");
                            clientsNumber = 0;
                            if (campaignClientsList != null) {
                                clientsNumber = campaignClientsList.get(campaignId);
                                clientsTitle.append(clientsNumber);
                            }

                            iTotal++;
                            flipper++;
                            String currentStatus = (String) wbo.getAttribute("currentStatus");
                            if (currentStatus == null) {
                                currentStatus = "";
                            }

                            if ((flipper % 2) == 1) {
                                bgColor = "silver_odd";
                            } else {
                                bgColor = "silver_even";
                            }

                            String permenantColor = "";
                            if (currentStatus.equalsIgnoreCase("20")) {
//                            permenantColor = "#FFFF99";
                            }
                %>
                    <TR title="Creation Time : <%=wbo.getAttribute("creationTime")%> Created By : <%=wbo.getAttribute("fullName")%>">
                        <TD STYLE="text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : "#dfdfdf"%>;" nowrap  CLASS="<%=bgColor%>" >
                            <img src="images/perm_campaign.png" width="20" style="display: <%=(currentStatus.equalsIgnoreCase("20")) ? "" : "none"%>"/>
                        </TD>

                        <%
                            for (int i = 0; i < s; i++) {
                                attName = shippingMfstAttributes[i];
                                String dateAlign = "";
                                attValue = wbo.getAttribute(attName) != null ? (String) wbo.getAttribute(attName) + " " : "";
                                if (i != 0) {
                                    dateAlign = "center";
                                    if (currentStatus.equalsIgnoreCase("20")) {
                                        attValue = "---";
                                    } else {
                                                if(i == 1 || i == 2) {
                                            attValue = sdf.format(sdf.parse((String) wbo.getAttribute(attName)));
                                        }
                                    }
                                }

                        %>
                        <TD STYLE="text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>; text-align: <%=dateAlign%>;" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>" >
                            <DIV  title="<%=campaignId%>">
                                <b>
                                    <%=attValue%> 
                                </b>
                            </DIV>
                        </TD>
                        <%
                            }
                            try {
                                totalCost += Integer.valueOf((String) wbo.getAttribute("cost"));
                            } catch (NumberFormatException nfe) {

                            }
                        %>

                        <%--<TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <img src="images/tools.png" width="30" style="display: <%=(currentStatus.equalsIgnoreCase("20") || tools.isEmpty()) ? "none" : ""%>" title="<%=toolsTitle%>" />
                        </TD>--%>

                        <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <img src="images/users.gif" width="16" style="display: <%=((clientsNumber == 0)) ? "none" : ""%>" title="<%=clientsTitle%>" />
                        </TD>

                        <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <!--<DIV ID="links" style="display: <%=currentStatus.equalsIgnoreCase("20") ? "none" : ""%>">-->
                            <DIV ID="links">
                                <A HREF="<%=context%>/CampaignServlet?op=viewCampaign&id=<%=wbo.getAttribute("id")%>" style="display: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "none" : ""%>">
                                    <%=shippingMfstTitles[6]%> 
                                </A>
                            </DIV>
                            <!--<DIV style="display: <%=currentStatus.equalsIgnoreCase("20") ? "" : "none"%>; text-align: center;">-->
                            <!--<DIV style="display: ''; text-align: center;">
                                 --- 
                            </DIV>-->
                        </TD>

                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <%
                                if (metaMgr.canDelete()) {
                            %>
                                    <!--<DIV ID="links" style="display: <%=currentStatus.equalsIgnoreCase("20") ? "none" : ""%>">-->
                            <DIV ID="links">
                                <A href="JavaScript: confirmDelete('<%=wbo.getAttribute("id")%>');" style="display: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "none" : ""%>">
                                    <%=shippingMfstTitles[7]%> 
                                </A>
                            </DIV>
                            <%
                            } else {
                            %>
                                    <!--<DIV style="display: <%=currentStatus.equalsIgnoreCase("20") ? "" : "none"%>; text-align: center;">
                                         --- 
                                    </DIV>-->

                            <DIV style="display:'non'; text-align: center;">
                                --- 
                            </DIV>
                            <%
                                }
                            %>
                        </TD> 

                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <DIV>
                                <b style="color: blue;" id="currentStatus<%=wbo.getAttribute("id")%>">
                                    <%=wbo.getAttribute("currentStatusName")%> 
                                </b>
                            </DIV>
                        </TD>

                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <input type="button" id="active<%=wbo.getAttribute("id")%>" value="Active" onclick="JavaScript: open_change_status_dialog('<%=wbo.getAttribute("id")%>', '<%=currentStatus%>', '16', 'active')" <%=currentStatus.equalsIgnoreCase("15") || currentStatus.equalsIgnoreCase("17") ? "" : "disabled"%>/>

                            <input type="button" id="onhold<%=wbo.getAttribute("id")%>" value="Onhold" onclick="JavaScript: open_change_status_dialog('<%=wbo.getAttribute("id")%>', '<%=currentStatus%>', '17', 'onhold')" <%=currentStatus.equalsIgnoreCase("16") ? "" : "disabled"%>/>

                            <input type="button" id="cancel<%=wbo.getAttribute("id")%>" value="Cancel" onclick="JavaScript: open_change_status_dialog('<%=wbo.getAttribute("id")%>', '<%=currentStatus%>', '19', 'cancel')" <%=currentStatus.equalsIgnoreCase("15") || currentStatus.equalsIgnoreCase("17") ? "" : "disabled"%>/>

                            <input type="button" id="finish<%=wbo.getAttribute("id")%>" value="Finish" onclick="JavaScript: open_change_status_dialog('<%=wbo.getAttribute("id")%>', '<%=currentStatus%>', '18', 'finish')" <%=currentStatus.equalsIgnoreCase("16") ? "" : "disabled"%>/>
                        </TD>
                        
                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <input type="button" id="delete<%=wbo.getAttribute("id")%>" value="Delete" style="display: <%=clientsNumber != 0 ? "none" : ""%>" onclick="deleteCamp(<%=wbo.getAttribute("id")%>);"/>
                        </TD>
                        <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-right: 10px; text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <%
                                if (!"subcampaign".equals(wbo.getAttribute("campaignType"))) {
                            %>
                            <a href="#"><img style="height:30px;" src="images/attach.png" title="Attach File" onclick="JavaScript: openAttachmentDialog('<%=wbo.getAttribute("id")%>', 'campaign');"/></a>
                            <a href="#"><img style="height:35px;" src="images/gallery.png" title="عرض الصور" onclick="JavaScript: openGalleryDialog('<%=wbo.getAttribute("id")%>', 'campaign');"/></a>
                                <%
                                    }
                                %>
                        </td>
                    </TR>
                <%
                        }
                    }
                %>
                </TBODY>
                <TFOOT>
                    <TR>
                        <th class="silver_footer" bgcolor="#808080" colspan="4" style="text-align : <fmt:message key="textalign"/>;padding-right:5;border-right-width:1;font-size:16;">
                            <b>
                                 <fmt:message key="totalCost" /> 
                            </b>
                        </th>
                        <th class="silver_footer" bgcolor="#808080" colspan="1" STYLE="text-align : <fmt:message key="textalign"/>;padding-left:5;font-size:16;"  >
                            <div>
                                <b>
                                     <%=totalCost%> 
                                </b>
                            </div>
                        </th>
                        <th class="silver_footer" bgcolor="#808080" colspan="2" style="text-align : <fmt:message key="textalign"/>;padding-right:5;border-right-width:1;font-size:16;">
                            &nbsp;
                        </th>
                        <TH CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="4" STYLE="text-align : <fmt:message key="textalign"/>;padding-right:5;border-right-width:1;font-size:16;">
                            <B>
                                 <fmt:message key="campcount" /> 
                            </B>
                        </TH>

                        <TH CLASS="silver_footer" BGCOLOR="#808080" colspan="3" STYLE="text-align : <fmt:message key="textalign"/>;padding-left:5;font-size:16;"  >
                            <DIV NAME="" ID="">
                                <B>
                                     <%=iTotal%> 
                                </B>
                            </DIV>
                        </TH>
                    </TR>
                </TFOOT>
            </TABLE>
                            
            <br />
            <br />
            
        </fieldset>
                            
        <br />
        <br />
        
        <div id="change_status_result_dialog">
            <p id="dialog_msg" align="center">
            </p>
        </div>
        
        <%--<div id="change_status_dialog">
            <TABLE align="center" dir="<%=dir%>"  width="100%">
                <TR id="cause_option_tr" style="height:  50px">
                    <TD style="border: none">
                        <label for="cause_option" id="cause_option_lbl"align="center" >
                             <%=reason%> 
                        </label>
                    </TD>
                    
                    <TD style="border: none">
                        <select  name="cause_option" id="cause_option" style="width: 85% ;" align="<%=align%>">
                            <option>poor turn out</option>
                            <option selected="selected">no available funds</option>
                            <option>provider commitment</option>
                            <option>Other</option>
                        </select>
                    </TD>
                </TR>
                
                <TR>
                    <TD style="border: none">
                        <label for="cause_text" align="center">
                             <%=notes%> 
                        </label>
                    </TD>
                    
                    <TD style="border: none">
                        <textarea  name="cause_text" id="cause_text" rows="5" cols="30" align="<%=align%>"></textarea>
                    </TD>
                </TR>
            </TABLE> 
        </div>--%>
    </body>
</html>