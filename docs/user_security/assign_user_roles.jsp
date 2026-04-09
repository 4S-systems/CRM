<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.maintenance.db_access.*, com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<HTML>
    <%
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

                Vector<WebBusinessObject> allRoles = (Vector<WebBusinessObject>) request.getAttribute("allTrades");
//                Vector<WebBusinessObject> projects_ = new Vector<WebBusinessObject>();
                Vector<String> tradesForUser = (Vector<String>) request.getAttribute("tradesForUser");
                String userId = (String) request.getAttribute("userId");
                String userName = (String) request.getAttribute("userName");
                String isDefault = (String) request.getAttribute("isDefaultTrade");
                String status = (String) request.getAttribute("Status");
                if (status == null) {
                    status = "";
                }

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode, title, fStatus, sStatus, cancel, save, name, code, strDefault,tradeQual,comments;
                String sPadding;
                if (stat.equals("En")) {
                    align = "left";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    title = "Add / Update Roles For User";
                    sStatus = "Site Saved Successfully";
                    fStatus = "Fail To Save This Site";
                    cancel = "Cancel";
                    name = "Name";
                    code = "Code";
                    save = "Save";
                    strDefault = "Default";
                    sPadding = "left";
                    tradeQual="Trade Qualification";
                    comments="Notes";
                } else {
                    align = "Right";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    langCode = "En";
                    title = "\u0623\u0636\u0627\u0641\u0629 / \u062A\u0639\u062F\u064A\u0644 \u0627\u0644\u0623\u062F\u0648\u0627\u0631 \u0644\u0644\u0645\u0633\u062A\u062E\u062F\u0645";
                    fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
                    sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
                    cancel = tGuide.getMessage("cancel");
                    name = "الدور";
                    code = "&#1575;&#1604;&#1603;&#1608;&#1583;";
                    save = "&#1581;&#1600;&#1601;&#1600;&#1592;";
                    strDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
                    sPadding = "right";
                    tradeQual="نوع الدور";
                    comments="ملاحظات";
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
                    document.USER_STORES_FORM.action = "<%=context%>/UsersServlet?op=saveUserRoles";
                    document.USER_STORES_FORM.submit();
                }
            }

            function validateForm() {
                var checkProject = document.getElementsByName('checkTrade');
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
                    alert("You must select at least one role ... ");
                    return false;
                } else {
                    alert("You must select default role ... ");
                    return false;
                }
            }
        
            function cancelForm() {
                document.USER_STORES_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
                document.USER_STORES_FORM.submit();
            }
        
            function checkedAll() {
                var checkProject = document.getElementsByName('checkTrade');
                var isDefault = document.getElementsByName('isDefault');
               
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
                }
                
            }
            function isDefaultDisabled(disabled, index) {
                document.getElementById('isDefault' + index).disabled = disabled;
                document.getElementById('isDefault' + index).checked = false;
            }
        
            function isCheckedAllProjects() {
                var checkProjects = document.getElementsByName('checkTrade');
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
           
            function checkAlla(index) {
                var check = false;
                if (document.getElementById('checkTrade'+index).checked == true) {
                    document.getElementById('tradeQualification'+index).disabled=false;
                    document.getElementById('notes'+index).disabled=false;
                    document.getElementById('tradeName'+index).disabled=false;
                    document.getElementById('tradeId'+index).disabled=false;
                    document.getElementById('isDefault'+index).checked=false
                    document.getElementById('isDefault'+index).disabled=false;
                    check  = false;
                } else {
                    document.getElementById('tradeQualification'+index).disabled=true;
                    document.getElementById('notes'+index).disabled=true;
                    document.getElementById('tradeName'+index).disabled=true;
                    document.getElementById('tradeId'+index).disabled=true;
                    document.getElementById('isDefault'+index).checked=false;
                    document.getElementById('isDefault'+index).disabled=true;
                    check = true;
                }

              //  isDefaultDisabled(check, index);
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

                            <TD CLASS="" width="50%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <input type="checkbox" style="float: <%=sPadding%>" id="checkAll" name="checkAll" onclick="checkedAll();" />
                                <%=name%>
                            </TD>
                            <TD  CLASS="" width="10%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                 <%=tradeQual%>
                            </TD>
                            <TD  CLASS="" width="10%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                 <%=comments%>
                            </TD>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <%=strDefault%>
                            </TD>
                        </TR>
                        <%
                                    int index = 0;
                                    int counter = 0;
                                    String tradeId, radioChecked,tradeQualification,notes;
                                    boolean checkTrade;
//                                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                                    for (WebBusinessObject role : allRoles) {
                                        tradeId = (String) role.getAttribute("tradeId");
                                        tradeQualification=(String) role.getAttribute("tradeQualification");
                                        if(tradeQualification==null){
                                            tradeQualification="";
                                        }
                                        notes=(String) role.getAttribute("notes");
                                        if(notes==null){
                                            notes="";
                                        }
                                        checkTrade = Tools.isFound(tradeId, tradesForUser);

                                        if (tradeId != null && tradeId.equals(isDefault)) {
                                            radioChecked = "checked";
                                        } else {
                                            radioChecked = "";
                                        }
                                        index = counter;
//                                        if(projectCode.equals("1365240752318")){
                        %>
                        <TR onmousemove="this.className='selectedRow0'" onmouseout="this.className='act_sub_heading'" class="act_sub_heading">

                            <TD style="cursor: pointer;text-align:<%=sPadding%>;padding-<%=sPadding%>:10;" >
                                <INPUT TYPE="CHECKBOX" ID="checkTrade<%=index%>" NAME="checkTrade" value ="<%=tradeId%>" <% if (checkTrade) {%> checked <% }%> onclick="checkAlla('<%=index%>');">
                                <%=role.getAttribute("tradeName")%>
                                <input type="hidden" id="tradeName<%=index%>" name="tradeName" value="<%=role.getAttribute("tradeName")%>" />
                            </TD>
                            <TD style="text-align:center;border-top-width: 0px">
                                <SELECT id="tradeQualification<%=index%>" name="tradeQualification" >
                                    <OPTION value="PRIM" >دور أساسي</OPTION>
                                    <OPTION value="SEC" >دور ثانوي</OPTION>
                                    <OPTION value="TEMP">بصفه مؤقته</OPTION>
                                </SELECT>
                                <!--<input type="text" id="tradeQualification" name="tradeQualification" value="<%=tradeQualification%>" />-->
                            </TD>
                            <TD style="text-align:center;border-top-width: 0px">
                                <input type="text" id="notes<%=index%>" name="notes" value="<%=notes%>" />
                            </TD>
                            <TD STYLE=" text-align: center;border-top-width: 0px">
                                
                                <input type="radio" id="isDefault<%=index%>" name="isDefault" <% if (!checkTrade) {%> disabled <% }%>  <%=radioChecked%> value="<%=tradeId%>" />
                                <input type="hidden" id="tradeId<%=index%>" name="tradeId" value="<%=tradeId%>" />
                            </TD>
                        </TR>
                        <%
//                                                                projects_ = projectMgr.getOnArbitraryKey(projectCode, "key2");
//                                                                int index_ = 0;
//                                                                int countTotal = 0;
//                                                                String projectCode_, radioChecked_, projectName_;
//                                                                boolean checkProject_;
//                                                                for (WebBusinessObject project_ : projects_) {
//                                                                    projectCode_ = (String) project_.getAttribute("projectID");
//                                                                    projectName_ = project_.getAttribute("projectName").toString();
//                                                                    checkProject_ = Tools.isFound(projectCode_, projectsForUser);
//
//                                                                    if (projectCode_ != null && projectCode_.equals(isDefault)) {
//                                                                        radioChecked_ = "checked";
//                                                                    } else {
//                                                                        radioChecked_ = "";
//                                                                    }
//                                                                    index_ = index+1;
//                                                                    counter++;
//                                                                    index_=counter;
//                                                                    countTotal++;
                        %>
<!--                        <TR onmousemove="this.className='selectedRow'" onmouseout="this.className=''">

                            <TD style="cursor: pointer;text-align:<%=sPadding%>;padding-<%=sPadding%>:30px;" >
                                <INPUT TYPE="CHECKBOX" ID="checkSubProject<%//=index_%>" NAME="checkProject" value ="<%//=index_%>" <%// if (checkProject_) {%> checked <% //}%> onclick="checkedStores('<%//=index%>', '<%//=index_%>');" />
                                <%=role.getAttribute("tradeName")%>
                                <input type="hidden" id="projectName" name="projectName" value="<%//=tradeName%>" />
                            </TD>
                            <%--<TD style="text-align:center;border-top-width: 0px">
                                <INPUT TYPE="CHECKBOX" ID="checkSubProject<%=index%><%=index_%>" NAME="checkSubProject<%=index%>" value ="<%=index_%>" <% if (checkProject_) {%> checked <% }%> onclick="checkedStores('<%=index%>','<%=index_%>');" />
                            </TD>--%>
                            <TD STYLE="text-align:center;border-top-width: 0px;">
                                <input type="radio" id="isDefault<%//=index_%>" name="isDefault" <% //if (!checkProject_) {%> disabled <% //}%> <%//=radioChecked_%> value="<%//=projectCode_%>" />
                                <input type="hidden" id="projectCode" name="projectCode" value="<%=tradeId%>" />
                            </TD>
                        </TR>-->
                        <%
                                                               // }
                                                               counter++;
                        %>
                        <!--<input type="hidden" name="totalSubProjects<%=index%>" id="totalSubProjects<%=index%>" value="<%//=countTotal%>">-->
                        <%
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
