<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
                MaintainableMgr maintainableMgr =MaintainableMgr.getInstance();
                IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();

                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");


                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

                // get current date
                Calendar cal = Calendar.getInstance();
                WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                String jDateFormat = "yyyy-MM-dd hh:mm:ss";//loggedUser.getAttribute("javaDateFormat").toString();
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowTime = sdf.format(cal.getTime());

                //Define language setting
                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;

                String selectSch, cancel, title;
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode, search, searchSubName;

                if (stat.equals("En")) {
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";

                    selectSch = "Select Schedule Title";
                    search = "Search";
                    cancel = "Cancel";
                    title = "Search About Schedule By Date";
                    searchSubName = "Search With Name or SubName";
                } else {
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";

                    selectSch = "&#1571;&#1582;&#1578;&#1585;&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577;";
                    search = "&#1576;&#1581;&#1579;";
                    cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
                    title = "بحث عن جداول الصيانة بالتاريخ";
                    searchSubName = "&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605; &#1575;&#1608; &#1576;&#1580;&#1586;&#1569; &#1605;&#1606; &#1575;&#1604;&#1575;&#1587;&#1605;";
                }

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Search Future Plan</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
        <script type="text/javascript" src="js/common.js" ></script>
        <script type="text/javascript" src="js/silkworm_validate.js" ></script>
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
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">
        <script type="text/javascript">
            /*$(document).ready(function() {

                var dates = $( "#beginDate, #endDate" ).datepicker({
                    defaultDate: "+1w",
                    changeMonth: true,
                    changeYear : true,
                    maxDate    : "+d",
                    dateFormat : "yy/MM/dd",
                    numberOfMonths: 1,
                    showAnim   : 'fold',
                    onSelect: function( selectedDate ) {
                        var option = this.id == "beginDate" ? "minDate" : "maxDate",
                        instance = $( this ).data( "datepicker" ),
                        date = $.datepicker.parseDate(
                        instance.settings.dateFormat ||
                            $.datepicker._defaults.dateFormat,
                        selectedDate, instance.settings );
                        dates.not( this ).datepicker( "option", option, date );

                        dates.not( "#beginDate" ).datepicker( "option", "minDate", date );

                    }
                });

            });*/
        </script>
        <script type="text/javascript">
            
            $(function() {
                $( "#from, #to" ).datetimepicker({
                    maxDate    : "+d",
                    changeMonth: true,
                    changeYear : true,
                    timeFormat:'hh:mm:ss',
                    dateFormat : 'yy-mm-dd'

                });
               

            });
        </script>
    </HEAD>

    <script>
        <%--------------Popup window-------------------%>
            function openWindowTasks(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=yes, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=500");
            }
            function getSchedules()
            {
                var formName = document.getElementById('ISSUE_FORM').getAttribute("name");
                var name = document.getElementById('scheduleName').value

                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);

                openWindowTasks('ScheduleServlet?op=searchSchBySubNamePopup&scheduleName='+res+'&formName='+formName);
            }
        <%---------------------------------%> 
        
            function changeMode(name){
                if(document.getElementById(name).style.display == 'none'){
                    document.getElementById(name).style.display = 'block';
                } else {
                    document.getElementById(name).style.display = 'none';
                }
            }
         
    </script>

    <BODY>

        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <center>
                <fieldset style="border-color:blue;width:90%;">
                    <legend align="center">
                        <table dir="rtl" align="center">
                            <tr>
                                <td class="td">  
                                    <IMG WIDTH="80" HEIGHT="80" SRC="images/Search.png">
                                </td>
                                <td class="td">
                                    <font color="blue" size="6"> <%=title%></font>
                                </td>
                            </tr>
                        </table>
                    </legend>

                    <br>
                    <table align="<%=align%>" border="0" width="93%">
                        <tr>
                            <td width="50%" STYLE="border:0px;">
                                <div STYLE="width:70%;border:2px solid gray;color:white;" class="header" align="<%=align%>">
                                    <div ONCLICK="JavaScript: changeMode('menu1');" class="header" STYLE="width:100%;color:white;cursor:hand;font-size:16;">
                                        <b>
                                            <%=searchSubName%>
                                        </b>
                                        <img src="images/arrow_down.gif">
                                    </div>
                                    <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:block;text-align:right;border-top:2px solid gray;" ID="menu1">
                                        <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                            <tr>
                                                <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                                    <button  onclick="return getDataInPopup('ScheduleServlet?op=searchSchByDate' + '&fieldName=CREATION_TIME&fieldValue=' + document.getElementById('beginDate').value + '&fieldName=CREATION_TIME&fieldValue=' + document.getElementById('endDate').value + '&formName=ISSUE_FORM');" style="width:120"> <%=search%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"/></button>
                                                </td>
                                                <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;direction: ltr;">
                                                    <input readonly id="from" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><br />
                                                    <input readonly id="to" name="endDate" type="text" value="<%=nowTime%>" style="width:90%" />
                                                    <input type="hidden" name="scheduleName" id="scheduleName" ondblclick="return getDataInPopup('ScheduleServlet?op=searchSchBySubNamePopup' + '&fieldName=MAINTENANCE_TITLE&fieldValue=' + getASSCIChar(this.value) + '&formName=ISSUE_FORM');" >
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>

                    </table>
                    <br><br>

                </fieldset>
            </center>
        </FORM>
    </BODY>
</HTML>     
