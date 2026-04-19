<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> clients = (List<WebBusinessObject>) request.getAttribute("clients");
    List<WebBusinessObject> usersList = (List<WebBusinessObject>) request.getAttribute("usersList");
    String fromDate = "";
    if (request.getAttribute("fromDate") != null) {
        fromDate = (String) request.getAttribute("fromDate");
    }
    String toDate = "";
    if (request.getAttribute("toDate") != null) {
        toDate = (String) request.getAttribute("toDate");
    }
    String createdBy = "";
    if (request.getAttribute("createdBy") != null) {
        createdBy = (String) request.getAttribute("createdBy");
    }
    String statusCode = "";
    if (request.getAttribute("statusCode") != null) {
        statusCode = (String) request.getAttribute("statusCode");
    }
    String comment = "";
    if (request.getAttribute("comment") != null) {
        comment = (String) request.getAttribute("comment");
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <style type="text/css">
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
        <script  type="text/javascript">
            $(function () {
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
        </script>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ReportsServletTwo?op=listClosureNotes" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">تعليقات اﻷغلاق</font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white">من تاريخ</b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white">إلي تاريخ</b>
                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="6" WIDTH="20%">  
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>"/>
                            <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" />
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">الموظف</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">الحالة</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="createdBy" >
                                <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=createdBy%>"/>
                            </select>
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="statusCode" >
                                <option value="6" <%=statusCode.equals("6") ? "selected" : ""%>>منهي</option>
                                <option value="7" <%=statusCode.equals("7") ? "selected" : ""%>>مغلق</option>
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white">التعليق</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="middle" colspan="2">
                            <input id="comment" name="comment" type="text" value="<%=comment%>" style="width: 350px;"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <br/>
            <form name="UNHANDLED_CLIENT_FORM" method="POST">
                <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE style="display" id="clients" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                        <thead>                
                            <tr>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px"><b>رقم العميل</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px"><b>إسم العميل</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px"><b>رقم الطلب</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px"><b>التعليق</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px"><b>التاريخ</b></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%  int counter = 0;
                                String clazz;
                                String beginDate = "";
                                String clientNo = "";
                                for (WebBusinessObject wbo : clients) {
                                    if ((counter % 2) == 1) {
                                        clazz = "silver_odd_main";
                                    } else {
                                        clazz = "silver_even_main";
                                    }
                                    counter++;
                                    if (wbo.getAttribute("beginDate") != null) {
                                        beginDate = ((String) wbo.getAttribute("beginDate"));
                                        beginDate = beginDate.substring(0, 16);
                                    }
                                    if (!clientNo.equals((String) wbo.getAttribute("clientNo"))) {
                                        clientNo = (String) wbo.getAttribute("clientNo");
                            %>
                            <tr class="<%=clazz%>" style="cursor: pointer" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                                <td STYLE="text-align: center" nowrap>
                                    <div>
                                        <b><%=wbo.getAttribute("clientNo")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=wbo.getAttribute("clientName")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <%
                                if ((counter % 2) == 1) {
                                    clazz = "silver_odd_main";
                                } else {
                                    clazz = "silver_even_main";
                                }
                                counter++;
                            %>
                            <tr class="<%=clazz%>" style="cursor: pointer" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                                <td STYLE="text-align: center" nowrap colspan="2">
                                    &nbsp;
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                  
                                        <b style="color: red;"><%=wbo.getAttribute("businessID")%></b><b style="color: blue;">/<%=wbo.getAttribute("businessIDByDate")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                  
                                        <b><%=wbo.getAttribute("statusNote") != null ? wbo.getAttribute("statusNote") : "لا يوجد"%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                   
                                        <b><%=beginDate%></b>
                                    </div>
                                </td>
                            </tr>
                            <%
                            } else {
                            %>
                            <tr class="<%=clazz%>" style="cursor: pointer" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                                <td STYLE="text-align: center" nowrap colspan="2">
                                    &nbsp;
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                  
                                        <b style="color: red;"><%=wbo.getAttribute("businessID")%></b><b style="color: blue;">/<%=wbo.getAttribute("businessIDByDate")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                  
                                        <b><%=wbo.getAttribute("statusNote") != null ? wbo.getAttribute("statusNote") : "لا يوجد"%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                   
                                        <b><%=beginDate%></b>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                        <tfoot>                
                            <tr>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px" colspan="3"><b>أجمالي</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px" colspan="2"><b><%=clients.size()%></b></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <br/>
                <br/>
            </form>
        </fieldset>
    </body>
</html>
