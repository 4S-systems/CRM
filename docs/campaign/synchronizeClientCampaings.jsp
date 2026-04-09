<%-- 
    Document   : synchronizeClientCampaings
    Created on : Mar 19, 2018, 10:17:30 AM
    Author     : fatma
--%>

<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String crbr = request.getAttribute("crbr") != null ? (String) request.getAttribute("crbr") : "0";
    String cmpnActvClntCmpn = request.getAttribute("cmpnActvClntCmpn") != null ? (String) request.getAttribute("cmpnActvClntCmpn") : "1";
    ArrayList<WebBusinessObject> campaignsList = request.getAttribute("campaignsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList") : null;
    String [] campaigns = request.getAttribute("campaigns") != null ?(String []) request.getAttribute("campaigns") : null;
    ArrayList<WebBusinessObject> syncRtClntCmpnLst = (ArrayList<WebBusinessObject>)request.getAttribute("syncRtClntCmpnLst");
    
    Calendar cal = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String fromDate = request.getAttribute("fromDate") != null ? (String) request.getAttribute("fromDate") : sdf.format(cal.getTime());
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String ttl, campaignStr, shw, cmpnActvStr, clntCmpnStr, dir;
    if (stat.equals("En")) {
        ttl = " Synchronize Client Campaings ";
        campaignStr = " Campaign ";
        shw = " Show ";
        cmpnActvStr = " Campaign Activity ";
        clntCmpnStr = " Client Campaign ";
        
        dir = "ltr";
    } else {
        ttl = " تزامن عملاء الحملات ";
        campaignStr = " الحملة ";
        shw = " إعرض ";
        cmpnActvStr = " نشاط الحملات ";
        clntCmpnStr = " حملات العملاء ";
        
        dir = "rtl";
    }
%>

<html>
    <head>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        
        <script src="js/amcharts/amcharts.js"></script>
        <script src="js/amcharts/serial.js"></script>
        <script src="js/amcharts/gantt.js"></script>
        <script src="js/amcharts/plugins/export/export.min.js"></script>
        <link rel="stylesheet" href="js/amcharts/plugins/export/export.css" type="text/css" media="all" />
        <script src="js/amcharts/themes/light.js"></script>
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <style>
            #chartdiv {
              width: 100%;
              height: 500px;
            }
        </style>
        
        <script type="text/javascript">
            $(document).ready(function () {
                $("#campaignsselect").select2();
           
                <%
                    if(cmpnActvClntCmpn != null && cmpnActvClntCmpn.equalsIgnoreCase("0")){
                %>
                        var chart = AmCharts.makeChart( "chartdiv", {
                             "type": "gantt",
                             "mouseWheelScrollEnabled" : true,
                             "mouseWheelZoomEnabled": true,
                             "marginRight": 50,
                             "marginLeft": 50,
                             "period": "DD",
                             "dataDateFormat": "YYYY-MM-DD",
                             "columnWidth": 0.5,
                             "valueAxis": {
                                "type": "date"
                            },
                            "brightnessStep": 0,
                            "graph": {
                                "fillAlphas": 1,
                                "lineAlpha": 1,
                                //"lineColor": "#fff",
                                "fillAlphas": 1,
                                "balloonText": "<b>[[campaign]]</b>:<br />[[open]] : [[value]]"
                            },
                            "rotate": true,
                            "categoryField": "campaign",
                            "segmentsField": "segments",
                            //"colorField": "color",
                            "startDateField": "start",
                            "endDateField": "end",
                            "dataProvider": [
                                <%
                                    for (int i=0; i<syncRtClntCmpnLst.size(); i++) {
                                        WebBusinessObject syncRtClntCmpnWbo = syncRtClntCmpnLst.get(i);
                                %>
                                        {"campaign": "<%=syncRtClntCmpnWbo.getAttribute("task")%>",
                                            <%
                                                if(syncRtClntCmpnWbo.getAttribute("start") != null && syncRtClntCmpnWbo.getAttribute("end") != null){
                                            %>
                                                    "segments": [ {
                                                        "start": "<%=syncRtClntCmpnWbo.getAttribute("start") != null ? syncRtClntCmpnWbo.getAttribute("start") : ""%>",
                                                        "end": "<%=syncRtClntCmpnWbo.getAttribute("end") != null ? syncRtClntCmpnWbo.getAttribute("end") : ""%>",
                                                        //"color": "#b9783f",
                                                        "campaign": "<%=syncRtClntCmpnWbo.getAttribute("task")%>"
                                                    } ]
                                            <%
                                                }
                                            %>
                                <%
                                        if(i<syncRtClntCmpnLst.size()-1){
                                %>
                                        },
                                <%
                                        } else {
                                %>
                                            }
                                <%
                                        }
                                    }
                                %>
                            ],
                            "valueScrollbar": {
                                "autoGridCount": true
                             },
                            "chartCursor": {
                                "cursorColor": "#2E86C1",
                                "valueBalloonsEnabled": true,
                                "cursorAlpha": 1,
                                "valueLineAlpha": 1,
                                "valueLineBalloonEnabled": true,
                                "valueLineEnabled": true,
                                "zoomable": true,
                                "valueZoomable": true
                            },
                            "export": {
                                "enabled": true
                            },"listeners":[{
                                "event": "rollOverGraphItem",
                                "method": function (event) {
                                  changeStroke(event, 5);
                                }
                            },{
                                "event": "rollOutGraphItem",
                                "method": function (event) {
                                  changeStroke(event, 1);
                                }     
                            }]
                        });
                <%
                    } else {
                %>
                        var chart = AmCharts.makeChart( "chartdiv", {
                             "type": "gantt",
                             "mouseWheelScrollEnabled" : true,
                             "mouseWheelZoomEnabled": true,
                             "marginRight": 50,
                             "marginLeft": 50,
                             "period": "DD",
                             "dataDateFormat": "YYYY-MM-DD",
                             "columnWidth": 0.5,
                             "valueAxis": {
                                "type": "date"
                            },
                            "brightnessStep": 0,
                            "graph": {
                                "fillAlphas": 1,
                                "lineAlpha": 1,
                                //"lineColor": "#fff",
                                "fillAlphas": 1,
                                "balloonText": "<b>[[campaign]]</b>:<br />[[open]] : [[value]]"
                            },
                            "rotate": true,
                            "categoryField": "campaign",
                            "segmentsField": "segments",
                            //"colorField": "color",
                            "startDateField": "start",
                            "endDateField": "end",
                            "dataProvider": [
                                <%
                                    String cmp = "false";
                                    for (int i=0; i<syncRtClntCmpnLst.size(); i++) {
                                        WebBusinessObject syncRtClntCmpnWbo = syncRtClntCmpnLst.get(i);
                                %>
                                        <%
                                            if(i == 0 || cmp.equals("false")){
                                        %>    
                                                {"campaign": "<%=syncRtClntCmpnWbo.getAttribute("task")%>",
                                                    "segments": [
                                        <%
                                            }
                                        %>
                                            {
                                                "start": "<%=syncRtClntCmpnWbo.getAttribute("start") != null ? syncRtClntCmpnWbo.getAttribute("start") : fromDate%>",
                                                "end": "<%=syncRtClntCmpnWbo.getAttribute("end") != null ? syncRtClntCmpnWbo.getAttribute("end") : fromDate%>",
                                                //"color": "#b9783f",
                                                "campaign": "<%=syncRtClntCmpnWbo.getAttribute("task")%>"
                                        <%
                                            if(i<syncRtClntCmpnLst.size()-1 && syncRtClntCmpnLst.get(i+1).getAttribute("cmpnId").equals(syncRtClntCmpnWbo.getAttribute("cmpnId").toString())){
                                                cmp = "true";
                                        %>    
                                                },
                                        <%
                                            } else {
                                                cmp = "false";
                                        %>
                                                    }
                                        <%
                                            }
                                        %>
                                <%
                                        if(cmp.equals("true")){
                                %>
                                <%
                                        }else if(i<syncRtClntCmpnLst.size()-1 || cmp.equals("false")){
                                %>
                                            ]},
                                <%
                                        } else if(i == syncRtClntCmpnLst.size()-1 || cmp.equals("false")){
                                %>
                                            ]}
                                <%
                                        }
                                    }
                                %>
                            ],
                            "valueScrollbar": {
                                "autoGridCount": true
                             },
                            "chartCursor": {
                                "cursorColor": "#2E86C1",
                                "valueBalloonsEnabled": true,
                                "cursorAlpha": 1,
                                "valueLineAlpha": 1,
                                "valueLineBalloonEnabled": true,
                                "valueLineEnabled": true,
                                "zoomable": true,
                                "valueZoomable": true
                            },
                            "export": {
                                "enabled": true
                            },"listeners":[{
                                "event": "rollOverGraphItem",
                                "method": function (event) {
                                  changeStroke(event, 5);
                                }
                            },{
                                "event": "rollOutGraphItem",
                                "method": function (event) {
                                  changeStroke(event, 1);
                                }     
                            }]
                        });
                <%
                    }
                %>
            });
            
            function changeStroke(event, strokeWidth) {
                var elements = event.item.columnGraphics.node.getElementsByTagName("path");
                for(var i = 0; i < elements.length; i++) {
                    elements[i].setAttribute("stroke-width", strokeWidth);
                } 
            }
        </script>
    </head>
    
    <body>
        <FIELDSET class="set" style="width: 99%; border-color: #006699">
            <form name="syncClntCmpRprt" action="<%=context%>/ReportsServletThree?op=synchronizeCampaignClients" method="POST">
                <table align="center" width="100%" style="margin-bottom: 2%;">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                                 <%=ttl%> 
                            </font>
                        </td>
                    </tr>
                </table>
                
                <%
                    if(crbr == null || crbr.equalsIgnoreCase("0")){
                %>
                        <table class="blueBorder" align="center" dir="<%=dir%>" width="50%" STYLE="border-width: 1px; border-color: white;" >
                            <tr>
                                <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 25%;" colspan="1">
                                    <b>
                                        <font size=3 color="white">
                                             <%=campaignStr%> 
                                    </b>
                                </td>
                                
                                <td style="text-align: center;" bgcolor="#dedede" colspan="4">
                                    <select name="campaignsselect" id="campaignsselect" style="width: 95%;" multiple="multiple">
                                        <%
                                            if(campaigns != null && campaigns.length>0){
                                                for(WebBusinessObject campaignWbo : campaignsList) {
                                                    String selected = "0";
                                                    for(int i=0; i<campaigns.length; i++) {
                                                        if(campaigns[i].equals(campaignWbo.getAttribute("id"))){
                                                            selected = "1";
                                                            break;
                                                        } else {
                                                        }
                                                    }
                                        %>
                                                        <option value="<%=campaignWbo.getAttribute("id")%>" <%=selected != null && selected.equals("1") ? "selected" : ""%>><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                        <%
                                                }
                                            } else {
                                                for(WebBusinessObject campaignWbo : campaignsList) {
                                        %>
                                                    <option value="<%=campaignWbo.getAttribute("id")%>"><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>   
                                </td>
                            </tr>
                            <tr>    
                                <td style="text-align: center;" bgcolor="#dedede" colspan="">
                                    <input type="submit" value="<%=shw%>" style="width: 90%;">
                                </td>
                                
                                <td style="text-align: center;" bgcolor="#dedede" style="font-size: 18px; width: 16%;">
                                    <input type="radio" name="cmpnActvClntCmpn" id="cmpnActv" value="1" <%=cmpnActvClntCmpn.equalsIgnoreCase("1") ? "checked" : ""%>>
                                </td>
                                
                                <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 34%;">
                                    <b>
                                        <font size=3 color="white">
                                             <%=cmpnActvStr%> 
                                    </b>
                                </td>
                                
                                <td style="text-align: center;" bgcolor="#dedede" style="font-size: 18px; width: 16%;">
                                    <input type="radio" name="cmpnActvClntCmpn" id="clntCmpn" value="0" <%=cmpnActvClntCmpn.equalsIgnoreCase("0") ? "checked" : ""%>>
                                </td>
                                
                                <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 34%;">
                                    <b>
                                        <font size=3 color="white">
                                             <%=clntCmpnStr%> 
                                    </b>
                                </td>
                            </tr>
                        </TABLE>
                <%
                    }
                %>
                <% int divHeight = campaigns != null && campaigns.length > 0 ? campaigns.length*20 : 100; %>
                <div id="chartdiv" style="height: <%=divHeight%>%; width: 100%;"></div>
            </form>
        </fieldset>
    </body>
</html>