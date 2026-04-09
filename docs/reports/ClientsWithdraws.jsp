<%-- 
    Document   : ClientsWithdraws
    Created on : Apr 18, 2018, 9:34:14 AM
    Author     : walid
--%>

<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        ArrayList<WebBusinessObject> clients = (ArrayList)request.getAttribute("clientsLst");
        String stat = (String) request.getSession().getAttribute("currentMode");
        int a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
        String telNo, dir, clntw, submit, msg, onlyNo, clntNo, clntNm, cb, ct, sender, recipe, noData;
        if (stat.equals("En")) {
            clntw = "Clients Withdraws";
            telNo = "Client Mobile No";
            dir = "ltr";
            submit = "Submit";
            msg = "Please Enter Mobile No";
            onlyNo = "You Can Insert Only Numbers";
            clntNo = "Client No";
            clntNm = "Client Name";
            cb = "Withdrawer";
            ct ="Creation Time";
            recipe = "Withdraw From";
            noData = "No Data";
        } else {
            clntw = "سحوبات العملاء";
            telNo = "رقم موبايل العميل";
            dir = "rtl";
            submit = "عرض";
            msg = "من فضلك ادخل رقم الموبايل ";
            onlyNo = "ارقام فقط";
            clntNo = "رقم العميل";
            clntNm = "اسم العميل";
            cb = "القائم بالسحب";
            ct = "وقت السحب";
            recipe = "المسحوب منه";
            noData = "لا يوجد سحب لهذا العميل";
        }
	
    %>
    
    
<html>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">

        <TITLE>Clients Withdraws</TITLE>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        
        <script type="text/javascript">
            
            var oTable;
            $(document).ready(function() {
                $("#clients").css("display", "none");
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            
            function submitForm()
            {
                if($("#mobNo").val() == '') {
                    alert('<%=msg%>');
                } else {
                    var mobNo = $("#mobNo").val();
                    document.CampClientsLoads.action = "<%=context%>/ReportsServletThree?op=ClientsWithdraws&mobNo=" +mobNo;
                    document.CampClientsLoads.submit();
                }
            }
            
            function isNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    alert("<%=onlyNo%>");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <FORM name="CampClientsLoads" method="post">

            <FIELDSET class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                                <%=clntw%>
                            </font>
                        </td>
                    </tr>
                </table>
                <br/>

                <TABLE class="blueBorder" ALIGN="CENTER" DIR=<%=dir%> ID="code" width="30%"  STYLE="border-width:1px;border-color:white;display: block;" >
                   <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> 
                                <%=telNo%>
                            </b>
                        </TD>
                        <TD bgcolor="#dedede" valign="MIDDLE" >
                            <input type="text" maxlength="12" id="mobNo" name="mobNo" onkeypress="javascript: return isNumber(event);"/>
                        </TD>
                    </TR>
                </TABLE>
                            
                <button class="button" type="button" onclick="JavaScript: submitForm();"   STYLE="color: #000;font-size:15;margin-top: 10px;font-weight:bold; height: 20px; width: 90px; "><%=submit%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                <br><br>
                
                <% if (clients != null && clients.size() > 0) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <h1 style="color: #0000ff; font-size: 20px;">
                        <div style="color: blue;" id="tableTitle">
                            <fmt:message key="tableTitle"/>
                        </div>
                    </h1>
                    <TABLE ALIGN="center" dir=<%=dir%> WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=clntNo%>  </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=clntNm%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=cb%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=ct%></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=recipe%></th>
                            </tr>
                        </thead>

                        <tbody>
                            <% for (WebBusinessObject wbo_ : clients) {
                            %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
				    <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo_.getAttribute("ClientId")%>">
					<%=wbo_.getAttribute("clientNo")%>
				    </a>
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("clientName")%>
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("createdBy")%>
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("wCreationTime").toString().split(" ")[0]%> 
                                    <font style="color: red;font-weight: bolder;" />
                                    <%=wbo_.getAttribute("wCreationTime").toString().split(" ")[1]%> 
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("recipe")%>
                                </TD>
                            </tr>
                            <%}%>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
                <br/>        
                <%} else if (clients != null && clients.size() == 0) {%>
                    <br/>
                    <b style="font-size: x-large; color: red;"><%=noData%></b>
                    <br/>
                    <br/>
                <%}%>
            </FIELDSET>
        </FORM>
    </body>
</html>
