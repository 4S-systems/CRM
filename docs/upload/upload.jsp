<%-- 
    Document   : index
    Created on : Jan 14, 2015, 9:35:41 AM
    Author     : haytham
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%>
<!DOCTYPE html>
<html>
    <head>
        <%  
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String businessObjectId = request.getParameter("businessObjectId");
            String objectType = request.getParameter("objectType");
            List<WebBusinessObject> docTypesList = (ArrayList<WebBusinessObject>) request.getAttribute("docTypesList");
            String context = metaMgr.getContext();
        %>
        <title>Ajax File Upload with Progress Bar</title>
        <!-- Include jQuery form & jQuery script file. -->

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script src="js/jquery/fileupload/jquery.form.js" ></script>
        <script src="js/jquery/fileupload/fileUploadScript.js" ></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet"></link>
        <!-- Include css styles here -->
        <style>
            #UploadForm {
                display: block;
                margin: 20px auto;
                border-radius: 10px;
                padding: 15px;
                border: 1px solid #C3C6C8;
                background-color: #E8E8E8;
                padding-bottom: 2px;
                padding-top: 2px
            }

            #progressbox {
                position: relative;
                width: 400px;
                border: 1px solid #ddd;
                padding: 1px;
                border-radius: 3px;
            }

            #progressbar {
                background-color: lightblue;
                width: 0%;
                height: 20px;
                border-radius: 4px;
            }

            #percent {
                position: absolute;
                display: inline-block;
                top: 3px;
                left: 48%;
            }
        </style>

    </head>
        <script type="text/javascript" language="javascript">
//           
            
            var loadFile = function(event) {
            var reader = new FileReader();
            reader.onload = function(){
              var output = document.getElementById('fileImg2');
              output.src = reader.result;
            };
            reader.readAsDataURL(event.target.files[0]);
              
            $("#fileName").html($("#myfile").val().split("\\",3)[2]);
           
            };
            
//            function submitForm(){
//                var formData = new FormData();
//                  formData.append("businessObjectId",'<%=businessObjectId%>');
//                  formData.append("documentType",$('select[name=documentType]').val());
//                  formData.append("objectType",'<%=objectType%>');
//                formData.append('file', $('#myfile')[0].files[0]);
//
//                $.ajax({
//                url : '<%=context%>/FileUploadServlet?op=upload',
//                type : 'POST',
//                data : formData,
//                processData: false,  // tell jQuery not to process the data
//                contentType: false,  // tell jQuery not to set contentType
//                enctype: 'multipart/form-data',
//                success : function(jsonString) {
//                
//                var info=$.parseJSON(jsonString);
//                alert(info.documentID);
//                 $("#documentID").val(info.documentID).change();
//                }
//                }); 
//            
//            
//            }
           
        </script>
    <body>
        <form id="UploadForm" action="FileUploadServlet?op=upload" method="post" enctype="multipart/form-data">
            <label for="documentType"><b>Document Type :</b>
                <select name="documentType">
                    <sw:WBOOptionList wboList="<%=docTypesList%>" displayAttribute="typeName" valueAttribute="typeID"/>
                </select>
            </label>
            <br/>
            <input type="file" size="60" id="myfile" name="myfile" onchange="javascript:loadFile(event)" accept="image/*"/>
            <input type="hidden" name="businessObjectId" id="businessObjectId" value="<%=businessObjectId%>" />
            <input type="hidden" name="objectType" id="objectType" value="<%=objectType%>" />
            <input type="submit" value=" Upload " style="width: 80px;" />
                    
            <div id="progressbox">
                <div id="progressbar"></div>
                <div id="percent">0%</div>
                        </div>
            <br />
            <div id="message"></div>
        </form>
    </body>
</html>
