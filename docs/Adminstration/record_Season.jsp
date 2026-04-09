<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        String status = (String) request.getAttribute("Status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        ArrayList allCode = (ArrayList) request.getAttribute("allCodes");
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String recordCode = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status;
        String season_code, english_name, arabic_name, forever;
        String title_1;
        String cancel_button_label;
        String save_button_label;
        String fStatus;
        String sStatus;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";

            english_name = "English Name";
            season_code = "Communication Channel";
            arabic_name = "Name";
            recordCode = "Automatic Code:";
            title_1 = "New Communication Tool أداة أتصال جديدة";
            //title_2="All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            sStatus = "Season Saved Successfully";
            fStatus = "Fail To Save This Season";
            langCode = "Ar";
            forever = "Forever";
        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            english_name = "الاسم الانجليزي";
            season_code = "قناة الأتصال";
            arabic_name = "الاسم";
            recordCode = "كود الحملة التلقائي :";

            title_1 = "New Communication Tool أداة أتصال جديدة";
            //title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            fStatus = "لم يتم تسجيل أداة الأتصال";
            sStatus = "تم تسجيل أداة الأتصال بنجاح";


            langCode = "En";
            forever = "دائما";
        }


    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>new Client</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="autosuggest.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>

        <%-----------------------------------------%>
        <script src="js/dhtmlxcommon.js"></script>
        <script src="js/dhtmlxcombo.js"></script>
        <link rel="STYLESHEET" type="text/css" href="css/dhtmlxcombo.css">
        <%-----------------------------------------%>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <!--        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>-->

    </HEAD>
    <script type="text/javascript">
        $(document).ready(function() {

            var dates = $("#begin_date, #end_date").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                changeYear: true,
                minDate: "+d",
                dateFormat: "yy/mm/dd",
                numberOfMonths: 1,
                showAnim: 'drop',
                onSelect: function(selectedDate) {
                    var option = this.id == "begin_date" ? "minDate" : "maxDate",
                            instance = $(this).data("datepicker"),
                            date = $.datepicker.parseDate(
                            instance.settings.dateFormat ||
                            $.datepicker._defaults.dateFormat,
                            selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);

                    dates.not("#begin_date").datepicker("option", "minDate", date);

                }
            });

        });
    </script>
    <script type="text/javascript">
        var dp_cal1;
        var dp_cal12;
        function go(x) {
            $.ajax({
                url: "<%=context%>/SeasonServlet",
                dataType: 'json',
                data: "op=ajaxGetCode&code=" + x,
                success: function(data) {
                    $('#arabicName').val(data['arabicName']);
                    $('#englishName').val(data['englishName']);
//                    $('#cost').val(data['cost']);
//                    $('#begin_date').val(data['beginDate']);
//                    $('#end_date').val(data['endDate']);
//                    $('#begin_date_Number').val(data['beginDateNumber']);
//                    $('#end_date_Number').val(data['endDatenumber']);
                    $('#prep_shoulder').val(data['preparation_shoulder']);
                    $('#closer_shoulder').val(data['closur_shoulder']);
                }
            });
        }

//        window.onload = function() {
////            dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('begin_date'));
////            dp_cal12 = new Epoch('epoch_popup', 'popup', document.getElementById('end_date'));
//
//        }


        function submitForm()
        {
            
//            if (!validateData("req", this.SEASON_FORM.cost, "Please, Enter Cost of the campaign.") || !validateData("numeric", this.SEASON_FORM.cost, "Cost of the campaign Number only.")) {
//                this.SEASON_FORM.cost.focus();
//                return;
//            }
//            else if (!document.SEASON_FORM.gender.required) {
//                alert("please select gender");
//            }
//            else if (!validateData("req", this.SEASON_FORM.begin_date, "Please, Enter Begin Date.") ) {
//                this.SEASON_FORM.begin_date.focus();
//                return;
//            } else if (!validateData("req", this.SEASON_FORM.end_date, "Please, Enter End Date.") ) {
//                this.SEASON_FORM.end_date.focus();
//                return;
//            } 
//            var begin_date=document.getElementById("begin_date").value;
//            var end_date=document.getElementById("end_date").value;
//            var monthNames = [ "January", "February", "March", "April", "May", "June",     "July", "August", "September", "October", "November", "December" ]; 
//            var beginMonth,endMonth=null;

//            var begin_date_Number=document.getElementById("begin_date_Number").value;
//            var end_date_Number=document.getElementById("end_date_Number").value;
//            var begin_dateNumber,end_dateNumber = null;
//            if((begin_date.length == 10) && (end_date.length == 10)){
//            beginMonth = begin_date.substring(5,7);
//            endMonth = end_date.substring(5,7);
//            if((begin_date_Number >0) &&(begin_date_Number <10)){
//                begin_dateNumber="0"+begin_date_Number;
//            }
//            if((end_date_Number >0) && (end_date_Number <10)){
//                end_dateNumber="0"+end_date_Number;
//            }else{
//                begin_dateNumber=begin_date_Number;
//                end_dateNumber=end_date_Number;
//            }
            /* alert(begin_dateNumber+"\t"+end_dateNumber +"\n"+beginMonth+"\t"+endMonth);*/
//            if((beginMonth != begin_dateNumber)){
//                alert("Error in begin Date should be in " +monthNames[--begin_date_Number]+"\t\n,insert new Date ");
//            }else if(endMonth != end_dateNumber){
//                alert("Error in end Date should be in " +monthNames[--end_date_Number]+ "\n,insert new Date");
//            }
//            else if(!validateData("req", this.SEASON_FORM.recordCode, "Please, enter Season Number.")){
//            this.SEASON_FORM.recordCode.focus();
//            }
//            else {
            document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=saveRecordSeason";
            document.SEASON_FORM.submit();
//            }}
        }

        function newCode() {
            var x = document.getElementById("recordCode");
            var date = document.getElementById("begin_date").value;
            if (date.length == 10) {
                var year = date.substring(0, 4);
                var index = document.getElementById("code").selectedIndex;
                x.value = document.getElementById("code").options[index].text + "-" + year;
            }
        }
        function IsNumeric(sText)
        {
            var ValidChars = "0123456789.";
            var IsNumber = true;
            var Char;


            for (i = 0; i < sText.length && IsNumber == true; i++)
            {
                Char = sText.charAt(i);
                if (ValidChars.indexOf(Char) == -1)
                {
                    IsNumber = false;
                }
            }
            return IsNumber;

        }

        function checkEmail(email) {
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
                return (true)
            }
            return (false)
        }

        function clearValue(no) {
            document.getElementById('Quantity' + no).value = '0';
            total();
        }

        function cancelForm()
        {
            document.SEASON_FORM.action = "main.jsp";
            document.SEASON_FORM.submit();
        }
    </SCRIPT>

    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>




        <FORM NAME="SEASON_FORM" METHOD="POST">

            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td" style="direction: ltr;">
                                <font color="blue" size="4"><%=title_1%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>  
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="black"><%=sStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%
                } else {%>
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%}
                    }

                %>

<!--table align="<%//=align%>" dir=<%//=dir%>>
<TR COLSPAN="2" ALIGN="<%//=align%>">
<TD STYLE="<%//=style%>" class='td'>
<FONT color='red' size='+1'><%//=title_2%></FONT> 
        </TD>
       
    </TR>
</table-->
                <br><br>

                <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0" id="MainTable">


                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="supplierNO2">
                                <p><b><%=season_code%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>;" class='td'>
                            <select style="width:230px;font-size: 14px;"id="code" name="code" value=''>
                                <option >-----إختيار-----<option>
                                <sw:WBOOptionList wboList="<%=allCode%>" displayAttribute="arabicName" valueAttribute="type_code"  />
                            </select>
                        </TD>

                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="address">
                                <p><b><%=arabic_name%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width: 230px;" name="arabic_name" ID="arabicName" size="33" value="" maxlength="255">
                        </TD>

                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="supplierName">
                                <p><b><%=forever%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"class='td'>
                            <input type="checkbox" id="forever" name="forever" value="1"/>
                        </TD>
                    </TR>
                </TABLE>

        </FORM>
    </BODY>
</HTML>     
