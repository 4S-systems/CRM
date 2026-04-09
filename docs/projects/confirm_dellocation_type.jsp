<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>

    <%
        String id = (String) request.getAttribute("id");
        String typeNameValue = (String) request.getAttribute("typeNameValue");

        ProjectMgr projectMgr = ProjectMgr.getInstance();

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

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
            tit = "  &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583; &#1567;";
            save = " &#1573;&#1581;&#1584;&#1601;";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            SNA = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
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
            <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

                function submitForm()
                {  
                    
                    document.PROJECT_DEL_FORM.action = "<%=context%>/ProjectServlet?op=deleteLocationType&id=<%=id%>&typeNameValue=<%=typeNameValue%>";
                    document.PROJECT_DEL_FORM.submit(); 
                }
                function cancelForm()
                {    
                    document.PROJECT_DEL_FORM.action = "<%=context%>/ProjectServlet?op=listLocationType";
                    document.PROJECT_DEL_FORM.submit();  
                }
            </SCRIPT>
        </HEAD>
        <BODY>

        <center>
            <FORM NAME="PROJECT_DEL_FORM" id="deleteForm" METHOD="POST">

                <DIV align="left" STYLE="color:blue;">
                    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                    <button onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                    <button onclick="submitForm()" class="button"><%=save%>    </button>
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
                                <input disabled type="TEXT" name="typeNameValue" value="<%=typeNameValue%>" ID="<%=typeNameValue%>" size="33"  maxlength="50">
                            </TD>
                        </TR>

                        <input  type="HIDDEN" name="projectId" value="<%=id%>">

                    </TABLE>
                    <br><br>
                </fieldset>
        </center>
    </FORM>

</BODY>
</HTML>     
