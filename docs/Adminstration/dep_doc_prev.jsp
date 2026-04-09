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

        ArrayList docTypes = (ArrayList) request.getAttribute("docTypes");
        Vector<WebBusinessObject> departments = (Vector) request.getAttribute("departments");
        ArrayList selectedDeps = (ArrayList) request.getAttribute("selectedDeps");
        ArrayList selectedLastVersion = (ArrayList) request.getAttribute("selectedLastVersion");
        WebBusinessObject selectedDocType = (WebBusinessObject) request.getAttribute("selectedDocType");
        String docTypeName = "";
        if (selectedDocType != null && selectedDocType.getAttribute("typeName") != null) {
            docTypeName = (String) selectedDocType.getAttribute("typeName");
        }

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
            title = "Document Security";
            sStatus = "Site Saved Successfully";
            fStatus = "Fail To Save This Site";
            cancel = "Cancel";
            departmentName = "Department Name";
            lastVersion = "Last Version";
            save = "Save";
            docType = "Document Type";
        } else {
            align = "Right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "صلاحيات المستندات";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            cancel = tGuide.getMessage("cancel");
            departmentName = "اسم الأدراة";
            lastVersion = "أخر أصدار فقط";
            save = "&#1581;&#1600;&#1601;&#1600;&#1592;";
            docType = "نوع المستند";
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
                document.USER_STORES_FORM.action = "<%=context%>/ProjectServlet?op=SaveDocTypeDeps";
                document.USER_STORES_FORM.submit();
//            }
        }

        function checkedAll() {
            var departmentID = document.getElementsByName('departmentID');
            if (document.getElementById('checkAll').checked) {
                for (var j = 0; j < departmentID.length; j++) {
                    departmentID[j].checked = true;
                }
            } else {
                for (var j = 0; j < departmentID.length; j++) {
                    departmentID[j].checked = false;
                }
            }
        }

        function getDocTypeDepartments(docTypeID) {
            window.location.replace('<%=context%>/ProjectServlet?op=DepartmentDocuments&docTypeID=' + docTypeID);
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
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = 'mainHeaderNormal'">
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=docType%></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable" >
                                <SELECT class="blackFont fontInput" style="width: 230px; font-size: 16px;" name="docTypeID" id="prev_type" onchange="getDocTypeDepartments(this.value)" onselect="getDocTypeDepartments(this.value)">
                                    <sw:WBOOptionList wboList="<%=docTypes%>" displayAttribute = "typeName" valueAttribute="typeID" scrollTo='<%=docTypeName%>' />
                                </SELECT>
                            </TD>
                        </TR>
                    </TABLE>
                    <TABLE id="complaintPrev" CLASS="blueBorder" WIDTH="60%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>"style="cursor: pointer">
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = 'mainHeaderNormal'">
                            <TD CLASS="" width="60%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:<%=align%>;padding-<%=align%>:5px;border-top-width: 0px">
                                <%=departmentName%>
                            </TD>
                            <TD  CLASS="" width="30%" style="text-align:center;font-size: 14px;font-weight: bold;color: black;border-top-width: 0px">
                                <%=lastVersion%>
                            </TD>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <input type="checkbox" id="checkAll" name="checkAll" onclick="checkedAll();" />
                            </TD>
                        </TR>
                        <%
                            for (WebBusinessObject department : departments) {
                        %>
                        <TR  onmousemove="this.className = 'selectedRow'" onmouseout="this.className = ''">
                            <TD STYLE="text-align:<%=align%>;padding-<%=align%>:45px;border-top-width: 0px">
                                <%=department.getAttribute("projectName")%>
                            </TD>
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <INPUT TYPE="CHECKBOX" ID="lastVersion" NAME="lastVersion" value ="<%=department.getAttribute("projectID")%>" 
                                       <%=(selectedLastVersion.contains(department.getAttribute("projectID"))) ? "checked" : ""%>>
                            </TD>
                            <TD style="text-align:center;border-top-width: 0px">
                                <INPUT TYPE="CHECKBOX" ID="departmentID" NAME="departmentID" value ="<%=department.getAttribute("projectID")%>" 
                                       onclick="departmentID();" <%=(selectedDeps.contains(department.getAttribute("projectID"))) ? "checked" : ""%>>
                            </TD>
                        </TR>
                        <%
                            }
                        %>
                    </TABLE>
                </FIELDSET>
            </center>
        </FORM>
    </BODY>
</HTML>