
<%@ page import="com.silkworm.business_objects.*,com.maintenance.db_access.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%>

<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

//Get request data
String issueId = (String)request.getAttribute("issueId");


 Vector DepComp = (Vector)request.getAttribute("DepComp");


String stat= (String)request.getSession().getAttribute("currentMode");
String align = null;
String dir = null;
String style = null;
String cellAlign = null;
String message = null;
String lang, langCode,addCmp;

if(stat.equals("En")){
    align = "center";
    dir = "LTR";
    style = "text-align:left";
    lang = "English";
    langCode = "Ar";
    cellAlign = "left";
    addCmp="Add Complaint";
    }else{
    align = "center";
    dir = "RTL";
    style = "text-align:Right";
    lang = "   &#1593;&#1585;&#1576;&#1610;  ";
    langCode = "En";
    cellAlign = "right";
    addCmp="&#1575;&#1590;&#1575;&#1601;&#1577; &#1588;&#1603;&#1608;&#1610; ";

}
%>

<script type="text/javascript">
     function addCmp(){
    var userId =  document.getElementById("DepCmp").value;
    var comment  =  document.getElementById("claim_content").value;
    var url2 = "<%=context%>/IssueServlet?op=saveCmpl&userId="+userId+"&comment="+comment;
    if (window.XMLHttpRequest) {
       req = new XMLHttpRequest( );
    }else if (window.ActiveXObject) {
       req = new ActiveXObject("Microsoft.XMLHTTP");
    }
   req.open("post",url2,true);
   req.send(null);
 }

   function addRow() {

            var table = document.getElementById("cmp");
            var rowCount = table.rows.length;
            var row = table.insertRow(rowCount);

            var cell1 = row.insertCell(0);
            var element1 = document.createElement("input");
            element1.type = "text";
            element1.id="claim_content";
            element1.name="claim_content";
            cell1.appendChild(element1);

            var cell2 = row.insertCell(1);
            var cmp = document.getElementById("DepCmp");
            var cmps = cmp.cloneNode(true);
            cell2.appendChild(cmps);

            var cell3 = row.insertCell(2);
            var element3 = document.createElement("input");
            element3.type = "checkbox";
            element3.name = "add_claim";
            cell3.appendChild(element3);
            element3.onchange=addCmp;

          


        }

</script>
<html>
    <head>
    </head>
    <body>
  <FORM NAME="CLIENT_COMPLAINT_FORM" METHOD="POST">
         <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">

        </DIV>
              <fieldset align=center class="set">
            <legend align="center">

                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>

                        <td class="td">
                            <font color="blue" size="6">الشكاوي
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br>

               <input type="button"  value="<%=addCmp%>"  onclick="addRow()" class="button">

                <TABLE  id ="cmp" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="500" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                  <TR>
                 <TD CLASS="header"  bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                        <B>الشكوى</B>
                    </TD>
                        <TD CLASS="header"  bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                        <B>الإدارة المختصة</B>
                    </TD>
                <TD CLASS="header"  bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                        <B>حفظ</B>
                    </TD>
               </TR>
                
            </TABLE>

                <div style="display: none">
                 <select name="DepCmp" ID="DepCmp" STYLE="width:230px">
            <%
           if(DepComp!=null){
            for(int i = 0; i < DepComp.size(); i++){
                WebBusinessObject wbo = (WebBusinessObject) DepComp.get(i);
            %>
            <option value="<%=(String) wbo.getAttribute("optionOne")%>"
                    >
            <%=(String) wbo.getAttribute("projectName")%>
                <%
                }}
                %>
            </select>
                </div>
  </fieldset>
  </FORM>
    </body>
</html>
