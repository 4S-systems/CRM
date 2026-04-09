<%-- 
    Document   : customizeClients
    Created on : Jun 20, 2017, 10:35:11 AM
    Author     : java3
--%>

<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> clients = (List<WebBusinessObject>) request.getAttribute("clients");
    List<WebBusinessObject> usersList = (List<WebBusinessObject>) request.getAttribute("usersList");
    List<WebBusinessObject> campaignsList = (List<WebBusinessObject>) request.getAttribute("campaignsList");
    
    ArrayList<WebBusinessObject> projectsList = request.getAttribute("projectsList") != null ? (ArrayList<WebBusinessObject>)request.getAttribute("projectsList"): null;
    
    String beginDate = "";
    if (request.getAttribute("beginDate") != null) {
        beginDate = (String) request.getAttribute("beginDate");
    }
    String endDate = "";
    if (request.getAttribute("endDate") != null) {
        endDate = (String) request.getAttribute("endDate");
    }
    String description = "";
    if (request.getAttribute("description") != null) {
        description = (String) request.getAttribute("description");
    }
    String createdBy = "";
    if (request.getAttribute("createdBy") != null) {
        createdBy = (String) request.getAttribute("createdBy");
    }
    String campaignID = "";
    if (request.getAttribute("campaignID") != null) {
        campaignID = (String) request.getAttribute("campaignID");
    }
    String clientType = "";
    if (request.getAttribute("clientType") != null) {
        clientType = (String) request.getAttribute("clientType");
    }
    String projectID = "";
    if (request.getAttribute("projectID") != null) {
        projectID = (String) request.getAttribute("projectID");
    }
    String status = (String) request.getAttribute("status");
    
    List<WebBusinessObject> distributionsList = (List<WebBusinessObject>) request.getAttribute("distributionsList");
    
    ArrayList<WebBusinessObject> empClients = (ArrayList<WebBusinessObject>) request.getAttribute("empClients");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        
        <style type="text/css">
            .titlebar {
                /*background-image: url(images/title_bar.png);*/
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
                background-color: #3399ff;
            }
            
            .login {
            /*display: none;*/
            direction: rtl;
            margin: 20px auto;
            padding: 10px 5px;
            /*        width:30%;*/
            background: #3f65b7;
            background-clip: padding-box;
            border: 1px solid #ffffff;
            border-bottom-color: #ffffff;
            border-radius: 5px;
            color: #ffffff;

            background: #7abcff; /* Old browsers */
            /* IE9 SVG, needs conditional override of 'filter' to 'none' */
            /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
            background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
            background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
        }
        
        .login  h1 {
            font-size: 16px;
            font-weight: bold;

            padding-top: 10px;
            padding-bottom: 10px;
            text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
            text-align: center;
            width: 96%;
            margin-left: auto;
            margin-right: auto;
            text-height: 30px;
            color: black;
            text-shadow: 0 1px rgba(255, 255, 255, 0.3);
            background: #FFBB00;
            /*background: #cc0000;*/
            background-clip: padding-box;
            border: 1px solid #284473;
            border-bottom-color: #223b66;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .table td{
            padding:5px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            border: none;
            margin-bottom: 30px;
        }
        </style>
        
        <script  type="text/javascript">
            function selectAll(obj, ckeckName) {
                $("input[name='" + ckeckName + "']").prop('checked', $(obj).is(':checked'));
            }
            
            function isChecked() {
                var isChecked = false;
                $("input[name='customerId']").each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                    }
                });
                return isChecked;
            }
            
            function lock(){
                var usrID = $("#usrID").val();
                if (!isChecked()) {
                    alert(' إختر عميل ');
                    return false;
                } else {
                    document.UNHANDLED_CLIENT_FORM.action = "<%=context%>/ClientServlet?op=customizeClient&save=true&usrID=" + usrID;
                    document.UNHANDLED_CLIENT_FORM.submit();
                } 
            }
            
            function showLock() {
                var url = "<%=context%>/ClientServlet?op=lockClientByUsrID";
                window.open(url);
                window.close();
            }
            
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            
            $(document).ready(function () {
                $("#createdBy").select2();
                
                $("#campaignID").select2();
                
                $("#usrID").select2();
                
                $("#projectID").select2();
                
                $("#clientType").select2();
                
                
                $("#clientsssss").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[ 7, "asc" ]],
                    "columnDefs": [{
                            "targets": 7,
                            "visible": false
                    }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(7, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="2">المصدر</td><td class="blueBorder blueBodyTD" style="font-size: 16px;" colspan="8">'
                                        + group + '</td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });
            
            function getProjects(obj) {
                $.ajax({
                    type: "post",
                    url: '<%=context%>/CampaignServlet?op=getProjectsAjax',
                    data: {
                        campaignID: $(obj).val()
                    },
                    success: function (dataStr) {
                        var result = $.parseJSON(dataStr);
                        var options = [];
                        options.push("<option value=''>", "الكل", "</option>");
                        try {
                            $.each(result, function () {
                                if (this.projectName) {
                                    options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                                }
                            });
                        } catch (err) {
                        }
                        $("#projectID").html(options.join(''));
                    }
                });
            }
            
        </script>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ClientServlet?op=customizeClient" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="white" size="4">
                            توزيع عملاء الحملة
                            </font>
                        </td>
                    </tr>
                </table>
                
                <br/>
                
                <%
                    if ("saved".equalsIgnoreCase(status)) {
                %>
                
                <table>
                    <tr>
                        <td class="td"> 
                            <b>
                                <font size="4" style="color: green;">
                                تم الحفظ بنجاح
                                </font>
                            </b>
                        </td>
                    </tr>
                </table>
                
                <br/>
                
                <%
                    }
                %>
                
                <table ALIGN="center" DIR="RTL" WIDTH="75%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" WIDTH="27%">
                            <b>
                                <font size=3 color="white">من تاريخ
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;"WIDTH="27%">
                            <b>
                                <font size=3 color="white">إلي تاريخ
                            </b>
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" WIDTH="27%" colspan="2">
                            <b>
                                <font size=3 color="white">Hash Tag
                            </b>
                        </td>
                        
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="3" WIDTH="20%">  
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; ">بحث
                                <IMG HEIGHT="15" SRC="images/search.gif" >
                            </button>
                        </td>
                        
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>">
                            <br/>
                            <br/>
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" >
                            <br/>
                            <br/>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" colspan="2">
                            <input id="description" name="description" type="text" value="<%=description%>" />
                            <br/>
                            <br/>
                        </td>
                       
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" width="27%">
                            <b>
                                <font size=3 color="white">المصدر
                            </b>
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" width="27%">
                            <b>
                                <font size=3 color="white">الحملة
                            </b>
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" width="27%">
                            <b><font size=3 color="white">المشروع</b>
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" width="27%">
                            <b>
                                <font size=3 color="white">نوع العميل
                            </b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="createdBy" name="createdBy" >
                                <option value="">الكل</option>
                                <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=createdBy%>"/>
                            </select>
                            
                            <br/>
                            <br/>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="campaignID" name="campaignID" 
                                    onchange="JavaScript: getProjects(this);">
                                <option value="">الكل</option>
                                <sw:WBOOptionList wboList='<%=campaignsList%>' displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>"/>
                            </select>
                            
                            <br/>
                            <br/>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="projectID" name="projectID">
                                <option value="">الكل</option>
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                            <br/><br/>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" name="clientType" >
                                <option value="">الكل</option>
                                <option value="11" <%="11".equals(clientType) ? "selected" : ""%>>Customer</option>
                                <option value="12" <%="12".equals(clientType) ? "selected" : ""%> selected>Lead</option>
                            </select>
                            
                            <br/>
                            <br/>
                        </td>
                        
                         <td STYLE="text-align:center" bgcolor="#dedede" rowspan="2" WIDTH="20%">  
                                <button id="lockBtn" type="button" onclick="showLock();" style="text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold;">
                                    Show Locked Clients
                                </button>
                            </td>
                    </tr>
                </table>
            </form>
            
            <br/>
            
            <form name="UNHANDLED_CLIENT_FORM" method="POST">
                <%if (!clients.isEmpty()) {%>
                    <table ALIGN="center" DIR="RTL" bgcolor="#dedede" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                        <tr style="width: 80%;">
                            
                            
                            <td style="font-size:18px; text-align: left" WIDTH="5%">
                                <button id="lockBtn" type="button" onclick="lock();" style="text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold;">
                                    Lock
                                </button>
                            </td>
                            
                            <td style="font-size:14px; text-align: right; border-left-width: 0px; width: 50%">
                                <select name="usrID" id="usrID" style="font-size: 14px;font-weight: bold; width: 100%; height: 25px; ">
                                    <%
                                    for (WebBusinessObject userWbo : distributionsList) {
                                    %>
                                    <option value="<%=userWbo.getAttribute("userId")%>"><%=userWbo.getAttribute("fullName")%></option>
                                <%
                                    }
                                %>
                                </select>
                            </td>
                        </tr>
                    </table>
                <%}%>
                
                <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showClients">
                
                    <TABLE style="display" id="clientsssss" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                        <thead>                
                            <tr>
                                <th STYLE="text-align:center; color:white; font-size:14px">
                                    <input type="checkbox" name="checkAll" onchange='selectAll(this, "customerId");'/>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b>م</b>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b>إسم العميل</b>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b>حالة العميل</b>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b>رقم الموبايل</b>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b>رقم التليفون</b>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b>البريد الإلكترونى</b>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b>المصدر</b>
                                </th>
                                
                                <th STYLE="text-align:center; font-size:14px">
                                    <b>تاريخ الأدخال</b>
                                </th>
                            </tr>
                        </thead>
                    
                        <tbody>
                            <%
                                int counter = 0;
                                String clazz = "";
                                String creationTime = "";
                                for (WebBusinessObject wbo : clients) {
                                    counter++;
                                    if(wbo.getAttribute("creationTime") != null) {
                                        creationTime = ((String) wbo.getAttribute("creationTime"));
                                        creationTime = creationTime.substring(0, 16);
                                    }
                            %>
                        
                                <tr class="<%=clazz%>" style="cursor: pointer" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                                    <TD STYLE="text-align: center; width: 5%" nowrap>
                                        <DIV>                   
                                            <input type="checkbox" name="customerId" value="<%=(String) wbo.getAttribute("id")%>" />
                                        </DIV>
                                    </TD>

                                    <TD STYLE="text-align: center; width: 5%" nowrap>
                                        <DIV>                   
                                            <b><%=counter%></b>
                                        </DIV>
                                    </TD>

                                    <TD STYLE="text-align: center" nowrap>
                                        <DIV>                           
                                            <b>
                                                <%=wbo.getAttribute("name")%>
                                            </b>
                                        </DIV>
                                    </TD>

                                    <TD STYLE="text-align: center" nowrap>
                                        <DIV>                  
                                            <b style="color: <%="lead".equals(wbo.getAttribute("statusNameEn")) ? "red" : "black"%>;">
                                                <%=wbo.getAttribute("statusNameEn")%>
                                            </b>
                                        </DIV>
                                    </TD>

                                    <TD STYLE="text-align: center" nowrap>
                                        <DIV>                   
                                            <b>
                                                <%=(wbo.getAttribute("mobile") != null ? wbo.getAttribute("mobile") : "")%>
                                            </b>
                                        </DIV>
                                    </TD>

                                    <TD STYLE="text-align: center" nowrap>
                                        <DIV>                   
                                            <b>
                                                <%=(wbo.getAttribute("phone") != null ? wbo.getAttribute("phone") : "")%>
                                            </b>
                                        </DIV>
                                    </TD>

                                    <TD STYLE="text-align: center">
                                        <DIV>                   
                                            <b>
                                                <%=(wbo.getAttribute("email") != null) ? wbo.getAttribute("email") : ""%>
                                            </b>
                                        </DIV>
                                    </TD>

                                    <TD STYLE="text-align: center" nowrap>
                                        <DIV>                           
                                            <b>
                                                <%=wbo.getAttribute("createdByName") != null ? wbo.getAttribute("createdByName") : ""%>
                                            </b>
                                        </DIV>
                                    </TD>

                                    <TD STYLE="text-align: center" nowrap>
                                        <DIV>                           
                                            <b>
                                                <%=creationTime%>
                                            </b>
                                        </DIV>
                                    </TD>
                                </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>
            </form>
        </fieldset>
    </body>
</html>