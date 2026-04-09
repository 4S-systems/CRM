<%-- 
    Document   : addMaintenanceItems
    Created on : Sep 10, 2017, 10:31:12 AM
    Author     : fatma
--%>

<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>

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
        <title> Business Items </title>
        
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            
            ArrayList<WebBusinessObject> itemsDependOnList = request.getAttribute("itemsDependOnList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("itemsDependOnList") : null;
            
            String issueId = request.getAttribute("issueId") != null ? (String) request.getAttribute("issueId") : "";
            
            int counter = 0;
            
            ArrayList<WebBusinessObject> MItmLst = request.getAttribute("MItmLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("MItmLst") : null;
            
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
                            locType: "MAINTENANCE-ITEM"
                        },
                        success: function(data) {
                            divTag.html(data).dialog({
                                modal: true,
                                title: " Add Maintenance Items ",
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
                                        var itemId, itemCode, itemName, className, rateHour;
                                        var counter = $('#numberOfRequestedItems').val();
                                        $(this).find(':checkbox:checked').each(function() {
                                            itemId = $(divTag.html()).find('#itemId' + this.value).val();
                                            itemCode = $(divTag.html()).find('#itemCode' + this.value).val();
                                            itemName = $(divTag.html()).find('#itemName' + this.value).val();
                                            rateHour = $(divTag.html()).find('#rateHour' + this.value).val();
                                             if(rateHour==null)
                                            {
                                                rateHour="0";
                                            } else if(rateHour == ""){
                                                rateHour="0";
                                            } else if(Number(rateHour) < 0){
                                                rateHour="0";
                                            } else if(rateHour.indexOf('-') >= 0){
                                                rateHour='0';
                                            }
                                            $(divTag.html()).find('#rateHour' + this.value).val(rateHour);
                                            if (counter % 2 === 1) {
                                                className = "silver_odd_main";
                                            } else {
                                                className = "silver_even_main";
                                            }
                                            $('#requestedItems > tbody:last').append("<TR id=\"row" + counter + "\"></TR>");
                                            $('#row' + counter).append("<TD STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><b><font size=\"2\" color=\"#000080\" style=\"text-align: center;\">" + itemCode + "</font></b></TD>")
                                                                .append("<TD class=\"silver_footer\" bgcolor=\"#808000\" STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\">" + itemName + "</font></b></TD>")
                                                                .append("<TD STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + ">" + rateHour + "<input type=\"hidden\" id=\"rateHour" + counter + "\" name=\"id\" value=\"" + rateHour + "\"></td></TD>")
                                                                .append("<TD STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><input type=\"hidden\" id=\"requestedItemId" + counter + "\" name=\"requestedItemId\" value=\"" + itemId + "\"/><input type=\"hidden\" id=\"id" + counter + "\" name=\"id\" /><input type=\"number\" id=\"hours" + counter + "\" name=\"hours\" value=\"1\" style=\"text-align: center; width: 100%\" min=\"1\" onchange=\"calcTotal(" + counter + ");\"/></TD>")
                                                                .append("<td style=\"text-align: center; border-left-width: 0px\" bgcolor=\"#DDDD00\" nowrap=\"\" class=\"silver_even_main\"><input type=\"text\" id=\"total" + counter + "\" name=\"total\" value=\"" + rateHour + "\" style=\"width: 100%; text-align: center;\" readonly></td>")
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
            
            function calcTotal(rowNum){
            var rh=Number($("#rateHour" + rowNum).val());
            if(rh==null){
                rh=0;
                var total =  rh* Number($("#hours" + rowNum).val());
                $("#total" + rowNum).val(total);
            }
            else
            {
              var total =  rh* Number($("#hours" + rowNum).val());
                $("#total" + rowNum).val(total);
            }
        }
            function saveBItems(){
                if (document.getElementById('row0') === null) {
                    alert(" Choose One Maintenance Item At Least ");
                    $("#btnRequestItems").click();
                }
                var counter = $("#numberOfRequestedItems").val();
                
                var requestedItemIdArr = [];
                var hours = [];
                var total = [];
                var requestedItemNote = [];
                var cmnt;
                
                for(var i=0; i<counter; i++){
                    requestedItemIdArr.push($("#requestedItemId" + i).val());
                    hours.push($("#hours" + i).val());
                    total.push($("#total" + i).val());
                    if($("#requestedItemNote" + i).val() == ""){
                        cmnt = " none ";
                    } else {
                        cmnt = $("#requestedItemNote" + i).val();
                    }
                    requestedItemNote.push(cmnt);
                }
                
                $.ajax({
                    url: "<%=context%>/IssueServlet?op=addMaintenanceItems",
                    data: {
                        issueId: <%=issueId%>,
                        reqType: "jobOrder",
                        requestedItemIdArr: requestedItemIdArr.join(),
                        hours: hours.join(),
                        total: total.join(),
                        requestedItemNote: requestedItemNote.join()
                    },
                    success: function(data, textStatus, jqXHR) {
                        location.reload();
                        alert(" Maintenance Item Has Been Added ");
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
                        url: "<%=context%>/IssueServlet?op=addMaintenanceItems",
                        data: {
                            delItm: "delItm",
                            itmID: itmID
                        },
                        success: function() {
                            location.reload();
                            alert(" Maintenance Item Has Been Deleted ");
                        }
                    });
                }
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
                     <fmt:message key="addMWork" /> 
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
                             <fmt:message key="orderID" /> 
                        </td>

                        <td class="td dataTD" style="width: 25%;">
                             <%=issueId%> 
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
                            <td class="blueBorder blueHeaderTD" style="width: 10%;"> R/H </td>
                            <td class="blueBorder blueHeaderTD" style="width: 10%;"> Hours </td>
                            <td class="blueBorder blueHeaderTD" style="width: 10%;"> Total </td>
                            <td class="blueBorder blueHeaderTD" style="width: 28%;"> Comment </td>
                            <td class="blueBorder blueHeaderTD" style="width: 6%;"> Delete </td>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            if(MItmLst != null){
                                for (WebBusinessObject MItmWbo : MItmLst) {%>
                                    <tr id="row">
                                        <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                            <b>
                                                <font size="2" color="#000080" style="text-align: center; width: 8%;">
                                                 <%=MItmWbo.getAttribute("code")%> 
                                                </font>
                                            </b>
                                        </td>

                                        <td class="silver_footer" bgcolor="#808000" style="text-align:center; color:black; font-size: 14px; width: 28%;">
                                            <b>
                                                <font color="#000080" style="text-align: center;">
                                                     <%=MItmWbo.getAttribute("prjName")%> 
                                                 </font>
                                            </b>
                                        </td>

                                        <td style="text-align: center; width: 10%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                             <%String amnt = ((String)MItmWbo.getAttribute("option3")).contains("-") ? "0" : (String)MItmWbo.getAttribute("option3");%> 
                                            <%=amnt%>
                                        </td>

                                        <td style="text-align: center; width: 10%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                             <%=MItmWbo.getAttribute("hourNum")%> 
                                        </td>

                                        <td style="text-align: center; border-left-width: 0px; width: 10%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                             <%=MItmWbo.getAttribute("total")%> 
                                        </td>

                                        <td style="text-align: center; border-left-width: 0px; width: 28%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                            <textarea type="text" style="width: 100%; border: none; cursor: not-allowed;" cols="10" readonly> <%=MItmWbo.getAttribute("note")%> </textarea>
                                        </td>
                                        
                                        <td style="text-align: center; border-left-width: 0px; width: 6%;" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                             <img src="images/icons/delete_ready.png" alt=" Delete Item " style="cursor: pointer; width: 20px; height: 20px;" onclick="deleteItm(<%=MItmWbo.getAttribute("itmID")%>);"/> 
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
                                 <input type="hidden" id="rateHour<%=counter%>" name="id" value="<%=itemWbo.getAttribute("optionTwo")%>"> 
                            </td>
                            
                            <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                                <input type="hidden" id="requestedItemId<%=counter%>" name="requestedItemId" value="<%=itemWbo.getAttribute("projectID")%>">
                                <input type="hidden" id="id<%=counter%>" name="id">
                                <input type="number" id="hours<%=counter%>" name="hours" value="1" style="text-align: center; width: 100%" min="1">
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
                    <tr>
                        <td>
                            <button type="button" id="btnRequestItems" onclick="openRequestItemsDailog();" style="width: 100%;">
                                 Choose Item <img src="images/short_cut_icon.png" alt="" height="18" width="18" />
                            </button>
                        </td>
                    </tr>
                </table>
                    
                <button type="button" onclick="saveBItems();" style="float: right; margin-right: 5%; margin-bottom: 5%;">
                     Save Items <img src="images/icons/accept.png" height="18" width="18" />
                </button>

                <input type="hidden" id="numberOfRequestedItems" name="numberOfRequestedItems" value="<%=counter%>" />
            </form>
        </FIELDSET>
    </body>
</html>