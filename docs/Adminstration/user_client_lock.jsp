<%-- 
    Document   : user_client_lock
    Created on : Jun 21, 2017, 10:00:47 AM
    Author     : java3
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> empClients = (ArrayList<WebBusinessObject>) request.getAttribute("empClients");
    String empID = (String) request.getAttribute("empID");
    
    String beginDate = "";
    if (request.getAttribute("sBeginDate") != null) {
        beginDate = (String) request.getAttribute("sBeginDate");
    }
    String endDate = "";
    if (request.getAttribute("sEndDate") != null) {
        endDate = (String) request.getAttribute("sEndDate");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <script>
            $(document).ready(function () {
                $("#showLockedClientsTbl").dataTable({
                        "bJQueryUI": true,
                        "destroy": true,
                        "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                        "order": [[ 1, "asc" ]]
                }).fadeIn(2000);
                
                 $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            
            function selectAll(obj, ckeckName) {
                $("input[name='" + ckeckName + "']").prop('checked', $(obj).is(':checked'));
            }
            
            function isChecked() {
                var isChecked = false;
                $("input[name='empCustomerId']").each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                    }
                });
                return isChecked;
            }
            
            function unlock(){
                var empID = $("#empID").val();
                if (!isChecked()) {
                    alert(' إختر عميل ');
                    return false;
                } else {
                    document.LOCKED_CLIENT_FORM.action = "<%=context%>/ClientServlet?op=lockClientByUsrID&operation=delete&usrID=" + empID;
                    document.LOCKED_CLIENT_FORM.submit();
                }
            }
            
            function back(){
                var url = "<%=context%>/ClientServlet?op=customizeClient";
                window.open(url);
                window.close();
            }
            
            function search(){
                var empID = $("#empID").val();
                var sBeginDate = $("#beginDate").val();
                var sEndDate = $("#endDate").val();
                document.LOCKED_CLIENT_FORM.action = "<%=context%>/ClientServlet?op=lockClientByUsrID&empID=" + empID + "&sBeginDate=" + sBeginDate + "&sEndDate=" + sEndDate;
                document.LOCKED_CLIENT_FORM.submit();
            }
        </script>
        
        <style type="text/css">
            .titlebar {
                /*background-image: url(images/title_bar.png);*/
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
                background-color: #3399ff;
            }
        </style>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="white" size="4">
                            العملاء المخصصين
                        </font>
                    </td>
                </tr>
            </table>
            
            <br>
            
            <form name="LOCKED_CLIENT_FORM" method="POST">
                
                <input type="button" class="button" value=" Unlock User "  onclick="unlock();">
                <input type="hidden" value="<%=empID%>"  id="empID">
                <input type="button" class="button" value=" Back "  onclick="back();">
                
                <br>
                
                <table ALIGN="center" DIR="RTL" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" WIDTH="30%">
                            <b>
                                <font size=3 color="white">من تاريخ
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;"WIDTH="30%">
                            <b>
                                <font size=3 color="white">إلي تاريخ
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;"WIDTH="30%">
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>">
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" >
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input type="button" class="button" value=" Search "  onclick="search();" style="width: 80%">
                        </td>
                    </tr>
                </table>
                
                <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showLockedClients">
                    <TABLE style="display" id="showLockedClientsTbl" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                        <thead>                
                            <tr>
                                <th STYLE="text-align:center; color:white; font-size:14px">
                                    <input type="checkbox" name="checkAllLock" onchange='selectAll(this, "empCustomerId");'/>
                                </th>

                                <th STYLE="text-align:center; font-size:14px">
                                    <b>م</b>
                                </th>

                                <th STYLE="text-align:center; font-size:14px">
                                    <b>إسم العميل</b>
                                </th>

                                <th STYLE="text-align:center; font-size:14px">
                                    <b>حالة العميل</b>
                                </th>

                                <th STYLE="text-align:center; font-size:14px">
                                    <b>رقم الموبايل</b>
                                </th>

                                <th STYLE="text-align:center; font-size:14px">
                                    <b>رقم التليفون</b>
                                </th>

                                <th STYLE="text-align:center; font-size:14px">
                                    <b>البريد الإلكترونى</b>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b> المسؤول </b>
                                </th>

                                <th STYLE="text-align:center; font-size:14px">
                                    <b>المصدر</b>
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <%
                                int counter = 0;
                                String clazz = "";
                                for (WebBusinessObject empClientsWbo : empClients) {
                                    counter++;
                            %>

                                    <tr class="<%=clazz%>" style="cursor: pointer" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                                        <TD STYLE="text-align: center; width: 5%" nowrap>
                                            <DIV>                   
                                                <input type="checkbox" name="empCustomerId" value="<%=(String) empClientsWbo.getAttribute("lckID")%>" />
                                                
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center; width: 5%" nowrap>
                                            <DIV>                   
                                                <b><%=counter%></b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                           
                                                <b>
                                                    <%=empClientsWbo.getAttribute("name")%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                  
                                                <b style="color: <%="lead".equals(empClientsWbo.getAttribute("statusNameEn")) ? "red" : "black"%>;">
                                                    <%=empClientsWbo.getAttribute("statusNameEn")%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                   
                                                <b>
                                                    <%=(empClientsWbo.getAttribute("mobile") != null ? empClientsWbo.getAttribute("mobile") : "")%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                   
                                                <b>
                                                    <%=(empClientsWbo.getAttribute("phone") != null ? empClientsWbo.getAttribute("phone") : "")%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center">
                                            <DIV>                   
                                                <b>
                                                    <%=(empClientsWbo.getAttribute("email") != null) ? empClientsWbo.getAttribute("email") : ""%>
                                                </b>
                                            </DIV>
                                        </TD>

                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                           
                                                <b>
                                                    <%=empClientsWbo.getAttribute("empName") != null ? empClientsWbo.getAttribute("empName") : ""%>
                                                </b>
                                            </DIV>
                                        </TD>
                                        
                                        <TD STYLE="text-align: center" nowrap>
                                            <DIV>                           
                                                <b>
                                                    <%=empClientsWbo.getAttribute("createdByName") != null ? empClientsWbo.getAttribute("createdByName") : ""%>
                                                </b>
                                            </DIV>
                                        </TD>
                                    </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </form>
            </table>
        </fieldset>
    </body>
</html>