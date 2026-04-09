<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

    </HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        //AppConstants appCons = new AppConstants();

        String[] projectAttributes = {"projectName"};
        String[] projectListTitles = new String[5];

        int s = projectAttributes.length;
        int t = s + 4;
        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;

        String status = (String) request.getAttribute("status");

        Vector projectsList = (Vector) request.getAttribute("data");


        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;
        String bgColorm = null;

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        ProjectMgr projectMgr = ProjectMgr.getInstance();

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel, TT, IG, AS, QS, BO, CD, PN, NAS, PL, sSccess, sFail;
        String attachDoc, viewAttach, noviewAttach;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "Delete Schedule - Are you Sure ?";
            save = "Delete";
            cancel = "Back To List";
            TT = "Task Title ";
            IG = "Indicators guide ";
            AS = "Active Site by Equipment";
            NAS = "Non Active Site";
            QS = "Quick Summary";
            BO = "Basic Operations";
            projectListTitles[0] = "Site Name";
            projectListTitles[1] = "Location Name";
            projectListTitles[2] = "View";
            projectListTitles[3] = "Edit";
            projectListTitles[4] = "Delete";
            CD = "Can't Delete Site";
            PN = "Projects No.";
            PL = "Projects List";
            sSccess = "Project Deleted Successfully";
            sFail = "Fail To Delete Project <br> May be related with other Things";
            attachDoc = "Attach document";
            viewAttach = "View attachments";
            noviewAttach = "No attached documents";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            tit = " &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
            save = " &#1573;&#1581;&#1584;&#1601;";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            IG = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
            AS = "&#1605;&#1608;&#1602;&#1593; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            NAS = "&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            QS = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            BO = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
            projectListTitles[0] = "اسم العنصر";
            projectListTitles[1] = "مكان العنصر";
            projectListTitles[2] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            projectListTitles[3] = "&#1578;&#1581;&#1585;&#1610;&#1585;";
            projectListTitles[4] = "&#1581;&#1584;&#1601;";
            CD = " &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            PN = "عدد العناصر";
            PL = "عرض العناصر";
            sSccess = "&#1578;&#1605; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; &#1576;&#1606;&#1580;&#1575;&#1581;";
            sFail = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1581;&#1584;&#1601; <br> &#1605;&#1581;&#1578;&#1605;&#1604; &#1575;&#1606; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1571;&#1588;&#1610;&#1575;&#1569; &#1571;&#1582;&#1585;&#1609;";
            attachDoc = "&#1571;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
            viewAttach = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
            noviewAttach = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
        }


    %>

    <script type="text/javascript">
        
        
        var oTable;
        var users = new Array();
        $(document).ready(function() {

            //                if ($("#tblData").attr("class") == "blueBorder") {
            //                    $("#tblData").bPopup();
            //                }
          
            //            $("#clients").css("display", "none");
            oTable = $('#projects').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true

            }).fadeIn(2000);

        });
    </script>
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
    <body>


       

        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">

        </DIV> 

            <fieldset align=center class="set" style="width: 90%">
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
            <br>

            <center> <b> <font size="3" color="red"> <%=PN%> : <%=projectsList.size()%> </font></b></center> 
            <br>

            <%if (status != null) {
            %>
            <table width="50%" align="center">
                <tr>
                    <%if (status.equalsIgnoreCase("ok")) {%>
                    <td class="bar">
                        <b><font color="blue" size="3"><%=sSccess%></font></b>
                    </td>
                    <%} else {%>
                    <td class="bar">
                        <b><font color="red" size="3"><%=sFail%></font></b>
                    </td>
                    <%}%>
                </tr>
            </table>
            <br>
            <%}%>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="projects" style="width:100%;display: none; ">

                    <!--                <TR>
                                        <TD CLASS="blueBorder blueHeaderTD" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                                            <B><%=QS%></B>
                                        </TD>
                                        <TD CLASS="blueBorder blueHeaderTD" COLSPAN="5" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                                            <B><%=BO%></B>
                                        </TD>
                                     
                                    </tr>-->
                    <thead>

                        <TR >

                            <%
                                String columnColor = new String("");
                                String columnWidth = new String("");
                                String font = new String("");
                                UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
                                Vector docList = new Vector();
                                for (int i = 0; i < t; i++) {
                                    //                        if(i == 0 ){
                                    //                            columnColor = "#9B9B00";
                                    //                        } else {
                                    //                            columnColor = "#7EBB00";
                                    //                        }
                                    //                        if(projectListTitles[i].equalsIgnoreCase("")){
                                    //                            columnWidth = "1";
                                    //                            columnColor = "black";
                                    //                            font = "1";
                                    //                        } else {
                                    //                            columnWidth = "100";
                                    //                            font = "12";
                                    //                        }
                            %>                
                            <Th>
                                <B><%=projectListTitles[i]%></B>
                            </Th>
                            <%
                                }
                            %>
                            <%--
                            <TD nowrap CLASS="firstname" BGCOLOR="#FFBF00" WIDTH="135" STYLE="border-WIDTH:0; font-size:12" COLSPAN="3" nowrap>
                                &nbsp;
                                </TD>
                            --%>
                            <Th>
                                <B><%=attachDoc%></B>
                            </Th>
                            <Th>
                                <B><%=viewAttach%></B>
                            </Th>
                            
                        </TR>
                    </thead>
                    <tbody>

                        <%

                            Enumeration e = projectsList.elements();


                            while (e.hasMoreElements()) {
                                iTotal++;
                                wbo = (WebBusinessObject) e.nextElement();

                                //                 flipper++;
                                //                  if((flipper%2) == 1) {
                                //                       bgColor="silver_odd";
                                //                       bgColorm = "silver_odd_main";
                                //                    } else {
                                //                        bgColor= "silver_even";
                                //                         bgColorm = "silver_even_main";
                                //                    }
                        %>

                        <TR >
                            <%
                                for (int i = 0; i < s; i++) {
                                    attName = projectAttributes[i];
                                    attValue = (String) wbo.getAttribute(attName);
                                    String locateValue=(String)wbo.getAttribute("ar");
                            %>

                            <TD   >
                                <DIV >

                                    <b> <%=attValue%> </b>
                                </DIV>
                            </TD>
                            
                            <TD   >
                                <DIV >

                                    <b> <%=locateValue%> </b>
                                </DIV>
                            </TD>
                            
                            <%
                                }
                            %>

                            <TD>
                                <DIV ID="links">
                                    <A HREF="<%=context%>/ProjectServlet?op=ViewProject&projectId=<%=wbo.getAttribute("projectID")%>">

                                        <%= projectListTitles[2]%>
                                    </A>
                                </DIV>
                            </TD>

                            <TD>
                                <DIV ID="links">
                                    <A HREF="<%=context%>/ProjectServlet?op=GetUpdateForm&projectId=<%=wbo.getAttribute("projectID")%>">
                                        <%= projectListTitles[3]%>
                                    </A>
                                </DIV>
                            </TD>
                            <%--
                            <%
                            if(projectMgr.getActiveSite(wbo.getAttribute("projectID").toString())) {
                            %>
                            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82" >
                                <DIV ID="links">
                                    
                                    <%=CD%>  
                                    
                                </DIV>
                            </TD>
                            
                            <%
                            } else {
                            %> 
                            --%>
                            <TD >
                                <DIV ID="links">
                                    <!--A HREF="<%=context%>/ProjectServlet?op=ConfirmDelete&projectId=<%=wbo.getAttribute("projectID")%>&projectName=<%=wbo.getAttribute("projectName")%>">
                                    <%//= projectListTitles[3]%>
                                </A-->
                                    <% 
                                        if(metaMgr.canDelete()){%>
                                   <A HREF="<%=context%>/ProjectServlet?op=ConfirmDelete&projectId=<%=wbo.getAttribute("projectID")%>&projectName=<%=wbo.getAttribute("projectName")%>">
                                        <%= projectListTitles[4]%>
                                    </A>
                                    <%    } else { }%>
                                     
                                    
                                   
                                </DIV>
                            </TD>
                            <%--
                            <% } %>
                            
                            
                            <TD WIDTH="20px" nowrap CLASS="cell" BGCOLOR="#FFE391">
                                <%
                                if(projectMgr.getActiveSite(wbo.getAttribute("projectID").toString())) {
                                %>
                                <IMG SRC="images/active.jpg"  ALT="Active Site by Equipment"> 
                                
                                
                                <%
                                } else {
                                %> 
                                
                                <IMG SRC="images/nonactive.jpg"  ALT="Non Active Site">
                                <% } %>
                            </TD>               
                            --%>

                            <TD>
                                <DIV ID="links">
                                    <A HREF="<%=context%>/UnitDocWriterServlet?op=attach&projId=<%=wbo.getAttribute("projectID")%>&type=project">
                                        <%=attachDoc%>
                                    </A>
                                </DIV>
                            </TD>
                            
                            <TD >
                                <DIV ID="links">
                                    <A HREF="<%=context%>/UnitDocReaderServlet?op=ListDoc&equipmentID=<%=wbo.getAttribute("projectID")%>&type=project">
                                        <%=viewAttach%>
                                    </A>
                                </DIV>
                            </TD>
                           
                        </TR>


                        <%

                            }

                        %>

                    </tbody>
                </table>
            </div> 
        </fieldset>

    </body>
</html>
