<%-- 
    Document   : email_popupClient
    Created on : Nov 27, 2017, 3:09:43 PM
    Author     : walid
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String titleStr = (String) request.getAttribute("title");
    
    String unitNo = (String) request.getAttribute("unitNo");
    String project = (String) request.getAttribute("project");
    String price = (String) request.getAttribute("price");
    String area = (String) request.getAttribute("area");
    String imageSrc = (String) request.getAttribute("imageSrc");
    
    String usrEmail = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
    
    String clientName = (String) request.getAttribute("clientName");
    String clientEmail = (String) request.getAttribute("clientEmail");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir, align, to, title, attachFile, body, unit, none, from, direction, title1;
    if (stat.equals("En")) {
        dir = "ltr";
        align = "left";
        to = "To";
        title = "Email";
        attachFile = "Attach File";
        body = "Body";
        unit= "Unit Details";
        none="None";
        from = " From ";
        direction = "left";
        title1 = "Title";
    } else {
        dir = "rtl";
        align = "right";
        to = "إلي";
        title = "الايميل";
        attachFile = "إرفاق ملف";
        body = "نص الرسالة";
        unit= "تفاصيل الوحده";
        none= "لا يوجد";
        direction = "right";
        from = " من ";
        title1 = "العنوان";
    }
%>

<html>
    <head>
        <script type="text/javascript" src="js/multiple-select/multiple-select.js"/>
        <script type="text/javascript" src="js/jquery-te/jquery-te-1.4.0.min.js"/>
        <link href="js/multiple-select/multiple-select.css" rel="stylesheet"/>
        <link href="js/jquery-te/jquery-te-1.4.0.css" rel="stylesheet"/>
        <script type="text/javascript">
        </script>
        <style>
            .table td {
                border: 0px;
            }
            .jqte_editor{height:150px;max-height:150px;}
        </style>
    </head>
    <body>
        <form id="emailForm" action="<%=context%>/EmailServlet?op=sendByAjaxClient" method="post" enctype="multipart/form-data">
            <table class="table" style="width:580px; direction: <%=dir%>">
                <tr style="padding-bottom: 5px;">
                    <td style="font-size: 16px;font-weight: bold;"><%=from%></td>

                    <td style="text-align: <%=direction%>; border: none; width: 25%;">
                        <input type="radio" value="<%=metaMgr.getEmailAddress()%>" id="from" name="from" style="width: 5%;" onclick="getpassword('comEmail');" checked/> <%=metaMgr.getEmailAddress()%> 
                    </td>

                    <td style="text-align: <%=direction%>; border: none; width: 25%;">	
                        <%
                            if(usrEmail != null && !usrEmail.isEmpty()){
                        %>
                                <input type="radio" value="<%=usrEmail%> " id="from" name="from" style="width: 10%;" onclick="getpassword('usrEmail');"/> <%=usrEmail%> 
                        <%
                            }
                        %>
                    </td>
                    </tr>
                <tr>
                    <td style="font-size: 16px;font-weight: bold;"><%=to%></td>
                    <td style="width: 80%; text-align: <%=align%>;" colspan="2">
                        <%=clientName!=null&&!clientName.equalsIgnoreCase("null")? clientName : ""%>
                        <input type="hidden" id="imageSrc" value="<%=imageSrc%>"/>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap><%=title1%></td>
                    <td style=" text-align: <%=align%>;" colspan="2">
                        <input type="text" size="60" maxlength="60" id="subject" name="subject" style="width: 100%;" value=""/>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap><%=title%></td>
                    <td style=" text-align: <%=align%>;" colspan="2">
                        <input type="text" size="60" maxlength="60" id="subject2" name="subject2" style="width: 100%;" value="<%=clientEmail!=null&&!clientEmail.equalsIgnoreCase("null")? clientEmail : ""%>"/>
                    </td>
                </tr>
                <%if (unitNo != null && !unitNo.equalsIgnoreCase("null")){%>
                    <tr>
                        <td style="font-size: 16px; font-weight: bold;" nowrap><%=unit%>
                            <input id="emailCounter" value="0" type="hidden" name="counter"/></td>
                        <td style="width: 60%; text-align: <%=align%>;" colspan="2">
                            <P type="text" name="unitDetails" id="unitDetails" style="height: 50px; width: 100%;" readonly>
                                -Unit No: <%=unitNo%>. <br> 
                                -Project: <%=project%>.<br> 
                                -Price: <%=price != null && !("0").equalsIgnoreCase((String) price) ? price : none%>.<br> 
                                -area: <%=area != null && !("0").equalsIgnoreCase((String) area) ? area : none%>.
                            </P>
                        </td>
                    </tr>
                <%}%>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap><%=body%>
                        <input id="emailCounter" value="0" type="hidden" name="counter"/></td>
                    <td style="width: 60%; text-align: <%=align%>;" colspan="2">
                        <textarea placeholder="<%=body%>" name="mailBody" id="mailBody" style="height: 150px; width: 100%;" class="editor"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap>
                        <%=attachFile%>
                    </td>
                    <td style="text-align: <%=align%>;" colspan="2">
                        <input type="button" id="addEmailFile" onclick="addEmailFiles(this)" value="+" />
                        <div id="listFile">

                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="emailStatus"></div>
                    </td>
                </tr>
            </table>
        </form>
        <script>
            $(".selectMulti").multipleSelect({
                isOpen: false,
                keepOpen: false,
                selectAll: false
            });
            $(".editor").jqte();
            
            function getpassword(emailTyp){
		if(emailTyp == "comEmail"){
		    $("#passTR").hide();
		} else if (emailTyp == "usrEmail"){
		    $("#passTR").fadeIn();
		}
	    }
        </script>
    </body>
</html>

