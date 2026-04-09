package com.silkworm.servlets;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.common.*;
import com.silkworm.business_objects.*;
import org.apache.log4j.Logger;

public class LogoutServlet extends swBaseServlet {

    ApplicationSessionRegistery reg = ApplicationSessionRegistery.getInstance();
    protected WebAppUser webAppUser = null;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(LogoutServlet.class);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject wboUser = (WebBusinessObject) session.getAttribute("loggedUser");

        try {
            session.invalidate();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
        eraseCookie(request, response);
        forward("/index.jsp", request, response);
    }

    private void eraseCookie(HttpServletRequest req, HttpServletResponse resp) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (int i = 0; i < cookies.length; i++) {
                cookies[i].setValue("");
                cookies[i].setPath("/");
                cookies[i].setMaxAge(0);
                resp.addCookie(cookies[i]);
            }
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
}
