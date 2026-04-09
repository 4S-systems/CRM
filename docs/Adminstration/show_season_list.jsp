<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">

        <head>
            <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
                <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
                    <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
                    <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
                    </head>

                    <%
                        /*String temp = request.getAttribute("numRows").toString();
                         int numRows = Integer.parseInt(temp);
                         */
                        int i = 0, j = 0;


                        Vector seasons = (Vector) request.getAttribute("seasons"),
                                subProjectVec = null;

                        ProjectMgr projectMgr = ProjectMgr.getInstance();
                        String mainProductId = null,
                                subProducttId = null;

                        String stat = (String) request.getSession().getAttribute("currentMode");
                        String align, dir, style, checkAllStr;

                        if (stat.equals("En")) {

                            align = "left";
                            dir = "LTR";
                            style = "text-align:left";
                            checkAllStr = "Check All";

                        } else {

                            align = "right";
                            dir = "RTL";
                            style = "text-align:Right";
                            checkAllStr = "إختر الكل";

                        }

                    %>

                    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
                        var checked = false;
                        var totalSubProjectCount = null;

                        function checkSubProjects(mainProductId) {
                            if (document.getElementById('mainProject' + mainProductId).checked == true) {
                                checked = true;

                                totalSubProjectCount = document.getElementById('totalSubProjectCount' + mainProductId).value;
                                for (var i = 0; i < totalSubProjectCount; i++) {
                                    document.getElementById('subProduct' + mainProductId + i).checked = checked;
                                }

                            } else {
                                checked = false;
                            }

                        }

                        function checkAllProjects() {
                            var allProjectsCbx = document.getElementById('allProjectsCbx');
                            var allProjects = document.getElementById('siteAll');
                            var projectArr = document.getElementsByName('site');

                            if (allProjectsCbx.checked == true) {
                                checked = true;
                                allProjects.value = "yes";

                            } else {
                                checked = false;
                                allProjects.value = "no";

                            }

                            for (var i = 0; i < projectArr.length; i++) {
                                projectArr[i].checked = checked;
                            }

                        }

                        /*
                         // trying to check/uncheck 'check all' checkbox automatically
                         function getChecked() {
                         
                         var checkedOffsprings = false;
                         
                         var allProjectsCbx = document.getElementById('allProjectsCbx');
                         var projectArr = document.getElementsByName('site');
                         
                         for (var i = 0; i < projectArr.length; i++) {
                         if(projectArr[i].checked == false) {
                         checkedOffsprings = false;
                         break;
                         
                         }
                         }
                         alert(checkedOffsprings)
                         allProjectsCbx.checked = checkedOffsprings;
                         }
                         */

                        function getEquipmentInPopup() {

                            var sites = document.getElementsByName('site');
                            var count = 0;

                            for (var i = 0; i < sites.length; i++) {
                                if (sites[i].checked) {
                                    count++;

                                }
                            }
                            if (count > 0) {
                                getDataInPopup('ReportsServletThree?op=ListEquipments' + '&fieldName=UNIT_NAME&fieldValue=' + getASSCIChar(document.getElementById('unitName').value) + '&site=' + getSites() + '&formName=SEARCH_MAINTENANCE_FORM');
                            } else {
                                alert("Must select at least one Site");
                            }
                        }

                        function getSites() {

                            var sitesValues = "'";
                            var sites = document.getElementsByName('site');
                            for (var i = 0; i < sites.length; i++) {
                                if (sites[i].checked) {
                                    sitesValues = sitesValues + sites[i].value + "','";
                                }
                            }

                            return sitesValues + "'";
                        }





                        function addTasks() {
                            var selectedSeasonArr = $('#seasons').find(':checkbox:checked');
                     
                            var seasonId, seasonName, seasonCode;
                            //                            var seasonTable = window.opener.jQuery("#season_table");
                            var insertedTable = window.opener.document.getElementById('season_table');
                            var div=window.opener.document.getElementById('campaign');
                            
                            //                            var businessId = window.opener.document.getElementById('businessId');

                            $(selectedSeasonArr).each(function(index, season) {
                                //                productId = $(product).val();
                                seasonId = $(season).parent().find('#season_id').val();
                              
                                seasonName = $(season).parent().find('#season_name').val();
                            
                                seasonCode = $(season).parent().find('#season_code').val();
                            
                                //                                alert(seasonId)
                                //                                alert(seasonName)
                                //                                alert(seasonCode)
                                row = insertedTable.insertRow();
                                row.style.border = "1px";
                                var cell0 = row.insertCell(0);
                                cell0.width = "20%";
                                cell0.innerHTML = seasonCode;

                                var cell1 = row.insertCell(1);
                                cell1.width = "25%";
                                cell1.innerHTML = seasonName;
                                var cell2 = row.insertCell(2);
                                cell2.width = "35%";
                                cell2.innerHTML = "<SPAN><TEXTAREA cols='35' rows='3' name='seasonNotes' id='seasonNotes'></TEXTAREA></SPAN><input type='hidden' name='seasonId' id='seasonId' value='" + seasonId + "' />\n\
                    <input type='hidden' name='seasonName' id='seasonName' value='" + seasonName + "' />\n\
                <input type='hidden' name='seasonCode' id='seasonCode' value='" + seasonCode + "' />";


                                var cell3 = row.insertCell(3);
                                cell3.width = "10%";
                                cell3.innerHTML = "<div type='button' class='save' id='saveSeason' name='save' onclick='saveSeason(this)'></div>";

                                var cell4 = row.insertCell(4);
                                cell4.width = "10%";
                                cell4.innerHTML = "<div type='button' class='remove' id='removeRow' name='removeRow' onclick='removeRow(this)'></div>";
                                //                                insertedTable.style.width = "70%";
                                //                                insertedTable.style.display = "block";

                                try {
                                    insertedTable.style.display = "block";
                                    //                                    div.style.display = "block";
                                    //   div.bPopup();
                                    window.opener.campaign();
                                         
                                } catch (err) {
                                    alert(err.description || err) //or console.log or however you debug
                                }
                                window.close();


                            });
                        }





                        function sendInfo(mainProduectId, mainProduectName, subProduectId, subProduectName) {

                            //            if (isExecutedFound(taskId)) {
                            //                alert(" that item is exist already in executed tasks table");
                            //                return;
                            //            }

                            //            if (isFound(taskId)) {
                            //                alert(" that item is exist already in the table");
                            //                return;
                            //            }

                            //            var className = "tRow";
                            //            if ((numRows % 2) == 1)
                            //            {
                            //                className = "tRow";
                            //            } else {
                            //                className = "tRow2";
                            //            }

                            var x = window.opener.document.getElementById('products_table').insertRow();

                            var C1 = x.insertCell(0);
                            var C2 = x.insertCell(1);
                            var C3 = x.insertCell(2);
                            var C4 = x.insertCell(3);
                            //            var C5 = x.insertCell(4);
                            //            var C6 = x.insertCell(5);
                            //            var C7 = x.insertCell(6);
                            //var C8 = x.insertCell(7);

                            C1.borderWidth = "3px";
                            C1.borderColor = "white";
                            C1.id = "codeTask";
                            C1.bgColor = "powderblue";
                            C1.className = className;

                            C2.borderWidth = "1px";
                            C2.id = "descEn";
                            C2.bgColor = "powderblue";
                            C2.className = className;

                            C3.borderWidth = "1px";
                            C3.id = "trade";
                            C3.bgColor = "powderblue";
                            C3.className = className;

                            // C4.borderWidth = "1px";
                            // C4.id = "eqType";
                            // C4.bgColor = "powderblue";
                            // C4.className=className;

                            //        C4.borderWidth = "1px";
                            //        C4.id = "jobSize";
                            //        C4.bgColor = "powderblue";
                            //        C4.className=className;

                            //            C4.borderWidth = "1px";
                            //            C4.id = "EHours";
                            //            C4.bgColor = "powderblue";
                            //            C4.className = className;
                            //
                            //            C5.borderWidth = "1px";
                            //            C5.bgColor = "powderblue";
                            //            C5.className = className;
                            //
                            //            C6.borderWidth = "1px";
                            //            C6.bgColor = "powderblue";
                            //            C6.className = className;
                            //
                            //            C5.innerHTML = "<textarea name='desc' ID='desc' cols='20' rows='2'></textarea>";
                            //            C6.innerHTML = "<input type='checkbox' name='check' ID='check'>" + "<input type='hidden' name='id' ID='id'>";

                            //            var pr = window.opener.document.getElementsByName('codeTask');
                            //            var nam = window.opener.document.getElementsByName('descEn');
                            //            var idCells = window.opener.document.getElementsByName('id');
                            //            var hoursCells = window.opener.document.getElementsByName('EHours');
                            //            var jop = window.opener.document.getElementsByName('trade');
                            //        var jopS=window.opener.document.getElementsByName('jobSize');
                            // var EQT=window.opener.document.getElementsByName('eqType');

                            //            nam[numRows].innerHTML = name;
                            //            pr[numRows].innerHTML = taskId;
                            //            idCells[numRows].value = primeryId;
                            // EQT[numRows].innerHTML=eqpName;
                            //        jopS[numRows].innerHTML=size;
                            //            hoursCells[numRows].innerHTML = hours;
                            //            jop[numRows].innerHTML = trade;
                            //
                            //            numRows++;

                            //            window.opener.document.getElementById('nRows').value = numRows;

                        }
                        //        function isFound(x) {
                        //            var code = window.opener.document.getElementsByName('codeTask');
                        //            var temp1 = "";
                        //            var temp2 = "";
                        //
                        //            for (var i = 0; i < numRows; i++) {
                        //                var t = code[i].innerHTML;
                        //                t = t.replace(" ", "");
                        //                var z = x.replace(" ", "");
                        //
                        //                temp1 = "";
                        //                temp2 = "";
                        //                for (n = 0; n < t.length; n++) {
                        //                    temp1 += t.charAt(n).charCodeAt();
                        //                }
                        //                for (c = 0; c < z.length; c++) {
                        //                    temp2 += z.charAt(c).charCodeAt();
                        //                }
                        //
                        //                if (temp1 == temp2)
                        //                    return true;
                        //            }
                        //
                        //            return false;
                        //        }
                        //
                        //        function isExecutedFound(x) {
                        //            var code = window.opener.document.getElementsByName('executedCodeTask');
                        //
                        //            for (i = 0; i < window.opener.document.getElementById('executedCon').value; i++) {
                        //                if (x == (code[i].innerHTML).replace(" ", "")) {
                        //                    return true;
                        //                }
                        //            }
                        //
                        //            return false;
                        //        }


                    </SCRIPT>
                    <style>
                        #products{
                            direction: rtl;
                            margin-left: auto;
                            margin-right: auto;

                        }
                        #products tr{
                            padding: 5px;
                        }
                        #products td{                font-size: 12px;
                                                     font-weight: bold;}
                        #products select{                font-size: 12px;
                                                         font-weight: bold;}
                        .seasonsBtn{
                            width:145px;
                            height:31px;
                            /*            margin: 4px;*/
                            background-repeat: no-repeat;
                            cursor: pointer;
                            border: none;
                            background-position: right top ;
                            display: inline-block;
                            background-color: transparent;
                            background-image:url(images/icons/choose.png);
                        }

                    </style>
                    <BODY>


                        <input type="hidden" id="siteAll" value="no" name="siteAll"/>

                        <div style="position:fixed;top: 45%;right: 5px;float: right;"> <input type="button" onclick="addTasks()"  class="seasonsBtn" ></DIV>
                        <div id='projectScroll' style="width:70%;margin-right:160px;float: right;margin-left: 10px;margin-top: 30px;">


                            <TABLE  id="seasons" CELLPADDING="4" style="width: 70%;" CELLSPACING="1" STYLE="border:0px;" align="center"  DIR="<%=dir%>">

                                <!--                    <TR>
                                                        <TD CLASS="mainHeaderNormal" WIDTH="100%" STYLE="<%=style%>;padding-<%=align%>:5;">
                                                            <INPUT TYPE="CHECKBOX" NAME="allProjectsCbx" ID="allProjectsCbx" onclick="checkAllProjects();"/>
                                <%=checkAllStr%>
                            </TD>
                        </TR>-->

                                <%
                                    while (i < seasons.size()) {
                                        WebBusinessObject wbo = new WebBusinessObject();
                                        wbo = (WebBusinessObject) seasons.get(i);
                                        String seasonName = (String) wbo.getAttribute("arabicName");
                                        String season_code = (String) wbo.getAttribute("record_code");
                                        String seasonId = (String) wbo.getAttribute("id");
                                %>

                                <tr>
                                    <TD WIDTH="100%" STYLE="<%=style%>;padding-<%=align%>:5;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                        <INPUT TYPE="CHECKBOX" NAME="seasonId" ID="seasonId<%=i%>" value="<%=seasonId%>"  />

                                        <%=seasonName%>
                                        <input type="hidden" id="season_code" name="season_type" value="<%=season_code%>"/>
                                        <input type="hidden" id="season_id" name="season_type" value="<%=seasonId%>"/>
                                        <input type="hidden" id="season_name" name="season_name" value="<%=seasonName%>"/>
                                    </TD>
                                </TR>



                                <%

                                        i++;
                                    }
                                %>

                            </TABLE>
                        </DIV>

                    </BODY>
                    </HTML>