package com.sunrise.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LayoutServlet")
public class LayoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String page = request.getParameter("page");
        if (page == null || page.trim().isEmpty()) {
            page = "dashboard";
        }

        request.getRequestDispatcher("layout-admin.jsp?page=" + page).forward(request, response);
    }
}