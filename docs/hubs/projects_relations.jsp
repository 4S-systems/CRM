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

                String selectReportType, title;

                String[] selectLabels = new String[4];
                String[] selectValues = new String[4];

                selectValues[0] = "projsRls";
                selectValues[1] = "allProjsAccess";
                selectValues[2] = "projsDist";
                selectValues[3] = "projsCost";
                
                if (stat.equals("En")) {

                    selectReportType = "Choose Report Type";
                    title = "Sites Relations Reports";
                    saving_status = "Saving status";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:center";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    project_name_label = "Location name";
                    project_location_label = "Location number";
                    project_desc_label = "Location decription";
                    title_1 = "Projects Relations";
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

                    selectLabels[0] = "Projects Relations";
                    selectLabels[1] = "Projects Accessibility";
                    selectLabels[2] = "Projects Distances";
                    selectLabels[3] = "Projects Costs";

                } else {

                    selectReportType = "إختر نوع التقرير";
                    title = "تقارير المواقع";
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
                    title_1 = "العلاقة بين المواقع";
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

                    selectLabels[0] = "علاقات المواقع";
                    selectLabels[1] = "قابلية الوصول بين المواقع";
                    selectLabels[2] = "المسافة بين المواقع";
                    selectLabels[3] = "تكلفة النقل";

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
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    $(document).ready(function(){
        view('projsRls');
    });
        function view(action)
        {
            //window.open('<%=context%>'+id+'&single=single',"_blank","toolbar=no, location=no, directories=no, status=yes, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=600");

            //alert(action);
            $("#viewerd").html('<img src="images/Loading2.gif"> loading ...');

            $.ajax({
                type: "POST",
                url: "<%=context%>/HubsServlet?op=getProjectsRelations",
                data: 'servedPage='+action,
                success: function(msg){
                    //$('#viewerd').html(msg);
                    $('#viewerd').html('<iframe src="<%=context%>/HubsServlet?op=getProjectsRelations&servedPage='+action+'" width="100%" height="500"  scrolling="yes"></iframe>');
                }
            });

        }

        function cancelForm()
        {
            document.PROJECT_FORM.action = "main.jsp";
            document.PROJECT_FORM.submit();
        }
    </SCRIPT>

    <script src='js/ChangeLang.js' type='text/javascript'></script>


    <BODY id="formError">

        <FORM NAME="PROJECT_FORM" METHOD="POST">

            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>



            <fieldset class="set" align="center">
                <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%></font></TD>
                    </TR>
                </TABLE>
                <br>

                <table ID="tableSearch" class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="70%">
                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;font-size:15px;">
                            <font  SIZE="2" COLOR="#F3D596"><b><%=selectReportType%>&nbsp;</b></font>
                        </TD>

                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;color:#000000;font-size:15px;background-color: #EDEDED" ROWSPAN="2" id="CellData" colspan="2">
                            <SELECT STYLE="font-weight: bold;font-size: 14;border: 1px solid #0000FF; width:230px; z-index:-1;" name="showProjsRlns" id="showProjsRlns" onchange="javascript: view($('#showProjsRlns :selected').val());">                                
                                <%
                                int index = 0;
                                while(index < selectValues.length){ %>
                                <option value="<%=selectValues[index]%>"><%=selectLabels[index]%></option>
                                <%index++;}%>
                            </SELECT>
                        </TD>
                    </TR>


                </table>
                <br>
                <table width="100%" border="5">
                    <tr>
                        <td valign="top">
                            <div id="viewerd"></div>
                        </td>
                    </tr>

                </table>
                <br><br><br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>
