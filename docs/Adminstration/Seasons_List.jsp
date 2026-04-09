<%@page import="com.silkworm.common.SecurityUser"%>
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

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <TITLE>System Departments List</TITLE>
    </HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        int iTotal = 0;
        String attValue = null;
        Vector seaVector = (Vector) request.getAttribute("seaVector");
        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
	ArrayList<WebBusinessObject> prvType = securityUser.getComplaintMenuBtn();
	ArrayList<String> privilegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
    %>

    <body>

        <script language="javascript" type="text/javascript">
            $(document).ready(function(){
                $('#seasons').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 20, 50, 100, -1], [10, 20, 50, 100, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": false
                }).fadeIn(2000);
            });
            function back(url)
            {
                document.PROJECT_FORM.action = url;
                document.PROJECT_FORM.submit();
            }

            function openView(id) {
                var divTag2 = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/SeasonServlet?op=ViewSeasonType',
                    data: {
                        seasonTypeId: id
                    },
                    success: function (data) {
                        console.log("openView data");
                        console.log(data);
                        divTag2.html(data)
                                .dialog({
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

                                })
                                .dialog('open');
                    }
                });
            }


            function openTools(code, name) {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/SeasonServlet?op=viewTools',
                    data: {
                        code: code
                    },
                    success: function (data) {
                        console.log("openTools data");
                        console.log(data);
                        divTag.html(data)
                                .dialog({
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

                                })
                                .dialog('open');
                    }
                });
            }
            function addToolForm(id) {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/SeasonServlet?op=addTool',
                    data: {
                        id: id
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: '<fmt:message key="addtool" />',
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
                                            saveTool(this);
                                        }
                                    }

                                })
                                .dialog('open');
                    }
                });
            }
            function saveTool(obj) {
                var code = $("#code").val();
                var arabicName = $("#arabicName").val();
                var forever = $("#forever").is(':checked') ? "1" : "0";
                if (arabicName === '') {
                    alert("<fmt:message key="arabicNameMsg" />");
                    $("#arabicName").focus();
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/SeasonServlet?op=saveToolAjax",
                        data: {
                            code: code,
                            arabic_name: arabicName,
                            english_name: arabicName,
                            forever: forever
                        },
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
            function newExpenseForm(id) {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FinancialManagementServlet?op=getNewExpenseForm',
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
            function updateShowHideChannel(id) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/SeasonServlet?op=updateShowHideChannelAjax",
                    data: {
                        id: id,
                        display: $("#display" + id).is(':checked') ? '1' : '0'
                    },
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        if (data.status === 'ok') {
                            alert("Updated Successfully");
                        }
                    }
                });
            }
        </script>
        <STYLE >
            .ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {
                float: none;
            }
            .ui-dialog .ui-dialog-title, .ui-dialog .ui-dialog-buttonpane {
                text-align:center;
                padding-left: 0.4em;
                padding-right: 0.4em;
            }
        </style>
        <fieldset align=center class="set" style="width: 90%; padding: 10px;">
            <legend align="center" dir=<fmt:message key="direction" /> align="center">
                <font color="blue" size="4"> Communication Channels قنوات الأتصال
                </font>
            </legend >
            <br/><br/>
            <TABLE  align="center" dir=<fmt:message key="direction" />>
                <td style="width: 50% ; border: none; padding: 20px;">
                    <TABLE id="seasons" align="center" dir="<fmt:message key="direction" />" width="400" cellpadding="0" cellspacing="0" style="border-right-width: 1px;">
                        <thead>
                            <TR >
                                <th nowrap CLASS="silver_footer" WIDTH="150" bgcolor="#808080" STYLE="border-WIDTH:0; font-size:14 ;white-space: nowrap;" rowspan="2">
                                    <B><fmt:message key="name" /></B>
                                </th>

                                <th nowrap CLASS="silver_footer" WIDTH="150" bgcolor="#808080" STYLE="border-WIDTH:0; font-size:14 ;white-space: nowrap;" rowspan="2">
                                    <B><fmt:message key="view" /></B>
                                </th>

                                <th nowrap CLASS="silver_footer" WIDTH="150" bgcolor="#808080" STYLE="border-WIDTH:0; font-size:14 ;white-space: nowrap;" rowspan="2">
                                    <B><fmt:message key="edit" /></B>
                                </th>

                                <th nowrap CLASS="silver_footer" WIDTH="150" bgcolor="#808080" STYLE="border-WIDTH:0; font-size:14 ;white-space: nowrap;" rowspan="2">
                                    <B><fmt:message key="delete" /></B>
                                </th>
                                <th nowrap class="silver_footer" WIDTH="150" bgcolor="#808080" style="border-width:0; font-size:14 ;white-space: nowrap;" rowspan="2">
                                    <B><fmt:message key="show" /></B>
                                </th>
                                <th nowrap class="silver_footer" bgcolor="#808080" STYLE="border-width: 0; font-size: 14 ; white-space: nowrap;" colspan="2">
                                    <b>
                                        <fmt:message key="tools" />
                                    </b>
                                </th>
                                <th nowrap class="silver_footer" bgcolor="#808080" STYLE="border-width: 0; font-size: 14px; white-space: nowrap;" colspan="2">
                                    <b>
                                        <fmt:message key="expenses" />
                                    </b>
                                </th>
                            </TR>
                            <tr>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%

                            Enumeration e = seaVector.elements();
                            iTotal = seaVector.size();

                            while (e.hasMoreElements()) {

                                wbo = (WebBusinessObject) e.nextElement();
                                flipper++;
                                if ((flipper % 2) == 1) {
                                    bgColor = "silver_odd";

                                } else {
                                    bgColor = "silver_even";

                                }
                        %>

                        <TR>

                            <fmt:message var="attname" key="comm_channel_attribute_name" />

                            <%
                                String attname = (String) pageContext.getAttribute("attname");
                                attValue = (String) wbo.getAttribute(attname) + " ";
                            %>
                            <TD STYLE="text-align: <fmt:message key="textalign" />" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>" >
                                <DIV >

                                    <b style="color: red;"> <%=attValue%> </b>
                                </DIV>
                            </TD>


                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10; text-align: <fmt:message key="textalign" />">
                                <DIV ID="links">
                                    <A href="<%=context%>/SeasonServlet?op=ViewSeasonType&seasonTypeId=<%=wbo.getAttribute("id")%>">
                                        <fmt:message key="view" />
                                    </A>
                                </DIV>
                            </TD>

                            <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10; text-align: <fmt:message key="textalign" />">
                                <DIV ID="links">
                                    <A HREF="<%=context%>/SeasonServlet?op=UpdateSeasonType&seasonTypeId=<%=wbo.getAttribute("id")%>">
                                        <fmt:message key="edit" />
                                    </A>
                                </DIV>
                            </TD>
                            <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10; text-align: <fmt:message key="textalign" />">
                                <DIV ID="links">
                                    <%
                                        if (privilegesList.contains("DELETE_COMM_CHANNEL")) {
                                    %>
                                    <A HREF="<%=context%>/SeasonServlet?op=ConfirmDeleteSeason&seasonTypeId=<%=wbo.getAttribute("id")%>">
                                        <fmt:message key="delete" />
                                    </A>
                                    <%
                                    } else { %>
                                    ******                                    
                                    <%
                                        }
                                    %>
                                </DIV>
                            </TD>
                            <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-left: 10px; padding-right: 10px;">
                                <input type="checkbox" id="display<%=wbo.getAttribute("id")%>" value="1" <%="1".equals(wbo.getAttribute("display")) ? "checked": ""%>
                                       onchange="JavaScript: updateShowHideChannel('<%=wbo.getAttribute("id")%>');"/>
                            </td>
                            <TD nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-left: 10px; padding-right: 10px;">
                                <img src="images/tools.png" style="width: 40px; cursor: hand;" title="<fmt:message key="viewtool" />"
                                     onclick="JavaScript: openTools('<%=wbo.getAttribute("type_code")%>', '<%=attValue%>')"/>
                            </TD>
                            <TD nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-left: 14px; padding-right: 14px;">
                                <img src="images/icons/add-request.png" style="height: 25px; cursor: hand;" title="<fmt:message key="addtool" />"
                                     onclick="JavaScript: addToolForm('<%=wbo.getAttribute("id")%>')" />
                            </TD>
                            <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-left: 14px; padding-right: 14px;">
                                <img src="images/icons/finance.jpg" style="height: 25px; cursor: hand;" title="<fmt:message key="expenses" />"
                                     onclick="JavaScript: openExpensesList('<%=wbo.getAttribute("id")%>')" />
                            </td>
                            <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-left: 14px; padding-right: 14px;">
                                <img src="images/icons/dollar-plus.jpg" style="height: 25px; cursor: hand;" title="<fmt:message key="addExpense" />"
                                     onclick="JavaScript: newExpenseForm('<%=wbo.getAttribute("id")%>')" />
                            </td>


                        </TR>


                        <%

                            }

                        %>
                        </tbody>
                    </TABLE>
                </td>
                <td style="width: 50% ; border: none">

                    <img align="center" dir=<fmt:message key="direction" /> src="images/communications.jpg" style="margin: 20%;  display: inherit;height: 350px;" />
                </td>
            </TABLE>

        </fieldset>


    </body>
</html>
