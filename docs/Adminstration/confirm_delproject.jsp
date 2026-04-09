<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>

    <%
        String projectId = (String) request.getAttribute("projectId");
        String projectName = (String) request.getAttribute("projectName");

        ProjectMgr projectMgr = ProjectMgr.getInstance();

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel, TT, SNA;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "Delete Site - Are you Sure ?";
            save = "Delete";
            cancel = "Back To List";
            TT = "Task Title ";
            SNA = "Site Name";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            tit = "حذف العنصر- هل أنت متأكد؟";
            save = " &#1573;&#1581;&#1584;&#1601;";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            SNA = "اسم العنصر";
        }

        String type = "";
        try {
            type = request.getAttribute("type").toString();
        } catch (Exception ex) {
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

        <HEAD>
            <TITLE>Document Viewer - Confirm Deletion</TITLE>
            <link rel="stylesheet" type="text/css" href="css/CSS.css" />
            <link rel="stylesheet" type="text/css" href="css/Button.css" />
            <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
            <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
            <script src='js/jsiframe.js' type='text/javascript'></script>
            <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>

            <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

                function submitForm()
                {  
                    var url = "op=Delete&projectId=<%=projectId%>&projectName=<%=projectName%>";
                    if('<%=type%>' != '') {
                        url += '&type=<%=type%>';
                    }
                    $.ajax({
                        async:false,
                        type: "POST",
                        url: "<%=context%>/ProjectServlet",
                        data: url,
                        success: function(msg){
                            if('<%=type%>' != '') {
                                window.opener.parent.document.location.replace("<%=context%>/ProjectServlet?op=showTree");
                                window.close();
                            } else {
                                document.PROJECT_DEL_FORM.action = "<%=context%>/ProjectServlet?op=ListProjects";
                                document.PROJECT_DEL_FORM.submit();  
                            }
                        }
                    });  
                }
                function cancelForm()
                {    
                    document.PROJECT_DEL_FORM.action = "<%=context%>/ProjectServlet?op=ListProjects";
                    document.PROJECT_DEL_FORM.submit();  
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
            <FORM NAME="PROJECT_DEL_FORM" id="deleteForm" METHOD="POST">

                <DIV align="left" STYLE="color:blue;">
                    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button" style="display: <%=type.equals("tree")?"none": ""%>">
                    <button    onclick="cancelForm()" class="button" style="display: <%=type.equals("tree")?"none": ""%>"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                    <button    onclick="submitForm()" class="button"><%=save%>    </button>
                </DIV> 
                <br />
                <fieldset class="set" style="border-color: #006699; width: 90%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=tit%> </FONT><BR></TD>
                        </TR>
                    </TABLE>
                    <br />
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">

                        <TR>
                            <TD class='td'>
                                <LABEL FOR="str_Function_Name">
                                    <p><b><%=SNA%></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD class='td'>
                                <input disabled type="TEXT" name="projectName" value="<%=projectName%>" ID="<%=projectName%>" size="33"  maxlength="50">
                            </TD>
                        </TR>

                        <input  type="HIDDEN" name="projectId" value="<%=projectId%>">

                    </TABLE>
                    <br><br>
                </fieldset>
        </center>
    </FORM>

</BODY>
</HTML>     
