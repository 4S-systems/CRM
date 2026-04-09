<%@page import="com.tracker.db_access.DepartmentMgr"%>
<%@page import="com.maintenance.db_access.EmployeeTypeMgr"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.maintenance.db_access.TradeMgr"%>
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
        String stat = (String) request.getSession().getAttribute("currentMode");
        ArrayList<WebBusinessObject> profileList = (ArrayList<WebBusinessObject>) request.getAttribute("profileList");
        WebBusinessObject EmployeeWbo = (WebBusinessObject) request.getAttribute("EmployeeWbo");
        DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
        ArrayList<WebBusinessObject> arrayList = new ArrayList();
        departmentMgr.cashData();
        arrayList = departmentMgr.getCashedTableAsArrayList();
        String dir, saveFailMsg, sTitle, saveSuccessMsg;
        if (stat.equals("En")) {
            dir = "LTR";
            sTitle = "Employee's Details";
        } else {
            dir = "RTL";
            sTitle = "تفاصيل موظف";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/silkworm_validate.js" type="text/javascript"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/validator.js" TYPE="text/javascript" />
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript">
            function cancelForm() {
                try {
                    opener.getClientInfo('');
                }
                catch (err) {
                }
                self.close();
            }

            function showAddProfile()
            {
                $('#add_profile').css("display", "block");
                $('#add_profile').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }
        </script>
        <style>
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }
            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }
            tr:nth-child(even) td.dataTD {
                background: #FFF
            }
            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
            }
            .closeBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close2.png);
            }
            #moMsg,#telMsg,#naMsg,#mailMsg{
                font-size: 14px;
                display: none;
                color: red;
                margin: 0px;
            }
            div.ui-datepicker{
                font-size:10px;
            }
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
        </style>
    </head>
    <BODY>
        <div id="add_profile"  style="width: 80% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 100%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <form id="education_form">
                    <table  border="0px"  style="width:100%;"  class="table">
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                القسم
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <SELECT name="departmentName" ID="departmentName" style="width:230px">
                                    <option value="1">المشتريات </option>
                                    <option value="1">خدمة العملاء </option>
                                    <option value="1">المبيعات </option>
                                </SELECT>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                عدد الاجازات السنوية
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <input  type="number" style="width:40%;" name="empNO" ID="empNO" size="33"  maxlength="10" class="empNumber" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                عدد الاذونات الشهرية
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <input  type="number" style="width:40%;" name="empNO" ID="empNO" size="33"  maxlength="10" class="empNumber" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                عدد ساعات العمل
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <input  type="number" style="width:40%;" name="empNO" ID="empNO" size="33"  maxlength="10" class="empNumber" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                                المرتب
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <input  type="number" style="width:40%;" name="empNO" ID="empNO" size="33"  maxlength="10" class="empNumber" />
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="submit" value="حفظ" id="addPhone" class="login-submit"/>
                    </div>                           
                </form>
            </div>
        </div>
        <form name="CLIENT_UPDATE" action="" METHOD="POST">
            <center>
                <input type="button" onclick="JavaScript:cancelForm()" class="closeBtn" style="margin-right: 2px;"></button>
            </center>
            <fieldset class="set" align="center" width="100%" style="width: 95%;margin-bottom: 10px;">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <table  border="0px" dir="<%=dir%>" class="table" style="width:90%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                    <tr>
                        <td class="td titleTD" style="width: 50%; padding-left: 20px;">
                            السجل الوظيفي
                            <img src="images/icons/eHR.gif" style="width: 30px;float: left; cursor: pointer;"
                                 onclick="JavaScript: showAddProfile();"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="td" style="vertical-align: top;">
                            <table width="100%">
                                <%
                                    if (profileList != null && profileList.size() > 0) {
                                        for (WebBusinessObject email : profileList) {
                                %>
                                <tr>
                                    <td class="td dataTD" style="padding-left: 17px;">
                                        <%=email.getAttribute("communicationValue")%>
                                        <img src="images/icons/remove.png" style="width: 30px;float: left; cursor: pointer;"
                                             onclick="JavaScript: removeEmail('<%=email.getAttribute("id")%>')"/>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td class="td dataTD">
                                        لا يوجد بيانات
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </td>       
                    </tr>
                </table>
            </fieldset>
        </form>
    </BODY>
</html>