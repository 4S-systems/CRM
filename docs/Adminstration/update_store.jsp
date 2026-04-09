<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    String status = (String) request.getAttribute("Status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    WebBusinessObject store = (WebBusinessObject) request.getAttribute("store");
    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
    employeeMgr.cashData();
    ArrayList empList = new ArrayList();
    Vector empsVector = employeeMgr.getOnArbitraryKey("1","key1");
    if(empsVector != null){
        for(int i=0; i<empsVector.size(); i++){
            WebBusinessObject empWbo = (WebBusinessObject)empsVector.elementAt(i);
            empList.add(empWbo);
        }
    }
    LiteWebBusinessObject employee = employeeMgr.getOnSingleKey(store.getAttribute("empID").toString());
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String store_number, store_name, store_location, store_manager, store_phone,Dupname;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        store_number="Store number";
        store_name="Store name";
        store_location="Store location";
        store_manager="Responsible manager";
        store_phone="Phone";
        
        
        title_1="Update Store";
        title_2="All information are needed";
        cancel_button_label="Back To List ";
        save_button_label="Save ";
        langCode="Ar";
        Dupname = "Name is Duplicated Chane it";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        store_number="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        store_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        store_location="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        store_manager="&#1575;&#1604;&#1605;&#1583;&#1610;&#1585; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        store_phone="&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
        
        
        title_1="&#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
           Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
   
    }
    String doubleName = (String) request.getAttribute("name");
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Employee</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            if (!validateData("req", this.STORE_FORM.storeNo, "Please, enter Store Number.") || !validateData("numeric", this.STORE_FORM.storeNo, "Please, enter a valid Store Number.")){
                this.STORE_FORM.storeNo.focus();
            } else if (!validateData("req", this.STORE_FORM.storeName, "Please, enter Store Name.") || !validateData("minlength=3", this.STORE_FORM.storeName, "Please, enter a valid Store Name.")){
                this.STORE_FORM.storeName.focus();
            } else if (!validateData("req", this.STORE_FORM.location, "Please, enter Store Location.") || !validateData("minlength=3", this.STORE_FORM.location, "Please, enter a valid Store Location.")){
                this.STORE_FORM.location.focus();
            } else if (!validateData("req", this.STORE_FORM.phone, "Please, enter Store Phone.") || !validateData("numeric", this.STORE_FORM.phone, "Please, enter a valid Store Phone.") || !validateData("minlength=7", this.STORE_FORM.phone, "Please, enter a valid Store Phone.")){
                this.STORE_FORM.phone.focus();
            } else{
                document.STORE_FORM.action = "<%=context%>/StoreServlet?op=UpdateStore";
                document.STORE_FORM.submit();  
            }
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
    
    function checkEmail(email) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            return (true)
        }
            return (false)
    }
    
    function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
    
      function cancelForm()
        {    
        document.STORE_FORM.action = "StoreServlet?op=ListStores";
        document.STORE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="STORE_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend> 
             <%
            if(null!=doubleName) {
            
            %>
            
            <table dir="<%=dir%>" align="<%=align%>">
                <tr>
                    <td class="td">
                        <font size=4 > <%=Dupname%> </font> 
                    </td>
                    
            </tr> </table>
            <%
            
            }
            
            %>    
            <%
            if(null!=status) {
            
            %>
            <table align="<%=align%>" dir=<%=dir%>>
                <tr>
                    
                    <td style="<%=style%> "class="td">
                        <font size=4 color="red">  <%=saving_status%>:<%=status%></font> 
                    </td>
                    
            </tr> </table>
            <%
            
            }
            
            %>
            <center> <font size=4 color="red"><b><%=title_2%></b></font></center> 
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR COLSPAN="2" ALIGN="CENTER">
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="storeNo">
                            <p><b><%=store_number%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" name="storeNo" ID="storeNo" size="33" value="<%=store.getAttribute("storeNo").toString()%>" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="storeName">
                            <p><b><%=store_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" name="storeName" ID="storeName" size="33" value="<%=store.getAttribute("storeName").toString()%>" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>"class='td'>
                        <LABEL FOR="location">
                            <p><b><%=store_location%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" name="location" ID="location" size="33" value="<%=store.getAttribute("location").toString()%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>"class='td'>
                        <LABEL FOR="empID">
                            <p><b><%=store_manager%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <SELECT name="empID" STYLE="width:232px;">
                            <sw:WBOOptionList wboList='<%=empList%>' displayAttribute = "empName" valueAttribute="empId" scrollTo="<%=employee.getAttribute("empName").toString()%>"/>
                        </SELECT>
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>"class='td'>
                        <LABEL FOR="phone">
                            <p><b><%=store_phone%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" name="phone" ID="phone" size="33" value="<%=store.getAttribute("phone").toString()%>" maxlength="255">
                    </TD>
                </TR>
            </TABLE>
            <input type="hidden" name="storeID" id="storeID" value="<%=store.getAttribute("storeID").toString()%>">
        </FORM>
        <br>
        </fieldset>
    </BODY>
</HTML>     
