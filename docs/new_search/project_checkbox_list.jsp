<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">

    <head>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </head>
    
    <%

    int i = 0, j = 0;
    
    WebBusinessObject mainProjectWbo = null,
                subProjectWbo = null;

    Vector allSites = (Vector) request.getAttribute("allSites"),
           subProjectVec = null;

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    String mainProjectId = null,
           subProjectId = null;

    String defaultSite = (String) request.getAttribute("defaultSite");
    String check = null;

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align, dir, style, checkAllStr;
    
    if(stat.equals("En")){
        
        align = "left";
        dir = "LTR";
        style = "text-align:left";
        checkAllStr = "Check All";
        
    } else {
        
        align = "right";
        dir = "RTL";
        style = "text-align:Right";
        checkAllStr = "إختر الكل";
        
    }
    %>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        var checked = false;
        var totalSubProjectCount = null;
        
        function checkSubProjects(mainProjectId) {
            if (document.getElementById('mainProject' + mainProjectId).checked == true) {
                checked = true;

                totalSubProjectCount = document.getElementById('totalSubProjectCount' + mainProjectId).value;
                for (var i = 0; i < totalSubProjectCount; i++) {
                    document.getElementById('subProject'+ mainProjectId + i).checked = checked;
                }
            
            } else {
                checked = false;
            }

        }

        function checkAllProjects() {
           var allProjectsCbx = document.getElementById('allProjectsCbx');
           var allProjects = document.getElementById('siteAll');
           var projectArr = document.getElementsByName('site');
           
           if (allProjectsCbx.checked == true) {
                checked = true;
                allProjects.value = "yes";

            } else {
                checked = false;
                allProjects.value = "no";

            }

           for (var i = 0; i < projectArr.length; i++) {
               projectArr[i].checked = checked;
           }

        }

        /*
        // trying to check/uncheck 'check all' checkbox automatically
        function getChecked() {
          
            var checkedOffsprings = false;

            var allProjectsCbx = document.getElementById('allProjectsCbx');
            var projectArr = document.getElementsByName('site');

            for (var i = 0; i < projectArr.length; i++) {
                if(projectArr[i].checked == false) {
                    checkedOffsprings = false;
                    break;

		}
            }
           alert(checkedOffsprings)
            allProjectsCbx.checked = checkedOffsprings;
        }
        */

                function getEquipmentInPopup(){

                    var sites = document.getElementsByName('site');
                    var count = 0;

                    for(var i = 0 ;i<sites.length;i++){
                        if(sites[i].checked){
                            count++;
                          
                        }
                    }
                    if(count > 0){
                         getDataInPopup('ReportsServletThree?op=ListEquipments' + '&fieldName=UNIT_NAME&fieldValue=' + getASSCIChar(document.getElementById('unitName').value) + '&site=' + getSites() + '&formName=SEARCH_MAINTENANCE_FORM');
                    }else {
                        alert("Must select at least one Site");
                    }
                }

                function getSites(){
                   
                    var sitesValues = "'";
                    var sites = document.getElementsByName('site');
                    for(var i = 0 ;i<sites.length;i++){
                        if(sites[i].checked){
                            sitesValues = sitesValues  + sites[i].value + "','";
                        }
                    }

                    return sitesValues + "'";
                }
    </SCRIPT>
    
    <BODY>
        
        <input type="hidden" id="siteAll" value="no" name="siteAll"/>
        
        <TABLE  WIDTH="200"  CELLPADDING="0" CELLSPACING="0" STYLE="border:0px; width:100%;" ALIGN="<%=align%>" DIR="<%=dir%>">

            <TR>
                <TD CLASS="mainHeaderNormal" WIDTH="100%" STYLE="<%=style%>;padding-<%=align%>:5;">
                    <INPUT TYPE="CHECKBOX" NAME="allProjectsCbx" ID="allProjectsCbx" onclick="checkAllProjects();"/>
                    <%=checkAllStr%>
                </TD>
            </TR>

            <%
            while(i < allSites.size()) {
                mainProjectWbo = (WebBusinessObject) allSites.get(i);
                mainProjectId = (String) mainProjectWbo.getAttribute("projectID");
                check = (defaultSite.equals(mainProjectId)) ? "CHECKED" : "";

            %>

            <TR>
                <TD CLASS="act_sub_heading" WIDTH="100%" STYLE="<%=style%>;padding-<%=align%>:5;">
                    <INPUT TYPE="CHECKBOX" NAME="site" ID="mainProject<%=i%>" value="<%=mainProjectId%>" <%=check%> onclick="checkSubProjects(<%=i%>);getChecked()"/>
                    <%=mainProjectWbo.getAttribute("projectName")%>
                </TD>
            </TR>

            <%

            subProjectVec = projectMgr.getOnArbitraryKey(mainProjectId, "key2");

            while(j < subProjectVec.size()) {
                subProjectWbo = (WebBusinessObject) subProjectVec.get(j);
                subProjectId = (String) subProjectWbo.getAttribute("projectID");
                check = (defaultSite.equals(subProjectId)) ? "CHECKED" : "";

            %>
                <TR>
                    <TD WIDTH="100%" STYLE="<%=style%>;padding-<%=align%>:25;background: white;">
                        <INPUT TYPE="CHECKBOX" NAME="site" ID="subProject<%=i%><%=j%>" value="<%=subProjectId%>" <%=check%> onclick="getChecked()"/>
                        <%=subProjectWbo.getAttribute("projectName")%>
                    </TD>
                </TR>
            <%

            j++;
            }
            %>

            <input type="hidden" name="totalSubProjectCount<%=i%>" id="totalSubProjectCount<%=i%>" value="<%=j%>">

            <%
            j = 0;
            i++;
            }
            %>
            
        </TABLE>
    </BODY>
</HTML>