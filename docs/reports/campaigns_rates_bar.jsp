<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="java.util.List"%>
<%@page import="flexjson.JSONSerializer"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<!DOCTYPE HTML>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        String[] clientsAttributes = {"clientName", "mobile", "clientCreationTime", "mct", "diffDays", "ratedBy", "rateName", "campaignTit"};
        int s = 0, t = 0;
        s = clientsAttributes.length;
	t = s + 1;
        String attName = null;
        String attValue = null;
        
        String [] campaigns = (String []) request.getAttribute("campaigns");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String ratingCategories = (String) request.getAttribute("ratingCategories");
        String resultsJson = (String) request.getAttribute("resultsJson");
        String D = request.getAttribute("viewD") != null ? (String) request.getAttribute("viewD") : "off";
        ArrayList<WebBusinessObject> campaignsList = request.getAttribute("campaignsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList") : new ArrayList<WebBusinessObject>();
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("result");
        String[] clientsListTitles = new String[8];
        
        CampaignMgr campaignMgr = CampaignMgr.getInstance();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        String defaultCampaign = "";
        String campaignDirection = "";
        String callCenterMode = "";
        if (securityUser != null && securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()) {
            defaultCampaign = securityUser.getDefaultCampaign();

            WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(defaultCampaign);
            if (campaignWbo != null) {
                defaultCampaign = (String) campaignWbo.getAttribute("campaignTitle");
                campaignDirection = (String) campaignWbo.getAttribute("direction");
            }
        }
        
        String id = (String) request.getAttribute("id");
        String searchBy = (String) request.getAttribute("searchBy");

        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, yTitle, grp, print, fromDate, toDate, camp, campDate,viewD,
                lstRtTm, xAlign, shwSync, CfromDate, CcampDate, dsAll, sAll,searchBySelect;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Clients Campaigns Rates";
            yTitle= "Clients Number";
            grp = "Groups";
            print = "View";
            fromDate = "From Date";
            toDate = "To Date";
            camp = "Campaigns";
            campDate = "Addition Client Campaign Date";
            viewD = "View Detailed comparison";
            lstRtTm = " Last Rating Time ";
            
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Client Mobile";
            clientsListTitles[2] = "Creation Time";
            clientsListTitles[3] = " First Classification Time";
            clientsListTitles[4] = "Difference Day(s)";
            clientsListTitles[5] = "Classified By";
            clientsListTitles[6] = "Classification";
            clientsListTitles[7] = "Campaign";
            shwSync = " Show Campaign Synchronization ";
            CfromDate = "Campaigns Begin Date";
            CcampDate = "Campaign Start Date";
            dsAll = "De Select All";
            sAll = "Select All";
            searchBySelect = "Search By Select Campaign";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "احصائيات نسب العملاء بالنسبه للحملات";
            yTitle= "اعداد العملاء";
            grp = "المجموعات";
            print = "عرض";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            camp = "الحملات";
            campDate = "تاريخ اضافة العميل للحمله";
            viewD = "اظهار المقارنه التفصيليه";
            lstRtTm = " تاريخ أخر تصنيف ";
            
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "الموبايل";
            clientsListTitles[2] = "تاريخ التسجيل";
            clientsListTitles[3] = " تاريخ التصنيف الأول ";
            clientsListTitles[4] = "الفارق بالأيام";
            clientsListTitles[5] = "التصنيف بواسطة";
            clientsListTitles[6] = "التصنيف";
            clientsListTitles[7] = "الحملة ";
            shwSync = " عرض تزامن الحملات ";
            CfromDate = "حملات بدات من تاريخ";
            CcampDate = "تاريخ بداية الحمله";
            dsAll = "الغاء التحديد";
            sAll = "تحديد الكل";
            searchBySelect = "البحث بإختيار الحملات";
        }
        
        ArrayList<WebBusinessObject> usrGroups = (ArrayList<WebBusinessObject>) request.getAttribute("usrGroups");
        List<WebBusinessObject> departments = (List<WebBusinessObject>) request.getAttribute("departments");
        String groupID =  request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
    %>

    <head>  
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
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
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        <script type="text/javascript" language="javascript">
            var chart;
            var chartCount;
            
            $(document).ready(function () {
                $("#campaignsselect").select2();
                
                var last_valid_selection = null;

              $('#campaignsselect').change(function(event) {
                if ($(this).val().length > 10) {
                  alert('You can only choose 10!');
                  $(this).val(last_valid_selection);
                } else {
                  last_valid_selection = $(this).val();
                }
              });
                
                <%if(campaigns != null && campaigns.length > 0){
                    //for(int i=0; i<campaigns.length; i++){
                %>
                        var x = '<%=campaigns[0]%>';
                    $("#campaignsselect option[value="+x+"]").attr("selected", true);
                <%
                       // }
                }%>
                    
                $("#fromDate,#toDate,#CfromDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                oTable = $('#clients').dataTable({
                   "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 8,
                            "visible": false
                        }, {
                            "targets": [0,1,2,3,4,5,6,7],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(8, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                    '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111;" colspan="10">' + group + '</td></tr>'
                                );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
                
                var searchBy = '<%=searchBy%>';
                if(searchBy === "byGroup"){
                    $("#grpID option[value=<%=id%>]").attr('selected', 'selected');
                } else {
                    $("#departmentId option[value=<%=id%>]").attr('selected', 'selected');
                }
            });
            
            <%if(D == null || D.isEmpty() || D.equalsIgnoreCase("off") ){%>
                $(document).ready(function () {
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: 'container',
                            type: 'column'
                        },
                        title: {
                            text: $('#title').val()
                        },
                        xAxis: {
                            categories: <%=ratingCategories%>
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: $('#yTitle').val()
                            }
                        },
                        tooltip: {
                            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                    '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                            footerFormat: '</table>',
                            shared: true,
                            useHTML: true
                        },
                        plotOptions: {
                            column: {
                                pointPadding: 0.2,
                                borderWidth: 0
                            }
                        },
                        series: <%=resultsJson%>
                    });
                });
            <%}%>
            
            function showChart(){
                var fromDate = $("#fromDate").val();
                var toDate = $("#toDate").val();
                var id = $("#departmentId").val();
                var name = $("#departmentId option:selected").text();
                var searchBy = "byDepartment";
                if (document.getElementById('searchByGroup').checked == true) {
                    id = $("#grpID").val();
                    name = $("#grpID option:selected").text();
                    searchBy = "byGroup";
                }
                //var groupID = $("#grpID").val();
                //console.log($("#campaignsselect option:selected").size());
                
                /*if($("#campaignsselect option:selected").size() > 5){
                    alert("You Can Select Less Than 5 campaigns");
                    //location.reload();
                }*/
            }
            
            function switchSearch() {
            if (document.getElementById('searchByDepartment').checked == true) {
                document.getElementById('searchByGroup').checked = false;
                $("#departmentId").removeAttr('disabled');
                $("#grpID").attr('disabled', 'disabled');
            } else {
                document.getElementById('searchByDepartment').checked = false;
                $("#grpID").removeAttr('disabled');
                $("#departmentId").attr('disabled', 'disabled');
            }
        }
        
        function viewDetailed(){
            var check = $("#viewD").val();
            if(check === "off"){
              $("#viewD").val("on");
              $("#viewD").prop("checked", true);
            } else if(check === "on"){
                $("#viewD").val("off");
                $("#viewD").prop("checked", false);
            }
        }
        
        function exportToExcel() {
                var toDate = $("#toDate").val();
                var fromDate = $("#fromDate").val();
                var campaignID = $("select#campaignsselect").val();
                
                var url = "<%=context%>/ReportsServletThree?op=CampaignsComparisionExcelReport&toDate=" + toDate + "&fromDate=" + fromDate + "&campaignID=" + campaignID;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }
            
            function shwSync(){
                var campaignID = $("select#campaignsselect").val();
                
                var url = "<%=context%>/ReportsServletThree?op=synchronizeCampaignClients&crbr=1&campaignID=" + campaignID + "&cmpnActvClntCmpn=1";
                window.open(url);
            }
            
            function getCampaigns(){
                deSelectAll();
                var CfromDate = $("#CfromDate").val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/ReportsServletThree?op=getCampaignsByBeginingDate',
                    data: {
                        CfromDate: CfromDate
                    },
                    success: function (dataStr) {
                        console.log("dataStr "+ dataStr);
                        var result = $.parseJSON(dataStr);
                        var options = [];
                        //$("#campaignsselect option:selected").prop("selected", false);
                        try {
                            $.each(result, function () {
                                if (this.campaignTitle) {
                                    options.push('<option value="', this.id, '">', this.campaignTitle, '</option>');
                                }
                            });
                        } catch (err) {
                        }
                        $("#campaignsselect").html(options.join(''));
                    }
                });
            }
            
            
            $('#select_all').click(function() {
                $('#campaignsselect option').prop('selected', true);
            });
            
            var select_ids = [];
            $(document).ready(function(e) {
                $('select#campaignsselect option').each(function(index, element) {
                    select_ids.push($(this).val());
                })
            });

            function selectAll()
            {
                $('select#campaignsselect').val(select_ids);
                document.camp_form.action = "<%=context%>/ReportsServletThree?op=CampaignsBarChartReport&deSelectAll=0";
                document.camp_form.submit();
            }
            
            function searchSelected()
            {
               // $('select#campaignsselect').val(select_ids);
                document.camp_form.action = "<%=context%>/ReportsServletThree?op=CampaignsBarChartReport&deSelectAll=0";
                document.camp_form.submit();
            }
            
            function deSelectAll()
            {
                $('select#campaignsselect').val('');
                document.camp_form.action = "<%=context%>/ReportsServletThree?op=CampaignsBarChartReport&deSelectAll=1";
                document.camp_form.submit();
            }
        </script>
    </head>
    <body>
        <input type="hidden" value="<%=title%>" id="title">
        <input type="hidden" value="<%=yTitle%>" id="yTitle">
        
        <FIELDSET class="set" style="width:85%;border-color: #006699">
            <form  NAME="camp_form" action="<%=context%>/ReportsServletThree?op=CampaignsBarChartReport" METHOD="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <TABLE class="blueBorder" ALIGN="center" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="70%" STYLE="border-width:1px;border-color:white;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="3">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="3">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="3">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" title=" <%=campDate%>" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="3">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true" title="<%=campDate%>"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="6">
                            <b><font size=3 color="white"> <%=CfromDate%></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="6">
                            <input type="text" style="width:190px" id="CfromDate" name="CfromDate" size="20" maxlength="100" title=" <%=CcampDate%>" readonly="true"
                                   value="<%=request.getAttribute("CfromDate") == null ? "" : request.getAttribute("CfromDate")%>" onchange="getCampaigns();"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="6">
                            <b><font size=3 color="white"> <%=camp%></b>
                        </td>
                    </tr>
                    <TR>
                        <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" colspan="6">
                            <select name="campaignsselect" id="campaignsselect" style="width: 70%;" multiple="multiple" class="" onchange="">
                                <%
                                    if(campaigns != null && campaigns.length>0){
                                        for(WebBusinessObject campaignWbo : campaignsList) {
                                            String selected = "0";
                                            for(int i=0; i<campaigns.length; i++) {
                                                if(campaigns[i].equals(campaignWbo.getAttribute("id"))){
                                                    selected = "1";
                                                    break;
                                                } else {
                                                }
                                            }
                                %>
                                                <option value="<%=campaignWbo.getAttribute("id")%>" <%=selected != null && selected.equals("1") ? "selected" : ""%>><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                <%
                                        }
                                    } else {
                                        for(WebBusinessObject campaignWbo : campaignsList) {
                                %>
                                            <option value="<%=campaignWbo.getAttribute("id")%>"><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>   
                        </TD>
                    </tr>
                    <TR>
                        <td  bgcolor="#dedede"  style="text-align:center; padding-bottom: 5px; padding-top: 5px" valign="middle" colspan="2" >
                            <input type="button" value="<%=sAll%>" id="select_all" name="select_all"  onclick="selectAll();" style="display: none;"/>
                            <input type="button" value="<%=searchBySelect%>" id="search_by_select" name="search_by_select"  onclick="searchSelected();"/>
                            <input type="button" value="<%=dsAll%>" id="deselect_all" name="deselect_all"  onclick="deSelectAll();"/>
                        </TD>
                        
                        <td  bgcolor="#dedede"  style="text-align:center; padding-bottom: 5px; padding-top: 5px" valign="middle" colspan="2" >
                            <button type="submit"  onclick="showChart()"  STYLE="display: none; color: #000;font-size:15px;font-weight:bold;height: 35px"> <%=print%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center; padding-bottom: 5px; padding-top: 5px; display: none;" valign="middle" colspan="2">
                            <b style="margin-left: 50px;">
                                <input  type="checkbox" value="<%=D%>" id="viewD" name="viewD" onchange="viewDetailed()" <%=D != null && D.equalsIgnoreCase("on") ? "checked" :""%> checked/>
                                <%=viewD%>
                            </b>
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center; padding-bottom: 5px; padding-top: 5px; display: none;" valign="middle" colspan="2">
                            <input type="button"  onclick="shwSync()"  STYLE="color: #000;font-size:15px;font-weight:bold;height: 35px" value="<%=shwSync%>">
                        </td>
                    </TR>
                </TABLE>
            </form>
        </fieldset>
       <%
            if(D == null || D.isEmpty() || D.equalsIgnoreCase("off") ){
       %>                
            <div id="container" style="height: 300px; width: 100%;">
            </div>
        <%
            } else { 
        %>  
            <%
                if (clientsList != null) {
            %>
                <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;margin-top: 15px;">
                    <button type="button" style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #000;font-size:15px;font-weight:bold; width: 150px; height: 30px; vertical-align: top;"
                            onclick="JavaScript: exportToExcel();" title="Export to Excel">Excel &nbsp; &nbsp;<img height="15" src="images/icons/excel.png" />
                    </button>
                            <br/>
                            <br/>
                    <table align="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <%--<th>
                                    <input type="checkbox" id="selectAll" onclick="JavaScript: selectAllChecks(this);" />
                                </th>--%>

                                <th>
                                </th>  
                                <%
                                   for (int i = 0; i < clientsListTitles.length; i++) {
                                %> 
                                    <th>

                                        <b><%=clientsListTitles[i]%></b>
                                    </th>
                                <%
                                   }
                                %>    
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                String callFunction;
                                for (WebBusinessObject clientWbo : clientsList) {
                            %>
                            <tr title="<%=lstRtTm%> <%=clientWbo.getAttribute("creationTime")%>">
                                <%--<td>
                                    <input type="checkbox" name="clientID" value="<%=clientWbo.getAttribute("clientID")%>"/>
                                    <input type="hidden" id="complaintType<%=clientWbo.getAttribute("clientID")%>" name="complaintType"
                                           value="<%=clientWbo.getAttribute("distributionType")%>"/>
                                </td>--%>

                                <td>
                                    <a target="blanck" href="<%=context%>/ClientServlet?op=clientDetails&issueID=<%=clientWbo.getAttribute("issueID")%>&clientId=<%=clientWbo.getAttribute("clientID")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;">
                                    </a>
                                </td>

                                <%
                                    for (int i = 0; i < s; i++) {
                                        attName = clientsAttributes[i];
                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";
                                        
                                        callFunction = "";
                                %>
                                <td>
                                    <div>
                                        <b<%=callFunction%>><%=attValue%></b>
                                        <%
                                            if (i == 6 && clientWbo.getAttribute("color") != null) {
                                        %>
                                        <img src="images/msdropdown/<%=clientWbo.getAttribute("color")%>.png" style="float: <%=xAlign%>; width: 20px; height: 20px;"/>
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>
                                <%
                                        }
                                %>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            
            <%}%>
        <%
            }
        %>
    </body>
</html>