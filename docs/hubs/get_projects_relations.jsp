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

                String sitesLabel, saveStatus, accessLabel, dist_Label, cost_Label, totalCostLabel;
                String accessEnableMsg, accessDisableMsg;
                if (stat.equals("En")) {

                    saving_status = "Saving status";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:center";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    project_name_label = "Location name";
                    project_location_label = "Location number";
                    project_desc_label = "Location decription";
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

                    sitesLabel = "Sites";
                    saveStatus = "Save Status";
                    accessLabel = "Accessibilty";
                    dist_Label = "Distance";
                    cost_Label = "Cost";
                    totalCostLabel = "Total Cost";
                    accessEnableMsg  = "Are You Sure you want to ENABLE the accessibility";
                    accessDisableMsg = "Are You Sure you want to DISABLE the accessibility";
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

                    sitesLabel = "المواقع";
                    saveStatus = "حالة الحفظ";
                    accessLabel = "قابلية الوصول";
                    dist_Label = "المسافة";
                    cost_Label = "التكلفة";
                    totalCostLabel = "التكلفة الكلية";

                    accessEnableMsg  = "هل تريد إتاحة الوصول بين الموقعين";
                    accessDisableMsg = "هل تريد غلق الوصول بين المواقعين";
                }

                String doubleName = (String) request.getAttribute("name");
                Vector projectsRelations = new Vector();
                Vector allProjects = new Vector();
                allProjects = (Vector) request.getAttribute("allProjects");
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
        <script type="text/javascript">
            function hideLabel(label, field){

                $('#'+label).css('display', 'none');
                $('#'+field).css('display', 'inline');
                $('#'+field).focus();

            }
            function editLabel(label, field, id, msg1, saveType, i){
                
                $('#'+msg1).html('<img src="images/ajax_small.gif"><br>...Saving');
                if(!IsNumeric($('#editDist'+i).val())){
                    alert('Distance must be numeric');
                    return false;
                }
                if(!IsNumeric($('#editCost'+i).val())){
                    alert('Cost must be numeric');
                    return false;
                }
                if($('#editCost'+i).val() == ''){
                    $('#editCost'+i).val('0');
                }
                if($('#editDist'+i).val() == ''){
                    $('#editDist'+i).val('0');
                }
                $.ajax({
                    type: "POST",
                    url: "<%=context%>/HubsServlet?op=updateProjectsRelations",
                    data: "id="+id+"&value="+$('#'+field).val() + "&saveType=" +saveType,
                    success: function(msg){
                        setTimeout(function() { $('#'+msg1).html("<img height='40' width='40' src='images/save_complete.png'/>"); }, 500);
                        $('#'+label).html($('#'+field).val());
                        $('#'+label).css('display', 'inline');
                        $('#'+field).css('display', 'none');
                        var tc = parseFloat($('#editDist'+i).val()) * parseFloat($('#editCost'+i).val());
                        $('#totalCost'+ i).html(tc);
                    }
                });

            }

            function updateAccessibility(access, id, imageId, accessId, i){
                var image = "save_complete.png";
                var accessMsg = "";
                if(access == '1'){
                    access = '0';
                    accessMsg = '<%=accessDisableMsg%>';

                } else {
                    access = '1';
                    accessMsg = '<%=accessEnableMsg%>';
                }
                var answer = confirm (accessMsg);
                if (answer){

                    
                    $('#'+accessId).val(access);
                    $('#'+imageId).html('<img src="images/ajax_small.gif"><br>...Saving');
                    $.ajax({
                        type: "POST",
                        url: "<%=context%>/HubsServlet?op=updateProjectsRelations",
                        data: "id="+id+"&value="+access + "&saveType=access",
                        success: function(msg){
                            setTimeout(function() { $('#'+imageId).html("<img height='30' width='30'  src='images/" + image + "'/>"); }, 500);
                            if(access == '0'){
                                image = "save_not_complete.png";

                                if(<%=!browserType.equals("MSIE-6.0")%>){
                                    $('#clickable'+ i).attr('onclick', '');
                                    $('#clickable1'+ i).attr('onclick', '');
                                }
                                $('#clickable'+ i).attr('disabled', true);
                                $('#clickable1'+ i).attr('disabled', true);
                                $('#clickable'+ i).html('---');
                                $('#clickable1'+ i).html('---');
                                $('#editDist'+ i).val('0');
                                $('#editCost'+ i).val('0');
                                $('#totalCost'+ i).html('---');
                            } else {

                                $('#clickable'+ i).attr('disabled', false);
                                $('#clickable1'+ i).attr('disabled', false);
                            
                                if(<%=!browserType.equals("MSIE-6.0")%>){
                                    $('#clickable'+ i).attr('onclick', 'JavaScript: hideLabel("clickable' + i + '","editDist' + i + '");');
                                    $('#clickable1'+ i).attr("onclick", "JavaScript: hideLabel('clickable1" + i + "','editCost" + i + "');");
                                }

                                $('#clickable'+ i).html($('#editDist'+i).val());
                                $('#clickable1'+ i).html($('#editCost'+i).val());
                                $('#totalCost'+ i).html(parseFloat($('#editDist'+i).val()) * parseFloat($('#editCost'+i).val()));
                            }
            
            
                        }
                    });
                }
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
                <table align="<%=align%>" dir="<%=dir%>">
                    <TR ALIGN="<%=align%>">

                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=title_2%></FONT> 
                        </TD>

                    </TR>
                </table>
                <br>
                <table class="tableStyle" align="<%=align%>" style="text-align: center;" dir="<%=dir%>">
                    <thead>
                        <TR>

                            <th STYLE="<%=style%>; width: 30%" class='th tabletitle'>
                                <%=sitesLabel%>
                            </th>
                            <th STYLE="<%=style%>" class='th tabletitle'>
                                <%=accessLabel%>
                            </th>
                            <th STYLE="<%=style%>" class='th tabletitle'>
                                <%=dist_Label%>
                            </th>
                            <th STYLE="<%=style%>; width: 70px" class='th tabletitle'>
                                <%=cost_Label%>
                            </th>
                            <th STYLE="<%=style%>; width: 150px" class='th tabletitle'>
                                <%=totalCostLabel%>
                            </th>
                            <th STYLE="<%=style%>; width: 60px" class='th tabletitle'>
                                <%=saveStatus%>
                            </th>
                        </TR>
                    </thead>
                    <tbody>

                        <%                        if (projectsRelations.size() > 0) {
                                        WebBusinessObject wbo = new WebBusinessObject();
                                        String projOne, projTwo, accessible, distance, cost, id, bgColor = "", bgColorm = "";
                                        String projName1 = "", projName2 = "", projId;
                                        float totalCost = 0;
                                        int n = 0;
                                        for (int i = 0; i < projectsRelations.size(); i++) {
                                            wbo = (WebBusinessObject) projectsRelations.get(i);
                                            id = wbo.getAttribute("id").toString();
                                            projOne = wbo.getAttribute("projOne").toString();
                                            projTwo = wbo.getAttribute("projTwo").toString();
                                            accessible = wbo.getAttribute("accessible").toString();
                                            distance = wbo.getAttribute("distance").toString();
                                            cost = wbo.getAttribute("distCost").toString();
                                            totalCost = (float) Math.round(Float.parseFloat(distance) * Float.parseFloat(cost));
                                            WebBusinessObject wbbo = null;
                                            projName1 = ""; projName2 = "";
                                            for (int j = 0; j < allProjects.size(); j++) {
                                                
                                                wbbo = (WebBusinessObject) allProjects.get(j);
                                                projId = wbbo.getAttribute("projectID").toString();
                                                if (projId.equalsIgnoreCase(projOne)) {
                                                    projName1 = wbbo.getAttribute("projectName").toString();
                                                }

                                                if (projId.equalsIgnoreCase(projTwo)) {
                                                    projName2 = wbbo.getAttribute("projectName").toString();
                                                }
                                                if (!projName1.equalsIgnoreCase("") && !projName2.equalsIgnoreCase("")) {
                                                    break;
                                                }

                                            }
                                            String image, event1 = "", event2 = "";
                                            String ditsLabel = "", costLabel = "";
                                            String disabled = "";
                                            event1 = "onclick=\"JavaScript: hideLabel('clickable" + i + "', 'editDist" + i + "');\"";
                                            event2 = "onclick=\"JavaScript: hideLabel('clickable1" + i + "', 'editCost" + i + "');\"";
                                            if (accessible.equals("1")) {
                                                image = "save_complete.png";
                                                ditsLabel = distance;
                                                costLabel = cost;

                                                /*event1 = "JavaScript: hideLabel('clickable"+i+"', 'editDist"+i+"');";
                                                event2 = "JavaScript: hideLabel('clickable1"+i+"', 'editCost"+i+"');";*/
                                            } else {
                                                ditsLabel = "---";
                                                costLabel = "---";
                                                totalCost = 0;
                                                disabled = "disabled";

                                                image = "save_not_complete.png";

                                                if (!browserType.equals("MSIE-6.0")) {
                                                    event1 = "";
                                                    event2 = "";
                                                }
                                            }

                                            if ((n % 2) == 1) {
                                                bgColor = "silver_odd";
                                                bgColorm = "silver_odd_main";

                                            } else {
                                                bgColor = "silver_even";
                                                bgColorm = "silver_even_main";
                                            }
                                            n++;
                        %>
                        <TR>
                            <td nowrap="nowrap" STYLE="<%=style%>; text-align: center;" class="<%=bgColorm%>">
                                <%=projName1%><hr><%=projName2%>
                            </td>
                            <td nowrap="nowrap" STYLE="<%=style%>; text-align: center;"class="<%=bgColor%>">
                                <div id="access<%=i%>" style="width:110px;"  onclick="JavaScript: updateAccessibility($('#accessible<%=i%>').val(), <%=id%>, 'access<%=i%>', 'accessible<%=i%>', '<%=i%>');"><img height="30" width="30" src="images/<%=image%>" style="padding-bottom: -20px" /></div>
                                <input type="hidden" id="accessible<%=i%>" value="<%=accessible%>" />
                            </td>
                            <td nowrap="nowrap" STYLE="<%=style%>; text-align: center;" class="silver_odd">
                                <center>
                                    <label id="clickable<%=i%>" <%=event1%> <%=disabled%> class="clickable"><%=ditsLabel%></label>
                                    <input id="editDist<%=i%>" onblur="JavaScript: editLabel('clickable<%=i%>', 'editDist<%=i%>', '<%=id%>', 'res<%=i%>', 'dist', '<%=i%>');" size="10" maxlength="10" name="editDist<%=i%>" type="text" class="editable" value="<%=distance%>" />
                                </center>
                            </td>
                            <td nowrap="nowrap" STYLE="<%=style%>; text-align: center;"class="silver_even">
                                <center>
                                    <label id="clickable1<%=i%>" <%=event2%> <%=disabled%> class="clickable"><%=costLabel%></label>
                                    <input id="editCost<%=i%>" onblur="JavaScript: editLabel('clickable1<%=i%>', 'editCost<%=i%>', '<%=id%>', 'res<%=i%>', 'cost', '<%=i%>');" name="editCost<%=i%>" type="text" class="editable" size="10" maxlength="10" value="<%=cost%>" />
                                </center>
                            </td>
                            <td nowrap="nowrap" STYLE="<%=style%>; text-align: center;"class="silver_even">
                                <center>
                                    <label id="totalCost<%=i%>" class="clickable"><%=totalCost%></label>
                                </center>
                            </td>
                            <td nowrap="nowrap" STYLE="<%=style%>; text-align: center;" class="silver_odd"><div id="res<%=i%>" style="width:110px;" ></div></td>
                        </TR>
                        <%}
                                    }%>
                    </tbody>
                    <tfoot>

                    </tfoot>

                </table>
                <br><br><br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
