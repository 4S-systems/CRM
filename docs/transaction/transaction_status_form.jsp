<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.business_objects.*,com.tracker.common.*, java.util.*"%>
<%@ page import="com.tracker.common.AppConstants"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Schedule</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    
    String context= metaMgr.getContext();
    String sTransactionID = request.getParameter("transactionID");
    Hashtable hashStatus = new Hashtable();
    UserMgr userMgr = UserMgr.getInstance();
    
    String filterName = request.getParameter("filterName");
    String filterValue = request.getParameter("filterValue");
    Vector vecStatus = new Vector();
    vecStatus.add("Granted");
    vecStatus.add("Not Available");
    vecStatus.add("Partially");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,sChangeStatus,BackToList,save,AllRequired,note,sStatus, sTransactionNO
            ;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        sChangeStatus="Change Transaction Status";
        BackToList = "Back to list";
        save = " Save ";
        AllRequired="(*) All data must be filled";
        sStatus="Status";
        note="Notes";
        hashStatus.put("Granted","Granted");
        hashStatus.put("Not Available","Not Available");
        hashStatus.put("Partially","Partially");
        sTransactionNO = "Transaction NO.";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sChangeStatus="&#1578;&#1594;&#1610;&#1585; &#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        save="&#1578;&#1587;&#1580;&#1610;&#1604;";
        AllRequired=" &#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
        sStatus="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        note="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        hashStatus.put("Granted","&#1603;&#1604; &#1575;&#1604;&#1591;&#1604;&#1576;");
        hashStatus.put("Not Available","&#1604;&#1575; &#1610;&#1608;&#1580;&#1583;");
        hashStatus.put("Partially","&#1576;&#1593;&#1590; &#1575;&#1604;&#1591;&#1604;&#1576;");
        sTransactionNO = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1591;&#1604;&#1576;";
    }
    %>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/TransactionServlet?op=SaveChangeStatus&transactionID=<%=request.getParameter("transactionID")%>";
        document.ISSUE_FORM.submit();  
        }
 
    
        function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/TransactionServlet?op=ListTransaction&filterValue=<%=filterValue%>";
        document.ISSUE_FORM.submit();  
        }
                                    
    
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="13" SRC="images/save.gif"></button>
                
                
            </DIV>  
            <br><br>
            <fieldset align=center class="set" >
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"> <%=sChangeStatus%>                  
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <br><br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=sTransactionNO%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="text" readonly name="transactionNO" style="width:230px;" value="<%=request.getParameter("transactionNO")%>" />
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><%=sStatus%>  <font color="#FF0000"> </font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <select name="status" id="status" style="width:230px;">
                                <%
                                for(int i = 0; i < vecStatus.size(); i++){
                                %>
                                <option value="<%=vecStatus.get(i)%>"><%=hashStatus.get(vecStatus.get(i))%>
                                <%
                                }
                                %>
                            </select>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=note%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <TEXTAREA rows="5" name="note" cols="26"></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>
                <br><br>
                <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
                <input type=HIDDEN name=filterName value="<%=filterName%>" >
                <input type=HIDDEN name=transactionID value="<%=sTransactionID%>" >
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
