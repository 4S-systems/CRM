<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    String status = (String) request.getAttribute("Status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    WebBusinessObject supplierWBO = (WebBusinessObject) request.getAttribute("supplierWBO");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String sup_number,save, sup_name,title_3, sup_address, sup_job, sup_phone, sup_fax, sup_city, sup_mail, sup_service, sup_notes, working_status,TT;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    String fStatus;
    String sStatus;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        sup_name = "Supplier name";
        sup_number = "Supplier number";
        sup_address = "Supplier address";
        sup_job = "Supplier job";
        sup_phone = "Supplier phone";
        sup_fax = "Fax";
        sup_mail = "E-mail";
        sup_city = "Supplier city";
        sup_service = "Supplier service";
        sup_notes = "Notes";
        // sup_city = "Supplier city";
        working_status = "Working";
        TT="Update Status";
        save="Save";
        
        title_1="Delete supplier";
        title_2="All information are needed";
        cancel_button_label="Back To List ";
        save_button_label="Save ";
        langCode="Ar";
        title_3="Update External Supplier";
        sStatus="Supplier Updated Successfully";
        fStatus="Fail To Update This Supplier";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:right";
        lang="English";
        
        sup_name = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        sup_number = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        sup_address = "&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        sup_job = "&#1575;&#1604;&#1605;&#1607;&#1606;&#1607;";
        sup_phone = "&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
        sup_fax = "&#1575;&#1604;&#1601;&#1575;&#1603;&#1587;";
        sup_mail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
        sup_city = "&#1575;&#1604;&#1605;&#1583;&#1610;&#1606;&#1607;";
        sup_service = "&#1575;&#1604;&#1582;&#1583;&#1605;&#1607; ";
        sup_notes = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        //sup_city = "Supplier city";
        working_status = "&#1610;&#1593;&#1605;&#1604;";
        
        
        title_1=" &#1581;&#1584;&#1601; &#1605;&#1608;&#1585;&#1583;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
        TT="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        title_3="&#1578;&#1581;&#1583;&#1610;&#1579; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1605;&#1608;&#1585;&#1583; &#1582;&#1575;&#1585;&#1580;&#1609;";
        save="&#1587;&#1580;&#1604; ";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        
    }
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            if (!validateData("req", this.SUPPLIER_FORM.supplierNO, "Please, enter Supplier Number.") || !validateData("numeric", this.SUPPLIER_FORM.supplierNO, "Please, enter a valid Supplier Number.")){
                this.SUPPLIER_FORM.supplierNO.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.supplierName, "Please, enter Supplier Name.") || !validateData("minlength=3", this.SUPPLIER_FORM.supplierName, "Please, enter a valid Supplier Name.")){
                this.SUPPLIER_FORM.supplierName.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.address, "Please, enter Supplier Address.") || !validateData("minlength=3", this.SUPPLIER_FORM.address, "Please, enter a valid Supplier Address.")){
                this.SUPPLIER_FORM.address.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.designation, "Please, enter Supplier Job.") || !validateData("minlength=3", this.SUPPLIER_FORM.designation, "Please, enter a valid Supplier Job.")){
                this.SUPPLIER_FORM.designation.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.phone, "Please, enter Supplier Phone.") || !validateData("numeric", this.SUPPLIER_FORM.phone, "Please, enter a valid Supplier Phone.") || !validateData("minlength=7", this.SUPPLIER_FORM.phone, "Please, enter a valid Supplier Phone.")){
                this.SUPPLIER_FORM.phone.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.fax, "Please, enter Supplier Fax.") || !validateData("numeric", this.SUPPLIER_FORM.fax, "Please, enter a valid Supplier Fax.") || !validateData("minlength=7", this.SUPPLIER_FORM.fax, "Please, enter Supplier Fax.")){
                this.SUPPLIER_FORM.fax.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.city, "Please, enter Supplier City.") || !validateData("minlength=3", this.SUPPLIER_FORM.city, "Please, enter a valid Supplier City.")){
                this.SUPPLIER_FORM.city.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.email, "Please, enter Supplier Email.") || !validateData("email", this.SUPPLIER_FORM.email, "Please, enter a valid Supplier Email.")){
                this.SUPPLIER_FORM.email.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.service, "Please, enter Supplier Service.") || !validateData("minlength=3", this.SUPPLIER_FORM.service, "Please, enter a valid Supplier Service.")){
                this.SUPPLIER_FORM.service.focus();
            } else if (!validateData("req", this.SUPPLIER_FORM.note, "Please, enter Note.")){
                this.SUPPLIER_FORM.note.focus();
            } else{
                document.SUPPLIER_FORM.action = "<%=context%>/SupplierServlet?op=UpdateSupplier";
                document.SUPPLIER_FORM.submit();  
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
        document.SUPPLIER_FORM.action = "<%=context%>/SupplierServlet?op=ListSuppliers";
        document.SUPPLIER_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button    onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/save.gif"></button>
        </DIV> 
        <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=title_3%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <FORM NAME="SUPPLIER_FORM" METHOD="POST">
                
                <%
                if(null!=status) {
        if(status.equalsIgnoreCase("ok")){
                %>  
                <tr>
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>                    
                            <td class="td">
                                <font size=4 color="black"><%=sStatus%></font> 
                            </td>                    
                    </tr> </table>
                </tr>
                <%
                }else{%>
                <tr>
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>                    
                            <td class="td">
                                <font size=4 color="red" ><%=fStatus%></font> 
                            </td>                    
                    </tr> </table>
                </tr>
                <%}
                }
                
                %>
                <br>
                <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="supplierNO">
                                <p><b><%=sup_number%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="supplierNO" ID="supplierNO" size="33" value="<%=supplierWBO.getAttribute("supplierNO").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="supplierName">
                                <p><b><%=sup_name%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="supplierName" ID="supplierName" size="33" value="<%=supplierWBO.getAttribute("name").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="address">
                                <p><b><%=sup_address%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="address" ID="address" size="33" value="<%=supplierWBO.getAttribute("address").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="designation">
                                <p><b><%=sup_job%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="designation" ID="designation" size="33" value="<%=supplierWBO.getAttribute("designation").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="city">
                                <p><b><%=sup_city%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </td>
                        <TD  STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="city" ID="city" size="33" value="<%=supplierWBO.getAttribute("city").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD  STYLE="<%=style%>" class='td'>
                            <LABEL FOR="phone">
                                <p><b><%=sup_phone%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="phone" ID="phone" size="33" value="<%=supplierWBO.getAttribute("phone").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="fax">
                                <p><b><%=sup_fax%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="fax" ID="fax" size="33" value="<%=supplierWBO.getAttribute("fax").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="email">
                                <p><b><%=sup_mail%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="email" ID="email" size="33" value="<%=supplierWBO.getAttribute("email").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="service">
                                <p><b><%=sup_service%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="service" ID="service" size="33" value="<%=supplierWBO.getAttribute("service").toString()%>" maxlength="255">
                        </TD>
                        
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="note">
                                <p><b><%=sup_notes%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <TEXTAREA type="TEXT" ROWS="5" style="width:230px" name="note" ID="note" COLS="25" size="33" value="" maxlength="255"><%=supplierWBO.getAttribute("note").toString()%></textarea>
                        </TD>
                        
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="isActive">
                                
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <INPUT 
                                <%
                                if(supplierWBO.getAttribute("isActive").toString().equalsIgnoreCase("1")){
                                %>
                                CHECKED
                                <%
                                }
                                %>
                                TYPE="CHECKBOX" name="isActive" ID="isActive"><b><%=working_status%></b>&nbsp;
                        </TD>
                        
                    </TR>
                    <input type="hidden" name="supplierID" value="<%=supplierWBO.getAttribute("id").toString()%>">
                    
                </TABLE>
            </FORM>
        </FIELDSET>
    </BODY>
</HTML>     
