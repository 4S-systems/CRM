<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("Status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    EmployeeTitleMgr employeeTitleMgr = EmployeeTitleMgr.getInstance();
    ArrayList EmpTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
    ArrayList tradeList = tradeMgr.getCashedTableAsBusObjects();
    ArrayList tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
    ArrayList parentUnitList = maintainableMgr.getCategoryAsBusObjects();
    
    String context = metaMgr.getContext();
    Vector  taskList = (Vector) request.getAttribute("data");
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
    String save_button_label,Jops,EstimatedHours,Houre,PN, sPerviousItems,tradeName,taskType,Category;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        code="Maintenance Item Code";
        code_name="Maintenance Item Name";
        title_1="New Maintenance Item";
        Jops="Reqiured Jop";
        EstimatedHours="Expected Duration";
        Houre="  Hour";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        Dupname = "Name is Duplicated Chane it";
        taksListTitles[0]="Maintenance Item Code";
        taksListTitles[1]="Maintenance Item Name";
        PN="Maintenance Item No.";
        sPerviousItems = "Pervious Maintenance Items";
        tradeName="Trade Name";
        taskType="Type Of Task";
        Category="Category";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583; ";
        code_name="&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583; ";
        Jops="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607; ";
        EstimatedHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578;";
        Houre="   &#1587;&#1575;&#1593;&#1607;";
        title_1="&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1580;&#1583;&#1610;&#1583;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        taksListTitles[0]="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        taksListTitles[1]="&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583;";
        PN=" &#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        sPerviousItems = "&#1575;&#1604;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602; &#1573;&#1583;&#1582;&#1575;&#1604;&#1607;&#1575;";
        tradeName="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        Category=" &#1575;&#1604;&#1589;&#1606;&#1601;";
        }
    String doubleName = (String) request.getAttribute("name");
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Failure Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
            if (!validateData("req", this.ITEM_FORM.title, "Please, enter Code.") || !validateData("minlength=3", this.ITEM_FORM.title, "Please, enter a valid Code.")){
                this.ITEM_FORM.title.focus();
            } else if (!validateData("req", this.ITEM_FORM.description, "Please, enter Code Name.") || !validateData("minlength=3", this.ITEM_FORM.description, "Please, enter a valid Code Name.")){
                this.ITEM_FORM.description.focus(); 
            } else if (!validateData("req", this.ITEM_FORM.executionHrs, "Please, enter Expected Duration.") || !validateData("num", this.ITEM_FORM.executionHrs, "Please, enter a valid Expected Duration.")){ 
                this.ITEM_FORM.executionHrs.focus();
            } else if (!validateData("req", this.ITEM_FORM.empTitle, "Please, enter Employee Title.")){
                 this.ITEM_FORM.empTitle.focus(); 
            } else if (!validateData("req", this.ITEM_FORM.tradeName, "Please, enter Trade Name.")){
                this.ITEM_FORM.tradeName.focus(); 
            } else if (!validateData("req", this.ITEM_FORM.taskType, "Please, enter Task Type.")){
                this.ITEM_FORM.taskType.focus(); 
            } else {
                document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=newtask";
                document.ITEM_FORM.submit();  
            }
        }
        
       function checkEmail(email) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            return (true)
        }
            return (false)
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
    
    function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
    
     function cancelForm()
        {    
        document.ITEM_FORM.action = "main.jsp";
        document.ITEM_FORM.submit();  
        }
    
       
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="ITEM_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
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
                    <td class="td">
                        <font size=4 ><%=status%> : <%=saving_status%></font> 
                    </td>
                    
            </tr> </table>
            <%
            
            }
            
            %>
            
            
            
            <table align="<%=align%>" dir=<%=dir%>>
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                    
                </TR>
            </table>
            <br><br>
            <TABLE ALIGN="<%=align%>"  DIR="<%=dir%>" border="0" width="90%" ID="MainTable0">
                <TR>
                    <TD CLASS="td" WIDTH="75%">
                        <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">
                            
                            <!--TR>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="Category">
                                            <p><b><%=Category%><font color="#FF0000">*</font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                                        <SELECT name="categoryName" id="categoryName" style="width:230px">
                                            <//'sw:WBOOptionList wboList='<%//=parentUnitList%>' displayAttribute = "unitName" valueAttribute="id"/>
                                        </SELECT>
                                        
                                    </TD>
                                </TR-->
                           <input type="hidden" name="categoryName" id="categoryName" value="1">
                            <TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="str_Function_Name">
                                        <p><b><%=code%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD STYLE="<%=style%>"class='td'>
                                    <input type="TEXT" name="title" ID="title" size="33" value="" maxlength="255">
                                </TD>
                            </TR>
                            
                            
                            
                            
                            <TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="str_Function_Desc">
                                        <p><b> <%=code_name%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD STYLE="<%=style%>"  class='td'>
                                    <input type="TEXT" name="description" ID="description" size="33" value="" maxlength="255">
                                </TD>
                                
                            </TR>
                            
                            <!--TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="str_Function_Desc">
                                        <p><b> <%=Jops%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                
                        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                            <SELECT name="empTitle" id="empTitle" style="width:230px">
                                <//sw:WBOOptionList wboList='<%//=EmpTitleList%>' displayAttribute = "name" valueAttribute="id"/>
                            </SELECT>
                       </TD>
                       </TR-->
                            <input type="hidden" name="empTitle" id="empTitle" value="1">
                            <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="assign_to">
                                <p><b><%=tradeName%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                            <SELECT name="tradeName" id="tradeName" style="width:230px">
                                <sw:WBOOptionList wboList='<%=tradeList%>' displayAttribute = "tradeName" valueAttribute="tradeId"/>
                            </SELECT>
                            
                        </TD>
                        </TR>
                        
                       
                            
                            <!--TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="assign_to">
                                <p><b><%=taskType%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                            <SELECT name="taskType" id="taskType" style="width:230px">
                                <//sw:WBOOptionList wboList='<%//=tasktypeList%>' displayAttribute = "name" valueAttribute="id"/>
                            </SELECT>
                            
                        </TD>
                        </TR-->
                        <input type="hidden" name="taskType" id="taskType" value="1">
                            <!--TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="str_Function_Desc">
                                        <p><b> <%=EstimatedHours%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD STYLE="<%=style%>"  class='td'>
                                    <input type="TEXT" name="executionHrs" ID="executionHrs" size="4" value="" maxlength="255"><font color="red"><%=Houre%>
                                </TD>
                                
                            </TR-->
                             <input type="hidden" name="executionHrs" id="executionHrs" value="1">
                        </TABLE>
                    </TD>
                    
                    <!--TD class="td" VALIGN="TOP" WIDTH="25%">
                        <TABLE ALIGN="<%//=align%>" dir="<%//=dir%>" WIDTH="300" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                            <TR>
                                <TD CLASS="td" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                                    <B><%//=sPerviousItems%></B>
                                </TD>
                            </TR>
                            <TR CLASS="head">
                                
                                <%
                            //    String columnColor = new String("");
                             //   String columnWidth = new String("");
                              //  String font = new String("");
                              //  for(int i = 0;i<t;i++) {
                                ///    if(i <= 1 ){
                                //        columnColor = "#9B9B00";
                                //    } else {
                                  //      columnColor = "#7EBB00";
                                 //   }
                                  //  if(taksListTitles[i].equalsIgnoreCase("")){
                                   //     columnWidth = "1";
                                   //     columnColor = "black";
                                   //     font = "1";
                                  //  } else {
                                     //   columnWidth = "100";
                                     //   font = "12";
                                  //  }
                                %>                
                                <TD nowrap CLASS="firstname" WIDTH="<%//=columnWidth%>" bgcolor="<%//=columnColor%>" STYLE="border-WIDTH:0; font-size:<%//=font%>;color:white;" nowrap>
                                    <B><%//=taksListTitles[i]%></B>
                                </TD>
                                <%
                             //   }
                                %>
                                
                            </TR>
                            <%
                            
                           // Enumeration e = taskList.elements();
                            
                            
                          //  while(e.hasMoreElements()) {
                            //    iTotal++;
                            //    wbo = (WebBusinessObject) e.nextElement();
                                
                               // flipper++;
                               // if((flipper%2) == 1) {
                               //     bgColor="#c8d8f8";
                              //  } else {
                               //     bgColor="white";
                             //   }
                            %>
                            
                            <TR bgcolor="<%//=bgColor%>">
                                <%
                                //for(int i = 0;i<s;i++) {
                                 //   attName =taskAttributes[i];
                                  //  attValue = (String) wbo.getAttribute(attName);
                                %>
                                
                                <TD  STYLE="<%//=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="cell" >
                                    <DIV >
                                        
                                        <b> <%//=attValue%> </b>
                                    </DIV>
                                </TD>
                                <%
                               // }
                                %>
                              <%// } %>
                                
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" BGCOLOR="#808080" COLSPAN="1" STYLE="<%//=style%>;padding-right:5;border-right-width:1;color:white;font-size:14;">
                                    <B><%//=PN%></B>
                                </TD>
                                <TD CLASS="cell" BGCOLOR="#808080" colspan="1" STYLE="<%//=style%>;padding-left:5;;color:white;font-size:14;">
                                    
                                    <DIV NAME="" ID="">
                                        <B><%//=iTotal%></B>
                                    </DIV>
                                </TD>
                            </TR>
                        </table>
                    </TD-->
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
