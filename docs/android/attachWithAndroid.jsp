<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
    ArrayList<LiteWebBusinessObject> devicesList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("devicesList");
    String saveVal = request.getAttribute("save") != null ? (String) request.getAttribute("save") : "";
    ArrayList<LiteWebBusinessObject> userDevicesList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("userDevicesList");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title = "", chooseUser = "", saveResultMsg = "";
    String dir, xAlign, chooseDevice, select, userName, add, macAddress, deviceID, save, delete, additionTime;
    if (stat.equals("En")) {
        title = " Attach User With Android Device ";
        chooseUser = " Choose User ";
        if (saveVal != null && saveVal.equals("1")) {
            saveResultMsg = " Record Has Been Save ";
        } else if (saveVal != null && saveVal.equals("0")) {
            saveResultMsg = " Not Saved ";
        }
        chooseDevice = " Choose Device ";
        select = " Select ";
        userName = " User Name ";
        add = " Add ";
        macAddress = " MAC Address ";
        deviceID = " Device ID ";
        save = " Save ";
        delete = " Dalete ";
        additionTime = " Addition Time ";
        dir = "ltr";
        xAlign = "right";
    } else {
        title = " ربط مستخدم بجهاز Android ";
        chooseUser = " إختر مستخدم ";
        if (saveVal != null && saveVal.equals("1")) {
            saveResultMsg = " تم الحفظ بنجاح ";
        } else if (saveVal != null && saveVal.equals("0")) {
            saveResultMsg = " لم يتم الحفظ ";
        }
        chooseDevice = " إختر جهاز ";
        select = " إختر ";
        userName = " إسم المستخدم ";
        add = " إضافة ";
        macAddress = " MAC Address ";
        deviceID = " Device ID ";
        save = " حفظ ";
        delete = " إمسح ";
        additionTime = " تاريخ الإضافة ";
        dir = "rtl";
        xAlign = "left";
    }
%>

<html>
    <head>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <style>
            .login {
                direction: rtl;
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
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 100%;
                margin-right: auto;
                text-height: 30px;
                color: black;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #223b66;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }

            .button2{
                font-size: 15px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                line-height: 20px;
                width: 150px;
                height: 30px;
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

            * > *{
                vertical-align: middle;
            } 
        </style>

        <script>
            $(document).ready(function () {
                $('#userTbl, #deviceTbl, #userDeviceTbl').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "fixedHeader": true
                }).fadeIn(2000);
            });

            function openPopup(popUpNm) {
                $("#" + popUpNm + "PopUp").bPopup();
            }

            function closePopUp(popUpNm) {
                $("#" + popUpNm + "PopUp").bPopup().close();
            }

            function addUserDevice(type) {
                var userDeviceID, userDeviceName;
                if (type === 'user') {
                    userDeviceID = $("input[name=userID]:checked").val().split(",")[0];
                    userDeviceName = $("input[name=userID]:checked").val().split(",")[1];
                    $("#userLabel").hide();
                    $("#newUserDeviceName").val(userDeviceName);
                    $("#newUserDeviceID").val(userDeviceID);
                } else if (type === 'device') {
                    userDeviceID = $("input[name=deviceID]:checked").val().split(",")[0];
                    userDeviceName = $("input[name=deviceID]:checked").val().split(",")[1];
                    $("#deviceLabel").hide();
                    $("#deviceName").val(userDeviceName);
                    $("#deviceID").val(userDeviceID);
                }
                $("#" + type + "PopUp").bPopup().close();
            }

            function save() {
                if ($('#newUserDeviceID').val() === null || $('#newUserDeviceID').val() === "") {
                    $("#userLabel").fadeIn();
                } else if ($('#deviceID').val() === null || $('#deviceID').val() === "") {
                    $("#deviceLabel").fadeIn();
                } else {
                    document.userDeviceForm.action = "<%=context%>/ProjectServlet?op=linkUserAndroidDevice&s=1&dID=" + $('#deviceID').val() + "&vID=" + $('#newUserDeviceID').val();
                    document.userDeviceForm.submit();
                }
            }

            function getLocayion(vID) {
                window.open("<%=context%>/ProjectServlet?op=getMSUWrkrLocation&vID=" + vID, "_blank");
            }
        </script>
    </head>
    <body>
        <fieldset class="set" style="width: 80%; border-color: #006699;">
            <legend>
                <font color="#005599" size="4"> <%=title%> 
            </legend>
            <label>
                <font size="4" color="<%=saveVal != null && saveVal.equals("1") ? "green" : "red"%>"/> <%=saveResultMsg%> 
            </label>
            <form name="userDeviceForm" method="POST">   
                <table style="width: 80%; direction: <%=dir%>;">
                    <tr>
                        <td class="blueHeaderTD" style="width: 42%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                            <b>
                                <font size="3" color="white">
                                <%=macAddress%> 
                                </font>
                            </b>
                        </td>
                        <td class="blueHeaderTD" style="width:42%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                            <b>
                                <font size="3" color="white">
                                <%=userName%> 
                                </font>
                            </b>
                        </td>
                        <td class="blueHeaderTD" style="width:15%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                            <b>
                                <font size="3" color="white">
                                <%=save%> 
                                </font>
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <td style="border: none; text-align: center; width: 42%;" nowrap>
                            <input id="deviceName" name="deviceName" class="set" type="text" style="width: 50%; text-align: center; font-weight: bold;" placeholder=" <%=chooseDevice%> " onchange="hidelbl('deviceLabel');" readonly>
                            <input id="deviceID" name="deviceID" type="hidden">
                            <img src="images/icons/gpsMobile.png" style="width: 30px; height: 30px;" title=" <%=select%> " onclick="openPopup('device');"/>
                            <label id="deviceLabel" style="display: none;">
                                <font color="red" size="1">  *Required  
                            </label>
                        </td>
                        <td style="border: none; text-align: center; width: 42%;" nowrap>
                            <input id="newUserDeviceName" name="newUserDeviceName" class="set" type="text" style="width: 50%; text-align: center; font-weight: bold;" placeholder=" <%=chooseUser%> " readonly>
                            <input id="newUserDeviceID" name="newUserDeviceID" type="hidden">
                            <img src="images/worker.png" style="width: 30px; height: 30px;" title=" <%=select%> " onclick="openPopup('user');"/>
                            <label id="userLabel" style="display: none;">
                                <font color="red" size="1">  *Required  
                            </label>
                        </td>
                        <td style="border: none; text-align: center; width: 15%;">
                            <img src="images/icons/message-boxs/success.png" style="width: 20px; height: 20px;" title=" <%=save%> " onclick="save();"/> 
                        </td>
                    </tr>
                </table>
                <div style="width: 80%; padding-top: 2%;">
                    <table name="userDeviceTbl" class="display" id="userDeviceTbl" width="100%" dir="<%=dir%>">
                        <thead>
                            <tr>
                                <th width="30%">
                                    <%=macAddress%>  
                                </th>
                                <th width="30%">
                                    <%=userName%>
                                </th>
                                <th width="25%">
                                    <%=additionTime%> 
                                </th>
                                <th width="15%">
                                    <%=delete%> 
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (userDevicesList != null && !userDevicesList.isEmpty()) {
                                    for (LiteWebBusinessObject msuWrkrWbo : userDevicesList) {
                            %>
                            <tr>
                                <td style=" text-align: center;">
                                    <%=msuWrkrWbo.getAttribute("macAddress")%>
                                    <img src="images/icons/place.png" style="cursor: pointer; width: 25px; height: 25px;" onclick="getLocayion('<%=msuWrkrWbo.getAttribute("vID")%>');"
                                </td>
                                <td style=" text-align: <%=dir%>;">
                                    <%=msuWrkrWbo.getAttribute("vNm") != null ? msuWrkrWbo.getAttribute("vNm") : ""%> 
                                </td>
                                <td style=" text-align: <%=dir%>;">
                                    <%=msuWrkrWbo.getAttribute("additionTime").toString().split(" ")[0]%> 
                                </td>
                                <td></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </form>
        </fieldset>
        <div id="userPopUp" style="width: 40%; display: none; position: fixed; height: auto;">
            <div style="clear: both; margin-left: 90%; margin-top: 0px;margin-bottom: -30px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); background-color: transparent;
                     -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopUp('user');"/>
            </div>
            <div class="login" style="width:80%; height: auto; margin-left: auto; margin-right: auto;">
                <h1 style="color: white;">
                    <%=chooseUser%> 
                    <img src="images/worker.png" style="width: 50px; height: 50px;"/> 
                </h1>
                <div width="80%">
                    <table name="userTbl" class="display" id="userTbl" width="100%" dir="<%=dir%>">
                        <thead>
                            <tr style="cursor: pointer;" class="odd gradeU">
                                <th width="2%">
                                </th>
                                <th width="65%">
                                    <%=userName%> 
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (usersList != null && !usersList.isEmpty()) {
                                    for (WebBusinessObject userWbo : usersList) {
                            %>
                            <tr style="cursor: pointer;">
                                <td style=" text-align: center; width: 2%;">
                                    <input type="radio" value="<%=userWbo.getAttribute("userId")%>,<%=userWbo.getAttribute("fullName")%>" name="userID" id="userID<%=userWbo.getAttribute("userId")%>">
                                </td>
                                <td style=" text-align: <%=dir%>; width: 65%;">
                                    <%=userWbo.getAttribute("fullName")%> 
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <input class="button2" type="button" name="add" onclick="addUserDevice('user');" id="add" value=" <%=add%> " style="width: 25%; float: <%=xAlign%>; text-align: center;">
                <br/>&nbsp;
            </div>
        </div>
        <div id="devicePopUp" style="width: 40%; display: none; position: fixed; height: auto;">
            <div style="clear: both; margin-left: 90%; margin-top: 0px;margin-bottom: -30px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); background-color: transparent;
                     -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopUp('device');"/>
            </div>
            <div class="login" style="width:80%; height: auto; margin-left: auto; margin-right: auto;">
                <h1 style="color: white;">
                    <%=chooseDevice%> 
                </h1>
                <div width="80%">
                    <table name="deviceTbl" class="display" id="deviceTbl" width="100%" dir="<%=dir%>">
                        <thead>
                            <tr style="cursor: pointer;" class="odd gradeU">
                                <th width="2%">
                                </th>
                                <th width="33%">
                                    <%=deviceID%> 
                                </th>
                                <th width="65%">
                                    <%=macAddress%> 
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (devicesList != null && !devicesList.isEmpty()) {
                                    for (LiteWebBusinessObject deviceWbo : devicesList) {
                            %>
                            <tr style="cursor: pointer;">
                                <td style=" text-align: center; width: 2%;">
                                    <input type="radio" value="<%=deviceWbo.getAttribute("id")%>,<%=deviceWbo.getAttribute("macAddress")%>" name="deviceID" id="deviceID<%=deviceWbo.getAttribute("id")%>">
                                </td>

                                <td style=" text-align: <%=dir%>; width:33%;">
                                    <%=deviceWbo.getAttribute("id")%> 
                                </td>

                                <td style=" text-align: <%=dir%>; width: 65%;">
                                    <%=deviceWbo.getAttribute("macAddress")%> 
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <input class="button2" type="button" name="add" onclick="addUserDevice('device');" id="add" value=" <%=add%> " style="width: 25%; float: <%=xAlign%>; text-align: center;">
                <br/>&nbsp;
            </div>
        </div>
    </body>
</html>
