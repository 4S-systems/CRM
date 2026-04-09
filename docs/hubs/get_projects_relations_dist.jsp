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
                    accessEnableMsg = "Are You Sure you want to ENABLE the accessibility";
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

                    accessEnableMsg = "هل تريد إتاحة الوصول بين الموقعين";
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
                
                $('#img'+i).html('<img src="images/ajax_small.gif"><br>...Saving');
                if(!IsNumeric($('#editDist'+i).val())){
                    alert('Distance must be numeric');
                    return false;
                }
                if($('#editDist'+i).val() == ''){
                    $('#editDist'+i).val('0');
                }
                $('#'+field).css('display', 'none');
                $.ajax({
                    type: "POST",
                    url: "<%=context%>/HubsServlet?op=updateProjectsRelations",
                    data: "id="+id+"&value="+$('#'+field).val() + "&saveType=" +saveType,
                    success: function(msg){
                        setTimeout(function() { 
                            $('#img'+i).html("");
                            $('#'+label).html($('#'+field).val());
                            $('#'+label).css('display', 'inline');
                        } , 500);
                        
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
                <%--<table class="tableStyle" align="<%=align%>" style="text-align: center;" dir="<%=dir%>">
                        <thead>
                            <TR>

                            <th STYLE="<%=style%>; width: 30%" class='th tabletitle'>
                                <%=sitesLabel%>
                            </th>
                            <th STYLE="<%=style%>" class='th tabletitle'>
                                <%=dist_Label%>
                            </th>
                            <th STYLE="<%=style%>; width: 70px" class='th tabletitle'>
                                <%=saveStatus%>
                            </th>
                        </TR>
                    </thead>
                    <tbody>

                        <%
                                    if (projectsRelations.size() > 0) {
                                        WebBusinessObject wbo = new WebBusinessObject();
                                        String projOne, projTwo, accessible, distance, id, bgColor = "", bgColorm = "";
                                        String projName1 = "", projName2 = "", projId;

                                        int n = 0;
                                        for (int i = 0; i < projectsRelations.size(); i++) {
                                            wbo = (WebBusinessObject) projectsRelations.get(i);
                                            id = wbo.getAttribute("id").toString();
                                            projOne = wbo.getAttribute("projOne").toString();
                                            projTwo = wbo.getAttribute("projTwo").toString();
                                            accessible = wbo.getAttribute("accessible").toString();
                                            distance = wbo.getAttribute("distance").toString();

                                            WebBusinessObject wbbo = null;
                                            projName1 = "";
                                            projName2 = "";
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
                                            String event1 = "";
                                            String ditsLabel = "";
                                            String disabled = "";
                                            event1 = "onclick=\"JavaScript: hideLabel('clickable" + i + "', 'editDist" + i + "');\"";
                                            if (accessible.equals("1")) {
                                                ditsLabel = distance;
                                            } else {
                                                ditsLabel = "---";
                                                disabled = "disabled";

                                                if (!browserType.equals("MSIE-6.0")) {
                                                    event1 = "";
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
                            <td nowrap="nowrap" STYLE="<%=style%>; text-align: center;" class="silver_odd">
                                <center>
                                    <label id="clickable<%=i%>" <%=event1%> <%=disabled%> class="clickable"><%=ditsLabel%></label>
                                    <input id="editDist<%=i%>" onblur="JavaScript: editLabel('clickable<%=i%>', 'editDist<%=i%>', '<%=id%>', 'res<%=i%>', 'dist', '<%=i%>');" size="10" maxlength="10" name="editDist<%=i%>" type="text" class="editable" value="<%=distance%>" />
                                </center>
                            </td>
                            <td nowrap="nowrap" STYLE="<%=style%>; text-align: center;" class="silver_odd"><div id="res<%=i%>" style="width:110px;" ></div></td>
                        </TR>
                        <%}
                                    }%>
                    </tbody>
                    <tfoot>

                    </tfoot>

                </table>--%>

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
                                    if (projectsRelations.size() > 0) {
                                        WebBusinessObject wbo = new WebBusinessObject();
                                        String projOne, projOne1, projTwo, accessible, distance, cost, id, bgColor = "", bgColorm = "";
                                        String projName1 = "", event = "", projId1, projId2;
                                        int n = 0;

                                        WebBusinessObject wbbo = null;
                                        WebBusinessObject wbbo1 = null;
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
                    String image = "save_not_complete.png";

                    if ((n % 2) == 1) {
                        bgColor = "silver_odd";
                        bgColorm = "silver_odd_main";

                    } else {
                        bgColor = "silver_even";
                        bgColorm = "silver_even_main";
                    }
                    n++;

                    for (int l = j + 1; l < allProjects.size(); l++) {
                        wbbo1 = (WebBusinessObject) allProjects.get(l);
                        projId2 = wbbo1.getAttribute("projectID").toString();
                        String event1 = "";
                        image = "save_not_complete.png";
                        int success = 0;
                        String code = "";
                        for (int m = 0; m < projectsRelations.size(); m++) {
                            code = Integer.toString(j) + "" + Integer.toString(l) + "" + Integer.toString(m);
                            event1 = "onclick=\"JavaScript: addProjsAccessibility('" + projId1 + "', '" + projId2 + "', '" + code + "');\"";
                            wbo = (WebBusinessObject) projectsRelations.get(m);
                            id = wbo.getAttribute("id").toString();
                            projOne = wbo.getAttribute("projOne").toString();
                            projTwo = wbo.getAttribute("projTwo").toString();
                            distance = wbo.getAttribute("distance").toString();
                            accessible = wbo.getAttribute("accessible").toString();

                            //String event1 = "";
                            String ditsLabel = "";
                            String disabled = "";
                            event1 = "onclick=\"JavaScript: hideLabel('clickable" + code + "', 'editDist" + code + "');\"";
                            if (accessible.equals("1")) {
                                ditsLabel = distance;
                            } else {
                                ditsLabel = "---";
                                disabled = "disabled";

                                if (!browserType.equals("MSIE-6.0")) {
                                    event1 = "";
                                }
                            }

                        if ((projId1.equals(projOne) && projId2.equals(projTwo)) || (projId1.equals(projTwo) && projId2.equals(projOne))) {
                            success = 1;

                            %>
                            <td nowrap="nowrap" STYLE="<%=style%>; font-size: 16px;"class="<%=bgColor%>">
                            <center>
                                <div id="img<%=code%>"></div>
                                <label id="clickable<%=code%>" <%=event1%> <%=disabled%> class="clickable"><%=ditsLabel%></label>
                                <input id="editDist<%=code%>" onblur="JavaScript: editLabel('clickable<%=code%>', 'editDist<%=code%>', '<%=id%>', 'res<%=code%>', 'dist', '<%=code%>');" size="10" maxlength="10" name="editDist<%=code%>" type="text" class="editable" value="<%=distance%>" />
                            </center>
                            </td>
                            <%
                                break;
                            }
                        }
                        if (success == 0) {%>
                        <td nowrap="nowrap" STYLE="<%=style%>;"class="<%=bgColor%>">
                            <center>
                                <label id="clickable<%=code%>" class="clickable">***</label>
                            </center>
                        </td>
                    <%}}%>
                    <TR>
                        <%}}%>
                        </tbody>
                    <tfoot>

                    </tfoot>

                </table>

                <br><br><br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
