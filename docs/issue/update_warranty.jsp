<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();

            TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
            String cMode = (String) request.getSession().getAttribute("currentMode");
            WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
            String stat = cMode;
            Calendar cal = Calendar.getInstance();
            String jDateFormat = user.getAttribute("javaDateFormat").toString();
            SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
            String nowTime = sdf.format(cal.getTime());
            String align = null;
            String dir = null;
            String style = null;
            String cancel, addWarranty, vendor, bDate, eDate, note, calenderTip, submit;

            if (stat.equals("En")) {
                align = "center";
                dir = "LTR";
                style = "text-align:left";
                cancel = "Cancel";
                addWarranty = "Warranty Information";
                vendor = "Vendor";
                bDate = "Begin Date";
                eDate = "End Date";
                note = "Note";
                submit = "update";
                calenderTip = "click inside text box to opn calender window";
            } else {
                align = "center";
                dir = "RTL";
                style = "text-align:Right";
                cancel = "&#1573;&#1594;&#1604;&#1575;&#1602;";
                addWarranty = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
                vendor = "&#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
                bDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;";
                eDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1575;&#1606;&#1578;&#1607;&#1575;&#1569;";
                note = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
                submit = "&#1578;&#1581;&#1583;&#1610;&#1579;";
                calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            }
            WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("oldWarranty");
%>
<script LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
    {
        this.close();
    }
    function compareDate()
    {
        return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
    }
    function submitForm()
    {
        if (!compareDate()){
            alert('End Date must be greater than or equal Begin Date');
            return false;
        }
        var parent = window.opener;
        var row = parent.document.getElementById("<%=request.getParameter("itemCode")%>");
        var C = row.cells;

        var img = parent.document.getElementById("<%=wbo.getAttribute("quantifiedId")%>");
        img.setAttribute("src","images/pencil_16.png");

        C[0].innerHTML = "<input type='hidden' value='<%=wbo.getAttribute("quantifiedId")%>' id='partId' name='partId'>" +
            "<input readonly style='width: 99%;text-align: center' type='text' value='<%=request.getParameter("itemCode")%>' id='partCode' name='partCode'>";
        C[1].innerHTML = "<input readonly style='width: 99%;text-align: center' type='text' value='"+document.getElementById("vendor").value+"' id='vendor' name='vendor'>";
        C[2].innerHTML = "<input readonly style='width: 99%;text-align: center' type='text' value='"+document.getElementById("beginDate").value+"' id='bDate' name='bDate'>";
        C[3].innerHTML = "<input readonly style='width: 99%;text-align: center' type='text' value='"+document.getElementById("endDate").value+"' id='eDate' name='eDate'>";
        C[4].innerHTML = "<input readonly style='width: 99%;text-align: center' type='text' value='"+document.getElementById("note").value+"' id='note' name='note'>";
        C[5].innerHTML = "-";
        C[6].innerHTML = "-";

        this.close();
    }
</script>
<style type="text/css">
    .grayStyle {
        color: blue;
        font-size: 16px;
        font-weight: bold;
        background-color: #9b9b9b;
    }
</style>
<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>Update Warranty</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link rel="stylesheet" href="css/blueStyle.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
    </head>
    <script type="text/javascript" >
        var dp_cal1,dp_cal12;
        window.onload = function (){
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
            dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
        }
    </script>
    <body>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        <%if (request.getAttribute("Tap") == null) {%>
        <DIV align="left" STYLE="color:blue;">
            <button  class="button" onclick="JavaScript: cancelForm();"><%=cancel%></button>
            <button  class="button" onclick="JavaScript: submitForm();"><%=submit%></button>
        </DIV>
        <%}%>
        <br>
        <center>
            <fieldset class="set" style="border-color: #006699;width: 95%">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"><%=addWarranty%></FONT><BR></td>
                    </tr>
                </table>
                <br>
                <table align="<%=align%>" DIR="<%=dir%>" border="0" cellpadding="0" cellspacing="0" WIDTH=90%>
                    <tr>
                        <td style="border-width: 0px;background-color: window;color: black" class="blueHeaderTD"><%=vendor%></td>
                        <td style="border-width: 0px"><input size="50" maxlength="100" type="text" value="<%=wbo.getAttribute("vendor")%>" name="vendor" id="vendor"></td>
                    </tr>
                    <tr>
                        <td style="border-width: 0px;background-color: window;color: black" class="blueHeaderTD"><%=note%></td>
                        <td style="border-width: 0px"><textarea rows=""  cols="39" name="note" id="note"><%=wbo.getAttribute("note")%></textarea> </td>
                    </tr>
                    <tr>
                        <td style="border-width: 0px;background-color: window;color: black" class="blueHeaderTD"><%=bDate%></td>
                        <td style="border-width: 0px"><input readonly size="40" id="beginDate" name="beginDate" type="text" value="<%=wbo.getAttribute("bDate").toString().replaceAll("-", "/")%>" ><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" ></td>
                    </tr>
                    <tr>
                        <td style="border-width: 0px;background-color: window;color: black" class="blueHeaderTD"><%=eDate%></td>
                        <td style="border-width: 0px"><input readonly size="40" id="endDate" name="endDate" type="text" value="<%=wbo.getAttribute("eDate").toString().replaceAll("-", "/")%>" ><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" ></td>
                    </tr>
                </table>
                <br>
                <br>
            </fieldset>
        </center>
    </body>
</html>
