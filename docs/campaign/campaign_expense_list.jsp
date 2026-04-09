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
        String[] shippingMfstTitles = new String[12];
        ArrayList <Integer> sumEXA=(ArrayList <Integer>) request.getAttribute("sumEXA");
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
        
        int s = shippingMfstAttributes.length;
        int t = s + 8;
        int iTotal = 0;

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
        
        String deleteMsg,align,reason,notes,dir,title, fromDateStr, toDateStr, crtnDate, shw, status, all, department;
        if (stat.equals("En")) {
            shippingMfstTitles[0] = "Campaign Code";
            shippingMfstTitles[1] = "From Date";
            shippingMfstTitles[2] = "To Date";
            shippingMfstTitles[3] = "Estimated Cost";
            shippingMfstTitles[4] = "Targeted Calls";
            shippingMfstTitles[5] = "Actuall Cost";
            shippingMfstTitles[6] = "Clients";
            shippingMfstTitles[7] = "View";
            shippingMfstTitles[8] = "Status";
            shippingMfstTitles[9] ="Expenses";
            shippingMfstTitles[10] ="Add Expenses";
            shippingMfstTitles[11] = "Delete";
            title="Campaigns Expenses";

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
        } else {
            shippingMfstTitles[0] = "كود الحملة";
            shippingMfstTitles[1] = "من تاريخ";
            shippingMfstTitles[2] = "ألي تاريخ";
            shippingMfstTitles[3] = "التكلفة التقريبية";
            shippingMfstTitles[4] = "المكالمات المستهدفة";
            shippingMfstTitles[5] = "التكلفة الفعلية";
            shippingMfstTitles[6] = "العملاء";
            shippingMfstTitles[7] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            shippingMfstTitles[8] = "الحالة";
            shippingMfstTitles[9] ="المصروفات";
            shippingMfstTitles[10] ="اضافه مصروفات";
            shippingMfstTitles[11] = "حذف";
            title="مصروفات الحملات";

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
           .ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {
                float: none;
            }
            .ui-dialog .ui-dialog-title, .ui-dialog .ui-dialog-buttonpane {
                text-align:center;
                padding-left: 0.4em;
                padding-right: 0.4em;
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
                    "bProcessing": true

                }).fadeIn(2000);
        });
        
       
        
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
        function deleteExpense(id) {
            var r = confirm("<fmt:message key="deleteMsg"/>");
                if (r) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/FinancialManagementServlet?op=deleteExpenseAjax",
                        data: {
                            id: id
                        },
                        success: function (jsonString) {
                            var data = $.parseJSON(jsonString);
                            if (data.status === 'ok') {
                                $("#row" + id).hide(1000, function () {
                                    $("#row" + id).remove();
                                });
                            }
                        }
                    });
                }
            }
         function newExpenseForm(id) {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FinancialManagementServlet?op=getNewExpenseCampaignForm',
                    data: {
                        id: id
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: '<fmt:message key="addExpense" />',
                                    show: "blind",
                                    hide: "explode",
                                    width: 500,
                                    closeOnEscape: false,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            $(this).dialog('close').dialog('destroy');
                                        },
                                        Ok: function () {
                                            saveExpense(this);
                                        }
                                    }

                                })
                                .dialog('open');
                    }
                });
            }
            
            
            function saveExpense(obj) {
                if ($("#companyID").val() === '') {
                    alert("<fmt:message key="companyRequiredMsg" />");
                    $("#companyID").focus();
                } else if ($("#expenseDate").val() === '') {
                    alert("<fmt:message key="expenseDateRequiredMsg" />");
                    $("#expenseDate").focus();
                } else if ($("#currencyType").val() === '') {
                    alert("<fmt:message key="currencyTypeRequiredMsg" />");
                    $("#currencyType").focus();
                } else if ($("#paidAmount").val() === '') {
                    alert("<fmt:message key="paidAmountRequiredMsg" />");
                    $("#paidAmount").focus();
                } else if ($("#exchangeRate").val() === '') {
                    alert("<fmt:message key="exchangeRateRequiredMsg" />");
                    $("#exchangeRate").focus();
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/FinancialManagementServlet?op=saveNewExpenseAjax",
                        data: $("#expense_form").serialize(),
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                alert("<fmt:message key="successMsg" />");
                                $(obj).dialog('close').dialog('destroy');
                            } else {
                                alert("<fmt:message key="failMsg" />");
                            }
                        }
                    });
                }
            }
           
          function openExpensesList(channelID) {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FinancialManagementServlet?op=getChannelExpenses',
                    data: {
                        channelID: channelID
                    },
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: name,
                            show: "blind",
                            hide: "explode",
                            width: 700,
                            closeOnEscape: false,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close').dialog('destroy');
                                }
                            }

                        }).dialog('open');
                    }
                });
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
            
          
           
        });
        
        function getCampaigns(){
            document.campaignForm.action = "<%=context%>/CampaignServlet?op=expenselistCampaigns";
            document.campaignForm.submit();
        }
        
    </script>
    
     <body>
        <fieldset align=center class="set" style="width: 90%;">
            <legend align="center">
                <table dir=<fmt:message key="direction"/> align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                                    <%=title %>
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
                        <td bgcolor="#dedede" valign="middle" width="50%" colspan="2">
                            <input type="button" class="button" style="width: 25%;" value="<%=shw%>" onclick="getCampaigns();"/>
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
                       
                    </TR>
                </THEAD>
                <TBODY>
                <%
                    int j=0;
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
                                attValue = (String) wbo.getAttribute(attName) + " ";
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
                        %>

                        <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <%= sumEXA.get(j)%>
                        </TD>

                        <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <img src="images/users.gif" width="16" style="display: <%=((clientsNumber == 0)) ? "none" : ""%>" title="<%=clientsTitle%>" />
                        </TD>

                        <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <!--<DIV ID="links" style="display: <%=currentStatus.equalsIgnoreCase("20") ? "none" : ""%>">-->
                            <DIV ID="links">
                                <A HREF="<%=context%>/CampaignServlet?op=viewCampaign&id=<%=wbo.getAttribute("id")%>" style="display: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "none" : ""%>">
                                    <%=shippingMfstTitles[7]%> 
                                </A>
                            </DIV>
                            <!--<DIV style="display: <%=currentStatus.equalsIgnoreCase("20") ? "" : "none"%>; text-align: center;">-->
                            <!--<DIV style="display: ''; text-align: center;">
                                 --- 
                            </DIV>-->
                        </TD>


                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <DIV>
                                <b style="color: blue;" id="currentStatus<%=wbo.getAttribute("id")%>">
                                    <%=wbo.getAttribute("currentStatusName")%> 
                                </b>
                            </DIV>
                        </TD>

                        <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-left: 14px; padding-right: 14px;">
                                <img src="images/icons/finance.jpg" style="height: 25px; cursor: hand;" title="<fmt:message key="expenses" />"
                                     onclick="JavaScript: openExpensesList('<%=wbo.getAttribute("id")%>')" />
                            </td>
                            <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-left: 14px; padding-right: 14px;">
                                <img src="images/icons/dollar-plus.jpg" style="height: 25px; cursor: hand;" title="<fmt:message key="addExpense" />"
                                     onclick="JavaScript: newExpenseForm('<%=wbo.getAttribute("id")%>')" />
                            </td>
                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align : <fmt:message key="textalign"/>; background-color: <%=("subcampaign".equals(wbo.getAttribute("campaignType"))) ? "#B5F8FF" : permenantColor%>;">
                            <input type="button" id="delete<%=wbo.getAttribute("id")%>" value="Delete" style="display: <%=clientsNumber != 0 ? "none" : ""%>" onclick="deleteCamp(<%=wbo.getAttribute("id")%>);"/>
                        </TD>
                    </TR>
                <%
                        j++;
                                }
                    }
                %>
                </TBODY>
                <TFOOT>
                    <TR>
                        <TH CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="6" STYLE="text-align : <fmt:message key="textalign"/>;padding-right:5;border-right-width:1;font-size:16;">
                            <B>
                                 <fmt:message key="campcount" /> 
                            </B>
                        </TH>

                        <TH CLASS="silver_footer" BGCOLOR="#808080" colspan="7" STYLE="text-align : <fmt:message key="textalign"/>;padding-left:5;font-size:16;"  >
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
       
    </body>
</html>