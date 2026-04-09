<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        // get current date and Time
        Calendar cal = Calendar.getInstance();
        String jDateFormat=user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowDate=sdf.format(cal.getTime());
        String title, groupByStr, beginDate ,endDate;
        String style=null;
        
        if (stat.equals("En")) {
            title = "General Report";            
            style="text-align:left";
            groupByStr="Group By";
            beginDate="From Date";
            endDate="To Date";
        } else {
            title = "التقرير العام";            
            style="text-align:right";
            groupByStr="مجمع حسب";
            beginDate="&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
            endDate="&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        }

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            
             var dp_cal1,dp_cal12;      
            window.onload = function () {
               dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
               dp_cal12  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
             };
      
            function openWindowEquip(url) {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
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

            function cancelForm()
            {    
                document.GENERAL_REPORT.action = "<%=context%>/main.jsp;";
                document.GENERAL_REPORT.submit();
            }
            
            function getClientComplaintList(docType) {
                var url = null;
                
                if(docType == 'pdf') {
                    url = '<%=context%>/PDFReportServlet?op=getClientComplaintList';
                    
                } else if(docType == 'xls') {
                    url = '<%=context%>/PDFReportServlet?op=getClientComplaintList';

                }
                
                document.GENERAL_REPORT.action = url;
                document.GENERAL_REPORT.submit();
            }

        </script>
    </HEAD>
    <BODY>
        <table align="center" width="80%">
            <tr>
                <td class="td">
                    <fieldset align="center" class="set" style="">
                    
                        <table  dir="RTL" align="center" width="100%" cellpadding="0" cellspacing="0" style="border: none;" border="0px">
                            <tr style="border: none;">
                                <td style="text-align:center;border-color: #006699;border: none;" width="100%" ><FONT color='black' SIZE="+1"><%=title%></FONT><BR></td>
                            </tr>
                        </table>

                        <FORM ID="GENERAL_REPORT" NAME="GENERAL_REPORT" METHOD="POST">
                            <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                                
                                
                                
                                <TR>
                                    <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </TD>
                                    <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </TD>
                                </TR>
                                <TR>

                                    <TD style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                        String url = request.getRequestURL().toString();
                                        String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                        Calendar c = Calendar.getInstance();
                                        %>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                                        <br><br>
                                    </TD>

                                    <td  bgcolor="#dedede"  style="text-align:right" valign="middle">
                                     <input id="endDate" name="endDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                                         <br><br>
                                    </td>

                                </TR>
                                <tr></tr>
                                <tr></tr>
                                <tr></tr>
                                <tr></tr>
                                <tr></tr>
                                <TR class="head">
                                    <TD style="<%=style%>; background-color: #FFFFFF;text-align: left;margin-left: 10px;" class="td2 formInputTag boldFont">
                                        <%=groupByStr%>
                                    </TD>
                                    <TD class="td2" style="<%=style%>; background-color: #FFFFFF;">
                                        <select id="groupBy" name="groupBy" style="margin-right: 10px;font-size: 12px;font-weight: bold;">
                                            <option value="department">department</option>
                                            <option value="sender">sender</option>
                                            <option value="client">client</option>
                                        </select> 
                                    </TD>
                                </TR>
                                
                            </TABLE>
                            
                        </FORM>

                        <div align="center">
                            <%--<button onclick="getClientComplaintList('xls'); return false;" class="button">Generate Excel<img src="<%=context%>/images/xlsicon.gif"></button>--%>
                            <button onclick="getClientComplaintList('pdf'); return false;" class="button">Generate PDF<img src="<%=context%>/images/pdf_icon.gif" HEIGHT="20"></button>
                        </div>
                        <br>
                    </fieldset>
                </td>
            </tr>
        </table>
    </BODY>
</HTML>