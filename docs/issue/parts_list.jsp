

<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*,com.maintenance.db_access.EqChangesMgr,com.maintenance.servlets.*,java.text.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.*, com.tracker.db_access.*,com.maintenance.db_access.EquipmentStatusMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    
    <%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    int noOfLinks=0;
    int count=0;
    String tempcount=(String)request.getAttribute("count");
    String partName = (String)request.getAttribute("partName");
    if(tempcount!=null)
        count=Integer.parseInt(tempcount);
    String tempLinks=(String)request.getAttribute("noOfLinks");
    if(tempLinks!=null)
        noOfLinks=Integer.parseInt(tempLinks);
    String fullUrl=(String)request.getAttribute("fullUrl");
    String url=(String)request.getAttribute("url");
    
    /**********************************/
    String temp=request.getAttribute("numRows").toString();
    int numRows=Integer.parseInt(temp);
    /**********************************/
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    //String[] projectAttributes = {"itemCode","itemDscrptn"};
    String[] projectAttributes = {"itemCode","itemName"};
    String[] projectListTitles = new String[4];
    
    int s = projectAttributes.length;
    int t = s;
    int iTotal = 0;
    int flipper = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    String bgColor = null;
    
    boolean active;
    
    Vector  parts = (Vector) request.getAttribute("data");
    
    WebBusinessObject wboCategoryName = null;
    
    WebBusinessObject wbo = null;
    
    EqChangesMgr eqChangesMgr = EqChangesMgr.getInstance();
    String  categoryName = (String) request.getAttribute("categoryName");
    
    EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
    String  formName = (String) request.getAttribute("formName");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,cancel,partsNum;
    
    String partNameLable,partCodeLable,listPartsTitle,selectPart,addParts;
    
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        partNameLable="Part Name";
        partCodeLable="Part Code";
        listPartsTitle="List Spare Parts";
        partsNum="Number Of Parts";
        selectPart="Select Part";
        addParts="Add Parts";
        
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        partNameLable="&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        partCodeLable="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        listPartsTitle="&#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        partsNum="&#1593;&#1583;&#1583; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        selectPart="&#1571;&#1582;&#1578;&#1585; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        addParts="&#1571;&#1590;&#1601; &#1575;&#1604;&#1602;&#1591;&#1593;";
        
    }
            ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
            PriceItemByBranchMgr priceItemByBranchMgr = PriceItemByBranchMgr.getInstance();
            WebBusinessObject activeStoreWbo = new WebBusinessObject();
            WebBusinessObject itemByPriceWbo = new WebBusinessObject();
            Vector activeStoreVec = new Vector();
            Vector itemByPriceVec = new Vector();
            Vector itemByPriceByBranchVec = new Vector();
            activeStoreVec = activeStoreMgr.getActiveStore(session);
            activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
            String branchCode = activeStoreWbo.getAttribute("branchCode").toString();
    %>
    
    <HEAD>
        <TITLE>Spare Parts List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/images.css">
        <style>
            .header
            {
            background: #2B6FBB url(images/gradienu.gif);
            color: #ffffff;
            font: bold 16px Times New Roman;
            }
            .tRow
            {
            background: #ABCDEF;
            color: #083E76;
            font: bold 14px Times New Roman;
            }
            
            .tRow2
            {
            background: White;
            color: #083E76;
            font: bold 14px Times New Roman;
            }
            .bar
            {
            background: #BDD5F1 url(images/gradient.gif) repeat-x top left;
            color: #083E76;
            font: bold 14px Times New Roman;
            }
            td{
            border-right-width:1px;
            }
        </style>
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
       
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
            function cancelForm(url)
        {    
        window.navigate(url);
        }
    </SCRIPT>
    <script type="text/javascript">
      var numRows=<%=numRows%>;

      function addParts(){
          var totalRow = document.getElementById('totalRow').value;
            
            for (i=0;i<totalRow;i++){
                if (document.getElementById('part'+i).checked  == true) {
                   
                    sendCode(document.getElementById('part'+i).value);
                }
            }
            
            window.close();  
      }
      
      
      function sendCode(subPartCode){
        
        window.opener.document.getElementById('TDName').value=subPartCode;

      }
      
       function getUnitTop(){
           var x =document.getElementById("selectIdTop").value;
           x = parseInt(x);
           var name =document.getElementById("partName").value;
           var res = ""
           for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
           }
           res = res.substr(0, res.length - 1);
           document.parts_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&partName="+res+"&numRows="+numRows;
           document.parts_form.submit();
       }
       
       function getUnitDown(){
           var x =document.getElementById("selectIdDown").value;
           x = parseInt(x);
           var name =document.getElementById("partName").value;
           var res = ""
           for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
           }
           res = res.substr(0, res.length - 1);
           document.parts_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&partName="+res+"&numRows="+numRows;
           document.parts_form.submit();
       }
       
      
       
                      </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    
    <BODY>
        <FORM NAME="parts_form" METHOD="POST">
            
            <fieldset align="center" class="set" >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">
                                <%=listPartsTitle%>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            
            <br>
            <%if(noOfLinks>0){%>
            <table align="center">
                <tr>
                    <td class="td" >
                        <b><font size="2" color="red">page No:</font><font size="2" color="black"><%=count+1%></font><font size="2" color="red">from</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                        <input type="hidden" name="partName" id="partName" value="<%=partName%>">
                    </td>
                    <td class="td"  >
                        <select id="selectIdTop" onchange="javascript:getUnitTop();">
                            <%for(int i=0;i<noOfLinks;i++){%>
                            <option value="<%=i%>" <%if(i==count){%> selected <% } %> ><%=i+1%></option>
                            <% } %>
                        </select>
                    </td>
                </tr>
            </table>
            <BR>
            <%}%>
            <TABLE ALIGN="CENTER" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-style:solid;border-width:2;border-color:black;border-right-WIDTH:2px;">
                <tr>
                    <td>
                        <input type="button" onclick="addParts()" value="Add Parts">
                    </td>
                </tr>                
            </table>
            <TABLE ALIGN="CENTER" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-style:solid;border-width:2;border-color:black;border-right-WIDTH:2px;">
                
                <TR CLASS="header">
                    <TD nowrap CLASS="header" STYLE="border-WIDTH:0;<%=style%>;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        #
                    </td>
                    <TD nowrap CLASS="header" STYLE="border-WIDTH:0;<%=style%>;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=selectPart%></B>
                    </TD>
                    <TD nowrap CLASS="header" STYLE="border-WIDTH:0;<%=style%>;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=partNameLable%></B>
                    </TD>
                    <TD nowrap CLASS="header" STYLE="border-WIDTH:0;<%=style%>;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=partCodeLable%></B>
                    </TD>
                </TR>
                
                <%
                int index = 1;
                Enumeration e = parts.elements();
                String classStyle="tRow2";
                while(e.hasMoreElements()) {
                    String price ="0.0";
                    String store = "none";
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    String partCode = wbo.getAttribute("itemCodeByItemForm").toString();
                    String subPartCode = wbo.getAttribute("itemCode").toString();
                  //  partName = wbo.getAttribute("itemDscrptn").toString();
                    partName =(String) wbo.getAttribute("itemDscrptn");
                    if(null == partName)
                        {
                        partName = "";
                     
                        }
                    flipper++;
                    if((flipper%2) == 1) {
                        classStyle="tRow2";
                    } else {
                        classStyle="tRow";
                    }
                    itemByPriceVec = priceItemByBranchMgr.getOnArbitraryDoubleKey(wbo.getAttribute("itemForm").toString(), "key1", wbo.getAttribute("itemCode").toString(), "key");
                    if(itemByPriceVec.size()>0){
                    for(int x=0;x<itemByPriceVec.size();x++){
                    itemByPriceWbo= (WebBusinessObject) itemByPriceVec.get(x);
                    if(itemByPriceWbo.getAttribute("branch") != null && !itemByPriceWbo.getAttribute("branch").equals("") && itemByPriceWbo.getAttribute("branch").equals(branchCode)){
                        itemByPriceByBranchVec.add(itemByPriceWbo);
                    }
                }
                itemByPriceWbo= (WebBusinessObject) itemByPriceByBranchVec.get(0);
                }
                    
                   
                    %>
                
                <TR>
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <%=index++%>
                    </td>
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        
                       
                            <input type="radio" name="part" id="part<%=iTotal-1%>" value="<%=subPartCode%>">
                    </TD>
                    
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <%--<a  href="javascript:sendInfo('<%=partCode%>', '<%=partName%>');">
                        <b style="text-decoration: none"><font color="black" size="3"> <%=partName%></font> </b> 
                        </a>
                        --%>
                        <b style="text-decoration: none"><font color="black" size="3"> <%=partName%></font> </b> 
                    </TD>
                    
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <b style="text-decoration: none"><font color="black" size="3"> <%=partCode%></font> </b> 
                        <%--
                        <a  href="javascript:sendInfo('<%=partCode%>', '<%=partName%>');">
                        <b style="text-decoration: none"><font color="black" size="3"> <%=partCode%></font> </b> </a>
                        --%>
                    </TD>
                </tr>
                <% }%>
                <TR>
                    <TD CLASS="bar" BGCOLOR="#808080"  STYLE="text-align:center;padding-left:5;border-right-width:1;color:Black;font-size:16;">
                        <B><%=partsNum%></B>
                    </TD>
                    
                    <TD CLASS="bar" BGCOLOR="#808080" COLSPAN="2" STYLE="text-align:center;padding-left:5;color:Black;font-size:16;">
                        <DIV NAME="" ID="">
                            <B><%=iTotal%></B>
                            <input type="hidden" name="totalRow" id="totalRow" value="<%=iTotal%>">
                        </DIV>
                    </TD>
                </TR>
                
            </TABLE>
            <table align="center">
                
                <input type="hidden" name="url" value="<%=url%>" id="url" >
                <input type="hidden" name="formName" value="<%=formName%>" id="formName" >
                <%if(noOfLinks>0){%>
                <tr>
                    <td class="td" >
                        <b><font size="2" color="red">page No:</font><font size="2" color="black"><%=count+1%></font><font size="2" color="red">from</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                    </td>
                    <td class="td"  >
                        <select id="selectIdDown" onchange="javascript:getUnitDown();">
                            <%for(int i=0;i<noOfLinks;i++){%>
                            <option value="<%=i%>" <%if(i==count){%> selected <% } %> ><%=i+1%></option>
                            <% } %>
                        </select>
                    </td>
                </tr>
                <%}%>
            </table>
            
        </FORM>
    </BODY>
</html>
