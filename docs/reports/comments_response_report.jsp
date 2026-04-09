<%@page import="java.text.DecimalFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> issues = (List<WebBusinessObject>) request.getAttribute("issues");
    String fromDate = "";
    if (request.getAttribute("fromDate") != null) {
        fromDate = (String) request.getAttribute("fromDate");
    }
    String toDate = "";
    if (request.getAttribute("toDate") != null) {
        toDate = (String) request.getAttribute("toDate");
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
            .even_main,.odd_main {
                border-right:.5px solid #D9E6EC;
                border-bottom:0px solid #D9E6EC;
                padding: 3px;
                border-top:0px solid #D9E6EC;
                font-size: 12px;
                word-wrap: break-word;
            }
            .even_main {
                background-color: #f3f3f3;
            }
            .odd_main {
                background-color: #e3e3e3; 
            }
            .comment1TD {
                background-color: #CCFFFF;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .comment2TD {
                background-color: #EBB462;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
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
            
            function updateCommentOwner(commentID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=updateCommentOwnerAjax",
                    data: {
                        commentID: commentID
                    }
                    ,
                    success: function(jsonString) {
                        // do nothing
                    }
                });
            }
        </script>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/CommentsServlet?op=getCommentResponseInterval" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">(AVR) المقاولات - متوسط سرعة الرد </font>
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
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="4" WIDTH="20%">  
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>">
                            <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" >
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <br/>
            <form name="UNHANDLED_CLIENT_FORM" method="POST">
                <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE style="display" id="clients" ALIGN="center" dir="rtl" WIDTH="90%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                        <thead>                
                            <tr>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>#</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>رقم المتابعة</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>بتاريخ</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>التعليق اﻷول</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>التعليق التالي</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>المرسل</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>المرسل إليه</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>المدة الزمنية (يوم)</b></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%  int counter = 0;
                                String clazz, diff, issueCreationTime;
                                DecimalFormat df = new DecimalFormat("#.00");
                                double total = 0;
                                for (WebBusinessObject wbo : issues) {
                                    if ((counter % 2) == 1) {
                                        clazz = "odd_main";
                                    } else {
                                        clazz = "even_main";
                                    }
                                    counter++;
                                    diff = (String) wbo.getAttribute("diff");
                                    diff = diff != null ? diff.substring(0, diff.indexOf(" ")) : "";
                                    if(!diff.isEmpty()) {
                                        total += Double.parseDouble(diff);
                                    }
                                    issueCreationTime = (String) wbo.getAttribute("issueCreationTime");
                                    issueCreationTime = issueCreationTime != null ? issueCreationTime.substring(0, issueCreationTime.indexOf(" ")) : "";
                            %>
                            <tr class="<%=clazz%>" style="cursor: pointer">
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=counter%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>
                                        <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=wbo.getAttribute("businessObjectID")%>"><b style="color: red;"><%=wbo.getAttribute("businessID")%></b><b style="color: blue;">/<%=wbo.getAttribute("businessIDByDate")%></b></a>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=issueCreationTime%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center; width: 200px;" class="comment1TD">
                                    <div>                           
                                        <b><%=wbo.getAttribute("comment1") != null ? wbo.getAttribute("comment1") : ""%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center; width: 200px;" class="comment2TD">
                                    <div>                           
                                        <b><%=wbo.getAttribute("comment2") != null ? wbo.getAttribute("comment2") : ""%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center">
                                    <div>                           
                                        <b><%=wbo.getAttribute("comment1CreatedByName")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center">
                                    <div onclick="JavaScript: updateCommentOwner('<%=wbo.getAttribute("comment2ID")%>')">                           
                                        <b><%=wbo.getAttribute("comment2CreatedByName")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center">
                                    <div>                           
                                        <b><%=diff%></b>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                        <tfoot>                
                            <tr>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:18px;" colspan="3"><b>أجمالي الطلبات</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:18px;" colspan="1"><b><%=issues.size()%></b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:18px;" colspan="2"><b>متوسط سرعة الرد</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:18px;" colspan="2"><b><%=issues.isEmpty() ? total : df.format(total / issues.size())%> يوم</b></th>
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
