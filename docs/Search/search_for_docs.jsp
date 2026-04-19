<%@page import="org.w3c.dom.Document"%>
<%@page import="com.docviewer.db_access.DocTypeMgr"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();


    Hashtable logos = new Hashtable();
    logos = (Hashtable) session.getAttribute("logos");

//get session logged user and his trades
    WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
    Vector data = (Vector) request.getAttribute("data");

    Document doc = null;
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    Vector<WebBusinessObject> docTypes = docTypeMgr.getCashedTable();
//     Vector<WebBusinessObject> docTypes = (Vector) request.getAttribute("docTypes");
    String beDate = (String) request.getAttribute("beginDate");
    String enDate = (String) request.getAttribute("endDate");
    String msgStatus = (String) request.getAttribute("msgStatus");
    String msgType = (String) request.getAttribute("msgType");
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1);
    int a = cal.get(Calendar.YEAR);
    int b = (cal.get(Calendar.MONTH)) + 1;
    int d = cal.get(Calendar.DATE);
    String prev = a + "/" + b + "/" + d;
    String age = "";
    int diffDays = 0;
    int diffMonths = 0;
    int diffYears = 0;

    WebBusinessObject catWbo = new WebBusinessObject();
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = "Ar";
    String align = "center";
    String dir = null;
    String style = null, lang, langCode, cancel, title, beginDate, endDate, print;
    String complaintNo, customerName, complaintDate, complaint;
    String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, docType, type, viewAttach, compStatus, compSender, noResponse, ageComp;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        cancel = "Cancel";
        title = "Search For Docs";
        beginDate = "From Date";
        endDate = "To Date";
        print = "Print";
        complaintNo = "Document Title";
        customerName = "Project Name";
        complaintDate = "Document date";
        complaint = "Document Type";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        view = "View";
        complaintCode = "Description";
        type = "Type";
        compStatus = "Staus";
        compSender = "Sender";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "A.C(day)";
        viewAttach = "View Docs";
        docType = "Doc Type";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        title = "بحث عن مستند";

        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        complaintNo = "عنوان المستند ";
        customerName = "اسم المستند";
        complaintDate = "تاريخ المستند";
        complaint = "تصنيف المستند";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        complaintCode = "الوصف";
        type = "النوع";
        compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        compSender = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
        viewAttach = "مشاهدة المستند";
        docType = "نوع الملف";
    }

%>



<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
        <!--<script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>-->
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">

        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">     

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <!--<script type="text/javascript" src="jquery-easyui/jquery.easyui.min.js"></script>-->

        <script type="text/javascript">
               
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: "+d",
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            }); 
        </script>
    </head>


    <script type="text/javascript">
      
        $(document).ready(function() {
         
            $('#indextable').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true



            })
        });
        //          
    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
       
        function submitForm()
        {    
            var configItemType= document.getElementById("configItemType").value;    
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            document.COMP_FORM.action ="<%=context%>/SearchServlet?op=SearchForComplaints&beginDate="+beginDate+"&endDate="+endDate+"&configItemType="+configItemType;
            document.COMP_FORM.submit();  
        }
    
        function showSubMenu(obj){
       
            var checked=$("#indextable").find(':checkbox:checked');
            if($(checked).length>1){
                $("#completeRemove").css("display", "block");
                $("#completeMove").css("display", "block");
                $("#simpleRemove").css("display", "none");
                $("#simpleMove").css("display", "none");
            }else{
                $("#completeRemove").css("display", "none");
                $("#completeMove").css("display", "none");
                $("#simpleRemove").css("display", "block");
                $("#simpleMove").css("display", "block");
            }
        }
        function removeSelectedFile(obj){
            var checkedRow=$("#indextable").find(':checkbox:checked');
          
             
            var x = "";
            var docId;
            $(checkedRow).each(function(index, checkedItem) {
                //                productId = $(product).val();
                docId=$(checkedItem).parent().parent().find("#docId").val();
                x = x + docId + ",";
            });
           
            $.ajax({
                type: "post",
                url: "<%=context%>/UnitDocReaderServlet?op=DeleteSelectedAttachFile",
                data: {
                    selectedId: x
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(checkedRow).parent().parent().remove();
                    }else{alert("توجد مشكلة فى الحذف")}
                }
            });
                
                          
        }
        function removeFile(obj){

            var docId=$("#sendDocId").val( );
            $.ajax({
                type: "post",
                url: "<%=context%>/UnitDocReaderServlet?op=DeleteFileAjax",
                data: {
                    docId:docId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $("#active").remove();
                        $('#singleFile').window('close');
                   
                    }else{alert("توجد مشكلة فى الحذف")}
                }
            });
                
                          
        }
        
        function updateFileParent(obj){
        
            if($("#mainProjectName").val().length>0){
               
                $("#mainProjectName").css("background-color","");
                var docId=$("#sendDocId").val( );
                var mainProjectId=$("#mainProjectId").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitDocReaderServlet?op=updateFileParent",
                    data: {
                        docId:docId,
                        mainProjectId:mainProjectId
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {
                        
                       
                            alert("تم النقل");
                       
                            $('#moveFile').window('close');
                       
                       
                        }else{alert("توجد مشكلة فى الحذف")}
                    }
                });
            }else{
                $("#mainProjectName").css("background-color","red");
                window.open('<%=context%>/ProjectServlet?op=getAllProject', '_blank', 'status=1,scrollbars=1,width=400');
            }
            return false;             
        }
        function updateFileParent2(obj){
        
            if($("#mainProjectName2").val().length>0){
                $("#mainProjectName2").css("background-color","");
                var docId=$("#docsId").val( );
                var mainProjectId=$("#mainProjectId2").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitDocReaderServlet?op=updateSelectedAttachFile",
                    data: {
                        docId:docId,
                        mainProjectId:mainProjectId
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {
                       
                            alert("تم الحفظ");
                            $('#moveMultiFile').window('close');
                       
                       
                        }else{alert("توجد مشكلة فى الحذف")}
                    }
                });
            }else{
                $("#mainProjectName2").css("background-color","red");
                window.open('<%=context%>/ProjectServlet?op=getAllProject', '_blank', 'status=1,scrollbars=1,width=400');
            }
            return false;             
        }
        function closeAlert(obj){
  
            $(obj).parent().parent().window('close');
        }
        $(document).keyup(function(e) {
            //            if (e.keyCode == 13) { $('.save').click(); }     // enter
            if (e.keyCode == 27) {   $("#showImg").window('close')}   // esc
        });
        function getDocs() {
            var configItemType= document.getElementById("configItemType").value;
            var beginDate = $("#beginDate").val();
 
            var endDate = $("#endDate").val();
            if((beginDate=null||beginDate=="")){
                alert("من فضلك أدخل تاريخ البداية");
            }
            else if((endDate=null||endDate=="")){
                alert("من فضلك أدخل تاريخ النهاية");
           
            }else{
                beginDate = $("#beginDate").val();
                endDate = $("#endDate").val();
                document.COMP_FORM.action = "<%=context%>/SearchServlet?op=getDocs&beginDate="+beginDate +"&endDate="+endDate+"&configItemType="+configItemType
                document.COMP_FORM.submit();
                //                $("#username").val("");
            }
        }
    </script>
    <style type="text/css">
        #data tr,td{
            border: none;

        }

    </style>
    <body>
        <input type="hidden" value="" id="docsId"/>

        <!--        <h2>Menu Events</h2>
                <div class="demo-info">
                    <div class="demo-tip icon-tip"></div>
                    <div>Right click on page to display menu and click an item.</div>
                </div>
                <div style="margin:10px 0;"></div>-->
        <div style="display: none">
            <div id="mm" class="easyui-menu" data-options="onClick:menuHandler" style="width:120px;height: auto;">

                <div data-options="name:'save',iconCls:'icon-save'">مشاهدة</div>
                <div data-options="name:'removeFile',iconCls:'icon-cancel'" id="simpleRemove">
                    <span>حذف</span>
                </div>
                <div data-options="name:'remove',iconCls:'icon-cancel'" data-options="onClick:menuHandler" id="completeRemove" style="display: none;">
                    <span>حذف</span>
                    <div style="height: auto;">


                        <div data-options="name:'removeSelected',iconCls:'icon-save'" id="removeSelected">المحدد</div>
                        <!--<div data-options="name:'removeAllSelected'"id="removeAllSelected" >الكل</div>-->
                    </div>

                </div>
                <div data-options="name:'moveFile',iconCls:'icon-reload'" id="simpleMove">
                    <span>تحريك</span>
                </div>
                <div data-options="name:'move',iconCls:'icon-reload'" style="display: none;" id="completeMove">
                    <span>تحريك</span>
                    <div style="height: auto;">


                        <div data-options="name:'moveSelected',iconCls:'icon-save'" id="moveSelected"    >المحدد</div>
                        <!--<div data-options="name:'removeAllSelected'"id="removeAllSelected" >الكل</div>-->
                    </div>

                </div>

                <!--<div data-options="name:'new'">تفاصيل أكثر</div>-->
                <div data-options="name:'selectAll'">تحديد الكل</div>
                <div data-options="name:'unselect'" id="unselect" style="display: none;">إزالة التحديد</div>
                <!--<div class="menu-sep"></div>-->
                <!--<div data-options="name:'exit'">Exit</div>-->
            </div>




            <div id="w" class="easyui-window" title="حذف جميع الملفات " data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:300px;height:auto;padding:10px;text-align: right;">
                <p>   هل أنت متأكد من حذف جميع الملفات ؟</p>

                <div data-options="region:'south',border:false" style="text-align:left;padding:5px 0 0;">
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:closeAlert(this)">لا</a>
                    <a class="easyui-linkbutton" data-options="name:'removeOk',iconCls:'icon-ok'" href="javascript:void(0)" onclick="javascript:removeSelectedFile(this)">نعم</a>

                </div>
            </div>

            <div id="singleFile" class="easyui-window" title="حذف  ملف " data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:300px;height:auto;padding:10px;text-align: right;">
                <p>   هل أنت متأكد من حذف هذا الملف ؟</p>

                <div data-options="region:'south',border:false" style="text-align:left;padding:5px 0 0;">
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:closeAlert(this)">لا</a>
                    <a class="easyui-linkbutton" data-options="name:'removeOk',iconCls:'icon-ok'" href="javascript:void(0)" onclick="javascript:removeFile(this)">نعم</a>

                </div>
            </div>

            <div id="showImg" class="easyui-window" title="  " data-options="modal:true,closed:true,iconCls:''" style="width:600px;height:auto;padding:10px;text-align: center;">
                <div id="showDocName" style="text-align: center;margin-right: auto;margin-left: auto;overflow: hidden;width: 98%;font-size: 18px;color: red;background-color: #f1f1f1;padding: 5px 5px;"></div>
                <img id="img" style="width: 100%;height: 400px;overflow: hidden"/>
                <!--                <div data-options="region:'south',border:false" style="text-align:left;padding:5px 0 0;">
                                    <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:closeAlert(this)">لا</a>
                                    <a class="easyui-linkbutton" data-options="name:'removeOk',iconCls:'icon-ok'" href="javascript:void(0)" onclick="javascript:removeSelectedFile(this)">نعم</a>
                        
                                </div>-->
            </div>


            <!--<div id="singleFile" class="easyui-window" title="حذف  ملف " data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:300px;height:auto;padding:10px;text-align: right;">-->
            <div id="moveFile" class="easyui-window" data-options="modal:true,closed:true" title="نقل ملف" style="width:400px;height:auto;padding:10px;text-align: right;">
                <div style="padding:10px 0 10px 60px;">
                    <form id="ff" method="post" name="PROJECTS_FORM">
                        <table style="width:100%;border: none;margin-right: auto;margin-left: auto" dir="rtl" id="data">
                            <tr >
                                <td >اسم المستند:</td>
                                <td style="text-align: right;" ><input class="easyui-validatebox" type="text" name="name" id="fileName"></input></td>
                            </tr>
                            <tr>
                                <td>الفئة:</td>
                                <td style="text-align: right;" >

                                    <input  id="fileCategory" class="easyui-tooltip" title="" 
                                            type="text" name="email" ></input></td>
                            </tr>
                            <tr>
                                <td >تاريخ الحفظ:</td>
                                <td style="text-align: right;" ><input id="fileDate" class="easyui-validatebox" type="text" name="subject" ></input></td>
                            </tr>
                            <tr>
                                <td>نوع المستند</td>
                                <td style="text-align: right;" ><input  id="fileType" class="easyui-validatebox" type="text" name="subject" ></input></td>
                            </tr>

                            <tr>
                                <td>مكان التحويل :</td>
                                <td style="text-align: right;">
                                    <input type="hidden" id="mainProjectId" name="alterMainProjectId" value=""/>
                                    <input readonly type="text" id="mainProjectName" class="easyui-tooltip" title=""  name="alterMainProjectName" value="" onmousedown="window.open('<%=context%>/ProjectServlet?op=getAllProject', '_blank', 'status=1,scrollbars=1,width=400')"/>
                                    <input type="button" onclick="window.open('<%=context%>/ProjectServlet?op=getAllProject', '_blank', 'status=1,scrollbars=1,width=400')" id="getParent" value="بحث" /></td>
                            </tr>
                        </table>
                    </form>
                </div>
                <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0 0;">
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:closeAlert(this)">إلغاء</a>
                    <a class="easyui-linkbutton" data-options="name:'removeOk',iconCls:'icon-ok'" href="javascript:void(0)" onclick="javascript:updateFileParent(this)">حفظ</a>

                </div>
            </div>


            <div id="moveMultiFile" class="easyui-window" data-options="modal:true,closed:true" title="نقل الملفات" style="width:600px;height:auto;padding:10px;text-align: right;">
                <form id="ff" method="post" name="MOVE_MULTI_FILE">
                    <div style="padding:10px 0 10px 60px;">

                        <table style="width:100%;border: none;margin-right: auto;margin-left: auto" dir="rtl" id="moveData">


                            <thead>
                                <tr class="">
                                    <td >اسم المستند</td>
                                    <td>الفئة</td>
                                    <td >تاريخ الحفظ</td>
                                    <td>نوع المستند</td>

                                </tr>
                            </thead>

                            <tbody>

                            </tbody>
                        </table>


                    </div>
                    <div style="float: right;width: 100%;margin-bottom: 20px;">
                        <input type="hidden" id="mainProjectId2" name="alterMainProjectId" value=""/>
                        <input type="button" onclick="window.open('<%=context%>/ProjectServlet?op=getAllProject', '_blank', 'status=1,scrollbars=1,width=400')" id="getParent" value="بحث" />
                        <input readonly type="text" style="text-align: right;" id="mainProjectName2" class="easyui-tooltip" title=""  name="alterMainProjectName" value="" onmousedown="window.open('<%=context%>/ProjectServlet?op=getAllProject', '_blank', 'status=1,scrollbars=1,width=400')"/>

                        <b>  مكان التحويل</b>
                    </div>
                </form>
                <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0 0;margin-top: 8px;">
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:closeAlert(this)">إلغاء</a>
                    <a class="easyui-linkbutton" data-options="name:'removeOk',iconCls:'icon-ok'" href="javascript:void(0)" onclick="javascript:updateFileParent2(this)">حفظ</a>

                </div>
            </div>
            <!--</div>-->






        </div>

        <FORM NAME="COMP_FORM" METHOD="POST">

            <table align="center" width="80%">
                <tr><td class="td">
                        <fieldset >
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%>

                                            </font>

                                        </td>
                                    </tr>
                                </table>
                            </legend>
                            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                                <TR>

                                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </TD>
                                    <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </TD>
                                </TR>
                                <TR>

                                    <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                            String url = request.getRequestURL().toString();
                                            String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <% if (enDate != null && !enDate.isEmpty()) {%>

                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </TD>

                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (enDate != null && !enDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=enDate%>" ><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>

                                </TR>
                                <tr></tr><tr></tr><tr></tr>
                                <tr>
                                    <td>
                                        <label style="font-size: 16px;color:blue;" >نوع الملف</label>
                                        <select style="font-size: 14px;font-weight: bold;" id="configItemType">
                                            <option value="all">الكل</option>
                                            <%for (WebBusinessObject Wbo : docTypes) {
                                                    String typeName = (String) Wbo.getAttribute("typeName");
                                                    String typeId = (String) Wbo.getAttribute("typeID");%>

                                            <option value='<%=typeId%>'><b><%=typeName%></b></option>
                                            <%}%>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                <br><br>
                                <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                                    <button  onclick="JavaScript: getDocs();"   STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  

                                </TD>
                                </tr>
                            </table>

                        </fieldset>

                </tr></td ></table>
        </FORM>

        <% if (data != null && !data.isEmpty()) {%>                              
        <% if (msgType != null && !msgType.isEmpty() && msgStatus != null && !msgStatus.isEmpty()) {%>                                
        <div style="float: right;width: 100%;text-align: right;"> <font style="font-family: serif,arial;font-size: 20px;color:#FF6600;"><b><%=msgType%> <%=msgStatus%></b></font>  
        </div>
        <div style="float: right;margin-bottom: 5PX;">
            <hr style="width:18em;" align="right"/>
        </div>
        <% }%>
        <table id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" class="   ">
            <thead>
                <TR>
                    <TH ><SPAN ></SPAN></TH>
                    <TH ><SPAN ><b> <%=complaintNo%></b></SPAN></TH>
                    <TH ><SPAN><b> <%=customerName%></b></SPAN></TH>
                    <TH  ><SPAN><b><%=complaintDate%></b></SPAN></TH>
                    <TH  ><SPAN><b> <%=complaint%></b></SPAN></TH>
                    <TH  ><SPAN><b> <%=docType%></b></SPAN></TH>
                    <TH  ><SPAN><b> <%=complaintCode%></b></SPAN></TH>
                    <!--<TH  ><SPAN><b><%=viewAttach%></b></SPAN></TH>-->

                </TR>
            </thead> 
            <tbody  >  
                <%

                    Enumeration e = data.elements();

                    WebBusinessObject wbo = new WebBusinessObject();
                    while (e.hasMoreElements()) {

                        wbo = (WebBusinessObject) e.nextElement();
                        WebBusinessObject doc_type = null;
                        docTypeMgr = DocTypeMgr.getInstance();
                        doc_type = docTypeMgr.getOnSingleKey(wbo.getAttribute("configItemType").toString());
                %>
                <tr onmouseover="$(this).css('background-color', '')" onmouseout="$(this).css('background-color', '')">
                    <TD>
                        <INPUT type="checkbox" id="check"  onchange="showSubMenu(this)"/>
                    </TD>
                    <TD >

                        <%if (wbo.getAttribute("docTitle") != null) {%>
                        <b id="docTitle"><%=wbo.getAttribute("docTitle")%></b>
                        <%}
                        %>

                    </TD>


                    <TD >

                        <%if (wbo.getAttribute("unitName") != null) {%>
                        <b id="unitName"><%=wbo.getAttribute("unitName")%></b>
                        <%}%>

                    </TD>

                    <TD >

                        <%if (wbo.getAttribute("docDate") != null) {%>
                        <b id="docDate"><%=wbo.getAttribute("docDate")%></b>
                        <%}%>

                    </TD>

                    <TD >

                        <%if (doc_type.getAttribute("typeName") != null) {%>
                        <b id="typeName"><%=doc_type.getAttribute("typeName")%></b>
                        <%}%>

                    </TD>

                    <TD >

                        <%if (wbo.getAttribute("docType") != null) {
                        %>
                        <b><%=wbo.getAttribute("docType")%></b>
                        <%}%>

                    </TD>

                    <TD >

                        <%if (wbo.getAttribute("description") != null) {
                                String comment = (String) wbo.getAttribute("description");
                        %>
                        <b><%=comment%></b>
                        <%}%>

                    </TD>

<!--                    <TD >
                        <DIV ID="links">
                            <A HREF="<%=context%>/UnitDocReaderServlet?op=ListDoc&equipmentID=<%=wbo.getAttribute("unitId")%>&type=project&docType=<%=wbo.getAttribute("configItemType")%>&docId=<%=wbo.getAttribute("docId")%>">
                                <%=viewAttach%>
                            </A>
                        </DIV>
                    </TD>-->
            <input type="hidden" id ="equipmentID" value="<%=wbo.getAttribute("unitId")%>" />
            <input type="hidden" id ="docType" value="<%=wbo.getAttribute("configItemType")%>" />
            <input type="hidden" id ="docId" value="<%=wbo.getAttribute("docId")%>" />
            <input type="hidden" id ="metaType" value="<%=wbo.getAttribute("docType")%>" />
            <input type="hidden" id ="documentName" value="<%=wbo.getAttribute("docTitle")%>" />

        </tr>
        <%

                }
            }
        %>
        <!--
                    <div  style="float: right;width: 100%;text-align: center;margin-bottom: 0px;"> <font style="font-family: serif,arial;font-size: 20px;color:#FF3333;"><b>لا توجد نتائج للبحث</b></font>  
                    </div>
                    <div style="text-align: center;margin-bottom: 5PX;margin-top: 0px;">
                        <hr style="width:16em;margin: 0px;" align="center"/>
                    </div>
        -->
    </tbody>

</table>
<input type="hidden" id ="sendEquipmentID" value="" />
<input type="hidden" id ="sendDocType" value="" />
<input type="hidden" id ="sendDocId" value="" />
<input type="hidden" id ="sendMetaType" value="" />
<input type="hidden" id ="sendDocumentName" value="" />
<script type="text/javascript">
   
    
    function menuHandler(item){

        if(item.name=="new"){
            var sendEquipmentID=$("#sendEquipmentID").val( );
            var sendDocType=$("#sendDocType").val( );
            var sendDocId=$("#sendDocId").val( );
            var sendMetaType=$("#sendMetaType").val( );
            var url="<%=context%>/UnitDocReaderServlet?op=DocDetails&docID="+sendDocId+"&metaType="+sendMetaType+"&equipmentID="+sendEquipmentID+"&docType="+sendDocType;
            window.open(url, "strWindowName", "strWindowFeatures");
        }
        if(item.name=="save"){
            var sendEquipmentID=$("#sendEquipmentID").val( );
            var sendDocType=$("#sendDocType").val( );
           
            var sendDocId=$("#sendDocId").val( );
            var sendMetaType=$("#sendMetaType").val( );
            // 
            var documentName=$("#sendDocumentName").val();
       
            if(sendMetaType=="jpg"){
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitDocReaderServlet?op=viewDocuments",
                    data: {
                        docID:sendDocId,
                        metaType:sendMetaType,
                        equipmentID:sendEquipmentID,
                        docType:sendMetaType
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {
                           
                            $("#img").attr("src",info.imagePath);
                            $("#showDocName").text(documentName)
                            $('#showImg').prop("title",documentName);
                            $('#showImg').window('open');
                        }
                    }
                });
            
            }else{
            
                var url="<%=context%>/UnitDocReaderServlet?op=viewDocuments&docID="+sendDocId+"&metaType="+sendMetaType+"&equipmentID="+sendEquipmentID+"&docType="+sendMetaType+"&docName="+documentName;
                window.open(url, "strWindowName", "strWindowFeatures");
            }
                     
           
        }
        //        if(item.name=="print"){
        //            var sendEquipmentID=$("#sendEquipmentID").val( );
        //            var sendDocType=$("#sendDocType").val( );
        //           
        //            var sendDocId=$("#sendDocId").val( );
        //            var sendMetaType=$("#sendMetaType").val( );
        //            var url="<%=context%>/UnitDocReaderServlet?op=ConfirmDelete&docID="+sendDocId+"&metaType="+sendMetaType+"&equipmentID="+sendEquipmentID+"&docType=jpg";
        //            
        //                     
        //            window.open(url, "strWindowName", "strWindowFeatures");
        //        }
        if(item.name=="selectAll"){

            $("#indextable tr #check").prop("checked", true);
            if($("#indextable tr #check").prop("checked")== true){
                $("#unselect").css("display","block");
            }
            
            var checked=$("#indextable").find(':checkbox:checked');
            if($(checked).length>1){
                $("#completeRemove").css("display", "block");
                $("#completeMove").css("display", "block");
                $("#simpleRemove").css("display", "none");
                $("#simpleMove").css("display", "none");
            }else{
                $("#completeRemove").css("display", "none");
                $("#completeMove").css("display", "none");
                $("#simpleRemove").css("display", "block");
                $("#simpleMove").css("display", "block");
            }
            

            
            //             if ($("#indextable tr #check").is(':checked')) {
            //            $("#indextable input[type=checkbox]").each(function () {
            //                $(this).attr("checked", true);
            //            });

           
     
        }
        if(item.name=="unselect"){
                            
            $("#indextable tr #check").prop("checked", false);
            if($("#indextable tr #check").prop("checked")==false){
                $("#unselect").css("display","none");
                $("#completeRemove").css("display", "none");
                $("#completeMove").css("display", "none");
                $("#simpleRemove").css("display", "block");
                $("#simpleMove").css("display", "block");
            }                     
        }
        if(item.name=="removeSelected"){

            $('#w').window('open');}
        if(item.name=="moveSelected"){

            $("#mainProjectName2").val("");
            var checkedRow=$("#indextable").find(':checkbox:checked');
          
             
            var x = "";
            var docId;
            var fileName;
            var fileCategory;
            var date;
            var type;
            $("#moveData tbody").html("");
            $(checkedRow).each(function(index, checkedItem) {
                //                productId = $(product).val();
                docId=$(checkedItem).parent().parent().find("#docId").val();
                fileName=$(checkedItem).parent().parent().find("#docTitle").text();
                fileCategory=$(checkedItem).parent().parent().find("#unitName").text();
                date=$(checkedItem).parent().parent().find("#docDate").text();
                type=$(checkedItem).parent().parent().find("#typeName").text();
                x = x + docId + ",";
                
                $("#moveData tbody").append("<tr>\n\
        <td >"+fileName+"</td>\n\
<td>"+fileCategory+"</td>\n\
<td>"+date+"</td>\n\
<td>"+type+"</td>\n\
<td><input class='easyui-validatebox' type='hidden' name='name' id='docId' value="+docId+" /></td>\n\
</tr>");
            });
            $("#docsId").val(x);
            $('#moveMultiFile').window('open');
        }
        if(item.name=="removeFile"){

            $('#singleFile').window('open');
        }
        if(item.name=="moveFile"){
           
            $('#moveFile').window('open');
            $("#mainProjectName").val("");
        }
  
        if(item.name=="removeAllSelected"){
            $("#indextable tr #check").prop("checked", true);
            $('#w').window('open');
           
        
        }
       
    }
    $(function(){
   
    
    
        $("#indextable tr").bind('contextmenu',function(e){
            e.preventDefault();
           
            $("#sendEquipmentID").val( $(this).find("#equipmentID").val());
            $("#sendDocType").val( $(this).find("#docType").val());
            $("#sendDocId").val( $(this).find("#docId").val());
            $("#sendMetaType").val( $(this).find("#metaType").val());
            $("#sendDocumentName").val( $(this).find("#documentName").val());
            $("#fileName").val($(this).find("#docTitle").text());
            $("#fileCategory").val($(this).find("#unitName").text());
            $("#fileCategory").attr("title",$(this).find("#unitName").text());
  
            $("#fileDate").val($(this).find("#docDate").text());
            $("#fileType").val($(this).find("#typeName").text());
            $(this).attr("id", "active");
            
            
            $('#mm').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
            $(this).css("background-color","#005599");
        });
    });
</script>
</BODY>
</HTML>     
