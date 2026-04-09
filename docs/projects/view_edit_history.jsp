<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> historyList = (ArrayList<WebBusinessObject>) request.getAttribute("historyList");
        String projectName = (String) request.getAttribute("projectName");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, project, unitsNum, inDate, meterPrice, garageNum, lockerNum;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            project = "Project";
            inDate = "In Date";
            unitsNum = "Units Number";
            meterPrice = " Meter Price ";
            garageNum = " Garages Number ";
            lockerNum = " Lockers Number";
        } else {
            align = "right";
            dir = "RTL";
            project = "المشروع";
            unitsNum = "عدد الوحدات";
            inDate = "في تاريخ";
            meterPrice = " سعر المتر";
            garageNum = " عدد الجراجات";
            lockerNum = " عدد وحدات التخزين ";
        }
    %>
    <head>
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }

            #products{
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }

            #products tr{
                padding: 5px;
            }

            #products td{
                font-size: 12px;
                font-weight: bold;
            }

            #products select{
                font-size: 12px;
                font-weight: bold;
            }
        </style>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function () {
                $('#historyTable').DataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });
        </SCRIPT>
    </head>

    <body>
        <div style="clear: both;margin-left: 95%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup('project_engineers')"/>
        </div>

        <div class="login" style="width: 95%;">
            <h3><%=project%> : <%=projectName%></h3>
            <table id="historyTable" style="width:100%;" style="border:none;" align="center" dir="<%=dir%>">
                <thead>
                    <tr>
                        <th nowrap>
                            <%=inDate%>
                        </th>
                        <th nowrap>
                            <%=unitsNum%>
                        </th>
                        <th nowrap>
                            <%=meterPrice%>
                        </th>
                        <th nowrap>
                            <%=garageNum%>
                        </th>
                        <th nowrap>
                            <%=lockerNum%>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (WebBusinessObject historyWbo : historyList) {
                    %>
                    <tr>
                        <td nowrap>
                            <%=historyWbo.getAttribute("creationTime") != null ? ((String) historyWbo.getAttribute("creationTime")).substring(0, 16) : ""%>
                        </td>
                        <td nowrap>
                            <%=historyWbo.getAttribute("unitNum") != null ? historyWbo.getAttribute("unitNum") : "0"%>
                        </td>
                        <td nowrap>
                            <%=historyWbo.getAttribute("meterPrice") != null ? historyWbo.getAttribute("meterPrice") : "0"%>
                        </td>
                        <td nowrap>
                            <%=historyWbo.getAttribute("garageNum") != null ? historyWbo.getAttribute("garageNum") : "0"%>
                        </td>
                        <td nowrap>
                            <%=historyWbo.getAttribute("lockerNum") != null ? historyWbo.getAttribute("lockerNum") : "0"%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <br/>
        </div>
    </body>
</html>