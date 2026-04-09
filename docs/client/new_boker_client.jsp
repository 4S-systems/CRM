<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();

    String projectId = (String) request.getAttribute("projectID");
    String ownerId = (String) request.getAttribute("ownerID");
    String unitName = (String) request.getAttribute("unitName");

    WebBusinessObject wbo = new WebBusinessObject();
    wbo = (WebBusinessObject) request.getAttribute("wbo");

    String context = metaMgr.getContext();
    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir, style, title, clientName, clientTel, add, update;

    if (stat.equals("En")) {
        dir = "LTR";
        style = "text-align:left";
        title = "Owner";
        clientName = "Owner Name";
        clientTel = "Owner Mobile";
        add = "Submit";
        update = "Update";
    } else {
        dir = "RTL";
        style = "text-align:Right";
        title = "مالك";
        clientName = "اسم المالك";
        clientTel = "تليفون المالك";
        add = "اضافه";
        update = "تعديل";
    }
%>
<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <SCRIPT  TYPE="text/javascript">

            $(document).ready(function () {
                var fff = $("#ownerID").val()

                if (fff != " " && fff != "" && fff != null && fff != "null") {
                    console.log("gfhfg" + fff);
                    $("#ClientName").attr("readonly", true);
                    $("#ClientTel").attr("readonly", true);
                }
            });

            function enableEdit() {
                console.log("jhhjggf");
                $("#ClientName").attr("readonly", false);
                $("#ClientTel").attr("readonly", false);
            }

            function submitFormAdd()
            {
                var ClientName = $('#ClientName').val();
                var projectId = <%=projectId%>;
                var ClientTel = $('#ClientTel').val();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveClientBoker",
                    data: {
                        projectId: projectId,
                        ClientName: ClientName,
                        ClientTel: ClientTel
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.Status === 'Ok') {
                            $('#msg').text("تم التسجيل بنجاح");
                        } else if (info.Status === 'No') {
                            $('#msg').text("لم يتم التسجيل");
                        } else if (info.Status === 'dublicate') {
                            $('#msg').text("لم يتم التسجيل لان الاسم او رقم التليفون مكرر");
                        }
                    }
                });
            }

            function checkClientMobile(key) {
                var clientMob = $("#ClientTel").val();
                var clientMobH = $("#ClientTelH").val();

                if (clientMob.length > 0) {
                    if (clientMob === clientMobH) {
                        if (key == "add") {
                            submitFormAdd();
                            location.reload();
                        } else {
                            submitFormUpdate();
                            
                        }
                    } else {
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/ClientServlet?op=getClientMobile",
                            data: {
                                mobile: clientMob
                            },
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'No') {
                                    if (key == "add") {
                                        submitFormAdd();
                                    } else {
                                        submitFormUpdate();
                                    }
                                } else if (info.status == 'Ok') {
                                    $('#msg').text("لم يتم التسجيل لان الرقم مكرر");

                                }
                            }
                        });
                    } 
                    }
                }
                
            

            function submitFormUpdate()
            {
                var ClientName = $('#ClientName').val();
                var projectId = <%=projectId%>;
                var ownerId = <%=ownerId%>;
                var ClientTel = $('#ClientTel').val();

                var url = "<%=context%>/ClientServlet?op=updateClientBoker";
                $.ajax({
                    type: "post",
                    url: url,
                    data: {
                        ClientName: ClientName,
                        ClientTel: ClientTel,
                        ownerId: ownerId,
                        projectId: projectId
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.Status === 'Ok') {
                            $('#msg').text("تم التعديل بنجاح");
                        } else if (info.Status === 'No') {
                            $('#msg').text("لم يتم التعديل");
                        } else if (info.Status === 'dublicate') {
                            $('#msg').text("لم يتم التعديل لان الاسم او رقم التليفون مكرر");
                        }
                        location.reload();
                    }
                });
            }

            function isNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    alert("أرقام فقط");
                    return false;
                }
                return true;
            }

            function check(key) {
                var clientName = $("#ClientName").val();
                var clientNameH = $("#ClientNameH").val();
                console.log(clientNameH);

                if (clientName.length > 0) {
                    if (clientName === clientNameH) {
                        checkClientMobile(key);
                    } else {
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/ClientServlet?op=getClientName",
                            data: {
                                clientName: clientName
                            },
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);

                                if (info.status == 'No') {
                                    checkClientMobile(key);
                                } else if (info.status == 'Ok') {
                                    $('#msg').text("لم يتم التسجيل لان الاسم مكرر");
                                }
                            }
                        });
                    }
                        
                }
            }
        </script>
    </head>

    <body>
        <form NAME="Boker_Client_FORM" METHOD="POST">
            <fieldset class="set" style="width:50%;border-color: #006699;height: 50%">
                <b style="color: green;font-size: 18px; "id="msg"></b>
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center; width: 100%">
                            <font color="#005599" size="5"><%=title%> for (<%=unitName%>)</font>
                        </td>
                    </tr>
                </table>
                <div style="height:10%">

                </div> 
                <table align="center" width="70%" height="17%" cellpadding="0" cellspacing="0" style="<%=style%>" dir="<%=dir%>">
                    <tr dir="<%=dir%>">
                        <TD class="blueHeaderTD" style="width:35%; font-size: 18px; border: none; padding: 10px;border-radius: 5px; margin: 10px">
                            <b>
                                <font size="3" color="white">
                                <%=clientName%>
                                </font>
                            </b>
                        </TD>
                        <td style="text-align:left;border: none; padding-left:17px">
                            <%if (wbo.getAttribute("name") != null && !wbo.getAttribute("name").equals("null")) {%>
                            <input type="TEXT" style="width:80%;border: 3px solid silver;border-radius: 5px;height: 100%" name="ClientName" ID="ClientName" size="250" value="<%=wbo.getAttribute("name")%>" maxlength="250">
                            <input type="hidden" style="width:80%;border: 3px solid silver;border-radius: 5px;height: 100%" name="ClientNameH" ID="ClientNameH" size="250" value="<%=wbo.getAttribute("name")%>" maxlength="250">
                            <%} else {%> 
                            <input type="TEXT" style="width:80%;border: 3px solid silver;border-radius: 5px;height: 100%" name="ClientName" ID="ClientName" size="250" value="" maxlength="250">
                            <%}%>
                        </td>
                    </tr>
                </table>       
                <div style="height:10%">

                </div>  
                <table align="center" width="70%" height="17%" cellpadding="0" cellspacing="0" style="<%=style%>" dir="<%=dir%>">
                    <tr dir="<%=dir%>">
                        <TD class="blueHeaderTD" style="width:35%; font-size: 18px; border: none; padding: 10px;border-radius: 5px; margin: 10px">
                            <b>
                                <font size="3" color="white">
                                <%=clientTel%>
                                </font>
                            </b>
                        </TD>
                        <td style="text-align:left;border: none; padding-left:15px">
                            <%if (wbo.getAttribute("mobile") != null && !wbo.getAttribute("mobile").equals("null")) {%>
                            <input type="TEXT" style="width:80%;border: 3px solid silver;border-radius: 5px;height: 100%" name="ClientTel" ID="ClientTel" size="250" value="<%=wbo.getAttribute("mobile")%>" maxlength="12" onkeypress="javascript: return isNumber(event);">
                            <input type="hidden" style="width:80%;border: 3px solid silver;border-radius: 5px;height: 100%" name="ClientTelH" ID="ClientTelH" size="250" value="<%=wbo.getAttribute("mobile")%>" maxlength="12" onkeypress="javascript: return isNumber(event);">
                            <%} else {%> 
                            <input type="TEXT" style="width:80%;border: 3px solid silver;border-radius: 5px;height: 100%" name="ClientTel" ID="ClientTel" size="250" value="" maxlength="12" onkeypress="javascript: return isNumber(event);">
                            <%}%>
                        </td>
                    </tr>
                </table>         

                <%if (ownerId != null && !ownerId.equals("null")) {%> 
                <input class="button" style="cursor: pointer;" name="edit" id="edit" type="button" value="Edit" onclick="enableEdit();">
                <input id="add" class="button" style="width:20%;margin: 10px;background-color: #9EA2C6" type="button"  value="<%=update%>" onclick="check('update');">
                <%} else {%>
                <input id="add" class="button" style="width:20%;margin: 10px;background-color: #9EA2C6" type="button"  value="<%=add%>" onclick="check('add');">                    
                <%}%>    

                <input id="ownerID" name="ownerID" type="hidden" value="<%=ownerId%>">
                <%--<img id="edit" style="height: 30px; width: 50px; cursor: pointer;display: none;" src="images/icons/edit2.jpg" onclick="enableEdit();">--%>
            </fieldset>
        </form>
    </body>
</html>
