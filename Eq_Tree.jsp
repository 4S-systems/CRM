<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*, com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        
        
        <SCRIPT LANGUAGE="JavaScript" SRC="js/AnimatedFader.js"></SCRIPT>
        <SCRIPT LANGUAGE="JavaScript">

	FadingText('fade1', 10,"FFFFFF");
	FadeInterval=30;

        </SCRIPT>
        
    </head>
    
    <%
    
    UnitMgr unitScheduleMgr = UnitMgr.getInstance();
    
    AppConstants appCons = new AppConstants();
    WebBusinessObject wbo=new WebBusinessObject();
    WebBusinessObject wbo2=null;
    Vector parentVector = new Vector();
    parentVector = (Vector) unitScheduleMgr.getRootNodes();
    Vector temp=null;
    Vector tree=new Vector();
    Vector par=new Vector();
    for(int i=0;i<parentVector.size();i++){
        wbo=(WebBusinessObject)parentVector.get(i);
        String name=(String)wbo.getAttribute("unitName");
        
        
        
        temp=new Vector();
        String p=(String)wbo.getAttribute("id");
        temp=(Vector)unitScheduleMgr.getChildren(p);
        par=new Vector();
        par.add(name);
        
        par.add(temp);
        tree.add(par);
    }
    
    String help="** &#1604;&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1604;&#1575;&#1609; &#1605;&#1593;&#1583;&#1607; &#1575;&#1590;&#1594;&#1591; &#1593;&#1604;&#1609; &#1575;&#1604;&#1575;&#1610;&#1602;&#1608;&#1606;&#1607; &#1575;&#1604;&#1589;&#1594;&#1610;&#1585;&#1607; &#1576;&#1580;&#1608;&#1575;&#1585; &#1575;&#1604;&#1575;&#1587;&#1605; &#1581;&#1578;&#1609; &#1578;&#1578;&#1605;&#1603;&#1606; &#1605;&#1606; &#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1580;&#1605;&#1610;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1606;&#1608;&#1593;  ***  &#1604;&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1605;&#1593;&#1583;&#1607; &#1605;&#1593;&#1610;&#1606;&#1607; &#1575;&#1588;&#1585; &#1593;&#1604;&#1610;&#1607;&#1575; &#1576;&#1575;&#1604;&#1605;&#1575;&#1608;&#1587; &#1578;&#1592;&#1607;&#1585; &#1604;&#1603; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1601;&#1609; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1605;&#1576;&#1610;&#1606; &#1575;&#1605;&#1575;&#1605;&#1603; **";
   
    %>        
    <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function changePage(url){
                window.navigate(url);
        }

       function changeicon(name,image1){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
                document.getElementById(image1).src ="images/-.jpg";

            }
              else if(document.getElementById(name).style.display == 'block'){
                document.getElementById(name).style.display = 'none';
                document.getElementById(image1).src ="images/+.jpg";
            }
        }
        
        
        function changeMode(image1){
    document.getElementById(image1).src ="images/lft.png";
    }
    
    function changeMode2(image1){
    document.getElementById(image1).src ="images/aro.png";
    }
        
        
    </SCRIPT>
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    
    
    <BODY >
        
        <fieldset align="center" class="set" >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    &#1588;&#1580;&#1585;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;        
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <Marquee DIRECTION=RIGHT SCROLLDELAY=150 width=60% bgcolor=#bbbccc>
                <font color="blue" size=2> <b><%=help%></b></font>
            </MARQUEE>
            
            
            <table width="100%" dir="rtl">   
                <tr><td class=td width="50%">
                        <%  
                        Vector parent=null;
                        for(int j=0;j<tree.size();j++){
                            parent=new Vector();
                            parent=(Vector)tree.get(j);
                        %>
                        
                        <div align="right"  style="margin-right:20" onclick="changeicon('div<%=j%>','im<%=j%>')" >
                            
                            <font color="red" size="4">
                                <img src="images/+.jpg">  <%=parent.get(0)%> 
                                
                            </font>
                            
                        </div>
                        
                        <div align="right" style="margin-right:40;display:none" id='div<%=j%>' >
                            
                            <% Vector v=(Vector)parent.get(1) ;
                            for(int k=0;k<v.size();k++){
                                wbo2=(WebBusinessObject)v.get(k);
                                String unitNo=(String)wbo2.getAttribute("unitNo");
                                String modelNo=(String)wbo2.getAttribute("modelNo");
                                String engineNo=(String)wbo2.getAttribute("engineNo");
                                String status=(String)wbo2.getAttribute("status");
                            %>
                            <div onMouseOver="fade_up('fade1',' <table style=text-align:right><tr><td class=td> <font color=red size=3><b>&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; </font></b></td><td class=td><%=unitNo%> </td></tr>  <tr><td class=td> <font color=red size=3> <b>&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;</font></b></td><td class=td><%=modelNo%> </td></tr>  <tr><td class=td> <font color=red size=3><b>&#1585;&#1602;&#1605; &#1575;&#1604;&#1588;&#1575;&#1587;&#1610;&#1607;</b></font></td><td class=td><%=engineNo%> </td></tr> <tr><td class=td> <font color=red size=3><b>&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;</b></font></td><td class=td><%=status%> </td></tr> </table>','000000')" onMouseOut="fade_down('fade1')">
                                <img src="images/-.jpg">
                                <font color="blue" size="3">
                                    
                                    <%=wbo2.getAttribute("unitName")%>
                                </font>
                            </div>
                            <br>
                            
                            <%    }    %>
                            
                        </div>
                        <%}%>
                        
                    </td>
                    <td class=td >
                        <script language="JavaScript1.2">
if (document.layers){
document.write('<ilayer name="nscontainer" width="100%" height="100">')
document.write('<layer name="fade1" width="100%" height="100">')
document.write('</layer></ilayer>')
}
else
document.write('<DIV STYLE="text-align:right" class="graypanel" ID="fade1"></DIV>')

                        </script>    
                    </td> 
            </tr> </table> 
        </fieldset>
        
    </BODY>
</HTML>