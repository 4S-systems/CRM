<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
         String status = (String) request.getAttribute("status");
        ArrayList<WebBusinessObject> apartmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("apartmentsList");
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        ArrayList<WebBusinessObject> modelsList = (ArrayList<WebBusinessObject>) request.getAttribute("modelsList");

        String projectID = request.getAttribute("projectID") != null ? (String) request.getAttribute("projectID") : "";
	
	String unitAreaID = request.getAttribute("unitAreaID") != null ? (String) request.getAttribute("unitAreaID") : "All";
          
    %>
    <head>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui-1.11.2/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
            <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
            <script type="text/javascript" language="javascript" src="js/jquery.easing.1.3.js"></script>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        
              
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                $("#units").dataTable({
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "columnDefs": [{
                            "targets": 0,
                            "orderable": false
                        }],
                    "order": [[2, "asc"]]
                }).fadeIn(2000);
		
		var unitAreaID = <%=unitAreaID%>;
		$('#unitAreaID  option[value="' + unitAreaID + '"]').prop("selected", true);
            });
            function viewGallery(unitID, modelID) {
                var url = '<%=context%>/UnitDocReaderServlet?op=unitDocGallery&unitID=' + unitID + '&modelID=' + modelID;
                var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
            function viewDocuments(parentId) {
                var url = '<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId + '';
                var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
            function popupAttach(obj, projectId) {
                $("#attachInfo").html("");
                $("#projectId").val(projectId);
                count = 1;
                $("#addFile2").removeAttr("disabled");
                $("#counter2").val("0");
                $("#listFile2").html("");
                $('#attachDialog').show();
                $("#attachDialog").css("display", "block");
                $('#attachDialog').bPopup({
                    easing: 'easeInOutSine', 
                    speed: 400,
                    transition: 'slideDown'});
            }
            function addFiles2(obj) {
                if ((count * 1) === 4) {
                    $("#addFile2").removeAttr("disabled");
                }

                if (count >= 1 & count <= 4) {
                    $("#listFile2").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
                    $("#counter2").val(count);
                    count = Number(count * 1 + 1);

                } else {
                    $("#addFile2").attr("disabled", true);
                }
            }
       
       
         function sendFilesByAjax(obj) {
            $("#attachForm").submit(function (e)
            {
                $(obj).parent().find("#progressx").css("display", "block");
                var formObj = $(this);
                var formURL = formObj.attr("action");
                var formData = new FormData(this);
                $.ajax({
                    url: formURL,
                    type: 'POST',
                    data: formData,
                    mimeType: "multipart/form-data",
                    contentType: false,
                    cache: false,
                    processData: false,
                    success: function (data, textStatus, jqXHR)
                    {
                        $("#progressx").html('');
                        $("#progressx").css("display", "none");
                           $("#attachInfo").html("<font color='white'>تم رفع الملفات</font>");
                    },
                    complete: function (response)
                    {
                     
                        location.reload();
                    },
                    error: function ()
                    {
                        $("#attachInfo").html("<font color='red'>لم يتم رفع الملفات</font>");
                    }
                });
                e.preventDefault(); //Prevent Default action. 
                e.unbind();
            });

        }
        
            function closeAttachPopup() {
                $("#attachDialog").bPopup().close();
                $("#attachDialog").css("display", "none");
            }
            function submitForm() {
                document.UNIT_LIST_FORM.submit();
            }
            function updateModel() {
                if (!validateData("req", this.UNIT_LIST_FORM.modelID,  '<fmt:message key="selectModelMsg" />')) {
                    this.UNIT_LIST_FORM.modelID.focus();
                } else if (!isChecked()) {
                    alert('<fmt:message key="noUnitSelectedMsg" />');
                    return false;
                } else {
                    document.UNIT_LIST_FORM.action = "<%=context%>/UnitServlet?op=getUnitsDetailsReport&save=true";
                    document.UNIT_LIST_FORM.submit();
                }
            }
            function selectAll(obj) {
                $("input[name='unitID']").prop('checked', $(obj).is(':checked'));
            }
            function isChecked() {
                var isChecked = false;
                $("input[name='unitID']").each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                    }
                });
                return isChecked;
            }
        </script>
        <style type="text/css">
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
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
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
            .remove__{
                width:20px;
                height:20px;
                background-image:url(images/icons/remove1.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
            }
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                color: #ffffff;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #cc0000;
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .login-input {
                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #000;
                font-size: 13px;
                cursor: auto;
                text-shadow: 0 1px black;
                background: #2b3e5d;
                border: 1px solid #ffffff;
                border-top-color: #0d1827;
                border-radius: 4px;
                background: rgb(249,252,247); /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
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
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
    </head>
    <body>
        <form name="UNIT_LIST_FORM" method="POST">
            <fieldset align=center class="set" style="width: 80%; border-color: #006699;">
                <legend align="center">
                    <font color="#005599" size="5">
                    <fmt:message key="linkunits" /> </font>
                </legend>
                <br/>
                <%
                    if (status != null) {
                %>
                  <%
                            if (status.equalsIgnoreCase("ok")) {
                        %>
                         <b><font color="blue" size="3"><fmt:message key="saved" /></font></b>
                       
                        <%
                        } else {
                        %>
                             <b><font color="red" size="3"><fmt:message key="notsaved" /></font></b>
                         <%
                            }
                        %>
                    <br/>
                <%
                    }
                %>
                <br/>
                <table align="center" dir='<fmt:message key="direction" />'  style="width: 80%;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="10%">
                            <b><font size=3 color="white"><fmt:message key="project" /></b>
                        </td>
                         <td style="text-align:center"  width="25%" valign="MIDDLE">
                            <select name="projectID" id="projectID" style=" width:100%; height: 100%; font-size: larger; text-align-last:center;" onchange="JavaScript: submitForm();">
                                <sw:WBOOptionList wboList="<%=projectsList%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>" />
                            </select>
                        </td>
                        <td  width="5%" style="border: none"></td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="10%">
                            <b><font size=3 color="white"><fmt:message key="unitmodel" /></b>
                        </td>
                         <td style="text-align:center"  width="25%" valign="MIDDLE">
                            <select name="modelID" id="modelID" style="width:100%; height: 100%; font-size: larger; text-align-last:center;">
                                <sw:WBOOptionList wboList="<%=modelsList%>" displayAttribute="projectName" valueAttribute="projectID" />
                            </select>
                         </td>
                    </tr>
		    
		    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="10%">
                            <b>
				<font size=3 color="white">
				     <fmt:message key="unitArea" /> 
			    </b>
                        </td>
			
                         <td style="text-align:center"  width="25%" valign="MIDDLE">
                            <select name="unitAreaID" id="unitAreaID" style=" width:100%; height: 100%; font-size: larger; text-align-last:center;" onchange="JavaScript: submitForm();">
                                <option value="All"> All </option>
				<option value="90"> 90 </option>
				<option value="110"> 110 </option>
				<option value="128"> 128 </option>
				<option value="135"> 135 </option>
				<option value="175"> 175 </option>
				<option value="220"> 220 </option>
				<option value="278"> 278 </option>
				<option value="410"> 410 </option>
                            </select>
                        </td>
			
			<td  width="3%" style="border: none"></td>
			<td  width="12%" style="border: none" colspan="2">
                             <button type="button" onclick="JavaScript: updateModel();"   style="width: 50%; float: right;" class="button">
                                 <fmt:message key="update" />
                             </button>
                             
                         </td>
		    </TR>
                     
                     
                     
                </table>
                <br/>
                <div style="width: 80%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <table align="center" dir=<fmt:message key="direction" /> id="units" style="width:100%;">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" name="allUnits" id="allUnits" onclick="JavaScript: selectAll(this)"/>
                                </th>
                                 
                                <th><B><fmt:message key="unit" /></B></th>
                                <th><B><fmt:message key="CreationTime" /></B></th>
                                <th><B><fmt:message key="CreatedBy" /></B></th>
                                <th><B> <fmt:message key="unitmodel" /></B></th>
				
				<th>
				    <B>
					<fmt:message key="unitArea" /> 
				    </B>
				</th>
				
                                <th><B><fmt:message key="view" /></B></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject apartmentWbo : apartmentsList) {
                            %>
                            <tr>

                                <td style="text-align: center">
                                    <input type="checkbox" name="unitID" value="<%=apartmentWbo.getAttribute("projectID")%>"/>
                                </td>
                               
                                    <%
                                        
                                    String projectName=apartmentWbo.getAttribute("projectName") != null ?  (String) apartmentWbo.getAttribute("projectName") : "" ;
                                    String creationTime=apartmentWbo.getAttribute("creationTime") != null ?  (String) apartmentWbo.getAttribute("creationTime") : "" ;
                                    String CreatedBy=apartmentWbo.getAttribute("fullName") != null ?  (String) apartmentWbo.getAttribute("fullName") : "" ;

                                    String modelName= apartmentWbo.getAttribute("modelName") != null ?  (String) apartmentWbo.getAttribute("modelName") : "" ;
                                    
                                    %>
                                     <td>
                                         <b>
                                            <a href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=apartmentWbo.getAttribute("projectID")%>&fromPage=getUnitsDetailsReport">
                                             <%= projectName  %>
                                         </a>
                                         </b>
                                     </td>
                                     <td>
                                         <b><%= creationTime  %></b>
                                     </td>
                                     <td>
                                         <b><%= CreatedBy  %></b>
                                     </td>
                                     <td>
                                         <b><%= modelName  %></b>
                                     </td>
				     
				     <td>
                                         <b>
					    <% 
						if(apartmentWbo.getAttribute("area") != null){
						
					    %>
						     <%=apartmentWbo.getAttribute("area")%> 
					    <%
						}
					    %>
					 </b>
                                     </td>
                                
                                 <td nowrap>
                                    &nbsp;
                                    <img onclick="JavaScript: popupAttach(this, '<%=apartmentWbo.getAttribute("projectID")%>');"
                                         width="19px" height="19px" src="images/icons/Attach.png" title='<fmt:message key="attach" />'
                                         alt='<fmt:message key="attach" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img onclick="JavaScript: viewDocuments('<%=apartmentWbo.getAttribute("projectID")%>');"
                                         width="19px" height="19px" src="images/unit_doc.png" title='<fmt:message key="showunitfiles" />'
                                         alt='<fmt:message key="showunitfiles" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img onclick="JavaScript: viewDocuments('<%=apartmentWbo.getAttribute("Model_Code")%>');"
                                         width="19px" height="19px" src="images/model.png" title='<fmt:message key="showmodelfiles" />'
                                         alt='<fmt:message key="showmodelfiles" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img onclick="JavaScript: viewGallery('<%=apartmentWbo.getAttribute("projectID")%>', '<%=apartmentWbo.getAttribute("Model_Code")%>');"
                                         width="25px" height="25px" src="images/gallery.png" title='<fmt:message key="showimages" />'
                                         alt='<fmt:message key="showimages" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;

                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <br/>
                
               
                <br/>
            </fieldset>
       </form>
        <div id="attachDialog" class="smallDialog" style="position: fixed; width: 320px; display: none;">
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeAttachPopup()"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <form id="attachForm" action="<%=context%>/UnitDocWriterServlet?op=saveMultiFiles" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable>إرفاق رسم هندسي</lable>
                        <input type="button" id="addFile2" onclick="addFiles2(this)" value="+" />

                        <input id="counter2" value="" type="hidden" name="counter"/>
                        <input id="projectId" name="projectId" value="" type="hidden" />
                        </td>
                        <td style="text-align:right;width: 70%;" id="listFile2"> 
                        </td>
                        </tr>
                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="status"></div>
                    <div id="attachInfo" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <input type="submit" value="تحميل"  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendFilesByAjax(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
    </body>
</html>
