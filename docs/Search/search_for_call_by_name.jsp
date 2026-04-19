<%--<%@page import="com.sun.xml.internal.ws.api.ha.StickyFeature"%>--%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
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

        String callName = (String) request.getAttribute("callName");
        Vector Departments = (Vector) request.getAttribute("Departments");

        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        Vector<WebBusinessObject> clientComp = new Vector();
        clientComp = (Vector) request.getAttribute("clientComp");
        Calendar cal = Calendar.getInstance();
        String jDateFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowTime = sdf.format(cal.getTime());
        cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -1);
        int a = cal.get(Calendar.YEAR);
        int b = (cal.get(Calendar.MONTH)) + 1;
        int d = cal.get(Calendar.DATE);
        String sDate, sTime = null;
        String prev = a + "/" + b + "/" + d;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, sTitle, sCancel, sOk, message, create;
        String client_number, client_name, client_address, client_job, client_phone, client_mobile, client_ssn, client_city, client_mail, client_service, client_notes, working_status, TT, sat, sun, mon, tue, wed, thu, fri, noResponse, ageComp, status;

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
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
            status = "status";

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

            create = "ادخال مكالمه";
            message = "";
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";

        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>

        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">     

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

    </HEAD>

    <script type="text/javascript">
        $(document).ready(function() {
            $('#call').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true



            })
        });
        //          
    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
  
            
        $(function() {
            $("#beginDate, #endDate").datepicker({
                changeMonth: true,
                changeYear: true,
                minDate: "+d",
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
        });
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

            if (searchBy == 'callName') {
                searchByValue = $("#callName").val();

            }
            if ($.trim(searchByValue).length > 0) {
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForCall&searchBy=" + searchBy;
                document.CLIENT_FORM.submit();

            }

        }
        
          
        function getInfo() {

            var beginDate = $("#beginDate").val();
            var callName=$("#callName").val();
            var endDate = $("#endDate").val();
            var Departments=$("#Departments").val();
            if((beginDate=null||beginDate=="")){
                alert("من فضلك أدخل تاريخ البداية");
            }
            else if((endDate=null||endDate=="")){
                alert("من فضلك أدخل تاريخ النهاية");
           
            }
           
            else if((Departments=null||Departments=="")){
                alert("من فضلك أدخل الاداره  ");
           
            }
            else{
                beginDate = $("#beginDate").val();
                endDate = $("#endDate").val();
                var callName=$("#callName").val();
        
                var Departments=$("#Departments").val();
           
                document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=SearchForCallFormByName&beginDate="+beginDate +"&endDate="+endDate+"&callName="+callName+"&Departments="+Departments
                document.CLIENT_FORM.submit();
                //                $("#username").val("");
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

                    <tr>
                    <TR>

                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> من تاريخ</b>
                        </TD>
                        <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                            <b> <font size=3 color="white"> الي تاريخ </b>
                        </TD>
                    </TR>
                    <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                        <%
                            String url = request.getRequestURL().toString();
                            String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                            Calendar c = Calendar.getInstance();
                        %>



                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" ><img src="images/showcalendar.gif" > 

                        <br><br>
                    </TD>

                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">


                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" > 

                        <br><br>
                    </td>

                    </tr>

                    <TR>
                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> اسم العميل</b>
                        </TD>

                        <TD STYLE="<%=style%>" class='td'>

                            <input type="TEXT" value="<%=(callName == null) ? "" : callName%>" id="callName" name="callName" >
                        </TD>

                    </TR>
                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                        <b><font size=3 color="white"> الاداره</b>
                    </TD>

                    <td>
                        <select name="Departments" ID="Departments" STYLE="width:230px">
                            <option value="all">الكل</option>
                            <%
                                if (Departments != null) {
                                    for (int i = 0; i < Departments.size(); i++) {
                                        WebBusinessObject wbo = (WebBusinessObject) Departments.get(i);
                            %>
                            <option value="<%=(String) wbo.getAttribute("projectID")%>"
                                    >
                                <%=(String) wbo.getAttribute("projectName")%>
                                <%
                                        }
                                    }
                                %>
                        </select>
                    </td>
                    <tr>
                        <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                            <button  onclick="JavaScript: getInfo();"   STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  

                        </TD>
                    </tr>
                </TABLE>

                <br><br>


                <% if (clientComp != null && !clientComp.isEmpty()) {%>
                <TABLE   id="call" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">

                    <thead><TR>
                            <TH><SPAN><img src="images/icons/Numbers.png" width="20" height="20"  /><b>  رقم المتابعه </b></SPAN></TH>
                            <TH > <SPAN><img src="images/icons/key.png" width="20" height="20"  /><b> كود الطلب</b></SPAN></TH>
                            <TH ><SPAN><img src="images/icons/key.png" width="20" height="20"  /><b> اسم العميل </b></SPAN></TH>
                            <TH ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> عنوان الطلب<b></SPAN></TH>
                                            <TH style="width: 20%;"><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> الطلب<b></SPAN></TH>
                                                            <TH  ><SPAN><img src="images/icons/manager.png"width="20" height="20"  /><b> الحاله </b></SPAN></TH>
                                                            <TH ><img src="images/icons/Time.png" width="20" height="20" /><b> وقت الإتصال</b></TH>        
                                                            <TH ><img src="images/icons/Time.png"width="20" height="20"  /><b> <%=ageComp%></b></TH>        
                                                            </TR> </thead>
                                                            <tbody  >  
                                                                <% for (WebBusinessObject wbo : clientComp) {%>


                                                                <TR >

                                                                    <TD ><b><font color="red"><%=wbo.getAttribute("businessID")%></font> </b></TD>
                                                                    <TD ><b><%=wbo.getAttribute("businessCompId")%><br><font color="red"><%=wbo.getAttribute("departmentName")%></font></br></TD>
                                                                    <TD ><b><%=wbo.getAttribute("customerName")%></b></TD>
                                                                    <%if (wbo.getAttribute("compSubject") != null && wbo.getAttribute("compSubject") != "") {%>
                                                                    <TD ><b><%=wbo.getAttribute("compSubject")%></b></TD>
                                                                    <%} else {%>
                                                                    <TD ><b>----</b></TD>
                                                                    <%}%>
                                                                    <%if (wbo.getAttribute("comments") != null && wbo.getAttribute("comments") != "") {%>

                                                                    <TD ><b><%=wbo.getAttribute("comments")%></b></TD>
                                                                    <%} else {%>
                                                                    <TD ><b>----</b></TD>
                                                                    <%}%>

                                                                    <TD ><b><%=wbo.getAttribute("statusArName")%></b></TD>

                                                                    <%  c = Calendar.getInstance();
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
                                                                    <TD ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                                                                    <td >

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



                                                            </FIELDSET>

                                                            </FORM>
                                                            </BODY>
                                                            </HTML>     
