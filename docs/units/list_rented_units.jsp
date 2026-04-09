<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@page import="java.util.Date"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] apartmentAttributes = {"projectName"};
        //String[] apartmentListTitles = new String[5];
        String[] apartmentListTitles = new String[7];
        int s = apartmentAttributes.length;
        //int t = s + 4;
        //int t = s + 6;
        int t = s + 6;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> apartmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("apartmentsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String toDate = sdf.format(c.getTime());
        if (request.getAttribute("toDate") != null) {
            toDate = (String) request.getAttribute("toDate");
        }
        c.add(Calendar.WEEK_OF_MONTH, -1);
        String fromDate = sdf.format(c.getTime());
        if (request.getAttribute("fromDate") != null) {
            fromDate = (String) request.getAttribute("fromDate");
        }

        String align = null;
        String dir = null;
        String apartmentsNo, title, fromDateTitle, toDateTitle;
        String contract;
       ProjectMgr projectMgr = ProjectMgr.getInstance();
       ClientMgr clientMgr= ClientMgr.getInstance();
        
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            apartmentListTitles[0] = "#";
            apartmentListTitles[1] = "Unit";
            apartmentListTitles[2] = "Client";
            apartmentListTitles[3] = "Start Date";
            apartmentListTitles[4] = "End Date";
            apartmentListTitles[5] = "Rent";
            apartmentListTitles[6] = "Sponcer";
         //   apartmentListTitles[7] = "Commerioal";
            apartmentsNo = "Apartments No.";
            title = "Available Apartments Rented";
            fromDateTitle = "From Date";
            toDateTitle = "To Date";
            contract="Rent Contracts";
        } else {
            align = "center";
            dir = "RTL";
            apartmentListTitles[0] = "#";
            apartmentListTitles[1] = "الوحدة";
            apartmentListTitles[2] = "العميل";
            apartmentListTitles[3] = "بداية العقد";
            apartmentListTitles[4] = "نهاية العقد";
            apartmentListTitles[5] = "قيمة التعاقد";
            apartmentListTitles[6] = "الكفيل";
//            apartmentListTitles[7] = "التعامل التجارى";
            apartmentsNo = "عدد الوحدات المؤجرة";
            title = "الوحدات المؤجرة";
            fromDateTitle = "من تاريخ";
            toDateTitle = "إلي تاريخ";
            contract="عقد ايجار";
        }
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
            
            //convert from chr to isl
            function intPart(floatNum){
if (floatNum< -0.0000001){
	 return Math.ceil(floatNum-0.0000001);
	}
return Math.floor(floatNum+0.0000001);	
}
            function chrToIsl(arg1) {//alert(arg1);
             var   arg=new Date(arg1);	
        y=arg.getFullYear();
        m=arg.getMonth()+1;
        d=arg.getDate();

					if ((y>1582)||((y==1582)&&(m>10))||((y==1582)&&(m==10)&&(d>14))) 
						{
						jd=intPart((1461*(y+4800+intPart((m-14)/12)))/4)+intPart((367*

(m-2-12*(intPart((m-14)/12))))/12)-
	intPart( (3* (intPart(  (y+4900+    intPart( (m-14)/12)     )/100)    )   ) /4)+d-32075;
						}
						else
						{
						jd = 367*y-intPart((7*(y+5001+intPart((m-9)/7)))/4)+intPart

((275*m)/9)+d+1729777;
						}
					//arg.JD.value=jd;
					//arg.wd.value=weekDay(jd%7);
					l=jd-1948440+10632;
					n=intPart((l-1)/10631);
					l=l-10631*n+355;
					j=(intPart((10985-l)/5316))*(intPart((50*l)/17719))+(intPart(l/5670))*(intPart

((43*l)/15238));
					l=l-(intPart((30-j)/15))*(intPart((17719*j)/50))-(intPart(j/16))*(intPart

((15238*j)/43))+29;
					m=intPart((24*l)/709);
					d=l-intPart((709*m)/24);
					y=30*n+j-30;

	//arg.HDay.value=d;
	//arg.HMonth.value=m;
	//arg.HYear.value=y;
        switch (m) {
    case 1:
        monthName = "محرم";
        break;
    case 2:
        monthName = "صفر";
        break;
    case 3:
        monthName = "ربيع اول";
        break;
    case 4:
        monthName = "ربيع ثانى";
        break;
    case 5:
        monthName = "جمادى اول";
        break;
    case 6:
        monthName = "جمادى ثانى";
    case 7:
        monthName = "رجب";
        break;
    case 8:
        monthName = "شعبان";
        break;
    case 9:
        monthName = "رمضان";
        break;
    case 10:
        monthName = "شوال";
        break;
    case 11:
        monthName = "ذوالقعدة";
        break;
    case 12:
        monthName = "ذوالحجة";
        break;
} 
        var isdate=d+'-'+monthName+'-'+y;
        //alert(isdate);
//var isldate=new Date(isdate);
//alert(isdate);
//document.write(isdate);
        return isdate;
        
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
        </style>
    </HEAD>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <legend align="center">

                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            <%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <br/>
            <%--  <form id="client_form" action="<%=context%>/UnitServlet" method="post">
                <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=fromDateTitle%></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><%=toDateTitle%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="width: 180px;"/>
                            <br/><br/>
                            <input type="hidden" name="op" value="listAvailableApartments"/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="width: 180px;"/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <TD STYLE="text-align:center" CLASS="td" colspan="2">  
                            <button type="submit" STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>
                        </td>
                    </tr>
                </table>
            </form>--%>
            <center> <b> <font size="3" color="red"> <%=apartmentsNo%> : <%=apartmentsList.size()%> </font></b></center> 
            <br/>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="apartments" style="width:100%;">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>                
                            <th>
                                <B><%=apartmentListTitles[i]%></B>
                            </th>
                            <%
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int counter = 1;
                            for (WebBusinessObject apartmentWbo : apartmentsList) {
                        %>
                        <tr>
                            <%                                for (int i = 0; i < s; i++) {
                                    attName = apartmentAttributes[i];
                                    attValue = (String) apartmentWbo.getAttribute(attName);
                            %>
                            <td>
                                <%=counter%>
                                 
                            </td>
                            <td>
                                <%--<%=apartmentWbo.getAttribute("projectID")%>--%>
                                <%String projectId=(String)apartmentWbo.getAttribute("projectID");%>
                                <%String projectName=((WebBusinessObject) projectMgr.getOnSingleKey(projectId)).getAttribute("projectName").toString();%>
                                <%=projectName%>
                                
                                <%--<IMG value="" onclick="JavaScript: viewGallery('<%=apartmentWbo.getAttribute("projectID")%>', '<%=apartmentWbo.getAttribute("Model_Code")%>');" width="19px" height="19px" src="images/units.png" title="عرض جميع الصور" alt="عرض جميع الصور" style="margin: -4px 0;"/>--%>

                            </td>
                            <td>
                               <%-- <%=apartmentWbo.getAttribute("clientID")%>--%>
                                <%String clientId=(String)apartmentWbo.getAttribute("clientID");%>
                                <%String clientName=((WebBusinessObject) clientMgr.getOnSingleKey(clientId)).getAttribute("name").toString();%>
                                <%=clientName%>
                            </td>
                             <td>
                                <%--<%=apartmentWbo.getAttribute("startDate")%>--%>
                                <% String chrStartDate= (String)apartmentWbo.getAttribute("startDate");%>
                                <%--<script>chrToIsl(<%=chrStartDate%>);</script>--%>
                                <script>
                                    var chStartDate="<%=chrStartDate%>";
                                    //chrToIsl(chStratDate);alert(chrToIsl(chStartDate));
                                    document.write(chrToIsl(chStartDate));
                                </script>
                            </td>
                            <td>
                                <%--<%=apartmentWbo.getAttribute("endDate")%>--%>
                                <% String chrEndDate= (String)apartmentWbo.getAttribute("endDate");%>
                                <script>
                                    var chEndDate="<%=chrEndDate%>";
                                    //var endDate=chrToIsl(chEndDate); //alert(chrToIsl(chEndDate));
                                    //document.write(endDate);//endDate.toString();
                                    document.write(chrToIsl(chEndDate));
                                </script>
                            </td>
                            <td>
                                <%=apartmentWbo.getAttribute("monthlyRent")%>
                            </td>
                            <td>
                                <%=apartmentWbo.getAttribute("sponcer")%>
                            </td>
                            <!--<td>
                                <div>
                                    <%--<SCRIPT> chrToIsl("01/01/2017");</script>--%>
                                     <%--<b><%=attValue%></b>--%>
                                </div>
                            </td>--!>
                            <%
                                }
                           // String area = (String) apartmentWbo.getAttribute("area");
                           // if (area == null || area.equals("UL") || area.equals("0")) {
                           //     area = "غير متاح";
                           // }
                           // String price = (String) apartmentWbo.getAttribute("price");
                           // if (price == null || price.equals("UL") || price.equals("0")) {
                           //     price = "غير متاح";
                           // }
                            %>
                            <!--<td>-->
                             <%--   <%=area%>--%>
                            <!--</td>
                            <td>
                              <%--  <%=price%>--%>
                            </td>
                            <td>
                                <%-- <%= apartmentWbo.getAttribute("creationTime")%> --%>
                                
                            </td>
                            <td>
                               <%-- <%=apartmentWbo.getAttribute("newCode")%>--%>
                                
                            <td nowrap>
                                <div>
                                 <%--   <b><a href="<%=context%>/UnitServlet?op=viewRentContract&projectID=<%=apartmentWbo.getAttribute("projectID")%>&fromPage=listApartment"><%=contract%></a></b>--%>
                                </div>
                            </td>-->
                            
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
