<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>


    <%
                String status = (String) request.getAttribute("Status");

                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

                // get all need data
                ArrayList allSites = (ArrayList) request.getAttribute("allSites");
                // get current defaultLocationName
                String defaultLocationName = (String) request.getAttribute("defaultLocationName");

                //get session logged user and his trades
                WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

                // get current date
                Calendar cal = Calendar.getInstance();
                String jDateFormat = user.getAttribute("javaDateFormat").toString();
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowTime = sdf.format(cal.getTime());

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode;

                String saving_status, Dupname;
                String title_1, title_2;
                String cancel_button_label;
                String save_button_label;
                String fStatus;
                String sStatus;
                String site, selectAll;


                String siteLabel1, siteLabel2, saveStatus, accessLabel, dist_Label, cost_Label, totalCostLabel, fromDate, toDate;

                String compareDateMsg, beginDateMsg, endDateMsg;
                if (stat.equals("En")) {

                    saving_status = "Saving status";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    title_1 = "Adding a new location";
                    title_2 = "All information are needed";
                    cancel_button_label = "Cancel ";
                    save_button_label = "Save ";
                    langCode = "Ar";
                    Dupname = "Name is Duplicated Chane it";
                    sStatus = "Site Saved Successfully";
                    fStatus = "Fail To Save This Site";
                    site = "Site";
                    selectAll = "All";

                    siteLabel1 = "First Site";
                    siteLabel2 = "Second Site";
                    saveStatus = "Save Status";
                    accessLabel = "Accessibilty";
                    dist_Label = "Distance";
                    cost_Label = "Cost";
                    totalCostLabel = "Total Cost";
                    fromDate = "From Date";
                    toDate = "To Date";

                    compareDateMsg = "End Actual End Date must be greater than or equal start actual Begin Date";
                    endDateMsg = "End Actual End Date must be less than or equal today Date";
                    beginDateMsg = "Strat Actual Begin Date must be less than or equal today Date";
                } else {

                    /*if(status.equalsIgnoreCase("ok"))
                    status="";*/
                    saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    title_1 = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1608;&#1602;&#1593; &#1580;&#1583;&#1610;&#1583;";
                    title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
                    cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
                    save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
                    langCode = "En";
                    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
                    fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
                    sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";

                    site = "الموقع";
                    selectAll = "الكل";

                    siteLabel1 = "الموقع الأول";
                    siteLabel2 = "الموقع الثاني";
                    saveStatus = "حالة الحفظ";
                    accessLabel = "قابلية الوصول";
                    dist_Label = "المسافة";
                    cost_Label = "التكلفة";
                    totalCostLabel = "التكلفة الكلية";
                    fromDate = "من تاريخ";
                    toDate = "إلي تاريخ";

                    compareDateMsg = "  \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
                    endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                    beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                }

                String doubleName = (String) request.getAttribute("name");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

    </HEAD>
    <script src='silkworm_validate.js' type='text/javascript'></script>
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
    <script type='text/javascript'>//<![CDATA[
        $(window).load(function(){
            $.fn.hideOption = function() {
                this.each(function() {
                    if ($(this).is('option') && (!$(this).parent().is('span'))) {
                        $(this).wrap('<span>').hide()
                    }
                });
            }

            $.fn.showOption = function() {
                this.each(function() {
                    if (this.nodeName.toLowerCase() === 'option') {
                        var p = $(this).parent(),
                        o = this;
                        $(o).show();
                        $(p).replaceWith(o)
                    } else {
                        var opt = $('option', $(this));
                        $(this).replaceWith(opt);
                        opt.show();
                    }
                });
            }


            $('#blah').toggle(function() {
                $('select option').hideOption();
                $(this).text('show the span again')
            }, function() {
                $('select span').showOption();
                $(this).text('hide the second option')
            });
        });//]]>

    </script>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        var dp_cal1 = null;
        var dp_cal2 = null;
        window.onload = function (){
            if(dp_cal1 == null && dp_cal2 == null) {
                dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
            }
            $('#access').click(function(){
                if($('#access').is(':checked')){
                    $('#distance').attr('disabled', false);
                    $('#cost').attr('disabled', false);
                    //document.getElementById("cost").disabled=false;
                } else {
                    $('#distance').attr('disabled', true);
                    $('#cost').attr('disabled', true);
                }
            });

            hideShowOption('siteOne', 'siteTwo');
        }

        function hideShowOption(idOne, idTwo){
            var site1 = $('#'+idOne+' option:selected');
            var site2 = $('#'+idTwo+' option:selected');
            //alert(site1.val());
            if(site1.val() == site2.val()){
                //site2.css('display', 'none');
                site2.remove();
            }
        }
        function compareDate()
        {
            return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
        }
        function submitForm()
        {
            /*if (!validateData("req", this.PROJECT_FORM.project_name, "Please, enter Site Name.") || !validateData("minlength=3", this.PROJECT_FORM.project_name, "Please, enter a valid Site Name.")){
                this.PROJECT_FORM.project_name.focus();
            } else if (!validateData("req", this.PROJECT_FORM.eqNO, "Please, enter Site Number.") || !validateData("alphanumeric", this.PROJECT_FORM.eqNO, "Please, enter a valid Number for Site Number.")){
                this.PROJECT_FORM.eqNO.focus();
            } else if (!validateData("req", this.PROJECT_FORM.project_desc, "Please, enter Site Description.")){
                this.PROJECT_FORM.project_desc.focus();
            } else{*/
            if(Date.parse(document.getElementById("beginDate").value) > Date.parse('<%=nowTime%>')){
                alert('<%=beginDateMsg%>');
                document.PROJECT_FORM.beginDate.focus();
                return false;
            } else if(Date.parse(document.getElementById("endDate").value) > Date.parse('<%=nowTime%>')){
                alert('<%=endDateMsg%>');
                document.PROJECT_FORM.endDate.focus();
                return false;
            } else if (!compareDate()){
                alert('<%=compareDateMsg%>');
                document.PROJECT_FORM.endDate.focus();
                return false;
            }
            document.PROJECT_FORM.action = "<%=context%>/HubsServlet?op=saveSiteRelation&saveSiteRelation=ok";
            document.PROJECT_FORM.submit();
            
            //}
        }

        function selectAllSites(optionListId,typeAllId){
            var length = document.getElementById(optionListId).options.length;
            var option = document.getElementById(optionListId).options;
            //window.SEARCH_MAINTENANCE_FORM.site.multiple = true;
            if(option[0].selected) {

                document.getElementById(typeAllId).value = "yes";
                siteAll = "yes";
                option[0].selected = false;
                for(var i = 1; i<length; i++){
                    option[i].selected = true;
                }
            } else {

                //window.SEARCH_MAINTENANCE_FORM.site.multiple = false;
                /*var selected = 0;
        var i = 0;
        for(i = 1; i<length; i++){
            if(option[i].selected == true){
                selected = i;
                break;
            }
        }
        for(i = 0; i<length; i++){
            option[i].selected = false;
        }
        option[selected].selected = true;*/

                document.getElementById(typeAllId).value = "no";
            }
        }

        function IsNumeric(sText)
        {
            var ValidChars = "0123456789.";
            var IsNumber=true;
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
    
        function clearValue(no){
            document.getElementById('Quantity' + no).value = '0';
            total();
        }
    
        function cancelForm()
        {    
            document.PROJECT_FORM.action = "main.jsp";
            document.PROJECT_FORM.submit();
        }
    </SCRIPT>

    <script src='ChangeLang.js' type='text/javascript'></script>
    <style type="text/css">

    </style>

    <BODY>

        <FORM NAME="PROJECT_FORM" METHOD="POST">

            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 


            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6">    <%=title_1%>                
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend>





                <%
                            if (null != doubleName) {

                %>

                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font size=4 > <%=Dupname%> </font> 
                        </td>

                    </tr> </table>
                    <%

                                }

                    %>


                <table align="<%=align%>" dir="<%=dir%>">
                    <%    if (null != status) {
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

                </table>
                <table align="<%=align%>" dir="<%=dir%>">
                    <TR COLSPAN="2" ALIGN="<%=align%>">

                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=title_2%></FONT> 
                        </TD>

                    </TR>
                </table>
                <br>
                <table align="<%=align%>" dir="<%=dir%>">
                    <tr>
                        <TD STYLE="<%=style%>" class='td'>
                            <b><font size=3 color="black"><%=siteLabel1%></font></b>
                        </TD>
                        <td class='td'><b>:</b></td>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="hidden" id="siteAll" value="no" name="siteAll" />
                            <select name="siteOne" id="siteOne" style="font-size:12px;font-weight:bold;width:100%; height: 100%; margin: 0px" onchange="JavaScript: hideShowOption('siteOne', 'siteTwo');">
                                <sw:WBOOptionList wboList="<%=allSites%>" displayAttribute="projectName" valueAttribute="projectID" scrollTo="<%=defaultLocationName%>" />
                            </select>
                        </TD>

                    </tr>
                    <tr></tr>
                    <tr>

                        <TD STYLE="<%=style%>" class='td'>
                            <b><font size=3 color="black"><%=siteLabel2%></font></b>
                        </TD>
                        <td class='td'><b>:</b></td>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="hidden" id="siteAll" value="no" name="siteAll" />
                            <select name="siteTwo" id="siteTwo" style="font-size:12px;font-weight:bold;width:100%; height: 100%; margin: 0px" onchange="JavaScript: hideShowOption('siteTwo', 'siteOne');">
                                <sw:WBOOptionList wboList="<%=allSites%>" displayAttribute="projectName" valueAttribute="projectID" scrollTo="<%=defaultLocationName%>" />
                            </select>
                        </TD>
                    </tr>
                    <tr>

                    </tr>

                    <TR>

                        <TD STYLE="<%=style%>"class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=accessLabel%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td class='td'><b>:</b></td>

                        <TD STYLE="<%=style%>"class='td'>
                            <input type="checkbox" name="access" id="access" value="1" />
                        </TD>
                        <td class='td'></td><td class='td'></td>
                    </TR>

                    <TR>


                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_EQ_NO">
                                <p><b><%=dist_Label%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td class='td'><b>:</b></td>
                        <TD STYLE="<%=style%>"class='td'>
                            <input type="TEXT" name="distance" disabled dir="<%=dir%>" ID="distance" size="32" value="" maxlength="255">
                        </TD>
                        <td class='td'></td><td class='td'></td>
                    </TR>
                    <TR>

                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Project_Name">
                                <p><b> <%=cost_Label%> <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td class='td'><b>:</b></td>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" dir="<%=dir%>" disabled name="cost" ID="cost" size="32" value="" maxlength="255">
                        </TD>
                        <td class='td'></td><td class='td'></td>
                    </TR>
                    <TR>

                        <TD STYLE="<%=style%>"class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=fromDate%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td class='td'><b>:</b></td>

                        <TD STYLE="<%=style%>"class='td'>
                            <input type="text" name="beginDate" id="beginDate"  size="32" value="<%=nowTime%>" maxlength="255"/>
                        </TD>
                        <td class='td'></td><td class='td'></td>
                    </TR>
                    <TR>

                        <TD STYLE="<%=style%>"class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=toDate%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td class='td'><b>:</b></td>

                        <TD STYLE="<%=style%>"class='td'>
                            <input type="text" name="endDate" id="endDate"  size="32" value="<%=nowTime%>" maxlength="255"/>
                        </TD>
                        <td class='td'></td><td class='td'></td>
                    </TR>
                </table>
                <br><br><br>
            </fieldset>
            <!--   <select id="foo">
<option value="visible">visible</option>
<option value="thing" id="lol">fsljs</option>
</select>

<button id="blah">hide all options</button>-->
        </FORM>
    </BODY>
</HTML>     
