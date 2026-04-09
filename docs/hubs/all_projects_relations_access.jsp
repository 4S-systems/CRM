<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.common.Tools"%>
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
                String project_name_label = null;
                String project_location_label = null;
                String project_desc_label = null;
                String title_1, title_2;
                String cancel_button_label;
                String save_button_label;
                String fStatus;
                String sStatus;
                String site, selectAll;

                String sitesLabel, siteLabel2, saveStatus, accessLabel, dist_Label, cost_Label, totalCostLabel, fromDate, toDate;
                String accessEnableMsg, accessDisableMsg;
                String compareDateMsg, beginDateMsg, endDateMsg;
                if (stat.equals("En")) {

                    saving_status = "Saving status";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:center";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    project_name_label = "Location name";
                    project_location_label = "Location number";
                    project_desc_label = "Location decription";
                    title_1 = "Projects Relations Accessibility";
                    title_2 = "All information are needed";
                    cancel_button_label = "Cancel ";
                    save_button_label = "Save ";
                    langCode = "Ar";
                    Dupname = "Name is Duplicated Chane it";
                    sStatus = "Site Saved Successfully";
                    fStatus = "Fail To Save This Site";
                    site = "Site";
                    selectAll = "All";

                    sitesLabel = "Sites";
                    saveStatus = "Save Status";
                    accessLabel = "Accessibilty";
                    dist_Label = "Distance";
                    cost_Label = "Cost";
                    totalCostLabel = "Total Cost";
                    accessEnableMsg = "Are You Sure you want to ENABLE the accessibility";
                    accessDisableMsg = "Are You Sure you want to DISABLE the accessibility";

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
                    style = "text-align:cenetr";
                    lang = "English";
                    project_name_label = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; ";
                    project_location_label = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
                    project_desc_label = " &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
                    title_1 = "قابلية الوصول بين المواقع";
                    title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
                    cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
                    save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
                    langCode = "En";
                    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
                    fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
                    sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";

                    site = "الموقع";
                    selectAll = "الكل";

                    sitesLabel = "المواقع";
                    saveStatus = "حالة الحفظ";
                    accessLabel = "قابلية الوصول";
                    dist_Label = "المسافة";
                    cost_Label = "التكلفة";
                    totalCostLabel = "التكلفة الكلية";

                    accessEnableMsg = "هل تريد إتاحة الوصول بين الموقعين";
                    accessDisableMsg = "هل تريد غلق الوصول بين المواقعين";

                    fromDate = "من تاريخ";
                    toDate = "إلي تاريخ";

                    compareDateMsg = "  \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
                    endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                    beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                }

                String doubleName = (String) request.getAttribute("name");
                Vector projectsRelations = new Vector();
                Vector allProjects = new Vector();
                allProjects = (Vector) request.getAttribute("allProjects");
                Vector distinctProjectsTwo = new Vector();
                distinctProjectsTwo = (Vector) request.getAttribute("distinctProjectsTwo");
                projectsRelations = (Vector) request.getAttribute("projectsRelations");
                String browserType1 = (String) request.getHeader("User-Agent");
                String browserType = Tools.getBrowserInfo(browserType1);

    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css">
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css">
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />


        <LINK rel="stylesheet" type="text/css" href="css/projRelations.css" />
        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
        <link rel="stylesheet" href="jquery-ui/themes/hot-sneaks/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">
        <script type="text/javascript">
            $(document).ready(function() {

                var dates = $( "#beginDate, #endDate" ).datepicker({
                    defaultDate: "+1w",
                    changeMonth: true,
                    changeYear : true,
                    maxDate    : "+d",
                    dateFormat : "yy/mm/dd",
                    numberOfMonths: 1,
                    showAnim   : 'drop',
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

            });
        </script>
        <script type="text/javascript" src="js/jquery-ui-1.8.9.custom.min.js"></script>
        <link href="css/demos.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery.ui.dialog.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery.ui.theme.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery.ui.core.css" rel="stylesheet" type="text/css" />

        <script type="text/javascript">
            $(function() {
                $( "#dialogdiv" ).dialog({autoOpen: false,show: 'blind',
                    hide: 'explode',
                    resizable: true,
                    modal:true,
                    height:500,
                    width:450, draggable: true//,
                    //close: function(event, ui) { $('#access'+code_).html("<img height='30' width='30'  src='images/unrelated.png'/>"); }
                });



                $('#access').click(function(){
                    if($('#access').is(':checked')){
                        $('#dist').attr('disabled', false);
                        $('#cost').attr('disabled', false);
                        //document.getElementById("cost").disabled=false;
                    } else {
                        $('#dist').attr('disabled', true);
                        $('#cost').attr('disabled', true);
                    }
                });

                /*var dp_cal1 = null;
                var dp_cal2 = null;
                if(dp_cal1 == null && dp_cal2 == null) {
                    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                    dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
                }*/
            });
        </script>
        <script type="text/javascript">
            var code_ = '';
            var id_ = '';
            var projID1 = '';
            var projID2 = '';
            var eventType = '';
            var image = "related_.png";
            function addProjsAccessibility(projId1, projId2, code, dialogTitle){

                //alert(dialogTitle);
                var answer = confirm ('<%=accessEnableMsg%> (' + dialogTitle + ')');
                if (answer){
                    $('#accessible'+code).val("1");
                    $('#Aaccess'+code).html('<img src="images/ajax_small.gif"><br>...Saving');

                    $('#save').css('display', 'inline');
                    $('#dialogdiv').dialog( "option" , "title" ,"Relate " + dialogTitle);
                    $("#dialogdiv").dialog('open');
                    //$("#dialogdiv").attr('title', 'p1 p2');
                    code_=code;
                    projID1 = projId1;
                    projID2 = projId2;
                    eventType = 'save';

                }
            }
            
            function saveProjsAccessibility(){
                

                if($('#access').is(':checked') && $('#access').val() == '1'){
                    $('#accessible'+code_).val('1');
                    image = "related_.png";
                } else {
                    $('#accessible'+code_).val('0');
                    image = "unrelated.png";
                }
                if($('#dist').val() == ''){
                    $('#dist').val('0');
                }
                if($('#cost').val() == ''){
                    $('#cost').val('0');
                }

                if(!IsNumeric($('#dist').val())){
                    alert('Distance must be numeric');
                    $('#access'+code_).html("<img height='30' width='30'  src='images/unrelated.png'/>");
                    return false;
                }
                if(!IsNumeric($('#cost').val())){
                    alert('Cost must be numeric');
                    $('#access'+code_).html("<img height='30' width='30'  src='images/unrelated.png'/>");
                    return false;
                }
                
                $.ajax({
                    type: "POST",
                    url: "<%=context%>/HubsServlet?op=addProjectsRelation",
                    data: "saveSiteRelation=ok&siteOne="+projID1+"&siteTwo="+projID2+"&access="+$('#accessible'+code_).val()+"&distance="+$('#dist').val()+"&cost="+$('#cost').val()+"&beginDate="+$('#beginDate').val()+"&endDate="+$('#endDate').val(),
                    success: function(msg){
                        
                        $('#access'+code_).html("<img height='30' width='30'  src='images/" + image + "'/>");
                        
                        $("#dialogdiv").dialog('close');
                        
                        $('#access').attr('checked', false);
                        $('#dist').val('');
                        $('#cost').val('');
                        $('#dist').attr('disabled', true);
                        $('#cost').attr('disabled', true);
                        
                        $('#access1' + code_).html("<div id='access"+code_+"' " + "onclick=\"JavaScript: updateRelations('"+msg+"', '"+code_+"');\"" + '><img height="30" width="30" src="images/'+image+'" /></div>');
                        $('#save').css('display', 'none');
                    
                    }
                });
            }

            function updateRelations(id1, code, dialogTitle){
                eventType = 'update';
                code_ = code;
                id_ = id1;
                var message = '';
                var access = $('#accessible' + code_);
                var img = $('#access' + code_);
                if(access.val() == '1'){
                    image = "unrelated.png";
                    message = '<%=accessDisableMsg%>';
                } else {
                    message = '<%=accessEnableMsg%>';
                }
                message += '(' + dialogTitle + ')';
                var answer = confirm (message);
                if (answer){

                    if(access.val() == '1'){
                        access.val('0');
                        $.ajax({
                            type: "POST",
                            url: "<%=context%>/HubsServlet",
                            data: "op=updateProjRelations&id="+id_+"&access="+access.val()+"&distance=0&cost=0&beginDate="+$('#beginDate').val()+"&endDate="+$('#endDate').val(),
                            success: function(msg){
                                $('#access1' + code_).html("<div id='access"+code_+"' " + "onclick=\"JavaScript: updateRelations('"+id_+"', '"+code_+"');\"" + '><img height="30" width="30" src="images/'+image+'" /></div>');
                            }
                        });
                    } else {

                        $(img).html('<img src="images/ajax_small.gif"><br>...Saving');
                        $('#access').css('cheched', true);
                        access.val("1");
                        $('#dialogdiv').dialog( "option" , "title" ,"Relate " + dialogTitle);
                        $("#dialogdiv").dialog('open');
                        code_=code;
                        id_ = id1;
                        $('#update').css('display', 'inline');
                    }

                }
            }

            function updateAccessibility(){
                var image = "related_.png";

                var access = $('#accessible' + code_);
                var img = $('#access' + code_);
                var accessCheckBox = $('#access');
                var distanceText = $('#dist');
                var costText = $('#cost');


                if(accessCheckBox.is(':checked') && $('#access').val() == '1'){

                    access.val('1');
                    image = "related_.png";
                } else {
                    access.val('0');
                    image = "unrelated.png";
                }

                if(distanceText.val() == ''){
                    distanceText.val('0');
                }
                if(costText.val() == ''){
                    costText.val('0');
                }

                if(!IsNumeric(distanceText.val())){
                    alert('Distance must be numeric');
                    img.html("<img height='30' width='30'  src='images/unrelated.png'/>");
                    return false;
                }
                if(!IsNumeric(costText.val())){
                    alert('Cost must be numeric');
                    img.html("<img height='30' width='30'  src='images/unrelated.png'/>");
                    return false;
                }
                
                $(img).html('<img src="images/ajax_small.gif"><br>...Saving');
                $.ajax({
                    type: "POST",
                    url: "<%=context%>/HubsServlet",
                    data: "op=updateProjRelations&id="+id_+"&access="+access.val()+"&distance="+distanceText.val()+"&cost="+costText.val()+"&beginDate="+$('#beginDate').val()+"&endDate="+$('#endDate').val(),
                    success: function(msg){
                        $('#access1' + code_).html("<div id='access"+code_+"' " + "onclick=\"JavaScript: updateRelations('"+id_+"', '"+code_+"');\"" + '><img height="30" width="30" src="images/'+image+'" /></div>');
                        if(access.val() == '0'){
                            image = "unrelated.png";
                        }
                        
                        $("#dialogdiv").dialog('close');
                        $('#dist').attr('disabled', true);
                        $('#cost').attr('disabled', true);
                        
                        accessCheckBox.attr('checked', false);
                        distanceText.val('');
                        costText.val('');
                        $('#update').css('display', 'none');
            
                    }
                });
            }
        </script>
    </HEAD>


    <BODY id="formError">

        <FORM NAME="PROJECT_FORM" METHOD="POST">

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

                <table class="tableStyle" align="<%=align%>" style="text-align: center;" dir="<%=dir%>">
                    <thead>
                        <TR>

                            <th STYLE="<%=style%>; width: 30%" class='th tabletitle'>
                                <%=sitesLabel%>
                            </th>
                            <%
                                        if (allProjects.size() > 0) {
                                            WebBusinessObject wbo = new WebBusinessObject();
                                            String projOne, projTwo, accessible, distance, cost, id, bgColor = "", bgColorm = "";
                                            String projName1 = "", projName2 = "", projId;

                                            for (int i = 0; i < allProjects.size(); i++) {
                                                wbo = (WebBusinessObject) allProjects.get(i);
                                                projName2 = wbo.getAttribute("projectName").toString();


                            %>
                            <th STYLE="<%=style%>; width: 30%" class='th tabletitle'>
                                <%=projName2%>
                            </th>
                            <%}
                                        }%>
                        </TR>
                    </thead>
                    <tbody>

                        <%
                        //if (projectsRelations.size() > 0) {
                            WebBusinessObject wbo = new WebBusinessObject();
                            String projOne, projOne1, projTwo, accessible, distance, cost, id, bgColor = "", bgColorm = "";
                            String projName1 = "", event = "", projId1, projId2;
                            int n = 0;

                            WebBusinessObject wbbo = null;
                            WebBusinessObject wbbo1 = null;
                            WebBusinessObject wbbo0 = null;
                            projName1 = "";
                            for (int j = 0; j < allProjects.size(); j++) {
                                wbbo = (WebBusinessObject) allProjects.get(j);
                                projId1 = wbbo.getAttribute("projectID").toString();
                                projName1 = wbbo.getAttribute("projectName").toString();
                        %>
                        <TR>
                            <td nowrap="nowrap" STYLE="<%=style%>;" class="<%=bgColorm%>">
                                <%=projName1%><hr>
                            </td>
                            <%
                            for (int h = 0; h < j + 1; h++) {%>
                            <td nowrap="nowrap" STYLE="<%=style%>;"class="<%=bgColor%>">
                                <div style="width:60px;"></div>
                                <input type="hidden" value="0" />
                            </td>
                            <%}
                            String image = "unrelated.png";

                            if ((n % 2) == 1) {
                                bgColor = "silver_odd";
                                bgColorm = "silver_odd_main";

                            } else {
                                bgColor = "silver_even";
                                bgColorm = "silver_even_main";
                            }
                            n++;
                            int success = 0;
                            String name1 = "", name2 = "", dialogTitle = "";
                            for (int l = j + 1; l < allProjects.size(); l++) {
                                wbbo0 = (WebBusinessObject) allProjects.get(j);
                                name2 = wbbo0.getAttribute("projectName").toString();
                                wbbo1 = (WebBusinessObject) allProjects.get(l);
                                name1 = wbbo1.getAttribute("projectName").toString();
                                dialogTitle = name1 + " and " + name2;
                                projId2 = wbbo1.getAttribute("projectID").toString();
                                String event1 = "";
                                image = "unrelated.png";
                                success = 0;
                                String code = "";
                                code = Integer.toString(j) + "" + Integer.toString(l);
                                for (int m = 0; m < projectsRelations.size(); m++) {
                                    code +=  Integer.toString(m);
                                    event1 = "onclick=\"JavaScript: addProjsAccessibility('" + projId1 + "', '" + projId2 + "', '" + code + "', '" + dialogTitle + "');\"";
                                    wbo = (WebBusinessObject) projectsRelations.get(m);
                                    id = wbo.getAttribute("id").toString();
                                    projOne = wbo.getAttribute("projOne").toString();
                                    projTwo = wbo.getAttribute("projTwo").toString();
                                    accessible = wbo.getAttribute("accessible").toString();
                                    event = "onclick=\"JavaScript: updateRelations('" + id + "', '" + code + "', '" + dialogTitle + "');\"";

                                    if ((projId1.equals(projOne) && projId2.equals(projTwo)) || (projId1.equals(projTwo) && projId2.equals(projOne))) {
                                        success = 1;
                                        if (accessible.equals("1")) {
                                            image = "related_.png";

                                        } else {
                                            image = "unrelated.png";

                                        }
                            %>
                            <td nowrap="nowrap" STYLE="<%=style%>;"class="<%=bgColor%>">
                                <div style="width:60px;" id="access1<%=code%>">
                                <div id="access<%=code%>" style="width:60px;"><img height="30" width="30" src="images/<%=image%>" <%=event%> style="padding-bottom: -20px" /></div>
                                </div>
                                <input type="hidden" id="accessible<%=code%>" value="<%=accessible%>" />
                            </td>
                            <%
                                    break;
                                }
                            }

                            if (success == 0) {
                                code +=  Integer.toString(l-1);
                                event1 = "onclick=\"JavaScript: addProjsAccessibility('" + projId1 + "', '" + projId2 + "', '" + code + "', '" + dialogTitle + "');\"";
    %>

                            <td nowrap="nowrap" STYLE="<%=style%>;"class="<%=bgColor%>">
                                <div style="width:60px;" id="access1<%=code%>">
                                    <div id="Aaccess<%=code%>" <%=event1%> style="width:60px;"><img height="30" width="30" src="images/relate.png" style="padding-bottom: -20px" /></div>
                                    <div id="access<%=code%>" <%=event%> style="width:60px; display: none;"><img height="30" width="30" src="images/related.png" style="padding-bottom: -20px;" /></div>
                                </div>
                                <input type="hidden" id="accessible<%=code%>" value="1" />
                            </td>
                            <%}

                                                                        }
                            %>
                        <TR>
                            <%

                                            }
                                        //}

                            %>
                    </tbody>
                    <tfoot>

                    </tfoot>

                </table>
                    <div id="dialogdiv" title="relate projects" style="overflow: scroll;">
                    <table align="<%=align%>" dir="<%=dir%>">
                        <TR>

                            <TD STYLE="<%=style%>"class='td'>
                                <LABEL FOR="str_Function_Desc">
                                    <p><b><%=accessLabel%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <td class='td'><b>:</b></td>

                            <TD STYLE="<%=style%>"class='td'>
                                <input type="checkbox" checked name="access" id="access" value="1" />
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
                                <input type="TEXT" name="dist" dir="<%=dir%>" ID="dist" size="32" value="" maxlength="255">
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
                                <input type="TEXT" dir="<%=dir%>" name="cost" ID="cost" size="32" value="" maxlength="255">
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
                        <TR>

                            <TD STYLE="<%=style%>; text-align: center;"class='td'>
                                
                                    <p><b><input type="button" name="save" id="save" value="Save" style="display: none;" onclick="javascript: saveProjsAccessibility();" /><br />
                                            <input type="button" name="update" id="update" value="Update" style="display: none;" onclick="javascript: updateAccessibility();" /></b>
                                
                            </TD>
                        </TR>
                    </table>
                </div>
                <br><br><br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
