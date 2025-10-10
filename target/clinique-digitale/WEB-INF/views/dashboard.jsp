<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinique.dto.UserDTO" %>
<html>
<head>
    <title>Dashboard - Clinique Digitale</title>
</head>
<body>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<h2>Bienvenue, <%= user.getNom() %>!</h2>
<p>Rôle: <%= user.getRole() %></p>

<a href="<%= request.getContextPath() %>/logout">Se déconnecter</a>
</body>
</html>