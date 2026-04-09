<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        String[] clientsAttributes = {"customerName", "clientPhone", "clientMobile", "fullName", "senderName", "entryDate"};
        String[] clientsListTitles = new String[6];
        int s = clientsAttributes.length;
        int t = s + 0;
        
        ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        
        
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        
        String beginDate = sdf.format(cal.getTime());
        if (request.getAttribute("beginDate") != null) {
            beginDate = (String) request.getAttribute("beginDate");
        }
        String endDate = sdf.format(cal.getTime());
        if (request.getAttribute("endDate") != null) {
            endDate = (String) request.getAttribute("endDate");
        }
        String sourceID = "";
        if (request.getAttribute("sourceID") != null) {
            sourceID = (String) request.getAttribute("sourceID");
        }
        
        String searchType = (String) request.getAttribute("searchType");
        String status = (String) request.getAttribute("status");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String clientsNo, title;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Phone";
            clientsListTitles[2] = "Mobile";
            clientsListTitles[3] = "Owner";
            clientsListTitles[4] = " Source ";
            clientsListTitles[5] = "Dist. Date";
            clientsNo = "Clients No.";
            title = "Distributed Clients";
        } else {
            align = "center";
            dir = "RTL";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "هاتف";
            clientsListTitles[2] = "موبايل";
            clientsListTitles[3] = "الموظف المسؤول";
            clientsListTitles[4] = " المصدر ";
            clientsListTitles[5] = "تاريخ التوزيع";
            clientsNo = "عدد العملاء";
            title = "العملاء الموزعين";
        }
       
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
       
	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
    %>
    <HEAD>
        <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/fileupload/jquery.form.js" ></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <!-- Include css styles here -->
        <link rel="stylesheet" href="css/demo_table.css">
        <link rel="stylesheet" href="css/jquery-ui.css"/>
        <LINK rel="stylesheet" href="css/CSS.css">
        <LINK rel="stylesheet" href="css/Button.css">
        <LINK rel="stylesheet" href="css/blueStyle.css"/> 
        <script type="text/javascript">
            var users = new Array();
            var divID;
            $(document).ready(function() {
                $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
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
                            
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ClientServlet?op=<%="myClient".equals(searchType) ? "myDistributedClients" : "distributedClients"%>" method="POST">
                <table ALIGN="center" DIR="<%=dir%>" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b>
                                <font size=3 color="white">
                                     From Date 
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                            <b>
                                <font size=3 color="white">
                                     To Date 
                            </b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>" style="margin: 5px;" />
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" style="margin: 5px;" />
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b>
                                <font size=3 color="white">
                                     Department 
                            </b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle" colspan="2">
                            <select style="width: 50%; font-weight: bold; font-size: 13px;" id="sourceID" name="sourceID">
                                <%if (userPrevList.contains("SHOW_ALL_CLIENT")) {%>
                                <option value="">All</OPTION>
                                <% } %>
				<%
				    if(usersList != null && !usersList.isEmpty()){
				%>
                                        <sw:WBOOptionList displayAttribute="fullName" valueAttribute="userId" wboList="<%=usersList%>" scrollToValue='<%=sourceID%>' />
				<%
				    }
				%>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" colspan="2">  
                            <button type="submit" STYLE="color: #000;font-size:15px;margin: 5px;font-weight:bold; width: 100px; ">
                                 Search 
                                 <IMG HEIGHT="15" SRC="images/search.gif" >
                            </button>
                        </td>
                    </tr>
                </table>
            </form>
                            
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <table ALIGN="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < clientsAttributes.length; i++) {
                            %>                
                                    <th>
                                        <B>
                                             <%=clientsListTitles[i]%> 
                                        </B>
                                    </th>
                            <%
                                }
                            %>
                        </tr>
                    </thead>
                    
                    <tbody>
                        <%
                            for (WebBusinessObject wbo : clientsList) {
                        %>
                                <tr>
                                    <td>
                                         <%=wbo.getAttribute("customerName") != null && !wbo.getAttribute("customerName").toString().equals("UL") ? wbo.getAttribute("customerName") : ""%> 
                                    <a target="_SELF" href="<%=context%>/ClientServlet?op=clientDetails&issueID=<%=wbo.getAttribute("customerId")%>&clientId=<%=wbo.getAttribute("customerId")%>">
                                                <img src="images/client_details.jpg" width="30" style="float: left;">
                                            </a>
                                    </td>

                                     <td>
                                         <%=wbo.getAttribute("clientPhone") != null && !wbo.getAttribute("clientPhone").toString().equals("UL") ? wbo.getAttribute("clientPhone") : ""%> 
                                    </td>

                                    <td>
                                         <%=wbo.getAttribute("clientMobile") != null && !wbo.getAttribute("clientMobile").toString().equals("UL") ? wbo.getAttribute("clientMobile") : ""%> 
                                    </td>

                                    <td>
                                         <%=wbo.getAttribute("fullName") != null && !wbo.getAttribute("fullName").toString().equals("UL") ? wbo.getAttribute("fullName") : ""%> 
                                    </td>

                                     <td>
                                         <%=wbo.getAttribute("createdBy") != null && !wbo.getAttribute("createdBy").toString().equals("UL") ? wbo.getAttribute("createdBy") : ""%> 
                                    </td>

                                    <td>
                                         <%=wbo.getAttribute("currentOwnerSince") != null && !wbo.getAttribute("currentOwnerSince").toString().equals("UL") ? wbo.getAttribute("currentOwnerSince").toString().split(" ")[0] : ""%> 
                                    </td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </fieldset>
    </body>
</html>