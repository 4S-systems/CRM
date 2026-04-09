<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String projectAccId = (String) request.getAttribute("projectAccId");
        String projectName = (String) request.getAttribute("projectName");
        WebBusinessObject projectWbo = (WebBusinessObject) request.getAttribute("projectWbo");
        String addEntity = (String) request.getAttribute("addEntity");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style,instalments,Name,update, mPrice, garageNum, lockerNum, entityType, price, area, garage, locker, add, 
                delete, projectDesc;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            Name="Project Name";
            instalments="instalments number";
            mPrice = " Meter Price ";
            garageNum = " Garages Number ";
            lockerNum = " Lockers Number";
            entityType = " Entity Type ";
            price = " Price ";
            area = " Area ";
            garage = " Garage ";
            locker = " Locker ";
            add = " Add ";
            update="Update";
            delete = " Delete ";
            projectDesc = "Project Desc.";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            instalments="عدد الوحدات";
            Name="أسم المشروع";
            mPrice = " سعر المتر";
            garageNum = " عدد الجراجات";
            lockerNum = " عدد وحدات التخزين ";
            entityType = " نوع الوحدة ";
            price = " السعر ";
            area = " المساحة ";
            garage = " جراچ ";
            locker = " وحدة تخزين ";
            add = " إضافة ";
            update="تحديث";
            delete = " حذف ";
            projectDesc = "وصف المشروع";
        }
        
        ArrayList<WebBusinessObject> entityLst = (ArrayList<WebBusinessObject>) request.getAttribute("entityLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("entityLst") : null;
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        
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
            
            #products{
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }
            
            #products tr{
                padding: 5px;
            }
            
            #products td{  
                font-size: 12px;
                font-weight: bold;
            }
            
            #products select{                
                font-size: 12px;
                font-weight: bold;
            }
        </style>
        
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function(){
                $('#entities').DataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });
            
            function updateProjectAccount(projectAccId, projectID) {
                var instaments = document.getElementById('instalmentsNumber').value;
                var mPriceJS = $('#meterPrice').val();
                var garageNumJS = $('#garageNum').val();
                var lockerNumJS = $('#lockerNum').val();
                var projectDesc = $('#projectDesc').val();
                if(instaments == ""){
                    instaments = "0";
                }
                
                if(mPriceJS == ""){
                    mPriceJS = "0";
                }
                
                if(garageNumJS == ""){
                    garageNumJS = "0";
                }
                
                if(lockerNumJS == ""){
                    lockerNumJS = "0";
                }
                
                $.ajax({
                    type: 'post',
                    url: "<%=context%>/ProjectServlet?op=updateProjectAccPopup",
                    data: {
                        projectAccId:projectAccId,
                        maxInstaments:instaments,
                        mPrice:mPriceJS,
                        garageNum:garageNumJS,
                        lockerNum:lockerNumJS,
                        projectID: projectID,
                        projectDesc: projectDesc
                    }, success: function(jsonString) {
                        alert("Project Account Upadted");
                        var info = $.parseJSON(jsonString);
                        if(instaments != "0"){
                            document.getElementById("maxInstamnts"+info.projectAccId).innerHTML = instaments;
                        }
                        
                        if(mPriceJS != "0"){
                           document.getElementById("mPrice"+info.projectAccId).innerHTML = mPriceJS;
                        }
                        
                        if(garageNumJS != "0"){
                            document.getElementById("garageNum"+info.projectAccId).innerHTML = garageNumJS;
                        }
                        
                        if(lockerNumJS != "0"){
                            document.getElementById("lockerNum"+info.projectAccId).innerHTML = lockerNumJS;
                        }
                        
                        $("#project_engineers").hide();
                        $('#overlay').hide();
                    }
                });
                
                return false;
            }
            
            function addProjectEntity(projectAccId, processType){
                var entityType = $('#entityType').val();
                var entityPrice = $('#entityPrice').val();
                var entityArea = $('#entityArea').val();
                
                if(entityPrice == ""){
                    entityPrice = "0";
                }
                
                if(entityArea == ""){
                    entityArea = "0";
                }
                
                var alertStr;
                if(processType == "add"){
                    alertStr = " Entity Has Been Added ";
                } else if (processType == "delete"){
                    alertStr = " Entity Has Been Deleted ";
                }
                
                $.ajax({
                    type: 'post',
                    url: "<%=context%>/ProjectServlet?op=updateProjectEntity",
                    data:{
                        processType:processType,
                        projectAccId:projectAccId,
                        entityType:entityType,
                        entityPrice:entityPrice,
                        entityArea:entityArea
                    }, success: function(jsonString) {
                       alert( alertStr );
                        var info = $.parseJSON(jsonString);
                        $("#project_engineers").hide();
                        $('#overlay').hide();
                    }, error: function() { 
                        alert(" Error Occure ");
                    }
                });
                
                return false;
            }
            
            function openUpdateProjectEntity(entityID){
                if($("#updateIcon" + entityID).attr("src") == "images/icons/edit.png"){
                    $("#entityAreaDiv" + entityID).hide();
                    $("#entityPriceDiv" + entityID).hide();
                    $("#updateIcon" + entityID).attr("src", "images/icons/accept.png")
                    $("#entityAreaView" + entityID).fadeIn();
                    $("#entityPriceView" + entityID).fadeIn();
                } else if($("#updateIcon" + entityID).attr("src") == "images/icons/accept.png"){
                    $("#updateIcon" + entityID).attr("src", "images/icons/edit.png")
                    $.ajax({
                        type: 'post',
                        url: "<%=context%>/ProjectServlet?op=updateProjectEntity",
                        data:{
                            processType:"update",
                            projectAccId:entityID,
                            entityPrice:$("#entityPriceView" + entityID).val(),
                            entityArea:$("#entityAreaView" + entityID).val()
                        }, success: function(jsonString) {
                            alert("Project Entity Upadted");
                            $("#project_engineers").hide();
                            $('#overlay').hide();
                        }
                    });
                }
            }
            
            function openAdd(){
                $("#entitiesDiv").hide();
                $("#projectEntityDiv").fadeIn();
            }
        </SCRIPT>
    </head>
                        
    <BODY>
        <div style="clear: both;margin-left: 95%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup('project_engineers')"/>
        </div>
        
        <div class="login" style="width: 95%;">
            <input type="hidden" id="siteAll" value="no" name="siteAll"/>
            
            <input type="hidden" name="projectID" value="<%=projectAccId%>"/>
            
            <div>
                <img src="images/icons/add_item.png" width="30" style="float: left;" title=" Add Entity " onclick="openAdd();"/>
            </div>
            
            <%
                if(addEntity != null && addEntity.equals("yes")) {
                    if(entityLst != null) { 
            %>
                        <div id="entitiesDiv" style="width: 95%; margin-left:auto; margin-right:auto;" >
                            <table id="entities" align="<%=align%>" width="100%" dir="<%=dir%>" cellpadding="0" cellspacing="0" >
                                <thead>
                                    <tr>
                                        <th></th>

                                        <th>
                                            <b>
                                                <%=entityType%>
                                            </b>
                                        </th>

                                        <th>
                                            <b>
                                                <%=area%>
                                            </b>
                                        </th>

                                        <th>
                                            <b>
                                                <%=price%>
                                            </b>
                                        </th>

                                        <th>
                                            <b>
                                                <%=update%>
                                            </b>
                                        </th>

                                        <th>
                                            <b>
                                                <%=delete%>
                                            </b>
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <% 
                                        for (WebBusinessObject entityWbo : entityLst) {
                                    %>
                                            <tr>
                                                <td>
                                                    <div>
                                                        <b>
                                                            <input type="hidden" id="entityID" value="<%=entityWbo.getAttribute("entityID")%>">
                                                        </b>
                                                    </div>
                                                </td>

                                                <td>
                                                    <div>
                                                        <b>
                                                            <%=entityWbo.getAttribute("entity")%>
                                                        </b>
                                                    </div>
                                                </td>

                                                <td>
                                                    <div>
                                                        <b>
                                                            <div id="entityAreaDiv<%=entityWbo.getAttribute("entityID")%>">
                                                                <%=entityWbo.getAttribute("area")%>
                                                            </div>
                                                            <input type="number" id="entityAreaView<%=entityWbo.getAttribute("entityID")%>" min="0" style="display: none; border: none; text-align: center;" value="<%=entityWbo.getAttribute("area")%>">
                                                        </b>
                                                    </div>
                                                </td>

                                                <td>
                                                    <div>
                                                        <b>
                                                            <div id="entityPriceDiv<%=entityWbo.getAttribute("entityID")%>">
                                                                <%=entityWbo.getAttribute("price")%>
                                                            </div>
                                                            <input type="number" id="entityPriceView<%=entityWbo.getAttribute("entityID")%>" min="0" style="display: none; border: none; text-align: center;" value="<%=entityWbo.getAttribute("price")%>" >
                                                        </b>
                                                    </div>
                                                </td>

                                                <td>
                                                    <div align="center" style="width: 100%;">
                                                        <img id="updateIcon<%=entityWbo.getAttribute("entityID")%>" src="images/icons/edit.png" width="19" height="19" style="cursor: hand; vertical-align: middle;" onclick="openUpdateProjectEntity('<%=entityWbo.getAttribute("entityID")%>')" />
                                                    </div>
                                                </td>

                                                <td>
                                                    <div align="center" style="width: 100%;">
                                                        <img id="deleteIcon<%=entityWbo.getAttribute("entityID")%>" src="images/icons/clear.png" width="19" height="19" style="cursor: hand; vertical-align: middle;" onclick="addProjectEntity('<%=entityWbo.getAttribute("entityID")%>', 'delete')" />
                                                    </div>
                                                </td>
                                            </tr>
                                    <%  } %>
                                </tbody>
                            </table>
                        </div>
                <%  }%>
            
                    <div id="projectEntityDiv" style="display: none;">
                        <TABLE id="projectEntity" style="width:95%;" align="center"  DIR="<%=dir%>">
                            <tr>
                                <TD nowrap STYLE="width: 50%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                    <%=Name%>
                                </TD>

                                <TD nowrap STYLE="width: 20%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                    <%=entityType%>
                                </TD>

                                <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                    <%=price%>
                                </TD>

                                <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                    <%=area%>
                                </TD>

                                <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                    &nbsp;
                                </TD>
                            </tr>

                            <tr>
                                <TD nowrap STYLE="width: 50%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                    <%=projectName%>
                                </TD>

                                <TD nowrap STYLE="width: 20%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                    <select id="entityType" style="width: 95%; font-size: 15px;">
                                        <option value="garage"> <%=garage%> </option>
                                        <option value="locker"> <%=locker%> </option>
                                    </select>
                                </TD>

                                <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                    <input type="number" id="entityPrice" min="0"/>
                                </TD>

                                <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                    <input type="number" id="entityArea" min="0"/>
                                </TD>

                                <TD nowrap STYLE="width: 10%;<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                    <button class="button" style="width: 100%;" name="addEntity" onclick="addProjectEntity('<%=projectAccId%>', 'add')"> <%=add%> </button>
                                </TD>
                            </tr>
                        </TABLE> 
                    </div>
            <% 
                } else { 
            %>
                    <TABLE  id="projectAccount" style="width:100%;" STYLE="border:none;" align="center"  DIR="<%=dir%>">
                        <tr>
                            <TD nowrap STYLE="width: 50%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                <%=Name%>
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                <%=instalments%>
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                <%=mPrice%>
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                <%=garageNum%>
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                <%=lockerNum%>
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                &nbsp;
                            </TD>
                        </tr>

                        <tr>
                            <TD nowrap STYLE="width: 50%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                <%=projectName%>
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                <input type="number" id="instalmentsNumber" min="0"/>
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                <input type="number" id="meterPrice" min="0" />
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                <input type="number" id="garageNum" min="0"/>
                            </TD>
                            <TD nowrap STYLE="width: 10%; <%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                <input type="number" id="lockerNum" min="0"/>
                            </TD>
                            <TD nowrap rowspan="2" STYLE="width: 10%;<%=style%>;padding:3px;background-image: url('images/gradient.gif'); background-size: 100% 100%;">
                                <button name="Save" onclick="updateProjectAccount('<%=projectAccId%>', '<%=projectWbo != null ? projectWbo.getAttribute("projectID") : ""%>')"><%=update%></button>
                            </TD>
                        </tr>
                        <tr>
                            <td nowrap style="<%=style%>;padding: 3px; background-image: url('images/gradient.gif'); background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                <%=projectDesc%>
                            </td>

                            <td colspan="4" nowrap style="<%=style%>;padding: 3px; background-image: url('images/gradient.gif'); background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                <textarea name="projectDesc" id="projectDesc" style="width: 100%;"><%=projectWbo != null ? projectWbo.getAttribute("projectDesc") : ""%></textarea>
                            </td>
                        </tr>
                    </TABLE> 
            <% } %>
        </div>
    </BODY>
</html>