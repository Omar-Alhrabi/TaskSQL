<?php
$conn = new PDO("mysql:host=localhost;dbname=university", "root", "");
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

if (isset($_POST['update'])) {
    try {
        $stmt = $conn->prepare("UPDATE students SET student_id=?, first_name=?, last_name=?, email=?, date_of_birth=?, gender=?, major=?, enrollment_year=?, updated_at=NOW() WHERE student_id=?");
        $stmt->execute([$_POST['student_id'], $_POST['first_name'], $_POST['last_name'], $_POST['email'], $_POST['date_of_birth'], $_POST['gender'], $_POST['major'], $_POST['enrollment_year'], $_POST['student_id']]);
        header("Location: index.php");
        exit();
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}

$id = $_GET['student_id'];
$stmt = $conn->prepare("SELECT * FROM students WHERE student_id = ?");
$stmt->execute([$id]);
$student = $stmt->fetch(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <title>Document</title>
    <style>
        body{
            font-family: Arial, sans-serif;
            background-color: #555555;
        }
        .form1{
            margin: auto;
            margin-top: 50px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);

        }
        .form1 input{
            width: 100%;
    font-size: 16px;
  
        }
        .btn{
            margin-top: 10px;
        }
        </style>
</head>
<body>
    <form action="update_student.php" method="post" class="align-items-center">
        <div class="col-md-6 form1"> 
    <label for="" class="form-label">student_id</label><br>
    <input type="text" id="student_id" name="student_id" required class="form-floating"><br>
    <label for="" class="form-label" >first_name</label><br>
    <input type="text" id="first_name" name="first_name" class="form-floating" ><br>
    <label for="" class="form-label" >last_name</label><br>
    <input type="text" id="last_name" name="last_name" class="form-floating"><br>
    <label for="" class="form-label" >email</label><br>
    <input type="text" id="email" name="email" class="form-floating"><br>
    <label for="" class="form-label" >date_of_birth</label><br>
    <input type="date" id="date_of_birth" name="date_of_birth" class="form-floating" ><br>
    <label for="" class="form-label" >gender</label><br>
      <select class="form-select input"  name="gender"><br>
      <option value="Male">Male</option>
      <option value="Female">Female</option>
      <option value="other">other</option>
    </select>
    <label for="" class="form-label" >major</label><br>
    <input type="text" id="major" name="major" class="form-floating"><br>
    <label for="" class="form-label" >enrollment_year</label><br>
    <input type="number" id="enrollment_year" name="enrollment_year" class="form-floating"><br>
    <input type="submit" value="Submit" class="btn btn-primary"><br>
    </div>
    </form>
</body>
</html>