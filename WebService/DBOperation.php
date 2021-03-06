<?php

class DBOperation {

  function saveText($text) {
    try {
      require_once("./config.php");
      $db = new PDO(DSN, DB_HOST, DB_PASSWORD);
      $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      $db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
      $stmt = $db -> prepare("insert into User(text) values(:text)");
      $stmt -> bindValue(":text", $text);
      $result = $stmt -> execute();
      $stmt = null;
      $db = null;
      if ($result) {
        return true;
      } else {
        return false;
      }
    } catch (PDOException $error) {
      print "エラー!: " . $error->getMessage() . "<br/gt;";
      die();
    }
  }

}

?>
