<%@page import="com.businessfw.hrs.servlets.EmployeeServlet"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String fDate, tDate;
        Calendar c = Calendar.getInstance();
        String jDateFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        sdf = new SimpleDateFormat("yyyy-MM-dd");
        tDate = sdf.format(c.getTime());
        fDate = sdf.format(c.getTime());

        Calendar calendar = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd HH:mm";
        sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(calendar.getTime());
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ArrayList<WebBusinessObject> reqTypLst1 = new ArrayList<WebBusinessObject>();
        {
            try {
                reqTypLst1 = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("ERQ", "key4"));
            } catch (Exception ex) {
                Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

        ArrayList<WebBusinessObject> reqTypLst = (ArrayList<WebBusinessObject>) request.getAttribute("reqTypLst") == null ? reqTypLst1 : (ArrayList<WebBusinessObject>) request.getAttribute("reqTypLst");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String title, HfromDate, HtoDate, submit, note, reqScaved, reqNsaved, ReqTyp,
                Choliday, Eper, Latt, PfromDate, PtoDate, Sholiday, requestTime;
        if (stat.equals("En")) {
            title = "Requests";
            HfromDate = "Holiday From Date";
            HtoDate = "Holiday To Date";
            PfromDate = "From Date";
            PtoDate = "To Date";
            submit = "Submit";
            note = "Notes";
            reqScaved = "Request Has Been Saved";
            reqNsaved = "Request Not Saved";
            ReqTyp = "Request Type";
            Choliday = "Casual Holiday";
            Eper = "Departure Permission";
            Latt = "Attendence Permission";
            Sholiday = "Standard Holiday";
            requestTime = "Request Time";
        } else {
            title = "الطلبات";
            HfromDate = "تاريخ بداية الاجازه";
            HtoDate = "تاريخ نهاية الاجازه";
            PfromDate = "من تاريخ";
            PtoDate = "الى تاريخ";
            submit = "تسجيل";
            note = "ملاحظات";
            reqScaved = "تم حفظ الطلب";
            reqNsaved = "لم يتم حفظ الطلب";
            ReqTyp = "نوع الطلب";
            Choliday = "اجازة عارضة";
            Eper = "اذن انصراف";
            Latt = "اذن حضور";
            Sholiday = "اجازة اعتيادية";
            requestTime = "مدة الطلب";
        }
        String empID = (String) request.getAttribute("empID") == null ? (String) loggedUser.getAttribute("userId") : (String) request.getAttribute("empID");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/silkworm_validate.js" type="text/javascript"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="js/jquery-ui.js"></script>




        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        <link rel="stylesheet" type="text/css" href="js/w2ui/w2ui-1.5.rc1.min.css" />

        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>  

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>

        <style>
            .tbFStyle{
                background: silver;
                width: auto; 
                text-align: right; 
                margin-bottom: 10px !important; 
                margin-left: 135px; 
                margin-right: auto; 
                letter-spacing: 35px;
                border-radius: 10px;
                padding-right: 20px;
            }

            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }
        </style>

        <script type="text/javascript" language="javascript">


            $(document).ready(function () {
                //changejsp();
                $("#OfromDate,#OtoDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm",
                    onSelect: function () {
                        var event;
                        if (typeof window.Event === "function") {

                            //create date format   
                            var date1 = new Date($("#OfromDate").val()).getTime();
                            var date2 = new Date($("#OtoDate").val()).getTime();
                            var msec = date2 - date1;
                            var mins = Math.floor(msec / 60000);
                            var hrs = Math.floor(mins / 60);
                            var days = Math.floor(hrs / 24);
                            
                            $("#day").val(days);
                            $("#hour").val(hrs % 24);
                            $("#minute").val(mins % 60);
                        }
                    }
                });
            });

            function submitRequest() {
                var empID = '<%=empID%>';
                var reqTyp = $("#reqTyp option:selected").val();
                var fDate = $("#OfromDate").val();
                var tDate = $("#OtoDate").val();
                var notes = $("#notes").val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/EmployeeServlet?op=submitHolidayRequest',
                    data: {
                        fDate: fDate,
                        tDate: tDate,
                        notes: notes,
                        reqTyp: reqTyp,
                        empID: empID
                    },
                    success: function (dataStr) {
                        console.log("dataStr " + dataStr);
                        var result = $.parseJSON(dataStr);
                        try {
                            if (result.status == 'OK') {
                                alert("<%=reqScaved%>");
                                location.reload();
                            } else {
                                alert("<%=reqNsaved%>");
                            }
                        } catch (err) {
                        }
                    }
                });
            }

            function changejsp() {
                var reqTyp = $("#reqTyp").val();
                if (reqTyp != null && reqTyp == "Choliday") {
                    $("#HFD").show();
                    $("#HTD").show();
                    $("#OFD").hide();
                    $("#OTD").hide();
                } else if (reqTyp != null && reqTyp == "per") {
                    $("#HFD").hide();
                    $("#HTD").hide();
                    $("#OFD").show();
                    $("#OTD").show();
                } else if (reqTyp != null && reqTyp == "half") {
                    $("#HFD").hide();
                    $("#HTD").hide();
                    $("#OFD").show();
                    $("#OTD").show();
                }
            }
        </script>
    </head>
    <body>
        <!-- <table border="0px" class="table tbFStyle" style="margin-top: -10px">
             <tr style="padding: 0px 0px 0px 50px;">
                 <td class="td" style="text-align: center;">
                     <a title="Back" style="padding: 5px;">
                         <image style="height:42px;" src="images/icons/BACKNEWTO.png" onclick="window.history.go(-1);"/>
                     </a>
                 </td>
             </tr>
         </table>-->

        <FIELDSET class="set" style="width:85%;border-color: #006699">
            <br/>
            <br/>
            <form  NAME="holiday_request_form" action="<%=context%>/ReportsServletThree?op=CampaignsBarChartReport" METHOD="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <TABLE class="blueBorder" ALIGN="center" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="60%" STYLE="border-width:1px;border-color:white;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="250px">
                            <b><font size=3 color="white"> <%=ReqTyp%></b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <SELECT id="reqTyp" name="reqTyp" style="width:250px;">
                                <sw:WBOOptionList wboList='<%=reqTypLst%>' displayAttribute="projectName" valueAttribute="projectID"/>
                                <%-- <sw:WBOOptionList wboList='<%=reqTypLst%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>--%>
                            </SELECT>
                        </td>
                    </tr>
                    <tr id="HFD" style="display: none;">
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="250px">
                            <b><font size=3 color="white"> <%=HfromDate%></b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <input type="text" style="width:250px" id="fromDate2" name="fromDate2" size="20" maxlength="100" readonly="true"
                                   value="<%=fDate%>"/>
                        </td>
                    </tr>

                    <tr id="HTD" style="display: none;">
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="250px">
                            <b><font size=3 color="white"> <%=HtoDate%></b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <input type="text" style="width:250px" id="toDate2" name="toDate2" size="20" maxlength="100" readonly="true" 
                                   value="<%=tDate%>"/>
                        </td>
                    </tr>

                    <tr id="OFD">
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="250px">
                            <b><font size=3 color="white"> <%=PfromDate%></b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <input type="text" style="width:250px" id="OfromDate" name="OfromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=nowTime%>"/>
                        </td>
                    </tr>

                    <tr id="OTD">
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="250px">
                            <b><font size=3 color="white"> <%=PtoDate%></b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <input type="text" style="width:250px" id="OtoDate" name="OtoDate" size="20" maxlength="100" readonly="true"
                                   value="<%=nowTime%>"/>
                        </td>
                    </tr>

                    <tr id="OTD">
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="250px">
                            <b><font size=3 color="white"> <%=requestTime%></b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <input type="text" style="width:50px" id="day" name="day" size="50" readonly="true" value="0"/>
                            <Font color="red">يوم</font> 
                            <input type="text" style="width:50px" id="hour" name="hour" size="50" readonly="true" value="0"/>
                            <Font color="red">ساعة</font> 
                            <input type="text" style="width:50px" id="minute" name="minute" size="50" readonly="true" value="0"/>
                            <Font color="red">دقيقة</font>
                        </td>
                    </tr>

                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="250px">
                            <b><font size=3 color="white"> <%=note%></b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <textarea  style="width:250px" id="notes" name="notes" size="20" maxlength="500"></textarea>
                        </td>
                    </tr>
                    <TR>
                        <td  bgcolor="#dedede"  style="text-align:center; padding-bottom: 5px; padding-top: 5px;" valign="middle" colspan="2">
                            <input type="button" onclick="submitRequest();"  STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 35px; width: 60px;" value="<%=submit%>">
                        </td>
                    </TR>
                </TABLE>
            </form>
        </fieldset>
    </body>
</html>
