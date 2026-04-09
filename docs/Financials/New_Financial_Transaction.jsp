
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
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

    ArrayList FAccountType = (ArrayList) request.getAttribute("FAccountType");
    ArrayList purposeArrayList = (ArrayList) request.getAttribute("purposeArrayList");
    ArrayList CostCenterList = (ArrayList) request.getAttribute("CostCenterList");
    ArrayList sourceDestinationLst = (ArrayList) request.getAttribute("sourceDestinationLst");
    
    ArrayList clientsList = (ArrayList) request.getAttribute("clientsList");
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;      
    String businessID = (String) request.getAttribute("businessID");
    String status = (String) request.getAttribute("status");
    String docNo=request.getAttribute("docNo")==null?"":(String) request.getAttribute("docNo");
    String option1=null;
    String netValue= request.getAttribute("netValue")==null?" ":(String)request.getAttribute("netValue");
    String conID= request.getAttribute("conID")==null?" ":(String)request.getAttribute("conID");
    String conName= request.getAttribute("conName")==null?" ":(String)request.getAttribute("conName");
    String invoID= request.getAttribute("invoID")==null?"":(String)request.getAttribute("invoID");
    String payfrom=request.getAttribute("conID")==null?"":"FIN_SAFE";
    String PayTo=request.getAttribute("conID")==null?"":"FIN_CNTRCT";
    for(int i=0; i<purposeArrayList.size(); i++){
        WebBusinessObject wbo = (WebBusinessObject) purposeArrayList.get(i);
        option1+="<Option value='"+wbo.getAttribute("projectID").toString()+"'>"+wbo.getAttribute("projectName").toString()+"</option>";
    }
    
    String option2=null;
    for(int i=0; i<CostCenterList.size(); i++){
        WebBusinessObject wbo = (WebBusinessObject) CostCenterList.get(i);
        option2+="<Option value='"+wbo.getAttribute("projectID").toString()+"'>"+wbo.getAttribute("projectName").toString()+"</option>";
    }
    String add,code,name,auto; 
    String  align = "center";
     if (stat.equals("En")) {
         add="Add";
         code="Code";
         name="Name";
         auto="auto";
         } else {
         add="أضافة";
         code="الكود";
         name="اﻷسم";
         auto="تلقائي";
     }
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        
          <style>
           
            .login {
                direction: rtl;
                /*margin: 20px auto;*/
                padding: 10px 5px;
                background: #dcdcdc;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #dcdcdc; /* Old browsers */
                background: -moz-linear-gradient(top, #dcdcdc 0%, #dcdcdc 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#dcdcdc), color-stop(100%,#dcdcdc)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #dcdcdc 0%,#dcdcdc 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #dcdcdc 0%,#dcdcdc 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #dcdcdc 0%,#dcdcdc 100%); /* IE10+ */
                background: linear-gradient(to bottom, #dcdcdc 0%,#dcdcdc 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#dcdcdc', endColorstr='#dcdcdc',GradientType=0 ); /* IE6-8 */
            }
            th { font-size: 16px; }
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                /*margin-left: auto;*/
                margin-right: auto;
                text-height: 30px;
                color: black;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
        

            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }

            #mydiv {
                text-align:center;
            }
            .bordered {
                border: 0px solid white;
            }
        </style>

        <script type="text/javascript">
            $(function () {
                $("#documentDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    buttonImageOnly: true,
                    buttonText: "Select date"
                });
                $("#transValue").change(function(){
                    $("#transNetValue").val($("#transValue").val());
                    
                });
                 $("#documentNumber").change(function(){
                    $("#accountCode").val($("#documentNumber").val());
                    
                });
                 
                   $("#documentNumber").prop("readonly", true);
                   $("#accountCode").prop("readonly", true);
                    $("#documentNumber").addClass('bordered');   
                     $("#accountCode").addClass('bordered'); 

               $('#docNoAuto').change(function() {
                    if($(this).is(":checked")) {
                    $("#documentNumber").prop("readonly", true);
                    $("#accountCode").prop("readonly", true);
                    $("#documentNumber").val("<%=docNo%>");
                    $("#accountCode").val("<%=docNo%>");
                     $("#documentNumber").addClass('bordered');   
                     $("#accountCode").addClass('bordered'); 

                    }else
                    {
                       $("#documentNumber").prop("readonly", false);
                       $("#accountCode").prop("readonly", false);
                       $("#documentNumber").val("");
                       $("#accountCode").val("");
                        $("#documentNumber").removeClass('bordered');   
                         $("#accountCode").removeClass('bordered'); 
                     }
                    
                    });
                
                if('<%=payfrom%>'=='FIN_SAFE'){
                    getSourceList("#sourceKind", 'source');
                }
                
            });

            function getSourceList(obj, listType) {
                var kindId = $(obj).val();
                showHideButton(kindId, listType);

                $("#" + listType).removeAttr("disabled");
                $("#" + listType).html("");

                $.ajax({
                    type: "post",
                    url: "<%=context%>/FinancialServlet?op=getKindsList",
                    data: {
                        kindId: kindId
                    },
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        var rowData;

                        if (data != null && data.length > 0) {
                            var len = data.length;
                            for (var i = 0; i < len; i++) {
                                rowData = data[i];
                                if(kindId != null && (kindId === "FIN_CNTRCT" || kindId === "FIN_CLNT")){
                                    $("#" + listType).html($("#" + listType).html() + "<option value='" + rowData.id + "'>" + rowData.name + "</option>");
                                } else if(kindId === "FIN_EMP"){
                                    $("#" + listType).html($("#" + listType).html() + "<option value='" + rowData.empId + "'>" + rowData.empName + "</option>");
                                } else {
                                    $("#" + listType).html($("#" + listType).html() + "<option value='" + rowData.projectID + "'>" + rowData.projectName + "</option>");
                                }
                                
                            }
                        } else {
                            $("#" + listType).attr("disabled", "disabled");
                            $("#" + listType).html("<option>لايوجد</option>");
                        }
                    }
                });
            }

            function submit() {
                if (!validateData("req", document.Transaction_FORM.documentNumber, "من فضلك ادخل رقم المستند...")) {
                    $("#documentNumber").focus();
                } else if (!validateData("req", document.Transaction_FORM.accountCode, "من فضلك ادخل رقم محاسبي  ..")) {
                    $("#accountCode").focus();
                } else if (!validateData("req", document.Transaction_FORM.transValue, "من فضلك ادخل القيمة  ..")) {
                    $("#transValue").focus();
                } else if (!validateData("req", document.Transaction_FORM.transNetValue, "من فضلك ادخل صافي القيمة  ..")) {
                    $("#transNetValue").focus();
                } else {
                    document.Transaction_FORM.action = "<%=context%>/FinancialServlet?op=saveFinTransaction&businessID=" +<%=businessID%> + "&documentNumber=" + $("#documentNumber").val() + "&documentDate=" + $("#documentDate").val() + "&accountCode=" + $("#accountCode").val() + "&FTypeID=" + $("#FTypeID").val() + "&purposeID=" + $("#purposeID").val() + "&sourceKind=" + $("#sourceKind").val() + "&source=" + $("#source").val() + "&destinationKind=" + $("#destinationKind").val() + "&destination=" + $("#destination").val() + "&transValue=" + $("#transValue").val() + "&transNetValue=" + $("#transNetValue").val() + "&notes=" + $("#notes").val()+"&invoID=<%=invoID%>";
                    document.Transaction_FORM.submit();
                }
            }
            
             function popupSeason() {
                $('#seasonCode').val("");
                $('#seasonName').val("");
                $('#seasonForm').css("display", "block");
                $("#seasonMsg").text("");
                $('#seasonForm').bPopup();
            }
            
            
             function addSeason() {
                var code = $('#seasonCode').val();
                var name = $('#seasonName').val();
                if (code === null || code === '') {
                    alert("Insert Code");
                    $('#seasonCode').focus();
                } else if (name === null || name === '') {
                    alert("Insert Name");
                    $('#seasonName').focus();
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/FinancialServlet?op=saveSeason",
                        data: {
                            code: code,
                            arabic_name: name,
                            english_name: name,
                            display: '1'
                        },
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                $("#dialedNumber").append("<option value='" + info.id + "'" + ">" + info.name + "</option>");
                                $('#seasonCode').val("");
                                $('#seasonName').val("");
                                alert("تم التسجيل بنجاح");
                            } else if (info.status === 'fail') {
                                alert("لم يتم التسجيل");
                            }
                            closePopup();
                           location.reload();
                        }
                    });
                }
            }
            
             function closePopup() {
                $("#seasonForm").bPopup().close();
            }

            function detailes() {
                $('#additions').css("display", "block");
            }

            function getFinanceTree()
            {
                openWindowFinanceTree('FinancialServlet?op=selectFinanaceTreeItem');
            }

            function openWindowFinanceTree(url)
            {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=750");
            }

            function AddNewRow() {
                $('#financeTable').append('<tr><td class="td"><div style="text-align: right;float: right;"><select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="q1" name="q1">' + $('#option1').val() + '</seclect></div></td>\n\
                                               <td class="td"><div style="text-align: right;float: right;"><input id="q2" name="q2" style="width: 225px;height: 30px" /><button type="button" class="button" onclick="JavaScript:getFinanceTree();" style="width:25"><IMG VALIGN="BOTTOM" SRC="images/search.gif"></button></div> </td>\n\\n\
                                               <td class="td"><div style="text-align: right;float: right;"><select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="q3" name="q3">' + $('#option2').val() + '</select></div></td>\n\
                                               <td class="td"><div style="text-align: right;float: right;"><input id="q4" name="q4" type="number" style="width: 160px;height: 30px" /></div></td>\n\
                                               <td class="td"><div style="text-align: right;float: right;"><input id="q5" name="q5" type="number" style="width: 160px;height: 30px" /></div></td></tr>');
            }
            function showHideButton (kind, type) {
                if (kind === "FIN_CNTRCT" || kind === "FIN_CLNT") {
                    $("#" + type + "View").show();
                } else {
                    $("#" + type + "View").hide();
                }
            }
            function getVendorDetails(type) {
                divTag = $("#detailsDiv");
                var kind = $("#" + type + "Kind").val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FinancialServlet?op=getVendorDetails',
                    data: {
			clientID: $("#" + type).val(),
                        kind: kind
                    },
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "Accounts Details",
                            show: "fade",
                            hide: "explode",
                            width: 700,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                'Close': function () {
                                    $(this).dialog('close');
                                }
                            }
                        }).dialog('open');
                    }
                });
            }
        </script>
    </head>
    <body>
        <div id="detailsDiv"></div>
        <fieldset class="set" style="width:90%;border-color: #006699">
            <input type="hidden" id="option1" value="<%=option1%>">
            <input type="hidden" id="option2" value="<%=option2%>">
            <div align="left" style="color:blue; margin-left: 2.5%">
                <button type="button" onclick="JavaScript: submit()" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">حفظ&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18"/></button>
                <!--<button type="button" onclick="JavaScript: detailes()" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">إضافة&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18"/></button>-->
            </div>

            <br/>
            <table align="center" width="90%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td class="titlebar" style="text-align: center">
                        <font color="#005599" size="4">حركة محاسبية</font>&nbsp;<img width="40" height="40" src="images/finical-rebort.png" style="vertical-align: middle;"/> 
                    </td>
                </tr>
            </table>

            <br>

            <form name="Transaction_FORM" method="post">
                <%if (status != null && status.equals("ok")) {%>
                <br>
                <table align="center" dir="ltr" WIDTH="90%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="blue">تم الحفظ بنجاح</font>
                        </td>
                    </tr>
                </table>
                <%} else if (status != null && status.equals("no")) {%>
                <table align="center" dir="ltr" WIDTH="90%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="red">لم يتم الحفظ بنجاح</font>
                        </td>
                    </tr>
                </table>
                <%}%>

                <table dir="RTL" cellpadding="0" cellspacing="0" style="border-width: 0">
                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>مسلسل المستند</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <%=businessID%>                
                            </div>  
                        </td>  

                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>رقم المستند</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td" id="autoDoc">
                            <div style="text-align: right;float: right;">
                                <input id="documentNumber" name="documentNumber" type="text" style="width: 100px;height: 30px" value="<%=docNo%>" />                  
                               <input type="checkbox" name="docNoAuto" id="docNoAuto" value="auto" checked="true"><%=auto%>
                            </div>  
                        </td>  
                        
                        <td class="td">
                            &nbsp;
                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>تاريخ المستند</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <input id="documentDate" readonly name="documentDate" type="text" style="width: 150px;height: 30px" value="<%=now%>" /> 
                            </div>  
                        </td>  

                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>لقيد المحاسبي</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td" id="autoDoc1">
                            <div style="text-align: right;float: right;">
                                 <input id="accountCode" name="accountCode" type="text" style="width: 100px;height: 30px" value="<%= docNo%>" />                
                            </div>  
                        </td>  
                         
                        <td class="td">
                            &nbsp;
                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>نوع الحركة المحاسبية</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <%if (FAccountType.size() > 0 && FAccountType != null) {%>
                                <select style="width: 150px;height:30px; font-weight: bold; font-size: 13px" id="FTypeID" name="FTypeID">
                                    <sw:WBOOptionList displayAttribute="projectName" valueAttribute="projectID" wboList="<%=FAccountType%>" />
                                </select>
                                <% } else {%>
                                <select style="width: 100%;height: 4.5%; font-weight: bold; font-size: 13px;" id="FTypeID" name="FTypeID">
                                    <option>لاشئ</option>
                                </select>
                                <%}%>  
                                <input type="hidden" id="purposeID" name="purposeID" value="لاشئ"/>
                                
                                <input type="button"   onclick="JavaScript: popupSeason();" value="<%=add%>">
                            </div>  
                        </td>
                        <td class="td" colspan="3">
                            &nbsp;
                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>قيمة الحركة</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <input id="transValue" name="transValue" type="number" value="<%=netValue%>" style="width: 150px;height: 30px" />                
                            </div>  
                        </td>  

                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>صافي القيمة</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <input id="transNetValue" name="transNetValue" value="<%=netValue%>" type="number" style="width: 150px;height: 30px" />                
                            </div>  
                        </td>  
                        <td class="td">
                            &nbsp;
                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>دائن</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="sourceKind" name="sourceKind" onchange="getSourceList(this, 'source')">
                                    <option></option>
                                    <sw:WBOOptionList displayAttribute="arDesc" valueAttribute="typeCode"   wboList="<%=sourceDestinationLst%>" scrollToValue="<%=payfrom%>"/>
                                </select>  
                            </div>  
                        </td>  

                        <td class="td" colspan="2">
                            <div style="text-align: right;float: right;">
                                <select style="width: 322px;height: 30px; font-weight: bold; font-size: 13px;" id="source" name="source">
                                    <option></option>
                                </select>
                            </div>  
                        </td>  
                        <td class="td">
                            <a href="#" onclick="JavaScript: getVendorDetails('source');" id="sourceView" style="display: none;" title="View">
                                <img src="images/icons/details.png" style="height: 30px;"/>
                            </a>
                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>مدين</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="destinationKind" name="destinationKind" onchange="getSourceList(this, 'destination')">
                                    <option></option>
                                    <sw:WBOOptionList displayAttribute="arDesc" valueAttribute="typeCode" wboList="<%=sourceDestinationLst%>" scrollToValue="<%=PayTo%>"/>
                                </select>  
                            </div>  
                        </td>  

                        <td class="td" colspan="2">
                            <div style="text-align: right;float: right;">
                                <select style="width: 322px;height: 30px; font-weight: bold; font-size: 13px;" id="destination" name="destination">
                                    <option selected="true" value="<%=conID%>"><%=conName%></option>
                                </select>
                            </div>  
                        </td>  
                        <td class="td">
                            <a href="#" onclick="JavaScript: getVendorDetails('destination');" id="destinationView" style="display: none;" title="View">
                                <img src="images/icons/details.png" style="height: 30px;"/>
                            </a>
                        </td>
                    </tr>

                   
                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>ملاحظات</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td" colspan="3">
                            <textarea id="notes" name="notes" style="width: 100%;" rows="2"></textarea>
                        </td>  
                        <td class="td">
                            &nbsp;
                        </td>
                    </tr>
                </table>

                <br>

                <div id="additions" style="width: 100%; display: none">
                    <table dir="RTL" cellpadding="0" cellspacing="0" style="border-width: 0" id="financeTable">
                        <tr>
                            <td class="td" colspan="5" align="left">
                                <button type="button" onclick="JavaScript: AddNewRow()" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">إضافة&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18"/></button>
                            </td>
                        </tr>

                        <tr>
                            <td class="td">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <LABEL FOR="str_EQ_NO">
                                        <p style="margin-top: 5px"><b>الغرض</b></p>
                                    </LABEL>
                                </div>
                            </td>

                            <td class="td">
                                <div style="text-align:center;width: 260px; display: inline-block;" class="selver2">
                                    <LABEL FOR="str_EQ_NO">
                                        <p style="margin-top: 5px"><b>الحساب</b></p>
                                    </LABEL>
                                </div>
                            </td>

                            <td class="td">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <LABEL FOR="str_EQ_NO">
                                        <p style="margin-top: 5px"><b>مركز التكلفة</b></p>
                                    </LABEL>
                                </div>
                            </td>

                            <td class="td">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <LABEL FOR="str_EQ_NO">
                                        <p style="margin-top: 5px"><b>مدين</b></p>
                                    </LABEL>
                                </div>
                            </td>

                            <td class="td">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <LABEL FOR="str_EQ_NO">
                                        <p style="margin-top: 5px"><b>دائن</b></p>
                                    </LABEL>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td class="td">
                                <div style="text-align: right;float: right;">
                                    <%if (purposeArrayList.size() > 0 && purposeArrayList != null) {%>
                                    <select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="q1" name="q1">
                                        <sw:WBOOptionList displayAttribute="projectName" valueAttribute="projectID" wboList="<%=purposeArrayList%>"/>
                                    </select>
                                    <% } else {%>
                                    <select style="width: 100%;height: 30px; font-weight: bold; font-size: 13px;" id="q1" name="q1">
                                        <option>لاشئ</option>
                                    </select>
                                    <%}%>            
                                </div> 
                            </td>

                            <td class="td">
                                <div style="text-align: right;float: right;">
                                    <input id="q2" name="q2" style="width: 225px;height: 30px" />
                                    <button type="button" class="button" onclick="JavaScript:getFinanceTree();" style="width:25"><IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>               
                                </div> 
                            </td>

                            <td class="td">
                                <div style="text-align: right;float: right;">
                                    <%if (CostCenterList.size() > 0 && CostCenterList != null) {%>
                                    <select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="q3" name="q3">
                                        <sw:WBOOptionList displayAttribute="projectName" valueAttribute="projectID" wboList="<%=CostCenterList%>"/>
                                    </select>
                                    <% } else {%>
                                    <select style="width: 100%;height: 30px; font-weight: bold; font-size: 13px;" id="q3" name="q3">
                                        <option>لاشئ</option>
                                    </select>
                                    <%}%>           
                                </div> 
                            </td>

                            <td class="td">
                                <div style="text-align: right;float: right;">
                                    <input id="q4" name="q4" type="number" style="width: 160px;height: 30px" />                
                                </div> 
                            </td>

                            <td class="td">
                                <div style="text-align: right;float: right;">
                                    <input id="q5" name="q5" type="number" style="width: 160px;height: 30px" />                
                                </div> 
                            </td>
                        </tr>
                    </table>
                </div>
               <div id="seasonForm"  style="width: 30%;height: 200px;display: none;position: fixed;">
                    <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
                        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
                    </div>
                    <div class="login" style="width: 86%;margin-bottom: 10px;margin-left: auto;margin-right: auto">
                        <table class="" style="width:100%;text-align: right;border: none;" class="table" >
                            <tr align="center" align="center">
                                <td colspan="2" style="font-size:14px; border: none;">
                                    <b style="color: #f9f9f9;font-size: 14px;" id="seasonMsg"></b></td>
                            </tr>
                            <tr>
                                <td  ALIGN="<%=align%>" style="border: none;"><%=code%></td>
                                <td width="200" style="border:0px;text-align: right;">
                                    <input type="text" style="width: 80px; float: right;" name="seasonCode" ID="seasonCode" size="50" value="" maxlength="50" />
                                </td>
                            </tr>
                            <tr>
                                <td  ALIGN="<%=align%>" style="border: none;"><%=name%></td>
                                <td width="200" style="border:0px;text-align: right;">
                                    <input type="text" style="width:150px;float: right;" name="seasonName" ID="seasonName" size="50" value="" maxlength="50" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align:center;border: none;">
                                    <input style="margin-top: 5px;"type="button" value="<%=add%>" onclick="addSeason()" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </form>
        </fieldset>
    </body>
</html>
