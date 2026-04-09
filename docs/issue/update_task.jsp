<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String status = (String) request.getAttribute("status");

WebBusinessObject task = (WebBusinessObject) request.getAttribute("task");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String issueId = (String) request.getAttribute("issueId");
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new task</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        var count = 1;
    function submitForm(){   
        if (!checkCodeTask()){
            alert ("Enter Task Code");
        } else if (!checkDescEn()){
            alert ("Enter English Description");
        } else if (!checkDescAr()){
            alert ("Enter Arabic Description");
        } else {
            document.TASK_EDIT_FORM.action = "<%=context%>/IssueServlet?op=UpdateTask&issueId=<%=issueId%>&taskID=<%=task.getAttribute("taskID")%>";
            document.TASK_EDIT_FORM.submit();
        }
    }
    
    function checkCodeTask(){
        if(this.TASK_EDIT_FORM.codeTask.value != ""){
            var codeTasks = this.TASK_EDIT_FORM.codeTask;
            for(i = 0; i < codeTasks.length; i++){
                if(codeTasks[i].value == ""){
                    codeTasks[i].focus();
                    return false;
                }
            }
        } else if(this.TASK_EDIT_FORM.codeTask.value == ""){
            this.TASK_EDIT_FORM.codeTask.focus();
            return false;
        }
        return true;
    }
    
    function checkDescEn(){
        if(this.TASK_EDIT_FORM.descEn.value != ""){
            var descEns = this.TASK_EDIT_FORM.descEn;
            for(i = 0; i < descEns.length; i++){
                if(descEns[i].value == ""){
                    descEns[i].focus();
                    return false;
                }
            }
        } else if(this.TASK_EDIT_FORM.descEn.value == ""){
            this.TASK_EDIT_FORM.descEn.focus();
            return false;
        }
        return true;
    }
    
    function checkDescAr(){
        if(this.TASK_EDIT_FORM.descAr.value != ""){
            var descArs = this.TASK_EDIT_FORM.descAr;
            for(i = 0; i < descArs.length; i++){
                if(descArs[i].value == ""){
                    descArs[i].focus();
                    return false;
                }
            }
        } else if(this.TASK_EDIT_FORM.descAr.value == ""){
            this.TASK_EDIT_FORM.descAr.focus();
            return false;
        }
        return true;
    }
    
    function addNew(){
        count++;
        var x = document.getElementById('listTable').insertRow();
        var y = x.insertCell(0);
        var z1 = x.insertCell(1);
        var z2 = x.insertCell(2);
        var z3 = x.insertCell(3);
        var z4 = x.insertCell(4);
        
        //z.outerText = "class='tdForm'";
        y.borderWidth = "1px";
        z1.borderWidth = "1px";
        z2.borderWidth = "1px";
        z3.borderWidth = "1px";
        z4.borderWidth = "1px";
        y.innerHTML = "<FONT FACE='tahoma'><b>" + count + "</b></font>&nbsp;";
        z1.innerHTML = "<input type='text' name='rank' ID='rank'>";
        z2.innerHTML = "<input type='text' name='codeTask' ID='codeTask'>";
        z3.innerHTML = "<textarea name='descEn' ID='descEn' cols='30' rows='2'></textarea>";
        z4.innerHTML = "<textarea name='descAr' ID='descAr' cols='30' rows='2'></textarea>";
    }
    
    function IsNumeric(sText)
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;

 
        for (i = 0; i < sText.length && IsNumber == true; i++) 
        { 
            Char = sText.charAt(i); 
            if (ValidChars.indexOf(Char) == -1) 
            {
                IsNumber = false;
            }
        }
        return IsNumber;

    }
    </SCRIPT>
    <BODY>
        <left>
        <FORM NAME="TASK_EDIT_FORM" METHOD="POST">
            
            <TABLE ALIGN="RIGHT" DIR="RTL" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:right;">
                        &#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;
                    </TD>
                    
                    <TD STYLE="text-align:left" CLASS="tableright" colspan="3">
                        
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/IssueServlet?op=ListTasks&issueId=<%=issueId%>">
                            <%=tGuide.getMessage("backtolist")%>
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            &#1587;&#1580;&#1604; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579; 
                        </A>
                        
                    </TD>
                </TR>
            </TABLE>
            <br><br>
            <%    if(null!=status) {
            
            %>
            
            
            <table align="right"> 
                <tr><td  class="td" align=right> <b><font size=4 ><%=status%> : &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; <b></td>
                    <td class="td">
                        <IMG VALIGN="BOTTOM" HEIGHT="20"  SRC="images/aro.JPG">
                    </td>    
                </tr>
            </table>
            <br><br>
            <%
            }
            %>
            
            <TABLE ALIGN="RIGHT" DIR="RTL" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="text-align:right" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b>Task Code / &#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="text-align:right" class='td'>
                        <input type="TEXT" name="codeTask" ID="codeTask" size="33" value="<%=task.getAttribute("codeTask")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="text-align:right"  class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b>Description / &#1575;&#1604;&#1608;&#1589;&#1601;</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="text-align:right" class='td'>
                        <TEXTAREA rows="5" name="descEn" ID="descEn" cols="33"><%=task.getAttribute("descEn")%></TEXTAREA>
                    </TD>
                </TR>
                
                <TR>
                    
                    <TD class='td'>
                        <input type="hidden" name="descAr" ID="descAr" cols="33" value="<%=task.getAttribute("descAr")%>">
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
