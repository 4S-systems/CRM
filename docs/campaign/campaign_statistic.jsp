<%@page import="java.util.Vector"%>
<%@page import="com.planning.db_access.SeasonMgr"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");
    String jspType = request.getAttribute("jspType") != null ? (String) request.getAttribute("jspType") : "";
    
    String campIDRes = (String) request.getAttribute("campID") != null ? (String) request.getAttribute("campID") : "";
    String prjIDRes = (String) request.getAttribute("prjID") != null ? (String) request.getAttribute("prjID") : "";
    String toolID = (String) request.getAttribute("toolID") != null ? (String) request.getAttribute("toolID") : "";
    
    ArrayList<WebBusinessObject> campaignList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignList");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
    } else {
        align = "center";
        dir = "RTL";
    }
    
    ArrayList<WebBusinessObject> allcampaignsList = request.getAttribute("allcampaignsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("allcampaignsList") : null;
    Vector seaVector = request.getAttribute("seaVector") != null ? (Vector) request.getAttribute("seaVector") : null;
    ArrayList<WebBusinessObject> projectsList = request.getAttribute("projectsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("projectsList") : null;
%>

<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

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
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <script type="text/javascript">
            $(function () {
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            var oTable;
            
            $(document).ready(function () {
                $("#campLstID").select2();
                $("#prjLstID").select2();
                $("#toolLstID").select2();
                
                oTable = $('#Campaigns').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": []
                }).fadeIn(2000);
            });

            function getResults() {
                var beginDate = $("#fromDate").val();
                var endDate = $("#toDate").val();

                document.stat_form.action = "<%=context%>/CampaignServlet?op=viewCampaignStat&beginDate=" + beginDate + "&endDate=" + endDate;
                document.stat_form.submit();
            }
            
            function getCampaignPrj(){
                var campLstID = $("#campLstID").val();
                
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/CampaignServlet?op=viewCampaignStat",
                        data: {
                            campLstID: campLstID,
                            PrjToolFlag: "prj"
                        }, success: function (jsonString) {
                            var result = $.parseJSON(jsonString);
                            var options = [];
                            options.push("<option value=''>", " All Projects ", "</option>");
                            $.each(result, function () {
                                options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                            });
                              $("#prjLstID").html(options.join(''));
                              getCampaignTool();
                        }
                    });
            }
            
            function getCampaignTool(){
                var campLstID = $("#campLstID").val();
                
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/CampaignServlet?op=viewCampaignStat",
                        data: {
                            campLstID: campLstID,
                            PrjToolFlag: "tool"
                        }, success: function (jsonString) {
                            var result = $.parseJSON(jsonString);
                            var options = [];
                            options.push("<option value=''>", " All Tools ", "</option>");
                            $.each(result, function () {
                                options.push('<option value="', this.id, '">', this.englishName, '</option>');
                            });
                              $("#toolLstID").html(options.join(''));
                        }
                    });
            }
        </script>
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }

            #mydiv {
                text-align:center;
            }
        </style>
    </head>

    <body>
        <FORM NAME="stat_form" METHOD="POST">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="50%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                <TR>
                    <TD width="8%" STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            عرض خلال 
                        </DIV>
                    </TD>
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        من تاريخ :
                    </TD>
                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="margin: 5px;" />
                    </TD>
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        الى تاريخ :
                    </TD>
                    <TD width="15%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="margin: 5px;" />
                    </TD>
                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                    </TD>
                </TR>
                
                <TR>
                    <TD width="25%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        
                    </TD>
                    
                    <TD width="25%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                     الحملة 
                    </TD>
                    <TD width="50%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" colspan="5">
                        <select style="font-size: 14px;font-weight: bold; width: 80%;" id="campLstID" name="campLstID" >
                            <option value=""> All Campaign </option>
                            <%
                                if(allcampaignsList != null){
                                    for(int i=0; i<allcampaignsList.size(); i++){
                                        WebBusinessObject campaignsWbo = new WebBusinessObject();
                                        campaignsWbo = allcampaignsList.get(i);
                            %>
                                        <option value="<%=campaignsWbo.getAttribute("id")%>" <%if(campaignsWbo.getAttribute("id")!=null && campaignsWbo.getAttribute("id").equals(campIDRes)){%> selected <%}%>> <%=campaignsWbo.getAttribute("campaignTitle")%> </option>
                                        <%}}%>
                        </select>
                    </TD>
                </TR>
                
                <TR>
                    <TD width="25%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        
                    </TD>
                    
                    <TD width="25%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                     المشروعات 
                    </TD>
                    <TD width="50%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" colspan="5">
                        <select style="font-size: 14px;font-weight: bold; width: 80%;" id="prjLstID" name="prjLstID"  onchange="getCampaignPrj();">
                            <option value=""> All Projects </option>
                            <%
                                if(projectsList != null){
                                    for(int i=0; i<projectsList.size(); i++){
                                        WebBusinessObject projectsWbo = new WebBusinessObject();
                                        projectsWbo = projectsList.get(i);
                            %>
                                        <option value="<%=projectsWbo.getAttribute("projectID")%>" <%if(projectsWbo.getAttribute("projectID")!=null && projectsWbo.getAttribute("projectID").equals(prjIDRes)){%> selected <%}%>> <%=projectsWbo.getAttribute("projectName")%> </option>
                                        <%}}%>
                        </select>
                    </TD>
                </TR>
                
                <TR>
                    <TD width="25%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        
                    </TD>
                    
                    <TD width="25%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                     الأدوات 
                    </TD>
                    <TD width="50%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" colspan="5">
                        <select style="font-size: 14px;font-weight: bold; width: 80%;" id="toolLstID" name="toolLstID" >
                            <option value=""> All Tools </option>
                            <%
                                if(allcampaignsList != null){
                                    ArrayList<WebBusinessObject> seaLst = new ArrayList<WebBusinessObject>();
                                    seaLst = new ArrayList<WebBusinessObject>(seaVector);
                                    for(int i=0; i<seaLst.size(); i++){
                                        WebBusinessObject seaWbo = new WebBusinessObject();
                                        seaWbo = seaLst.get(i);
                            %>
                                        <option value="<%=seaWbo.getAttribute("id")%>" <%if(seaWbo.getAttribute("id")!=null && seaWbo.getAttribute("id").equals(toolID)){%> selected <%}%>> <%=seaWbo.getAttribute("englishName")%> </option>
                            <%}}%>
                        </select>
                    </TD>
                </TR>
                
                <TR>
                    <TD width="2%" STYLE="text-align: left; color: blue; font-size: 14px; border-left-width: 0px" nowrap CLASS="silver_even_main" > <INPUT id="jspType" name="jspType" type="radio" value="details" <%if(jspType != null && jspType.equals("details")){%> checked <%} else if(jspType != null && jspType.equals("")){%> checked <%}%> > </TD>
                    <TD width="48%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" colspan="2"> تفصيلي </TD>
                    <TD width="2%" STYLE="text-align: left; color: blue; font-size: 14px; border-left-width: 0px" nowrap CLASS="silver_even_main" > <INPUT id="jspType" name="jspType" type="radio" value="total" <%if(jspType != null && jspType.equals("total")){%> checked <%}%>> </TD>
                    <TD width="48%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" colspan="2"> إجمالى </TD>
                </TR>
            </TABLE>
        </FORM>
        <br>

        <% if( campaignList != null) {%>
        <div style="width: 90%;margin-right: auto;margin-left: auto;">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="Campaigns" style="">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">الحملة</th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">المشروع</th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">الاداة</th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">تكلفة الحملة</th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">العدد المستهدف للعملاء</th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Inbound Clients</th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Outbound Clients</th>
                        <th style="color: #005599 !important; font-weight: bold; font-size: 14px;">اجمالي العملاء</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String campID = "";

                        HashMap<String, ArrayList<WebBusinessObject>> groups = new HashMap<String, ArrayList<WebBusinessObject>>();
                        ArrayList<WebBusinessObject> campaignGroup = new ArrayList();

                        for (int i = 0; i < campaignList.size(); i++) {
                            WebBusinessObject campWbo = new WebBusinessObject();
                            campWbo = campaignList.get(i);

                            if (campWbo.getAttribute("parent_id").toString().equals("0")) {
                                groups.put(campID, campaignGroup);
                                campaignGroup = new ArrayList();
                                campID = campWbo.getAttribute("CampaignID").toString();
                                campaignGroup.add(campWbo);
                            } else if (campWbo.getAttribute("parent_id").toString().equals(campID) && (Integer.parseInt(campWbo.getAttribute("OutboundTotal").toString()) + Integer.parseInt(campWbo.getAttribute("InboundTotal").toString()) != 0)) {
                                campaignGroup.add(campWbo);
                            }

                            if (i == campaignList.size() - 1 && !campWbo.getAttribute("parent_id").toString().equals("0")) {
                                groups.put(campID, campaignGroup);
                            }
                        }

                        groups.remove("");

                        for (Map.Entry m : groups.entrySet()) {
                            int totalCost = 0;
                            int totalInbound = 0;
                            int totalOutbound = 0;
                            int totalClients = 0;

                            ArrayList<WebBusinessObject> campList = new ArrayList<WebBusinessObject>();

                            campList = (ArrayList<WebBusinessObject>) m.getValue();

                            for (int j = 0; j < campList.size(); j++) {
                                WebBusinessObject wbo = (WebBusinessObject) campList.get(j);

                                if (j != 0) {
                                    totalCost += Integer.parseInt(wbo.getAttribute("cost").toString());
                                }
                                totalInbound += Integer.parseInt(wbo.getAttribute("InboundTotal").toString());
                                totalOutbound += Integer.parseInt(wbo.getAttribute("OutboundTotal").toString());
                                totalClients += Integer.parseInt(wbo.getAttribute("Total_Clients").toString());

                    %>
                    <%if (wbo.getAttribute("parent_id").toString().equals("0")) {%>
                    <tr style=" background-color: #ffefef">
                        <td style="border-bottom: none;">
                            <%=wbo.getAttribute("campaignTitle")%>
                        </td>
                        <td style="border-bottom: none;">
                            <%=wbo.getAttribute("PROJECT_NAME")%>
                        </td>
                        <td>
                            ---
                        </td>
                        <td>
                            <%=wbo.getAttribute("cost")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("objective")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("InboundTotal")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("OutboundTotal")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("Total_Clients")%>
                        </td>
                    </tr>
                    <%} else {%>
                    <tr>
                        <td style=" background-color: #ffefef; border-bottom: none; border-top: none;"></td>
                        <td style=" background-color: #ffefef; border-bottom: none; border-top: none;"></td>
                        <td>
                            <%=wbo.getAttribute("Tool_Name")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("cost")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("objective")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("InboundTotal")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("OutboundTotal")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("Total_Clients")%>
                        </td>
                    </tr>
                    <%}
                        }%>
                    <tr style=" background-color: #D7D7D7">  
                        <td>
                            <font color="red" size="3">الاجمالي</font>     
                        </td>
                        <td>
                            ---
                        </td>
                        <td>
                            ---
                        </td>
                        <td>
                            <font color="red" size="3"><%=totalCost%></font> 
                        </td>
                        <td>
                            <font color="red" size="3">---</font> 
                        </td>
                        <td>
                            <font color="red" size="3"><%=totalInbound%></font> 
                        </td>
                        <td>
                            <font color="red" size="3"><%=totalOutbound%></font>
                        </td>
                        <td>
                            <font color="red" size="3"><%=totalClients%></font>
                        </td>
                    </tr>
                    <%
                        }
                    %>

                </tbody>
            </table>
        </div>
        <%}%>
    </body>
</html>