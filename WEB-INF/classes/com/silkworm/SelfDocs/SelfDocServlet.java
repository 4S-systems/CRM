
package com.silkworm.SelfDocs;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.project_doc.SelfDocMgr;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.Vector;


public class SelfDocServlet extends TrackerBaseServlet {

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        super.processRequest(request, response);
        try {
            switch (operation) {
                case 1:
                    servedPage = "docs/equipment/form_details.jsp";
                    SelfDocMgr selfDocMgr = SelfDocMgr.getInstance();
                    Vector<WebBusinessObject> formsWbo = new Vector<WebBusinessObject>();
                    String formCode = request.getParameter("formCode");
                    formsWbo = selfDocMgr.getFormsList(formCode);
                    request.setAttribute("formsWbo", formsWbo);
                    this.forward(servedPage, request, response);
                    break;
                    
                    
                default:
                    System.out.println("No operation was matched");
            }
        } finally {
            out.close();
        }
    }

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("getFormDetails")) {
            return 1;
        }
        
        

        return 0;
    }
}
