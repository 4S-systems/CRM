<%@page import="com.maintenance.db_access.TradeMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>


<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");
        String clientNo = (String) request.getAttribute("clientNo");
        String clientName = (String) request.getAttribute("clientName");

        String status = (String) request.getAttribute("status");
        String checked = (String) request.getAttribute("check");

        Vector<WebBusinessObject> vendors = (Vector) request.getAttribute("vendorVec");
        if (vendors == null) {
            vendors = new Vector();
        }
        WebBusinessObject userDefaultProject = (WebBusinessObject) request.getAttribute("userDefaultProject");
        boolean isAuthorized = false;
        boolean dayInRange = false;
        String fromDate = "";
        String toDate = "";
        if (userDefaultProject != null) {
            isAuthorized = true;
            fromDate = (String) userDefaultProject.getAttribute("relatedFrom");
            toDate = (String) userDefaultProject.getAttribute("relatedTo");
            Calendar c = Calendar.getInstance();
            if (fromDate != null && toDate != null) {
                if (Integer.parseInt(fromDate) <= c.get(Calendar.DAY_OF_MONTH) && Integer.parseInt(toDate) >= c.get(Calendar.DAY_OF_MONTH)) {
                    dayInRange = true;
                }
            }
        }

        String align = null;
        String dir = null;
        String style = null;
        String sTitle, notSelected;
        String notAuthorized, dateOutOfRange;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Search for vendors";
            notSelected = "Not Selected";
            notAuthorized = "You do not have authorization to create new one";
            dateOutOfRange = "Can not insert new one out of period of dates (" + fromDate + " : " + toDate + ")";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "قائمة اﻷعمال";
            notSelected = "لم يتم الاختيار";
            notAuthorized = "لا يوجد لك صلاحية لأدخال مستخلص";
            dateOutOfRange = "لا يمكن رفع مستخلص خارج الفترة (" + fromDate + " : " + toDate + ") من الشهر";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
<!--        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>-->
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function() {
                $("#clients").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                });
            });

            $(function() {
                $("input[name=search]").change(function() {
                    var value = $("input[name=search]:checked").attr("id");
                    if (value == 'clientNo') {
                        $("#searchValue").val("");
                        $("#searchValue").attr("placeholder", "رقم المقاول");
                        $("#msgT").html("");
                        $("#msgM").html("");
                        $("#msgNo").html("");
                        $("#info").html("");
                        $("#msgNa").html("");
                        $("#searchValue").css("border", "");
                        $("#showClients").css("display", "none");
                    } else if (value == 'clientName') {
                        $("#searchValue").val("");
                        $("#searchValue").attr("placeholder", "اسم المقاول");
                        $("#msgT").html("");
                        $("#msgM").html("");
                        $("#msgNo").html("");
                        $("#msgNa").html("");
                        $("#info").html("");
                        $("#searchValue").css("border", "");
                        $("#showClients").css("display", "none");
                    }
                })

            })
            function clearAlert() {
                $("#msgT").html("");
                $("#msgM").html("");
                $("#msgNo").html("");
                $("#info").html("");
                $("#msgNa").html("");
                $("#searchValue").css("border", "");
                $("#showClients").css("display", "none");
            }

            function getVendorInfo(obj) {
                var searchByValue = '';
                var value = $(obj).parent().parent().parent().parent().find("input[name=search]:checked").attr("id");
                $("#info").html("");
                //            if ($(obj).parent().find("#searchValue").val().length > 0) {

                if (value == 'clientNo') {
                    searchByValue = $(obj).parent().parent().find("#searchValue").val();
                } else {
                    searchByValue = $(obj).parent().parent().find("#searchValue").val();
                }
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForVendor&searchBy=" + value + "&searchByValue=" + searchByValue;
                document.CLIENT_FORM.submit();
                $("#clients").css("display", "");
                $("#showClients").val("show");
                //            } else {
                //                $("#info").html("أدخل محتوى البحث");
                //                $("#searchValue").focus();
                //                $("#searchValue").css("border", "1px solid red");
                //            }
            }

            function submitForm()
            {
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchSPInSchedule";
                document.CLIENT_FORM.submit();
            }

            function createExtractIssue(clientId, comments, note, callType) {
                if (!<%=isAuthorized%>) {
                    alert("<%=notAuthorized%>");
                } else if (!<%=dayInRange%>) {
                    alert("<%=dateOutOfRange%>");
                } else {
                    document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=newExtractIssue&clientId=" + clientId + "&comments=" + comments + "&note=" + note + "&callType=" + callType;
                    document.CLIENT_FORM.submit();
                }
            }
            function openCommentHieraricy(clientId) {

                document.CLIENT_FORM.action = "<%=context%>/IssueServlet?op=openCommentHierariecy&clientId=" + clientId;
                document.CLIENT_FORM.submit();

            }

            function cancelForm()
            {
                document.CLIENT_FORM.action = "main.jsp";
                document.CLIENT_FORM.submit();
            }
        </SCRIPT>
        <style>  
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
            /*            label{
                            font: Georgia, "Times New Roman", Times, serif;
                            font-size:14px;
                            font-weight:bold;
                            color:#005599;
                            margin-right: 5px;
                        }*/
            #row:hover{
                background-color: #D3E3EB !important;
            }
        </style>
    </HEAD>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="width: 100%;">
                    <FIELDSET class="set" style="width:85%;border-color: #006699" >
                        <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                            <tr>
                                <td width="100%" class="titlebar">
                                    <font color="#005599" size="4"><%=sTitle%></font>
                                </td>
                            </tr>
                        </table>
                        <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                            <TR>
                                <TD style="border: none" width="70%">
                                    <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER">
                                        <tr>
                                            <td STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto" id="te">
                                                    <span><input type="radio" name="search" value="<%=(clientNo == null) ? "" : clientNo%>" id="clientNo"  checked="false" />  <font size="2"  color="#000"><b>رقم المقاول</b></font></span>
                                                    <span><input type="radio" name="search" value="<%=(clientName == null) ? "" : clientName%>" id="clientName" checked="true"/>  <font size="2" color="#000"><b>اسم المقاول</b></font></span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td STYLE="<%=style%>" class='td'></td></tr>
                                        <tr>
                                            <td STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto" id="te">
                                                    <%if (checked != null) {%>
                                                    <input type="text" name="searchValue" id="searchValue"  placeholder="رقم المقاول" onkeyup="clearAlert()" onkeypress="clearAlert()"onblur="getVendorInfo(this)"/>
                                                    <%} else {%>
                                                    <input type="text" name="searchValue" id="searchValue" placeholder="اسم المقاول" onkeyup="clearAlert()" onkeypress="clearAlert()" onblur="getVendorInfo(this)"/>
                                                    <%}%>
                                                    <input type="button"  id="searchBtn" onclick="getVendorInfo(this)" value="بحث"/>
                                                </div>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 96%;margin-left: auto;margin-right: auto">
                                                    <LABEL id="msgM" style="color: red;"></LABEL>
                                                    <LABEL id="msgT" style="color: red;"></LABEL>
                                                    <LABEL id="msgNo" style="color: red;"></LABEL>
                                                    <LABEL id="info" style="color: green;"></LABEL>
                                                        <%if (status != null && status.equals("no")) {%>
                                                    <LABEL id="msgNa" style="color: red;">لم يتم الحفظ</LABEL>
                                                        <%} else {%>
                                                        <%}%>
                                                </div>
                                            </td>

                                        </tr>
                                    </TABLE>
                                </TD>
                                <TD style="border: none" align="left" width="30%">
                                    <img alt="Database Configuration" src="images/engineer.jpg" width="200" height="100" style="border: none; vertical-align: middle;" />
                                </TD>
                            </TR>
                        </TABLE>
                    </FIELDSET>
                    <br />
                </div>
                <%if (!vendors.isEmpty()) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE id="clients" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" style="display">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">عمل مستخلص</th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">عمل طلب تسليم</th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">رقم المقاول</th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">إسم المقاول</th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">نشاط المقاول</th>
                            </tr>
                        <thead>
                        <tbody>  
                            <%
                                TradeMgr tradeMgr = TradeMgr.getInstance();
                                String nationality;
                                String job;
                                String jobName = " لم يتم الاختيار";
                                for (WebBusinessObject wbo : vendors) {
                                    nationality = (String) wbo.getAttribute("nationality");
                                    job = (String) wbo.getAttribute("job");
                                    if (job != null && !job.startsWith(" ")) {
                                        WebBusinessObject wboa = tradeMgr.getOnSingleKey(job);
                                        jobName = (String) wboa.getAttribute("tradeName");
                                    }
                                    if (nationality != null && nationality.equalsIgnoreCase("000")) {
                                        nationality = notSelected;
                                    }
                            %>
                            <tr style="cursor: pointer" id="row">
                                <TD onclick="createExtractIssue(<%=wbo.getAttribute("id")%>, 'internal', 'internal', 'internal');">
                                    <b><img value="" onclick="" width="24" height="24" src="images/icons/excel.png" style="" /></B>
                                </TD>
                                <td onclick="openCommentHieraricy(<%=wbo.getAttribute("id")%>)">
                                    <b><img value="" onclick="" width="35" height="35" src="images/icons/request.png" style="" /></b>
                                </td>
                                <TD>
                                    <% if (wbo.getAttribute("clientNO") != null) {%>
                                    <b><%=wbo.getAttribute("clientNO")%></b>
                                    <% }%>
                                </TD>
                                <TD >
                                    <%if (wbo.getAttribute("name") != null) {%>
                                    <b><%=wbo.getAttribute("name")%></b>
                                    <%}%>

                                </TD>
                                <TD>
                                    <b><%=jobName%></b>
                                </TD>
                            </tr>
                            <% }%>
                        </tbody>  
                    </TABLE>
                    <BR />
                </div>
                <%}%>
            </div>
        </FORM>
    </BODY>
</HTML>     
