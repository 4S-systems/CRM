/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var sendGetReq = function(url_, data_, success_, fail_) {
    $.ajax({
        type: "GET",
        url: url_,
        data: data_,
        success: success_,
        error: fail_,
        dataType: "json"
    });
};


