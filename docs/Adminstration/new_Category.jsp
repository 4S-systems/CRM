<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<HTML>


    <%
                String status = (String) request.getAttribute("Status");

                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode;

                String catTip, descTip;

                String saving_status, Dupname;
                String category_name, category_desc;
                String title_1, title_2;
                String cancel_button_label;
                String save_button_label;
                String fStatus;
                String sStatus;
                if (stat.equals("En")) {

                    saving_status = "Saving status";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";

                    category_name = "Category name";
                    category_desc = "Description";

                    ////////// tool tip assignment///////////
                    catTip = "Enter the new category name<br> Example: machines";
                    descTip = "Enter the description that descripe this new category";

                    title_1 = "New part category";
                    title_2 = "All information are needed";
                    cancel_button_label = "Cancel ";
                    save_button_label = "Save ";
                    langCode = "Ar";
                    Dupname = "Name is Duplicated Chane it";
                    sStatus = "Category Saved Successfully";
                    fStatus = "Fail To Save This Category";
                } else {

                    saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";

                    category_name = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601; ";
                    category_desc = "&#1575;&#1604;&#1608;&#1589;&#1601; ";

                    ////////// tool tip assignment///////////
                    catTip = "&#1575;&#1583;&#1582;&#1604; &#1575;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601; &#1575;&#1604;&#1580;&#1583;&#1610;&#1583; <br>&#1605;&#1579;&#1575;&#1604;: &#1575;&#1604;&#1575;&#1578; &#1586;&#1585;&#1575;&#1593;&#1610;&#1607;";
                    descTip = "&#1575;&#1583;&#1582;&#1604; &#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1584;&#1609; &#1610;&#1593;&#1576;&#1585; &#1593;&#1606; &#1607;&#1584;&#1575; &#1575;&#1604;&#1589;&#1606;&#1601;";

                    title_1 = "&#1575;&#1590;&#1575;&#1601;&#1607; &#1589;&#1606;&#1601; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
                    title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
                    cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
                    save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
                    langCode = "En";
                    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
                    fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
                    sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
                }
                String doubleName = (String) request.getAttribute("name");
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new Category</TITLE>
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
                document.CATEGORY_FORM.action = "<%=context%>/ItemsServlet?op=SaveCategory";
                document.CATEGORY_FORM.submit();  
            }
        }
        
        function cancelForm()
        {    
            document.CATEGORY_FORM.action = "main.jsp";
            document.CATEGORY_FORM.submit();  
        }
        
        function showCursor(text)
        {
            document.getElementById('trail').innerHTML=text;
            document.getElementById('trail').style.visibility="visible";
            document.getElementById('trail').style.position="absolute";
            document.getElementById('trail').style.left=event.clientX+10;
            document.getElementById('trail').style.top=event.clientY;
        }

        function hideCursor()
        {
            document.getElementById('trail').style.visibility="hidden";
        }
        
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>

        <FORM NAME="CATEGORY_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6">    <%=title_1%>
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend>
                <%
                            if (null != doubleName) {

                %>

                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font size=4 > <%=Dupname%> </font>
                        </td>

                    </tr> </table>
                    <%}%>
                <table dir="<%=dir%>" align="<%=align%>">
                    <%    if (null != status) {
                                    if (status.equalsIgnoreCase("ok")) {
                    %>
                    <tr>
                        <table align="<%=align%>" dir=<%=dir%>>
                            <tr>
                                <td class="td">
                                    <font size=4 color="black"><%=sStatus%></font>
                                </td>
                            </tr>
                        </table>
                    </tr>
                    <%} else {%>
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

                </table>
                <br>

                <table align="<%=align%>" dir=<%=dir%>>
                    <TR COLSPAN="2" ALIGN="<%=align%>">
                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=title_2%></FONT>
                        </TD>
                    </TR>
                </table>
                <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">

                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Place_Name">
                                <p><b><%=category_name%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" name="categoryName" ID="categoryName" size="34" value="" onclick="JavaScript: showCursor('<%=catTip%>');" onmouseout="JavScript: hideCursor();" maxlength="255">
                        </TD>
                    </TR>

                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="catDsc">
                                <p><b><%=category_desc%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <TEXTAREA rows="5" name="catDsc" ID="catDsc" cols="27" onclick="JavaScript: showCursor('<%=descTip%>');" onmouseout="JavScript: hideCursor();"></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
