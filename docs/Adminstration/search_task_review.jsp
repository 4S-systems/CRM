<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String listType=(String)request.getAttribute("listType");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy-MM-dd hh:mm:ss";//loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    String saving_status;
    String title_1;
    String cancel_button_label;
    String save_button_label;
    
    String search,toolName,searchTitleName,searchTitleCode,searchLableName,searchLableCode,toolCode,delete,notes,searchByName,searchByCode,dateFrom,dateTo;
    
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        title_1="Maintenance Items Search";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        search="Auto search";
        searchLableName="Search to Review";
        searchLableCode="Write Maintenance Item Code or SubCode";
        searchTitleName="Seach About Maintenance Item By Name";
        searchTitleCode="Seach About Maintenance Item By Code";
        
        searchByName="Saerch By Item Name";
        searchByCode="Search By Item Code";        
        dateFrom=" From ";
        dateTo=" To ";
        
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        title_1="&#1576;&#1581;&#1579; &#1593;&#1606; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604;";
        langCode="En";
        
        search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
        searchLableName="بحث للمراجعة";
        searchLableCode="&#1571;&#1603;&#1578;&#1576; &#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583; &#1571;&#1608; &#1580;&#1586;&#1569; &#1605;&#1606;&#1607; ";
        
        searchTitleName="&#1576;&#1581;&#1579; &#1593;&#1606; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
        searchTitleCode="&#1576;&#1581;&#1579; &#1593;&#1606; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; &#1576;&#1575;&#1604;&#1603;&#1608;&#1583;";
        
        searchByName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
        searchByCode="&#1576;&#1581;&#1579; &#1576;&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
             
        dateFrom=" من ";
        dateTo=" الى ";
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Search About Task</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css\headers.css">        
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">
       
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            
     function cancelForm()
        {    
        document.SEARCH_FORM.action = "main.jsp";
        document.SEARCH_FORM.submit();  
        }
            
    var count = 0;

    function Delete() {
    
        var tbl = document.getElementById('listTable');
        var check=document.getElementsByName('check');
        
        count=document.getElementById('nRows').value;
        
        for(var i=0;i<count;i++){
            if(check[i].checked==true){
                
                tbl.deleteRow(i+1);
                i--;
                count--;
                
                document.getElementById('nRows').value=count;
                
            }   
        }
    }
    
    function checkNotes(){
        var notesArr = document.getElementsByName('notes');
        
        for(i=0; i<notesArr.length; i++){
            if(notesArr[i].value =="" || notesArr[i].value =="null")
                notesArr[i].value = "No Notes";
        }
    }
    </SCRIPT>
        
    </HEAD>
    
    <script>

       <%--------------Popup window-------------------%> 
        function openWindowTasks(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=500");
            }
            
        function getTasks()
            {
                var formName = document.getElementById('SEARCH_FORM').getAttribute("name");
                

                
                
                 var listType='<%=listType%>';
                
                if(listType=="details"){
                    document.SEARCH_FORM.action="TaskServlet?op=searchTaskBySub&searchType=name&taskName="+'&formName='+formName;
                    document.SEARCH_FORM.submit();
                } else if(listType == "notPopup"){
                    document.SEARCH_FORM.action="TaskServlet?op=getSearchTaskNotPopup&searchType=name&taskName="+res+'&formName='+formName;
                    document.SEARCH_FORM.submit();
                } else{
                    document.SEARCH_FORM.action = "<%=context%>/TaskServlet?op=searchTaskResult&searchType=name&taskName="+res+"&formName="+formName;
                    document.SEARCH_FORM.submit();
                    //openWindowTasks('TaskServlet?op=searchTaskResult&searchType=name&taskName='+res+'&formName='+formName);
                }
            }
             function AllTasks()
            {
                //var formName = document.getElementById('SEARCH_FORM').getAttribute("name");
                    document.SEARCH_FORM.action="TaskServlet?op=getTaskByDate&searchType=name&Tasks=All"+'&formName=';
                    document.SEARCH_FORM.submit();
                
            }
            
        function getTasksByCode()
            {
                var formName = document.getElementById('SEARCH_FORM').getAttribute("name");
                var name = document.getElementById('taskCode').value
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                 var listType='<%=listType%>';
                 
                 if(listType=="details"){                 
                    document.SEARCH_FORM.action="TaskServlet?op=searchTaskBySub&searchType=code&taskCode="+res+'&formName='+formName;
                    document.SEARCH_FORM.submit();
                    
                }else{
                    document.SEARCH_FORM.action = "<%=context%>/TaskServlet?op=searchTaskResult&searchType=code&taskCode="+res+"&formName="+formName;
                    document.SEARCH_FORM.submit();
                    //openWindowTasks('TaskServlet?op=searchTaskResult&searchType=code&taskCode='+res+'&formName='+formName);
                }
            }
        <%---------------------------------%> 
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                  document.getElementById(name).style.display = 'block';
            } else {
                   document.getElementById(name).style.display = 'none';
            }
        }
        
    </script>
     <%---------------------------------%> 
     <script type="text/javascript">
            
            $(function() {
                $( "#from, #to" ).datetimepicker({
                    maxDate    : "+d",
                    changeMonth: true,
                    changeYear : true,
                    timeFormat:'hh:mm:ss',                   
                    dateFormat : 'yy-mm-dd'

                });
               

            });
        </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="SEARCH_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <table align="<%=align%>" border="0" width="80%">
                <tr>
                    <td width="50%" STYLE="border:0px;">
                        <div STYLE="width:80%;border:2px solid gray;color:white;" class="header" align="<%=align%>">
                            <div ONCLICK="JavaScript: changeMode('menu1');" class="header" STYLE="width:100%;color:white;cursor:hand;font-size:16;">
                                <b>
                                    <%=searchTitleName%>
                                </b>
                                <img src="images/arrow_down.gif">
                            </div>
                            <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:block;text-align:right;border-top:2px solid gray;" ID="menu1">
                                <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                    <tr>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                            <B><%=dateFrom%></b>
                                            <input readonly dir="ltr" id="from" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%; direction: ltr;" />
                                         
                                                   
                                        </td>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                            <B><%=dateTo%></b>
                                          
                                          <input readonly id="to" name="endDate" type="text" value="<%=nowTime%>" style="width:90%;direction: ltr;" />
                                                                          </td>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                           
                                        </td>                               </td>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                            <button onclick="JavaScript:AllTasks();" style="width:120"> <%=searchLableName%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            <br>
            
          
        </FORM>
    </BODY>
</HTML>     
