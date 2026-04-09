<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
        int flipper = 0;
        String className;
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] projectAttributes = {"projectName"};
        String[] projectListTitles = new String[4];
        int s = projectAttributes.length;
        int t = s + 2;
        int iTotal = 0;
        String attName, attValue, maxInstalments, edite, projectAccId;
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        ArrayList<WebBusinessObject> neightborhoodList = (ArrayList<WebBusinessObject>) request.getAttribute("neightborhoodList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String sProjectsTotal, sProjectsList, viewEngineers, projectName,chooseProject;
        if (stat.equals("En")) {
            chooseProject="Choose Projcts";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            projectListTitles[0] = "Project Name";
            projectListTitles[1] = " Area ";
            projectListTitles[3] = "View";
            projectListTitles[2] = "Instalments Number";
            sProjectsTotal = "Total Projects";
            sProjectsList = " Attach Projects ";
            viewEngineers = "View Engineers";
            edite = "Edite";
        } else {
            edite = "تعديل";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            projectListTitles[0] = "اسم المشروع";
            projectListTitles[1] = " المنطقة ";
            projectListTitles[3] = "عرض";
            projectListTitles[2] = "عدد الوحدات";
            sProjectsTotal = "عدد المشاريع";
            sProjectsList = "ربط المشاريع";
            viewEngineers = "عرض المهندسين";
            chooseProject="أختر المشاريع";
        }
    %>

    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <title>Project List</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        
        <script  TYPE="text/javascript">
            var divID;
            function closePopup(formID) {
                $("#" + formID).hide();
                $('#overlay').hide();
            }
            function closeOverlay() {
                $("#" + divID).hide();
                $("#overlay").hide();
            }
            function showProjectUsers(projectID) {
                divID = "project_engineers";
                $('#overlay').show();
                var url = "<%=context%>/ProjectServlet?op=manageProjectEngineers&projectID=" + projectID;
                jQuery('#project_engineers').load(url);
                $('#project_engineers').css("display", "block");
                $('#project_engineers').dialog();
            }
            function editProjectAccount(projectAccId, projectName) {
                divID = "project_engineers";
                $('#overlay').show();
                var url = "<%=context%>/ProjectServlet?op=editeProjectAccount&projectAccId=" + projectAccId + "&projectName=" + encodeURI(projectName);
                jQuery('#project_engineers').load(url);
                $('#project_engineers').css("display", "block");
                $('#project_engineers').dialog();
            }
            
            
            function isChecked() {
                var isChecked = false;
                $("input[name='prjID']").each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                    }
                });
                return isChecked;
            }
            
            function addprjzone(){
                //var prjIDVal = [];
                if (!isChecked()) {
                    alert('<fmt:message key="selectPrjMsg" />');
                    return false;
                } else {
                    document.prjForm.action = "<%=context%>/ProjectServlet?op=addProjectZone&save=true";
                    document.prjForm.submit();
                }
            }
            
            $(document).ready(function(){
                $('#projects').DataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });
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
            .smallDialog {
                width: 320px;
                display: none;
                position: fixed;
                z-index: 1100;
            }
            .mediumDialog {
                width: 370px;
                display: none;
                position: fixed;
                z-index: 1100;
                top: 150px;
                left: 500px;
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 1000;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }
            #container{
	font-family:Arial, Helvetica, sans-serif;
	position:absolute;
	top:0;
	left:0;
	background: #005778;
	width:100%;
	height:100%;
}
.hot-container p { margin-top: 10px; }
a { text-decoration: none; margin: 0 10px; }

.hot-container {
	min-height: 100px;
	margin-top: 100px;
	width: 100%;
	text-align: center;
}

a.btn {
	display: inline-block;
	color: #666;
	background-color: #eee;
	text-transform: uppercase;
	letter-spacing: 2px;
	font-size: 12px;
	padding: 10px 30px;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border: 1px solid rgba(0,0,0,0.3);
	border-bottom-width: 3px;
}

	a.btn:hover {
		background-color: #e3e3e3;
		border-color: rgba(0,0,0,0.5);
	}
	
	a.btn:active {
		background-color: #CCC;
		border-color: rgba(0,0,0,0.9);
	}

        </style>
    </head>
    <body>
        <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">
        </div>
        <div id="project_engineers" class="mediumDialog"></div>
        <div align="left" style="color:blue;">
        </div> 
        <fieldset align=center class="set">
            <legend align="center">
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6"><%=sProjectsList%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br/>
            <!-- in development abd elrahman mohamed 13/5/2017-->
            <form name="prjForm" id="prjForm" method="POST">
                <table align="<%=align%>" cellpadding="0" cellspacing="0" BORDER="0">
                    <Tr>
                        <TD>
                            <%=chooseProject%>
                        </TD>
                    </Tr>
                    <tr>
                        <td class='td'>
                            <select id="regons_list" class="chosen-select-campaign" style="font-size: 14px;font-weight: bold; width: 300px;" name="zoneID">
                                <option >choose a regon</option>
                                <sw:WBOOptionList wboList='<%=neightborhoodList%>' displayAttribute="projectName" valueAttribute="projectID" />
                            </select>
                            <a href="#" class="btn" onclick="addprjzone()">Attach Projects</a>
                        </td>
                    </tr>
                </table>
            <!-- ------------------------------------------------------------------------------- -->
            <div style="width: 50%;margin-left:auto; margin-right:auto;" >
                <table id="projects" align="<%=align%>" width="100%" dir="<%=dir%>" cellpadding="0" cellspacing="0" >
                <thead>
                <tr >
                    <th nowrap class="silver_header" width="20"  style="border-width:0;" nowrap>
                        <b></b>
                    </th>
                    <%
                        String columnColor = new String("");
                        String columnWidth = new String("100");
                        String font = new String("12");
                        for (int i = 0; i < projectListTitles.length; i++) {
                            if (i == 0) {
                                columnColor = "#9B9B00";
                            } else {
                                columnColor = "#7EBB00";
                            }
                    %>

                    <th nowrap class="silver_header"   style="border-width:0; font-size:<%=font%>;" nowrap>
                        <b><%=projectListTitles[i]%></b>
                    </th>
                    
                    <%
                        }
                    %>
                    <th nowrap class="silver_header"   style="border-width:0; font-size:<%=font%>;" nowrap>
                        <b><%=edite%></b>
                    </th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (WebBusinessObject wbo : projectsList) {
                        iTotal++;
                        flipper++;
                        if ((flipper % 2) == 1) {
                            className = "silver_odd_main";
                        } else {
                            className = "silver_even_main";
                        }
                        projectAccId = ((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("projectAccId") + "";
                        projectName = wbo.getAttribute("projectName") + "";
                %>
                <tr>
                    <%
                        for (int i = 0; i < s; i++) {
                            attName = projectAttributes[i];
                            attValue = (String) wbo.getAttribute(attName);
                            maxInstalments = ((WebBusinessObject) wbo.getAttribute("projectAcc")).getAttribute("maxInstalments") + "";

                    %>
                    <td>
                        <input type="checkbox" name="prjID" value="<%=wbo.getAttribute("projectID")%>" <input type="checkbox" name="prjID" value="<%=wbo.getAttribute("projectID")%>" <%if(wbo.getAttribute("projectZone") != null){%> disabled <%}%>/>
                    </td>
                    <td style="<%=style%>"  nowrap  class="<%=className%>" >
                        <div >
                            <b> <%=attValue%> </b>
                        </div>
                    </td>
                    
                    <td style="<%=style%>"  nowrap  class="<%=className%>" >
                        <div >
                            <b>
                                 <%=wbo.getAttribute("prjZoneName") != null ? wbo.getAttribute("prjZoneName") : ""%> 
                            </b>
                        </div>
                    </td>
                    
                    <td style="<%=style%>" nowrap  class="<%=className%>" >
                        <div >
                            <b id="maxInstamnts<%=wbo.getAttribute("projectID")%>"> <%=maxInstalments%> </b>
                        </div>
                    </td>
                    <%
                        }
                    %>
                    <td style="<%=style%>"   nowrap  class="<%=className%>" >
                        <div >
                            <b onclick="JavaScript: showProjectUsers('<%=wbo.getAttribute("projectID")%>');" style="cursor: pointer;"> <%=viewEngineers%> </b>
                        </div>
                    </td>
                    <td style="<%=style%>" bgcolor="#DDDD00"  nowrap  class="<%=className%>" >
                        <div >
                            <b onclick="JavaScript: editProjectAccount('<%=projectAccId%>', '<%=projectName%>');" style="cursor: pointer;"> <%=edite%> </b>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %> 
                </tbody>
            </table>
            </div>
                </FORM>
            <br><br>
        </fieldset>
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>
