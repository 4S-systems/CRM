<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
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
        String[] buildingAttributes = {"projectName"};
        String[] buildingListTitles = new String[6];
        int s = buildingAttributes.length;
        int t = s + 5;
        String attName = null;
        String attValue = null;
        String status = (String) request.getAttribute("status");
        Vector buildingsList = (Vector) request.getAttribute("data");
        WebBusinessObject wbo = null;
        String stat = (String) request.getSession().getAttribute("currentMode");
         String buildingsNo, sSccess, sFail, unitsModels, pricingUnits;
        if (stat.equals("En")) {
              buildingListTitles[0] = "Site Name";
            buildingListTitles[1] = "View";
            buildingListTitles[2] = "";
            buildingListTitles[3] = "";
            buildingListTitles[4] = "Delete";
            buildingListTitles[5] = "Add Model";
            buildingsNo = "Buildings No.";
               sSccess = "Building Deleted Successfully";
            sFail = "Fail To Delete Building";
            unitsModels = "Units Models";
            pricingUnits = "Units Pricing";
        } else {
              buildingListTitles[0] = "المبني";
            buildingListTitles[1] = "عرض";
            buildingListTitles[2] = "";
            buildingListTitles[3] = "";
            buildingListTitles[4] = "حذف";
            buildingListTitles[5] = "إضافة نموذج سكنى";
            buildingsNo = "عدد العمائر";
             sSccess = "تم حذف المبني بنجاح";
            sFail = "لم يتم الحذف";
            unitsModels = "نماذج الوحدات";
            pricingUnits = "تسعير الوحدات";
        }
    %>
    <HEAD>
        <TITLE>Buildings List</TITLE>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
            <script type="text/javascript" language="javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">


        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

        <!--<script type="text/javascript" src="js/jquery.chained.remote.min.js"></script>  -->
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        
        
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function() {
                oTable = $('#buildings').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
                centerDiv('add_ModelDiv');
            });
            function showUnitsList(buildingId) {
                var url = "<%=context%>/ProjectServlet?op=showUnits&buildingId=" + buildingId;
                jQuery('#units_list').load(url);
                $('#units_list').show();
//                centerDiv('units_list');
                divID = 'units_list';
                $("#overlay").show();
            }
            function centerDiv(div) {
                $("#" + div).css("position", "fixed");
                $("#" + div).css("top", Math.max(0, (($(window).height() - $("#" + div).outerHeight()) / 2) +
                        $(window).scrollTop()) + "px");
                $("#" + div).css("left", Math.max(0, (($(window).width() - $("#" + div).outerWidth()) / 2) +
                        $(window).scrollLeft()) + "px");
            }
            function closeOverlay() {
                $("#" + divID).hide();
                $("#overlay").hide();
            }
            function closePopup(formID) {
                closeOverlay();
            }
            function viewDocuments(parentId) {
                var url = '<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId + '';
                var wind = window.open(url, '<fmt:message key="listdocs" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
            function viewGallery(unitID, modelID) {
                var url = '<%=context%>/UnitDocReaderServlet?op=unitDocGallery&unitID=' + unitID + '&modelID=' + modelID;
                var wind = window.open(url,  '<fmt:message key="listdocs" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
            function showAddModel(obj) {
                $('#add_ModelDiv').show();
                divID = 'add_ModelDiv';
                $("#overlay").show();
                $("#projectCode").val(obj);
                $("#modelName").val('');
                $("#message").html('');
//                $('#add_ModelDiv').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
//                    speed: 400,
//                    transition: 'slideDown'});
                $('#add_ModelDiv').show();
                $("#overlay").show();
            }
            function addModel() {
                var mainProjectID = $("#projectCode").val();
                var projectDesc = $("#modelName").val();
                $.ajax({
                    url: "<%=context%>/ProjectServlet?op=saveModelUnderBuilding",
                    data: {projectName: projectDesc, mainProjectId: mainProjectID},
                    type: 'POST',
                    success: function(data) {

                        if (data === 'Ok') {
                            $("#message").html('<fmt:message key="saved" />');
//                            hideAddModel();
                        } else if (data === 'No') {
                            $("#message").html('<fmt:message key="notsaved" />');
//                            hideAddModel();

                        } else if (data === 'NO-Dublicate') {
                            $("#message").html('<fmt:message key="modelerror" />');
//                            hideAddModel();

                        }
                    }

                });

            }

            function hideAddModel() {
                $('#add_ModelDiv').hide();
                divID = 'add_ModelDiv';
                $("#overlay").hide();
                $("#projectCode").val('');
            }
            function viewDocuments(parentId) {
                var url='<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=' + parentId +'';
                var wind = window.open(url,'<fmt:message key="listdocs" />',"toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
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
                        $("#attachInfo").html("<font color='white'> <fmt:message key="filesuploaded" />    </font>");
                    },
                    complete: function (response)
                    {
                     
                        location.reload();
                    },
                    error: function ()
                    {
                        $("#attachInfo").html("<font color='red'> <fmt:message key="filesnotuploaded" />  </font>");
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
            function openGallaryDialog(projectId) {
                var url = '<%=context%>/UnitDocReaderServlet?op=viewBuildingMapPosition&projectId=' + projectId + '';
                var wind = window.open(url, '<fmt:message key="showmap" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
        </script>
        <style type="text/css">
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
                text-height: 30px;


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
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2Y5ZmNmNyIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNmNWY5ZjAiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
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
    </HEAD>
    <body>
        <fieldset align=center class="set" style="width: 65%; border-color: #006699;">
            <legend align="center">
                    <font color="#005599" size="5">
                            <fmt:message key="showbulidings" />
                            </font>
                        
            </legend>
            <br>
            <center> <b> <font size="3" color="red"> <%=buildingsNo%> : <%=buildingsList.size()%> </font></b></center> 
            <br>
            <%
                if (status != null) {
            %>
            <table width="50%" align="center">
                <tr>
                    <%
                        if (status.equalsIgnoreCase("ok")) {
                    %>
                    <td class="bar">
                        <b><font color="blue" size="3"><%=sSccess%></font></b>
                    </td>
                    <%
                    } else {
                    %>
                    <td class="bar">
                        <b><font color="red" size="3"><%=sFail%></font></b>
                    </td>
                    <%
                        }
                    %>
                </tr>
            </table>
            <br>
            <%
                }
            %>
            <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="center" dir=<fmt:message key="direction"/> id="buildings" style="width:100%;">
                    <thead>
                        <TR>
                            <Th>
                                <B>&nbsp;</B>
                            </Th>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>                
                            <Th>
                                <B><%=buildingListTitles[i]%></B>
                            </Th>
                            <%
                                }
                            %>
                            <Th>
                                <B>&nbsp;</B>
                            </Th>
                        </TR>
                    </thead>
                    <tbody>
                        <%
                            Enumeration e = buildingsList.elements();
                            while (e.hasMoreElements()) {
                                wbo = (WebBusinessObject) e.nextElement();
                        %>
                        <TR>
                            <TD style="cursor: pointer" nowrap>
                                <DIV>
                                    <img onclick="JavaScript: popupAttach(this, '<%=wbo.getAttribute("projectID")%>');"
                                         width="19px" height="19px" src="images/icons/Attach.png" title='<fmt:message key="attach" />'
                                         alt='<fmt:message key="attach" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("projectID")%>');"
                                         width="19px" height="19px" src="images/unit_doc.png" title='<fmt:message key="showbuildingfiles" />' 
                                         alt='<fmt:message key="showbuildingfiles" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img value="" onclick="JavaScript: viewDocuments('<%=wbo.getAttribute("mainProjId")%>');"
                                         width="19px" height="19px" src="images/compound.png" title='<fmt:message key="showcompoundfiles" />'
                                         alt='<fmt:message key="showcompoundfiles" />' style="margin: -4px 0; cursor: pointer;"/>
                                    &nbsp;
                                    <img value="" onclick="JavaScript: viewGallery('<%=wbo.getAttribute("projectID")%>', '<%=wbo.getAttribute("mainProjId")%>');"
                                         width="25px" height="25px" src="images/gallery.png" title='<fmt:message key="showimages" />' alt='<fmt:message key="showimages" />'
                                         style="margin: -4px 0; cursor: pointer;"/>
                                </DIV>
                            </TD>
                            <%                                for (int i = 0; i < s; i++) {
                                    attName = buildingAttributes[i];
                                    attValue = (String) wbo.getAttribute(attName);
                            %>
                            <TD>
                                <DIV>
                                    <b><a href="#" onclick="JavaScript:showUnitsList('<%=wbo.getAttribute("projectID")%>');"><%=attValue%></a></b>
                                </DIV>
                            </TD>
                            <TD>
                                <DIV>
                                    <b><a href="<%=context%>/UnitDocReaderServlet?op=viewBuildingDetails&buildingID=<%=wbo.getAttribute("projectID")%>"><%=buildingListTitles[1]%></a></b>
                                </DIV>
                            </TD>
                            <TD>
                                <DIV>
                                    <b><a href="<%=context%>/ProjectServlet?op=getUnitsModelsForm&buildingId=<%=wbo.getAttribute("projectID")%>"><%=unitsModels%></a></b>
                                </DIV>
                            </TD>
                            <%
                                }
                            %>
                            <TD>
                                <DIV>
                                    <b><a href="<%=context%>/UnitServlet?op=getUnitPriceForm&buildingId=<%=wbo.getAttribute("projectID")%>"><%=pricingUnits%></a></b>
                                </DIV>
                            </TD>
                            <TD>
                                <DIV ID="links">
                                    <%if (metaMgr.canDelete()) {%>
                                    <A HREF="<%=context%>/ProjectServlet?op=ConfirmDeleteBuilding&buildingId=<%=wbo.getAttribute("projectID")%>&buildingName=<%=wbo.getAttribute("projectName")%>">
                                        <%= buildingListTitles[4]%>
                                    </A>
                                    <%} else {%>
                                    ---
                                    <%}%>
                                </DIV>
                            </TD>
                            <td>
                                <DIV ID="links" onclick="">
                                    <a href="#" onclick="showAddModel('<%=wbo.getAttribute("projectID")%>')"> <fmt:message key="addmodel" />    </a>
                                </DIV>
                            </td>
                            <td nowrap>
                                <a href="#" onclick="getDataInPopup('<%=context%>/UnitDocWriterServlet?op=attachMapPosition&projId=<%=wbo.getAttribute("projectID")%>');">
                                    <image src="images/position.png" style="height: 23px;" title='<fmt:message key="addloc" /> '/>
                                </a>
                                <a href="#" onclick="openGallaryDialog('<%=wbo.getAttribute("projectID")%>')">
                                   <image src="images/master_plan.png" style="height: 25px;" title='<fmt:message key="showlocs" /> ' />
                                </a>
                            </td>
                        </TR>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <div id="units_list" style="width: 800px !important;display: none; z-index: 10000; top: 50px; left: 350px; position: fixed;"></div>
            <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

            </div>
            <div id="add_ModelDiv"  style="width: 300px;display: none;position: fixed;margin-left: auto;margin-right: auto; z-index: 1000;">

                <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 20px;
                         -moz-border-radius: 20px;
                         border-radius: 20px;" onclick="closePopup('add_ModelDiv')"/>
                </div>

                <!--<h1>رسالة قصيرة</h1>-->
                <div class="login" style="width: 90%;text-align: center">
                    <table>
                        <tr>
                            <td style="border: none">
                                <fmt:message key="modelname"/> 

                            </td>
                            <td style="border: none">
                                <input id="modelName" name="modelName" type="text" style="text-align: right"/>
                                <input type="hidden" id="projectCode" name="projectCode" />
                            </td>
                        </tr>

                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="status"></div>

                    <div id="message" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <INPUT  type="button" id="saveModel" onclick="addModel()" value=<fmt:message key="save"/> />


                </div>

            </div>
        </fieldset>          
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
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable>
                            <fmt:message key="attach"/></lable>
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
                    <input type="submit" value=<fmt:message key="upload" />  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendFilesByAjax(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
         
    </body>
</html>
