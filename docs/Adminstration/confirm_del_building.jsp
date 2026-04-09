<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib  prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />

    <%
        String buildingId = (String) request.getAttribute("buildingId");
        String buildingName = (String) request.getAttribute("buildingName");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
        <HEAD>
            <TITLE>Confirm Deletion</TITLE>
            <link rel="stylesheet" type="text/css" href="css/CSS.css" />
            <link rel="stylesheet" type="text/css" href="css/Button.css" />
            <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
            <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
            <script src='js/jsiframe.js' type='text/javascript'></script>
            <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>
            <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
                function submitForm()
                {
                    var url = "op=DeleteBuilding&buildingId=<%=buildingId%>&buildingName=<%=buildingName%>";
                    $.ajax({
                        async: false,
                        type: "POST",
                        url: "<%=context%>/ProjectServlet",
                        data: url,
                        success: function(msg) {
                            document.PROJECT_DEL_FORM.action = "<%=context%>/ProjectServlet?op=listBuildings";
                            document.PROJECT_DEL_FORM.submit();
                        }
                    });
                }
                function cancelForm()
                {
                    document.PROJECT_DEL_FORM.action = "<%=context%>/ProjectServlet?op=listBuildings";
                    document.PROJECT_DEL_FORM.submit();
                }
            </SCRIPT>
        </HEAD>
        <BODY>
        <center>
            <FORM NAME="PROJECT_DEL_FORM" id="deleteForm" METHOD="POST">
                
                
                <fieldset class="set" style="border-color: #006699; width: 40%">
                    <TABLE class="blueBorder" dir='<fmt:message key="direction" />' align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> 
                                <fmt:message key="delbuild" />
                                </FONT><BR></TD>
                        </TR>
                    </TABLE>
                    <br />
                    <TABLE ALIGN="center" dir='<fmt:message key="direction" />' CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <TR>
                            <TD class='td'>
                                <LABEL FOR="str_Function_Name">
                                    <p><b>
                                            <fmt:message key="building" />
                                        </b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD class='td'>
                                <input disabled type="TEXT" name="buildingName" value="<%=buildingName%>" ID="<%=buildingName%>" size="33"  maxlength="50">
                            </TD>
                        </TR>
                        
                        <input  type="HIDDEN" name="buildingId" value="<%=buildingId%>">
                    </TABLE>
                    <br><br>
                    <TABLE style="width: 30%" dir='<fmt:message key="direction" />'>
                         <TR>
                            <TD style="  border: none"> 
                                <button onclick="cancelForm()" class="button" style="width: 100%">
                        <fmt:message key="cancle" /></button>
                  </TD>   
                  <TD style="width: 5%;   border: none">
                      
                  </TD>
                  <TD style="   border: none">
                      <button  onclick="submitForm()" class="button" style="width: 100%">
                      <fmt:message key="delete" />
                      </button>
                
                  </TD>
              </TR>
                    </TABLE>
                      <br/>
                </fieldset>
            </FORM>
        </center>
    </BODY>
</HTML>     
