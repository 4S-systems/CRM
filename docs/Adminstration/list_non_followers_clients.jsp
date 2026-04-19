<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"name", "phone", "mobile", "currentOwnerName", "lastComDate","lastAppDate"};
        String[] clientsListTitles = new String[7];
        int s = clientsAttributes.length;
        int t = clientsListTitles.length;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
        ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");
        String currentOwnerID = request.getAttribute("currentOwnerID") != null ? (String) request.getAttribute("currentOwnerID") : "";
        String rateID = request.getAttribute("rateID") != null ? (String) request.getAttribute("rateID") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        int period = Integer.parseInt((String) request.getAttribute("period"));
        //Privileges
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        ArrayList<WebBusinessObject> prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        String align = null, xAlign;
        String dir = null;
        String clientsNo, title;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Phone";
            clientsListTitles[2] = "Mobile";
            clientsListTitles[3] = "Responsible";
            clientsListTitles[4] = "Last Comment Date";
            clientsListTitles[5] = "Last Appointment Date";
            clientsListTitles[6] = "Classification";
            clientsNo = "Clients No.";
            title = "Non Followed Clients Since";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "هاتف";
            clientsListTitles[2] = "موبايل";
            clientsListTitles[3] = "المسؤول";
            clientsListTitles[4] = "تاريخ اخر تعليق";
            clientsListTitles[5] = "تاريخ اخر متابعه";
            clientsListTitles[6] = "التصنيف";
            clientsNo = "عدد العملاء";
            title = "العملاء الغير متابعين من مدة";
        }
    %>
    <HEAD>
        <TITLE>Buildings List</TITLE>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function() {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
                try {
                    $(".clientRate").msDropDown();
                } catch (e) {
                    alert(e.message);
                }
            });
            function submitform()
            {
                document.non_followers_form.submit();
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
                color: #27272A;
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
            .ddlabel {
                float: left;
            }
            .fnone {
                margin-right: 5px;
            }
            .ddChild, .ddTitle {
                text-align: right;
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
            <br>
            <div style="width: 100%; text-align: center;">
                <form name="non_followers_form">
                    <table align="center" dir="rtl">
                        <tr>
                            <td class="td">
                                <table align="center" dir="rtl" width="570" cellspacing="2" cellpadding="1">
                                    <tr>
                                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                            <b><font size=3 color="white">عرض منذ :</b>
                                        </td>
                                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                            <select name="period" id="period" STYLE="width: 200px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitform();">
                                                <option value="30" <%=period == 30 ? "selected" : ""%>>شهر</option>
                                                <option value="60" <%=period == 60 ? "selected" : ""%>>شهرين</option>
                                                <option value="90" <%=period == 90 ? "selected" : ""%>>3 أشهر</option>
                                                <option value="182" <%=period == 182 ? "selected" : ""%>>6 أشهر</option>
                                                <option value="365" <%=period == 365 ? "selected" : ""%>>عام</option>
                                            </select>
                                            <input type="hidden" name="op" value="nonFollowers"/>
                                            <br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                            <b> <font size=3 color="white">المسؤول</b>
                                        </td>
                                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                            <select style="width: 200px; font-size: 14px;font-weight: bold;" name="currentOwnerID" id="currentOwnerID" onchange="JavaScript: submitform();">
                                                <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute = "fullName" valueAttribute="userId" scrollToValue="<%=currentOwnerID%>"/>
                                            </select>
                                            <br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                            <b> <font size=3 color="white">التصنيف</b>
                                        </td>
                                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                            <select class="clientRate" name="rateID" id="rateID" style="width: 200px; font-size: 14px;font-weight: bold;"
                                                    onchange="JavaScript: submitform();">
                                                <%
                                                    for (WebBusinessObject rateWbo : ratesList) {
                                                %>
                                                <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateWbo.getAttribute("projectID").equals(rateID) ? "selected" : ""%>  data-image="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><%=rateWbo.getAttribute("projectName")%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <br/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="td">
                                <img src="images/followup.jpg" style="width: 100px;"/>
                            </td>
                        </tr>
                    </table>
                </form>
                <br />
                <b> <font size="3" color="red"> <%=clientsNo%> : <%=clientsList.size()%> </font></b>
            </div> 
            <br/>
            <div style="width: 85%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>                
                            <th>
                                <B><%=clientsListTitles[i]%></B>
                            </th>
                            <%
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (clientsList != null) {
                                for (WebBusinessObject clientWbo : clientsList) {
                                    attName = clientsAttributes[0];
                                    attValue = (String) clientWbo.getAttribute(attName);
                        %>
                        <tr>
                            <td>
                                <div>
                                    <a href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=clientWbo.getAttribute("id")%>&clientType=-10"<b><%=attValue%></b>
                                        <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientWbo.getAttribute("id")%>">
                                            <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                                        </a>
                                </div>
                            </td>
                            <%
                                for (int i = 1; i < s; i++) {
                                    attName = clientsAttributes[i];
                                    attValue = (String) clientWbo.getAttribute(attName);
                            %>
                            <td>
                                <div>
                                    <b><%=attValue%></b>
                                </div>
                            </td>
                            <%
                                }
                            %>
                            <td>
                                <div>
                                    <%
                                        if (clientWbo.getAttribute("rateName") != null) {
                                    %>
                                    <b><%=clientWbo.getAttribute("rateName")%></b>
                                    <img src="images/msdropdown/<%=clientWbo.getAttribute("imageName")%>.png" style="float: <%=xAlign%>;"/>
                                    <%
                                        }
                                    %>&nbsp;
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <br/><br/>
        </fieldset>
    </body>
</html>
