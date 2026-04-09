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
    String action =(String) request.getAttribute("action");
    if(action == null){
        action = "";
    }
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String sup_number, sup_name,title_3, sup_address, sup_job, sup_phone, sup_fax, sup_city, sup_mail, sup_service, sup_notes, working_status,TT;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
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
        TT="Waiting Business Rule";
        
        
        title_1="Delete supplier";
        title_2="All information are needed";
        cancel_button_label="Back To List ";
        save_button_label="Save ";
        langCode="Ar";
        title_3="View External Supplier";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
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
        TT="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
        title_3="&#1593;&#1585;&#1590; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1605;&#1608;&#1585;&#1583; &#1582;&#1575;&#1585;&#1580;&#1609;";   
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <script language="javascript" type='text/javascript'>
           function cancelForm()
        {    
        document.ITEM_FORM.action = "<%=context%>/SupplierServlet?op=ListSuppliers";
        document.ITEM_FORM.submit();  
        }
    </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY>
        
        <FORM NAME="ITEM_FORM" METHOD="POST">
            
            <%    if(action.equals("delete")) {
            
            %>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                
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
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                
                <table align="<%=align%>" dir="<%=dir%>" ><tr><td style="<%=style%>"class="td">
                            <b><FONT COLOR="red" SIZE="4"> <%=TT%></font></b>
                </td></tr></table>
                <br>
            </fieldset>
            <%
            }else  {
            %>    
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                
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
            
            <TABLE class="backgroundTable" CELLPADDING="0" CELLSPACING="5" width="60%" BORDER="0" ALIGN="<%=align%>" DIR="<%=dir%>">
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px;" class='backgroundHeader' width="30%">
                                <p><b><%=sup_number%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="supplierNO" ID="supplierNO" size="33" value="<%=supplierWBO.getAttribute("supplierNO").toString()%>" maxlength="255">
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_name%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="supplierName" ID="supplierName" size="33" value="<%=supplierWBO.getAttribute("name").toString()%>" maxlength="255">
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_address%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px"class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="address" ID="address" size="33" value="<%=supplierWBO.getAttribute("address").toString()%>" maxlength="255">
                            </TD>
                        </TR>

                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_job%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="designation" ID="designation" size="33" value="<%=supplierWBO.getAttribute("designation").toString()%>" maxlength="255">
                            </TD>
                        </TR>

                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_city%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="city" ID="city" size="33" value="<%=supplierWBO.getAttribute("city").toString()%>" maxlength="255">
                            </TD>
                        </TR>

                        <TR>
                            <TD  STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_phone%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="phone" ID="phone" size="33" value="<%=supplierWBO.getAttribute("phone").toString()%>" maxlength="255">
                            </TD>
                        </TR>

                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_fax%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="fax" ID="fax" size="33" value="<%=supplierWBO.getAttribute("fax").toString()%>" maxlength="255">
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_mail%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="email" ID="email" size="33" value="<%=supplierWBO.getAttribute("email").toString()%>" maxlength="255">
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_service%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="service" ID="service" size="33" value="<%=supplierWBO.getAttribute("service").toString()%>" maxlength="255">
                            </TD>

                        </TR>
                        <TR>
                           <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                               <p><b><%=sup_notes%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <TEXTAREA readonly style="width:100%" ROWS="5" name="note" ID="note" COLS="25" ><%=supplierWBO.getAttribute("note").toString()%></TEXTAREA>
                            </TD>
                        </TR>
                        <TR>
                            <TD class='TD' width="30%">
                                <LABEL FOR="isActive">

                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px"class='TD' width="70%">
                                <INPUT readonly
                                       <% if(supplierWBO.getAttribute("isActive").toString().equalsIgnoreCase("1")){ %>
                                       CHECKED
                                       <% } %>
                                       TYPE="CHECKBOX" name="isActive" ID="isActive"><b><%=working_status%></b>
                            </TD>
                        </TR>
                    </TABLE>
            <% } %>
        </FORM>
    </BODY>
</HTML>     
