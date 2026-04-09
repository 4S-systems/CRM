<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    Vector  tasks = (Vector) request.getAttribute("tasks");
    WebBusinessObject wbo = null;
    
    String values=(String)request.getAttribute("allValues");
    String allValues[]=values.split("#");
    
    WebBusinessObject taskWbo=null;
    
    Enumeration e = tasks.elements();
    Enumeration eTotal = tasks.elements();
    Double iTemp = new Double(0);
    int iTotal = 0;
    request.getSession().setAttribute("tasks", tasks);
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,S,Total,Percent,amount,names,title ,pageTitle , pageTitleTip ;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Maintenance Items Statistics ";
        save=" Excel Sheet";
        cancel = "Cancel";
        TT="Total Schedules ";
        S="Status";
        Total="Total";
        Percent="Percent";
        amount="Number Of using";
        names="Maintenance Item Name";
        title="Maintenance Items Report";
         pageTitle="RPT-MNTNCE-ITEM-JO-1";
         pageTitleTip="Maintenance Item By JobOrder Report";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit="&#1575;&#1604;&#1605;&#1606;&#1581;&#1606;&#1609; &#1575;&#1604;&#1578;&#1603;&#1585;&#1575;&#1585;&#1609; &#1604;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        save="&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
        cancel = "&#1593;&#1608;&#1583;&#1607;";
        TT="&#1593;&#1583;&#1583; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604; ";
        S="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        Total="&#1575;&#1604;&#1593;&#1583;&#1583; &#1575;&#1604;&#1603;&#1604;&#1610;";
        Percent="&#1575;&#1604;&#1606;&#1587;&#1576;&#1577;";
        amount="&#1593;&#1583;&#1583; &#1605;&#1585;&#1575;&#1578; &#1575;&#1604;&#1575;&#1587;&#1578;&#1582;&#1583;&#1575;&#1605;";
        names="&#1571;&#1587;&#1605;&#1575;&#1569; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        title="&#1575;&#1604;&#1605;&#1606;&#1581;&#1606;&#1609; &#1575;&#1604;&#1578;&#1603;&#1585;&#1575;&#1585;&#1609; &#1604;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
         pageTitle="RPT-MNTNCE-ITEM-JO-1";
         pageTitleTip="&#1575;&#1581;&#1589;&#1575;&#1574;&#1610;&#1577; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1591;&#1576;&#1602;&#1575; &#1604;&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";

    }
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Equipment Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <script type="text/javascript" src="js/jscharts.js"></script>
    </HEAD>
    <script language="javascript" type="text/javascript">
          function changePage(url){
                window.navigate(url);
            }
            
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

          function cancelForm()
        {
           document.EQP_REPORT_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
           document.EQP_REPORT_FORM.submit();
        }
      
    </script>
    <BODY>
         <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="EQP_REPORT_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" width="50"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"></button>
            </DIV>  
            <br><br>
            <fieldset align=center class="set" >
                <legend align="center">
                    
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"><%=tit%></font>
                            </td>
                        </tr>
                    </table>
                </legend >
                 <div dir="left">
                            <table>
                                <tr>
                                    <td>
                                        <font color="#FF385C" size="3">
                                            <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=pageTitleTip%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                                        </font>
                                    </td>
                                </tr>
                            </table>
                        </div>
                <center>
                    
                    <APPLET CODE="HorizontalBar3D.class" WIDTH=650 HEIGHT="900">
                        
                        <PARAM name="set_border_off">
                        <PARAM name="legend_border_off">
                        <PARAM name="transparency" value=".7">
                        <PARAM name="angle" value="50">
                        
                        <PARAM name="legend_rows" value="3">
                        
                        <PARAM name="x_axis_description" value="<%=amount%>">
                        <PARAM name="y_axis_description" value="<%=names%>">
                        
                        <PARAM name="title" value="<%=title%>">
                        <PARAM name="title_color" value="0,0,0">
                        <PARAM name="show_percents_on_legend">
                        <PARAM name="show_description_on_y_axis">
                        <PARAM name="show_values_on_top_of_bars">
                        <PARAM name="back_grid_color" value="200,200,200">
                        <PARAM name="backg_color" value="217,223,235">
                        <PARAM name="grid_color" value="0,0,100">
                        <%
                        int value=0;
                        int c=0;
                        
                        //Becouse this applete work on array mith max 40 elements
                        int size=tasks.size();
                        if(size>40)
                            size=40;
                        //////////////////
                        for(int i=0;i<size;i++){
                            taskWbo=(WebBusinessObject)tasks.get(i);
                            value=Integer.parseInt(allValues[i]);
                            if(value>0){
                                c++;
                        %>
                        <PARAM name="val_<%=c%>" value="<%=value%>">
                        <PARAM name="description_<%=c%>" value="<%=(String)taskWbo.getAttribute("name")%>">
                        <%}}
                        %>
                        
                    </APPLET>
                    
                </center>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
