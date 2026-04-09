<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    HttpSession s = request.getSession();
    WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
    ArrayList<WebBusinessObject> projectsList = (ArrayList) request.getAttribute("projectTree");
    int unitPrice = (int) request.getAttribute("unitPrice");
  
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />
  
    <head>
        <title>Unit Details</title>
        <link rel="stylesheet" href="css/demo_table.css">    
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <script type="text/javascript" src="js/jquery.carouFredSel-6.2.0.js"></script>
        <script type="text/javascript" src="js/jquery.transit.min.js"></script>
        <script type="text/javascript" src="js/jquery.mousewheel.min.js"></script>
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css" />
        <link REL="stylesheet" TYPE="text/css" HREF="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
    </head>

    <script type="text/javascript">
        var initialPrice;

        function closeOverlay() {
            $("#" + divID).hide();
            $("#overlay").hide();
        }

        function calcInitial()
        {
            initialPrice = (<%=unitPrice%> * $('#reservePrecen').val()) / 100;
            var rest = <%=unitPrice%> - initialPrice;
                    
            $('#initValue').html(initialPrice);
            for(var i=1; i<=5; i++){
                $('#installment'+i).html((rest/(12*i)).toFixed(0)+' / '+'<fmt:message key="month" />');
            }
        }
    </script>

    <style type="text/css">
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

        .image_carousel {
            padding: 15px 0 15px 40px;
            width: 100%;
            height: 100%;
            position: relative;
        }
        .image_carousel img {
            border: 1px solid #ccc;
            background-color: white;
            padding: 9px;
            margin: 7px;
            display: block;
            float: left;
        }
        a.prev, a.next {
            background: url(images/miscellaneous_sprite.png) no-repeat transparent;
            width: 45px;
            height: 50px;
            display: block;
            position: absolute;
            top: -40px;
        }
        a.prev {			
            left: 15px;
            background-position: 0 0; }
        a.prev:hover {		background-position: 0 -50px; }
        a.next {			right: -30px;
                   background-position: -50px 0; }
        a.next:hover {		background-position: -50px -50px; }

        a.prev span, a.next span {
            display: none;
        }
        .clearfix {
            float: none;
            clear: both;
        }
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
        .smallDialog {
            width: 320px;
            display: none;
            position: fixed;
            z-index: 1000;
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
    </style>

    <body>
        <FORM NAME="UNIT_FORM" id="new_location_type_Form" METHOD="POST">
            <fieldset class="set" style="border-color: #006699; width: 95%; min-height: 400px;">
                <TABLE class="backgroundTable" width="80%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR='<fmt:message key="direction" />'>
                    <TR>
                        <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> 
                    <fmt:message key="unitdetails" />
                            </FONT><BR></TD>
                    </TR>

                    <tr>
                        <td style="width: 600px; vertical-align: top;">
                            <TABLE class="backgroundTable" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR='<fmt:message key="direction" />'>
                                <%
                                    if (projectsList.size() > 0) {
                                        for (int i = 0; i < projectsList.size(); i++) {
                                            WebBusinessObject wbo = projectsList.get(i);
                                %>
                                <tr>
                                    <TD style="text-align:center; border:1px" class="backgroundHeader" id="CellData">
                                        <b style="margin-left: 5px;padding-left: 5px;font-weight: bold">
                                            <font size="3" color="black"><%=wbo.getAttribute("LocationTypeName")%>
                                        </b>
                                    </td>
                                    <TD style=" background-color: white">
                                        <b>
                                            <font size="3">
                                            <%=wbo.getAttribute("projectName")%>
                                            </font>
                                        </b>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>

                                <tr>
                                    <TD style=" text-align:center; border:1px" class="backgroundHeader" id="CellData">
                                        <b>
                                            <font size="3" color="black">
                                            <fmt:message key="unitprice" />
                                            </font>
                                        </b>
                                    </td>
                                    <TD style=" background-color: white">
                                        <b>
                                            <font color="red" size="3">
                                            <%
                                                if (unitPrice == 0) {
                                            %>
                                            الوحدة غير مسعرة
                                            <%
                                            } else {
                                            %>
                                            <%= unitPrice%>
                                            <%
                                                }
                                            %>
                                            </font>
                                        </b>
                                    </td>
                                </tr>

                                <%if (unitPrice > 0) {%>
                                <tr>
                                    <TD style=" text-align:center; border:1px" class="backgroundHeader" id="CellData">
                                        <b>
                                            <font size="3" color="black">
                                            <fmt:message key="depositperc" />
                                            </font>
                                        </b>
                                    </td>

                                    <TD style=" background-color: white">
                                        <input type="TEXT" style="width: 70%;text-align: center" name="reservePrecen" dir='<fmt:message key="direction" />' ID="reservePrecen"  size="15" maxlength="255"> %  
                                        <input type="button" id="calculate" value='<fmt:message key="calculate" />'  onClick="JavaScript: calcInitial();">
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>

                        </td>
                    </tr>
                </table>

                <br/>


                <%if (unitPrice > 0) {%>
                <TABLE class="backgroundTable" width="80%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR='<fmt:message key="direction" />'>
                    <TR>
                        <TD style="text-align:center;border-color: #006699;" colspan="2" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1">
                            
                            <fmt:message key="unitinstallment" /></FONT><BR></TD>
                    </TR>

                    <TR>
                        <TD style=" text-align:center; border:1px" width="50%" class="backgroundHeader" id="CellData">
                            <b style="margin-left: 5px;padding-left: 5px;font-weight: bold">
                                <font size="3" color="black">   
                                <fmt:message key="deposit" />
                                </font>
                            </b>
                        </td>

                        <TD style=" background-color: white" id="initValue">
                        </td>
                    </TR>

                    <TR>
                        <TD colspan="2">
                            <TABLE class="backgroundTable" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR='<fmt:message key="direction" />'>
                                <thead>
                                    <tr>
                                        <th style="color: #005599; font: 20px; font-weight: bold;" width="50%" class="blueBorder blueHeaderTD" >
                                         <fmt:message key="year" />
                                        </th>
                                        <th style="color: #005599; font: 20px; font-weight: bold;" width="50%" class="blueBorder blueHeaderTD">
                                         <fmt:message key="installment" />
                                        </th>
                                    </tr>
                                <thead>

                                <tbody>
                                    <%
                                        for (int i = 1; i <= 5; i++) {
                                    %>
                                    <tr>
                                        <TD style=" text-align:center; border:1px" width="50%" class="backgroundHeader">
                                            <%=i%>
                                        </td>
                                        <TD style=" text-align:center; border:1px" width="50%" class="backgroundHeader" id="installment<%=i%>">
                                        </td>    
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </TD>
                    </TR>
                </table>
                <%}%>
            </fieldset>
        </FORM>
    </body>
</html>