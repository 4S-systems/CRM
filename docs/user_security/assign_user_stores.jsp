<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.maintenance.db_access.*, com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    Vector<WebBusinessObject> prevliges = (Vector<WebBusinessObject>) request.getAttribute("prevliges");
    ArrayList<String> userPrivilegeList = (ArrayList<String>) request.getAttribute("userPrivilegeList");
    Vector prevTypeV = (Vector) request.getAttribute("prevTypeV");
    
//    Vector<String> storesForUser = (Vector<String>) request.getAttribute("storesName");
    String userId = (String) request.getAttribute("userId");
    String userName = (String) request.getAttribute("userName");
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
        title = "Add / Update Prevliges For User";
        sStatus="Site Saved Successfully";
        fStatus="Fail To Save This Site";
        cancel="Cancel";
        name = "Name Branch / Store";
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
        title = "أضافة / تعديل الصلاحيات للمستخدم ";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        cancel = tGuide.getMessage("cancel");
        name = "اسم الصلاحيه";
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
                document.USER_STORES_FORM.action = "<%=context%>/UsersServlet?op=saveUserStores";
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

      function getAssignPrev (type){
          
            window.navigate('<%=context%>/UsersServlet?op=assignStores&prev_type=' + type + '&userId=' + <%=userId%>);
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
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%><font color="#FFFFFF" size="4">&ensp;:&ensp;</font><%=userName%></font></TD>
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
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=prevType%></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable" >
                                <SELECT class="blackFont fontInput" style="width: 230px; font-size: 16px;" name="prev_type" onchange="JavaScript: getAssignPrev(this.value)">
                                    <% for (int x=0;x<prevTypeV.size();x++){
                                        WebBusinessObject opWbo = new WebBusinessObject();
                                        opWbo = (WebBusinessObject) prevTypeV.get(x);
                                        %>
                                        <option value="<%=opWbo.getAttribute("id")%>" <%=(prevTypeId.contains(opWbo.getAttribute("id").toString()))? "selected" : ""%>><%=opWbo.getAttribute("nameAr")%></option>
                                        <% }%>
                                </SELECT>
                            </TD>
                        </TR>
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className='selectedRow'" onmouseout="this.className='mainHeaderNormal'">
                            <TD CLASS="" width="60%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:<%=align%>;padding-<%=align%>:5px;border-top-width: 0px">
                                <%=name%>
                            </TD>
                            <TD  CLASS="" width="30%" style="text-align:center;font-size: 14px;font-weight: bold;color: black;border-top-width: 0px">
                                <%=code%>
                            </TD>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <%// if(!notFoundBranches) { %>
                                    <input type="checkbox" id="checkAll" name="checkAll" onclick="checkedAll();" />
                                <%// } else { %>
                                    &ensp;
                                <%// } %>
                            </TD>
                        </TR>
                        <%
//                        int indexBranch = 0;
                        
//                        Vector<WebBusinessObject> stores;
//                        String storeCode;
//                        boolean checkStore, notFoundStores;
//                        for(WebBusinessObject prev : prevliges) {
//                            stores = (Vector<WebBusinessObject>) prev.getAttribute("stores");
//                            notFoundStores = stores != null && stores.isEmpty();
                        %>
<!--                        <TR style="cursor: pointer" CLASS="act_sub_heading" onmousemove="this.className='selectedRow'" onmouseout="this.className='act_sub_heading'">
                            <TD  STYLE="text-align:<%=align%>;padding-<%=align%>:15px;color: blue;border-top-width: 0px">
                                <%//=branch.getAttribute("projectName")%>
                            </TD>
                            <TD STYLE="text-align:center;color: blue;border-top-width: 0px">
                                <%//=branch.getAttribute("projectID")%>
                            </TD>
                            <TD style="text-align:center;border-top-width: 0px">
                                <% //if(!notFoundStores) { %>
                                    <INPUT TYPE="CHECKBOX" ID="checkBranch<//%=indexBranch%>" NAME="checkBranch" value ="" onclick="isCheckedAllBranchFromCheckBox('<//%=indexBranch%>');">
                                <% //} else { %>
                                    &ensp;
                                <%// } %>
                            </TD>
                        </TR>-->
                            <%int index = 0;
                            for(WebBusinessObject prev : prevliges) {
                                
//                                String prevCode = (String) prev.getAttribute("prevCode");
//                                checkStore = Tools.isFound(prevCode, storesForUser);
                            %>
                            <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className=''">
                                <TD STYLE="text-align:<%=align%>;padding-<%=align%>:45px;border-top-width: 0px">
                                    <%=prev.getAttribute("prevNameAr")%>
                                    <input type="hidden" id="prevNameAr" name="prevNameAr" value="<%=prev.getAttribute("prevNameAr")%>" />
                                    <input type="hidden" id="prevNameEn" name="prevNameEn" value="<%=prev.getAttribute("prevNameEn")%>" />
                                </TD>
                                <TD STYLE="text-align:center;border-top-width: 0px">
                                    <%=prev.getAttribute("prevCode")%>
                                    <input type="hidden" id="prevCode" name="prevCode" value="<%=prev.getAttribute("prevCode")%>" />
                                </TD>
                                <TD style="text-align:center;border-top-width: 0px">
                                    <INPUT TYPE="CHECKBOX" ID="checkPrev" NAME="checkPrev" value ="<%=index%>" onclick="checkPrev();" <%=(userPrivilegeList.contains(prev.getAttribute("prevCode")))? "checked" : ""%>>
                                </TD>
                            </TR>
                            <%
                                index++;
                            }
                            %>

                            <% //if(notFoundStores) {%>
<!--                            <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className=''">
                                <TD STYLE="text-align:center;border-top-width: 0px;color: red" colspan="3">
                                    <//%=noStores%>
                                </TD>
                            </TR>-->
                            <%// } %>

                        <%
//                            indexBranch++;
//                        }
                        %>
                        <%// if(notFoundBranches) {%>
<!--                        <TR style="cursor: pointer" class="act_sub_heading" onmousemove="this.className='selectedRow'" onmouseout="this.className='act_sub_heading'">
                            <TD STYLE="text-align:center;border-top-width: 0px;color: red" colspan="3">
                                <//%=noBranches%>
                            </TD>
                        </TR>-->
                        <%// } %>
                    </TABLE>
                    <br>
                     <input type="hidden" id="userId" name="userId" value="<%=userId%>" />

                     
<!--                     <script type="text/javascript">
                         // to check for all store select all or not
                         //isCheckedAllBranch();
                     </script>-->
                </FIELDSET>
            </center>
        </FORM>
    </BODY>
</HTML>
