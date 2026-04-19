<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Main.Main"  />
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();

            int iTotal = 0;
            Vector<WebBusinessObject> data = (Vector<WebBusinessObject>) request.getAttribute("data");
            ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
            ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("users");
            ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");
            Map<String, ArrayList<WebBusinessObject>> dataResult = (HashMap<String, ArrayList<WebBusinessObject>>) request.getAttribute("dataResult");

            String fromDate = "";
            if (request.getAttribute("fromDate") != null) {
                fromDate = (String) request.getAttribute("fromDate");
            }
            String toDate = "";
            if (request.getAttribute("toDate") != null) {
                toDate = (String) request.getAttribute("toDate");
            }
            String createdBy = "";
            if (request.getAttribute("createdBy") != null) {
                createdBy = (String) request.getAttribute("createdBy");
            }
            String campaignID = "";
            if (request.getAttribute("campaignID") != null) {
                campaignID = (String) request.getAttribute("campaignID");
            }
            String rateID = "";
            if (request.getAttribute("rateID") != null) {
                rateID = (String) request.getAttribute("rateID");
            }
            String subject = "";
            if (request.getAttribute("subject") != null) {
                subject = (String) request.getAttribute("subject");
            }
            String reportType = (String) request.getAttribute("reportType");
            //Privileges
            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            ArrayList<WebBusinessObject> prvType = securityUser.getComplaintMenuBtn();
            ArrayList<String> privilegesList = new ArrayList<>();
            for (WebBusinessObject wboTemp : prvType) {
                if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                    privilegesList.add((String) wboTemp.getAttribute("prevCode"));
                }
            }

            String stat = "Ar";
            String align = "center";
            String dir = null;
            String style = null, lang, langCode, excelStr;

            if (stat.equals("En")) {
                align = "left";
                dir = "LTR";
                style = "text-align:right";
                lang = "&#1593;&#1585;&#1576;&#1610;";
                langCode = "Ar";
                excelStr = " Excel ";
            } else {
                dir = "RTL";
                align = "right";
                style = "text-align:Right";
                lang = "English";
                langCode = "En";
                excelStr = " Excel ";
            }

            ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
            String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
            ArrayList<WebBusinessObject> employeeList = (ArrayList<WebBusinessObject>) request.getAttribute("users");

        %>
        <TITLE>System Users List</TITLE>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <link href="js/select2.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" language="javascript" src="js/select2.min.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }
            textarea {width: 90%;   height: 70%; text-align: center; border: none;}

            #hide{ display: none;}

            .ddlabel {
                float: left;
            }
            .fnone {
                margin-right: 5px;
            }
            .ddChild, .ddTitle {
                text-align: right;
            }
        </style>
    </HEAD>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".selectCampaign").select2();
            $("#subject").val('<%=subject%>');
            try {
                $(".clientRate").msDropDown();
            } catch (e) {
                alert(e.message);
            }
        });

        $(function () {
            $("#fromDate, #toDate").datepicker({
                changeMonth: true,
                changeYear: true,
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
        });

        var divCommentsTag;
        function openCommentsDialog(complaintId) {
            loading("block");
            divCommentsTag = $("div[name='divCommentsTag']");
            $.ajax({
                type: "post",
                url: '<%=context%>/CommentsServlet?op=showGenralClientCommentsPopup',
                data: {
                    clientComplaintId: complaintId
                },
                success: function (data) {
                    divCommentsTag.html(data)
                            .dialog({
                                modal: true,
                                title: "<fmt:message key="viewcomments" />",
                                show: "fade",
                                hide: "explode",
                                width: 1000,
                                position: {
                                    my: 'center',
                                    at: 'center'
                                },
                                buttons: {
                                    Cancel: function () {
                                        divCommentsTag.dialog('close');
                                    },
                                    Done: function () {
                                        divCommentsTag.dialog('close');
                                    }
                                }
                            })
                            .dialog('open');
                },
                error: function (data) {
                    alert('Data Error = ' + data);
                }
            });
            loading("none");
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
        function popupAddComment(obj, clientId) {
            $("#clientId").val(clientId);
            $("#commentAreaForSave").val("");
            $("#commentType").val("0")
            $("#commMsg").hide();
            $('#add_comments').css("display", "block");
            $('#add_comments').bPopup({easing: 'easeInOutSine',
                speed: 400,
                transition: 'slideDown'});
        }
        function saveComment(obj) {
            var clientId = $("#clientId").val();
            var type = $("#commentType").val();
            var comment = $("#commentAreaForSave").val();
            var businessObjectType = $(obj).parent().parent().parent().find($("#businessObjectType")).val();
            $(obj).parent().parent().parent().parent().find("#progress").show();
            $.ajax({
                type: "post",
                url: "<%=context%>/CommentsServlet?op=saveComment",
                data: {
                    clientId: clientId,
                    type: type,
                    comment: comment,
                    businessObjectType: businessObjectType
                },
                success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
                        $('#add_comments').bPopup().close();
                    } else if (eqpEmpInfo.status == 'no') {
                        alert("لم يتم حفظ التعليق");
                    }
                }
            });
        }
        function openInNewWindow(url) {
            var win = window.open(url, '_blank');
            win.focus();
        }
        function getEmployees(obj) {
            var departmentID = $(obj).val();
            $.ajax({
                type: "post",
                url: "<%=context%>/CommentsServlet?op=getEmployeesList",
                data: {
                    departmentID: departmentID
                },
                success: function (jsonString) {
                    try {
                        var output = [];
                        output.push('<option value="all">' + "<fmt:message key="all" />" + '</option>');
                        var createdBy = $("#createdBy");
                        $(createdBy).html("");
                        var info = $.parseJSON(jsonString);
                        for (i = 0; i < info.length; i++) {
                            var item = info[i];
                            output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                        }
                        createdBy.html(output.join(''));
                    } catch (err) {
                    }
                }
            });
        }
        function showProjects(obj, clientID) {
            $.ajax({
                type: "post",
                url: "<%=context%>/CommentsServlet?op=getProjectsList",
                data: {
                    clientID: clientID
                },
                success: function (jsonString) {
                    try {
                        var title = "<fmt:message key="projects"/>:";
                        var info = $.parseJSON(jsonString);
                        for (i = 0; i < info.length; i++) {
                            var item = info[i];
                            title += "\n" + item.productCategoryName;
                        }
                        $(obj).attr("title", title);
                    } catch (err) {
                    }
                }
            });
        }

        function exportToExcel() {
            var toDate = $("#toDate").val();
            var fromDate = $("#fromDate").val();
            var subject = $("#subject").val();
            var url = "<%=context%>/CommentsServlet?op=getAllClientCommentsExcel&toDate=" + toDate + "&fromDate=" + fromDate + "&subject=" + subject;
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
        }
    </script>

    <style>
        .odd_main {
            border-right:.5px solid #D9E6EC;
            border-bottom:0px solid #D9E6EC;
            padding: 3px;
            border-top:0px solid #D9E6EC;
            font-size: 12px;
            word-wrap: break-word;
            background-color: #e3e3e3;
        }
        .even_main {
            border-right:.5px solid #D9E6EC;
            border-bottom:0px solid #D9E6EC;
            padding: 3px;
            border-top:0px solid #D9E6EC;
            font-size: 12px;
            word-wrap: break-word;
            background-color: #f3f3f3;
        }
    </style>

    <body>

        <div name="divCommentsTag"></div>
        <div id="add_comments"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;"><!--class="popup_appointment" -->
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <%
                        if (metaMgr.getShowCommentType().equalsIgnoreCase("1")) {
                    %>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">
                            <fmt:message key="commenttype" />
                        </td>
                        <td style="width: 70%;" >
                            <select style="float: right;width: 30%; font-size: 14px;" id="commentType" >
                                <option value="0"><fmt:message key="ceneralcomment" /></option>
                                <option value="1"><fmt:message key="privatecomment" /></option>
                            </select>
                            <input type="hidden" id="businessObjectType" value="1"/>
                        </td>

                    </tr>
                    <%
                    } else {
                    %>
                    <input type="hidden" id="commentType" name="commentType" value="0"/>
                    <input type="hidden" id="businessObjectType" value="1"/>
                    <%
                        }
                    %>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">
                            <fmt:message key="comment" />
                        </td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="commentAreaForSave" name="commentAreaForSave" > </textarea>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                    <input type="button" value="حفظ"   onclick="saveComment(this)" id="saveComm"class="login-submit"/></div>                             </form>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
                    <fmt:message key="commentadded" />
                </div>
                <input type="hidden" id="clientId" value="1"/>
            </div>  
        </div>

        <div id="loading" class="container" style="display: none">
            <div class="contentBar">
                <div id="block_1" class="barlittle"></div>
                <div id="block_2" class="barlittle"></div>
                <div id="block_3" class="barlittle"></div>
                <div id="block_4" class="barlittle"></div>
                <div id="block_5" class="barlittle"></div>
            </div>
        </div>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/CommentsServlet?op=getAllClientComments" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"> <fmt:message key="clientscomments" /> </font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR=<fmt:message key="direction" /> WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><fmt:message key="fromdate" /></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"> <fmt:message key="todate" /></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="margin: 10px;"/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" />
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"><fmt:message key="subject" /></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" colspan="2">
                            <select id="subject" name="subject" style="margin: 10px;">
                                <option value=""></option>
                                <option value="1">Nomination</option>
                                <option value="2">Direct Client</option>
                                <option value="3">Indirect client</option>
                            </select>
                        </td>
                    </tr>
                    <%
                        if (reportType == null) {
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><fmt:message key="dep" /></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><fmt:message key="campaign" /></b>
                        </td>
                    </tr>
                    <tr>
                        <TD bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <div id="mydiv">
                                <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 170px;"
                                        onchange="JavaScript: getEmployees(this);">
                                    <option value="all"><fmt:message key="all" /></option>
                                    <% if (departments != null) {%>
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                    <% }%>
                                </select>
                            </DIV>
                        </TD>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" name="campaignID" class="selectCampaign">
                                <option value="all"><fmt:message key="all" /></option>
                                <sw:WBOOptionList wboList='<%=campaignsList%>' displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>"/>
                            </select>
                        </td>
                    </TR>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><fmt:message key="employee" /></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><fmt:message key="rate" /></b>
                        </td>
                    </tr>
                    <TR>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="createdBy" name="createdBy" >
                                <option value="all"><fmt:message key="all" /></option>
                                <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=createdBy%>"/>
                            </select>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select class="clientRate" style="font-size: 14px;font-weight: bold; width: 170px;" id="rateID" name="rateID">
                                <option value=""><fmt:message key="all" /></option>
                                <%
                                    for (WebBusinessObject rateWbo : ratesList) {
                                %>
                                <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateWbo.getAttribute("projectID").equals(rateID) ? "selected" : ""%>  data-image="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><%=rateWbo.getAttribute("projectName")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" colspan="2">
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #27272A;font-size:15px;margin: 10px;font-weight:bold; width: 120px; ">
                                <fmt:message key="search"/>
                                <IMG HEIGHT="15" SRC="images/search.gif" ></button>
                            <a href="<%=context%>/CommentsServlet?op=getClientCommentsPDF&fromDate=<%=fromDate%>&toDate=<%=toDate%>&createdBy=<%=createdBy%>&campaignID=<%=campaignID%>&departmentID=<%=departmentID%>">
                                <img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/>
                            </a>
                        </td>
                    </tr>
                    <%
                    } else {
                    %>
                    <tr>
                        <td colspan="<%=privilegesList.contains("EXCEL") ? "1" : "2"%>" style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input type="hidden" name="reportType" value="<%=reportType%>"/>
                            <button type="submit" style="color: #27272A;font-size:15px;margin: 10px;font-weight:bold; width: 120px; ">
                                <fmt:message key="search"/>
                                <IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                        </td>

                        <td colspan="" style="text-align: center; display: <%=privilegesList.contains("EXCEL") ? "" : "none"%>;" bgcolor="#dedede" valign="middle">
                            <%--<input type="button" name="excel" value="<%=excelStr%>" onclick="exportToExcel();"/>
                            <IMG HEIGHT="15" style="margin-right: 2px; margin-top: 1px;" SRC="images/icons/excel.png" />--%>
                            <button type="button" STYLE="display: <%=privilegesList.contains("EXCEL") ? "" : "none"%>; color: #27272A;font-size:15;font-weight:bold;"
                                    onclick="exportToExcel()"><IMG HEIGHT="15" style="margin-right: 2px; margin-top: 1px;" SRC="images/icons/excel.png" />Excel
                            </button>
                        </td>

                    </tr>
                    <%
                        }
                    %>
                </table>

                <br/><br/>
                <div style="width: 100%;margin-left: auto;margin-right: auto;">
                    <TABLE class="blueBorder" id="clients" align="center" DIR=<fmt:message key="direction" /> WIDTH="100%" CELLPADDING="0" cellspacing="0">
                        <thead>
                            <TR>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="4%"><b>#</b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="9%"><b><fmt:message key="clientcode" /> </b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="33%"><b><fmt:message key="clientname" /> </b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="10%"><b><fmt:message key="mobile" /> </b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="10%"><b><fmt:message key="intnumber" /></b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="18%"><b><fmt:message key="mail" /></b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="8%"><b><fmt:message key="entryDate" /></b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="8%"><b>Source</b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="8%"><b>Know Us</b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="8%"><b><fmt:message key="rate" /></b></TH>
                            </TR>
                        </thead>  

                        <tbody  id="planetData2">
                            <%
                                if (data != null && data.size() > 0) {
                                    ArrayList<WebBusinessObject> commentsList;
                                    for (WebBusinessObject wbo : data) {
                                        iTotal++;
                                        commentsList = dataResult.get((String) wbo.getAttribute("clientID"));
                            %>
                            <TR style="padding: 1px;">
                                <TD>
                                    <%=iTotal%>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientNo")%>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientName")%>
                                    <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId='+<%=wbo.getAttribute("clientID")%>);"><img src="images/client_details.jpg" width="30" style="float: left;"></a>
                                    <a href="#">
                                        <img src="images/icons/project.png" height="22" style="float: left;"
                                             onmouseover="JavaScript: showProjects(this, '<%=wbo.getAttribute("clientID")%>');"/>
                                    </a>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientMobile")%>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientInterPhone") != null && !"UL".equals(wbo.getAttribute("clientInterPhone")) ? wbo.getAttribute("clientInterPhone") : ""%>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientEmail")%>
                                </td>

                                <TD nowrap>
                                    <%=wbo.getAttribute("creationTime") != null ? ((String) wbo.getAttribute("creationTime")).substring(0, 16) : "---"%>
                                </td>

                                <td>
                                    <%=wbo.getAttribute("englishname") != null ? wbo.getAttribute("englishname") : ""%>
                                </td>
                                
                                <td>
                                    <%=wbo.getAttribute("campaign_title") != null ? wbo.getAttribute("campaign_title") : ""%>
                                </td>
                                
                                <td>
                                    <%=wbo.getAttribute("rateName") != null ? wbo.getAttribute("rateName") : ""%>
                                </td>
                            </TR>
                            <TR style="padding: 1px;">
                                <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px; background-repeat: repeat" colspan="2">
                                    <fmt:message key="comments" />
                                </TD>
                                <TD colspan="6">
                                    <table style="width: 80%; margin: auto;" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" style="text-align: right;">
                                                <fmt:message key="comments" />
                                                <%
                                                    if (wbo.getAttribute("isOwner") != null && ((Boolean) wbo.getAttribute("isOwner"))) {
                                                %>
                                                <img src="images/icons/add-comment.png" title="<fmt:message key="addcomment" />" onclick="JavaScript: popupAddComment(this, '<%=wbo.getAttribute("clientID")%>')" height="25" style="cursor: hand; float: left;"/>
                                                <%
                                                    }
                                                %>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <fmt:message key="commentdate" />
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">

                                                <fmt:message key="employee" />
                                            </td>
                                        </tr>
                                        <%
                                            int counter = 0;
                                            String clazz;
                                            for (WebBusinessObject commentWbo : commentsList) {
                                                String creationTime = (String) commentWbo.getAttribute("creationTime");
                                                if (creationTime != null && creationTime.length() > 16) {
                                                    creationTime = creationTime.substring(0, creationTime.lastIndexOf(":"));
                                                }
                                                if ((counter % 2) == 1) {
                                                    clazz = "odd_main";
                                                } else {
                                                    clazz = "even_main";
                                                }
                                                counter++;
                                        %>
                                        <tr>
                                            <td class="<%=clazz%>">
                                                <TEXTAREA style="background-color: #f4efcd;" readonly rows="4"><%=commentWbo.getAttribute("comment") != null ? commentWbo.getAttribute("comment") : "لا يوجد"%></TEXTAREA>
                                            </td>
                                            <td class="<%=clazz%>" nowrap style="width: 100px;">
                                                <%=creationTime%>
                                            </td>
                                            <td class="<%=clazz%>" nowrap style="width: 80px;">
                                                <% String fullNameUser = UserMgr.getInstance().getByKeyColumnValue("key",(String) commentWbo.getAttribute("createdBy"), "key3"); %>
                                                <%=fullNameUser%>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </table>
                                </TD>
                            </TR>
                            <tr>
                                <td colspan="10" class="" style="text-align:center; color:white; font-size:14px; background-color: #94DBFF;"><b>&nbsp;</b></td>
                            </tr>
                            <%
                                    }
                                }%>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
            </form>
        </fieldset>
        <br/>
    </body>
</html>
