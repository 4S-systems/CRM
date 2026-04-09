<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@page pageEncoding="UTF-8" %>

<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        Vector employeeList = (Vector) request.getAttribute("data");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;
        String title, empNo, empName, empEmail, status, notes, reason, active, longLeav, resign, fired, emp_pdf;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Employee List";
            empNo = "Emplyee Number";
            empName = "Employee Name";
            empEmail = "Email";
            status = "Status";
            notes = "Notes";
            reason = "Reason";
            active = "Active";
            longLeav = "Long Leave";
            resign = "Resign";
            fired = "Fired";
            emp_pdf = "View Sheet";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "عرض الموظفين";
            empNo = "رقم الموظف";
            empName = "اسم الموظف";
            empEmail = "البريد الالكتروني";
            status = "الحالة";
            notes = "ملاحظات";
            reason = "السبب";
            active = "عامل";
            longLeav = "اجازة طويلة";
            resign = "استقال";
            fired = "رفد";
            emp_pdf = "عرض الملف";
        }
    %>   
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Employees List</TITLE>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script> 
    </HEAD>
    

    <script language="javascript" type="text/javascript">
        var users = new Array();
        $(document).ready(function () {
            $("#employees").css("display", "none");
            $('#employees').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
            }).fadeIn(2000);
            
            $("#change_status_dialog").dialog({
                autoOpen: false,
                resizable: false,
                height: "auto",
                width: 400,
                modal: true,
                buttons: {
                    Cancle: function() {
                        $( this ).dialog( "close" );
                    }
                }
            });
        });
        
            
            
        function open_change_status_dialog(id, oldStatus, newStatus, type) {
            status_id=id;
            status_oldStatus=oldStatus;
            status_type=type;
            status_newStatus=newStatus;
            $("#cause_text").val("");
            var change_status_tittle;
            if(newStatus == 72) {
                change_status_tittle="Activate Employee";
                $("#cause_option_tr_long_leave").hide();
                $("#cause_option_tr_resign").hide();
                $("#cause_option_tr_fired").hide();
            } else if(newStatus == 73) {
                change_status_tittle="Long Leave Employee";
                $("#cause_option_tr_long_leave").show();
                $("#cause_option_tr_resign").hide();
                $("#cause_option_tr_fired").hide();
            } else if(newStatus == 74) {
                change_status_tittle="Resign Employee";
                $("#cause_option_tr_long_leave").hide();
                $("#cause_option_tr_resign").show();
                $("#cause_option_tr_fired").hide();
            } else if(newStatus == 75) {
                change_status_tittle="Fired Employee";
                $("#cause_option_tr_long_leave").hide();
                $("#cause_option_tr_resign").hide();
                $("#cause_option_tr_fired").show();
            }
            
            //$('#change_status_dialog').dialog('option', 'title', change_status_tittle);
            //$("#change_status_dialog").dialog('open');
            
            //$('#change_status_dialog').css("display", "block");
            //$('#change_status_dialog').dialog();
            
            $('#change_status_dialog').css("display", "block");
            $('#change_status_dialog').bPopup({
                easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'
            });
        }
            
            function changestatus(){
                var cause_option_selected;
                if(status_newStatus == 72) {
                    cause_option_selected="";
                } else if(status_newStatus == 73) {
                    cause_option_selected=$("#cause_option_long_leave option:selected").val()+" - ";
                } else if(status_newStatus == 74) {
                    cause_option_selected=$("#cause_option_resign option:selected").val()+" - ";
                } else if(status_newStatus == 75) {
                    cause_option_selected=$("#cause_option_fired option:selected").val()+" - ";
                }
                $.ajax({
                    type: "post",
                    url: "<%=context%>/EmployeeServlet?op=changeEmployeeStatus",
                    data: {
                        id: status_id,
                        oldStatus : status_oldStatus,
                        newStatus : status_newStatus,
                        notes : cause_option_selected+$("#cause_text").val()
                    }, success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("Status Changed Successfully");
                            /*$("#change_status_result_dialog").dialog("open");
                            $("#dialog_msg").text("تم تغيير الحالة");*/
                            $("#currentStatus" + status_id).html(info.currentStatusName);
                            if (status_type == 'active') {
                                $("#active" + status_id).attr("disabled", "disabled");
                                $("#long-leave" + status_id).removeAttr("disabled");
                                $("#resigned" + status_id).removeAttr("disabled");
                                $("#fired" + status_id).removeAttr("disabled");
                            } else if (status_type == 'long-leave') {
                                $("#active" + status_id).removeAttr("disabled");
                                $("#long-leave" + status_id).attr("disabled", "disabled");
                                $("#resigned" + status_id).removeAttr("disabled");
                                $("#fired" + status_id).removeAttr("disabled");
                            } else if (status_type == 'resigned') {
                                $("#active" + status_id).removeAttr("disabled");
                                $("#long-leave" + status_id).removeAttr("disabled");
                                $("#resigned" + status_id).attr("disabled", "disabled");
                                $("#fired" + status_id).removeAttr("disabled");
                            } else if (status_type == 'fired') {
                                $("#active" + status_id).removeAttr("disabled");
                                $("#long-leave" + status_id).removeAttr("disabled");
                                $("#resigned" + status_id).removeAttr("disabled");
                                $("#fired" + status_id).attr("disabled", "disabled");
                            }
                            $("#change_status_dialog").dialog("close");
                        } else if (info.status == 'faild') {
                            /*$("#dialog_msg").text("لم يتم تغيير الحالة");
                            $("#change_status_result_dialog").dialog("open");*/
                            alert("لم يتم تغيير الحالة");
                        }
                    }
                });
            }
            
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }
        
    </script>

    <style>
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
        #row:hover{
            background-color: #EEEEEE;
        }
        .client_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addclient.png);
        }
        .company_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addCompany.png);
        }
        .enter_call {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
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
        .remove{
            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);
        }
        .toolBox {
            width:40px;
            height: 40px;
            float:right;
            margin: 0px;
            padding: 0px;
        }

        .toolBox a img {
            width: 40px important;
            height: 40px important;
            float: right;
            margin: 0px;
            padding: 0px;
            text-align: right;
        }
        .button2{
            font-family: "Script MT", cursive;
            font-size: 18px;
            font-style: normal;
            font-variant: normal;
            font-weight: 400;
            line-height: 20px;
            width: 134px;
            height: 32px;
            text-decoration: none;
            display: inline-block;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.8s;
            cursor: pointer;
            border-radius: 12px;
            border: 1px solid #008CBA;
            padding-left:2%;
            text-align: center;
        }


        .button2:hover {
            background-color: #afdded;
            padding-top: 0px;
        }
    </style>
    <BODY>

    <body>
        <form name="EMPLOYEE_LIST_FORM" METHOD="POST" action="">
            <fieldset align=center class="set">
                <legend align="center">

                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend >

                <%if (employeeList != null && !employeeList.isEmpty()) {
                %>
                <div style="width: 87%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir=<fmt:message key="direction"/> WIDTH="100%" id="employees" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=empNo%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=empName%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=empEmail%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=status%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=emp_pdf%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"></th>
                            </tr>
                        <thead>
                        <tbody>  
                            <%
                                Enumeration e = employeeList.elements();
                                LiteWebBusinessObject wbo = new LiteWebBusinessObject();
                                while (e.hasMoreElements()) {
                                    wbo = (LiteWebBusinessObject) e.nextElement();
                            %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <%if (wbo.getAttribute("empNO") != null) {%>
                                    <b><%=wbo.getAttribute("empNO")%></b>
                                    <%}
                                    %>
                                </TD>

                                <TD>
                                    <%if (wbo.getAttribute("empName") != null) {%>
                                    <b>
                                        <%=wbo.getAttribute("empName")%> 
                                        <a target="_blanck" href="<%=context%>/EmployeeServlet?op=ViewEmployee&empId=<%=wbo.getAttribute("empId")%>">
                                            <img src="images/comment_no.png" width="30" style="float: left;" title="تفاصيل"/>
                                        </a>
                                    </b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo.getAttribute("email") != null) {%>
                                    <b><%=wbo.getAttribute("email")%></b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <%if (wbo.getAttribute("statusEnName") != null) {%>
                                    <b><%=wbo.getAttribute("statusEnName")%></b>
                                    <%}%>
                                </TD>
                                <TD>
                                    <a id="pdf" href="<%=context%>/EmployeeServlet?op=employeeSheetPDF&empId=<%=wbo.getAttribute("empId")%>">
                                        <img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/>
                                    </a>
                                </TD>
                                <TD>
                                    <input type="button" id="active<%=wbo.getAttribute("empId")%>" value="<%=active%>" onclick="JavaScript: open_change_status_dialog('<%=wbo.getAttribute("empId")%>', '<%=wbo.getAttribute("status_name")%>', '72', 'active')" <%=wbo.getAttribute("status_name").toString().equalsIgnoreCase("72") ? "disabled": ""%>/>
                                
                                    <input type="button" id="long-leave<%=wbo.getAttribute("empId")%>" value="<%=longLeav%>" onclick="JavaScript: open_change_status_dialog('<%=wbo.getAttribute("empId")%>', '<%=wbo.getAttribute("status_name")%>', '73', 'long-leave')" <%=wbo.getAttribute("status_name").toString().equalsIgnoreCase("73") ? "disabled": ""%>/>

                                    <input type="button" id="resigned<%=wbo.getAttribute("empId")%>" value="<%=resign%>" onclick="JavaScript: open_change_status_dialog('<%=wbo.getAttribute("empId")%>', '<%=wbo.getAttribute("status_name")%>', '74', 'resigned')" <%=wbo.getAttribute("status_name").toString().equalsIgnoreCase("74") ? "disabled": ""%>/>

                                    <input type="button" id="fired<%=wbo.getAttribute("empId")%>" value="<%=fired%>" onclick="JavaScript: open_change_status_dialog('<%=wbo.getAttribute("empId")%>', '<%=wbo.getAttribute("status_name")%>', '75', 'fired')" <%=wbo.getAttribute("status_name").toString().equalsIgnoreCase("75") ? "disabled": ""%>/>
                                </TD>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>  

                    </TABLE>
                </div>
                <%
                    }
                %>
                </div>

                <br><br>
            </fieldset>
        </form>
        <div id="change_status_dialog"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>   
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <TABLE align="center" dir="<%=dir%>"  width="100%">
                    <TR id="cause_option_tr_long_leave" style="height:  50px">
                        <TD style="border: none">
                            <label for="cause_option_long_leave" id="cause_option_long_leave_lbl"align="center" >
                                 <%=reason%> 
                            </label>
                        </TD>

                        <TD style="border: none">
                            <select  name="cause_option_long_leave" id="cause_option_long_leave" style="width: 75% ;" align="<%=align%>">
                                <option value="Sick leave" selected="selected">Sick leave</option>
                                <option value="maternity leave" >maternity leave</option>
                                <option>Other</option>
                            </select>
                        </TD>
                    </TR>
                    
                    <TR id="cause_option_tr_resign" style="height:  50px">
                        <TD style="border: none">
                            <label for="cause_option_resign" id="cause_option_resign_lbl"align="center" >
                                 <%=reason%> 
                            </label>
                        </TD>

                        <TD style="border: none">
                            <select  name="cause_option_resign" id="cause_option_resign" style="width: 75% ;" align="<%=align%>">
                                <option value="There Is Better opportunity" selected="selected">There Is Better opportunity</option>
                                <option value=" Ill Treatment" >Ill Treatment</option>
                                <option>Other</option>
                            </select>
                        </TD>
                    </TR>
                    
                    <TR id="cause_option_tr_fired" style="height:  50px">
                        <TD style="border: none">
                            <label for="cause_option_fired" id="cause_option_fired_lbl"align="center" >
                                 <%=reason%> 
                            </label>
                        </TD>

                        <TD style="border: none">
                            <select  name="cause_option_fired" id="cause_option_fired" style="width: 75% ;" align="<%=align%>">
                                <option value="Lack of commitment" selected="selected">Lack of commitment</option>
                                <option value="bad behavior" >bad behavior</option>
                                <option value="Frequent absence">Frequent absence</option>
                                <option>Other</option>
                            </select>
                        </TD>
                    </TR>

                    <TR>
                        <TD style="border: none">
                            <label for="cause_text" align="center">
                                 <%=notes%> 
                            </label>
                        </TD>

                        <TD style="border: none">
                            <textarea  name="cause_text" id="cause_text" rows="5" cols="30" align="<%=align%>"></textarea>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD style="border: none" colspan="2">
                            <input style="margin: 5px; margin-right: 20px;" type="button" id="save" value="Save" onclick="JavaScript: changestatus()"/>
                        </TD>
                    </TR>
                </TABLE> 
            </div> 
        </DIV>                
    </body>
</html>


