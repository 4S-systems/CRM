 <%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      
    </head>
    <body>
         
         <div id="complaintReport" style="display: none;width: 80%; height: 80%;"></div>
        <div id="addChannelComment" style="display: none;width: 80%; height: auto"></div>
        <div id="redirectComp"  style="width: 30%;display: none;">
            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -10;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
             <div class="login" style="width: 90%;float: left;margin-bottom: 3px;">
                <table class="" style="width:100%;text-align: right;border: none;margin-bottom: 3px;"  class="table" cellspacing="10px;">

                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">إسم الموظف</label></TD>
                        <td  style="text-align: right;">
                            <SELECT id="department" name="department" STYLE="width:80%;font-size: small;text-align: right;float: right">
                                <sw:WBOOptionList wboList='<%=employeesx%>' displayAttribute = "userName" valueAttribute="userId" />

                            </SELECT>
                        </td>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript:redirectComplaintToEmployee(this);" value="تحويل" style="margin-top: 15px;font-family: sans-serif"></TD>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <b id="redirectMsg" style="text-align: center;color: white;font-size: 15px;"></b>
                        </td>
                    </tr>
                </TABLE>
            </div>
        </div>

        <div id="notificationComp"  style="width:40%;display: none;">
            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -10;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;float: left;margin-bottom: 3px;">
                  <!--                
                                notificationComp
                                allEmployees
                -->
                <table id="employeesTable"  align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="">
                    <thead>
                        <TR>
                            <TH><SPAN style=""></SPAN></TH>
                            <TH><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b>Employee Id </b></SPAN></TH>
                            <TH><SPAN><img src="images/icons/client.png" width="20" height="20" /><b>Employee Name </b></SPAN></TH>

                        </TR>
                    </thead>
                    <tbody  >  
                        <%
                            for (WebBusinessObject wbo : allEmployees) {
                        %>
                        <TR id="empRow">

                            <TD style="background-color: transparent;">
                                <SPAN style="display: inline-block;height: 20px;background: transparent;"><INPUT type="checkbox" id="empId" class="case" value="<%=wbo.getAttribute("userId")%>" name="selectedEmp"/>
                                    <input type="hidden" id="employeeId" value="<%=wbo.getAttribute("userId")%>" />
                                </SPAN>
                            </TD>

                            <TD style="background-color: transparent;">
                                <%=wbo.getAttribute("userName")%>
                            </TD>
                            <TD style="background-color: transparent;">
                                <%=wbo.getAttribute("fullName")%>
                            </TD>
                        </TR>
                        <% }%>
                    </tbody>
                </table>
                <div style="width: 100%;text-align: center;margin-left: auto;margin-right: auto;">

                    <input type="text" id="notificationComment" style="width: 100%" /> </br>
                    <input type="button" onclick="JavaScript:notificationComplaintToEmployee(this);" value="إعــــــــلام" style="margin-top: 15px;font-family: sans-serif">
                    <br/><span type="text" id="notificationMsg" style="width: 100%; font-size: large; color: black; font-weight: bold;" /> 
                    <input type="hidden" id="comment" name="comment" value="إعلام من <%=securityUser.getFullName()%>" />
                    <input type="hidden" id="subject" name="subject" value="إعلام من <%=securityUser.getFullName()%>" />
                </div>
            </div>
        </div>


        <div id="closeNote"  style="width: 40%;display: none; position: fixed">

            <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >

                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">اﻷجراء المحدد</label></td>
                        <td style="width: 60%;">
                            <select id="actionTaken" name="actionTaken" STYLE="width:175px;font-size: small;text-align: right;float: right">
                                <sw:WBOOptionList wboList='<%=closureActionsList%>' displayAttribute = "title" valueAttribute="id" />
                                <option value="100" selected>لا شيئ</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإغلاق</label></TD>
                        <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                        <td style="width: 60%;">  <input name="closedEndDate" id="closedEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript:closeComplaint(this);" class="button_close">

                        </TD>
                    </tr>
                    <tr>
                        <%
                            String msg = "\u062A\u0645 \u0627\u0644\u0623\u063A\u0644\u0627\u0642 \u0628\u0646\u062C\u0627\u062D";
                            if (MetaDataMgr.getInstance().getSendMail() != null && MetaDataMgr.getInstance().getSendMail().equalsIgnoreCase("1")) {
                                msg += " \u0648 \u0623\u0631\u0633\u0627\u0644 \u0625\u0645\u064A\u0644 \u0628\u0630\u0644\u0643";
                        %>
                        
                        <% }%>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="closedMsg"><%=msg%></div>
                        </td>
                    </tr>
                </TABLE>
            </div>
        </div>                       
       
        <div id="redistributionComp"  style="width:40%;display: none;">
            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -10;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;float: left;margin-bottom: 3px;">
                <table id="employeesTable2"  align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="">
                    <thead>
                        <TR>
                            <TH><SPAN style=""></SPAN></TH>
                            <TH><SPAN><img src="images/icons/client.png" width="20" height="20" /><b>اسم الموظف</b></SPAN></TH>
                        </TR>
                    </thead>
                    <tbody  >  
                        <%
                            if (userUnderManager != null) {
                                for (WebBusinessObject wbo : userUnderManager) {
                        %>
                        <TR id="empRow">
                            <TD style="background-color: transparent;">
                                <SPAN style="display: inline-block;height: 20px;background: transparent;">
                                    <INPUT type="radio" id="empId" class="case" value="<%=wbo.getAttribute("userId")%>" name="selectedEmp"/>
                                    <input type="hidden" id="employeeId" value="<%=wbo.getAttribute("userId")%>" />
                                </SPAN>
                            </TD>
                            <TD style="background-color: transparent;">
                                <%=wbo.getAttribute("fullName")%>
                            </TD>
                        </TR>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
                <div style="width: 100%;text-align: center;margin-left: auto;margin-right: auto;">
                    <input type="text" id="redistributionComment" style="width: 100%; display: none" /> </br>
                    <input type="button" onclick="JavaScript:redistributionComplaintToEmployee(this);" class="managerBt" value="" style="margin-top: 15px;font-family: sans-serif">
                    <input type="hidden" id="comment" name="comment" value="اعادة توجيه من <%=securityUser.getFullName()%>" />
                    <input type="hidden" id="subject" name="subject" value="اعادة توجيه من <%=securityUser.getFullName()%>" />
                    <b id="redistributionComplaintMSG"></b>
                </div>
            </div>
        </div>
        
        <div id="rejectedNote"  style="width: 40%;display: none; position: fixed">

            <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >

                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإلغاء</label></TD>
                        <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                        <td style="width: 60%;">  <input name="rejectedEndDate" id="rejectedEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript:rejectedComplaint(this);" class="rejectedBtn">

                        </TD>
                    </tr>
                    <tr>
                    <tr>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="rejectedMsg">  </>
                        </td>
                    </tr>
                    </tr>
                </TABLE>
            </div>
        </div>
        <div id="finishNote"  style="width: 40%;display: none;position: fixed">

            <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >                



                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">اﻷجراء المحدد</label></td>
                        <td style="width: 60%;">
                            <select id="actionTaken" name="actionTaken" STYLE="width:175px;font-size: small;text-align: right;float: right">
                                <sw:WBOOptionList wboList='<%=actionsList%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                <option value="100" selected>Other</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإنهاء</label></TD>
                        <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                        <td style="width: 60%;">  <input name="finishEndDate" id="finishEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript:finishComplaint(this);" class="button_finis"></TD>
                    </tr>
                    <tr>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="finishMsg">تم الإنهاء بنجاح</>
                        </td>
                    </tr>


                </TABLE>
            </div>

        </div>

                    
    </body>
</html>
