<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        ArrayList<WebBusinessObject> projectsCampaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsCampaignsList");
        Map<String, ArrayList<WebBusinessObject>> campaignProjectsMap = (Map<String, ArrayList<WebBusinessObject>>) request.getAttribute("campaignProjectsMap");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style, title, campaignTitle, fromDate, toDate, display, total;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Projects' Campaigns Statistics";
            campaignTitle = "Campaign";
            fromDate = "Start Date";
            toDate = "End Date";
            display = "Display";
            total = "Total";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "أحصائيات حملات المشاريع";
            campaignTitle = "الحملة";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            total = "أجمالي";
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css" />
        <script type="text/javascript" src="js/jquery-1.12.4.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript">
            $(function () {
            });
            $(document).ready(function () {
                oTable = $('#projectsCampaigns').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[-1], ["All"]],
                    "pageLength": -1
                }).fadeIn(2000);
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function submitForm() {
                document.project_campaign_form.action = "<%=context%>/ReportsServletThree";
                document.project_campaign_form.submit();
            }
        </script>
    </head>
    <body>
        <form name="project_campaign_form" action="post">
            <div align="left" STYLE="color:blue;">
                <input type="button"  value="<%=display%>"  onclick="submitForm()" class="button"/>
                <input type="hidden" name="op" value="getProjectsCampaignsReport"/>
            </div>  
            <br /><br />
            <fieldset align=center class="set" >
                <legend align="center"> 
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend >
                <table class="blueBorder" align="<%=align%>" dir="<%=dir%>" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width:1px;border-color:white;display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                </table>
                <br /><br/>
                <center>
                    <div style="width: 90%;">
                        <table id="projectsCampaigns" width="100%" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0">
                            <thead>
                                <tr bgcolor="#C8D8F8">
                                    <th>
                                        <%=campaignTitle%>
                                    </th>
                                    <%
                                        for (WebBusinessObject projectWbo : projectsList) {
                                            projectWbo.setAttribute("total", new Integer(0));
                                    %>
                                    <th>
                                        <%=projectWbo.getAttribute("projectName")%>
                                    </th>
                                    <%
                                        }
                                    %>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    ArrayList<WebBusinessObject> tempList;
                                    String preCampaignTitle = "";
                                    for (WebBusinessObject wbo : projectsCampaignsList) {
                                        tempList = campaignProjectsMap.get((String) wbo.getAttribute("id"));
                                        if (!preCampaignTitle.equals(wbo.getAttribute("campaignTitle"))) {
                                            preCampaignTitle = (String) wbo.getAttribute("campaignTitle");
                                %>
                                <tr>
                                    <td>
                                        <%=wbo.getAttribute("campaignTitle")%>
                                    </td>
                                    <%
                                        for (WebBusinessObject projectWbo : projectsList) {
                                    %>
                                    <td>
                                        <%
                                            if (tempList != null && tempList.contains((String) projectWbo.getAttribute("projectID"))) {
                                                projectWbo.setAttribute("total", ((Integer) projectWbo.getAttribute("total")) + 1);
                                        %>
                                        <img src="images/accept.png" style="width: 30px;"/>
                                        <%
                                            }
                                        %>
                                        &nbsp;
                                    </td>
                                    <%
                                        }
                                    %>
                                </tr>      
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                            <tfoot>
                                <tr bgcolor="#C8D8F8">
                                    <th>
                                        <%=total%>
                                    </th>
                                    <%
                                        for (WebBusinessObject projectWbo : projectsList) {
                                    %>
                                    <th>
                                        <%=projectWbo.getAttribute("total")%>
                                    </th>
                                    <%
                                        }
                                    %>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    <br />
                    <br />
                </center>
            </fieldset>
        </form>
    </body>
</html>     
