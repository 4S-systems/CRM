<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
    String status = (String) request.getAttribute("Status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebBusinessObject wboSeason=(WebBusinessObject)request.getAttribute("wboSeason");
    String isForever = (String) wboSeason.getAttribute("isForever");
    if (isForever == null) {
        isForever = "";
    }
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;

    String saving_status;
    String season_code, english_name, arabic_name, begin_date, end_date, prep_shoulder, closer_shoulder, forever;
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

        english_name = "English Name";
        season_code = "Code";
        arabic_name = "Arabic Name";
        begin_date = "Begin Date";
        end_date = "End Date";
        prep_shoulder = "Preparation Shoulder(Week)";
        closer_shoulder = "Closer Shoulder(Week)";


        title_1="Delete Season";
        //title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Delete ";
        sStatus="Season deleted Successfully";
        fStatus="Fail To delete This Season";
        langCode="Ar";
        forever = "Forever";
    }else{

        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";

        english_name = "الاسم الانجليزي";
        season_code = "الكود";
        arabic_name ="الاسم العريي";
        begin_date = "شهرالبدايه المعتاد";
        end_date = "شهر النهايه المعتاد";
        prep_shoulder = "فترة التجهيز(بالاسبوع)";

        closer_shoulder = "فترة الاغلاق(بالاسبوع)";



        title_1="هل أنت متأكد من حذف أداة الحملة هذه";
        //title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="إلغاء";
        save_button_label="حذف";
        fStatus= "لم يتم حذف هذا النوع";
        sStatus="تم حذف هذا النوع";


        langCode="En";
        forever = "دائما";
    }


    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>new Client</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="autosuggest.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
         <script type="text/javascript" src="js/jquery.calendars.js"></script>
        <script type="text/javascript" src="js/jquery.calendars.plus.js"></script>
        <link  rel="stylesheet" type="text/css" href="js/jquery.calendars.picker.css"/>
        <script type="text/javascript" src="js/jquery.calendars.picker.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                $(".calendar").calendarsPicker();
            });

        </script>

    </HEAD>

    <SCRIPT  TYPE="text/javascript">



        function submitForm(){
                document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=deleteRecordSeason";
                document.SEASON_FORM.submit();
                }

     function cancelForm()
        {


        document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=listRecordSeasons";
        document.SEASON_FORM.submit();
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>




        <FORM NAME="SEASON_FORM" METHOD="POST">

           
            
              <TABLE style="width:60% ">
                 <TR>
                    <TD style="width: 10%;; border: none">
                        <IMG class="img" style="cursor: pointer" width="50%" VALIGN="BOTTOM" onclick="JavaScript: cancelForm();" SRC="images/buttons/backBut.png" > 
                    </TD>
                    <TD style="width: 50%; border: none">
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

            <!--table align="<%//=align%>" dir=<%//=dir%>>
            <TR COLSPAN="2" ALIGN="<%//=align%>">
            <TD STYLE="<%//=style%>" class='td'>
            <FONT color='red' size='+1'><%//=title_2%></FONT>
                    </TD>

                </TR>
            </table-->
            <br><br>

            <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0" id="MainTable">


                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="address">
                            <p><b><%=arabic_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input readonly type="TEXT" style="width:230px" name="arabic_name" ID="arabicName" size="33" value="<%=wboSeason.getAttribute("arabicName")%>" maxlength="255">
                        <input readonly type="hidden" style="width:230px" name="seasonTypeId" ID="seasonTypeId" size="33" value="<%=wboSeason.getAttribute("id")%>" maxlength="255" autocomplete="off" >
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="supplierName">
                            <p><b><%=english_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input readonly type="TEXT" style="width:230px" name="english_name" ID="englishName" size="33" value="<%=wboSeason.getAttribute("englishName")%>" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="supplierName">
                            <p><b><%=forever%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="checkbox" id="forever" name="forever" value="1" disabled="true"
                               <%=isForever.equals("1")?"checked":""%>/>
                    </TD>
                </TR>
 
            </TABLE>
                    <br>
                     <DIV align="center" STYLE="color:blue;">
                 <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <br>
            </FIELDSET> 
                    </TD>
                 </TR>
              </TABLE>
              
        </FORM>
    </BODY>
</HTML>
