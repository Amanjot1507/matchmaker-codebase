<%--
	Allows you to save student application
 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="java.util.*,model.*,javax.persistence.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<% EntityManagerFactory emf = Persistence.createEntityManagerFactory("test");
   EntityManager em = emf.createEntityManager();

   EntityTransaction tx = em.getTransaction();
   tx.begin();

   String text = request.getParameter("cover-letter");
   if (request.getParameter("app-id") != null && request.getParameter("app-id").length() > 0){
	   Application a = ApplicationController.getApplicationById(em, request.getParameter("app-id"));
     em.lock(a, LockModeType.OPTIMISTIC);
	   ApplicationController.acceptInvitation(em, a, text); 
   }
   else{
	   Student s = StudentController.getStudentByNetID(em,(String) session.getAttribute("currentUser"));
	   Project p = ProjectController.getProjectById(em, request.getParameter("id"));
	   em.lock(s, LockModeType.OPTIMISTIC);
     em.lock(p, LockModeType.OPTIMISTIC);
   	   Application a = ApplicationController.createApplication(em, s, p, text);
   }

   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "student-projects.jsp"); 
   tx.commit();
%>
</body>
</html>
