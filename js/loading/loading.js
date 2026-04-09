var spinner;
var opts = {
    lines: 17, // The number of lines to draw
    length: 20, // The length of each line
    width: 12, // The line thickness
    radius: 46, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 90, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#000', // #rgb or #rrggbb or array of colors
    speed: 1.1, // Rounds per second
    trail: 68, // Afterglow percentage
    shadow: true, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: '30%', // Top position relative to parent
    left: '50%' // Left position relative to parent
};

function showLoading(id) {
    var target = document.getElementById(id);
    spinner = new Spinner(opts).spin(target);
}

function stopLoading() {
    sleep(1000);
    spinner.stop();
}

function sleep (timestamp) {
    var now = new Date().getTime();
    while(new Date().getTime() < now + timestamp){} 
}


