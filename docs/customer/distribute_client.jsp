<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="loc" value="en"/>
<c:if test="${!(empty sessionScope.currentMode)}">
    <c:set var="loc" value="${sessionScope.currentMode}"/>
</c:if>

<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Campaigns.Campaigns"  />

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        List<WebBusinessObject> employees = request.getAttribute("employees") != null ? (List) request.getAttribute("employees") : new ArrayList<>();
        String clientId = (String) request.getAttribute("clientId");
        String clientName = (String) request.getAttribute("clientName");
        String employeeId = (String) request.getAttribute("employeeId");
        String employeeName = (String) request.getAttribute("employeeName");
        String status = (String) request.getAttribute("status");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir=null;
        String align1=null;
        String align2=null;
        String lang, langCode, groupByStr, disType, disEmp, print, title, distribution,distribution2,choice;
        if (stat.equals("En")) {
            dir = "LTR";
            align1="right";
            align2="left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            groupByStr = "Distribution List";
            disType = "Distribute Type ";
            disEmp = "Distribute To ";
            title = "Distribute Client: ";
            print = "get report";
            distribution = "Distribute";
            distribution2 = "Distribution to";
            choice="Choose"; 
        } else {
            dir = "RTL";
            align1="left";
            align2="right";
            lang = "English";
            langCode = "En";
            groupByStr = "قائمة التوزيع";
            disType = "نوع التوزيع ";
            disEmp = "موزع إلى ";
            title = "توزيع العميل:";
            distribution = "توزيع";
            distribution2 = "تم التوزيع الى";
            print = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; ";
            choice="أختر";
        }
        
        List<WebBusinessObject> data = (List<WebBusinessObject>) request.getAttribute("data");
        //List<WebBusinessObject> employees = (List<WebBusinessObject>) request.getAttribute("employees");
        employees = (List<WebBusinessObject>) request.getAttribute("employees");
        ArrayList<WebBusinessObject> requestTypes = request.getAttribute("requestTypes") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes") : null;
        
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Employees Load</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="css/chosen.css"/>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            <%
                if ("ok".equalsIgnoreCase(status) && request.getAttribute("redirect") != null) {
            %>
                    $(document).ready(function () {
                        location.href = "<%=context%>/ClientServlet?op=distributeDone&employeeId=<%=employeeId%>&employeeName=<%=employeeName%>&clientId=<%=clientId%>&clientName=<%=clientName%>&status=<%=status%>";
                    });
            <%
                }
            %>
                
            function distributeClient(obj) {
                if($("#requestType").val() == ""){
                    alert(" إختر نوع التوزيع ");
                } else {
                    var clientId = document.getElementById('clientId').value;
                    var clientName = document.getElementById('clientName').value;
                    var employeeId = document.getElementById('employeeId').value;
                    document.DISTRIBUTED_CLIENT.action = "<%=context%>/ClientServlet?op=distributeNewClient&clientId=" + clientId + "&clientName=" + clientName + "&employeeId=" + employeeId;
                    document.DISTRIBUTED_CLIENT.submit();
                    $(obj).attr("disabled", true);
                }
            }
        </SCRIPT>
        
        <STYLE>
        .button2{
            font-family: "Script MT", cursive;
            font-size: 20px;
            font-style: normal;
            font-variant: normal;
            font-weight: 400;
            line-height: 20px;
            width: 134px;
           /* height: 32px;*/
            text-decoration: none;
            display: inline-block;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.8s;
            cursor: pointer;
            border-radius: 12px;
            border: 1px solid #008CBA;
            padding-left:2%;
            text-align: center;
        }

        .button2:hover {
            background-color: #afdded;
            padding-top: 0px;
        }
        </style>
    </HEAD>
    
    <BODY>
        <FORM name="DISTRIBUTED_CLIENT" method="post" > 
            <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>" />
            
            <input type="hidden" id="clientName" name="clientName" value="<%=clientName%>" />
            <!--DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            </DIV-->  
            
            <FIELDSET class="set" style="width:85%;border-color: #006699"  dir="<%=dir%>">
                <table align="center" width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="50%" class="titlebar" style="text-align: <%=align1%>;border: none">
                            <font color="#005599" size="4">
                                 <%=title%> 
                            </font>
                        </td>

                        <td width="50%" class="titlebar" style="text-align: <%=align2%>;border: none">
                            <font color="#005599" size="4">
                                 <%=clientName%> 
                            </font>
                        </td>
                    </tr>
                </table>
                            
                <%
                    if ("no".equalsIgnoreCase(status)) {
                %>
                        <table align="center" WIDTH="70%">
                            <tr>
                                <td class="backgroundHeader">
                                    <font size="3" color="red">لم يتم التوزيع</font>
                                </td>
                            </tr>
                        </table>
                <% 
                    } else if ("ok".equalsIgnoreCase(status)) {
                %>
                        <table align="center" WIDTH="70%">
                            <tr>
                                <td class="backgroundHeader">
                                    <font size="3" color="blue"><%=distribution2%> <%=employeeName%></font>
                                </td>
                            </tr>
                        </table>
                                <script>
    setTimeout(function() {
        window.location.href = "<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientId%>";
    }, 2000); // Delay in milliseconds (2000 milliseconds = 2 seconds)
    //                                 </script>
                <%
                    }
                    if (!"ok".equalsIgnoreCase(status)) {
                %>
                        <TABLE  align="center">
                            <td style="border: none">
                                <TABLE class="blueBorder" ALIGN="CENTER" ID="code" CELLPADDING="0" CELLSPACING="0" STYLE="border-width:1px;border-color:white;display: block;" >
                                    <TR>
                                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;">
                                            <b>
                                                <font size=3 color="white">
                                                     <%=groupByStr%>
                                            </b>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD style="text-align:center;width: 400px;border: none;padding-top: 20px;padding-bottom: 20px" bgcolor="#dedede"  valign="MIDDLE"  >
                                            <b>
                                                <font size=3 color="black" style="margin-left: 30px">
                                                     <%=disType%> 
                                            </b>
                                            
                                            <select name="requestType" id="requestType" style="width: 200px;" class="chosen-select-campaign">
                                                <option value=""><%=choice%></option>
                                                <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
                                            </select>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD style="text-align:center;width: 400px;border: none;padding-bottom: 5px" bgcolor="#dedede"  valign="MIDDLE"  >
                                            <b>
                                                <font size=3 color="black" style="margin-left: 37px">
                                                     <%=disEmp%> 
                                            </b>
                                            <select style="width: 200px;margin-left: -15px" id="employeeId" name="employeeId" class="chosen-select-campaign">
                                                <sw:WBOOptionList displayAttribute="fullName" valueAttribute="userId" wboList="<%=employees%>" />
                                            </select>
                                        </TD>
                                    </TR>
                                    
                                    <TR>
                                        <TD style="text-align:center;width: 400px;border: none;padding-bottom: 20px" bgcolor="#dedede"  valign="MIDDLE"  >
                                            <button class="button2" type="button" onclick="JavaScript: distributeClient(this);" STYLE="margin-top: 20px;font-weight:bold; ">
                                                 <%=distribution%> 
                                                <%
                                                    if (stat.equals("En")){ 
                                                %>
                                                        <img src="images/icons/backword.png" width="15" height="15"/>
                                                <%
                                                    }else{
                                                %>
                                                        <img src="images/icons/forward.png" width="15" height="15"/>
                                                <%
                                                    }
                                                %>
                                            </button>
                                            
            <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>" />
                                        </TD>
                                    </TR>
                                </TABLE>
                            </td>
                            
                            <td style="width: 50% ; border: none">
                                <img align="center"  src="images/distribution.png" style="height: 187px;width: 265px;margin-right: 20px;border-radius: 5px"/>
                            </td>
                        </TABLE>
                <%
                    }
                %>
            </FIELDSET>
        </FORM>
            <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
                '.chosen-select-rate': {no_results_text: 'No classification found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            getEmployees($("#departmentID"), true);
        </script>
    </BODY>
</HTML>     