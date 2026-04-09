<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.maintenance.db_access.UserStoresMgr"%>
<%@page import="javax.management.relation.Relation"%>
<%@page import="com.silkworm.pagination.PAGINATION_CONSTANT"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.*" %>
<%@page import="com.silkworm.pagination.Filter,com.silkworm.pagination.FilterCondition"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%

    String name, list_title_page, listLabel, dir, defaultView, cancel,
            align = "center", textAlign = "right", rowsPerPageLabel, pageLabel, ofLabel, goToPageNumber, refreshSearchLabel;
    String stat = (String) request.getSession().getAttribute("currentMode");

    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    String context = metaDataMgr.getContext();

    Filter filter = new Filter();
    filter = (Filter) request.getAttribute("filter");

    short index = filter.getPageIndex();
    short startPage = filter.getStartPage();
    short endPage = filter.getEndPage();
    short numberPages = filter.getNumberPages();
    short rowsPerPage = filter.getCountRowPage();

    boolean canBack = (index > 0);
    boolean canNext = (index < (numberPages - 1));

    // this paths if lang. is arabic
    String sawper;
    String imgLastPage = "images/right_last_arrow.png";
    String imgFirstPage = "images/left_first_arrow.png";
    String imgBack = "images/left_arrow.png";
    String imgNext = "images/right_arrow.png";
    String imgBackDisable = "images/left_disable_arrow.png";
    String imgNextDisable = "images/right_disable_arrow.png";

    if (stat.equals("Ar")) {
        name = "&#1575;&#1604;&#1573;&#1587;&#1605;";
        listLabel = "قائمة الموظفين";
        list_title_page = "قائمة الموظفين";
        dir = "rtl";
        align = "center";
        textAlign = "right";
        rowsPerPageLabel = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1606;&#1578;&#1575;&#1574;&#1580; &#1601;&#1610; &#1575;&#1604;&#1589;&#1601;&#1581;&#1577;";

        pageLabel = "&#1589;&#1601;&#1581;&#1577;";
        ofLabel = "&#1605;&#1606;";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        goToPageNumber = "&#1575;&#1604;&#1573;&#1606;&#1578;&#1602;&#1575;&#1604; &#1573;&#1604;&#1610; &#1589;&#1601;&#1581;&#1577; &#1585;&#1602;&#1605;";
        defaultView = "&#1575;&#1604;&#1608;&#1590;&#1593; &#1575;&#1604;&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1610;";
        refreshSearchLabel = "&#1576;&#1581;&#1579; / &#1573;&#1593;&#1575;&#1583;&#1577; &#1576;&#1581;&#1579;";

    } else {
        name = "Name";
        listLabel = "Employee List";
        list_title_page = "Employee List";
        dir = "ltr";
        align = "center";
        textAlign = "left";
        rowsPerPageLabel = "Number of rows per page";
        pageLabel = "Page";
        ofLabel = "of";
        cancel = "Close";
        goToPageNumber = "Go To Page Number";
        defaultView = "Default View";
        refreshSearchLabel = "Refresch / Search";
        sawper = imgLastPage;
        imgLastPage = imgFirstPage;
        imgFirstPage = sawper;
        sawper = imgNext;
        imgNext = imgBack;
        imgBack = sawper;
        sawper = imgNextDisable;
        imgNextDisable = imgBackDisable;
        imgBackDisable = sawper;
    }

    if (!canNext) {
        imgNext = imgNextDisable;
    }
    if (!canBack) {
        imgBack = imgBackDisable;
    }

    List<WebBusinessObject> data = (List<WebBusinessObject>) request.getAttribute("data");
    WebBusinessObject wbo = null;
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=list_title_page%></title>
        <script TYPE="text/javascript" LANGUAGE="JavaScript" SRC="js/lib/jquery/core/jquery-1.6.4.min.js" ></script>
        <script TYPE="text/javascript" LANGUAGE="JavaScript" SRC="js/common.js" ></script>
        <script TYPE="text/javascript" LANGUAGE="JavaScript" SRC="js/jquery-1.2.6.min.js" ></script>
        <script TYPE="text/javascript" LANGUAGE="JavaScript" SRC="js/silkworm_validate.js" ></script>
        <link type="text/css" rel="stylesheet" href="css/content_<%=stat%>.css" />
        <script TYPE="text/javascript" LANGUAGE="JavaScript">
            $('input').keyup(function() {
                $this = $(this);
                if ($this.val().length == 1)
                {
                    var x = new RegExp("[\x00-\x80]+");
                    var isAscii = x.test($this.val());
                    if (isAscii)
                    {
                        $this.css("direction", "ltr");
                    }
                    else
                    {
                        $this.css("direction", "rtl");
                    }
                }
            });
        </script>
        <style type="text/css">
            td,th{padding: 5px;}
            td{
                background-color: #d3d5d4;
            }
            th{
                background-color: #4c85b4;
                color: #aed5de;
            }
            a{ text-decoration: none; }

            #content tr:hover{background: #aed5de; }
        </style>
        <script type="text/javascript">

            function submitForm(url) {
                document.LIST_COST_CENTERS_FORM.action = url;
                document.LIST_COST_CENTERS_FORM.submit();
            }

            function refreshForm() {
                var fieldName = document.getElementById('fieldName').value;
                var fieldValue = getASSCIChar(getOperationOrFieldValue("fieldValue"));

                var operation = getOperationOrFieldValue("operator");

                var rowsPerPage = 10;
                var selectionType = "single";
                try {
                    rowsPerPage = document.getElementById("rowsPerPage").value;
                } catch (e) {
                }
                var url = "<%=context%>/CampaignServlet?op=getSearchForEmployee&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType;
                if (fieldName != null) {
                    url += "&fieldName=" + fieldName;
                    if (fieldValue != null || fieldValue != "") {
                        url += "&fieldValue=" + fieldValue + "&operation=" + operation;
                    }
                }
                submitForm(url);
            }

            function checkDirction() {
                var dir = 'rtl';
                return dir;
            }
            function goToPage(pageIndex) {
                var fieldName = document.getElementById('fieldName').value;

                var rowsPerPage = 10;
                var selectionType = "single";
                try {
                    rowsPerPage = document.getElementById("rowsPerPage").value;
                } catch (e) {
                }
                var fieldValue = getASSCIChar(getOperationOrFieldValue("fieldValue"));
                var operation = getOperationOrFieldValue("operator");


                var url = "<%=context%>/CampaignServlet?op=getSearchForEmployee&Index=" + pageIndex + "&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType;

                if (fieldName != null) {
                    url += "&fieldName=" + fieldName;
                    if (fieldValue != null || fieldValue != "") {
                        url += "&fieldValue=" + fieldValue + "&operation=" + operation;// + "&newRelation=<%--=newRelation--%>";
                    }
                }
                submitForm(url);
            }

            function defaultView() {
                var fieldName = document.getElementById('fieldName').value;
                var fieldValue = "";
                var operation = "";
                var rowsPerPage = 10;

                var url = "<%=context%>/CampaignServlet?op=getSearchForEmployee&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType;
                if (fieldName != null) {
                    url += "&fieldName=" + fieldName;
                    if (fieldValue != null || fieldValue != "") {
                        url += "&fieldValue=" + fieldValue;
                    }
                }
                submitForm(url);
            }

            function sendEmployeeInfo(id, name) {
                    window.opener.jQuery("[name=employeeID]").val(id);
                    window.opener.jQuery("[name=employeeName2]").val(name);
                    window.opener.jQuery("[name=employeeName2]").select();
                    window.close();
//                }
            }
        </script>
    </head>
    <body>
        <div class="content" align="center" dir="<%=dir%>" style="position:relative; overflow:auto;">
            <form method="post" name="LIST_COST_CENTERS_FORM" action="">
                <DIV align="left" STYLE="color:blue;">
                    <button  onclick="JavaScript: closeForm();" class="button"> <%=cancel%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                    <button  onclick="JavaScript: defaultView();" class="button"> <%=defaultView%> </button>
                </DIV>
                <fieldset class="border" style="width: auto;">
                    <legend class="title center"><b><%=listLabel%></b></legend>
                    <div style="padding: 5px; background: #d3d5d4;">
                        <TABLE ID="tableSearch" class="blueBorder" ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="90%">
                            <%
                                List<FilterCondition> conditions = filter.getConditions();
                                if (conditions.size() > 0) {
                                    FilterCondition fcond = conditions.get(0);
                                    String field_name = fcond.getFieldName().toString();
                                    String field_value = fcond.getValue().toString();
                            %>
                            <TR>
                                <TD CLASS="" STYLE="text-align: <%=textAlign%>;font-size:15px;">
                                    <input type="hidden" name="fieldName" id="fieldName" value="<%=field_name%>" /><b><%=name%> :</b>
                                </TD>
                                <TD CLASS="" STYLE="text-align: <%=textAlign%>;" id="CellData" colspan="2">
                                    <input type="text" dir="ltr" value="<%=field_value%>" name="fieldValue" ID="fieldValue" size="30" />&ensp;
                                    <button id="btnSearch" value="" style="text-align: <%=textAlign%>;" ONCLICK="JavaScript: refreshForm()" ><img src="images/refresh.png" alt="<%=refreshSearchLabel%>" title="<%=refreshSearchLabel%>" align="middle" width="24" height="24"/></button>
                                </TD>
                            </TR>
                            <%}%>
                        </TABLE>
                    </div>
                    <div>&nbsp;</div>
                    <div>
                        <table width="500">
                            <tr>
                                <%
                                    Short colsNo = 3;
                                %>
                                <td colspan="<%=colsNo%>">
                                    <% if (numberPages > 1) {%>
                                    <TABLE ALIGN="CENTER" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" style="border: none; margin-bottom: 10px; margin-top: 10px" width="95%">
                                        <TR>
                                            <TD dir="<%=dir%>" style="border: none" align="center">
                                                <a href="JavaScript: goToPage('0');"><img alt="First Page" title="First Page" src="<%=imgFirstPage%>" width="40" height="33" style="border: none; vertical-align: text-bottom" /></a>
                                                <a <% if (canBack) {%> href="JavaScript: goToPage('<%=(index - 1)%>');" <% }%>><img alt="Previous Page" title="Previous Page" src="<%=imgBack%>" width="40" height="33" style="border: none; vertical-align: text-bottom" /></a>

                                                <a <% if (canNext) {%> href="JavaScript: goToPage('<%=(index + 1)%>');" <% }%>><img alt="Next Page" title="Next Page" src="<%=imgNext%>" width="40" height="33" style="border: none; vertical-align: text-bottom"/></a>
                                                <a href="JavaScript: goToPage('<%=(numberPages - 1)%>');"><img alt="Last Page" title="Last Page" src="<%=imgLastPage%>" width="40" height="33" style="border: none; vertical-align: text-bottom;"/></a>
                                            </TD>
                                            <%int selectedPage = 0;%>
                                            <td><%=goToPageNumber%> :
                                                <select name="pages" onchange="JavaScript: goToPage(this.value);" >
                                                    <option value="" >--</option>
                                                    <%for (int pageIndex = 0; pageIndex < numberPages; pageIndex++) {%>
                                                    <option value="<%=pageIndex%>"
                                                            <%if (pageIndex == index) {%>
                                                            selected ="selected"
                                                            <% selectedPage = pageIndex;%>
                                                            <%}%>
                                                            ><%=pageIndex + 1%></option>
                                                    <%}%>
                                                </select>
                                            </td>
                                        </TR>
                                        <tr>

                                            <td colspan="2" style="text-align: center;">
                                                <font style="color: #000099; font-weight: bold; text-align: center" ><%=pageLabel%> :<%=selectedPage + 1%> <%=ofLabel%> <%=numberPages%></font>
                                                &nbsp;&nbsp;&nbsp; <%=rowsPerPageLabel%> : <input type="text" name="rowsPerPage" id="rowsPerPage" value="<%=rowsPerPage%>" maxlength="2" size="5" />
                                            </td>
                                        </tr>
                                    </TABLE>
                                    <% }%>
                                </td>
                            </tr>
                            <tr>
                                <th class="thTitle">
                                    #
                                </th>
                                <th class="thTitle">
                                    <label>الموظف</label>
                                </th>
                            </tr>
                            <%
                                int iTotal = 0;
                                String event = "single";
                                for (int i = 0; i < data.size(); i++) {
                                    wbo = (WebBusinessObject) data.get(i);
                                    String codeValue = wbo.getAttribute("userId").toString();
                                    String nameValue = "";
                                    try {
                                        nameValue = wbo.getAttribute("fullName").toString();
                                    } catch (Exception ex) {
                                        nameValue = "لا يوجد إسم عربي";
                                    }
                                    iTotal++;
                                    event = "onclick=\"return sendEmployeeInfo('" + codeValue + "', '" + nameValue + "')\"";
                            %>
                            <tr>
                                <td class="td2" style="width: 20px;">
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <%=iTotal%></font> </b>
                                    </a>
                                </td>
                                <td>
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <%=nameValue%> </font> </b>
                                        <input type="hidden" name="nameValue" value="<%=nameValue%>"/>
                                        <input type="hidden" name="codeValue" value="<%=codeValue%>"/>
                                    </a>
                                </td>
                            </tr>
                            <%}%>
                        </table>
                    </div>
                </fieldset>
            </form>
        </div>
    </body>
</html>
