<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page  pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Main.Main"  />    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            ArrayList<WebBusinessObject> mFolders = (ArrayList<WebBusinessObject>) request.getAttribute("mFolders");
        %>
    </head>
    <body>
        <script type="text/javascript">
            function openProjectsInFolder(obj) {
                var folderID = $(obj).parent().parent().find("#folderID").val();
                var url = "<%=context%>/ProjectServlet?op=mFolderList&folderID=" + folderID ;
//                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=800,height=400");

                $("#mFolderProject").load(url);
            }
        </script>
        <style>
            .buttons-input {
                width:1000px;
            }

            .buttons-input ul {
                margin:0px;
                padding:0px;
            }

            .buttons-input ul li {
                display:inline-block;
            }
        </style>
        <fieldset >
            <legend>
                <h1>
                    <fmt:message key="myfolders" />
                </h1>
            </legend>
            <div class="buttons-input" >
                <% if (mFolders.size() == 0){%>
                      <label class="" style="font-size: x-large;font-weight: bold">
                          
                          <fmt:message key="nofolders" />
                      </label>
                <%}%>
                <ul>
                    <%for (int i = 0; i < mFolders.size(); i++) {%>
                    <li>
                        <div>
                            <img src="images/dialogs/folder.jpeg" width="100px" height="100px" onclick="openProjectsInFolder(this)">
                        </div>
                        <div>
                            <label class="" style="font-size: larger;font-weight: bold"><%=mFolders.get(i).getAttribute("projectName")%> (<%=mFolders.get(i).getAttribute("count")%>)</label>
                            <input type="hidden" id="folderID" name="folderID" value="<%=mFolders.get(i).getAttribute("projectID")%>" />
                        </div>
                    </li>
                    <%}%>
                </ul>
            </div>
            <DIV id="mFolderProject">

            </DIV>
        </fieldset>
    </body>
</html>