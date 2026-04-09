<%-- 
    Document   : assetreport
    Created on : Sep 12, 2017, 12:29:36 PM
    Author     : asteriskpbx
--%>

<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.lang.String"%>
<%@page import="java.util.ArrayList"%>

<%@page import="java.util.Enumeration"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<!DOCTYPE html>

<%
    ArrayList<WebBusinessObject> lst = (ArrayList<WebBusinessObject>)request.getAttribute("rowdata");
  String  tit="Report Of Asset";
   
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String id = request.getAttribute("id") != null ? (String) request.getAttribute("id") : "";
            String projectName = request.getAttribute("projectName") != null ? (String) request.getAttribute("projectName") : "";
             ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList<WebBusinessObject> equClassLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("EQP_CLASS", "key6"));
    ArrayList<WebBusinessObject> branches = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key4"));

%>

<html>
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
       
         <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
         <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
         <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
         <script type="text/javascript" src="js/jquery.dataTables.js"></script>

<link rel="stylesheet" href="css/demo_table.css">

<script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

 <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
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
            .smallDialog {
                width: 320px;
                display: none;
                position: fixed;
                z-index: 1100;
            }
            .mediumDialog {
                width: 90%;
                display: none;
                position: fixed;
                z-index: 1100;
                left: 5%;
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 1000;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }
            #container{
	font-family:Arial, Helvetica, sans-serif;
	position:absolute;
	top:0;
	left:0;
	background: #005778;
	width:100%;
	height:100%;
}
.hot-container p { margin-top: 10px; }
a { text-decoration: none; margin: 0 10px; }

.hot-container {
	min-height: 100px;
	margin-top: 100px;
	width: 100%;
	text-align: center;
}

a.btn {
	display: inline-block;
	color: #666;
	background-color: #eee;
	text-transform: uppercase;
	letter-spacing: 2px;
	font-size: 12px;
	padding: 10px 30px;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border: 1px solid rgba(0,0,0,0.3);
	border-bottom-width: 3px;
}

	a.btn:hover {
		background-color: #e3e3e3;
		border-color: rgba(0,0,0,0.5);
	}

        #mypopup{
            padding-top: 20%;
        }
        </style>
   <script>$(document).ready(function() {
    $('#assetrep').dataTable({
        bJQueryUI: true,
        sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
    });
    
    $("#branch").select2();
    
} );</script>
<script>
   function showUpdatePopup(projectId, room,floor,model,branch) {
       $("#mypopup").bPopup();
       $("#edtAsstName").val($("#asstName"+projectId).val());
       $("#selectclass").val($("#assetClass"+projectId).val());
       $("#ro").val(room);
       $("#fl").val(floor);
       $("#mo").val(model);
       $("#brn").val(branch);
       $("#prjID").val(projectId);
            }
            
            function updateProjectAsset(){
                var projectId = $("#prjID").val();
                var selectclass = $("#selectclass").val();
                var modd=$("#mo").val();
                //var braa=$("#selectbranch").val();
                var floo=$("#fl").val();
                var roo=$("#ro").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=getasset",
                    data: {
                        id: projectId,
                        sel: selectclass,
                        mod:modd,
                        //bbrr:braa,
                        flo:floo,
                        rom:roo,
                        myOp: "up"
                        
                    }
                    ,
                    success: function (jsonString) {
                   
                    } 
                });
            }
   function deleteassetdata(id) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=deleteassetdata",
                    data: {
                        id: id, 
                myOp: "de"
                    }
                    ,
                    success: function (jsonString) {
                       /* var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
                            alert("تم الحذف بنجاح");
                            closePopup();
                            location.reload();
                        } else if (eqpEmpInfo.status == 'no') {
                            alert("خطأ لم يتم الحذف");
                            closePopup();
                        }*/
                    }
                });
            }
            
        function closePopup(){
            $("#mypopup").bPopup().close();
        }
        
        function isChecked() {
                var CheckedNo = 0;
                $("input[name='asstID']").each(function () {
                    if ($(this).is(':checked')) {
                        CheckedNo = CheckedNo + 1;
                    }
                });
                return CheckedNo;
            }
            
            function updateBranch(){
                var CheckedNo = isChecked();
                if(CheckedNo == 1){
                    
                    var assetID = $("#asstID:checked").val()
                    $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=getasset",
                    data: {
                        id: assetID,
                        bbrr:  $("#branch").val(),
                        myOp: "upBranch"
                        
                    }
                    ,
                    success: function (jsonString) {
                        location.reload();
                    } });
                } else {
                    alert(" Please Check ONe Asset At Least. ");
                }
            }
   </script>
    </head>
    <body>
         <table style="width: 25%;" align="center" cellpadding="0" cellspacing="0" BORDER="0">
                <tr>
                    <td class='td' style="text-align: center;">
                        <select id="branch" name="branch" style="font-size: 14px;font-weight: bold; width: 300px;" >
                            <option > Choose Branch </option>
                            <sw:WBOOptionList wboList='<%=branches%>' displayAttribute="projectName" valueAttribute="projectID" />
                        </select>
                        <a href="#" class="btn" onclick="updateBranch();"> Attach branch </a>
                    </td>
                </tr>
            </table> 
                                
        <div>
             <fieldset align=center class="set" style="width: 90%">
                 <legend align="center">
            <table>
                    <tr>

                        <td class="td">
                            <font color="blue" size="5"><%=tit%> 
                            </font>
                        </td>
                    </tr>
                </table>
                            </legend>
                            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
        <TABLE style="width: 100%"  id="assetrep"dir=<fmt:message key="direction" style="width:100%;display: none; "/>   
                        <thead>
                            <tr>
                                <th></th>
                                <th style="color: #000000 !important;   "><font size="2">Asset Name</font></th>
                                <th style="color: #000000 !important;  "><font size="2">Class</font></th>
                                <th style="color: #000000 !important; "><font size="2">Description</font></th>
                                <th style="color: #000000 !important; "><font size="2">Model</font></th>
                                <th style="color: #000000 !important; "> <font size="2">Branch</font></th>
                                <th style="color: #000000 !important;  "><font size="2">Floor</font></th>
                                <th style="color: #000000 !important;"><font size="2">Room</font></th>
                                <th style="color: #0000FF !important"><font size="3">update</font></th>
                                <th style="color: #0000FF !important"><font size="3">delete</font></th>
                               
                                
                              
                            </tr>
                        <thead>
                        <tbody>  
                          
                            <%for(int i=0;i<lst.size();i++){  
                            WebBusinessObject myWbo = lst.get(i);
                            WebBusinessObject myWbo1=branches.get(i);
                            String[] parts= myWbo.getAttribute("optionOne").toString().split(":");
                            String[] floor = parts[1].split("R");   //floor[0]
                            String[] room = parts[2].split("M");   //room[0]    modle=parts[3]
                            %>
                            
                            <tr>
                                <td>
                                 <input type="checkbox" name="asstID" id="asstID" value="<%=myWbo.getAttribute("projectID")%>"/>
                                </td>
             <td><%=myWbo.getAttribute("assetName")%> <input type="hidden" id="asstName<%=myWbo.getAttribute("projectID")%>" value="<%=myWbo.getAttribute("assetName")%>"></td>
             <td><%=myWbo.getAttribute("assetClass")%><input type="hidden" id="assetClass<%=myWbo.getAttribute("projectID")%>"value="<%=myWbo.getAttribute("assetClass")%>"></td>
             <td><%=myWbo.getAttribute("projectDesc")%></td>
             <td><%=parts[3]%></td>
             <td><%=myWbo.getAttribute("branch") %><input type="hidden" id="assetbranch<%=myWbo.getAttribute("projectID")%>"value="<%=myWbo.getAttribute("assetbranch")%>"></td>
             <td><%=floor[0]%></td>
             <td><%=room[0]%></td>
             <td><a id="upd" style="color: #0000FF" onclick="showUpdatePopup('<%=myWbo.getAttribute("projectID")%>', '<%=room[0]%>','<%=floor[0] %>','<%=parts[3] %>','<%=myWbo.getAttribute("branch") %>')">update asset</a></td>
             <td><a id="del" style="color: #0000FF" onclick="deleteassetdata('<%=myWbo.getAttribute("projectID") %>');">delete asset</a></td>
               
               
               
               </tr>
               <%}%>
    
                
                        </tbody>  

                    </TABLE>
               </div>
         
                 </fieldset>
        </div>
               
               <div id="mypopup" style="display: none; height: 95%;">
                   <div style="clear: both;margin-left: 95%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup()"/>
        </div>
                   <div class="login" style="width: 100%;">
                        <form name="DD" action="" method="post">
                       <table id="assetdata">
                           <thead>
                          
                           <th>Name</th>
                           <th>Class</th>
                           <th>Model</th>
                           <th>Floor</th>
                           <th>Room</th>
                           <th></th>
                           </thead>
                           <tbody>
                          
                          
                           
                           
                           <td><input type="text" name="des" id="edtAsstName"></td>
                           <td><select id="selectclass" name="sel">
                              <%for(int i=0; i<equClassLst.size(); i++){%>
                              <option value="<%=equClassLst.get(i).getAttribute("projectID")%>"><%=equClassLst.get(i).getAttribute("projectName")%></option>
                        <%}%>
                               </select></td>
                               <td><input type="text" id="mo" name="mod"></td>
                               <td><input type="text" id="fl" name="flo"></td>
                               <td><input type="text" id="ro" name="rom"></td>
                           <td><input type="hidden" id="prjID"><input type="submit" value="update" onclick="updateProjectAsset();"></td>
                           

                           </tbody>
                       </table>
                           </form>
                   </div>
               
    </body>
</html>
