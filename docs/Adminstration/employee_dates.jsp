<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
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
        ArrayList<WebBusinessObject> datesList = (ArrayList<WebBusinessObject>) request.getAttribute("datesList");
        LiteWebBusinessObject EmployeeWbo = (LiteWebBusinessObject) request.getAttribute("EmployeeWbo");
        ArrayList<WebBusinessObject> educaionTypes = EmployeeTypeMgr.getInstance().getOnArbitraryKey2("2", "key3");
        
        String newDate = "";
        
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
            $(function () {
                $("#newDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            
            function cancelForm() {
                try {
                    opener.getClientInfo('');
                }
                catch (err) {
                }
                self.close();
            }
            
            function showAddDate()
            {
                $('#add_education').css("display", "block");
                $('#add_education').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
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
        <div id="add_education"  style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
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
                                التاريخ
                            </td>
                            <td style="width: 80%; text-align: right;" colspan="3">
                                <input style=" width: 230px;" type="TEXT" dir="LTR" name="newDate" ID="newDate" size="32" value="<%=newDate%>" readonly />
                                <SELECT name="educaionTypes" id="educaionTypes" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">
                                    <%  if (educaionTypes != null && !educaionTypes.isEmpty()) {%>
                                    <OPTION value="000">---إختر---</OPTION>
                                        <%

                                            for (WebBusinessObject wbo2 : educaionTypes) {%>
                                    <OPTION value="<%=wbo2.getAttribute("id")%>"><%=wbo2.getAttribute("arTitle")%></OPTION>

                                    <%
                                            }

                                        }
                                    %>
                                </SELECT>
                                <input type="hidden" value="phone" name="type"/>
                                <input type="hidden" value="<%=EmployeeWbo.getAttribute("empId")%>" name="empId"/>
                                <input type="hidden" value="addClientCommunication" name="op"/>
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
                            التاريخ
                            <img src="images/icons/add_event2.png" style="width: 30px;float: left; cursor: pointer;"
                                 onclick="JavaScript: showAddDate();"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="td" style="vertical-align: top;">
                            <table width="100%">
                                <%
                                    if (datesList != null && datesList.size() > 0) {
                                        for (WebBusinessObject email : datesList) {
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