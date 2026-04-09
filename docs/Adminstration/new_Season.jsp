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


        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status;
        String season_code, english_name, arabic_name, begin_date, end_date, prep_shoulder, closer_shoulder;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label, display;
        String fStatus;
        String sStatus;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";

            english_name = "English Name";
            season_code = "Code";
            arabic_name = "Arabic Name";
            begin_date = "Begin Date";
            end_date = "End Date";
            prep_shoulder = "Preparation Shoulder(Week)";
            closer_shoulder = "Closer Shoulder(Week)";


            title_1 = "New Communication Channel قناة أتصال جديدة";
            //title_2="All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            sStatus = "Season Saved Successfully";
            fStatus = "Fail To Save This Season";
            langCode = "Ar";
            display = "Display";
        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";

            english_name = "الاسم الانجليزي";
            season_code = "الكود";
            arabic_name = "الاسم العريي";
            begin_date = "شهرالبدايه المعتاد";
            end_date = "شهر النهايه المعتاد";
            prep_shoulder = "فترة التجهيز(بالاسبوع)";

            closer_shoulder = "فترة الاغلاق(بالاسبوع)";



            title_1 = "New Communication Channel قناة أتصال جديدة";
            //title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            fStatus = "لم يتم تسجيل هذا النوع";
            sStatus = "تم تسجيل نوع الحمله بنجاح";


            langCode = "En";
            display = "إظهار";
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
            $(document).ready(function() {
                $(".calendar").calendarsPicker();
            });

        </script>

    </HEAD>

    <SCRIPT  TYPE="text/javascript">

        function checkCode(obj) {

            var code = $("#code").val();
            $("#MSG").text("")
            $("#arabicName").css("background-color", "");
            $("#englishName").css("background-color", "");
            $("#prep_shoulder").css("background-color", "");
            $("#closer_shoulder").css("background-color", "");
            $("#warning").css("display", "none");
            $("#ok").css("display", "none");
            if (code.length > 0) {


                $.ajax({
                    type: "post",
                    url: "<%=context%>/SeasonServlet?op=checkCode",
                    data: {
                        code: code
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'error') {

                            $("#MSG").css("color", "green");
                            $("#MSG").css(" text-align", "left");
                            //                            alert(jsonString);
                            $("#MSG").text(" متاح")
                            $("#MSG").removeClass("error");
                            $("#arabicName").removeAttr("disabled");
                            $("#englishName").removeAttr("disabled");
                            $("#prep_shoulder").removeAttr("disabled");
                            $("#closer_shoulder").removeAttr("disabled");
                            $("#arabicName").css("background-color", "");
                            $("#englishName").css("background-color", "");
                            $("#prep_shoulder").css("background-color", "");
                            $("#closer_shoulder").css("background-color", "");
                            $("#warning").css("display", "none");
                            $("#ok").css("display", "inline")
                        } else if (info.status == 'Ok') {
                            $("#MSG").css("color", "red");
                            $("#warning").css("display", "inline")
                            $("#ok").css("display", "none");
                            $("#MSG").text(" محجوز");
                            $("#MSG").addClass("error");
                            $("#arabicName").attr("disabled", "ture");
                            $("#arabicName").css("background-color", "#ff8f9e");
                            $("#englishName").attr("disabled", "ture");
                            $("#englishName").css("background-color", "#ff8f9e");
                            $("#prep_shoulder").attr("disabled", "ture");
                            $("#prep_shoulder").css("background-color", "#ff8f9e");
                            $("#closer_shoulder").attr("disabled", "ture");
                            $("#closer_shoulder").css("background-color", "#ff8f9e");

                        }
                    }
                });
                //            });
            }
        }





        function submitForm()
        {
            if (!validateData("req", this.SEASON_FORM.code, "Please, enter Season Number.")) {
                this.SEASON_FORM.code.focus();
            }
            else if ($("#MSG").attr("class") == "error") {
                alert("please enter available code");
                return;
            }
            else if (!validateData("req", this.SEASON_FORM.arabicName, "Please, enter Arabic Name.") || !validateData("minlength=3", this.SEASON_FORM.arabicName, "Please, enter a valid Arabic Name.")) {
                this.SEASON_FORM.arabicName.focus();
            }
            else if (!validateData("req", this.SEASON_FORM.englishName, "Please, enter English Name.") || !validateData("minlength=3", this.SEASON_FORM.englishName, "Please, enter a valid English Name.")) {
                this.SEASON_FORM.englishName.focus();
            }
            else {
                document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=saveSeason";
                document.SEASON_FORM.submit();
            }
        }


        function IsNumeric(sText)

        {
            var ValidChars = "0123456789.";
            var IsNumber = true;
            var Char;


            for (i = 0; i < sText.length && IsNumber == true; i++)
            {
                Char = sText.charAt(i);
                if (ValidChars.indexOf(Char) == -1)
                {
                    var TCode = document.getElementById('code').value;

                    if (/[^a-zA-Z0-9]/.test(TCode)) {
                        alert('Input is not alphanumeric');
                        return false;
                    }
                }
                else {
                    alert("The code is either alphanumeric or alphabetical");
                    break;
                }
            }
            return IsNumber;

        }

        function checkEmail(email) {
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
                return (true)
            }
            return (false)
        }

        function clearValue(no) {
            document.getElementById('Quantity' + no).value = '0';
            total();
        }

        function cancelForm()
        {
            document.SEASON_FORM.action = "main.jsp";
            document.SEASON_FORM.submit();
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>




        <FORM NAME="SEASON_FORM" METHOD="POST">

            <DIV align="left" STYLE="color:blue;">
                <!--<input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">-->
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td" style="direction: ltr;">
                                <font color="blue" size="4"><%=title_1%>                
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
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
                } else {%>
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
                            <LABEL FOR="supplierNO2">
                                <p><b><%=season_code%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>"class='td' id="CellData">
                            <input type="TEXT" style="width:100px" name="code" id="code" size="33" value="" maxlength="255" autocomplete="off" onkeyup="checkCode(this)">
                            <div id="warning"style="margin-right: 6px;display: none;width: 16px;height: 16px; background-image: url(images/warning.png);background-repeat: no-repeat;"></DIV>
                            <div id="ok"style="margin-right: 6px;display: none;width: 16px;height: 16px; background-image: url(images/ok2.png);background-repeat: no-repeat;"></DIV>
                            <LABEL id="MSG" ></LABEL>

                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="address">
                                <p><b><%=arabic_name%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="arabic_name" ID="arabicName" size="33" value="" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="supplierName">
                                <p><b><%=english_name%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"class='td'>
                            <input type="TEXT" style="width:230px" name="english_name" ID="englishName" size="33" value="" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <p><b><%=display%></b>&nbsp;
                        </TD>
                        <TD STYLE="<%=style%>"class='td'>
                            <input type="checkbox" name="display" ID="display" value="1" />
                        </TD>
                    </TR>
                </TABLE>
                <br>
                <br>
                <br>
                <br>
                <br>
                <br>
                <br>
                <br>
                </FORM>
                </BODY>
                </HTML>     
