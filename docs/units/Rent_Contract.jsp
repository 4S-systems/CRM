
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.Calendar"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    Calendar calendar = Calendar.getInstance();

    String context = metaMgr.getContext();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String now = sdf.format(calendar.getTime());

    //ArrayList FAccountType = (ArrayList) request.getAttribute("FAccountType");
    //ArrayList purposeArrayList = (ArrayList) request.getAttribute("purposeArrayList");
    ArrayList clientsList = (ArrayList) request.getAttribute("clientsList");
    //String businessID = (String) request.getAttribute("businessID");
    String status = (String) request.getAttribute("status");
    String projectID=(String)request.getAttribute("projectID");
    
%>
<html>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <%-- islamic calendar jquery libs--%>
        <!--<link rel="stylesheet" type ="text/css" href="js/islamic_calendar/jquery.calendars.picker.css">-->
        <link rel="stylesheet" type="text/css" href="js/jquery.calendars.picker.css">
        <%-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>--%>
        <script type="text/javascript" language="javascript" src="js/islamic_calendar/jquery.plugin.js"></script>
        <script type="text/javascript" language="javascript" src="js/islamic_calendar/jquery.calendars.js"></script>
        <script type="text/javascript" language="javascript" src="js/islamic_calendar/jquery.calendars.plus.js"></script>
        <script type="text/javascript" language="javascript" src="js/islamic_calendar/jquery.calendars.picker.js"></script>
        <%-- <script type="text/javascript" language="javascript" src="js/islamic_calendar/jquery.calendars.islamic.js"></script>
        <script type="text/javascript" language="javascript" src="js/islamic_calendar/jquery.calendars.islamic-ar.js"></script>--%>
        <script type="text/javascript" language="javascript" src="js/islamic_calendar/jquery.calendars.ummalqura.js"></script>
        <script type="text/javascript" language="javascript" src="js/islamic_calendar/jquery.calendars.ummalqura-ar.js"></script>
        <%-- End islamic calendar jquery libs --%>
    <script type="text/javascript">
        <%-- islamic calendar script--%>
        
        $(function() {
	var calendar = $.calendars.instance('ummalqura','ar');
	//$('#popupDatepicker').calendarsPicker({calendar: calendar});
        //$('#popupDatepicker2').calendarsPicker({calendar: calendar});
      //  $('#startDatee').calendarsPicker({calendar: calendar, onClose:islToChr});//formatDate: 'dd/mm/yyyy'});
       // $('#endDatee').calendarsPicker({calendar: calendar, onClose:NoOfMonths()});//onSelect:NoOfMonths onClose:islToChr});//formatDate:'dd/mm/yyyy'});
       $('#startDatee').calendarsPicker({calendar: calendar, onSelect:function(){
            var dstart=$('#startDatee').calendarsPicker('getDate');
            var startdate=islToChr(dstart);
            //alert(startdate);
            document.getElementById('startDate').value=startdate;
       }})
        $('#endDatee').calendarsPicker({calendar: calendar, onSelect: function(){
               var d11 = $('#startDatee').calendarsPicker('getDate');
                var d22= $('#endDatee').calendarsPicker('getDate');
                var d1=new Date(d11);
                var d2= new Date(d22);
                var days=Math.ceil((d2 - d1) / (1000 * 60 * 60 * 24));
                var monthss=Math.round(days/30);
                document.getElementById('contractPeriod').value=monthss;
                //islToChr(d22);
                var enddate=islToChr(d22);
              //  alert (enddate);
                document.getElementById('endDate').value=enddate;
            }
       })
	
});

function showDate(date) {
	alert('The date chosen is ' + date);
}

function NoOfMonths() {
    /*var Nomonths;
    var date1=document.getElementById('startDatee').value;
    var date2=document.getElementById('endDatee').value;
    var yyyy1 = date1.getFullYear().toString();
    var mm1 = (date1.getMonth()+1).toString();
    var dd1  = date1.getDate().toString();
    var yyyy2 = date2.getFullYear().toString();
    var mm2 = (date2.getMonth()+1).toString();
    var dd2  = date2.getDate().toString();
    Nomonths=(yyyy2-yyyy1)*12;
    Nomonths-=mm1;
    Nomonths+=mm2;
        //date1=yyyy+'/'+mm+'/'+dd;
   // alert(date1);
   // var date2=document.getElementById('endDatee').value;
   // Nomonths= (date2.getFullYear() - date1.getFullYear()) * 12;
   // Nomonths-= date1.getMonth() + 1;
    Nomonths+= date2.getMonth() +1; // we should add + 1 to get correct month number
   // return Nomonths <= 0 ? 0 : Nomonths;
 
d1 = new Date($( "#startdatee" ).val());
d2 = new Date($( "#enddatee").val());
alert(monthDiff(d1, d2));  
    alert(Nomonths);
    dcoument.getElementById("contractPeriod").value=Nomonths;*/

        
        var d11=document.getElementById('startDatee').value;
    var d22=document.getElementById('endDatee').value;
//var d11 = $('#startDatee').calendarsPicker('getDate');
//var d22= $('#endDatee').calendarsPicker('getDate');
var d1=new Date(d11);
var d2= new Date(d22);
 //months = (d2.getFullYear() - d1.getFullYear()) * 12;
 //   months -= d1.getMonth() + 1;
 //   months += d2.getMonth();
//alert(months);
var d1Manth=d1.getMonth()+1;
var d1Year=d1.getFullYear();
var d2Manth=d2.getMonth() + 1;
var d2Year=d2.getFullYear();
//alert('first month is '+d1Manth);
//alert('first year is '+d1Year);
//alert('2nd month is '+d2Manth);
//alert('2nd year is  '+d2Year);
var days=Math.ceil((d2 - d1) / (1000 * 60 * 60 * 24));
var monthss=Math.round(days/29);
//alert ('the months are: ' + monthss);
document.getElementById('contractPeriod').value=monthss;
islToChr(d22);
//alert ('the days are: ' +days);
//}
}


<%-- End islamic calendar script--%>
           
            function submit() {
                //if (!validateData("req", document.Contract_Form.contractNumber, "من فضلك ادخل رقم العقد...")) {
                //    $("#contractNumber").focus();
                //} else if (!validateData("req", document.Contract_Form.monthlyRent, "من فضلك ادخل  قيمة التعاقد  ..")) {
                //    $("#monthlyRent").focus();
                if (!validateData("req", document.Contract_Form.monthlyRent, "من فضلك ادخل  قيمة التعاقد  ..")) {
                    $("#monthlyRent").focus();
                } else if (!validateData("req", document.Contract_Form.startDatee, "من فضلك ادخل تاريخ بداية التعاقد  ..")) {
                    $("#startDatee").focus();
                } else if (!validateData("req", document.Contract_Form.endDatee, "من فضلك ادخل تاريخ نهاية التعاقد  ..")) {
                    $("#endDatee").focus();
                    } else if ( $('#startDatee').calendarsPicker('getDate')>= $('#endDatee').calendarsPicker('getDate')) {
           alert('تاريخ بداية التعاقد يجب ان يكون اقل  من تاريخ نهاية التعاقد ');        
            $("#endDatee").focus();
                } else {
                    //alert('entred her ');
                    <%--document.Contract_Form.action = "<%=context%>/FinancialServlet?op=saveFinTransaction2&businessID=" +<%=businessID%> + "&documentNumber=" + $("#documentNumber").val() + "&documentDate=" + $("#documentDate").val() + "&accountCode=" + $("#accountCode").val() + "&FTypeID=" + $("#FTypeID").val() + "&purposeID=" + $("#purposeID").val() + "&sourceKind=" + $("#sourceKind").val() + "&source=" + $("#source").val() + "&destinationKind=" + $("#destinationKind").val() + "&destination=" + $("#destination").val() + "&transValue=" + $("#transValue").val() + "&transNetValue=" + $("#transNetValue").val() + "&notes=" + $("#notes").val();--%>
                    document.Contract_Form.action = "<%=context%>/UnitServlet?op=saveRentContract&contractNumber=" +$("#contractNumber").val()+ "&projectID=" + <%=projectID%> + "&clientID=" + $("#clientID").val() + "&startDatee=" + $("#startDate").val() + "&endDatee=" + $("#endDate").val() + "&contractPeriod=" + $("#contractPeriod").val() + "&monthlyRent=" + $("#monthlyRent").val()+  "&sponcer=" + $("#sponcer").val() + "&paymentKind=" + $("#paymentKind").val();
                    document.Contract_Form.submit();
                }
            }

                       
            function intPart(floatNum){
if (floatNum< -0.0000001){
	 return Math.ceil(floatNum-0.0000001);
	}
return Math.floor(floatNum+0.0000001);	
}
            
            function islToChr(arg1) {
var arg=new Date(arg1);
y=arg.getFullYear();
m=arg.getMonth()+1;
d=arg.getDate();
	jd=intPart((11*y+3)/30)+354*y+30*m-intPart((m-1)/2)+d+1948440-386;
	
					if (jd> 2299160 )
						{
						 l=jd+68569;
						 n=intPart((4*l)/146097);
						l=l-intPart((146097*n+3)/4);
						 i=intPart((4000*(l+1))/1461001);
						l=l-intPart((1461*i)/4)+31;
						 j=intPart((80*l)/2447);
						d=l-intPart((2447*j)/80);
						l=intPart(j/11);
						m=j+2-12*l;
						y=100*(n-49)+i+l;
						}	
					else	
						{
						 j=jd+1402;
						 k=intPart((j-1)/1461);
						 l=j-1461*k;
						 n=intPart((l-1)/365)-intPart(l/1461);
						 i=l-365*n+30;
						j=intPart((80*i)/2447);
						d=i-intPart((2447*j)/80);
						i=intPart(j/11);
						m=j+2-12*i;
						y=4*k+n+i-4716;
						}

	
//alert(d + '/' + m + '/' + y);
var chrdate=y+'-'+m+'-'+d;
var chdate=new Date(chrdate);
//alert(chdate);
return chrdate;
}
            
        </script>
    </head>
    <body>
        <fieldset class="set" style="width:90%;border-color: #006699">
            <div align="left" style="color:blue; margin-left: 2.5%">
                <button type="button" onclick="JavaScript: submit()" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">حفظ&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18"/></button>
                <%--  <button type="button" onclick="JavaScript: detailes()" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">إضافة&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18"/></button>--%>
            </div>

            <br/>
            <table align="center" width="90%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td class="titlebar" style="text-align: center">
                        <font color="#005599" size="4">عقد ايجار</font>&nbsp;<img width="40" height="40" src="images/finical-rebort.png" style="vertical-align: middle;"/> 
                    </td>
                </tr>
            </table>

            <br>

            <form name="Contract_Form" method="post">
                <%if (status != null && status.equals("ok")) {%>
                <br>
                <table align="center" dir="ltr" WIDTH="90%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="blue">تم الحفظ بنجاح</font>
                        </td>
                    </tr>
                </table>
                <%} else {%>

                <%}%>
                <%if (status == null ) {%>
                <div style="width: 90%; ">
                    <div style="width: 100%;margin-top: 1%; "> 
                        <div style="width: 100%;display: inline-block; "> 
                            <%--<div style="text-align:center;width: 180px;height: 25px;padding:5px 0 0 5px;  display: inline-block;margin-left: -75px" class="selver2">--%>
                             <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -178px" class="selver2">
                                <font color="black" size="3">: كود الوحدة</font>
                            </div>
                            <div style="font-weight: bold;width: 64%;text-align: right;float: left;margin-right:  10px;padding-top: 5px">
                                <%=request.getAttribute("projectName")%>                
                            </div>
                            
                        </div></div>
                                <%--<div style="width: 40%;display: inline-block; "> 
                            <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -75px" class="selver2">
                                <font color="black" size="3">: رقم العقد</font>
                            </div>
                            <div style="text-align: right;float: left;margin-right: 10px;">
                                <input id="contractNumber" name="contractNumber" type="number" style="width: 150px;height: 30px" />                
                            </div>
                                                      
                        </div>
                        
                    </div>--%>
                    <div style="width: 100%;margin-top: 1%; ">
                        <div style="width: 100%;display: inline-block; "> 
                            <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -167px" class="selver2">
                                <font color="black" size="3">: اسم العميل</font>
                            </div>
                            <div style="text-align: right;float: left;margin-left: 235px;">
                               <%-- <input id="accountCode" name="accountCode" type="number" style="width: 150px;height: 30px" /> --%>
                               <%if (clientsList.size() > 0 && clientsList != null) {%>
                            <select style="width: 94%;height: 30px; font-weight: bold; font-size: 13px;" id="clientID" name="clientID">
                                <sw:WBOOptionList displayAttribute="name" valueAttribute="id" wboList="<%=clientsList%>"/>
                            </select>
                            <% } else {%>
                            <select style="width: 100%;height: 30px; font-weight: bold; font-size: 13px;" id="clientID" name="clientID">
                                <option>لاشئ</option>
                            </select>
                            <%}%>
                            </div>
                        </div>
                        
                        
                        
                        
                        
                        
                                
                    </div>
                    <div style="width: 100%;margin-top: 1%; ">
                        <div style="width: 40%;display: inline-block; "> 
                            <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -75px" class="selver2">
                                <font color="black" size="3"><%--<%=request.getAttribute("projectName")%> --%>: مدة التعاقد</font>
                            </div>
                            <div style="text-align: right;float: left;margin-right: 10px;">
                                <%--<input id="contractPeriod" name="contractPeriod" type="number" style="width: 150px;height: 30px" />--%>
                                <input id="contractPeriod" name="contractPeriod" readonly type="text"   style="width :150px;height :30px"/> 
                            </div>
                    </div>
                        <div style="width: 40%;display: inline-block; "> 
                            <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -75px" class="selver2">
                                <font color="black" size="3">: اسم الكفيل</font>
                            </div>
                            <div style="text-align: right;float: left;margin-right: 10px;">
                                <input id="sponcer" name="sponcer" type="text" style="width: 150px;height: 30px" />                
                            </div>
                        </div>
                            
                    </div>
                            <div style="width: 100%;margin-top: 1%; ">
                        <div style="width: 40%;display: inline-block; "> 
                            <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -75px" class="selver2">
                                <font color="black" size="3">: نهاية التعاقد</font>
                            </div>
                            <div style="text-align: right;float: left;margin-right:  10px;">
                                <%-- <input id="endDate"  readonly  name="endDate" type="text" style="width: 150px;height: 30px" value="<%=now%>" />--%>
                                <input id="endDatee"  name="endDate" type="text"  style="width: 150px;height: 30px" <%--value="<%=now%>" --%>/>
                                
                            </div></div>
                            <div style="width: 40%;display: inline-block; "> 
                            <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -75px" class="selver2">
                                <font color="black" size="3">: بداية التعاقد</font>
                            </div>
                            <div style="text-align: right;float: left;margin-right:  10px;">
                                <%--<input id="startDate" readonly name="startDate" type="text" style="width: 150px;height: 30px" value="<%=now%>" />--%>
                                <input id="startDatee"  name="startDate" type="text" style="width: 150px;height: 30px" <%--value="<%=now%>"--%> />
                            </div>
                            </div></div>
                            <div style="width: 100%;margin-top: 1%; ">
                                <div style="width: 40%;display: inline-block; "> 
                            <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -65px" class="selver2">
                                <font color="black" size="3">: نظام الدفع</font>
                            </div>
                            <%--<div style="text-align: right;float: left;margin-right: 10px;">
                               <%-- <input id="monthlyRent" name="monthlyRent" type="number" style="width: 150px;height: 30px" /> 
                                <div style="width: 100px;text-align: right;float: left;margin-left: 75px;">--%>
                               <div style="width: 100px;text-align: right;float: left;margin-left: 50px;">
                            <select style="text-align: left;width: 100%;height: 30px; font-weight: bold; font-size: 13px;" id="paymentKind" name="paymentKind" onchange="getSourceList(this, 'source')">
                                <option value="1">يومى</option>
                                <option value="2">اسبوعى</option>
                                <option value="3">شهرى</option>
                                <option value="4">سنوى</option>
                            </select>    
                        </div>
                            </div>
                                                      
                           
                            <div style="width: 40%;display: inline-block; "> 
                            <div style="text-align:center;width: 180px;  display: inline-block;height: 25px;padding:5px 0 0 5px;margin-left: -75px" class="selver2">
                                <font color="black" size="3">: قيمة التعاقد</font>
                            </div>
                            <div style="text-align: right;float: left;margin-right: 10px;">
                                <input id="monthlyRent" name="monthlyRent" type="number" style="width: 150px;height: 30px" />                
                            </div>
                                                      
                            </div> </div>
                            
                            </div>
                    </div>
                    <div type="lable" id="startDate" visible="false" >
                    <div type="lable" id="endDate" visible="false">
                        <%}%>
            </form>
        </fieldset>
   
    </body>
</html>
