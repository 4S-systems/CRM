<%-- 
    Document   : confirmDeleteSomeUnits
    Created on : Dec 10, 2014, 4:05:16 PM
    Author     : crm32
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> arrayOfApartmentToDelete = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script>
            function submitForm() {
                document.PROJECT_DEL_FORM.action = "<%=context%>/UnitServlet?op=deleteMoreApartments";
                document.PROJECT_DEL_FORM.submit();
            }
        </script>
    </head>
    <body>
    <center>
        <FORM NAME="PROJECT_DEL_FORM" id="deleteForm" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <button onclick="cancelForm()" class="button">الغاء<IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button onclick="submitForm()" class="button">حذف</button>
            </DIV> 
            <br />
            <fieldset class="set" style="border-color: #006699; width: 90%">
                <TABLE class="blueBorder"  align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> الغاء</FONT><BR></TD>
                    </TR>
                </TABLE>
                <br />
                <TABLE  CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <%for (int i = 0; i < arrayOfApartmentToDelete.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) arrayOfApartmentToDelete.get(i);
                    %>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=wbo.getAttribute("apartmentName")%></b>&nbsp;
                                    <input type="hidden" value="<%=wbo.getAttribute("apartmentId")%>" name="apartmentID" id="apartmentID" />
                            </LABEL>
                        </TD>

                    </TR>
                    <%}%>
                </TABLE>
                <br><br>
            </fieldset>
        </FORM>
    </center>
</body>
</html>
