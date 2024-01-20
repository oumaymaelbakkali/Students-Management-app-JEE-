package controller;

import actionModel.StudentAction;
import model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
@WebServlet("/students")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StudentAction studentAction;

    public StudentServlet() {
        super();
        this.studentAction = new StudentAction();
    }

 protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String studentIdParam = request.getParameter("id");
    if (studentIdParam != null) {
    	Long studentId = Long.parseLong(studentIdParam);
        Student student = studentAction.getStudentById(studentId);
        response.setContentType("application/json");

        // Write the JSON response to the client using PrintWriter
        try (PrintWriter out = response.getWriter()) {
            // Manually create a JSON string
            String studentDetailsJson = "{"
                    + "\"id\": " + student.getId() + ","
                    + "\"email\": \"" + student.getEmail() + "\","
                    + "\"filiere\": \"" + student.getFiliere() + "\","
                    + "\"nom\": \"" + student.getNom() + "\","
                    + "\"tel\": \"" + student.getTel() + "\""
                    + "}";

            // Write the JSON string to the response
            System.out.println(studentDetailsJson);
            out.print(studentDetailsJson);
        }
    
}
    else {
        // If "id" is not present, retrieve the list of all students
        List<Student> studentList = studentAction.getAllStudents();
        // Add the list of students to the request attribute
        request.setAttribute("studentList", studentList);
        // Forward to a JSP page to display the list of students
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}

protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "add":
                    handleAddStudent(request, response);
                    break;
                case "update":
                    handleUpdateStudent(request, response);
                    break;
                default:
                  
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
            }
        } else {
           
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

private void handleAddStudent(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
   
    String nom = request.getParameter("nom");
    String email = request.getParameter("email");
    String filiere = request.getParameter("filiere");
    String tel = request.getParameter("tel");


    Student newStudent = new Student(nom, email, tel, filiere);

   
    studentAction.addStudent(newStudent);

   
    response.sendRedirect(request.getContextPath() + "/students");
}

private void handleUpdateStudent(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
   
    String studentId = request.getParameter("id");
    String nom = request.getParameter("nom");
    String email = request.getParameter("email");
    String tel = request.getParameter("tel");
    String filiere = request.getParameter("filiere");
    System.out.println(studentId + nom );

    
    if (studentId != null && !studentId.isEmpty()) {
        
        Student updatedStudent = new Student();
        updatedStudent.setId(Long.parseLong(studentId));
        updatedStudent.setNom(nom);
        updatedStudent.setEmail(email);
        updatedStudent.setTel(tel);
        updatedStudent.setFiliere(filiere);

        
        boolean updateSuccess = studentAction.updateStudent(updatedStudent);

        if (updateSuccess) {
            
            response.sendRedirect(request.getContextPath() + "/students");
        } else {
            
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    } else {
        
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Student ID is missing or empty");
    }
}


protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
    
    String studentIdParam = request.getParameter("id");

    if (studentIdParam != null && !studentIdParam.isEmpty()) {
        
        Long studentId = Long.parseLong(studentIdParam);

       
        boolean deleteSuccess = studentAction.deleteStudent(studentId);

        if (deleteSuccess) {
            
        	  response.setStatus(HttpServletResponse.SC_OK);
              response.getWriter().println("Student deleted successfully");
              response.getWriter().println("<html><head><script>");
              response.getWriter().println("function submitForm() {");
              response.getWriter().println("  var form = document.createElement('form');");
              response.getWriter().println("  form.action = '/students';");
              response.getWriter().println("  form.method = 'post';");
              response.getWriter().println("  document.body.appendChild(form);");
              response.getWriter().println("  form.submit();");
              response.getWriter().println("}</script></head><body onload='submitForm()'></body></html>");
              return;

        } else {
          
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Failed to delete student");
        }
    } else {
        
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().println("Student ID is missing or empty");
    }
}




@Override
    public void destroy() {
        super.destroy();
        studentAction.closeSessionFactory();
    }
}
