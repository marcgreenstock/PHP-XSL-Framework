<?php
class admin {
	public $user = false;
	protected $db;
	
	public function __construct() {
		$this->db = new mysqli(DB_HOST,DB_USER,DB_PASS);
		$this->authenticate();
	}
	
	private function authenticate() {
		if(isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW'])) {
			if($result = $this->db->query($sql = sprintf('
				SELECT
					`admin`.*
				FROM `%1$s`.`admin`
				WHERE `admin`.`username` = "%2$s"
				AND `admin`.`password` = "%3$s";
			',
				DB_PREFIX.'core',
				$this->db->escape_string($_SERVER['PHP_AUTH_USER']),
				$this->db->escape_string($_SERVER['PHP_AUTH_PW'])
			))) {
				if($this->user = $result->fetch_object()) {
					$result->close();
					return;
				}
				$result->close();
			}
		}
		$this->sendHeaders();
	}
	
	private function sendHeaders() {
		header('WWW-Authenticate: Basic realm="Marc Greenstock Admin"');
		header('HTTP/1.0 401 Unauthorized');
		print '<h1>We don\'t take too kindly towards your kind around here!</h1>';
		die();
	}
}
?>