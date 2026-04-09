<%@page import="com.routing.MailGroupMgr"%>
<%@page import="com.maintenance.common.Tools"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
            TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
//            Vector<WebBusinessObject> compEmps = (Vector<WebBusinessObject>) request.getAttribute("compEmps");
            MailGroupMgr mailGroupMgr= MailGroupMgr.getInstance();
            WebBusinessObject wbo = new WebBusinessObject();
            String status = (String) request.getAttribute("status");
            String mailGroupName="";
            
            if (status == null) {
                status = "";
            } else if (status.equals("ok")){
                 mailGroupName= session.getAttribute("mailGroupName").toString();
            }
            
            

            String stat = (String) request.getSession().getAttribute("currentMode");

            String align = null;
            String dir = null;
            String style = null;
            String lang, langCode;
            String fStatus, Private;
            String save, cancel,  name, divAlign,compEmpStr, site, isDefault, basicData, code, sTitle, doubleName, success;
            String sPadding, strDefault,emps,empNameShown,delete,saveToGroup,res;
            if (stat.equals("En")) {
                align = "center";
                dir = "LTR";
                divAlign = "left";
                style = "text-align:left";
                lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                code = "Code";
                sTitle = "New Mail Group";
                cancel = "Cancel";
                save = "Save";
                langCode = "Ar";
                
                compEmpStr = "Employees";
                Private = "Private";
                fStatus = "Fail To Create Group";
                site = "Branches";
                isDefault = "Is Default";
                basicData = "Basic Data";
                name = "Name";
                doubleName = "This User Name Exist";
                success = "New Mail Group has been added successfully";
                strDefault = "Default";
                sPadding = "left";
                emps="Employees";
                empNameShown="User Name";
                delete="Delete";
                saveToGroup="Add";
                res="Responsibles";
            } else {
                align = "center";
                dir = "RTL";
                divAlign = "right";
                style = "text-align:Right";
                lang = "English";
                code = "الكود";
                sTitle = "إضافة مجموعة بريد";
                cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
                save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
                langCode = "En";
                compEmpStr = "الموظفين";
                fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
                Private = "خاص";
                site = "&#1575;&#1604;&#1601;&#1585;&#1608;&#1593;";
                isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
                basicData = "&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
                name = "&#1575;&#1604;&#1571;&#1587;&#1605;";
                doubleName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1607;&#1584;&#1575; &#1605;&#1608;&#1580;&#1608;&#1583;";
                success = "تم إضافة مجموعة البريد بنجاح";
                strDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
                emps="الموظفين";
                sPadding = "right";
                empNameShown="اسم الموظف";
                delete="حذف";
                saveToGroup="إضافه";
                res="المسئولين";
            }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/validator.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    $(document).ready(function(){
        $('#checkAllGroup').click(function(){
            checkAll('Group');
        });
    });

        var users=new Array();
        var checked = false;
        function checkAll(group) {

           if (document.getElementById(group).checked == true) {
                checked = true;
            } else {
                checked = false;
            }

              var totalEmps = document.getElementById('checkGroup').value;
              for (i = 1; i <= totalEmps; i++) {
                  document.getElementById('checkGroup' + '' + i).checked = checked;
              }
        }
        
        function checkForCheckAll() {
            var count = 0;
            var length = document.getElementsByName('checkGroup').length;
            alert('length of checked items= '+length);
            for(var i = 0; i < length; i++) {
                if(document.getElementById('checkGroup'+ i).checked) {
                    count++;
                }
            }

            if(length > 0 && count == length) {
                document.getElementById('checkAllGroup').checked = true;
            } else {
                document.getElementById('checkAllGroup').checked = false;
            }
        } 
        function submitForm() {
//            alert('ay 7aga ');
            if (!validateData("req", this.MAIL_GROUP_FORM.name, "Please, enter Name ...")) {
                this.MAIL_GROUP_FORM.name.focus();
            } else if (!validateData("req", this.MAIL_GROUP_FORM.code, "Please, enter Code ...")) {
                this.MAIL_GROUP_FORM.code.focus();
//            } else if (!validateData("req", this.MAIL_GROUP_FORM.compEmps, "Please, enter Employees ...")) {
//                this.MAIL_GROUP_FORM.compEmps.focus();
            } else {
//                alert('else ');
                document.MAIL_GROUP_FORM.action = "<%=context%>/ComplaintEmployeeServlet?op=saveMailGroup";
                document.MAIL_GROUP_FORM.submit();
            }
        }
        function cancelForm() {
            document.MAIL_GROUP_FORM.action = "main.jsp";
            document.MAIL_GROUP_FORM.submit();  
        }
        
        function addEmpsToGroup(c, x) {
//                alert('entered ');
               
                var empIdArr = $('input[name=userId]');
                var empId = $(empIdArr[x-1]).val();
//                var commentsArr = $('input[name=comments]');
//                var comments = $(commentsArr[x-1]).val();
//                var responsibleArr = $('select[name=responsible]');
                
//                var responsible = $(responsibleArr[x-1]).val();
//                alert('res= '+responsible);
                $("#save" + x).html("<img src='images/icons/spinner.gif'/>");
                    
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ComplaintEmployeeServlet?op=updateComplaintEmployee",
                    data: { userId: empId},

                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);

                        if(eqpEmpInfo.status == 'Ok') {

                            $("#save" + x).html("");
                            $("#save" + x).css("background-position", "top");
                        }
                    }
                });
        }
        
       
    </SCRIPT>

    <style type="text/css">
            .remove{

                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);

            }
            #showHide{
                /*background: #0066cc;*/
                border: none;
                padding: 10px;
                font-size: 16px;
                font-weight: bold;
                color: #0066cc;
                cursor: pointer;
                padding: 5px;
            }
            #dropDown{
                position: relative;
            }
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }

            .datepick {}

            .save {
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
            .silver_odd_main,.silver_even_main {
                text-align: center;
            }
            
            input { font-size: 18px; }

    </style>
    <BODY>
        <FORM action=""  NAME="MAIL_GROUP_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 5%; padding-bottom: 10px">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="cancelForm()" class="button"><%=cancel%></button>
                &ensp;
                <button onclick="JavaScript:  submitForm();" class="button"><%=save%></button>
            </DIV>
            <center>
                <fieldset class="set" style="width:90%;border-color: #006699;">
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=sTitle%></font>
                            </td>
                        </tr>
                    </table>
                    <% if (status.equalsIgnoreCase("error")) {%>
                    <br>
                    <table align="<%=align%>" dir="<%=dir%>" WIDTH="70%">
                        <tr>
                            <td class="backgroundHeader">
                                <font size="3" color="red"><%=fStatus%></font>
                            </td>
                        </tr>
                    </table>
                    <% } else if (status.equalsIgnoreCase("ok")) {%>
                    <br>
                    <table align="<%=align%>" dir=<%=dir%> WIDTH="70%">
                        <tr>
                            <td class="backgroundHeader">
                                <font size="3" color="blue"><%=success%>: &nbsp;&nbsp;</font><FONT size="3" color="red"><%=mailGroupName%></font>
                            </td>
                        </tr>
                    </table>
                    <% }%>
                    <TABLE class="backgroundTable" width="70%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>">
                        
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=name%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="name" ID="name" size="33" value="" maxlength="255" style="color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=code%></b></p>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="code" ID="code" size="33" value="" maxlength="255" style="color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>

<!--                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=compEmpStr%></b>&nbsp;
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <select name="compEmps" id="compEmps" dir="<%=dir%>" style="color: black; font-weight: bold; font-size: 12px">
                                  
                                </select>
                            </TD>
                        </TR>-->

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=Private%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <div align="<%=divAlign%>"><input type="checkbox" name="private" ID="private" value="Yes"></div>
                            </TD>
                        </TR>
                    </TABLE>
                    <TABLE>
                        
                        <% if (status.equalsIgnoreCase("ok")){
                        %>
<!--                        <TR>
                        <TD style="<%=style%>; padding-<%=dir%>: 5px;" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <p><b> <%=emps%> <font color="#FF0000">*</font></b>
                        </TD>
                        <TD style="border: none; padding-<%=dir%>: 5px;">
                            <button id="firstEmpSearchBtn" name="Attach Emps" value="" style="text-align: center;" onclick="return getDataInPopup('ComplaintEmployeeServlet?op=listComEmps&formName=MAIL_GROUP_FORM&selectionType=multi')"/>
                                <img src="images/refresh.png" alt="" title="" align="middle" width="24" height="24"/>
                            </button>
                        </td>
                        </tr>-->
                        
                         <TR>
                        <TD style="<%=style%>; padding-<%=dir%>: 5px;" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <p><b> <%=res%> <font color="#FF0000">*</font></b>
                        </TD>
                        <TD style="border: none; padding-<%=dir%>: 5px;">
                            <button id="secondEmpSearchBtn" name="Attach Res" value="" style="text-align: center;" onclick="return getDataInPopup('ComplaintEmployeeServlet?op=listResEmps&formName=MAIL_GROUP_FORM&selectionType=multi')"/>
                                <img src="images/refresh.png" alt="" title="" align="middle" width="24" height="24"/>
                            </button>
                        </td>
                        </tr>
                        <%}%>
                        
                    </TABLE>
                    
                    <br/><br/>

                    <DIV id="tblDataDiv" style="display: block;">
                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="50%" cellpadding="0" cellspacing="0">
                            <TR>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" ><b> <%=empNameShown%> </b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=saveToGroup%></b></TD>
                                <!--<TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=delete%></b></TD>-->
                            </TR>
                        </TABLE>
                    </DIV>
                    <br/><br/>
                </fieldset>
            </center>
                            
        </FORM>
    </BODY>
</HTML>     
