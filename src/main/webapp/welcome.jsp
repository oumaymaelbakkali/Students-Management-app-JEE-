<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Student" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .card {
            width: 300px;
            margin: 50px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
        }

        h1 {
            color: #333;
        }

        button {
            background-color:#ff9933;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #FFA500;
        }

        .icon {
            margin-left: 5px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>Welcome back</h1>
        
        <form action="students" method="get">
            <button type="submit">Go to <strong>EIDIA</strong> Students list<span class="icon">&#9654;</span></button>
        </form>
    </div>
</body>
</html>
