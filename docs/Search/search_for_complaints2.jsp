<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();


    Hashtable logos = new Hashtable();
    logos = (Hashtable) session.getAttribute("logos");

//get session logged user and his trades
    WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
    Vector data = (Vector) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String enDate = (String) request.getAttribute("endDate");
    String msgStatus = (String) request.getAttribute("msgStatus");
    String msgType = (String) request.getAttribute("msgType");
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1);
    int a = cal.get(Calendar.YEAR);
    int b = (cal.get(Calendar.MONTH)) + 1;
    int d = cal.get(Calendar.DATE);
    String prev = a + "/" + b + "/" + d;
    String age = "";
    int diffDays = 0;
    int diffMonths = 0;
    int diffYears = 0;

    WebBusinessObject catWbo = new WebBusinessObject();
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = "Ar";
    String align = "center";
    String dir = null;
    String style = null, lang, langCode, cancel, title, beginDate, endDate, print;
    String complaintNo, customerName, complaintDate, complaint;
    String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, type, compStatus, compSender, noResponse, ageComp;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        cancel = "Cancel";
        title = "Complaints Reprot";
        beginDate = "From Date";
        endDate = "To Date";
        print = "Print";
        complaintNo = "Order No.";
        customerName = "Customer name";
        complaintDate = "Calling date";
        complaint = "Complaint";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        view = "View";
        complaintCode = "Complaint code";
        type = "Type";
        compStatus = "Staus";
        compSender = "Sender";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "A.C(day)";

    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        title = "";

        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        complaintDate = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1575;&#1578;&#1589;&#1575;&#1604;";
        complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
        type = "النوع";
        compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        compSender = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";

    }

%>

<script src='ChangeLang.js' type='text/javascript'></script>
<script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
<script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
<link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">


<script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>

<script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
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
            
        var beginDate = document.getElementById("beginDate").value;
        var endDate = document.getElementById("endDate").value;
        document.COMP_FORM.action ="<%=context%>/SearchServlet?op=SearchForComplaints&beginDate="+beginDate+"&endDate="+endDate;
        document.COMP_FORM.submit();  
    }
    
    
    
    function getComplaints() {

        var beginDate = $("#beginDate").val();
 
        var endDate = $("#endDate").val();
        if((beginDate=null||beginDate=="")){
            alert("من فضلك أدخل تاريخ البداية");
        }
        else if((endDate=null||endDate=="")){
            alert("من فضلك أدخل تاريخ النهاية");
           
        }else{
            beginDate = $("#beginDate").val();
            endDate = $("#endDate").val();
            var type=$("#type").val();
            var compStatus=$("#compStatus").val();
            document.COMP_FORM.action = "<%=context%>/SearchServlet?op=SearchForComplaints2&beginDate="+beginDate +"&endDate="+endDate+"&type="+type+"&compStatus="+compStatus
            document.COMP_FORM.submit();
            //                $("#username").val("");
        }
    }
    
    
    
    
    function searchForComplaints(){
      
        var beginDate = $("#beginDate").val();
 
        var endDate = $("#endDate").val();
        var type=$("#type").val();
        var compStatus=$("#compStatus").val();

       

        $.ajax({
            type: "post",
            url: "<%=context%>/SearchServlet?op=SearchForComplaints",
            data: {
               
                beginDate :beginDate,
                endDate: endDate,
                type:type,
                compStatus:compStatus
            },
            success: function(jsonString) {
                var eqpEmpInfo = $.parseJSON(jsonString);

                if (eqpEmpInfo.status == 'Ok') {

                    $("#save" + x).html("");
                    $("#save" + x).css("background-position", "top");
                }
            }
        });

    }
</script>


<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">

    </head>
    <body>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>

        <FORM NAME="COMP_FORM" METHOD="POST">

            <table align="center" width="80%">
                <tr><td class="td">
                        <fieldset >
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%>

                                            </font>

                                        </td>
                                    </tr>
                                </table>
                            </legend>
                            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                                <TR>

                                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </TD>
                                    <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </TD>
                                </TR>
                                <TR>

                                    <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                            String url = request.getRequestURL().toString();
                                            String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <% if (enDate != null && !enDate.isEmpty()) {%>

                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </TD>

                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (enDate != null && !enDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=enDate%>" ><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>

                                </TR>
                                <tr>
                                    <td>
                                        <label style="font-size: 16px;color:blue;" >النوع</label>
                                        <select style="font-size: 14px;font-weight: bold;" id="type">
                                            <option value="1">شكوى</option>
                                            <option value="2">طلب</option>

                                            <option value="3">إستعلام</option>
                                        </select>
                                    </td>
                                    <td>
                                        <label style="font-size: 16px;color: red;" > المسئولية</label>
                                        <select style="font-size: 14px;font-weight: bold;"id="compStatus" >
                                            <option value="3">للعلم</option>
                                            <option value="2">للمساعدة</option>

                                        </select>
                                    </td>

                                </tr>
                                <tr>
                                <br><br>
                                <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                                    <button  onclick="JavaScript: getComplaints();"   STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  

                                </TD>
                                </tr>
                            </table>

                        </fieldset>

                </tr></td ></table>
        </FORM>
        <% if (data != null && !data.isEmpty()) {%>                              
        <% if (msgType != null && !msgType.isEmpty() && msgStatus != null && !msgStatus.isEmpty()) {%>                                
        <div style="float: right;width: 100%;text-align: right;"> <font style="font-family: serif,arial;font-size: 20px;color:#FF6600;"><b><%=msgType%> <%=msgStatus%></b></font>  
        </div>
        <div style="float: right;margin-bottom: 5PX;">
            <hr style="width:18em;" align="right"/>
        </div>
        <% }%>                                
        <table class="blueBorder"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
            <thead>
                <TR>

                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%"><SPAN><b>مرسل من</b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%"><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%"><SPAN><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%"><SPAN><b>نصائح التوجية</b></SPAN></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>وقت الإستلام</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b><%=ageComp%></b></TH>

                </TR>
            </thead> 
            <tbody  id="planetData2">  
                <%

                    Enumeration e = data.elements();

                    WebBusinessObject wbo = new WebBusinessObject();
                    while (e.hasMoreElements()) {

                        wbo = (WebBusinessObject) e.nextElement();
                        WebBusinessObject senderInf = null;
                        UserMgr userMgr = UserMgr.getInstance();
                        senderInf = userMgr.getOnSingleKey(wbo.getAttribute("senderId").toString());
                %>
                <TR style="padding: 1px;">

                    <TD class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px" >
                        <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                    </TD>


                    <TD style="border-left:0px; border-right:0px; border-bottom: 1px black; ">

                        <%if (wbo.getAttribute("customerName") != null) {%>
                        <b><%=wbo.getAttribute("customerName")%></b>
                        <%}%>

                    </TD>

                    <TD style="border-left:0px; border-right:0px; border-bottom: 1px black; ">

                        <%if (senderInf.getAttribute("userName") != null) {%>
                        <b><%=senderInf.getAttribute("userName")%></b>
                        <%}%>

                    </TD>

                    <TD style="border-left:0px; border-right:0px; border-bottom: 1px black; ">

                        <%if (wbo.getAttribute("comments") != null) {
                                String comment = null;
                                String s = (String) wbo.getAttribute("comments");
                                if (s.length() > 10) {
                                    comment = s.substring(0, 20);
                                } else {
                                    comment = s;
                                }
                        %>
                        <b><%=comment%></b>
                        <%}%>

                    </TD>
                    <TD style="border-left:0px; border-right:0px; border-bottom: 1px black; ">

                        <%if (wbo.getAttribute("businessCompId") != null) {%>
                        <b><%=wbo.getAttribute("businessCompId")%></b>
                        <%}%>

                    </TD>

                    <TD style="border-left:0px; border-right:0px; border-bottom: 1px black; ">

                        <%if (wbo.getAttribute("manager_comment") != null) {%>
                        <b><%=wbo.getAttribute("manager_comment")%></b>
                        <%}%>

                    </TD>

                    <%
                        String sDate, sTime = null;
                        DateFormat formatter;
                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                        String[] arrDate = wbo.getAttribute("entryDate").toString().split(" ");
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

                    <TD nowrap class="blueBorder blueBodyTD" STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px"><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>

                    <td style="border-left:0px; border-right:0px; border-bottom: 1px black; ">
                        <%
                            try {
                                out.write("<b>" + DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar") + "</b>");
                            } catch (Exception E) {
                                out.write("<b>" + noResponse + "</b>");
                            }
                        %>
                    </td>



                </TR>


                <%

                        }
                    }

                %>


            </tbody>

        </table>
    </BODY>
</HTML>     
