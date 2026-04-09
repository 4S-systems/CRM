<%@page import="com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    SupplierMgr supplierMgr = SupplierMgr.getInstance();
    FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
    UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
    String projId =(String) request.getAttribute("projId");
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();
    String filterName = request.getParameter("filterName");
    String filterValue = request.getParameter("filterValue");

    String context = metaMgr.getContext();
    String status = (String) request.getAttribute("Status");
    String message = "";

    //ArrayList arrUrgency = urgencyMgr.getCashedTableAsBusObjects();
    //ArrayList arrFailure = failureCodeMgr.getCashedTableAsBusObjects();
    //ArrayList arrSupplier = supplierMgr.getCashedTableAsBusObjects();

    ArrayList arrayListTemp = new ArrayList();
    //arrayListTemp = maintainableMgr.getCashedTableAsBusObjects();
    ArrayList arrayList = new ArrayList();
    //for (int i = 0; i < arrayListTemp.size(); i++) {
    //   WebBusinessObject wbo = (WebBusinessObject) arrayListTemp.get(i);
    // if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
    //   arrayList.add(wbo.getAttribute("unitName").toString());
    // }
    //}

    // get current date and Time
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String jDateFormat = loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate = sdf.format(cal.getTime());

    String issueStatus = (String) request.getAttribute("issueStatus");



    ArrayList listTrade = new ArrayList();
    listTrade.add("Mechanical");
    listTrade.add("Electrical");
    listTrade.add("Civil");
    listTrade.add("Instrument");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, cancel, cost, maint, save, reason1, reason2, reason3, Titel, addTaskNote, sTitel, MUnit, ReceivedBY, Fcode, uLevel, eBDate, pDesc, M1, M2, sNoData, sLaborCost, sPartCost, attach, externalType, part, total, noTaskNote;
    String FTYP, FDA, desc;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";

        cancel = "Cancel";
        save = "Create";
        Titel = "Attached file";
        sTitel = "Schedule Title ";
        MUnit = "Maintained Unit ";
        ReceivedBY = "To Importer ";
        Fcode = "Failure Code ";
        uLevel = "Urgency Level Type ";
        M1 = "Success";
        M2 = "There Is a problem In Creation";
        eBDate = "Invoice Date";
        pDesc = "Warranty Detail";
        sNoData = "No Data are available for";
        save = "Create";
        sLaborCost = "Labor Cost";
        sPartCost = "Part Cost";
        attach = "Attach file";
        part = "Part";
        externalType = "External Type";
        total = "Totaly";
        reason1 = "Resources Needed Not Found";
        reason2 = "Under Warranty";
        reason3 = "Others";
        maint = " Maintenance View ";
        cost = "Cost";
        addTaskNote = "You must Start The JobOrder ";
        noTaskNote = "You must add maintenance item";
        FTYP = "Document Type";
        FDA = "Document date";
        desc = "Description";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = tGuide.getMessage("cancel");
        Titel = "&#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        M1 = "&#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1576;&#1606;&#1580;&#1575;&#1581; ";
        M2 = "&#1607;&#1606;&#1575;&#1603; &#1605;&#1588;&#1603;&#1604;&#1577; &#1601;&#1609; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        sTitel = " &#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        MUnit = "&#1575;&#1604;&#1608;&#1581;&#1583;&#1607; &#1575;&#1604;&#1605;&#1589;&#1575;&#1606;&#1607;";
        ReceivedBY = " &#1604;&#1604;&#1605;&#1608;&#1585;&#1583;";
        Fcode = " &#1575;&#1604;&#1603;&#1608;&#1583;";
        uLevel = " &#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1576;&#1607;";
        save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1607; ";
        eBDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1601;&#1575;&#1578;&#1608;&#1585;&#1577;";
        pDesc = "&#1578;&#1601;&#1589;&#1610;&#1604; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        sNoData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607; &#1604;";
        save = " &#1587;&#1580;&#1604;";
        sLaborCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
        sPartCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        attach = "&#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        total = "&#1603;&#1604;&#1610;";
        externalType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
        part = "&#1580;&#1586;&#1574;&#1610;";
        reason1 = "&#1593;&#1583;&#1605; &#1578;&#1608;&#1601;&#1585; &#1575;&#1604;&#1605;&#1608;&#1575;&#1585;&#1583;";
        reason2 = "&#1578;&#1581;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        reason3 = "&#1571;&#1582;&#1585;&#1609;";
        maint = "&#1576;&#1610;&#1575;&#1606; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        cost = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577;";
        addTaskNote = "&#1610;&#1580;&#1576; &#1576;&#1583;&#1569; &#1578;&#1606;&#1601;&#1610;&#1584; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        noTaskNote = "\u064A\u062C\u0628 \u0625\u0636\u0627\u0641\u0629 \u0628\u0646\u0648\u062F \u0635\u064A\u0627\u0646\u0629 \u0623\u0648\u0644\u0627";
        FTYP = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        FDA = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        desc = "&#1575;&#1604;&#1608;&#1589;&#1601;";
    }


%>

<script src='silkworm_validate.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    var dp_cal1;
    window.onload = function () {
        dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('docDate'));
    };
   

    function submitForm(){
        
        if(document.getElementById('docDate').value==""){
            alert("Please, enter Date.");
            document.getElementById('docDate').focus();
            return;
        }else if(document.getElementById('description').value=="" ){
            alert("Please fill needed fields.");
            return;
        } else{
            document.EXTERNAL_ORDER_FORM.action = "<%=context%>/UnitDocWriterServlet?op=SaveCustomerFile&projId=<%=projId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.EXTERNAL_ORDER_FORM.submit();
        }
    }

    function cancelForm() {
        document.EXTERNAL_ORDER_FORM.action = "<%=context%>/ClientServlet?op=ListClients";
        document.EXTERNAL_ORDER_FORM.submit();
    }

    function changePic() {
        var fileName = document.getElementById("file1").value;
        var arrfileName = fileName.split(".");
        document.getElementById("fileExtension").value=arrfileName[1];
        document.getElementById("docType").value=arrfileName[1];
       
        if(fileName.length > 0){
            
            if (fileName.indexOf("doc") > -1 || fileName.indexOf("DOC") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("docx") > -1 || fileName.indexOf("DOCX") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("xls") > -1 || fileName.indexOf("XLS") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("xlsx") > -1 || fileName.indexOf("XLSX") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("ppt") > -1 || fileName.indexOf("PPT") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("pptx") > -1 || fileName.indexOf("PPTX") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("pdf") > -1 || fileName.indexOf("PDF") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("htm") > -1 || fileName.indexOf("HTM") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("txt") > -1 || fileName.indexOf("TXT") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("ppt") > -1 || fileName.indexOf("PPT") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("mpp") > -1 || fileName.indexOf("MPP") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("vsd") > -1 || fileName.indexOf("VSD") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';     
            }else if(fileName.indexOf("vsd") > -1 || fileName.indexOf("VSD") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1){
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            }else if(fileName.indexOf("eml") > -1 || fileName.indexOf("EML") > -1){
                document.getElementById("imageName").value = fileName;
                //document.getElementById("file1").value = '';
            }else if(fileName.indexOf("rar") > -1 || fileName.indexOf("RAR") > -1){
                document.getElementById("imageName").value = fileName;
                // document.getElementById("file1").value = '';     
            } else {
                alert("Invalid File type");
                document.getElementById("file1").focus();
                //getNoImage();
                document.getElementById("imageName").value = "";
            }
        } else {
            //getNoImage();
            document.getElementById("imageName").value = "";
        }
    }
</SCRIPT>

<script src='js/ChangeLang.js' type='text/javascript'></script>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Attached file</TITLE>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css">
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css">
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js.js"></script>
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>

    <BODY>
        <FORM action=""  NAME="EXTERNAL_ORDER_FORM" METHOD="POST" ENCTYPE="multipart/form-data">
            <input type="hidden" name="type" id="type" value="client"/>
            <input type=HIDDEN name="docType" id="docType" value="">


            <input type=HIDDEN name="fileExtension" id="fileExtension" value="" >
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%> <IMG alt="" SRC="images/cancel.gif"></button>


                <button  onclick="JavaScript: submitForm();" class="button"><%=save%> <IMG alt="" HEIGHT="15" SRC="images/save.gif"></button>

            </DIV>
            <br>
            <center>
                <fieldset class="set" style="width:95%;border-color: #006699;" >
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color="#F3D596" size="4"><%=Titel%></FONT></td>
                        </tr>
                    </table>


                    <br>
                    <%
                        if (null != status) {
                    %>
                    <%
                        if (status.equalsIgnoreCase("ok")) {
                            message = M1;
                        } else {
                            message = M2;
                        }
                    %>

                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                        <TR BGCOLOR="FBE9FE">
                            <TD STYLE="<%=style%>" class="td">
                                <B><FONT FACE="tahoma" color='blue'><%=message%></FONT></B>
                            </TD>
                        </TR>
                    </TABLE>
                    <br><br>
                    <% }%>


                    <br>
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <TR>
                            <TD class="td" width="50%">
                                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                    <TR>
                                        <TD nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b><%=sTitel%></b></TD>
                                        <TD STYLE="<%=style%>" class='td'>
                                            <input  type="text" name="docTitle" id="docTitle" size="25" value="" maxlength="255" style="width:230px">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD nowrap  STYLE="<%=style%>;font-size: 15px" class="td"><b><%=FTYP%></b></TD>
                                        <TD STYLE="<%=style%>" class='td'>
                                            <SELECT name="configType" style="width:230px">
                                                <sw:WBOOptionList wboList="<%=configType%>" valueAttribute="typeID" displayAttribute="typeName" scrollTo = ""/>
                                            </SELECT>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b><%=FDA%></b></TD>
                                        <td STYLE="<%=style%>"  class="calender">
                                            <input id="docDate" name="docDate" type="text" value="<%=nowDate%>"><img alt="" src="images/showcalendar.gif" >
                                        </td>
                                    </TR>


                                    <TR>
                                        <TD nowrap STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=desc%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                                        <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                                            <TEXTAREA rows="5" style="width:230px" name="description" id="description" cols="80"></TEXTAREA>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b><%=attach%></b></TD>
                                        <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                                            <input type="file" name="file1" style="height: 25px" id="file1" onchange="JavaScript: changePic();">
                                            <input type="hidden" name="imageName" id="imageName" value="">
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD class="td">


                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                            <TD class="td" width="5%">
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>





                </fieldset>
            </center>
        </FORM>
    </BODY>
</HTML>