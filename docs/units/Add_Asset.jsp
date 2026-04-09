<%-- 
    Document   : Add_Asset
    Created on : Aug 14, 2017, 3:32:04 PM
    Author     : fatma
--%>

<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.lowagie.text.html.HtmlTags"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<!DOCTYPE html>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    ArrayList<WebBusinessObject> clientsList = request.getAttribute("clientsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("clientsList") : null;

    ArrayList<WebBusinessObject> projectLst = request.getAttribute("projectLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("projectLst") : null;

    String saveFlag = request.getAttribute("saveFlag") != null ? (String) request.getAttribute("saveFlag") : null;

    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir, selectClient, title, selectBranch, assetCod, assetTitle, floorNum, roomNum, model, save, equClass;
    if (stat.equals("En")) {
        dir = "LTR";
        selectClient = " Select Client ";
        title = " Add Assets ";
        selectBranch = " Select Branch ";
        assetCod = " Asset Code ";
        assetTitle = " Asset Title ";
        floorNum = " Floor ";
        roomNum = " Room ";
        model = " Model ";
        save = " Save ";
        equClass = " Equipment Class ";
    } else {
        dir = "RTL";
        selectClient = " إختر عميل ";
        title = " إضافة معدات ";
        selectBranch = " إختر فرع ";
        assetCod = " الكود ";
        assetTitle = " الإسم ";
        floorNum = " الدور ";
        roomNum = " غرفة ";
        model = " موديل ";
        save = " حفظ ";
        equClass = " Equipment Class ";
    }

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList<WebBusinessObject> equClassLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("EQP_CLASS", "key6"));
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Add Assets </title>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>

        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <script type="text/javascript">
            $(document).ready(function () {
                $("#clientsLstIDS").select2();

                $("#projectLstIDS").select2();

                $("#equClassLstIDS").select2();

            });

            function viewProjects() {
                var clientId = $('#clientsLstIDS option:selected').val();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=addAsset",
                    data: {
                        clientId: clientId
                    }, success: function (jsonString) {
                        var result = $.parseJSON(jsonString);
                        var options = [];
                        $.each(result, function () {
                            options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                        });
                        $("#projectLstIDS").html(options.join(''));
                    }
                });
            }

            function saveAsset() {
                var parentPrj = $('#projectLstIDS option:selected').val();
                var floorNum = $('#floorNum').val();
                var roomNum = $('#roomNum').val();
                var model = $('#model').val();
                var assetCod = $('#assetCod').val();
                var assetTitle = $('#assetTitle').val();
                var operation = "save";
                var equClassID = $("#equClassLstIDS option:selected").val();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=addAsset",
                    data: {
                        parentPrj: parentPrj,
                        floorNum: floorNum,
                        roomNum: roomNum,
                        model: model,
                        assetCod: assetCod,
                        assetTitle: assetTitle,
                        operation: operation,
                        equClassID: equClassID
                    }
                });
            }
        </script>


        <style>

            .titlebar {
                height: 30px;
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
            
            .button2{
            font-family: "Script MT", cursive;
            font-size: 18px;
            font-style: normal;
            font-variant: normal;
            font-weight: 400;
            line-height: 20px;
            width: 134px;
            height: 32px;
            text-decoration: none;
            display: inline-block;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.8s;
            cursor: pointer;
            border-radius: 12px;
            border: 1px solid #008CBA;
            padding-left:2%;
            text-align: center;
        }


        .button2:hover {
            background-color: #afdded;
            padding-top: 0px;
        }
        </style>
    </head>
    <body>
        <form NAME="Add_Assets_FORM" METHOD="POST">
            <fieldset class="set backstyle" style="width:80%; border-color: #006699;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="direction: <%=dir%>">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4">
                            <%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>

                <br/>

                <% if (saveFlag != null && saveFlag.equals("yes")) {%>
                <input type="text" id="saveRes" name="saveRes" value=" Asset Has Been Saved " style="border: none; color: green;">
                <% } else if (saveFlag != null && saveFlag.equals("no")) {%>
                <input type="text" id="saveRes" name="saveRes" value=" Asset Hasn`t Been Saved " style="border: none; color: red;">
                <% } %>

                <%
                    if (clientsList != null && !clientsList.isEmpty()) {%>
                <div style="width: 90%; padding: 9px; direction: <%=dir%>;">
                    <TABLE style="width: 80%; direction: <%=dir%>;">
                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=selectClient%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;" colspan="5">
                                <SELECT id="clientsLstIDS" name="clientsLstIDS" STYLE="width:80%; font-size: medium; font-weight: bold;" onchange="viewProjects();">
                                    <option value="">
                                        <%=selectClient%> 
                                    </option>
                                    <sw:WBOOptionList wboList='<%=clientsList%>' displayAttribute = "name" valueAttribute="id" />
                                </SELECT>
                            </TD>
                        </TR>

                        <tr></tr>
                        <tr></tr>

                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=selectBranch%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;" colspan="5">
                                <SELECT id="projectLstIDS" name="projectLstIDS" STYLE="width: 80%; font-size: medium; font-weight: bold;" onchange="">
                                    <option value="">
                                        <%=selectBranch%> 
                                    </option>
                                </SELECT>
                            </TD>
                        </TR>

                        <tr></tr>
                        <tr></tr>

                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=equClass%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;" colspan="5">
                                <SELECT id="equClassLstIDS" name="equClassLstIDS" STYLE="width: 80%; font-size: medium; font-weight: bold;" onchange="">
                                    <option value="">
                                        <%=equClass%> 
                                    </option>
                                    <sw:WBOOptionList wboList='<%=equClassLst%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                </SELECT>
                            </TD>
                        </TR>
                        <tr></tr>
                        <tr></tr>

                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=assetCod%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;">
                                <input id="assetCod" name="assetCod" type="text" style="border: 1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px" placeholder=" Add Asset Code ">
                            </TD>

                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=assetTitle%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border:none; padding: 10px;">
                                <input id="assetTitle" name="assetTitle" type="text" style="border: 1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px" placeholder=" Add Asset Title ">
                            </TD>

                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=model%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;">
                                <input id="model" name="model" type="text" style="border:1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px" placeholder=" Add Asset Model ">
                            </TD>
                        </TR>

                        <tr></tr>
                        <tr></tr>

                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=floorNum%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;">
                                <input id="floorNum" name="floorNum" type="number" style="border: 1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px" min="1">
                            </TD>

                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px; border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=roomNum%>
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;">
                                <input id="roomNum" name="roomNum" type="number" style="border: 1px solid silver;border-radius: 5px;height: 25px;padding-left: 10px" min="1">
                            </TD>
                        </TR>

                        <TR>
                            <td style="border: none; text-align: center; padding: 10px; float: end;" colspan="4">
                            </td>

                            <td style="border: none; text-align: center; padding: 10px; float: end;" colspan="2">
                                <button class="button2" style="width: 60%;" onclick="saveAsset();">
                                    <%=save%>
                                </button>
                            </td>
                        </TR>
                    </TABLE>
                </div>
                <% }%>
            </fieldset>
        </form>
    </body>
</html>
