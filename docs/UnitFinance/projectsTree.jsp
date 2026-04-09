<%-- 
    Document   : projectsTree
    Created on : Aug 15, 2017, 3:25:18 PM
    Author     : fatma
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String prj;
    if (stat.equals("En")) {
        prj = " Projects ";
    } else {
        prj = " مشروعات ";
    }
    
    ArrayList<WebBusinessObject> projectLst = (ArrayList<WebBusinessObject>) request.getAttribute("projectLst");
    ArrayList<WebBusinessObject> zoneLst = (ArrayList<WebBusinessObject>) request.getAttribute("zoneLst");
    String includePage = "<jsp:include page='/docs/campaign/new_campaign.jsp' flush='true'></jsp:include>";
    
    String mainPrjID = "44";
    
    request.setAttribute("mainPrjID", mainPrjID);
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <link rel="stylesheet" href="jqwidgets.4.5/jqwidgets/styles/jqx.base.css" type="text/css" />
        
       <script type="text/javascript" src="jqwidgets.4.5/scripts/jquery-1.11.1.min.js"></script>
        
        <script type="text/javascript" src="jqwidgets.4.5/scripts/demos.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxcore.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxbuttons.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxdata.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxscrollbar.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxpanel.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxtree.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqwidgets/jqxexpander.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxsplitter.js"></script>
        
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxmenu.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        
        <script type="text/javascript">
             var $j = jQuery.noConflict();
             
            $j(document).ready(function () {
                // Create jqxTree
                $j("#splitter").jqxSplitter({
                    width: '99%',
                    height: '100%',
                    panels: [
                        {size: '33%'},
                        { size: '67%'}]
                });
                
                $j("#fromDatenewCamp, #toDatenewCamp").timepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
                
            function View(projectId) {
                $j.ajax({
                    type: "post",
                    data: {
                        projectId: projectId
                    },
                    url: "<%=context%>/ProjectServlet?op=apartmentProjectTree",
                    success: function (jsonString) {
                        var data = $j.parseJSON(jsonString);
                        var source =
                                {
                                    datatype: "json",
                                    datafields: [
                                        {
                                            name: 'id'
                                        },
                                        {
                                            name: 'projectID'
                                        },
                                        {
                                            name: 'parentid'
                                        },
                                        {
                                            name: 'text'
                                        },
                                        {
                                            name: 'icon'
                                        },
                                        {
                                            name: 'type'
                                        },
                                        {
                                            name: 'contextMenu'
                                        }
                                    ],
                                    id: 'id',
                                    localdata: data
                                };

                        // create data adapter.
                        var dataAdapter = new $j.jqx.dataAdapter(source);
                        // perform Data Binding.
                        dataAdapter.dataBind();
                        // get the tree items. The first parameter is the item's id. The second parameter is the parent item's id. The 'items' parameter represents 
                        // the sub items collection name. Each jqxTree item has a 'label' property, but in the JSON data, we have a 'text' field. The last parameter 
                        // specifies the mapping between the 'text' and 'label' fields.  
                        var records = dataAdapter.getRecordsHierarchy('id', 'parentid', 'items', [{name: 'text', map: 'label'}]);

                        $j('#jqxTree').jqxTree({width: '99%', height: '100%', source: records});
                        $j('#jqxTree').css('visibility', 'visible');
                        var contextMenu = $j("#jqxMenu").jqxMenu({width: '50%', height: '100%', autoOpenPopup: false, mode: 'popup'});
                        var clickedItem = null;
                        var projectId = null;
                        var attachContextMenu = function () {
                            // open the context menu when the user presses the mouse right button.
                            $j("#jqxTree li").on('mousedown', function (event) {
                                var target = $j(event.target).parents('li:first')[0];
                                var rightClick = isRightClick(event);
                                var contextMenuArr = dataAdapter.records[target.id ].contextMenu;
                                projectId = dataAdapter.records[target.id ].projectID;
                                contextMenu = $j("#jqxMenu").jqxMenu({source: contextMenuArr, width: '200px', theme: theme, height: (27.8 * contextMenuArr.length) + 'px', autoOpenPopup: false, mode: 'popup'});
                                if (rightClick && target != null) {
                                    $j("#jqxTree").jqxTree('selectItem', target);
                                    var scrollTop = $j(window).scrollTop();
                                    var scrollLeft = $j(window).scrollLeft();
                                    contextMenu.jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
                                    return false;
                                }
                            });
                        }

                        attachContextMenu();
                        $j("#jqxMenu").on('itemclick', function (event) {
                            var item = $j.trim($j(event.args).text());
                            switch (item) {
                                case 'View Campaign':
                                    viewCampaign(projectId);
                                    break;
                                case 'Add New Campaign':
                                addNewCampaign(projectId);
                                break;
                                case 'View Units':
                                    viewUnits(projectId);
                                    break;
                            }
                        });
                        // disable the default browser's context menu.
                        $j(document).on('contextmenu', function (e) {
                            if ($j(e.target).parents('.jqx-tree').length > 0) {
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
                    }
                });

                $j('#search').removeAttr('disabled');
                $j('#searchText').removeAttr('disabled');
            }
            
            function viewCampaign(projectId){
                $j("#confirmPopup").fadeOut();
                
                $j("#ContentPanel").append("<TABLE WIDTH='100%' id='camps'> </table>");
                $j.ajax({
                    type: "post",
                    data: {
                        projectId: projectId
                    },
                    url: "<%=context%>/ProjectServlet?op=apartmentProjectTree&getCamp=1",
                    success: function (jsonString) {
                        var data = $j.parseJSON(jsonString);
                        $j('#camps').dataTable({
                            "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                            iDisplayLength: 10,
                            columns: [
                                {
                                    title: 'Campaign Name',
                                    data: 'campaignName'
                                },
                                {
                                    title: 'From Date',
                                    data: 'fromDate'
                                },
                                {
                                    title: 'To Date',
                                    data: 'toDate'
                                },
                                {
                                    title: 'Cost',
                                    data: 'cost'
                                },
                                {
                                    title: 'Objective',
                                    data: 'objective'
                                }
                            ],
                            data: data,
                        }).fadeIn(2000);
                    }
                });
            }
            
            function addNewCampaign(projectId){
                //$("#campaignInfo").fadeOut();
                $j("#mainPrjID").val(projectId);
                
                $j("#confirmPopup").fadeIn();
                /*$.ajax({
                    type: "post",
                    data: {
                        projectId: projectId
                    },
                    url: "<%=context%>/CampaignServlet?op=getCampaignForm&tree=1",
                    success: function (jsonString) {
                         $("#newCampaignDiv").fadeIn();
                    }
                });*/
            }
            
            function viewUnits(projectId){
            }
        </script>
        
        <style>
        </style>
    </head>
    <body>
        <div id="splitter">
            <div>
                <FORM NAME="UNIT_FORM" id="Units_Tree_Form" METHOD="POST">
                    <input type="hidden" id="mainPrjID" name="mainPrjID">
                    <TABLE class="" CELLPADDING="0" CELLSPACING="8" ALIGN="LEFT">
                        <tr>
                            <TD align style="width: 50px;border: 0px;">
                                <SELECT name='projectId' id='projectId' style='font-size:16px;height: 27px;width: 120px' onchange="View('1492358497401');">
                                    <option value="" style="color: blue;"> </option>
                                    <option value="1492358497401" style="color: blue;"> مشروعات سكنية </option>
                                </select>
                            </TD>
                        </tr>
                    </TABLE>
                </form>
                
                <div id='jqxTree' style="visibility: hidden; border: none;" >
                </div>
                
                <div id='jqxMenu'>
                </div>
            </div>
            
            <div id="ContentPanel" style="overflow: scroll;">
                <div id="confirmPopup" style="display: none;">
                    <jsp:include page="/docs/campaign/new_campaign.jsp" flush="true">
                        <jsp:param name="mainPrjID" value="${mainPrjID}"/>
                    </jsp:include>
                </div>
            </div>
        </div>
    </body>
</html>