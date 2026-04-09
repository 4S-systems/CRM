<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        //get session logged user and his trades
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        // get current date
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowTime = sdf.format(cal.getTime());

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

        String title, eqName, beginDate, endDate, search, cancel;
        String style=null;
        
        if (stat.equals("En")) {
            title = "Search Maintenance Schedules for an Equipment (Equipment Plan)";
            eqName = "Equipment Name";
            beginDate = "Begin Date";
            endDate = "End Date";
            search = "Search";
            cancel = "Cancel";
            style="text-align:left";
            
        } else {
            title = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1604;&#1605;&#1593;&#1583;&#1577; (&#1582;&#1591;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;)";
            eqName = "&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577";
            
            beginDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577";
            endDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577";
            search = "&#1576;&#1581;&#1579";
            cancel = tGuide.getMessage("cancel");
            style="text-align:right";
            
        }

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">

            var dp_cal1,dp_cal12;
            window.onload = function (){
                dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));

            }
            
            function openWindowEquip(url) {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
            }

            function getEquipment() {
                var formName = document.getElementById('EQUIPMENT_SCHEDULES_FORM').getAttribute("name");
                var name = document.getElementById('unitName').value
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                openWindowEquip('SelectiveServlet?op=listEquipmentsAndViewEquipment&unitName='+res+'&formName='+formName);
            }

            function reloadAE(nextMode) {
                var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;

                if (window.XMLHttpRequest){
                    req = new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }

                req.open("Post",url,true);
                req.onreadystatechange =  callbackFillreload;
                req.send(null);
            }

            function callbackFillreload() {
                if (req.readyState==4) {
                    if (req.status == 200) {
                        window.location.reload();
                    }
                }
            }

            function submitForm() {
                
                if (validBeginDate()) {
                    alert('Begin date must be greater than or equal to current date');
                
                } else if(compareDate()) {
                    alert('End date must be greater than or equal begin date');
                
                } else {
                    document.EQUIPMENT_SCHEDULES_FORM.action = "<%=context%>/SearchServlet?op=searchSchedulesByEquipment";
                    document.EQUIPMENT_SCHEDULES_FORM.submit();
                    
                }
                        
            }

            function cancelForm()
            {    
                document.EQUIPMENT_SCHEDULES_FORM.action = "<%=context%>/main.jsp;";
                document.EQUIPMENT_SCHEDULES_FORM.submit();
            }

            function compareDate()
            {   
                return Date.parse(document.getElementById("endDate").value) < Date.parse(document.getElementById("beginDate").value);
            }
            
            function validBeginDate() {
                return document.getElementById("beginDate").value < '<%=nowTime%>';
                   
            }
           
        </script>
    </HEAD>
    <BODY>
        <table align="center" width="80%">
            <tr>
                <td class="td">
                    <fieldset align="center" class="set" style="">
                        <table class="blueBorder" dir="RTL" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                            <tr>
                                <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"><%=title%></FONT><BR></td>
                            </tr>
                        </table>

                        <FORM ID="EQUIPMENT_SCHEDULES_FORM" NAME="EQUIPMENT_SCHEDULES_FORM" METHOD="POST">
                            <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                                <TR class="head">
                                    <TD style="<%=style%>; width:20%; background-color: #FFFFFF;" class="td2 formInputTag boldFont">
                                        <%=eqName%>
                                    </TD>
                                    <TD style="<%=style%>; background-color: #FFFFFF;" class="td2 blackFont fontInput" id="CellData">

                                        <input type="text" style="<%=style%>;width: 300px;color:black;font-weight: bold" onchange="javascript:inputChange();" name="unitName" ID="unitName" value="" >
                                        <input type="hidden" dir="ltr"  class="head"  name="unitId" ID="unitId"  value=""  >

                                        <input type="button" class="button" name="btnSearch" id="btnSearch" style="width:60px;height: 25px;" onclick="JavaScript:getEquipment();" value="<%=search%>">
                                        <br><br>
                                     </TD>
                                </TR>
                                
                                <TR class="head">
                                    <TD style="<%=style%>; background-color: #FFFFFF;" class="td2 formInputTag boldFont">
                                        <%= beginDate%>
                                    </TD>
                                    <TD class="td2" style="<%=style%>; background-color: #FFFFFF;">
                                        <%
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" class="blackFont fontInput" style="<%=style%>;width: 300px;"><img src="images/showcalendar.gif" >
                                        <br><br>
                                    </TD>
                                </TR>
                                
                                <TR class="head">
                                    <TD style="<%=style%>; background-color: #FFFFFF;" class="td2 formInputTag boldFont">
                                        <%= endDate%>
                                    </TD>
                                    <td class="td2" style="<%=style%>; background-color: #FFFFFF;">
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>"  class="blackFont fontInput" style="<%=style%>;width: 300px;"><img src="images/showcalendar.gif" >
                                        <br><br>
                                    </td>
                                </TR>
                            </TABLE>
                            
                        </FORM>

                        <div align="center">
                            <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                            <button  onclick="JavaScript: submitForm();" class="button">   <%= search%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        </div>
                        <br>
                    </fieldset>
                </td>
            </tr>
        </table>
    </BODY>
</HTML>