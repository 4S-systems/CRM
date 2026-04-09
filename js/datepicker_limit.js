/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*$(document).ready(function() {

    var dates = $( "#beginDate, #endDate" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        changeYear : true,
        maxDate    : "+d",
        dateFormat : "yy/mm/dd",
        numberOfMonths: 1,
        showAnim   : 'drop',
        onSelect: function( selectedDate ) {
            var option = this.id == "beginDate" ? "minDate" : "maxDate",
            instance = $( this ).data( "datepicker" ),
            date = $.datepicker.parseDate(
            instance.settings.dateFormat ||
                $.datepicker._defaults.dateFormat,
            selectedDate, instance.settings );
            dates.not( this ).datepicker( "option", option, date );

            dates.not( "#beginDate" ).datepicker( "option", "minDate", date );
        }
    });

});*/
var dp_cal1 = null;
var dp_cal2 = null;
var chaild_window;
var sitesValues = "";
window.onload = function (){
    if(dp_cal1 == null && dp_cal2 == null) {
        dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
        dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
    }
}