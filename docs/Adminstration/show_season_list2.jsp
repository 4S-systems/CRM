<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">

        <head>

        </head>

        <%
            /*String temp = request.getAttribute("numRows").toString();
             int numRows = Integer.parseInt(temp);
             */
            int i = 0, j = 0;


            ArrayList<WebBusinessObject> seasons = (ArrayList<WebBusinessObject>) request.getAttribute("seasons");

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
     

            function addTasks() {
                          
                var selectedSeasonArr = $('#seasons').find(':checkbox:checked');
                           
                var seasonId, seasonName;
                var ids =new Array();
                var x=false;
                var select=false;
                var disable=false;
                //                            var seasonTable = window.opener.jQuery("#season_table");
                var row;
                var insertedTable = $('#season_table');
                $(selectedSeasonArr).each(function(index, season) {
                    seasonId = $(season).parent().find('#season_id').val();
                           
                    for(var i=0;i<ids.length;i++){
                              
                        if(seasonId==ids[i]){
                
                            x=true;
                        }
                    }
                })
                if(selectedSeasonArr.length>0){
                    if(!x){
                    
                        $(selectedSeasonArr).each(function(index, season) {
                            //                productId = $(product).val();
                            var i=0;
                            if($(season).attr("id")=="selected"){
                                select=true;
                            }else if($(season).attr("disabled")==true){
                                disable=true;
                            }else{
                                seasonId = $(season).parent().find('#season_id').val();
                                ids[i]=seasonId;
                                
                                seasonName = $(season).parent().find('#season_name').val();
                            
                            
                                //                                alert(seasonId)
                                //                                alert(seasonName)
                                //                                alert(seasonCode)
                                $('#season_table tr:last').after("<tr><td>"+seasonName+"</td>\n\
<td><SPAN><TEXTAREA cols='30' rows='3' name='seasonNotes' id='seasonNotes'></TEXTAREA></SPAN><input type='hidden' name='seasonId' id='seasonId' value='" + seasonId + "' />\n\
        <input type='hidden' name='seasonName' id='seasonName' value='" + seasonName + "' />\n\
<td><div type='button' class='save__' id='saveSeason' name='save' onclick='saveSeason(this)'></div></td><td><div type='button' class='remove__' id='removeRow' name='removeRow' onclick='removeRow(this)'></div></td></tr>");
                                $(season).attr("id","selected");}
                            i++;

                        }); $("#season_table").css("display","");
                        //                    selectedSeasonArr.attr("checked",false);
                        //                    selectedSeasonArr.attr("background-color","green");
                        selectedSeasonArr.attr("disabled",true);
                    }
                    else{
                        alert("هذه الحملة تم تسجيلها مسبفا");
                    }
                }else{
                    alert("قم بإختيار حملة أو أكثر");
                }
                if(select&disable){  alert("لقد تم  الإختيار مسبقا");}
                return false;
                            
            }


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


            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;float: left;margin: 0px 0xp;">
                <input type="hidden" id="siteAll" value="no" name="siteAll"/>
                <TABLE  id="seasons" CELLPADDING="4" style="width: 50%;" CELLSPACING="2" STYLE="border:none;" align="center"  DIR="<%=dir%>">

                    <%
                        while (i < seasons.size()) {
                            WebBusinessObject wbo = new WebBusinessObject();
                            wbo = (WebBusinessObject) seasons.get(i);
                            String seasonName = (String) wbo.getAttribute("campaignTitle");
                            String seasonId = (String) wbo.getAttribute("id");
                    %>

                    <tr>
                        <TD WIDTH="100%" STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                            <INPUT TYPE="CHECKBOX" NAME="seasonId" ID="seasonId<%=i%>" value="<%=seasonId%>"  />

                            <%=seasonName%>
                            <input type="hidden" id="season_id" name="season_type" value="<%=seasonId%>"/>
                            <input type="hidden" id="season_name" name="season_name" value="<%=seasonName%>"/>
                        </TD>
                    </TR>



                    <%

                            i++;
                        }
                    %>

                    <tr> <td style="text-align: center;border: none"><input type="button" onclick="addTasks()"  value="إختيار" style="font-family: sans-serif" ></td> </tr>
                </TABLE>
                <table  style="width:92%;display: none;margin-left: auto;margin-right: auto;" id="season_table">

                    <thead>
                        <tr>
                            <th width="20%"CLASS="blueBorder backgroundTable">إسم الحملة </th> 
                            <th width="50%"CLASS="blueBorder backgroundTable">ملاحظات</th>
                            <th width="5%"CLASS="blueBorder backgroundTable">حفظ</th>
                            <th width="5%"CLASS="blueBorder backgroundTable">حذف</th>
                        </tr>
                    </thead>
                    <tbody>

                    </tbody>

                </table>
            </div>

        </BODY>
        </HTML>