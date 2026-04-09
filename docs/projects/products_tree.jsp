<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    String status = (String) request.getAttribute("Status");
    //  String Name = (String) request.getAttribute("mainName");
    // Vector brands = new Vector();
    // brands = (Vector) request.getAttribute("brands");
    Vector<WebBusinessObject> mainCatsTypes = new Vector();
    // String doubleName = (String) request.getAttribute("name");
    mainCatsTypes = (Vector) request.getAttribute("data");
    String doubleName = (String) request.getAttribute("name");
    Vector brands = new Vector();
    brands = (Vector) request.getAttribute("brands");
    String Name = (String) request.getAttribute("mainName");
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String message = null;
    String lang, langCode, title, Show, mainData, EquipmentRow, selectMain, link1, link2, link3, link4, link5, M1, M2, Dupname;
    String open, add, deleteProjectLabel, geographicLoc, updateProject, attachedImage;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        title = "Equipment Tree";
        Show = "Show Tree";
        EquipmentRow = "Equipment Categories";
        selectMain = "Select Main Type";
        link1 = "Equipment Details";
        link2 = "Last Job Order";
        link3 = "Schedules";
        link4 = "Equipment Plan";
        link5 = "Related Parts";
        M1 = "The Saving Successed";
        M2 = "The Saving Successed Faild";
        Dupname = "Name is Duplicated Change it";
        open = "Main Information ";
        add = "New sub Project";
        deleteProjectLabel = "Delete Project";
        geographicLoc = "Geographic Location";
        updateProject = "Update Location";
        attachedImage = "Attached image";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        title = "المنتجات";
        Show = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1588;&#1580;&#1585;&#1607;";
        EquipmentRow = " &#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;";
        selectMain = "&#1571;&#1582;&#1578;&#1585; &#1606;&#1608;&#1593; &#1585;&#1574;&#1610;&#1587;&#1610;";
        link1 = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        link2 = "&#1593;&#1585;&#1590; &#1571;&#1582;&#1585; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        link3 = "&#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
        link4 = "&#1575;&#1604;&#1582;&#1591;&#1607;";
        link5 = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        M1 = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";

        open = "المعلومات الأساسية";
        add = "موقع فرعي جديد";
        deleteProjectLabel = "حذف الموقع";
        geographicLoc = "الموقع الجغرافى";
        updateProject = "تحديث الموقع";
        attachedImage = "الصور المرفقة";
        M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
    }

    ArrayList treeMenu = metaMgr.getTreeMenu();
    if (treeMenu.get(0) == null) {
        System.out.println("jkdshfljksahdfjklshdlkjfsdh kjlg");

    }
%>
<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="treemenu/page_style.css" />
        <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>


        <script type="text/javascript">
            function getSubProduct(mainProductId) {
                if(mainProductId==null||mainProductId==""){
                  
                }else{
                    document.getElementById('subProduct').innerHTML = "";
                    $("#showBtn").removeAttr("disabled");
                    var url = "<%=context%>/ProjectServlet?op=getModels&mainProductId=" + mainProductId;
                    if (window.XMLHttpRequest) {
                        req = new XMLHttpRequest();
                    } else if (window.ActiveXObject) {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    req.open("Post",url,true);
                    req.onreadystatechange =  callbackFillMainCategory;
                    req.send(null);}
            }
            function callbackFillMainCategory(){
                if (req.readyState==4) {
                    if (req.status == 200) {
                        var brand = document.getElementById('subProduct');
                        var result = req.responseText;
                        //                        alert(result);
                        if(result != "") {
                            var data = result.split("<element>");
                            var idAndName = "";
                          
                            for(var i = 0; i < data.length; i++) {
                                idAndName = data[i].split("<subelement>");

                                brand.options[brand.options.length] = new Option(idAndName[1], idAndName[0]);
                            }
                        } else {
                            //                            alert("Not Found Brands For this Main Category ...")
                        }
                    }
                }
            }
            function changeMode(name) {
                if(document.getElementById(name).style.display == 'none') {
                    document.getElementById(name).style.display = 'block';
                } else {
                    document.getElementById(name).style.display = 'none';
                }
            }
    
            function reloadAE(nextMode){

                var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
                if (window.XMLHttpRequest)
                {
                    req = new XMLHttpRequest();
                }
                else if (window.ActiveXObject)
                {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                req.open("Post",url,true);
                req.onreadystatechange =  callbackFillreload;
                req.send(null);

            }
            function submitForm()
            {
                
                var id = document.getElementById("subProduct").value;
    
            
                //                alert(id);
                document.MainType_Form.action = "<%=context%>/ProjectServlet?op=ProductItemsTree&ID="+id;
                              
                document.MainType_Form.submit();
              
            }

        </script>

        <style >
            a{
                color:blue;
                background-color: transparent;
                text-decoration: none;
                font-size:12px;
                font-weight:bold;
            }

            #open, #email, #save,#delete,#insert{
                font-size: 12px;
                font-weight: bold;
            }
        </style>
        <script type="text/javascript">
            $(document).ready(function() {
                $('a[title="child"]').contextMenu('myMenu1', {


                    bindings: {

                        'open': function(t) {


                            view(t.id);
                            //$("#show").val("  "+t.id);EquipmentServlet?op=ListEquipments&fieldName=PARENT_ID&fieldValue=

                        },

                        'email': function(t) {

                            deleteProj(t.id, t.name);

                        }, 'add': function(t) {

                            //view(t.id);
                            getDataInPopup('<%=context%>/ProjectServlet?op=addProject&mainProjectId='+t.id);
                            //alert('Trigger was '+t.id+'\nAction was Save');

                            //$("#show").val("  "+t.id);

                        },

                        'save': function(t) {

                            //alert('Trigger was '+t.title+'\nAction was Save');
                            insertmap(t.id);

                        },

                        'delete': function(t) {

                            viewmap(t.id);

                        },

                        'update': function(t) {

                            updateProject(t.id);

                        },

                        'attach': function(t) {

                            getAttached(t.id);

                        }
                    },

                    itemStyle: {

                        width:'130px',

                        backgroundColor : '#C8C8C8',

                        color: 'black',

                        border: 'none',

                        padding: '1px'

                    },

                    itemHoverStyle: {

                        color: 'white',

                        backgroundColor: '#66CCFF',

                        border: 'none'

                    }



                });
                $('a[title="parent"]').contextMenu('myMenu', {


                    bindings: {

                        'open':         function(t) {
                            //view(t.id);
                            getDataInPopup('<%=context%>/EquipmentServlet?op=ListEquipments&parentId=' + t.id);
                            //alert('Trigger was '+t.id+'\nAction was Save');

                            //$("#show").val("  "+t.id);

                        },
                        'add': function(t) {

                            //view(t.id);
                            getDataInPopup('<%=context%>/EquipmentServlet?op=attachedEqptoMainEqp&equipmentID='+t.id);
                            //alert('Trigger was '+t.id+'\nAction was Save');

                            //$("#show").val("  "+t.id);

                        },

                        'email': function(t) {

                            //deleteProj(t.id);
                            AddEquipment(t.id);

                        },

                        'save': function(t) {

                            alert('Trigger was '+t.title+'\nAction was Save');

                        },

                        'delete': function(t) {

                            alert('Trigger was '+t.target+'\nAction was Delete');

                        }
                    }


                });
                //$('.node').click(function(){
                //alert('Left mouse bussss'+$(this).attr('id'));


                //});
                $('#ww').mousedown(function(event) {
                    switch (event.which) {
                        case 1:
                            alert('Left mouse button pressed');
                            break;
                        case 2:
                            alert('Middle mouse button pressed');
                            break;
                        case 3:
                            alert('Right mouse button pressed');
                            break;
                        default:
                            alert('You have a strange mouse');
                    }
                });
                $('.dTreeNode').first().children("a").removeAttr('href');
            });

            function view(id)
            {
                $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                $.ajax({
                    type: "POST",
                    success: function(msg){
                        $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=ViewProject&projectId='+id+'&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                    }
                });

            }
            function deleteProj(id, projName)
            {
                //alert('name : ' + projName + ' , id = ' + id);
                $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                $.ajax({
                    type: "POST",
                    success: function(msg){
                        $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=ConfirmDelete&projectId='+id+'&projectName='+projName+'&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                    }
                });

            }
            function viewmap(id)
            {
                $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                $.ajax({
                    type: "POST",
                    url: "<%=context%>/ProjectServlet",
                    data: "op=viewProjectMap&projectID="+id,
                    success: function(msg){
                        $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=viewProjectMap&single=image&projectID='+id+'"width="100%" height="500" scrolling="no"></iframe>');
                        //$('#viewer').html(msg);
                    },error:function(){
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
                    data: "op=insertProjectMap&projectId="+id,
                    success: function(msg){
                        $('#viewer').html('<iframe src="<%=context%>/EquipmentServlet?op=insertProjectMap&single=image&projectId='+id+'" width="100%" height="500" scrolling="no"></iframe>');
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
                    success: function(msg){
                        $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=GetUpdateForm&projectId='+id+'&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                        //$('#viewer').html(msg);
                    }
                });

            }

            function getAttached(id)
            {
                $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                $.ajax({
                    type: "POST",
                    /*url: "<%--=context--%>/EquipmentServlet",
            data: "op=insertEquipmentMap&equipmentID="+id,*/
                    success: function(msg){
                        $('#viewer').html('<iframe src="<%=context%>/ProjectServlet?op=GetAttachedImage&projectId='+id+'&type=tree" width="100%" height="500" scrolling="no"></iframe>');
                        //$('#viewer').html(msg);
                    }
                });

            }

            function AddEquipment(parentId){
                
                $("#viewer").html('<img src="images/Loading2.gif">        loading ...');
                $('#viewer').html('<iframe src="<%=context%>/EquipmentServlet?op=GetEqpForm&showEquipment=ok&parentId='+parentId+'" align="middle" height="950" frameborder="0" width="100%" scrolling="no" allowtransparency="true" application="true"></iframe>');
                
                //                $.ajax({
                //                  type: "POST",
                //                    url: "<%=context%>/EquipmentServlet",
                //                    data: "op=GetEqpForm&parentId="+parentId+"&parentName="+parentName,
                //                    success: function(msg){
                //                        $('#viewer').html(msg);
                //                    }
                //                });

            }

            function UpdateEquipment(eqpId, parentName){
                $("#viewer").html('<img src="images/Loading2.gif"> loading ...');
                $.ajax({
                    type: "POST",
                    url: "<%=context%>/NewEquipmentServlet",
                    data: "op=GetUpdateEquipmentForm&equipmentID="+eqpId,
                    success: function(msg){
                        $('#viewer').html(msg);
                    }
                });

            }
        </script>
    </head>

    <body>

        <div class="contextMenu" id="myMenu1">

            <ul>

                <li id="open"><a href="#top"> <%=open%></a></li>

                <li id="add"><a href="#top"> <%=add%> </a></li>

                <li id="email"><a href="#top"> <%=deleteProjectLabel%></a> </li>

                <li id="update"><a href="#top"> <%=updateProject%></a></li>

                <!--<li id="save">Update</li>-->

                <li id="delete"><a href="#top"> <%=geographicLoc%></a></li>
                <li id="attach"><a href="#top"> <%=attachedImage%></a></li>

            </ul>

        </div>
        <div class="contextMenu" id="myMenu">

            <ul>

                <li id="open"> Search </li>

                <li id="add"> add </li>

                <li id="email"> New Equipment </li>

                <li id="save"> Save </li>

                <li id="delete"> View Map </li>

            </ul>

        </div>
        <form name="MainType_Form" method="post">

            <fieldset class="set" style="width:100%;border-color: #006699;" >
                <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%></font></TD>
                    </TR>
                </TABLE>
                <br>

                <table ID="tableSearch" class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="3" CELLSPACING="1" width="50%">
                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;font-size:15px;">
                            <font  SIZE="2" COLOR="#F3D596"><b>نوع الإستثمار</b></font>
                        </TD>

                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;color:#000000;font-size:15px;background-color: #EDEDED;text-align: right;"id="CellData" >
                            <!--<SELECT name="mainCatType" ID="mainCatType" STYLE="font-weight: bold;font-size: 14;border: 1px solid #0000FF; width:230px; z-index:-1;" >-->
                            <!--<option value="-1"></option>-->
                            <%--<sw:WBOOptionList wboList='<%=mainCatsTypes%>' displayAttribute = "typeName" valueAttribute="id"/>--%> 
                            <!--<input type="hidden" name="mainName" value="typeName"/>-->
                            <!--</SELECT>-->
                            <SELECT name='mainProduct' id='mainProduct' style='width:170px;font-size:16px;' onchange="getSubProduct(this.value)">
                                <option>----</option>
                                <%for (WebBusinessObject Wbo : mainCatsTypes) {
                                        String productName = (String) Wbo.getAttribute("projectName");
                                        String productId = (String) Wbo.getAttribute("projectID");%>
                                <option value='<%=productId%>'><b id="projectN"><%=productName%></b></option>
                                <%}%>
                            </select>

                            <!--<button  onclick="JavaScript:  submitForm();" class="button" style="width:100px "> <%=Show%></button>-->
                        </TD>
                    </TR>
                    <tr><td colspan="3" style="height: 5px;"></td></tr>
                    <TR rowspan="2">
                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;font-size:17px;">
                            <font  SIZE="2" COLOR="#F3D596"><b>الفنة</b></font>
                        </TD>

                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;color:#000000;font-size:15px;background-color: #EDEDED;text-align: right;"  >
                            <!--<SELECT name="mainCatType" ID="mainCatType" STYLE="font-weight: bold;font-size: 14;border: 1px solid #0000FF; width:230px; z-index:-1;" >-->
                            <!--<option value="-1"></option>-->
                            <%--<sw:WBOOptionList wboList='<%=mainCatsTypes%>' displayAttribute = "typeName" valueAttribute="id"/>--%> 
                            <!--<input type="hidden" name="mainName" value="typeName"/>-->
                            <!--</SELECT>-->



                            <SELECT name='subProduct' id='subProduct' style='width:170px;font-size:16px;'>
                                <option>----</option>
                            </select>

                            <!--<button  onclick="JavaScript:  submitForm();" class="button" style="width:100px "> <%=Show%></button>-->
                        </TD>
                    </TR>
                    <tr ><td colspan="3"></td></tr>
                    <tr>
                        <td colspan="2" style="border: none;">
                            <button id="showBtn" onclick="JavaScript:  submitForm();" class="button" style="width:100px " disabled="disabled"> <%=Show%></button>
                        </td>

                    </tr>

                </table>
                <%if (brands != null) {%><table width="100%" ><tr><td valign="top" width="30%" style="padding-left: 20px;">

                            <div align ="left">



                                <script type="text/javascript">
                                    <!--
                                    d = new dTree('d');
                                    d.add(0,-1,'<%=Name%>');
                                    <%
                                        int size = 1;
                                        int parent = 0;

                                        for (int i = 0; i < brands.size(); i++) {
                                            WebBusinessObject Model = (WebBusinessObject) brands.get(i);

                                    %>
                                        d.add(<%=size%>,0,"<%= Model.getAttribute("projectName")%>","javascript:view('<%= Model.getAttribute("projectID")%>');",'child','<%= Model.getAttribute("projectID")%>');
                                    <%
                                            size++;
                                            parent++;



                                        }%>
		
                                
                                            //d.closeAll();
                                            d.openAll();
                                            document.write(d);

                                            //-->
                                </script>
                            </div>
                        </td>
                        <td valign="top">
                            <table id="status" style="display: block;">
                                <%
                                    if (null != status) {
                                        if (status.equalsIgnoreCase("ok")) {
                                            message = M1;
                                        } else {
                                            if (status.equalsIgnoreCase("1062")) {
                                                message = M2;
                                            } else {
                                                message = M2;
                                            }
                                        }
                                %>
                                <TR>
                                    <TD STYLE="text-align: center" colspan="4" class="blueBorder backgroundTable boldFont bar">
                                        <B><FONT size="3" color="blue"><%=message%></FONT></B><br>
                                    </TD>
                                </TR>
                                <% }%>
                                <% if (null != doubleName) {%>
                                <TR>
                                    <TD STYLE="text-align: center" colspan="4" class="blueBorder backgroundTable boldFont bar">
                                        <B><FONT size="3" color="blue"><%=Dupname%></FONT></B><br>
                                    </TD>
                                </TR>
                                <% }%>
                            </table>

                            <div id="viewer" style="width: 700px;"></div>

                        </td>
                    </tr>
                </table>
                <%}%>
            </fieldset>
        </form>
        <script type="text/javascript">
            $(function(){
                $("#subProduct").remoteChained("#mainProduct", "<%=context%>/projectServlet?op=getModels");
               
            }); 
        </script>
    </body>
</html>
