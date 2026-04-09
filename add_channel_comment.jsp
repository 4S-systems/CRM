<%@page import="java.sql.Timestamp"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <head>
        <title></title>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();

            Vector<WebBusinessObject> channels = (Vector) request.getAttribute("channels");
            String clientComplaintId = (String) request.getAttribute("clientComplaintId");
        %>
        <script type="text/javascript">
            function saveChannelComment() {
                var numberOfChannels = document.getElementById('numberOfChannels').value;
                var comment = $("#channelComment").val().trim();
                var channelId = $("#channelId").val();
                var objectType = $("#objectType").val();

                if (comment == '') {
                    $("#commentMSG").css("color", "red");
                    $("#commentMSG").css("font-size", "18px");
                    $("#commentMSG").text("من فضلك اضف التعليق");
                    $("#commentMSG").addClass("error");
                    $("#commentWarning").css("display", "inline");
                } else if (numberOfChannels == 0) {
                    alert("من فضلك اختار المرسل اليه");
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/CommentsServlet?op=saveChannelComment",
                        data: {
                            clientComplaintId: '<%=clientComplaintId%>',
                            channelId: channelId,
                            comment: comment,
                            objectType: objectType
                        }
                        ,
                        success: function(jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
                                alert("تم التسجيل بنجاح");
                                $("#addChannelComment").bPopup().close();
                            } else if (eqpEmpInfo.status == 'no') {
                                alert("error");
                            }
                        }
                    });
                    $("#commentMSG").text("");
                    $("#commentWarning").css("display", "none");
                    $("#commentMSG").css("display", "none");
                }
            }
        </script>
    </head>
    <body>
        <input type="hidden" name="clientComplaintId" id="clientComplaintId" value="<%=clientComplaintId%>" />
        <input type="hidden" name="objectType" id="objectType" value="2" />
        <input type="hidden" name="numberOfChannels" id="numberOfChannels" value="<%=channels.size()%>" />

        <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>
        <form name="ADD_CHANNEL_COMMENT" method="post">
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;"> التعليق الى: </td>
                        <td style="width: 70%;" colspan="3">
                            <select style="float: right;width: 30%; font-size: 14px;" id="channelId" name="channelId">
                                <option value="all" selected>الكل</option>
                                <% for (WebBusinessObject channel : channels) {%>
                                <option value="<%=channel.getAttribute("id")%>"><%=channel.getAttribute("name")%></option>
                                <% }%>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td width="10%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">التعليق</td>
                        <td width="80%">
                            <textarea style="width: 100%;height: 80px;" id="channelComment" name="channelComment"></textarea>
                        </td>
                        <TD style="border-width: 0px" width="5%">
                            <img id="commentWarning" src="images/cancel_white.png" alt="images/cancel_white.png" align="middle" style="display: none"/>
                        </TD>
                        <TD style="border-width: 0px" width="5%">
                            <p id="commentMSG"></p>
                        </TD>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;" >
                    <input type="button" value="حفظ" onclick="saveChannelComment()" id="saveComm" class="button"/>
                </div>
            </div>
        </form>
    </body>
</html>