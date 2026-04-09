<%@page import="com.tracker.db_access.ProjectMgr"%>
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
        ProjectMgr projectMgr= ProjectMgr.getInstance();
        ArrayList locationTypesList = (ArrayList) request.getAttribute("locationTypesList");
        String selectedProj = "";

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status, Dupname;
        String project_code_label = null;
        String project_name_label = null;
        String project_desc_label = null;
        String futile_label = null;
        String location_type_label = null;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label;
        String fStatus;
        String sStatus,str1,str2,str3,str4,str5,str6,str7,str8,unitNo,model;
        String futileMsg = "";
        String isTrnsprtStn;
        String isMngmntStn;
        String typeName = null;


        String selectAll, main_project_name_label, searchTitle, byName, byCode;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            project_code_label = "Building No.";
            project_name_label = "Entrance No.";
            project_desc_label = "Location decription";
            futile_label = "Adding sub location ";
            location_type_label = "Loaction Type";
            title_1 = "Add a new sub-site To ( ";
            title_2 = "All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            langCode = "Ar";
            Dupname = "Name or code is Duplicated Change it";
            sStatus = "Site Saved Successfully";
            fStatus = "Fail To Save This Site";

            selectAll = "All";
            main_project_name_label = "Main Project";

            searchTitle = "Project From ERP";
            byName = "Name";
            byCode = "Code";

            typeName = "projectName";
            futileMsg = "Can't add a sub locations ";
            isTrnsprtStn = "Is Transport Station";
            isMngmntStn = "Is Managment Station";
            str1="Floor";
            str2="Apartment No.";
            str3="Desc.";
            str4 ="Available Units";
            str5="All Units";
            str6="Garden Space";
            str7="Garden Price";
            str8="Total Unit Space";
            unitNo="Unit No.";
            model="Model";
        } else {

            /*if(status.equalsIgnoreCase("ok"))
             status="";*/
            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            project_code_label = "رقم العماره ";
            project_name_label = "رقم المدخل";
            project_desc_label = "الوصف ";
            futile_label = "إضافة مواقع فرعية ";
            location_type_label = "نوع الموقع ";
            title_1 = "إضافة موقع فرعي جديد ل ( ";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            langCode = "En";
            Dupname = "الإسم أو الكود مكرر الرجاء تغييره";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";

            selectAll = "الكل";
            main_project_name_label = "الموقع الرئيسي";

            searchTitle = "من المخازن";

            byName = "بالإسم";
            byCode = "بالكود";

            typeName = "projectName";
            futileMsg = "لا يمكن إضافة مواقع فرعية";
            isTrnsprtStn = "محطة نقل";
            isMngmntStn = "موقع إدارى";
            str1="الدور";
            str2="رقم الشقه";
            str3="الوصف";
            str4 ="عدد الوحدات المتاحه";
            str5="العدد الكلي للوحدات";
            str6="الموقع الرئيسي";
            str7="قيمة الحديقه";
            str8="المساحه الكليه للوحده";
            unitNo="رقم الوحده";
            model="النموذج";
        }

        String doubleName = (String) request.getAttribute("name");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />

        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/validator.js' type='text/javascript'></script>
        <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm()
            {   
                var mainProject=document.getElementById("mainProjectId").value;
                //alert('main= '+mainProject);
//                if (!validateData("req", this.PROJECT_FORM.project_name, "Please, enter Site Name.") || !validateData("minlength=3", this.PROJECT_FORM.project_name, "Please, enter a valid Site Name.")){
//                    this.PROJECT_FORM.project_name.focus();
//                } else if (!validateData("req", this.PROJECT_FORM.eqNO, "Please, enter Site Number.") || !validateData("alphanumeric", this.PROJECT_FORM.eqNO, "Please, enter a valid Number for Site Number.")){
//                    this.PROJECT_FORM.eqNO.focus();
//                } else if (!validateData("req", this.PROJECT_FORM.project_desc, "Please, enter Site Description.")){
//                    this.PROJECT_FORM.project_desc.focus();
//                } else{
                document.HOUSING_UNIT_FORM.action = "<%=context%>/ProjectServlet?op=saveModel";
                document.HOUSING_UNIT_FORM.submit();
               // }
            }

            function sendData(id){
            //alert('id= '+id);
//                 $.ajax({
//                url: "<%=context%>/ProjectServlet",
//                dataType: 'json',
//                data: "op=ajaxGetCode&code="+id,
//                success:  function(data){
//                    //alert('data[eqNO]==='+data['eqNo']);
//                    $('#eqNO').val(data['eqNo']);
//                }
//            }); 
            }
            
            function cancelForm()
            {
                window.close();
            }

        </SCRIPT>
        <script src='js/ChangeLang.js' type='text/javascript'></script>

    </HEAD>

    <BODY>
        <FORM NAME="HOUSING_UNIT_FORM" id="HOUSING_UNIT_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>

                <%// if (futile.equals("1")) {%>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                    <%//}%>
            </DIV>


            <br />

            <CENTER>
                <fieldset class="set" style="border-color: #006699; width: 90%">
<!--                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=title_1%> <%//=request.getAttribute("mainProjName").toString()%> )</FONT><BR></TD>
                        </TR>
                    </TABLE> -->
                    <br />
                    <% //if (futile.equals("1")) {%>
                    <%//if (null != doubleName) {%>

<!--                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font size=4 > <%=Dupname%> </font>
                            </td>
                        </tr>
                    </table>-->
                    <%//}%>

                    <table align="<%=align%>" dir="<%=dir%>">
                        <%
                            if (null != status) {
                                if (status.equalsIgnoreCase("Ok")) {
                        %>
                        <tr>
                            <td>
                                <table align="<%=align%>" dir=<%=dir%>>
                                    <tr>
                                        <td class="td">
                                            <font size=4 color="black"><%=sStatus%></font>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%} else {%>
                        <tr>
                            <td>
                                <table align="<%=align%>" dir=<%=dir%>>
                                    <tr>
                                        <td class="td">
                                            <font size=4 color="red" ><%=fStatus%></font>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%}
                            }%>
                    </table>
<!--                    <table align="<%=align%>" dir="<%=dir%>">
                        <TR COLSPAN="2" ALIGN="<%=align%>">
                            <TD STYLE="<%=style%>" class='td'>
                                <FONT color='red' size='+1'><%=title_2%></FONT>
                            </TD>
                        </TR>
                    </table>-->
                    <br />
                    <table align="<%=align%>" dir="<%=dir%>">
                        
                         <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=str6%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="1" class="blueBorder backgroundTable" >
                                <SELECT class="blackFont fontInput" style="width: 150px; font-size: 16px;" name="mainProjectId" id="mainProjectId" onchange="sendData(this.value)">
                                    <sw:OptionsList listAsArrayList="<%=locationTypesList%>" scrollTo="<%=typeName%>" displayAttribute = "<%=typeName%>" valueAttribute="projectID"/>
                                </SELECT>
                            </TD>
                        </TR>
                       
                         <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_Project_Name">
                                    <p><b> <%=location_type_label%> <font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable">
                                <input type="TEXT" dir="<%=dir%>" name="location_type" ID="location_type" size="30" value="<%=request.getAttribute("location_type").toString()%>" maxlength="30">
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=model%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable" >
                                <input type="TEXT" name="eqNO" dir="<%=dir%>" ID="eqNO"  value=""  size="32" maxlength="255">
                            </TD>
                        </TR>
                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_Project_Name">
                                    <p><b> <%=str3%> <font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable">
                                <input type="TEXT" dir="<%=dir%>" name="project_desc" ID="project_desc" size="32" value="" maxlength="255">
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_Project_Name">
                                    <p><b> <%=str4%> <font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable">
                                <input type="TEXT" dir="<%=dir%>" name="option_one" ID="option_one" size="3" value="" maxlength="3">
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_Project_Name">
                                    <p><b> <%=str5%> <font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable">
                                <input type="TEXT" dir="<%=dir%>" name="option_two" ID="option_two" size="3" value="" maxlength="3">
                            </TD>
                        </TR>
                        
                       
<!--                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=futile_label%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable" >
                                <input type="radio" checked="checked" name="futile" dir="<%=dir%>" ID="futile" size="32" value="1" maxlength="255"> يمكن
                                <input type="radio" name="futile" dir="<%=dir%>" ID="futile" size="32" value="0" maxlength="255"> لايمكن
                            </TD>
                        </TR>-->
                       
<!--                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_Function_Desc">
                                    <p><b><%=project_desc_label%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable" >
                                <TEXTAREA rows="5" name="project_desc" dir="rtl" ID="project_desc" cols="26"></TEXTAREA>
                            </TD>
                        </TR>-->
<!--                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL>
                                    <p><b><%=isMngmntStn%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable" >
                                <INPUT type="checkbox" id="isMngmntStn" name="isMngmntStn" checked="true" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL>
                                    <p><b><%=isTrnsprtStn%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD colspan="3" class="blueBorder backgroundTable" >
                                <INPUT type="checkbox" id="isTrnsprtStn" name="isTrnsprtStn" checked="true" />
                            </TD>
                        </TR>-->
                    </table>
                    <%//} else {%>
<!--                    <table align="<%=align%>" dir="<%=dir%>">
                        <TR>
                            <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=futileMsg%></b>&nbsp;</p>
                                </LABEL>
                            </TD>
                        </TR>
                    </TABLE>-->
                    <%//}%>
                    <br /><br /><br />
                </fieldset>
            </CENTER>
        </FORM>
    </BODY>
</HTML>