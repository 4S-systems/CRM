<%@ page import="com.silkworm.common.*,com.docviewer.db_access.*,com.silkworm.util.DateAndTimeConstants,java.util.ArrayList,com.silkworm.common.swWebApplication"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.db_access.FileMgr,com.silkworm.business_objects.WebBusinessObject"%>
<%@ page import="com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.docviewer.db_access.ImageMgr"%>
<%@ page import="com.docviewer.business_objects.Document,java.util.*,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<HTML>
    
    <%
    System.out.println("in the jsp");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    FileMgr fileMgr = FileMgr.getInstance();
    String fileExtension = null;
    String instTitle =null;
    //String folderName = null;
    WebBusinessObject fileDescriptor = null;
    String iconFile = null;
    String context = metaMgr.getContext();
    Document doc = (Document) request.getAttribute("docObject");
    ImageMgr imgMgr = ImageMgr.getInstance();
    //ArrayList sptrs = null;
    if(doc != null) {
        fileExtension = (String) doc.getAttribute("docType");
        instTitle = doc.getAttribute("instTitle").toString();
        if(instTitle.indexOf("-") >= 0) {
            instTitle = instTitle.substring(instTitle.indexOf("-") + 1);
        }
        //folderName = (String) doc.getAttribute("account");
        fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
        iconFile = (String) fileDescriptor.getAttribute("iconFile");
        // Document sptrDoc = (Document) imageMgr.getOnSingleKey(doc.getAttribute("parentID").toString());
        //String folderID = (String) sptrDoc.getAttribute("parentID");
        // sptrs = imgMgr.getCntrDocsChildren(folderID);
    }
    String status = (String) request.getAttribute("Status");
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    // ArrayList docType = docTypeMgr.getCashedTableAsArrayList();
    long lToday = TimeServices.getDate();
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ArrayList configType = docTypeMgr.getCashedTableAsArrayList();
    // get current date
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
    String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate=sdf.format(cal.getTime());
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer- Create Document</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.DOC_FORM.action = "<%=context%>/InstWriterServlet?op=Update";
        document.DOC_FORM.submit();  
        }
        
                var dp_cal1; 
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('instDate'));

        }

    </SCRIPT>
    
    <BODY>
        <left>
        <%    if(null!=status) {
        
        %>
        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR VALIGN="MIDDLE">
                <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    <%=tGuide.getMessage("updatedoc")%>
                </TD>
                <TD CLASS="tabletitle" STYLE="">
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                </TD>
                <TD CLASS="tableright" colspan="3">
                    
                    <A HREF="<%=context%>/ScheduleServlet?op=ScheduleList">
                        <%=tGuide.getMessage("cancel")%>
                        <IMG SRC="images/cancel.gif">
                    </A>
                </TD>
            </TR>
            <TR>
                <TD class='td'>
                    &nbsp;
                </TD>
            </TR>
        </TABLE>
        
        <b><FONT color='black'><%=tGuide.getMessage("docupdatestatus")%></font><FONT color='red'> <%=status%></font></b>
        <TABLE>
            <TR>
                <TD class='td'>
                    &nbsp;
                </TD>
            </TR>
        </TABLE>
        <%
        } else {
        %>
        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR VALIGN="MIDDLE">
                <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    <%=tGuide.getMessage("updatedoc")%>
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/<%=iconFile%>"
                     </TD>
                <TD CLASS="tabletitle" STYLE="">
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                </TD>  
                <TD CLASS="tableright" colspan="3">
                    <A HREF="<%=context%>/main.jsp">
                        <IMG SRC="images/cancel.gif">
                        <%=tGuide.getMessage("cancel")%>
                    </A>
                    <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">    
                    <A HREF="JavaScript: submitForm();">
                        <IMG SRC="images/save.gif">
                        <%=tGuide.getMessage("updatedoc")%>
                    </A>
                </TD>
            </TR>
        </TABLE> 
        
        <FORM NAME="DOC_FORM" METHOD="POST">                       
            <table>
                <tr>
                    <td class="td" valign="top" >
                        <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                            <input type=HIDDEN name="folderID" value="<%//=folderID%>" >
                            <TR>
                                <TD class='td'>
                                    <LABEL FOR="ISSUE_TITLE">
                                        <p><b><%=tGuide.getMessage("doctitle")%>: </b>&nbsp;
                                    </LABEL>
                                </TD>                                              
                                <TD class='td'>
                                    <input type="TEXT" name="instTitle" ID="instTitle" size="33" value="<%=instTitle%>" maxlength="50">
                                </TD>
                            </TR>
                            
                            
                            <TR>
                                <TD class='td'>
                                    &nbsp;
                                </TD>
                            </TR>
                            <TR>
                                
                                <TD class='td'>
                                    <LABEL FOR="ISSUE_TITLE">
                                        <p><b><%=tGuide.getMessage("configitemtype")%>: </b>&nbsp;
                                    </LABEL>
                                </TD>                                              
                                <TD class='td'>
                                    <SELECT name="configType" STYLE="width:170pt">
                                        <sw:OptionList optionList='<%=configType%>' scrollTo = "<%=doc.getAttribute("configItemType").toString()%>"/>
                                    </SELECT>  
                                </TD>
                            </TR>
                            
                            
                            <TR>
                                <TD class='td'>
                                    &nbsp;
                                </TD>
                            </TR>
                            <TR>
                                <TD class='td'>
                                    <LABEL FOR="ISSUE_TITLE">
                                        <p><b><%=tGuide.getMessage("docdate")%>:</b>&nbsp;
                                    </LABEL>
                                </TD>
                                <%
                                String url = request.getRequestURL().toString();
                                String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                Calendar c = Calendar.getInstance();
                                TimeServices.setDate((String) doc.getAttribute("instDate"));
                                c.setTimeInMillis(TimeServices.getDate());
                                %>
                                <TD class='td'>
                                    <!--SELECT name="month" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                    </SELECT>
                                    <SELECT name="day" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                                    </SELECT>
                                    <SELECT name="year" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                                    </SELECT-->
                                    <input name="instDate" id="instDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" > 
                                </td>
                            </TR>
                            
                            <!--
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                            <p><b><%//=tGuide.getMessage("version")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                            <input type="TEXT" name="version" ID="version" size="10" value="<%//=(String) doc.getAttribute("versionNumber")%>" maxlength="10">
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                            <p><b><%//=tGuide.getMessage("modifiedby")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                            <input type="TEXT" name="modifiedBy" ID="modifiedBy" size="10" value="<%//=(String) doc.getAttribute("modifiedBy")%>" maxlength="10">
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                            <p><b><%//=tGuide.getMessage("reviewedby")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                            <input type="TEXT" name="reviewedBy" ID="reviewedBy" size="10" value="<%//=(String) doc.getAttribute("reviewedBy")%>" maxlength="10">
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                            <p><b><%//=tGuide.getMessage("approvedby")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                            <input type="TEXT" name="approvedBy" ID="approvedBy" size="10" value="<%//=(String) doc.getAttribute("approvedBy")%>" maxlength="10">
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="release_date">
                            <p><b><%//=tGuide.getMessage("releasedate")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            //<%//TimeServices.//setDate((String) // doc.getAttribute("releaseDate"));%>
                            <TD class='td'>
                            <SELECT name="beginMonth" size=1>
                           
                            </SELECT>
                            <SELECT name="beginDay" size=1>
                              
                            </SELECT>
                            <SELECT name="beginYear" size=1>
                               

                            </SELECT>
                            </td>
                            </TR>
                            -->
                            <TR>
                                <TD class='td'>
                                    &nbsp;
                                </TD>
                            </TR>
                            <TR>
                                <TD class='td'>
                                    <LABEL FOR="str_Function_Desc">
                                        <p><b><%=tGuide.getMessage("docdesc")%>:</b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <TEXTAREA rows="5" name="description" cols="25"><%=doc.getAttribute("description").toString()%></TEXTAREA>
                                </TD>
                            </TR>
                        </TABLE>	
                    </td>
                </tr>
            </table>
            <input type="hidden" name="instID" value="<%=(String) doc.getAttribute("instID")%>">
        </FORM>
        <%
        TimeServices.setDate(lToday);
        }
        %>
    </BODY>
</HTML>     
