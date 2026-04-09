<%@page import="org.w3c.dom.Document"%>
<%@page import="com.docviewer.db_access.DocTypeMgr"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
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

    Document doc = null;
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    Vector<WebBusinessObject> docTypes = docTypeMgr.getCashedTable();
//     Vector<WebBusinessObject> docTypes = (Vector) request.getAttribute("docTypes");
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
    String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, docType, type, viewAttach, compStatus, compSender, noResponse, ageComp;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        cancel = "Cancel";
        title = "Search For Docs";
        beginDate = "From Date";
        endDate = "To Date";
        print = "Print";
        complaintNo = "Document Title";
        customerName = "Project Name";
        complaintDate = "Document date";
        complaint = "Document Type";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        view = "View";
        complaintCode = "Description";
        type = "Type";
        compStatus = "Staus";
        compSender = "Sender";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "A.C(day)";
        viewAttach = "View Docs";
        docType = "Doc Type";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        title = "بحث عن مستند";

        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        complaintNo = "عنوان المستند ";
        customerName = "اسم المعده";
        complaintDate = "تاريخ المستند";
        complaint = "نوع المستند";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        complaintCode = "الوصف";
        type = "النوع";
        compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        compSender = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
        viewAttach = "مشاهدة المستند";
        docType = "نوع الملف";
    }

%>



<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/locale/easyui-lang-ar.js">
        <script type="text/javascript" src="jquery-easyui/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-easyui/jquery.easyui.min.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">     

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

    </head>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function() {
            $("#endDate").datepicker({
                changeMonth: true,
                changeYear: true,
                minDate: "+d",
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
        }); 
        function submitForm()
        {    
            var configItemType= document.getElementById("configItemType").value;    
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            document.COMP_FORM.action ="<%=context%>/SearchServlet?op=SearchForComplaints&beginDate="+beginDate+"&endDate="+endDate+"&configItemType="+configItemType;
            document.COMP_FORM.submit();  
        }

    </script>
    <style type="text/css">
        #data tr,td{
            border: none;

        }

    </style>
    <body>
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
                                    <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </TD>
                                </TR>
                                <TR>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" > 
                                        <br><br>
                                    </td>
                                </TR>
                            </table>
                        </fieldset>
                </tr></td ></table>
        </FORM>
</BODY>
</HTML>     
