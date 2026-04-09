function ui_Calendar(firstDay, fieldId, patternId, 
                     calendarToggleId, datePickerId, 
		     monthMenuId, yearMenuId, rowId, showButtonSrc, 
		     hideButtonSrc, dateFormat, dateClass, 
		     edgeClass, selectedClass, edgeSelectedClass, 
		     todayClass, hiddenClass) {
	// object fields
    this.firstDay = firstDay; 
    this.field = document.getElementById(fieldId); 
    this.pattern = document.getElementById(patternId);
    this.calendarToggle = document.getElementById(calendarToggleId); 
    this.datePickerId = datePickerId;
    this.dateLinkId = datePickerId + ":dateLink";
    this.lastRow = document.getElementById(rowId); 
    this.monthMenu = listbox_getSelectElement(monthMenuId);
    this.yearMenu = listbox_getSelectElement(yearMenuId);
    this.showButtonSrc = showButtonSrc;
    this.hideButtonSrc = hideButtonSrc;
    this.dateFormat = dateFormat;
    this.dateClass = dateClass;
    this.selectedClass = selectedClass;
    this.edgeClass = edgeClass;
    this.todayClass = todayClass;
    this.edgeSelectedClass = edgeSelectedClass;
    this.hiddenClass = hiddenClass;
    this.currentValue; 

    // object methods  
    this.toggle = ui_Calendar_toggleCalendar;
    this.dayClicked = ui_Calendar_dayClicked;
    this.decreaseMonth = ui_Calendar_decreaseMonth;
    this.increaseMonth = ui_Calendar_increaseMonth;
    this.redrawCalendar = ui_Calendar_redrawCalendar; 
    this.setCurrentValue = ui_Calendar_setCurrentValue;
    this.setDisabled = ui_Calendar_setDisabled;
    this.setInitialFocus = ui_Calendar_setInitialFocus;
}

/* This function is used by the day links in the calendar display to
   set the date in the textfield. The day argument is the day as an
   int, the monthFix is -1, 0, +1 and is used by the last days of the 
   previous month and the next days of the next month. */
function ui_Calendar_dayClicked(link) {

    // get the current year
    var year = 
        parseInt(this.yearMenu.options[this.yearMenu.selectedIndex].value);

    // get the current month
    var month = 
        parseInt(this.monthMenu.options[this.monthMenu.selectedIndex].value);    
    var day = parseInt(link.innerHTML); 
    var monthFix = 0; 
    var className = link.className; 
    if(className == this.edgeClass) { 
        if(day > 20) { 
	    monthFix = -1; 
	} 
	else if(day < 7) { 
	    monthFix = 1; 
	} 
    } 

    if(monthFix != 0) { 
        if(monthFix == -1) { 
	    if(month == 1) { 
	        month = 13; 
		year--; 
	    } 
	} 
	else { 
	    if(month == 12) { 
	        month = 0; 
		year++;
	    } 
	} 
        month = month + monthFix; 
    } 

    var date = new String(this.dateFormat); 
    date = date.replace("yyyy", new String(year)); 
    if(month < 10) { 
        date = date.replace("MM", "0" + new String(month)); 
    } 
    else { 
        date = date.replace("MM", new String(month)); 
    } 
    if(day < 10) { 
        date = date.replace("dd", "0" + new String(day)); 
    } 
    else { 
        date = date.replace("dd", new String(day)); 
    }
    this.field.value = date; 
    this.toggle();
}

function ui_Calendar_decreaseMonth() {
    var month = parseInt(this.monthMenu.value); 
    if(month == 1) { 
        // <RAVE> Value out of bounds causes problems in IE so add check
        if (this.yearMenu.selectedIndex > 0) {
            var year = parseInt(this.yearMenu.value); 
            year--; 
            this.yearMenu.value = year; 
            month = 12; 
        }
        // </RAVE>
    } 
    else { 
      month--; 
    } 
    this.monthMenu.value = month;
    this.redrawCalendar(false); 
}

function ui_Calendar_increaseMonth() {
    var month = parseInt(this.monthMenu.value); 
    if(month == 12) { 
        // <RAVE> Value out of bounds causes problems in IE so add check
        if (this.yearMenu.selectedIndex < this.yearMenu.length - 1) {
            var year = parseInt(this.yearMenu.value); 
            year++; 
            this.yearMenu.value = year; 
            month = 1; 
        }
        // </RAVE>
    } 
    else { 
      month++; 
    } 
    this.monthMenu.value = month;
    this.redrawCalendar(false); 
}

function ui_Calendar_redrawCalendar(initialize) {

    var selected = 0;
    var currYear; 
    var currMonth; 
    var currDay; 
    if(this.currentValue != null) { 
        currYear = this.currentValue.getFullYear(); 
	currMonth = this.currentValue.getMonth() + 1; 
	currDay = this.currentValue.getDate(); 

	if(initialize) { 
            // <RAVE>
	    //this.monthMenu.value = currMonth;
	    //this.yearMenu.value = currYear; 
            rave_setLimitedSelectedValue(this.monthMenu, currMonth);
            rave_setLimitedSelectedValue(this.yearMenu, currYear);
            // </RAVE>
	    selected = currDay; 
	} 
	else { 
	    if(currYear == parseInt(this.yearMenu.value) &&
	       currMonth == parseInt(this.monthMenu.value)) {
	        selected = currDay; 
	    } 
	} 
    } 

    var today = 0; 
    var todaysDate = new Date();
    currYear = todaysDate.getFullYear(); 
    currMonth = todaysDate.getMonth() + 1; 
    currDay = todaysDate.getDate(); 
    if(currYear == parseInt(this.yearMenu.value) &&
       currMonth == parseInt(this.monthMenu.value) && 
       currDay != selected) {
        today = currDay; 
    } 
    
    var month = parseInt(this.monthMenu.value); 
    month--;
    var year = parseInt(this.yearMenu.value); 

    // construct a date object for the newly displayed month
    var first = new Date(year, month, 1);
    var numDays = 31; 
    var last = new Date(year, month, numDays + 1);

    while(last.getDate() != 1) { 
	numDays--; 
	last = new Date(year, month, numDays + 1);
    } 

    // determine what day of the week the 1st of the new month is
    var linkNum = 0; 
    var link; 

    // Fill in any number of days before the first day of the month
    // On Firefox at least, JavaScript treats Sunday as the first day 
    // of the week regardless of the browser's locale. 
    // We have to compensate for the fact that Sunday is not the first
    // day of the week everywhere.

    var firstDay = first.getDay();  

    // In JavaScript (unlike java.util.Calendar), Sunday is 0. 
    if(firstDay != this.firstDay) { 
        // <RAVE>
        var backDays = (firstDay - this.firstDay + 7) % 7;
        var oneDayInMs = 1000 * 60 * 60 * 24;
        var day = new Date(first.getTime() - backDays * oneDayInMs);
        // assert day == first day of week of previous month
        while (day.getMonth() !=  month) {
	    link = document.getElementById(this.dateLinkId + linkNum);
	    link.className = this.edgeClass;      
	    link.innerHTML = day.getDate(); 
            day.setTime(day.getTime() + oneDayInMs);
	    linkNum++; 
        }
        // </RAVE>
    } 
      
    var counter = 0; 
    while(counter < numDays) { 
        link = document.getElementById(this.dateLinkId + linkNum);
	link.innerHTML = ++counter; 
	if(counter == selected) { 
	    link.className = this.selectedClass;     
	} 
	else if(counter == today) { 
	    link.className = this.todayClass;     
	} 
	else { 
	    link.className = this.dateClass;      
	} 
	linkNum++; 
    } 

    if(linkNum < 35) { 
        counter = 1; 
	while(linkNum < 35) { 
            link = document.getElementById(this.dateLinkId + linkNum);
	    link.className = this.edgeClass;      
	    link.innerHTML = counter; 
	    linkNum++;
	    counter++; 
	} 
	this.lastRow.style.display = "none";
    } 
    else if(linkNum == 35) { 
	this.lastRow.style.display = "none";
    } 
    else { 
        counter = 1; 
	while(linkNum < 42) { 
	    link = document.getElementById(this.dateLinkId + linkNum);
	    link.className = this.edgeClass;      
	    link.innerHTML = counter; 
	    linkNum++;
	    counter++; 
	} 
        // <RAVE> IE does not support "display: table-row" so just unset it
	//this.lastRow.style.display = "table-row";
	this.lastRow.style.display = "";
        // </RAVE>
    } 




    // Calculate today's date and reset the style class unless it's
    // also selected... 

}

// This does not work for August (08) and September (09) but it works
// for all the other months????
function ui_Calendar_setCurrentValue() { 

    var curDate = this.field.value; 
    var matches = true; 
    if(curDate == "") { 
        this.currentValue = null; 
	return;
    } 

    var pattern = new String(this.dateFormat); 
    var yearIndex = pattern.indexOf("yyyy"); 
    var monthIndex = pattern.indexOf("MM"); 
    var dayIndex = pattern.indexOf("dd"); 
    // <RAVE>
    if (yearIndex < 0 || monthIndex < 0 || dayIndex < 0) {
        // Invalid format, set currentValue accordingly
        this.currentValue = null; 
	return;
    }        
    // </RAVE>

    var counter = 0; 
    var number; 

    var selectedDate = new Date(); 
    var found = 0; 
    var dateString; 

    while(counter < curDate.length) { 

        if(counter == yearIndex) { 
	    try { 
	        number = parseInt(curDate.substr(counter, 4)); 
                // <RAVE>
                if (isNaN(number)) {
                    this.currentValue = null; 
                    return;
                }
                // </RAVE

		// if the number is in range... ???
		selectedDate.setFullYear(number);
		++found; 
	    }
	    catch(e) {
	    } 
	} 
	else if(counter == monthIndex) { 
	    try { 
	      
	        dateString = curDate.substr(counter, 2); 
		// This is a workaround for Firefox! 
		// parseInt() returns 0 for values 08 and 09
		// while for example 07 works! 
		if(dateString.charAt(0) == '0') { 
                    // <RAVE> Second arg to substr in js is length not index
		    //dateString = dateString.substr(1, 2); 
		    dateString = dateString.substr(1, 1); 
                    // </RAVE>
		} 
		number = parseInt(dateString); 
                // <RAVE>
                if (isNaN(number)) {
                    this.currentValue = null; 
                    return;
                }
                // </RAVE

		selectedDate.setMonth(number-1); 
		++found;
	    }
	    catch(e) {} 
	} 
	else if(counter == dayIndex) { 
	  try { 
	      dateString = curDate.substr(counter, 2); 
	      // This is a workaround for Firefox! 
	      // parseInt() returns 0 for values 08 and 09
	      // while all other leading zeros work
	      if(dateString.charAt(0) == '0') { 
                  // <RAVE> Second arg to substr in js is length not index
                  //dateString = dateString.substr(1, 2); 
                  dateString = dateString.substr(1, 1); 
                  // </RAVE>
	      } 
	      number = parseInt(dateString); 
              // <RAVE>
              if (isNaN(number)) {
                  this.currentValue = null; 
                  return;
              }
              // </RAVE

	      selectedDate.setDate(number); 
	      ++found;
	  }
	  catch(e) {} 
	} 
	++counter; 
    } 
    if(found == 3) { 
      this.currentValue = selectedDate; 
      this.redrawCalendar(true); 
    } 
    else { 
      this.currentValue = null; 
    } 
    return;
}

function ui_Calendar_toggleCalendar() {
   var div = document.getElementById(this.datePickerId);
   // <RAVE> Fix popup calendar layout when placed in a tabset (eeg 2005-11-04)
   //var left = findPosX(this.calendarToggle);
   //var top = findPosY(this.calendarToggle);

   div.style.position = "absolute";
   //div.style.left = (left-25) + "px";
   //div.style.top = (top+15) + "px"; 
   div.style.left = "5px";
   div.style.top = "24px"; 
   // </RAVE>

    if(div.style.display == "block") {
        // hide the calendar popup
        div.style.display = "none";
        this.calendarToggle.src = this.showButtonSrc;

        // <RAVE>
        ieStackingContextFix(div);
        // </RAVE>
    } 
    else {
        this.setCurrentValue(); 
        // display the calendar popup
        div.style.display = "block";
	this.calendarToggle.src = this.hideButtonSrc;
	// place focus on the month menu
	this.setInitialFocus(); 
	// workaround for initial display problem on mozilla
	// the problem manifests itself as follows: 
	// click the link to make the calendar show
	// click one of the triangular buttons - the display
	// "contracts"
	// ...except it doesn't work!
	//var actualClass = link.className;
	//link.className = "DatBldLnk";
	//link.className = actualClass;

        // <RAVE>
        ieStackingContextFix(div);
        rave_redrawPopup(this);
        // </RAVE>
    }
}

// <RAVE> Function worksaround IE bug where popup calendar appears under
// other components (eeg 2005-11-11)
/**
 * div = Main popup div with class="CalPopShdDiv"
 */
function ieStackingContextFix(div) {
    // Test for IE and return if not
    if (!document.all) {
        return;
    }

    if (div.style.display == "block") {
        // This popup should be displayed

        // Get the current zIndex for the div
        var divZIndex = div.currentStyle.zIndex;

        // Propogate the zIndex up the offsetParent tree
        var tag = div.offsetParent;
        while (tag != null) {
            var position = tag.currentStyle.position;
            if (position == "relative" || position == "absolute") {
                // Save any zIndex so it can be restored
                tag.raveOldZIndex = tag.style.zIndex;
                // Change the zIndex
                tag.style.zIndex = divZIndex;
            }
            tag = tag.offsetParent;
        }

        // Hide controls unaffected by z-index
        ieShowShim(div);
    } else {
        // This popup should be hidden so restore zIndex-s
        var tag = div.offsetParent;
        while (tag != null) {
            var position = tag.currentStyle.position;
            if (position == "relative" || position == "absolute") {
                if (tag.raveOldZIndex != null) {
                    tag.style.zIndex = tag.raveOldZIndex;
                }
            }
            tag = tag.offsetParent;
        }

        ieHideShim(div);
    }
}

/**
 * Gets or creates an iframe shim for popup used to hide windowed
 * components in IE 5.5 and above. Assumes popup has id.
 */
function ieGetShim(popup) {
    var shimId = popup.id + "_shim";
    var shim = document.getElementById(shimId);
    if (shim == null) {
        shim = document.createElement(
            '<iframe style="display: none;" src="javascript:false;"' +
            ' frameBorder="0" scrolling="no"></iframe>');
        shim.id = shimId;
        if (popup.offsetParent == null) {
            document.body.appendChild(shim);
        } else {
            popup.offsetParent.appendChild(shim);
        }
    }
    return shim;
}

function ieShowShim(popup) {
    var shim = ieGetShim(popup);
    shim.style.position = "absolute";
    shim.style.left = popup.style.left;
    shim.style.top = popup.style.top;
    shim.style.width = popup.offsetWidth;
    shim.style.height = popup.offsetHeight;
    shim.style.zIndex = popup.currentStyle.zIndex - 1;
    shim.style.display = "block";
}

function ieHideShim(popup) {
    var shim = ieGetShim(popup);
    shim.style.display = "none";
}

function rave_setSelectedValue(select, val) {
    for (var i = 0; i < select.length; i++) {
        if (select.options[i].value == val) {
            select.selectedIndex = i;
            return;
        }
    }
    select.selectedIndex = -1;
}

/**
 * Set the value of a SELECT, but limit value to min and max
 */
function rave_setLimitedSelectedValue(select, value) {
    var min = select.options[0].value;
    var max = select.options[select.length - 1].value;
    if (value < min) {
        select.selectedIndex = 0;
    } else if ( value > max) {
        select.selectedIndex = select.length - 1;
    } else {
        rave_setSelectedValue(select, value);
    }
    return;
}

/**
 * Workaround gecko scrunched table bug and force a redraw
 */
function rave_redrawPopup(calendar) {
    // Force a redraw of the popup header controls by changing the selected
    // month which will call the onChange handler to redraw.
    var oldIndex = calendar.monthMenu.selectedIndex;
    calendar.monthMenu.selectedIndex = 0;
    calendar.monthMenu.selectedIndex = oldIndex;

    // Redraw the popup grid with the date numbers
    calendar.redrawCalendar(false);
}
// </RAVE>

// <RAVE> TODO Remove unused functions
/*
function findPosX(obj) {
    var curleft = 0;
    if (obj.offsetParent) {
	while (obj.offsetParent) {
           curleft += obj.offsetLeft
           obj = obj.offsetParent;
	}
    } else if (obj.x)
         curleft += obj.x;
    return curleft;
}

function findPosY(obj) {
    var curtop = 0;
    if (obj.offsetParent) {
        while (obj.offsetParent) {
            curtop += obj.offsetTop
	    obj = obj.offsetParent;
        }
   } else if (obj.y)
	curtop += obj.y;
   return curtop;
}
*/
// </RAVE>


function ui_Calendar_setDisabled(disabled) {

    field_setDisabled(this.field.id, disabled); 
    var span = this.calendarToggle.parentNode;
    if(disabled) { 
      span.style.display = "none"; 
    } 
    else { 
      span.style.display = "block"; 
    } 
    if(disabled) { 
        common_addStyleClass(this.pattern, this.hiddenClass); 
    } 
    else { 
        common_stripStyleClass(this.pattern, this.hiddenClass); 
    } 
} 

function ui_Calendar_setInitialFocus() {

    var pattern = new String(this.dateFormat); 
    var yearIndex = pattern.indexOf("yyyy"); 
    var monthIndex = pattern.indexOf("MM"); 

    if(yearIndex < monthIndex) { 
        this.yearMenu.focus(); 
    } 
    else { 
        this.monthMenu.focus(); 
    } 
} 
