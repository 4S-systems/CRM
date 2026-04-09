<%@page import="com.silkworm.util.ServletUtils"%>
<%@page import="com.maintenance.common.UserGroupConfigMgr"%>
<%@page import="com.silkworm.db_access.PersistentSessionMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="com.maintenance.common.ParseSideMenu"%>
<%@ page import="com.silkworm.business_objects.secure_menu.*,com.silkworm.business_objects.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.common.*,com.maintenance.db_access.*,com.tracker.db_access.ProjectMgr"%>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Main.Main"  />
    <%
        response.addHeader("Pragma", "No-cache");
        response.addHeader("Cache-Control", "no-cache");
        response.addDateHeader("Expires", 1);
        UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
        CampaignMgr campaignMgr = CampaignMgr.getInstance();
        GroupMgr groupMgr = GroupMgr.getInstance();
        UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
        HttpSession s = request.getSession();
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String context = metaDataMgr.getContext();
        ServletContext c = s.getServletContext();
  String lang = (String) request.getSession().getAttribute("currentMode");
        ArrayList<WebBusinessObject> messagesList = new ArrayList<>();
        if (session.getServletContext().getAttribute("messagesList") != null) {
            messagesList = ServletUtils.getApplicationMessages(session);
        }
  
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }
        
        boolean displayAutoPilot = false;
        boolean displayCallCenter = false;
        boolean displayCampaign = false;
        boolean displayBranch = false;

        String companyName = metaDataMgr.getCompanyNameForLogo();
        String managerName = "غير محدد";
        String departmentTitle = "المدير";
        WebBusinessObject loggedUser = PersistentSessionMgr.getInstance().getOnSingleKey(request.getSession().getId());
        if (loggedUser != null)
        {

            ArrayList<WebBusinessObject> toolsList;
            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            ArrayList<WebBusinessObject> prevList = securityUser.getComplaintMenuBtn();
            for (WebBusinessObject prevWbo : prevList)
            {
                if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("SHOW AUTO-PILOT"))
                {
                    displayAutoPilot = true;
                }
                else if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("SHOW CALL CENTER"))
                {
                    displayCallCenter = true;
                }
                else if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("SHOW CAMPAIGN"))
                {
                    displayCampaign = true;
                }
                else if (((String) prevWbo.getAttribute("prevCode")).equalsIgnoreCase("SHOW BRANCH"))
                {
                    displayBranch = true;
                }
            }
            String userId = (String) loggedUser.getAttribute("userId");
            String groupId = securityUser.getUserGroupId();;
            Vector<WebBusinessObject> userGroups = securityUser.getUserGroup();
            String projectId = securityUser.getSiteId();
            List<WebBusinessObject> userProjects;
            List<WebBusinessObject> groups;
            if (displayAutoPilot)
            {
                groups = userGroupConfigMgr.getAllUserGroupConfig(userId);
            }
            else
            {
                groups = new ArrayList<>();
            }
            if (displayCampaign)
            {
                toolsList = new ArrayList<>(campaignMgr.getOnArbitraryKeyOracle("16", "key4"));
                toolsList.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));
            }
            else
            {
                toolsList = new ArrayList<>();
            }
            if (displayBranch)
            {
                userProjects = securityUser.getUserProjects();
            }
            else
            {
                userProjects = new ArrayList<>();
            }
            boolean isSuperUser = securityUser.isSuperUser();

            Vector sideMenuVec = new Vector();
            sideMenuVec = (Vector) s.getAttribute("sideMenuVec");

            Hashtable topMenu = new Hashtable();
            topMenu = (Hashtable) s.getAttribute("topMenu");

            String userName = securityUser.getFullName();

            // to get the manager
//            UserMgr userMgr = UserMgr.getInstance();
//            WebBusinessObject mng = userMgr.getManagerByEmployeeID(userId);
            if (securityUser.getManagerName() != null)
            {
                managerName = securityUser.getManagerName();
            }
            else
            {
                if (securityUser.getDepartmentName() != null)
                {
                    managerName = securityUser.getDepartmentName();
                    if (lang.equalsIgnoreCase("Ar")) departmentTitle = "الأدارة";
                    else departmentTitle="Managment";
                }
            }

            if (userName.length() > 20)
            {
                userName = userName.substring(0, 5) + "..." + userName.substring(userName.length() - 5);
            }

            ThreeDimensionMenu tdm = (ThreeDimensionMenu) c.getAttribute("myMenu");
            ArrayList menuBody = tdm.getContents();

            Vector vecBuild = metaDataMgr.getVecBuild();
            String sBuild = new String("");
            for (int i = 0; i < vecBuild.size(); i++)
            {
                if (i == 0)
                {
                    sBuild = ((String) vecBuild.get(i));
                }
                else
                {
                    sBuild = sBuild + "\n" + ((String) vecBuild.get(i));
                }
            }
             System.out.println("currentMode="+lang);
            String align = new String("LEFT");
            String dir = new String("rtl");
            String backImage = new String("En_blue_sub_menu_bg.png");
            String sFontSize = new String("11");

            String filter, cancelFilter, menulang, lastJo, lastEqp, lastMItem, lastSch;
            String  sLogOut, sMainPage, initInspections, inspection;
            String langCode,langtittle, bookmarks;

             if (lang == null)
            {
                lang = new String("En");
            }
            if (lang.equalsIgnoreCase("Ar"))
            {
                align = new String("RIGHT");
                dir = "ltr";
                 backImage = new String("Ar_blue_sub_menu_bg.png");
                sFontSize = new String("14");
                menulang = "ar";
                langCode = "En";
                langtittle="English";
                departmentTitle= "المدير";
                filter = "&#1571;&#1582;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1585; &#1576;&#1600;&#1600;&#1600;&#1581;&#1600;&#1600;&#1600;&#1600;&#1579;";
                cancelFilter = "&#1573;&#1604;&#1600;&#1600;&#1600;&#1594;&#1600;&#1600;&#1600;&#1600;&#1575;&#1569; &#1575;&#1604;&#1600;&#1600;&#1602;&#1600;&#1600;&#1575;&#1574;&#1600;&#1600;&#1605;&#1600;&#1600;&#1600;&#1607;";
                lastEqp = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1571;&#1582;&#1585; &#1605;&#1593;&#1583;&#1607;";
                lastJo = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1582;&#1585; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604;";
                lastMItem = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1582;&#1585; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607;";
                lastSch = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1582;&#1585; &#1580;&#1583;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1607;";
                  sLogOut = "&#1582;&#1585;&#1608;&#1580;";
                sMainPage = "&#1575;&#1604;&#1589;&#1601;&#1581;&#1577; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
                initInspections = "&#1593;&#1585;&#1590; &#1575;&#1582;&#1585; &#1591;&#1604;&#1576;&#1575;&#1578; &#1601;&#1581;&#1589;";
                inspection = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1582;&#1585; &#1591;&#1604;&#1576; &#1601;&#1581;&#1589;";
                bookmarks = "علاماتي";
            }
            else
            {
                align = new String("LEFT");
                menulang = "en";
                langCode = "Ar";
                langtittle="العربية";
                departmentTitle="Manager";
                filter = "Last Filter";
                cancelFilter = "Cancel Filter";
                lastEqp = "View Last Equipment";
                lastJo = "View Last Job Order";
                lastMItem = "View Last Maint. Item";
                lastSch = "View Last Schedule";
                 sLogOut = "Logout";
                sMainPage = "Home";
                initInspections = "View Last Order Inspections";
                inspection = "View Last Inspection";
                bookmarks = "My Bookmarks";
            }

            Vector menuElements = new Vector();
            String keys[] =
            {
                "jobOrder", "task", "schedule", "equipment", "lastFilter", "inspection", "initInspections"
            };
            String names[] =
            {
                lastJo, lastMItem, lastSch, lastEqp, filter, inspection, initInspections
            };

            Vector tempVec = new Vector();
            Vector elemVec = new Vector();
            if (topMenu != null && topMenu.size() > 0)
            {
                for (int n = 0; n < keys.length; n++)
                {
                    tempVec = new Vector();
                    tempVec = (Vector) topMenu.get(keys[n]);
                    if (tempVec != null && tempVec.size() > 0)
                    {
                        elemVec = new Vector();
                        elemVec.add(names[n]);
                        elemVec.add(tempVec.get(1));
                        menuElements.add(elemVec);
                    }
                }
            }

            // setting campaign mode
            String playCampaignModeImg = "images/icons/circle_green.png";
            String stopCampaignModeImg = "images/icons/circle_red.png";
            String playCampaignModeTitle = "Campaign Mode is Running";
            String StropCampaignModeTitle = "Campaign Mode is Stoped";
            String campaignModeTitle = (securityUser.isCanRunCampaignMode()) ? playCampaignModeTitle : StropCampaignModeTitle;
            String campaignModeImg = (securityUser.isCanRunCampaignMode()) ? playCampaignModeImg : stopCampaignModeImg;
            boolean isCanRunCampaignMode = userGroupMgr.isUserHasGroup(userId, CRMConstants.SALES_MARKTING_GROUP_ID);
    %>
    <HEAD>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/HTML  charset=UTF-8">
        <link rel="Shortcut Icon" href="images/gear.gif" />
        <TITLE>Main Menu</TITLE>

        
        <script type="text/javascript" src="scripts/jquery-1.4.3.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
         <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"></link> 
         
         
          <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"></link>   
        
          
    	 <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.position.js"></script>  

        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js"></script>
        <script src="js/mmenu.js" type="text/javascript"></script>
        <script src="js/ajax_view_image.js" type="text/javascript"></script>

        <SCRIPT LANGUAGE="JavaScript" SRC="js/CustomDialog.js" TYPE="text/javascript" />
        <SCRIPT LANGUAGE="JavaScript" SRC="Library.js" TYPE="text/javascript"></SCRIPT>
        
        <script src="js/GetSelectedRadioButtonOrCheckBox.js" TYPE="text/javascript"></script>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/calendar.js" TYPE="text/javascript"></SCRIPT>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/date-functions.js" TYPE="text/javascript"></SCRIPT>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/datechooser.js" TYPE="text/javascript"></SCRIPT>
        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/validator.js" TYPE="text/javascript"></SCRIPT>
        <SCRIPT type="text/javascript" LANGUAGE="JavaScript"></SCRIPT>
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="<%=menulang%>/c_config.js"></script>
        <script type="text/javascript" src="<%=menulang%>/c_smartmenus.js"></script>
        <script type="text/javascript" language="javascript" src="js/notifications/toastr.js"></script>
        <link href="js/pnotify/jquery.pnotify.default.css" media="all" rel="stylesheet" type="text/css" />
        <link href="js/pnotify/jquery.pnotify.default.icons.css" media="all" rel="stylesheet" type="text/css" />
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css" />
        <link REL="stylesheet" TYPE="text/css" HREF="css/Button.css" />
        <link REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css" />
        <link rel="stylesheet" type="text/css" href="css/datechooser.css" />
        <link rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <link rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <link rel="stylesheet" href="jquery-ui/demos/demos.css" />
        <link rel="stylesheet" type="text/css" href="js/notifications/bootstrap-combined.min.css">
        <link rel="stylesheet" type="text/css" href="js/notifications/toastr.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Google+Sans:ital,opsz,wght@0,17..18,400..700;1,17..18,400..700&family=Noto+Naskh+Arabic:wght@400..700&display=swap" rel="stylesheet">
     <!-- Bootstrap CSS -->
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
  rel="stylesheet">

        <style type="text/css" >
/*            .summary_td {
                border: 1px solid #C3C6C8; 
                border-right-width: 0px; 
              
                font-size: 10px; 
                color: #666666; 
                padding: inherit; 
                height: 16px; 
                color: black; 
                text-align: center; 
                font-weight: capitalize;
                width:110px;
            }*/
            #slidemenubar, #slidemenubar2{
                position:absolute;
                border:1px solid black;
                line-height:10px;
            }

            #slidemenubar3, #slidemenubar4{
                position:absolute;
                border:1px solid black;
                line-height:10px;
            }

/*            #menu01 a {color:black;font-size:10pt;font-weight:bold;font-family:Times New Roman;padding-<%=align%>:10px;background-color:#99C1D6;text-decoration:none;text-indent:1px;}
            #menu01 a:active {color:black;text-decoration:none;}
            #menu01 a:hover {color:black;background-color:#94DBFF;font-size:12pt}
            #menu01 a:visited {color:black;text-decoration:none;}

            #menu02 a {color:navy;background-color:white;padding-<%=align%>:10px;text-decoration:none;text-indent:1ex;}
            #menu02 a:active	{color:blue;text-decoration:none;}
            #menu02 a:visited {color:blue;text-decoration:none;}
            #menu02 a:hover {color:red;background-color:#f0fea8}

            .menuHead {
                width:131px;
                position: absolute;
                <%=align%>:220px;
                top:130px;
                display:block;
                background-color:#CFE2D1;
                color:#035899;
                z-index:1000;
            }

            .menuTitle {
                height:30px;
                border: 1px solid  #202020;
                border-bottom: 0px;
                 border: 1px solid rgb(153, 153, 153);
                padding-top:3px;
                padding-left:3px;
                background-image: url(images/Ar_blue_menu_bg.png);
                  background-color: #3b5998;
                color:#035899;
                font-weight:bold;
                font-size:<%=sFontSize%>;
                cursor:pointer;
            }

            .menuSubTitle {
                height:20px;
                font-weight:bold;
                font-size:<%=sFontSize%>;
                cursor:pointer;
            }*/

            .emptyCell {
                color:#ffffff
            }
            .dataCell {
                height:80%;
                width:100%;
                display:block;
                color:#035899;
                cursor:pointer;
            }

            .side { }

            .menuBody {
                border:1px solid;
                background: #ffffff url(images/<%=backImage%>) repeat <%=align%>
            }

            tdCell {
                border: 1px solid #202020; 		/* border color set here C3C6C8*/
                font-family:arial,verdana,tahoma, sans-serif;	/*Page Font*/
                font-size:11px; 				/*Page Font size, in font points*/
                background-color:#e3f1bd;
                text-align:center;
            }

            html,body {

                height:96%;
                margin: 0px 0px 0px 0px ;
                padding: 0px 0px 0px 0px ;
                font-family:  Amiri ;
             font-family: "Google Sans", sans-serif;;
            }

            #site-body-content {
                padding: 15px 15px 15px 15px ;

            }

            #site-bottom-bar {
                margin:auto;
                bottom: 0px ;
                font-family:  Amiri ;
                /*font-size: 11px ;*/
                height: 30px ;
                width: 96% ;

            }


     #site-bottom-bar-frame {
    height: 30px;
    /* width: 1000px; */
    padding-right: 0px;
    padding-left: 0px;
    
    margin: auto;
    background: #27272a;
}

            #site-bottom-bar-content {

            }
            a {font-size:12px;font-weight:bold; }
            a:active {font-size:12px;font-weight:bold;}
            /*#menu01 a:hover {color:black;background-color:#FFFF99;font-size:12pt}*/
            a:hover {font-size:12px;font-weight:bold;}
            a:visited { font-size:12px;font-weight:bold;}
            /* -------------------------------------------------- */
            /* -- IE 6 FIXED POSITION HACK ---------------------- */
            /* -------------------------------------------------- */

            textarea{
                resize:none;
                white-space: pre-line;
            }
     
 
            /* شكل الخلية نفسها */
.legacy-td {
    padding: 6px 8px;
    border-radius: 6px;
    transition: background-color 0.2s ease;
}

/* الهوفر على الخلية */
.legacy-td:hover {
    background-color: #ffffff;
}

/* الأيقونة */
.legacy-td img {
    transition: filter 0.2s ease;
}

/* نخلي الأيقونة سودا عند الهوفر */
.legacy-td:hover img {
    filter: brightness(0) saturate(100%);
}

/* Sidebar menu */
.sidebar-menu { position: fixed; top: 0px; bottom: 0; width: 240px; border: 1px solid #4f6582; background-color:#27272A;  z-index: 1030; padding: 8px; }
.sidebar-inner { overflow-y: auto; max-height: 100%;  }
.sidebar-inner a { display: block; padding: 6px 10px;   font-family: "Google Sans", sans-serif !important;  }
.sidebar-inner a:hover { background-color: #94DBFF; }
/* Sidebar menu layout fixes */
.sidebar-inner ul.MM { list-style: none; margin-top: 10px !important; padding: 0 !important; display: flex; flex-direction: column; gap: 4px; }
.sidebar-inner ul.MM > li { display: block; }
/* Sidebar menu item look */
.sidebar-inner ul.MM > li > a { display: block; color: #ffffff !important;    border-radius: 7px; padding: 10px 5px; font-size:16px;  }
.MM li a:visited{border: none;}
.MM li a, .MM li a:link{border: none;}
/* Submenus: default hidden, show on hover; override inline styles */
.sidebar-inner ul.SM { list-style: none; margin: 4px 0 8px 12px !important; border:none;  background-color:#27272A; padding: 0 !important; display: none !important; visibility: hidden !important; position: static !important; width: auto !important; }
/*.sidebar-inner li:hover > ul.SM { display: block !important; visibility: visible !important;  border:none; }*/
/* Offset page content to avoid overlap with fixed sidebar (current align=LEFT) */
body { padding-left: 260px; }

/* Sidebar menu background resets for items */
.sidebar-inner ul.MM > li,
.sidebar-inner ul.MM > li > a,
.sidebar-inner ul.SM > li,
.sidebar-inner ul.SM > li > a { background: none !important; background-image: none !important; }


.sidebar-inner ul.MM > li > a:hover { background-color: #3F3F47 !important; border:none;}
/* Submenu items */
.sidebar-inner ul.SM > li > a { color: #ffffff !important;    border-radius: 7px; padding: 10px 5px; font-size:13x; }
.sidebar-inner ul.SM > li > a:hover { background-color: #3F3F47 !important; border:none; }
/* Sidebar summary card */
/*.sidebar-summary { margin-bottom: 8px; border: 1px solid rgba(255,255,255,0.18); background-color: rgba(10,20,35,0.35); border-radius: 8px; padding: 8px; color: #e7f7fb; }
.sidebar-summary .summary_td { background: transparent !important; border: 1px solid rgba(255,255,255,0.12) !important; color: #e7f7fb !important; font-size: 10px !important; }
.sidebar-summary b { color: #e7f7fb; }
.sidebar-summary a { color: #94DBFF !important; }
 Fix sidebar horizontal overflow 
.sidebar-menu, .sidebar-inner { overflow-x: hidden; }
.sidebar-summary { box-sizing: border-box; }
.sidebar-summary table { width: 100% !important; max-width: 100%; table-layout: fixed; border-collapse: collapse; }
.sidebar-summary td, .sidebar-summary th { max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }*/

.sidebar-summary {
    background-color: rgba(10,20,35,0.35);
    border: 1px solid rgba(255,255,255,0.18);
    border-radius: 8px;
    padding: 10px;
    color: #e7f7fb;
    position: relative;
    width: 220px;
    font-family: "Segoe UI", sans-serif;
}

.user-info {
    display: flex;
    align-items: center;
    cursor: pointer;
}

.user-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%; /* circle */
    margin-right: 10px;
    object-fit: contain;
    border: 2px solid #94DBFF;
}

.user-text {
    display: flex;
    flex-direction: column;
    margin-top: 5px;
    text-align: left;
}

.user-name {
    font-weight: bold;
    font-size: 14px;
    color: #fff;
}

.user-manager {
    font-size: 12px;
    color: #ccc;
}

/* popup مخفي افتراضياً */
.user-popup {
    display: none;
    position: absolute;
    top: 60px; /* أسفل الاسم */
    left: 50%;
    transform: translateX(-50%);
    background-color: rgba(20,30,50,0.95);
    color: #fff;
    border: 1px solid rgba(255,255,255,0.2);
    border-radius: 6px;
    padding: 10px;
    z-index: 200;
    width: 200px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.4);
}

.user-info:hover + .user-popup {
    display: block;
}

.user-popup table {
    width: 100%;
    border-collapse: collapse;
}

.user-popup td {
    padding: 3px 5px;
    font-size: 12px;
    color: #e7f7fb;
}


.sidebar-inner ul.MM, .sidebar-inner ul.SM { width: 100%; max-width: 100%; }
.sidebar-inner ul.MM > li, .sidebar-inner ul.SM > li { max-width: 100%; }
.sidebar-inner ul.MM > li > a, .sidebar-inner ul.SM > li > a { display: block; box-sizing: border-box; width: 100%; }

/* remove old arrows and plus icons */
.sidebar-inner img[src*="arrow"],
.sidebar-inner img[src*="other"],
.sidebar-inner .MMS,
.sidebar-inner .SMS {
    display: none !important;
}

/* ====== LINKS ====== */
.sidebar-inner a {
    font-family: "Google Sans", "Segoe UI", Tahoma, sans-serif;
    font-size: 12px;
    font-weight: 400;
    color: #fff !important;
    text-decoration: none;
    display: block;
}

/* ====== MAIN ITEM ====== */
.sidebar-inner ul.MM > li > a {
    padding: 10px 14px;
    border-radius: 8px;
}

/* ====== SUB ITEM ====== */
.sidebar-inner ul.SM > li > a {
    padding: 8px 20px;
    font-size: 13px;
    font-weight: 500;
}

/* ====== HOVER (شكل فقط) ====== */
.sidebar-inner a:hover {
    background-color: #3F3F47;
}

/* ====== ARROW ====== */
.sidebar-inner ul.MM > li > a::after {
    content: "›";
    float: right;
    font-size: 14px;
    opacity: .7;
    transition: transform .25s ease;
}

.sidebar-inner li.open > a::after {
    transform: rotate(90deg);
}
/* arrow only for submenu items that have a nested submenu */
.sidebar-inner ul.SM > li:has(ul) > a::after {
    content: "›";      /* السهم */
    float: right;
    font-size: 12px;
    opacity: .6;
    transition: transform .25s ease;
}

/* rotate arrow when open */
.sidebar-inner ul.SM > li.open:has(ul) > a::after {
    transform: rotate(90deg);
}



/* ====== SUBMENU CONTROL (CLICK ONLY) ====== */
.sidebar-inner li > ul {
    display: none;
}


.sidebar-inner li.open > ul {
    display: block !important;
}
/* Submenus click-only */
.sidebar-inner li > ul.SM {
    display: none; /* اخفاء افتراضي */
}

.sidebar-inner li.open > ul.SM {
    display: block !important; /* الظهور عند الضغط */
    visibility: visible !important;
}
#Main_Menu1 > li:first-child {
     margin-left: 0em !important; 
}
.sidebar-inner {
    overflow-y: scroll; /* خلي الـ content scrollable */
    scrollbar-width: none; /* Firefox */
}

.sidebar-inner::-webkit-scrollbar {
    display: none; /* Chrome, Safari, Edge */
}
        </style>
   <link REL="stylesheet" TYPE="text/css" HREF="css/crmStyle.css" />
        <script type="text/javascript" >

function changeLang(nextmode,context) {
    console.log(nextmode);
    $.ajax({
        type : 'post',
        url  :  context+ '/ajaxGetItrmName',
        data : 'key=' + nextmode,
        success: function () {
                   location.reload();
        },
                error: function () {
                         console.log("error");
                    }
    });
    
}
            var stack_bar_bottom = {"dir1": "up", "dir2": "left", "spacing1": 0, "spacing2": 0, "firstpos1": 0, "firstpos2": 0};
            $(function () {
//                $.pnotify.defaults.styling = "jqueryui";
//                $.pnotify.defaults.history = false;
                userHasNewTickets();
            });
            function userHasNewTickets() {

                $.ajax({
                    type: "get",
                    cache: false,
                    url: "<%=context%>/ajaxServlet?op=userHasNewTickets",
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        if (data.userHasNewTickets == true) {
                            $.pnotify({
                                title: '\u062A\u0630\u0643\u0631\u0629',
                                text: '!\u0644\u062F\u064A\u0643 \u0634\u0643\u0627\u0648\u0649 \u062C\u062F\u064A\u062F\u0629',
                                stack: stack_bar_bottom,
                                addclass: "stack-bar-bottom",
                                animation: "slide",
                                delay: 5000
                            });
                        }

                    },
                    complete: function () {
                        // Schedule the next request when the current one's complete
                        setTimeout(userHasNewTickets, 60000);
                    }
                });
            }

            var i;
            var myclose = false;
            function closeApplication() {
                window.navigate("LogoutServlet");
            }

            function ConfirmClose() {
                if (event.clientY < 0) {
                    window.navigate("LogoutServlet");
                }
            }

            function HandleOnClose()
            {
                if (myclose == true)
                    window.navigate("LogoutServlet");
            }

            function show(no) {
                document.getElementById("groupA" + no).style.display = "block";
            }

            function showSubGroup(no, groupNo) {
                document.getElementById("subGroup" + groupNo + no).style.display = "block";
                document.getElementById("subGroup" + groupNo + no).style.top = document.getElementById("group" + groupNo + no).offsetTop; // + document.getElementById("groupA" + groupNo).offsetTop;
            }

            function hideSubGroup(no, groupNo) {
                document.getElementById("subGroup" + groupNo + no).style.display = "none";
            }

            function hide(no) {
                document.getElementById("groupA" + no).style.display = "none";
            }

            function overCell(elem) {
                elem.style.backgroundColor = "#3b5998";
                elem.style.borderRight = "1px solid";
                elem.style.borderLeft = "1px solid";
                elem.style.borderBottom = "1px solid";
                elem.style.borderTop = "1px solid";
            }

            function outCell(elem) {
                elem.style.backgroundColor = "";
                elem.style.borderRight = "";
                elem.style.borderLeft = "";
                elem.style.borderBottom = "";
                elem.style.borderTop = "";
            }

            function overCellFontChange(elem) {
                elem.style.color = "#F3D596";
            }

            function outCellFontChange(elem) {
                elem.style.color = "#000000";
            }

            function back(elem)
            {
                clearInterval(interval)
                elem.style.filter = false
            }

            function openUserData(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }

            function changeGroup(obj) {
                var groupId = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=changeDefaultGroup",
                    data: {groupId: groupId
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            location.href = '<%=context%>/main.jsp';
                        } else {
                            alert("failed to change group")
                        }

                    }
                });
            }

            function changePilotMode(val) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=changePilotMode",
                    data: {
                        modeValue: val
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            location.href = '<%=context%>/main.jsp';
                        } else {
                            alert("failed to change group")
                        }

                    }
                });
            }

            function changeBranch(obj) {
                var projectId = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=changeDefaultBranch",
                    data: {
                        projectId: projectId
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            location.href = '<%=context%>/main.jsp';
                        } else {
                            alert("failed to change group")
                        }

                    }
                });
            }

            function changeCampaignMode() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=changeCampaignMode",
                    data: {
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            location.href = '<%=context%>/main.jsp';
                        } else {
                            alert("failed to change campaign mode")
                        }
                    }
                });
            }

            function changeCampaign(obj) {
                var campaignId = $(obj).val();
                if (campaignId == '') {
                    $("#defaultCampaign").hide();
                }
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=changeDefaultCampaign",
                    data: {
                        campaignId: campaignId
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            if ($("#defaultCampaign")) {
                                if (info.campaignTitle == '') {
                                    $("#defaultCampaign").hide();
                                } else {
                                    $("#defaultCampaign").attr("title", "Campaign Name: " + info.campaignTitle);
                                    $("#defaultCampaign").show();
                                }
                            }
                        } else {
                            alert("failed to change campaign")
                        }

                    }
                });
            }
//           function changeCallcenterMode(obj) {
//             alert("callCenterMode")
//                var callCenterMode = $(obj).val();
//               
//                if (callCenterMode == '' || callCenterMode == 1) {
//                    $("#defaultCallCenter").hide();
//                }
//                var modeValue = $(obj).val();
//                $.ajax({
//                    type: "post",
//                    url: "<%=context%>/UsersServlet?op=changeCallcenterMode",
//                    data: {
//                        modeValue: modeValue
//                    },
//                    success: function(jsonString) {
//                        var info = $.parseJSON(jsonString);
//                        if (info.status == 'ok') {
//                            //Do nothing
//                      
//                        } else {
//                            $("#defaultCallCenter").hide();
//                            alert("Failed to change mode")
//                        }
//
//                    }
//                );
//            }
            function changeCallcenterMode(obj) {
                var modeValue = $(obj).val();
                var callCenterMode = $(obj).val();
//               
//                if (callCenterMode == '' || callCenterMode == 1) {
//                    $("#defaultCallCenter").hide();
//                }
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=changeCallcenterMode",
                    data: {
                        modeValue: modeValue
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            //Do nothing

                            if (info.callCenterMode == '1') {
                                $("#inbound").hide();
                                $("#outbound").hide();
                                $("#callDir").hide();
                                $("#meetDir").hide();
                                $("#interDir").hide();
                            } else if (info.callCenterMode == "2") {
                                $("#inbound").show();
                                $("#outbound").hide();
                                $("#callDir").show();
                                $("#meetDir").hide();
                                $("#interDir").hide();
                            } else if (info.callCenterMode == "3") {
                                $("#outbound").show();
                                $("#inbound").hide();
                                $("#callDir").show();
                                $("#meetDir").hide();
                                $("#interDir").hide();
                            } else if (info.callCenterMode == "4") {
                                $("#outbound").hide();
                                $("#inbound").show();
                                $("#callDir").hide();
                                $("#meetDir").show();
                                $("#interDir").hide();
                            } else if (info.callCenterMode == "5") {
                                $("#outbound").show();
                                $("#inbound").hide();
                                $("#callDir").hide();
                                $("#meetDir").show();
                                $("#interDir").hide();
                            } else if (info.callCenterMode == "6") {
                                $("#outbound").hide();
                                $("#inbound").show();
                                $("#callDir").hide();
                                $("#meetDir").hide();
                                $("#interDir").show();
                            }



                        } else {
                            alert("Failed to change mode")
                        }

                    }
                });
            }

            function changeAutoPilotMode(obj) {
                var modeValue = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=autoPilotMode",
                    data: {
                        modeValue: modeValue
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if ((info.status == 'ok') && ($(obj).val() != '-1')) {
                            $("#autoPilotIcon").show();
                            $("#autoPilotLabel").show();
                        } else if (info.status == 'ok') {
                            $("#autoPilotIcon").hide();
                            $("#autoPilotLabel").hide();
                        } else {
                            alert("failed to change auto pilot mode")
                        }
                    }
                });
            }

            resizereinit = true;
            <%
                int index = 1;
                if (sideMenuVec != null)
                {
                    Vector linkVec = new Vector();
                    int count = 0;
                    linkVec = new Vector();
                    Hashtable style = new Hashtable();
                    style = (Hashtable) sideMenuVec.get(0);
            %>
            menu[<%=index%>] = {
                id: 'menu01', //use unique quoted id (quoted) REQUIRED!!
                menutop: 200,
                fontsize: '103%', // express as percentage with the % sign
                linkheight: 22, // linked horizontal cells height
                hdingwidth: 190, // heading - non linked horizontal cells width
                hdingtxtalign: '<%=align%>', // heading - non linked horizontal cells right left or center text alignment
                linktxtalign: '<%=align%>', // linked horizontal cells right left or center text alignment
                barwidth: 35,
                //barbgcolor:'#4d6814',
                barbgcolor: '#006699',
                menufont: 'verdana', // menu font
                hdingfontsize: '15px',
                bartext: '<%=style.get("barText").toString()%>',
                // Finished configuration. Use default values for all other settings for this particular menu (menu[1]) ///
                menuItems: [// REQUIRED!!
                    //[name, link, target, colspan, endrow?] - leave 'link' and 'target' blank to make a header
                    ["<%=style.get("title").toString()%>"], //create header

            <% for (int i = 1; i < sideMenuVec.size() - 2; i++)
                {
                    count++;
                    linkVec = new Vector();
                    linkVec = (Vector) sideMenuVec.get(i);%>
                    ["<%=linkVec.get(0).toString()%>", "<%=linkVec.get(1).toString()%>", ""],
            <%
                }
                linkVec = new Vector();
                linkVec = (Vector) sideMenuVec.get(sideMenuVec.size() - 2);
            %>
                    ["<%=linkVec.get(0).toString()%>", "<%=linkVec.get(1).toString()%>", ""]
                ]
            }; // REQUIRED!! do not edit or remove

            <% index++;%>

            <% }
                if (menuElements != null && menuElements.size() > 0)
                {%>

            menu[2] = {// REQUIRED!!  This menu explicitly declares all available options even if they are the same as the defaults
                id: 'menu02',
                user_defined_stylesheet: false, //if true, prevents script from generating stylesheet for this menu
                user_defined_markup: false, //if true, prevents script from generating markup for this menu
                design_mode: false, //if true, generates a report of the script generated/intended styles and markup (as a design aid)
                menutop: 160, // initial top offset - except for top menu, where it is meaningless
                menuleft: '45%', // initial left offset - only for top menu, as pixels (can be a quoted percentage - ex: '50%')
                keepinview: 80, // Use false (for not static) - OR - true or numeric top offset when page scrolls
                menuspeed: 20, // Speed of menu sliding smaller is faster (interval of milliseconds)
                menupause: 500, // How long menu stays out when mouse leaves it (in milliseconds)
                d_colspan: 3, // Available columns in menu BODY as integer
                allowtransparent: false, // true to allow page to show through menu if other bg's are transparent or border has gaps
                barwidth: 20, // bar (the vertical cell) width
                wrapbar: true, // extend and wrap bar below menu for a more solid look (default false) - will revert to false for top menu
                hdingwidth: 210, // heading - non linked horizontal cells width
                hdingheight: 25, // heading - non linked horizontal cells height
                hdingindent: 1, // heading - non linked horizontal cells text-indent represents ex units (@8 pixels decimals allowed)
                linkheight: 20, // linked horizontal cells height
                linktopad: 3, // linked horizontal cells top padding
                borderwidth: 2, // inner border-width used for this menu
                /////////////////////////// quote these properties: /////////////////////
                bordercolor: '#000080', // inner border color
                borderstyle: 'solid', // inner border style (solid, dashed, inset, etc.)
                outbrdwidth: '0ex 0ex 0ex 0ex', // outer border-width used for this menu (top right bottom left)
                outbrdcolor: 'lightblue', // outer border color
                outbrdstyle: 'solid', // outer border style (solid, dashed, inset, etc.)
                barcolor: 'white', // bar (the vertical cell) text color
                barbgcolor: '#006699',
                barfontweight: 'bold', // bar (the vertical cell) font weight
                baralign: 'center', // bar (the vertical cell) right left or center text alignment
                menufont: 'verdana', // menu font
                fontsize: '90%', // express as percentage with the % sign
                hdingcolor: 'white', // heading - non linked horizontal cells text color
                hdingbgcolor: '#006699',
                hdingfontweight: 'bold', // heading - non linked horizontal cells font weight
                hdingvalign: 'middle', // heading - non linked horizontal cells vertical align (top, middle or center)
                hdingtxtalign: 'center', // heading - non linked horizontal cells right left or center text alignment
                linktxtalign: '<%=align%>', // linked horizontal cells right left or center text alignment
                linktarget: '', // default link target, leave blank for same window (other choices: _new, _top, or a window or frame name)
                kviewtype: 'fixed', // Type of keepinview - 'fixed' utilizes fixed positioning where available, 'absolute' fluidly follows page scroll
                menupos: 'top', // set side that menu slides in from (right or left or top)
                bartext: 'Last Filter', // bar text (the vertical cell) use text or img tag
                ///////////////////////////
                menuItems: [
                    //[name, link, target, colspan, endrow?] - leave 'link' and 'target' blank to make a header
                    ["<%=filter%>"], //create header
            <% for (int m = 0; m < menuElements.size(); m++)
                {
                    tempVec = new Vector();
                    tempVec = (Vector) menuElements.get(m);
            %>
                    ["<%=(String) tempVec.get(0)%>", "<%=(String) tempVec.get(1)%>", ""],
            <% }%>
                    ["<%=cancelFilter%>", "EquipmentServlet?op=cancelFilter", ""]
                ]}; // REQUIRED!! do not edit or remove

            <% index++;
                }%>
            <% if (index > 0)
                {%>
            make_menus();
            <% }%>
            $(document).ready(function(){
            <%
                for (WebBusinessObject messageWbo : messagesList) {
            %>
            notify('<%=(messageWbo.getAttribute("option1") != null && !"UL".equals(messageWbo.getAttribute("option1")) ? "<h2>" + messageWbo.getAttribute("option1") + "</h2><br/>&nbsp;&nbsp;&nbsp;" : "") + messageWbo.getAttribute("message")%>', '<%=messageWbo.getAttribute("option2") != null && !"UL".equals(messageWbo.getAttribute("option2")) ? messageWbo.getAttribute("option2") : ""%>');
            <%
                }
            %>
            });
        </script>

    </HEAD>

    <BODY onbeforeunload="ConfirmClose()" onunload="HandleOnClose();" style="margin-top: 0px;min-width: 950px;">
        <center id="site-body-container"  style="min-height:93%;height: auto;">
            <div style="border: 1px solid #4f6582;/*width: 1000px;*/ min-height:96%; position: relative; margin: auto;padding-right: 0px; padding-left: 0px ;height: auto;">
                 <nav class="modern-topbar navbar fixed-top p-3 " style="background: #27272A;">
                        <div class="container-fluid g-1 align-items-center">
                            <div class="row">
                                 <div class="col-auto legacy-td " background="images/gradient.gif" STYLE="border-top-WIDTH:0; font-size:12px;">
                                <a href="<%=context%>/SessionsServlet?op=logout">
                                    <img src="images/icons/logout.png" width="24px" height="20px" align="middle" alt="<%=sLogOut%>" title=<fmt:message key="logout"/> />
                                </a>
                            </div>
                                      </div>
                                
                                <div class="row">
                                        <div class="col-auto  "  background="images/gradient.gif" STYLE="border-top-WIDTH:0;" nowrap>
                                <b>
                                    <% if (securityUser.isCanChangeHeadBar())
                                        {%>
                                    <select id="groups" onchange="changeGroup(this)" style="width: 150px;border-radius: 6px;padding: 4px 4px;">
                                        <% for (WebBusinessObject obj : userGroups)
                                            {%>
                                        <option value="<%=obj.getAttribute("groupID")%>" <%if (obj.getAttribute("groupID").equals(groupId))
                                            {%> selected="true"<%}%>><%=obj.getAttribute("groupName")%></option>
                                        <%}%>
                                    </select>
                                    <% }
                                    else
                                    {%>
                                    <font color="blue"><%=securityUser.getUserGroupName()%></font>
                                        <%} %>
<!--                                    <img src="images/icons/magic_stick.png" width="24px" height="24px" align="middle" title='<fmt:message key="changeview"/>' >-->
                                </b>
                            </div>
                            <div class="col-auto legacy-td " width="14%" background="images/gradient.gif" STYLE="border-top-WIDTH:0;" nowrap>
                                <b>
                                    <%
                                        if (displayCallCenter)
                                        {
                                            if (securityUser.isCanChangeHeadBar())
                                            {%>
                                    <select id="groups" onchange="changeCallcenterMode(this)" style="margin-top: 7px">
                                        <option value="<%=CRMConstants.CALL_CENTER_INBOUND_CALL%>" <%=(CRMConstants.CALL_CENTER_INBOUND_CALL.equalsIgnoreCase(securityUser.getCallcenterMode())) ? "selected" : ""%>>Inbound Call</option>
                                        <option value="<%=CRMConstants.CALL_CENTER_OUTBOUND_CALL%>" <%=(CRMConstants.CALL_CENTER_OUTBOUND_CALL.equalsIgnoreCase(securityUser.getCallcenterMode())) ? "selected" : ""%>>Outbound Call</option>
                                        <option value="<%=CRMConstants.CALL_CENTER_INBOUND_VISIT%>" <%=(CRMConstants.CALL_CENTER_INBOUND_VISIT.equalsIgnoreCase(securityUser.getCallcenterMode())) ? "selected" : ""%>>Inbound Visit</option>
                                        <option value="<%=CRMConstants.CALL_CENTER_OUTBOUND_VISIT%>" <%=(CRMConstants.CALL_CENTER_OUTBOUND_VISIT.equalsIgnoreCase(securityUser.getCallcenterMode())) ? "selected" : ""%>>Outbound Visit</option>
                                        <option value="<%=CRMConstants.CALL_CENTER_INBOUND_INTERNET%>" <%=(CRMConstants.CALL_CENTER_INBOUND_INTERNET.equalsIgnoreCase(securityUser.getCallcenterMode())) ? "selected" : ""%>>Inbound Internet</option>
                                    </select>
                                    <% }
                                    else
                                    {%>
                                    <font color="blue"><%=securityUser.getCallcenterModeName()%></font>
                                        <%} %>
                                    <img src="images/icons/call_center.png" width="24px" height="24px" align="middle" title="Change Call Center Mode">
                                    <%
                                    }
                                    else
                                    {
                                    %>
                                    &nbsp;
                                    <%
                                        }
                                    %>
                                </b>
                            </div>
                            <div class="col-auto legacy-td " width="22%" background="images/gradient.gif" STYLE="border-top-WIDTH:0;" nowrap>
                                <b>
                                    <%
                                        if (displayAutoPilot)
                                        {
                                            if (securityUser.isCanChangeHeadBar())
                                            {%>
                                    <select id="autoPilot" onchange="changeAutoPilotMode(this)" style="margin-top: 7px; width: 120px" >
                                        <% for (WebBusinessObject obj : groups)
                                            {%>
                                        <option value="<%=obj.getAttribute("group_id")%>" <%if (obj.getAttribute("group_id").equals(securityUser.getDefaultNewClientDistribution()))
                                            {%> selected="true"<%}%>><%=obj.getAttribute("groupName")%></option>
                                        <%}%>
                                    </select>
                                    <% }
                                    else
                                    {%>
                                    <font color="blue"><%if (securityUser.isCanRunAutoPilotMode())
                                        {%><%=securityUser.getDefaultNewClientDistributionName()%><% }
                                    else
                                    {%>***<%}%></font>
                                        <%}%>
                                    <img id="autoPilotModeIconOff" onclick="<%if (!securityUser.isCanRunAutoPilotMode() && securityUser.isCanChangeHeadBar())
                                        {%>JavaScript:changePilotMode('1');<%}%>" src="images/icons/plane_icon<%if (!securityUser.isCanRunAutoPilotMode())
                                        {%>_off<%}%>.png" width="24px" height="24px" align="middle" title="Auto-Pilot Mode" style="<%if (!securityUser.isCanRunAutoPilotMode())
                                        {%>cursor: hand;<%}%>"/>
                                    &ensp;
                                    <img id="manualPilotModeIconOff" onclick="<%if (securityUser.isCanRunAutoPilotMode() && securityUser.isCanChangeHeadBar())
                                        {%>JavaScript:changePilotMode('0');<%}%>" src="images/icons/manual_pilot<%if (securityUser.isCanRunAutoPilotMode())
                                        {%>_off<%}%>.png" width="24px" height="24px" align="middle" title="Auto-Pilot Mode" style="<%if (securityUser.isCanRunAutoPilotMode())
                                        {%>cursor: hand;<%}%>"/>
                                    <%
                                    }
                                    else
                                    {
                                    %>
                                    &nbsp;
                                    <%
                                        }
                                    %>
                                </b>
                            </div>
                                </div>
                      
                            <div class="row">
                                 <div class="col-auto legacy-td " background="images/gradient.gif" STYLE="border-top-WIDTH:0; font-size:12px;">
                                <a href="<%=context%>/SessionsServlet?op=logout">
                                    <img src="images/icons/logoutNew.png" width="24px" height="24px" align="middle" alt="<%=sLogOut%>" title=<fmt:message key="logout"/> />
                                </a>
                            </div>
                            <div class="col-auto legacy-td " background="images/gradient.gif" STYLE="border-top-WIDTH:0; font-size:12px;">
                                <a href="<%=context%>/IssueServlet?op=homePage"><img src="images/icons/home.png" align="middle"  width="24px" height="24px" alt="<%=sMainPage%>" title='<fmt:message key="home"/>' /></a>
                            </div>
                            <div class="col-auto legacy-td" width="4%" background="images/gradient.gif" STYLE="border-top-WIDTH:0;">
                                <a href="<%=context%>/BookmarkServlet?op=ViewBookmarks"><img src="images/icons/BookmarkesNew.png" width="24px" height="24px" align="middle" alt="<%=bookmarks%>" title=<fmt:message key="bookmark"/> /></a>
                            </div>
                            <div class="col-auto legacy-td" background="images/gradient.gif" STYLE="border-top-WIDTH:0;">
                                <a href="<%=context%>/CalendarServlet?op=showCalendar"><img src="images/icons/calendarNew.png" width="24px" height="24px" align="middle" title=<fmt:message key="calender"/> /></a>
                            </div>
                            <div class="col-auto legacy-td " background="images/gradient.gif" STYLE="border-top-WIDTH:0; font-size:12px;">
                                <a href="<%=context%>/ProjectServlet?op=listMyFolders"><img src="images/icons/folder_closedNew.png" align="middle"  width="24px" height="24px" alt="<%=sMainPage%>"  title=<fmt:message key="listfolder"/> /></a>
                            </div>
                            <div class="col-auto legacy-td" background="images/gradient.gif" STYLE="border-top-WIDTH:0;">
                                <a href="<%=context%>/UsersServlet?op=editPassword&userId=<%=userId%>&numberOfUsers=0&index=10"><img src="images/icons/padlock.png" align="middle" alt="تغير كلمة المرور" width="24px" height="24px" title='<fmt:message key="changpass"/>' /></a>
                            </div>
                            <div class="col-auto legacy-td" background="images/gradient.gif" STYLE="border-top-WIDTH:0; display: <%=userPrevList.contains("CALLS") ? "" : "none"%>;">
                                <a href="#" onclick='JavaScript: window.open("<%=context%>/ManageWebClientServlet?op=uploadClientsFromExcel", "_Self", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=800, height=600");'><img src="images/client_detailsNew.png" align="middle" alt="سحب المكالمة" width="24px" height="24px"  title='Upload Clients from Excel'  /></a>
                            </div>
                            <div class="col-auto legacy-td" background="images/gradient.gif" STYLE="border-top-width: 0px; display: <%=userPrevList.contains("ACTIVITIES") ? "" : "none"%>;">
                                <a href="<%=context%>/AppointmentServlet?op=clientDetailsLead">
                                    <img src="images/icons/client_details.png" align="middle" alt="أنشطتي" width="24px" height="24px"  title='Cliets Details'/>
                                </a>
                            </div>
                            
                            <div class="col-auto legacy-td" background="images/gradient.gif" STYLE="border-top-width: 0px; display: <%=userPrevList.contains("PAYMENT_PLANS") ? "" : "none"%>;">
                                <a href="<%=context%>/UnitServlet?op=getMyPaymentPlans">
                                    <img src="images/icons/paymentPlans.png" align="middle" alt="Payment Plans" width="30px" height="30px"  title='<fmt:message key="paymentPlans" />'/>
                                </a>
                            </div>
                               <div class="col-auto legacy-td"  background="images/gradient.gif" STYLE="border-top-width: 0px; display: <%=userPrevList.contains("COMMENTS") ? "" : "none"%>;"> 
                                <a href="<%=context%>/CommentsServlet?op=myComments">
                                    <img src="images/icons/comments.png" alcign="middle" alt="تعليقاتي" style="height: 24px ; width: 24px;" title='<fmt:message key="mycomments" />'/> 
                                </a>
                            </div>
                                
                                
                             <div class="col-auto legacy-td" background="images/gradient.gif" STYLE="border-top-width: 0px; display: <%=userPrevList.contains("APPOINTMENTS") ? "" : "none"%>;">
                                <a href="<%=context%>/AppointmentServlet?op=myAppointment">
                                    <img src="images/icons/calendar-256.png" align="middle" alt="متابعاتى" style="height: 24px;" title='<fmt:message key="myappointments" />'/>
                                </a>
                            </div>
                            <div class="col-auto legacy-td"  background="images/gradient.gif" STYLE="border-top-width: 0px; display: <%=userPrevList.contains("NEW_CLIENT") ? "" : "none"%>;">
                                <a href="<%=context%>/ClientServlet?op=GetClientForm">
                                    <img src="images/client/add-client.png" align="middle" alt="<fmt:message key="newClient" />" style="height: 24px; width: 24px;" title='<fmt:message key="newClient" />'/>
                                </a>
                            </div>
                            
                               <div class="col-auto legacy-td"  background="images/gradient.gif" STYLE="border-top-width: 0px; cursor: pointer; color: white;">
                                <a onclick="changeLang('<%=langCode%>','<%=context%>')" >
                                    <%=langtittle%>
                                </a>
                            </div>
                           <div class="col-auto legacy-td " width="11%" background="images/gradient.gif" STYLE="border-top-WIDTH:0;" nowrap>
                                <b>
                                    <%
                                        if (displayBranch)
                                        {
                                            if (securityUser.isCanChangeHeadBar())
                                            {%>
                                    <select id="branches" onchange="changeBranch(this)" style="margin-top: 7px">
                                        <% for (WebBusinessObject obj : userProjects)
                                            {%>
                                        <option value="<%=obj.getAttribute("projectID")%>" <%if (obj.getAttribute("projectID").equals(projectId))
                                            {%> selected="true"<%}%>><%=obj.getAttribute("projectName")%></option>
                                        <%}%>
                                    </select>
                                    <% }
                                    else
                                    {%>
                                    <font color="blue"><%=securityUser.getSiteName()%></font>
                                        <%} %>
                                    <img src="images/icons/branch.png" width="23px" height="23px" align="middle" title="Change Default Branch">
                                    <%
                                    }
                                    else
                                    {
                                    %>
                                    &nbsp;
                                    <%
                                        }
                                    %>
                               </b>
                            </div>
                            <div class="col-auto legacy-td " width="14%" background="images/gradient.gif" STYLE="border-top-WIDTH:0;" nowrap>
                                <b>
                                    <%
                                        if (displayCampaign)
                                        {
                                            if (securityUser.isCanChangeHeadBar())
                                            {%>
                                    <select id="campaign" onchange="changeCampaign(this)" style="width: 100px;margin-top: 7px">
                                        <option value=""><fmt:message key="choose" /></option>
                                        <% for (WebBusinessObject obj : toolsList)
                                            {%>
                                        <option value="<%=obj.getAttribute("id")%>" <%if (obj.getAttribute("id").equals(securityUser.getDefaultCampaign()))
                                            {%> selected="true"<%}%>><%=obj.getAttribute("campaignTitle")%></option>
                                        <%}%>
                                    </select>
                                    <% }
                                    else
                                    {%>
                                    <font color="blue"><%=securityUser.getDefaultCampaignName()%></font>
                                        <%} %>
                                    <img src="images/icons/Target_Icon.png" width="25px" height="25px" align="middle" title='<fmt:message key="changecamp"/>'>
                                    <%
                                    }
                                    else
                                    {
                                    %>
                                    &nbsp;
                                    <%
                                        }
                                    %>
                                </b>
                            </div>
                        
                            </div>
                         
                            
                        </div>
                    </nav>  
                <TABLE   align="center" cellpadding="0" cellspacing="0" STYLE="margin-top:30px; BORDER-top-WIDTH:2px; BORDER-right-WIDTH:2px; BORDER-left-WIDTH:2px; BORDER-bottom-WIDTH:2px;" width="100%;">
                    <TR ALIGN='<fmt:message key="align" />' dir='<fmt:message key="direction" />'>
                         
                        
<!--                           <div class="summary_td col-auto" style="display: none;" align="left">
                            <TABLE  bgcolor="#dedede" ALIGN="CENTER" DIR='<fmt:message key="direction" />' CELLPADDING="0" CELLSPACING="0" width="100%" STYLE="border-width:1px;display: block; height: auto" >
                                <TR>
                                    <TD class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b>
                                            <fmt:message key="curruser"/> :
                                        </b>
                                    </TD>
                                    <TD class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <a href="JavaScript:openUserData('UsersServlet?op=userData');">
                                            <%=userName%> 
                                        </a>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b><%=departmentTitle%> :</b>
                                    </TD>
                                    <TD class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=managerName%>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b><fmt:message key="manggroup"/>  :</b>
                                    </TD>
                                    <TD class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=securityUser.getUserGroupName()%>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b><fmt:message key="lastsign"/> :</b>
                                    </TD>
                                    <TD class="summary_td" style="text-align: <%=align%>; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=securityUser.getLastLogin()%>
                                    </TD>
                                </TR>
                                
                                <%if(securityUser.getCompanyName()!=""){%>
                                <TR>
                                    <TD class="summary_td" style="text-align: right; padding-right: 5px; font-size: 12px; border-left-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <b><fmt:message key="company"/>   </b>
                                    </TD>
                                    <TD class="summary_td" style="text-align: right; padding-right: 5px; font-size: 12px; border-right-width: 0px; height: 20px" valign="MIDDLE" nowrap>
                                        <%=securityUser.getCompanyName()%>
                                    </TD>
                                </TR>
                                <%}%>
                            </TABLE>
                        </div>-->
                        
                       
                        
                    </TR> 
                    
                                    
                    <div style="height: 28px;"></div>>
                </TABLE>
                            <!--//////////////////////////////////////////-->
                       <aside id="sidebarMenu" class="sidebar-menu" style="<%=("LEFT".equalsIgnoreCase(align))?"left:0;":"right:0;"%>">
                    <div class="sidebar-inner">
                       <div class="sidebar-summary">
    <div class="user-info">
      
        <!--<img src="images/boy.png" alt="User" class="user-avatar">-->
           <img src="images/panda.png" alt="User" class="user-avatar">

        <div class="user-text">
            <span class="user-name"><%=userName%></span>
            <span class="user-manager"><%=managerName%></span>
        </div>
    </div>


    <div class="user-popup">
        <table>
            <tr>
                <td><b><fmt:message key="manggroup"/>:</b></td>
                <td><%=securityUser.getUserGroupName()%></td>
            </tr>
            <tr>
                <td><b><fmt:message key="lastsign"/>:</b></td>
                <td><%=securityUser.getLastLogin()%></td>
            </tr>
            <% if(securityUser.getCompanyName() != "") { %>
            <tr>
                <td><b><fmt:message key="company"/>:</b></td>
                <td><%=securityUser.getCompanyName()%></td>
            </tr>
            <% } %>
        </table>
    </div>
</div>

                        <%
                            if (isSuperUser)
                            {
                        %>
                        <%=lang.equalsIgnoreCase("Ar") ? tdm.getMenuString() : tdm.getMenuEnString()%>
                        <%
                            }
                            else
                            {
                        %>
                        <%=lang.equalsIgnoreCase("Ar") ? securityUser.getMenuString() : securityUser.getMenuEnString()%>
                        <%
                            }
                        %>
                    </div>
                </aside>

                <div style="background-color: transparent;width: 20%;text-align: left;;float: left;display: block;clear: both;margin-top: 5px;">


                    <%
                        String lastLogin = securityUser.getLoginDate();
                    %>
                    <div style="margin-left: 5px;color: white;">
                        Last login : <b style=""><%=lastLogin%></B>
                    </div>
                </div>

                <div style="margin: 0px; clear: both;height: 10px;display: block;"></div>
                <%
                    String page2 = (String) request.getAttribute("page");

                    if (null == page2)
                    {
                        WebBusinessObject userGroup = userGroupMgr.getOnSingleKey(securityUser.getUserGroupId());
                        WebBusinessObject group = groupMgr.getOnSingleKey(userGroup.getAttribute("groupID").toString());
                        page2 = (String) group.getAttribute("defaultPage");
                    }
                    try
                    {
                %>
                <jsp:include page="<%=page2%>" flush="true"  />
                <%}
                    catch (Exception ex)
                    {
                        out.println(ex.getMessage());
                    }%>
                <div style="margin: 0px; clear: both;height: 10px;display: block;"></div>
            </div>
            <div id="site-bottom-bar" style="width: 100%">
                <center>
                     <div id="site-bottom-bar-frame" style="width: 100%">
                        <div id="site-bottom-bar-content" style="width: 100%">
                            <div style="padding-top: 5px; font-family: 'Times New Roman', Times, serif;float: left;color: #e7f7fb; font-size: 15px;padding-left: 30px" >
                                © 4S Advanced Technologies
                            </div>
                         </div>
                    </div>
                </center>
            </div>
            <iframe name="print_frame" width="0" height="0" frameborder="0" src="<%=context%>/PDFReportServlet?op=getPrintForm"></iframe>
        </center>
                
                <div>
                    <p id="msg"></p>
                </div>
        <div style="margin: 330px 10px 330px 10px;border-radius: 5px 5px 5px 5px " id="stickyalerts" class="sticky-queue top-right">
        </div>
        <script>
document
  .querySelectorAll('.sidebar-inner li > a')
  .forEach(a => {

    a.addEventListener('click', function (e) {

        const li = this.parentElement;
        const submenu = li.querySelector(':scope > ul');

        // لو مفيش submenu سيبه يفتح اللينك عادي
        if (!submenu) return;

        e.preventDefault();

        li.classList.toggle('open');
    });

});



</script>

                <script type="text/javascript">
            $(function () {
                $("#group_Btn").click(function (e) {
                    var position = $("#group_Btn").offset();
                    $('#groups').css({
                        "position": "fixed",
                        "left": position.left,
                        "top": position.top + 13,
                        "z-index": "1000",
                        "float": "left",
                        "display": "block"
                    });
                });
            });
            function redirectToClient(clientMobile) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientByyMobileAjax",
                    data: {
                        clientMobile: clientMobile.substring(0, clientMobile.indexOf('@'))
                    },
                    success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            var r = confirm("For Immediate Attention from '" + clientMobile.substring(clientMobile.indexOf('@') + 1)
                                    + "'\nDo you want to redirect to see it?");
                            if(r) {
                                location.href = "<%=context%>/ClientServlet?op=clientDetails&clientId=" + info.id;
                            }
                        }
                    }
                });
            }
        </script>
        <% }
            else
            {
                String servedPage = context + "/index.jsp";
                response.sendRedirect(servedPage);
            }%>
            
            
        <jsp:include page="notification_alarm.jsp" flush="true" />
        <jsp:include page="docs/sla/sla_alarm.jsp" flush="true" />
        <jsp:include page="docs/websocket/notification.jsp" flush="true" />
   
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    </BODY>
</HTML>
