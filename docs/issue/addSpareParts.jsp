<%-- 
    Document   : addSpareParts
    Created on : Sep 13, 2017, 12:02:58 PM
    Author     : fatma
--%>

<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <c:set var="loc" value="en"/>
    
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Client.client"  />
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Add Spare Parts </title>
        
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            
            ArrayList<WebBusinessObject> itemsDependOnList = request.getAttribute("itemsDependOnList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("itemsDependOnList") : null;
            
            String issueId = request.getAttribute("issueId") != null ? (String) request.getAttribute("issueId") : "";
            String busID = request.getAttribute("busID") != null ? (String) request.getAttribute("busID") : "";
            
            int counter = 0;
            
            ArrayList<WebBusinessObject> sprPrtLst = request.getAttribute("sprPrtLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("sprPrtLst") : null;
            
            String comStatus = request.getAttribute("comStatus") != null ? (String) request.getAttribute("comStatus") : "";
            
            WebBusinessObject jobOrderWbo = (WebBusinessObject) request.getAttribute("jobOrderWbo");
        %>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        
        <script>
            var comStatus = <%=comStatus%>;
            
            function openRequestItemsDailog() {
                if(comStatus == "7"){
                    alert(" This Job Order Is Closed ");
                } else if(comStatus == "6"){
                    alert(" This Job Order Is Finishesd ");
                } else {
                    var divTag = $("<div></div>");
                    $.ajax({
                        type: "post",
                        url: '<%=context%>/RequestItemServlet?op=listBusinessItems',
                        data: {
                            locType: "spare_part"
                        },
                        success: function(data) {
                            divTag.html(data).dialog({
                                modal: true,
                                title: " Add Spare Part ",
                                show: "fade",
                                hide: "explode",
                                width: 500,
                                position: {
                                    my: 'center',
                                    at: 'center'
                                },
                                buttons: {
                                    Cancel: function() {
                                        $(this).dialog('close');
                                    },
                                    Done: function() {
                                        var itemId, itemCode, itemName, className, rateAmount, quantity;
                                        var counter = $('#numberOfRequestedItems').val();
                                        $(this).find(':checkbox:checked').each(function() {
                                            itemId = $(divTag.html()).find('#itemId' + this.value).val();
                                            itemCode = $(divTag.html()).find('#itemCode' + this.value).val();
                                            itemName = $(divTag.html()).find('#itemName' + this.value).val();
                                            rateAmount = $(divTag.html()).find('#rateHour' + this.value).val();
                                            quantity = $(divTag.html()).find('#quantity' + this.value).val();
                                             if(rateAmount==null)
                                            {
                                                rateAmount='0';
                                                $(divTag.html()).find('#rateHour' + this.value).value = '0';
                                            } else if(rateAmount == ""){
                                                rateAmount='0';
                                                $(divTag.html()).find('#rateHour' + this.value).value = '0';
                                            } else if(Number(rateAmount) < 0){
                                                rateAmount='0';
                                                $(divTag.html()).find('#rateHour' + this.value).value = '0';
                                            } else if(rateAmount.indexOf('-') >= 0){
                                                rateAmount='0';
                                                $(divTag.html()).find('#rateHour' + this.value).value = '0';
                                            }
                                            
                                            if (counter % 2 === 1) {
                                                className = "silver_odd_main";
                                            } else {
                                                className = "silver_even_main";
                                            }
                                            $('#requestedItems > tbody:last').append("<TR id=\"row" + counter + "\"></TR>");
                                            $('#row' + counter).append("<TD STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><b><font size=\"2\" color=\"#000080\" style=\"text-align: center;\">" + itemCode + "</font></b></TD>")
                                                                .append("<TD class=\"silver_footer\" bgcolor=\"#808000\" STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\">" + itemName + "</font></b></TD>")
                                                                .append("<TD STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + ">" + rateAmount + "<input type=\"hidden\" id=\"rateAmount" + counter + "\" name=\"id\" value=\"" + rateAmount + "\"> <input type=\"hidden\" id=\"realAmount" + counter + "\" name=\"realAmount\" value=\"" + quantity + "\"></td></TD>")
                                                                .append("<TD STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><input type=\"hidden\" id=\"requestedItemId" + counter + "\" name=\"requestedItemId\" value=\"" + itemId + "\"/><input type=\"hidden\" id=\"id" + counter + "\" name=\"id\" /><input type=\"number\" id=\"amount" + counter + "\" name=\"amount\" value=\"1\" style=\"text-align: center; width: 100%\" min=\"1\" onchange=\"calcTotal(" + counter + ", " + quantity + ");\"/></TD>")
                                                                .append("<td style=\"text-align: center; border-left-width: 0px\" bgcolor=\"#DDDD00\" nowrap=\"\" class=\"silver_even_main\"><input type=\"text\" id=\"total" + counter + "\" name=\"total\" value=\"" + rateAmount + "\" style=\"width: 100%; text-align: center;\" readonly></td>")
                                                                .append("<TD STYLE=\"text-align: center; border-left-width: 0px\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><textarea type=\"text\" id=\"requestedItemNote" + counter + "\" name=\"requestedItemNote\" value=\"\" style=\"width: 100%\" cols=\"10\"/></TD>");
                                            counter++;
                                        }
                                        )
                                        $('#numberOfRequestedItems').val(counter);
                                        $(this).dialog('close');
                                    }
                                }
                            }).dialog('open');
                        }
                    });
                }
            }
            
            function calcTotal(rowNum, quantity){
                var amt = Number($("#amount" + rowNum).val())

                if(Number(quantity) >= amt){
                    var cost=Number($("#rateAmount" + rowNum).val());
                    if(cost == null)
                    {
                        cost=0;
                        var total =  cost* Number($("#amount" + rowNum).val());
                        $("#total" + rowNum).val(total);
                    }
                    else
                    {
                        var total =  cost* Number($("#amount" + rowNum).val());
                        $("#total" + rowNum).val(total);
                    }
                } else {
                    alert(" To Large Amount Of Spare No " + (Number(rowNum)+1));
                }
            }
            
            function saveBItems(){
                if (document.getElementById('row0') === null) {
                    alert(" Choose One Spare Part At Least ");
                    $("#btnRequestItems").click();
                }
                var counter = $("#numberOfRequestedItems").val();
                
                var requestedItemIdArr = [];
                var amount = [];
                var realAmount = [];
                var total = [];
                var requestedItemNote = [];
                var cmnt;
                
                for(var i=0; i<counter; i++){
                    requestedItemIdArr.push($("#requestedItemId" + i).val());
                    amount.push($("#amount" + i).val());
                    realAmount.push($("#realAmount" + i).val());
                    total.push($("#total" + i).val());
                    if($("#requestedItemNote" + i).val() == ""){
                        cmnt = " none ";
                    } else {
                        cmnt = $("#requestedItemNote" + i).val();
                    }
                    requestedItemNote.push(cmnt);
                }
                
                $.ajax({
                    url: "<%=context%>/IssueServlet?op=addSpareParts",
                    data: {
                        issueId: <%=issueId%>,
                        reqType: "jobOrder",
                        requestedItemIdArr: requestedItemIdArr.join(),
                        amount: amount.join(),
                        total: total.join(),
                        realAmount: realAmount.join(),
                        requestedItemNote: requestedItemNote.join()
                    },
                    success: function() {
                        location.reload();
                        alert(" Spare Part Has Been Added ");
                    }
                });
            }
            
            function deleteItm(itmID){
                if(comStatus == "7"){
                    alert(" This Job Order Is Closed ");
                } else if(comStatus == "6"){
                    alert(" This Job Order Is Finishesd ");
                } else {
                    $.ajax({
                        url: "<%=context%>/IssueServlet?op=addSpareParts",
                        data: {
                            delItm: "delItm",
                            itmID: itmID
                        },
                        success: function() {
                            location.reload();
                            alert(" Spare Part Has Been Deleted ");
                        }
                    });
                }
            }
            
            function purchaseOrder(){
                document.Work_ITEMS_FORM.action = "<%=context%>/IssueServlet?op=addSpareParts&pO=1&busID=<%=busID%>";
                document.Work_ITEMS_FORM.submit();
            }
        </script>
        
        <style>
            * > * {
                vertical-align : middle;
            }
            
            table label {
                float: <fmt:message key="align" />;
                text-align: center;
            }
            
            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1;
            }
            
            tr:nth-child(even) td.dataTD {
                background: #FFF;
            }
            
            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }
            
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }
            
            .dataTD {
                float: <fmt:message key="align" />;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }
            
            
        </style>
    </head>
    <body>
        <FIELDSET class="set" style="width:80%; border-color: #006699">
            <legend align="center">
                <font color="blue" size="6">
                     <fmt:message key="spareParts" /> 
                </font>
            </legend>
            
            <form name="Work_ITEMS_FORM" method="post" enctype="multipart/form-data">
                <table style="width: 80%; padding-bottom: 5%;">
                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #339FFF;">
                             <fmt:message key="jobOrderDetails" /> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%;">
                             <img src="images/icons/Numbers.png" height="18" width="18" /> <fmt:message key="orderID" /> 
                        </td>

                        <td class="td dataTD" style="width: 25%;">
                             <%=busID%>
                             <input type="hidden" value="<%=busID%>">
                        </td>

                        <td class="td titleTD" style="width: 25%;">
                            <fmt:message key="orderstatus" />
                        </td>

                        <td class="td dataTD" style="width: 25%;">
                             <%=jobOrderWbo.getAttribute("status")%> 
                        </td>
                    </tr>
                </table>
                
                <table id="requestedItems" dir="ltr" style="margin-left: 5px; margin-bottom: 5px; width: 80%;">
                    <thead>
                        <tr>
                            <td class="blueBorder blueHeaderTD" style="width: 8%;"> Code </td>
                            <td class="blueBorder blueHeaderTD" style="width: 28%;"> Name </td>
                            <td class="blueBorder blueHeaderTD" style="width: 10%;"> Cost </td>
                            <td class="blueBorder blueHeaderTD" style="width: 10%;"> Amount </td>
                            <td class="blueBorder blueHeaderTD" style="width: 10%;"> Total </td>
                            <td class="blueBorder blueHeaderTD" style="width: 28%;"> Comment </td>
                            <td class="blueBorder blueHeaderTD" style="width: 6%;"> Delete </td>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            if(sprPrtLst != null){
                                for (WebBusinessObject sprPrtWbo : sprPrtLst) {%>
                                    <tr id="row">
                                        <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                            <b>
                                                <font size="2" color="#000080" style="text-align: center; width: 8%;">
                                                 <%=sprPrtWbo.getAttribute("code")%> 
                                                </font>
                                            </b>
                                        </td>

                                        <td class="silver_footer" bgcolor="#808000" style="text-align:center; color:black; font-size: 14px; width: 28%;">
                                            <b>
                                                <font color="#000080" style="text-align: center;">
                                                     <%=sprPrtWbo.getAttribute("prjName")%> 
                                                 </font>
                                            </b>
                                        </td>

                                        <td style="text-align: center; width: 10%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                            <%String amnt = ((String)sprPrtWbo.getAttribute("option3")).contains("-") ? "0" : (String)sprPrtWbo.getAttribute("option3");%> 
                                            <%=amnt%>
                                        </td>

                                        <td style="text-align: center; width: 10%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                             <%=sprPrtWbo.getAttribute("hourNum")%> 
                                        </td>

                                        <td style="text-align: center; border-left-width: 0px; width: 10%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                             <%=sprPrtWbo.getAttribute("total")%> 
                                        </td>

                                        <td style="text-align: center; border-left-width: 0px; width: 28%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                            <textarea type="text" style="width: 100%; border: none; cursor: not-allowed;" cols="10" readonly> <%=sprPrtWbo.getAttribute("note")%> </textarea>
                                        </td>
                                        
                                        <td style="text-align: center; border-left-width: 0px; width: 6%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                             <img src="images/icons/delete_ready.png" alt=" Delete Item " style="cursor: pointer; width: 20px; height: 20px;" onclick="deleteItm(<%=sprPrtWbo.getAttribute("itmID")%>);"/> 
                                        </td>
                                    </tr>
                        <%      }
                            }
                        %>
                        <%
                            counter = 0;
                            if (itemsDependOnList != null) {
                                ProjectMgr projectMgr = ProjectMgr.getInstance();
                                WebBusinessObject itemWbo;
                                for (WebBusinessObject requestItemWbo : itemsDependOnList) {
                                    itemWbo = projectMgr.getOnSingleKey((String) requestItemWbo.getAttribute("projectId"));
                                    if (itemWbo != null) {
                        %>
                        <tr id="row<%=counter%>">
                            <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                <b>
                                    <font size="2" color="#000080" style="text-align: center;">
                                     <%=itemWbo.getAttribute("eqNO")%> 
                                    </font>
                                </b>
                            </td>

                            <td class="silver_footer" bgcolor="#808000" style="text-align:center; color:black; font-size: 14px; height: 25px">
                                <b>
                                    <font color="#000080" style="text-align: center;">
                                         <%=itemWbo.getAttribute("projectName")%> 
                                     </font>
                                </b>
                            </td>

                            <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                 <%=itemWbo.getAttribute("optionThree")%>
                                 <input type="hidden" id="rateAmount<%=counter%>" name="id" value="<%=itemWbo.getAttribute("optionTwo")%>"> 
                            </td>
                            
                            <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                <input type="hidden" id="requestedItemId<%=counter%>" name="requestedItemId" value="<%=itemWbo.getAttribute("projectID")%>">
                                <input type="hidden" id="id<%=counter%>" name="id">
                                <input type="number" id="amount<%=counter%>" name="amount" value="1" style="text-align: center; width: 100%" min="1">
                            </td>
                            
                            <td style="text-align: center; border-left-width: 0px" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                <input type="text" id="total<%=counter%>" name="total" value="" style="width: 100%; text-align: center;" readonly>
                            </td>
                            
                            <td style="text-align: center; border-left-width: 0px" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                <textarea type="text" id="requestedItemNote<%=counter%>" name="requestedItemNote" value="" style="width: 100%" cols="5"/>
                            </td>
                        </tr>
                        <%
                                        counter++;
                                    }
                                }
                            }
                        %>
                    </tbody>
                </table>

                <table style="border: none;">
                    <tr style="border: none;">
                        <td style="border: none;">
                            <button class="button" type="button" id="btnRequestItems" onclick="openRequestItemsDailog();" style="width: 100%; margin-bottom: 5%;">
                                 Choose Spare Part <img src="images/short_cut_icon.png" alt="" height="25" width="25" />
                            </button>
                        </td>
                    </tr>
                </table>
                    
                <button class="button" type="button" onclick="purchaseOrder();" style="width: 15%; float: right; margin-right: 5%; margin-bottom: 5%; margin-top: 5%;">
                     Purchase Order <img src="images/icons/procurement.png" height="25" width="25" />
                </button>
                    
                <button class="button" type="button" onclick="saveBItems();" style="width: 15%;float: right; margin-right: 5%; margin-bottom: 5%; margin-top: 5%;">
                     Save Spare Part <img src="images/icons/accept.png" height="25" width="25" />
                </button>

                <input type="hidden" id="numberOfRequestedItems" name="numberOfRequestedItems" value="<%=counter%>" />
            </form>
        </FIELDSET>
    </body>
</html>
