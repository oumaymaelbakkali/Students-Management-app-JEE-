package actionModel;

import model.Student;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;



import java.util.List;

public class StudentAction {
    private final SessionFactory sessionFactory;

    public StudentAction() {
        this.sessionFactory = new Configuration().configure("hibernate.cfg.xml").buildSessionFactory();
    }

   public void addStudent(Student student) {
    try (Session session = sessionFactory.openSession()) {
        Transaction transaction = session.beginTransaction();
        try {
            session.save(student);
            transaction.commit();
        } catch (Exception e) {
           
            e.printStackTrace();
            transaction.rollback(); 
        }
    }
}
   

   public Student getStudentById(Long studentId) {
	    try (Session session = sessionFactory.openSession()) {
	        Student student = session.get(Student.class, studentId);

	        if (student == null) {
	            System.out.println("No student found with ID: " + studentId);
	        }
	       
	        return student;
	    } catch (HibernateException e) {
	        System.err.println("Error retrieving Student by ID: " + e.getMessage());
	        return null; 
	    }
	}
   public boolean deleteStudent(Long studentId) {
       try (Session session = sessionFactory.openSession()) {
           Transaction transaction = session.beginTransaction();

           try {
               Student studentToDelete = session.get(Student.class, studentId);
               if (studentToDelete != null) {
                   session.delete(studentToDelete);
                   transaction.commit();
                   System.out.println("Student deleted successfully: " + studentToDelete);
                   return true;
               } else {
                   System.out.println("No student found with ID: " + studentId);
                   return false;
               }
           } catch (HibernateException e) {
               transaction.rollback();
               System.err.println("Error deleting Student: " + e.getMessage());
               return false;
           }
       } catch (HibernateException e) {
           System.err.println("Error deleting Student: " + e.getMessage());
           return false;
       }
   }
   public boolean updateStudent(Student updatedStudent) {
	    try (Session session = sessionFactory.openSession()) {
	        Transaction transaction = session.beginTransaction();

	        try {
	            
	            Student existingStudent = (Student) session.merge(updatedStudent);

	            
	            transaction.commit();

	            System.out.println("Student updated successfully: " + existingStudent);
	            return true;
	        } catch (HibernateException e) {
	           
	            transaction.rollback();
	            System.err.println("Error updating Student: " + e.getMessage());
	            return false;
	        }
	    } catch (HibernateException e) {
	        System.err.println("Error updating Student: " + e.getMessage());
	        return false;
	    }
	}



  public List<Student> getAllStudents() {
    try (Session session = sessionFactory.openSession()) {
        String hql = "FROM Student";
        List<Student> studentList = session.createQuery(hql, Student.class).getResultList();

     

        return studentList;
    } catch (HibernateException e) {
        System.err.println("Error retrieving Student list: " + e.getMessage());
        return null;
    }
}

    public void closeSessionFactory() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
