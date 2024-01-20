<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Student" %>
<%@ page import="actionModel.StudentAction" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="ressources/css/styles.css">
    <title>Liste des étudiants de EIDIA</title>
  
</head>
<body>
    <div class="container">
        <div class="school-card-container">
            <div class="sub-card">
                <div class="school-info">
                    <span class="school-icon school-icon-blue">&#128187;</span>
                    <div>
                        <h6 style="color: #70a8ff;">Web & Mobile</h6>
                        <h4 style="color: #70a8ff;">12 %</h4>
                    </div>
                </div>
            </div>

            <div class="sub-card">
                <div class="school-info">
                
                    <span class="school-icon school-icon-bleu">&#128104;</span>
                    <div>
                        <h6 style="color: #a4b0f4;">IA</h6>
                        <h4 style="color: #a4b0f4;">40 %</h4>
                    </div>
                </div>
            </div>

            <div class="sub-card">
                <div class="school-info">
                    <span class="school-icon school-icon-red">&#128373;</span>
                    <div>
                        <h6 style="color: #ff6b6b;">Cyber</h6>
                        <h4 style="color: #ff6b6b;">35 %</h4>
                    </div>
                </div>
            </div>

            <div class="sub-card">
                <div class="school-info">
                    <span class="school-icon school-icon-vert">&#129302;</span>
                    <div>
                        <h6 style="color: #70a8ff;">Robotique</h6>
                        <h4 style="color: #70a8ff;">13 %</h4>
                    </div>
                </div>
            </div>
        </div>
        <h4 style="color: gray;">Liste des étudiants de <strong>EIDIA</strong></h4>
        <div class="main-card">
       


            <button class="add-button" onclick="showAddForm()">
                <span class="plus-icon">+</span> <strong>Ajouter Un Nouveau Etudiant </strong>
            </button>
        
       
<table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Email</th>
                <th>Téléphone</th>
                <th>Filiere</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
       
            <% List<Student> studentList = (List<Student>) request.getAttribute("studentList"); %>
            <% if (studentList != null && !studentList.isEmpty()) { %>
                <% for (Student student : studentList) { %>
                    <tr>
                        <td><%= student.getId() %></td>
                        <td><%= student.getNom() %></td>
                        <td><%= student.getEmail() %></td>
                        <td><%= student.getTel() %></td>
                        <td><%= student.getFiliere() %></td>
                      <td>
                            <!-- View button with eye icon -->
                            <button class="view-btn" onclick="viewStudent(<%= student.getId() %>)">
                                <span class="icon-view"></span>Voir
                            </button>

                            <!-- Edit button with pencil icon -->
                            <button class="edit-btn" onclick="editStudent(<%= student.getId() %>)">
                                <span class="icon-edit"></span>Modifier
                            </button>

                            <!-- Delete button with wastebasket icon -->
                            <button class="delete-btn" onclick="deleteStudent(<%= student.getId() %>)">
                                <span class="icon-delete"></span>Supprimer
                            </button>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="6">Aucun étudiant disponible.</td>
                </tr>
            <% } %>
        </tbody>
    </table>


        </div>
    </div>

    <script>
    function editStudent(studentId) {
        window.currentStudentId = studentId;
        fetch('/ControleJEEE/students?id=' + studentId)
            .then(response => response.json())
            .then(studentData => {
                console.log('Student Details:', studentData);
                const nomElement = document.getElementById("nom");
                const emailElement = document.getElementById("email");
                const telElement = document.getElementById("tel");
                const filiereElement = document.getElementById("filiere");
                const studentIdInput = document.getElementById("id");

                if (nomElement && emailElement && telElement && filiereElement && studentIdInput) {
                    
                    nomElement.value = studentData.nom || '';
                    emailElement.value = studentData.email || '';
                    telElement.value = studentData.tel || '';
                    filiereElement.value = studentData.filiere || '';

                    
                    studentIdInput.value = studentData.id || ''; 
                } else {
                    console.error('One or more HTML elements not found.');
                }
            })
            .catch(error => console.error('Erreur lors de la récupération des données de l\'étudiant : ', error));

       
        document.getElementById("editStudentPopup").style.display = "block";
    }



    function hideditStudent() {
        document.getElementById("editStudentPopup").style.display = "none";
    } 
    
    function viewStudent(studentId) {
        console.log("View student clicked for ID:", studentId);

        fetch('/ControleJEEE/students?id=' + studentId)
            .then(response => response.json())
            .then(studentDetails => {
                console.log('Student Details:', studentDetails);

                var studentContent = "ID: " + studentDetails.id + "<br>Name: " + studentDetails.nom + "<br>Email: " + studentDetails.email + "<br>Filiere: " + studentDetails.filiere + "<br>Telephone: " + studentDetails.tel;

                document.getElementById("viewContent").innerHTML = studentContent;
                document.getElementById("viewStudentPopup").style.display = "block";
            })
            .catch(error => {
                console.error('Error fetching student details:', error);
            });
    }



    function hideViewStudent() {
        document.getElementById("viewStudentPopup").style.display = "none";
    }


    function deleteStudent(studentId) {
        window.currentStudentId = studentId;
        var modal = document.getElementById('deleteStudentPopup');
        modal.style.display = 'block';
    }

    function closeDeleteConfirmationModal() {
        var modal = document.getElementById('deleteStudentPopup');
        modal.style.display = 'none';
    }
    
       
        function showAddForm() {
            document.getElementById("addPopup").style.display = "block";
        }

        function hideAddForm() {
            document.getElementById("addPopup").style.display = "none";
        }
       
      
        function deleteStudentConfirmed(studentId) {
           
            console.log('Deleting student with ID:', studentId);
           
            
            fetch('/ControleJEEE/students?id=' + studentId, {
                method: 'DELETE',
            })

            .then(response => {
                if (response.ok) {
                    console.log('Student deleted successfully');
                    
                    closeDeleteConfirmationModal();
                } else {
                    console.error('Failed to delete student');
                    
                }
            })
            .catch(error => {
                console.error('Error deleting student:', error);
                // Handle the error case here
            });
        }

     
   

    </script>
    
  <div id="editStudentPopup" class="popup">
    <div class="popup-content">
        <span class="close" onclick="hideditStudent()">&times;</span>
  <form id="updateForm" action="${pageContext.request.contextPath}/students" method="post">

    <input type="hidden" name="action" value="update">

    <!-- Add a hidden field for the studentId -->
    <input type="hidden" id="id" name="id" value="${student.id}">

   

    <label for="nom" style="color: gray; ">Nom :</label>
    <input type="text" id="nom" name="nom" value="${student.nom}" style="color: gray; margin-top: -50px;" required>

    <label for="email" style="color: gray; margin-top: -30px;">Email :</label>
    <input type="email" id="email" name="email" value="${student.email}" style="color: gray; margin-top: -50px;" required>

    <label for="tel" style="color: gray;margin-top: -30px;">Téléphone :</label>
    <input type="tel" id="tel" name="tel" value="${student.tel}" style="color: gray; margin-top: -50px;" required>

    <label for="filiere" style="color: gray; margin-top: -30px;" >Filière :</label>
    <select id="filiere" name="filiere" style="color: gray; margin-top: -50px;" required>
        <option value="web_mobile" ${student.filiere == 'web_mobile' ? 'selected' : ''}>Web & Mobile</option>
        <option value="ia" ${student.filiere == 'ia' ? 'selected' : ''}>IA</option>
        <option value="cyber" ${student.filiere == 'cyber' ? 'selected' : ''}>Cyber</option>
        <option value="robotique" ${student.filiere == 'robotique' ? 'selected' : ''}>Robotique</option>
    </select>

    <input type="submit" value="Modifier" style="margin-top: -50px;">
</form>
  
   
       
</div>

</div>

  <div id="addPopup" class="popup">
    <div class="popup-content">
        <span class="close" onclick="hideAddForm()">&times;</span>
        
        <form id="addStudentForm" action="/ControleJEEE/students" method="post">
            <!-- Add a hidden field for the action -->
            <input type="hidden" name="action" value="add">

            <label for="nom" style="margin-bottom: -50px;">Nom:</label>
            <input type="text" id="nom" name="nom" style="margin-bottom: -30px;" required>

            <label for="email" style="margin-bottom: -50px;">Email:</label>
            <input type="email" id="email" name="email" style="margin-bottom: -30px;" required>

            <label for="tel" style="margin-bottom: -50px;">Téléphone:</label>
            <input type="tel" id="tel" name="tel" style="margin-bottom: -30px;" required>

            <label for="filiere" style="margin-bottom: -50px;">Filière:</label>
            <select id="filiere" name="filiere"   required>
                <option value="web_mobile">Web & Mobile</option>
                <option value="ia">IA</option>
                <option value="cyber">Cyber</option>
                <option value="robotique">Robotique</option>
            </select>

            <input type="submit" value="Ajouter" style="margin-top: -30px;">
        </form>
    </div>
</div>
  
  <div id="viewStudentPopup" class="popup"> 
  <div class="popup-content">
        <span class="close" onclick="hideViewStudent()">&times;</span>
        <h3 style="color: gray;">Student Detail</h3>
   <div style="color: gray;" id="viewContent"></div></div>
 
  </div>
  
  
  <div id="deleteStudentPopup" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeDeleteConfirmationModal()">&times;</span>
        <p>Are you sure you want to delete this student?</p>
        <button class="delete-btn" onclick="deleteStudentConfirmed(window.currentStudentId)">Yes, delete</button>
        <button onclick="closeDeleteConfirmationModal()">Cancel</button>
    </div>
</div>  
</body>

</html>
