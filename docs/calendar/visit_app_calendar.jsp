<%-- 
    Document   : visit_app_calendar
    Created on : Aug 10, 2017, 3:49:46 PM
    Author     : fatma
--%>

<%@page import="com.maintenance.db_access.UserCompanyProjectsMgr"%>
<%@page import="com.maintenance.db_access.TradeMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tracker.db_access.UserAreaMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.List"%>
<%@page import="com.crm.common.CalendarUtils"%>
<%@page import="com.crm.common.CalendarUtils.Day"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Map"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>

<HTML>  
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Map<String, Map<String, WebBusinessObject>> data = (Map<String, Map<String, WebBusinessObject>>) request.getAttribute("data");
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowDate = sdf.format(c.getTime());
        List<CalendarUtils.Day> days = (List<CalendarUtils.Day>) request.getAttribute("days");
        String projectID = (String) request.getAttribute("projectID");
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        
        if(unitsList == null) {
            unitsList = new ArrayList<>();
        }
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String PL, titleRow, joborderTitle, roleTitle, selectBranch, selectEqu, jobOrdr, clientName, techSpName, createdBy, mDate, comment, save, done, direction, equ, equClass, CRC, SLA, deadLine;
        
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            PL = "Agents Appoientments";
            titleRow = "Agent Name";
            joborderTitle = "Job Order";
            roleTitle = "Role";
            selectBranch = " Select Branch ";
            selectEqu = " Select Equipment ";
            jobOrdr = " Job Order ";
            clientName = " Client Name ";
            techSpName = " Technical Specialist Name ";
            createdBy = " Created By ";
            mDate = " Maintenance Date ";
            comment = " Comment ";
            save = " Save ";
            done = " Order Has Been Add";
            direction = "Left";
            equ = " Equipment ";
            equClass = " Equipment Class ";
            CRC = "CRC";
            SLA = "SLA";
            deadLine = " DeadLine ";
        } else {
            align = "center";
            dir = "RTL";
            PL = "أوامر شغل فنيين";
            titleRow = "اسم الموظف";
            joborderTitle = "زيارة لعميل";
            roleTitle = "المهنة";
            selectBranch = " إختر فرع ";
            selectEqu = " إختر وحدة ";
            jobOrdr = " أمر الشغل ";
            clientName = " إسم العميل ";
            techSpName = " إسم الفنى ";
            createdBy = " بواسطة ";
            mDate = " تاريخ الصيانة ";
            comment= " التعليق ";
            save = " حفظ ";
            done = " تم إضافة الطلب ";
            direction = "right";
            equ = " Equipment ";
            equClass = " نوع المعدات ";
            CRC = "CRC";
            SLA = "SLA";
            deadLine = " DeadLine ";
        }
        
        ArrayList<WebBusinessObject> projectLst = (ArrayList<WebBusinessObject>) request.getAttribute("projectLst");
        ArrayList<WebBusinessObject> equClassLst = (ArrayList<WebBusinessObject>) request.getAttribute("equClass");
        
        int monthMaxDays = c.getActualMaximum(Calendar.DAY_OF_MONTH);
        int yearMaxDays = c.getActualMaximum(Calendar.DAY_OF_YEAR);
        int x = 0;
    %>
    <head>
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <script type="text/javascript">
            $(function () {
                $("#projectLstIDS").select2();
                
                $("#unitLstIDS").select2();
            });
            
            function popupJoborder(userID, userName, roleType) {
                divID = "client_joborder";
                $('#joborderClientName').html($('#clientName').val() ? $('#clientName').val() : $('#clientName').html());
                $('#joborderEqu').html($('#unitLstIDS option:selected').text() ? $('#unitLstIDS option:selected').text() : $('#unitLstIDS option:selected').html());
                $('#joborderEquID').val($('#unitLstIDS option:selected').val());
                $('#joborderTechnician').html(userName);
                $('#joborderUserID').val(userID);

                if (roleType == 'supervisor') {
                    $('#joborderManager').show();
                    $('#joborderWorker').hide();
                } else {
                    $('#joborderManager').hide();
                    $('#joborderWorker').show();
                }

                $('#client_joborder').css("display", "block");
                $('#client_joborder').bPopup();
            }
            
            function saveJoborderManager(obj) {
                var ticketType = "12";
                var comment = $('#joborderComment').val();
                var userId = $('#joborderUserID').val();
                var clientId = $('#clientId').val();
                var joborderDate = $('#joborderDate').val();
                var unitID = $('#joborderEquID').val();
                var equClassID = $("#equClassLstIDS option:selected").val();
                var CRC = $('#CRC').val();
                var SLA = $('#SLA').val();
                
                if (validateJoborder()) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=saveJoborderManager",
                        data: {
                            userId: userId,
                            comment: comment,
                            ticketType: ticketType,
                            clientId: clientId,
                            joborderDate: joborderDate,
                            title: 'Job Order',
                            note: 'Job Order',
                            unitID: unitID,
                            subject: 'Job Order',
                            equClassID: equClassID,
                            SLA: SLA,
                            CRC: CRC
                        }, success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            
                            if (info.status == 'ok') {
                                alert(' Job Order Has Been Added ');
                                closePopupDialog('client_joborder');
                            } else if (info.status == 'notManager') {
                                alert(' Can not save... Admin on this area is not a manager ');
                            }
                        }
                    });
                }
            }
            
            function validateJoborder() {
                return true;
            }
            
            function viewUnits(){
                var projectLstIDS = $("#projectLstIDS").val();
                var clientId = $('#clientId').val();
                
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=owendPrjUnit",
                    data: {
                        prjIDRes: projectLstIDS,
                        clientId: clientId
                    }, success: function (jsonString) {
                        var result = $.parseJSON(jsonString);
                        var options = [];
                        options.push("<option value=''>", "All", "</option>");
                        $.each(result, function () {
                            options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                        });
                          $("#unitLstIDS").html(options.join(''));
                    }
                });
            }
            
            function getEquipmentInfo(){
                var unitID = $("#unitLstIDS option:selected").val();
                
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=owendPrjUnit",
                    data: {
                        equ: "yes",
                        unitID: unitID
                    }, success: function (jsonString) {
                        var result = $.parseJSON(jsonString);
                        var options = [];
                        $.each(result, function () {
                            options.push('<option value="', this.EqID, '">', this.EqName, '</option>');
                        });
                        $("#equClassLstIDS").html(options.join(''));
                    }
                });
            }
            
            function calcDeadLine(){
                 var sla = Number($("#SLA").val());
                 var monthDays = Number("<%=monthMaxDays%>");
                 var now;

                 var nowSplit = "<%=nowDate%>".split("/");
                 var day=Number(nowSplit[2]), month=Number(nowSplit[1]), year=Number(nowSplit[0]);
                 var days=day+sla;
                if(days > monthDays){
                    var x = Math.floor((days/monthDays));
                    month = month + Number(x);
                    if(month > 12){
                        var y = Math.floor((month/12));
                        year = Number(year) + Number(y);
                        month = month - (12*Number(y));
                        if(month == 0){
                            month = 12;
                            year = Number(year) - 1;
                        }
                    } else{
                        day = days - (monthDays*Number(x));
                        if(day == 0){
                            day = 1;
                            month = Number(month) - 1;
                        }
                    }
                } else {
                    day = day + sla;
                }
                
                if(Number(day) < 10 && day.toString().length < 2){
                    day = "0" + day;
                }
                if(Number(month) < 10 && month.toString().length < 2){
                    month = "0" + month;
                }
                 
                now = year + "/" + month + "/" + day;
                $("#joborderDate").val(now);
            }
            
            function calcremDays(rem, monthDays){
                rem = rem - Number(monthDays);
                return rem;
            }
        </script>
        
        <style type="text/css">
            .login {
                direction: <%=dir%>;
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
                background: #FF9900;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
        </style>
    </head>
    
    <body>
        <FORM name="unitsearchForm" method="POST">
            <%if(projectLst != null && !projectLst.isEmpty()){%>
                <div style="width: 90%; padding: 20px; direction: <%=dir%>;">
                    <TABLE style="width: 90%; direction: <%=dir%>;">
                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;">
                                <b>
                                    <font size="3" color="white">
                                     <%=selectBranch%>
                                    </font>
                                </b>
                            </TD>
                            
                            <TD style="border: none; text-align: center; padding: 10px;" colspan="3">
                                <SELECT id="projectLstIDS" name="projectLstIDS" STYLE="width:75%; font-size: medium; font-weight: bold;" onchange="viewUnits();">
                                    <sw:WBOOptionList wboList='<%=projectLst%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                </SELECT>
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;">
                                <b>
                                    <font size="3" color="white">
                                     <%=selectEqu%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;" colspan="3">
                                <SELECT id="unitLstIDS" name="unitLstIDS" STYLE="width:75%; font-size: medium; font-weight: bold;" onchange="getEquipmentInfo();">
                                </SELECT>
                            </TD>
                        </TR>
                    </TABLE>
                </div>
             <% } %>
        </FORM>
            
        <div id="client_joborder" style="width: 45% !important; display: none; position: relative; z-index: 10000; direction: <%=dir%>;">
            <div style="clear: both; margin-left: 90%; margin-top: 0px; margin-bottom: -38px; direction: <%=dir%>">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopupDialog('client_joborder')"/>
            </div>
            
            <div class="login" style="width: 90%; margin-bottom: 10px; margin-left: auto; margin-right: auto; direction: <%=dir%>;">
                <h1 align="center" style="vertical-align: middle; background-color: #006daa;">
                     <%=jobOrdr%> 
                     <img src="images/icons/visit_icon.png" alt="phone" width="24px"/>
                </h1>
                     
                <table class="table" style="width:90%; direction: <%=dir%>;" >
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=clientName%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <label id="joborderClientName">
                            </label>
                            
                            <input type="hidden" id="joborderUserID" name="joborderUserID"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=equClass%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <SELECT id="equClassLstIDS" name="equClassLstIDS" STYLE="width:75%; font-size: medium; font-weight: bold;" onchange="">
                            </SELECT>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=equ%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <label id="joborderEqu">
                            </label>
                            
                            <input type="hidden" id="joborderEquID" name="joborderEquID"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=direction%>;">
                             <%=techSpName%> : 
                        </td>
                        <td style="text-align: <%=direction%>;">
                            <label id="joborderTechnician">
                            </label>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=direction%>;">
                             <%=createdBy%> : 
                        </td>
                        <td style="text-align: <%=direction%>;">
                            <label id="joborderEmployee">
                                <%=loggedUser.getAttribute("userName")%>
                            </label>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=SLA%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <INPUT id="SLA" name="SLA" type="number"  min="0" onchange="calcDeadLine();">
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:red; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=deadLine%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>; color:red;">
                            <INPUT id="joborderDate" name="joborderDate" style="border: none; color: red;" readonly>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=CRC%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <INPUT id="CRC" name="CRC" type="text">
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=direction%>;">
                            <%=comment%> : 
                        </td>
                        <td style="text-align: <%=direction%>;">
                            <textarea cols="26" rows="10" id="joborderComment" style="width: 99%; background-color: #FFF7D6;">
                            </textarea>
                        </td>
                    </tr>
                </table>
                        
                <div style="text-align: <%=direction%>; margin-left: 2%; margin-right: auto; direction: <%=dir%>;" >
                    <button type="button" id="joborderManager" onclick="javascript: saveJoborderManager(this);" style="font-size: 14px; font-weight: bold; width: 150px">
                        <%=save%>
                    </button>
                    
                    <button type="button" id="joborderManager" onclick="javascript: saveJoborderManager(this);" style="font-size: 14px; font-weight: bold; width: 150px">
                        <%=save%>
                    </button>
                </div>
                    
                <div id="progress" style="display: none; direction: <%=dir%>;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                    
                    <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg">
                         <%=done%>
                    </div>
            </div>  
        </div>
        <TABLE id="hhgh" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="width: 90%; border: 2px solid #d3d5d4">
            <TR>
                <TD class="blueBorder blueHeaderTD" COLSPAN="<%=(days.size() + 3)%>" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:14px">
                    <DIV>
                        <B>
                            <%=PL%>
                        </B>
                    </DIV>
                </TD>
            </TR>
            <TR>
                <TD rowspan="2" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main" >
                    <b><font size="2" color="#000080" style="text-align: center;">#</font></b>
                </TD>
                <TD rowspan="2" class="silver_footer" bgcolor="#808000" STYLE="width: 200px;text-align:center;color:black;font-size:14px">
                    <b><font color="#000080" style="text-align: center;"><%=titleRow%></font></b>
                </TD>
                <TD rowspan="2" class="silver_footer" bgcolor="#808000" STYLE="width: 200px;text-align:center;color:black;font-size:14px">
                    <b><font color="#000080" style="text-align: center;"><%=roleTitle%></font></b>
                </TD>
            </TR>
            <TR>
                <% for (Day day : days) {%>
                <TD STYLE="text-align: center; font-size: x-small;" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main" >
                    <font color="red"><%=day.getName()%></font>
                    <br>
                    <B><%=day.getDay()%></B>
                </TD>
                <%}%>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main" >
                    &nbsp;
                </TD>
            </TR>
            <%
                String userId, userName, bgColorm;
                Map<String, WebBusinessObject> dayInfo;
                WebBusinessObject appointment;
                WebBusinessObject userRole;
                String roleType, altValue, visitCount;
                int flipper = 0;
                UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                TradeMgr tradeMgr = TradeMgr.getInstance();
                for (Map.Entry<String, Map<String, WebBusinessObject>> entry : data.entrySet()) {
                    userId = entry.getKey().split("@@")[0];
                    ArrayList<WebBusinessObject> usersInProjectList = new ArrayList<>(userCompanyProjectsMgr.getOnArbitraryDoubleKeyOracle(
                                projectID, "key2", CRMConstants.TRADE_FIELD_TECHNICIAN_ID, "key4"));
//                    ArrayList<WebBusinessObject> userAreaList = new ArrayList(userAreaMgr.getOnArbitraryDoubleKeyOracle(userId, "key1", areaID, "key2"));
                    WebBusinessObject userWbo ;
                    String roleName = "none";
                    if(!usersInProjectList.isEmpty()) {
                        userWbo = usersInProjectList.get(usersInProjectList.size() - 1);
                        roleName = (String)tradeMgr.getOnSingleKey((String) userWbo.getAttribute("option1")).getAttribute("tradeName");
                    }
                    userName = entry.getKey().split("@@")[1];
                    dayInfo = entry.getValue();
                    userRole = dayInfo.get("userRole");
                    roleType = "technician";
                    altValue = "";
                    if (userRole != null && "supervisor".equals(userRole.getAttribute("roleType"))) {
                        roleType = "supervisor";
                        altValue = "مشرف المنطقة";
                    }
                    if ((flipper % 2) == 1) {
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColorm = "silver_even_main";
                    }
                    flipper++;
            %>
            <TR>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                    <DIV>
                        <%=flipper%>
                    </DIV>
                </TD>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%> <%=roleType%>Class" >
                    <DIV title="<%=altValue%>">
                        <%=userName%>
                    </DIV>
                </TD>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%> <%=roleType%>Class" >
                    <DIV title="<%=altValue%>">
                        <%=roleName%>
                    </DIV>
                </TD>
                <%
                    for (Day day : days) {
                        appointment = dayInfo.get(day.getDay() + "");
                        if (appointment != null) {
                            visitCount = (String) appointment.getAttribute("visitCount");
                        } else {
                            visitCount = "";
                        }
                %>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                    <b style="font-size: medium;"><%=visitCount%></b>
                </TD>
                <% }%>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                    <img src="images/icons/visit_icon.png" height="30px" title="<%=joborderTitle%>"
                         style="cursor: hand;" onclick="JavaScript: popupJoborder('<%=userId%>', '<%=userName%>', '<%=roleType%>')"/>
                </TD>
            <TR>
                <% }%>
        </TABLE>
        <br/><br/>
    </body>
</html> 