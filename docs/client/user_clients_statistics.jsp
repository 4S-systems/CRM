<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        String answered = "";
        String notAnswered = "";
        if (data != null && data.size() > 0) {
            WebBusinessObject wbo = (WebBusinessObject) data.get(0);
            if (wbo != null) {
                answered = wbo.getAttribute("Answered") + "";
                notAnswered = wbo.getAttribute("Not_Answered") + "";
            }
        }
        String bDate = (String) request.getAttribute("beginDate");
        String eDate = (String) request.getAttribute("endDate");
        String userID = (String) request.getAttribute("userID");
        String userName = (String) request.getAttribute("userName");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
        } else {
            align = "center";
            dir = "RTL";
        }
    %>

    <head>
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
    </head>
    <body>
        <form name="stat_form" method="POST">
            <fieldset class="set" style="width:96%; height: auto;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="100%" class="titlebar" style="font-size: 18px; font-weight: bolder;">
                            تحليل نسب عملاء الموظف: <font color="red"><%=userName%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/><br/>
                <%if (data != null && data.size() > 0) {%>
                <table align="center" dir="left" width="80%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4;">
                    <tr>
                        <td style="width:60%">
                            <div id="container" style="width: 80%; height: 400px; margin: 0 auto"></div>
                        </td>
                        <td style="width:40%">
                            <table align="center" dir="<%=dir%>" cellpadding="0" cellspacing="0" width="90%">
                                <tr bgcolor="#C8D8F8">
                                    <td style="width:50%">
                                        Answered
                                    </td>
                                    <td style="width:50%">
                                        Not Answered
                                    </td>
                                </tr>
                                <%
                                    WebBusinessObject wbo = (WebBusinessObject) data.get(0);
                                %>
                                <tr>
                                    <td>
                                        <%if (wbo.getAttribute("Answered").equals("0")) {%>
                                        <%=wbo.getAttribute("Answered")%>
                                        <%} else {%>
                                        <a href="<%=context%>/AppointmentServlet?op=showStatResultDetails&type=Answered&beginDate=<%=bDate%>&endDate=<%=eDate%>&departmentID=null&campaignID=0&userID=<%=userID%>"><%=wbo.getAttribute("Answered")%></a>
                                        <%}%>                                   
                                    </td>
                                    <td>
                                        <%if (wbo.getAttribute("Not_Answered").equals("0")) {%>
                                        <%=wbo.getAttribute("Not_Answered")%>                               
                                        <%} else {%>
                                        <a href="<%=context%>/AppointmentServlet?op=showStatResultDetails&type=Not_Answered&beginDate=<%=bDate%>&endDate=<%=eDate%>&departmentID=null&campaignID=0&userID=<%=userID%>"><%=wbo.getAttribute("Not_Answered")%></a>
                                        <%}%> 
                                    </td>
                                </tr>            
                            </table>
                        </td>
                    </tr>
                </table>
                <%}%>
                <br/>
                <br/>
            </fieldset>
        </form>
        <script language="JavaScript">
            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    },
                    title: {
                        text: 'Call Center Statistics'
                    },
                    xAxis: {
                        categories: ['Call Status']
                    },
                    labels: {
                        items: [{
                                style: {
                                    left: '0px',
                                    top: '0px',
                                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
                                }}]
                    },
                    series: [{type: 'column',
                            name: 'Answered',
                            data: [<%=answered%>]
                        }, {type: 'column',
                            name: 'Not Answered',
                            data: [<%=notAnswered%>]
                        }
                    ]
                });
            });
        </script>
    </body>
</html>