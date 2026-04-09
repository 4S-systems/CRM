<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
  
<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String status = (String) request.getAttribute("status");

WebBusinessObject place = (WebBusinessObject) request.getAttribute("place");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new place</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.PLACES_FORM.action = "<%=context%>/PlaceServlet?op=UpdatePlace";
        document.PLACES_FORM.submit();  
        }

    </SCRIPT>

    <BODY>
        <left>
        <FORM NAME="PLACES_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("updateexistingplace")%> 
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/PlaceServlet?op=ListPlaces">
                            <%=tGuide.getMessage("backtolist")%> 
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("updateplace")%> 
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <%
            if(null!=status) {

            %>

            <h3>   <%=tGuide.getMessage("placeupdatestatus")%> : <font color="#FF0000"><%=status%></font> </h3>
           
            <%

            }

%>
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>

        
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=tGuide.getMessage("placename")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="placeName" ID="placeName" size="33" value="<%=place.getAttribute("placeName")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=tGuide.getMessage("placedesc")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <TEXTAREA rows="5" name="place_desc" cols="25"><%=place.getAttribute("placeDesc")%></TEXTAREA>
                    </TD>
                </TR>
            </TABLE>
            <input type="hidden" name="placeID" ID="placeID" value="<%=place.getAttribute("placeID")%>">
        </FORM>
    </BODY>
</HTML>     
                    