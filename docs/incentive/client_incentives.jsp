<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Campaigns.Campaigns"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> clientIncentives = (ArrayList<WebBusinessObject>) request.getAttribute("clientIncentives");
        String[] incentiveTitles = (String[]) request.getAttribute("incentiveTitles");
       
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            var oTable,oTable2;
            $(document).ready(function() {
                oTable = $('#clientIncentives').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": false,
                    "bProcessing": false

                }).fadeIn(2000);
                
                oTable2 = $('#searchtable').dataTable({
                    bJQueryUI: true,
                    "bPaginate": false,
                    "bInfo":false,
                    "bFilter":false,
                    "bordering":false

                }).fadeIn(2000);
            });
            
            
            function submitForm()
            {
                document.CLIENT_INCENTIVE_FROM.action = "<%=context%>/IncentiveServlet?op=viewClientIncentives";
                document.CLIENT_INCENTIVE_FROM.submit();
            }
            $(function() {
                $("#startDate,#endDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function incentiveList(clientId) {
                $(".submenu_incentive").hide();
                var url = "<%=context%>/SeasonServlet?op=showIncentives&clientId=" + clientId;
                $('#add_incentives').load(url);
                $("#add_incentives").css("display", "block");
                $('#add_incentives').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
        </SCRIPT>
        <style>
            #products
            {
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }
            #products tr
            {
                padding: 5px;
            }
            #products td
            {  
                font-size: 12px;
                font-weight: bold;
            }
            #products select
            {                
                font-size: 12px;
                font-weight: bold;
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

                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
            }
            .login  h1 {

                font-size: 16px;
                font-weight: bold;

                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;

                margin-left: auto;
                margin-right: auto;
                text-height: 30px;


                color: #ffffff;

                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #cc0000;
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }

            .login-input {

                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #000;
                font-size: 13px;
                cursor: auto;
                text-shadow: 0 1px black;
                background: #2b3e5d;
                border: 1px solid #ffffff;
                border-top-color: #0d1827;
                border-radius: 4px;
                background: rgb(249,252,247);
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
            }
            
            .login-input:focus {
                outline: 0;
                background-color:  #ffa84c;;
                -webkit-box-shadow: inset 0 1px 2px #ffa84c, 0 0 4px 1px #ffa84c;
                box-shadow: inset 0 1px 2px #ffa84c, 0 0 4px 1px #ffa84c;
            }
            .lt-ie9 .login-input {
                line-height: 35px;
            }

            .login-submit {
                text-align: center;
                width: 30%;
                height: 37px;
                margin-top: 15px;
                margin-left: auto;
                margin-right: auto;
                margin-bottom: 15px;
                font-size: 14px;
                font-weight: bold;
                color: #294779;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #f1f1f1;
                background-clip: padding-box;
                border-radius: 4px;
                cursor: pointer;
                background: #cfe7fa;
                background: #f9fcf7;
                background: -moz-linear-gradient(top, #f9fcf7 0%, #f5f9f0 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#f9fcf7), color-stop(100%,#f5f9f0)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #f9fcf7 0%,#f5f9f0 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #f9fcf7 0%,#f5f9f0 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #f9fcf7 0%,#f5f9f0 100%); /* IE10+ */
                background: linear-gradient(to bottom, #f9fcf7 0%,#f5f9f0 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
            }
            .login-submit:active {
                background: #a4c2f3;
                -webkit-box-shadow: inset 0 1px 5px rgba(0, 0, 0, 0.4), 0 1px rgba(255, 255, 255, 0.1);
                box-shadow: inset 0 1px 5px rgba(0, 0, 0, 0.4), 0 1px rgba(255, 255, 255, 0.1);
            }

            .login-help {
                text-align: center;
            }
            .login-help  a {
                font-size: 11px;
                color: #d4deef;
                text-decoration: none;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
            }
            .login-help a:hover {
                text-decoration: underline;
            }
        </style>

    </head>
    <BODY>
        <FORM NAME="CLIENT_INCENTIVE_FROM" METHOD="POST">
           
            <fieldset align=center class="set" style="width: 50%">
                <legend align="center">
                            <font color="blue" size="6">
                                    <fmt:message key="clientincentives" />
                                </font>
                </legend>
                         <TABLE  ALIGN="CENTER" DIR="RTL" ID="code" width="50%" STYLE="border-width:1px;border-color:white;display: block; margin-top: 2%" >
                    <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white">
                                <fmt:message key="fromDate"/></b>
                        </TD>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white">
                                <fmt:message key="toDate"/></b>
                        </TD>
                    </TR>
                    <TR>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("startDate") == null ? "" : request.getAttribute("startDate")%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("endDate") == null ? "" : request.getAttribute("endDate")%>"/>
                        </td>
                    </TR>
                </TABLE>
                <BR/>
                &nbsp;
                <BR/>
                 <DIV align="center" STYLE="color:blue;">
                <input type="button"  value='<fmt:message key="print"/>'  onclick="submitForm()" class="button">
                    <input type="hidden" name="op" value="viewClientIncentives"/>
            </DIV>
                    <br/>
               
                <div style="width:70%;margin-right: auto;margin-left: auto;">
                    <TABLE ALIGN="center" dir=<fmt:message key="direction"/> id="clientIncentives" style="width:100%; display: <%=incentiveTitles != null ? "" : "none"%>">
                        <thead>
                            <TR>
                                <Th>
                                    <B>
                                        <fmt:message key="clienttittle"/></B>
                                </Th>
                                <%
                                    if (incentiveTitles != null) {
                                        for (String incentiveTitle : incentiveTitles) {
                                %>
                                <Th>
                                    <B><%=incentiveTitle%></B>
                                </Th>
                                <%
                                        }
                                    }
                                %>
                            </TR>
                        </thead>
                        <tbody>
                            <%
                                if (clientIncentives != null) {
                                    for (WebBusinessObject wbo : clientIncentives) {
                                        String clientName = (String) wbo.getAttribute("clientName");
                            %>
                            <TR>
                                <TD>
                                    <a href="#" onclick="JavaScript: incentiveList('<%=wbo.getAttribute("clientId")%>');"><%=clientName%></a>
                                </TD>
                                <%
                                    if (incentiveTitles != null) {
                                        for (String incentiveTitle : incentiveTitles) {
                                %>
                                <TD>
                                    <%=wbo.getAttribute(incentiveTitle) != null ? wbo.getAttribute(incentiveTitle) : "0"%>
                                </TD>
                                <%
                                                }
                                            }
                                        }
                                    }
                                %>
                            </TR>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
            </fieldset>
        </FORM>
        <div id="add_incentives" style="width: 30% !important;display: none;position: fixed ;"></div>
    </BODY>
</html>