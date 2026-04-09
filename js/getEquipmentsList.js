/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function getEquipmentInPopup(){

    var sites = document.getElementById('site');
    var count = 0;

    for(var i = 0 ;i<sites.options.length;i++){
        if(sites.options[i].selected){
            count++;
        }
    }
    if(count > 0){
         getDataInPopup('ReportsServletThree?op=ListEquipments' + '&fieldName=UNIT_NAME&fieldValue=' + getASSCIChar(document.getElementById('unitName').value) + '&site=' + getSites() + '&formName=SEARCH_MAINTENANCE_FORM');
    }else {
        alert("Must select at least one Site");
    }
}
/*
function getEquipmentInPopup(formName,site){

    var sites = document.getElementById('site');
    var count = 0;

    for(var i = 0 ;i<sites.options.length;i++){
        if(sites.options[i].selected){
            count++;
        }
    }
    if(count > 0){
         getDataInPopup('ReportsServletThree?op=ListEquipments' + '&fieldName=UNIT_NAME&fieldValue=' + getASSCIChar(document.getElementById('unitName').value) + '&site=' + site + '&formName='+formName);
    }else {
        alert("Must select at least one Site");
    }
}
*/
function getSites(){
    var sitesValues = "'";
    var sites = document.getElementById('site');
    for(var i = 0 ;i<sites.options.length;i++){
        if(sites.options[i].selected){
            sitesValues = sitesValues  + sites.options[i].value + "','";
        }
    }

    return sitesValues + "'";
}
