/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function openCustom(url)
{
    openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
}

function cancelForm(context)
{
    document.SEARCH_MAINTENANCE_FORM.target = "";
    document.SEARCH_MAINTENANCE_FORM.action = context + "/main.jsp;";
    document.SEARCH_MAINTENANCE_FORM.submit();
}

function back(context)
{
    document.SEARCH_MAINTENANCE_FORM.target = "";
    document.SEARCH_MAINTENANCE_FORM.action = context + "/ReportsServlet?op=mainPage";
    document.SEARCH_MAINTENANCE_FORM.submit();
}

function compareDate()
{
    return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
}

function getSearchBy() {
    var selectEquip = document.getElementsByName("selectEquip");
    for(var i = 0; i < selectEquip.length; i++) {
        if(selectEquip[i].checked) {
            return selectEquip[i].value;
        }
    }

    return "maintype";
}

function getMaintype(){
    var mainTypeValues = "";
    var maintype = document.getElementById('maintype');
    for(var i = 0 ;i<maintype.options.length;i++){
        if(maintype.options[i].selected){
            mainTypeValues = mainTypeValues  + maintype.options[i].value + " ";
        }
    }

    return mainTypeValues;
}

function getAllSites(){
    var sitesValues = "";
    var sites = document.getElementById('site');
    for(var i = 1 ;i<sites.options.length;i++){
        sitesValues = sitesValues  + sites.options[i].value + " ";
    }
    return sitesValues;
}

function getBrand(){
    var brandValues = "";
    var brand = document.getElementById('brand');
    for(var i = 0 ;i<brand.options.length;i++){
        if(brand.options[i].selected){
            brandValues = brandValues  + brand.options[i].value + " ";
        }
    }
    return brandValues;
}

function getAllBrand(){
    var brandValues = "";
    var brand = document.getElementById('brand');
    for(var i = 1 ;i<brand.options.length;i++){
        brandValues = brandValues  + brand.options[i].value + " ";
    }
    return brandValues;
}

function getAllMainType(){
    var mainTypeValues = "";
    var maintype = document.getElementById('maintype');
    for(var i = 1 ;i<maintype.options.length;i++){
        mainTypeValues = mainTypeValues  + maintype.options[i].value + " ";
    }
    return mainTypeValues;
}

function getAllTrade(){
    var tradeValues = "";
    var trade = document.getElementById('trade');
    for(var i = 1 ;i<trade.options.length;i++){
        tradeValues = tradeValues  + trade.options[i].value + " ";
    }
    return tradeValues;
}

function getIssueTitle(){
    var issueTitleValues = "";
    var issueTitle = document.getElementsByName('issueTitle');

    for(var i = 0; i < issueTitle.length; i++){
        if(issueTitle[i].checked){
            issueTitleValues = issueTitle[i].value;
        }
    }
    return issueTitleValues;
}

function getCurrentStatus(){
    var currentStatusValues = "";
    var currenStatus = document.getElementsByName('currenStatus');

    for(var i = 0; i < currenStatus.length; i++){
        if(currenStatus[i].checked){
            currentStatusValues = currentStatusValues + currenStatus[i].value + " ";
        }
    }
    return currentStatusValues;
}

function textChange(textBox){
    document.getElementById(textBox).value = "";
}

function getEquipment(){
    sitesValues = "";
    var sites = document.getElementById('site');
    var count = 0;

    for(var i = 0 ;i<sites.options.length;i++){
        if(sites.options[i].selected){
            sitesValues = sitesValues  + sites.options[i].value + " ";
            count++;
        }
    }

    if(trim(sitesValues) == "selectAll"){
        sitesValues = getAllSites();
    }
    if(count > 0){
        var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
        var name = document.getElementById('unitName').value;
        var res = "";
        for (i=0;i < name.length; i++) {
            res += name.charCodeAt(i) + ',';
        }
        res = res.substr(0, res.length - 1);
        openWindow('ReportsServletThree?op=selectEquipment&unitName='+res+'&formName='+formName+'&sites='+sitesValues);
    }else{
        alert("Must select at least one Site");
    }

}

function getTask(){
    var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
    var name = document.getElementById('taskName').value;
    var res = "";
    for (i=0;i < name.length; i++) {
        res += name.charCodeAt(i) + ',';
    }
    res = res.substr(0, res.length - 1);
    openWindow('ReportsServlet?op=listTasks&taskName='+res+'&formName='+formName);
}

function getItems(){
    var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
    var name = document.getElementById('sparePart').value;
    var res = "";
    for (i=0;i < name.length; i++) {
        res += name.charCodeAt(i) + ',';
    }
    res = res.substr(0, res.length - 1);
    openWindow('ReportsServletThree?op=selectItems&sparePart='+res+'&formName='+formName);
}

function openWindow(url)
{
    chaild_window = window.open(url, "chaild_window", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
    chaild_window.focus();
}

function showHide(id){
    var divUnit = document.getElementById('divUnit');
    var divMainType = document.getElementById('divMainType');
    var divBrand = document.getElementById('divBrand');
    if(id == 'mainTypeRadio') {
        divMainType.style.display = "block";
        divUnit.style.display = "none";
        divBrand.style.display = "none";
    } else if(id == 'brandRadio') {
        divBrand.style.display = "block";
        divUnit.style.display = "none";
        divMainType.style.display = "none";
    } else {
        divUnit.style.display = "block";
        divMainType.style.display = "none";
        divBrand.style.display = "none";
    }
}

function showHide2(id){
    var site = document.getElementById('site');
    if(id == 'defSite'){
        site.style.display = "none";
    }else if (id == 'allSites'){
        site.style.display = "block";
    }
}
        
function trim(str) {
    return str.replace(/^\s+|\s+$/g,"");
}

function selectAllElements(optionListId){
    var length = document.getElementById(optionListId).options.length;
    var option = document.getElementById(optionListId).options;
    if(option[0].selected) {
        option[0].selected = false;
        for(var i = 1; i<length; i++){
            option[i].selected = true;
        }
        if(optionListId == "maintype"){
            mainTypeAll = "yes";
        } else if(optionListId == "site"){
            siteAll = "yes";
        } else if(optionListId == "brand"){
            brandAll = "yes";
        } else if(optionListId == "trade"){
            tradeAll = "yes";
        }
    } else {
        if(optionListId == "maintype"){
            mainTypeAll = "no";
        } else if(optionListId == "site"){
            siteAll = "no";
        } else if(optionListId == "brand"){
            brandAll = "no";
        } else if(optionListId == "trade"){
            tradeAll = "no";
        }
    }
}

function changeMode(id) {
    if(document.getElementById(id).style.display == 'none'){
        document.getElementById(id).style.display = 'block';
    } else {
        document.getElementById(id).style.display = 'none';
    }
}
function selectAllSites(optionListId,typeAllId){
    var length = document.getElementById(optionListId).options.length;
    var option = document.getElementById(optionListId).options;
    //window.SEARCH_MAINTENANCE_FORM.site.multiple = true;
    if(option[0].selected) {
        
        document.getElementById(typeAllId).value = "yes";
        siteAll = "yes";
        option[0].selected = false;
        for(var i = 1; i<length; i++){
            option[i].selected = true;
        }
    } else {

        //window.SEARCH_MAINTENANCE_FORM.site.multiple = false;
        /*var selected = 0;
        var i = 0;
        for(i = 1; i<length; i++){
            if(option[i].selected == true){
                selected = i;
                break;
            }
        }
        for(i = 0; i<length; i++){
            option[i].selected = false;
        }
        option[selected].selected = true;*/

        document.getElementById(typeAllId).value = "no";
    }
}

function getFormDetails(code) {
    openWindow('SelfDocServlet?op=getFormDetails&formCode=' + code);
}
