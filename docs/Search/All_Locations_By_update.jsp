<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page  pageEncoding="UTF-8" %>
<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();

    /**
     * ****** Get Request data *******
     */
    String mainLocation = (String) request.getAttribute("mainLocation");
    if (mainLocation == null) {
        mainLocation = "";
    }

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList getallLocation = projectMgr.getAllAsArrayList();
    /**
     * ****** End Of Get Request data *******
     */
    WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

    // get current date


    String context = metaMgr.getContext();

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, save, Basic_Data, back, mainCategoryTypeStr;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";

        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        save = "Save";
        mainCategoryTypeStr = "Select Main Site";
        Basic_Data = "New Equipment - <font color=#F3D596>Basic Data</font>";
        back = "Cancel";

    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        mainCategoryTypeStr = "إختار الموقع الرئيسى";
        save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
        Basic_Data = "&#1605;&#1593;&#1583;&#1577; &#1580;&#1583;&#1610;&#1583;&#1577; - <font color=#F3D596>&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577;</font>";
        back = tGuide.getMessage("cancel");

    }
%>




<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>عرض شجرة المواقع</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css">
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css">
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>
        <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/jquery-1.5.min.js"></script>
        <script type="text/javascript">

            function sendInfo(Name ,Id){
                if(window.opener.PROJECTS_FORM){
                    window.opener.PROJECTS_FORM.alterMainProjectName.value=Name;
                    var x=window.opener.PROJECTS_FORM;
                    $(x).find("#mainProjectName").attr("title",Name);
                    $(x).find("#mainProjectName").css("background-color","");
                    window.opener.PROJECTS_FORM.alterMainProjectId.value=Id;

                    self.close();
                    
                }
                if(window.opener.MOVE_MULTI_FILE){
                    window.opener.MOVE_MULTI_FILE.alterMainProjectName.value=Name;
                    var x=window.opener.MOVE_MULTI_FILE;
                    $(x).find("#mainProjectName2").attr("title",Name);
                    $(x).find("#mainProjectName2").css("background-color","");
                    window.opener.MOVE_MULTI_FILE.alterMainProjectId.value=Id;

                    self.close();
                }
               
            }
        </script>


        <style type="text/css" >
            .boldFont {
                color: black;
                font-weight: bold;
            }
            #inserRows tr th{
                padding: 10px;
                margin :10px;
            }
            .fontInput {
                width: 80%;
                font-size: 12px;
                font-weight: bold;
            }
        </style>
    </HEAD>
    <body>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <DIV id="loadBrand" align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px; padding-top: 10px">
            <input type="button" value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            &ensp;
            <button  onclick="self.close();" class="button"><%=back%></button>

        </DIV>
    <CENTER>

        <table width="100%">
            <tr>
                <td valign="middle" width="40%" bgcolor="#E8E8E8" style="padding: 50px;">
                    <div align ="left">
                        <%--<script type="text/javascript">
                            <!--
                            d = new dTree('d');
                            d.add(0,-1,'المواقع الرئيسية');
                            <%
                                int size = 1;
                                int parent = 1;
                                 for (int i = 0; i < getallLocation.size(); i++) {
                                String nameParent = ((WebBusinessObject)getallLocation.get(i)).getAttribute("mainProjId").toString();
                                System.out.println("getProjName"+nameParent);
                                  if(((WebBusinessObject)getallLocation.get(i)).getAttribute("mainProjId").equals("0")){%>
                                      d.add(<%=size%>,0,'<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectName")%>',"javascript:sendInfo('<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectName")%>','<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectID")%>');",'parent','<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectID")%>');
                                    <%                   
                                     size++;
                                     Vector childNode = new Vector();
                                        try{
                                         childNode = projectMgr.getOnArbitraryKey(((WebBusinessObject)getallLocation.get(i)).getAttribute("projectID").toString(), "key2");
                                         if(childNode.size()>0){
                                             System.out.println("have child Sites");
                                             for(int j=0;j<childNode.size();j++){
                                            %>
                                         d.add(<%=size%>,<%=parent%>,'<%=((WebBusinessObject)childNode.get(j)).getAttribute("projectName")%>',"javascript:sendInfo('<%=((WebBusinessObject)childNode.get(j)).getAttribute("projectName")%>','<%=((WebBusinessObject)childNode.get(j)).getAttribute("projectID")%>');",'child','<%=((WebBusinessObject)childNode.get(j)).getAttribute("projectID")%>');
                                           <%size++; }}else{
                                             System.out.println("Not Have Sites");
                                             }
                                        }catch(Exception exc){
                                            System.out.println(exc.getMessage());
                                         } 
                                    parent=size;
                                    }}%>
                                d.openAll();
                                document.write(d);
                              
                        </script>

                        --%>
                        <script type="text/javascript">
                            <!--
                            d = new dTree('d');
                            d.add(0,-1,'المواقع الرئيسية');
                            <%
                                ArrayList<WebBusinessObject> list = (ArrayList<WebBusinessObject>) request.getAttribute("list");

                                WebBusinessObject pwbo = new WebBusinessObject();

                                int size = 1;
                                int parent = -1;
                                for (int i = 0; i < list.size(); i++) {
                                    pwbo = ((WebBusinessObject) list.get(i));
                                    String projectName = pwbo.getAttribute("projectName").toString();
                                    String projectID = pwbo.getAttribute("projectID").toString();
                                    size = Integer.parseInt(pwbo.getAttribute("size").toString());
                                    parent = Integer.parseInt(pwbo.getAttribute("parent").toString());
                                    /*pwbo.setAttribute("size", size);
                                     pwbo.setAttribute("parent", parent);*/

                            %>

                                d.add(<%=size%>,<%=parent%>,'<%=projectName%>',"javascript:sendInfo('<%=projectName%>','<%=projectID%>');",'parent','<%=projectID%>');


                            <%}%>
                                d.openAll();
                                document.write(d);

                        </script>
                    </div>
                </td>
                <td valign="top">
                    <div id="viewer"></div>
                </td></tr>
        </table>

    </CENTER>
</body>
</html>