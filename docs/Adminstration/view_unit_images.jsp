<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
    
    <%
    response.addHeader("Pragma","No-cache");
    response.addHeader("Cache-Control","no-cache");
    response.addDateHeader("Expires",1);
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String equipmentID = (String) request.getAttribute("equipmentID");
    Vector imagePath = (Vector) request.getAttribute("imagePath");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sView, cancel,close;
    if(cMode.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        sView = "View";
        cancel="Back";
        close="Close";
    } else {
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sView = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; ";
        close="&#1573;&#1594;&#1604;&#1575;&#1602;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Document Details</TITLE>
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script type="text/javascript" src="js/jquery.carouFredSel-6.2.0.js"></script>
        <script type="text/javascript" src="js/jquery.transit.min.js"></script>
        <script type="text/javascript" src="js/jquery.mousewheel.min.js"></script>
        
        <script>
            $(function() {
                
                $("#foo").carouFredSel({
                    auto : false,
                    transition: true,
                    mousewheel: true,
                    prev : "#foo_prev",
                    next : "#foo_next"
                });
                
            });
	</script>
        
        <style type="text/css">
            
            .image_carousel {
                padding: 15px 0 15px 40px;
                width: 800px;
                height: 1400px;
                position: relative;
            }
            .image_carousel img {
                border: 1px solid #ccc;
                background-color: white;
                padding: 9px;
                margin: 7px;
                display: block;
                float: left;
            }
            a.prev, a.next {
                background: url(images/miscellaneous_sprite.png) no-repeat transparent;
                width: 45px;
                height: 50px;
                display: block;
                position: absolute;
                top: -40px;
            }
            a.prev {			
                left: 15px;
                background-position: 0 0; }
            a.prev:hover {		background-position: 0 -50px; }
            a.next {			right: -30px;
                       background-position: -50px 0; }
            a.next:hover {		background-position: -50px -50px; }

            a.prev span, a.next span {
                display: none;
            }
            .clearfix {
                float: none;
                clear: both;
            }
        </style>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm()
        {    
        window.location = "<%=context%>/UnitDocReaderServlet?op=ViewImages&equipmentID=<%=equipmentID%>";
        } 
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <DIV align="left" STYLE="color:blue;">
            
            <button onclick="javascript:window.close();" class="button"><%=close%> </button>
            
        </DIV> 
        
        <br><br>
        <fieldset align=center class="set">
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=sView%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br>
            <div class="image_carousel">
                <div id="foo">

                    <%for (int i = 0; i < imagePath.size(); i++) {%>
                    <img src="<%=imagePath.get(i)%>" width="800" height="1400"/>
                    <%}%>
                </div>
                <div class="clearfix"></div>
                <a class="prev" id="foo_prev" href="#"><span>prev</span></a>
                <a class="next" id="foo_next" href="#"><span>next</span></a>
            </div>
            <br>
        </fieldset>
    </BODY>
</HTML>     
