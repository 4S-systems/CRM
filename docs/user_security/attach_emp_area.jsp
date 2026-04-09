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

        String status = (String) request.getAttribute("status");
        Vector<WebBusinessObject> listUserArea = (Vector) request.getAttribute("listUserArea");
        Calendar cal = Calendar.getInstance();
        String jDateFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowTime = sdf.format(cal.getTime());
        String type = (String) request.getAttribute("type");
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

        String search, cancel, fromDate, save, dir, style, selectStr, lang, langCode,
                title, back, employeeStr, supervisorStr, codeStr, assistantStr, projectStr,
                distanceStr, deleteStr, siteStr, sitesStr, dir1;


        String align = "center";
        String fStatus;
        String sStatus;
        String compareDateMsg, beginDateMsg, endDateMsg, beginDate, endDate,
                projectDistancesReportStr;
        String empNameShown = "";
        if (stat.equals("En")) {
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            style = "text-align:left";
            langCode = "Ar";
            dir = "LTR";
            dir1 = "left";
            cancel = "Cancel";
            title = "Attach Employees";
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
            siteStr = "Manager";
            sitesStr = "Employees";

            beginDate = "From Actual Begin Date";
            endDate = "To Actual Begin Date";
            compareDateMsg = "End Actual End Date must be greater than or equal start actual Begin Date";
            endDateMsg = "End Actual End Date must be less than or equal today Date";
            beginDateMsg = "Strat Actual Begin Date must be less than or equal today Date";
            projectDistancesReportStr = "Project Distances Report";

        } else {
            lang = "   English    ";
            style = "text-align: right";
            langCode = "En";
            dir = "RTL";
            dir1 = "right";
            back = "العودة";
            save = "حفظ";
            cancel = tGuide.getMessage("cancel");
            title = "ربط الموظفين";
            search = "بحث";
            fromDate = "إعتبارا من";
            selectStr = "إختر";
            employeeStr = "العامل";

            supervisorStr = "مشرف";
            assistantStr = "تباع";
            codeStr = "الكود";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";

            projectStr = "إسم المنطقة";
            distanceStr = "ملاحظات";
            deleteStr = "حذف";
            siteStr = "الموظفين";
            sitesStr = "المناطق";

            beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            endDate = "&#1573;&#1604;&#1610; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            compareDateMsg = "  \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
            endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
            beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
            projectDistancesReportStr = "تقرير معاملات المواقع";
        }



        String fieldId = "userID";
        String fieldName = "userName";
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Attach Employees</TITLE>


        <!--<link rel="stylesheet" type="text/css" href="css/CSS.css" />-->
        <!--<link rel="stylesheet" type="text/css" href="css/Button.css" />-->
        <!--<link rel="stylesheet" type="text/css" href="css/blueStyle.css" />-->
        <!--<link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />-->
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <!--<link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">-->
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>



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
    <script type="text/javascript">
        $(function(){
            $('#userArea').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[5, 10, 15, -1], [5, 10, 15, "All"]],
                iDisplayLength: 5,
                iDisplayStart: 0,
                "bSort": false,
                "bPaginate": true,
                "bProcessing": true,
                "fnDrawCallback": function ( oSettings ) {
                    /* Need to redo the counters if filtered or sorted */
                    if ( oSettings.bSorted || oSettings.bFiltered )
                    {
                        for ( var i=0, iLen=oSettings.aiDisplay.length ; i<iLen ; i++ )
                        {
                            $('td:eq(0)', oSettings.aoData[ oSettings.aiDisplay[i] ].nTr ).html( i+1 );
                        }
                    }
                },
                "aoColumnDefs": [
                    { "bSortable": false, "aTargets": [ 0 ] }
                ],
                "aaSorting": [[ 1, 'asc' ]]
                
                //            "aaSorting": [[ 5, "desc" ]]

            }).show();
            
        })
        
    </script>
    <script type="text/javascript">

 
        //            alert(minDateS)
        //alert('mindate'+minDateS)

        
        function saveUserArea(obj,index){
            var userId=$("#userId").val();
            var userName=$("#userName").val();
            var tradesId = $(obj).parent().parent().find("#trades").val();
            var notes = $(obj).parent().parent().find("#notes").val();
            var begin_date = $(obj).parent().parent().find("#begin_date").val();
            var end_date = $(obj).parent().parent().find("#end_date").val();
            var    areaId= $(obj).parent().parent().find("#areaId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/UsersServlet?op=saveUserArea",
                data: {
                    userId: userId,
                    tradesId: tradesId,
                    notes: notes,
                    begin_date: begin_date,
                    end_date:end_date,
                    areaId:areaId
                }
                ,
                success: function(jsonString) {
                    var result = $.parseJSON(jsonString);
  
                    if (result.status == 'Ok') {
                        $(obj).parent().parent().find("#save").css("background-position","top");
                        $(obj).parent().parent().find("#save").removeAttr("onclick");
                    } else if (result.status == 'No') {
                        alert("لم يتم الحفظ")
                    }
                }
            });
    
        }
        function beginDate(obj){
            $(obj).val("");
            $(function(){
                
                $(obj).datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                                 
                    dateFormat: "yy/mm/dd",

                    timeFormat: "hh:mm:ss"
                });    
            })
            
        }
        function endDate(obj){
                        
            $(obj).datetimepicker({
                changeMonth: true,
                changeYear: true,
                minDate:$(obj).parent().parent().find("#begin_date").val(),            
                dateFormat: "yy/mm/dd",

                timeFormat: "hh:mm:ss"
            });    
                
        }
    
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
            
        function upsertSiteRelation(c, x) {
            var firstEmpId = $("#empOne").val();
                
            var secondEmpArr = $('input[name=empTwo]');
            var secondEmpId = $(secondEmpArr[x-1]).val();
                
            var commentsArr = $('input[name=comments]');
            var comments = $(commentsArr[x-1]).val();
            //alert("values: 1st emp= "+firstEmpId+'  2nd emp= '+secondEmpId);
                
            if (firstEmpId == null || firstEmpId == '') {
                alert("Please choose a valid employee first!");

            } else {
                $("#save" + x).html("<img src='images/icons/spinner.gif'/>");
  
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=upsertEmpRelation",
                    data: {firstEmpId: firstEmpId,
                        secondEmpId: secondEmpId,
                        comments: comments},
                        
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);

                        if(eqpEmpInfo.status == 'Ok') {
                                
                            $("#save" + x).html("");
                            $("#save" + x).css("background-position", "top");

                        }
                    }
                });
            }
        }
        function remove2(obj){
          
            $(obj).parent().parent().remove();
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
        function showUserArea(obj){
          
            var url = "<%=context%>/UsersServlet?op=showUserArea&userId=" + $("#userId").val() ;
            $('#showUserArea').load(url);
            $('#showUserArea').css("display", "block");
       
            $('#showUserArea').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown',follow:[false, false],modalColor: 'black'});
        }
    </script>
    <STYLE type="text/css">

        .login1{
            direction: rtl;
            margin: 20px auto;
            padding: 10px 5px;
            /*        width:30%;*/
            background: #3f65b7;
            background-clip: padding-box;
            border: 1px solid #ffffff;
            border-bottom-color: #ffffff;
            border-radius: 5px;
            color: #ffffff;
            background: #7abcff; /* Old browsers */
            /* IE9 SVG, needs conditional override of 'filter' to 'none' */
            /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
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
            border-radius: 20px;}</style>
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
                                <p><b> <%=siteStr%> <font color="#FF0000">*</font></b>
                            </TD>
                            <TD style="border: none; padding-<%=dir1%>: 5px;text-align: right">
                                <input type="hidden" name="empOne" id="userId" value="" />
                                <input type="text" name="empName" id="userName" value="" onchange="clearUnitId();" onclick="return getDataInPopup('UsersServlet?op=listUnattachedEmployees&fieldName=USER_NAME&fieldValue=&formName=ATTACH_EMPS_FORM&selectionType=multi&firstEmpId=' + document.getElementById('empOne').value);" readonly="readonly"/>
                                &nbsp;&nbsp;
                                <div style="text-align: center;background-image: url(images/icons/status_.png) ;background-repeat: no-repeat;width: 24px;height: 24px;display: inline-block" onclick="return getDataInPopup('UsersServlet?op=listAllUsers&fieldName=USER_NAME&fieldValue=&formName=ATTACH_EMPS_FORM&selectionType=multi&firstEmpId=' + document.getElementById('userId').value);">

                                </div>

                            </td>
                        </TR>
                        <TR>

                            <TD style="<%=style%>; padding-<%=dir1%>: 5px;" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <p><b> <%=sitesStr%> <font color="#FF0000">*</font></b>
                            </TD>
                            <TD style="border: none; padding-<%=dir1%>: 5px;text-align: right">
                                <!--<input type="button" id="secondEmpSearchBtn" name="Attach Emps"  style="text-align: center;" onclick="return getDataInPopup('UsersServlet?op=listUnattachedEmployees&fieldName=USER_NAME&fieldValue=&formName=ATTACH_EMPS_FORM&selectionType=multi&firstEmpId=' + document.getElementById('empOne').value);" disabled value="Attach Emps"/><img src="images/refresh.png" align="middle" width="24" height="24"/>-->
                                &nbsp;&nbsp;&nbsp;<input type="button" id="listArea" name="listArea" value="List Area" style="text-align: center;" onclick="window.open('<%=context%>/EquipmentServlet?op=getAllArea', '_blank', 'status=1,scrollbars=1,width=400')" disabled/>
                                <input type="button" id="user_area" name="listArea" value="show user area" style="text-align: center;" onclick="showUserArea(this)" disabled/>
                            </td>
                        </TR>
                    </TABLE>
                    <br /><br />

                    <DIV id="tblDataDiv" style="display: block;">
                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="80%" cellpadding="0" cellspacing="0">
                            <TR>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%" ><b>التخصص</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" id="empNameShown" value=""><b><%=projectStr%> &nbsp; <%=empNameShown%> </b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=distanceStr%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>تاريخ البداية</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>تاريخ النهاية</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=save%></b></TD>
                                <!--<TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=deleteStr%></b></TD>-->
                            </TR>
                        </TABLE>
                    </DIV>

                    <br /><br />
                </FIELDSET>
            </CENTER>
        </FORM>
        <div id="showUserArea"  style="width: 70% !important;display: none;margin-left: auto;margin-right: auto;text-align: center;position: fixed ;">

        </div>
    </BODY>
</HTML>
