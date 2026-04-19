<%@page import="com.docviewer.db_access.DocTypeMgr"%>
<%@page import="com.silkworm.db_access.FileMgr"%>
<%@page import="com.docviewer.common.DVAppConstants"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.IssueDocumentMgr"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
    DVAppConstants appCons = new DVAppConstants();
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    List<WebBusinessObject> docList = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String[] docAttributes = {"docTitle", "configItemType", "docDate", "createdByName"};
    String[] docTitles = new String[5];
    int s = docAttributes.length;
    int t = s + 1;
    String attName, attValue;

    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    Calendar calendar = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String today = sdf.format(calendar.getTime());
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    if (beDate == null || eDate == null) {
        eDate = sdf.format(calendar.getTime());
        calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        int yaer = calendar.get(Calendar.YEAR);
        int month = (calendar.get(Calendar.MONTH)) + 1;
        int day = calendar.get(Calendar.DATE);
        beDate = yaer + "/" + month + "/" + day;
    }
    String projectID = "";
    if (request.getAttribute("projectID") != null) {
        projectID = (String) request.getAttribute("projectID");
    }
    String titleValue = "";
    if (request.getAttribute("title") != null) {
        titleValue = (String) request.getAttribute("title");
    }
    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate, searchBy;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Search for Documents";
        beginDate = "From Date";
        endDate = "To Date";
        searchBy = "Search By";
        docTitles[0] = "Document Title";
        docTitles[1] = "Type";
        docTitles[2] = "Date";
        docTitles[3] = "User Name";
        docTitles[4] = "View";
    } else {
        dir = "RTL";
        title = "البحث عن وثائق";
        beginDate = "من تاريخ";
        endDate = "الى تاريخ";
        searchBy = "البحث ب";
        docTitles[0] = "عنوان المستند";
        docTitles[1] = "النوع";
        docTitles[2] = "التاريخ";
        docTitles[3] = "اسم المستخدم";
        docTitles[4] = "مشاهدة";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: new Date('<%=today%>'),
                    dateFormat: "yy/mm/dd"
                });
            });

            $(document).ready(function() {
                $("#requests").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });

            function getComplaints() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if ((beginDate == null || beginDate == "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if ((endDate == null || endDate == "")) {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
                    var projectID = $("#projectID").val();
                    var title = $("#title").val();
                    document.DOCUMENT_FORM.action = "<%=context%>/SearchServlet?op=searchForAllDocuments&beginDate=" + beginDate + "&endDate=" + endDate + "&projectID=" + projectID + "&title=" + title;
                    document.DOCUMENT_FORM.submit();
                }
            }
        </script>

        <style type="text/css">
            .canceled {
                background-color: rgba(255, 0, 0, 0.5);
                color: #004276;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .confirmed {
                background-color: #459E00;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
        </style>
    </head>
    <body>
        <form name="DOCUMENT_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <img width="40" height="40" src="images/icons/request.png" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table align="center" style="margin-left: 25%; margin-right: 25%;" dir="rtl" width="50%" cellspacing="3" cellpadding="10">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input id="beginDate" readonly name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" >                 
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input id="endDate" readonly name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white"> الملف</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE" colspan="2">
                                        <select style="font-size: 14px;font-weight: bold; width: 250px;" id="projectID" >
                                            <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white"> <%=searchBy%></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="2">
                                        <input type="text" name="title" id="title" value="<%=titleValue != null ? titleValue : ""%>"
                                               style="width: 500px; background-color: #FBEC88;"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center;" bgcolor="#dedede" colspan="2">
                                        <button type="button" onclick="JavaScript: getComplaints();" style="color: #27272A;font-size:15px;margin-top: 2px;margin-bottom: 2px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <%
                                if (docList != null && !docList.isEmpty()) {
                            %>
                            <center>
                                <div style="width: 97%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <TR >

                                                <%
                                                    for (int i = 0; i < t; i++) {

                                                %>     
                                                <TD >
                                                    <B><%=docTitles[i]%></B>
                                                </TD>
                                                <%
                                                    }
                                                %>

                                            </TR>  
                                        </thead>
                                        <tbody>
                                            <%
                                                for (WebBusinessObject doc : docList) {
                                                    fileDescriptor = fileMgr.getObjectFromCash((String) doc.getAttribute("documentType"));
                                            %>
                                            <tr>
                                                <%
                                                    for (int i = 0; i < s; i++) {
                                                        attName = docAttributes[i];
                                                        attValue = (String) doc.getAttribute(attName);
                                                        if(attName.equals("configItemType")) {
                                                             WebBusinessObject tempWBO = docTypeMgr.getOnSingleKey(attValue);
                                                             attValue = (String) tempWBO.getAttribute("typeName");
                                                        }
                                                %>
                                                <TD>
                                                    <DIV>
                                                        <b> <%=attValue%> </b>
                                                    </DIV>
                                                </TD>
                                                <%
                                                    }
                                                %>
                                                <TD>
                                                    <DIV ID="links">
                                                        <A HREF="<%=context%>/UnitDocReaderServlet?op=ViewDocument&docType=<%=doc.getAttribute("docType")%>&docID=<%=doc.getAttribute("docID")%>&metaType=<%=doc.getAttribute("metaType")%>&projId=<%=projectID%>">
                                                            <%=docTitles[4]%>  
                                                        </A>
                                                        <IMG SRC="images/<%=fileDescriptor.getAttribute("iconFile")%>"  ALT="Document Image"> 
                                                    </DIV>
                                                </TD>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <%
                                }
                            %>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>     
