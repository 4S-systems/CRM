<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>

    <%

        FileMgr fileMgr = FileMgr.getInstance();
        //WebBusinessObject fileDescriptor = null;
        String backTarget=null;
        response.addHeader("Pragma","No-cache");
        response.addHeader("Cache-Control","no-cache");
        response.addDateHeader("Expires",1);

        Document doc = (Document) request.getAttribute("docObject");
       // fileDescriptor = fileMgr.getObjectFromCash(doc.getDocumentType());


       // WebBusinessObject VO = (WebBusinessObject) request.getAttribute("viewOrigin");
        String imagePath = (String) request.getAttribute("imagePath");
        //String filter= (String) VO.getAttribute("filter");
        //String filterValue= (String)VO.getAttribute("filterValue");

        String issueid = (String) request.getAttribute("issueid");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        //if (filter.equals("") || filterValue.equals("")) {
            backTarget=context+"/main.jsp";
       // } else //if(filter.equalsIgnoreCase("PublishDocument")){
            //backTarget=context+"/ConfigurationServlet?op=PublishDocument&publishType="+filterValue;
            //}
            //else
      //  {
            //backTarget=context+"/SearchServlet?op="+filter+"&filterValue="+filterValue;
      //  }

        Document childDoc = null;
        boolean bHasChild = false;

        TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
       // DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
        //ArrayList configType = docTypeMgr.getCashedTableAsArrayList();
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - Document Details</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.DOC_FORM.action = "<%=context%>/ImageWriterServlet?op=CheckDoc";
        document.DOC_FORM.submit();  
        }


        function attachImage()
        {    
        document.IMG_FORM.action = "<%=context%>/ImageWriterServlet?op=SaveDoc";
        document.IMG_FORM.submit();  
        }
        
    </SCRIPT>

    <BODY>
        <left>          

        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR VALIGN="MIDDLE">
                <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    <%=tGuide.getMessage("viewdocumentdetails")%> 
                </TD>
                <TD CLASS="tabletitle" STYLE="">
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                </TD>

                <TD CLASS="tableright" colspan="3">

                    

                    <IMG VALIGN="BOTTOM"   SRC="images/arrow_left_red.gif">
                    <A HREF="JavaScript: history.back(0);"<%//=backTarget%>>
                        <%=tGuide.getMessage("backtolist")%>
                    </A>
                   
  
                </TD>
               
            </TR>
            
                
                </table>
                <TR>
               <TD class='td'>
                          &nbsp;
                  </TD>
              </TR>
        <table>
                <TR>
                <TD class='td'>
                    <img name='docImage' alt='document image' src='<%=imagePath%>' >
                </TD>
                <%
                   // }
                %>
            </tr>
        </table>
    </BODY>
</HTML>     
                    