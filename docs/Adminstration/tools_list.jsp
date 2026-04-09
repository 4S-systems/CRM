<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*,com.maintenance.db_access.EqChangesMgr,com.maintenance.servlets.*,java.text.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.*, com.tracker.db_access.*,com.maintenance.db_access.EquipmentStatusMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<HTML>
     <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Campaigns.Campaigns"  />
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    
    <%
    int noOfLinks=0;
    int count=0;
    String tempcount=(String)request.getAttribute("count");
    String unitName = (String)request.getAttribute("unitName");
    String tName = (String)request.getAttribute("toolName");
    String searchType=request.getAttribute("searchType").toString();
    
    if(tempcount!=null)
        count=Integer.parseInt(tempcount);
    String tempLinks=(String)request.getAttribute("noOfLinks");
    if(tempLinks!=null)
        noOfLinks=Integer.parseInt(tempLinks);
    String fullUrl=(String)request.getAttribute("fullUrl");
    String url=(String)request.getAttribute("url");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    
    String context = metaMgr.getContext();
    
    Vector  tools = (Vector) request.getAttribute("data");
    /**********************************/
    String temp=request.getAttribute("numRows").toString();
    int numRows=Integer.parseInt(temp);
    int total=Integer.parseInt(request.getAttribute("total").toString());
    /**********************************/
    
    WebBusinessObject wbo = null;
    
    String  formName = (String) request.getAttribute("formName");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
     String toolName,toolCode,selectTool,viewEq,toolNum,totalNum;
    
    if(stat.equals("En")){
        
         
        viewEq="List Tools";
        toolCode="Tool Code";
        toolName="Tool Name";
    selectTool="Select Tools";
        toolNum="Number Of Tools";
        totalNum="Total Number Of Tools";
        
    }else{
           viewEq="&#1593;&#1585;&#1590; &#1575;&#1604;&#1571;&#1583;&#1608;&#1575;&#1578;";
        toolCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607;";
        toolName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607;";
         selectTool="&#1571;&#1582;&#1578;&#1585; &#1575;&#1604;&#1571;&#1583;&#1608;&#1575;&#1578;";
        toolNum="&#1593;&#1583;&#1583; &#1575;&#1604;&#1571;&#1583;&#1608;&#1575;&#1578;";
        totalNum="&#1593;&#1583;&#1583; &#1575;&#1604;&#1571;&#1583;&#1608;&#1575;&#1578; &#1575;&#1604;&#1603;&#1604;&#1609;";
        
    }
    %>
    
    <HEAD>
        <TITLE>Tools List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
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

      function addTools(){
          
            var toolsCheckBox=document.forms[0].tool;

            for (m=0;m<toolsCheckBox.length;m++)
              {
              if (toolsCheckBox[m].checked)
                {
                    var data=toolsCheckBox[m].value.split("!#");
                    sendInfo(data[0],data[1],data[2]);
                }
              }
            window.close();  
      }
      
      
      function sendInfo(toolId,toolNo,toolName){
       
        if(isFound(toolNo)){
            alert(" that Tool is exist already in the table");
            return;
        }        
        
        var className="tRow";
        if((numRows%2)==1)
        {
            className="tRow";
        }else{
            className="tRow2";
        }        
        
        var x = window.opener.document.getElementById('listTable').insertRow();
        
        var C1 = x.insertCell(0);
        var C2 = x.insertCell(1);
        var C3 = x.insertCell(2);
        var C4 = x.insertCell(3);
              
        C1.borderWidth = "1px";
        C1.borderColor="black";
        C1.id = "toolNo";
        C1.className=className;
        
        C2.borderWidth = "1px";
        C2.id = "tName";
        C2.className=className;
        
        C3.borderWidth = "1px";
        C3.id = "notes";
        C3.className=className;
        
        C4.borderWidth = "1px";
        C4.className=className;
                
        C3.innerHTML = "<textarea name='notes' id='notes' cols='20' rows='2'>Add Your Notes</textarea>";    
        C4.innerHTML = "<input type='checkbox' name='check' ID='check'>"+"<input type='hidden' name='id' ID='id'>";    

        var cellToolNo=window.opener.document.getElementsByName('toolNo');
        var cellTName=window.opener.document.getElementsByName('tName');
        var cellNotes=window.opener.document.getElementsByName('notes');
        var idCells=window.opener.document.getElementsByName('id');
        
        cellToolNo[numRows].innerHTML = toolNo;
        cellTName[numRows].innerHTML = toolName;
        idCells[numRows].value=toolId;
        
        numRows++;

        window.opener.document.getElementById('nRows').value=numRows;

      }
      
     function getUnitTop(){
           var x =document.getElementById("selectIdTop").value;
           x = parseInt(x);
           
           var searchType="<%=searchType%>";
           
           if(searchType=="code"){
                var name =document.getElementById("recToolCode").value;
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                document.tool_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&toolCode="+res+"&numRows="+numRows+"&searchType=<%=searchType%>";
           }else{
                var name =document.getElementById("recToolName").value;
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                document.tool_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&toolName="+res+"&numRows="+numRows+"&searchType=<%=searchType%>";
           }

           document.tool_form.submit();
     }
       
     function getUnitDown(){
           var x =document.getElementById("selectIdDown").value;
           x = parseInt(x);
           
           var searchType=<%=searchType%>;
           if(searchType=="code"){
                var name =document.getElementById("toolCode").value;
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                document.tool_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&toolCode="+res+"&numRows="+numRows+"&searchType=<%=searchType%>";
           }else{
                var name =document.getElementById("toolName").value;
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                document.tool_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&toolName="+res+"&numRows="+numRows+"&searchType=<%=searchType%>";
           }

           document.tool_form.submit();
       }
       
      function isFound(x){
        var code=window.opener.document.getElementsByName('toolNo');
        var temp1="";
        var temp2="";
        
        for(var i=0;i<numRows;i++){
            var t=code[i].innerHTML;
            t=t.replace(" ","");
            var z=x.replace(" ","");
            
            temp1="";
            temp2="";
            for(n=0;n<t.length;n++){
                temp1+=t.charAt(n).charCodeAt();
            }
            for(c=0;c<z.length;c++){
                temp2+=z.charAt(c).charCodeAt();
            }
            
            if(temp1==temp2) 
                return true;
            }
        
        return false;
    }
    
                      </script>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    
    <BODY>
        <FORM NAME="tool_form" METHOD="POST">
            <script type="text/javascript" src="js/wz_tooltip.js"></script>
            <script type="text/javascript" src="js/tip_balloon.js"></script>
            
            <input type="hidden" name="recToolName" id="recToolName" value="<%=tName%>">
            <input type="hidden" name="recToolCode" id="recToolCode" value="<%=tName%>">
            
            <BR>
            
            
            <fieldset align="center" class="set" >
            <legend align="center">
                
                
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=viewEq%>          
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
                        <input type="hidden" name="unitName" id="unitName" value="<%=unitName%>">
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
            
            <TABLE ALIGN="CENTER" dir=<fmt:message key="direction" /> WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-style:solid;border-width:2;border-color:black;border-right-WIDTH:2px;">
                <tr>
                    <td>
                        <input type="button" onclick="addTools()" value="Add Tools">
                    </td>
                </tr>                
            </table>
            
            <TABLE ALIGN="CENTER" dir=<fmt:message key="direction" /> WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-style:solid;border-width:2;border-color:black;border-right-WIDTH:2px;">
                
                <TR CLASS="header">
                    
                    <TD CLASS="header" STYLE="border-WIDTH:0;text-align:center;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=selectTool%></B>
                    </TD>
                    
                    <TD STYLE="border-WIDTH:0;text-align:center;padding-right:50;font-size:16;color:white;height:30;">
                        <B><%=toolName%></B>
                    </TD>
                    <TD STYLE="border-WIDTH:0;text-align:center;padding-right:50;font-size:16;color:white;height:30;">
                        <B><%=toolCode%></B>
                    </TD>
                    
                </TR>
                <%
                String equpId,equpName,equpNo;
                int iTotal=0;
                Enumeration e = tools.elements();
                String classStyle="tRow2";
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    equpId = wbo.getAttribute("id").toString();
                    equpName = wbo.getAttribute("unitName").toString();
                    equpNo = wbo.getAttribute("unitNo").toString();
                    
                    if((iTotal%2) == 1) {
                        classStyle="tRow2";
                    } else {
                        classStyle="tRow";
                    }
                
                
                
                %>
                
                <TR>
                    
                    <TD  STYLE="text-align: <fmt:message key="textalign" /> ;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <input type="checkbox" name="tool" id="tool" value="<%=equpId%>!#<%=equpNo%>!#<%=equpName%>">
                        <input type='hidden' name='id' ID='id' value="<%=equpId%>">
                    </TD>
                    
                    <TD  STYLE="text-align: <fmt:message key="textalign" /> ;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <b style="text-decoration: none"><font color="black" size="3"> <%=equpName%></font> </b> 
                    </TD>
                    
                    <TD  STYLE="text-align: <fmt:message key="textalign" />  ;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <b style="text-decoration: none"><font color="black" size="3"> <%=equpNo%></font> </b> 
                    </TD>
                </tr>
                <% }%>
            </TABLE>
            
            <TABLE ALIGN="CENTER" dir=<fmt:message key="direction" /> WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-style:solid;border-width:2;border-color:white;border-right-WIDTH:2px;">
                <TR>
                    <TD CLASS="bar" COLSPAN="2"  STYLE="height:30px;text-align:center;padding-left:5;border-right-width:1;color:Black;font-size:16;">
                        <font color="black" size="4"><B><%=toolNum%></B></FONT>
                    </TD>
                    
                    <TD CLASS="bar" BGCOLOR="#808080" STYLE="height:30px;text-align:center;padding-left:5;color:Black;font-size:16;">
                        <DIV NAME="" ID="">
                            <B><%=iTotal%></B>
                        </DIV>
                    </TD>
                </TR>
                
                <TR>
                    <TD CLASS="bar" BGCOLOR="#808080" COLSPAN="2" STYLE="height:30px;text-align:center;padding-left:5;border-right-width:1;color:Black;font-size:16;">
                        <font color="black" size="4"> <B><%=totalNum%></B></FONT>
                    </TD>
                    
                    <TD CLASS="bar" BGCOLOR="#808080" STYLE="height:30px;text-align:center;padding-left:5;color:Black;font-size:16;">
                        <B><%=total%></B>
                    </TD>
                </TR>
            </table>
            <br>
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
