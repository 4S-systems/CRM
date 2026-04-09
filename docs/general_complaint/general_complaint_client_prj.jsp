<%-- 
    Document   : general_complaint_client_prj
    Created on : Aug 09, 2017, 2:05:30 PM
    Author     : fatma
--%>

<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject,com.tracker.db_access.ProjectMgr"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        Calendar calendar = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd HH:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(calendar.getTime());
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        String entryDate = (String) request.getAttribute("entryDate");
        int currentDay = calendar.get(calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(calendar.YEAR);
        int currentMonth = calendar.get(calendar.MONTH);
        ArrayList<WebBusinessObject> complaints = new ArrayList(projectMgr.getOnArbitraryKeyOracle("cmplnt", "key6"));
        ArrayList<WebBusinessObject> requests = new ArrayList(projectMgr.getOnArbitraryKeyOracle("rqst", "key6"));
        
        if (complaints == null) {
            complaints = new ArrayList();
        } else {
            for (int i = complaints.size() - 1; i >= 0; i--) {
                WebBusinessObject tempWbo = complaints.get(i);
                
                if ("0".equals(tempWbo.getAttribute("mainProjId"))) {
                    complaints.remove(tempWbo);
                    break;
                }
            }
        }
        
        if (requests == null) {
            requests = new ArrayList();
        } else {
            for (int i = requests.size() - 1; i >= 0; i--) {
                
                WebBusinessObject tempWbo = requests.get(i);
                if ("0".equals(tempWbo.getAttribute("mainProjId"))) {
                    requests.remove(tempWbo);
                    break;
                }
            }
        }
        
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, title, selectClient, issueNum;
        String calenderTip, client, search, date;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "Create Complaint / Request";
            calenderTip = "click inside text box to opn calender window";
            selectClient = "Select Client";
            client = " Client ";
            search = " Search ";
            issueNum = " Follow Up Numbers ";
            date = " Date ";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "إنشاء شكوي / طلب";
            calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            selectClient = "أختر عميل";
            client = " العميل ";
            search = " بحث ";
            issueNum = " رقم المتابعة ";
            date = " التاريخ ";
        }
    %>
    
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery.datetimepicker.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"/>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            
            $(function () {
                $("#entryDate").datetimepicker({
                    maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                    changeMonth: true,
                    changeYear: true,
                    timeFormat: 'hh:mm',
                    dateFormat: 'yy/mm/dd'
                });
            });
            
            function saveCall() {
                var x = $("#note").val();
                
                if (x.length === 0) {
                    alert(" Please Add Comment For Order. ");
                    return false;
                }
                
                if ($("#clientId").val() === '') {
                    alert(" Choose Client. ");
                    openClientsDailog();
                    return;
                }
                
                if ($("#note").val().length > 0) {
                    $("#pursuanceNO").html("<img src='images/icons/spinner.gif'/>");
                    var call_status = $("#call_status:checked").val();
                    var note = $("#note").val();
                    var entryDate = $("#entryDate").val();
                    var clientId = $("#clientId").val();

                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=insertNewCmpl",
                        data: {
                            call_status: call_status,
                            note: note,
                            entryDate: entryDate,
                            clientId: clientId,
                            type: note
                        }, success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'success') {
                                $("#businessId").val(info.businessID);
                                $("#issueId").val(info.issueId);
                                $("#uploadFile").show();
                                $("#pursuanceNO").html("");
                                $("#pursuanceNO").html('<lable id="busNumber"><font color="red" size="3">' + info.businessID + '/</font><font color="blue" size="3" >' + info.businessIDbyDate + '</font></lable>');
                                $("#getDIV").html("");
                            } else {
                                $("#pursuanceNO").html("");
                                $("#pursuanceNO").html('<font color="red" size="3">Save Failed!/</font>');
                            }
                            
                            getPrj(clientId);
                        }
                    });
                    return false;
                }
            }
            
            var divAttachmentTag;
            function openAttachmentDialog(objectType) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                var issueId = $("#issueId").val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
                    data: {
                        businessObjectId: issueId,
                        objectType: objectType
                    }, success: function (data) {
                        divAttachmentTag.html(data).dialog({
                            modal: true,
                            title: " Attach Files. ",
                            show: "fade",
                            hide: "explode",
                            width: 800,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                Cancel: function () {
                                    divAttachmentTag.dialog('close');
                                },
                                Done: function () {
                                    divAttachmentTag.dialog('close');
                                }
                            }
                        }).dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
            
            function openClientsDailog() {
                var divTag = $("<div></div>");
                var radioVal = "";
                $.ajax({
                    type: "post",
                    url: '<%=context%>/ClientServlet?op=listClientsOwnerPopup',
                    data: {},
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "<%=selectClient%>",
                            show: "fade",
                            hide: "explode",
                            width: 600,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                Cancel: function () {
                                    $(this).dialog('close').dialog('destroy');
                                }, Done: function () {
                                    $(this).find(':radio:checked').each(function () {
                                        radioVal = this.value;
                                        $("#clientId").val(this.value);
                                        $("#clientName").val($(divTag.html()).find('#clientName' + this.value).val());
                                        $("#area_id").val($(divTag.html()).find('#clientRegion' + this.value).val());
                                        $("#clientMobile").val($(divTag.html()).find('#clientMobile' + this.value).val());
                                        $("#address").val($(divTag.html()).find('#clientAddress' + this.value).val());
                                    });
                                    
                                    $(this).dialog('close').dialog('destroy');
                                    
                                    $.ajax({
                                        type: "post",
                                        url: '<%=context%>/ClientServlet?op=getClientProject',
                                        data:{
                                            clientID: radioVal
                                        }
                                    });
                                    
                                    saveCall();
                                }
                            }
                        }).dialog('open');
                    }
                });
            }
            
            function closePopupDialog(formID) {
                try {
                    $('#' + formID).bPopup().close();
                } catch (err) {
                }
                
                try {
                    $("#" + formID).hide();
                    $('#overlay').hide();
                } catch (err) {
                }
            }
            
            function getPrj(clientId){
                var url = "<%=context%>/ProjectServlet?op=getClientOwnedProject&clientID=" + clientId;
                jQuery('#getDIV').load(url);
                $('#getDIV').css("display", "block");
                $("#getDIV").css("background", "#FFFFFF");
            }
        </script>
                
        <style>
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
            
            textarea{
                resize:none;
            }
            
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                height:20px;
                border: none;
            }
            
            label{
                font: Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight:bold;
                color:#005599;
            }
            
            .div{
                direction: rtl;
            }
            
            .button2{
            font-family: "Script MT", cursive;
            font-size: 18px;
            font-style: normal;
            font-variant: normal;
            font-weight: 400;
            line-height: 20px;
            width: 110px;
            height: 25px;
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
                
    <body>
        <div name="divAttachmentTag"></div>
        
        <form NAME="UNIT_LIST_FORM" METHOD="POST">
            <fieldset class="set backstyle" style="width:90%; border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="direction: <%=dir%>">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4">
                                 <%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>
                
                <br/>
                
                <div style="width:100%; margin-right: auto; margin-left: auto; direction: <%=dir%>;">
                    <div style="width: 100%; margin-left: auto; margin-right: auto; border: none; direction: <%=dir%>;">
                        <div style="width: 90%; margin-left: auto; margin-right:auto; margin-top: 0px; border: none; direction: <%=dir%>;">
                            <table style="width: 90%; direction: <%=dir%>;" class="table">
                                <tr>
                                    <td width="20%" style="color: #fff;border-radius: 5px" class="blueHeaderTD">
                                         <%=client%> 
                                    </td>
                                    
                                    <td class="cell" bgcolor="#EEEEEE" style="text-align:center; font-size:14px; border-width:1px; border-color:white;" id="data" colspan="2">
                                        <input type="text" dir="<%=dir%>" style="height: 25px;border: 1px solid silver;border-radius: 5px;padding-left: 10px " autocomplete="off" value="" id="clientName" name="clientName" onclick="openClientsDailog();" readonly/>
                                        <input type="hidden" id="clientId" name="clientId" value=""/>
                                        <input type="hidden" id="clientMobile" name="clientMobile" value=""/>
                                        <input type="hidden" id="address" name="address" value=""/>
                                        <input class="button2" type="button" name=" search" onclick="openClientsDailog();" id=" search" value=" <%=search%> ">
                                    </td>
                                    
                                    <td width="20%" style="color: #fff;border-radius: 5px" class="blueHeaderTD">
                                         <%=issueNum%> 
                                        <input name="note" type="hidden" value="call" id="note"/>
                                        <input name="call_status" id="call_status" type="hidden" value="incoming" />
                                    </td>
                                        
                                    <td width="20%" style="<%=style%>">
                                        <div id="pursuanceNO"></div>
                                        <input type="hidden" id="issueId" />
                                    </td>
                                        
                                    <td style="display:none;" width="20%" style="color: #000;" class="excelentCell formInputTag">
                                         <%=date%>
                                    </td>
                                    
                                    <td style="display:none;" width="40%" dir="ltr" style="<%=style%>">
                                        <input name="entryDate" id="entryDate" type="text" size="50" maxlength="50" style="width: 180px;" value="<%=(entryDate == null) ? nowTime : entryDate%>"/><img alt=""  style="margin-right: 5px;" src="images/showcalendar.gif" onMouseOver="Tip('<%=calenderTip%>', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE, 'Display Calender Help', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"  />
                                    </td>
                                </tr>
                            </table>
                        </div>
                                    
                        <div id="getDIV" style="width:100%; clear: both; margin: auto; direction: <%=dir%>;" class="div backstyle2"></div>
                    </div>
                </div>
            
                <br/>
            </fieldset>
        </form>