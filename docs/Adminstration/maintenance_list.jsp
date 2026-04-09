<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.ProjectMgr"%>
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

        //AppConstants appCons = new AppConstants();

        String[] maintenanceAttributes = {"maintenanceName"};
        String[] maintenanceListTitles = {"Maintenance Name", "View", "Edit", "Delete"};

        int s = maintenanceAttributes.length;
        int t = s+3;
        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;

        ProjectMgr projectMgr = ProjectMgr.getInstance();

        Vector  maintenanceList = (Vector) request.getAttribute("data");


        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

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
                <IMG WIDTH="20" HEIGHT="20" SRC="images/user.gif">
                <%=tGuide.getMessage("maintenancelist")%>
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
              
                <TD nowrap CLASS="firstname" WIDTH="120" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                    <%=maintenanceListTitles[i]%>
                </TD>
                 
                    
           
                <%
                    }
                %>
            </TR>  
            <%

                Enumeration e = maintenanceList.elements();


                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();

                    flipper++;
                    if((flipper%2) == 1) {
                        bgColor="#c8d8f8";
                    } else {
                        bgColor="white";
                    }
            %>

            <TR bgcolor="<%=bgColor%>">
                <%
                    for(int i = 0;i<s;i++) {
                    attName = maintenanceAttributes[i];
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
                
                <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                    <DIV ID="links">
                        <A HREF="<%=context%>/MaintenanceServlet?op=ViewMaintenance&maintenanceName=<%=wbo.getAttribute("maintenanceName")%>">
                            <%=tGuide.getMessage("view")%>
                        </A>
                    </DIV>
                </TD>

                <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                    <DIV ID="links">
                        <A HREF="<%=context%>/MaintenanceServlet?op=GetUpdateForm&maintenanceName=<%=wbo.getAttribute("maintenanceName")%>">
                            <%=tGuide.getMessage("edit")%>
                        </A>
                    </DIV>
                </TD>
                <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                    <DIV ID="links">
                        <A HREF="<%=context%>/MaintenanceServlet?op=ConfirmDelete&maintenanceName=<%=wbo.getAttribute("maintenanceName")%>">
                            <%=tGuide.getMessage("delete")%>
                        </A>
                    </DIV>
                </TD>
                       
             

           
            </TR>
             
            
            <%

                }

            %>
            <TR>
                <TD CLASS="total" COLSPAN="3" STYLE="text-align:right;padding-right:5;border-right-width:1;">
                    Total Maintenances
                </TD>
                <TD CLASS="total" colspan="1" STYLE="text-align:left;padding-left:5;">
                    
                    <DIV NAME="" ID="">
                        <%=iTotal%>
                    </DIV>
                </TD>
            </TR>
        </table>




    </body>
</html>
