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
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="View";
        sCancel="Back";
        sOk="Ok";
        langCode="Ar";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        sOk="&#1605;&#1608;&#1575;&#1601;&#1602;";
        langCode="En";
    }
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
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
        <button  onclick="JavaScript: history.back(0);" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
        <br>
        <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                                <%=sTitle%>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <table align="center">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <TR>
                    <TD class='td'>
                        <img name='docImage' alt='document image' src='<%=imagePath%>' >
                    </TD>
                </tr>
            </table>
        </fieldset>
    </BODY>
</HTML>     
