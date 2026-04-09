<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page pageEncoding="UTF-8"%>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


//WebBusinessObject user = (WebBusinessObject) request.getAttribute("userWbo");
WebBusinessObject userEx = (WebBusinessObject) request.getAttribute("userExtWbo");

TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
String stat= (String) request.getSession().getAttribute("currentMode");
String status = (String) request.getAttribute("status");
String test = (String) request.getAttribute("test");
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status;
String sTitle,title_2;
String sUserName,sUserDesc;
String cancel_button_label;
String save_button_label, sPadding, sMenu, sSelect, sPassword, sEmail, sGroup, sTrade,project;
String isDefault,sGrantUser,filterQuery,sSelectAll,textAlign;
String sStatusMsg, fStatusMsg;
String temp1,temp2,temp3,temp4,temp5,temp6; 
String title ,Commercial_Register,Tax_Card_Number,AUTHORIZED_PERSON,COMPANY_ADDRESS,RECORD_DATE, saveButton ;
String email,phone_number;
String add_photo_checlBox;
if(stat.equals("En")){
    title="Boker Edit Information";
    saveButton="saveButton";
    Commercial_Register="Commercial Register";
    Tax_Card_Number="Tax Card Number";
    AUTHORIZED_PERSON="AUTHORIZED PERSON";
    COMPANY_ADDRESS="COMPANY ADDRESS";
    RECORD_DATE="RECORD DATE" ;
    saving_status="Saving status";
    align="center";
    sStatusMsg = "Saving Successfully";
    fStatusMsg = "Fail To Save";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    textAlign = "left";
    sUserName="Broker Name";
    sUserDesc="User Description";
    sTitle="View Existing User";
    title_2="All information are needed";
    cancel_button_label="Back To List";
    save_button_label="Save";
    langCode="Ar";
    sPadding = "left";
    sMenu = "Menu";
    sSelect = "Select";
    sPassword = "Password";
    sEmail = "Email Address";
    sGroup = "Group";
    sTrade = "Trade";
    project="Site";
    isDefault = "Is Default";
    sGrantUser = "Grants user";
    filterQuery="Search by";
    sSelectAll = "All";
    email = "Email";
    phone_number="Phone Number";
    add_photo_checlBox = "Attach Image";
}else{
   
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    saveButton= "حفظ";
    title="تعديل بيانات وسيط";
    sStatusMsg = "تم الحفظ بنجاح";
    fStatusMsg = "لم يتم الحفظ";
    Commercial_Register="السجل التجاري";
    Tax_Card_Number="رقم البطاقة الضربية";
    AUTHORIZED_PERSON="من له حق التوقيع ";
    COMPANY_ADDRESS="عنوان الشركة ";
    RECORD_DATE="تاريخ السجل التجاري " ;
     textAlign = "right";
    sUserName="اسم الوسيط";
    sUserDesc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    sTitle="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1593;&#1608;&#1583;&#1577;";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604;";
    langCode="En";
    sPadding = "right";
    sMenu = "&#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    sSelect = "&#1575;&#1582;&#1578;&#1575;&#1585;";
    sPassword = "&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
    sEmail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
    sGroup = "&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    project="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
    sGrantUser = "&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    filterQuery="&#1575;&#1604;&#1576;&#1581;&#1579; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
    sSelectAll ="&#1575;&#1604;&#1603;&#1604;";
    email = "البريد الإلكتروني";
    phone_number="رقم الموبايل";
    add_photo_checlBox = "ارفع صورة";
}
Vector userGroupVec = new Vector();
WebBusinessObject userGroupWbo = new WebBusinessObject();
List filterList=(ArrayList) request.getAttribute("filterList");
boolean viewIsDefualt = (Boolean) request.getAttribute("viewIsDefualt");
String time1=" ";
if (userEx != null  && userEx.getAttribute("RecordDate") != null  )
{
   time1= (String) userEx.getAttribute("RecordDate");
}
            
        
%>

<!DOCTYPE html>
<html>
     <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
         <link rel="stylesheet" type="text/css" href="CSS.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/w2ui/w2ui-1.5.rc1.min.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/w2ui/w2ui-1.5.rc1.min.js"></script>
        <title>mediator Edit Information</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script LANGUAGE="JavaScript" type="text/javascript">
            $(function () {
                $("#RecordDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                    
                });
            
               
            });
            
            function submitForm()
            {
              
                    document.USERS_FORM.action = "<%=context%>/UsersServlet?op=mediatorInformation";
                    document.USERS_FORM.submit();
              
           }
           function cancelForm() {
                document.USERS_FORM.action = "<%=context%>/UsersServlet?op=getBrokersList";
                document.USERS_FORM.submit();
            }
            var divAttachmentTag;
            function openAttachmentDialog(businessObjectId, objectType) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
                    data: {
                        businessObjectId: businessObjectId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "ارفاق مستندات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 480,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divAttachmentTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
            function showAttachedFiles(businessObjectId) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=viewDocuments',
                    data: {
                        businessObjectId: businessObjectId
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "مشاهدة المستندات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 700,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divAttachmentTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
            function changeImageState(checkBox) {
                if (checkBox.checked) {
                    document.getElementById("file1").disabled = false;
                    document.getElementById("imageName").value = "";
                } else {
                    document.getElementById("file1").disabled = true;
                }
            }
            
            
            function changePic(input) {
                var fileName = document.getElementById("file1").value;
                if (fileName.length > 0) {
                    if (fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1 || fileName.indexOf("GIF") > -1 || fileName.indexOf("gif") > -1 || fileName.indexOf("PNG") > -1 || fileName.indexOf("png") > -1 || fileName.indexOf("pdf") > -1 || fileName.indexOf("PDF") > -1 || fileName.indexOf("doc") > -1 || fileName.indexOf("DOC") > -1  )   {
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            $('#itemImage')
                                    .attr('src', e.target.result)
                                    .width(180)
                                    .height(220);
                        };
                        reader.readAsDataURL(input.files[0]);
                        document.getElementById("imageName").value = fileName;
                    } else {
                        alert("Invalid Image type ");
                        document.getElementById("itemImage").src = 'images/no_image.jpg';
                        document.getElementById("imageName").value = "";
                        document.getElementById("file1").select();
                    }
                } else {
                    document.getElementById("itemImage").src = 'images/no_image.jpg';
                    document.getElementById("imageName").value = "";
                }
            }
        </script>
     <style>
            .backgroundTable {
                text-align: <%=textAlign%>;
                padding-<%=textAlign%>: 15px;
                padding-bottom: 10px;
            }
            .w2ui-grid .w2ui-grid-toolbar {
                padding: 14px 5px;
                height: 150px;
            }

            .w2ui-grid .w2ui-grid-header {
                padding: 14px;
                font-size: 20px;
                height: 150px;
            }
            
            .ui-dialog-titlebar-close {
                visibility: hidden;
            }
        </style>
    </head>
    <body>
        <div name="divAttachmentTag"></div>
        <div align="left" style="color:blue;">
            <button type="button" onclick="JavaScript: submitForm();" class="button"><%=saveButton%><img height="15" src="images/save.gif" /></button>
            <button type="button" onclick="JavaScript: cancelForm();" class="button">Back<img height="15" src="images/save.gif" /></button>
        </div>
        <form name="USERS_FORM"  id="USERS_FORM" method="post" enctype="multipart/form-data" >
            <fieldset class="set" align="center">
                <legend align="center">
                   
                    <table align="<%=align%>" dir="<%=dir%>">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"><%=title%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>

                <div style="margin-left: auto; margin-right: auto; width: 1100px;">
                    <div id="toolbar" dir="<%=dir%>" style="padding: 4px; border: 1px solid #dfdfdf; border-radius: 3px; width: 1100px;">
                    </div>
                </div>

                <script type="text/javascript">
                    $(function () {
                        $('#toolbar').w2toolbar({
                            name: 'toolbar',
                            items: [
                                {
                                    type: 'html',
                                    id: 'attachFile',
                                    html: function (item) {
                                        var html = '<a href="#"><img style="height:35px;" src="images/attach.png" title="Attach File" onclick="JavaScript: openAttachmentDialog(\x27<%=userEx.getAttribute("id")%>\x27, \x27client\x27);"/></a>';
                                        return html;
                                    }
                                }, {
                                    type: 'break'
                                },
                                {
                                    type: 'html',
                                    id: 'viewFiles',
                                    html: function (item) {
                                        var html = '<a href="#"><img style="height:35px;" src="images/Foldericon.png" title="View Files" onclick="JavaScript: showAttachedFiles(\x27<%=userEx.getAttribute("id")%>\x27);"/></a>';
                                        return html;
                                    }
                                }, {
                                    type: 'break'
                                }
                            ], onClick: function (event) {}
                    });
                    });
                </script>
                 <table align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0" style="background: #f9f9f9;"
                       width="100%" id="MainTable">
                    <tr>
                        <td style="<%=style%>" class='td' width="30%">  
                                <table align="<%=align%>" dir=<%=dir%>>
                                    <tr>

                                        <td class="td">
                                            <%
                                                if (null != status) {
                                                    if (status.equalsIgnoreCase("ok")) {
                                            %>
                                            <h3>   <font color="green" size="6">  <%=sStatusMsg%> </font></h3>
                                            <br />
                                            <%} else {%>
                                            <h3> <font color="red" size="6">    <%=fStatusMsg%> </font> </h3>
                                            <br />
                                            <%}
                                                }
                                            %>               

                                        </td>
                                    </tr>
                                </table>
                <BR>
               <table  CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <tr>
                   <td class='blueBorder blueHeaderTD'>
                       <LABEL FOR="str_Function_Desc">
                         <p><b><%=sUserName%>:</b></p>
                       </LABEL>
                    </td >
                    <td class='backgroundTable'>
                     <input type="text" id="nameBroker" name="nameBroker" value="<%=userEx != null && userEx.getAttribute("englishName") != null ? userEx.getAttribute("englishName") : ""%>"/>
                     <input type='hidden' name='userId' value="<%=userEx.getAttribute("id")%>" />
                       <input type='hidden' name='nameBrokerOld' value="<%=userEx.getAttribute("englishName")%>" />
                    </td>
                </tr>
                <tr>
                    <td class='blueBorder blueHeaderTD'>
                        <p><b><%=email%>:</b><p>
                    </td>
                    <td class='backgroundTable'>
                        <input type="text" id="email" name="email" value="<%=userEx != null && userEx.getAttribute("arabicName") != null ? userEx.getAttribute("arabicName") : ""%>"/>
                    </td>
                </tr>
                <tr>
                    <td class='blueBorder blueHeaderTD'>
                         <LABEL FOR="str_Function_Desc">
                         <p><b><%=Commercial_Register%>:</b><p>
                         </label>
                    </td>
                    <td class='backgroundTable'>
                        
                        
                        <input type="TEXT" id="CommercialRegister" name="CommercialRegister" value="<%=userEx != null && userEx.getAttribute("preparation_shoulder") != null ? userEx.getAttribute("preparation_shoulder") : ""%>"/>
                    </td>
                </tr>
                <tr>
                    <td class='blueBorder blueHeaderTD'>
                         <LABEL FOR="str_Function_Desc">
                             <p><b><%=Tax_Card_Number%>:</b></p>
                         </label>
                    </td>
                    <td class='backgroundTable'>
                         
                        <input type="TEXT" id="TaxCardNumber" name="TaxCardNumber" value="<%=userEx != null && userEx.getAttribute("closur_shoulder") != null ? userEx.getAttribute("closur_shoulder") : ""%>"/>
                    </td>
                </tr>
                <tr>
                    <td class='blueBorder blueHeaderTD'>
                         <LABEL FOR="str_Function_Desc">
                             <p><b><%=RECORD_DATE%>:</b></p>
                         </label>
                    </td>
                    <td class='backgroundTable'>
                      
                       
                        
                      <input type="text"  name="RecordDate" id="RecordDate" size="33" value="<%=userEx != null && userEx.getAttribute("beginDate") != null ? ((String) userEx.getAttribute("beginDate")).substring(0, 10).replaceAll("-", "/") : ""%>" style="width: 150px;"/>
                        
                    </td>
                </tr>
                <tr>
                    <td class='blueBorder blueHeaderTD'>
                         <LABEL FOR="str_Function_Desc">
                             <p><b><%=AUTHORIZED_PERSON%>:</b></p>
                         </label>
                    </td>
                    <td class='backgroundTable'>
                       
                        <input type="TEXT" name="AuthorizedPerson" id="AuthorizedPerson" value="<%=userEx != null && userEx.getAttribute("code") != null ? userEx.getAttribute("code") : ""%>"/>
                    </td>
                </tr>
                <tr>
                    <td class='blueBorder blueHeaderTD'>
                         <LABEL FOR="str_Function_Desc">
                             <p><b><%=COMPANY_ADDRESS%>:</b></p>
                         </label>
                    </td>
                    <td class='backgroundTable'>
                       
                        <input type="TEXT" name="companyAddress" id ="companyAddress" size="35" value="<%=userEx != null && userEx.getAttribute("cost") != null ? userEx.getAttribute("cost") : ""%>"/> 
                    </td>
                </tr>
                <tr>
                    <td class='blueBorder blueHeaderTD'>
                         <LABEL FOR="str_Function_Desc">
                             <p><b><%=phone_number%>:</b></p>
                         </label>
                    </td>
                    <td class='backgroundTable'>
                       
                      <input type="text"  name="phoneNumber" id="phoneNumber" size="33" value="<%=userEx != null && userEx.getAttribute("isForever") != null ? userEx.getAttribute("isForever") : ""%>" style="width: 150px;"/>
                        
                    </td>
                </tr>
                <tr>
                    <td class='blueBorder blueHeaderTD'>
                         <LABEL FOR="str_Function_Desc">
                             <p><b>No. of Sales	:</b></p>
                         </label>
                    </td>
                    <td class='backgroundTable'>
                       
                      <input type="text"  name="noSales" id="noSales" size="33" value="<%=userEx != null && userEx.getAttribute("NOSALES") != null ? userEx.getAttribute("NOSALES") : ""%>" style="width: 150px;"/>
                        
                    </td>
                </tr>
            </table>
            </td>
              
                    </tr>
                </table>
                                     
          </fieldset>
        </form>
    </body>
</html>
