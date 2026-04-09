<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.IssueDocumentMgr"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page import="com.silkworm.util.DateAndTimeConstants"%>
<%@page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%@ page pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;

    RequestItemsDetailsMgr requestItemsDetailsMgr = RequestItemsDetailsMgr.getInstance();
    String issueId = request.getAttribute("IssueId").toString();

    List<WebBusinessObject> requestedItems = requestItemsDetailsMgr.getByIssueId(issueId);

    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
    }
%>

<head>
    <link rel="stylesheet" href="css/progress/style.css" />
    <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
    <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
    <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
    <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css" />
    <link REL="stylesheet" TYPE="text/css" HREF="css/Button.css" />

    <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
    <title>بنود أعمال</title>
</head>

<style type="text/css">  
    .titlebar {
        background-image: url(images/title_bar.png);
        background-position-x: 50%;
        background-position-y: 50%;
        background-size: initial;
        background-repeat-x: repeat;
        background-repeat-y: no-repeat;
        background-attachment: initial;
        background-origin: initial;
        background-clip: initial;
        background-color: rgb(204, 204, 204);
    }
    .vert { /* wider than clip to position buttons to side */
        margin-left: 2px;
        margin-right: 2px;
        width: 100%;
        height: auto;
    }

    .vert .simply-scroll-clip {
        width: 100%;
        height: auto;
    }

    // loading progress bar
    .container {width: 100px; margin: 0 auto; overflow: hidden;}
    .contentBar {width:100px; margin:0 auto; padding-top:0px; padding-bottom:0px;}
    .barlittle {
        background-color:#2187e7;  
        background-image: -moz-linear-gradient(45deg, #2187e7 25%, #a0eaff); 
        background-image: -webkit-linear-gradient(45deg, #2187e7 25%, #a0eaff);
        border-left:1px solid #111; border-top:1px solid #111; border-right:1px solid #333; border-bottom:1px solid #333; 
        width:10px;
        height:10px;
        float:left;
        margin-left:5px;
        opacity:0.1;
        -moz-transform:scale(0.7);
        -webkit-transform:scale(0.7);
        -moz-animation:move 1s infinite linear;
        -webkit-animation:move 1s infinite linear;
    }
    #block_1{
        -moz-animation-delay: .4s;
        -webkit-animation-delay: .4s;
    }
    #block_2{
        -moz-animation-delay: .3s;
        -webkit-animation-delay: .3s;
    }
    #block_3{
        -moz-animation-delay: .2s;
        -webkit-animation-delay: .2s;
    }
    #block_4{
        -moz-animation-delay: .3s;
        -webkit-animation-delay: .3s;
    }
    #block_5{
        -moz-animation-delay: .4s;
        -webkit-animation-delay: .4s;
    }
    @-moz-keyframes move{
        0%{-moz-transform: scale(1.2);opacity:1;}
        100%{-moz-transform: scale(0.7);opacity:0.1;}
    }
    @-webkit-keyframes move{
        0%{-webkit-transform: scale(1.2);opacity:1;}
        100%{-webkit-transform: scale(0.7);opacity:0.1;}
    }
    .headerTitle {
        font-size: 20px;
        color: darkred;
        text-align: right;
        padding-right: 20px;
        text-wrap: none;
    }
    .headerNumber {
        font-size: 17px;
        color: blue;
        text-align: right;
        text-wrap: none;
    }
</style>

<body>
    <table id="requestedItems" align="left" dir="rtl" STYLE="width: 99%; padding-left: .5%; margin-top: 0.5%" CELLPADDING="0" CELLSPACING="0">
        <thead>
            <tr>
                <td class="blueBorder blueHeaderTD" width="10%">كود</td>
                <td class="blueBorder blueHeaderTD" width="40%">اسم</td>
                <td class="blueBorder blueHeaderTD" width="9%">كمية</td>
                <td class="blueBorder blueHeaderTD" width="9%">موافق</td>
                <td class="blueBorder blueHeaderTD" width="32%">تعليق</td>
            </tr>
        </thead>
        <tbody>
            <%
                int counter = 0;
                String bgColorm, note;
                for (WebBusinessObject requestedItem : requestedItems) {
                    if ((counter % 2) == 1) {
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColorm = "silver_even_main";
                    }
                    note = (String) requestedItem.getAttribute("note");
                    if (note == null) {
                        note = "";
                    }
            %>
            <tr id="row<%=counter%>">
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                    <b><font size="2" color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("itemCode")%></font></b>
                </TD>
                <TD class="silver_footer" bgcolor="#808000" STYLE="text-align:center; color:black; font-size:14px; height: 25px">
                    <b><font color="#000080" style="text-align: center;"><%=requestedItem.getAttribute("itemName")%></font></b>
                </TD>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                    <input type="hidden" id="id<%=counter%>" name="id" value="<%=requestedItem.getAttribute("id")%>"/>
                    <input type="hidden" id="requestedItemId<%=counter%>" name="requestedItemId" value="<%=requestedItem.getAttribute("projectId")%>"/>
                    <input type="text" id="quantity<%=counter%>" name="quantity" value="<%=requestedItem.getAttribute("quantity")%>" style="text-align: center;width: 100%"
                           readonly />
                </TD>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                    <select id="accepted<%=counter%>" name="accepted" style="width: 100%" disabled >
                        <option value="<%=CRMConstants.REQUEST_ITEM_ACCEPTED%>" <%if (CRMConstants.REQUEST_ITEM_ACCEPTED.equalsIgnoreCase((String) requestedItem.getAttribute("valid"))) {%>selected=""<%}%>>مقبول</option>
                        <option value="<%=CRMConstants.REQUEST_ITEM_NOT_ACCEPTED%>" <%if (CRMConstants.REQUEST_ITEM_NOT_ACCEPTED.equalsIgnoreCase((String) requestedItem.getAttribute("valid"))) {%>selected=""<%}%>>مرفوض</option>
                    </select>
                </TD>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>">
                    <input type="text" id="note<%=counter%>" name="note" value="<%=note%>" style="width: 100%"
                           readonly />
                </TD>
            </tr>
            <% counter++;
                    }%>
        </tbody>
    </table>
</body>