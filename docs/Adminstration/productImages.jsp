<%@page import="com.docviewer.common.DVAppConstants"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%


    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String status = (String) request.getAttribute("status");

    WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    Vector mainProjectVec = null;
    ArrayList mainProjectList = null;
    String defaultLocationName = null;

    String isSubProject = (String) request.getAttribute("isSubProject");

    // is a sub project
    if (isSubProject.equalsIgnoreCase("yes")) {
        mainProjectVec = (Vector) request.getAttribute("mainProjectVec");
        mainProjectList = new ArrayList(mainProjectVec);
        defaultLocationName = (String) request.getAttribute("defaultLocationName");

    }

    String OldProjectName = null;
    OldProjectName = (String) project.getAttribute("projectName");
    ArrayList locationTypesList = (ArrayList) request.getAttribute("locationTypesList");

    String isMngmntStn = "", isTrnsprtStn = "";

    if (project.getAttribute("isMngmntStn").equals("1")) {
        isMngmntStn = "checked";

    }

    if (project.getAttribute("isTrnsprtStn").equals("1")) {
        isTrnsprtStn = "checked";

    }

    DVAppConstants appCons = new DVAppConstants();
    Vector imagePath = (Vector) request.getAttribute("imagePath");
    Vector docList = (Vector) request.getAttribute("data");
    String[] docAttributes = {"docTitle", "docDate", "configItemType"};
    String[] docTitles = appCons.getDocHeaders();

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;


    String doubleName = (String) request.getAttribute("name");
    String type = "";
    try {
        type = request.getAttribute("type").toString();
    } catch (Exception ex) {
    }

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new project</TITLE>
        <script type="text/javascript" src="js/fancy/lib/jquery-1.9.0.min.js"></script>

        <!-- Add mousewheel plugin (this is optional) -->
        <script type="text/javascript" src="js/fancy/lib/jquery.mousewheel-3.0.6.pack.js"></script>

        <!-- Add fancyBox main JS and CSS files -->
        <script type="text/javascript" src="js/fancy/jquery.fancybox.js?v=2.1.4"></script>
        <link rel="stylesheet" type="text/css" href="js/fancy/jquery.fancybox.css?v=2.1.4" media="screen" />

        <!-- Add Button helper (this is optional) -->
        <link rel="stylesheet" type="text/css" href="js/fancy/helpers/jquery.fancybox-buttons.css?v=1.0.5" />
        <script type="text/javascript" src="js/fancy/helpers/jquery.fancybox-buttons.js?v=1.0.5"></script>

        <!-- Add Thumbnail helper (this is optional) -->
        <link rel="stylesheet" type="text/css" href="js/fancy/helpers/jquery.fancybox-thumbs.css?v=1.0.7" />
        <script type="text/javascript" src="js/fancy/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>

        <!-- Add Media helper (this is optional) -->
        <script type="text/javascript" src="js/fancy/helpers/jquery.fancybox-media.js?v=1.0.5"></script>

        <script type="text/javascript">
            $(document).ready(function() {
                //                $.fancybox.play();
                //
                $(".fancybox").fancybox({
                    openEffect	: 'elastic',
                    closeEffect	: 'elastic',

                    maxWidth	: 800,
                    maxHeight	: 600,
                    fitToView	: false,
                    width:600,
                    autoSize	: false,
                    closeClick	: false
                  
                });
                //              /  $(".fancybox-effects-a").fancybox();
             
       
            });
        </script>

    </HEAD>

    <BODY>


        <div style="position: absolute;margin-right: auto; margin-left: auto;margin-top: 250px;background-color: #FFCC66">
            <%for (int i = 0; i < imagePath.size(); i++) {%>
            <a  class="fancybox" id="erdf" href="<%=imagePath.get(i)%>">


                <img src="<%=imagePath.get(i)%>" alt="" width="50" height="50" />

            </a>
            <%}%>
        </div>
    </BODY>
</HTML>     