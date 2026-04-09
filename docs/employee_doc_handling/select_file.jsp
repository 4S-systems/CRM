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
    
    String empID = (String) request.getAttribute("empID");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,SNA,tit1,RU,EMP;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Select File Type";
        tit1="Delete Employee";
        save="Ok";
        cancel="Back To List";
        TT="Select File Type ";
        SNA="Site Name";
        RU="Waiting Business Rule";
        EMP="Employee Name";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit="  &#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601;";
        tit1="&#1581;&#1584;&#1601;   &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
        save="&#1605;&#1608;&#1575;&#1601;&#1602;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
        SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
        EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new issue</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
       function submitForm()
   {    
      document.ISSUE_FORM.action = "<%=context%>/EmployeeDocWriterServlet?op=GetDocForm&empID=<%=empID%>";
      document.ISSUE_FORM.submit();  
   }
     function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/EmployeeServlet?op=ListEmployee";
        document.ISSUE_FORM.submit();  
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
    </SCRIPT>
    
    <BODY>
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button    onclick="submitForm()" class="button"><%=save%>   <IMG SRC="images/don.gif">  </button>
            </DIV> 
            <br><br>
            <fieldset align=center class="set">
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=tit%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR>
                    
                    <input type=HIDDEN name="empID" value="<%=empID%>" >
                    <input type=HIDDEN name="fileExtension" value="<%=fileExtension%>" >
                </TR>
            </TABLE>
            <br>
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><font color="#FF0000">*</font><%=TT%>
                            </b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <SELECT name="DocType">
                            <sw:OptionList optionList='<%=ArchiveFile%>' scrollTo = ""/>
                            
                        </SELECT>
                    </TD>
                    
                    
                    <TD class='td'>
                    </TD>
                </TR>
                
            </TABLE>  
        </FORM>
    </BODY>
</HTML>     
