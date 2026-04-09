<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.db_access.EmployeesLoadsMgr"%>
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
        ArrayList<WebBusinessObject> projectList = (ArrayList<WebBusinessObject>) request.getAttribute("projectList");

        String align, dir, style = null;
        String sTitle, num, projectTitle, phone, email,searchButton;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Search for a Specific Client";
            num = "Unit\\Client Number";
            phone = "Dialed\\Phone\\Mobile Number";
            projectTitle = "Project";
            email = "Email";
            searchButton="Search";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "بحث عن عميل محدد";
            num = "رقم الوحدة";
            phone = "رقم التليفون/الموبايل/الطالب/العميل";
            projectTitle = "المشروع";
            email = "البريد اﻷلكتروني";
            searchButton="بحث";
        }
    %>

    <HEAD>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <TITLE></TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/chosen.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
    </HEAD>

    <script type="text/javascript">
        var searchTypeSt;
        function getClientInfo(searchType) {
            var num = $("#num").val();
            if (searchType != '') {
                searchTypeSt = searchType;
            }
            if (searchTypeSt == 'searchByPhone') {
                num = $("#phone").val();
            }
            if (searchTypeSt == 'searchByEmail') {
                num = $("#email").val();
            }
            $("#info").html("");

            var projectID = $("#projectID").val();
            if (num.length > 0) {
                var url = "<%=context%>/ClientServlet?op=getClientHistory&num=" + num + "&projectID=" + projectID + "&searchType=" + searchTypeSt;
                $("#clientDetails").html("");
                $("#clientDetails").html("Loading ...");
                jQuery('#clientDetails').load(url);
            }
        }
    </script>

    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="width: 100%;">
                <fieldset class="set" align="center" width="100%" style="width: 70%;margin-bottom: 10px;">
                    <legend align="center">
                        <table dir="<%=dir%>" align="center">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6">
                                    الصحيفة التاريخية
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </legend>

                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%">
                        <tr>
                            <td class='td'>
                                <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                                    <tr>
                                        <td colspan="1" STYLE="<%=style%>" class='td'><%=projectTitle%></td>
                                        <td style="text-align:center" valign="middle" class="td">
                                                <select style="font-size: 14px;font-weight: bold; width: 280px;" id="projectID" name="projectID"
                                                        class="chosen-select-project">
                                                <option value="">All</option>
                                                <sw:WBOOptionList wboList='<%=projectList%>' displayAttribute = "projectName" valueAttribute="projectID"/>
                                            </select>
                                        </td>
                                        <td colspan="1" STYLE="<%=style%>" class='td'><%=num%></td>
                                        <td colspan="1" STYLE="<%=style%>;width: 250px;" class='td' nowrap>
                                            <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;" id="te">
                                                <input type="text" name="num" id="num" placeholder="<%=num%>" onblur="getClientInfo('searchByUnitNo')"/>
                                                <input type="button"  id="searchBtn" onclick="getClientInfo('searchByUnitNo')" value='<%=searchButton%>'/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" STYLE="<%=style%>" class='td'>
                                            &nbsp;
                                        </td>
                                        <td colspan="1" STYLE="<%=style%>" class='td'><%=phone%></td>
                                        <td colspan="1" STYLE="<%=style%>;width: 250px;" class='td' nowrap>
                                            <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;" id="te">
                                                <input type="text" name="phone" id="phone" placeholder="<%=phone%>" onblur="getClientInfo('searchByPhone')"/>
                                                <input type="button"  id="searchBtn" onclick="getClientInfo('searchByPhone')" value='<%=searchButton%>'/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" STYLE="<%=style%>" class='td'>
                                            &nbsp;
                                        </td>
                                        <td colspan="1" STYLE="<%=style%>" class='td'><%=email%></td>
                                        <td colspan="1" STYLE="<%=style%>;width: 250px;" class='td' nowrap>
                                            <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;" id="te">
                                                <input type="text" name="email" id="email" placeholder="<%=email%>" onblur="getClientInfo('searchByEmail')"/>
                                                <input type="button"  id="searchBtn" onclick="getClientInfo('searchByEmail')" value='<%=searchButton%>'/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" STYLE="<%=style%>" class='td'>
                                            &nbsp;
                                        </td>
                                        <td colspan="2" STYLE="<%=style%>" class='td'>
                                            <div style="text-align: center;width: 96%;margin-left: auto;margin-right: auto">
                                                <LABEL id="info" style="color: green;"></LABEL>
                                            </div>
                                        </td>
                                    </tr>
                                </TABLE>
                            </TD>
                        </TR>
                    </TABLE>
                </FIELDSET>

                <div style="width: 100%;margin-right: auto;margin-left: auto;" id="clientDetails">
                </div>
                <br>
            </DIV>
        </FORM>
        <script>
            var config = {
                '.chosen-select-project': {no_results_text: 'No project found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </BODY>
</HTML>