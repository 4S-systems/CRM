<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
    String context = MetaDataMgr.getInstance().getContext();
    String itemCode = (String) request.getAttribute("itemCode");
    String issueId = (String) request.getAttribute("issueId");
    String quantity = (String) request.getAttribute("quantity");
    Hashtable<String, String> quatities = (Hashtable<String, String>) request.getAttribute("quatities");
    Vector<WebBusinessObject> tasks = (Vector<WebBusinessObject>) request.getAttribute("tasks");

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String dir=null;
    String lang, langCode, close, save, title;
    String divAlign;
    String quantDis, maintenanceItem, quant, spareCode;

    if(stat.equals("En")){
        divAlign = "left";
        dir="LTR";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        close = "Close";
        save = "Save";
        title = "Distribution of spare parts to Maintenance Items";
        maintenanceItem = "Maintenance Items";
        quant = "Quantity";
        quantDis = "Quantity Distribution";
        spareCode = "Parts Code";
    }else{
        divAlign = "right";
        dir="RTL";
        lang="   English    ";
        langCode="En";
        close = "&#1594;&#1604;&#1602;";
        save = "&#1581;&#1600;&#1601;&#1600;&#1592;";
        title = "&#1578;&#1608;&#1586;&#1610;&#1593; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1593;&#1604;&#1609; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        maintenanceItem = "&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        quant = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
        quantDis = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1608;&#1586;&#1593;&#1577;";
        spareCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Issue Detail</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/blueStyle.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <SCRIPT type="text/javascript" src="js/silkworm_validate.js" ></SCRIPT>
    </HEAD>

    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        var loading_image_path = "images/loading-bar.gif";
        var save_complete_image_path = "images/save_complete.png";
        var save_not_complete_image_path = "images/save_not_complete.png";
        function saveForm() {
            settingLoading();
            var q = document.getElementById("distQuantity").innerHTML;
            if(parseInt(q) > 0 && parseInt('<%=quantity%>') == parseInt(q)) {
                var quantity = "", task = "";
                var quantitys = document.getElementsByName('quantity');
                var taskIds = document.getElementsByName('taskId');
                for(var i = 0; i < quantitys.length; i++) {
                    if(quantitys[i].value != "") {
                        quantity += quantitys[i].value;
                        task += taskIds[i].value;
                        if(i < (quantitys.length - 1)) {
                            quantity += "@@";
                            task += "@@";
                        }
                    }
                }
                var url = "<%=context%>/ajaxServlet?op=saveDistributionParts&issueId=<%=issueId%>&itemCode=<%=itemCode%>&tasks=" + task + "&quantitys=" + quantity;
                if (window.XMLHttpRequest) {
                    req = new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                
                req.open("Post",url,true);
                req.onreadystatechange =  callback;
                req.send(null);
                
            } else if(parseInt(q) == 0) {
                hideImg();
                alert("Error \nMust Enter Quantity to Distribution");
            } else if(parseInt('<%=quantity%>') > parseInt(q)) {
                hideImg();
                alert("Error \nMust Distributed all Quantity \nfound quanity : " + (parseInt('<%=quantity%>') - parseInt(q)) + " not distributed");
            } else {
                hideImg();
                alert("Error \nMust Distribution Quantity (" + q + ") Less than or equal Total Quantity (" + <%=quantity%> + ") " );
            }
        }

        function settingLoading() {
            document.getElementById("loading_img").src = loading_image_path;
            document.getElementById("loading_img").style.display = "block";
            document.getElementById("btnSave").disabled = true;
            document.getElementById("status").innerHTML = "";
        }

        function settingActive(path, message) {
            document.getElementById("loading_img").src = path;
            document.getElementById("btnSave").disabled = false;
            document.getElementById("status").innerHTML = message;
        }
        
        function hideImg() {
            document.getElementById("loading_img").style.display = "none";
            document.getElementById("btnSave").disabled = false;
            document.getElementById("status").innerHTML = "";
        }

        function callback() {
            if (req.readyState==4) {
                if (req.status == 200) {
                    if(req.responseText != null && req.responseText == "ok")
                        settingActive(save_complete_image_path, "Save Complete");
                    else 
                        settingActive(save_not_complete_image_path, "Save Not Complete");
                }
             }
        }

        function isRealQuantity(index){
            initTotalQuantity();
            var quantity = document.getElementsByName("quantity")[index - 1];
            if(quantity.value == "") {
                document.getElementById("tasksTable").rows[index].className = "";
                return false;
            } else if(quantity.value == "0") {
                alert("Must Quantity Large Than Zero ...");
                quantity.focus();
                deHilightForAll(index);
                document.getElementById("tasksTable").rows[index].className = "";
                return false;
            } else if(!IsNumeric(quantity.value)) {
                alert("Must Quantity Number ...");
                quantity.focus();
                deHilightForAll(index);
                quantity.value = "";
                document.getElementById("tasksTable").rows[index].className = "";
                return false;
            }

            var intQuantity = new Number(quantity.value);
            if(intQuantity <= 0) {
                alert("Must Quantity Large Than Zero ");
                quantity.focus();
                deHilightForAll(index);
                document.getElementById("tasksTable").rows[index].className = "";
                return false;
            }

            document.getElementById("tasksTable").rows[index].className = "";
            return true;
        }

        function initTotalQuantity() {
            var total = 0;
            var quantitys = document.getElementsByName("quantity");
            for(var i = 0; i < quantitys.length; i++) {
                if(IsNumeric(quantitys[i].value) && quantitys[i].value != "") {
                    if(new Number(quantitys[i].value) != NaN) {
                        total += parseInt(quantitys[i].value);
                    }
                }
            }
            
            document.getElementById("distQuantity").innerHTML = total;
        }
        
        function deHilightForAll(index) {
            var rows = document.getElementById("tasksTable").rows;
            var length = rows.length
            for(var i = 1; i < length; i ++) {
                if(rows[i].id != index) {
                    rows[i].className = "";
                }
            }
        }
        
        function hilight(index) {
            document.getElementById("tasksTable").rows[index].className = "rowHilight";
        }
    </SCRIPT>

    <STYLE type="text/css">
        .borderBottom {
            border-bottom: black solid 2px;
            border-top: none;
            border-right: none;
            border-left: none
        }
    </STYLE>

    <BODY>
        <FORM NAME="ISSUE_DETAILS_FORM" METHOD="POST" action="">
            <DIV align="left" STYLE="color:blue;padding-left: 2.5%;padding-top: 10px;" ID="btnDiv">
                <input type="button" style="width:80px;height:30px;font-weight:bold" onclick="reloadAE('<%=langCode%>')" value="<%=lang%>" class="button">
                    &ensp;
                <input type="button" style="width:80px;height:30px;font-weight:bold"  value="<%=close%>"  onclick="window.close()" class="button">
                    &ensp;
                <input type="button" id="btnSave" style="width:80px;height:30px;font-weight:bold"  value="<%=save%>"  onclick="JavaScript: saveForm();" class="button">
            </DIV>
            <BR>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699;width: 95%;">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="CENTER" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:CENTER;border-color: #006699;" width="50%" class="blueBorder blueHeaderTD"><FONT color='#F3D596' SIZE="4"><%=title%></FONT></TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <TABLE dir="<%=dir%>" border="0" width="92%" cellpadding="0" cellspacing="5" align="CENTER">
                        <TR>
                            <TD class="backgroundHeader" style="border: none; font-size: 18px; text-align: <%=divAlign%>; padding-<%=divAlign%>: 5px; color: black; font-weight: bold; height: 25px" width="75%" >
                                <%=spareCode%>&ensp;&ensp;<font color="blue"><%=itemCode%></font>
                            </TD>
                            <TD class="backgroundHeader" style="border: none; font-size: 18px; text-align: <%=divAlign%>; padding-<%=divAlign%>: 5px; color: black; font-weight: bold; height: 25px" width="25%" >
                                <%=quant%>&ensp;&ensp;<font color="blue"><%=quantity%></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <TABLE id="tasksTable" dir="<%=dir%>" border="0" width="90%" cellpadding="0" cellspacing="0" align="CENTER">
                        <TR>
                            <TD class="borderBottom" style="text-align: <%=divAlign%>; color: black; font-weight: bold; height: 25px" width="80%" >
                                <div align="<%=divAlign%>">
                                    <p dir="rtl" align="CENTER" style="background-color: #E6E6FA;width:70%;font-weight: bold;font-size: 16px;text-align: <%=divAlign%>; padding-<%=divAlign%>: 5px"><b><%=maintenanceItem%></b></p>
                                </div>
                            </TD>
                            <TD class="borderBottom" style="text-align: <%=divAlign%>; color: black; font-weight: bold; height: 25px" width="20%" >
                                <div align="<%=divAlign%>">
                                    <p dir="rtl" align="CENTER" style="background-color: #E6E6FA;width:100%;font-weight: bold;font-size: 16px;text-align: <%=divAlign%>; padding-<%=divAlign%>: 5px"><b><%=quant%></b></p>
                                </div>
                            </TD>
                        </TR>
                        <%
                        int index = 0;
                        String itemQuantity, taskId;
                        for(WebBusinessObject task : tasks) {
                            index++;
                            taskId = (String) task.getAttribute("taskId");
                            itemQuantity = quatities.get(taskId);
                            if(itemQuantity == null) {
                                itemQuantity = "";
                            }
                        %>
                        <TR id="<%=index%>">
                            <TD class="borderBottom blueBodyTD" style="text-align: <%=divAlign%>; padding-<%=divAlign%>: 10px; color: black; font-weight: bold; height: 25px" width="80%" >
                                <%=task.getAttribute("name")%>
                                <input type="hidden" id="taskId" name="taskId" value="<%=taskId%>" />
                            </TD>
                            <TD class="borderBottom blueBodyTD" style="text-align: <%=divAlign%>; color: black; font-weight: bold; height: 25px" width="20%" >
                                <input type="text" id="quantity" name="quantity" value="<%=itemQuantity%>" onfocus="JavaScript: hilight('<%=index%>');" onblur="JavaScript: isRealQuantity('<%=index%>');" style="margin-bottom: 2px; margin-top: 2px" />
                            </TD>
                        </TR>
                        <% } %>
                        <TR>
                            <TD style="text-align: <%=divAlign%>; color: black; font-weight: bold; height: 25px" width="80%" >
                                <div align="<%=divAlign%>">
                                    <p dir="rtl" align="CENTER" style="background-color: #E6E6FA;width:70%;font-weight: bold;font-size: 16px;text-align: <%=divAlign%>; padding-<%=divAlign%>: 5px"><b><%=quantDis%></b></p>
                                </div>
                            </TD>
                            <TD class="borderBottom" style="text-align: <%=divAlign%>; color: black; font-weight: bold; height: 25px" width="20%" >
                                <div align="<%=divAlign%>">
                                    <p dir="rtl" align="CENTER" style="background-color: #E6E6FA;width:100%;font-weight: bold;font-size: 16px;text-align: <%=divAlign%>; padding-<%=divAlign%>: 5px"><font color="blue"><b id="distQuantity" >0</b></font></p>
                                </div>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <TABLE border="0" dir="ltr" align="CENTER" width="90%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD style="border: none; width: auto">
                                <img id="loading_img" src="images/loading-bar.gif" height="60" alt="loading" align="middle" style="display: none"/>
                            </TD>
                            <TD style="border: none; width: 90%">
                                <b id="status" style="font-weight: bold;font-size: 16px;text-align:left" ></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
    <!-- -->
    <SCRIPT type="text/javascript" >
        initTotalQuantity();
    </SCRIPT>
</HTML>