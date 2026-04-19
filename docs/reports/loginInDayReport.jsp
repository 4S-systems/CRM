<%-- 
    Document   : loginInDay
    Created on : Aug 17, 2020, 2:28:24 PM
    Author     : mariam
--%>

<%@page import="com.clients.db_access.AppointmentMgr"%>
<%@page import="com.clients.servlets.AppointmentServlet"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.silkworm.common.GroupMgr"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.LoginHistoryMgr"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.sql.Time"%>
<%@page import="com.auth0.jwt.internal.org.bouncycastle.asn1.cms.TimeStampAndCRL"%>
<%@page import="java.sql.Date"%>
<%@page import="com.silkworm.common.UserGroupMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String sBDate = (String) request.getAttribute("fromDate");
        
        GroupMgr groupMgr=GroupMgr.getInstance();
        
        ArrayList<WebBusinessObject> departmentsList =(ArrayList<WebBusinessObject>)request.getAttribute("departmentsList");
        ArrayList<WebBusinessObject> usersLst =(ArrayList<WebBusinessObject>)request.getAttribute("usersLst");
                //new ArrayList(groupMgr.getAllGroups());
        String departmentID=request.getAttribute("department")!=null?(String) request.getAttribute("department"):"all";
        String userID=request.getAttribute("userID")!=null?(String) request.getAttribute("userID"):"all";
        String startDate = null;
        String toDateValue = null;
        
        if (sBDate != null && !sBDate.equals("")) {
            startDate = sBDate;
        } else {
            cal.add(Calendar.DAY_OF_MONTH, 0);
            startDate = sdf.format(cal.getTime());
        }
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String loginHr,department,userTitle,appointmentCount;
        String style, print, title, fromDate, toDate, firstEmployee, firstLogin, lastEmployee, lastLogin, loginDate,moreDetails,timeInterval,numOfLogin;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Login Report in Day";
            print = "View Report";
            fromDate = "In Date";
            toDate = "To Date";
            firstEmployee = "Employee Name";
            firstLogin = "First Login";
            lastEmployee = "Last Employee";
            lastLogin = "Last Login";
            loginDate = "Time";
            moreDetails="More Times";
            timeInterval="Time Interval";
            numOfLogin="Count login";
            loginHr="Login Hour";
            department="department";
            userTitle="User";
            appointmentCount="Appointment Count";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "تقرير الجضور فى يوم";
            print = "مشاهده التقرير";
            fromDate = "فى تاريخ";
            toDate = "الى تاريخ";
            firstEmployee = "اسم موظف";
            firstLogin = "أول حضور";
            lastEmployee = "أخر موظف";
            lastLogin = "أخر حضور";
            loginDate = "الوقت";
            moreDetails="كل دخول فى اليوم";
            timeInterval=" ساعات العمل";
            numOfLogin="عدد مرات الدخول";
            loginHr="ساعات الدخول";
            department="ادارة";
            userTitle="المستخدم";
            appointmentCount="عدد المكالمات";
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/highcharts-more.js"></script>
        <script src="https://code.highcharts.com/modules/xrange.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <script src="https://code.highcharts.com/modules/export-data.js"></script>
        <script src="https://code.highcharts.com/modules/accessibility.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet"></link>
        <script type="text/javascript">
            function submitForm() {
                document.EmployeesLoads.action = "<%=context%>/ReportsServletThree?op=getLoginInDay";
                document.EmployeesLoads.submit();
            }
            $(document).ready(function() {
                $("#fromDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
                //$("#department").val('<%=departmentID%>').change();
                $("#department").select2();
                //$("#userID").val('<%=userID%>').change();
                $("#userID").select2();
                
                
                Highcharts.chart('container', {
                    chart: {
                        type: 'columnrange',
                        inverted:true
                        
                    },
                    title: {
                        text: 'اوقات دخول المستخدمين'
                    },
                    subtitle: {
                        text: ''
                    },
                     plotOptions: {
                         series: {
                                states: {
                                    hover: {
                                        enabled: false
                                    }
                                }
                            },
                        columnrange: {
                            dataLabels: {
                                enabled: true,
                                align:'left',
                                formatter: function() {
                                    return Highcharts.dateFormat('%H:%M',this.y);
                                  }
                            }
                        }
                    },
                    tooltip:{enabled:false},
                    legend:{enabled:true,
                    layout: 'vertical',
                        align: 'right',
                        verticalAlign: 'top',
                        x: -100,
                        y: 100,
                        floating: true,
                        borderWidth: 1,
                        backgroundColor: '#FFFFFF',
                        shadow: true
                        },
                    yAxis: {
                        type:"datetime",
                        title:{
                        text:"اوقات الدخول"},
                        labels: {
                            style: {
                                fontWeight: 'bold',
                                color:'#6D869F'
                            },
                            formatter: function() {
                              return Highcharts.dateFormat('%H:%M',
                                                            this.value);
                            }
                          }},
                    xAxis: {
                        labels: {
                            style: {
                                color: 'black',
                                fontWeight: 'bold'
                            }
                        },
                        reversed:true
                ,categories: [<% if (data != null) {
                                for (int i = 0; i < data.size(); i++) {
                                    WebBusinessObject wbo_ = data.get(i);
                                    if (i > 0) {
                                        out.write(",");
                                    }
                                    out.write("'" + (String) wbo_.getAttribute("userName") + "'");
                                }
                            }%>],
                        
                        title: {
                            text: 'المستخدمين',
                            align: 'high'
                        }
                    },
                   
                    series: [{
                            name: 'اوقات الدخول',
                            showInLegend: false,
                            data: [<% if (data != null) {
                                SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                sdf2.setTimeZone(TimeZone.getTimeZone("GMT"));
                                    for (int i = 0; i < data.size(); i++) {
                                        WebBusinessObject wbo_ = data.get(i);
                                        if (i > 0) {
                                            out.write(",");
                                        }
                                        out.write("["+sdf2.parse(wbo_.getAttribute("minTime").toString()).getTime() +",");
                                        out.write(sdf2.parse(wbo_.getAttribute("maxTime").toString()).getTime()+2*60*60*1000+"]");
                                    }
                                }%>],
                                dataLabels: {
                                enabled: true,
                                align:'left',
                                formatter: function() {
                                    return Highcharts.dateFormat('%H:%M',this.y);
                                  }
                            }
                        
                        }]
                });

                
            });
            var data2;
            function getAllEntries(userID,username,totalHrs){
            
                divAttachmentTag = $("div[name='divDayEntries']");
                var fromDate = $("#fromDate").val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/ReportsServletThree?op=getEntriesByDay',
                    data: {
                        userID: userID,
                        day: fromDate
                    },
                    success: function (data) {
                       
                       var info=$.parseJSON(data);
                       data2=info;
                       var date=info[0].loginTime.substring(0,10);
                       
                       var div="<table style='direction:rtl;width: 65%;margin-left:50px;'><thead><th bgcolor='#C8D8F8'>#</th><th bgcolor='#C8D8F8'><%=loginHr%></th></thead>";
                       for(var i=0;i<info.length;i++){
                           var j=i+1;
                              div=div.concat("<tr><td>"+ j +"</td><td>"+info[i].loginTime.substring(11,16)+"</td></tr>");
                            };
                               div=div.concat("<tr><td bgcolor='#C8D8F8'><%=timeInterval%></td><td>"+totalHrs+"</td></tr></table>");
                        divAttachmentTag.html(div)
                                .dialog({
                                    modal: true,
                                    title: "اوقات دخول "+ username +"خلال اليوم "+date,
                                    show: "fade",
                                    hide: "explode",
                                    width: 450,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        
                                        Done: function () {
                                            
                                            divAttachmentTag.dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
            var dataajax;
            function getUsersbyDepart(obj){
            var departID=obj;
            if(departID!="all"){
            $.ajax({
                type:'post',
                url:'<%=context%>/ReportsServletThree?op=getUsersByDepart',
                data:{
                    departID:departID
                },
                success:function(data){
                    dataajax=data;
                    var result = $.parseJSON(data);
                        var options = [];
                        options.push("<option value='all'>", "الكل", "</option>");
                        try {
                            $.each(result, function () {
                                if (this.fullName) {
                                    options.push('<option value="', this.userId, '">', this.fullName, '</option>');
                                }
                            });
                        } catch (err) {
                            alert("error");
                        }
                        $("#userID").html(options.join(''));
                        $("#userID").select2();
                },error:function(){
                    alert("ajax error");
                }
            });
            }
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
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            .ui-dialog-title{
                direction:rtl;
            }
            #filterTbl tr{
                        border: 5px solid white;
                        height: 45px;

            }
        </style>
    </head>
    <body>
        <form name="EmployeesLoads" method="post"> 
            <br/>
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table id="filterTbl" ALIGN="center" DIR="RTL" WIDTH="62%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="45%">
                            <b><font size=3 color="white"><%=fromDate%></b>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" readonly value="<%=startDate%>" style="margin-right: 30px;"/><img src="images/showcalendar.gif"/> 
                            
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="45%">
                             <b><font size=3 color="white"><%=department%></b>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <SELECT id="department" name="department" STYLE="width:50%;font-size: medium; font-weight: bold;" onchange="javascript:getUsersbyDepart(this.value);" >
                                <option value="all">الكل</option>
                                <sw:WBOOptionList wboList='<%=departmentsList%>' displayAttribute = "projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>"/>
                            </SELECT>
                            
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="45%">
                             <b><font size=3 color="white"><%=userTitle%></b>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <SELECT id="userID" name="userID" STYLE="width:50%;font-size: medium; font-weight: bold;"  >
                                <option value="all">الكل</option>
                                <sw:WBOOptionList wboList='<%=usersLst%>' displayAttribute = "fullName" valueAttribute="userId" scrollToValue="<%=userID%>" />
                            </SELECT>
                            
                        </td>
                    </tr>
                    <tr>
                       <td STYLE="text-align:center;border:0px;padding:10px" colspan="2" rowspan="2" WIDTH="20%">
                            <button onclick="JavaScript: submitForm();" STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 25px"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"/> </button>
                        </td> 
                       
                    </tr>
                </table>
                <br/>
                <center>
                     <div id="container" style="width: 600px; height: 300px; margin: 0 auto; display: <%=data != null ? "" :"none"%>;"></div>
                    <%
                        if (data != null) {
                            
                    %>
                        <div>
                             ساعات العمل:تم افتراض ساعة بعد اخر دخول 
                            <img src="images/icons/pinfo.png" width="20px"/>
                    </div>
                    <table width="600" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0">
                        <tr bgcolor="#C8D8F8">
                            <td>
                                <%=firstEmployee%>
                            </td>
                            <td><%=numOfLogin%></td>
                            <td>
                                <%=timeInterval%>
                            </td>
                            <td>
                                <%=loginDate%>
                            </td>
                            <td>
                                 <%=appointmentCount%>       
                            </td>
                            
                            
                        </tr>
                        <%
                            SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
                                  AppointmentMgr ap=AppointmentMgr.getInstance();
                            for (WebBusinessObject wbo : data) {
                                  int diff=1;
                                  String minTime=wbo.getAttribute("minTime").toString();
                                  String maxTime=wbo.getAttribute("maxTime").toString();
                                  int t1=Integer.parseInt(minTime.substring(11, 16).split(":")[0]);
                                  int t2=Integer.parseInt(maxTime.substring(11, 16).split(":")[0]);
                                  int m1=Integer.parseInt(minTime.substring(11, 16).split(":")[1]);
                                  int m2=Integer.parseInt(maxTime.substring(11, 16).split(":")[1]);
                                  diff+=t2-t1;
                                  Date from =new java.sql.Date(sdf2.parse(minTime).getTime());
                                  Date to=new java.sql.Date(sdf2.parse(maxTime).getTime());
                                  int appointCount=ap.getAppointmentsCountInPeriod(wbo.getAttribute("userID").toString(),from,to);
                                  
                        %>
                        <tr>
                            <td>


                                <%=wbo.getAttribute("userName")%>
                            </td>
                            <td>
                                  <%=wbo.getAttribute("entryCount")%>      
                            </td>
                            <td>
                                <%=diff%>hrs
                            </td>
                            <td style="width: 25%;">
                                <%=minTime.substring(11, 16)%>
                                <img onclick="javascript:getAllEntries('<%=wbo.getAttribute("userID")%>','<%=wbo.getAttribute("userName")%>','<%=diff%>');" src="images/details.png" width="12%"/>
                            </td>
                            <td>
                                        <%=appointCount%>
                            </td>
                            
                            
                        </tr>      
                        <%
                            }
                        %>
                    </table>
                    <%
                        }
                    %>
                    <br/>
                    <br/>
                </center>
            </fieldset>
                    <div name="divDayEntries">
                        
                    </div>
        </form>
    </body>
</html>

