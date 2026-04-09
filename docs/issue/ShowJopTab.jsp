<%@ page language="java" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<html>
    <head>
        <%
        
        String key = request.getAttribute("key").toString();
        System.out.println("jjjjjjjjjjjj  "+key);
        
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
        <title>Ajax on Java Chapter 7, Ajax Tags</title>
        <!--${pageContext.request.contextPath}/tabcontent-->
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxtags-1.2/prototype-1.4.0.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxtags-1.2/scriptaculous.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxtags-1.2/overlibmws.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxtags-1.2/ajaxtags.js"></script>
        
        <link rel="stylesheet" type="text/css" href="css/ajaxtags-sample.css" />
        <style>
            Table.Product {border: solid 2px; border-color:#ff0066;}
            TD.Product{background-color:#ff0066;border: solid 2px; color:#ff0066}
            TH.Product{background-color:#ff0066; color:#ff0066}
            
            Table.User {border: solid 2px; border-color:#ff0066;}
            TR.UserDark {background-color:#ff0066;border: solid 2px; color:#ff0066}
            TR.UserLight {background-color:#ff0066;border: solid 2px; color:#ff0066}
            TH.User {background-color:#ff0066; color:#ff0066}
            
            Table.Cart {border: solid 2px; border-color:#ff0066;}
            TR.CartLight {background-color:#ff0066;border: solid 2px; color:#ff0066}
            TR.CartDark {background-color:#ff0066;border: solid 2px; color:#ff0066}
            TH.Cart {background-color:#ff0066; color:#ff0066}
        </style>
    </head>
    
    <body>
        <table align="right" dir="rtl"><tr><td class="td" style="text-align:right"> <h1>&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1576;&#1581;&#1579;</h1></td></tr></table>
        <br><br>
        <div align="right" dir="rtl">
            
            
            <ajax:tabPanel 
                panelStyleId="tabPanel"
                contentStyleId="tabContent"
                panelStyleClass="tabPanel"
                contentStyleClass="tabContent"
                currentStyleClass="ajaxCurrentTab">
                <ajax:tab caption="&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;"
                          baseUrl="${pageContext.request.contextPath}/IssueServlet?op=tap1&key=${key}"
                          defaultTab="true"/>
                <ajax:tab caption="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;"
                          baseUrl="${pageContext.request.contextPath}/IssueServlet?op=ViewParts&Tap=Yes&key=${key}"
                />
                
                <ajax:tab caption="&#1575;&#1604;&#1605;&#1607;&#1606; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607;"
                          baseUrl="${pageContext.request.contextPath}/IssueServlet?op=Re_Jops&Tap=Yes&key=${key}"
                />
                <ajax:tab caption="&#1575;&#1604;&#1593;&#1605;&#1575;&#1604; "
                          baseUrl="${pageContext.request.contextPath}/IssueServlet?op=Workers&Tap=Yes&key=${key}"
                />
                <ajax:tab caption="&#1578;&#1608;&#1580;&#1610;&#1607;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;"
                          baseUrl="${pageContext.request.contextPath}/IssueServlet?op=Work_Instruction&Tap=Yes&key=${key}"
                />
                
            </ajax:tabPanel>
            
        </div>
    </body>
</html>

