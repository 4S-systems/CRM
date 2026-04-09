<%@page import="org.json.simple.JSONArray"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Vector"%>
 <%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Projects.Projects"  />
<html>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    ArrayList<WebBusinessObject> allMainNodes = (ArrayList<WebBusinessObject>) request.getAttribute("allMainNodes");
    String mainNodeID = request.getAttribute("mainNodeID") != null ? (String) request.getAttribute("mainNodeID") : "";
    JSONArray data = (JSONArray) request.getAttribute("jsonArray");
%>
     <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jqwidgets.4.5/jqwidgets/styles/jqx.base.css" type="text/css" />
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/scripts/jquery-1.11.1.min.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/scripts/demos.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxcore.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxdata.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxbuttons.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxscrollbar.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxpanel.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxtree.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxmenu.js"></script>
        <style type="text/css">
            #panelContentpaneljqxTree {
                background-color: lightyellow;
                font-weight: bolder;
            }
            #jqxMenu {
                font-weight: bolder;
            }
        </style>
        <script type="text/javascript">
            $(document).ready(function () {
                $('#jqxTree').on('select', function (event) {
                    var args = event.args;
                    var item = $('#jqxTree').jqxTree('getItem', args.element);
//                    if (item.level > 0) {
//                    }
                    ;
                });
                // prepare the data
                var source =
                        {
                            datatype: "json",
                            datafields: [
                                {name: 'id'},
                                {name: 'projectID'},
                                {name: 'parentid'},
                                {name: 'text'},
                                {name: 'icon'},
                                {name: 'type'},
                                {name: 'contextMenu'}
                            ],
                            id: 'id',
                            localdata: <%=data%>
                        };

                // create data adapter.
                var dataAdapter = new $.jqx.dataAdapter(source);
                // perform Data Binding.
                dataAdapter.dataBind();
                // get the tree items. The first parameter is the item's id. The second parameter is the parent item's id. The 'items' parameter represents 
                // the sub items collection name. Each jqxTree item has a 'label' property, but in the JSON data, we have a 'text' field. The last parameter 
                // specifies the mapping between the 'text' and 'label' fields.  
                var records = dataAdapter.getRecordsHierarchy('id', 'parentid', 'items', [{name: 'text', map: 'label'}]);
                $('#jqxTree').jqxTree({source: records, width: '500px'});

                var contextMenu = $("#jqxMenu").jqxMenu({width: '120px', height: '56px', autoOpenPopup: false, mode: 'popup'});
               
                var projectId = null;

                var attachContextMenu = function () {
                    // open the context menu when the user presses the mouse right button.
                    $("#jqxTree li").on('mousedown', function (event) {
                        var target = $(event.target).parents('li:first')[0];
                        var rightClick = isRightClick(event);

                        var contextMenuArr = dataAdapter.records[target.id ].contextMenu;
                        projectId = dataAdapter.records[target.id ].projectID;
                        contextMenu = $("#jqxMenu").jqxMenu({source: contextMenuArr, width: '220px', theme: theme, height: (27.8 * contextMenuArr.length) + 'px', autoOpenPopup: false, mode: 'popup'});

                        if (rightClick && target != null) {
                            $("#jqxTree").jqxTree('selectItem', target);
                            var scrollTop = $(window).scrollTop();
                            var scrollLeft = $(window).scrollLeft();

                            contextMenu.jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
                            return false;
                        }
                    });
                }

                attachContextMenu();
                $("#jqxMenu").on('itemclick', function (event) {
                    var item = $.trim($(event.args).text());
                    switch (item) {
                        case 'البيانات الأساسية':
                            view(projectId);
                            break;
                        case 'عنصر فرعي جديد':
                            getDataInPopup('<%=context%>/ProjectServlet?op=addProject&mainProjectId=' + projectId);
                            break;
                        case 'حذف العنصر':
                            deleteProj(projectId, "");
                            break;
                        case 'أرفاق مستند':
                            getDataInPopup('<%=context%>/UnitDocWriterServlet?op=attach&projId=' + projectId + '&type=tree');
                            break;
                        case 'تحديث العنصر':
                            updateProject(projectId);
                            break;
                        case 'نقل العنصر':
                            updateParentOfProject(projectId);
                            break;
                        case 'عرض المرفقات':
                            var url = '<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&&projId=' + projectId + '&type=project';
                            var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                            wind.focus();
                            break;
                        case 'المستندات المرفقة':
                            getAttached(projectId);
                            break;
                        case 'اضافة حساب رئيسي':
                            newAccount(projectId, "main");
                            break;
                        case 'اضافة حساب فرعي':
                            newAccount(projectId, "branch");
                            break;
                        case 'حذف الحساب':
                            deleteAccount(projectId);
                            break;
                        case 'تحديث الموقع الجغرافى':
                            insertmap(projectId);
                            break;
                        case 'الموقع الجغرافى':
                            viewmap(projectId);
                            break;
                    }
                });

                // disable the default browser's context menu.
                $(document).on('contextmenu', function (e) {
                    if ($(e.target).parents('.jqx-tree').length > 0) {
                        return false;
                    }
                    return true;
                });

                function isRightClick(event) {
                    var rightclick;
                    if (!event)
                        var event = window.event;
                    if (event.which)
                        rightclick = (event.which == 3);
                    else if (event.button)
                        rightclick = (event.button == 2);
                    return rightclick;
                }

                function view(id)
                {
                    $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                    $.ajax({
                        type: "POST",
                        success: function (msg) {
                            $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=ViewProject&projectId=' + id + '&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                        }
                    });

                }
                function deleteProj(id, projName)
                {
                    getDataInPopup('<%=context%>/ProjectServlet?op=ConfirmDelete&projectId=' + id + '&projectName=' + projName + '&type=tree');
                }
                function viewmap(id)
                {
                    $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                    $.ajax({
                        type: "POST",
                        url: "<%=context%>/ProjectServlet",
                        data: "op=viewProjectMap&projectID=" + id,
                        success: function (msg) {
                            $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=viewProjectMap&single=image&projectID=' + id + '"width="100%" height="500" scrolling="no"></iframe>');
                            //$('#viewer').html(msg);
                        }, error: function () {
                            $('#viewer').html('<p><b> Need Internet Connection </b></p>');
                        }
                    });

                }

                function insertmap(id)
                {
                    $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                    $.ajax({
                        type: "POST",
                        url: "<%=context%>/ProjectServlet",
                        data: "op=insertProjectMap&projectId=" + id,
                        success: function (msg) {
                            $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=insertProjectMap&single=image&projectId=' + id + '" width="100%" height="500" scrolling="no"></iframe>');
                            //$('#viewer').html(msg);
                        }
                    });

                }

                function updateProject(id)
                {
                    $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                    $.ajax({
                        type: "POST",
                        /*url: "<%--=context--%>/EquipmentServlet",
                         data: "op=insertEquipmentMap&equipmentID="+id,*/
                        success: function (msg) {
                            $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=GetUpdateForm&projectId=' + id + '&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                            //$('#viewer').html(msg);
                        }
                    });

                }

                function updateParentOfProject(id)
                {
                    $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                    $.ajax({
                        type: "POST",
                        /*url: "<%--=context--%>/EquipmentServlet",
                         data: "op=insertEquipmentMap&equipmentID="+id,*/
                        success: function (msg) {
                            $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=updateParentOfProject&projectId=' + id + '&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                            //$('#viewer').html(msg);
                        }
                    });

                }


                function getSaveAttachedFile(id)
                {
                    openWindowParts('<%=context%>/UnitDocWriterServlet?op=attach&docId=' + id + '&type=project');

                }

                function openWindowParts(url) {
                    openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=1000, height=600");
                }

                function getAttached(id)
                {
                    $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                    $.ajax({
                        type: "POST",
                        /*url: "<%--=context--%>/EquipmentServlet",
                         data: "op=insertEquipmentMap&equipmentID="+id,*/
                        success: function (msg) {
                            $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=GetAttachedImage&projectId=' + id + '&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                            //$('#viewer').html(msg);
                        }
                    });

                }

                function AddEquipment(parentId) {

                    $("#viewer").html('<img src="images/Loading2.gif">         loading ...');
                    $('#viewer').html('<iframe src="<%=context%>/EquipmentServlet?op=GetEqpForm&showEquipment=ok&parentId=' + parentId + '" align="middle" height="950" frameborder="0" width="100%" scrolling="no" allowtransparency="true" application="true"></iframe>');

                    //                $.ajax({
                    //                    type: "POST",
                    //                    url: "<%=context%>/EquipmentServlet",
                    //                    data: "op=GetEqpForm&parentId="+parentId+"&parentName="+parentName,
                    //                    success: function(msg){
                    //                        $('#viewer').html(msg);
                    //                    }
                    //                });

                }

                function UpdateEquipment(eqpId, parentName) {
                    $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                    $.ajax({
                        type: "POST",
                        url: "<%=context%>/NewEquipmentServlet",
                        data: "op=GetUpdateEquipmentForm&equipmentID=" + eqpId,
                        success: function (msg) {
                            $('#viewer').html(msg);
                        }
                    });

                }
            });
            function submitForm() {
                window.location = "<%=context%>/ProjectServlet?op=showProjectsTree&mainNodeID=" + $("#mainNodeID").val();
            }

            function newAccount(id, type) {
                $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                $.ajax({
                    type: "POST",
                    success: function (msg) {
                        $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=getNewAccountForm&projectId=' + id + '&creationType=' + type + '&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                    }
                });
            }

            function deleteAccount(id)
            {
                getDataInPopup('<%=context%>/FinancialServlet?op=deleteAccount&projectId=' + id + '&type=tree');
            }
        </script>
    </head>

    <body>
        <%
            if (allMainNodes != null && !allMainNodes.isEmpty()) {
        %>
        <form id="TREE_FORM" action="<%=context%>/ProjectServlet?op=displayLocationsTree">
            <table align="center" cellpadding="0" cellspacing="0" border="0" style="margin-right: auto; margin-left: auto; float: left;">
                <tr>
                    <td class='td'>
                        <select name="mainNodeID" id="mainNodeID" style=" width: 180px;"
                                onchange="JavaScript: submitForm();">
                            <option value=""><fmt:message key="all"/></option>
                            <sw:WBOOptionList wboList="<%=allMainNodes%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=mainNodeID%>"/>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
        <br/>
        <%
            }
        %>
        <br/>
        <table>
            <tr>
                <td valign="top" style="background-color:#FFFF99 ;border: 2px groove;">
                    <div id='jqxTree'>
                    </div>

                    <div id='jqxMenu'>
                    </div>
                </td>
                <td valign="top" STYLE="text-align: center;vertical-align: top;">
                    <div id="viewer" style="width: 700px;"></div>
                </td>
            </tr>
        </table>
    </body>
</html>
