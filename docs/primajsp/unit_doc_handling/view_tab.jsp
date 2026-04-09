<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.contractor.db_access.MaintainableMgr, com.maintenance.db_access.*, com.tracker.db_access.*"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
FileMgr fileMgr = FileMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
SupplierMgr supplierMgr = SupplierMgr.getInstance();
DepartmentMgr deptMgr = DepartmentMgr.getInstance();
EmployeeMgr empMgr = EmployeeMgr.getInstance();
SupplierEquipmentMgr equipSupMgr = SupplierEquipmentMgr.getInstance();
EquipOperationMgr eqpOpMgr = EquipOperationMgr.getInstance();
AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
ProductionLineMgr  productionLineMgr = ProductionLineMgr.getInstance();

String context = metaMgr.getContext();
String backTarget=null;

WebBusinessObject equipmentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey((String) request.getAttribute("equipID"));
WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
WebBusinessObject locationWBO = projectMgr.getOnSingleKey(equipmentWBO.getAttribute("site").toString());
WebBusinessObject deptWBO = deptMgr.getOnSingleKey(equipmentWBO.getAttribute("department").toString());
WebBusinessObject productionLineWBO = productionLineMgr.getOnSingleKey(equipmentWBO.getAttribute("productionLine").toString());

WebBusinessObject empWBO = empMgr.getOnSingleKey(equipmentWBO.getAttribute("empID").toString());
WebBusinessObject eqSupWBO = equipSupMgr.getOnSingleKey(equipmentWBO.getAttribute("id").toString());
WebBusinessObject supWBO = supplierMgr.getOnSingleKey((String) eqSupWBO.getAttribute("supplierID"));
WebBusinessObject contEmpWBO = empMgr.getOnSingleKey(eqSupWBO.getAttribute("contractEmp").toString());
Vector eqpOpVector = eqpOpMgr.getOnArbitraryKey(equipmentWBO.getAttribute("id").toString(), "key1");
WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVector.elementAt(0);

String unitName=equipmentWBO.getAttribute("unitName").toString();
request.setAttribute("unitName",unitName);

Vector data=new Vector();
data.add(equipmentWBO);

request.getSession().setAttribute("info", data);
response.addHeader("Pragma","No-cache");
response.addHeader("Cache-Control","no-cache");
response.addDateHeader("Expires",1);

Vector imagePath = (Vector) request.getAttribute("imagePath");

backTarget=context+"/main.jsp";

String dateAcquired = eqSupWBO.getAttribute("purchaseDate").toString();
String expiryDate = eqSupWBO.getAttribute("warrantyExpDate").toString();
EqChangesMgr eqChangesMgr = EqChangesMgr.getInstance();
Vector vecChanges = eqChangesMgr.getOnArbitraryKey(((String) equipmentWBO.getAttribute("id")), "key1");

String equipmentID = (String) request.getAttribute("equipID");
UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
boolean active = maintainableMgr.hasSchedules(equipmentID);
EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
WebBusinessObject tempWbo = equipmentStatusMgr.getLastStatus(equipmentID);
int currentStatus = 2;
if(tempWbo != null){
    String stateID = (String) tempWbo.getAttribute("stateID");
    currentStatus = new Integer(stateID).intValue();
}

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,tit1,RU,EMP,STAT,NO,Reading,Excellent,Good,Poor;
String back="&#1575;&#1604;&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="View File";
    tit1="Select File Type";
    save="Attach";
    cancel="Back To List";
    TT="Select File Type ";
    SNA="Site Name";
    RU="Waiting Business Rule";
    EMP="Employee Name";
    STAT="Attaching Status";
    NO="Attach File Before Filling Information";
    Excellent="Excellent";
    Good="Good";
    Poor="Poor";
}else{
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="  &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;  ";
    tit1="&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    save="&#1573;&#1585;&#1601;&#1602;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
    EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    STAT=" &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    NO="&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
    Excellent="&#1605;&#1605;&#1578;&#1575;&#1586;&#1607;";
    Good="&#1580;&#1610;&#1583;";
    Poor="&#1585;&#1583;&#1610;&#1574;&#1607;";
}
%>

<SCRIPT>
    function changeMode(name){
        if(document.getElementById(name).style.display == 'none'){
            document.getElementById(name).style.display = 'block';
        } else {
             document.getElementById(name).style.display = 'none';
        }
    }
            
    function changePage(url){
        window.navigate(url);
    }
</SCRIPT>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Maintenance - View Equipment Details</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <BODY>
        <fieldset align="center" class="set">
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                                &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; / View Equipment
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            
            <TABLE  WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD CLASS="td">
                        <TABLE  WIDTH="600" CELLPADDING="0" CELLSPACING="0">
                            <TR>
                                <TD CLASS="td" bgcolor="darkgoldenrod" STYLE="text-align:center;color:white;font-size:16" COLSPAN="3">
                                    <B>&#1602;&#1585;&#1575;&#1569;&#1607; &#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; / Equipment Counter Reading</B>
                                </TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                    <B>Total<br>&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;</B>
                                </TD>
                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                    <B>Last Reading<br>&#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</B>
                                </TD>
                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                    <B>Last Reading Date<br>&#1578;&#1575;&#1585;&#1610;&#1582; &#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</B>
                                </TD>                   
                            </TR>
                            
                            <TR>
                                <%
                                Vector items = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                                if(items.size() > 0){
                                    for(int i = 0; i < items.size(); i++){
                                        WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                                        WebBusinessObject categoryName = (WebBusinessObject) maintainableMgr.getOnSingleKey(wbo.getAttribute("unitName").toString());
                                        String unit = "";
                                        if(equipmentWBO.getAttribute("rateType").equals("odometer")){
                                            unit = "km";
                                        } else {
                                            unit = "hr";
                                        }
                                %>
                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=wbo.getAttribute("acual_Reading").toString()%>&nbsp;<%=unit%></TD>
                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=wbo.getAttribute("current_Reading").toString()%>&nbsp;<%=unit%></TD>
                                <%
                                Date d = Calendar.getInstance().getTime();
                                String readingDate = (String) wbo.getAttribute("entry_Time");
                                Long l = new Long(readingDate);
                                long sl = l.longValue();
                                d.setTime(sl);
                                readingDate = d.toString();
                                readingDate = readingDate.substring(0,10)+readingDate.substring(23,28);      
                                %>
                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=readingDate%></TD>
                                <%
                                    }
                                } else {
                                %>
                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;" COLSPAN="3">No Reading for this equipment <br> &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1585;&#1575;&#1569;&#1577; &#1604;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;</TD>
                                <%
                                }
                                %>
                            </TR>
                        </TABLE>
                    </TD>
                    <TD CLASS="td">
                    </TD>
                </TR>
                
                <TR>
                    <TD CLASS="td">&nbsp;</TD>
                    <TD CLASS="td">&nbsp;</TD>
                </TR>
                
                <TR>
                    <TD CLASS="td">
                        <TABLE WIDTH="600" BORDER="0" CELLSPACING="0">
                            <TR>
                                <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                    <B>Basic Information / &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1607;</B>   
                                </TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Asset No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("unitNo")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B><%=tGuide.getMessage("equipmentname")%> / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("unitName")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Engine Number / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("engineNo")%></TD>
                            </TR>
                            
                            <!--TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Auth. Employee / &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=empWBO.getAttribute("empName")%></TD>
                            </TR-->
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Location / &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=locationWBO.getAttribute("projectName")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Department / &#1575;&#1604;&#1602;&#1587;&#1605;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=deptWBO.getAttribute("departmentName")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Production Line / &#1582;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=productionLineWBO.getAttribute("code")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Category / &#1575;&#1604;&#1589;&#1606;&#1601;</B></TD>
                                <TD CLASS="cell" bgcolor="darkkhaki" STYLE="text-align:center;font-size:12"><B><%=wboTemp.getAttribute("unitName")%></B></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Status / &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;</B></TD>
                                <%
                                String status;
                                if(equipmentWBO.getAttribute("status").equals("1")){
                                    status = Excellent;
                                } else if(equipmentWBO.getAttribute("status").equals("2")){
                                    status = Good;
                                } else {
                                    status = Poor;
                                }
                                %>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=status%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B><%=tGuide.getMessage("equipmentdescription")%> / &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("desc")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                    <B>Operation Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1604;</B>   
                                </TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Equipment Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                <TD CLASS="cell" bgcolor="darkkhaki" STYLE="text-align:center;font-size:12"><B><%=equipmentWBO.getAttribute("rateType")%></B></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Operation Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=eqpOpWbo.getAttribute("operation_type")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Average / &#1575;&#1604;&#1605;&#1578;&#1608;&#1587;&#1591;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=eqpOpWbo.getAttribute("average")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                    <B>Manufacturing Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1593;</B>   
                                </TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Manufacturer / &#1575;&#1604;&#1605;&#1589;&#1606;&#1593;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("manufacturer")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Model No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("modelNo")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Serial No / &#1575;&#1604;&#1587;&#1585;&#1610;&#1575;&#1604;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("serialNo")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Notes / &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=eqSupWBO.getAttribute("note")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                    <B>Warranty Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</B>   
                                </TD>
                            </TR>
                            
                            <!--TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Supplier / &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=supWBO.getAttribute("name")%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Contractor  / &#1575;&#1604;&#1605;&#1578;&#1593;&#1575;&#1602;&#1583;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=contEmpWBO.getAttribute("empName")%></TD>
                            </TR-->
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>( Warranty / Contract) Date / &#1578;&#1575;&#1585;&#1610;&#1582; (&#1575;&#1604;&#1590;&#1605;&#1575;&#1606; / &#1575;&#1604;&#1578;&#1593;&#1575;&#1602;&#1583;)</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=expiryDate.substring(0,10)%></TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Perchace Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1588;&#1585;&#1575;&#1569;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=dateAcquired.substring(0,10)%></TD>
                            </TR>
                        </TABLE>
                    </TD>
                    <TD CLASS="td3">
                        <TABLE>
                            <%
                            if(imagePath.size() > 0){
                                    for(int i = 0; i < imagePath.size(); i++){
                            %>
                            <TR>
                                <TD class='td3'>
                                    <img name='docImage' alt='document image' src='<%=imagePath.get(i).toString()%>'  width="250" height="200">
                                </TD>
                            </TR>
                            <%
                                    }
                            } else {
                            %>
                            <TR>
                                <TD class='td'>
                                    <img name='docImage' alt='document image' src='images/no_image.jpg' border="2">
                                </TD>
                            </tr>
                            <%
                            }
                            %>
                        </Table>
                    </TD>
                </TR>
            </TABLE>
            <br>
        </fieldset>
    </BODY>
</HTML>     
