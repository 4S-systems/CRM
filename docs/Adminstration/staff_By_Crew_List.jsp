<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="0">
   <HEAD>
       <TITLE>System Projects List</TITLE>
       <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

CrewMissionMgr crewMissionMgr=CrewMissionMgr.getInstance();

//AppConstants appCons = new AppConstants();

String[] categoryAttributes = {"crewName"};
String[] categoryListTitles = {"Crew Name", "Total Staff", "View Staff"};  

int s = categoryAttributes.length;
int t = s+2;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;



Vector  categoryList = (Vector) request.getAttribute("data");


WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String categoryId=null;
String Total =null;

%>

<body>


    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
    <TR>
        <TD class='td'>
            &nbsp;
        </TD>
    </TR>

    </table> 

    <TABLE  stylel="position:absolute;top:400px;left:30px;border-right-WIDTH:1px"  WIDTH="200" CELLPADDING="0" CELLSPACING="0">


                               
        <TD nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
            Category List
        </TD>
        <TD CLASS="tabletitle" STYLE="">
            <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
        </TD>
            
                  
        </TR>
    </TABLE>


    <TABLE WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    <TR CLASS="head">
        <%
        for(int i = 0;i<t;i++) {
       

        %>
              
        <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <%=categoryListTitles[i]%>
        </TD>
                 
                    
           
        <%
                 }
        %>
    </TR>  
    <%
                
    Enumeration e = categoryList.elements();
    
    
    while(e.hasMoreElements()) {
        iTotal++;
        wbo = (WebBusinessObject) e.nextElement();
        
        flipper++;
        if((flipper%2) == 1) {
            bgColor="#c8d8f8";
        } else {
            bgColor="white";
        }
        categoryId = (String) wbo.getAttribute("crewID");
        %>

    <TR bgcolor="<%=bgColor%>">
        <%
                 for(int i = 0;i<s;i++)
                 {
                       attName = categoryAttributes[i];
                       attValue = (String) wbo.getAttribute(attName);
        %>
        
        <TD  nowrap  CLASS="cell" >
            <DIV >
                    
                <b> <%=attValue%> </b>
            </DIV>
        </TD>
        <%
                  }
              %>
                   
              <%
              Total=crewMissionMgr.getTotalStaff(categoryId);
              if (Total!=null){
              %>
        <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
            <DIV ID="links">
                <!--
                <A HREF="<%//=context%>/ItemsServlet?op=ViewCategory&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                    <%//=tGuide.getMessage("view")%>
                </A>
                -->
                <%=Total%>
            </DIV>
          <%  } else { %>
          
            <DIV ID="links">
                <!--
                <A HREF="<%//=context%>/ItemsServlet?op=ViewCategory&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                    <%//=tGuide.getMessage("view")%>
                </A>
                -->
                No Parts for Category
            </DIV>
            <% } %>
        </TD>
            
        <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
            <% if(Total.equals("0")) { %>
            <DIV ID="links">
               
                <font color="red"> <b>  No Staff for Crew Mission </b></font>
            </DIV>
            <% } else {  %>
            
            <DIV ID="links">
                <A HREF="<%=context%>/CrewMissionServlet?op=ShowStaffCode&crewID=<%=wbo.getAttribute("crewID")%>">
                    View Staff
                </A>
            </DIV>
            <% } %>
        </TD>
        <!--
        <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
            <DIV ID="links">
                <A HREF="<%//=context%>/ItemsServlet?op=ConfirmDeleteCategory&categoryId=<%//=wbo.getAttribute("categoryId")%>&categoryName=<%//=wbo.getAttribute("categoryName")%>">
                    <%//=tGuide.getMessage("delete")%>
                </A>
            </DIV>
        </TD>
               -->        
             

           
    </TR>
             
            
    <%
                
           }
          
          %>
        <!--  
    <TR>
        <TD CLASS="total" COLSPAN="3" STYLE="text-align:right;padding-right:5;border-right-width:1;">
            Total Category
        </TD>
        <TD CLASS="total" colspan="1" STYLE="text-align:left;padding-left:5;">
                    
            <DIV NAME="" ID="">
                <%//=iTotal%>
            </DIV>
        </TD>
    </TR>
    -->
    </table>




</body>
</html>
