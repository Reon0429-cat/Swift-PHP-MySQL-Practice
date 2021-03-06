<?php

header('Content-Type: application/json; charset=UTF-8');
header("Access-Control-Allow-Origin: *");

$response = array();
if (isset($_POST["text"])) {
    $text = $_POST["text"];
    require_once "./DBOperation.php";
    $db = new DBOperation();
    if ($db->saveText($text)) {
      $response["error"] = false;
      $response["message"] = "success";
    } else {
      $response["error"] = true;
      $response["message"] = "failure";
    }
} else {
  $response["error"] = true;
  $response["message"] = "not certification";
}

echo json_encode($response);

?>
