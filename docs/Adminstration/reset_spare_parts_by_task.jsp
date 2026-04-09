<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("Status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    
    WebBusinessObject taskWbo=new WebBusinessObject();
    Vector taskParts=new Vector();
    taskWbo=(WebBusinessObject)request.getAttribute("taskWbo");
    taskParts=(Vector)request.getAttribute("taskParts");
    
    String taskName=taskWbo.getAttribute("title").toString();
    String taskId=taskWbo.getAttribute("id").toString();
    
    String context = metaMgr.getContext();
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String[] taskAttributes = {"title", "name"};
    String[] taksListTitles = new String[2];
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    int s = taskAttributes.length;
    int t = s;
    int iTotal = 0;
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    
    ArrayList JobZiseList = new ArrayList();
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status,Dupname;
    String code, code_name;
    String title_1,title_2;
    String cancel_button_label;
    String fStatus;
    String sStatus;
    String save_button_label,Jops,EstimatedHours,Houre,PN, sPerviousItems,tradeName,taskType,Category,JobZise,eng_Desc;
    
    String search,AddCode,AddName,addNew,tCost,itemCode,name,price,count,cost,Mynote,del,scr,add;
    String updateParts,noItems,addSpareParts,viewSpareParts,totalCost;
    String sMaster,sAlter;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        code="Maintenance Item Code";
        code_name="Arabic Description";
        title_1="View Spare Parts for Item";
        Jops="Reqiured Jop";
        EstimatedHours="Expected Duration";
        Houre="  Hour";
        title_2=taskName;
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        Dupname = "Name is Duplicated Chane it";
        taksListTitles[0]="Maintenance Item Code";
        taksListTitles[1]="Arabic Description";
        PN="Maintenance Item No.";
        sPerviousItems = "Pervious Maintenance Items";
        tradeName="Trade Name";
        taskType="Type Of Task";
        Category="Category";
        sStatus="Maintenance Item Saved Successfully";
        fStatus="Fail To Save Maintenance Item ";
        
        add="   Add   ";
        search="Auto search";
        AddCode="  Add using Part Code  ";
        AddName="  Add using Part Name  ";
        addNew="Add new part";
        tCost="Total cost  ";
        itemCode="Code";
        name="Name";
        price="Price";
        count="Quntity";
        cost="Total Price";
        Mynote="Note";
        del="Delete";
        scr="images/arrow1.swf";
        updateParts="View Spare Parts on Maintenance Item "+taskName;
        noItems="No Spare Parts On This Item";
        addSpareParts="alternative items";
        viewSpareParts="view items";
        totalCost="Total cost of spare parts";
        sMaster = "Master";
        sAlter = "Alternative";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583; ";
        code_name="&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1593;&#1585;&#1576;&#1609;";
        Jops="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607; ";
        EstimatedHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578;";
        Houre="   &#1587;&#1575;&#1593;&#1607;";
        title_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1604;&#1604;&#1576;&#1606;&#1583;";
        title_2=taskName;
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1585;&#1576;&#1591; &#1575;&#1604;&#1576;&#1606;&#1583; &#1576;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        langCode="En";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        taksListTitles[0]="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        taksListTitles[1]="&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1593;&#1585;&#1576;&#1609;";
        PN=" &#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        sPerviousItems = "&#1575;&#1604;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602; &#1573;&#1583;&#1582;&#1575;&#1604;&#1607;&#1575;";
        tradeName="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        Category=" &#1575;&#1604;&#1589;&#1606;&#1601;";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        JobZiseList.add("&#1603;&#1576;&#1610;&#1585;");
        JobZiseList.add("&#1605;&#1578;&#1608;&#1587;&#1591;");
        JobZiseList.add("&#1576;&#1587;&#1610;&#1591;");
        JobZise = "&#1581;&#1580;&#1605; &#1575;&#1604;&#1593;&#1605;&#1604;";
        eng_Desc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
        
        add="  &#1571;&#1590;&#1601;  ";
        search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
        AddCode="   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;   ";
        AddName="   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;   ";
        addNew="  &#1571;&#1590;&#1601; &#1602;&#1591;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1607; ";
        tCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;   ";
        itemCode="&#1575;&#1604;&#1603;&#1608;&#1583;";
        name="&#1575;&#1604;&#1573;&#1587;&#1605;";
        price="&#1575;&#1604;&#1587;&#1593;&#1585; ";
        count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
        cost=" &#1575;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
        Mynote="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        del="&#1581;&#1584;&#1601; ";
        scr="images/arrow2.swf";
        updateParts="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1604;&#1604;&#1576;&#1606;&#1583; "+taskName;
        noItems="&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1607; &#1576;&#1575;&#1604;&#1576;&#1606;&#1583;";
        addSpareParts="&#1576;&#1583;&#1575;&#1574;&#1604; &#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        viewSpareParts="&#1593;&#1585;&#1590; &#1575;&#1604;&#1576;&#1583;&#1575;&#1574;&#1604;";
        totalCost="\u0627\u062C\u0645\u0627\u0644 \u0627\u0644\u062A\u0643\u0644\u0641\u0647 \u0644\u0642\u0637\u0639 \u0627\u0644\u063A\u064A\u0627\u0631";
        sMaster = "&#1585;&#1574;&#1610;&#1587;&#1609;";
        sAlter = "&#1576;&#1583;&#1610;&#1604;";
    }
    String doubleName = (String) request.getAttribute("name");
    
    ArrayList hoursJob = new ArrayList();
    String hour = null;
    for(float i=0; i<60.5; i+=0.5){
        hour=new Float(i).toString();
        hoursJob.add(hour);
    }
    hoursJob.remove(0);
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Failure Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css\headers.css">
        <script src="js/sorttable.js"></script>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
   
     function cancelForm()
        {    
        document.ITEM_FORM.action = "main.jsp";
        document.ITEM_FORM.submit();  
        }

    function setAlternativeItems(mainItemId){
        
         window.location="<%=context%>/TaskServlet?op=setAlternativeItems&taskId=<%=taskId%>&mainItemId="+mainItemId;
    }

   
        
       function submitForm() {
           if(parseInt(countA) == 0 || parseInt(countA) <0){
               alert("select at least one alternative item");
            }else{
                document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=migrateAlterItemParts&taskId=<%=taskId%>";
                document.ITEM_FORM.submit();
            }
        }

        var countA = 0;

        function changeItem(crt){
            if(document.getElementById('m_'+crt.value).checked==true){
                document.getElementById('a_'+crt.value).checked = false;
            }else if(document.getElementById('a_'+crt.value).checked==true){
                document.getElementById('m_'+crt.value).checked = false;
            }
        }

        function getCountM(crt){
            if(document.getElementById('m_'+crt.value).checked==true){
                countM = parseInt(countM) +1;
            }else{
                countM = parseInt(countM) -1;
            }
        }
        
        function getCountA(crt){
            if(document.getElementById('m_'+crt.value).checked==false){
                if(document.getElementById('a_'+crt.value).checked==true){
                countA = parseInt(countA) +1;
            }else{
                countA = parseInt(countA) -1;
                if(parseInt(countA)<0){
                    countA =0;
                }
            }
            }
            
        }

    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="ITEM_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <% if(taskParts.size()>0) { %>
                &ensp;
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%></button>
                <% } %>
            </DIV>
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <table align="<%=align%>" dir=<%=dir%>>
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                    
                </TR>
            </table>
            <br>
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="750">
                <TR>
                    <TD CLASS="header" bgcolor="darkgoldenrod" STYLE="text-align:center;color:White;font-size:16;height:30;">
                        <B><%=updateParts%></B>                   
                    </TD>
                </TR>
            </TABLE>
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" id="sortable" WIDTH="750" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:0px;">
                <TR>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="400">
                        <b><%=sMaster%></b>
                    </TH>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="400">
                        <b><%=sAlter%></b>
                    </TH>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="150">
                        <b><%=itemCode%></b>
                    </TH>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="250">
                        <b><%=name%></b>
                    </TH>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="50">
                        <b><%=count%></b>
                    </TH>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="50">
                        <b><%=price%></b>
                    </TH>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="100">
                        <b><%=cost%></b>
                    </TH>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="250">
                        <b><%=Mynote%></b>
                    </TH>
                    <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="250">
                        <b>&nbsp;</b>
                    </TH>
                     <TH CLASS="header" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14;height:30;" WIDTH="250">
                        <b>&nbsp;</b>
                    </TH>
                    
                </TR>
                <%
                WebBusinessObject taskPartWbo=new WebBusinessObject();
                String classStyle="tRow2";
                if(taskParts.size()>0){
                    for(int i=0;i<taskParts.size();i++){
                        taskPartWbo=new WebBusinessObject();
                        taskPartWbo=(WebBusinessObject)taskParts.get(i);
                        if((i%2)==1){
                            classStyle="tRow2";
                        }else{
                            classStyle="tRow";
                        }
                %>
                <TR>
                    <% if(i==0){ %>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="400" id="code">
                        <input type="radio" checked onclick="javascript:changeItem(this);"  id="m_<%=taskPartWbo.getAttribute("id").toString()%>" name="masterItem" value="<%=taskPartWbo.getAttribute("id").toString()%>">
                    </TD>
                    <% }else{ %>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="400" id="code">
                        <input type="radio" onclick="javascript:changeItem(this);"  id="m_<%=taskPartWbo.getAttribute("id").toString()%>" name="masterItem" value="<%=taskPartWbo.getAttribute("id").toString()%>">
                    </TD>
                    <% } %>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="400" id="code">
                        <input type="checkbox" onclick="javascript:changeItem(this);getCountA(this);" id="a_<%=taskPartWbo.getAttribute("id").toString()%>" name="alterItem" value="<%=taskPartWbo.getAttribute("id").toString()%>">
                    </TD>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="100" id="code">
                        <%=taskPartWbo.getAttribute("itemId").toString()%>
                    </TD>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="100" id="code">
                        <%=taskPartWbo.getAttribute("itemId").toString()%>
                    </TD>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="250" id="name1">
                        <%=taskPartWbo.getAttribute("itemName").toString()%>
                    </TD>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="50">
                        <%=taskPartWbo.getAttribute("itemQuantity").toString()%>
                    </TD>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="50" id="price">
                        <%=taskPartWbo.getAttribute("itemPrice").toString()%>
                    </TD>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="50"  >
                       <input  class='blackFont' type='text' id="cost"  value="<%=taskPartWbo.getAttribute("totalCost").toString()%>" name="cost" />
                    </TD>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="200">
                        <%=taskPartWbo.getAttribute("note").toString()%>
                    </TD>
                    <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="200">
                        <input type="button" value="<%=addSpareParts%>" onclick="javascript:setAlternativeItems('<%=taskPartWbo.getAttribute("itemId").toString()%>');"/>
                    </TD>

                </TR>

                <%}%>
                <TR bgcolor="#E8E8FF">
                    <td></td>
                    <td></td>
                    <td></td>
                    <td CLASS="blueBorder blackFont" STYLE="height: 25px" width="65%" ><font size="3" color="black"><b><%=totalCost%></b></font></td>
                    
                    <td CLASS="blueBorder blackFont" width="35%"><font size="3"><b><input type="text" name="totalCost"  readonly ID="totalCost" value="" maxlength="255" STYLE="text-align: center;font-weight: bold;background-color: yellow;  color: black;font-size: 14px" ></b></font></td>
                </TR>
                <% String st="<script>document.writeln(total)</script>";
                String totCost=st;
                //String totCost=request.getParameter("totalCost");
                //request.getSession().setAttribute("totalCost", totCost);
                %>
                <%}else{%>
                <tr>
                    <TD CLASS="tRow2" COLSPAN="6" STYLE="text-align:center;color:black;font-size:14;height:30;" WIDTH="100%">
                        <font color="red" size="4">
                            <%=noItems%>
                        </font> 
                    </TD>
                </tr>
                <%}%>

            </TABLE>

            <br>
        </FORM>
    </BODY>
</HTML>     
