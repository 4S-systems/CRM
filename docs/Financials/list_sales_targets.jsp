<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
        //Kareem
        int flipper = 0;
        String className;
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] projectAttributes = {"projectName"};
        //String[] projectListTitles = new String[2];
        //String[] projectListTitles = new String[4];
        String[] projectListTitles = new String[7];
        int s = projectAttributes.length;
        //int t = s + 1;
        //int t=s+3;
        int t=s+6;
        int iTotal = 0;
        String attName, attValue;
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        ArrayList<WebBusinessObject> projectsList2 = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        String tradeId = request.getAttribute("tradeId").toString();
        //if (tradeId.equals("%")){tradeId="1";}
        String projectIds = request.getAttribute("projectIds").toString();
        String intervalId = request.getAttribute("intervalId").toString();
       // if(projectId.equals("%")){projectId="1";}
        Vector tradeTypeV=(Vector)request.getAttribute("tradeVector");
    ArrayList<WebBusinessObject> tradeTypeList=new ArrayList<WebBusinessObject>(tradeTypeV);
    ArrayList<WebBusinessObject> intervalsList=(ArrayList<WebBusinessObject>) request.getAttribute("intervals");//intervals
    ArrayList<WebBusinessObject> intervalsList2=(ArrayList<WebBusinessObject>) request.getAttribute("intervals");//
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String sProjectsTotal, sProjectsList, viewEngineers,selectProject,selectTrade, all,selectInterval;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            projectListTitles[0]="#";
            projectListTitles[1] = "Project Name";
            projectListTitles[2] = "Employee";
            projectListTitles[3] = "Job";
            //projectListTitles[4] = "Sales Target Type";
            projectListTitles[4] = "Interval";
            projectListTitles[5] = "Value";
            projectListTitles[6]="Update";
           // projectListTitles[3] = "View2";
            sProjectsTotal = "Total Projects";
            sProjectsList = "Sales Targets";//"Sales Targets List";
            viewEngineers = "View Engineers";
            selectProject="Choose Project";
            selectTrade="Choose Job";
            all="all";
            selectInterval="Choose Interval";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            projectListTitles[0]="#";
            projectListTitles[1] = "اسم المشروع";
            projectListTitles[2] = "الموظف";
            projectListTitles[3] = "الوظيفة";
            //projectListTitles[4] = "نوع هدف المبيعات";
            projectListTitles[4] = "الفترة";
            projectListTitles[5] = "القيمة";
            projectListTitles[6]="تحديث";
            //projectListTitles[3] = "عرض3";
            sProjectsTotal = "عدد المشاريع";
            sProjectsList = "عرض المستهدفات";//"عرض اﻻهداف البيعية";
            viewEngineers = "عرض المهندسين";
            selectProject="اختار المشروع";
            selectTrade="اختار الوظيفة";
            all="كل";
            selectInterval="اختار الفترة";
        }
    %>

    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <title>Project List</title>
        <%--
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>--%>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script  TYPE="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#apartments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            var divID;
            function closePopup(formID) {
                $("#" + formID).hide();
                $('#overlay').hide();
            }
            function closeOverlay() {
                $("#" + divID).hide();
                $("#overlay").hide();
            }
            function showProjectUsers(projectID) {
                divID = "project_engineers";
                $('#overlay').show();
                var url = "<%=context%>/ProjectServlet?op=manageProjectEngineers&projectID=" + projectID;
                jQuery('#project_engineers').load(url);
                $('#project_engineers').css("display", "block");
                $('#project_engineers').dialog();
            }
            function getProject(projectId){
                 var e = document.getElementById("tradeId");
                 var strUser = e.options[e.selectedIndex].value;
                 document.PROJECT_FORM.action ="<%=context%>/ProjectServlet?op=listSalesTragets&projectID="+projectId.value+"&tradeId="+strUser;
                 document.PROJECT_FORM.submit();
                
            }
            function getTrade(tradeId){
                var e = document.getElementById("projectID");
                 var strUser = e.options[e.selectedIndex].value;
                document.PROJECT_FORM.action ="<%=context%>/ProjectServlet?op=listSalesTragets&tradeId="+tradeId.value +"&projectID="+strUser;
                 document.PROJECT_FORM.submit();
            }
            function getInterval(intervalId){
                var e = document.getElementById("projectID");
                 var strUser = e.options[e.selectedIndex].value;
                 var e2 = document.getElementById("tradeId");
                 var strUser2 = e.options[e.selectedIndex].value;
                document.PROJECT_FORM.action ="<%=context%>/ProjectServlet?op=listSalesTragets&intervalId="+intervalId.value +"&projectID="+strUser+"&tradeId="+strUser2;
                 document.PROJECT_FORM.submit();
                
            }
            function editSalesTarget(index) {
               // alert($("#targettype" + index).val() + " - " + $("#targetvalue" + index).val());
            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=editSalesTargetByAjax",
                data: {
                    IDs: $("#id"+index).val(),
                    Interval_Id: $("#Interval_Id" + index).val(),
                    targetValue: $("#targetvalue" + index).val()
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        alert('تم التحديث بنجاح');
                      //  $("#targettype").html($("#targettype").val());
                      //  $("#targettype").html($("#targetvalue").val());
                    } else if (info.status == 'faild') {
                        //console.log(data);
                       // alert(data);
                        alert('لم يتم التحديث');
                        $("#Interval_Id").html($("#Interval_Id").val());
                        $("#targettype").html($("#targetvalue").val());
                    }
                    closeOverlay();
                }
            });
        }
        </script>
        <%--
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .smallDialog {
                width: 320px;
                display: none;
                position: fixed;
                z-index: 1100;
            }
            .mediumDialog {
                width: 370px;
                display: none;
                position: fixed;
                z-index: 1100;
                top: 150px;
                left: 500px;
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 1000;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }
        </style>--%>
        <style type="text/css">
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
            }
            .remove__{
                width:20px;
                height:20px;
                background-image:url(images/icons/remove1.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
            }
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: #ffffff;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #cc0000;
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .login-input {
                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #000;
                font-size: 13px;
                cursor: auto;
                text-shadow: 0 1px black;
                background: #2b3e5d;
                border: 1px solid #ffffff;
                border-top-color: #0d1827;
                border-radius: 4px;
                background: rgb(249,252,247); /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
        </style>
    </head>
    <body><%--
        <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">
        </div>
        <div id="project_engineers" class="mediumDialog"></div>
        <div align="left" style="color:blue;">
        </div> 
        <fieldset align=center class="set">
            <legend align="center">
                <FORM NAME="PROJECT_FORM" METHOD="POST">
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6"><%=sProjectsList%> 
                            </font>
                        </td>
                    </tr>
                    <TR>--%>
    <fieldset align=center class="set" style="width: 90%">
            <legend align="center">

                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            <%=sProjectsList%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <br/>
            <center> <b> <font size="3" color="red"> <%=sProjectsTotal%> : <%=projectsList.size()%> </font></b></center>
            <center><table><tr>          <td>      <b>
                                <%=selectProject%></b><b>
                                        <select onchange="javascript:getProject(this);"name='projectID' id='projectID' style='width:170px;font-size:16px;'>
                                            <option value=""><%=all%></OPTION>
                                            <sw:WBOOptionList wboList="<%=projectsList2%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectIds%>" /><%--/>scrollToValue="<%=projectId%>"/>--%>
                                        </select></b></td>
                    
                        <td><b>
                                <%=selectTrade%></b><b>
                                        <select onchange="javascript:getTrade(this);"name='tradeID' id='tradeId' style='width:170px;font-size:16px;'>
                                            <option value =""><%=all%></OPTION>
                                            <sw:WBOOptionList wboList="<%=tradeTypeList%>" displayAttribute="tradeName" valueAttribute="tradeId" scrollToValue="<%=tradeId%>"/><%--/>scrollToValue="<%=tradeId%>"/>--%>
                                </select>
                            </b></td>
                            <td><b>
                                <%=selectInterval%></b><b>
                                        <select onchange="javascript:getInterval(this);"name='intervalID' id='intervalId' style='width:170px;font-size:16px;'>
                                            <option value =""><%=all%></OPTION>
                                            <sw:WBOOptionList wboList="<%=intervalsList%>" displayAttribute="id" valueAttribute="id" scrollToValue="<%=intervalId%>"/>
                                </select>
                            </b></td>
                    </tr>
             
                </table>
             </center> 
            <br/>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <FORM NAME="PROJECT_FORM" METHOD="POST">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="apartments" style="width:100%;">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>                
                            <th>
                                <B><%=projectListTitles[i]%></B>
                            </th>
                            <%
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int counter = 1;
                            for (WebBusinessObject wbo : projectsList) {
                        %>
                        <tr>
                            <%                                for (int i = 0; i < s; i++) {
                                    attName = projectAttributes[i];
                                    attValue = (String) wbo.getAttribute(attName);
                            %>
                            <td>
                                <%=counter%>
                                 
                            </td>
                            <%--<td  bgcolor="#dedede" valign="middle" colspan="2">
                                        <select onchange="javascript:getProject(this);"name='projectID' id='projectID' style='width:170px;font-size:16px;'>
                                            <sw:WBOOptionList wboList="<%=projectsList2%>" displayAttribute="projectName" valueAttribute="projectID" /><%--scrollToValue="<%=projectId%>"/>--%>
                                <%--        </select>
                                    </td>
                                    <td  bgcolor="#dedede" valign="middle" colspan="2">
                                        <select onchange="javascript:getTrade(this);"name='tradeID' id='tradeId' style='width:170px;font-size:16px;'>
                                            <sw:WBOOptionList wboList="<%=tradeTypeList%>" displayAttribute="tradeName" valueAttribute="tradeId" /><%--scrollToValue="<%=tradeId%>"/>--%>
                                <%--       </select>
                                    </td>
                                </TR>
                </table>
            </legend >
            <br/>
            <table id='apartments' cellpadding="0" cellspacing="0" BORDER="0">
                <tr>
                    <td class='td'>
                        &nbsp;
                    </td>
                </tr>
            </table>
            <table align="<%=align%>" dir="<%=dir%>" width="400" cellpadding="0" cellspacing="0" style="border-right-width:1px;">
                <tr >
                    <%
                        String columnColor = new String("");
                        String columnWidth = new String("100");
                        String font = new String("12");
                        for (int i = 0; i < t; i++) {
                            if (i == 0) {
                                columnColor = "#9B9B00";
                            } else {
                                columnColor = "#7EBB00";
                            }
                    %>
                    <td nowrap class="silver_header" width="<%=columnWidth%>" bgcolor="<%=columnColor%>" style="border-width:0; font-size:<%=font%>;" nowrap>
                        <b><%=projectListTitles[i]%></b>
                    </td>
                    <%
                        }
                    %>
                </tr>  
                <%
                    for (WebBusinessObject wbo : projectsList) {
                        iTotal++;
                        flipper++;
                        if ((flipper % 2) == 1) {
                            className = "silver_odd_main";
                        } else {
                            className = "silver_even_main";
                        }
                %>
                <tr>
                    <%
                        for (int i = 0; i < s; i++) {
                            attName = projectAttributes[i];
                            attValue = (String) wbo.getAttribute(attName);
                    %>
                    <td style="<%=style%>" bgcolor="#DDDD00" nowrap  class="<%=className%>" >
                        <div >
                            <b> <%=attValue%> </b>
                        </div>
                    </td>
                    <%
                        }
                    %>
                   <%-- <td style="<%=style%>" bgcolor="#DDDD00" colspan="2" nowrap  class="<%=className%>" >
                        <div >
                            <b onclick="JavaScript: showProjectUsers('<%=wbo.getAttribute("projectID")%>');" style="cursor: pointer;"> <%=viewEngineers%> </b>
                        </div>
                    </td>--%>
                   <td>
                               
                                <%String projectName=(String)wbo.getAttribute("projectName");%>
                                
                                <%=projectName%>
                                <%String id=(String)wbo.getAttribute("id");%>
                                <input type="text" hidden id="id<%=counter%>" value="<%=id%>">
                            </td>
                   <td>
                               
                                <%String engineerName=(String)wbo.getAttribute("engineerName");%>
                                
                                <%=engineerName%>
                            </td>
                            <td>
                               <%-- <%=apartmentWbo.getAttribute("clientID")%>--%>
                                <%String roleName=(String)wbo.getAttribute("roleName");%>
                                
                                <%=roleName%>
                            </td>
                            <td>
                               <%-- <%=apartmentWbo.getAttribute("clientID")%>--%>
                                <%--<%String interval=(String)wbo.getAttribute("interval");%>--%>
                                <%--<input type="text" readonly id="targettype<%=counter%>" value="<%=interval%>"/>--%>
                                <%--<%=selectInterval%></b><b>--%>
                                        <select <%--onchange="javascript:getInterval(this);"--%>name='intervalID' id="Interval_Id<%=counter%>" style='width:170px;font-size:16px;'>
                                            <%--<option value =""><%=all%></OPTION>--%>
                                            <%String interval=(String)wbo.getAttribute("interval");%>
                                            <sw:WBOOptionList wboList="<%=intervalsList2%>" displayAttribute="id" valueAttribute="id" scrollToValue="<%=interval%>"/>
                                </select>
                            </td>
                            <td>
                               <%-- <%=apartmentWbo.getAttribute("clientID")%>--%>
                               <% Double value=new Double(wbo.getAttribute("targetValue").toString());%>
                                
                                <input tyep="text" id="targetvalue<%=counter%>" value="<%=value%>"/>
                            </td>
                            <td>
                               <%-- <%=apartmentWbo.getAttribute("clientID")%>--%>
                                <%String has_row=(String)wbo.getAttribute("hasRow");
                                String name;
                                if(has_row.equals("1")){
                                    name="تحديث";
                                }else{
                                    name="اضافة";
                                }
                                
                                %>
                                
                                <button type="button" onclick="JavaScript: editSalesTarget('<%=counter%>');"> <%=name%></button>
                            </td>
                            
               <%-- </tr>--%>
                <%
                    }
                %> 
                        </tr>
                        <%--         
                <tr>
                    <td class="silver_footer" bgcolor="#808080" COLSPAN="1" style="<%=style%>;padding-right:5px;border-right-width:1px;font-size:16px;">
                        <b><%=sProjectsTotal%></b>
                    </td>
                    <td class="silver_footer" bgcolor="#808080" style="<%=style%>;padding-left:5px;font-size:16px;">
                        <b><%=iTotal%></b>
                    </td>
                </tr>
            </table></form>--%>
                         <%
                                counter++;
                            }
                        %>
                    </tbody>
                </table></form>
            <br><br>
        </fieldset>
    </body>
</html>
