<!-- DBに指示を出す -->

<?php

class DBOperation {

  private $conn;

  function __construct() {
    require_once dirname(__FILE__)."/config.php";
    require_once dirname(__FILE__)."/DBConnect.php";
    $db = new DBConnect();
    $this -> conn = $db -> connect();
  }

  function saveText($text) {
    $stmt = $this->conn->prepare("insert into User(text) values (?)");
    $stmt -> bind_param("s", $text);
    $result = $stmt -> execute();
    $stmt -> close();
    if ($result) {
      return true;
    } else {
      return false;
    }
  }

}

?>