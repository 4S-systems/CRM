<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Issue.clientProduct"   />


    <head>
        <title></title>
        <link rel="stylesheet" href="css/demo_table.css">    
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </head>


    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        HttpSession s = request.getSession();
        Vector<WebBusinessObject> documents = (Vector) request.getAttribute("documents");
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String loggedUser = (String) waUser.getAttribute("userId");

        metaMgr.setMetaData("xfile.jar");

        UserMgr userMgr = UserMgr.getInstance();

        String stat = (String) request.getSession().getAttribute("currentMode");

        String sDate, sTime = null;
        String sat, sun, mon, tue, wed, thu, fri, today;
        if (stat.equals("En")) {
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            today = "Today";
        } else {
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            today = "\u0627\u0644\u064a\u0648\u0645";
        }
    %>
    <script type="text/javascript">
        $(document).ready(function() {
            $('#attachedTable1').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
            })
        });
        function deleteDocument(docID) {
            $.ajax({
                type: "post",
                url: "<%=context%>/SeasonServlet?op=deleteDocument",
                data: {
                    docID: docID
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        $("#row" + docID).remove();
                    }
                }
            });
        }
    </script>
    <body>
        <% if (documents != null && !documents.isEmpty()) {

        %>

        <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>
       <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: 300px;">
           <table  border="0px"  style="width:100%;" dir='<fmt:message key="direction"/>' class="blueBorder" id="attachedTable1">
                <thead>
                    <TR >
                        <td><fmt:message  key="tittle" />  </td>
                        <td><fmt:message  key="type" />  </td>
                        <td><fmt:message  key="date" />   </td>
                        <td><fmt:message  key="username" />   </td>
                        <td style="display: none;">&nbsp;</td>

                    </TR>  
                </thead>
                <tbody >
                    <%                        for (WebBusinessObject wbo : documents) {
                            WebBusinessObject userWbo = null;
                            if (wbo.getAttribute("createdBy") != null) {
                                userWbo = userMgr.getOnSingleKey(wbo.getAttribute("createdBy").toString());
                            }
                            String userName = "";
                            if (userWbo != null) {
                                userName = (String) userWbo.getAttribute("fullName");
                            }
                    %>


                    <tr id="row<%=wbo.getAttribute("docID")%>">
                        <td>
                            <input type="hidden" value="<%=wbo.getAttribute("docID")%>" name="docID"  id="docID"/>
                            <input type="hidden" value="<%=wbo.getAttribute("docType")%>" name="documentType"  id="documentType"/>
                            <A HREF="#" onclick="javascript:viewClientDocument(this)">
                                <%=wbo.getAttribute("docTitle")%>
                            </A>
                        </td>
                        <td><%=wbo.getAttribute("docType")%></td>
                        <% Calendar c = Calendar.getInstance();
                            DateFormat formatter;
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = wbo.getAttribute("creationTime").toString().split(" ");
                            Date date = new Date();
                            sDate = arrDate[0];
                            sTime = arrDate[1];
                            String[] arrTime = sTime.split(":");
                            sTime = arrTime[0] + ":" + arrTime[1];
                            sDate = sDate.replace("-", "/");
                            arrDate = sDate.split("/");
                            sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            String currentDate = formatter.format(date);
                            String sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                        %>
                        <%if (currentDate.equals(sDate)) {%>
                            <TD nowrap  ><font color="red"><%=today%> - </font><b><%=sTime%></b></TD>
                        <%} else {%>

                            <TD nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                        <%}%>
                        <td><%=userName%></td>
                        <td style="display: none;">
                            <A HREF="#" onclick="javascript:deleteDocument('<%=wbo.getAttribute("docID")%>')">
                                <fmt:message  key="delete" /> 
                            </A>
                        </td>
                    </tr>
                    <%
                        }%>
                </tbody>
            </table>
        </div>
        <% } else {
        %>

        <div style="clear: both;margin-left: 68%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
        </div>

        <div class="login" style="width: 40%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
            <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;"><fmt:message key="nofiles"/></div>
        </div>
        <%}
        %>
    </body>
</html>