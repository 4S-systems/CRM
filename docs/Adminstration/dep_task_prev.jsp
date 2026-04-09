<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.maintenance.db_access.*, com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String status = (String) request.getAttribute("Status");
        if (status == null) {
            status = "";
        }

        ArrayList<WebBusinessObject> tickets = (ArrayList) request.getAttribute("tickets");
        ArrayList<WebBusinessObject> departments = (ArrayList) request.getAttribute("departments");
        ArrayList selectedTypes = (ArrayList) request.getAttribute("selectedTypes");
        String departmentID = (String)request.getAttribute("departmentID");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, fStatus, sStatus, cancel, save, departmentName, lastVersion, docType;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Task Security";
            sStatus = "Site Saved Successfully";
            fStatus = "Fail To Save This Site";
            cancel = "Cancel";
            departmentName = "Department Name";
            lastVersion = "Last Version";
            save = "Save";
            docType = "Task Type";
        } else {
            align = "Right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "صلاحيات المهمات";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            cancel = tGuide.getMessage("cancel");
            departmentName = "اسم الأدراة";
            lastVersion = "أخر أصدار فقط";
            save = "&#1581;&#1600;&#1601;&#1600;&#1592;";
            docType = "نوع المهمة";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Assigned Stores</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/blueStyle.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm() {
//            var departmentID = document.getElementsByName('departmentID');
//            var countCheck = 0;
//            for (var i = 0; i < departmentID.length; i++) {
//                if (departmentID[i].checked == true) {
//                    countCheck++;
//                    //departmentID[i].value = i;
//                }
//            }
//            if (countCheck == 0) {
//                alert("Select at least one department");
//            } else {
                document.USER_STORES_FORM.action = "<%=context%>/ProjectServlet?op=saveDepartmentTasks";
                document.USER_STORES_FORM.submit();
//            }
        }

        function checkedAll() {
            var taskTypeID = document.getElementsByName('taskTypeID');
            if (document.getElementById('checkAll').checked) {
                for (var j = 0; j < taskTypeID.length; j++) {
                    taskTypeID[j].checked = true;
                }
            } else {
                for (var j = 0; j < taskTypeID.length; j++) {
                    taskTypeID[j].checked = false;
                }
            }
        }

        function getDepartmentTaskTypes(departmentID) {
            window.location.replace('<%=context%>/ProjectServlet?op=DepartmentTasks&departmentID=' + departmentID);
        }
    </SCRIPT>

    <style type="text/css">
        .mainHeaderNormal {
            background-color: #E6E6FA;
        }

        .selectedRow {
            background: #F2F1ED;
        }
    </style>

    <BODY>
        <FORM NAME="USER_STORES_FORM" METHOD="POST" action="">
            <DIV  STYLE="color:blue;padding-left: 2.5%;text-align: center;margin-right: auto;margin-left: auto;width: 60%;">
                <button onclick="JavaScript: cancelForm();" class="button"><%=cancel%></button>
                &ensp;
                <button onclick="JavaScript: submitForm();" class="button"><%=save%></button>
            </DIV>
            <br>
            <center>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>
                    <%if (!status.equals("")) {%>
                    <br>
                    <table class="blueBorder" dir="rtl" align="center" width="40%" cellpadding="0" cellspacing="0">
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
                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="40%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = 'mainHeaderNormal'">
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=departmentName%></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable" > 
                                <SELECT class="blackFont fontInput" style="width: 230px; font-size: 16px;" name="departmentID" id="prev_type" onchange="getDepartmentTaskTypes(this.value)" onselect="getDepartmentTaskTypes(this.value)">
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute = "projectName" valueAttribute="projectID" scrollToValue='<%=departmentID%>' />
                                </SELECT>
                            </TD>
                        </TR>
                    </TABLE>
                    <TABLE id="complaintPrev" CLASS="blueBorder" WIDTH="40%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>"style="cursor: pointer">
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = 'mainHeaderNormal'">
                            <TD CLASS="" width="60%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:<%=align%>;padding-<%=align%>:5px;border-top-width: 0px">
                                <%=docType%>
                            </TD>
                            <%--
                            <TD  CLASS="" width="30%" style="text-align:center;font-size: 14px;font-weight: bold;color: black;border-top-width: 0px">
                                <%=lastVersion%>
                            </TD>
                            --%>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <input type="checkbox" id="checkAll" name="checkAll" onclick="checkedAll();" />
                            </TD>
                        </TR>
                        <%
                            for (WebBusinessObject taskType : tickets) {
                        %>
                        <TR  onmousemove="this.className = 'selectedRow'" onmouseout="this.className = ''">
                            <TD STYLE="text-align:<%=align%>;padding-<%=align%>:45px;border-top-width: 0px">
                                <%=taskType.getAttribute("type_name")%>
                            </TD>
                           
                             <%--
                            <TD STYLE="text-align:center;border-top-width: 0px">
                              
                                <INPUT TYPE="CHECKBOX" ID="lastVersion" NAME="lastVersion" value ="<%=taskType.getAttribute("projectID")%>" 
                                       <%=(selectedLastVersion.contains(taskType.getAttribute("projectID"))) ? "checked" : ""%>>
                            </TD>
                            --%>
                            <TD style="text-align:center;border-top-width: 0px">
                               
                                <INPUT TYPE="CHECKBOX" ID="taskTypeID" NAME="taskTypeID" value ="<%=taskType.getAttribute("type_id")%>" 
                                       onclick="taskTypeID();" <%=(selectedTypes.contains(taskType.getAttribute("type_id"))) ? "checked" : ""%> >
                               
                            </TD>
                        </TR>
                        <%
                            }
                        %>
                    </TABLE>
                    <br />
                </FIELDSET>
            </center>
        </FORM>
    </BODY>
</HTML>