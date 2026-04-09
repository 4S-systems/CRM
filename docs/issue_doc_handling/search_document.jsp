<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*, java.util.*,com.silkworm.common.*,com.docviewer.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String num = "";
        if (request.getAttribute("num") != null) {
            num = (String) request.getAttribute("num");
        }
        WebBusinessObject issueWbo = (WebBusinessObject) request.getAttribute("issueWbo");
        WebBusinessObject docWbo = (WebBusinessObject) request.getAttribute("docWbo");
        String uploadDate = "";
        String docId = "";
        if(docWbo != null && docWbo.getAttribute("creationTime") != null) {
            uploadDate = (String) docWbo.getAttribute("creationTime");
            docId = (String) docWbo.getAttribute("documentID");
        }
        String align, dir, style, title, save, cancel;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Search for Document";
            save = "Search";
            cancel = "Back";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "البحث عن مستخلص محدد";
            save = "بحث";
            cancel = "إنهاء";
        }
    %>

    <HEAD>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0"/>
    <TITLE>Document Viewer - Confirm Deletion</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
    <link REL="stylesheet" TYPE="text/css" HREF="Button.css"/>
</HEAD>
<script LANGUAGE="JavaScript" TYPE="text/javascript">
    function submitForm() {
        document.DOCUMENT_FORM.action = "<%=context%>/IssueDocServlet?op=searchForDocument";
        document.DOCUMENT_FORM.submit();
    }
    function cancelForm() {
        document.DOCUMENT_FORM.action = "main.jsp";
        document.DOCUMENT_FORM.submit();
    }
</script>
<body>
    <div align="left" STYLE="color:blue;">
        <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
        <button    onclick="submitForm()" class="button"> &nbsp;&nbsp; <%=save%> &nbsp;&nbsp; 
        </button>
    </div>
    <br><br>
    <fieldset align=center class="set" style="width: 90%;">
        <legend align="center">
            <table dir=" <%=dir%>" align="<%=align%>">
                <tr>
                    <td class="td">
                        <font color="blue" size="6"><%=title%> 
                        </font>
                    </td>
                </tr>
            </table>
        </legend>
        <form  NAME="DOCUMENT_FORM" METHOD="POST">
            <table align="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <tr>
                    <td STYLE="<%=style%>" class='td'>
                        رقم المستخلص
                    </td>
                    <td STYLE="text-align:right" class='td'>
                        <input type="text" name="num" value="<%=num%>"/>
                    </td>
                </tr>
            </table>
            <%
                if (issueWbo != null) {
            %>
            <br/><br/>
            
            <table align="<%=align%>" dir="<%=dir%>" style="margin-top: 0px;">
                <tr>
                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                        <label>
                            <p><b>اسم المقاول</b>&nbsp;
                        </label>
                    </td>
                    <td style="<%=style%>" class='td'>
                        <%=issueWbo.getAttribute("contractorName")%>
                    </td>
                </tr>
                <tr >
                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                        <label>
                            <p><b>تاريخ التحميل</b>&nbsp;
                        </label>
                    </td>
                    <td style="<%=style%>" class='td'>
                        <%=uploadDate%>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                        <label>
                            <p><b>مدير المشروع</b>&nbsp;
                        </label>
                    </td>
                    <td style="<%=style%>" class='td'>
                        <%=issueWbo.getAttribute("createdByName")%>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                        <label>
                            <p><b></b>&nbsp;
                        </label>
                    </td>
                    <td style="<%=style%>" class='td'>
                        <a href="<%=context%>/DocumentServlet?op=downloadDocument&documentId=<%=docId%>" title="تحميل"><img src="images/down_16.png"/></a>
                    </td>
                </tr>
            </table>
            <%
                }
            %>
        </form>
    </fieldset>
</body>
</html>     
