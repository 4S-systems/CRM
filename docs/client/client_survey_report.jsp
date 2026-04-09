<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsListTitles = new String[2];
        ArrayList<LiteWebBusinessObject> clientSurveyList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("clientSurveyList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Satisfaction Average";
            clientsListTitles[1] = "Survey Question";
        } else {
            align = "center";
            xAlign = "left";
            dir = "LTR";
            clientsListTitles[0] = "متوسط رضاء العملاء";
            clientsListTitles[1] = "موضوع الأستقصاء";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[1, "asc"]]
                }).fadeIn(2000);
            });
        </script>
        <style type="text/css">
        </style>
    </head>
    <body>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Clients Survey Report التقرير الأستقصائي للعملاء</b>
        <fieldset align=center class="set" style="width: 90%">
            <form name="CLIET_SURVEY_FORM" action="" method="POST">
                <br/>
                <div style="width: 60%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <table align="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <%
                                    for (int i = 0; i < clientsListTitles.length; i++) {
                                %>                
                                <th>
                                    <b><%=clientsListTitles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (LiteWebBusinessObject clientSurveyWbo : clientSurveyList) {
                            %>
                            <tr>
                                <td>
                                    <div class="rateit" data-rateit-value="<%=clientSurveyWbo.getAttribute("average")%>" data-rateit-ispreset="true" data-rateit-readonly="true" style="font-size:30px" data-rateit-mode="font"></div>
                                </td>
                                <td>
                                    <div>
                                        <b dir="ltr" style="cursor: hand; float: right;"><%=clientSurveyWbo.getAttribute("question")%></b>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>
