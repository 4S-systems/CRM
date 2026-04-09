<%@page import="com.docviewer.common.DVAppConstants"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%


    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String status = (String) request.getAttribute("status");
    String treeName = (String) request.getAttribute("treeName");
    if (treeName.equals("no")) {
        WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        Vector mainProjectVec = null;
        ArrayList mainProjectList = null;
        String defaultLocationName = null;

        String isSubProject = (String) request.getAttribute("isSubProject");

        // is a sub project
        if (isSubProject.equalsIgnoreCase("yes")) {
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

        DVAppConstants appCons = new DVAppConstants();
        Vector imagePath = (Vector) request.getAttribute("imagePath");
        Vector docList = (Vector) request.getAttribute("data");
        String[] docAttributes = {"docTitle", "docDate", "configItemType"};
        String[] docTitles = appCons.getDocHeaders();

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

        String typeName = null;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "View attached image";
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

        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            tit = "الصور المرفقة";
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
        }

        String doubleName = (String) request.getAttribute("name");
        String type = "";
        try {
            type = request.getAttribute("type").toString();
        } catch (Exception ex) {
        }

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new project</TITLE>
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script src='js/jsiframe.js' type='text/javascript'></script>

        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/validator.js' type='text/javascript'></script>

        <script type="text/javascript" src="js/jquery.carouFredSel-6.2.0.js"></script>

        <script>
            $(function() {

                $("#foo").carouFredSel();

            });
        </script>
        <style type="text/css">

            .image_carousel {
                /*padding: 15px 0 15px 40px;*/
                width: 200px;
                text-align: center;
            }
            .image_carousel img {
                border: 1px solid #ccc;
                background-color: white;
                padding: 9px;
                margin: 7px;
                display: block;
                float: left;
            }
            .clearfix {
                float: none;
                clear: both;
            }


            .stepcarousel{
                position: relative; /*leave this value alone*/
                border: 10px solid black;
                overflow: scroll; /*leave this value alone*/
                width: 270px; /*Width of Carousel Viewer itself*/
                height: 200px; /*Height should enough to fit largest content's height*/
            }

            .stepcarousel .belt{
                position: absolute; /*leave this value alone*/
                left: 0;
                top: 0;
            }

            .stepcarousel .panel{
                float: left; /*leave this value alone*/
                overflow: hidden; /*clip content that go outside dimensions of holding panel div*/
                margin: 10px; /*margin around each panel*/
                width: 250px; /*Width of each panel holding each content. If removed, widths should be individually defined on each content div then. */
            }

        </style>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm()
            {
                if (!validateData("req", document.PROJECTS_FORM.projectName, "Please, enter Site Name.") || !validateData("minlength=3", document.PROJECTS_FORM.projectName, "Please, enter a valid Site Name.")){
                    document.PROJECTS_FORM.projectName.focus();
                } else if (!validateData("req", document.PROJECTS_FORM.eqNO, "Please, enter Site Number.") || !validateData("alphanumeric", document.PROJECTS_FORM.eqNO, "Please, enter a valid Number for Site Number.")){
                    document.PROJECTS_FORM.eqNO.focus();
                } else if (!validateData("req", document.PROJECTS_FORM.projectDesc, "Please, enter Site Description.")){
                    document.PROJECTS_FORM.projectDesc.focus();
                } else{
                    var url = "op=UpdateProject&OldProjectName=<%=OldProjectName%>"
                        + "&isSubProject=<%=isSubProject%>";
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
         
            function getImages(objId) {
           
                openWindow('UnitDocReaderServlet?op=viewUnitImages&projectId='+objId);
            }

            function openWindow(url)
            {
                window_chaild = window.open(url, "window_chaild", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
                window_chaild.focus();
                //window.open(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            }
        </SCRIPT>
    </HEAD>

    <BODY>
    <center>

        <fieldset class="set" style="border-color: #006699; width: 100%">
            <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <TR>
                    <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=tit%> </FONT><BR></TD>
                </TR>
            </TABLE>
            <br />
            <FORM NAME="PROJECTS_FORM" id="updateForm" METHOD="POST">


                <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" width="100%"  CELLPADDING="0" CELLSPACING="0" BORDER="0">

                    <% if (imagePath != null & !imagePath.isEmpty()) {%>
                    <TR>
                        <td CLASS="td" width="100%" style="text-align: center;">

                            <div class="image_carousel">
                                <div id="foo">

                                    <%for (int i = 0; i < imagePath.size(); i++) {%>
                                    <img src="<%=imagePath.get(i)%>" width="650" height="380" />

                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <%if (null != docList && !docList.isEmpty()) {%>
                            <div style="width: 100%; text-align: center;">
                                <a href="javascript:getImages(<%=project.getAttribute("projectID")%>)">
                                    <font color="black"> <b><%=docTitles[3]%></b></font>
                                </a>
                            </div>
                            <% }%>

                        </td>
                    </TR>
                    <%}
                    } else {%>

                    <b style="text-align: center;font-size: 19px;">لا توجد صور لعرضها</b>

                    <%}%>
                </TABLE>
                <input type="hidden" name="projectID" ID="projectID" value="<%=project.getAttribute("projectID")%>">
            </FORM>
            <br>
        </fieldset>
    </center>
    <%} else {
        }%>
</BODY>
</HTML>     