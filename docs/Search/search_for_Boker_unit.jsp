<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
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
    <fmt:setBundle basename="Languages.Units.Units"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        String clientID = (String)request.getAttribute("clientID");
        
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        ArrayList<WebBusinessObject> projectsLst = (ArrayList<WebBusinessObject>) request.getAttribute("projects");

        String stat = (String) request.getSession().getAttribute("currentMode");
        
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String toDate = request.getAttribute("toDate") != null ? (String) request.getAttribute("toDate") : sdf.format(c.getTime());
        c.add(Calendar.WEEK_OF_MONTH, -1);
        
        String fromDate = request.getAttribute("fromDate") != null ? (String) request.getAttribute("fromDate") : sdf.format(c.getTime());

        String[] tableHeader = new String[4];
        String align = null;
        String dir = null;
        String style = null;
        String sTitle, message;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Broker Units";
            tableHeader[0] = "id";
            tableHeader[1] = "username";
            tableHeader[2] = "email";
            tableHeader[3] = "full name";
            message = "";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "وحدات السمسرة";
            tableHeader[0] = "رقم العميل";
            tableHeader[1] = "إسم العميل";
            tableHeader[2] = "رقم الموبايل";
            tableHeader[3] = "الايميل";
            message = "";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <link rel="stylesheet" type="text/css" href="js/jquery.dataTables.css">
    </HEAD>
    <script type="text/javascript">

        var oTable;
        var users = new Array();
        $(document).ready(function () {
            $(".projectsTbl").dataTable({
                "bJQueryUI": true,
                "aLengthMenu": [[10, 20, 50, 100, -1], ["10", "20", "50", "100", "All"]],
                "iDisplayLength": 10,
                "bPaginate": true,
                "bProcessing": true,
                "aaSorting": [[0, "asc"]]
            });
        });

        $(function () {
            $("#fromDate, #toDate").datepicker({
                changeMonth: true,
                changeYear: true,
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
        });
        
        function AddToCart(projectID, productCategoryID, productCategoryName, projectName)
            {
                var clientID = <%=clientID%>;
                var userId = <%=loggedUser.getAttribute("userId")%>;
                
                var url = "<%=context%>/ClientServlet?op=addToCart";
                $.ajax({
                    type: "post",
                    url: url,
                    data: {
                        clientID: clientID,
                        projectID: projectID,
                        productCategoryID: productCategoryID,
                        productCategoryName: productCategoryName,
                        userId: userId,
                        projectName: projectName,
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.Status === 'Ok') {
                            alert("تمت الاضافه للمعاينات");
                        } else if (info.Status === 'No') {
                            alert("لم تتم الاضافه للمعاينات");
                        }
                        location.reload();
                    }
                });
            }

    </script>

    <style>
        #element_to_pop_up { display:none; }
        .titlebar {
            background-image: url(<%=context%>/jquery-ui/themes/base/images/ui-bg_highlight-soft_75_cccccc_1x100.png);
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
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
        #row:hover{
            background-color: #EEEEEE;
        }
        .client_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addclient.png);
        }
        .company_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addCompany.png);
        }
        .enter_call {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
        .show{
            display: block;
        }
        .hide{
            display: none;
        }
        .remove{

            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);

        }
        #showHide{
            /*background: #0066cc;*/
            border: none;
            padding: 10px;
            font-size: 16px;
            font-weight: bold;
            color: #0066cc;
            cursor: pointer;
            padding: 5px;
        }
        #dropDown{
            position: relative;
        }
        .backStyle{
            border-bottom-width:0px;
            border-left-width:0px;
            border-right-width:0px;
            border-top-width:0px
        }

        .datepick {}

        .save {
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .silver_odd_main,.silver_even_main {
            text-align: center;
        }

        input { font-size: 18px; }
        textarea{
            resize:none;
        }
        .table td{
            padding:5px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            /*height:20px;*/
            border: none;
        }

        #claim_division {

            width: 97%;
            display: none;
            margin:3px auto;
            border: 1px solid #999;
        }
        #order_division{

            width: 97%;
            display: none;
            margin:3px auto;
            border: 1px solid #999;
        }
        label{
            font:Verdana, Geneva, sans-serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
        }
        .login {
            /*display: none;*/
            direction: rtl;
            margin: 20px auto;
            padding: 10px 5px;
            /*        width:30%;*/
            background: #3f65b7;
            background-clip: padding-box;
            border: 1px solid #ffffff;
            border-bottom-color: #ffffff;
            border-radius: 5px;
            color: #ffffff;

            background: #7abcff; /* Old browsers */
            /* IE9 SVG, needs conditional override of 'filter' to 'none' */
            /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
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
        .dropdown 
        {
            color: #555;

            /*margin: 3px -22px 0 0;*/
            width: 128px;
            position: relative;
            height: 17px;
            text-align:left;
        }
        .dropdown li a 
        {
            color: #555555;
            display: block;
            font-family: arial;
            font-weight: bold;
            padding: 6px 15px;
            cursor: pointer;
            text-decoration:none;
        }
        .dropdown li a:hover
        {
            background:#155FB0;
            color:yellow;
            text-decoration: none;
        }
        .submenux
        {

            background:#FFFFCC;
            position: absolute;
            top: 30px;
            left:0px;
            /*left: 0px;*/
            /*        z-index: 1000;*/
            width: 120px;
            display: none;
            margin-left: 0px;;
            padding: 0px 0 5px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
        }
        .submenuxx
        {

            background:#FFFFCC;
            position: absolute;
            top: 30px;
            left:30px;
            /*left: 0px;*/
            /*        z-index: 1000;*/
            width: 120px;
            display: none;
            margin-left: 0px;;
            padding: 0px 0 5px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
        }

        #call_center{
            direction:rtl;
            padding:0px;
            margin-top: 10px;
            /*        background-color: #dedede;*/
            margin-left: auto;
            margin-right: auto;
            margin-bottom: 5px;
            color:#005599;
            /*            height:600px;*/
            width:98%;
            /*position:absolute;*/
            border:1px solid #f1f1f1;
            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;

        }
        #title{padding:10px;
               margin:0px 10px;
               height:30px;
               width:95%;
               clear: both;
               text-align:center;

        }
        .text-success{
            font-family:Verdana, Geneva, sans-serif;
            font-size:24px;
            font-weight:bold;
        }

        #tableDATA th{

            font-size: 15px;
        }

        .save {
            width:32px;
            height:32px;
            background-image:url(images/icons/check.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .status{

            width:32px;
            height:32px;
            background-image:url(images/icons/status.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .remove {
            width:32px;
            height:32px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/remove.png);

        }
        .button_commx {
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            /**/
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/comm.png);
        }
        .button_attach{
            width:128px;
            height:27px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            /**/
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/attach.png);
        }
        .button_bookmar {
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/bookmark.png);
        }

        .button_redirec{
            width:132px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/redi.png);
        }

        .button_finis{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/finish.png);
        }

        .button_clos {
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/close.png);
        }
        .rejectedBtn{
            width:145px;
            height:40px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/button5.png);
        }
        .attach_button{
            width:145px;
            height:40px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/attachF.png);
        }

        .button_clientO{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/clientO.png);
            /*        background-position: top right;*/
        }.managerBt{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/manager.png);
            /*        background-position: top right;*/
        }
        .popup_conten{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 300px;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }
        .popup_content{ 
            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #dfdfdf;
            margin-bottom: 5px;
            width: 300px;
            height: 300px;
            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }

        #projectsTbl{
            width: 100%;
            margin-top: 20px;
        }
        #projectsTbl th{
            padding: 5px;
            font-size: 16px;
            background:#f1f1f1;
            font-family: arial;


        }
        #projectsTbl td{
            font-size: 12px;
            border: none;
        }
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <fieldset align=center class="set" style="width: 90%; border-color: #006699;">
            <font color="#005599" size="5"><%=sTitle%></font>
            <form id="client_form" action="<%=context%>/SearchServlet?op=BokerUnitsList&clientID=<%=clientID%>" method="post">
                <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white">
                                <fmt:message key="fromdate" /> 
                            </b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><fmt:message key="todate" />  </b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="width: 180px;" readonly/>
                            <br/><br/>
                            <input type="hidden" name="op" value="listAvailableApartments"/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="width: 180px;" readonly/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <TD STYLE="text-align:center" CLASS="td" colspan="2">  
                            <button type="submit" STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; width: 20%;">
                                <fmt:message key="search"/>
                                <IMG HEIGHT="15" SRC="images/search.gif" >
                            </button>
                        </td>
                    </tr>
                </table>
            </form>
            <FORM NAME="CLIENT_FORM" METHOD="POST">
                    <div style="width: 100%;">
                            <!--<table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td width="100%" class="titlebar">
                                        <font color="#005599" size="4"><%=sTitle%></font>
                                    </td>
                                </tr>
                            </table>-->
                            <br/>

                        <div style="width:60%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                            <TABLE class="projectsTbl" dir="<%=dir%>">
                                <THEAD>
                                    <TR></TR>
                                    <tr>
                                        <th><fmt:message key="cart"/></th>
                                        <%--<th><fmt:message key="mail"/></th>--%>
                                        <th><fmt:message key="owner"/></th>
                                        <th><fmt:message key="mobile"/></th>
                                        <th><fmt:message key="unit"/></th>
                                        <th><fmt:message key="project"/></th>
                                        <th><fmt:message key="ad"/></th>
                                    </tr>
                                </THEAD>
                                <tbody>
                                    <% for (int i = 0; i < projectsLst.size(); i++) {
                                            WebBusinessObject wbo = (WebBusinessObject) projectsLst.get(i);%>
                                        <TR>
                                            <TD  CLASS="cell">
                                                <img title=<fmt:message key="cart"/>  src="images/icons/cart.png" width="30" style="float: left;" onclick="AddToCart('<%=wbo.getAttribute("project_id")%>', '<%=wbo.getAttribute("productCategoryID")%>', '<%=wbo.getAttribute("productCategoryName")%>', '<%=wbo.getAttribute("projectName")%>');"/>
                                            </TD>
                                            <%--<TD  CLASS="cell">
                                                <img src="images/icons/mail1.png" width="25" style="float: left;" title=<fmt:message key="mail"/>/>
                                            </TD>--%>
                                            <TD  CLASS="cell">
                                                <%=wbo.getAttribute("ClientName")%> 
                                            </TD>

                                            <TD  CLASS="cell">
                                                <%=wbo.getAttribute("ClientMobile")%> 
                                            </TD>

                                            <TD  CLASS="cell" STYLE="padding-left:40;text-align:right;"> 
                                                <%=wbo.getAttribute("projectName")%>
                                            </TD>

                                            <TD  CLASS="cell" STYLE="padding-left:40;text-align:right;"> 
                                                <%=wbo.getAttribute("productCategoryName")%>
                                            </TD>

                                            <TD  CLASS="cell" STYLE="padding-left:40;text-align:right;"> 
                                                <%if (wbo.getAttribute("productDesc") == "UL" && !wbo.getAttribute("productDesc").equals("UL")){%>
                                                    <%=wbo.getAttribute("productDesc")%>
                                                <%} else {%>
                                                    <%=" "%>
                                                <%}%>
                                            </TD>
                                        </TR>
                                        <%}%>
                                    </tbody>
                                </TABLE>
                            </DIV>
                </div>
        </FIELDSET>
    </BODY>
</HTML>     
