<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%


    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String status = (String) request.getAttribute("status");

    WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    Vector mainProjectVec = null;
    ArrayList mainProjectList = null;
    String defaultLocationName = null;
    
    String isSubProject = (String) request.getAttribute("isSubProject");
    
    // is a sub project
    if(isSubProject.equalsIgnoreCase("yes")) {
        mainProjectVec = (Vector) request.getAttribute("mainProjectVec");
        mainProjectList = new ArrayList(mainProjectVec);
        defaultLocationName = (String) request.getAttribute("defaultLocationName");
    
    }
    
    String OldProjectName = null;
    OldProjectName = (String) project.getAttribute("projectName");
    ArrayList locationTypesList = (ArrayList) request.getAttribute("locationTypesList");

    String isMngmntStn = "", isTrnsprtStn = "";
    
    if (project.getAttribute("isMngmntStn").equals("1")) {
        isMngmntStn = "checked";

    }
    
    if (project.getAttribute("isTrnsprtStn").equals("1")) {
        isTrnsprtStn = "checked";

    }
    
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, tit, save, cancel, TT, SNA, SNO, DESC, STAT, Dupname,
            isTrnsprtStnStr, isMngmntStnStr, main_project_name_label;
    String fStatus;
    String sStatus;

    String project_code_label = null;
    String projectName_label = null;
    String project_desc_label = null;
    String futile_label = null;
    String location_type_label = null;
    String alter_main_project_name_label,search;
    String typeName = null;
    if (stat.equals("En")) {

        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        tit = "Update Project";
        save = "Save";
        cancel = "Back To List";
        TT = "Task Title ";
        SNA = "Site Name";
        SNO = "Site No.";
        DESC = "Description";
        STAT = "Update Status";
        Dupname = "Name is Duplicated Chane it";
        sStatus = "Site Updated Successfully";
        fStatus = "Fail To Update This Site";
        typeName = "enDesc";
        project_code_label = "Location name";
        projectName_label = "Location code";
        project_desc_label = "Location decription";
        futile_label = "Adding sub location ";
        location_type_label = "Loaction Type";
        isTrnsprtStnStr = "Is Transport Station";
        isMngmntStnStr = "Is Managment Station";
        main_project_name_label = "Main Project";
        alter_main_project_name_label="Alteranative main branch";
        search="Search";
    } else {

        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        tit = "    &#1578;&#1581;&#1583;&#1610;&#1579; &#1605;&#1608;&#1602;&#1593; &#1605;&#1608;&#1580;&#1608;&#1583; ";
        save = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
        cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        SNA = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        SNO = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        DESC = "&#1575;&#1604;&#1608;&#1589;&#1601;";
        STAT = " &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        
        isTrnsprtStnStr = "محطة نقل";
        isMngmntStnStr = "موقع إدارى";
        project_code_label = "كود الموقع ";
        projectName_label = "إسم الموقع ";
        project_desc_label = "الوصف ";
        futile_label = "إضافة مواقع فرعية ";
        location_type_label = "نوع الموقع ";
        typeName = "arDesc";
        main_project_name_label = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1609;";
        alter_main_project_name_label="الفرع الرئيسى البديل";
        search="بحث";
    }

    String doubleName = (String) request.getAttribute("name");
    String type = "";
    try {
        type = request.getAttribute("type").toString();
    } catch (Exception ex) {
    }

    String mainProjectName = (String) request.getAttribute("mainProjectName");
    String mainProjectId = (String) request.getAttribute("mainProjectId");
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new project</TITLE>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script src='js/jsiframe.js' type='text/javascript'></script>

        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/validator.js' type='text/javascript'></script>
        <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm()
            {
                if (!validateData("req", document.PROJECTS_FORM.alterMainProjectName, "Please, enter Site Name.")){
                    document.PROJECTS_FORM.alterMainProjectName.focus();
                } else{
                    var url = "op=UpdateParenetProject&OldProjectName=<%=OldProjectName%>"
                                ;
                    if('<%=type%>' != '') {
                        url += '&type=<%=type%>';
                    }
                    //document.PROJECTS_FORM.action = url;
                    //document.PROJECTS_FORM.submit();
                    //document.location.reload();
                    var form = $('#updateForm');
                    $.ajax({
                        async:false,
                        type: "POST",
                        url: "<%=context%>/ProjectServlet",
                        data: url+'&'+form.serialize(),
                        success: function(msg){
                            parent.location.reload();
                        }
                    });
                }
            }
        
            function IsNumeric(sText)
            {
                var ValidChars = "0123456789.";
                var IsNumber=true;
                var Char;

 
                for (i = 0; i < sText.length && IsNumber == true; i++) 
                { 
                    Char = sText.charAt(i); 
                    if (ValidChars.indexOf(Char) == -1) 
                    {
                        IsNumber = false;
                    }
                }
                return IsNumber;

            }
    
            function clearValue(no){
                document.getElementById('Quantity' + no).value = '0';
                total();
            }
    
            function cancelForm()
            {    
                document.PROJECTS_FORM.action = "<%=context%>/ProjectServlet?op=ListProjects";
                document.PROJECTS_FORM.submit();  
            }
        
            function reloadAE(nextMode){
      
                var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
                if (window.XMLHttpRequest)
                { 
                    req = new XMLHttpRequest(); 
                } 
                else if (window.ActiveXObject)
                { 
                    req = new ActiveXObject("Microsoft.XMLHTTP"); 
                } 
                req.open("Post",url,true); 
                req.onreadystatechange =  callbackFillreload;
                req.send(null);
      
            }

            function callbackFillreload(){
                if (req.readyState==4)
                { 
                    if (req.status == 200)
                    { 
                        window.location.reload();
                    }
                }
            }
        </SCRIPT>
    </HEAD>

    <BODY>
    <center>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            <button    onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/save.gif"></button>
        </DIV> 
        <br />
        <fieldset class="set" style="border-color: #006699; width: 90%">
            <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <TR>
                    <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=tit%> </FONT><BR></TD>
                </TR>
            </TABLE>
            <br />
            <FORM NAME="PROJECTS_FORM" id="updateForm" METHOD="POST">
                 
                    <%
                        if (null != status) {
                            if (status.equalsIgnoreCase("ok")) {
                    %>  
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="black"><%=sStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%
                } else {%>
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%}
                    }

                %>
                <br/>
                <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <%if(mainProjectVec != null) {%>
                    
                        <TR>
                            <TD  style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=main_project_name_label%></b>&nbsp;</p>
                                </LABEL>
                            </TD>
                           <TD  class="blueBorder backgroundTable" >
                               <input type="hidden" id="mainProjectId" name="mainProjectId" value="<%=mainProjectId%>"/>
                               <input readonly type="text" id="mainProjectName" name="mainProjectName" value="<%=mainProjectName%>"/>
                            </TD>
                        </TR>
                    
                    <%}%>
                    <TR>
                        <TD  style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_EQ_NO">
                                <p><b><%=project_code_label%></b>&nbsp;</p>
                            </LABEL>
                        </TD>
                        <TD  class="blueBorder backgroundTable" >
                            <input readonly type="TEXT" name="eqNO" dir="<%=dir%>" ID="eqNO" size="32" value="<%=project.getAttribute("eqNO")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD  style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_projectName">
                                <p><b> <%=projectName_label%> </b>&nbsp;</p>
                            </LABEL>
                        </TD>
                        <TD class="blueBorder backgroundTable">
                            <input readonly type="TEXT" dir="<%=dir%>" name="projectName" ID="projectName" size="32" value="<%=project.getAttribute("projectName").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD  style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <LABEL FOR="str_EQ_NO">
                                    <p><b><%=alter_main_project_name_label%></b>&nbsp;</p>
                                </LABEL>
                            </TD>
                           <TD class="blueBorder backgroundTable" >
                               <input type="hidden" id="mainProjectId" name="alterMainProjectId" value=""/>
                               <input readonly type="text" id="mainProjectName" name="alterMainProjectName" value=""/>
                            </TD>
                            <td style="border: 0px">
                               <input type="button" onclick="window.open('<%=context%>/ProjectServlet?op=getAllProject', '_blank', 'status=1,scrollbars=1,width=400')"  value="<%=search%>">
                            </td>
                        </TR>

                </TABLE>
                <input type="hidden" name="projectID" ID="projectID" value="<%=project.getAttribute("projectID")%>">
            </FORM>
            <br>
        </fieldset>
    </center>
</BODY>
</HTML>     