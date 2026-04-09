<%-- 
    Document   : fcltWrkrsAss
    Created on : Nov 2, 2017, 11:45:14 AM
    Author     : fatma
--%>

<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList<WebBusinessObject> branches = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("CLT", "key4"));
    int brnchLn = branches.size();

    String stat = (String) request.getSession().getAttribute("currentMode");
    String projectName = request.getAttribute("projectName") != null ? (String) request.getAttribute("projectName") : "";
    String projectID = request.getAttribute("projectID") != null ? (String) request.getAttribute("projectID") : "";

    String dir, selectClient, selectSite, title, title1, selectBranch, selectWrkr, wrkrNo, wrkrNm, wrkrSp, wrkrJb, wrkrRt, align, add, save;
    if (stat.equals("En")) {
        dir = "LTR";
        selectClient = " Select Client ";
        selectSite = "Select Site";
        title = "Sites Employees Association ";
        title1 = " Workers";
        selectBranch = " Select Branch ";
        selectWrkr = " Select Worker ";
        wrkrNo = " Workr No. ";
        wrkrNm = " Name ";
        wrkrSp = " Speciality ";
        wrkrJb = " Grade ";
        wrkrRt = " Rate/Hour ";
        align = "left";
        add = " Add ";
        save = " Save ";
    } else {
        dir = "RTL";
        selectClient = " إختر عميل ";
        selectSite = " اختر موقع";
        title = " إضافة موظف لموقع ";
        title1 = "العمال";
        selectBranch = " إختر فرع ";
        selectWrkr = " إختر عامل ";
        wrkrNo = " رقم العامل ";
        wrkrNm = " الإسم ";
        wrkrSp = " التخصص ";
        wrkrJb = " المهنة ";
        wrkrRt = " القيمة/الساعة ";
        align = "ltr";
        add = " إضافة ";
        save = " حفظ";
    }

    ArrayList<WebBusinessObject> clientsList = request.getAttribute("clientsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("clientsList") : null;
    ArrayList<LiteWebBusinessObject> wrkrLst = request.getAttribute("wrkrLst") != null ? (ArrayList<LiteWebBusinessObject>) request.getAttribute("wrkrLst") : null;

    int counter = 0;

    String afc = request.getAttribute("afc") != null ? (String) request.getAttribute("afc") : null;

    ArrayList<WebBusinessObject> fcltyWrkrLst = request.getAttribute("fcltyWrkrLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("fcltyWrkrLst") : null;

    String cT[] = null;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Facilities Workers Association </title>
    </head>

    <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>

    <script src="js/select2.min.js"></script>
    <link href="js/select2.min.css" rel="stylesheet">

    <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>

    <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
    <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

    <style>
        *>*{
            vertical-align: middle;
        }

        .titlebar {
            height: 30px;
            background-image: url(images/title_bar.png);
            background-position-x: 50%;
            background-position-y: 50%;
            background-size: initial;
            background-repeat-x: repeat;
            background-repeat-y: no-repeat;
            background-attachment: initial;
            background-origin: initial;
            background-clip: initial;
            background-color: rgb(204, 204, 204);
        }


        .button2{
            font-size: 15px;
            font-style: normal;
            font-variant: normal;
            font-weight: bold;
            line-height: 20px;
            width: 150px;
            height: 30px;
            text-decoration: none;
            display: inline-block;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.8s;
            cursor: pointer;
            border-radius: 12px;
            border: 1px solid #008CBA;
            padding-left:2%;
            text-align: center;
        }


        .button2:hover {
            background-color: #afdded;
            padding-top: 0px;
        }

        .table td{
            padding:5px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            border: none;
            margin-bottom: 30px;
        }
        .table tr{
            padding:10px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            border: none;
            margin-bottom: 30px;
        }

        .titleRow {
            background-color: orange;
        }

        .tbFStyle{
            background: silver;
            width: 25%; 
            text-align: right; 
            margin-bottom: 10px !important; 
            margin-left: 135px; 
            margin-right: auto; 
            letter-spacing: 35px;
            border-radius: 10px;
            padding-right: 20px;
        }
        #mypopup{
            padding-top: 20%;
            height: 50px;
        }
        .login {
            direction: rtl;
            margin: 20px auto;
            padding: 10px 5px;
            background: #3f65b7;
            background-clip: padding-box;
            border: 1px solid #ffffff;
            border-bottom-color: #ffffff;
            border-radius: 5px;
            color: #ffffff;
            background: #7abcff; /* Old browsers */
            background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
            background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
        }
        .login {
            direction: rtl;
            padding: 10px 5px;
            background: #3f65b7;
            background-clip: padding-box;
            border: 1px solid #ffffff;
            border-bottom-color: #ffffff;
            border-radius: 5px;
            color: #ffffff;
            background: #7abcff; /* Old browsers */
            background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
            background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
        }

        .button2{
            font-size: 15px;
            font-style: normal;
            font-variant: normal;
            font-weight: bold;
            line-height: 20px;
            width: 150px;
            height: 30px;
            text-decoration: none;
            display: inline-block;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s;
            transition-duration: 0.8s;
            cursor: pointer;
            border-radius: 12px;
            border: 1px solid #008CBA;
            padding-left:2%;
            text-align: center;
        }

        .button2:hover {
            background-color: #afdded;
            padding-top: 0px;
        }

        .table td{
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            border: none;
            margin-bottom: 30px;
        }
        .remove{
            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);
        }
        .smallDialog {
            width: 320px;
            display: none;
            position: fixed;
            z-index: 1100;
        }
        .mediumDialog {
            width: 90%;
            display: none;
            position: fixed;
            z-index: 1100;
            left: 5%;
        }
        .overlayClass {
            width: 100%;
            height: 100%;
            display: none;
            background-color: rgb(0, 85, 153);
            opacity: 0.4;
            z-index: 1000;
            top: 0px;
            left: 0px;
            position: fixed;
        }
        .img:hover{
            cursor: pointer ;
        }
        #container{
            font-family:Arial, Helvetica, sans-serif;
            position:absolute;
            top:0;
            left:0;
            background: #005778;
            width:100%;
            height:100%;
        }
        .hot-container p { margin-top: 10px; }
        a { text-decoration: none; margin: 0 10px; }

        .hot-container {
            min-height: 100px;
            margin-top: 100px;
            width: 100%;
            text-align: center;
        }

        a.btn {
            display: inline-block;
            color: #666;
            background-color: #eee;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-size: 12px;
            padding: 10px 30px;
            border-radius: 5px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border: 1px solid rgba(0,0,0,0.3);
            border-bottom-width: 3px;
        }

        a.btn:hover {
            background-color: #e3e3e3;
            border-color: rgba(0,0,0,0.5);
        }

        #mypopup{
            padding-top: 10%;
        }
        .titleRow {
            background-color: orange;
        }

        .login  h1 {
            font-size: 16px;
            font-weight: bold;
            padding-top: 10px;
            padding-bottom: 10px;
            text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
            text-align: center;
            width: 96%;
            margin-right: auto;
            text-height: 30px;
            color: black;
            text-shadow: 0 1px rgba(255, 255, 255, 0.3);
            background: #FFBB00;
            /*background: #cc0000;*/
            background-clip: padding-box;
            border: 1px solid #284473;
            border-bottom-color: #223b66;
            border-radius: 4px;
            cursor: pointer;
        }

        * > *{
            vertical-align: middle;
        }
    </style>

    <script>
        $(document).ready(function () {
            $("#clientsLstIDS").select2();
            $("#projectLstIDS").select2();
            $(".branch").select2();
            $(".shift").select2();
            $("#sitesLstIDS").select2();

            $('#wrkrTbl').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[5, 10, 25, 50, 100, -1], [5, 10, 25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true,
                "bAutoWidth": true,
                "aaSorting": [[0, "asc"]]
            }).fadeIn(2000);

            $('#brnchWrkr').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[5, 10, 25, 50, 100, -1], [5, 10, 25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "aaSorting": [[0, "asc"]]
            }).fadeIn(2000);
        });

        function viewBranches() {
            var clientId = $('#clientsLstIDS option:selected').val();

            $("#projectLstIDSTD>*").remove();

            $("#projectLstIDSTD").append('<SELECT id="projectLstIDS" name="projectLstIDS" STYLE="width: 80%; font-size: medium; font-weight: bold;" onchange="viewClients();"></SELECT>');
            $("#projectLstIDS").select2();
            
            $("#sitesLstIDSTD>*").remove();

            $("#sitesLstIDSTD").append('<SELECT id="sitesLstIDS" name="sitesLstIDS" STYLE="width: 80%; font-size: medium; font-weight: bold;" onchange="viewFcltyCnfg();"></SELECT>');
            $("#sitesLstIDS").select2();

            var options = [];
            var selectBranch = "<%=selectBranch%>";
            $("#projectLstIDS").append('<option value="">', selectBranch, '</option>');

            $.ajax({
                type: "post",
                url: "<%=context%>/EmployeeServlet?op=projectEmpAss",
                data: {
                    clientId: clientId
                }, success: function (jsonString) {
                    var result = $.parseJSON(jsonString);

                    $.each(result, function () {
                        options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                    });

                    $("#projectLstIDS").append(options.join(''));
                }
            });
            viewFcltyCnfg();
        }
        
        function viewClients() {
            var branchID = $('#projectLstIDS option:selected').val();

            $("#sitesLstIDSTD>*").remove();

            $("#sitesLstIDSTD").append('<SELECT id="sitesLstIDS" name="sitesLstIDS" STYLE="width: 80%; font-size: medium; font-weight: bold;" onchange="viewFcltyCnfg();"></SELECT>');
            $("#sitesLstIDS").select2();

            var options = [];
            var selectClient = "<%=selectClient%>";
            $("#sitesLstIDS").append('<option value="">', selectClient, '</option>');

            $.ajax({
                type: "post",
                url: "<%=context%>/EmployeeServlet?op=projectEmpAss",
                data: {
                    branchID: branchID
                }, success: function (jsonString) {
                    var result = $.parseJSON(jsonString);

                    $.each(result, function () {
                        options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                    });

                    $("#sitesLstIDS").append(options.join(''));
                }
            });
            viewFcltyCnfg();
        }

        function openWrkrDailog() {
            $("#wrkrs").bPopup();
        }

        function closePopup(obj) {
            $(obj).parent().parent().bPopup().close();
        }

        function addWrkr() {
            var wrkrID, wrkrCd, wrkrNm, wrkrRt, wrkrUnt, wrkrSp, wrkrJb, className;
            var counter = $('#numberOfRequestedItems').val();

            $("input[name='wrkrID']:checked").each(function () {
                wrkrID = $('#wrkrID' + this.value).val();
                wrkrCd = $('#wrkrNo' + this.value).val();
                wrkrNm = $('#wrkrNm' + this.value).val();
                wrkrSp = $('#wrkrSp' + this.value).val();
                wrkrJb = $('#wrkrJb' + this.value).val();
                wrkrRt = $('#wrkrRt' + this.value).val();
                wrkrUnt = $('#wrkrUnt' + this.value).val();
		var flag = "0";
		var i = 1;
		
		if (wrkrRt == null)
		{
		    wrkrRt = "0";
		} else if (wrkrRt == "") {
		    wrkrRt = "0";
		} else if (Number(wrkrRt) < 0) {
		    wrkrRt = "0";
		} else if (wrkrRt.indexOf('-') >= 0) {
		    wrkrRt = '0';
		}

		$('#rateHour' + this.value).val(wrkrRt);

		if (counter % 2 === 1) {
		    className = "silver_odd_main";
		} else {
		    className = "silver_even_main";
		}

		$("#rqstWrkr").fadeIn();

		$('#rqstWrkr > tbody:last').append("<TR id=\"row" + counter + "\"></TR>");

		$('#row' + counter).append("<TD STYLE=\"text-align: center\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + " ><b><font size=\"2\" color=\"#000080\" style=\"text-align: center;\">" + wrkrCd + "</font></b> <input type=\"hidden\" id=\"wrkrID" + counter + "\" name=\"wrkrID\" value=\"" + wrkrID + "\" ></TD>")
			.append("<TD class=\"silver_footer\" bgcolor=\"#808000\" STYLE=\"text-align:center; color:black; font-size:14px; height: 25px\"><b><font color=\"#000080\" style=\"text-align: center;\">" + wrkrNm + "</font></b></TD>")
			.append("<TD style=\"text-align: center; border-left-width: 0px\" bgcolor=\"#DDDD00\" nowrap=\"\" class=\"silver_even_main\"> <SELECT class=\"shftID\" id=\"shftID" + counter + "\" name=\"shftID\" STYLE=\"width: 100%; font-size: medium; font-weight: bold;\"> <option value=\"6 AM - 3 PM\"> 6 AM - 3 PM </option> <option value=\"7 AM - 4 PM\"> 7 AM - 4 PM </option> <option value=\"8 AM - 5 PM\"> 8 AM - 5 PM </option> <option value=\"9 AM - 6 PM\"> 9 AM - 6 PM </option> <option value=\"10 AM - 7 PM\"> 10 AM - 7 PM </option> <option value=\"11 AM - 8 PM\"> 11 AM - 8 PM </option> <option value=\"12 PM - 9 PM\"> 12 PM - 9 PM </option> <option value=\"1 PM - 10 PM\"> 1 PM - 10 PM </option> <option value=\"2 PM - 11 PM\"> 2 PM - 11 PM </option> <option value=\"3 PM - 12 AM\"> 3 PM - 12 AM </option> <option value=\"4 PM - 1 AM\"> 4 PM - 1 AM </option> <option value=\"5 PM - 2 AM\"> 5 PM - 2 AM </option> <option value=\"6 PM - 3 AM\"> 6 PM - 3 AM </option> <option value=\"7 PM - 4 AM\"> 7 PM - 4 AM </option> <option value=\"8 PM - 5 AM\"> 8 PM - 5 AM </option> <option value=\"9 PM - 6 AM\"> 9 PM - 6 AM </option> </SELECT> </TD>")
			.append("<TD STYLE=\"text-align: center; border-left-width: 0px\" BGCOLOR=\"#DDDD00\" nowrap  CLASS=" + className + "><textarea type=\"text\" id=\"wrkrRmrk" + counter + "\" name=\"wrkrRmrk\" value=\"\" style=\"width: 100%\" cols=\"10\"/></TD>");
		counter++;
		
		$(this).attr("checked", false);
		$(this).attr("disabled", true);
            });

            $(".shftID").select2();
            $('#numberOfRequestedItems').val(counter);
            $("#wrkrs").bPopup().close();
        }

        function saveWrkr() {
            if ($('#clientsLstIDS option:selected').val() == null || $('#clientsLstIDS option:selected').val() == "" || $('#clientsLstIDS option:selected').val() == " ") {
                alert(" Choose Site ");
                e.preventDefault();
            } else if ($('#projectLstIDS option:selected').val() == null || $('#projectLstIDS option:selected').val() == "" || $('#projectLstIDS option:selected').val() == " ") {
                alert(" Choose Branch ");
                e.preventDefault();
            } else if ($('#sitesLstIDS option:selected').val() == null || $('#sitesLstIDS option:selected').val() == "" || $('#sitesLstIDS option:selected').val() == " ") {
                alert(" Choose Client ");
                e.preventDefault();
            } else if (document.getElementById('row0') == null) {
                alert(" Choose One Worker At Least ");
                $("#selectWrkr").click();
                e.preventDefault();
            }

            var counter = $("#numberOfRequestedItems").val();

            var fcltyID = $("#sitesLstIDS").val();
            var wrkrID = [];
            var wrkrSft = [];
            var wrkrRmrk = [];
            var wrkrRt = [];

            for (var i = 0; i < counter; i++) {
                wrkrID.push($("#wrkrID" + i).val());
                wrkrSft.push($("#shftID" + i + " option:selected").val());
                wrkrRt.push($("#wrkrRt" + i).val());
                if ($("#wrkrRmrk" + i).val() == "") {
                    wrkrRmrk.push(" ");
                } else {
                    wrkrRmrk.push($("#wrkrRmrk" + i).val());
                }
            }

            $.ajax({
                url: "<%=context%>/EmployeeServlet?op=projectEmpAss",
                data: {
                    fcltyID: fcltyID,
                    wrkrID: wrkrID.join(),
                    wrkrSft: wrkrSft.join(),
                    wrkrRmrk: wrkrRmrk.join(),
                    wrkrRt: wrkrRt.join()
                },
                success: function (data, textStatus, jqXHR) {
		    alert(" Added Successfully ");
                    location.reload();
                }
            });
        }

        function viewFcltyCnfg() {
            var clientId = $('#clientsLstIDS option:selected').val();
            var fcltyID = $('#projectLstIDS option:selected').val();
            var branchID = $('#sitesLstIDS option:selected').val();

            $("#brnchWrkrBdy>*").remove();

            var trs = [];

            $.ajax({
                type: "post",
                url: "<%=context%>/EmployeeServlet?op=projectEmpAss",
                data: {
                    clientId: clientId,
                    fcltyID: fcltyID,
                    branchID: branchID,
                    gtFclt: "1"
                }, success: function (jsonString) {
                    var result = $.parseJSON(jsonString);
                    var count = 0;

                    $.each(result, function () {
                        //this.row_id
                        trs.push('<tr><td> ', count + 1, ' </td><td> ', this.wrkrNo, '</td><td> ', this.wrkrNm, ' </td><td> ', this.wrkrMbl, ' </td><td> ', this.wrkrSft, '</td><td> ', this.wrkrRt, ' / Hour </td><td> ', this.creationTime, ' </td><td> ', this.createdBy, ' </td><td>', this.Branch, ' </td><td><select class="branch" id="branch', this.row_id, '" style="font-size: 14px;font-weight: bold; width: 80%;" onchange="updateBranch(\'', this.row_id, '\');">');
                        var pID, pNm;
                        trs.push('<option value=""> Choose Branch </option>');
        <%
            if (branches != null && !branches.isEmpty()) {
                WebBusinessObject brnchWbo = new WebBusinessObject();
                for (int i = 0; i < branches.size(); i++) {
                    brnchWbo = branches.get(i);
        %>
                        pID = '<%=brnchWbo.getAttribute("projectID")%>';
                        pNm = '<%=brnchWbo.getAttribute("projectName")%>';

                        trs.push('<option value="' + pID + '">' + pNm + '</option>');
        <%
                }
            }
        %>

                        trs.push('</select></td><td><SELECT onchange=updateShift(', this.row_id, ') class=\"shift\" id=\"shift', this.row_id, '" "\" name=\"shftID\" STYLE=\"width: 100%; font-size: medium; font-weight: bold;\"> <option value=\"6 AM - 3 PM\"> 6 AM - 3 PM </option> <option value=\"7 AM - 4 PM\"> 7 AM - 4 PM </option> <option value=\"8 AM - 5 PM\"> 8 AM - 5 PM </option> <option value=\"9 AM - 6 PM\"> 9 AM - 6 PM </option> <option value=\"10 AM - 7 PM\"> 10 AM - 7 PM </option> <option value=\"11 AM - 8 PM\"> 11 AM - 8 PM </option> <option value=\"12 PM - 9 PM\"> 12 PM - 9 PM </option> <option value=\"1 PM - 10 PM\"> 1 PM - 10 PM </option> <option value=\"2 PM - 11 PM\"> 2 PM - 11 PM </option> <option value=\"3 PM - 12 AM\"> 3 PM - 12 AM </option> <option value=\"4 PM - 1 AM\"> 4 PM - 1 AM </option> <option value=\"5 PM - 2 AM\"> 5 PM - 2 AM </option> <option value=\"6 PM - 3 AM\"> 6 PM - 3 AM </option> <option value=\"7 PM - 4 AM\"> 7 PM - 4 AM </option> <option value=\"8 PM - 5 AM\"> 8 PM - 5 AM </option> <option value=\"9 PM - 6 AM\"> 9 PM - 6 AM </option> </SELECT></td><td><img src="images/icons/terminate.png" title="Terminate Worker" style="width: 25px; height: 25px;cursor: hand" onclick="showNotePopup(', this.row_id, ')"/> <input type="hidden" id="Wrkrid', this.row_id, '" value="', this.wrkrID, '"/><input type="hidden" id="Sid', this.row_id, '" value="', this.wrkrSft, '"/><input type="hidden" id="rtid', this.row_id, '" value="', this.wrkrRt, '"/></td></tr>');
                    });
                    $("#brnchWrkrBdy").append(trs.join(''));
                    $(".branch").select2();
                    $(".shift").select2();
                }
            });

            var op = [];
            var pID, pNm;

            op.push('<option value=""> Choose Branch </option>');
        <%
            if (branches != null && !branches.isEmpty()) {
                WebBusinessObject brnchWbo = new WebBusinessObject();
                for (int i = 0; i < branches.size(); i++) {
                    brnchWbo = branches.get(i);
        %>
            pID = '<%=brnchWbo.getAttribute("projectID")%>';
            pNm = '<%=brnchWbo.getAttribute("projectName")%>';

            op.push('<option value="' + pID + '">' + pNm + '</option>');
        <%
                }
            }
        %>


            $("#branchDiv").append(op.join(''));


        }
        function updateBranch(row_id) {


            var Sid = $("#Sid" + row_id).val();
            var Wrkrid = $("#Wrkrid" + row_id).val();
            var rtid = $("#rtid" + row_id).val();

            $.ajax({
                type: "post",
                url: "<%=context%>/EmployeeServlet?op=projectEmpAss",
                data: {
                    id: row_id,
                    bbrr: $("#branch" + row_id).val(),
                    Wid: Wrkrid,
                    Rid: rtid,
                    Sid: Sid,
                    myOp: "upBranch"
                }
                ,
                success: function (jsonString) {
		    alert(" Updated Successfully ");
		    location.reload();
                }});
        }

        function updateShift(row_id) {
            $.ajax({
                type: "post",
                url: "<%=context%>/EmployeeServlet?op=projectEmpAss",
                data: {
                    id: row_id,
                    bbrr: $("#shift" + row_id).val(),
                    myOp: "upShift"

                }
                ,
                success: function (jsonString) {
                    alert(" Updated Successfully ");
		    location.reload();
                }});
        }

        function deleteWorker(row_id, ter) {
            var comment = $("#TerReason").val() + " : " + ter;
            var reason = $("#TerReason").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/EmployeeServlet?op=projectEmpAss",
                data: {
                    id: row_id,
                    ter: ter,
                    reason: reason,
                    comment: comment,
                    myOp: "de"

                }
                ,
                success: function (jsonString) {
                    alert("Worker Has Been Terminated")
                    setTimeout(location.reload.bind(location), 100);
                }});
        }

        function showNotePopup(row_id) {
            $("#mypopup").bPopup();
            $("#id").val(row_id);
        }
        function closePopup1() {
            $("#mypopup").bPopup().close();
        }
    </script>
    <body>
        <table border="0px" class="table tbFStyle" style="margin-top: -10px">
            <tr style="padding: 0px 0px 0px 50px;">
                <td class="td" style="text-align: center;">
                    <a title=" Back " style="padding: 5px;">
                        <image style="height:42px;" src="images/icons/BACKNEWTO.png" onclick="window.history.go(-1);"/>
                    </a>

                    <a title=" Save " href="#" onclick='saveWrkr();' style="padding: 5px;">
                        <image style="height:42px;" src="images/icons/SAVENEWTO.png"/>
                    </a>

                    <input type="hidden" id="numberOfRequestedItems" name="numberOfRequestedItems" value="<%=counter%>" />

                    <a  href="<%=context%>/EmployeeServlet?op=GetEmployee" target="blanck" title=" Add Employee " style="padding: 5px;">
                        <image style="height:42px;" src="images/icons/ADDNEWTO.png"/>
                    </a>
                </td>
            </tr>
        </table>

        <form NAME="fcltWrkrsAss_FORM" METHOD="POST">
            <fieldset class="set backstyle" style="width: 95%; border-color: #006699;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="direction: <%=dir%>">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4">
                            <%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>

                <%
                    if (afc != null && afc.equals("1")) {
                %>
                <font color="green" size="4">
                Recorded Successfully 
                </font>
                <%
                } else if (afc != null && afc.equals("0")) {
                %>
                <font color="red" size="4">
                Not Recorded  
                </font>
                <%
                    }
                %>

                <%
                    if (clientsList != null && !clientsList.isEmpty()) {
                %>
                <div style="width: 90%; padding: 9px; direction: <%=dir%>;">
                    <TABLE style="width: 80%; direction: <%=dir%>;">
                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=selectSite%> 
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;">
                                <SELECT id="clientsLstIDS" name="clientsLstIDS" STYLE="width:80%; font-size: medium; font-weight: bold;" onchange="viewBranches();">
                                    <option value="">
                                        <%=selectSite%> 
                                    </option>
                                    <sw:WBOOptionList wboList='<%=clientsList%>' displayAttribute="projectName" valueAttribute="projectID" />
                                </SELECT>
                            </TD>
                        </TR>

                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=selectBranch%> 
                                    </font>
                                </b>
                            </TD>

                            <TD id="projectLstIDSTD" style="border: none; text-align: center; padding: 10px;">
                                <SELECT id="projectLstIDS" name="projectLstIDS" STYLE="width: 80%; font-size: medium; font-weight: bold;" onchange="viewClients();">
                                    <option value="">
                                        <%=selectBranch%> 
                                    </option>
                                </SELECT>
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=selectClient%> 
                                    </font>
                                </b>
                            </TD>

                            <TD id="sitesLstIDSTD" style="border: none; text-align: center; padding: 10px;">
                                <SELECT id="sitesLstIDS" name="sitesLstIDS" STYLE="width: 80%; font-size: medium; font-weight: bold;" onchange="viewFcltyCnfg();">
                                    <option value="">
                                        <%=selectClient%> 
                                    </option>
                                </SELECT>
                            </TD>
                        </TR>

                        <TR>
                            <TD class="blueHeaderTD" style="width:25%; font-size: 18px; border: none; padding: 10px;border-radius: 5px">
                                <b>
                                    <font size="3" color="white">
                                    <%=selectWrkr%> 
                                    </font>
                                </b>
                            </TD>

                            <TD style="border: none; text-align: center; padding: 10px;">
                                <input class="button2" type="button" name="selectWrkr" onclick="openWrkrDailog();" id="selectWrkr" value=" <%=selectWrkr%> " style="width: 40%;">
                            </TD>
                        </TR>
                    </table>
                </div>

                <table id="rqstWrkr" dir="ltr" style="margin-left: 5px; margin-bottom: 5px; width: 90%; display: none;">
                    <thead>
                        <tr>
                            <td class="blueBorder blueHeaderTD" style="width: 5%;"> Code </td>
                            <td class="blueBorder blueHeaderTD" style="width: 18%;"> Name </td>
                            <td class="blueBorder blueHeaderTD" style="width: 13%;"> Shift </td>
                            <td class="blueBorder blueHeaderTD" style="width: 18%;"> Comment </td>

                        </tr>
                    </thead>

                    <tbody>
                    </tbody>
                </table>
                <br><br>
                <%
                    }
                %>
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="direction: <%=dir%>">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4">
                            <%=title1%> 
                            </font>
                        </td>
                    </tr>
                </table>
                <div style="width: 98%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <br>
                    <TABLE style="width: 100%" id="brnchWrkr" dir=<fmt:message key="direction" style="width:100%;display: none; "/>   
                        <thead>
                            <tr>
                                <th style="width: 1%; color: #000000 !important;">
                                </th>

                                <th style="width: 4%; color: #000000 !important;">
                                    <font size="2">
                                    No. 
                                    </font>
                                </th>

                                <th style="width: 8%; color: #000000 !important;">
                                    <font size="2">
                                    Name 
                                    </font>
                                </th>

                                <th style="width: 9%; color: #000000 !important;">
                                    <font size="2">
                                    Mobile 
                                    </font>
                                </th>

                                <th style="width: 9%; color: #000000 !important;display: none;">
                                    <font size="2">
                                    Grade 
                                    </font>
                                </th>

                                <th style="width: 9%; color: #000000 !important;">
                                    <font size="2">
                                    Shift 
                                    </font>
                                </th>

                                <th style="width: 8%; color: #000000 !important;">
                                    <font size="2">
                                    Rate / Unit 
                                    </font>
                                </th>

                                <th style="width: 9%; color: #000000 !important;">
                                    <font size="2">
                                    Addition Time 
                                    </font>
                                </th>

                                <th style="width: 8%; color: #000000 !important;">
                                    <font size="2">
                                    Added By 
                                    </font>
                                </th>
                                <th style="width: 9%; color: #000000 !important;">
                                    <font size="2">
                                    Branch 
                                    </font>
                                </th>
                                <th style="width: 9%; color: #000000 !important">
                                    <font size="2"> 
                                    Edit Branch
                                    </font>
                                </th>
                                <th style="width: 9%; color: #000000 !important">
                                    <font size="2"> 
                                    Edit Shift
                                    </font>
                                </th>
                                <th style="width: 3%; color: #000000 !important">
                                    <font size="2"> 
                                    Terminate
                                    </font>
                                </th>
                            </tr>
                        </thead>

                        <tbody id="brnchWrkrBdy">
                            <%
                                if (fcltyWrkrLst != null && !fcltyWrkrLst.isEmpty()) {
                                    WebBusinessObject fcltyWrkrWbo = new WebBusinessObject();

                                    for (int index = 0; index < fcltyWrkrLst.size(); index++) {
                                        fcltyWrkrWbo = fcltyWrkrLst.get(index);
                            %>
                            <tr>
                                <td>
                                    <%=index + 1%> 
                                </td>

                                <td>
                                    <%=fcltyWrkrWbo.getAttribute("wrkrNo")%> 
                                </td>

                                <td>
                                    <%=fcltyWrkrWbo.getAttribute("wrkrNm")%> 
                                </td>

                                <td>
                                    <%=fcltyWrkrWbo.getAttribute("wrkrMbl")%> 
                                </td>

                                <td style="display: none;">
                                    <%=fcltyWrkrWbo.getAttribute("wrkrGrd")%> 
                                </td>

                                <td>
                                    <%=fcltyWrkrWbo.getAttribute("wrkrSft")%> 
                                </td>

                                <td>
                                    <%=fcltyWrkrWbo.getAttribute("wrkrRt")%> / Hour 
                                </td>

                                <td>
                                    <%
                                        if (fcltyWrkrWbo.getAttribute("creationTime") != null) {
                                            cT = fcltyWrkrWbo.getAttribute("creationTime").toString().split(" ");
                                        }
                                    %>
                                    <%=cT[0]%> 
                                </td>

                                <td>
                                    <%=fcltyWrkrWbo.getAttribute("createdBy")%> 
                                </td>
                                <td>
                                    <%=fcltyWrkrWbo.getAttribute("Branch")%> 
                                    <input type="hidden" id="assetbranch<%=fcltyWrkrWbo.getAttribute("wrkrID")%>"value="<%=fcltyWrkrWbo.getAttribute("row_id")%>">
                                </td>
                                <td>
                                    <select class="branch" id="branch<%=fcltyWrkrWbo.getAttribute("row_id")%>" style="font-size: 5px;font-weight: bold; width: 80%;" onchange="updateBranch('<%=fcltyWrkrWbo.getAttribute("row_id")%>', '<%=fcltyWrkrWbo.getAttribute("wrkrID")%>', '<%=fcltyWrkrWbo.getAttribute("brunch_id")%>', '<%=fcltyWrkrWbo.getAttribute("wrkrSft")%>');">
                                        <option value=""> Choose Branch </option>
                                        <sw:WBOOptionList wboList='<%=branches%>' displayAttribute="projectName" valueAttribute="projectID" />
                                    </select>

                                    <input type="hidden" id="Wrkrid<%=fcltyWrkrWbo.getAttribute("row_id")%>" value="<%=fcltyWrkrWbo.getAttribute("wrkrID")%>"/>
                                    <input type="hidden" id="Sid<%=fcltyWrkrWbo.getAttribute("row_id")%>" value="<%=fcltyWrkrWbo.getAttribute("wrkrSft")%>"/>
                                    <input type="hidden" id="rtid<%=fcltyWrkrWbo.getAttribute("row_id")%>" value="<%=fcltyWrkrWbo.getAttribute("wrkrRt")%>"/>
                                </td>
                                <td>
                                    <select class="shift" id="shift<%=fcltyWrkrWbo.getAttribute("row_id")%>" style="font-size: 5px;font-weight: bold; width: 80%;" onchange="updateShift('<%=fcltyWrkrWbo.getAttribute("row_id")%>');">
                                        <option value=""> Choose Shift </option>
                                        <option value="6 AM - 3 PM"> 6 AM - 3 PM </option> <option value="7 AM - 4 PM"> 7 AM - 4 PM </option> <option value="8 AM - 5 PM"> 8 AM - 5 PM </option> <option value="9 AM - 6 PM"> 9 AM - 6 PM </option> <option value="10 AM - 7 PM"> 10 AM - 7 PM </option> <option value="11 AM - 8 PM"> 11 AM - 8 PM </option> <option value="12 PM - 9 PM"> 12 PM - 9 PM </option> <option value="1 PM - 10 PM"> 1 PM - 10 PM </option> <option value="2 PM - 11 PM"> 2 PM - 11 PM </option> <option value="3 PM - 12 AM"> 3 PM - 12 AM </option> <option value="4 PM - 1 AM"> 4 PM - 1 AM </option> <option value="5 PM - 2 AM"> 5 PM - 2 AM </option> <option value="6 PM - 3 AM"> 6 PM - 3 AM </option> <option value="7 PM - 4 AM"> 7 PM - 4 AM </option> <option value="8 PM - 5 AM"> 8 PM - 5 AM </option> <option value="9 PM - 6 AM"> 9 PM - 6 AM </option>
                                    </select>

                                </td>
                                <td>
                                    <img src="images/icons/terminate.png" title="Terminate Worker" style="width: 25px; height: 25px;cursor: hand" onclick="showNotePopup('<%=fcltyWrkrWbo.getAttribute("row_id")%>')"/>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>

            </fieldset>

            <div id="wrkrs" style="width: 80%; display: none; position: fixed; height: auto;">
                <div style="clear: both; margin-left: 90%; margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); background-color: transparent;
                         -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup(this)"/>
                </div>

                <div class="login" style="width:80%; height: auto; margin-left: auto; margin-right: auto;">
                    <div width="80%">
                        <table name="wrkrTbl" id="wrkrTbl" class="display" cellspacing="0" width="100%" dir="<%=dir%>">
                            <thead>
                                <tr>
                                    <TH width="2%">
                                    </TH>

                                    <TH width="16%">
                                        <%=wrkrNo%> 
                                    </TH>

                                    <TH width="22%">
                                        <%=wrkrNm%> 
                                    </TH>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    if (wrkrLst != null && !wrkrLst.isEmpty()) {
                                        for (LiteWebBusinessObject wrkrWbo : wrkrLst) {
                                %>
                                <tr style="cursor: pointer;" onmouseover="this.className = ''" onmouseout="this.className = ''">
                                    <td style=" text-align: center; width: 2%;">
                                        <input type="checkbox" value="<%=wrkrWbo.getAttribute("empId")%>" name="wrkrID" id="wrkrID<%=wrkrWbo.getAttribute("empId")%>">
                                        <input type="hidden" id="wrkrNm<%=wrkrWbo.getAttribute("empId")%>" value="<%=wrkrWbo.getAttribute("empName")%> " />
                                        <input type="hidden" id="wrkrNo<%=wrkrWbo.getAttribute("empId")%>" value="<%=wrkrWbo.getAttribute("empNO")%>" />
                                    </td>

                                    <td style=" text-align: <%=align%>; width:16%;">
                                        <%=wrkrWbo.getAttribute("empNO")%> 
                                    </td>

                                    <td style=" text-align: <%=align%>; width: 22%;">
                                        <%=wrkrWbo.getAttribute("empName")%> 
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <input class="button2" type="button" name="addWrkr" onclick="addWrkr();" id="addWrkr" value=" <%=add%> " style="width: 10%; float: right;">
                </div>

            </div>
        </form>

        <form name="DD" action="" method="post">
            <div id="mypopup" style="display: none; height: 95%; width: 40%;">
                <div style="clear: both;margin-left: 95%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup1()"/>
                </div>
                <div class="login" style="width: 100%;margin-left: auto; margin-right: auto;">
                    <h1 align="center" style="vertical-align: middle; background-color: #006daa;margin-left: auto; margin-right: auto;">
                        Terminate Worker
                    </h1>
                    <center>
                        <table id="terWorker" style="width:90%; direction: left;">
                            <tbody>
                                <tr style="border: none; padding-bottom: 5px;">
                                    <td style="border: none; width: 65%; text-align: left;" colspan="2">
                                        <SELECT class="set" id="TerReason" name="TerReason" STYLE="width: 75%; height: 130%; font-size: 15px; font-weight: bolder; text-align: center; vertical-align: middle " onchange="">
                                            <option value="Termination of his service"> Termination of his service </option>
                                            <option value="According to Bank Request"> According to the Bank Request </option>
                                        </select>
                                    </td>
                                    <td style="color:#f1f1f1; font-size: 16px; border: none; font-weight: bold; text-align: left; width: 35%;">  Termination Reason  </td> 


                                </tr>
                                <tr style="border: none; padding-top: 5px;">
                                    <td style="border: none; width: 65%; text-align: left;" colspan="2">
                                        <textarea class="set" cols="20" rows="7" id="joborderComment" style="width: 99%; background-color: #FFF7D6; text-align: left;"></textarea> 
                                    </td>
                                    <td style="color:#f1f1f1; border: none; font-size: 16px; font-weight: bold; text-align: left; width: 35%;">  Termination Notes  </td>

                                </tr>

                            </tbody>
                        </table>
                    </center>
                    <div style="text-align: right; margin-left: 2%; margin-right: auto; direction: <%=dir%>; padding: 5px;" >
                        <input type="hidden" id="row_id">
                        <button type="button" class="button2" id="joborderManager" onclick="javascript:deleteWorker($('#id').val(), $('#joborderComment').val());" style="font-size: 15px; font-weight: bold; width: 20%; margin-right: 5%;">
                            <%=save%> 
                        </button>
                    </div>


                    <td><input type="hidden" id="id"></td>
                </div>
            </div>   

        </form>
    </body>
</html>