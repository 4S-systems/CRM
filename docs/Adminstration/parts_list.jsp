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
            /* background: #BDD5F1 url(images/gradient.gif) repeat-x top left;*/
            background: #ABCDEF;
            color: #083E76;
            font: bold 14px Times New Roman;
            }
            
            .tRow2
            {
            /* background: #BDD5F1 url(images/gradient.gif) repeat-x top left;*/
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
          
            var partsCheckBox=document.forms[0].part;
            for (i=0;i<partsCheckBox.length;++ i)
              {
              if (partsCheckBox[i].checked)
                {
                    var codeName=partsCheckBox[i].value.split("!#");
                    sendInfo(codeName[0],codeName[1]);
                }
              }
            window.close();  
      }
      
      
      function sendInfo(partId,name){
        var id = partId;
        var name = name;
       
        if(isFound(partId)){
            alert(" that item is exist already in the table");
            return;
        }        
        
        var className="tRow2";
        if((numRows%2)==1)
        {
            className="tRow2";
        }else{
            className="tRow";
        }        
        
        var x = window.opener.document.getElementById('itemTable').insertRow();

        var C1 = x.insertCell(0);
        var C2 = x.insertCell(1);
        var C3 = x.insertCell(2);
        var C4 = x.insertCell(3);
        var C5 = x.insertCell(4);
        var C6 = x.insertCell(5);
        var C7 = x.insertCell(6);
        
        C1.borderWidth = "1px";
        C1.id = "code";
        C1.bgColor = "#FFFFFF";
        C1.className=className;
        
        C2.borderWidth = "1px";
        C2.id = "name1";
        C2.bgColor = "#FFFFFF";
        C2.className=className;
         
        C3.borderWidth = "1px";
        C3.bgColor = "#FFFFFF";
        C3.className=className;
        
        C4.borderWidth = "1px";
        C4.id = "price"; 
        C4.bgColor = "#FFFFFF";
        C4.className=className;

        C5.borderWidth = "1px";
        C5.id = "cost";
        C5.bgColor = "#FFFFFF";
        C5.className=className;
        
        C6.borderWidth = "1px";
        C6.bgColor = "#FFFFFF";
        C6.className=className;
        
        C7.borderWidth = "1px";
        C7.bgColor = "#FFFFFF";
        C7.className=className;
        
        
        C3.innerHTML = "<input type='text' name='qun' ID='qun'  onblur='checNumeric()' size='6' maxlength='5' >";
        C6.innerHTML = "<input type='text' name='note' ID='note' value='Add your Note' size='25'>";
        C7.innerHTML = "<input type='checkbox' name='check' ID='check'>" + "<input type='hidden' name='Hid' ID='Hid'>" + "<input type='hidden' name='des' ID='des'>" + "<input type='hidden' name='cat' ID='cat'>";
        
        var nam=window.opener.document.getElementsByName('name1');
        var code=window.opener.document.getElementsByName('code');
        var pr=window.opener.document.getElementsByName('price');
        var c=window.opener.document.getElementsByName('cost');
        var ids=window.opener.document.getElementsByName('Hid');
        var cat=window.opener.document.getElementsByName('cat');
        
        nam[numRows].innerHTML = name;
        code[numRows].innerHTML = partId;
        pr[numRows].innerHTML = "0";
        c[numRows].innerHTML ="0.0";
        ids[numRows].value=partId;
        cat[numRows].value="";
        
        numRows++;
       
        window.opener.document.getElementById('nRows').value=numRows;

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
       
      function isFound(x){
        var code=window.opener.document.getElementsByName('code');
        var temp1="";
        var temp2="";
        for(var i=0;i<numRows;i++){
            var t=code[i].innerHTML;
           // alert(t);
            t=t.replace(" ","");
            var z=x;
            temp1="";
            temp2="";
            for(n=0;n<t.length;n++){
                temp1+=t.charAt(n).charCodeAt();
            }
            for(c=0;c<z.length;c++){
                temp2+=z.charAt(c).charCodeAt();
            }

            if(t==z) 
                return true;
            }
        
        return false;
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
                Enumeration e = parts.elements();
                String classStyle="tRow2";
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    String partCode = wbo.getAttribute("itemCodeByItemForm").toString();
                  //  partName = wbo.getAttribute("itemDscrptn").toString();
                    partName = wbo.getAttribute("itemDscrptn").toString();
                    flipper++;
                    if((flipper%2) == 1) {
                        classStyle="tRow2";
                    } else {
                        classStyle="tRow";
                    }
                %>
                
                <TR>
                    
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <input type="checkbox" name="part" id="part" value="<%=partCode%>!#<%=partName%>">
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
