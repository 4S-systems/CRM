<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> mainProjects = (ArrayList<WebBusinessObject>) request.getAttribute("mainProjects");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, saveFailMsg, sTitle, saveSuccessMsg2, saveSuccessMsg;
        if (stat.equals("En")) {
            dir = "LTR";
            saveFailMsg = "Fail to Save";
            saveSuccessMsg = "Data Saved Successfully";
            saveSuccessMsg2 = "Thank You for Contacting US - A Sales Representative will Contact You as soon as Possible";
            sTitle = "Client Registration";
        } else {
            dir = "RTL";
            saveFailMsg = "لم يتم التسجيل";
            saveSuccessMsg = "Thank You for Contacting US - A Sales Representative will Contact You as soon as Possible";
            saveSuccessMsg2 = "شكرا لك على التواصل معنا - مندوب المبيعات سوف يتصل بك في أقرب وقت ممكن";
            sTitle = "&nbsp;Getting Acquainted&nbsp;";
        }
        String companyName = metaMgr.getCompanyNameForLogo();
        String logoName = "logo.png";
        if (companyName != null) {
            logoName = "logo-" + companyName + ".png";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <link rel="stylesheet" type="text/css" href="css/webStyle.css" />
        <!-- modernizr enables HTML5 elements and feature detects -->
        <script type="text/javascript" src="js/web/modernizr-1.5.min.js"></script>
        <script type="text/javascript">
            function closeForm() {
                document.CLIENT_FORM.action = "<%=context%>/main.jsp";
                document.CLIENT_FORM.submit();
            }

            function InvalidEmailMsg(textbox) {
                if (textbox.value == '') {
                    textbox.setCustomValidity('مطلوب أدخال البريد اﻷلكتروني');
                } else if (textbox.validity.typeMismatch) {
                    textbox.setCustomValidity('مطلوب أدخال بريد ألكتروني صحيح  \n ex: userid@company.com');
                } else {
                    textbox.setCustomValidity('');
                }
                return true;
            }
            function InvalidNameMsg(textbox) {
                if (textbox.value == '') {
                    textbox.setCustomValidity('Please Enter Full Name');
                } else {
                    textbox.setCustomValidity('');
                }
                return true;
            }
            function InvalidPhoneMsg(textbox) {
                if (textbox.value.length < 8 && textbox.value.length > 0) {
                    textbox.setCustomValidity('At least 8 Number are required');
                } else if (textbox.validity.badInput) {
                    textbox.setCustomValidity('Only numbers are required');
                } else {
                    textbox.setCustomValidity('');
                }
                return true;
            }
            function InvalidMobileMsg(textbox) {
                if (textbox.value.length < 11) {
                    textbox.setCustomValidity('At least 11 Number are required');
                } else {
                    textbox.setCustomValidity('');
                }
                return true;
            }
            $(function () {
                var requiredCheckboxes = $("input[name='projectId']");
                requiredCheckboxes.change(function () {
                    if (requiredCheckboxes.is(':checked')) {
                        requiredCheckboxes.removeAttr('required');
                    } else {
                        requiredCheckboxes.attr('required', 'required');
                    }
                });
            });
        </script>
        <style>
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
            .submitBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/submit.png);
            }

            .button2{
                background: khaki !important;
                font-family: "Script MT", cursive !important;
                font-size: 18px !important;
                font-style: normal !important;
                font-variant: normal !important;
                font-weight: 400 !important;
                line-height: 20px !important;
                width: 134px !important;
                height: 32px !important;
                text-decoration: none !important;
                display: inline-block !important;
                margin: 4px 2px !important;
                -webkit-transition-duration: 0.4s !important; /* Safari */
                transition-duration: 0.8s !important;
                cursor: pointer !important;
                border-radius: 12px !important;
                border: 1px solid #008CBA !important;
                padding-left:2% !important;
                text-align: center !important;
            }


            .button2:hover {
                background-color: #afdded !important;
                padding-top: 0px !important;
            }

            .button3{
                font-family: "Script MT", cursive !important;
                font-size: 20px !important;
                font-style: normal !important;
                font-variant: normal !important;
                font-weight: 600 !important;
                line-height: 20px !important;
                text-decoration: none !important;
                margin-top: 6px;
                padding-left: 22px;
            }
        </style>
    </head>
    <body dir="<%=dir%>">
        <form action="<%=context%>/FreeFormServlet?op=SaveClientData" method="post" name="CLIENT_FORM" accept-charset="ISO-8859-1">
            <fieldset class="set" align="center" style="margin: 20px 20px 20px 20px;">
                <legend align="center">
                    <font size="6">
                    <%=sTitle%>
                    </font>
                </legend>
                <%
                    if (request.getAttribute("status") != null && request.getAttribute("status").equals("ok")) {
                %>
                <div class="form_settings" style="text-align: center;float: left;display: inline-block">
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <b style="color: goldenrod; font-size: 18px;">
                        <%=saveSuccessMsg%>
                    </b>
                    <br />
                    <br />

                    <b style="color: goldenrod; font-size: 18px;">
                        <%=saveSuccessMsg2%>
                    </b>

                    <br />
                    <br />
                    <br />
                    <p style="text-align: left;">
                        <span>&nbsp;</span>
                        <a href="https://www.facebook.com/" title="Close"  onclick="window.open(this.href, '_self');" class="button2"><span class="button3">Close</span></a>
                        <br />
                        <br />
                </div>
                <%
                } else if (request.getAttribute("status") != null && request.getAttribute("status").equals("fail")) {
                %>
                <br />
                <br />
                <br />
                <b style="color: red; font-size: 18px;">
                    <%=saveFailMsg%>
                </b>
                <br />
                <br />
                <br />
                <%
                    }
                    if (request.getAttribute("status") == null || request.getAttribute("status").equals("fail")) {
                %>

                <div class="form_settings" style="float: left">
                    <p>
                        <span>Name</span>
                        <input type="text" name="clientName" value="" required
                               oninvalid="JavaScript: InvalidNameMsg(this);" oninput="JavaScript: InvalidNameMsg(this);" dir="LTR" />
                        <input name="iehack" type="hidden" value="&#9760;" />
                    </p>
                    <p>
                        <span>Mobile</span>
                        <input type="number" id="mobile" name="clientMobile" value="" required onblur="JavaScript: InvalidMobileMsg(this);"
                               onKeyPress="if (this.value.length == 11)
                                          return false;" oninvalid="JavaScript: InvalidMobileMsg(this);" dir="LTR" oninput="JavaScript: InvalidMobileMsg(this);"/>
                    </p>
                    <p>
                        <span>International</span>
                        <input type="number" id="clientPhone" name="clientPhone" dir="LTR" value="" onblur="JavaScript: InvalidPhoneMsg(this);"
                               oninvalid="JavaScript: InvalidPhoneMsg(this);" />
                    </p>
                    <p>
                        <span>Email</span>
                        <input type="email" name="email" value="" required dir="LTR"
                               oninvalid="JavaScript: InvalidEmailMsg(this);" oninput="JavaScript: InvalidEmailMsg(this);" />
                    </p>
                    <p>
                        <span>Wish List</span>
                        <textarea rows="6" dir="LTR" cols="50" name="description" id="description" style="text-align: left">Desired Area : 
Floor : 
Twin House : 
Other Wishes: </textarea>
                    </p>
                    <p style="padding-top: 15px">
                        <span>&nbsp;</span>
                        <span>
                            <input class="button2" type="submit" value="Save" />
                        </span>
                        <!--span>
                            <input class="submit" type="button" value="إنهاء" onclick="JavaScript: closeForm();" />
                        </span-->
                    </p>
                </div>
                <%
                    }
                %>
                <div style="display: inline-block; float: right">
                    <img src="images/<%=logoName%>" style="width: 200px;margin-right: 180px;margin-top: 100px" />
                </div>
            </fieldset>
            <%
                if (request.getAttribute("status") == null || request.getAttribute("status").equals("fail")) {
            %>
            <!--fieldset class="set" align="center" style="margin: 20px 20px 20px 20px;">
                <legend align="center">
                    <font size="5">
                    &nbsp;مشروعات الشركة&nbsp;
                    </font>
                </legend>
                <TABLE style="direction: rtl; width: 420px;">
                    <tr>
                        <th >المشروع</th>
                        <th>الدفع فى خلال</th>
                        <th>نظام الدفع</th>
                        <th>المساحة</th>
                        <th>&nbsp;</th>
                    </tr>
            <%
                if (mainProjects != null) {
                    for (WebBusinessObject mainProjectWbo : mainProjects) {
                        String projectId = (String) mainProjectWbo.getAttribute("projectID");
                        String projectName = (String) mainProjectWbo.getAttribute("projectName");
            %>     
            <tr>
                <td>
            <%=projectName%>
        </td>
        <td>
            <select name="period<%=projectId%>" style="width: 70px;">
                <option value="سنة">سنة</option>
                <option value="سنتين">سنتين</option>
                <option value="3 سنوات">3 سنوات</option>
                <option value="4 سنوات">4 سنوات</option>
                <option value="5 سنوات">5 سنوات</option>
            </select>
        </td>
        <td>
            <select name="paymentType<%=projectId%>" style="width: 70px;">
                <option value="نقدى">نقدى</option>
                <option value="تقسيط">تقسيط</option> 
            </select>
        </td>
        <td>
            <input style='width:80px' type="text" name="area<%=projectId%>"/>
        </td>
        <td>
            <input type="checkbox" name="projectId" value="<%=projectId%>" style="width: 30px;" required
                   title="مطلوب أختيار مشروع علي اﻷقل"/>
        </td>
    </tr>
            <%
                    }
                }
            %>
        </table>
    </fieldset-->
            <%
                }
            %>
        </form>
        <!-- javascript at the bottom for fast page loading -->
        <script type="text/javascript" src="js/web/jquery.js"></script>
        <script type="text/javascript" src="js/web/jquery.easing-sooper.js"></script>
    </body>
</html>