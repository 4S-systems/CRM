<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Projects.Projects"  />
  

<%
            TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
             

            ArrayList treeMenu = metaMgr.getTreeMenu();
            if (treeMenu.get(0) == null) {
                System.out.println("jkdshfljksahdfjklshdlkjfsdh kjlg");

            }
%>
<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="treemenu/page_style.css" />
        <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>

        <script type="text/javascript">
            function changeMode(name) {
                if(document.getElementById(name).style.display == 'none') {
                    document.getElementById(name).style.display = 'block';
                } else {
                    document.getElementById(name).style.display = 'none';
                }
            }
    
           
            $(document).ready(function(){
;
               $('#TreeInfo').html("<iframe style='padding:10px; border:none' width=98% height='500px' src=\"<%=context%>/ProjectServlet?op=showProjectsTree\" ></iframe>");
            });
        </script>

        <style>
            a{
                color:blue;
                background-color: transparent;
                text-decoration: none;
                font-size:12px;
                font-weight:bold;
            }
            #open, #email, #save,#delete,#insert{
                font-size: 12px;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <form name="MainType_Form" method="post">
             <fieldset class="set" style="width:90%;border-color: #006699;" >
                 <LEGEND> 
                     <font color="#005599" size="5">
                            <fmt:message key="organizationtree"/>
                            </font></TD>
                 </LEGEND>
                <br />
                <div  style="width: 100%;" id="TreeInfo" align='<fmt:message key="align"/>'>
                </div>
            </fieldset>
        </form>
    </body>
</html>
