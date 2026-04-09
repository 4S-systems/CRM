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

        String title, eqName, beginDate, endDate, search, exportReport, cancel;
        String style=null;
        
        if (stat.equals("En")) {
            title = "Search Due Equipment Schedules for a Brand/Model";
            eqName = "Brand Name";
            beginDate = "First Due Begin Date for Schedules";
            search = "Search";
            exportReport = "Export Report";
            cancel = "Cancel";
            style="text-align:left";
            
        } else {
            title = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1608;&#1575;&#1580;&#1576;&#1577; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584; &#1604;&#1605;&#1575;&#1585;&#1603;&#1577;/&#1605;&#1608;&#1583;&#1610;&#1604;";
            eqName = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1577;";
            beginDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1577; &#1571;&#1608;&#1604; &#1573;&#1587;&#1578;&#1581;&#1602;&#1575;&#1602; &#1604;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
            search = "&#1576;&#1581;&#1579;";
            exportReport = "&#1573;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
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

            var dp_call;
            window.onload = function (){
                dp_call  = new Epoch('epoch_popup','popup',document.getElementById('dueBeginDate'));
                
            }
            
            function openWindowEquip(url) {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
            }

            function getBrand() {
                var formName = document.getElementById('BRAND_SCHEDULES_FORM').getAttribute("name");
                var name = document.getElementById('brandName').value
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                openWindowEquip('SelectiveServlet?op=listBrandsAndViewEquipment&brandName='+res+'&formName='+formName);
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

            function open_Window(url)
            {
                var openedWindow = window.open(url,"window_chaild","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
                openedWindow.focus();

            }

            function submitForm() {
                var brandId = document.getElementById('brandId').value;

                if(brandId == '') {
                    alert('Enter a brand name');
                } else if (validBeginDate()) {
                    alert('Due begin date must be greater than or equal to current date');
                
                } else {

                    open_Window('');
                    document.BRAND_SCHEDULES_FORM.target = "window_chaild";
                    document.BRAND_SCHEDULES_FORM.action = "<%=context%>/PDFReportServlet?op=EqpsByDueAfterDateBrandSchedules";
                    document.BRAND_SCHEDULES_FORM.submit();
                    
                }       
            }

            function cancelForm()
            {    
                document.BRAND_SCHEDULES_FORM.action = "<%=context%>/main.jsp;";
                document.BRAND_SCHEDULES_FORM.submit();
            }

            function validBeginDate() {
                return document.getElementById("dueBeginDate").value < '<%=nowTime%>';
                   
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

                        <FORM ID="BRAND_SCHEDULES_FORM" NAME="BRAND_SCHEDULES_FORM" METHOD="POST">
                            <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                                <TR class="head">
                                    <TD style="<%=style%>; width:20%; background-color: #FFFFFF;" class="td2 formInputTag boldFont">
                                        <%=eqName%>
                                    </TD>
                                    <TD style="<%=style%>; background-color: #FFFFFF;" class="td2 blackFont fontInput" id="CellData">

                                        <input type="text" style="<%=style%>;width: 300px;color:black;font-weight: bold" onchange="javascript:inputChange();" name="brandName" ID="brandName" value="" >
                                        <input type="hidden" dir="ltr"  class="head"  name="brandId" ID="brandId"  value=""  >

                                        <input type="button" class="button" name="btnSearch" id="btnSearch" style="width:60px;height: 25px;" onclick="JavaScript: getBrand();" value="<%=search%>">
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
                                        <input id="dueBeginDate" name="dueBeginDate" type="text" value="<%=nowTime%>" class="blackFont fontInput" style="<%=style%>;width: 300px;"><img src="images/showcalendar.gif" >
                                        <br><br>
                                    </TD>
                                </TR>
                                
                            </TABLE>
                            
                        </FORM>

                        <div align="center">
                            <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel%><IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                            <button  onclick="JavaScript: submitForm();" style="width: 150px;" class="button"><%=exportReport%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        </div>
                        <br>
                    </fieldset>
                </td>
            </tr>
        </table>
    </BODY>
</HTML>