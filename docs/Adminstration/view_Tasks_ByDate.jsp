<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.quality_assurance.db_accesss.GenericApprovalStatusMgr"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
    <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        TaskMgr taskMgr = TaskMgr.getInstance();

        String context = metaMgr.getContext();
        GenericApprovalStatusMgr genericApprovalStatusMgr;
        genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
        String[] taskAttributes = {"title"};
        String[] taksListTitles = new String[4];

        /***************** Next Links Data *********************/
        int noOfLinks = 0;
        int count = 0;
        String searchType = (String) request.getAttribute("searchType");
        String tempcount = (String) request.getAttribute("count");
        String taskName = (String) request.getAttribute("taskName");

        if (tempcount != null) {
            count = Integer.parseInt(tempcount);
        }
        String tempLinks = (String) request.getAttribute("noOfLinks");
        if (tempLinks != null) {
            noOfLinks = Integer.parseInt(tempLinks);
        }
        String fullUrl = (String) request.getAttribute("fullUrl");
        String url = (String) request.getAttribute("url");

        /********************** End *****************************/
        String total = (String) request.getAttribute("total");

        int s = taskAttributes.length;
        int t = s + 3;
        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;

        Vector taskList = (Vector) request.getAttribute("data");
        String  beginDate=(String)session.getAttribute("beginDatesql");
        String  endDate=(String)session.getAttribute("endDatesql");
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date dateBeg = sdf.parse(beginDate);
        java.util.Date dateEnd = sdf.parse(endDate);
         
        beginDate=sdf1.format(dateBeg);
        endDate=sdf1.format(dateEnd);  
        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel,from, TT, IG, AS,datefrom,dateto, QS, BO, CD, PN,pageNo, createdBy,applyitem, PL,markfordelete,approved,notapproved;
        if (stat.equals("En")) {

            pageNo="page No:";
            datefrom="Date From";
            align = "center";
            from=" &nbsp From &nbsp ";
            dateto=" &nbsp To &nbsp ";
            dir = "LTR";
            markfordelete="Mark For Delete";
            applyitem="Item Approved";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "Delete Schedule - Are you Sure ?";
            save = "Delete";
            cancel = "Back To List";
            TT = "Note";
            IG = "Indicators guide ";
            AS = "Active Task by job order";
            createdBy = "Created By";
            QS = "Quick Summary";
            BO = "Maintenance Item name";
            taksListTitles[0] = "Maintenance Item Code";
            taksListTitles[1] = "View";
            taksListTitles[2] = "Edit";
            taksListTitles[3] = "Delete";
            CD = "Can't Delete Task";
            PN = "Maintenance Item No.";
            PL = "Maintenance Items List For Review";
            approved="Approved";
            notapproved="Not Approved";
        } else {
            datefrom="التاريخ من";
            dateto=" &nbsp &nbsp الى &nbsp &nbsp ";
          
            from=" &nbsp من &nbsp ";
            pageNo="صفحة رقم";
            applyitem="مطابقة البند";
            align = "center";
            markfordelete="ترشيح للحذف";
            approved="مطابق";
            notapproved="يحتاج تعديل";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            tit = " &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
            save = " &#1573;&#1581;&#1584;&#1601;";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "ملاحظة";
            IG = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
            AS = "&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
            createdBy = "المؤلف";
            QS = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            BO = "اسم البند";
            taksListTitles[0] = "كود  البند";
            taksListTitles[1] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            taksListTitles[2] = "&#1578;&#1581;&#1585;&#1610;&#1585;";
            taksListTitles[3] = "&#1581;&#1584;&#1601;";
            CD = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            PN = " &#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            PL = "عرض بنود الصيانة للمراجعة";
        }
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    %>

    <script language="javascript" type="text/javascript">
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
        
            
        function getUnitTop(){
            var x =document.getElementById("selectIdTop").value;
            x = parseInt(x);
            var name =document.getElementById("taskName").value;
            var res = ""
            for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
            }
            res = res.substr(0, res.length - 1);
            var tempurl="<%=context%>/TaskServlet?op=getTaskByDate&count=";
            var taskType='<%=searchType%>';
           
            if(taskType=="code")
                tempurl=tempurl+x+"&Tasks="+res+"&searchType=<%=searchType%>";
            else
                tempurl=tempurl+x+"&Tasks="+res+"&searchType=<%=searchType%>";
           
            window.navigate(tempurl);

        }
       
        function getUnitDown(){
            var x =document.getElementById("selectIdDown").value;
            x = parseInt(x);
            var name =document.getElementById("taskName").value;
            var res = ""
            for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
            }
            res = res.substr(0, res.length - 1);
           
            var tempurl="<%=context%>/TaskServlet?op=getTaskByDate&count=";
            var taskType='<%=searchType%>';
           
            if(taskType=="code")
                tempurl=tempurl+x+"&taskCode="+res+"&searchType=<%=searchType%>";
            else
                tempurl=tempurl+x+"&taskName="+res+"&searchType=<%=searchType%>";
           
            window.navigate(tempurl);
        }
        
    </script>
    <script type="text/javascript" src="js/jquery-1.5.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.8.9.custom.min.js"></script>
    <link href="css/demos.css" rel="stylesheet" type="text/css" />
    <link href="css/jquery.ui.dialog.css" rel="stylesheet" type="text/css" />
    <link href="css/jquery.ui.theme.css" rel="stylesheet" type="text/css" />
    <link href="css/jquery.ui.core.css" rel="stylesheet" type="text/css" />

    <script>
        $(function() {
            $( "#dialogdiv" ).dialog({autoOpen: false,hide: 'scale',
                resizable: false,
                modal:true,
                height:430,
                width:700, draggable: false  });
        });
        
        function opend(c){			
            $.ajax({
                type:"post",
                url:"<%=context%>/TaskServlet",
                data:"op=printTaskForm&single=single&taskId="+c,
                success:function(msg){
                    $("#dialogdiv").html(msg);						
                    $("#dialogdiv").dialog('open');
                }
            });	
        }
        function approved(c,x,y){		
       
             $("#"+x+' div[class='+y+']').html("<img src='images/icons/spinner.gif'/>");
            
            $.ajax({
                type:"post",
                url:"<%=context%>/GenericApprovalStatusServlet",
                data:"op=SaveScheduleAppoval&type=MI&Status="+c+"&note="+$("#"+x+' input[name=desc]').val()+"&taskId="+$("#"+x+' input[name=taskId]').val(),
                success:function(msg){
                    $("#"+x+' div[class='+y+']').html("");
                    $("#"+x+' div').css("background-position","bottom");
                    $("#"+x+' div[class='+y+']').css("background-position","top");
                }
            });	
        }
              function edita(x){
                        $("#"+x+' input[name=desc]').css("display","inline");
			$("#"+x+' input[name=desc]').focus();
			$("#"+x+' span[name=desc]').css("display","none");
              }
              function notedite(x){
                        $("#"+x+' span[name=desc]').html($("#"+x+' input[name=desc]').val());
			$("#"+x+' input[name=desc]').css("display","none");
			$("#"+x+' span[name=desc]').css("display","inline");
              }
        
    </script>
   <style>

.editable{display:block;width: 70px;}
.noneeditable{display:none;
width: 70px;}
.appro,.approd,.appron{
        width:20px;
	height:20px;
	background-image:url(images/icons/icon-32-publish.png);
	background-repeat: no-repeat;
        cursor: pointer;
        
		
}
.approd{
	background-image:url(images/icons/icon-32-remove.png);	
}
.appron{
	background-image:url(images/icons/icon-32-unpublish.png);
}
.activate{	
	   
}

    </style>
    <body>
        
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">

            </DIV> 

            <fieldset align=center class="set">
                
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
                <br>

                <center> <b> <font size="3" color="red"> <%=PN%> : <%=total%> </font></b></center> 
                <br>

                <%if (noOfLinks > 0) {%>
                <table align="center">
                    <tr>
                        <td class="td"colspan="2"align="center" >
                            <b><font size="2" color="blue"> <%=datefrom%> </font><font size="2" color="black"><%=beginDate%></font><font size="2" color="blue"> <%=dateto%> </font><font size="2" color="black"> <%=endDate%></font></b>
                           
                        </td>
                    </tr>
                    <tr>
                        
                        <td class="td" >
                            <b><font size="2" color="red"><%=pageNo%> </font><font size="2" color="black"> <%=count + 1%> </font><font size="2" color="red"> <%=from%></font><font size="2" color="black"> <%=noOfLinks%></font></b>
                            <input type="hidden" name="taskName" id="taskName" value="<%=taskName%>">
                        </td>
                        <td class="td"  >
                            <select id="selectIdTop" onchange="javascript:getUnitTop();">
                                <%for (int i = 0; i < noOfLinks; i++) {%>
                                <option value="<%=i%>" <%if (i == count) {%> selected <% }%> ><%=i + 1%></option>
                                <% }%>
                            </select>
                        </td>
                    </tr>
                </table>
                <BR>
                <%}%>
                <TABLE WIDTH="600" border="0" ALIGN="center" CELLPADDING="1" CELLSPACING="0" dir="<%=dir%>" class="silver_table">
                    <TR class="silver_header">
                        <TD width="81" COLSPAN="1" nowrap  CLASS="silver_header" nowrap="nowrap"STYLE="text-align:center;font-size:16px;border-right:0px solid #666666 ;"><B><B><%=taksListTitles[0]%></B></B></TD>
                        <TD  CLASS="silver_header" STYLE="text-align:center;font-size:16;border-right:0px solid #666666 ;"><B><%=BO%></B><div id="dialogdiv" style="overflow: scroll;"></div></TD>
                        <TD  CLASS="silver_header" nowrap="nowrap" STYLE="text-align:center;font-size:16;border-right:0px solid #666666 ;"><B><%=createdBy%></B></TD>
                        <TD  CLASS="silver_header" STYLE="text-align:center;font-size:16;border-right:0px solid #666666 ;"><%=TT%></TD>
                        <TD  CLASS="silver_header" STYLE="text-align:center;font-size:16;border-right:0px solid #666666 ;"><%=applyitem%></TD>
                    </TR>
                    <%

                        Enumeration e = taskList.elements();
                        String categoryId = "";
                        int n = 0;
                        String bgColorm = "",b1="bottom",b2="bottom",b3="bottom",note1="",edit="";
                        while (e.hasMoreElements()) {
                            iTotal++;
                            categoryId = "";
                            wbo = (WebBusinessObject) e.nextElement();
                            categoryId = wbo.getAttribute("parentUnit").toString();
                            WebBusinessObject Approval= genericApprovalStatusMgr.getOnSingleKey1(wbo.getAttribute("id").toString());
                                b1="bottom";b2="bottom";b3="bottom";note1="";
                              
                            if(Approval!=null){ 
                                if(Approval.getAttribute("comments")!=null)
                                 note1=Approval.getAttribute("comments").toString();
                               
                               if(Approval.getAttribute("status")!=null&&Approval.getAttribute("status").equals("MarkForDelete"))
                                b3="top";
                            if(Approval.getAttribute("status")!=null&&Approval.getAttribute("status").equals("NotApproved"))
                                b2="top";                          
                            if(Approval.getAttribute("status")!=null&&Approval.getAttribute("status").equals("Approved"))
                                b1="top";
                           }
                            flipper++;
                            if ((n % 2) == 1) {
                                bgColor = "silver_odd";
                                bgColorm = "silver_odd_main";

                            } else {
                                bgColor = "silver_even";
                                bgColorm = "silver_even_main";
                            }
                    %>
                    <form id="fo<%=n%>">
                    <TR>
                        <%

                            for (int i = 0; i < s; i++) {
                                attName = taskAttributes[i];
                                attValue = (String) wbo.getAttribute(attName);
                        %>
                        <TD bgcolor="" class="<%=bgColorm%>"><DIV > <b> <%=attValue%></b> </DIV></TD>
                        <%
                            }
                        %>
                        <TD nowrap   CLASS="<%=bgColor%>" STYLE="<%=style%>">
                            <span style="cursor: pointer;white-space: nowrap;color: #666666;"title="اضغط هنا للمشاهدة" onclick="opend('<%=wbo.getAttribute("id")%>')"><%=wbo.getAttribute("name")%></span>
                            <!-- "status => NotApproved"  "comments => sdfsdfsdf"  -->
                        </TD>
                       

                        <TD  nowrap   CLASS="<%=bgColor%>" STYLE="<%=style%>"><%=wbo.getAttribute("createdBy")%>
                        </TD>
                         <TD width="111" nowrap    CLASS="<%=bgColor%>" STYLE="<%=style%>"title="اضغط هنا لادخال ملاحظاتك"><span name="desc" class="editable" onclick="edita('fo<%=n%>');"><%=note1%> </span><input type="text"  name="desc" id="desc" onblur="notedite('fo<%=n%>');" class="noneeditable" value="<%=note1%>" /></TD>
                        <TD  nowrap   CLASS="<%=bgColor%>" STYLE="<%=style%>">
                            <table border="2" cellpadding="1" cellspacing="0">
                                <tr>
                                    <input name="taskId" type="hidden" id="taskId" value="<%=wbo.getAttribute("id")%>">
                                    <input name="note" type="hidden" id="note" value="as">
                                    <td nowrap="nowrap" class="silver_odd"style="padding: 6px;" >
                                        
                                        <%=markfordelete%>
                                        <div class="approd" style="background-position:<%=b3%>;"  onclick="approved('MarkForDelete','fo<%=n%>','approd');" ></div></td>
                                    <td nowrap="nowrap" class="silver_even" style="padding:6px;">
                                        
                                        <%=notapproved%>
                                        <div class="appron" style="background-position:<%=b2%>;" onclick="approved('NotApproved','fo<%=n%>','appron');" ></div></td>
                                    <td nowrap="nowrap" class="silver_odd"  style="padding: 6px; width: 70px;">
                                        
                                        <%=approved%>
                                        <div class="appro" style="background-position:<%=b1%>;" onclick="approved('Approved','fo<%=n%>','appro');" ></div></td>
                                </tr>
                            </table></TD>

                        
                    </TR>
                    </form>
                    <% n++;
                            }%>
                    <TR CLASS="silver_footer">
                        <TD  COLSPAN="2" STYLE="<%=style%>;padding:5;font-size:14;"><B><%=PN%></B></TD>
                        <TD  colspan="3" STYLE="<%=style%>;padding:5;font-size:14;"><DIV NAME="" ID="div"> <B><%=iTotal%></B> </DIV></TD>
                    </TR>
                </TABLE>
                <br>
                <table align="center">

                    <input type="hidden" name="url" value="<%=url%>" id="url" >
                    <input type="hidden" name="taskName" id="taskName" value="<%=taskName%>">
                    <%if (noOfLinks > 0) {%>
                    <tr>
                        <td>
                            <b><font size="2" color="red">page No:</font><font size="2" color="black"><%=count + 1%></font><font size="2" color="red">from</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                        </td>
                        <td class="td"  >
                            <select id="selectIdDown" onchange="javascript:getUnitDown();">
                                <%for (int i = 0; i < noOfLinks; i++) {%>
                                <option value="<%=i%>" <%if (i == count) {%> selected <% }%> ><%=i + 1%></option>
                                <% }%>
                            </select>
                        </td>
                    </tr>
                    <%}%>
                </table>
            </fieldset>
       </body>
</html>
