<%@page import="com.maintenance.db_access.MainCategoryTypeMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.persistence.relational.UniqueIDGen,com.workFlowTasks.db_access.*,com.tracker.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>


    <%
                String status = (String) request.getAttribute("status");
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();

                String context = metaMgr.getContext();
    //
                String url = context + "/ScheduleServlet?op=SearchEquip";

    //paging
                Vector issueList = (Vector) request.getAttribute("data");
                int noOfLinks = 0;
                int count = 0;
                String[] projectAttributes = {"unitNo", "unitName"};
                String[] projectListTitles = new String[2];
                int s = projectAttributes.length;
                int t = s;

                String tempcount = (String) request.getAttribute("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                String tempLinks = (String) request.getAttribute("noOfLinks");
                if (tempLinks != null) {
                    noOfLinks = Integer.parseInt(tempLinks);
                }
                //paging
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

                String formName = (String) request.getAttribute("formName");
                String name = (String) request.getAttribute("name");
                int flipper = 0;

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String attName = null;
                String attValue = null;
                String absalign = "";
                String dir = null;
                String style = null;
                String lang, langCode, cancel;
                String Total, title;
                String KMLabel, TimeLabel;

                if (stat.equals("En")) {
                    title = "List Brands";
                    Total = "Number";
                    projectListTitles[0] = "Unit Number";
                    projectListTitles[1] = "Unit Name";
                    align = "center";
                    absalign = "Left";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "  &#1593;&#1585;&#1576;&#1610; ";
                    cancel = "Cancel";
                    langCode = "Ar";
                    KMLabel = "By KM";
                    TimeLabel = "By Time";

                } else {
                    title = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1575;&#1578;";
                    Total = "&#1575;&#1604;&#1593;&#1583;&#1583;";
                    projectListTitles[0] = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
                    projectListTitles[1] = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
                    align = "center";
                    absalign = "Right";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    langCode = "En";
                    cancel = tGuide.getMessage("cancel");
                    KMLabel = "بالكيلو";
                    TimeLabel = "بالساعة";
                }


    %>



    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>List OF Main Type Tables</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link rel="stylesheet" type="text/css" href="css/headers.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>

    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

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
        function sendInfo(name,id,TypeRate)
        {
            var check = "ahmed";
            if(id == "" || name =="" || TypeRate =="")
            {
                window.opener.document.<%=formName%>.unitName.value = "";
                window.opener.document.<%=formName%>.unitCats.value = "";
            }
            else
            {
                window.opener.document.<%=formName%>.unitName.value = name;
                window.opener.document.<%=formName%>.unitCats.value = id;
                window.opener.document.getElementById('typeRate').innerHTML='('+TypeRate+')';
                window.opener.document.getElementById('eqpByRateType0').innerHTML='('+TypeRate+')';
            
            }
            window.close();
        }

        function goToUrlDown(){
            var no = document.getElementById('pageNoDown').value;
            var url = "<%=url%>&count=" + no;
            document.Tables_FORM.action = url;
            document.Tables_FORM.submit();
        }
        function goToUrlUp(){
            var no = document.getElementById('pageNoUp').value;
            var url = "<%=url%>&count=" + no;
            document.Tables_FORM.action = url;
            document.Tables_FORM.submit();
        }

    </SCRIPT>
    <style type="text/css">
        .myBorderSilver{
            border-color:#000080;
            border-width:1px;
            border-style:solid
        }
    </style>

    <script type="text/javascript" src="js/ChangeLang.js"></script>

    <BODY style="background-color:white">
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <FORM NAME="Tables_FORM" id="Tables_FORM" METHOD="POST" >
            <DIV align="left" STYLE="color:blue;">
                <button  onclick="reloadAE('<%=langCode%>')" class="button" style="background-color:#006699"> <%=lang%></button>
                <button  onclick="window.close()" class="button" style="background-color:#006699"> <%=cancel%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
            </DIV>
            <BR>
            <center>
                <fieldset class="set">
                    <legend align="center">
                        <table dir="<%=dir%>" align="<%=align%>">
                            <tr>

                                <td class="td">
                                    <font color="blue" size="6"><%=title%></font>
                                </td>
                            </tr>
                        </table>
                    </legend>

                    <BR>

                    <div align="center">
                        <input type="hidden" name="url" value="<%=url%>" id="url" >
                        <input type="hidden" name="formName" value="<%=formName%>" />
                        <%if (name != null) {%>
                        <input type="hidden" name="name" value="<%=name%>" />
                        <%}%>

                        <%if (noOfLinks > 0) {%>
                        <font size="3" color="red" style="font-weight:bold" >Page No</font><font size="3" color="black" ><%=(count + 1)%></font><font size="3" color="red" style="font-weight:bold" > of </font><font size="3" color="black" ><%=noOfLinks%></font>
                        &ensp;
                        <select id="pageNoUp" onchange="goToUrlUp()" style="font-size:14px;font-weight:bold;color:black">
                            <%for (int i = 0; i < noOfLinks; i++) {%>
                            <option  value="<%=i%>" <%if (i == count) {%> selected <%}%> ><%=(i + 1)%></option>
                            <%}%>
                        </select>
                        <%
                                    }
                        %>
                    </div>

                    <BR>

                    <TABLE CLASS="myBorderSilver" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="90%">

                        <TR>
                            <%
                                        for (int i = 0; i < t; i++) {
                            %>
                            <TD nowrap CLASS="myBorderSilver" bgcolor="#006699" STYLE="text-align:center;font-size:16px;color:white;height:30px;" nowrap>
                                <B><%=projectListTitles[i]%></B>
                            </TD>
                            <%
                                        }
                            %>

                        </TR>

                        <%

                                    WebBusinessObject wbo = new WebBusinessObject();
                                    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                                    Enumeration e = issueList.elements();
                                    String typeOfRate = null;
                                    String mainCatTypeId = null;
                                    while (e.hasMoreElements()) {

                                        wbo = (WebBusinessObject) e.nextElement();
                                        mainCatTypeId = wbo.getAttribute("maintTypeId").toString();
                                        flipper++;
                                        try {
                                            typeOfRate = mainCategoryTypeMgr.getTypeOfMainTypeNameById(mainCatTypeId);
                                            if (typeOfRate.equals("BY_TIME")) {
                                                typeOfRate = TimeLabel;
                                            } else if (typeOfRate.equals("BY_KM")) {
                                                typeOfRate = KMLabel;
                                            }
                                        } catch (Exception exp) {
                                            typeOfRate = "";
                                        }

                        %>
                        <TR>

                            <%
                                        String width;
                                        for (int i = 0; i < s; i++) {
                                            attName = projectAttributes[i];
                                            attValue = (String) wbo.getAttribute(attName);

                                            if (i == 0) {
                                                width = "35%";
                                            } else {
                                                width = "65%";
                                            }


                            %>

                            <TD WIDTH="<%=width%>" STYLE="text-align:center;height:20px;" nowrap  CLASS="myBorderSilver" BGCOLOR="#F0F0F0">
                                <a  href="javascript:sendInfo('<%=wbo.getAttribute("unitName").toString()%>','<%=wbo.getAttribute("id").toString()%>','<%=typeOfRate%>');" >
                                    <b style="text-decoration: none"> <font color="black" size="3"> <%=attValue%> </font> </b> </a>
                            </TD>


                            <%
                                        }
                            %>
                        </TR>
                        <% }%>
                        <TR CLASS="myBorderSilver" BGCOLOR="9B9B00">

                            <TD  STYLE="text-align:center;height:25px;" nowrap  CLASS="myBorderSilver" BGCOLOR="#808080">
                                <b style="text-decoration: none"> <font color="black" size="3"> <%=Total%> </font> </b>
                            </TD>
                            <TD  STYLE="text-align:center;height:25px;" nowrap  CLASS="myBorderSilver" BGCOLOR="#808080">
                                <b style="text-decoration: none"> <font color="black" size="3"><%=issueList.size()%></font> </b>
                            </TD>
                        </TR>

                    </TABLE>

                    <div align="center">
                        <input type="hidden" name="url" value="<%=url%>" id="url" >
                        <%if (noOfLinks > 0) {%>
                        <br>
                        <font size="3" color="red" style="font-weight:bold" >Page No</font><font size="3" color="black" ><%=(count + 1)%></font><font size="3" color="red" style="font-weight:bold" > of </font><font size="3" color="black" ><%=noOfLinks%></font>
                        &ensp;
                        <select id="pageNoDown" onchange="goToUrlDown()" style="font-size:14px;font-weight:bold;color:black"/>
                        <%for (int i = 0; i < noOfLinks; i++) {%>
                        <option  value="<%=i%>" <%if (i == count) {%> selected <%}%> ><%=(i + 1)%></option>
                        <%}%>
                        </select>
                        <%
                                    }
                        %>
                    </div>
                    <br>
                </fieldset>
            </center>
        </FORM>

    </BODY>

</HTML>
