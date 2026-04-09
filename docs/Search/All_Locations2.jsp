<%@page import="com.maintenance.db_access.TradeMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page  pageEncoding="UTF-8" %>
<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    Vector<WebBusinessObject> trades = new Vector();
    trades = tradeMgr.getOnArbitraryKey("0", "key3");
    /**
     * ****** Get Request data *******
     */
    String mainLocation = (String) request.getAttribute("mainLocation");
    if (mainLocation == null) {
        mainLocation = "";
    }

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList getallLocation = projectMgr.getAllAsArrayList();
    /**
     * ****** End Of Get Request data *******
     */
    WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

    // get current date


    String context = metaMgr.getContext();

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, save, Basic_Data, back, mainCategoryTypeStr;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";

        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        save = "Save";
        mainCategoryTypeStr = "Select Main Site";
        Basic_Data = "New Equipment - <font color=#F3D596>Basic Data</font>";
        back = "Cancel";

    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        mainCategoryTypeStr = "إختار الموقع الرئيسى";
        save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
        Basic_Data = "&#1605;&#1593;&#1583;&#1577; &#1580;&#1583;&#1610;&#1583;&#1577; - <font color=#F3D596>&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577;</font>";
        back = tGuide.getMessage("cancel");

    }
%>




<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>عرض المناطق</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css">
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css">
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>
        <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/jquery-1.5.min.js"></script>
        <script type="text/javascript">
            function sendInfo(Name ,Id){
                var row;
                var insertedTable = window.opener.document.getElementById('tblData');
                var check = document.getElementsByName('relatedEmpsIds');
                var length = check.length;
                var commentsArr = document.getElementsByName('comments');
                          
                var lastrow = insertedTable.rows.length;
                var checkex = 0;                
                var count = 0;
                var insertCount = 0;
                ++insertCount;
                row = insertedTable.insertRow(insertCount);   
                insert_Cells(row, lastrow, count + lastrow,Name, Id, "");
                count++; 

                if(count > 0){
             
                    this.close();
                }else{
 
                }
            }
            function insert_Cells(row, order,index,fullName,areaId,  comments){
        
                var classname="silver_odd_main";
                if(index%2==0)
                    classname="silver_even_main";
           
                var cell0 = row.insertCell(0);
                var cell1 = row.insertCell(1);                           
                var cell2 = row.insertCell(2);                            
                var cell3 = row.insertCell(3);
                var cell4 = row.insertCell(4);
                var cell5 = row.insertCell(5);
                var cell6 = row.insertCell(6);
//                var cell7 = row.insertCell(7);
                cell0.className = classname;
                cell0.innerHTML = '<input type="hidden" name="areaId" id="areaId"  value="'+areaId+'" /><span id="order" name="order" value="'+index+'">' +index+ "</span><input type=\"hidden\" name=\"empTwo\" value="+ areaId +" />";
               
                
                cell1.className =classname;
                cell1.innerHTML ="<select id='trades'>"+document.getElementById("trades").innerHTML
                     
                    +"</select>";
                
                cell2.className = classname;
                cell2.innerHTML = fullName+
                    '<input type="hidden" name="userName" id="userName" value="'+fullName+'" />';
                
                cell3.className = classname;
                cell3.innerHTML = '<textarea type="text" name="notes" id="notes"  value="" ></textarea>';
                
                cell4.className = classname;
                cell4.innerHTML = '<input readonly="true" style="font-size:10px;" type="text" name="begin_date" id="begin_date"value="" onclick="beginDate(this)" onmousedown="beginDate(this)"/>';
                
                cell5.className = classname;
                cell5.innerHTML = '<input readonly="true" style="font-size:10px;" type="text" name="end_date" id="end_date"  value=""   onclick="endDate(this)" onmousedown="endDate(this)"/>';
                
                
                cell6.className = classname;
                cell6.innerHTML = '<div id="save" class="save" style="background-position: bottom;margin-left:auto;margin-right:auto" onclick="saveUserArea(this, '+index+')"></div>';
                  
//                cell7.className = classname;
//                cell7.innerHTML = '<div class="remove" onclick="remove2(this)" id="" title="" style="margin-left:auto;margin-right:auto" ></div>';
                              
//                opener.window.users[areaId]=1;

            }
        </script>


        <style type="text/css" >
            .boldFont {
                color: black;
                font-weight: bold;
            }
            #inserRows tr th{
                padding: 10px;
                margin :10px;
            }
            .fontInput {
                width: 80%;
                font-size: 12px;
                font-weight: bold;
            }
        </style>
    </HEAD>
    <body>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <DIV id="loadBrand" align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px; padding-top: 10px">
            <input type="button" value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            &ensp;
            <button  onclick="self.close();" class="button"><%=back%></button>

        </DIV>
    <CENTER>

        <table width="100%">
            <tr>
                <td valign="middle" width="40%" bgcolor="#E8E8E8" style="padding: 50px;">
                    <div align ="left">
                        <script type="text/javascript">
                            <!--
                            d = new dTree('d');
                            d.add(0,-1,'المواقع الرئيسية');
                            <%
                                ArrayList<WebBusinessObject> list = (ArrayList<WebBusinessObject>) request.getAttribute("list");

                                WebBusinessObject pwbo = new WebBusinessObject();

                                int size = 1;
                                int parent = -1;
                                for (int i = 0; i < list.size(); i++) {
                                    pwbo = ((WebBusinessObject) list.get(i));
                                    String projectName = pwbo.getAttribute("projectName").toString();
                                    String projectID = pwbo.getAttribute("projectID").toString();
                                    size = Integer.parseInt(pwbo.getAttribute("size").toString());
                                    parent = Integer.parseInt(pwbo.getAttribute("parent").toString());
                                    /*pwbo.setAttribute("size", size);
                                     pwbo.setAttribute("parent", parent);*/

                            %>

                                d.add(<%=size%>,<%=parent%>,'<%=projectName%>',"javascript:sendInfo('<%=projectName%>','<%=projectID%>');",'parent','<%=projectID%>');


                            <%}%>
                                d.openAll();
                                document.write(d);

                        </script>
                    </div>
                </td>
                <td valign="top">
                    <div id="viewer"></div>
                </td></tr>
        </table>
        <select id="trades" style="display: none;">
            <%
                for (int i = 0; i < trades.size(); i++) {
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo = trades.get(i);
                    String id = (String) wbo.getAttribute("tradeId");
                    String name = (String) wbo.getAttribute("tradeName");%>

            <option value="<%=id%>"><%=name%></option>

            <%
                }
            %>
        </select>

    </CENTER>
</body>
</html>