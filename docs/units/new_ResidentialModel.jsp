<%-- 
    Document   : new_ResidentialModel
    Created on : Sep 13, 2014, 2:13:01 PM
    Author     : walid
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />
  
    <%
        String status = (String) request.getAttribute("Status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
   ProjectMgr projectMgr = ProjectMgr.getInstance();
        ArrayList parents = new ArrayList<WebBusinessObject>();
        Vector res = projectMgr.getAllProjects("1364111290870");
        for (int i = 0; i < res.size(); i++) {
            WebBusinessObject wbo = (WebBusinessObject) res.get(i);
            parents.add(wbo);
        }
    %> 
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>Untitled Document</title>

        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="css/style.css"/>

        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
        <script src='silkworm_validate.js' type='text/javascript'></script>
        <script type="text/javascript" LANGUAGE="JavaScript">
            function submitForm() {
                ///alert("You button was pressed");

                if (!validateData("req", this.PROJECT_FORM.eqNO, "Please, enter Site Number.") || !validateData("alphanumeric", this.PROJECT_FORM.eqNO, "Please, enter a valid Number for Site Number.")) {
                    this.PROJECT_FORM.eqNO.focus();
                } else if (!validateData("req", this.PROJECT_FORM.project_name, "Please, enter Site Name.") || !validateData("minlength=3", this.PROJECT_FORM.project_name, "Please, enter a valid Site Name.")) {
                    this.PROJECT_FORM.project_name.focus();
                } else if (!validateData("req", this.PROJECT_FORM.project_desc, "Please, enter Site Description.")) {
                    this.PROJECT_FORM.project_desc.focus();
                } else {
                    //$("#ispressed").val("ispressed");
                    //console.log("SubmitForm");
                    document.PROJECT_FORM.action = "<%=context%>/UnitServlet?op=saveResidentialModel";
                    document.PROJECT_FORM.submit();
                }
            }

            function isNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    alert("أرقام فقط");
                    return false;
                }

                return true;
            }

        </script>
        <style >
           .td{
                border: none;
                text-align: <fmt:message key="textalign" /> ;
                padding-<fmt:message key="textalign" /> : 5%;
            }
            
             .titlebar {
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
            
        </style>

    </head>
    <body>
        <FORM NAME="PROJECT_FORM" METHOD="POST" action="">
            
            <div class="container">
                <div class="row">
                    <div class="col-lg-1 col-xs-1">
                    </div>

                    <%
                        if (status != null) {
                    %>
                    <table width="50%" align="center">
                        <tr>
                            <%
                                if (status.equalsIgnoreCase("ok")) {
                            %>
                            <td class="bar">
                                <b><font color="blue" size="3"><fmt:message key="saved" /> </font></b>
                            </td>
                            <%
                            } else {
                            %>
                            <td class="td" class="bar">
                                <b><font color="red" size="3"> <fmt:message key="notsaved" />    </font></b>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                    </table>
                    <br>
                    <%
                        }
                    %>

                    <center>
                        <div class="col-lg-5 col-xs-10">
                            <form>
                                
                                 <fieldset class="set"  style="width:85% ; border-color: #006699;">
                                    <legend>
                                       <font color="#005599" size="5">
                                       <fmt:message key="addunitmodel" />
                                      </font>
                                      </legend>
                                   
                                        <table dir='<fmt:message key="direction" />' style="width: 100%">
                                            <tr>
                                               <td class="td" style=" width: 50%">
                                                   <br/> 
                                                   <fieldset class="set" style="width:90%;border-color: #006699; " >
                                                        <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                                                    <tr>
                                                                        <td width="100%" class="titlebar">
                                                                            <font color="#005599" size="3">
                                                                            <fmt:message key="basicdata"/>
                                                                            </font>
                                                                        </td>
                                                                    </tr>
                                                             </table>
                                                        
                                                            <table class="backgroundTable" style="border: none; width: 100%; border-radius: 0px 0px 10px 10px; " dir='<fmt:message key="direction" />'>
                                                                <input type="hidden" name="futile" ID="futile"  value="0">
                                                                <input type="hidden" name="location_type" ID="location_type"  value="UNIT-MODEL">
                                                             <tr>
                                                              <td class="td">
                                                                  <label> 
                                                                     <p><b>
                                                                         <fmt:message key="project"/>
                                                                         </b>
                                                                 </label>
                                                                </td>
                                                                <td class="td">
                                                                 <SELECT name='mainProjectId' id='mainProjectId' style='width:170px;font-size:16px;'>
                                                                    <option>----</option>
                                                                    <%for (int i = 0; i < parents.size(); i++) {
                                                                        WebBusinessObject Wbo = (WebBusinessObject) parents.get(i);

                                                                        String productName = (String) Wbo.getAttribute("projectName");
                                                                        String productId = (String) Wbo.getAttribute("projectID");%>
                                                                     <option value='<%=productId%>'><b id="projectN"><%=productName%></b></option>
                                                                                            <%}%>
                                                               </select>
                                                            </td>
                                                            </tr>
                                                            <tr>
                                                              <td class="td">
                                                               <label>
                                                                   <p><b>
                                                                       <fmt:message key="classify"/>
                                                                       </b>
                                                               </label> 
                                                              </td>
                                                                <td class="td">
                                                                   <SELECT name='category' id='category' style='width:170px;font-size:16px;'>
                                                                        <option>----</option>
                                                                        <option>أقتصادى</option>    
                                                                        <option>فاخر</option>
                                                                        <option>متوسط</option>
                                                                    </select>

                                                                </td>   

                                                            </tr>
                                                            <tr>
                                                                     <td class="td">
                                                                        <label>
                                                                            <p>
                                                                                <b>
                                                                                     <fmt:message key="modelcode"/>
                                                                                </b>
                                                                        </label>
                                                                    </td>
                                                                    <td class="td">
                                                                        <input type="TEXT" name="eqNO" ID="eqNO" size="12" value="" maxlength="255" >
                                                                    </td>
                                                            </tr>
                                                                <td class="td">
                                                                        <LABEL >
                                                                            <p><b>
                                                                                <fmt:message key="modelname"/>
                                                                                </b>
                                                                        </LABEL> 
                                                                    </td> 
                                                                    <td class="td">
                                                                         <input type="TEXT"  name="project_name" ID="project_name" size="12" value="" maxlength="255" >
                                                                    </td>
                                                                <tr>
                                                                    <td class="td">
                                                                        <LABEL>
                                                                            <p><b>
                                                                                <fmt:message key="desc"/>
                                                                                </b>
                                                                        </LABEL>
                                                                    </td>
                                                                    <td class="td">
                                                                        <TEXTAREA rows="3" name="project_desc" dir="rtl" ID="project_desc" cols="30"></TEXTAREA>
                                                </td>
                                            </tr>
                                          
                                            
                                            
                                            <tr>
                                                <td class="td">
                                                  <label><p><b><fmt:message key="theprice" /></b></label>
 
                                                </td>
                                                <td class="td">
                                                   <input type="text"  size="12" value="" maxlength="255" name="max_price" id="max_price" onkeypress="JavaScript: return isNumber(event);"/> 

                                                </td>
                                            </tr>
                                        </table>
                                </fieldset> 
                                       
                                                </td>
                                             
                                              <td class="td" style=" width: 50%">
                                                <fieldset class="set" style="width:90%;border-color: #006699;height: 95%;margin-top: 14px" >
                                                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                                                    <tr>
                                                                        <td width="100%" class="titlebar">
                                                                            <font color="#005599" size="3">
                                                                            <fmt:message key="details" />
                                                                            </font>
                                                                        </td>
                                                                    </tr>
                                                             </table>
                                                         <table class="backgroundTable" style="border: none; width: 100%; border-radius: 0px 0px 10px 10px;" dir='<fmt:message key="direction" />'>
                                                            <tr>
                                                               <td class="td" style="width: 30%"> 
                                                        <label>
                                                            <p>
                                                                <b>
                                                                <fmt:message key="totalarea"/>
                                                                </b>
                                                        </label>
                                                                 </td>
                                                    <td class="td"> 
                                                        <input type="text" size="12" value="" maxlength="255" name="total_area" id="total_area" onkeypress="JavaScript: return isNumber(event);"/>
                                                    </td>
                                                            </tr>
                                                            <tr>
                                                               <td class="td" style="width: 35%">
                                                        <label><p><b>  
                                                                <fmt:message key="netarea"/>
                                                                </b></label>
                                                    </td>
                                                    <td class="td">
                                                        <input type="text" size="12" value="" maxlength="255" name="net_area" id="net_area" onkeypress="JavaScript: return isNumber(event);"/>
                                                    </td>  
                                                            </tr>
                                                            <tr>

                                                                 <td class="td" style="width: 30%"> 
                                                        <label><p><b>
                                                                <fmt:message key="rooms"/>
                                                                </b></label>
                                                    </td>
                                                    <td class="td">
                                                        <input type="text" size="12" value="" maxlength="255" name="rooms_no" id="rooms_no" onkeypress="JavaScript: return isNumber(event);"/>
                                                    </td>
                                                            </tr>
                                                            <tr>
                                                    <td class="td" style="width: 30%"> 
                                                        <label><p><b>
                                                                <fmt:message key="kitchens"/>
                                                                </b></label>
                                                    </td>
                                                    <td class="td">
                                                        <input type="text" size="12" value="" maxlength="255" name="kitchens_no" id="kitchens_no" onkeypress="JavaScript: return isNumber(event);"/>
                                                    </td>

                                                            </tr>
                                                            <tr>
                                                                 <td class="td" style="width: 30%"> 
                                                        <label><p><b>
                                                                <fmt:message key="pathrooms"/>
                                                                </b></label> 
                                                    </td>
                                                    <td class="td">
                                                        <input type="text" size="12" value="" maxlength="255" name="pathroom_no" id="pathroom_no" onkeypress="JavaScript: return isNumber(event);"/>
                                                    </td>
                                                            </tr>
                                                            <tr>
                                                     <td class="td" style="width: 30%">
                                                        <label><p><b>
                                                                <fmt:message key="balcony"/>
                                                                </b></label>
                                                    </td>
                                                    <td class="td">
                                                        <input type="text" size="12" value="" maxlength="255" name="balcony_no" id="balcony_no" onkeypress="JavaScript: return isNumber(event);"/>
                                                    </td> 
                                                            </tr>
                                                            <tr>
                                                         <td style="border: none ; width: 25%">          
                                                             <label><p><b> 
                                                                  <fmt:message key="garage"/>
                                                                  </b>
                                                             </label>
                                                      
                                                        <input type="checkbox" size="12" name="garage" id="garage"/> 
                                                     </td>
                                                       <td style="border: none ; width: 25%">          
                                                          <label><p><b>
                                                                 <fmt:message key="store"/>
                                                                 </b></label>
                                                         <input type="checkbox" size="12" name="storage" id="storage"/> 
                                                     </td>  
                                                            
                                                    <td style="border: none ; width: 25%">                    

                                                           <label><p><b>
                                                                         <fmt:message key="elevators"/>
                                                                             </b></label>
                                                          <input type="checkbox" size="12" name="elevator" id="elevator"/>
                                                     </td>
                                                      <td style="border: none ; width: 25%">          
                                                         <label><p><b>
                                                                  <fmt:message key="club"/>
                                                                 </b></label>
                                                         <input type="checkbox" size="12" name="club" id="club"/>
                                                     </td>
                                                            </tr>
                                                        </table>
                                                    
                                                </fieldset>                                                                                                                            
                                                 </td>
                                    </tr>
                                     
                                   
                                </table>
                                        
                                    
                                </fieldset>
                          <br/>                                       
                             <DIV align="center" STYLE="color:blue; width:50%">
                        <button  onclick="JavaScript: cancelForm();" class="button">
                            <fmt:message key="cancle" />
                            <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                        <button  id="submitBut" name="submitBut" onclick="JavaScript:  submitForm();" class="button">
                                <fmt:message key="save" />
                                <IMG HEIGHT="15" SRC="images/save.gif"></button>
                    </DIV>
                                
                                <input style="display: none" type="text" value=""  name="ispressed" id="ispressed" /> 
                                <input type="hidden"  size="12" value="UL" maxlength="255" name="min_price" id="min_price" onkeypress="JavaScript: return isNumber(event);"/> 
 
                            </form>
                        </div><!--end col-lg-7-->
                    </center>


                </div><!--end row-->
            </div><!--end container-->
        </FORM>
    </body>

</html>