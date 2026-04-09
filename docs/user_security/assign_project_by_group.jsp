<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.maintenance.db_access.*, com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    Vector<WebBusinessObject> mainProjectV = (Vector<WebBusinessObject>) request.getAttribute("mainProjectV");
    ArrayList<String> projectByGroupList = (ArrayList<String>) request.getAttribute("projectByGroupList");
    
//    Vector<String> storesForUser = (Vector<String>) request.getAttribute("storesName");
    String groupId = (String) request.getAttribute("groupId");
    String groupName = (String) request.getAttribute("groupName");
    String status = (String) request.getAttribute("Status");
    if(status == null) status = "";

//    boolean notFoundBranches = branches != null && branches.isEmpty();

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, title, fStatus, sStatus, cancel, save, name, code;
    String noStores, noBranches,prevType;
    if(stat.equals("En")){
        align="left";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        title = "Add / Update prevliges for saving folders";
        sStatus="Site Saved Successfully";
        fStatus="Fail To Save This Site";
        cancel="Cancel";
        name = "Name of folders";
        code = "Code";
        save = "Save";
        noBranches = "No Branches For This User";
        noStores = "No Stores Under This Branch";
        prevType = "Previliges Type";
    } else {
        align="Right";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        title = "إضافة / تعديل صلاحية  تسجيل الملفات";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        cancel = tGuide.getMessage("cancel");
        name = "اسم الملفات";
        code = "&#1575;&#1604;&#1603;&#1608;&#1583;";
        save = "&#1581;&#1600;&#1601;&#1600;&#1592;";
        noBranches = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1601;&#1585;&#1608;&#1593; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        noStores = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1582;&#1575;&#1586;&#1606; &#1578;&#1581;&#1578; &#1607;&#1584;&#1575; &#1575;&#1604;&#1601;&#1585;&#1593;";
        prevType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1604;&#1575;&#1581;&#1610;&#1577;";
    }

    String storeName = "name" + stat;
    String prevTypeId = (String) request.getAttribute("prevType");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Assigned Stores</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/blueStyle.css"/>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm() {
            var checkPrev = document.getElementsByName('checkPrev');
            var countCheck = 0;
            for (var i = 0; i < checkPrev.length; i++) {
                if(checkPrev[i].checked == true) {
                    countCheck++;
                    checkPrev[i].value = i;
               }
            }
//            if(countCheck == 0) {
//                alert("Select at least one privlige");
//            } else {
                document.USER_STORES_FORM.action = "<%=context%>/GroupServlet?op=saveProjectByGroup";
                document.USER_STORES_FORM.submit();
//            }
        }
        
        function cancelForm() {
            document.USER_STORES_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
            document.USER_STORES_FORM.submit();
        }
        
        function checkedAll() {
//            var checkBranch = document.getElementsByName('checkBranch');
            var checkPrev = document.getElementsByName('checkPrev');
            if(document.getElementById('checkAll').checked) {
//                for(var i = 0; i < checkBranch.length; i++) {
//                    checkBranch[i].checked = true;
//                }
                for(var j = 0; j< checkPrev.length; j++) {
                    checkPrev[j].checked = true;
                }
            } else {
//                for(var i = 0; i < checkBranch.length; i++) {
//                    checkBranch[i].checked = false;
//                }
                for(var j = 0; j< checkPrev.length; j++) {
                    checkPrev[j].checked = false;
                }
            }
        }
                
//        function checkedStores() {
//            isCheckedAllBranch();
//        }
//        
//        function isCheckedAllBranch() {
//            var checkBranchs = document.getElementsByName('checkBranch');
//            var index, idStr, count = 0;
//            
//            for(var i = 0; i < checkBranchs.length; i++) {
//                idStr = checkBranchs[i].id;
//                index = idStr.replace("checkBranch", "");
//                if(isCheckedBranch(index)) {
//                    count++;
//                }
//            }
//
//            if(count == checkBranchs.length && checkBranchs.length > 0) {
//                document.getElementById('checkAll').checked = true;
//            } else {
//                document.getElementById('checkAll').checked = false;
//            }
//        }

   function checkProj(){
       var checkPrev = document.getElementsByName('checkPrev');
       var countCheck = 0;
            for (var i = 0; i < checkPrev.length; i++) {
                if(checkPrev[i].checked == true) {
                    countCheck++;
                    checkPrev[i].value = i;
               }
            }
             if(countCheck == checkPrev.length) {
                document.getElementById('checkAll').checked = true;
            }else{
                document.getElementById('checkAll').checked = false;
            }
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
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%><font color="#FFFFFF" size="4">&ensp;:&ensp;</font><%=groupName%></font></TD>
                        </TR>
                    </TABLE>
                    <%if(!status.equals("")){%>
                    <br>
                    <table class="blueBorder" dir="rtl" align="center" width="60%" cellpadding="0" cellspacing="0">
                        <tr>
                            <%if(status.equals("ok")){%>
                            <td class="blueBorder" width="100%" bgcolor="#D0D0D0" style="padding-bottom: 2px;padding-top: 2px">
                                <font color="blue" style="font-weight: bold" size="3"><center><%=sStatus%></center></font>
                            </td>
                            <%} else if(status.equals("no")){%>
                            <td class="blueBorder" width="100%" bgcolor="#D0D0D0" style="padding-bottom: 2px;padding-top: 2px">
                                <font color="red" style="font-weight: bold" size="3"><center><%=fStatus%></center></font>
                            </td>
                            <%}%>
                        </tr>
                    </table>
                    <%}%>
                    <br>
                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="60%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className='selectedRow'" onmouseout="this.className='mainHeaderNormal'">
                            <TD CLASS="" width="60%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:<%=align%>;padding-<%=align%>:5px;border-top-width: 0px">
                                <%=name%>
                            </TD>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <input type="checkbox" id="checkAll" name="checkAll" onclick="checkedAll();" />
                                    &ensp;
                            </TD>
                        </TR>
                        
                            <%int index = 0;
                            for(WebBusinessObject mainProjWbo : mainProjectV) {
                            %>
                            <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className=''">
                                <TD STYLE="text-align:<%=align%>;padding-<%=align%>:45px;border-top-width: 0px">
                                    <%=mainProjWbo.getAttribute("projectName")%>
                                </TD>
                                <TD style="text-align:center;border-top-width: 0px">
                                    <INPUT TYPE="CHECKBOX" ID="checkPrev" NAME="checkPrev" value ="<%=index%>" onclick="checkProj();" <%=(projectByGroupList.contains(mainProjWbo.getAttribute("projectID")))? "checked" : ""%>>
                                    <INPUT type="hidden" id="<%=mainProjWbo.getAttribute("projectID").toString()%>" name="projectId" value="<%=mainProjWbo.getAttribute("projectID").toString()%>"/>
                                </TD>
                            </TR>
                            <%
                                index++;
                            }
                            %>

                     </TABLE>
                    <br>
                     <input type="hidden" id="groupId" name="groupId" value="<%=groupId%>" />
                </FIELDSET>
            </center>
        </FORM>
    </BODY>
</HTML>
