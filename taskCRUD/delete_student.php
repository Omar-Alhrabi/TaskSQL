<?php

if (!empty($_GET['student_id'])) {
    $student_id = $_GET['student_id'];

    try {

        $conn = new PDO("mysql:host=localhost;dbname=university", "root", "");
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $stmt = $conn->prepare("UPDATE students SET deleted_at = NOW() WHERE student_id = ?");
        $stmt->execute([$student_id]);
        header("Location: index.php");
        exit();
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
} else {

    echo "Invalid request: student_id is missing!";
    exit();
}
?>
