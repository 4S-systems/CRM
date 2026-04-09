<%--<%@page import="com.sun.xml.internal.ws.api.ha.StickyFeature"%>--%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String messageFlag = (String) request.getAttribute("messageFlag");
        String stat = (String) request.getSession().getAttribute("currentMode");

        String callId = (String) request.getAttribute("callId");
        String allClosed=(String) request.getAttribute("allClosed");
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        Vector<WebBusinessObject> clientComp = new Vector();
        String sDate, sTime = null;
        clientComp = (Vector) request.getAttribute("clientComp");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, sTitle, sCancel, sOk, message, create;
        String client_number, ageComp, client_name, client_address, client_job, client_phone, client_mobile, client_ssn, client_city, client_mail, client_service, client_notes, working_status, TT, sat, sun, mon, tue, wed, thu, fri, noResponse;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            sTitle = "Search";
            sCancel = "Cancel";
            sOk = "Search";
            langCode = "Ar";

            client_name = "Client name";
            client_number = "Client number";
            client_address = "Client address";
            client_job = "Client job";
            client_phone = "Client phone";
            client_mobile = "Mobile Number";
            //  client_fax = "Fax";
            client_mail = "E-mail";
            client_city = "Client city";
            client_ssn = "Client Ssn";
            //  client_service = "Client service";
            client_notes = "Notes";
            // sup_city = "Supplier city";
            working_status = "Working";
            TT = "Waiting Business Rule";
            create = "New Complaint";
            message = "";
            ageComp = "A.C(day)";
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";

        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            sTitle = "&#1576;&#1581;&#1579;";
            sCancel = tGuide.getMessage("cancel");
            sOk = "&#1576;&#1581;&#1579;";
            langCode = "En";

            client_name = "اسم العميل";
            client_number = "رقم العميل";
            client_address = "&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
            client_job = "المهنة";
            client_mobile = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1576;&#1575;&#1610;&#1604;";
            client_phone = "&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
            //client_fax = "&#1575;&#1604;&#1601;&#1575;&#1603;&#1587;";
            client_mail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
            client_city = "&#1575;&#1604;&#1605;&#1583;&#1610;&#1606;&#1607;";
            // client_service = "&#1575;&#1604;&#1582;&#1583;&#1605;&#1607; ";
            client_notes = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            client_ssn = "&#1575;&#1604;&#1585;&#1602;&#1605; &#1575;&#1604;&#1602;&#1608;&#1605;&#1609;";
            //sup_city = "Supplier city";
            working_status = "&#1606;&#1588;&#1591;";
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            create = "ادخال مكالمه";
            message = "";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm()
        {
            document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchSPInSchedule";
            document.CLIENT_FORM.submit();
        }

        function cancelForm()
        {
            document.CLIENT_FORM.action = "main.jsp";
            document.CLIENT_FORM.submit();
        }



        function getClientInfo(searchBy) {
            var searchByValue = '';

            if (searchBy == 'callId') {
                searchByValue = $("#callId").val();

            }
            if ($.trim(searchByValue).length > 0) {
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForCall&searchBy=" + searchBy;
                document.CLIENT_FORM.submit();

            }

        }
        


    </SCRIPT>
    <style>
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">

            <BR>
            <div style="width: 100%;">
                <fieldset class="set" align="center" width="100%">
                    <legend align="center">
                        <table dir="<%=dir%>" align="center">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6">
                                    <%=sTitle%>
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </legend>
                    <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                        <TR>
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL>
                                    <p><b>رقم المتابعة</b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>

                                       <input type="TEXT" value="<%=(callId == null) ? "" : callId%>" id="callId" name="callId" onblur="getClientInfo('callId');
                                           return false;">
                            </TD>
                        </TR>
                    </TABLE>

                    <br><br>

                    <%if (clientWbo != null) {%>
                    <!--<TABLE class="backgroundTable" CELLPADDING="0" CELLSPACING="5" width="60%" BORDER="0" ALIGN="<%=align%>" DIR="<%=dir%>" class="table">-->

                    <table align="center" width="100%" class="tableStyle" style="background: #f9f9f9;margin-right: auto;margin-left: auto;" DIR="<%=dir%>">
                        <tr align="center" style="height: 10px;">
                            <td colspan="2"  class="blueBorder blueHeaderTD" style="font-size:18px;">بيانات العميل</td>
                        </tr>
                        <tr>
                            <td style="width: 50%;border: none;">
                                <table style="width:100%;" ><!--

                                    <tr>
                                        <td style="color: #000;" class="excelentCell formInputTag" width="30%" >
                                            <input type="hidden" name="clientId" id="clientId" value="<%=clientWbo.getAttribute("id").toString()%>" >
                                    <%=client_number%>

                                </td>
                                <td style="text-align:right;border: none;">    
                            <lable><font color="red" size="3"><%=clientWbo.getAttribute("clientNO")%>/</font><font color="blue" size="3" ><%=clientWbo.getAttribute("clientNoByDate")%></font></lable>
                    </td>
                </tr>-->
                                    <tr>
                                        <td style="color: #000;" class="excelentCell formInputTag" width="30%" >اسم العميل</td>
                                        <%if ((String) clientWbo.getAttribute("name") != null && (String) clientWbo.getAttribute("name") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("name").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <td style="color: #000;"class="excelentCell formInputTag" >النوع</td>
                                        <%if ((String) clientWbo.getAttribute("gender") != null && (String) clientWbo.getAttribute("gender") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("gender").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <td style="color: #000;"class="excelentCell formInputTag" >الحالة الإجتماعية</td>
                                        <%if ((String) clientWbo.getAttribute("matiralStatus") != null && (String) clientWbo.getAttribute("matiralStatus") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("matiralStatus").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>
                                    <tr>

                                        <td style="color: #000;" class="excelentCell formInputTag"width="30%" >الرقم القومى</td>
                                        <%if ((String) clientWbo.getAttribute("clientSsn") != null && (String) clientWbo.getAttribute("clientSsn") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("clientSsn").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <td style="color: #000;" class="excelentCell formInputTag">رقم التليفون</td>
                                        <%if ((String) clientWbo.getAttribute("phone") != null && (String) clientWbo.getAttribute("phone") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("phone").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>
                                </table>
                            </td>
                            <td style="border: none;">
                                <table style="width: 100%;">


                                    <tr>
                                        <td style="color: #000;" class="excelentCell formInputTag" width="30%" >رقم الموبايل</td>
                                        <%if ((String) clientWbo.getAttribute("mobile") != null && (String) clientWbo.getAttribute("mobile") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("mobile").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <td style="color: #000;" class="excelentCell formInputTag" width="30%" >العنوان</td>
                                        <%if ((String) clientWbo.getAttribute("address") != null && (String) clientWbo.getAttribute("address") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("address").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <td style="color: #000;" class="excelentCell formInputTag" width="30%" >الدخل الإجمالى</td>
                                        <%if ((String) clientWbo.getAttribute("salary") != null && (String) clientWbo.getAttribute("salary") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("salary").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>

                                    <tr>
                                        <td style="color: #000;" class="excelentCell formInputTag" width="30%" >البريد الإلكترونى</td>
                                        <%if ((String) clientWbo.getAttribute("email") != null && (String) clientWbo.getAttribute("email") != "") {%>
                                        <td style="text-align:right;border: none;"><label><%=clientWbo.getAttribute("email").toString()%></label></td>
                                        <%} else {%>
                                        <td style="text-align:right;border: none;"><label>-----</label></td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><input type="hidden"></td>

                                    </tr>
                                </table>
                            </td>
                        </tr>

                    </table>


                    <!--</TABLE>-->
                    <% }%>    
                    <% if (clientComp != null && !clientComp.isEmpty()) {%>
                    <TABLE class="blueBorder" align="center" DIR="<%=dir%>" WIDTH="96%" CELLPADDING="0" cellspacing="0">
                        <TR>
                            <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><SPAN><img src="images/icons/Numbers.png"width="20" height="20" /><b> رقم المتابعه </b></SPAN></TH>
                            <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><SPAN><img src="images/icons/key.png" width="20" height="20" /><b> كود الطلب</b></SPAN></TH>
                            <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><SPAN><img src="images/icons/key.png" width="20" height="20" /><b>  اسم العميل </b></SPAN></TH>
                            <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%"><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> عنوان الطلب <b></SPAN></TH>
                            <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%"><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> الطلب<b></SPAN></TH>
                                            
                                                            <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%"><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b> الحاله </b></SPAN></TH>
                                                            <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="9%"><img src="images/icons/Time.png" width="20" height="20" /><b> وقت الإتصال</b></TH>        
                                                            <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="9%"><img src="images/icons/Time.png" width="20" height="20" /><b>  <%=ageComp%> </b></TH>        
                                                            </TR> 
                                                            <tbody  id="planetData2">  
                                                                <% for (WebBusinessObject wbo : clientComp) {%>

                                                                <TR style="cursor: pointer" onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                                                                    <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px"><b><%=wbo.getAttribute("businessID")%> </b></TD>

                                                                    <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px"><b><%=wbo.getAttribute("businessCompId")%><br><font color="red"><%=wbo.getAttribute("departmentName")%></b></TD>
                                                                    
                                                                    <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px"><b><%=wbo.getAttribute("customerName")%></b></TD>
                                                                    <%if (wbo.getAttribute("compSubject") != null && wbo.getAttribute("compSubject") != "") {%>
                                                                    <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px"><b><%=wbo.getAttribute("compSubject")%></b></TD>
                                                                    <%} else {%>
                                                                    <TD ><b>----</b></TD>
                                                                    <%}%>

                                                                    <%if (wbo.getAttribute("comments") != null && wbo.getAttribute("comments") != "") {%>
                                                                    <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px"><b><%=wbo.getAttribute("comments")%></b></TD>
                                                                    <%} else {%>
                                                                    <TD ><b>----</b></TD>
                                                                    <%}%>

                                                                    <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px"><b><%=wbo.getAttribute("statusArName")%></b></TD>
                                                                    <% Calendar c = Calendar.getInstance();
                                                                        DateFormat formatter;
                                                                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                                                                        String[] arrDate = wbo.getAttribute("currentOwnerSince").toString().split(" ");
                                                                        sDate = arrDate[0];
                                                                        sTime = arrDate[1];
                                                                        String[] arrTime = sTime.split(":");
                                                                        sTime = arrTime[0] + ":" + arrTime[1];
                                                                        sDate = sDate.replace("-", "/");
                                                                        arrDate = sDate.split("/");
                                                                        sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                                                                        c.setTime((Date) formatter.parse(sDate));
                                                                        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                                                                        String sDay = null;
                                                                        if (dayOfWeek == 7) {
                                                                            sDay = sat;
                                                                        } else if (dayOfWeek == 1) {
                                                                            sDay = sun;
                                                                        } else if (dayOfWeek == 2) {
                                                                            sDay = mon;
                                                                        } else if (dayOfWeek == 3) {
                                                                            sDay = tue;
                                                                        } else if (dayOfWeek == 4) {
                                                                            sDay = wed;
                                                                        } else if (dayOfWeek == 5) {
                                                                            sDay = thu;
                                                                        } else if (dayOfWeek == 6) {
                                                                            sDay = fri;
                                                                        }
                                                                    %>
                                                                    <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px"><font color="red"><%=sDay%></font> - <b><%=sDate + " " + sTime%></b></TD>
                                                                    <TD>
                                                                        <%
                                                                            try {
                                                                                out.write("<b>" + DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar") + "</b>");
                                                                            } catch (Exception E) {
                                                                                out.write("<b>" + noResponse + "</b>");
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </TR>
                                                                <% }%>
                                                            </tbody>
                                                            </TABLE>
                                                            <%}%>

                                                            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                                                <TR>
                                                                    <TD class="td">
                                                                        &nbsp;
                                                                    </TD>
                                                                </TR>
                                                            </TABLE>
                                                            <%
                                                                if (messageFlag != null) {
                                                            %>
                                                            <center>
                                                                <table  dir="<%=dir%>">
                                                                    <tr>
                                                                        <td class="td"  align="<%=align%>">
                                                                            <H4><font color="red"><%=message%></font></H4>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <br><br>
                                                            </center>
                                                            <%
                                                                }
                                                                if(allClosed!=null){
                                                                  if(allClosed.equalsIgnoreCase("true")){
                                                            %>
                                                            <input  type="button" onclick="getDataInPopup('IssueServlet?op=closeIssueStatus&callId='+<%=callId%>);"  id="closeStatus" class="closeStatus" value="إغلاق الحاله"/>
                                                            <%        }  
                                                                }
                                                                
                                                            %>
                                                            <input  type="button" onclick="getDataInPopup('IssueServlet?op=closeIssueStatus&callId='+<%=callId%>);"  id="closeStatus" class="closeStatus" style="display: none;margin-right: 5px;" value="إغلاق الحاله"/>
                                                            </FIELDSET>
                                                            </div>
                                                            </FORM>
                                                            </BODY>
                                                            </HTML>     
