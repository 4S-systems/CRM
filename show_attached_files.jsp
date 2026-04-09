<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <head>
        <title></title>
        <link rel="stylesheet" href="css/demo_table.css">    
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </head>


    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        HttpSession s = request.getSession();
        Vector<WebBusinessObject> documents = (Vector) request.getAttribute("documents");
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String loggedUser = (String) waUser.getAttribute("userId");
        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();

        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        
        UserMgr userMgr = UserMgr.getInstance();

        String stat = (String) request.getSession().getAttribute("currentMode");
        
        String sDate, sTime = null;
        String sat, sun, mon, tue, wed, thu, fri, today;
        if (stat.equals("En")) {
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            today = "Today";
        } else {
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            today = "\u0627\u0644\u064a\u0648\u0645";
        }
    %>
    <script type="text/javascript">
        function removeComment(obj) {
            var commentId = $(obj).parent().parent().find("#commentId").val();
            //            alert(commentId)
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=removeComment",
                data: {
                    commentId: commentId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        //                        alert("ok");
                        // change update icon state1370883718265
                        $(obj).parent().parent().parent().remove();
                        $(obj).parent().parent().parent().find("#hr").hide();
                        $(obj).parent().parent().parent().parent().find("#hr").hide();
                        $(obj).parent().parent().parent().parent().parent().find("#hr").hide();

                        //                        alert("sdfs")

                    }
                }
            });
        }

        function editData(obj) {

            $(obj).parent().parent().parent().find("#commentText").css("display", "none");
            $(obj).parent().parent().parent().find("#commentArea").css("display", "block");
            $(obj).parent().find(".updateComment").attr("id", "updateComment");
            $(obj).parent().find("#updateComment").css("display", "block");
            $(obj).parent().find("#updateComment").css("background-position", "bottom");

            //            $(obj).parent().parent().parent().find("#updateA").css("background-position", "bottom");
            //            $(obj).parent().parent().parent().parent().parent().parent().find($("#appTitle1")).removeProp("disabled");

        }
        function updateComment(obj) {
            if ($(obj).attr("id") === "updateComment") {
                var commentId = $(obj).parent().parent().find("#commentId").val();
                //                alert(commentId)
                var comment = $(obj).parent().parent().parent().find("#commentArea").val();
                //                alert(comment)
                //            alert(appointmentId)
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=updateComment",
                    data: {
                        commentId: commentId,
                        comment: comment
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {
                            $(obj).parent().parent().parent().find("#commentText").html(info.comment);
                            $(obj).parent().parent().parent().find("#commentText").css("display", "block");
                            $(obj).parent().parent().parent().find("#commentArea").css("display", "none");
                            $(obj).css("background-position", "top");
                            $(obj).removeAttr("id");


                        }
                    }
                });
            }
        }
        $(document).ready(function() {
            $('#attachedTable').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true



            })
        });
        
        
    </script>
    <body>
        <% if (documents != null && !documents.isEmpty()) {

        %>

        <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>

        <!--<h1>رسالة قصيرة</h1>-->
        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: 300px;">
            <table  border="0px"  style="width:100%;"  class="blueBorder" id="attachedTable">
                <thead>
                    <TR >
                        <td>عنوان الملف</td>
                        <td>نوع الملف</td>
                        <td>تاريخ التسجيل</td>
                        <td>اسم المستخدم</td>

                    </TR>  
                </thead>
                <tbody >
                    <%
                        for (WebBusinessObject wbo : documents) {
                            String type = (String) wbo.getAttribute("type");
                            WebBusinessObject userWbo = null;
                            if(wbo.getAttribute("createdById") != null){
                                userWbo = userMgr.getOnSingleKey(wbo.getAttribute("createdById").toString());
                            }
                            String userName = "";
                            if(userWbo != null){
                                userName = (String) userWbo.getAttribute("fullName");
                            }

                            //                        wbo2 = userMgr.getOnSingleKey(ownerComment);
                            //                        String createdBy = (String) wbo2.getAttribute("fullName");

                            //                        String comment = "";
                            //                        if (wbo.getAttribute("comment") != null) {
                            //                            comment = (String) wbo.getAttribute("comment");
                            //                        }
                            //                        String commentId = (String) wbo.getAttribute("id");

                    %>


                    <tr>
                        <td>
                            <input type="hidden" value="<%=wbo.getAttribute("documentID")%>" name="docID"  id="docID"/>
                            <input type="hidden" value="<%=wbo.getAttribute("documentType")%>" name="documentType"  id="documentType"/>
                            <A HREF="#" onclick="javascript:viewDocument(this)">
                                <%=wbo.getAttribute("documentTitle")%>
                            </A>
                        </td>
                        <td><%=wbo.getAttribute("documentType")%></td>
                        <% Calendar c = Calendar.getInstance();
                            DateFormat formatter;
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = wbo.getAttribute("creationTime").toString().split(" ");
                            Date date = new Date();
                            sDate = arrDate[0];
                            sTime = arrDate[1];
                            String[] arrTime = sTime.split(":");
                            sTime = arrTime[0] + ":" + arrTime[1];
                            sDate = sDate.replace("-", "/");
                            arrDate = sDate.split("/");
                            sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            String currentDate = formatter.format(date);
                            String sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                        %>
                        <%if (currentDate.equals(sDate)) {%>
                        <TD nowrap  ><font color="red"><%=today%> - </font><b><%=sTime%></b></TD>
                                <%} else {%>

                        <TD nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                                <%}%>
                        <td><%=userName%></td>
                    </tr>

                    <%
                        }%>
                </tbody>
            </table>
        </div>
        <% } else {
        %>

        <div style="clear: both;margin-left: 68%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
        </div>

        <div class="login" style="width: 40%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
            <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;">لاتوجد ملفات للمشاهدة</div>
        </div>


        <%}
        %>
    </body>
</html>