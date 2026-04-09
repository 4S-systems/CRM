

<%@page import="java.util.Enumeration"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>.<c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Campaigns.Campaigns"  />
  
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Departments List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
          int iTotal = 0;
        String attValue = null;
        Vector seaVector = (Vector) request.getAttribute("seaVector");
         WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;
      


    %>

    <body>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script language="javascript" type="text/javascript">
            $(document).ready(function(){
                $('#recordSeasons').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 20, 50, 100, -1], [10, 20, 50, 100, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": false
                }).fadeIn(2000);
            });
             
            function back(url)
            {
                document.PROJECT_FORM.action = url;
                document.PROJECT_FORM.submit();
            }
        </script>
         
        <fieldset align=center class="set" style="width: 50%; margin-top: 20px; padding: 20px;">
            <legend   align="center">
                <table  dir=<fmt:message key="direction" /> align="center">
                    <tr>

                        <td class="td">
                            <font color="blue" size="4">
                            <fmt:message key="PL"/>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
             
            
            <TABLE dir="RTL" ALIGN="RIGHT" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;"></TABLE>

            <TABLE id="recordSeasons" ALIGN="center" dir=<fmt:message key="direction" />  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <thead>

                    <tr>
                        <th nowrap CLASS="silver_footer" WIDTH="150" bgcolor="#808080" STYLE="border-WIDTH:0; font-size:14 ;white-space: nowrap;" >
                            <B><fmt:message key="name" /></B>
                        </th>

                         <th nowrap CLASS="silver_footer" WIDTH="150" bgcolor="#808080" STYLE="border-WIDTH:0; font-size:14 ;white-space: nowrap;" >
                            <B><fmt:message key="view" /></B>
                        </th>

                        <th nowrap CLASS="silver_footer" WIDTH="150" bgcolor="#808080" STYLE="border-WIDTH:0; font-size:14 ;white-space: nowrap;" >
                            <B><fmt:message key="edit" /></B>
                        </th>

                        <th nowrap CLASS="silver_footer" WIDTH="150" bgcolor="#808080" STYLE="border-WIDTH:0; font-size:14 ;white-space: nowrap;" >
                            <B><fmt:message key="delete" /></B>
                        </th>
                    </tr>
                </thead>
                <tbody>
                <%

                    Enumeration e = seaVector.elements();

                    iTotal=seaVector.size();

                    while (e.hasMoreElements()) {
                         wbo = (WebBusinessObject) e.nextElement();

                        flipper++;
                        if ((flipper % 2) == 1) {
                            bgColor = "silver_odd";
                           
                        } else {
                            bgColor = "silver_even";
                           
                        }
                %>

                <TR>
                     <fmt:message var="attname" key="comm_channel_attribute_name" />
                
            <%
               String attname= (String)pageContext.getAttribute("attname"); 
               attValue = (String) wbo.getAttribute(attname)+" "; 
                %>
                    <TD STYLE="text-align: <fmt:message key="textalign" />" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>" >
                        <DIV >

                            <b style="color: #005599;"> <%=attValue%> </b>
                        </DIV>
                    </TD>
 

                    <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10; text-align:  <fmt:message key="textalign" />>
                        <DIV ID="links">
                            <A HREF="<%=context%>/SeasonServlet?op=ViewRecordSeason&seasonTypeId=<%=wbo.getAttribute("id")%>">
                               <fmt:message key="view"/>
                            </A>
                        </DIV>
                    </TD>

                    <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align:  <fmt:message key="textalign" />">
                        <DIV ID="links">
                            <A HREF="<%=context%>/SeasonServlet?op=UpdateRecordSeason&seasonTypeId=<%=wbo.getAttribute("id")%>">
                               <fmt:message key="update"/>
                            </A>
                        </DIV>
                    </TD>
                    <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;text-align:  <fmt:message key="textalign" />">
                        <DIV ID="links">
                            <A HREF="<%=context%>/SeasonServlet?op=ConfirmDeleteRecordSeason&seasonTypeId=<%=wbo.getAttribute("id")%>">
                                  <fmt:message key="delete"/>
                            </A>
                        </DIV>
                    </TD>
               </TR>


                <%

                    }

                %>
                </tbody>
                <tfoot>
                    <TR>
                        <th CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="2" STYLE="text-align:  <fmt:message key="textalign" />;padding-right:5;border-right-width:1;font-size:16;">
                            <B><fmt:message key="PN" /></B>
                        </th>
                        <th CLASS="silver_footer" BGCOLOR="#808080" colspan="2" STYLE="text-align:  <fmt:message key="textalign" />;padding-left:5;font-size:16;"  >

                            <DIV NAME="" ID="">
                                <B><%=iTotal%></B>
                            </DIV>
                        </th>
                    </TR>
                </tfoot>
            </TABLE>

            <br /><br />
        </fieldset>


    </body>
</html>
