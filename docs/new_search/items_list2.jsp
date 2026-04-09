<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String[] employeeAttributes = {"title", "name"};
        String[] employeeListTitles = new String[2];

        int s = employeeAttributes.length;
        int t = s;
        int iTotal = 0;

        Vector employeeList = (Vector) request.getAttribute("data");

        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String PN, PL;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            employeeListTitles[0] = "Item Code";
            employeeListTitles[1] = "Item Name";
            PN = "Item No.";
            PL = "Item List";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            employeeListTitles[0] = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
            employeeListTitles[1] = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
            PN = " &#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            PL = "&#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        }
        int noOfLinks = 0;
        int count = 0;
        String tempcount = (String) request.getAttribute("count");
        String sparePart = (String) request.getAttribute("sparePart");
        String formName = (String) request.getAttribute("formName");
        if (tempcount != null) {
            count = Integer.parseInt(tempcount);
        }
        String tempLinks = (String) request.getAttribute("noOfLinks");
        if (tempLinks != null) {
            noOfLinks = Integer.parseInt(tempLinks);
        }
        String fullUrl = (String) request.getAttribute("fullUrl");
        String url = (String) request.getAttribute("url");
    %>

    <script language="javascript" type="text/javascript">
        function reloadAE(nextMode){

            var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            {
                req = new XMLHttpRequest();
            }
            else if (window.ActiveXObject)
            {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post",url,true);
            req.onreadystatechange =  callbackFillreload;
            req.send(null);

        }

        function callbackFillreload(){
            if (req.readyState==4)
            {
                if (req.status == 200)
                {
                    window.location.reload();
                }
            }
        }

        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
    </script>
    <script type="text/javascript">
        function sendInfo(id,name){
            var id = id;
            var name = name;
            if(id =="null" || id =="" || name=="null" || name==""){
                window.opener.document.<%=formName%>.partId.value = "";
                window.opener.document.<%=formName%>.sparePart.value = "";
                window.close();
            } else {
                window.opener.document.<%=formName%>.partId.value = id;
                window.opener.document.<%=formName%>.sparePart.value = name;
                window.close();
            }
        }

        function getTasksTop(){
            var count =document.getElementById("selectIdTop").value;
            var name  =document.getElementById("sparePart").value;
            count = parseInt(count);
            var res = ""
            for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
            }
            res = res.substr(0, res.length - 1);
            document.task_form.action = "<%=context%>/<%=fullUrl%>&count="+count+"&taskName="+res+"&url=<%=url%>"+"&sparePart="+res;
            document.task_form.submit();
        }
       
        function getTasksDown(){
            var count =document.getElementById("selectIdDown").value;
            var name =document.getElementById("sparePart").value;
            count = parseInt(count);
            var res = ""
            for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
            }
            res = res.substr(0, res.length - 1);
            document.task_form.action = "<%=context%>/<%=fullUrl%>&count="+count+"&taskName="+res+"&url=<%=url%>";
            document.task_form.submit();
            
        }
    </script>
    <body>

        <FORM NAME="task_form" METHOD="POST">
            <fieldset align=center class="set">
                <legend align="center">

                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6"><%=PL%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend >

                <TABLE ALIGN="<%=align%>" dir=<%=dir%> WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">

                    <br>

                    <center> <b> <font size="3" color="red"> <%=PN%> : <%=employeeList.size()%> </font></b></center>
                    <br>
                    <table align="center">

                        <% if (noOfLinks > 1) {%>
                        <tr>
                            <td class="td" >
                                <b><font size="2" color="red">Page No:</font><font size="2" color="black">&nbsp; <%=count + 1%>&nbsp;</font><font size="2" color="red">of&nbsp;</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                            </td>
                            <td class="td"  >
                                <select id="selectIdTop" onchange="javascript:getTasksTop();">
                                    <%for (int i = 0; i < noOfLinks; i++) {%>
                                    <option value="<%=i%>" <%if (i == count) {%> selected <% }%> ><%=i + 1%></option>
                                    <% }%>
                                </select>
                            </td>
                        </tr>
                        <%}%>
                    </table>
                    <br>
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="80%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                        <TR CLASS="head">
                            <TD nowrap WIDTH="3%" CLASS="firstname" bgcolor="#4B8A08" STYLE="border-WIDTH:0; font-size:16;color:white;padding-left:3px;padding-right:3px;text-align:center" >
                                <B>#</B>
                            </TD>
                            <%

                                String columnColor = new String("");
                                String font = new String("");
                                for (int i = 0; i < t; i++) {
                                    if (i == 0) {
                                        columnColor = "#9B9B00";
                                    } else {
                                        columnColor = "#7EBB00";
                                    }
                                    if (employeeListTitles[i].equalsIgnoreCase("")) {
                                        columnColor = "black";
                                        font = "1";
                                    } else {
                                        font = "18";
                                    }
                            %>
                            <TD nowrap CLASS="firstname" bgcolor="#4B8A08" STYLE="border-WIDTH:0; font-size:<%=font%>;color:white;padding-left:20px;padding-right:20px;padding-bottom:5px;padding-top:5px;<%=style%>">
                                <B><%=employeeListTitles[i]%></B>
                            </TD>
                            <%
                                }
                            %>

                        </TR>

                        <%
                            int index = count * 20;
                            Enumeration e = employeeList.elements();
                            while (e.hasMoreElements()) {
                                iTotal++;
                                index++;
                                wbo = (WebBusinessObject) e.nextElement();

                                flipper++;
                                if ((flipper % 2) == 1) {
                                    bgColor = "#c8d8f8";
                                } else {
                                    bgColor = "white";
                                }
                        %>
                        <TR bgcolor="<%=bgColor%>">
                            <TD WIDTH="3%" CLASS="firstname" bgcolor="#4B8A08" STYLE="border-WIDTH:0; font-size:16;color:white;padding-left:3px;padding-right:3px;text-align:center">
                                <B><%=index%></B>
                            </TD>
                            <TD WIDTH="37%" STYLE="<%=style%>;border-bottom:black 1px solid"  BGCOLOR="#D0F5A9">
                                <DIV >
                                    <a  href="javascript:sendInfo('<%=wbo.getAttribute("itemId")%>', '<%=wbo.getAttribute("itemDesc")%>');" > <b style="text-decoration: none;color:black;padding-left:20px;padding-right:20px;"> <%=(String) wbo.getAttribute("itemId")%> </b> </a>
                                </DIV>
                            </TD>
                            <TD WIDTH="60%" STYLE="<%=style%>;border-bottom:black 1px solid"  BGCOLOR="#D0F5A9" nowrap>
                                <DIV >
                                    <a  href="javascript:sendInfo('<%=wbo.getAttribute("itemId")%>', '<%=wbo.getAttribute("itemDesc")%>');" > <b style="text-decoration: none;color:black;padding-left:20px;padding-right:20px;"> <%=(String) wbo.getAttribute("itemDesc")%> </b> </a>
                                </DIV>
                            </TD>
                        </TR>
                        <%
                            }
                        %>
                        <TR>
                            <TD nowrap CLASS="cell" BGCOLOR="#4B8A08" COLSPAN="2" STYLE="text-align:center;padding-right:5;border-right-width:1;color:white;font-size:16;padding-left:20px;padding-right:20px">
                                <B><%=PN%></B>
                            </TD>

                            <TD nowrap CLASS="cell" BGCOLOR="#4B8A08" colspan="1" STYLE="text-align:center;padding-left:5;;color:white;font-size:16;padding-left:20px;padding-right:20px">
                                <DIV NAME="" ID="">
                                    <B><%=iTotal%></B>
                                </DIV>
                            </TD>
                        </TR>
                    </table>

                    <table align="center">
                        <input type="hidden" name="url" value="<%=url%>" id="url" >
                        <input type="hidden" name="formName" value="<%=formName%>" id="formName" >
                        <input type="hidden" name="sparePart" value="<%=sparePart%>" id="sparePart">
                        <% if (noOfLinks > 1) {%>
                        <tr>
                            <td class="td" >
                                <b><font size="2" color="red">Page No:</font><font size="2" color="black">&nbsp;<%=count + 1%>&nbsp;</font><font size="2" color="red">of&nbsp;</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                            </td>
                            <td class="td"  >
                                <select id="selectIdDown" onchange="javascript:getTasksDown();">
                                    <%for (int i = 0; i < noOfLinks; i++) {%>
                                    <option value="<%=i%>" <%if (i == count) {%> selected <% }%> ><%=i + 1%></option>
                                    <% }%>
                                </select>
                            </td>
                        </tr>
                        <%}%>
                    </table>
            </fieldset>
        </form>
    </body>
</html>
