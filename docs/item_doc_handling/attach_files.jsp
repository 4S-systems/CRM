<%@ page import="com.silkworm.common.*,com.docviewer.db_access.*,com.silkworm.util.DateAndTimeConstants,java.util.ArrayList,com.silkworm.common.swWebApplication"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.db_access.FileMgr,com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String fileExtension = (String) request.getAttribute("fileExtension");
    String imAttStatus = (String) request.getAttribute("status");
    
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
    String iconFile = (String) fileDescriptor.getAttribute("iconFile");
    
    String fileMetaType = (String) fileDescriptor.getAttribute("metaType");
    
    String pIndex = request.getParameter("pIndex");
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    
    String[] allFiles = (String[]) request.getAttribute("allfiles");
    
    String itemID = (String) request.getAttribute("itemID");
    String docType = (String) request.getAttribute("docType");
    
    String op=null;
    
    
    
String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status,choose_file;
    String title_1,title_2;
    String choose_type;
    //String cat_name, part_name, part_code, part_unit, store_name, part_price;
    String cancel_button_label, info;
    String save_button_label;
    if(stat.equals("En")){

        saving_status="Attaching status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
       info="Please attach a document before entering data";
        choose_type="Choose file type";
        title_1="Attach a document";
        choose_file="Choose file";
        cancel_button_label=" Return to menu ";
        save_button_label="Attach file";
        langCode="Ar";
    }else{

        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        choose_type=" &#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601;";
        info="&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; ";
        title_1=" &#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
       choose_file="&#1573;&#1582;&#1578;&#1575;&#1585; &#1575;&#1604;&#1605;&#1604;&#1601;";
        cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
        save_button_label="&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        langCode="En";
    }
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer- Create Document</TITLE>
       <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">


        function attachImage()
        {    
        document.IMG_FORM.action = "<%=context%>/ItemDocWriterServlet?op=AttachImage&fileExtension=<%=fileExtension%>&itemID=<%=itemID%>&docType=<%=docType%>&categoryId=<%=request.getAttribute("categoryId").toString()%>&pIndex=<%=pIndex%>";
        document.IMG_FORM.submit();  
        }
         function changePage(url){
                window.navigate(url);
    }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    
    <BODY>
        
        
         <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: changePage('<%=context%>/ItemsServlet?op=ShowItem&categoryId=<%=request.getAttribute("categoryId").toString()%>&itemID=<%=itemID%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button  onclick="JavaScript: attachImage();" class="button"><%=save_button_label%><IMG SRC="images/attach.gif"></button>
              </DIV> 
             <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6">    <%=title_1%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
        
        
        <TABLE dir="<%=dir%>" align="<%=align%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            
                
                
                
                
                
                   
                    
                    <%
                    if(null!=allFiles && (allFiles.length!=0)) {
        int s = allFiles.length;
        int i = 0;
        for(i=0;i<s;i++) {
                    
                    %>
                    <IMG   SRC="images/<%=iconFile%>">
                    <%=allFiles[i]%>
                    
                    
                    <%
                    }
                    
                    %>
                    
                    
                    
                    <%
                    }
                    %>
                    
                    
                    <% //if(fileMetaType.equalsIgnoreCase("image"))
                    // {
                    %>                      
                    <!--          
                    <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                    <IMG SRC="images/don.gif">
                    <A HREF="<%=context%>/ImageWriterServlet?op=DoneAttach&fileExtension=<%=fileExtension%>">
                    <%=tGuide.getMessage("doneattaching")%>
                    </A>
                    -->
                    <%
                    //  }
                    %>                 
                    
                    
                </TD>
            </TR>
        </TABLE>
        
        
        <table dir="<%=dir%>" align="<%=align%>"> 
            <tr><td>
            </td></tr>
        <tr><td class="mes" align=center> </td></tr> </table>      
        
        <% if(null!=imAttStatus) {
        %>
        <table dir="<%=dir%>" align="<%=align%>"> 
            <tr><td>
            </td></tr>
            <tr><td class="td" align=center>  <font size="4"> <%=imAttStatus%> : <%=saving_status%>  </td>
                 
        </tr> </table>
        
        <%
        }
        %>
        
        <FORM name="IMG_FORM" action="<%=context%>/ImageWriterServlet?op=SaveDoc" method="post" enctype="multipart/form-data">
            <TABLE dir="<%=dir%>" align="<%=align%>" name="SUB_TABLE" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <%/**/%>
                <!--
                <TR COLSPAN="2" ALIGN="CENTER">
                    <TD class='td'>
                        <font color="#FF0000"> <b> <%/*=info*/%></b></font>
                        <input type=HIDDEN name="docType" value="<%=docType%>" >
                        <input type=HIDDEN name="itemID" value="<%=itemID%>" >
                    </td>
                    
                    
                </tr>
                -->
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD class='td'>
                        <LABEL FOR="FILE_CHOOSER">
                            <p><b><%=choose_file%>&nbsp;&nbsp;<%/*=fileDescriptor.getAttribute("fileType")*/%>  </b>&nbsp;
                        </LABEL>
                    </td>
                    <TD class='td'>
                        
                        <input type="file" name="file1">
                        
                    </td>
                    
                    
                    
                </tr>
            </table>
        </form>
        <br><br><br>
        
        
        
        
    </BODY>
</HTML>     
