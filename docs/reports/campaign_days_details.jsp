<%-- 
    Document   : campaign_days_details
    Created on : Mar 3, 2019, 1:40:26 PM
    Author     : walid
--%>
<%@page import="oracle.net.aso.h"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<!DOCTYPE html>

<html> 
     <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext(); 
        String totalc,missC,AssC ,totalD,remainingD,lastD ,  dir ,style ,
            lang,langCode ,align ,dayRatio, completedCampaign,ratio,uncompletedCampaign,campaignState,clientRatio ,CampaignName,title;
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode , ratio1="",costRaito ,lemo="",less,more;
        String tCost,aCost,diff;
        int diff1=0; 
                String RDays=(String) request.getAttribute("RDays");
                 String lDays= (String) request.getAttribute("lDays");
                 String tDays= (String) request.getAttribute("tDays");
                 String targetCount=(String) request.getAttribute("targetCount");
                 String clientCount=(String) request.getAttribute("clientCount");
                 String campaignID1=(String) request.getAttribute("campaignID");
                 String campaignTitle=(String) request.getAttribute("campaignTitle");
                 String jsonText= (String) request.getAttribute("jsonText");
                 String jsonText2= (String) request.getAttribute("jsonText1");
                 String jsonText3= (String) request.getAttribute("jsonText3");
                 int SumEx=(int)request.getAttribute("SumEx"); 
                 int TotalCost=(int)request.getAttribute("TotalCost"); 
                 
                 int Rday=Integer.parseInt(RDays);
                 int lday=Integer.parseInt(lDays);
                 int tday=Integer.parseInt(tDays);
                         int missed=Integer.parseInt(targetCount)-Integer.parseInt(clientCount); 
                  int  clientCount1= Integer.parseInt(clientCount);
                   int  targetCount1= Integer.parseInt(targetCount);
                  if(Rday < 0)
                  {
                      Rday=0;
                      lday=tday;
                  }
                 if(missed <0)
                 {
                     missed=0;
                     
                 }
                  if (stat.equals("En")) {

                        align = "center";
                        dir = "LTR";
                        style = "text-align:left";
                        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                        langCode = "Ar";
                        totalc=" Targeted Clients";
                        missC="Missed ";
                        AssC ="Registered ";
                       totalD="Total Days";
                       remainingD="Remaining";
                       lastD="elapsed" ;
                       dayRatio="Days ";
                       clientRatio="Clients ";
                       CampaignName="Campaign Name";
                       title="Campaign Dashboard";
                       campaignState="Campaign";
                       completedCampaign="Finished ";
                       uncompletedCampaign="Ongoing ";
                       ratio="Achieved ";
                       costRaito="Cost ";
                       tCost=" Total Cost";
                       aCost=" Actual Cost";
                       diff="Difference";
                       less="More ";
                       more="Less  ";  
                  } else{
                            align = "center";
                            dir = "RTL";
                            style = "text-align:Right";
                            lang = "English";
                            langCode = "En";  
                             totalc=" العدد المستهدف ";
                        missC="العددالغير منجز ";
                        AssC ="العدد المنجز";
                       totalD="عدد الايام الكلى ";
                       remainingD="الايام الباقيه";
                       lastD="الايام المنقضيه" ;
                       dayRatio="نسبة اﻷيام ";
                       clientRatio="نسبة العملاء";
                       CampaignName="أسم الحملة";
                       title="لوحة قياسات الحمله";
                       campaignState="حالة الحملة";
                       completedCampaign="منتهيه ";
                       uncompletedCampaign=" نشطه";
                       ratio="نسبة الانجاز";
                       costRaito="نسبة التكلفه" ;
                       tCost="التكلفه الكليه للحملة ";
                       aCost= "التكلفه الفعليه للحمله";
                       diff="فرق التكلفه   ";
                       less="زائد";
                       more=" باقى "; 
                                }
                 
     %>
     <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
       
        <TITLE>Campaign Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.8.9.custom.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <script type="text/javascript" src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
       
        <script type="text/javascript">
              var chartD;
              var chartC;
               $(document).ready(function () {
                  
              var  chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    },
                    title: {
                        text: null
                    },
                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                        }
                    },
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            }
                        }
                    },
                    labels: {
                        style: {
                            color: 'black',
                            fontSize: '10px',
                            fontWeight: 'bold'
                        },
                        items: [{
                                html: '<%=dayRatio %>',
                                style: {
                                    left: '200px',
                                    top: '15px',
                                     fontSize: '15px',
                                    
                                }},
                            {
                                html:'<%=clientRatio %>',
                                style: {
                                    left: '560px',
                                    top: '15px',
                                    fontSize: '15px',
                                    
                                }},
                                    {
                                html: '<%=costRaito %>',
                                style: {
                                    left: '900px',
                                    top: '15px',
                                    fontSize: '15px',
                                    
                                }},
                            ]
                    },
                    series: [{
                            type: 'pie',
                            data: <%=jsonText%>,
                            center: ['20%']
                        }, {
                            type: 'pie',
                            data: <%=jsonText2%>,
                            center: ['50%']
                        }, {
                            type: 'pie',
                            data: <%=jsonText3%>,
                            center: ['80%']
                        }
                        
                        ]
                });
                 });
              
        </script>
        <style>
        .chart {
              height: 200px;
           }
        </style>
    </head>
    <body>
        <div style="margin-bottom: 50px;">
            <table dir="<%=dir%>"style="width: 40%;" align="<%=align%>">
               <tr >
                   <th class="blueBorder blueHeaderTD" style="font-size: 18px; width: 25%;" colspan="2">
                       <font color="#1A1A68" size="6px" ><%=title %></font>
                    </th>
                </tr>
                <tr >
                    
                        <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 25%;" >
                        <b>
                            <font size=3 color="white">
                          <%=CampaignName +" "%>   
                          </font>
                        </b>
                    </td>
                       
                    <td >
                        <font color="black" size="3" >
                                  <%=campaignTitle %>
                        </font>
                       
                    </td>
                </tr>
            </table>
       
                </div>  
      <div id="container" style="height: 300px;margin-bottom: 50px;"  ></div> 
      <DIV style="width: 30%; height: 400px;display: inline-block;">
             <TABLE dir="<%=dir%>" align="<%=align%>">
                 <thead>
                 <tr >
                 <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 25%;"><%= totalD%></TH>
                 
                 <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 25%;"><%= lastD %></TH>
                 <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 25%;"><%= remainingD %></TH>
                 <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 25%;"><%=campaignState%></th>
                 </tr>
                 </thead>
                 
                 <tbody>
                 <tr>
                 <td style="font-size: 15px"><%=tday %></td>
                 <td style="font-size: 15px"><%= lday %></Td>
                 <td style="font-size: 15px"><%= Rday %></Td>
                 <% if(tday==lday) {%>
                 <td style="font-size: 16px"><%=completedCampaign %> </td>
                 <%} else{  %>
                  <td style="font-size: 16px"> <%=uncompletedCampaign %></td>
                 <% } %>
                  </tr>
                 </tbody>
                 
             </TABLE>
         </DIV >
         <DIV style="width: 30%; height: 400px;display: inline-block;" >
             <TABLE dir="<%=dir%>" align="<%=align%>">
                 <thead>
                     <tr >
                 <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 23%;" ><%= totalc%></TH>
               
                 <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 23%;"><%= AssC %></TH>
                   <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 23%;"><%= missC %></TH>
                   <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 23%;"><%=ratio%></th>
                   
                 
                     </tr>
                 </thead>
                 
                 <tbody>
                     <tr>
                 <td style="font-size: 15px"><%=targetCount1 %></td>
                
                 <td style="font-size: 15px"><%= clientCount1 %></Td>
                  <td style="font-size: 15px"><%= missed %></Td>
                  <%
                       ratio1="0";
                       DecimalFormat f = new DecimalFormat("#.##");
                      if (targetCount1==0){
                          ratio1="--";
                      }
                      else 
                      {
                          float ratio5=(float)clientCount1/targetCount1;
                          ratio1=String.valueOf(ratio5);
                          
                      }
                      
                  %>
                  <td style="font-size: 15px"><%=ratio1 %> %</td>
                     </tr>
                 </tbody> 
             </TABLE>
         </DIV >
        <div style="width: 30%; height: 400px;display: inline-block;">
            <table dir="<%=dir%>" align="<%=align%>">
                  <tr >
                    <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 20%;"> <%=tCost%> </th>
                    <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 20%;"> <%=aCost%> </th>
                    <th class="blueBorder blueHeaderTD" style="font-size: 15px; width: 20%;"> <%=diff%> </th>
                </tr>
                <tr>
                    <td style="font-size: 15px"><%=TotalCost%></td>
                    <td style="font-size: 15px"><%=SumEx%></td>
                    <%
                        if(TotalCost-SumEx <0)
                        {
                            diff1=(TotalCost-SumEx )*-1; 
                            lemo=less;
                        }
                        else{
                            diff1=TotalCost-SumEx ;
                            lemo=more;
                        }
                     
                        
                       %>
                       <td dir='<%=dir%>' style="font-size: 15px"><%=lemo+" "+diff1%></td>
                </tr>
            </table>
            
        </div>

      
     
    </body>
</html>
