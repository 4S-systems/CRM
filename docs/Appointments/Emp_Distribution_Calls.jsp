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

        String bDate = (String) request.getAttribute("beginDate");
        String eDate = (String) request.getAttribute("endDate");
        String userName = (String) request.getAttribute("userName");
        String userID = (String) request.getAttribute("userID");
        String TypeTag = (String) request.getAttribute("TypeTag");

        String jsonText = (String) request.getAttribute("jsonText");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
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
        <title>Call Center Statistics</title>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </head>

    <body>
        <div align="left" STYLE="color:blue; margin-left: 50px;">
            <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
        </div>

        <br/><br/>

        <div style="width: 100%; text-align: center; direction: rtl">
            <font size="3">مكالمات الموظف : </font><b><font size="3" color="red"><%=userName%></font></b>
            <br>
            <br>
            <font size="3"> في الفترة من </font><b><font size="3" color="red"><%=bDate%></font></b><font size="3">الى  </font><b><font size="3" color="red"><%=eDate%></font></b>
        </div> 
        <br/>
        <br/>

        <% if (data != null && !data.isEmpty()) {
                WebBusinessObject wbo = (WebBusinessObject) data.get(0);

                String answered = wbo.getAttribute("ANSWERED").toString();
                String notAnswered = wbo.getAttribute("NOT_ANSWERED").toString();
                String planedCalls = wbo.getAttribute("PLANED_CALLS").toString();
        %>

        <TABLE ALIGN="center" dir="left" WIDTH="60%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
            <tr>
                <td>
                    <br>
                    <div id="container" style="width: 80%; height: 400px; margin: 0 auto"></div>
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
                                    text: 'Employee Call Statistics'
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
                                    },
                                    {type: 'column',
                                        name: 'Planed Calls',
                                        data: [<%=planedCalls%>]
                                    }
                                ]
                            });
                        });
                    </script>

                    <br>
                    <br>

                    <TABLE ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="90%">
                        <TR  bgcolor="#C8D8F8">
                            <TD style="width:35%">
                                Answered
                            </TD>
                            <TD style="width:35%">
                                Not Answered
                            </TD>
                            <TD style="width:30%">
                                Planed Calls
                            </TD>
                        </TR>

                        <TR>
                            <TD>
                                <%if (answered.equals("0")) {%>
                                <%=answered%>
                                <%} else {%>
                                <%=answered%>
                                <%}%>                                   
                            </TD>
                            <TD>
                                <%if (notAnswered.equals("0")) {%>
                                <%=notAnswered%>                               
                                <%} else {%>   
                                <%=notAnswered%>
                                <%}%> 
                            </TD>
                            <TD>
                                <%if (planedCalls.equals("0")) {%>
                                <%=planedCalls%>                               
                                <%} else {%>
                                <%=planedCalls%>
                                <%}%> 
                            </TD>
                        </TR>            
                    </TABLE>
                    <br>
                </td>
            </tr>
        </table>
        <%} else {%>
        لا يوجد مكالمات
        <%}%>

    <CENTER>
</html>
