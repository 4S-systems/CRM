<%-- 
    Document   : storesContent
    Created on : Oct 1, 2017, 12:28:42 PM
    Author     : fatma
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    ArrayList<WebBusinessObject> strLst = request.getAttribute("strLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("strLst") : null;
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> sprPrt = request.getAttribute("sprPrt") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("sprPrt") : null;
    ArrayList<WebBusinessObject> sprTyp = request.getAttribute("sprTyp") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("sprTyp") : null;
    
    int iTotal = 0, flipper = 0;
    String className = new String();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Stores </title>
    </head>
    
    <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
    
    <script src="js/select2.min.js"></script>
    
    <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
    
    <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
    
    <link href="js/select2.min.css" rel="stylesheet">
    
    <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
    
    <script>
        $(document).ready(function(){
            $("#strID").select2();
            $("#typID").select2();
            
                $('#sprPrtLst').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "bAutoWidth": true,
                    "aaSorting": [[0, "asc"]]
                }).fadeIn(2000);
        });
        
        function getSpareTypes(){
            var strID = $("#strID option:selected").val();
            
            $("#tblDiv").fadeOut();
            
            $.ajax({
                type: "post",
                data: {
                    strID: strID,
                    getType: "1"
                },
                url: "<%=context%>/StoreServlet?op=storeContent",
                success: function (jsonString) {
                    var sprTyp = $.parseJSON(jsonString);
                    var options = [];
                    
                    options.push('<option value=""> All Types </option>');
                    
                    $.each(sprTyp, function () {
                       options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                    });
                    
                    $("#typID").html(options.join(''));
                }
            });
        }
        
        function getSpareParts(){
            var typID = $("#typID option:selected").val();
            var strID = $("#strID option:selected").val();
            
            $("#tblDiv").fadeIn();
            
             $.ajax({
                type: "post",
                data: {
                    typID: typID,
                    strID: strID,
                    getSpr: "1"
                },
                url: "<%=context%>/StoreServlet?op=storeContent",
                success: function (jsonString) {
                    var sprTyp = $.parseJSON(jsonString);
                    var tds = [];
                    
                    $.each(sprTyp, function () {
                        tds.push('<tr> <td style="width: 5%;"> <input type="checkbox" name="sprID" id="sprID" value="', this.projectID , '"/> </td>');
                        tds.push('<td style="width: 75%;">', this.projectName, '</td>');
                        tds.push('<td style="width: 10%;">', this.optionOne, '</td> </tr>');
                    });
                    
                    $("#tblBd").html(tds.join(''));
                }
            });
        }
        
        function addMaterial() {
            var strID = $("#strID option:selected").val();
            if(strID == ""){
                alert(" Choose Store From Store List ");
            } else {    
                $("#strIDPP").val(strID);
                
                $.ajax({
                    type: "post",
                    data: {
                        strID: strID,
                        getTyps: "1"
                    },
                    url: "<%=context%>/StoreServlet?op=storeContent",
                    success: function (jsonString) {
                        var sprTyps = $.parseJSON(jsonString);
                        var tds = [];
                    
                        $.each(sprTyps, function () {
                            tds.push('<tr> <td nowrap class="silver_odd_main" >', this.projectName, '</td>');
                            tds.push('<td nowrap class="silver_odd_main"> <input type="checkbox" name="typID" id="typID" value="', this.projectID , '"/></td></tr>');
                        });
                        $("#sprTypBd").html(tds.join(''));
                    }
                });

                $('#addMaterial').css("display", "block");
                $('#addMaterial').bPopup();
            }
        }
        
        function closePopup(divName){
            $('#' + divName).bPopup().close();
        }
        
        function isChecked(eleID) {
                var isChecked = false;
                $("input[name='" + eleID + "']").each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                    }
                });
                return isChecked;
            }
            
        function addTypStrFun(){
            var strIDPP = $("#strIDPP").val();
            
            var typIDs = [];
            
            $("input[name=typID]:checked").each(function() {
                typIDs.push($(this).val());
            });
            
            if(isChecked("typID")){
                $.ajax({
                    type: "post",
                    data: {
                        strIDPP: strIDPP,
                        typIDs: typIDs.join(),
                        addTypStr: "1"
                    },
                    url: "<%=context%>/StoreServlet?op=storeContent",
                    success: function (jsonString) {
                        var result = $.parseJSON(jsonString);
                        
                        if(result.flag == "true"){
                            alert(" Spare/Material Type Has Been Added ");
                            $('#addMaterial').bPopup().close();
                        } else {
                            alert(" Spare/Material Type Has not Been Added ");
                        }
                        
                        $("#typID").empty();
                        getSpareTypes();
                    }
                });
            } else {
                alert(" Choose One Type At Least ");
            }
        }
        
        function purchaseOrder(){
            if(isChecked("sprID")){
                document.SRTFORM.action = "<%=context%>/IssueServlet?op=addSpareParts&pO=2";
                document.SRTFORM.submit();
            } else {
                alert(" Choose One Spare Part / Material At Least ")
            }
        }
    </script>
    
    <style>
        *>*{
            vertical-align: middle;
        }
        
        .login {
            /*display: none;*/
            direction: rtl;
            margin: 20px auto;
            padding: 10px 5px;
            /*        width:30%;*/
            background: #3f65b7;
            background-clip: padding-box;
            border: 1px solid #ffffff;
            border-bottom-color: #ffffff;
            border-radius: 5px;
            color: #ffffff;
            background: #7abcff; /* Old browsers */
            /* IE9 SVG, needs conditional override of 'filter' to 'none' */
            /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
            background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
            background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */

            -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
            -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
            box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
            -webkit-border-radius: 20px;
            -moz-border-radius: 20px;
            border-radius: 20px;
        }
    </style>
    <body>
        <fieldset class="set" style="width:80%; border-color: #006699;">
            <FORM NAME="SRTFORM" id="SRTFORM" METHOD="POST">
                <table ALIGN="center" DIR="center" WIDTH="80%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="25%">
                            <input type="text" value=" Choose Store " style="background: url(../images/thbg.jpg); width: 100%; text-align: center; border: none; color: white;" readonly>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <select id="strID" name="strID" style="font-size: 14px; width: 75%" onchange="getSpareTypes();">
                                <option value=""> Choose Store </option>
                                <sw:WBOOptionList wboList="<%=strLst%>" displayAttribute="projectName" valueAttribute="projectID"/>
                            </select>
                        </td>
                        
                        <td style="text-align:center; border: none;" valign="MIDDLE">
                            <img src="images/icons/add_item.png" title=" Add Material " style="width: 30px; height: 30px;" onclick="addMaterial();"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="25%">
                            <input type="text" value=" Choose Spare Type " style="background: url(../images/thbg.jpg); width: 100%; text-align: center; border: none; color: white;" readonly>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <select id="typID" name="typID" style="font-size: 14px; width: 75%" onchange="getSpareParts();">
                            </select>
                        </td>
                    </tr>
                </table>
                  
                <div id="tblDiv" style="width: 80%; display: none; padding-top: 5%;" align="center">
                    <table id="sprPrtLst" name="sprPrtLst">
                        <thead>
                            <tr>
                                <th></th>
                                
                                <th>
                                     Spare Parts 
                                </th>
                                
                                <th>
                                     Quantity 
                                </th>
                            </tr>
                        </thead>
                        
                        <tbody id="tblBd">
                        </tbody>
                    </table>
                    
                    <button class="button" type="button" onclick="purchaseOrder();" style="width: 20%; float: right; margin-bottom: 5%; margin-top: 5%;">
                         Purchase Order <img src="images/icons/procurement.png" height="25" width="25" />
                    </button>
                </div>
            </form>
        </fieldset>
                            
        <div id="addMaterial" style="display: none; width: 50%;">
            <div style="width: 32px; clear: both; margin-left: 8%; margin-top: 0px; margin-bottom: -38px; z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px;
                                                                                border-radius: 100px;" onclick="closePopup('addMaterial')"/>
            </div>
            
            <div class="login" style="width: 80%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: 300px;">
                <form id="addTypStrForm" name="addTypStrForm" method="POST">
                    <input type="hidden" id="strIDPP" name="strIDPP">
                    
                    <div style="width: 80%; margin-left:auto; margin-right:auto;" >
                        <table id="sprTyps" align="center" width="100%">
                            <thead>
                                <tr>
                                    <th nowrap class="silver_header" width="90%" style="border-width:0;" nowrap>
                                        <b>
                                             Spare/Material Types 
                                        </b>
                                    </th>
                                    
                                    <th nowrap class="silver_header" width="10%" style="border-width:0;" nowrap>
                                    </th>
                                </tr>
                            </thead>
                            <tbody id="sprTypBd">
                            </tbody>
                        </table>
                            
                        <input class="button" type="button" id="addTypStr" name="addTypStr" value="Add" onclick="addTypStrFun();">
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>