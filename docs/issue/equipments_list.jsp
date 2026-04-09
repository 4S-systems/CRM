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
    String unitName = (String)request.getAttribute("unitName");
    if(tempcount!=null)
        count=Integer.parseInt(tempcount);
    String tempLinks=(String)request.getAttribute("noOfLinks");
    if(tempLinks!=null)
        noOfLinks=Integer.parseInt(tempLinks);
    String fullUrl=(String)request.getAttribute("fullUrl");
    String url=(String)request.getAttribute("url");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
    SupplierMgr supplierMgr = SupplierMgr.getInstance();
    SupplierEquipmentMgr equipSupMgr = SupplierEquipmentMgr.getInstance();
    AverageUnitServlet averageUnitServlet = AverageUnitServlet.getInstance();
    
    String context = metaMgr.getContext();
    
    String[] projectAttributes = {"unitNo","unitName"};
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
    
    Vector  projectsList = (Vector) request.getAttribute("data");
    
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
    String warntyDate = null;
    String style=null;
    String lang,langCode,semitrailer,truck,attachedEqp,viewTitel,isStandAlon,standAlon,notStandAlon,eq_work,eq_Type,eq_JO,equipment_Status,Basic,Indicators,Quick,eqNum,ListCount,eqs,viewEq,cannotDel,ex,good,poor,workEq,outWork,activ,notActiv,Delete,edit,View,warranty,outwarranty,sCategoryName,catName,cancel;
    
    
    String out_Warranty="";
    String in_Warranty="";
    String excelent_Status="";
    String good_Status="";
    String poor_Status="";
    String active_machine="";
    String nonactive_machine="";
    String with_JobOrder="";
    String without_JobOrder="";
    String category_Name="";
    String work_machine="";
    String outwork_machine="";
    String fieldsettitle="";
    
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        viewTitel="Update Category Data";
        Quick="Quick Summary";
        Basic="Basic Oprations";
        Indicators="Indicators Guide";
        eqNum="Equipment Number";
        ListCount="Listing Resault: ";
        eqs=" Equipment";
        viewEq="List Equipment";
        cannotDel="Cann't Delete";
        //ex="Excellent Status";
        ex=" 75 - 100 %";
        //good="Good Status ";
        good=" 50 - 75 %";
        //poor="Poor Status";
        poor=" 0 - 50 % ";
        workEq="Equipment Inside Service";
        outWork="Equipment Out of Service " ;
        activ="Active Equipment";
        notActiv="Non Active Equipment";
        Delete="Delete";
        edit="Edit";
        View="View";
        warranty = "Machine under Warranty";
        outwarranty = "Machine out of Warranty";
        sCategoryName = "Category for Equipment is ";
        catName = "Category Name for Equipment";
        cancel="Weekly Diary";
        
        projectListTitles[0]="Equipment Code";
        projectListTitles[1]="Equipment Name";
        
        out_Warranty="Machine Out Warranty";
        in_Warranty="Machine under Warranty";
        excelent_Status="Excelent Machine";
        good_Status="Good Machine";
        poor_Status="Poor  Machine";
        active_machine="Active Equipment";
        nonactive_machine="Non Active Equipmentt";
        with_JobOrder="Machine has job orders";
        without_JobOrder="Machine hasn't job orders";
        category_Name="Category Name for Equipment";
        work_machine="Working Equipment";
        outwork_machine="Out of Work Equipment";
        fieldsettitle="List Attchement Equipments ";
        equipment_Status="Equipment Efficient";
        eq_work="Equipment Status";
        eq_Type="Equipment Type";
        eq_JO="Equipment Job Orders";
        isStandAlon="Equipment StandAlone Or Not";
        notStandAlon="Can't Work StandAlone";
        standAlon="May Work StandAlone";
        semitrailer="Equipment can't work only";
        truck="Equipment can work only";
        attachedEqp="Equipment Attched With Another";
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        notActiv=" &#1605;&#1593;&#1583;&#1577; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        activ="&#1605;&#1593;&#1583;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        outWork=" &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
        workEq="&#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607; ";
        poor=" 0 - 50 % ";
        good=" 50 - 75 %";
        ex=" 75 - 100 %";
        //    poor=" &#1581;&#1575;&#1604;&#1577; &#1585;&#1583;&#1610;&#1574;&#1577;";
        //    good=" &#1581;&#1575;&#1604;&#1577; &#1580;&#1610;&#1583;&#1577;";
        //    ex="&#1581;&#1575;&#1604;&#1577; &#1580;&#1610;&#1583;&#1577; &#1580;&#1583;&#1575;";
        viewTitel="  &#1578;&#1581;&#1583;&#1610;&#1579; &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        Quick="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        Basic="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        Indicators="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        eqNum="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        ListCount="&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1593;&#1585;&#1590; :";
        eqs=" &#1605;&#1593;&#1583;&#1577;";
        viewEq=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        cannotDel="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1575;&#1604;&#1581;&#1584;&#1601;";
        Delete=tGuide.getMessage("delete");
        edit=tGuide.getMessage("edit");
        View= tGuide.getMessage("view");
        String[] projectListTitlesAR = {"  &#1575;&#1587;&#1605; &#1575;&#1604;&#1575;&#1604;&#1600;&#1600;&#1600;&#1577;", " &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;", " &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;", " &#1578;&#1581;&#1585;&#1610;&#1585;", " &#1581;&#1584;&#1601;"/*, "Attach File &#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;","View Files &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;", "Change &#1578;&#1594;&#1610;&#1610;&#1585;", "Show Changes &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578;"*/};
        warranty = "&#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1578;&#1581;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        outwarranty = "&#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        sCategoryName = "&#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        catName = "  &#1583;&#1604;&#1610;&#1604; &#1571;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601; &#1604;&#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        cancel="&#1575;&#1604;&#1575;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1575;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607;";
        projectListTitles[0]="&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        projectListTitles[1]="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        
        out_Warranty="&nbsp;&#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        in_Warranty="&#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1578;&#1581;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        excelent_Status="&#1605;&#1593;&#1583;&#1607; &#1605;&#1605;&#1578;&#1575;&#1586;&#1607;";
        good_Status="&#1605;&#1593;&#1583;&#1607; &#1580;&#1610;&#1583;&#1607;";
        poor_Status="&#1605;&#1593;&#1583;&#1607; &#1587;&#1610;&#1574;&#1607;";
        active_machine="&#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604;";
        nonactive_machine="&#1605;&#1593;&#1583;&#1607; &#1604;&#1575;&#1578;&#1593;&#1605;&#1604;";
        with_JobOrder="&#1605;&#1593;&#1583;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        without_JobOrder="&#1605;&#1593;&#1583;&#1577; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        category_Name="&#1583;&#1604;&#1610;&#1604; &#1571;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601; &#1604;&#1578;&#1604;&#1603; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        work_machine="&#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604;";
        outwork_machine="&#1605;&#1593;&#1583;&#1607; &#1604;&#1575;&#1578;&#1593;&#1605;&#1604;";
        fieldsettitle="&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1604;&#1581;&#1602;&#1607;";
        equipment_Status="&#1603;&#1600;&#1600;&#1601;&#1600;&#1600;&#1571;&#1577; &#1575;&#1604;&#1600;&#1600;&#1605;&#1600;&#1600;&#1593;&#1600;&#1600;&#1583;&#1607;";
        eq_work="&#1581;&#1600;&#1600;&#1600;&#1575;&#1604;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1607; &#1575;&#1604;&#1600;&#1600;&#1605;&#1600;&#1600;&#1593;&#1600;&#1600;&#1583;&#1607;";
        eq_Type="&#1606;&#1600;&#1600;&#1608;&#1593; &#1575;&#1604;&#1600;&#1600;&#1605;&#1600;&#1600;&#1593;&#1600;&#1600;&#1583;&#1607;";
        eq_JO="&#1575;&#1608;&#1575;&#1605;&#1600;&#1585; &#1575;&#1604;&#1600;&#1600;&#1588;&#1600;&#1600;&#1594;&#1600;&#1600;&#1604;";
        isStandAlon="&#1593;&#1600;&#1600;&#1605;&#1600;&#1600;&#1604; &#1575;&#1604;&#1600;&#1600;&#1605;&#1600;&#1600;&#1593;&#1600;&#1600;&#1583;&#1607;";
        notStandAlon="&#1604;&#1575; &#1578;&#1600;&#1593;&#1600;&#1600;&#1605;&#1600;&#1600;&#1604; &#1576;&#1600;&#1600;&#1605;&#1600;&#1600;&#1601;&#1600;&#1600;&#1585;&#1583;&#1607;&#1575;";
        standAlon="&#1578;&#1600;&#1593;&#1600;&#1600;&#1605;&#1600;&#1600;&#1604; &#1576;&#1600;&#1600;&#1605;&#1600;&#1600;&#1601;&#1600;&#1600;&#1585;&#1583;&#1607;&#1575;";
        semitrailer="&#1605;&#1593;&#1583;&#1607; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1605;&#1601;&#1585;&#1583;&#1607;&#1575;";
        truck="&#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604; &#1576;&#1605;&#1601;&#1585;&#1583;&#1607;&#1575;";
        attachedEqp="&#1605;&#1593;&#1583;&#1607; &#1605;&#1604;&#1581;&#1602;&#1607; &#1593;&#1604;&#1609; &#1605;&#1593;&#1583;&#1607; &#1575;&#1582;&#1585;&#1609;";
    }
    %>
    
    <HEAD>
        <TITLE>Equipments List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/images.css">
        <style>
            .header
            {
            background: #006699 url(images/gradienu.gif);
            color: #ffffff;
            font: bold 16px Times New Roman;
            }
            .tRow
            {
            /*// background: #BDD5F1 url(images/gradient.gif) repeat-x top left;*/
            background: #006699;
            color: #083E76;
            font: bold 14px Times New Roman;
            }
            
            .tRow2
            {
            /*// background: #BDD5F1 url(images/gradient.gif) repeat-x top left;*/
            background: White;
            color: #006699;
            font: bold 14px Times New Roman;
            }
            .bar
            {
            background: #BDD5F1 url(images/gradient.gif) repeat-x top left;
            color: #006699;
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
      function sendInfo(id,name,empName,status){
        var id = id;
        var name = name;
       
        window.opener.document.<%=formName%>.unitId.value = name;
        window.opener.document.<%=formName%>.unitName.value = id;
     //   window.opener.document.<%=formName%>.eqName.value = name;
        window.opener.document.getElementById("eqName").style.fontSize="18px";
        window.opener.document.getElementById("eqName").style.color="Red";
        window.opener.document.getElementById("eqName").style.fontWeight="bold";
        window.opener.document.getElementById("eqName").innerHTML = name;
        
        window.opener.document.getElementById("empName").style.fontSize="16px";
        window.opener.document.getElementById("empName").style.color="Red";
        window.opener.document.getElementById("empName").style.fontWeight="bold";
        window.opener.document.getElementById("empName").innerHTML = empName;
        
        window.opener.document.getElementById("eqStatus").style.fontSize="16px";
        window.opener.document.getElementById("eqStatus").style.color="Blue";
        window.opener.document.getElementById("eqStatus").style.fontWeight="bold";
        window.opener.document.getElementById("eqStatus").innerHTML = status;
        
        window.close();
      }
      
       function getUnitTop(){
           var x =document.getElementById("selectIdTop").value;
           x = parseInt(x);
           var name =document.getElementById("unitName").value;
           var res = ""
           for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
           }
           res = res.substr(0, res.length - 1);
           document.equip_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&unitName="+res;         
           document.equip_form.submit();
       }
       
       function getUnitDown(){
           var x =document.getElementById("selectIdDown").value;
           x = parseInt(x);
           var name =document.getElementById("unitName").value;
           var res = ""
           for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
           }
           res = res.substr(0, res.length - 1);
           document.equip_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&unitName="+res;
           document.equip_form.submit();
       }
    </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    
    <BODY>
        <FORM NAME="equip_form" METHOD="POST">
            <script type="text/javascript" src="js/wz_tooltip.js"></script>
            <script type="text/javascript" src="js/tip_balloon.js"></script>
            
            
            
            
            <BR>
            
            
            <fieldset align="center" class="set" >
            <legend align="center">
                
                
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <%if(url!=null){
                            if(url.contains("ListAttachedEquipment")){
                            %>
                            <font color="blue" size="6">    <%=fieldsettitle%>          
                            </font>
                            <%}else{%>
                            <font color="blue" size="6">    <%=viewEq%>          
                            </font>
                            <%}}else{%>
                            <font color="blue" size="6">    <%=viewEq%>          
                            </font>
                            <%}%>
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
            <TABLE ALIGN="CENTER" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-style:solid;border-width:2;border-color:black;border-right-WIDTH:2px;">
                
                
                <TR CLASS="header">
                    
                    <%
                    String columnColor = new String("");
                    String columnWidth = new String("");
                    String font = new String("");
                    for(int i = 0;i<t;i++) {
                        if(i == 0 || i == 1){
                            columnColor = "#7EB6FF";
                        } else {
                            columnColor = "#7EBB00";
                        }
                        if(projectListTitles[i].equalsIgnoreCase("")){
                            columnColor = "black";
                            font = "1";
                        } else {
                            font = "12";
                        }
                    %>                
                    <TD nowrap CLASS="header" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0;<%=style%>;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=projectListTitles[i]%></B>
                    </TD>
                    <%
                    }
                    %>
                    
                </TR>
                <%
                String statusMsg="";
                EmpBasicMgr empBasicMgr=EmpBasicMgr.getInstance();
                equipmentStatusMgr=EquipmentStatusMgr.getInstance();
                Enumeration e = projectsList.elements();
                String classStyle="tRow2";
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    String equpId = wbo.getAttribute("id").toString();
                    String equpName = wbo.getAttribute("unitName").toString();
                    String empId = wbo.getAttribute("empID").toString();
                    WebBusinessObject empWbo =empBasicMgr.getOnSingleKey(empId);
                    String empName=empWbo.getAttribute("empName").toString();
                    
                    WebBusinessObject eqStatusWbo=equipmentStatusMgr.getLastStatus(equpId);
                    if(eqStatusWbo.getAttribute("stateID").toString().equalsIgnoreCase("2")){
                        statusMsg=outWork;
                    }else{
                        statusMsg=workEq;
                    }
                    //                   WebBusinessObject eqSupWBO = equipSupMgr.getOnSingleKey(wbo.getAttribute("id").toString());
                    //if(eqSupWBO==null)
                    //    continue;
                    flipper++;
                    if((flipper%2) == 1) {
                        classStyle="tRow2";
                    } else {
                        classStyle="tRow";
                    }
                
                
                
                %>
                
                <TR>
                    
                    <%
                    for(int i = 0;i<s;i++) {
                        
                        attName = projectAttributes[i];
                        attValue = (String) wbo.getAttribute(attName);
                    
                    %>
                    
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <a  href="javascript:sendInfo('<%=equpId%>', '<%=equpName%>', '<%=empName%>' ,'<%=statusMsg%>');" >
                        <b style="text-decoration: none"><font color="black" size="3"> <%=attValue%></font> </b> </a>
                    </TD>
                    
                    
                    <%
                    }
                    %>
                </tr>
                <% }%>
                <TR>
                    <TD CLASS="bar" BGCOLOR="#006699"  STYLE="text-align:center;padding-left:5;border-right-width:1;color:Black;font-size:16;">
                        <B><%=eqNum%></B>
                    </TD>
                    
                    <TD CLASS="bar" BGCOLOR="#006699" STYLE="text-align:center;padding-left:5;color:Black;font-size:16;">
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
