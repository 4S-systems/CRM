<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" href="css/style.css" type="text/css" media="screen" />
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");

        String rows = (String) request.getAttribute("rows");
        String flats = (String) request.getAttribute("flats");
        String garage = (String) request.getAttribute("garage");
        WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
        String status = (String) request.getAttribute("status");
        String dataSaved = (String) request.getAttribute("dataSaved");
        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();

        String title;
        String saveMessage;
        if (stat.equals("En")) {
            title = "Schematic Representation for Units in Building: ";
            saveMessage = "Saved Successfully";
        } else {
            title = "Schematic Representation for Units in Building: ";
            saveMessage = "تم التسجيل بنجاح";
        }
    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function getUnits() {
            var modelId = $("#modelId").val();
            document.UNITS_FORM.action = "<%=context%>/ProjectServlet?op=generateFlats&modelId=" + modelId;
            document.UNITS_FORM.submit();
        }
    </SCRIPT>
    <style>
        #tabs li{
            display: inline;
        }
        #tabs li a{

            text-align:center; font:bold 15px;
            display:inline;
            text-decoration:none;
            padding-right:20px;
            padding-left:20px;
            padding-bottom:0;
            margin:0px;
            font-size: 15px;
            background-image:url(images/buttonbg.jpg);       
            background-repeat: repeat-x;
            background-position: bottom;
            color:#069;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        #tabs li a:hover{
            background-color:#FFF;
            color:#069; 
        }
        .button_close{
            width:76px;
            height:35px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/close_.png);
        }

        .button_redirec{
            width:85px;
            height:40px;
            /*margin-right: 90px;*/
            border: none;
            background-repeat: no-repeat;
            cursor: pointer;

            background-position: right top ;
            /*display: inline-block;*/
            background-color: transparent;
            background-image:url(images/buttons/button2.png);
        }
        .button_remove{
            width:85px;
            height:40px;
            margin: 0px;

            /*margin-right: 90px;*/
            border: none;
            background-repeat: no-repeat;
            cursor: pointer;

            background-position: right top ;
            /*display: inline-block;*/
            background-color: transparent;
            background-image:url(images/buttons/button3.png);
        }
        .turn_off{
            width:85px;
            height:40px;
            float: right;
            margin: 0px;
            /*margin-right: 90px;*/
            border: none;
            background-repeat: no-repeat;
            cursor: pointer;
            margin-top: 3px;
            background-position: right top ;
            /*display: inline-block;*/
            background-color: transparent;
            background-image:url(images/buttons/button5.png);
        }
        .save{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .remove{

            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);

        }
        .titlebar {
            background-image: url(images/title_bar.png);
            background-position-x: 50%;
            background-position-y: 50%;
            background-size: initial;
            background-repeat-x: repeat;
            background-repeat-y: no-repeat;
            background-attachment: initial;
            background-origin: initial;
            background-clip: initial;
            background-color: rgb(204, 204, 204);
        }

    </style>
    <BODY>  
        <FORM NAME="UNITS_FORM" id="UNITS_FORM" METHOD="POST">
            <%
                if (garage != null) {
            %>
            <input type="hidden" name="garage" value="<%=garage%>"/>
            <%
                }
            %>
            <FIELDSET class="set" style="width:85%;border-color: #006699" >
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <b><font color="black" size="4"><%=title%><font color="#005599" size="4"><%=project.getAttribute("projectName")%></font></font></b>
                        </td>
                    </tr>
                </table>
                <input type="hidden" id="modelId" name="modelId" value="<%=project.getAttribute("projectID").toString()%>"/>
                <br><br>
                <center>
                    <% if ((status != null && !status.equals("") && status.equals("no")) || (status == null)) {%>
                    <TABLE class="blueBorder" align="center" width="60%" cellpadding="0" cellspacing="0" style="background-color: #E6E6FA;">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;height: 50px" width="100%">
                                <button style="width: 120px;"   onclick="JavaScript:  getUnits();" class="button">
                                    <IMG HEIGHT="17" SRC="images/database_orange.png"> &nbsp;Materialize
                                </button>
                            </TD>
                        </TR>
                    </TABLE> 
                    <% } else if(dataSaved != null && dataSaved.equalsIgnoreCase("Ok")) { %>
                    <TABLE class="blueBorder" align="center" width="60%" cellpadding="0" cellspacing="0" style="background-color: #E6E6FA;">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;height: 50px" width="100%">
                                <b style="color: blue; font-size: large;"><%=saveMessage%></b>
                            </TD>
                        </TR>
                    </TABLE> 
                    <% } %>
                    <br/><br/>
                    <TABLE class="backgroundTable" width="60%" CELLPADDING="0" CELLSPACING="12" ALIGN="CENTER" style="border-color: #006699; border-width: 1px">
                        <%
                            for (int x = 0; x < new Integer(rows); x++) {
                               int z =0 ;
                                if(x==0){
                                     z =  (x );
                                }else{
                                      z = 100 * (x);

                                }
                        %>
                        <tr>
                            <% for (int y = 0; y < new Integer(flats); y++) {
                                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                                    Vector unitsVec = projectMgr.getOnArbitraryDoubleKey(project.getAttribute("projectID").toString(), "key2", (z + y + 1) + "", "key7");
                                    WebBusinessObject unitWbo = new WebBusinessObject();
                                    if (unitsVec.size() > 0) {
                                        unitWbo = (WebBusinessObject) unitsVec.get(0);
                                    }
                                    String url = "#";
                            %>
                            <td style="width:10%;height:50px;background-color:white;border: none;">
                                <a href="<%=url%>">
                                    <%if(x == 0){%>
                                         <b><font color="#005599" size="4">A.00<%=z + y + 1%></font>&nbsp;&nbsp;

                                    <%}else{%>
                                         <b><font color="#005599" size="4">A.<%=z + y + 1%></font>&nbsp;&nbsp;
                                    <%}%>
                                    <div style="height:100%;width:100%;" >
                                        <% if ((status != null && !status.equals("") && status.equals("no")) || status == null) {%>
                                        <img src="images/house.JPG"/>
                                        <%} else if (status != null && !status.equals("") && status.equals("ok")) {
                                            Vector statusV = new Vector();
                                            statusV = issueStatusMgr.getOnArbitraryKey((String) unitWbo.getAttribute("projectID"), "key1");
                                            if ((statusV.size() > 0 && statusV.size() == 1) || dataSaved != null) {
                                        %>
                                        <img src="images/available_house.JPG"/>
                                        <% } else { %>
                                        <img src="images/reserved_house.JPG"/>
                                        <% }
                                            } %>
                                    </div>
                                    </b>
                                </a>
                            </td>
                            <%}%>
                        </tr>
                        <%}%>
                    </table>
                    <br />
                </center>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>