<%@page import="org.json.simple.JSONArray"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Vector"%>
<%@page pageEncoding="UTF-8" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    HttpSession s = request.getSession();
    WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
    String loggedUser = (String) waUser.getAttribute("userId");

    ArrayList<WebBusinessObject> projectsList = (ArrayList) request.getAttribute("prjects");

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, title;

    if (stat.equals("En")) {
        align = "center";
        dir = "Ltr";
        style = "text-align:left";
        lang = "عربي";
        langCode = "Ar";
        title = "View Unit Details";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        title = "عرض تفاصيل الوحدة السكنية";
    }
%>

<html>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jqwidgets/jqwidgets/styles/jqx.base.css" type="text/css" />
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="jqwidgets/scripts/jquery-1.11.1.min.js"></script>
        <script type="text/javascript" src="jqwidgets/scripts/demos.js"></script>
        <script type="text/javascript" src="jqwidgets/jqwidgets/jqxcore.js"></script>
        <script type="text/javascript" src="jqwidgets/jqwidgets/jqxdata.js"></script>
        <script type="text/javascript" src="jqwidgets/jqwidgets/jqxbuttons.js"></script>
        <script type="text/javascript" src="jqwidgets/jqwidgets/jqxscrollbar.js"></script>
        <script type="text/javascript" src="jqwidgets/jqwidgets/jqwidgets/jqxexpander.js"></script>
        <script type="text/javascript" src="jqwidgets/jqwidgets/jqxpanel.js"></script>
        <script type="text/javascript" src="jqwidgets/jqwidgets/jqxtree.js"></script>
        <script type="text/javascript" src="jqwidgets/jqwidgets/jqxmenu.js"></script>       
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <style type="text/css">
            #panelContentpaneljqxTree {
                background-color: lightyellow;
                font-weight: bolder;
            }

            #jqxMenu {
                font-weight: bolder;
            }

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

            .image_carousel {
                padding: 15px 0 15px 40px;
                width: 100%;
                height: 100%;
                position: relative;
            }
            .image_carousel img {
                border: 1px solid #ccc;
                background-color: white;
                padding: 9px;
                margin: 7px;
                display: block;
                float: left;
            }
            a.prev, a.next {
                background: url(images/miscellaneous_sprite.png) no-repeat transparent;
                width: 45px;
                height: 50px;
                display: block;
                position: absolute;
                top: -40px;
            }
            a.prev {			
                left: 15px;
                background-position: 0 0; }
            a.prev:hover {		background-position: 0 -50px; }
            a.next {			right: -30px;
                       background-position: -50px 0; }
            a.next:hover {		background-position: -50px -50px; }

            a.prev span, a.next span {
                display: none;
            }
            .clearfix {
                float: none;
                clear: both;
            }
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
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .smallDialog {
                width: 320px;
                display: none;
                position: fixed;
                z-index: 1000;
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .mfp-no-margins img.mfp-img {
                padding: 0;
            }
        </style>

        <script type="text/javascript">
            function View() {
                var selectedLabel;

                $.ajax({
                    type: "post",
                    data: {projectId: $("#project").val()},
                    url: "<%=context%>/FinancialServlet?op=buildFinanceTree",
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
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
                                    localdata: data
                                };
                        // create data adapter.
                        var dataAdapter = new $.jqx.dataAdapter(source);
                        // perform Data Binding.
                        dataAdapter.dataBind();
                        // get the tree items. The first parameter is the item's id. The second parameter is the parent item's id. The 'items' parameter represents 
                        // the sub items collection name. Each jqxTree item has a 'label' property, but in the JSON data, we have a 'text' field. The last parameter 
                        // specifies the mapping between the 'text' and 'label' fields.  
                        var records = dataAdapter.getRecordsHierarchy('id', 'parentid', 'items', [{name: 'text', map: 'label'}]);
                        $('#jqxTree').jqxTree({source: records, width: '200px'});
                        $('#jqxTree').css('visibility', 'visible');
                        $('#jqxTree').on('click', function () {
                            var item = $('#jqxTree').jqxTree('getSelectedItem');
                            selectedLabel = item.label;
                            var id = item.id;

                            var insertedAccount = window.opener.document.getElementById('q2');
                            insertedAccount.value = selectedLabel;
                            window.close();
                            
                        });
                        var contextMenu = $("#jqxMenu").jqxMenu({width: '120px', height: '56px', autoOpenPopup: false, mode: 'popup'});
                        var clickedItem = null;
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
                                case 'اضافة حساب رئيسي':
                                    newAccount(projectId, "main");
                                    break;
                                case 'اضافة حساب فرعي':
                                    newAccount(projectId, "branch");
                                    break;
                                case 'حذف الحساب':
                                    deleteAccount(projectId);
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
                    }
                });

                $('#search').removeAttr('disabled');
                $('#searchText').removeAttr('disabled');
            }

            function popupPlan() {
                $('#ViewDetailes').bPopup({modal: false});
                $('#ViewDetailes').css("display", "block");
            }

            function closePopup(obj) {
                $("#ViewDetailes").bPopup().close();
                $("#ViewDetailes").css("display", "none");
            }

            function Search() {
                //Setting current selected item as null 
                $('#jqxTree').jqxTree('selectItem', null);

                //collapsing tree(in case if user has already searched it )
                $('#jqxTree').jqxTree('collapseAll');

                //Using span for highlighting text so finding earlier searched items(if any)
                var previousHighlightedItems = $('#jqxTree').find('span.highlightedText');

                // If there are some highlighted items, replace the span with its html part, e.g. if earlier it was <span style="background-color:"Yellow">Te></span>st then it will replace it with "Te""st"
                if (previousHighlightedItems && previousHighlightedItems.length > 0) {
                    var highlightedText = previousHighlightedItems.eq(0).html();

                    $.each(previousHighlightedItems, function (idx, ele) {
                        $(ele).replaceWith(highlightedText);
                    });
                }

                //Getting all items for jqxTree
                var items = $('#jqxTree').jqxTree("getItems");

                //Getting value for input search box and converting it to lower for case insensitive(may change)
                var searchedValue = $("#searchText").val().toLowerCase();

                //Searching the text in items label
                for (var i = 0; i < items.length; i++) {
                    var itemText = items[i].label.toLowerCase();
                    if (items[i].label.toLowerCase().indexOf(searchedValue) > -1) {
                        //If found expanding the tree to that item
                        $('#jqxTree').jqxTree('expandItem', items[i].parentElement);

                        //selecting the item : not necessary as it selects the last item if multiple occurrences are found             
                        $('#jqxTree').jqxTree('selectItem', items[i]);

                        //changing the innerhtml of found item and adding span with highlighted color
                        var itemLabelHTML = $(items[i].element).find('div').eq(0).html();

                        //splitting the item text so that only searched text can be highlighted by appending span to it.
                        var splittedArray = itemLabelHTML.split(searchedValue);
                        var highlightedText = '';

                        //if there are multiple occurrences of same searched text then adding span accordingly
                        for (var j = 0; j < splittedArray.length; j++) {
                            if (j != splittedArray.length - 1)
                                highlightedText = highlightedText + splittedArray[j] + '<span class="highlightedText" style="background-color:yellow">' + searchedValue + '</span>';
                            else
                                highlightedText = highlightedText + splittedArray[j];

                        }

                        //replacing the item html with appended styled span
                        $(items[i].element).find('div').eq(0).html(highlightedText);
                    }
                }
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
        <FORM NAME="UNIT_FORM" id="Units_Tree_Form" METHOD="POST">
            <TABLE class="" CELLPADDING="0" CELLSPACING="8" ALIGN="LEFT" DIR="<%=dir%>">
                <tr>
                    <!--TD style=" background-color: lightsteelblue; border: 0px">
                        <p><b style="font-weight: bold">الحساب الرئيسي</b></p>
                    </TD-->
                    <TD align style="width: 50px;border: 0px;">
                        <SELECT name='project' id='project' style='font-size:16px;height: 27px;width: 120px' onchange="getModels(this.value)">
                            <option value="1475870638176" style="color: blue;">الكل</option>
                            <%
                                for (WebBusinessObject Wbo : projectsList) {
                                    String projectName = (String) Wbo.getAttribute("projectName");
                                    String projectId = (String) Wbo.getAttribute("projectID");
                            %>
                            <option value='<%=projectId%>'><b id="projectN"><%=projectName%></b></option>
                            <% }%>
                        </select>
                    </TD>
                    <TD style=" border: 0px; width: 20px">
                        <input type="button" id="view" value="أعرض" onClick="JavaScript: View();">
                    </td>
                </tr>
                <!--TR>
                    <TD style=" background-color: lightsteelblue; border: 0px; width: 20px" colspan="2">
                        <input style="width:100%;font-size:14px;font-weight: bold" type="TEXT" dir="<%=dir%>" name="searchText" ID="searchText" size="20" value="" disabled="false">
                    </TD>
                    <TD>
                        <input type="button" id="search" value="ابحث" onClick="JavaScrip
                                    : Search();" width="50px" disabled="false">
                    </TD>
                </TR-->
            </TABLE>
        </FORM>
        <br>

        <table cellpadding="0" cellspacing="0" style="border:0px;float: left">
            <tr>
                <td valign="top" style="background-color:lightyellow ;border: 0px groove;">
                    <div id='jqxTree'>
                    </div>

                    <div id='jqxMenu'>
                    </div>
                </td>
                <td valign="top" STYLE="text-align: center;vertical-align: top;border: 0px">
                    <div id="viewer" style="width: 700px;"></div>
                </td>
            </tr>
        </table>    

        <br/>
    </body>
</html>