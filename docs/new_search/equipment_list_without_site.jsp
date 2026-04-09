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

    String code, name, all, list_title_page, listLabel, dir, fieldValue, defaultView, cancel, msg,
            align = "center", textAlign = "right", searchResult, rowsPerPageLabel, pageLabel, ofLabel, goToPageNumber
            , refreshSearchLabel, siteNameLabel;
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;

    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    String context = metaDataMgr.getContext();

    String selectionType = "";

    selectionType = request.getParameter("selectionType");

    if (selectionType == null) {
        selectionType = "single";
    }

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

    String fieldId = "ID";
    String fieldName = "UNIT_NAME";
    String fieldCode   = "UNIT_NO";
    String elementId = "id", elementName = "unitName", elementCode = "unitNo";
    if (stat.equals("Ar")) {
        code = "&#1575;&#1604;&#1603;&#1608;&#1583;";  //
        name = "&#1575;&#1604;&#1573;&#1587;&#1605;";
        listLabel = "&#1602;&#1575;&#1574;&#1605;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        list_title_page = "&#1602;&#1575;&#1574;&#1605;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";

        fieldValue = "&#1602;&#1610;&#1605;&#1577; &#1575;&#1604;&#1581;&#1602;&#1604;";
        all = "&#1575;&#1604;&#1603;&#1604;";

        dir = "rtl";
        align = "center";
        textAlign = "right";

        searchResult = "&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1576;&#1581;&#1579;";

        rowsPerPageLabel = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1606;&#1578;&#1575;&#1574;&#1580; &#1601;&#1610; &#1575;&#1604;&#1589;&#1601;&#1581;&#1577;";

        pageLabel = "&#1589;&#1601;&#1581;&#1577;";
        msg = "\u0627\u0644\u0631\u062C\u0627\u0621 \u0627\u062E\u062A\u064A\u0627\u0631 \u0648\u0627\u062D\u062F \u0623\u0648 \u0623\u0643\u062B\u0631 \u0645\u0646 \u0627\u0644\u062C\u062F\u0627\u0648\u0644 \u060C \u0623\u0648 \u0625\u0636\u063A\u0637 \u0639\u0644\u0649 \u0625\u0646\u0647\u0627\u0621 \u0644\u0644\u062E\u0631\u0648\u062C \u0645\u0646 \u0627\u0644\u0635\u0641\u062D\u0629.";
        ofLabel = "&#1605;&#1606;";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        goToPageNumber = "&#1575;&#1604;&#1573;&#1606;&#1578;&#1602;&#1575;&#1604; &#1573;&#1604;&#1610; &#1589;&#1601;&#1581;&#1577; &#1585;&#1602;&#1605;";
        defaultView = "&#1575;&#1604;&#1608;&#1590;&#1593; &#1575;&#1604;&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1610;";
        refreshSearchLabel = "&#1576;&#1581;&#1579; / &#1573;&#1593;&#1575;&#1583;&#1577; &#1576;&#1581;&#1579;";
        siteNameLabel = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    } else {

        code = "Code";  //
        name = "Name";
        listLabel = "Equipments List";
        list_title_page = "Equipments List";
        fieldValue = "Field Value";

        dir = "ltr";
        align = "center";
        textAlign = "left";

        all = "All";

        searchResult = "Search Result";

        rowsPerPageLabel = "Number of rows per page";
        msg = "Please select one or more schedule, Or Click close to exit page.";
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

        siteNameLabel = "Site";
    }

    if (!canNext) {
        imgNext = imgNextDisable;
    }
    if (!canBack) {
        imgBack = imgBackDisable;
    }

    List<WebBusinessObject> elementslist = (List<WebBusinessObject>) request.getAttribute("elementslist");
    WebBusinessObject wbo = null;
    Vector<WebBusinessObject> scheduleRelationTypes = new Vector<WebBusinessObject>(0);
    WebBusinessObject relationWbo = null;
    scheduleRelationTypes = (Vector<WebBusinessObject>)request.getAttribute("scheduleRelationTypes");
    StringBuilder relations = new StringBuilder("");
    String formName = (String) request.getAttribute("formName");
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
            
            function submitForm(url){

                url += '&formName=<%=formName%>';
                document.LIST_EQUIPMENTS_FORM.action = url;
                document.LIST_EQUIPMENTS_FORM.submit();
            }

            function refreshForm() {
                var fieldName = document.getElementById('fieldName').value;
                var fieldValue = getASSCIChar(getOperationOrFieldValue("fieldValue"));
                
                var operation  = getOperationOrFieldValue("operator");
                var rowsPerPage = 10;
                var selectionType = "single";
                try{
                    rowsPerPage = document.getElementById("rowsPerPage").value;
                } catch (e){}
                try{
                    selectionType = "<%=selectionType%>";
                }catch(ex){}
                var url = "<%=context%>/ReportsServlet?op=listEquipmentsWithoutSite&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType +"&goToViewEquipment=ok";
                if(fieldName != null){
                    url += "&fieldName=" + fieldName;
                    if(fieldValue != null || fieldValue != ""){
                        url += "&fieldValue=" + fieldValue;// + "&newRelation=<%--=newRelation--%>";
                    }
                }
                submitForm(url);
            }

            function goToPage(pageIndex) {
                var fieldName = document.getElementById('fieldName').value;
                var rowsPerPage = 10;
                var selectionType = "single";
                try{
                    rowsPerPage = document.getElementById("rowsPerPage").value;
                } catch (e){}
                try{
                    selectionType = "<%=selectionType%>";
                }catch(ex){}

                //var sites = document.getElementById('site').value;
                var fieldValue = getASSCIChar(getOperationOrFieldValue("fieldValue"));
                var operation  = getOperationOrFieldValue("operator");
                var url = "<%=context%>/ReportsServlet?op=listEquipmentsWithoutSite&Index=" + pageIndex + "&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType +"&goToViewEquipment=ok";
                if(fieldName != null){
                    url += "&fieldName=" + fieldName;
                    if(fieldValue != null || fieldValue != ""){
                        url += "&fieldValue=" + fieldValue + "&operation=" + operation;// + "&newRelation=<%--=newRelation--%>";
                    }
                    //url += "&sites=" + sites;
                }
                submitForm(url);
            }
                        
            function defaultView(){
                var fieldName = document.getElementById('fieldName').value;
                var fieldValue = "";
                var operation  = "";
                var rowsPerPage = 10;
                
                try{
                    selectionType = "<%=selectionType%>";
                }catch(ex){}
                var url = "<%=context%>/ReportsServlet?op=listEquipmentsWithoutSite&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType +"&goToViewEquipment=ok";
                if(fieldName != null){
                    url += "&fieldName=" + fieldName;
                    if(fieldValue != null || fieldValue != ""){
                        url += "&fieldValue=" + fieldValue;
                    }
                }
                submitForm(url);
            }

            function sendInfo(elementCodeValue,elementNameValue) {

                window.opener.document.<%=formName%>.elementIdValue.value = elementCodeValue;
                window.opener.document.<%=formName%>.elementNameValue.value = elementNameValue;
                window.close();
              }
        </script>
    </head>
    <body>
        <div class="content" align="center" dir="<%=dir%>" style="position:relative; overflow:auto;">
            <form method="post" name="LIST_EQUIPMENTS_FORM" action="">
                <DIV align="left" STYLE="color:blue;">
                    <%if (selectionType.equalsIgnoreCase("multi")) {%>
                    
                    <button  type=button STYLE=" " ONMOUSEDOWN="sendInfo();"  style="background: url(images/buttonBlue.jpg) repeat-x top center; border: 1px solid #999;
                             -moz-border-radius: 5px; padding: 5px; color: black; font-weight: bold;
                             -webkit-border-radius: 5px; font-size: 13px;  width: 90px; hieght:60px; " > <font color="black" ></font>Done</button>
                
                <%}%>
                <button  onclick="JavaScript: closeForm();" class="button"> <%=cancel%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript: defaultView();" class="button"> <%=defaultView%> </button>
                </DIV>
                
                
                <fieldset class="border" style="width: auto;">
                    <legend class="title center"><b><%=listLabel%></b></legend>

                    <div style="padding: 5px; background: #d3d5d4;">
                        <TABLE ID="tableSearch" class="blueBorder" ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="90%">
                            <%

                                //fields names, fields values  and operation
                                List<FilterCondition> conditions = filter.getConditions();

                                if (conditions.size() > 0) {
                                    for (int j = 0; j < conditions.size(); j++) {

                                        FilterCondition fcond = conditions.get(j);
                                        String field_name = fcond.getFieldName().toString();
                                        String field_value = fcond.getValue().toString();
                                        String operation = fcond.getOperation().toString();

                                        String selectedCode = "";
                                        String selectedName = "";

                                        if (field_name.equalsIgnoreCase(fieldId)) {
                                            selectedCode = "selected";
                                        } else if (field_name.equalsIgnoreCase(fieldName)) {
                                            selectedName = "selected";
                                        }
                                        String inputType = "text";
                                        if(j >= 1){
                                            inputType = "hidden";
                                            %>
                                            <input type="hidden" value="<%=field_value%>" name="site" id="site" />
                                            <%
                                        } else {


                            %>
                            <TR>
                                <TD CLASS="" STYLE="text-align: <%=textAlign%>;font-size:15px;">
                                    <select id="fieldName">
                                        <option value ="<%=fieldCode%>" <%=selectedCode%>><%=code%></option>
                                        <option value ="<%=fieldName%>" <%=selectedName%>><%=name%></option>
                                    </select>
                                </TD>
                                <TD CLASS="" STYLE="text-align: <%=textAlign%>;" id="CellData" colspan="2">
                                    <input type="<%=inputType%>" dir="ltr" value="<%=field_value%>" name="fieldValue" ID="fieldValue" size="30" />&ensp;
                                    <button id="btnSearch" value="" style="text-align: <%=textAlign%>;" ONCLICK="JavaScript: refreshForm()" ><img src="images/refresh.png" alt="<%=refreshSearchLabel%>" title="<%=refreshSearchLabel%>" align="middle" width="24" height="24"/></button>
                                </TD>
                            </TR>
                            <% } }
                                }%>
                        </TABLE>
                    </div>
                    <div>&nbsp;</div>
                    <div>
                        <table width="500">
                            <tr>
                                <%
                                Short colsNo = 4;
                                if(selectionType.equalsIgnoreCase("multi")){
                                    colsNo = 4;
                                }%>
                                <td colspan="<%=colsNo%>">
                                    <% if (numberPages > 1) {%>
                                    <TABLE ALIGN="CENTER" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" style="border: none; margin-bottom: 10px; margin-top: 10px" width="95%">
                                        <TR>
                                            <TD dir="<%=dir%>" style="border: none" align="center">
                                                <a href="JavaScript: goToPage('0');"><img alt="First Page" title="First Page" src="<%=imgFirstPage%>" width="40" height="33" style="border: none; vertical-align: text-bottom" /></a>
                                                <a <% if (canBack) {%> href="JavaScript: goToPage('<%=(index - 1)%>');" <% }%>><img alt="Previous Page" title="Previous Page" src="<%=imgBack%>" width="40" height="33" style="border: none; vertical-align: text-bottom" /></a>
                                                &ensp;
                                                <% for (int indexPage = startPage; indexPage < endPage; indexPage++) {%>
                                                <!--<a href="JavaScript: goToPage('<%=(indexPage)%>');" class="pagingStyle"
                                                <% if (index == indexPage) {%>

                                                style="background-image: url('images/bg_paging_selected.png'); color: #F3D596; border-bottom-width: 10px;margin-bottom: 0; margin-right: 0px; margin-top: 0;  padding: 12px 6px 1px;"
                                                <% } else {%>
                                                style="background-image: url('images/bg_paging.png'); border-bottom-width: 10px;margin-bottom: 0; margin-right: 0px; margin-top: 0; padding: 12px 6px 1px;" onmouseover="this.style.backgroundImage = 'url(images/bg_paging_highlit.png)'" onmouseout="this.style.backgroundImage = 'url(images/bg_paging.png)'"
                                                <% }%> >

                                                <%--=(indexPage + 1)--%>

                                                <!--</a>-->

                                                <% }%>
                                                &ensp;
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
                                <%if (selectionType.equalsIgnoreCase("multi")) {%>
                                <th class="thTitle" style="width: 20px;">
                                    <input type="checkbox" id="checkAll" onclick="CheckAll(this.id, 'relatedunitNos');" value=""/>
                                </th>
                                <%}%>
                                <th class="thTitle">
                                    <%=code%>
                                </th>
                                <th class="thTitle">
                                    <%=name%>
                                </th>
                                <th class="thTitle">
                                    <%=siteNameLabel%>
                                </th>
                            </tr>
                            <%
                                int iTotal = 0;

                                String event = "single";

                                for (int i = 0; i < elementslist.size(); i++) {

                                    wbo = (WebBusinessObject) elementslist.get(i);
                                    String elementIdValue = wbo.getAttribute(elementId).toString();
                                    if(elementIdValue.equalsIgnoreCase((String)request.getAttribute(elementId))){
                                        continue;
                                    }
                                    String elementCodeValue = wbo.getAttribute(elementCode).toString();
                                    String elementNameValue = wbo.getAttribute(elementName).toString();
                                    iTotal++;
                                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                                    Vector siteVc = projectMgr.getOnArbitraryKey(wbo.getAttribute("site").toString(), "key");
                                    WebBusinessObject siteWbo = new WebBusinessObject();
                                    String siteName = new String();
                                    if(siteVc.size() > 0){
                                        siteWbo = (WebBusinessObject)siteVc.elementAt(0);
                                        siteName = siteWbo.getAttribute("projectName").toString();
                                    }
                                    

                            %>
                            <%if (selectionType.equalsIgnoreCase("single")) {
                                    event = "onclick=\"return sendInfo('" + elementCodeValue + "', '" + elementNameValue + "')\"";
                                }%>
                            <tr>
                                <td class="td2" style="width: 20px;">
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <%=iTotal%></font> </b>
                                    </a>
                                </td>
                                <%if (selectionType.equalsIgnoreCase("multi")) {%>
                                <td class="thTitle">
                                    <input type="checkbox" name="relatedunitNos" value="<%=elementCodeValue%>"/>
                                </td>
                                <%}%>
                                <td class="td2" style="width: 20px;">
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <%=elementCodeValue%></font> </b>
                                        <input type="hidden" name="id" value="<%=elementCodeValue%>"/>
                                    </a>
                                </td>
                                <td>
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <%=elementNameValue%> </font> </b>
                                        <input type="hidden" name="elementNameValue" value="<%=elementNameValue%>"/>
                                        <input type="hidden" name="id" value="<%=elementCodeValue%>"/>
                                    </a>
                                </td>
                                <td>
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <%=siteName%> </font> </b>
                                        <input type="hidden" name="elementNameValue" value="<%=elementNameValue%>"/>
                                        <input type="hidden" name="id" value="<%=elementCodeValue%>"/>
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
