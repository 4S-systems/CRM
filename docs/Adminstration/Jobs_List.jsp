

<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<HEAD>
    <TITLE>System Departments List</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    
    <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
       
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
</HEAD>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


//AppConstants appCons = new AppConstants();

String[] shippingMfstAttributes = {"tradeName","clientCount"};
String[] shippingMfstTitles =new String[5];

int s = shippingMfstAttributes.length;
int t = s+3;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;



Vector  tradeVector = (Vector) request.getAttribute("tradeVector");


WebBusinessObject wbo = null;


WebBusinessObject wbo2 = null;
WebBusinessObject wbo3 = null;
int flipper = 0;
String bgColor = null;
String bgColorm = null;

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String action = "delete";

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,createInvoice,save,cancel,TT,IG,AS,QS,BO,CD,PN,NAS,PL;
String backToList, backToOperationOrder,sTradeType,cannotbedeleted;
if(stat.equals("En")){

    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    save="Delete";
    cancel = "Cancel";
    backToList ="Back To List";
    backToOperationOrder ="Back To Operaion Order";
    TT="Task Title ";
    IG="Indicators guide ";
    AS="Active Site by Equipment";
    NAS="Non Active Site";
    QS="Quick Summary";
    BO="Basic Operations";
    shippingMfstTitles[0]="Season Name";
    shippingMfstTitles[1]="Client Count";
    shippingMfstTitles[2]="View";
    shippingMfstTitles[3]="Edit";
    shippingMfstTitles[4]="Delete";
    
    CD="Can't Delete Site";
    PN="Seasons  No.";
    PL="Seasonst List";
    createInvoice="Create Invoice";
    sTradeType="Trade type";
    cannotbedeleted="cannot be deleted";
}else{

    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    save=" &#1573;&#1581;&#1584;&#1601;";
    cancel = "إلغاء";
    backToList ="العودة إلي القائمة";
    backToOperationOrder ="العودة إلي أمر التشغيل";
    TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    AS="&#1605;&#1608;&#1602;&#1593; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
    NAS="&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
    QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    shippingMfstTitles[0]="اسم المهنه";
    shippingMfstTitles[1]="عدد العملاء";
    shippingMfstTitles[2]=" مشاهده";
    shippingMfstTitles[3]="&#1578;&#1581;&#1585;&#1610;&#1585;";
    shippingMfstTitles[4]="&#1581;&#1584;&#1601;";
    //shippingMfstTitles[5]="حذف";
    
    
    createInvoice="إعداد الفاتورة";
    CD=" &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    PN="عدد المهن";
    PL="عرض المهن";
    sTradeType="نوع المهنة";
    cannotbedeleted="غير مسموح الحذف";
}
    Vector tradeTypeV=(Vector)request.getAttribute("tradeTypeV");
    ArrayList<WebBusinessObject> tradeTypeList=new ArrayList<WebBusinessObject>(tradeTypeV);
    String tradeTypeId = request.getAttribute("tradeTypeId").toString();
    
    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    
    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
	
    ArrayList<String> userPrevList = new ArrayList<String>();
    WebBusinessObject wboPrev;
    for (int i = 0; i < groupPrev.size(); i++) {
	wboPrev = (WebBusinessObject) groupPrev.get(i);
	userPrevList.add((String) wboPrev.getAttribute("prevCode"));
    }
    String jsonText = (String) request.getAttribute("jsonText");
%>

<body>

    <script language="javascript" type="text/javascript">
        
        $(document).ready(function(){
            $('#showjobs').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10,20,50,-1], [10,20,50,"All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": false

                }).fadeIn(2000);
                
               
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'showjobchart',
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
        function reloadAE(nextMode){

       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            {
                req = new XMLHttpRequest();
            }
               else if (window.ActiveXObject)
            {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post",url,true);
            req.onreadystatechange =  callbackFillreload;
            req.send(null);

      }

       function callbackFillreload(){
         if (req.readyState==4)
            {
               if (req.status == 200)
                {
                     window.location.reload();
                }
            }
       }

           function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }

        function getTrade(ctr)
        {
            document.PROJECT_FORM.action ="<%=context%>/ClientServlet?op=ViewJobs&tradeTypeId="+ctr.value;
            document.PROJECT_FORM.submit();
        }
        

        function back(url)
        {
            document.PROJECT_FORM.action = url;
            document.PROJECT_FORM.submit();
        }
	
	function exportToExcel() {
	    var tradeType = $("#tradeType option:selected").val();
	    var url = "<%=context%>/ClientServlet?op=ViewJobs&ex=1&tradeTypeId=" + tradeType;
	    window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
	}
    </script>
    <style>
    
      
    </style>
    <FORM NAME="PROJECT_FORM" METHOD="POST">
        </FORM>
    <fieldset align=center class="set" style="width:90%">
    <legend align="center">

        <table dir=" <%=dir%>" align="<%=align%>">
            <tr>

                <td class="td">
                    <font color="blue" size="6"><%=PL%>
                    </font>
                </td>
            </tr>
        </table>
    </legend >
    <br />

    <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
	<button type="button" style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #27272A;font-size:15px;font-weight:bold; width: 150px; height: 30px; vertical-align: top;"
		onclick="JavaScript: exportToExcel();" title="Export to Excel">Excel &nbsp; &nbsp;<img height="15" src="images/icons/excel.png" />
	</button>
    </DIV>
		
    <center>
        <b> <font size="3" color="red"> <%=PN%> : <%=tradeVector.size()%> </font></b>
    </center>
    <br>
 
    <div STYLE="width:80%;margin-left: auto; margin-right: auto;" > 
        <div id="showjobchart">
            
        </div>
    <TABLE id="showjobs" ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;width:100%">
        <thead>
        <TR>
            <Th nowrap colspan="1" CLASS="silver_header" STYLE="border-WIDTH:0; font-size:14;white-space: nowrap;" >
                <B><%=sTradeType%></B>
        </Th>
        <Th nowrap colspan="2" CLASS="silver_header" STYLE="border-WIDTH:0;white-space: nowrap;" >
            <SELECT onchange="javascript:getTrade(this);" name="tradeType" id="tradeType" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">
                   <sw:WBOOptionList wboList="<%=tradeTypeList%>" displayAttribute="name" valueAttribute="id" scrollToValue="<%=tradeTypeId%>"  />
            </SELECT>
        </Th>
        <th colspan="2" CLASS="silver_header" STYLE="border-WIDTH:0;white-space: nowrap;" >
            &emsp;
        </th>
        </TR>
        
        <TR>

            <%
            String columnColor = new String("");
            String columnWidth = new String("");
            String font = new String("");
            for(int i = 0;i<t;i++) {
                if(i == 0 ){
                    columnColor = "#9B9B00";
                } else {
                    columnColor = "#7EBB00";
                }
                if(shippingMfstTitles[i].equalsIgnoreCase("")){
                    columnWidth = "1";
                    columnColor = "black";
                    font = "1";
                } else {
                    columnWidth = "150";
                    font = "12";
                }
            %>
            <Th nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;white-space: nowrap;" >
                <B><%=shippingMfstTitles[i]%></B>
            </Th>
            <%
            }
            %>

        </TR>
        </THEAD>
        <TBODY>
            
        <%

        Enumeration e = tradeVector.elements();


        while(e.hasMoreElements()) {
            iTotal++;
            wbo = (WebBusinessObject) e.nextElement();

            flipper++;
                     if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    }
        %>

        <TR>
            <%
            for(int i = 0;i<s;i++) {
                attName = shippingMfstAttributes[i];
                attValue = (String) wbo.getAttribute(attName)+" ";
                
                
            %>

            <TD STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>" >
                <DIV >

                    <b style="color: red;"> <%=attValue%> </b>
                </DIV>
            </TD>
           
            <%
            }
            %>
           
            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                <DIV ID="links">
                    <A HREF="<%=context%>/ClientServlet?op=ViewThisJob&tradeId=<%=wbo.getAttribute("tradeId")%>">
                        <%=shippingMfstTitles[2]%>
                    </A>
                </DIV>
            </TD>

            <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                <DIV ID="links">
                    <A HREF="<%=context%>/ClientServlet?op=UpdateTradeType&tradeId=<%=wbo.getAttribute("tradeId")%>">
                        <%=shippingMfstTitles[3]%>
                    </A>
                </DIV>
            </TD>
            <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>" />
                <DIV ID="links">
                    <%if(wbo.getAttribute(shippingMfstAttributes[1]).equals("0")){%>
                    <A  HREF="<%=context%>/ClientServlet?op=confirmDeleteJob&tradeId=<%=wbo.getAttribute("tradeId")%>">
                        <%=shippingMfstTitles[4]%>
                    </A>
                    <%}else{%>
                    <p>
                        <%=cannotbedeleted%>
                    </P>
                    <%}%>
                </DIV>
            </TD>

           
        </TR>


        <%

        }

        %>
        
        </TBODY>
        <TFOOT>
            <Th CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="3" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
                <B><%=PN%></B>
            </Th>
            <Th CLASS="silver_footer" BGCOLOR="#808080" colspan="2" STYLE="<%=style%>;padding-left:5;font-size:16;"  >

                <DIV NAME="" ID="">
                    <B><%=iTotal%></B>
                </DIV>
            </Th>
        </tfoot>
    </TABLE>
    </DIV>

    <br /><br />
    </fieldset>


</body>
</html>
