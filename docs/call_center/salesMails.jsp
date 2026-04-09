<%-- 
    Document   : salesMails
    Created on : Nov 7, 2017, 10:00:54 AM
    Author     : fatma
--%>

<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String usrEmail = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, dir, srch, to, subjct, txtBd, style, attchfl, snd, nDir, direction, nDirection, from, pass;
    
    if (stat.equals("En")) {
	title = " Send E-Mail ";
	dir = "LTR";
	nDir = "RTL";
	srch = " Search ";
	to = " To ";
	subjct = " Subject ";
	txtBd = " Text Body ";
	style = "text-align:left";
	attchfl = " Attach Files ";
	snd = " Send ";
	direction = "left";
	nDirection = "right";
	from = " From ";
	pass = " Password ";
    } else {
	title = " إرسال رسالة إلكترونية ";
	dir = "RTL";
	nDir = "LTR";
	srch = " بحث ";
	to = " إلى ";
	subjct = " الموضوع ";
	txtBd = " المحتوى ";
	style = "text-align:Right";
	attchfl = " المرفقات ";
	snd = " إرسال ";
	direction = "right";
	nDirection = "left";
	from = " من ";
	pass = " كلمة المرور ";
    }
%>

<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Sales Contact Center </title>
	
	<script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
	
	<style>
	    *>*{
		vertical-align: middle;
	    }
	    
	    .titlebar {
                height: 30px;
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
	</style>
	
	<script>
	    $(document).ready(function () {

            });
	    
	    function selectAllItems() {
                $('#toMails option').prop('selected', true);
            }
	    
	    function sendMailss()
            {
                var status = $("#status").val();
                //if ($("#status").val() == "ok" || $("#for").val() == "allClient" || $("#for").val() == "searchClient") {
                    //var clientNumber = $("#errorMsg").val();
                    var file = $("#file").val();
                    var fileName = document.getElementById("file1").value;
                    var fileExt = "noFiles";
                    var fileTitle = "noTitle";

                    if (fileName.length > 0)
                    {

                        var fileExtPos = fileName.lastIndexOf('.');
                        var fileTitlePos = fileName.lastIndexOf('\\');

                        fileExt = fileName.substr(fileExtPos + 1);

                        fileTitle = fileName.substring(fileTitlePos + 1, fileExtPos);

                        document.getElementById("fileExtension").value = fileExt;

                        document.getElementById("docTitle").value = fileTitle;

                    }
		    
		    
		    var toMails = [];
		    $("#toMails option:selected").each(function(){
			toMails.push($("#toMails option:selected").val());
		    });
		    var fromTyp = $("input[name=from]:checked").val();
		    //console.log(" fromTyp = " + fromTyp);
		    
		    document.salesMailForm.action = "<%=context%>/EmailServlet?op=sendMail&fileExtension=" + fileExt + "&for=allClient&mails=" + toMails.join() + "&fromTyp=" + fromTyp;
                    document.salesMailForm.submit();
            }
	    
	    function getpassword(emailTyp){
		if(emailTyp == "comEmail"){
		    $("#passTR").hide();
		} else if (emailTyp == "usrEmail"){
		    $("#passTR").fadeIn();
		}
	    }
	</script>
    </head>
    
    <body>

        <div id="sms_content" class="popup_content" >
            <%
                String status = request.getAttribute("status") != null ? (String) request.getAttribute("status") : "";
                if (status.equals("ok")) {
            %>
		    <div style="margin-left: auto;margin-right: auto;color: green; font-size: 25px; font-weight: bold;">تم الإرسال بنجاح</div>
            <%
		} else if (status.equals("error")) {
            %>
		    <div style="margin-left: auto;margin-right: auto;color: red; font-size: 25px; font-weight: bold;">لم يتم الإرسال</div>
            <%
		}
	    %>
        </div>
	
	<fieldset class="set backstyle" style="width: 80%; border-color: #006699;">
	    <table width="100%" cellpadding="0" cellspacing="0" style="direction: <%=dir%>;">
		<tr>
		    <td class="titlebar">
			<font color="#005599" size="4">
			     <%=title%> 
			</font>
		    </td>
		</tr>
	    </table>
			    
	    <div style="width: 80%; direction: <%=dir%>;">
		<form name="salesMailForm" method="post" enctype="multipart/form-data" >
		    <input type="hidden" value="Customer Service" id="from"/>
		    
		    <table class="table" style="width: 80%; border: none; <%=style%>">
			<tr style="padding-bottom: 5px;">
			    <td style="color:#000080; font-size: 14px; font-weight: bold; width: 25%; border: none; text-align: <%=direction%>;">
				 <%=from%> : 
			    </td>
			    
			    <td style="text-align: <%=direction%>; border: none; width: 25%;">
				<input type="radio" value="comEmail" id="from" name="from" style="width: 5%;" onclick="getpassword('comEmail');" checked/> <%=metaMgr.getEmailAddress()%> 
			    </td>
			    
			    <td style="text-align: <%=direction%>; border: none; width: 25%;">	
				<%
				    if(usrEmail != null && !usrEmail.isEmpty()){
				%>
					<input type="radio" value="usrEmail" id="from" name="from" style="width: 5%;" onclick="getpassword('usrEmail');"/> <%=usrEmail%> 
				<%
				    }
				%>
			    </td>
			</tr>
			
			<tr id="passTR" style="padding-bottom: 5px; display: none;">
			    <td style="color:#000080; font-size: 14px; font-weight: bold; width: 25%; border: none; text-align: <%=direction%>;">
				 <%=pass%> : 
			    </td>
			    
			    <td style="text-align: <%=direction%>; border: none; width: 75%;" colspan="2">
				<input placeholder=" ************************* " type="password" class="set" id="pass" name="pass" style="width: 50%;"/>
			    </td>
			</tr>
			
			<tr style="padding-bottom: 5px; padding-top: 5px;">
			    <td style="color:#000080; font-size: 14px; font-weight: bold; width: 25%; border: none; text-align: <%=direction%>;">
				 <%=to%> : 
			    </td>
			    
			    <td width="41%"style="text-align: <%=direction%>; border: none;">
				<input type="hidden" id="to" name="to"/>
				
				<select name="toMails" id="toMails" class="set" style="width: 90%; text-align: center;" multiple>
				</select>
			    </td>
			    
			    <td width="33%" style="text-align: <%=nDirection%>; border: none;">
				<input type="button" id="searchBtn" class="button2" style="width: 50%; text-align: center;" onclick="window.open('<%=context%>/ClientServlet?op=salesMail&ppu=1', 'blank', 'status=1, scrollbars=1, width=auto, height=800')" value=" <%=srch%> "/>
			    </td>
			</tr>
			
			<tr style="padding-bottom: 5px;">
			    <td style="color:#000080; font-size: 14px; font-weight: bold; width: 25%; border: none; text-align: <%=direction%>;">
				 <%=subjct%> : 
			    </td>
			    
			    <td style="text-align: <%=direction%>; border: none; width: 75%;" colspan="2">
				<input placeholder=" <%=subjct%> " type="text" class="set" size="60" maxlength="60" id="subject" name="subject" style="width: 50%;"/>
			    </td>
			</tr>
			
			<tr style="padding-bottom: 5px;">
			    <td style="color: #000080; font-size: 14px; font-weight: bold; width: 25%; border: none; text-align: <%=direction%>;">
				 <%=txtBd%> : 
			    </td>
			    
			    <td style="border: none;  width: 75%; text-align: <%=direction%>;" colspan="2">
				<textarea class="set" placeholder=" <%=txtBd%> " rows="5" cols="40" name="message" id="message" style="color: #000;"> 
				</textarea>
			    </td>
			</tr>
			
			<tr style="padding-bottom: 5px;">
			    <td style="color:#000080; font-size: 14px; font-weight: bold; width: 25%; border: none; text-align: <%=direction%>;">
				 <%=attchfl%> : 
			    </td>
			    
			    <td style="text-align: <%=direction%>; width: 75%; border: none;" colspan="2">
				<input type="file" name="file1" id="file1" onchange="JavaScript: changePic();" style="border: none;">
				<input type="hidden" name="fileName" id="fileName" value="">
				<input type="file" name="file2"  id="file2" onchange="JavaScript: changePic();">
				<input type="file" name="file3"  id="file3" onchange="JavaScript: changePic();">
				<input type="hidden" name="docType" value="">
				<input type="hidden" name="docTitle" value="Employee File" id="docTitle">
				<input type="hidden" name="description" value="Employee File">
				<input type="hidden" name="faceValue" value="0">
				<input type="hidden" name="fileExtension" value="" id="fileExtension">
				<%
				    Calendar c = Calendar.getInstance();
				    Integer iMonth = new Integer(c.get(c.MONTH));
				    int month = iMonth.intValue() + 1;
				    iMonth = new Integer(month);
				%>
				<input type="hidden" name="docDate" value="<%=iMonth.toString() + "/" + c.get(c.DATE) + "/" + c.get(c.YEAR)%>">
				<input type="hidden" name="configType" value="1">
			    </td>
			</tr>

			<tr>
			    <td style="border: none; width: 33%; text-align: <%=nDirection%>;" colspan="3"> 
				<input type="hidden" id="clientId" name="clientId"/>
				<input type="button" value=" <%=snd%> " class="button2" style="text-align: center;" onclick="sendMailss();" />
			    </td>
			</tr>
		    </table>
		</form>
	    </div>
	</fieldset>
    </body>
</html>