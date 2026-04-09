<%-- 
    Document   : communicationChannelsComparison
    Created on : Apr 19, 2018, 12:12:24 PM
    Author     : fatma
--%>

<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> cmntChnlCmprLst = request.getAttribute("cmntChnlCmprLst") != null ? (ArrayList<WebBusinessObject>)request.getAttribute("cmntChnlCmprLst") : null;
    ArrayList<WebBusinessObject> chnlLst = request.getAttribute("chnlLst") != null ? (ArrayList<WebBusinessObject>)request.getAttribute("chnlLst") : null;
    
    String[] chnls = request.getAttribute("chnls") != null ?(String []) request.getAttribute("chnls") : null;
    
    String yr = request.getAttribute("yr") != null ?(String) request.getAttribute("yr") : "";
    String mnth = request.getAttribute("mnth") != null ?(String) request.getAttribute("mnth") : "";
    int Cyear = Calendar.getInstance().get(Calendar.YEAR);
    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir, chnlStr, shw, yrStr, mnthStr, msgErr, title;
    if (stat.equals("En")) {
        dir = "ltr";
        
        chnlStr = " Campiagns ";
        shw = " Show ";
        yrStr = " Year ";
        mnthStr = " Month ";
        msgErr = " No Data To Display ";
        title = "Campaigns Comparison";
    } else {
        dir = "rtl";
        
        chnlStr = "الحملات";
        shw = " إعرض ";
        yrStr = " السنة ";
        mnthStr = " الشهر ";
        msgErr = " لا يوجد بيانات لعرضها ";
        title = "مقارنة الحملات";
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("MMM-yy");
    Date date1 = new Date();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Campaigns Comparison</title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <script src="js/amcharts/amcharts.js"></script>
        <script src="js/amcharts/serial.js"></script>
        <script src="js/amcharts/plugins/export/export.min.js"></script>
        <link rel="stylesheet" href="js/amcharts/plugins/export/export.css" type="text/css" media="all" />
        <script src="js/amcharts/themes/light.js"></script>

        <style>
            #chartdiv {
              width: 100%;
              height: 500px;
            }
        </style>
        
        <script>
            $(document).ready(function(){
                $("#chnlsSelect").select2();
            });

            <%
                if(cmntChnlCmprLst != null && cmntChnlCmprLst.size() > 0){
            %>
                    var chart = AmCharts.makeChart("chartdiv", {
                        "theme": "light",
                        "type": "serial",
                        "sortColumns": true,
                        "categoryField": "date",
                        "columnWidth": 1,
                        "dataProvider": [
                            <%
                                for(int i=0; i<cmntChnlCmprLst.size(); i++){
                            %>
                                    {
                                        "date": "<%=cmntChnlCmprLst.get(i).getAttribute("year")%>",
                                        "<%=cmntChnlCmprLst.get(i).getAttribute("arbNm")%>" : "<%=cmntChnlCmprLst.get(i).getAttribute("clntCnt")%>"
                                        <%
                                            while(i != cmntChnlCmprLst.size()-1 && cmntChnlCmprLst.get(i).getAttribute("year").equals(cmntChnlCmprLst.get(i+1).getAttribute("year"))){
                                                i++;
                                        %>
                                                ,"<%=cmntChnlCmprLst.get(i).getAttribute("arbNm")%>" : "<%=cmntChnlCmprLst.get(i).getAttribute("clntCnt")%>"
                                        <%
                                            }
                                        %>
                                    }
                                    <%
                                        if(i != cmntChnlCmprLst.size()-1){
                                    %>
                                             ,
                                    <%
                                        }
                                    %>
                            <%
                                }
                            %>],
                        "valueScrollbar": {
                            "autoGridCount": true
                        },
                        "valueAxes": [{
                            //"stackType": "3d",
                            "axisAlpha": 100,
                            "position": "left",
                            "title": "Campaigns Comparison",
                        }],
                        "startDuration": 1,
                        "graphs": [
                            <%
                                for(int i=0; i<chnlLst.size(); i++){
                            %>
                                    {
                                        "balloonText": "<b>[[category]]</b> <br> <%=chnlLst.get(i).getAttribute("campaignTitle")%> : <b>[[value]]</b>",
                                        "fillAlphas": 1,
                                        "lineAlpha": 1,
                                        "title": "<%=chnlLst.get(i).getAttribute("campaignTitle")%>",
                                        "type": "column",
                                        "valueField": "<%=chnlLst.get(i).getAttribute("campaignTitle")%>"
                                    }
                                    <%
                                        if(i != chnlLst.size()-1){
                                    %>      
                                            ,
                                    <%
                                        }
                                    %>
                            <%
                                }
                            %>
                        ],
                        "plotAreaFillAlphas": 1,
                        "depth3D": 25,
                        "angle": 25,
                        "export": {
                            "enabled": true
                        }
                    });
            <%
                }
            %>
        </script>
    </head>
    
    <body>
        <form name="communicationChannelsComparison" action="<%=context%>/ClientServlet?op=campaignsComparison" method="POST">
            <table class="blueBorder" align="center" width="80%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueBorder blueHeaderTD">
                        <font color="white" size="4"><%=title%></font>
                    </td>
                </tr>
            </table>
            <br/>
            <table class="blueBorder" align="center" dir="<%=dir%>" width="50%" STYLE="border-width: 1px; border-color: white;" >
                <tr>
                    <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 25%;" colspan="2">
                        <b>
                            <font size=3 color="white">
                                 <%=chnlStr%> 
                        </b>
                    </td>

                    <td style="text-align: center; width: 50%;" bgcolor="#dedede" colspan="2">
                        <select name="chnlsSelect" id="chnlsSelect" style="width: 95%;" multiple="multiple">
                            <%
                                if(chnls != null && chnls.length>0){
                                    for(WebBusinessObject campaignWbo : chnlLst) {
                                        String selected = "0";
                                        for(int i=0; i<chnls.length; i++) {
                                            if(chnls[i].equals(campaignWbo.getAttribute("id"))){
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
                                    for(WebBusinessObject chnlWbo : chnlLst) {
                            %>
                                        <option value="<%=chnlWbo.getAttribute("id")%>"><%=chnlWbo.getAttribute("campaignTitle")%></option>
                            <%
                                    }
                                }
                            %>
                        </select>   
                    </td>

                    <td style="text-align: center; width: 25%;" bgcolor="#dedede" rowspan="2">
                        <input type="submit" class="button" value="<%=shw%>" style="width: 90%;">
                    </td>
                </tr>
                
                <tr>
                    <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 12%;">
                        <b>
                            <font size=3 color="white">
                                 <%=yrStr%> 
                        </b>
                    </td>

                    <td style="text-align: center; width: 25%;" bgcolor="#dedede">
                        <select name="yrSelect" id="yrSelect" style="width: 95%;" >
                            <option value="" <%=yr == null || yr.equals("") ? "selected" : ""%>> All </option>
                               <% 
                                    for (int i=2016 ;i<= Cyear ;i++ ) {
                                    String vs=String.valueOf(i);
                               %>
                                      <option value="<%=vs%>" <%=yr != null && yr.equals(vs) ? "selected" : ""%>> <%=vs%> </option>

                              <% } %>
                      <!--      <option value="2017" <%=yr != null && yr.equals("2017") ? "selected" : ""%>> 2017 </option>
                            <option value="2018" <%=yr != null && yr.equals("2018") ? "selected" : ""%>> 2018 </option>
                            <option value="2019" <%=yr != null && yr.equals("2019") ? "selected" : ""%>> 2019 </option>
-->
                        </select>   
                    </td>
                    
                    <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 12%;">
                        <b>
                            <font size=3 color="white">
                                 <%=mnthStr%> 
                        </b>
                    </td>

                    <td style="text-align: center; width: 26%;" bgcolor="#dedede">
                        <select name="mnthSelect" id="mnthSelect" style="width: 95%;" >
                            <option value="" <%=mnth == null || mnth.equals("") ? "selected" : ""%>> All </option>
                            <option value="01" <%=mnth != null && mnth.equals("01") ? "selected" : ""%>> JAN </option>
                            <option value="02" <%=mnth != null && mnth.equals("02") ? "selected" : ""%>> FEB </option>
                            <option value="03" <%=mnth != null && mnth.equals("03") ? "selected" : ""%>> MAR </option>
                            <option value="04" <%=mnth != null && mnth.equals("04") ? "selected" : ""%>> APR </option>
                            <option value="05" <%=mnth != null && mnth.equals("05") ? "selected" : ""%>> MAY </option>
                            <option value="06" <%=mnth!= null && mnth.equals("06") ? "selected" : ""%>> JUN </option>
                            <option value="07" <%=mnth != null && mnth.equals("07") ? "selected" : ""%>> JUL </option>
                            <option value="08" <%=mnth != null && mnth.equals("08") ? "selected" : ""%>> AUG </option>
                            <option value="09" <%=mnth != null && mnth.equals("09") ? "selected" : ""%>> SEP </option>
                            <option value="10" <%=mnth != null && mnth.equals("10") ? "selected" : ""%>> OCT </option>
                            <option value="11" <%=mnth != null && mnth.equals("11") ? "selected" : ""%>> NOV </option>
                            <option value="12" <%=mnth != null && mnth.equals("12") ? "selected" : ""%>> DEC </option>
                        </select>   
                    </td>
                </tr>
            </TABLE>
            
            <div style="display: <%=cmntChnlCmprLst == null || cmntChnlCmprLst.size() == 0 ? "block" : "none"%>; width: 100%; padding: 5%;">
                <label>
                    <font style="color: red; font-weight: bolder; font-size: 25px;">
                         <%=msgErr%> 
                </label>
            </div>
            
            <div id="chartdiv"></div>
        </form>
    </body>
</html>
