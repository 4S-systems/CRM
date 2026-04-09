<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%--<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>--%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        ArrayList complaintList = (ArrayList) request.getAttribute("complaintList");
        
        String status = (String) request.getAttribute("status");

        Calendar cal = Calendar.getInstance();
        String jDateFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowTime = sdf.format(cal.getTime());
        String type = (String) request.getAttribute("type");
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

        String search, cancel, fromDate, save, dir, style, selectStr, lang, langCode,
                title, back, employeeStr, supervisorStr, codeStr, assistantStr, projectStr,
                distanceStr, deleteStr, complaintStr, sitesStr, dir1,responsibleStr;


        String align = "center";
        String fStatus;
        String sStatus;
        String compareDateMsg, beginDateMsg, endDateMsg, beginDate, endDate,
                projectDistancesReportStr;
        String empNameShown="";
        if (stat.equals("En")) {
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            style = "text-align:left";
            langCode = "Ar";
            dir = "LTR";
            dir1 = "left";
            cancel = "Cancel";
            title = "Attach Employees To Complaints";
            search = "Search";
            back = "Back";
            save = "Save";
            fromDate = "As of";
            selectStr = "Select";
            sStatus = "Deleted Successfully";
            fStatus = "Fail To Delete";

            supervisorStr = "Supervisor";
            assistantStr = "Assistant";
            codeStr = "SODIC ID";
            projectStr = "Emp Name";
            distanceStr = "Comments";
            deleteStr = "Delete";
            complaintStr = "Complaint";
            sitesStr = "Employees";

            beginDate = "From Actual Begin Date";
            endDate = "To Actual Begin Date";
            compareDateMsg = "End Actual End Date must be greater than or equal start actual Begin Date";
            endDateMsg = "End Actual End Date must be less than or equal today Date";
            beginDateMsg = "Strat Actual Begin Date must be less than or equal today Date";
            projectDistancesReportStr = "Project Distances Report";
            responsibleStr="Responsibility";
            
        } else {
            lang = "   English    ";
            style = "text-align: right";
            langCode = "En";
            dir = "RTL";
            dir1 = "right";
            back = "العودة";
            save = "حفظ";
            cancel = tGuide.getMessage("cancel");
            title = "ربط الموظفين بالشكاوى";
            search = "بحث";
            fromDate = "إعتبارا من";
            selectStr = "إختر";
            employeeStr = "العامل";

            supervisorStr = "مشرف";
            assistantStr = "تباع";
            codeStr = "الكود";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";

            projectStr = "اسم الموظف";
            distanceStr = "ملاحظات";
            deleteStr = "حذف";
            complaintStr = "الشكوى";
            sitesStr = "الموظفين";

            beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            endDate = "&#1573;&#1604;&#1610; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            compareDateMsg = "  \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
            endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
            beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
            projectDistancesReportStr = "تقرير معاملات المواقع";
            responsibleStr="المسئول";
        }
        String fieldId = "userID";
        String fieldName = "userName";
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Attach Employees</TITLE>

        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/validator.js"></script>

        <script type="text/javascript">

            
            var users=new Array();
            var form = null;

            function cancelForm(url)
            {
                window.navigate(url);
            }

            function clearUnitId() {
                users[$("#empOne").val()]=0;
                $("#empOne").val('');

            }
            
            function saveComplaintEmployee(c, x) {
                //alert('entered ');
                var complaintId = $("#complaint option:selected").val();
                var empIdArr = $('input[name=empId]');
                var empId = $(empIdArr[x-1]).val();
                var commentsArr = $('input[name=comments]');
                var comments = $(commentsArr[x-1]).val();
                var responsibleArr = $('select[name=responsible]');
                
                var responsible = $(responsibleArr[x-1]).val();
                //alert('res= '+responsible);
                $("#save" + x).html("<img src='images/icons/spinner.gif'/>");
                    
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ComplaintEmployeeServlet?op=saveComplaintEmployee",
                    data: {complaintId: complaintId,
                           empId: empId,
                           comments: comments,
                            responsible: responsible},

                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);

                        if(eqpEmpInfo.status == 'Ok') {

                            $("#save" + x).html("");
                            $("#save" + x).css("background-position", "top");
                        }
                    }
                });
                
            }

            function remove(t, index){
                //alert;

                if($(t).parent().parent().parent().parent().attr('rows').length!=1){
                    $(t).parent().parent().remove();
                    if($("#empOne").val() != t.id) {
                        users[t.id]  =0;
                    }

                    var check = document.getElementsByName('order');
                    var index_ = document.getElementsByName('index');
                    //alert(check.length);
                    for(var i=0; i<check.length; i++){
                        //alert(i+1);
                        check[i].innerHTML = i+1;
                        index_[i].value = i+1;
                        //alert(index_[i].id);
                        index_[i].id = 'index'+(i+1);
                        //alert(index_[i].id);
                        //$('#order'+index).val(i+1);
                    }

                }
                else{
                    $(t).parent().parent().parent().parent().parent().parent().remove();
                    segment[t.title] =0;
                    var check = document.getElementsByName('order');
                    var index_ = document.getElementsByName('index');
                    //alert(check.length);
                    for(var i=0; i<check.length; i++){
                        //alert(i+1);
                        check[i].innerHTML = i+1;
                        index_[i].value = i+1;
                        //alert(index_[i].id);
                        index_[i].id = 'index'+(i+1);
                        //alert(index_[i].id);
                        //$('#order'+index).val(i+1);
                    }

                }
            }
            
            function getEmpName(){
               // alert('---');
                empNameShown=$("#empName").val();
                $("#empNameShown").val()=empNameShown;
              //  alert('-siteNameShown--'+siteNameShown);
            }
            
        </script>

        <style type="text/css">
            .remove{

                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);

            }
            #showHide{
                /*background: #0066cc;*/
                border: none;
                padding: 10px;
                font-size: 16px;
                font-weight: bold;
                color: #0066cc;
                cursor: pointer;
                padding: 5px;
            }
            #dropDown{
                position: relative;
            }
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }

            .datepick {}

            .save {
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
            .silver_odd_main,.silver_even_main {
                text-align: center;
            }
            
            input { font-size: 18px; }

        </style>
    </HEAD>

    <BODY STYLE="">
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="ATTACH_EMPS_FORM" METHOD="POST">
<!--            <DIV align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px; padding-top: 10px">
                <button  onclick="JavaScript: cancelForm('<%=context%>/main.jsp');" class="button"><%=back%></button>

                <button  onclick="JavaScript: submitForm();" class="button"><//%=save%></button>

                <button  onclick="JavaScript: getProjectDistancesReport();" class="button"><//%=projectDistancesReportStr%></button>
            </DIV>-->
                
            <CENTER>
                <FIELDSET class="set" style="width:90%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699" width="100%" class="blueBorder blueHeaderTD"><font color="#006699" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>

                    <table align="<%=align%>" dir="<%=dir%>">
                        <%    if (null != status) {
                                if (status.equalsIgnoreCase("ok")) {
                        %>  
                        <tr>
                        <table align="<%=align%>" dir=<%=dir%>>
                            <tr>
                                <td class="td">
                                    <font size=4 color="black"><%=sStatus%></font>
                                </td>
                            </tr> </table>
                        </tr>
                        <%
                        } else {%>
                        <tr>
                        <table align="<%=align%>" dir=<%=dir%>>
                            <tr>
                                <td class="td">
                                    <font size=4 color="red" ><%=fStatus%></font>
                                </td>
                            </tr> </table>
                        </tr>
                        <%}
                            }
                        %>

                    </table>
                    <br><br>
                    <TABLE id="MaintNum" ALIGN="center" DIR="<%=dir%>" WIDTH="80%" CELLSPACING=0 CELLPADDING=0 BORDER="0" style="display: block;">

                        <TR>

                            <TD style="<%=style%>; padding-<%=dir1%>: 5px;" width="15%" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <p><b> <%=complaintStr%> <font color="#FF0000">*</font></b>
                            </TD>
                            <TD style="border: none; padding-<%=dir1%>: 5px;">
                                <SELECT id="complaint" name="complaint" STYLE="width:230px">
                                    <sw:WBOOptionList wboList='<%=complaintList%>' displayAttribute = "projectName" valueAttribute="projectID"/>
                                </SELECT>
                            </td>
                        </TR>
                        <TR>

                            <TD style="<%=style%>; padding-<%=dir1%>: 5px;" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <p><b> <%=sitesStr%> <font color="#FF0000">*</font></b>
                            </TD>
                            <TD style="border: none; padding-<%=dir1%>: 5px;">
                                <button id="secondEmpSearchBtn" name="Attach Emps" value="" style="text-align: center;" onclick="return getDataInPopup('ComplaintEmployeeServlet?op=listUnattachedEmployees&formName=ATTACH_EMPS_FORM&selectionType=multi&complaintId=' + $('#complaint option:selected').val())"/>
                                    <img src="images/refresh.png" alt="" title="" align="middle" width="24" height="24"/>
                                </button>
                            </td>
                        </TR>
                    </TABLE>
                    <br/><br/>

                    <DIV id="tblDataDiv" style="display: block;">
                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="80%" cellpadding="0" cellspacing="0">
                            <TR>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%" ><b><%=codeStr%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" id="empNameShown" value=""><b><%=projectStr%> &nbsp; <%=empNameShown%> </b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=distanceStr%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=responsibleStr%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=save%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=deleteStr%></b></TD>
                            </TR>
                        </TABLE>
                    </DIV>
                    <br/><br/>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
