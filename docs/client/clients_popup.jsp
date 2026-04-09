<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        session = request.getSession();
        String[] projectListTitles = {"Code", "Name", "Mobile"};

        int s = projectListTitles.length;
        int t = s;

        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign;
        String dir = null;
        String style = null;
        String title, cancel;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            style = "text-align:left";
            title = "Clients";
            cancel = "Cancel";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            style = "text-align:Right";
            title = "العملاء";
            projectListTitles[0] = "الكود";
            projectListTitles[1] = "الاسم";
            projectListTitles[2] = "الموبايل";
            cancel = "أنهاء";
        }
    %>
    <head>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui-1.11.2/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" language="javascript" src="js/common.js"></script>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css"/>
        <link REL="stylesheet" TYPE="text/css" HREF="css/Button.css"/>
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <script language="JavaScript" type="text/javascript">
            $(document).ready(function () {
                $("#trailers").dataTable({
                    "destroy": true
                }).fadeIn(2000);
            });

            function sendClientInfo(id, name, code) {
                if( window.opener.document.getElementById('treatType').value==="1")
                {
                    
                    window.opener.document.getElementById('clientIdSell').value = id;
                    window.opener.document.getElementById('clientNameSell').innerHTML = name;
                    window.opener.document.getElementById('clientCodeSell').value = code;
                    window.opener.document.getElementById('errorMsgSell').innerHTML = "";
                }
                else if( window.opener.document.getElementById('treatType').value==="2"){
                try {
                   window.opener.document.getElementById('clientId').value = id;
                    window.opener.document.getElementById('clientName').innerHTML = name;
                    window.opener.document.getElementById('clientCode').value = code;
                    window.opener.document.getElementById('errorMsgReserve').innerHTML = "";
                } catch (err) {
                }
            }
            else if( window.opener.document.getElementById('treatType').value==="3")
            {
                 try {
                   window.opener.document.getElementById('clientIdRent').value = id;
                    window.opener.document.getElementById('clientNameRent').innerHTML = name;
                    window.opener.document.getElementById('clientCodeRent').value = code;
                    window.opener.document.getElementById('errorMsgRent').innerHTML = "";
                } catch (err) {
                }
            } else if( window.opener.document.getElementById('treatType').value === "4") {
                window.opener.document.getElementById('clientID').value = id;
                window.opener.document.getElementById('clientName').value = name;
            } else if( window.opener.document.getElementById('treatType').value === "5") {
                window.opener.document.getElementById('clientIDPayment').value = id;
                window.opener.document.getElementById('clientNamePayment').innerHTML = name;
            }
                window.close();
            }
        </script>
    </head>
    <body>
        <form name="UNITS_LIST" method="post">
            <div align="left" style="color:blue;">
                <button onclick="JavaScript: closeForm();" class="button"> <%=cancel%> <img valign="bottom" src="images/cancel.gif"/> </button>
            </div>
            <br/>
            <fieldset align="center" class="set">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                            <font color='white' SIZE="+1">
                            <%=title%>
                            </font>
                            <br/>
                        </td>
                    </tr>
                </table>
                <br/><br/>
                <div style="width: 90%; margin-left: auto; margin-right: auto;">
                    <table id="trailers" WIDTH="100%" border="0" ALIGN="center" CELLPADDING="1" CELLSPACING="0" dir="<%=dir%>" class="silver_table">            
                        <thead>
                            <tr class="silver_header">
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th class="silver_header" style="text-align:center; font-size:16px; border-right:0px solid #666666 ;">
                                    <b><%=projectListTitles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                String bgColorm = "silver_even_main";
                                for (WebBusinessObject wbo : clientsList) {
                            %>
                            <tr>        
                                <td class="<%=bgColorm%>" style="text-align:center; font-size:16px; border-right:0px solid #666666 ;">
                                    <a href="#" onclick="return sendClientInfo('<%=wbo.getAttribute("id")%>', '<%=wbo.getAttribute("name")%>', '<%=wbo.getAttribute("clientNO")%>')">
                                        <b><font size="2"> <%=wbo.getAttribute("clientNO")%></font> </b>
                                    </a>
                                </td>      
                                <td class="<%=bgColorm%>" style="text-align:center; font-size:16px; border-right:0px solid #666666 ;">
                                    <a href="#" onclick="return sendClientInfo('<%=wbo.getAttribute("id")%>', '<%=wbo.getAttribute("name")%>', '<%=wbo.getAttribute("clientNO")%>')">
                                        <b><font size="2"> <%=wbo.getAttribute("name")%></font> </b>
                                    </a>
                                </td>
                                <td class="<%=bgColorm%>" style="text-align:center; font-size:16px; border-right:0px solid #666666 ;">
                                    <a href="#" onclick="return sendClientInfo('<%=wbo.getAttribute("id")%>', '<%=wbo.getAttribute("name")%>', '<%=wbo.getAttribute("clientNO")%>')">
                                        <b><font size="2"> <%=wbo.getAttribute("mobile") != null && !"UL".equals(wbo.getAttribute("mobile")) ? wbo.getAttribute("mobile") : ""%></font> </b>
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <br/><br/>
            </fieldset>
        </form>
    </body>
</html>
