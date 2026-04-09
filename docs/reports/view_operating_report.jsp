<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*,com.maintenance.db_access.EqChangesMgr,com.maintenance.servlets.*,java.text.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.*, com.tracker.db_access.*,com.maintenance.db_access.EquipmentStatusMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <%
    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    String context = metaDataMgr.getContext();
    String cMode= (String) request.getSession().getAttribute("currentMode");
    IssueMgr issueMgr = IssueMgr.getInstance();

    // get report pictures
    Hashtable logos=new Hashtable();
    logos=(Hashtable)session.getAttribute("logos");

    Vector allReading = (Vector) request.getAttribute("allReading");
    String unitName = (String) request.getAttribute("unitName");
    String beginDate = (String) request.getAttribute("beginDate");
    String endDate = (String) request.getAttribute("endDate");
    String typeRate = (String) request.getAttribute("typeRate");

    String  stat=cMode;
    String dir=null;
    String style=null,align;
    String listSchedules,issueNo,counter,date,lang,langCode,print,from,to,name,unit,noReading , pageTitle , pageTitleTip;

    if(stat.equals("En")){
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        dir="LTR";
        align = "left";
        style="text-align:left";
        listSchedules="View Reading Counter and Job order Generated for Machine ";
        issueNo = "Job Order number";
        counter = "Counter";
        date = "Date";
        print = "Print";
        from = "From";
        to = "To";
        name = "Name Equipment";
        noReading = "No. Reading";
        if(typeRate.equals("fixed"))
             unit = "Hours";
        else
             unit = "K.M";
           pageTitle="RPT-EQP-OPRTNG-12";
        pageTitleTip="View Operation Report";

    }else{
        lang="   English    ";
        langCode="En";
        dir="RTL";
        align = "right";
        style="text-align:Right";
        listSchedules="&#1593;&#1585;&#1590; &#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1593;&#1583;&#1575;&#1583;&nbsp; &#1608; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1578;&#1609; &#1578;&#1605; &#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580;&#1607;&#1575;&nbsp; ";
        date = "&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
        issueNo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        counter = "&#1575;&#1604;&#1593;&#1583;&#1575;&#1583;";
        print = "&#1575;&#1591;&#1576;&#1593;";
        name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        from="&#1605;&#1606;";
        to="&#1575;&#1604;&#1609;";
        noReading="&#1593;&#1583;&#1583; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1575;&#1578;";
        if(typeRate.equals("fixed"))
             unit = "&#1587;&#1575;&#1593;&#1577;";
        else
             unit = "&#1603;&#1610;&#1604;&#1608;&#1605;&#1578;&#1585;";

          pageTitle="RPT-EQP-OPRTNG-12";
        pageTitleTip="&#1593;&#1585;&#1590; &#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1578;&#1588;&#1594;&#1610;&#1604;";
    }
    String viewIssue = "AssignedIssueServlet?op=VIEWDETAILS&issueId=";
    %>

    <HEAD>
        <TITLE>Equipments List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/images.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
    </HEAD>
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function changeMode(name){
        if(document.getElementById(name).style.display == 'none'){
            document.getElementById(name).style.display = 'block';
        } else {
            document.getElementById(name).style.display = 'none';
        }
    }

    function printWindow(){
            document.getElementById('divDutton').style.display = "none";
            window.print();
            document.getElementById('divDutton').style.display = "block";
        }

        function openWindow(url,width,height)
        {
            //window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=" + width + ", height=" + height);
            window.showModalDialog(url, null, "dialogWidth:800px;dialogHeight:1000px;")
        }
</SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="equip_form" METHOD="POST">
                <div dir="LTR" id="divDutton">
                        <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                            &ensp;
                        <button  onclick="JavaScript: printWindow();" style="width:80px"><%=print%></button>


                </div>


                <table border="0" width="60%" id="table1" ALIGN="center" dir="<%=dir%>">
                    <tr>
                        <td align="center" colspan="4" style="border:0px">
                        <img border="0" src="images/<%=logos.get("headReport1").toString()%>" width="450" height="100"></td>
                    </tr>
                    <tr>
                        <td class="td" align="center" style="text-align:center">
                            <font color="blue" size="5"><%=listSchedules%></font>
                        </td>
                    </tr>
                </table>

                            <div dir="left">
                                  <table>
                                      <tr>
                                          <td>
                                              <font color="#FF385C" size="3">
                                           <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=pageTitleTip%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                                              </font>
                                          </td>
                                      </tr>
                                  </table>
                                  </div>
                <br>
                <TABLE align="CENTER" DIR= <%=dir%> CELLPADDING="0" cellspacing="0" STYLE="border:1px;" >
                    <TR>
                        <TD nowrap CLASS="head" STYLE="height:30px;font-size:16;font-weight:bold;color:black;padding-right:3px;padding-left:3px"><%=name%></TD>
                        <TD nowrap CLASS="firstname" STYLE="height:30px;font-size:16;font-weight:bold;color:black;border-top:1px solid;padding-right:3px;padding-left:3px"><%=unitName%></TD>
                    </TR>
                    <TR>
                        <TD nowrap CLASS="head" STYLE="height:30px;font-size:16;font-weight:bold;color:black;padding-right:3px;padding-left:3px"><%=from%></TD>
                        <TD nowrap CLASS="firstname" STYLE="height:30px;font-size:16;font-weight:bold;color:black;padding-right:3px;padding-left:3px"><%=beginDate%></TD>
                        <TD nowrap CLASS="head" STYLE="height:30px;font-size:16;font-weight:bold;color:black;padding-right:3px;padding-left:3px"><%=to%></TD>
                        <TD nowrap CLASS="firstname" WIDTH="150" STYLE="height:30px;font-size:16;font-weight:bold;color:black;;border-top:1px solid;padding-right:3px;padding-left:3px"><%=endDate%></TD>
                    </TR>
                </TABLE>
                <br>
                <TABLE align="CENTER" DIR= <%=dir%> WIDTH="75%" CELLPADDING="0" cellspacing="0" STYLE="border-right-WIDTH:1px;" >
                    <TR CLASS="head">
                        <TD nowrap CLASS="firstname" STYLE="height:30px;font-size:16;font-weight:bold;color:black"><%=counter%>&ensp;(<font color="red"> <%=unit%></font>)</TD>
                        <TD CLASS="firstname" nowrap STYLE="height:30px;font-size:16;font-weight:bold;color:black"><%=date%></TD>
                        <TD nowrap CLASS="firstname" STYLE="height:30px;font-size:16;font-weight:bold;color:black"><%=issueNo%></TD>
                    </TR>
                    <%
                    WebBusinessObject wbo,webIssue;
                    String numjob,url;
                    String sBID,sBIDByDate,entryTime,entryDate,issueId;
                    long timeStamp;
                    Date d;
                    int day,month,year;
                    for(int i = 0 ;i < allReading.size() ;i++){
                        wbo = (WebBusinessObject) allReading.get(i);
                        // get date as dd/mm/yyyy from time milesecond
                         entryTime = (String) wbo.getAttribute("entry_Time");
                         timeStamp = Long.valueOf(entryTime).longValue();
                         d = new Date(timeStamp);
                         year = d.getYear() + 1900;
                         month = d.getMonth() + 1;
                         day = d.getDate();

                         entryDate = day + "/" + month + "/" + year;

                         issueId = (String) wbo.getAttribute("issueId");
                    %>
                    <TR>
                        <TD nowrap CLASS="firstname" STYLE="height:25px;font-size:14;font-weight:bold;color:black"><%=wbo.getAttribute("current_Reading")%></TD>
                        <TD CLASS="firstname" nowrap STYLE="height:25px;font-size:14;font-weight:bold;color:black"><%=entryDate%></TD>
                        <TD nowrap CLASS="firstname" STYLE="height:25px;font-size:14;font-weight:bold;color:black">
                            <%
                            if(issueId != null){
                                 webIssue = issueMgr.getOnSingleKey(issueId);
                                 sBID = (String) webIssue.getAttribute("businessID");
                                 sBIDByDate = (String) webIssue.getAttribute("businessIDbyDate");
                                 numjob = sBID + "/" +sBIDByDate;
                                 url = "IssueServlet?op=printJobOrder&issueId=" + webIssue.getAttribute("id") +"&issueTitle=" +webIssue.getAttribute("issueTitle") + "&issueStatus=" + webIssue.getAttribute("currentStatus") + "&sID=" + numjob + "&back=no&unitName=No found Title";
                            %>
                            <a href="JavaScript:openWindow('<%=url%>','900','800');" >
                                <font size="2" color="red"><%=sBID%></font><font size="2">/<%=sBIDByDate%></font>
                            </a>
                            <%}else{%>
                                ------
                            <%}%>
                        </TD>
                    </TR>
                    <%}%>
                    <TR CLASS="head">
                        <TD nowrap CLASS="firstname" COLSPAN="2" STYLE="height:20px;font-size:16;font-weight:bold;color:black"><%=noReading%></TD>
                        <TD nowrap CLASS="firstname" STYLE="height:20px;font-size:16;font-weight:bold;color:black"><%=allReading.size()%></TD>
                    </TR>
                </TABLE>
        </FORM>
    </BODY><TD CLASS="bar" BGCOLOR="#808080" STYLE="text-align:center;padding-left:5;color:Black;font-size:16;">
</html>
