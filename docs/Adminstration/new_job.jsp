<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%

        String status = (String) request.getAttribute("Status");

        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");

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
        String job_code, arName, enName, title;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label, automated, sTradeType;
        String fStatus;
        String sStatus;
        if (stat.equals("En"))
        {

            saving_status = "Saving status";
            align = "center";
            dir = "Ltr";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            arName = "arabic title";
            enName = "english title";
            job_code = "job code";
            title_1 = "New Client";
            //title_2="All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            sStatus = "Client Saved Successfully";
            fStatus = "Fail To Save This Client";
            langCode = "Ar";
            automated = "Automated";
            title = "add job";
            sTradeType = "Trade type";
        }
        else
        {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            enName = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1607;&#1606;&#1577;(&#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;)";
            arName = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1607;&#1606;&#1577;(&#1593;&#1585;&#1576;&#1609;)";
            job_code = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1607;&#1606;&#1577;";
            title_1 = "تسجيل عميل جديد";
            //title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            fStatus = "لم يتم تسجيل هذا العميل";
            sStatus = "تم تسجيل العميل بنجاح";
            automated = "&#1578;&#1604;&#1602;&#1575;&#1574;&#1609;";
            title = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1607;&#1606;&#1577;";
            langCode = "En";
            sTradeType = "نوع المهنة";
        }

        Vector tradeTypeV = (Vector) request.getAttribute("tradeTypeV");
        ArrayList<WebBusinessObject> tradeTypeList = new ArrayList<WebBusinessObject>(tradeTypeV);


    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>new Client</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="autosuggest.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="blueStyle.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>



    </HEAD>
    <style>
        textarea{resize:none;}
    </style>
    <SCRIPT  TYPE="text/javascript">

        function submitForm()
        {

            var code = $('#jobNameAr').val();
            var jobNameAr = $('#jobNameAr').val();
            var jobNameEn = $('#jobNameAr').val();
            var ttradeTypeId = $('#tradeType').val();
            ;
//            var ttradeTypeId = "2";
            if (code == null || code == '') {
                alert("write job code");
            } else if (jobNameAr == null || jobNameAr == '') {
                alert("write arabic job name");
            } else {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveJob",
                    data: {
                        code: code,
                        jobNameAr: jobNameAr,
                        jobNameEn: jobNameEn,
                        ttradeTypeId: ttradeTypeId
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.Status === 'Ok') {
                            $("#job").append("<option value='" + info.code + "'" + ">" + info.name + "</option>");
                            $('#jobNameAr').val("");
                            $('#msg').text("تم التسجيل بنجاح");
                        } else if (info.Status === 'No') {
                            $('#msg').text("لم يتم التسجيل");
                            $('#jobNameAr').val("");
                        } else if (info.Status === "dublicate") {
                            $('#msg').text("لقد تم الادخال مسبقا");
                            $('#jobNameAr').val("");

                        }
                    }
                });


            }


        }
//        function submitForm()
//        {
//            
//            var code = $('#jobCode').val();
//            var jobNameAr = $('#jobNameAr').val();
//            var jobNameEn = $('#jobNameEn').val();
//            var ttradeTypeId = $('#tradeType').val();
//            if(code==null ||code==''){
//                alert("write job code");
//            }else if(jobNameAr==null || jobNameAr==''){
//                alert("write arabic job name");
//            }else{
//                $.ajax({
//                type: "post",
//                url: "<%=context%>/ClientServlet?op=saveJob",
//                data: {
//                    code: code,
//                    jobNameAr: jobNameAr,
//                    jobNameEn: jobNameEn,
//                    ttradeTypeId: ttradeTypeId
//                },
//                success: function(jsonString) {
//                    var info = $.parseJSON(jsonString);
//                 
//                    if (info.Status == 'Ok') {
//                        $("#job").append("<option value='"+info.code+"'"+">"+info.name+"</option>");
//                        $('#jobCode').val("");
//                        $('#jobNameAr').val("");
//                        $('#jobNameEn').val("");
//                        $('#msg').text("تم التسجيل بنجاح");
//                        
//                        
//                    } else if (info.Status == 'No') {
//                        $('#msg').text("لم يتم التسجيل");
//                        $('#jobCode').val("");
//                        $('#jobNameAr').val("");
//                        $('#jobNameEn').val("");
//                    }
//                }
//            });
//            
//            
//            }
//            
//            
//        }
        function cancelForm()
        {
            document.CLIEN_FORM.action = "main.jsp";
            document.CLIEN_FORM.submit();
        }


    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY >

        <FORM NAME="CLIEN_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;">
                <table border="0px"  style="width:40%;" class="table" dir="rtl" >
                    <tr align="center" align="center">
                        <td colspan="2"  class="blueBorder blueHeaderTD" style="font-size:18px;"><%=title%></td>
                    </tr>
                    <tr align="center" align="center">
                        <td colspan="2"  style="font-size:18px;"><b style="color: green;font-size: 18px;"id="msg"></b></td>
                    </tr>
                    <tr >
                        <td width="35%" style="color: #27272A;" class="excelentCell formInputTag">
                            <%=sTradeType%>
                        </td>
                        <td  style="text-align:right;background: #f1f1f1;">
                            <SELECT name="tradeType" id="tradeType" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;">
                                <%--//// Comment Here    <sw:WBOOptionList wboList="<%=tradeTypeList%>" displayAttribute="name" valueAttribute="id"  />--%>
                                <%
                                    for (int i = 0; i < tradeTypeList.size(); i++)
                                    {
                                        String selected = "";
                                        if (((String) tradeTypeList.get(i).getAttribute("id")).equals("1"))
                                        {
                                            selected = "selected";
                                        }
                                %>
                                <option value=<%=tradeTypeList.get(i).getAttribute("id")%> <%=selected%> ><%=tradeTypeList.get(i).getAttribute("name")%></option>
                                <%}%>
                            </SELECT>
                        </td>
                    </tr>
                    <%--
                    <tr >
                        <td width="35%" style="color: #000;" class="excelentCell formInputTag">
                            <%=job_code%>
                        </td>
                        <td  style="text-align:right;background: #f1f1f1;">

                            <input  type="TEXT" style="width:40%;" name="jobCode" ID="jobCode" size="30"  maxlength="30" >
                        </td>
                    </tr>
                    --%>
                    <tr >
                        <td width="35%" style="color: #27272A;" class="excelentCell formInputTag">
                            <%=arName%>
                        </td>
                        <td style="text-align:right;background: #f1f1f1;">
                            <input type="TEXT" style="width:150px;" name="jobNameAr" ID="jobNameAr" size="50" value="" maxlength="50">
                        </td>
                    </tr>
                    <%-- <tr>
                         <td width="35%" style="color: #000;" class="excelentCell formInputTag">
                             <%=enName%>
                         </td>
                         <td style="text-align:right;background: #f1f1f1;">
                             <input type="TEXT" style="width:150px;" name="jobNameEn" ID="jobNameEn" size="33" value="" maxlength="255">
                         </td>
 </tr> --%>
                    <tr>

                        <td colspan="2" style="text-align:center;background: #f1f1f1;">
                            <input type="button"  value="إضافة" onclick="submitForm()">
                        </td>
                    </tr>
                </table>
            </DIV>
        </FORM>
    </BODY>
</HTML>     
