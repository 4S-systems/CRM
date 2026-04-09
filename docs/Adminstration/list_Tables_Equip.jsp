<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.persistence.relational.UniqueIDGen,com.workFlowTasks.db_access.*,com.tracker.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>


<%

        System.out.println("In Page  Now ----------------");
        String status = (String) request.getAttribute("status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

        String context = metaMgr.getContext();
//
        String url = context + "/ScheduleServlet?op=SearchTablesEquip";

//paging
        Vector issueList = (Vector) request.getAttribute("data");
        int noOfLinks = 0;
        int count = 0;
        String[] projectAttributes = {"maintTitle","unitName"};
        String[] projectListTitles = new String[2];
         int s = projectAttributes.length;
         int t = s;

        String tempcount = (String) request.getAttribute("count");
        if (tempcount != null) {
            count = Integer.parseInt(tempcount);
        }
        String tempLinks = (String) request.getAttribute("noOfLinks");
        if (tempLinks != null) {
            noOfLinks = Integer.parseInt(tempLinks);
        }
        //paging
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String formName = (String) request.getAttribute("formName");
        Vector codes = (Vector) request.getAttribute("codes");

        String bgColor = null;
        int flipper = 0;
// get current date
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfTime = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        String nowDate = sdf.format(cal.getTime());
        String[] date = nowDate.split("/");
        String seq = date[0] + "/" + date[2];

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
         String attName = null;
        String attValue = null;
        String absalign = "";
        String dir = null;
        String style = null;
        String lang, langCode;
        String task_subject;
        String saving_status, Dupname;
        String task_name_ar, task_desc_ar;
        String task_name_en, task_desc_en;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label;
        String fStatus;
        String sStatus;
        String selectFromList;
        String code, department, taskType, orderDate, userName, service, altIm, po, account, develop, management,
               TotalTablesMsg, attachFile, sNotify, sAll, mailForNotify, fileTypeError, customerName, relationType, search;

        if (stat.equals("En")) {

            TotalTablesMsg="Total Numbers Of Tables is "+codes.size();
            projectListTitles[0]="Table Name";
            projectListTitles[1]="Equipment Name";
            saving_status = "Saving status";
            align = "center";
            absalign = "Left";
            dir = "LTR";
            style = "text-align:left";
            lang = "  &#1593;&#1585;&#1576;&#1610; ";

            title_1 = "New SubTicket";
            title_2 = "All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            langCode = "Ar";
            Dupname = "Name is Duplicated Chane it";
            sStatus = "Ticket Saved Successfully";
            fStatus = "Fail To Save This Ticket";
            customerName = "Customer Name";
            relationType = "Relation Type";
            search = "search";

        } else {
            TotalTablesMsg="&#1593;&#1583;&#1583; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1605;&#1578;&#1575;&#1581;&#1577; &#1604;&#1607;&#1584;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; = " +codes.size();
            projectListTitles[0]="&#1575;&#1587;&#1605; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
            projectListTitles[1]="&#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            absalign = "Right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            customerName = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";

            title_1 = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1593;&#1605;&#1604;&#1575;&#1569;";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            langCode = "En";
            Dupname = "&#1578;&#1608;&#1580;&#1583; &#1605;&#1607;&#1605;&#1607; &#1576;&#1606;&#1601;&#1587; &#1575;&#1604;&#1575;&#1587;&#1605; &#1605;&#1606; &#1601;&#1590;&#1604;&#1603; &#1594;&#1610;&#1585; &#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            fStatus = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            sStatus = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
            search = "&#1576;&#1581;&#1579;";

            fileTypeError = "&#1582;&#1591;&#1571; &#1601;&#1609; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;";
            relationType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1604;&#1575;&#1602;&#1577;";
        }


%>



<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>List OF Equipment Tables</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <link rel="stylesheet" type="text/css" href="css/headers.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>

</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

function reloadAE(nextMode){

            var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
                {
                    req = new XMLHttpRequest();
                }
                else if (window.ActiveXObject)
                    {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("Post",url,true);
                    req.onreadystatechange =  callbackFillreload;
                    req.send(null);

                }

                function callbackFillreload(){
                    if (req.readyState==4)
                        {
                            if (req.status == 200)
                                {
                                    window.location.reload();
                                }
                            }
                        }
    function sendInfo(name,id)
    {
        var name = name;
        if(name =="null" || name =="")
        {
            window.opener.document.<%=formName%>.unit.value = "";
            window.close();
        }
        else
        {
            window.opener.document.<%=formName%>.unit.value = name;
            window.close();
        }

        var id = id;
        if(id =="null" || id =="")
        {
            window.opener.document.<%=formName%>.unitCatID.value = "";
            window.close();
        }
        else
        {
            window.opener.document.<%=formName%>.unitCatID.value = id;
            window.close();
        }
    }

    function goToUrlDown(){
    var no = document.getElementById('pageNoDown').value;
        var url = "<%=url%>&count=" + no;
        document.Tables_FORM.action = url;
        document.Tables_FORM.submit();
    }
    function goToUrlUp(){
        var no = document.getElementById('pageNoUp').value;
        var url = "<%=url%>&count=" + no;
        document.Tables_FORM.action = url;
        document.Tables_FORM.submit();
    }

</SCRIPT>

<script type="text/javascript" src="js/ChangeLang.js"></script>
<BODY style="background-color:white">
<script type="text/javascript" src="js/wz_tooltip.js"></script>
<script type="text/javascript" src="js/tip_balloon.js"></script>
<FORM NAME="Tables_FORM" id="Tables_FORM" METHOD="POST" >


<BR>
<legend align="center">
    <table dir="<%=dir%>" align="<%=align%>">
        <tr>

            <td class="td">
                <font color="blue" size="6"><%="List of Equipment Tables"%></font>
            </td>
        </tr>
    </table>
</legend>

<BR>

<div align="center">
    <input type="hidden" name="url" value="<%=url%>" id="url" >
        <input type="hidden" name="formName" value="<%=formName%>" />

    <%if (noOfLinks > 0) {%>
    <font size="3" color="red" style="font-weight:bold" >Page No</font><font size="3" color="black" ><%=(count + 1)%></font><font size="3" color="red" style="font-weight:bold" > of </font><font size="3" color="black" ><%=noOfLinks%></font>
    &ensp;
    <select id="pageNoUp" onchange="goToUrlUp()" style="font-size:14px;font-weight:bold;color:black">
        <%for (int i = 0; i < noOfLinks; i++) {%>
        <option  value="<%=i%>" <%if (i == count) {%> selected <%}%> ><%=(i + 1)%></option>
        <%}%>
    </select>
    <%
        }
    %>
</div>

<BR>

<TABLE ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="400" STYLE="border-width:1px;border-color:white;">

<TR CLASS="header">
<%
                    String columnColor = new String("");
                    String columnWidth = new String("");
                    String font = new String("");
                    for(int i = 0;i<t;i++) {
                        if(i == 0 || i == 1){
                            columnColor = "#9B9B00";
                        } else {
                            columnColor = "#7EBB00";
                        }
                    %>
                    <TD nowrap CLASS="header" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0;<%=style%>;padding-left:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=projectListTitles[i]%></B>
                    </TD>
                    <%
                    }
                    %>

                </TR>

<%

        WebBusinessObject wbo = new WebBusinessObject();
        Enumeration e = issueList.elements();
        String classStyle="tRow2";
        while (e.hasMoreElements()) {

            wbo = (WebBusinessObject) e.nextElement();

            flipper++;
                    if((flipper%2) == 1) {
                        classStyle="tRow2";
                    } else {
                        classStyle="tRow";
                    }

%>
                <TR>

                    <%
                    for(int i = 0;i<s;i++) {

                        attName = projectAttributes[i];
                        attValue = (String) wbo.getAttribute(attName);

                    %>

                    <TD  STYLE="<%=style%>;padding-left:60;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <b style="text-decoration: none"> <font color="black" size="3"> <%=attValue%> </font> </b> </a>
                    </TD>


                    <%
                    }
                    %>
                </TR>
                <% }%>
                <TR CLASS="header" >
                    <TD NOWRAP CLASS="header" bgcolor="#9B9B00" STYLE="border-WIDTH:0;<%=style%>;padding-justify:110;font-size:16;color:white;height:30;" nowrap>
                        <B><%=TotalTablesMsg%></B>
                    </TD>
                    <TD NOWRAP CLASS="header" bgcolor="#9B9B00" STYLE="border-WIDTH:0;<%=style%>;padding-justify:110;font-size:16;color:white;height:30;" nowrap>
                        
                    </td>
                </TR>

</TABLE>

<div align="center">
    <input type="hidden" name="url" value="<%=url%>" id="url" >
    <%if (noOfLinks > 0) {%>
    <br>
    <font size="3" color="red" style="font-weight:bold" >Page No</font><font size="3" color="black" ><%=(count + 1)%></font><font size="3" color="red" style="font-weight:bold" > of </font><font size="3" color="black" ><%=noOfLinks%></font>
    &ensp;
    <select id="pageNoDown" onchange="goToUrlDown()" style="font-size:14px;font-weight:bold;color:black"/>
        <%for (int i = 0; i < noOfLinks; i++) {%>
        <option  value="<%=i%>" <%if (i == count) {%> selected <%}%> ><%=(i + 1)%></option>
        <%}%>
    </select>
    <%
        }
    %>
</div>
</FORM>

</BODY>

</HTML>
