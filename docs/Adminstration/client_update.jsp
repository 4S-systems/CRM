<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.maintenance.db_access.TradeMgr"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>

<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    List<WebBusinessObject> userProjects = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));

    ArrayList<WebBusinessObject> seasonsList = (ArrayList<WebBusinessObject>) request.getAttribute("seasonsList");
    ArrayList<WebBusinessObject> jobs = (ArrayList<WebBusinessObject>) request.getAttribute("jobs");
    WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");

    //SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    //boolean isCanMoreEdit = securityUser.getUserId().equalsIgnoreCase((String) clientWbo.getAttribute("createdBy"));

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align, dir, style, saveFailMsg, sTitle, search, saveSuccessMsg,choose,notfound,yes,no;
    if (stat.equals("En")) {
	align = "left";
	dir = "LTR";
	style = "text-align:left";
	saveFailMsg = "Fail to Update";
	saveSuccessMsg = "Data Updated Successfully";
	sTitle = "Update Client Data";
	search = "Search";
	choose = "Choose";
	notfound = "Not Found";
	yes = "Yes";
	no = "No";
    } else {
	align = "right";
	dir = "RTL";
	style = "text-align:Right";
	saveFailMsg = "لم يتم التعديل, ربما يكون بيانات العميل موجودة من قبل.";
	saveSuccessMsg = "تم التعديل بنجاح";
	sTitle = "تحديث بيانات عميل";
	search = "بحث";
	choose = "اختر";
	notfound = "لا يوجد";
	yes = "نعم";
	no = "لا";
    }

    String knowUs = clientWbo.getAttribute("option3") + "";

    Vector<WebBusinessObject> mainRegion = (Vector<WebBusinessObject>) request.getAttribute("mainRegion");

    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
    ArrayList<String> userPrevList = new ArrayList<String>();
    WebBusinessObject wbo;
    for (int i = 0; i < groupPrev.size(); i++) {
	wbo = (WebBusinessObject) groupPrev.get(i);
	userPrevList.add((String) wbo.getAttribute("prevCode"));
    }
%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Client.client"  />

    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
	
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/silkworm_validate.js" type="text/javascript"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/validator.js" TYPE="text/javascript" />
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
        
         <link rel="stylesheet" href="jquery-multiSelect/jquery.multiselect.css">
        <link rel="stylesheet" href="css/chosen.css"/>
        <script type="text/javascript" src="js/jquery-ui-1.8.9.custom.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet"></link>
        
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        
        
        <script type="text/javascript">
            $(function() {
                $("#dialedNumber").chosen();
                $(".chosen-select-region").chosen();
                
                $("#birthDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd',
                    yearRange: "-100:+0"
                });
            });
	    
            function submitForm(){
                if (!validateData2("req", this.CLIENT_UPDATE.clientName) || !validateData2("minlength=3", this.CLIENT_UPDATE.clientName)) {
                    this.CLIENT_UPDATE.clientName.focus();
		    
                    if ($("#clientName").val() == "") {
                        $("#naMsg").show();
                        $("#naMsg").text("إسم العميل مطلوب");
                    } else if (!validateData2("minlength=3", this.CLIENT_UPDATE.clientName)) {
                        $("#naMsg").show();
                        $("#naMsg").text("الإسم اقل من 3 حروف");
                    } else {
                        $("#naMsg").hide();
                        $("#naMsg").html("");
                    }
		    
                    return false;
                }
		
                var phoneNo = this.CLIENT_UPDATE.phone.value;
                var mobileNo = this.CLIENT_UPDATE.mobile.value;
                var dialedNumber = this.CLIENT_UPDATE.dialedNumber.value;
                var interPhone = this.CLIENT_UPDATE.interPhone.value;
                if (phoneNo.trim() === "" && mobileNo.trim() === "" && dialedNumber.trim() === "" && interPhone.trim() === "") {
                    alert("يجب ادخال رقم تليفون واحد على الاقل");
                    return false;
                } else {
                    if (phoneNo.trim().length > 0 && phoneNo.trim().length < 8) {
                        alert("يجب ادخال رقم التليفون كامل او مسحه (من8 ألي 10 أرقام)");
                         $("#phone").focus();
                         return false;
                    }
		    
                    if (mobileNo.trim().length > 0 && mobileNo.trim().length < 11) {
                        alert("يجب ادخال رقم الموبايل كامل او مسحه (11 رقم)");
                        $("#mobile").focus();
                        return false;
                    }
		    
//                    if (dialedNumber.trim().length > 0 && dialedNumber.trim().length < 8) {
//                        alert("يجب ادخال رقم التليفون الطالب كامل او مسحه (من 8 ألي 14 رقم)");
//                        $("#dialedNumber").focus();
//                        return false;
//                    }

                    if (interPhone.trim().length > 0 && interPhone.trim().length < 10) {
                        alert("يجب ادخال رقم التليفون الدولي كامل او مسحه (من 10 ألي 16 رقم)");
                        $("#interPhone").focus();
                        return false;
                    }
                }
		
                if (!validateData2("email", this.CLIENT_UPDATE.email)) {
                    $("#mailMsg").show();
                    $("#mailMsg").html("بريد إلكترونى غير صحيح <br><font style='color:#005599;font-size:10px;'>For Example: mymail@yahoo.com</font>");
                    return false;
                }
		
                if (!validateData2("numeric", this.CLIENT_UPDATE.mobile)) {
                    this.CLIENT_UPDATE.mobile.focus();
		    
                    if (!validateData2("numeric", this.CLIENT_UPDATE.mobile)) {
                        $("#moMsg").show();
                        $("#moMsg").text("ارقام فقط");
                    } else {
                        $("#moMsg").hide();
                        $("#moMsg").html("");
                    }
		    
                    return false;
                }
                else {
                    $('#dialedNumber').removeAttr('disabled');
                    document.CLIENT_UPDATE.action = "<%=context%>/ClientServlet?op=UpdateClientData";
                    document.CLIENT_UPDATE.submit();
                }
            }
	    
            function checkMail(obj) {
                if (!validateData2("email", this.CLIENT_UPDATE.email)) {
                    $("#mailMsg").show();
                    $("#mailMsg").html("بريد إلكترونى غير صحيح <br><font style='color:#005599;font-size:10px;'>For Example: mymail@yahoo.com</font>");
                } else {
                    $("#mailMsg").hide();
                    $("#mailMsg").html("");
                }
            }
	    
            function checkTel(obj) {
                if (!validateData2("numeric", this.CLIENT_UPDATE.phone)) {
                    $("#telMsg").show();
                    $("#telMsg").html("ارقام فقط");
                } else {
                    $("#telMsg").hide();
                    $("#telMsg").html("");
                }
            }
	    
            function checkMobile(obj) {
                if (!validateData2("numeric", this.CLIENT_UPDATE.mobile)) {
                    $("#moMsg").show();
                    $("#moMsg").html("ارقام فقط");
                } else if ((mobile > 0 & phone > 0) & (mobile == phone)) {
                    $("#moMsg").show();
                    $("#moMsg").html("الرقم مكرر");
                } else {
                    $("#moMsg").hide();
                    $("#moMsg").html("");
                    $("#moMsg").html("");
                }
            }
	    
            function cancelForm() {
                try {
                    opener.getClientInfo('');
                } catch(err) {
                    opener.location.reload(false);
                }
                self.close();
            }
	    
	    function checkClientMobile(obj) {
		var clientMob = $("#mobile").val();
		//var clientInternationMob = $("#internationalM").val();
		//var phone = clientInternationMob + clientMob;
		if (clientMob.length > 0 && clientMob != $("#cmpMbl").val()) {
		    $.ajax({
			type: "post",
			url: "<%=context%>/ClientServlet?op=getClientMobile",
			data: {
			    mobile: clientMob
			},
			success: function(jsonString) {
			    var info = $.parseJSON(jsonString);
			    if (info.status == 'No') {
				$("#moMsg").css("color", "green");
				$("#mobMSG").css(" text-align", "left");
				$("#mobMSG").text("");
				$("#mobMSG").removeClass("error");
				$("#mobWarning").css("display", "none");
				$("#mobOk").css("display", "inline");
				$("#submitBtn").removeAttr("disabled");
				  $("#existmobClient").css("display","none");
			    } else if (info.status == 'Ok') {
				$("#mobMSG").css("color", "red");
				$("#mobMSG").css("font-size", "12px");
				$("#mobMSG").text(" محجوز");
				$("#mobMSG").addClass("error");
				$("#mobMSG").css("display", "inline");
				$("#mobWarning").css("display", "inline");
				$("#mobOk").css("display", "none");
				$("#submitBtn").attr("disabled", "true");

				 $("#existmobClient").css("display","inline");
				$("#existmobClient").text("View");
			    <%
				if (userPrevList.contains("EXISTS_CLIENT")) {
			    %>
				    $("#existmobClient").attr("href",  "<%=context%>/ClientServlet?op=clientDetails&clientId="+info.id);
			    <%
				} else {
			    %>
				    $("#existmobClient").attr("href",  "JavaScript: showDetails(" + info.id + ");");
			    <%
				}
			    %>

			    }
			}
		    });
		} else {
		    $("#existmobClient").css("display","none");
		    $("#mobOk").css("display", "none");
		    $("#mobWarning").css("display", "none");
		    $("#mobMSG").text("");
		}
	    }
	    
	    function checkClientInterPhone(obj) {
		var interPhone = $("#interPhone").val();
		
		if (interPhone.length > 0 && interPhone != $("#cmpinterPhone").val()) {
		    $.ajax({
			type: "post",
			url: "<%=context%>/ClientServlet?op=getClientInterPhone",
			data: {
			    interPhone: interPhone
			},success: function(jsonString) {
			    var info = $.parseJSON(jsonString);
			    if (info.status === 'No') {
				$("#interMSG").css("color", "green");
				$("#interMSG").css(" text-align", "left");
				$("#interMSG").text("");
				$("#interMSG").removeClass("error");
				$("#interWarning").css("display", "none");
				$("#interOk").css("display", "inline");
				$("#existinterClient").css("display","none");
				$("#submitBtn").removeAttr("disabled");
			    }else if (info.status === 'Ok') {
				$("#interMSG").css("color", "red");
				$("#interMSG").css("font-size", "12px");
				$("#interMSG").text(" محجوز");
				$("#interMSG").addClass("error");
				$("#interWarning").css("display", "inline");
				$("#interOk").css("display", "none");
				$("#existinterClient").css("display","inline");
				$("#existinterClient").text("View");
				 $("#submitBtn").attr("disabled", "true");
				$("#existinterClient").attr("href",  "<%=context%>/ClientServlet?op=clientDetails&clientId="+info.id);
			    }
			}
		    });
		} else {
		    $("#existinterClient").css("display","none");
		    $("#interOk").css("display", "none");
		    $("#interWarning").css("display", "none");
		    $("#interMSG").text("");
		}
	    }
	    
	    function checkClientPhone(obj) {
		var clientPhone = $("#phone").val();
		//var clientLocalPhone = $("#localP").val();
		//var clientInternationPhone = $("#internationalP").val();
		//var phone = clientInternationPhone + clientLocalPhone + clientPhone;
		if (clientPhone.length > 0 && clientPhone != $("#cmpphone").val()) {
		    $.ajax({
			type: "post",
			url: "<%=context%>/ClientServlet?op=getClientPhone",
			data: {
			    phone: clientPhone
			},success: function(jsonString) {
			    var info = $.parseJSON(jsonString);
			    
			    if (info.status == 'No') {
				$("#telMSG").css("color", "green");
				$("#telMSG").css("text-align", "left");
				$("#telMSG").css("display", "inline");
				$("#telMSG").text("");
				$("#submitBtn").removeAttr("disabled");
				$("#telMSG").removeClass("error");
				$("#telWarning").css("display", "none");
				$("#telOk").css("display", "inline");
				$("#existphoneClient").css("display","none");
			    } else if (info.status == 'Ok') {
				$("#telMSG").css("color", "red");
				$("#telMSG").css("display", "inline");
				$("#telMSG").css("font-size", "12px");
				$("#telMSG").text(" محجوز");
				$("#telMSG").addClass("error");
				$("#telWarning").css("display", "inline");
				$("#telOk").css("display", "none");
				 $("#submitBtn").attr("disabled", "true");
				$("#existphoneClient").css("display","inline");
				$("#existphoneClient").text("View");
				$("#existphoneClient").attr("href",  "<%=context%>/ClientServlet?op=clientDetails&clientId="+info.id);
			    }
			}
		    });
		} else {
		    $("#existphoneClient").css("display","none");
		    $("#telOk").css("display", "none");
		    $("#telWarning").css("display", "none");
		    $("#telMSG").text("");
		}
	    }
        </script>
	
        <style>
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }
	    
            .dataTD {
                text-align:center;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }
	    
            tr:nth-child(even) td.dataTD {
                background: #FFF;
            }
	    
            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1;
            }
	    
            .closeBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close2.png);
            }
	    
            .submitBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/submit.png);
            }
	    
            #moMsg, #telMsg, #naMsg, #mailMsg{
                font-size: 14px;
                display: none;
                color: red;
                margin: 0px;
            }
	    
            div.ui-datepicker{
                font-size:10px;
            }
	    
            .fnone {
                margin-right: 5px;
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
    </head>
    
    <BODY>
        <form name="CLIENT_UPDATE" action="<%=context%>/ClientServlet?op=UpdateClientData" METHOD="POST">
            <center>
                <input type="button" onclick="JavaScript:submitForm()" class="button2" value='Save' />
                <input type="button" onclick="JavaScript:cancelForm()" class="button2" value='Cancel' />
            </center>
	    
            <fieldset class="set" align="center" width="100%" style="width: 70%;margin-bottom: 10px;">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                     <%=sTitle%> 
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
				
                <%
                    if (request.getAttribute("status") != null && request.getAttribute("status").equals("ok")) {
                %>
			<b style="color: blue">
			     <%=saveSuccessMsg%> 
			</b>
                <%
		    } else if (request.getAttribute("status") != null && request.getAttribute("status").equals("fail")) {
                %>
			<b style="color: red">
			     <%=saveFailMsg%> 
			</b>
                <%
                    }
                %>
		
                <table  border="0px" dir="<%=dir%>" class="table" style="width:90%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                    <tr>
                        <td class="td">
                            <table>
                                <tr>
                                    <td class="td titleTD">
                                        <fmt:message key="clientid"/>
                                    </td>
				    
                                    <td class="td dataTD">
                                        <label>
					     <%=clientWbo.getAttribute("clientNO")%> 
					</label>
					
                                        <input type="hidden" name="clientNO" value="<%=clientWbo.getAttribute("clientNO")%>"/>
                                    </td>
				    
                                    <td class="td titleTD">
                                        <fmt:message key="phone"/>
                                    </td>
				    
                                    <td class="td dataTD">
                                        <input type="text" id="phone" name="phone" value="<%=clientWbo.getAttribute("phone") != null && !clientWbo.getAttribute("phone").equals("UL") ? ((String) clientWbo.getAttribute("phone")).trim() : ""%>" <%--onkeyup="checkClientPhone(this)"--%> onmouseout="checkClientPhone(this)" maxlength="10"/>
					
					<input type="hidden" id="cmpphone" value="<%=clientWbo.getAttribute("phone") != null && !clientWbo.getAttribute("phone").equals("UL") ? ((String) clientWbo.getAttribute("phone")).trim() : ""%>">
                                        
					<label id="telMSG">
					</label>
					
					<div id="telWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                            <IMG src="" width="16px" height="16px" style="background-color: transparent; border: none; background-image: url(images/warning.png); background-repeat: no-repeat;" />
                                        </div>
					
					<div id="telOk"style="display: none;width: 20px;height: 20px;border: none;">
                                            <IMG src="" width="16px" height="16px" style="background-color: transparent; border: none; background-image: url(images/ok2.png); background-repeat: no-repeat;" />
                                        </div>
					
					<a id="existphoneClient" class="linkbtn" style="display: none" href="#">
					     Exist 
					</a>
                                    </td>
                                </tr>
				
                                <tr>
                                    <td class="td titleTD">
                                         <fmt:message key="clientname"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <input <%=userPrevList.contains("EDIT_CLIENT_NAME") ? "" : "readonly"%> type="text" name="clientName" value="<%=clientWbo.getAttribute("name")%>" />
                                        
					<p id="naMsg">
					</p>
					
                                        <input type="hidden" id="clientId" name="clientId" value="<%=clientWbo.getAttribute("id")%>"/>
                                    </td>
				    
                                    <td class="td titleTD">
                                         <fmt:message key="mobile"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <input <%=userPrevList.contains("EDIT_PHONE") ? "" : "readonly"%> type="text" id="mobile" name="mobile" value="<%=clientWbo.getAttribute("mobile") != null && !clientWbo.getAttribute("mobile").equals("UL") ? ((String) clientWbo.getAttribute("mobile")).trim() : ""%>" onkeypress="checkMobile(this)" onblur="checkMobile(this)" onmouseout="javascript:return checkClientMobile(this)" maxlength="11"/>
                                        
					<input type="hidden" id="cmpMbl" value="<%=clientWbo.getAttribute("mobile") != null && !clientWbo.getAttribute("mobile").equals("UL") ? ((String) clientWbo.getAttribute("mobile")).trim() : ""%>">
					
					<label id="moMsg">
					</label>
					
					<div id="mobWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                            <IMG src="" width="16px" height="16px" style="background-color: transparent; border: none; background-image: url(images/warning.png); background-repeat: no-repeat;" />
                                        </div>
					
					<div id="mobOk"style="display: none;width: 20px;height: 20px;border: none;">
                                            <IMG src="" width="16px" height="16px" style="background-color: transparent; border: none; background-image: url(images/ok2.png); background-repeat: no-repeat;" />
                                        </div>
					
					<a id="existmobClient" class="linkbtn" style="display: none" href="#">
					    Exist 
					</a>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="td titleTD" nowrap>
                                         <fmt:message key="wifehusband"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <input type="text" name="partner" value="<%=clientWbo.getAttribute("partner") != null && !clientWbo.getAttribute("partner").equals("UL") ? clientWbo.getAttribute("partner") : ""%>" />
                                    </td>
				    
                                    <td class="td titleTD">
                                         <fmt:message key="internumber"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <input type="text" id="interPhone" name="interPhone" value="<%=clientWbo.getAttribute("interPhone") != null && !clientWbo.getAttribute("interPhone").equals("UL") ? ((String) clientWbo.getAttribute("interPhone")).trim() : ""%>" maxlength="16" onkeyup="javascript:return checkClientInterPhone(this)"/>
					
					<input type="hidden" id="cmpinterPhone" value="<%=clientWbo.getAttribute("interPhone") != null && !clientWbo.getAttribute("interPhone").equals("UL") ? ((String) clientWbo.getAttribute("interPhone")).trim() : ""%>">
					
					<LABEL id="interMSG" style="display :inline">
					</LABEL>
					
					 <div id="interWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                            <IMG src="" width="16px" height="16px" style="background-color: transparent; border: none; background-image: url(images/warning.png); background-repeat: no-repeat;" />
                                        </div>
					
					<div id="interOk"style="display: none;width: 20px;height: 20px;border: none;">
                                            <IMG src="" width="16px" height="16px" style="background-color: transparent; border: none; background-image: url(images/ok2.png); background-repeat: no-repeat;" />
                                        </div>
					
					<a id="existinterClient" class="linkbtn" style="display: none" href="#"> Exist </a>
                                    </td>
                                </tr>
				
                                <tr>
                                    <td class="td titleTD">
                                         <fmt:message key="socialstatus"/> 
                                    </td>
                                    
                                    <td class="td dataTD">
                                        <input type="text" name="matiralStatus" value="<%=clientWbo.getAttribute("matiralStatus") != null && !clientWbo.getAttribute("matiralStatus").equals("UL") ? clientWbo.getAttribute("matiralStatus") : "0"%>"/>
                                    </td>
				    
                                    <td class="td titleTD">
                                         <fmt:message key="knowUs"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <select <%=userPrevList.contains("EDIT_KNOWUS") ? "" : "disabled"%> name="dialedNumber" id="dialedNumber" style="font-weight: bold; font-size: 16px; width: 175px; direction: <%=dir%>; text-align: <fmt:message key="align"/>;">
                                            <option value=""> <fmt:message key="select" /> </option>
                                            <%
                                                for (WebBusinessObject seasonWbo : seasonsList) {
                                            %>
						    <option value="<%=seasonWbo.getAttribute("id")%>" <%=knowUs.equals(seasonWbo.getAttribute("id")) ? "selected" : ""%>> <%=seasonWbo.getAttribute("arabicName")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </td>
                                </tr>
				
                                <tr>
                                    <td class="td titleTD">
                                         <fmt:message key="gender"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <table style="width: 90%">
                                            <tr>
						<td>
						    <span>
							<input type="radio" name="gender" value="ذكر" <%=clientWbo.getAttribute("gender").equals("ذكر") || clientWbo.getAttribute("gender").equals("UL") ? "checked" : ""%>/>
							
							<font size="3" color="#005599">
							    <b>
								 <fmt:message key="male"/> 
							    </b>
							</font>
						    </span>
						</td>
					    
						<td>
						    <span>
							<input type="radio" name="gender" value="أنثى" <%=clientWbo.getAttribute("gender").equals("أنثى") ? "checked" : " "%>/>

							<font size="3" color="#005599">
							    <b>
								 <fmt:message key="female"/> 
							    </b>
							    </font>
						    </span>
						</td>
					     </tr>
                                        </table>
                                    </td>
				    
                                    <td class="td titleTD">
                                         <fmt:message key="address"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <input type="text" name="address" value="<%=clientWbo.getAttribute("address") != null && !clientWbo.getAttribute("address").equals("UL") ? clientWbo.getAttribute("address") : ""%>"/>
                                    </td>
                                </tr>
				
                                <tr>
                                    <td class="td titleTD">
                                         <fmt:message key="birthdate"/> 
                                    </td>
				    
                                    <td class="td dataTD calender" nowrap>
                                        <%
                                            String birthDateStr = "";
                                            if (clientWbo.getAttribute("birthDate") != null) {
                                                birthDateStr = ((String) clientWbo.getAttribute("birthDate")).split(" ")[0];
                                            }
                                        %>
					
                                        <input type="TEXT" name="birthDate" ID="birthDate" value="<%=birthDateStr%>" readonly />
                                    </td>
                                    
                                    <td class="td titleTD" nowrap>
                                         <fmt:message key="email"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <input type="text" name="email" value="<%=clientWbo.getAttribute("email") != null && !clientWbo.getAttribute("email").equals("UL") ? clientWbo.getAttribute("email") : ""%>" onblur="checkMail(this.value)"/>
                                        
					<label id="mailMsg">
					</label>
                                    </td>       
                                </tr>
				
                                <tr>
                                    <td class="td titleTD">
                                         <fmt:message key="id"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <input type="text" name="clientSsn" value="<%=clientWbo.getAttribute("clientSsn") != null && !clientWbo.getAttribute("clientSsn").equals("UL") ? clientWbo.getAttribute("clientSsn") : ""%>" />
                                    </td>
				    
                                    <td class="td titleTD">
                                        <fmt:message key="isworkabroad"/>
                                    </td>
				    
                                    <td class="td dataTD">
                                        <span>
					    <input type="radio" name="workOut" value="1" <%=clientWbo.getAttribute("option1") != null && clientWbo.getAttribute("option1").equals("1") ? "checked" : ""%>/>
					    
					    <font size="3" color="#005599">
						<b>
						     <fmt:message key="yes"/> 
						</b>
				            </font>
					</span>
						
                                        <span>
					    <input type="radio" name="workOut" value="0" <%=clientWbo.getAttribute("option1") == null || clientWbo.getAttribute("option1").equals("0") ? "checked" : ""%>/>
					    
					    <font size="3" color="#005599">
						<b>
						     <fmt:message key="no"/> 
						</b>
					    </font>
					</span>
                                    </td>
                                </tr>
				
                                <tr>
                                    <td class="td titleTD">
                                         <fmt:message key="job"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <%
                                            String jobName = "";
                                            TradeMgr tradeMgr = TradeMgr.getInstance();
                                            String jobCode = "";
                                            if (clientWbo.getAttribute("job") != null && !clientWbo.getAttribute("job").equals("")) {
                                                jobCode = (String) clientWbo.getAttribute("job");
                                                WebBusinessObject wbo5 = new WebBusinessObject();
                                                wbo5 = tradeMgr.getOnSingleKey(jobCode);
                                                if (wbo5 != null) {
                                                    jobName = (String) wbo5.getAttribute("tradeName");
                                                } else {
						    if(stat.equals("En"))
							jobName ="No choice";
						    else
							jobName = "لم يتم الإختيار";
                                                }
                                            }
                                        %>
					 
                                        <SELECT name="job" id="job" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;" class="hidex">
                                            <OPTION value="000"> --- <%=choose%> --- </OPTION>
                                                <%
                                                    if (jobs != null & !jobs.isEmpty()) {
                                                        for (WebBusinessObject wbo3 : jobs) {    
						%>
							    <OPTION value="<%=wbo3.getAttribute("tradeId")%>" <%=wbo3.getAttribute("tradeId").equals(jobCode) ? "selected" : ""%>><%=wbo3.getAttribute("tradeName")%></OPTION>
                                                <%
                                                        }
                                                    }
                                                %>
                                        </SELECT>
                                    </td>
				    
                                    <td class="td titleTD">
                                         <fmt:message key="isrelativabroad"/> 
                                    </td>
				    
                                    <td class="td dataTD">
                                        <span>
					    <input type="radio" name="kindred" value="1" <%=clientWbo.getAttribute("option2") != null && clientWbo.getAttribute("option2").equals("1") ? "checked" : ""%>/>
					    
					    <font size="3" color="#005599">
						<b>
						     <fmt:message key="yes"/> 
						</b>
					    </font>
					</span>
						
                                        <span>
					    <input type="radio" name="kindred" value="0" <%=clientWbo.getAttribute("option2") == null || clientWbo.getAttribute("option2").equals("0") ? "checked" : ""%>/>
					    
					    <font size="3" color="#005599">
						<b>
						     <fmt:message key="no"/> 
						</b>
					    </font>
					</span>
                                    </td>
                                </tr>
				
                                <tr>
                                    <td class="td titleTD">
                                         <fmt:message key="region"/> 
                                    </td>
				    
                                    <td class="td dataTD" >
                                        <%
                                              String regionName = (String) clientWbo.getAttribute("region");
                                        %>
					
                                        <table style="display: block; margin-right: -5px;" ALIGN="center"  dir="<%=dir%>" border="0" id="regionTable">
                                            <tr>
                                                <td style="<%=style%>" class="td2">
                                                    <input type="text" id="newregion" name="newregion" value="<%=regionName%>"/>
                                                </td>
                                            </tr>
                                                
                                        </table>
                                    </td>
				    
				    <td class="td titleTD">
					 <fmt:message key="branch"/> 
				    </td>
				    <td class="td dataTD">
					<%
					    for(int i =0 ;i < userProjects.size();i++){
						WebBusinessObject obj = (WebBusinessObject) userProjects.get(i);
					%>
						<div style="text-align: <fmt:message key="align"/>"><span><input type="radio" name="clientBranch" value="<%=obj.getAttribute("projectID")%>" <%=clientWbo.getAttribute("branch") != null && clientWbo.getAttribute("branch").equals(obj.getAttribute("projectID")) ? "checked" : "checked"%>/> <font size="3" color="#005599"><b><%=obj.getAttribute("projectName")%></b></font></span></div>
					<%
					    }
					%>
						
					<div style="text-align: <fmt:message key="align"/>"><span><input type="radio" name="clientBranch" value="UL" <%=clientWbo.getAttribute("branch") == null || clientWbo.getAttribute("branch").equals("UL") ? "checked" : ""%>/> <font size="3" color="#005599"><b  ><fmt:message key="unspecified"/></b></font></span></div>
				    </td>
                                </tr>
				
                                <tr>
                                    <td class="td titleTD" >
                                         <fmt:message key="notes"/> 
                                    </td>
				    
                                    <td class="td dataTD" colspan="3" style="text-align: <fmt:message key="align" /> ">
                                        <textarea <%=userPrevList.contains("EDIT_NOTE") ? "" : "readonly"%> id="description" name="description" cols="26" rows="10"><%=clientWbo.getAttribute("description") != null && !((String) clientWbo.getAttribute("description")).equals("UL") ? clientWbo.getAttribute("description") : ""%></textarea>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </BODY>
</html>