<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


WebBusinessObject web = (WebBusinessObject) request.getAttribute("data");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");


String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;

    String saving_status;
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
        save_button_label="Refresh ";
        langCode="Ar";
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
        save_button_label=" &#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;";
        langCode="En";
    }

%>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new Category</TITLE>
         <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>

 <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm()
        {
        document.PROJECT_VIEW_FORM.action = "<%=context%>/ProjectServlet?op=ViewParts";
        document.PROJECT_VIEW_FORM.submit();
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>

        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">

             <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>

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


            <br><br>

            <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">

                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=cat_name%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="text" readonly  value="<%=web.getAttribute("nameAr")%>"/>
                    </TD>
                </TR>

                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=cat_desc%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="text" readonly style="width:230px"  value="<%=web.getAttribute("nameEn")%>"/>

                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>
