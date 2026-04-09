<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
String context = metaMgr.getContext();


WebBusinessObject failure = (WebBusinessObject) request.getAttribute("failure");

  String tradeId = failure.getAttribute("tradeId").toString();
  WebBusinessObject tradeList = new WebBusinessObject();
  tradeList = tradeMgr.getOnSingleKey(tradeId);
  String tradeName = tradeList.getAttribute("tradeName").toString();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status;
String failure_title, failre_desc,goupFCode;
String title_1,title_2;
String cancel_button_label;
String save_button_label;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    failure_title="Title";
    failre_desc="Description";
    title_1="View Failure Code";
    title_2="All information are needed";
    cancel_button_label="Back To List";
    save_button_label="Save ";
    langCode="Ar";
    goupFCode="Group of Failure code";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    failure_title="&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
    failre_desc="&#1575;&#1604;&#1608;&#1589;&#1601; ";
    
    title_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
    goupFCode="&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604;";
  
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
 function cancelForm()
        {    
        document.PROJECT_VIEW_FORM.action = "<%=context%>//FailureCodeServlet?op=ListFailureCode";
        document.PROJECT_VIEW_FORM.submit();  
        }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - view Failure Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=goupFCode%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=dir%>" class='td'>
                        <input disabled type="TEXT" name="tradeName" ID="tradeName" STYLE="width:230px" size="34" value="<%=tradeName%>" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=failure_title%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=dir%>" class='td'>
                        <input disabled type="TEXT" name="title" ID="title" STYLE="width:230px" size="34" value="<%=failure.getAttribute("title")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=failre_desc%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <TEXTAREA DISABLED  rows="5" name="description" STYLE="width:230px" ID="description" cols="27"><%=failure.getAttribute("description")%></TEXTAREA>
                        <!--
                        <input disabled type="TEXT" name="description" ID="description:" size="33" value="<%//=failure.getAttribute("description")%>" maxlength="255">
                    -->
                    </TD>
                </TR>
            </TABLE>
        </FORM>
        <br>
        </fieldset>
    </BODY>
</HTML>     
