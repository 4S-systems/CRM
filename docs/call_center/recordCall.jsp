<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.maintenance.db_access.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();

    Calendar cal = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd hh:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(cal.getTime());

    String call_status = (String) request.getAttribute("call_status");
    String entryDate = (String) request.getAttribute("entryDate");

    if (call_status == null) {
        call_status = "";

    }

    WebBusinessObject issueWbo = (WebBusinessObject) request.getAttribute("issueWbo");

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList complaintList = projectMgr.getSubProjectsByCode("cmp");

    String context = metaMgr.getContext();

//Get request data
    String issueId = (String) request.getAttribute("issueId");


    Vector DepComp = (Vector) request.getAttribute("DepComp");



    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");

    WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");
    String status = (String) request.getAttribute("status");
    Boolean isChecked = false;

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String cellAlign = null;
    String message = null;
    String lang, langCode, calenderTip, cancel, save, title, JOData, JONo, forEqp, task, complaint, entryTime, notes, add, delete, noComplaints, M, M2;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        cellAlign = "left";

        cancel = "Back";
        save = "Save";
        title = "Relate complaints to tasks";
        JOData = "Job Order Data";
        JONo = "Job Order Number";
        forEqp = "Equipment Name";
        task = "Task Name";
        complaint = "Complaint";
        entryTime = "Entry date";
        notes = "Recommendations";
        add = "Select";
        delete = "Delete Selection";
        noComplaints = "No complaints related to this job order";
        M = "Data Had Been Saved Successfully";
        M2 = "Saving Failed ";
        calenderTip = "click inside text box to opn calender window";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cellAlign = "right";

        cancel = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
        title = "&#1593;&#1585;&#1590; &#1608;&#1578;&#1581;&#1604;&#1610;&#1604; &#1575;&#1604;&#1588;&#1603;&#1575;&#1608;&#1609;";
        JOData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        JONo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        forEqp = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        task = "&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        complaint = "&#1575;&#1604;&#1588;&#1603;&#1608;&#1609;";
        entryTime = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1588;&#1603;&#1608;&#1609;";
        notes = "&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
        add = "&#1575;&#1582;&#1578;&#1585;";
        delete = "&#1581;&#1584;&#1601; &#1575;&#1604;&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
        noComplaints = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1588;&#1603;&#1575;&#1608;&#1609; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        M = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
        M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
    }

    String clientId = (String) request.getAttribute("clientId");

%>
<HTML>
    <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
    <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

    <script type="text/javascript" src="js/jquery.chained.remote.min.js"></script>  
    <script type="text/javascript">

        function submitForm()
        {

            if (($("#note").val().length == 0)) {
                alert("من فضلك أدخل تعليق عن المكالمة");
                return true;
            }
            else {
                document.CLIENT_COMPLAINT_FORM.action = "<%=context%>/IssueServlet?op=insertNewCmplPopup&type=call";
                document.CLIENT_COMPLAINT_FORM.submit();

            }
        }

        function cancelForm() {
            document.CLIENT_COMPLAINT_FORM.action = "<%=context%>/SearchServlet?op=searchForClient";
            document.CLIENT__FORM.submit();
        }

    </script>


    <script src='ChangeLang.js' type='text/javascript'></script>


    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>record call</title>
        <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

    </head>

    <script type="text/javascript">

        $(document).ready(function() {

            $("#entryDate").datetimepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                timeFormat: 'hh:mm',
                dateFormat: 'yy/mm/dd'
            });

        });

    </script>
    <style>
        body{
            font-size: 10px;
        }
        textarea{
            resize:none;
        }
        table td{
            padding:5px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            height:20px;
            border: none;
        }
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
        }

        #claim_division {

            width: 97%;
            display: none;
            margin:3px auto;
            border: 1px solid #999;
        }
        #order_division{

            width: 97%;
            display: none;
            margin:3px auto;
            border: 1px solid #999;
        }

        .div{

            direction: rtl;
        }

        #call_center{
            direction:rtl;
            padding:0px;
            margin-top: 5px;
            margin-left: auto;
            margin-right: auto;
            margin-bottom: 5px;
            color:#005599;
            /*            height:600px;*/
            width:100%;
            position:relative;
            border:1px solid #f1f1f1;
            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;

        }
        #title{padding:10px;
               margin:0px 10px;
               height:30px;
               width:95%;
               clear: both;
               text-align:center;

        }
        .text-success{
            font-family:Verdana, Geneva, sans-serif;
            font-size:24px;
            font-weight:bold;
        }

        /*        #unit_division {
                    width:46%;
                    float:left;
                    border: 1px solid red;
                                height:200px;
        
                    margin-top: 0px;
                    margin-right: 5px;
                    margin-bottom: 5px;
                    margin-left: 5px;
                                padding-top: 10px;
                                padding-right: 10px;
                                padding-bottom: 10px;
                                padding-left: 10px;
        
                }*/
        /*        #customer_division {
                    width:46%;
                    border: 1px solid red;
        
                                height:200px;
                    margin-top: 0px;
                    margin-right: 0px;
                    margin-bottom: 0px;
                    margin-left: 46%;
                                padding-top: 10px;
                                padding-right: 10px;
                                padding-bottom: 10px;
                                padding-left: 10px;
        
                }*/
        /*        #information { 
                    padding:10px;
                    width: 96%;
                    margin: 5px auto;
                    height:220px;
                }*/
        #tableDATA th{

            font-size: 15px;
        }

        .save {
            width:32px;
            height:32px;
            background-image:url(images/icons/check.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .status{

            width:32px;
            height:32px;
            background-image:url(images/icons/status.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .remove {
            width:32px;
            height:32px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/remove.png);

        }
        .button_order {
            width:104px;
            height:40px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/request_.png);
        }
        .button_claim {
            width:104px;
            height:40px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/claimm.png);
        }
        .button_query{
            width:104px;
            height:40px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/query_.png);
        }
        .button_close{
            width:76px;
            height:35px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/close_.png);
        }
        .button_record{
            width:145px;
            height:31px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
    </style>
    <body>
        <FORM NAME="CLIENT_COMPLAINT_FORM" METHOD="POST">
            <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>"/>

            <div  id="call_center" class="div" >


                <table style="width: 60%;margin-top: 7px;" class="table">
                    <tr algin="center">
                        <td colspan="2" class="blueBorder blueHeaderTD" style="font-size:17px;">المكالمة / المقابلة</td>
                    </tr>
                    <!--                    <tr>
                                            <td style="border-left: none;width: 50%;">
                    
                                                <table width="100%"   dir="rtl" height="100%" style="border-left:0px;">-->
                    <tr>
                        <td  width="30%" style="color: #000;" class="excelentCell formInputTag"  >رقم المتابعة</td>

                        <td style="<%=style%>">

                            <%if (status != null && status.equalsIgnoreCase("success")) {%>
                            <b>
                                <font color="red" size="3" id="businessId"><%=issueWbo.getAttribute("businessID")%>/</font><font color="blue" size="3" ><%=issueWbo.getAttribute("businessIDbyDate")%></font>
                            </b>
                            <%}%>

                        </td>

                    </tr>

                    <tr>
                        <td  style="color: #000;" class="excelentCell formInputTag" >تعليق عام </td>
                        <td style="text-align:right;">
                            <% if (status != null && status.equalsIgnoreCase("success") && issueWbo.getAttribute("issueDesc") != null) {%>
                            <textarea name="note" id="note" rows="5" cols="10" style="width:100%;" resize="false" ><%=issueWbo.getAttribute("issueDesc")%></textarea></td>
                            <%} else {%>
                    <textarea name="note" id="note" rows="5" cols="10" style="width:100%;" resize="false" ></textarea></td>
                    <% }%>
                    </tr>
                    <!--                </table>
                                    </td>-->
                    <!--                <td  style="border-right: none;width: 50%;">
                    
                                        <table border="1px" width="100%" class="table">-->
                    <tr>
                        <td width="30%"  style="color: #000;" class="excelentCell formInputTag"> نوع المكالمة</td>
                        <%if (status != null && status.equalsIgnoreCase("success")) {%>
                        <td style="text-align:right;">
                            <input  name="call_status" type="radio" value="incoming" <%if (call_status.equals("incoming")) {%> checked <%}%> />
                            <label>واردة</label>
                            <input name="call_status" type="radio" value="out_call" style="margin-right: 10px;" <%if (call_status.equals("out_call")) {%> checked <%}%>/>
                            <label>صادرة</label>
                        </td>
                        <% } else {%>
                        <td style="text-align:right;">
                            <input  name="call_status" type="radio" value="incoming" checked />
                            <label>واردة</label>
                            <input name="call_status" type="radio" value="out_call" style="margin-right: 10px;"/>
                            <label>صادرة</label>
                        </td>
                        <% }%>
                    </tr>
                    <tr>
                        <td  style="color: #000;" class="excelentCell formInputTag">التاريخ</td>
                        <td dir="ltr" style="<%=style%>"> <input name="entryDate" id="entryDate" type="text" size="50" maxlength="50" style="width: 45%;" value="<%=(entryDate == null) ? nowTime : entryDate%>"/><img alt=""  style="margin-right: 5px;" src="images/showcalendar.gif" onMouseOver="Tip('<%=calenderTip%>', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE, 'Display Calender Help', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"  /></td>
                    </tr>
                    <tr>
                        <td colspan="2">

                            <%if (status != null && status.equalsIgnoreCase("success")) {
                            %>
                            <script type="text/javascript">

        var table = window.opener.document.getElementById('clientInf');
        //                       alert(businessId)
        var row;
        row = table.insertRow();
        var cell0 = row.insertCell(0);
        cell0.width = "200px";
        cell0.className = "businessNumTitle";
        cell0.innerHTML = "رقم المتابعة";

        var cell1 = row.insertCell(1);
        //     
        var businessId =<%=issueWbo.getAttribute("businessID")%>;
        cell1.className = "businessNum";
        cell1.innerHTML =<%=issueWbo.getAttribute("businessID")%> + "<input type='hidden' value='" + businessId + "' id='businessId'/>";
        var recordBtn = window.opener.document.getElementById('recordCall');
        var productBtn = window.opener.document.getElementById('productsBtn');
        var seasonBtn = window.opener.document.getElementById('seasonBtn');
        var degreeBtn = window.opener.document.getElementById('degreeBtn');
        var redirectBtn = window.opener.document.getElementById('redirectCust');
        $(productBtn).css("display", "inline-block");
        $(redirectBtn).css("display", "inline-block");
        $(seasonBtn).css("display", "inline-block");
        $(degreeBtn).css("display", "inline-block");
        recordBtn.parentNode.removeChild(recordBtn);


        setTimeout('self.close()', 000)
                            </script>
                            <% } else {%>
                            <div style="margin-left: auto;margin-right: auto;text-align:center;">  
                                <!--<input name="save_info" type="button" onclick="JavaScript:  submitForm();" id ="save_info" value="تسجيل المكالمة" class="btn btn-large btn-success" />-->
                                <input  name="save_info" type="button" onclick="JavaScript:  submitForm();" id ="save_info"class="button_record"/>
                            </div>
                            <% }%>


                        </td>

                    </tr>

                </table>
            </div>

        </FORM>
    </body>
</html>
