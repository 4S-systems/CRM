<%@ page import="com.silkworm.business_objects.*,com.maintenance.db_access.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    TaskMgr taskMgr = TaskMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();

    ArrayList tasks = taskMgr.getCashedTableAsBusObjects();

    String context = metaMgr.getContext();

    //Get request data
    String issueId = (String) request.getAttribute("issueId");
    WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

    LaborComplaintsMgr lbMgr = LaborComplaintsMgr.getInstance();
    Vector issueComplaintsVec = lbMgr.getOnArbitraryKey(issueId, "key1");
    Enumeration e = issueComplaintsVec.elements();
    Vector complaintsVec = new Vector();
    int ind = 0;
    WebBusinessObject indWbo = new WebBusinessObject();
    while (e.hasMoreElements()) {
        WebBusinessObject wbo = (WebBusinessObject) e.nextElement();
        ind++;
        String index = "" + ind;
        wbo.setAttribute("index", index);
        complaintsVec.add(wbo);
        indWbo.setAttribute(wbo.getAttribute("id").toString(), index);

    }
    //data :"complaintId => 1328515635500" "taskId => 1302077911991" issueTasksArr "id => 1302077911991"
    //
    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");

    String issueNo = (String) request.getAttribute("jobNo");
    Vector data = (Vector) request.getAttribute("comp");
    String status = (String) request.getAttribute("status");
    Boolean isChecked = false;
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();

    Vector issueTaksVec = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
    ArrayList issueTasksArr = new ArrayList();
    WebBusinessObject taskWbo = new WebBusinessObject();

    for (int i = 0; i < issueTaksVec.size(); i++) {
        String taskCode = ((WebBusinessObject) issueTaksVec.get(i)).getAttribute("codeTask").toString();
        taskWbo = taskMgr.getOnSingleKey(taskCode);
        issueTasksArr.add(taskWbo);
    }


    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String cellAlign = null;
    String message = null;
    String lang, langCode, cancel, save, title, JOData, JONo, forEqp, task, complaint, entryTime, notes, add, delete, noComplaints, M, M2;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        cellAlign = "left";
        cancel = "Back";
        save = "Save";
        title = "Relate Complaint to tasks";
        JOData = "Job Order Data";
        JONo = "Job Order Number";
        forEqp = "Equipment Name";
        task = "Task Name";
        complaint = "Complaint";
        entryTime = "Entry date";
        notes = "Recommendations";
        add = "Select";
        delete = "Delete Selection";
        noComplaints = "No Complaint related to this job order";
        M = "Data Had Been Saved Successfully";
        M2 = "Saving Failed ";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cellAlign = "right";
        cancel = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        save = "تقرير الشكوي";
        title = "عرض وتحليل الشكوي";
        JOData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        JONo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        forEqp = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        task = "&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        complaint = "الشكوي";
        entryTime = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1588;&#1603;&#1608;&#1609;";
        notes = "&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
        add = "&#1575;&#1582;&#1578;&#1585;";
        delete = "&#1581;&#1584;&#1601; &#1575;&#1604;&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
        noComplaints = "لا يوجد شكاوي مرتبطه بأمر الشغل";
        M = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
        M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    }
%>

<script type="text/javascript">
    function submitForm()
    {
        //var counter=document.getElementById('counter');
        var countValue=checkBox();
        var countResult=parseInt (countValue);

        if(countResult == 0)
        {
            alert('Attach at least one maintenance item ');
        }

        else
        {
            document.COMPLAINT_FORM.action = "<%=context%>/AssignedIssueServlet?op=composeCmpl&issueId=<%=issueId%>&maintTitle=<%=issueWbo.getAttribute("issueType").toString()%>&jobNo=<%=issueNo%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.COMPLAINT_FORM.submit();
        }

    }
    
    function cancelForm(){    
        document.COMPLAINT_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.COMPLAINT_FORM.submit();  
    }
    
    function getcheck(i) {
        var task = document.getElementById("task");
        var taskName = task.options[task.selectedIndex].text;
        var taskId = task.options[task.selectedIndex].value;
        
        var tasksNamesArr = document.getElementsByName('taskName');
        var tasksIdsArr = document.getElementsByName('taskId');
       
        var check = document.getElementById("select"+i);
        var delCB = document.getElementById("del"+i);
       
        if(check.checked == true)
        {
           
            if(!checkTask(taskId))
            {
                check.checked = false;
                return;
            }
       
            tasksNamesArr[i].innerHTML = taskName;
            tasksIdsArr[i].value = taskId;

            delCB.checked = false;
            delCB.disabled = true;
        } else {
            check.checked = false;
           
            delCB.disabled = false;
        }
       
    }
   
    function delcheck(i) {
        var tasksNamesArr = document.getElementsByName('taskName');
        var tasksIdsArr = document.getElementsByName('taskId');
       
        var check = document.getElementById("del"+i);
        var selectCB = document.getElementById("select"+i);
       
        if(check.checked == true){
            tasksNamesArr[i].innerHTML = "---";
            tasksIdsArr[i].value = "---";

            selectCB.checked = false;
            selectCB.disabled = true;
        } else {
            check.checked = false;
           
            selectCB.disabled = false;
        }
    }
   
    function checkTask(taskId){
        var flag = true;
        var tasksIdsArr = document.getElementsByName('taskId');

        if(tasksIdsArr.length != 0){
            for(i=0; i<tasksIdsArr.length; i++)
            {
                
                if(tasksIdsArr[i].value == taskId )
                {
                    flag = false;
                    alert('This task was selected for another complaint');
                    return flag;
                }
            }
        }
       
        return flag;
    }

    function checkBox()
    {
        var count = 0;
        var nameValues=document.getElementsByName('taskId');

        for(i=0;i<nameValues.length;i++)
        {
            if(nameValues[i].value != "---")
            {
                count++;
                break;
            }
        }
        return count;

    }

    function deleteTask(issueiId){

        var url2 = "<%=context%>/AssignedIssueServlet?op=deleteTask&issueId="+issueiId;
    
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest( );
        }else if (window.ActiveXObject) {
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }
   
        req.open("post",url2,true);
        req.send(null);
    }

</script>
<script src='ChangeLang.js' type='text/javascript'></script>
<style type="text/css">
    .container {
        width: 820px;
        border: 3px outset #dfdfdf;
        padding: 1px;
        margin: auto;
    }
    .item_content {

        border: 1px dotted #6CC;
        margin-bottom: 3px;
    }
    .item_drop {
        height: 60px;
        width: 120px;
        overflow:auto;
        float: right;
        border: 1px solid #3C5983;
    }
    .item_drag{
        height: 40px;
        width: 45px;
        cursor:pointer;
        float: left;
        margin:1px;
        position:relative;
        background-image: url(images/complain-drag.png);
        background-repeat: no-repeat;
    }
    .item_drag:hover{
        background-image: url(images/complain.png);
    }
    .item_drag_drop{
        height: 40px;
        width: 45px;
        float: left;
        margin:1px;
        position:relative;
        background-image: url(images/complain.png);
        background-repeat: no-repeat;
    }
    .item_drag_drop1{
        height: 40px;
        width: 45px;
        float: left;
        margin:1px;
        position:relative;
        background-image: url(images/complain1.png);
        background-repeat: no-repeat;
    }
    .item_text {
        float: left;
        width: 265px;
        font-size: 14px;
        font-weight: bold;
        padding: 3px;
        border: 1px solid #3C5983;
    }
    .itemscontainer{
        float: left;
        width: 400px;
    }
    .complain_container {
        float: right;
        width: 350px;
        border: 1px solid #6CC;
    }
    .complain_details{
        font-size: 14px;
        font-weight: bold;        
        padding: 3px;
        padding-top:10px;   
    }
    .number{
        color:#069;
        position:absolute;
        float:right;
        font-size:25px;
        cursor:pointer;
        left: 0px;
        top: -3px;
    }
    .cancel{
        color:#069;
        position:absolute;
        float:right;
        left: 25px;
        top: 19px;	
        cursor:pointer;
        background-image: url(images/icon-16-delete.png);
        background-repeat: no-repeat;
        width: 18px;
        height: 17px;
    }
</style>

<script type="text/javascript" src="js/jquery-1.5.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.9.custom.min.js"></script>
<script type="text/javascript" src="js/comp_item.js"></script>
<script type="text/javascript">
    function submitOk(){
        //alert(ElementArray.length) "recomend => undefined";
        $("#main1").html("");
        $("#main").html("");
        var totalElement=totaleEl-1;
        if(totaleEl==0){
            $("#main1").html("<Font size=4 color=red><b>"+" تم التسجيل بنجاح "+"</b></Font");
            $("#main").html("<Font size=4 color=red><b>"+" تم التسجيل بنجاح "+"</b></Font");
            totaleEl=ElementArray.length;
            return;
        }
                       
        $.ajax({
            type:"post",
            url:"<%=context%>/AssignedIssueServlet",
            data:"op=combinComp&arr="+ElementArray.length+"&total="+totaleEl+"&issueId=<%=issueId%>&maintTitle=<%=issueWbo.getAttribute("issueType").toString()%>&jobNo=<%=issueNo%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&recommend="+ElementArray[totalElement][2]+"&taskId="+ElementArray[totalElement][0]+"&compId="+ElementArray[totalElement][1],
            success:function(msg){
                // $("#main").html("<br> تم التسجيل بنجاح ");						
                $("#"+ElementArray[totalElement][0]+' > div[id="'+ElementArray[totalElement][1]+'"]').attr("class","item_drag_drop1"); 
                //alert(ElementArray[totalElement][1]);
                //ElementArray.splice(totalElement,1);
                totaleEl--;
                setTimeout(function() { submitOk();
                },100);
                
            }
				
        });
			
    }
    //--------------------------------------

    function v(){
        alert(totaleEl);
  
    }
</script>
<script type="text/javascript" src="js/apprise-1.5.full.js"></script>
<link rel="stylesheet" href="css/apprise.css" type="text/css" />
<script>
    function tryit()
    {
    
        var string="<center><font size=5>"+"اضف تعليق"+"</font></center>";
        var args={'input':'No Recommendation', 'textOk':'موافق' ,'textCancel':'الغاء'};	
        apprise(string, args, function(r)
        {
            if(r) 
            { 
                if(typeof(r)=='string')
                {
                    //alert("herer ");
                    var h ='<div class="item_drag_drop" title="'+r+'" id="'+$('#dragid').val()+'">'+item+'<span id="'+$('#dragid').val()+'" onclick="remove(this)" class="cancel"></span></div>';
                    // $('#rot').append("<br>"+r); 
                    $("#"+$('#dropid').val()).append(h);
                    $("#"+$('#dropid').val()).parent().effect("highlight", {color: "#dfdfdf"}, 1000);
                    var element=new Array(3);
                    element[0]=$('#dropid').val();
                    element[1]=$('#dragid').val();
                    element[2]=r;					
                    addElement(element);
		
               }
                else
                { alert("there is error");}
            }
            else 
            {}
        });
    }
</script>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <BODY>

        <input name="dragid" type="hidden" id="dragid" value="" />
        <input name="dropid" type="hidden" id="dropid" value="" />
                <a href="<%=context%>/PDFReportsTreeServlet?op=itemComplainReport&issueId=<%=issueId%>&maintTitle=null&jobNo=<%=issueWbo.getAttribute("businessID").toString().concat("/").concat(issueWbo.getAttribute("businessIDbyDate").toString())%>&filterValue=null&filterName=null" >test</a>
        <FORM NAME="COMPLAINT_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="cancelForm();" class="button"><%=cancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <%if (data.size() > 0 && data != null) {%>
            <a  href="<%=context%>/PDFReportsTreeServlet?op=itemComplainReport&issueId=<%=issueId%>&maintTitle=null&jobNo=<%=issueWbo.getAttribute("businessID").toString().concat("/").concat(issueWbo.getAttribute("businessIDbyDate").toString())%>&filterValue=null&filterName=null" class="button" style="display:inline-block; height: 30px; width: 120px;margin: 0px;"  > <%=save%>  </a>

            <%}%>
            <br>

            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                <%=title%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                  <br>
            <a  href="<%=context%>/PDFReportsTreeServlet?op=itemComplainReport&issueId=<%=issueId%>&maintTitle=null&jobNo=<%=issueWbo.getAttribute("businessID").toString().concat("/").concat(issueWbo.getAttribute("businessIDbyDate").toString())%>&filterValue=null&filterName=null" class="button" style="display:inline-block; height: 30px; width: 120px;margin: 0px;"  > <%=save%>  </a>

                                <br>

                <%
                    if (null != status) {
                %>
                <%
                    if (status.equalsIgnoreCase("ok")) {
                        message = M;
                    } else {
                        message = M2;
                    }
                %>   
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="400">
                    <TR BGCOLOR="#FFE391">
                        <TD STYLE="text-align:center;font-size:16" class="td" >
                            <B><FONT color='red'><%=message%></FONT></B>
                        </TD>
                    </TR>
                </table>
                <%
                    }
                %>

                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="400">
                    <TR>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" COLSPAN="2">
                            <B><%=JOData%></B>                   
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                            <b><%=JONo%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                            <b><%=issueWbo.getAttribute("businessID").toString().concat("/").concat(issueWbo.getAttribute("businessIDbyDate").toString())%></b>                              
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                            <b><%=forEqp%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px;" WIDTH="200">
                            <b><%=issueWbo.getAttribute("issueType").toString()%></b>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                <br> <center> <button type="button"  onclick="submitOk()" class="button"> حــفظ  <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                </center> 
                <div class="container">
                    <div>
                        <div class="silver_header" style="text-align:center;width: 50%;float: left;font-size: 18px;padding: 0px;   ">بنود الصيانة</div>
                        <div class="silver_header" style="text-align:center;width: 50%;float: right;font-size: 18px;padding: 0px;    ">الشكوي</div>
                        <div style="clear:both"></div>
                    </div>
                    <br><div id="main1">&nbsp;</div><br>
                    <div style="clear:both">
                        <div class="itemscontainer">
                            <%
                                for (int i = 0; i < issueTasksArr.size(); i++) {
                                    WebBusinessObject taskwebo = (WebBusinessObject) issueTasksArr.get(i);
                            %>
                            <div class="item_content">
                                <div class="item_drop" id="<%=taskwebo.getAttribute("id").toString()%>">
                                    <%
                                        for (int j = 0; j < data.size(); j++) {
                                            WebBusinessObject wbo = (WebBusinessObject) data.elementAt(j);

                                            if (wbo.getAttribute("taskId").equals(taskwebo.getAttribute("id"))) {
                                                String indexString = (String) indWbo.getAttribute(wbo.getAttribute("complaintId"));


                                    %>
                                    <div class="item_drag_drop1" title="<%=wbo.getAttribute("recomend")%>" > <b class="number"><%=indexString%></b><span id="<%=wbo.getAttribute("complaintId")%>" onclick="remove(this);" class="cancel"></span>  </div>
                                    <script> 
                                        var eleme=new Array(2);
                                        eleme[0]='<%=taskwebo.getAttribute("id")%>';
                                        eleme[1]='<%=wbo.getAttribute("complaintId")%>';
                                        eleme[2]='<%=wbo.getAttribute("recomend")%>';
                                        addElement(eleme);</script>
                                        <% }
                              }%>
                                </div>
                                <div class="item_text"><%=taskwebo.getAttribute("taskTitle").toString()%></div>

                                <div style="clear:both"></div>
                            </div>
                            <%}%>

                            <div style="clear:both"></div>

                        </div>
                        <div class="complain_container">

                            <%
                                for (int i = 0; i < complaintsVec.size(); i++) {
                                    WebBusinessObject wbo = (WebBusinessObject) complaintsVec.elementAt(i);
                            %>
                            <div class="item_content">
                                <div class="item_drag" id="<%=wbo.getAttribute("id").toString()%>" index=""> <b class="number"><%=wbo.getAttribute("index").toString()%></b> </div>
                                <div class="complain_details"><%=wbo.getAttribute("delayReason").toString()%></div>
                                <div style="clear:both"></div>

                            </div>

                            <%}%>

                            <div style="clear:both"></div>
                        </div>
                        <div style="clear:both"></div><br><div id="main">&nbsp;</div><br>
                        <center> <button type="button"  onclick="submitOk()" class="button"> حــفظ  <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                        </center> <br><div style="clear:both"></div>
                    </div>
            </fieldset>
        </FORM>
    </BODY>
</HTML>
