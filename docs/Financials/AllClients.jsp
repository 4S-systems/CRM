<%@page import="java.text.SimpleDateFormat"%>
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
            align = "center", textAlign = "right", searchResult, rowsPerPageLabel, pageLabel, ofLabel, goToPageNumber, refreshSearchLabel;
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;

    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    String context = metaDataMgr.getContext();

    String selectionType = "single";


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
        name = "إسم العميل";
        listLabel = "قائمة العملاء";
        list_title_page = "قائمة الوحدات";

        fieldValue = "&#1602;&#1610;&#1605;&#1577; &#1575;&#1604;&#1581;&#1602;&#1604;";
        all = "&#1575;&#1604;&#1603;&#1604;";

        dir = "rtl";
        align = "center";
        textAlign = "right";

        searchResult = "&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1576;&#1581;&#1579;";

        rowsPerPageLabel = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1606;&#1578;&#1575;&#1574;&#1580; &#1601;&#1610; &#1575;&#1604;&#1589;&#1601;&#1581;&#1577;";

        pageLabel = "&#1589;&#1601;&#1581;&#1577;";
        msg = ".من فضلك اختار عميل";
        ofLabel = "&#1605;&#1606;";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        goToPageNumber = "&#1575;&#1604;&#1573;&#1606;&#1578;&#1602;&#1575;&#1604; &#1573;&#1604;&#1610; &#1589;&#1601;&#1581;&#1577; &#1585;&#1602;&#1605;";
        defaultView = "&#1575;&#1604;&#1608;&#1590;&#1593; &#1575;&#1604;&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1610;";
        refreshSearchLabel = "&#1576;&#1581;&#1579; / &#1573;&#1593;&#1575;&#1583;&#1577; &#1576;&#1581;&#1579;";
    } else {
        name = "Client Name";
        listLabel = "Clients List";
        list_title_page = "Clients List";
        fieldValue = "Field Value";

        dir = "ltr";
        align = "center";
        textAlign = "left";

        all = "All";

        searchResult = "Search Result";

        rowsPerPageLabel = "Number of rows per page";
        msg = "Please select Client, Or Click close to exit page.";
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

    List<WebBusinessObject> clientsLst = (List<WebBusinessObject>) request.getAttribute("clientsLst");
    WebBusinessObject wbo = null;
    String fieldId = "id";
    String fieldName = "name";
//    String fieldCode = "sodicId";

    String tableNameField = "PROJECT_NAME", tableIdField = "PROJECT_ID";//, tableCodeField = "SODIC_ID";
    String filteredVal = (String) request.getAttribute("fieldValue");
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

                document.LIST_USERS_FORM.action = url;
                document.LIST_USERS_FORM.submit();
            }
            
            function sendInfo(id, name) {
                
                window.opener.document.getElementById('clientID').value = id;
                window.opener.document.getElementById('clientName').value = name;
                
                window.close();

            }
            function refreshForm() {
                //fieldValue
                var fieldName = document.getElementById('fieldName').value;
                var fieldValue = document.getElementById('fieldValue').value;
                //var fieldValue = getASSCIChar(getOperationOrFieldValue("fieldValue"));
                
                var operation  = getOperationOrFieldValue("operator");
                
                var rowsPerPage = 10;
                var selectionType = "single";
                try{
                    rowsPerPage = document.getElementById("rowsPerPage").value;
                } catch (e){}
                try{
                    selectionType = "<%=selectionType%>";
                }catch(ex){}
                
                var url = "<%=context%>/ProjectServlet?op=getAllClients&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType+"&fieldValue="+fieldValue;
                
                submitForm(url);
            }

            function goToPage(pageIndex) {
                var rowsPerPage = 10;
                //alert('index--= '+pageIndex);
                var selectionType = "single";
                try{
                    rowsPerPage = document.getElementById("rowsPerPage").value;
                } catch (e){}
                try{
                    selectionType = "<%=selectionType%>";
                }catch(ex){}
                var url = "<%=context%>/UsersServlet?op=listUnattachedEmployees&Index=" + pageIndex + "&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType;
                submitForm(url);
            }
            
            
            function send_Info(){
                //alert('entered to send');
                var row;
                var insertedTable = window.opener.document.getElementById('tblData');
                var check = document.getElementsByName('relatedEmpsIds');
                //alert('check '+check);
                var length = check.length;
               // alert('length='+length)
                var mgrId = document.getElementsByName('<%=fieldId%>');
//                var sodicId = document.getElementsByName('<//%=fieldCode%>');
                var fullName = document.getElementsByName('<%=fieldName%>');
                var commentsArr = document.getElementsByName('comments');
                
                var lastrow = insertedTable.rows.length;
                var checkex = 0;                
                var count = 0;
                var insertCount = 0;
                
                for(var i = 0; i < length; i++){
                   // alert('values: mgrId= '+mgrId[i].value+'sodicId= '+sodicId[i].value+'userName= '+userName[i].value);
                    if(check[i].checked == true){
                      //  alert('test');
                        if(!opener.window.users[mgrId[i].value]){
                           // alert('test');
                           ++insertCount;
                            row = insertedTable.insertRow(insertCount);   
                    
                            insert_Cells(row, lastrow, count + lastrow, fullName[i].value, mgrId[i].value, commentsArr[i].value);
                        
                            count++; 
                        } else { 
                            //alert('test');
                        //    alert(userName[i].value+' alredy choosed');
                        }
                    }
                }
                if(count > 0){
                    this.close();
                }else{
                    
                    alert("<%=msg%>");
                    
                }
            }
            
            function insert_Cells(row, order,index,fullName,userId,  comments){
        
                var classname="silver_odd_main";
                if(index%2==0)
                    classname="silver_even_main";
            
                var cell0 = row.insertCell(0);
                var cell1 = row.insertCell(1);                           
                var cell2 = row.insertCell(2);                            
                var cell3 = row.insertCell(3);
                var cell4 = row.insertCell(4);
                var cell5 = row.insertCell(5);
                                
                cell0.className = classname;
                cell0.innerHTML = '<input type="hidden" name="index" id="index" size="10" value="'+index+'" /><span id="order" name="order" value="'+index+'">' +index+ "</span><input type=\"hidden\" name=\"empTwo\" value="+ userId +" />";
               
                
                cell1.className =classname;
                cell1.innerHTML = 0;
                
                cell2.className = classname;
                cell2.innerHTML = fullName+
                    '<input type="hidden" name="userName" id="userName'+order+'" value="'+fullName+'" />';
                
                cell3.className = classname;
                cell3.innerHTML = '<input type="text" name="comments" id="comments" size="10" value="'+comments+'" />';
                
                cell4.className = classname;
                cell4.innerHTML = '<div id="save'+index+'" class="save" style="background-position: bottom;margin-left:auto;margin-right:auto" onclick="upsertSiteRelation(this, '+index+')"></div>';
                  
                cell5.className = classname;
                cell5.innerHTML = '<div class="remove" onclick="remove2(this)" id="'+userId+'" title="'+ userId +'" style="margin-left:auto;margin-right:auto" ></div>';
                              
                opener.window.users[userId]=1;

            }
            
            function defaultView(){
                var rowsPerPage = 10;
                
                try{
                    selectionType = "<%=selectionType%>";
                }catch(ex){}
                var url = "<%=context%>/UsersServlet?op=listUnattachedEmployees&rowsPerPage=" + rowsPerPage + "&selectionType=" + selectionType;
                
                submitForm(url);
            }
            
            
        </script>
    </head>
    <body>
        <div class="content" align="center" dir="<%=dir%>" style="position:relative; overflow:auto;">
            <form method="post" name="LIST_USERS_FORM" action="">
                <DIV align="left" STYLE="color:blue;">
                    <%if (selectionType.equalsIgnoreCase("multi")) {%>

                    <button  type=button STYLE=" " ONMOUSEDOWN="send_Info();"  style="background: url(images/buttonBlue.jpg) repeat-x top center; border: 1px solid #999;
                             -moz-border-radius: 5px; padding: 5px; color: black; font-weight: bold;
                             -webkit-border-radius: 5px; font-size: 13px;  width: 90px; hieght:60px; " > <font color="black" ></font>Done</button>

                    <%}%>
                    <button  onclick="JavaScript: closeForm();" class="button"> <%=cancel%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                    <button  onclick="JavaScript: defaultView();" class="button"> <%=defaultView%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                </DIV>


                <fieldset class="border" style="width: auto;">
                    <legend class="title center"><%=listLabel%></legend>

                    <div style="padding: 5px; background: #d3d5d4;">
                        <TABLE ID="tableSearch" class="blueBorder" ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="90%">
                            
                            <TR>
                                <TD CLASS="" STYLE="text-align: <%=textAlign%>;font-size:15px;">
                                    <input type="hidden" name="fieldName" id="fieldName"  value="NAME"/><b><%=name%> :</b>
                                </TD>
                                <TD CLASS="" STYLE="text-align: <%=textAlign%>;" id="CellData" colspan="2">
                                    <input type="text" dir="ltr" name="fieldValue" ID="fieldValue" size="30" value="<%=filteredVal != null ? filteredVal : ""%>"/>&ensp;
                                    <button id="btnSearch" value="" style="text-align: <%=textAlign%>;" ONCLICK="JavaScript: refreshForm()" ><img src="images/refresh.png" alt="<%=refreshSearchLabel%>" title="<%=refreshSearchLabel%>" align="middle" width="24" height="24"/></button>
                                </TD>
                            </TR>
                        </TABLE>
                    </div>
                    <div>&nbsp;</div>
                    <div>
                        <table width="500">
                            <tr>
                                <%
                                    Short colsNo = 3;
                                    if (selectionType.equalsIgnoreCase("multi")) {
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
                                    <input type="checkbox" id="checkAll" onclick="CheckAll(this.id, 'relatedEmpsIds');" value=""/>
                                </th>
                                <%}%>

                                <th class="thTitle">
                                    <%=name%>
                                </th>
                            </tr>
                            <%
                                int iTotal = 0;

                                String event = "single";
                                String idValue, nameValue, codeValue;
                                        String comments="";

                                for (int i = 0; i < clientsLst.size(); i++) {

                                    wbo = (WebBusinessObject) clientsLst.get(i);
                                    idValue = wbo.getAttribute(fieldId).toString();
                                    nameValue = wbo.getAttribute(fieldName).toString();
//                                    codeValue = wbo.getAttribute(fieldCode).toString();
                                    iTotal++;


                            %>
                                   <% event = "onclick=\" sendInfo('" + idValue + "', '" + nameValue + "')\"";%>
                            <tr>
                                <td class="td2" style="width: 20px;">
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <%=iTotal%></font> </b>
                                    </a>
                                </td>
                                <%if (selectionType.equalsIgnoreCase("multi")) {%>
                                <td class="thTitle">
                                    <input type="checkbox" name="relatedEmpsIds" value="<%=idValue%>"/>
                                </td>
                                <%}%>
<!--                                <td class="td2" style="width: 20px;">
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <//%=codeValue%></font> </b>
                                    </a>
                                </td>-->
                                <td>
                                    <a  href="#" <%=event%>>
                                        <b style="text-decoration: none"><font color="black" size="3"> <%=nameValue%> </font> </b>
                                        <input type="hidden" name="<%=fieldName%>" value="<%=nameValue%>"/>
                                        <input type="hidden" name="<%=fieldId%>" value="<%=idValue%>"/>
                                        <!--<input type="hidden" name="<//%=fieldCode%>" value="<//%=codeValue%>"/>-->
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
