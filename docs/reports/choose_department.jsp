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
ProjectMgr projectMgr = ProjectMgr.getInstance();
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        
        Vector allMainType = (Vector)request.getAttribute("allMainType");
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        // get current date and Time
        Calendar cal = Calendar.getInstance();
        String jDateFormat=user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowDate=sdf.format(cal.getTime());
        String title, groupByStr, beginDate ,endDate;
        String style=null;
        String print;
        
        if (stat.equals("En")) {
            title = "General Report";            
            style="text-align:left";
            groupByStr="Group By";
            beginDate="From Date";
            endDate="To Date";
            print="get report";
        } else {
            title = "نسب توزيع الطلبات حسب القسم ";            
            style="text-align:right";
            groupByStr="&#1575;&#1604;&#1602;&#1587;&#1605; ";
            beginDate="&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
            endDate="&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
            
            print="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; ";
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

       function submitForm()
       {
           var pName = document.getElementById("pName").value;
         
            document.REQUEST_REPORT.action = "<%=context%>/ReportsServletThree?op=requestRatioReport&pName"+pName;
        document.REQUEST_REPORT.submit(); 
       }
            
     

        </script>
    </HEAD>
    <BODY>
       
           <FORM ID="REQUEST_REPORT" NAME="REQUEST_REPORT" METHOD="POST">
                        <fieldset align=center class="set">
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%>

                                            </font>

                                        </td>
                                    </tr>
                                </table>
                            </legend>
                            <TABLE  ALIGN="CENTER" DIR="RTL" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                                <TR>
                                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                                        <%=groupByStr%>
                                    </TD>
                                    <TD bgcolor="#dedede" valign="middle" width="325px">
                                        <select id="pName" name="pName">
                                            <%
                                                WebBusinessObject wbo = null;
                                                for (int i = 0; i < allMainType.size(); i++) {
                                                    wbo = (WebBusinessObject) allMainType.get(i);
                                            %>
                                            <option value="<%=wbo.getAttribute("projectName")%>"><%=wbo.getAttribute("projectName")%> </option>
                                            <% }%>
                                        </select>
                                    </TD>
                                </TR>
                                
                            </TABLE>
                            
                       
                        <div align="center">
                          <button  onclick="JavaScript: submitForm();"   STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; "><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        </div>
                        <br>
                    </fieldset>
                        </FORM>
    </BODY>
</HTML>