<!-- DBと接続するためのファイル -->

<?php

class DBConnect {
  private $conn;

  function __construct() {
  }

  function connect() {
    require_once "config.php";
    $this -> conn = new mysqli(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME);
    if (mysqli_connect_errno()) {
      echo "DB接続失敗" . mysqli_connect_errno();
    }
    return $this -> conn;
  }
}

?>