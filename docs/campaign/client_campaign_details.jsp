<%-- 
    Document   : client_campaign_details
    Created on : Sep 8, 2020, 12:21:11 PM
    Author     : mariam
--%>

<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@ page import= "java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String campaignID = request.getAttribute("campaignID") != null ? (String) request.getAttribute("campaignID") : "";
        String rateID = request.getAttribute("rateID") != null ? (String) request.getAttribute("rateID") : "";
        CampaignMgr campaignMgr =CampaignMgr.getInstance();
        WebBusinessObject campWbo=campaignMgr.getOnSingleKey("key", campaignID);
        ProjectMgr projectMgr=ProjectMgr.getInstance();
        WebBusinessObject rateWbo=projectMgr.getOnSingleKey("key", rateID);
        String startDate = request.getAttribute("startDate") != null ? (String) request.getAttribute("startDate") : "";
        String endDate = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : "";
        String weekno = request.getAttribute("weekno") != null ? (String) request.getAttribute("weekno") : "";
        ArrayList<WebBusinessObject> clientsDet = (ArrayList<WebBusinessObject>) request.getAttribute("clientsDet");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy");
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.WEEK_OF_YEAR, Integer.parseInt(weekno));
        String dateFrom=sdf.format(cal.getTime());
        if(sdf.parse(startDate).after(sdf.parse(dateFrom))){
        dateFrom=startDate;
        }
        
        cal.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
        String dateTo=sdf.format(cal.getTime());
        if(sdf.parse(endDate).before(sdf.parse(dateTo))){
        dateTo=endDate;
        }
        Formatter format;
        String clientNo,clientName,Mobile,creationTime,comment,description,createdBy;
        
        clientNo="Client Code";
        clientName="Client Name";
        Mobile="Mobile Phone";
        creationTime="Creation Time ";
        comment="last call Comment";
        description="Description";
        createdBy="Employee Name";
    
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="jquery-multiSelect/jquery.multiselect.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>

        <script type="text/javascript" LANGUAGE="JavaScript">
            var oTable;
            $(document).ready(function () {
                
                oTable = $('#clientDetails').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                    iDisplayStart: 0,
                    iDisplayLength: 20,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[1, "asc"]]

                }).fadeIn(2000);
            });
</script>
<style>
    #clientDetails_wrapper{
        width:95%;
    } 
</style>
    </head>
    <body>
        <fieldset>
            <legend>
                 <font color="blue" size="6">Clients Details</font>
            </legend>
            <br>
        <table align="center" width="93%" cellpadding="0" cellspacing="0" style="border-color: black; border-width: 1px; border-style: solid">
                        <tr style="text-align-last: center;">
                            <td width="100%" class="titlebar" colspan="4" style="border-color: black; border-width: 1px; border-style: solid">
                                <font color="#005599" size="4">Clients in week_<%=weekno%></font>
                            </td>
                        </tr>

                        <tr style=" border-width: 0">
                            <td width="20%" class="titlebar" style="border-color: black; border-width: 1px; border-style: solid">
                                <font color="#183c5a" size="3">From Date</font>
                            </td>
                            <td width="30%" style="border-color: black; border-width: 1px; border-style: solid">
                                <font color="red" size="3"><%=sdf2.format(sdf.parse(dateFrom))%></font>
                            </td>
                            <td width="20%" class="titlebar" style="border-color: black; border-width: 1px; border-style: solid">
                                 <font color="183c5a" size="3">To Date</font>
                            </td>
                            <td width="20%"style="border-color: black; border-width: 1px; border-style: solid">
                                 <font color="red" size="3"><%=sdf2.format(sdf.parse(dateTo))%></font>
                            </td>
                        </tr>
                         <tr style=" border-width: 0">
                            <td width="20%" class="titlebar" style="border-color: black; border-width: 1px; border-style: solid">
                                <font color="#183c5a" size="3">Campaign Title</font>
                            </td>
                            <td width="30%" style="border-color: black; border-width: 1px; border-style: solid">
                                <font color="red" size="3"><%=campWbo.getAttribute("campaignTitle")==null?"-":campWbo.getAttribute("campaignTitle")%></font>
                            </td>
                            <td width="20%" class="titlebar" style="border-color: black; border-width: 1px; border-style: solid">
                                 <font color="183c5a" size="3">Selected Rate</font>
                            </td>
                            <td width="20%" style="border-color: black; border-width: 1px; border-style: solid">
                                 <font color="red" size="3"><%=rateWbo.getAttribute("projectName")==null?"-":rateWbo.getAttribute("projectName")%></font>
                            </td>
                        </tr>
        </table>
        </br>
        <table id="clientDetails" class="display" align="center"  WIDTH="100%" CELLPADDING="0" cellspacing="0">
            <thead>
            <td><%=clientNo%></td>
            <td><%=clientName%></td>
            <td><%=Mobile%></td>
            <td> <%=description%></td>
            <td> <%=creationTime%></td>
            <td width="25%"><%=comment%></td>
            
            <td> <%=createdBy%></td>
             
            </thead>
            <tbody>
                <%if (clientsDet!=null && !clientsDet.isEmpty()){%>
                <%for (WebBusinessObject wbo:clientsDet){
                
                
                WebBusinessObject formatted = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("clCreation_time"), "En");
                UserMgr userMgr=UserMgr.getInstance();
                String userName=wbo.getAttribute("createdBy").toString();
                if(!userName.equalsIgnoreCase("--")){
                WebBusinessObject usrWbo=userMgr.getOnSingleKey("key", userName);
                userName=usrWbo.getAttribute("fullName").toString();
                }
                %>
                <tr>
                    <td><%=wbo.getAttribute("CLIENT_NO")%></td>
                    <td><%=wbo.getAttribute("NAME")%></td>
                    <td><%=wbo.getAttribute("MOBILE")%></td>
                    <td><%=wbo.getAttribute("description")%></td>
                    <td><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                    <td><%=wbo.getAttribute("comment_desc")%></td>
                    
                    <td><%=userName%></td>
                    
                </tr>
                
                <%}}%>
            </tbody>
        </table>
        </fieldset>
    </body>
</html>
