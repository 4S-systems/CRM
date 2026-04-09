<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.international.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.docviewer.db_access.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.silkworm.db_access.FileMgr"%>
<%@ page import="com.silkworm.common.TimeServices"%>


<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    String fileExtension = (String) request.getAttribute("fileExtension");
    ImageMgr imageMgr = ImageMgr.getInstance();
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String pIndex = request.getParameter("pIndex");
    String categoryId = request.getParameter("categoryId");
    WebBusinessObject webIssue = (WebBusinessObject) request.getAttribute("webIssue");
    
    ArrayList ArchiveFile = new ArrayList();
    ArchiveFile.add("Word file");
    ArchiveFile.add("Exel File");
    ArchiveFile.add("PowerPoint file");
    ArchiveFile.add("AdobAcrobat File");
    ArchiveFile.add("Html File");
    ArchiveFile.add("Text File");
    ArchiveFile.add("OutLook File");
    ArchiveFile.add("MSP File");
    ArchiveFile.add("Visio File");
    ArchiveFile.add("WinAce File");
    ArchiveFile.add("IMG File");
    
    String status = (String) request.getAttribute("Status");
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    
    String itemID = (String) request.getAttribute("itemID");
    
    
    
String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String title_1,title_2;
    String choose_type;
    //String cat_name, part_name, part_code, part_unit, store_name, part_price;
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){

        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
       
        choose_type="Choose file type";
        title_1="Choose file type";
        //title_2="All information are needed";
        cancel_button_label=" Return to menu ";
        save_button_label="Ok";
        langCode="Ar";
    }else{

        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        choose_type=" &#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601;";
        
        title_1=" &#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601;";
       // title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
        save_button_label="&#1605;&#1608;&#1575;&#1601;&#1602;";
        langCode="En";
    }
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new issue</TITLE>
       <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
       function submitForm()
   {    
      document.ISSUE_FORM.action = "<%=context%>/ItemDocWriterServlet?op=GetDocForm&itemID=<%=itemID%>&categoryId=<%=request.getAttribute("categoryId").toString()%>&pIndex=<%=pIndex%>";
      document.ISSUE_FORM.submit();  
   }
    function changePage(url){
                window.navigate(url);
    }
    </SCRIPT>
     <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
             <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: changePage('<%=context%>/ItemsServlet?op=ShowItem&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
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
                
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    <input type=HIDDEN name="itemID" value="<%=itemID%>" >
                    <input type=HIDDEN name="fileExtension" value="<%=fileExtension%>" >
                </TR>
            </TABLE>
            
            
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=choose_type%><font color="#FF0000">*</font>
                            </b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"  class='td'>
                        <SELECT name="DocType">
                            <sw:OptionList optionList='<%=ArchiveFile%>' scrollTo = ""/>
                            
                        </SELECT>
                    </TD>
                    
                    
                    <TD class='td'>
                    </TD>
                </TR>
                
            </TABLE>  
        </FORM>
        <br><br><br><br>
    </BODY>
</HTML>     
