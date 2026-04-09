<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.silkworm.persistence.relational.UniqueIDGen"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();

String context = metaMgr.getContext();
String status = (String) request.getAttribute("Status");
String cMode= (String) request.getSession().getAttribute("currentMode");

String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;
String saving_status;
String cancel_button_label;
String save_button_label;
String title;
String selectFile;
String errorMsg;
String seePic;
String textAlign;

if(stat.equals("En")){
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="&#1593;&#1585;&#1576;&#1610;";
    cancel_button_label="Cancel ";
    save_button_label="Upload";
    langCode="Ar";
    title="Save Store Data From Excel File";
    selectFile="Please Choose Excel File";
    errorMsg="Error.Check your file structure, see the picture bellow";
    seePic="Please set your Excel file in the format like the picture bellow";
    textAlign="left";
} else {
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    save_button_label="&#1578;&#1581;&#1605;&#1610;&#1604;";
    langCode="En";
    title = "&#1581;&#1601;&#1592; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606; &#1605;&#1606; &#1605;&#1604;&#1601; &#1575;&#1603;&#1587;&#1604;";
    selectFile="&#1575;&#1582;&#1578;&#1585; &#1605;&#1604;&#1601; &#1575;&#1603;&#1587;&#1604;";
    errorMsg="&#1582;&#1591;&#1571;. &#1571;</span>&#1593;&#1583; &#1576;&#1606;&#1575;&#1569; &#1575;&#1604;&#1605;&#1604;&#1601; &#1576;&#1575;&#1604;&#1588;&#1603;&#1604; &#1575;&#1604;&#1605;&#1608;&#1590;&#1581; &#1601;&#1610; &#1575;&#1604;&#1589;&#1608;&#1585;&#1577;";
    seePic="&#1575;&#1593;&#1583;&#1575;&#1583; &#1605;&#1604;&#1601; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606; &#1604;&#1575;&#1576;&#1583; &#1571;&#1606; &#1610;&#1603;&#1608;&#1606; &#1605;&#1591;&#1575;&#1576;&#1602;&#1575; &#1604;&#1604;&#1589;&#1608;&#1585;&#1577;";
    textAlign="right";
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function validateFile(){ 
        var fileName = document.getElementById("xlsFile").value;

        if(fileName.length <= 0){
            alert("Please select a file.");
            document.getElementById("xlsFile").value = "";
            document.getElementById("xlsFile").select();
        } else{
            if(fileName.indexOf("xls") <= -1 ){
                alert("Invalid Document type, required XLS file.");
                document.getElementById("xlsFile").value = "";
                document.getElementById("xlsFile").select();
            } else {
                document.STORE_FORM.action = "<%=context%>/StoreServlet?op=saveImportedStore";
                document.STORE_FORM.submit();
            }
        }
    }
    
    function cancelForm(){    
        document.STORE_FORM.action = "main.jsp";
        document.STORE_FORM.submit();  
    }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Import Store Date from Excel</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    <BODY>
        <FORM NAME="STORE_FORM" METHOD="POST" enctype="multipart/form-data">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  validateFile();" class="button"><%=save_button_label%>&nbsp;<IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            
            <br>
            
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend>

                <%
                if(null!=status) {
                %>
                <br>
                <table align="<%=align%>" dir="<%=dir%>">
                    <TR BGCOLOR="FBE9FE">
                        <td class="td">
                            <font size=4 ><Font COLOR="blue"><%=saving_status%></font>&nbsp;:&nbsp;<Font COLOR="red"><%=errorMsg%></FONT></FONT>
                        </td>
                    </tr> 
                </table>
                <%
                }
                %>
                
                <br>
                <table align="<%=align%>" dir="<%=dir%>">
                    <tr>
                        <td class="td" style="text-align:<%=textAlign%>">
                            <font size=4 COLOR="red" ><%=seePic%></font> 
                        </td>
                    </tr> 
                    <tr>
                        <td class="td">
                            <IMG VALIGN="center" SRC="images/Stores.bmp"><br>
                        </td>
                    </tr>
                    <tr>
                        <td class="td" style="text-align:<%=textAlign%>">
                            <font size=4 COLOR="red"><%=selectFile%></font> 
                        </td>
                    </tr>
                    <tr>
                        <td class="td" style="text-align:<%=textAlign%>">
                            <input type="file" name="xlsFile" id="xlsFile" accept="*.xls">
                        </td>
                    </tr>
                </table>
                <br>
            </fieldset>
        </FORM>
    </BODY>
</html>