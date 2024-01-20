document.addEventListener("DOMContentLoaded", function () {
    loadStudentList();
});

function loadStudentList() {
    fetch('/api/students')
        .then(response => response.json())
        .then(students => {
            const tableBody = document.getElementById('studentTableBody');
            tableBody.innerHTML = '';

            students.forEach(student => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${student.id}</td>
                    <td>${student.firstName}</td>
                    <td>${student.lastName}</td>
                    <td>${student.email}</td>
                    <td>
                        <button onclick="editStudent(${student.id})">Edit</button>
                        <button onclick="deleteStudent(${student.id})">Delete</button>
                    </td>
                `;
                tableBody.appendChild(row);
            });
        })
        .catch(error => console.error('Error loading student list:', error));
}

function openAddStudentForm() {
    document.getElementById('addStudentForm').style.display = 'block';
}

function closeAddStudentForm() {
    document.getElementById('addStudentForm').style.display = 'none';
}

function addStudent() {
    const firstName = document.getElementById('firstName').value;
    const lastName = document.getElementById('lastName').value;
    const email = document.getElementById('email').value;

    const newStudent = {
        firstName: firstName,
        lastName: lastName,
        email: email
    };

    fetch('/api/students', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(newStudent)
    })
    .then(response => response.json())
    .then(data => {
        console.log('Student added successfully:', data);
        closeAddStudentForm();
        loadStudentList();
    })
    .catch(error => console.error('Error adding student:', error));
}
