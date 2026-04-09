<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@page import="java.util.Date"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
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
        String[] apartmentAttributes = {"projectName"};
        int s = apartmentAttributes.length;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> apartmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("apartmentsList");
        ArrayList projectsList = (ArrayList) request.getAttribute("projectsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String toDate = sdf.format(c.getTime());
        if (request.getAttribute("toDate") != null) {
            toDate = (String) request.getAttribute("toDate");
        }
        c.add(Calendar.YEAR, -1);
        String fromDate = sdf.format(c.getTime());
        if (request.getAttribute("fromDate") != null) {
            fromDate = (String) request.getAttribute("fromDate");
        }

           String   unavailable, payPlan, dir, SppayPlan, CppayPlan, DppayPlan;
         if (stat.equals("En")) {
                unavailable="Unavailable";
                SppayPlan = " SPP";
                CppayPlan = "CPP";
                DppayPlan = "DPP";
             dir = "ltr";
        } else {
               unavailable="غير متاح";
               SppayPlan = "SPP";
               CppayPlan = "CPP";
               DppayPlan = "DPP";
               dir = "rtl";
        }
        
         String[] str;
        double amount = 0;
        DecimalFormat formatter = new DecimalFormat("#,###.##");
        String clientID = (String) request.getAttribute("clientID") != null ? (String) request.getAttribute("clientID") : "";
	
        String unitAreaID = request.getAttribute("unitAreaID") != null ? (String) request.getAttribute("unitAreaID") : "All";
        String unitArea = request.getAttribute("unitAreaID") != null ? (String) request.getAttribute("unitAreaID") : "";
        
        String projectID = "";
        if (request.getAttribute("projectID") != null) {
            projectID = (String) request.getAttribute("projectID");
        }
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        
    %>
    <HEAD>
        <TITLE>Buildings List</TITLE>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#apartments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
		
		//var unitAreaID = <%=unitAreaID%>;
		//$('#unitAreaID  option[value="' + unitAreaID + '"]').prop("selected", true)
            });

            function viewGallery(unitID, modelID) {
                var url = '<%=context%>/UnitDocReaderServlet?op=unitDocGallery&unitID=' + unitID + '&modelID=' + modelID;
                var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
            $(function () {
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            
            
            function getPaymentPlansOfProject(){
                var prjID = $("#projectID option:selected").val();
                var url = '<%=context%>/UnitServlet?op=getPaymentPlans&prjID=' + prjID;
                var wind = window.open(url, "", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
            
            function submitForm() {
                document.client_form.action = "UnitServlet?op=listAvailableApartments";
                document.client_form.submit();
            }
            
            function AddToCart(projectID, projectName)
            {
                var clientID = <%=clientID%>;
                var userId = <%=loggedUser.getAttribute("userId")%>;
                var productCategoryID = $("#projectID option:selected").val();
                var productCategoryName = $("#projectID option:selected").text();
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
        <style type="text/css">
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
                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
            }
            .remove__{
                width:20px;
                height:20px;
                background-image:url(images/icons/remove1.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
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
                background: rgb(249,252,247); /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
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
            table label {
                float: right;
            }

            td {
                padding-bottom: 10px;
            }
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }

            .dataTD {
                text-align:right;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataTD {
                background: #FFF
            }

            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
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

            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                margin-bottom: 30px;
            }

            .titleRow {
                background-color: orange;
            }

            .detailTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color: #FCC90D;
            }

            .dataDetailTD {
                text-align:right;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataDetailTD {
                background: #FFF19F
            }

            tr:nth-child(odd) td.dataDetailTD {
                background: #FFF19F
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
            
            .tbFStyle{
                background: silver;
                width: auto; 
                text-align: right; 
                margin-bottom: 10px !important; 
                margin-left: 135px; 
                margin-right: auto; 
                letter-spacing: 35px;
                border-radius: 10px;
                padding-right: 20px;
            }
            
            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
            }
        </style>
    </HEAD>
    <body>
        <table border="0px" class="table tbFStyle" style="margin-top: -10px">
            <tr style="padding: 0px 0px 0px 50px;">
                <td class="td" style="text-align: center;">
                    <a title="Back" style="padding: 5px;">
                        <image style="height:42px;" src="images/icons/BACKNEWTO.png" onclick="window.history.go(-1);"/>
                    </a>
                </td>
            </tr>
        </table>
        <fieldset align=center class="set" style="width: 90%; border-color: #006699;">
            <legend align="center">

                     <font color="#005599" size="5">
                            <fmt:message key="availableunits"/>
                            </font>
                       
            </legend>
            <br/>
            <form id="client_form" name ="client_form" action="<%=context%>/UnitServlet?op=listAvailableApartments" method="post">
                <input type="hidden" id="clientID" name="clientID" value="<%=clientID%>">
                <input type="hidden" name="op" value="listAvailableApartments"/>

                <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                    <!--<tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="25%">
                            <b>
				<font size=3 color="white">
				     <fmt:message key="project" /> 
			    </b>
                        </td>
                        
			<td  bgcolor="#dedede"  style="text-align:center" valign="middle" WIDTH="25%" colspan="3">
                            <select name="projectID" id="projectID" style=" width:100%; height: 100%; font-size: larger; text-align-last:center;" onchange="JavaScript: submitForm();">
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute = "projectName" valueAttribute="projectName" />
                            </select>
                        </td>
		    </TR>
                    
		    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="25%">
                            <b>
				<font size=3 color="white">
				     <fmt:message key="unitArea" /> 
			    </b>
                        </td>
			
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="width: 180px;"/>
                            <br/><br/>
                            <input type="hidden" name="op" value="listAvailableApartments"/>
                        </td>
                    </tr>-->
		    
                    <tr>
			<td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><fmt:message key="area" />  </b>
                        </td>
			
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white">
                                <fmt:message key="project" /> 
                                </b>
                        </td>
                    </tr>
                    
		    <tr>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input type="number" name="unitAreaID" id="unitAreaID" style=" width:100%; height: 100%; font-size: larger; text-align-last:center;" onchange="JavaScript: submitForm();" value="<%=unitArea%>"/>
                        </td>
                        
			<td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <select name="projectID" id="projectID" style="width: 300px;" onchange="submitForm()" <!--onchange="getPaymentPlansOfProject();"--> >
                                <option value="" > All Projects </option>
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                        </td>
		    </TR>
		    
                    <tr>
                        <TD STYLE="text-align:center" CLASS="td" colspan="2">  
                            <button type="submit" STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; ">
                                <fmt:message key="search"/><IMG HEIGHT="15" SRC="images/search.gif" ></button>
                        </td>
                    </tr>
                </table>
            </form>
                            <center> <b> <font size="3" color="red"> <fmt:message key="apartments" /> : <%=apartmentsList.size()%> </font></b></center> 
            <br/>
            <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="center" dir='<fmt:message key="direction" />' id="apartments" style="width:100%;">
                    <thead>
                        <tr>
                            <th><B></B></th>
                            <th><B><fmt:message key="unit" /></B></th>
                            <th><B><fmt:message key="model" /></B></th>
                            <th><B><fmt:message key="projectname" /></B></th>
                            <th><B><fmt:message key="fullName" /></B></th>
                            <th><B><fmt:message key="area" /></B></th>
                            <th><B><fmt:message key="price" /></B></th>
                            <th style="display: none;"><B><fmt:message key="commstate" /></B></th>
                            <th><B></B></th>
                            <th><B></B></th>
                            <th><B></B></th>
                            <th><B></B></th>
                            <th><B><fmt:message key="AdditionTime" /></B></th>
                            <th><B></B></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int counter = 1;
                            for (WebBusinessObject apartmentWbo : apartmentsList) {
                        %>
                        <tr>
                            <%  for (int i = 0; i < s; i++) {
                                    attName = apartmentAttributes[i];
                                    attValue = (String) apartmentWbo.getAttribute(attName);
                            %>
                            <td>
                                <%=counter%>
                            </td>
                           
                            <td>
                                <div>
                                    <b><a href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=apartmentWbo.getAttribute("projectID")%>&fromPage=listAvailableApartments&fromDate=<%=request.getParameter("fromDate")%>&toDate=<%=request.getParameter("toDate")%>"><%=attValue%></a></b>
                                </div>
                            </td>
                            <%
                                }
                            String area = (String) apartmentWbo.getAttribute("area");
                            if (area == null || area.equals("UL") || area.equals("0")) {
                                area = unavailable;
                            }
                            String price = (String) apartmentWbo.getAttribute("price");
                            if (price == null || price.equals("UL") || price.equals("0")) {
                                price =unavailable;
                            }
                            %>
                            <td>
                                <%=apartmentWbo.getAttribute("modelName") != null ? apartmentWbo.getAttribute("modelName") : "---"%>
                            </td>
                            <td> <%-- //Kareem rent task --%>
                                <%= apartmentWbo.getAttribute("parentName")%>
                                
                            </td>
                            <td> <%-- //Kareem rent task --%>
                                <%= apartmentWbo.getAttribute("fullName")%>
                                
                            </td>
                            
                            <td>
                                <%=area%>
                            </td>
                            <td>
                                <% if (price == null) {%>
                                    ...
                                <% } else {
                                    try {
                                        amount = Double.parseDouble(price.toString());
                                    } catch (NumberFormatException ne) {
                                        amount = 0;
                                    }
                                %>
                                <%=formatter.format(amount)%>
                                <% } %>
                            </td>
                            <td style="display: none;">
                                <%
				    if(apartmentWbo.getAttribute("newCode") != null){
				%>
                                     <%=apartmentWbo.getAttribute("newCode")%> 
                                <%
				    } else {
				%>
                                     --- 
				<%
				    }
				    if(apartmentWbo.getAttribute("newCode") == null || (apartmentWbo.getAttribute("newCode") != null && !((apartmentWbo.getAttribute("newCode")).toString()).equals("تمليك"))){
				%>
					<b>
					    <a href="<%=context%>/UnitServlet?op=viewRentContract&projectID=<%=apartmentWbo.getAttribute("projectID")%>&fromPage=listApartment">
						 <fmt:message key="contract"/> 
					    </a>
					</b>
				<%
				    }
				%>
                            </td>
                             <td>
                                <IMG value="" onclick="JavaScript: viewGallery('<%=apartmentWbo.getAttribute("projectID")%>', '<%=apartmentWbo.getAttribute("Model_Code")%>');" width="25px" height="25px" src="images/gallery.png" title='<fmt:message key="showimages" />' alt='<fmt:message key="showimages" />' style="margin: -4px 0; cursor: pointer;"/>
                                
                            </td>
                            <td>
                                <b>
                                    <% if(clientID != null && !clientID.equals("") && apartmentWbo.getAttribute("shopCart") != null && apartmentWbo.getAttribute("shopCart").equals("true") && amount > 0){ %>
                                        <a href="<%=context%>/UnitServlet?op=paymentPlan&unitID=<%=apartmentWbo.getAttribute("projectID")%>&clientID=<%=clientID%>&clientID=<%=clientID%>&typ=spp" title="Standard Payment Plan"> <%=SppayPlan%> </a>
                                    <%
                                    } else {
                                    %>
                                    ---
                                    <% } %>
                                </b>
                            </td>
                            <td>
                                <b>
                                    <% if (clientID != null && !clientID.equals("") && apartmentWbo.getAttribute("shopCart") != null && apartmentWbo.getAttribute("shopCart").equals("true") && amount > 0) {%>
                                    <a href="<%=context%>/UnitServlet?op=paymentPlan&unitID=<%=apartmentWbo.getAttribute("projectID")%>&clientID=<%=clientID%>&clientID=<%=clientID%>&typ=cpp" title="Customized Payment Plan"> <%=CppayPlan%> </a>
                                    <%
                                    } else {
                                    %>
                                    ---
                                    <% }%>
                                </b>
                            </td>
                            <td>
                                <b>
                                    <% if(clientID != null && !clientID.equals("") && apartmentWbo.getAttribute("shopCart") != null && apartmentWbo.getAttribute("shopCart").equals("true") && amount > 0){ %>
                                        <a href="<%=context%>/UnitServlet?op=dualPaymentPlan&unitID=<%=apartmentWbo.getAttribute("projectID")%>&clientID=<%=clientID%>&clientID=<%=clientID%>&typ=dpp" title="Dual Payment Plan"> <%=DppayPlan%> </a>
                                    <%
                                    } else {
                                    %>
                                    ---
                                    <% } %>
                                </b>
                            </td>
                            <td> <%-- //Kareem rent task --%>
                                <%= apartmentWbo.getAttribute("creationTime").toString().split(" ")[0]%>
                                
                            </td>
                            <TD>
                                <img  title=<fmt:message key="cart"/>  src="images/icons/cart.png" width="30" style="display: <%=apartmentWbo.getAttribute("shopCart")!= null && apartmentWbo.getAttribute("shopCart").equals("true") ? "none" : ""%> ;float: left;" onclick="AddToCart('<%=apartmentWbo.getAttribute("projectID")%>', '<%=apartmentWbo.getAttribute("parentName")%>');"/>
                            </TD>
                        </tr>
                        <%
                                counter++;
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <br/><br/>
        </fieldset>
    </body>
</html>
