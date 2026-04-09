<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Vector"%>
<%
 String allbrand = "";
Vector allbrandes = (Vector)request.getAttribute("allbranch");
if(allbrandes.size()>0){
    allbrand +="{\"allbrand\":[";
    for(int i =0 ; i<allbrandes.size();i++){
        allbrand+="{\""+"siteName\" :"+"\""+((WebBusinessObject)allbrandes.get(i)).getAttribute("projectName")+"\","
                +"\"siteId\" :"+"\""+((WebBusinessObject)allbrandes.get(i)).getAttribute("projectID")+"\""+"}";
                if(i!=allbrandes.size()-1){
                     allbrand+=",";
                    }
        }
       allbrand+="]}";
}else{
    allbrand=null;
    }
System.out.println(allbrand);
%>
<%=allbrand%>