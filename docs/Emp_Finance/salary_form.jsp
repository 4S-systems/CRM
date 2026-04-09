<%@page import="com.businessfw.hrs.financials.SalaryItem"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    ArrayList<LiteWebBusinessObject> salaryItems = (ArrayList<LiteWebBusinessObject>) request.getAttribute("salaryItems");
    String empID = (String) request.getAttribute("empID");

    double total = 0.0;
%>

<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Employee.employee"  />

    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/responstable.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        <link rel="stylesheet" type="text/css" href="js/w2ui/w2ui-1.5.rc1.min.css" />

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/w2ui/w2ui-1.5.rc1.min.js"></script>
        <script>
            function submitForm() {

            }

            function print() {

            }
        </script>
        <style>

            table label {
                float: <fmt:message key="align" />;
                text-align: center;
            }

            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1;
            }

            tr:nth-child(even) td.dataTD {
                background: #FFF;
            }

            .table td {
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }

            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }

            .dataTD {
                float: <fmt:message key="align" />;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
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
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
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


                color: black;

                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .tbFStyle {
                background: silver;
                width: 25%; 
                text-align: right; 
                margin-bottom: 10px !important; 
                margin-left: 135px; 
                margin-right: auto; 
                letter-spacing: 35px;
                border-radius: 10px;
                padding-right: 20px;
            }
            .detailTD {
                background-color: white;
            }
        </style>  
    </head>

    <body>
        <table border="0px" class="table tbFStyle" style="margin-top: -10px">
            <tr style="padding: 0px 0px 0px 50px;">
                <td class="td" style="text-align: center;">
                    <a title="Back" style="padding: 5px;">
                        <image style="height:42px;" src="images/icons/BACKNEWTO.png" onclick="window.history.go(-1);"/>
                    </a>
                    <a title="Save" href="#" onclick='submitForm();' style="padding: 5px;">
                        <image style="height:42px;" src="images/icons/SAVENEWTO.png"/>
                    </a>
                    <a title="Print" href="#" onclick='print();' style="padding: 5px;">
                        <image style="height:42px;" src="images/printer2.png"/>
                    </a>
                </td>
            </tr>
        </table>

        <fieldset class="set backstyle" style="width:90%; border-color: #006699;">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="direction: <fmt:message key="dir" />;">
                <tr>
                    <td class="titlebar" style="text-align: center">
                        <font color="#005599" size="4">
                        <fmt:message key="salarySheet" /> 
                        </font>
                    </td>
                </tr>
            </table>

            <br/>

            <form name="Salary_FORM">
                <input type="hidden" name="empID" value="<%=empID%>"/>
                
                <table border="1" style="width: 90%;margin-bottom: 5%;" dir="<fmt:message key="dir"/>">
                    <thead>
                        <tr>
                            <th class="td titleTD"><fmt:message key="salaryCode"/></th>
                            <th class="td titleTD"><fmt:message key="salaryItem"/></th>
                            <th class="td titleTD"><fmt:message key="salaryItemValue"/></th>
                            <th class="td titleTD"><fmt:message key="salaryType"/></th>
                            <th class="td titleTD"><fmt:message key="salaryItemTotal"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (salaryItems != null) {
                                SalaryItem salryItem;
                                double amount;
                                String salaryItemValue = "";
                                String salaryItemType = "";
                                LiteWebBusinessObject costItemWbo;

                                for (LiteWebBusinessObject salItemWbo : salaryItems) {
                                    salryItem = (SalaryItem) salItemWbo.getAttribute("salaryItem");
                                    amount = salryItem.getTotalSlaryItem().doubleValue();

                                    if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                        salaryItemValue = salItemWbo.getAttribute("configValue").toString() + "%";
                                    } else {
                                        salaryItemValue = salItemWbo.getAttribute("configValue").toString();
                                    }

                                    if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                        salaryItemType = "دائن";
                                        total += amount;
                                    } else {
                                        salaryItemType = "مدين";
                                        total -= amount;
                                    }
                        %>
                        <tr>
                            <td class="detailTD">
                                <b><%=salItemWbo.getAttribute("expenseCode")%></b>
                                <input type="hidden" name="expenseItemID" value="<%=salItemWbo.getAttribute("expenseID")%>"/>
                                <input type="hidden" name="salaryItemVal" value="<%=salryItem.getTotalSlaryItem().doubleValue()%>"/>
                                <input type="hidden" name="salaryItemType" value="<%=salItemWbo.getAttribute("ConfigType").toString()%>"/>
                            </td>
                            <td class="detailTD"><b><%=salItemWbo.getAttribute("expenseAR")%></b></td>
                            <td class="detailTD"><b><%=salaryItemValue%></b></td>
                            <td class="detailTD"><b><%=salaryItemType%></b></td>
                            <td class="detailTD"><b><%=salryItem.getTotalSlaryItem().doubleValue()%></b></td>
                        </tr>
                        <%
                                }
                            }
                        %>

                        <tr>
                            <td style="border: none;" colspan="3">
                            </td>
                            <td class="detailTD" style="background-color: yellow;">
                                <fmt:message key="netTotal"/>
                            </td>
                            <td class="detailTD" id="totalTD">
                                <%=total%>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </fieldset>
    </body>
</html>