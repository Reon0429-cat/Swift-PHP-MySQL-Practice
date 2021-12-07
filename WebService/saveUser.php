<?php

// DBに値を実際にINSERTする処理
$response = array();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $text = $_POST["text"];
    require_once "./DBOperation.php";
    $db = new DBOperation();
    if ($db->saveText($text)) {
      $response["error"] = false;
      $response["message"] = "挿入成功";
    } else {
      $response["error"] = true;
      $response["message"] = "挿入失敗";
    }
} else {
  $response["error"] = true;
  $response["message"] = "承認されていない";
}

echo json_encode($response)

?>