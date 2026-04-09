<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String status = (String) request.getAttribute("Status");

WebBusinessObject category = (WebBusinessObject) request.getAttribute("category");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status,Dupname;
    String title_1,title_2;
    String cat_name,cat_desc;
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){

        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        cat_name="Category name";
        cat_desc="Category description";
        title_1="Category view";
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
        
        
     
        cat_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        cat_desc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
        title_1=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1589;&#1606;&#1601;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
        save_button_label=" &#1587;&#1580;&#1604; ";
        langCode="En";
          Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
   
    }
      String doubleName = (String) request.getAttribute("name");

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new Category</TITLE>
          <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {  
        
            if (!validateData("req", this.CATEGORY_FORM.categoryName, "Please, enter Category Name.") || !validateData("minlength=3", this.CATEGORY_FORM.categoryName, "Please, enter a valid Category Name.")){
                this.CATEGORY_FORM.categoryName.focus();
            } else if (!validateData("req", this.CATEGORY_FORM.catDsc, "Please, enter Category Description.")){
                this.CATEGORY_FORM.catDsc.focus();
            } else{
                document.CATEGORY_FORM.action = "<%=context%>/ItemsServlet?op=UpdateCategory";
                document.CATEGORY_FORM.submit();  
            }
        }
        
        function cancelForm()
        {    
            document.CATEGORY_FORM.action = "<%=context%>//ItemsServlet?op=ListCategory";
            document.CATEGORY_FORM.submit();  
        }
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="CATEGORY_FORM" METHOD="POST">
            
             <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button> 
            <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            
              </DIV> 
             <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
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
            
           
                <%    if(null!=status) {
                
                %>
                <br><br>
                
                 <table align="<%=align%>" dir=<%=dir%>> 
                <tr><td  class="td" align=<%=align%>> <b><font color="red" size=4 > <%=saving_status%> : <%=status%> </font> <b></td>
                      
                </tr>
                </table>
                
                <%
                }
                %>
            
            <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=cat_name%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"  class='td'>
                        <input  type="TEXT" name="categoryName" ID="categoryName" size="34" value="<%=category.getAttribute("categoryName")%>" maxlength="255">
                    </TD>
                </TR>
                <!--
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_EQ_NO">
                <p><b><%//=tGuide.getMessage("eqNO")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                <input type="TEXT" name="eqNO" ID="eqNO" size="33" value="<%//=project.getAttribute("eqNO")%>" maxlength="255">
                    </TD>
                </TR>
          -->
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=cat_desc%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <TEXTAREA   rows="5" name="catDsc" ID="catDsc" cols="27"><%=category.getAttribute("catDsc")%></TEXTAREA>
                        <!--
                        <input type="TEXT" name="catDsc" ID="catDsc" size="33" value="<%//=category.getAttribute("catDsc")%>" maxlength="255">
                    -->
                    </TD>
                </TR>
            </TABLE>
            <br><br><br>
            <input type="hidden" name="categoryId" ID="categoryId" value="<%=category.getAttribute("categoryId")%>">
        </FORM>
    </BODY>
</HTML>     
