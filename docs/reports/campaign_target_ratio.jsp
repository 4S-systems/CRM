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

<HTML>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> campaignClientsCounts = (ArrayList<WebBusinessObject>) request.getAttribute("campaignClientsCounts");
        int totalClientsCount = 0;
        if (request.getAttribute("totalClientsCount") != null) {
            totalClientsCount = (Integer) request.getAttribute("totalClientsCount");
        }
        String jsonText = (String) request.getAttribute("jsonText");
        String startDateVal = request.getAttribute("startDate") == null ? "" : (String) request.getAttribute("startDate");
        String endDateVal = request.getAttribute("endDate") == null ? "" : (String) request.getAttribute("endDate");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
         float clientEC=0; 
         float clientEC1=0; 
         float clientEC2=0; 
        String lang, langCode,ClientExpCost,totalCost,ClientRealCost,divCost,   title, clientsCountStr,objectiveClientsCountStr, campaignStr, startDate, endDate, display, RatesStr, source, responsible, view,
                soldCountStr,diff1, diff2,campaignEffective, campaignDate;
        int totalclients = 0;
        if (campaignClientsCounts != null) {
            totalclients = campaignClientsCounts.size();
        }
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            diff1="more";
            diff2="less";
   
            title = "Campaign objective Ratio";
            campaignStr = "Campaign";
            clientsCountStr = "Actull Clients Count";
            objectiveClientsCountStr="Targeted Clients Count";
            startDate = "Start Date";
            endDate = "End Date";
            display = " Generate Report ";
            RatesStr = "Client Rates";
            source = "Source Statistics";
            responsible = "Responsible Statisitics";
            view = "View";
            soldCountStr = "Sold Count";
            campaignEffective = "Target Achieved Ratio ";
            campaignDate = "Client Creation Date";
            ClientExpCost="Client Expected Cost";
            ClientRealCost="Client Real Cost";
            totalCost="Total Cost"; 
            divCost="Diviation Cost";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "نسبة تحقيق هدف الحملة";
            campaignStr = "الحملة";
            objectiveClientsCountStr="عدد العملاء المستهدفين";
            clientsCountStr = "عدد العملاء الفعليين";
            startDate = "من تاريخ";
            endDate = "ألي تاريخ";
            display = "أعرض التقرير";
            RatesStr = "توزيعة العملاء";
            source = "أحصائيات المصدر";
            responsible = "أحصائيات المسؤول";
            view = "أعرض";
            diff1="اكتر";
            diff2="اقل";
            totalCost="التكلفه الكليه";
            soldCountStr = "المبيعات";
            campaignEffective = "نسبة تحقيق الهدف";
            campaignDate = "تاريخ انشاء الحمله";
            ClientExpCost="التكلفه المتوقعه للعميل";
            ClientRealCost="التكلفه الفعليه للعميل";
            divCost="فرق التكلفه";
            
        }

        String campaignType = request.getAttribute("campaignType") != null ? (String) request.getAttribute("campaignType") : "all";

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Equipment Statistics</TITLE>
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
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            var totalselectedclients = 0;
            var actualtotalclients =<%=totalclients%>;
            var counter = 0;
            function toggle(source) {
                totalselectedclients = 0;
                counter = 0;
                $(".campaignschck").each(function () {
                    this.checked = source.checked;
                    totalselectedclients = Number(totalselectedclients) + Number(this.value);
                });
                if (!source.checked)
                {
                    totalselectedclients = 0;
                    counter = 0;
                }
                else {
                    counter = actualtotalclients;
                }

                $("#totalclients").text(totalselectedclients);

            }
            $(function () {
                $("#selectall").trigger('click');
                $(".campaignschck").click(function () {
                    if (this.checked)
                    {
                        counter++;
                        totalselectedclients = Number(totalselectedclients) + Number(this.value);
                    }
                    else
                    {
                        counter--;
                        totalselectedclients = Number(totalselectedclients) - Number(this.value);
                    }
                    $("#totalclients").text(totalselectedclients);
                    if (counter == 0) {
                        $("#selectall").prop("checked", false);
                    }
                    else if (counter == actualtotalclients) {
                        $("#selectall").prop("checked", true)
                    }
                    ;
                    ;
                });

                $("#startDate,#endDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            /* preparing pie chart */
            var chart;
            $(document).ready(function () {

              

                chart = new Highcharts.Chart({
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
                                enabled: true,
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            }
                        }
                    },
                    series: [{
                            type: 'pie',
                            data: <%=jsonText%>
                        }]
                });
            });
            /* -preparing pie chart */
        </script>
        <style>
            .fSize {
                font-size: 16px;
            }
            a.fSize:hover {
                font-size: 16px;
            }
        </style>
    </HEAD>
    <script language="javascript" type="text/javascript">
        function changePage(url) {
            window.navigate(url);
        }

        function reloadAE(nextMode) {

            var url = "<%=context%>/ajaxGetItrmName?key=" + nextMode;
            if (window.XMLHttpRequest)
            {
                req = new XMLHttpRequest();
            }
            else if (window.ActiveXObject)
            {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post", url, true);
            req.onreadystatechange = callbackFillreload;
            req.send(null);

        }
        function submitForm()
        {
            document.Stat1.action = "<%=context%>/ReportsServletThree?op=campaignOpjactiveRatioReport";
            document.Stat1.submit();
        }
        /*function exportToExcel() {
            openInNewWindow("<%=context%>/ReportsServletThree?op=campaignClientsReport&excel=true&startDate="
                    + $("#startDate").val() + "&endDate=" + $("#endDate").val() + "&campaignType="
                    + $('input[name="campaignType"]:checked').val() + "&campaignTypeRadio=" + $("#campaignTypeRadio").val());
        }*/
        var divTag;
        function showChart(campaignID, type) {
            openInNewWindow("<%=context%>/ReportsServletThree?op=campaignUsersRatioReport&campaignID=" + campaignID + "&type=" + type + "&startDate=" + $("#startDate").val() + "&endDate" + $("#endDate").val());
        }
        function openInNewWindow(url) {
            var win = window.open(url, '_blank');
            win.focus();
        }
    </script>
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <div id="usersRationDiv"></div>
        <FORM name="Stat1" id="State1"  action = "<%=context%>/ReportsServletThree?op=campaignOpjactiveRatioReport"method="POST">
            <FIELDSET align=center class="set" >
                <legend align="center"> 
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                    <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                            <b title="<%=campaignDate%>"><font size=3 color="white"> <%=startDate%></b>
                        </TD>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                            <b title="<%=campaignDate%>"><font size=3 color="white"> <%=endDate%></b>
                        </TD>
                    </TR>
                    <TR>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                                   value="<%=startDateVal%>" title="<%=campaignDate%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                                   value="<%=endDateVal%>" title="<%=campaignDate%>"/>
                        </td>
                    </TR>
                    <TR>
			<td  bgcolor="#dedede" valign="middle">
			    <DIV align="center" STYLE="color:blue; width: 100%;">
				<input type="submit"  value="<%=display%>" >
				<input type="hidden" name="op" value="campaignClientsReport">
			    </DIV>
			</TD>
			
                                           </TR>
                </TABLE>


                <BR>
                <center> <font size="3" color="red"><b> <%=clientsCountStr%> : <%=totalClientsCount%></b> </font></center>
                <br><br>
                <CENTER>
                    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
                    <br><br>
                    <%
                        if (campaignClientsCounts != null) {
                    %>
                    
                    <br/>
                    <br/>
                    <TABLE WIDTH="900" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="5" CELLSPACING="0">
                        <TR  bgcolor="#C8D8F8">
                            <TD style="font-size: 20px;">
                                <%=campaignStr%>
                            </TD>
                              
                            <TD style="font-size: 20px;">
                                <%=objectiveClientsCountStr%>
                            </TD>
                            <TD style="font-size: 20px;">
                                <%=clientsCountStr%>
                            </TD>
                            
                            <TD style="font-size: 20px;">
                                <%=totalCost%>
                            </TD>
                             <TD style="font-size: 20px;">
                                <%=ClientExpCost%>
                            </TD>
                             <TD style="font-size: 20px;">
                                <%=ClientRealCost%>
                            </TD>
                            <TD style="font-size: 20px;">
                                <%=divCost%>
                            </TD>
                            
                            <TD style="font-size: 20px;">
                                <%=campaignEffective%>
                            </TD>
                            
                         
                            
                        </TR>
                        <%
                            int totalSold = 0;
                            double temp;
                            DecimalFormat df = new DecimalFormat("#");
                            for (WebBusinessObject wbo : campaignClientsCounts) {
                                totalSold += Integer.valueOf(wbo.getAttribute("soldCount") + "");
                                temp = Double.valueOf(wbo.getAttribute("soldCount") + "") / Double.valueOf(wbo.getAttribute("clientCount") + "") * 100.0;
                        %>
                        <TR>
                            <TD>
                                <%=wbo.getAttribute("campaignTitle")%>
                            </TD>
                            <% if (wbo.getAttribute("soldCount").equals("0")) {%>
                            <TD style="background:#f6ffb4" >
                                
                                 
                                  <%=wbo.getAttribute("soldCount")%> 
                                   

                            </TD>
                             <% } else { %>
                             
                             
                             <TD>
                                    <%=wbo.getAttribute("soldCount")%>
                                    
                             </TD>
                             <% } %>
                               <% if (wbo.getAttribute("clientCount").equals("0")) {%>
                            <TD style="background:#f6ffb4" >
                                
                                 
                                  <%=wbo.getAttribute("clientCount")%> 
                                   

                            </TD>
                             <% } else { %>
                             
                             
                             <TD>
                                  <%=wbo.getAttribute("clientCount")%> 

                                    
                             </TD>
                             <% } %>
                            
                            <TD>
                                    <%=wbo.getAttribute("COST")%>
                                    
                             </TD>
                                 <%
                                     DecimalFormat df1 = new DecimalFormat("#.###"); 
                                    if( Integer.parseInt( (String )wbo.getAttribute("soldCount")  ) > 0)
                                     {
                                        clientEC=(float) Integer.parseInt((String )wbo.getAttribute("COST") )/Integer.parseInt((String )wbo.getAttribute("soldCount"));
                                     
                                     
                                     %>
                                      <TD >
                                <%=df1.format(clientEC)%>
                                   </TD>
                                <% } else { %> 
                          
                                
                                <td style="background:#f6ffb4" >
                                    <P  > -- </p>
                                     </TD>
                                <% } %>
                           
                            
                                 <%
                                    if( Integer.parseInt( (String )wbo.getAttribute("clientCount")  ) > 0)
                                     {
                                        clientEC1=(float) Integer.parseInt((String )wbo.getAttribute("COST") )/Integer.parseInt((String )wbo.getAttribute("clientCount"));
                                     
                                     
                                     %>
                                      <TD>
                                <%=df1.format(clientEC1)%>
                                 </TD>
                                <% } else { %> 
                                 <td style="background:#f6ffb4" >
                                    <P  > -- </p>
                                     </TD>
                                <% } %>
                            
                            
                           
                                 <%
                                     String diff="";
                                    if( Integer.parseInt( (String )wbo.getAttribute("clientCount")  ) > 0 &&  Integer.parseInt( (String )wbo.getAttribute("soldCount")  ) > 0)
                                     {
                                        clientEC2= clientEC1- clientEC;
                                        if(clientEC2 > 0)
                                       diff=diff1;
                                        else {diff=diff2;
                                        clientEC2=clientEC2*-1;
                                        }
                                       %>
                                         <TD style="width:10%">
                                <%= diff+ " "+df1.format(clientEC2)%>
                                         </TD>
                                <% } else { %> 
                                 <td style="background:#f6ffb4" >
                                <P> -- </p>
                               </TD>

                                <% } %>
                            
                            
                            
                                <%if( Integer.parseInt( (String )wbo.getAttribute("soldCount")  ) == 0){ %>
                                <TD style="background:#f6ffb4"><P> -- </P></TD>
                                    <%} else {%>
                                <TD>
                                <b class="fSize" ><%=wbo.getAttribute("percent")%> %</b>
                                </TD>
                                <% } %> 
                            
                           
                            </TR>      
                        <%
                            }
                        %>
                        <TR  bgcolor="#C8D8F8">
                            <TD colspan="1">Total Clients</TD>
                             <TD colspan="1"> <%=totalSold%></TD>
                            <TD colspan="1"> <%=totalClientsCount%></TD>
                           
                            <TD colspan="5"> </TD>
                        </TR>
                    </TABLE>
                    <%
                        }
                    %>
                    <BR>
                    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
                        <TR>
                            <TD CLASS="td">
                                &nbsp;
                            </TD>
                        </TR>
                    </TABLE>
                </CENTER>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
