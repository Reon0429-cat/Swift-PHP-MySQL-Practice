<?php

header('Content-Type: application/json; charset=UTF-8');
header("Access-Control-Allow-Origin: *");

// fetchAllのPDOのオプションについて
// https://blog.senseshare.jp/fetch-mode.html
// 配列とJSON
// https://dev-lib.com/php-json-array/

require_once("./config.php");
$pdo = new PDO(DSN, DB_HOST, DB_PASSWORD);
$stmt = $pdo -> prepare("select * from User");
$response = $stmt -> execute();
if ($response) {
  // 連想配列として返す
  $items = $stmt -> fetchAll(PDO::FETCH_ASSOC);
  // $items = array(
  //   array('name' => 'A'),
  //   array('name' => 'B'),
  //   array('name' => 'C'),
  //   array('name' => 'D'),
  // );
  $json = json_encode($items, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE);
  echo $json;

}
$pdo = null;

?>
