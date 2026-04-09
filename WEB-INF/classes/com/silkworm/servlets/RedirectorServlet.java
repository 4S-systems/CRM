package com.silkworm.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet that simply redirects users to the Web application home page.
 * Registered with the default servlet URL to prevent clients from using
 * http://host/webAppPrefix/servlet/ServletName to bypass filters or security
 * settings that are associated with custom URLs.
 * <P>
 */
public class RedirectorServlet extends HttpServlet {

    public void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        if (!response.isCommitted()) {
            response.sendRedirect(request.getServletPath());
        }
    }

    public void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
