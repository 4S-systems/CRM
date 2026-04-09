<%@ page language="java" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.contractor.db_access.MaintainableMgr, com.maintenance.db_access.*, com.tracker.db_access.*"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>


<%


TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

IssueMgr issueMgr=IssueMgr.getInstance();
String issueId = request.getAttribute("issueId").toString();
WebBusinessObject issueWbo=issueMgr.getOnSingleKey(issueId);
String businessID=issueWbo.getAttribute("businessID").toString();

Vector complexIssues=(Vector)request.getAttribute("complexIssues");
WebBusinessObject cIssueWbo=new WebBusinessObject();
cIssueWbo=(WebBusinessObject)complexIssues.get(0);
String cIssueId=cIssueWbo.getAttribute("id").toString();
String tabTitle=cIssueWbo.getAttribute("index").toString()+"/"+businessID;

String backTarget=null;

response.addHeader("Pragma","No-cache");
response.addHeader("Cache-Control","no-cache");
response.addDateHeader("Expires",1);


backTarget=context+"/main.jsp";


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align = null;
String dir = null;
String listAttachedDriver=null;
String style = null;
String lang,langCode,save, cancel, Indicators;
if (stat.equals("En")) {
    align = "center";
    dir = "LTR";
    style = "text-align:left";
    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
    langCode = "Ar";
    
} else {
    align = "center";
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    
}
%>

<html>
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
        <title>Ajax on Java Chapter 7, Ajax Tags</title>
        <!--${pageContext.request.contextPath}/tabcontent-->
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxtags-1.2/prototype-1.4.0.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxtags-1.2/scriptaculous.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxtags-1.2/overlibmws.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxtags-1.2/ajaxtags.js"></script>
        
        <link rel="stylesheet" type="text/css" href="css/ajaxtags-sample.css" />
        <style>
            Table.Product {border: solid 2px; border-color:#CCFF66;}
            TD.Product{background-color:#CCCCFF;border: solid 2px; color:#000099}
            TH.Product{background-color:#000099; color:#CCCCFF}
            
            Table.User {border: solid 2px; border-color:#CCFF66;}
            TR.UserDark {background-color:#CCCCFF;border: solid 2px; color:#6666CC}
            TR.UserLight {background-color:#CCFFFF;border: solid 2px; color:#6666CC}
            TH.User {background-color:#6666CC; color:#CCCCFF}
            
            Table.Cart {border: solid 2px; border-color:#339966;}
            TR.CartLight {background-color:#CCCCFF;border: solid 2px; color:#336666}
            TR.CartDark {background-color:#33FF99;border: solid 2px; color:#336666}
            TH.Cart {background-color:#336666; color:#CCCCFF}
        </style>
    </head>
    <SCRIPT>
    function changeMode(name){
        if(document.getElementById(name).style.display == 'none'){
            document.getElementById(name).style.display = 'block';
        } else {
             document.getElementById(name).style.display = 'none';
        }
    }
            
    function changePage(url){
        window.navigate(url);
    }
    
    
    </SCRIPT>
    <body>
        
        <div align="center" dir="rtl">
            
            
            <ajax:tabPanel 
                panelStyleId="tabPanel"
                contentStyleId="tabContent"
                panelStyleClass="tabPanel"
                contentStyleClass="tabContent"
                currentStyleClass="ajaxCurrentTab">
                <ajax:tab caption="<%=tabTitle%>"
                          baseUrl="${pageContext.request.contextPath}/CompexIssueServlet?op=TabPartsComplex&issueID=${issueId}&cIssueID=${cIssueId}"
                          defaultTab="true"/>
                <%
                for(int i=1;i<complexIssues.size();i++){
    cIssueWbo=new WebBusinessObject();
    cIssueWbo=(WebBusinessObject)complexIssues.get(i);
    cIssueId=cIssueWbo.getAttribute("id").toString();
    tabTitle="";
    tabTitle=cIssueWbo.getAttribute("index").toString()+"/"+businessID;
                %>
                <ajax:tab caption="<%=tabTitle%>"
                          baseUrl="${pageContext.request.contextPath}/CompexIssueServlet?op=TabPartsComplex&issueID=${issueId}&cIssueID=${cIssueId}"
                          parameters="tab=Products" />
                <%
                }
                %>
            </ajax:tabPanel>
            
        </div>
    </body>
</html>

