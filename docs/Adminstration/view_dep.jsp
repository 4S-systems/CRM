<%@page import="com.tracker.db_access.LocationTypeMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();


    WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    LocationTypeMgr locationTypeMgr = LocationTypeMgr.getInstance();
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String isTrnsprtStn;
    String isMngmntStn;
    String lang, langCode, locationType, futile, tit, save, cancel, TT, SNA, SNO, DESC;
    String futile_En_NO = "", futile_En_Yes = "", futile_Ar_NO = "", futile_Ar_Yes = "";
    if (stat.equals("En")) {
        futile = "Adding sun location";
        futile_En_NO = "can't add sub location";
        futile_En_Yes = "can add sub location";
        align = "center";
        dir = "LTR";
        locationType = "Location Type";
        style = "text-align:left; padding-left:10px;";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        tit = "View Project";
        save = "Delete";
        cancel = "Back To List";
        TT = "Task Title ";
        SNA = "Site Name";
        SNO = "Site No.";
        DESC = "Description";
        isTrnsprtStn = "Is Transport Station";
        isMngmntStn = "Is Managment Station";
    } else {
        futile = "";
        futile_Ar_NO = "&#65275; &#1610;&#1605;&#1603;&#1606;";
        futile_Ar_Yes = "&#1610;&#1605;&#1603;&#1606;";
        align = "center";
        dir = "RTL";
        style = "text-align:Right; padding-right:10px;";
        lang = "English";
        locationType = "التصنيف";
        langCode = "En";
        tit = " &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        save = " &#1573;&#1581;&#1584;&#1601;";
        cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        SNA = "إسم الإدارة";
        SNO = "كود الإدارة";
        DESC = "&#1575;&#1604;&#1608;&#1589;&#1601;";
        isTrnsprtStn = "&#1605;&#1581;&#1591;&#1577; &#1606;&#1602;&#1604;";
        isMngmntStn = "&#1605;&#1608;&#1602;&#1593; &#1573;&#1583;&#1575;&#1585;&#1609;";
    }
    String type = "";
    try {
        type = request.getAttribute("type").toString();
    } catch (Exception ex) {
    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new Project</TITLE>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script language="javascript" type="text/javascript" >
        
            function cancelForm()
            {    
                document.PROJECT_VIEW_FORM.action = "<%=context%>//ProjectServlet?op=ListProjects";
                document.PROJECT_VIEW_FORM.submit();  
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
        </script>
    </HEAD>
    <BODY>
    <center>
              <DIV  STYLE="color:blue;width: 100%;margin-left: auto;margin-right: auto;text-align: center;">
          <!--<input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">-->
            <%if (!type.equals("tree")) {%>
            <BUTTON type="button"    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif" ></BUTTON>
                <%}%>
        </DIV> 
        <br />
        <fieldset class="set" style="border-color: #006699; width: 90%">
<!--            <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <TR>
                    <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=tit%> </FONT><BR></TD>
                </TR>
            </TABLE>-->
            <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">

                <table ALIGN="<%=align%>" DIR="<%=dir%>" >
                    <TR>
                        <TD style="<%=style%>;width: 40%;text-align: center " class="td2 formInputTag boldFont boldFont backgroundHeader">
                            <LABEL FOR="str_Function_CODE">
                                <p><b><%=SNO%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <input disabled type="TEXT" STYLE="width:230px" name="eqNO" ID="eqNO" size="33" value="<%=project.getAttribute("eqNO")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>;width: 40%;text-align: center "class="td2 formInputTag boldFont boldFont backgroundHeader">
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=SNA%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <input disabled type="TEXT" STYLE="width:230px" name="projectName" ID="projectName" size="33" value="<%=project.getAttribute("projectName")%>" maxlength="255">
                        </TD>
                    </TR>

                    <TR>
                        <TD style="<%=style%>;width: 40%;text-align: center "class="td2 formInputTag boldFont boldFont backgroundHeader">
                            <LABEL FOR="Location_Type">
                                <p><b><%=locationType%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <%
                                String locType_Lang = "";
                                if (stat.equals("En")) {
                                    locType_Lang = (String) ((WebBusinessObject)locationTypeMgr.getOnArbitraryKey((String) project.getAttribute("location_type"), "key1").get(0)).getAttribute("enDesc");
                                } else {
                                    locType_Lang = (String) ((WebBusinessObject)locationTypeMgr.getOnArbitraryKey((String) project.getAttribute("location_type"), "key1").get(0)).getAttribute("arDesc");
                                }%>
                            <input disabled type="TEXT" STYLE="width:230px" name="locationType" ID="locationType" size="33" value="<%=locType_Lang%>" maxlength="255">

                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>;width: 40%;text-align: center " class="td2 formInputTag boldFont boldFont backgroundHeader">
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=DESC%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <TEXTAREA DISABLED STYLE="width:230px" rows="5" name="projectDesc" ID="projectDesc" cols="33"><%=project.getAttribute("projectDesc")%></TEXTAREA>
                            <!--
                            <input disabled type="TEXT" name="projectDesc" ID="projectDesc" size="33" value="<%//=project.getAttribute("projectDesc")%>" maxlength="255">
                            -->
                        </TD>
                    </TR>
                   
                </TABLE>
            </FORM>
    </center>
</BODY>
</HTML>     
