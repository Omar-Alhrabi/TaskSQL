<?php

$conn = new PDO("mysql:host=localhost;dbname=university", "root", "");
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$stmt = $conn->prepare("SELECT * FROM students ");
$stmt->execute();
$students = $stmt->fetchAll(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List</title>
    <style>
        table , td , th {
            width: 60%;
            border: 1px solid #111;
            border-collapse: collapse;
            margin: 0 auto;
            text-align: center;
            font-size: 16px;
        }
        </style>
</head>
<body>
    <h2>Student List</h2>
    <a href="create_student.php">Add New Student</a>
    <table>
        <tr>
            <th>student_id</th>
            <th>Name</th>
            <th>Email</th>
            <th>birthday</th>
            <th>gender</th>
            <th>Major</th>
            <th>enrollment_year</th>
            <th>Actions</th>
        </tr>
        <?php 
        foreach ($students as $student): ?>
            <tr>
            <td><?= $student['student_id'] ?></td>
            <td><?= $student['first_name'] . ' ' . $student['last_name'] ?></td>
            <td><?= $student['email'] ?></td>
            <td><?= $student['date_of_birth'] ?></td> 
            <td><?= $student['gender'] ?></td>
            <td><?= $student['major'] ?></td>
            <td><?= $student['enrollment_year'] ?></td>
            <td>
            <button onclick="window.location.href='update_student.php'">Update</button>
            <button onclick="if (confirm('Are you sure?')) window.location.href='delete_student.php?student_id=<?= $student['student_id'] ?>'">Delete</button>
            </td>
        </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
