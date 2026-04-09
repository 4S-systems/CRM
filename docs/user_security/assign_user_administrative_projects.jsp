<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.maintenance.db_access.*, com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        Vector<WebBusinessObject> projects = (Vector<WebBusinessObject>) request.getAttribute("allProjects");
        Vector<WebBusinessObject> projects_ = new Vector<WebBusinessObject>();
        Vector<String> projectsForUser = (Vector<String>) request.getAttribute("projectsForUser");
        String userId = (String) request.getAttribute("userId");
        String userName = (String) request.getAttribute("userName");
        String isDefault = (String) request.getAttribute("isDefaultProject");
        String status = (String) request.getAttribute("Status");
        if (status == null) {
            status = "";
        }

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, fStatus, sStatus, cancel, save, name, code, strDefault;
        String sPadding;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Add / Update Administrative Branches For User";
            sStatus = "Site Saved Successfully";
            fStatus = "Fail To Save This Site";
            cancel = "Cancel";
            name = "Name";
            code = "Code";
            save = "Save";
            strDefault = "Default";
            sPadding = "left";
        } else {
            align = "Right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "أضافة / تعديل الفروع الإدارية للمستخدم ";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            cancel = tGuide.getMessage("cancel");
            name = "&#1575;&#1604;&#1571;&#1587;&#1605;";
            code = "&#1575;&#1604;&#1603;&#1608;&#1583;";
            save = "&#1581;&#1600;&#1601;&#1600;&#1592;";
            strDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";

            sPadding = "right";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Assigned Stores</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/blueStyle.css"/>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm() {
                if(validateForm()) {
                    document.USER_STORES_FORM.action = "<%=context%>/UsersServlet?op=saveUserProjects&backTo=administProj";
                    document.USER_STORES_FORM.submit();
                }
            }

            function validateForm() {
                var checkProject = document.getElementsByName('checkProject');
                var isDefault = document.getElementsByName('isDefault');
                var selectIsDefault = false;
                var count = 0;

                for(var i = 0; i< checkProject.length; i++) {
                    if(checkProject[i].checked) {
                        count++;

                        if(isDefault[i].checked) {
                            selectIsDefault = true;
                        }
                    }
                }

                if(selectIsDefault && count > 0) {
                    return true;
                } else if(count == 0) {
                    alert("You must select at least one branch ... ");
                    return false;
                } else {
                    alert("You must select default branch ... ");
                    return false;
                }
            }
        
            function cancelForm() {
                document.USER_STORES_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
                document.USER_STORES_FORM.submit();
            }
        
            function checkedAll() {
                var checkProject = document.getElementsByName('checkProject');
                var isDefault = document.getElementsByName('isDefault');
                var checkSubProject = 0;
                var checked = false;
                var check = false;
                var disabled = false;
                if(document.getElementById('checkAll').checked) {
                    checked = true;
                    check  = false;
                    disabled = false;

                } else {
                    checked = false;
                    check = true;
                    disabled = true;
                }
                //alert('checkProject.length : '+checkProject.length);
                //alert('isDefault.length : '+isDefault.length);
                for(var j = 0; j< checkProject.length; j++) {
                    checkProject[j].checked = checked;

                    isDefault[j].disabled = disabled;
                    isDefault[j].checked = check;
                    try{
                        //                        document.getElementById('checkProject'+j).checked = checked;
                        //                        isDefaultDisabled(check, j);
                        //                        document.getElementById('checkSubProject'+j).checked = checked;
                        //                        isDefaultDisabledSubProjects(check, j, "");
                        //alert('checkProject.length : '+checkProject.length+ ' : ' +j);

                        //                        checkSubProject = document.getElementById('totalSubProjects'+j);
                        //                        //alert('checkSubProject.value totalSubProjects :' +checkSubProject.value+' : '+j);
                        //                        var subIndex = 0;
                        //
                        //                        alert('totalSubProjects'+j+ ' : '+checkSubProject.value);
                        //                        if(checkSubProject.value > 0) {
                        //                            for(var i = 0; i< checkSubProject.value; i++) {
                        //                                subIndex = j++;
                        //                                alert('checkSubProject'+subIndex);
                        //                                document.getElementById('checkSubProject'+subIndex).checked = checked;
                        //                                //isDefaultDisabledSubProjects(check, j, subIndex);
                        //                            }
                        //                        }
                    } catch(e){ }
                }
                
            }
        
            function checkedStores(i, j) {
                //alert('index  : '+index)
                //var i = "";
                var index = j;
                var disabled = document.getElementById('checkSubProject' + index).checked;
                //alert('disabled  : '+disabled)
                if(disabled) {
                    
                    isDefaultDisabled(false, index);
                    document.getElementById('checkProject'+i).checked=true;
                    isDefaultDisabled(false, i);
                }
                else {
                    
                    isDefaultDisabled(true, index);

                    //isUnCheckedAllSubProjects(i,j);
                }
            }

            function isDefaultDisabled(disabled, index) {
                document.getElementById('isDefault' + index).disabled = disabled;
                document.getElementById('isDefault' + index).checked = false;
            }

            function isDefaultDisabledSubProjects(disabled, i, j) {
                document.getElementById('isDefault' + i + j).disabled = disabled;
                document.getElementById('isDefault' + i + j).checked = false;
            }
        
            function isCheckedAllProjects() {
                var checkProjects = document.getElementsByName('checkProject');
                var count = 0;
            
                for(var i = 0; i < checkProjects.length; i++) {
                    if(checkProjects[i].checked) {
                        count++;
                    }
                }

                if(count == checkProjects.length && checkProjects.length > 0) {
                    document.getElementById('checkAll').checked = true;
                } else {
                    document.getElementById('checkAll').checked = false;
                }
            }
            function isUnCheckedAllSubProjects(j) {
                var checkSubProjects = document.getElementById('totalSubProjects'+j);
                //alert('checkSubProjects.value : ' +checkSubProjects.value);
                var count = 0;

                for(var i = 0; i < checkSubProjects.value; i++) {
                    if(document.getElementById('checkSubProject'+j+i).checked) {
                        count++;
                    }
                }
                if(count == checkSubProjects.value && checkSubProjects.value > 0) {
                    document.getElementById('checkProject'+j).checked = true;
                } else if (count == 0) {

                    document.getElementById('checkProject'+j).checked=false;

                    isDefaultDisabled(true, j);

                }
            }
            function checkAlla(index) {

                var checkSubProject = 0;
                var checked = false;
                var check = false;
                if (document.getElementById('checkProject'+index).checked == true) {

                    checked = true;
                    check  = false;
                } else {
                    checked = false;
                    check = true;
                }

                isDefaultDisabled(check, index);
                var subIndex = parseInt(index);
                /*try{
                    var checkSubProject = document.getElementById('totalSubProjects'+index);
                    if(checkSubProject.value > 0) {
                     
                    
                        for(var i = 0; i< checkSubProject.value; i++) {
                            subIndex++;
                            //alert('sssssssss----' + subIndex + '---sssssss: ' + checkSubProject.value);
                            //alert('ssssssssssssssss: ' + document.getElementById('checkSubProject'+subIndex).checked);
                            document.getElementById('checkSubProject'+subIndex).checked = checked;
                            isDefaultDisabled(check, subIndex);
                        }
                    }
                } catch(e){}*/
            }
        </SCRIPT>

        <style type="text/css">
            .mainHeaderNormal {
                background-color: #E6E6FA;
            }
            .selectedRow0 {
                background:#99ffcc;
            }
            .selectedRow {
                background: #00ffff;
            }
        </style>
    </HEAD>


    <BODY>
        <FORM NAME="USER_STORES_FORM" METHOD="POST" action="">
            <DIV align="left" STYLE="color:blue;padding-left: 2.5%">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="JavaScript: cancelForm();" class="button"><%=cancel%></button>
                &ensp;
                <button onclick="JavaScript: submitForm();" class="button"><%=save%></button>
            </DIV>
            <br>
            <center>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%><font color="#FFFFFF" size="4">&ensp;:&ensp;</font><%=userName%></font></TD>
                        </TR>
                    </TABLE>
                    <%if (!status.equals("")) {%>
                    <br>
                    <table class="blueBorder" dir="rtl" align="center" width="60%" cellpadding="0" cellspacing="0">
                        <tr>
                            <%if (status.equals("ok")) {%>
                            <td class="blueBorder" width="100%" bgcolor="#D0D0D0" style="padding-bottom: 2px;padding-top: 2px">
                        <font color="blue" style="font-weight: bold" size="3"><center><%=sStatus%></center></font>
                        </td>
                        <%} else if (status.equals("no")) {%>
                        <td class="blueBorder" width="100%" bgcolor="#D0D0D0" style="padding-bottom: 2px;padding-top: 2px">
                        <font color="red" style="font-weight: bold" size="3"><center><%=fStatus%></center></font>
                        </td>
                        <%}%>
                        </tr>
                    </table>
                    <%}%>
                    <br>
                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="60%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className='selectedRow0'" onmouseout="this.className='mainHeaderNormal'">

                            <TD CLASS="" width="80%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <input type="checkbox" style="float: <%=sPadding%>" id="checkAll" name="checkAll" onclick="checkedAll();" />
                                <%=name%>
                            </TD>
                            <%--<TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <input type="checkbox" id="checkAll" name="checkAll" onclick="checkedAll();" />
                            </TD>--%>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <%=strDefault%>
                            </TD>
                        </TR>
                        <%
                            int index = 0;
                            int counter = 0;
                            String projectCode, radioChecked;
                            boolean checkProject;
                            ProjectMgr projectMgr = ProjectMgr.getInstance();
                            for (WebBusinessObject project : projects) {
                                projectCode = (String) project.getAttribute("projectID");
                                checkProject = Tools.isFound(projectCode, projectsForUser);

                                if (projectCode != null && projectCode.equals(isDefault)) {
                                    radioChecked = "checked";
                                } else {
                                    radioChecked = "";
                                }
                                index = counter;
                        %>
                        <TR onmousemove="this.className='selectedRow0'" onmouseout="this.className='act_sub_heading'" class="act_sub_heading">

                            <TD style="cursor: pointer;text-align:<%=sPadding%>;padding-<%=sPadding%>:10;" >
                                <INPUT TYPE="CHECKBOX" ID="checkProject<%=index%>" NAME="checkProject" value ="<%=index%>" <% if (checkProject) {%> checked <% }%> onclick="checkAlla('<%=index%>');">
                                <%=project.getAttribute("projectName")%>
                                <input type="hidden" id="projectName" name="projectName" value="<%=project.getAttribute("projectName")%>" />
                            </TD>
                            <%--<TD style="text-align:center;border-top-width: 0px">
                                <INPUT TYPE="CHECKBOX" ID="checkProject<%=index%>" NAME="checkProject" value ="<%=index%>" <% if (checkProject) {%> checked <% }%> onclick="checkAlla('<%=index%>');">
                            </TD>--%>
                            <TD STYLE=" text-align: center;border-top-width: 0px">
                                <input type="radio" id="isDefault<%=index%>" name="isDefault" <% if (!checkProject) {%> disabled <% }%> <%=radioChecked%> value="<%=projectCode%>" />
                                <input type="hidden" id="projectCode" name="projectCode" value="<%=projectCode%>" />
                            </TD>
                        </TR>
                        <%                                   
                        counter++;

                                index++;
                            }
                        %>
                    </TABLE>
                    <br>
                    <input type="hidden" id="userId" name="userId" value="<%=userId%>" />


                    <script type="text/javascript">
                        // to check for all project select all or not
                        isCheckedAllProjects();
                    </script>
                </FIELDSET>
            </center>
        </FORM>
    </BODY>
</HTML>
