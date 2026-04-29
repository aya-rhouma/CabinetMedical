package com.jee.servlet;

import java.io.IOException;

import com.jee.ejb.interfaces.PatientServiceLocal;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @EJB
    private PatientServiceLocal patientService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("medecins", patientService.getAllMedecins());
        request.setAttribute("specialites", patientService.getAllSpecialites());

        // ✅ CHEMIN CORRECT
        request.getRequestDispatcher("/index.jsp")
                .forward(request, response);
    }
}
