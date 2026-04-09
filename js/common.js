
function  getDataInPopup(url){
    //alert("Message");
    var wind = window.open(url,"testname","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=650, height=600");
    wind.focus();
}

function getOperationOrFieldValue(op){
    
    var fieldValue = document.getElementById("fieldValue").value;
    var operator = "LIKE";
    var checkStart = fieldValue.substr(0, 1);
    var checkEnd   = fieldValue.substr(fieldValue.length - 1, fieldValue.length);
    if(checkStart == "%" && checkEnd == "%"){
        operator = "CONTAIN";
        fieldValue = fieldValue.substr(1, fieldValue.length - 2);
    }else if (checkStart == "%" && checkEnd != "%"){
        operator = "END_WITH";
        fieldValue = fieldValue.substr(1, fieldValue.length);
    }else if (checkStart != "%" && checkEnd == "%"){
        operator = "START_WITH";
        fieldValue = fieldValue.substr(0, fieldValue.length - 1);
    }else if (checkStart != "%" && checkEnd != "%"){
        operator = "LIKE";
        fieldValue = fieldValue.substr(0, fieldValue.length);
    }

    if(fieldValue == ""){
        operator = "LIKE";
    }
    //return operator + "|" + fieldValue;
    var result = "";
    if(op == "operator"){
        result = operator;
    }else if (op == "fieldValue"){
        for(var i = 0; i < fieldValue.length; i++){
            fieldValue = fieldValue.replace("%", "");
        }
        result = fieldValue;
    }
    //alert(operator + " " + fieldValue);
    return result;
}

function fillSchedule(code, name){
    
    window.opener.document.getElementById('scheduleId').value=code;
    window.opener.document.getElementById('scheduleName').value=name;
    //goToURL("ScheduleServlet?op=listRelatedSchedules", "scheduleId=" + code, "POST", fillRelatedSchedules, null, true, true);
    window.close();
}

var index = 0;
var numberOfUsers = 0;
function fillUserData(userObj){
    //var img = document.getElementById('salesEmployeeStatusImg');
    var userName = document.USERS_FORM.userName;
    var password = document.USERS_FORM.password;
    var email = document.USERS_FORM.email;
    var trade = document.USERS_FORM.trade;
    if(userObj.status == true){
        userName.value = userObj.userName;
        index = userObj.index;
        password.value = userObj.password;
        email.value = userObj.email;
        trade.value = userObj.tradeName;
        numberOfUsers = userObj.numberOfUsers;
    //img.src = successImg;
    } else {
        userName.value = "";
        password.value = "";
        email.value = "";
        trade.value = "";
        index = userObj.index;
        numberOfUsers = userObj.numberOfUsers;
    //img.src = failImg;
    }
//img.style.display = "block";
}

function getNumberOfUsers(){
    return numberOfUsers;
}

function getIndex(){
    return index;
}
function closeForm() {
    window.close();
}


function CheckAll(checkAllBox, checkedBoxs){

    var checkAll = document.getElementById(checkAllBox);
    if(checkAll.checked == true){
        var all = document.getElementsByName(checkedBoxs);
        var length = all.length;
        for(var i = 0; i < length; i++){
            all[i].checked = true;
        }
    }else{
        var all = document.getElementsByName(checkedBoxs);
        var length = all.length;
        for(var i = 0; i < length; i++){
            all[i].checked = false;
        }
    }
}

function goToURL(url, param, methodType, callback, affectedElemID, isParentWindowElem, isJson)
{
    if(methodType == null || methodType == undefined)
        methodType = 'POST';

    $.ajax({
        type: methodType,
        url: url,
        data: param,
        dataType: "json",
        success: function(html){
           
            if(affectedElemID != null && affectedElemID != undefined && $('#'+affectedElemID).html() != null){
                $('#'+affectedElemID).html(html);
            }
            if(callback != undefined && callback != null){
                if(isJson != undefined && isJson != null && isJson == true){
                    var jsonObject = eval(html);
                    callback(jsonObject);
                }else
                    callback();
            }
        }
    });

    return true;
}


function  selectUser(directType, index, numberOfUsers){
    //alert("directType : " + directType + ", index : " + index + ", numberOfUsers : " + numberOfUsers)
    //get item information related to this item
    getTitlePagination();
    goToURL("UsersServlet?op=directToUser&index=" + index + "&directType=" + directType , "numberOfUsers=" + numberOfUsers, "POST", fillUserData, null, true, true);
/*if(goToURL("UsersServlet?op=directTo&index=" + index + "&directType=" + directType , "numberOfUsers=" + numberOfUsers, "POST", fillUserData, null, true, true))
        {
            goToURL("UsersServlet?op=directTo&index=" + index + "&directType=" + directType , "numberOfUsers=" + numberOfUsers, "POST", fillUserData, null, true, true)
        }*/
}

function getTitlePagination(){
    try{
        document.getElementById('titlePaginationEn').innerHTML = '<font color="black">current</font><font color="red">&ensp;:&ensp;</font><font color="red">&ensp;&ensp;</font>' + getIndex() + ' Of ' + getNumberOfUsers();
    }catch(e){
        document.getElementById('titlePaginationAr').innerHTML = '<font color="black">\u0627\u0644\u062D\u0640\u0640\u0640\u0627\u0644\u0649 </font><font color="red">&ensp;:&ensp;</font><font color="red">&ensp;&ensp;</font>' + getIndex() + ' \u0645\u0646 ' + getNumberOfUsers();
    }
}

function getTitlePagination01(lang){
    if(lang == 'En'){
        document.getElementById('titlePaginationEn').innerHTML = '<font color="black">current</font><font color="red">&ensp;:&ensp;</font><font color="red">&ensp;&ensp;</font>' + getIndex() + ' Of ' + getNumberOfUsers();
    } else{
        document.getElementById('titlePaginationAr').innerHTML = '<font color="black">\u0627\u0644\u062D\u0640\u0640\u0640\u0627\u0644\u0649 </font><font color="red">&ensp;:&ensp;</font><font color="red">&ensp;&ensp;</font>' + getIndex() + ' \u0645\u0646 ' + getNumberOfUsers();
    }
}

function getGroups(){
/*<TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className='selectedRow'" onmouseout="this.className='backgroundHeader'">
                            <TD CLASS="" width="10%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px;height: 20px">
                                <%=isDefault%>
                            </TD>
                            <TD CLASS="" width="90%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <%=name%>
                            </TD>
                        </TR>
                        <%
                        boolean booleanIsDefault = false;
                        String defaultRow = "";
                        for(WebBusinessObject group : groups) {
                            booleanIsDefault = isDefaultGroup != null && isDefaultGroup.equalsIgnoreCase((String) group.getAttribute("groupID"));
                            if(booleanIsDefault) {
                                defaultRow = "defaultRow";
                            } else {
                                defaultRow = "";
                            }
                        %>
                        <TR class="<%=defaultRow%>" style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className='<%=defaultRow%>'">
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <% if(booleanIsDefault) { %>
                                    <img src="images/accept.png" height="15" width="16" alt="accept" />
                                <% } else { %>
                                    &ensp;
                                <% } %>
                            </TD>
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <%=group.getAttribute("groupName")%>
                            </TD>
                        </TR>
                        <% } %>
                        <% if(groups != null && groups.isEmpty()) { %>
                        <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className='<%=defaultRow%>'">
                            <TD colspan="2" STYLE="text-align:center;border-top-width: 0px; color: red">
                                <%=isNotSelec%>
                            </TD>
                        </TR>
                        <% } %>
                    </TABLE>*/
}


function printDiv(printAreaID) {
    window.frames["print_frame"].document.getElementById("printFramDiv").innerHTML= document.getElementById(printAreaID).innerHTML;
    window.frames["print_frame"].window.focus();
    window.frames["print_frame"].window.print();
}
/*
///////////////////////////////////////////////////////////
-----------------------------------------------------------
***********************************************************
                Switch between languages
***********************************************************
-----------------------------------------------------------
/////////\\\\\\\\\\\\//////////////\\\\\\\\\///////////\\\\\
*/
