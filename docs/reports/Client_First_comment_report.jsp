<%@page import="java.text.DecimalFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject, java.util.*"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
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
                background-color: #cccccc;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .comment2TD {
                background-color: #7fc1ea;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .comment3TD {
                background-color: #59bebd;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .TotalTime {
                background-color: #f8deff;
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
                    success: function (jsonString) {
                        // do nothing
                    }
                });
            }
        </script>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/CommentsServlet?op=getClientCommentResponseInterval" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">متوسط سرعة الرد علي العميل</font>
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
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>
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
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>كود العميل</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>اسم العميل</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>تاريخ اضافة العميل</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>الموظف السؤلرعن اضافة العميل</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>التعليق</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>تاريخةالتعليق</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>الموظف السؤل عن التعليق</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; font-size:14px;"><b>الوقت المستغرق</b></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%  int counter = 0;
                                String clazz;

                                for (WebBusinessObject wbo : issues) {
                                    if ((counter % 2) == 1) {
                                        clazz = "odd_main";
                                    } else {
                                        clazz = "even_main";
                                    }
                                    counter++;

                                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                    Calendar cal = Calendar.getInstance();

                                    String creationDate = wbo.getAttribute("clientCreationTime").toString();
                                    String comment1Date = dateFormat.format(cal.getTime());

                                    //get the diffrenence between end and start date
                                    DateAndTimeControl dtControl = new DateAndTimeControl();
                                    Vector duration = dtControl.calculateDateDiff(creationDate, comment1Date);
                            %>
                            <tr class="<%=clazz%>" style="cursor: pointer">
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=wbo.getAttribute("ClientNumber")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=wbo.getAttribute("ClientName")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=wbo.getAttribute("clientCreationTime").toString().substring(0, 11)%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=wbo.getAttribute("CLIENT_CREATED_BY_NAME")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center; width: 200px;" class="comment2TD">
                                    <div>                           
                                        <b><%=wbo.getAttribute("COMMENT_DESC")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=wbo.getAttribute("COMMENTS_CREATION_TIME")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center" nowrap>
                                    <div>                           
                                        <b><%=wbo.getAttribute("COMMENT_CREATED_BY_NAME")%></b>
                                    </div>
                                </td>
                                <td STYLE="text-align: center; width: 200px;">
                                    <div>                           
                                        <b><%=duration.get(0).toString()%></b>
                                    </div>
                                </td>
                            </TR>
                            <%}%>
                        </tbody>
                    </table>
                </div>
                <br/>
                <br/>
            </form>
        </fieldset>
    </body>
</html>
