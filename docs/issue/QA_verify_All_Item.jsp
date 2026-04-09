<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.business_objects.*,com.tracker.common.*, java.util.*"%>
<%@ page import="com.tracker.common.AppConstants,com.maintenance.db_access.*"%>
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
    // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
    
    String context= metaMgr.getContext();
    String projectname = (String) request.getParameter("projectName");
    
    UserMgr userMgr = UserMgr.getInstance();
    String issueId = (String) request.getAttribute("issueId");
    String issueTitle = (String) request.getAttribute("issueTitle");
    String direction = (String) request.getAttribute(AppConstants.DIRECTION);
    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");
    
    //AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
    
    System.out.println("Worker Notes Page" + issueId);
    
    
    
    String[] itemsAttributes = {"itemDesc", "itemPrice"};
    String[] itemsListTitles = {"Item Name", "Price", "Unit", "Quantity", "Total Item Cost", "Note"};//"Is Included",
    
    int s = itemsAttributes.length;
    int t = s+4;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String backTarget=null;
    
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    MaintenanceItemMgr itemMgr = MaintenanceItemMgr.getInstance();
    WebBusinessObject wboItem = null;
    String scheduleID = (String) request.getAttribute("scheduleID");
    Vector machinItemsList = (Vector) request.getAttribute("machineItems");
    Vector catsList = (Vector) request.getAttribute("categories");
    Vector items = (Vector) request.getAttribute("items");
    // Vector quantifiedItems = (Vector) request.getAttribute("quantifiedItems");
    WebBusinessObject wbo = null;
    String status = (String) request.getAttribute("Status");
    
    backTarget=context+"/main.jsp";
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
    }
    
    %>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
         
          document.ISSUE_FORM.action = "<%=context%>/ProgressingIssueServlet?op=SaveStatusEmg&projectName=<%=projectname%>";
          document.ISSUE_FORM.submit(); 
          
        }
        
        function total(){
        var quantity = document.getElementsByName('Quantity');
        var price = document.getElementsByName('Price');
        var id = document.getElementsByName('ID');
        var total = 0;
        for(j = 0; j < quantity.length; j++){
            if(quantity[j].value != ""){
                if(IsNumeric(quantity[j].value)){
                    total = total + (quantity[j].value * price[j].value);
                    document.getElementById("Total" + id[j].value).innerHTML = quantity[j].value * price[j].value;
                } else {
                    quantity[j].value = "";//quantity[j].value.substr(0, quantity[j].value.length - 1);
                    document.getElementById("Total" + id[j].value).innerHTML = "0";
                    //if(quantity[j].value != ""){
                    //    if(IsNumeric(quantity[j].value)){
                    //        total = total + (quantity[j].value * price[j].value);
                    //    }
                    //}
                }
            } else {
                document.getElementById("Total" + id[j].value).innerHTML = "0";
            }
        }
        document.getElementById('tdPTotal').innerHTML = total;
        document.getElementById('totalPrice').value = total;
    }
    
    function IsNumeric(sText)
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;

 
        for (i = 0; i < sText.length && IsNumber == true; i++) 
        { 
            Char = sText.charAt(i); 
            if (ValidChars.indexOf(Char) == -1) 
            {
                IsNumber = false;
            }
        }
        return IsNumber;

    }
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    
    <BODY>
        
        
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>"
                   onclick="reloadAE('<%=langCode%>')" STYLE="background:#cc6699;font-size:15;color:white;font-weight:bold; ">
        </DIV> 
        <left>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <%    if(null!=status) {
            
            %>
            <table width="600" dir="<%=dir%>">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;<%=style%>;">
                        Schedule Closure Form
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        
                        
                        <A HREF="<%=backTarget%>">
                            <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif">
                            Back to list
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        
                    </TD>
                </TR>
                
            </table>
            <b><FONT color='black'>Schedule Saving Status:</font><FONT color='red'> <%=status%></font></b>
            
            <% }else { %>
            
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
                
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;<%=style%>;">
                        Schedule Closure Form
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif">
                        <A HREF="<%=backTarget%>">
                            Back to list
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            Save Status
                        </A>
                    </TD>
                </TR>
            </TABLE>
            
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD class='td'>
                        <FONT color='red' size='+1'>All * Fields are required</FONT> 
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b>Schedule Title<font color="#FF0000"> </font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="text" name="issueTitle" value="<%=issueTitle%>" ID="<%=issueTitle%>" size="33"  maxlength="50">
                    </TD>
                </TR>
            
            </TABLE>
            <input type=HIDDEN name="issueId" value = "<%=issueId%>" >
            
            <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
            <input type=HIDDEN name=filterName value="<%=filterName%>" >
            <input type=HIDDEN name="<%=AppConstants.DIRECTION%>" value="<%=direction%>" >
            
            <BR><BR>
            <TABLE WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
                <TR CLASS="head">
                    <%
                    float total = 0f;
                    for(int i = 0;i<t;i++) {
                    %>
                    <TD nowrap CLASS="firstname" WIDTH="120" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                        <%=itemsListTitles[i]%>
                        </TD>
                    <%
                    }
                    %>
                </TR>
                <%
                for(int i=0; i<catsList.size(); i++) {
                %>
                <TR>
                    <TD BGCOLOR="#c8d8f8" COLSPAN="6"><B><%=catsList.elementAt(i)%></B></TD>
                </TR>
                <%
                for(int j=0; j<machinItemsList.size(); j++) {
                    wbo = (WebBusinessObject) machinItemsList.elementAt(j);
                    int quantity = 0;
                    float itemCost = 0f;
                    String note = new String("");
                    if(wbo.getAttribute("catName").equals(catsList.elementAt(i))) {
                        String rowID = wbo.getAttribute("categoryID").toString();
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        // if(items.indexOf(rowID) > -1){
                        //wboTemp = (WebBusinessObject) quantifiedItems.get(items.indexOf(rowID));
                        //   quantity = new Integer(wboTemp.getAttribute("itemQuantity").toString()).intValue();
                        // itemCost = new Float(wboTemp.getAttribute("totalCost").toString()).floatValue();
                        // total = total + itemCost;
                        // note = wboTemp.getAttribute("note").toString();
                        // }
                        wboItem = (WebBusinessObject) itemMgr.getOnSingleKey(wbo.getAttribute("itemID").toString());
                %>
                <TR>
                    <TD BGCOLOR="white"><%=wbo.getAttribute("itemDesc").toString()%></TD>
                    <TD BGCOLOR="white"><LABEL><%=wbo.getAttribute("itemPrice").toString()%></LABEL></TD>
                    <%
                    ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
                    WebBusinessObject wboTempo = itemUnitMgr.getOnSingleKey((String) wboItem.getAttribute("itemUnit"));
                    %>
                    <TD BGCOLOR="white"><LABEL><%=wboTempo.getAttribute("unitName").toString()%></LABEL></TD>
                    <TD CLASS="shaded"><INPUT TYPE="text" CLASS="shaded" ID="Quantity<%=rowID%>" NAME="Quantity" SIZE="14" ONKEYUP="JavaScript: total();" VALUE="<%=quantity%>"></TD>
                    <!--TD CLASS="shaded"><INPUT TYPE="CHECKBOX" NAME="item" ID="<%//=rowID%>"></TD-->
                    <TD CLASS="shaded" ID="Total<%=rowID%>"><%=itemCost%></TD>
                    <TD>
                        <INPUT TYPE="TEXT" NAME="note<%=wbo.getAttribute("categoryID").toString()%>">
                        <INPUT TYPE="hidden" NAME="Price" ID="Price<%=rowID%>" VALUE="<%=wbo.getAttribute("itemPrice").toString()%>">
                        <INPUT TYPE="hidden" NAME="ID" ID="ID<%=rowID%>" VALUE="<%=wbo.getAttribute("categoryID").toString()%>">
                        <INPUT TYPE="hidden" NAME="itemID" ID="itemID<%=rowID%>" VALUE="<%=rowID%>">
                    </TD>
                </TR>
                <%
                    }
                }
                %>
                <%
                }
                %>
                <TR>
                    <TD></TD>
                    <TD></TD>
                    <TD CLASS="total" colspan="2" STYLE="<%=style%>;padding-right:5;border-right-width:1;">
                        Total Maintenance Project Cost
                    </TD>
                    <TD CLASS="total" colspan="1" STYLE="<%=style%>;padding-left:5;" ID="tdPTotal">
                        <%=total%>
                    </TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="totalPrice" ID="totalPrice" VALUE="<%=total%>"> 
                    </TD>
                    <TD></TD>
                </TR>
            </TABLE>
            <% } %>
        </FORM>
    </BODY>
</HTML>     
