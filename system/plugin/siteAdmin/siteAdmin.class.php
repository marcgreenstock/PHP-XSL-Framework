<?php
class siteAdmin extends plugin {
	private $user;
	
	public function __construct() {
		$this->authenticate();
	}
	
	public function buildMenu() {
		
	}
	
	private function authenticate() {
		if(isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW'])) {
			if($result = )
			if($result = $GLOBALS['core']->db->query(sprintf('
				SELECT
					`admin`.*
				FROM `%1$s`.`admin`
				WHERE `admin`.`username` = "%2$s"
				AND `admin`.`password` = "%3$s";
			',
				DB_PREFIX.'core',
				$GLOBALS['core']->db->escape_string($_SERVER['PHP_AUTH_USER']),
				$GLOBALS['core']->db->escape_string($_SERVER['PHP_AUTH_PW'])
			))) {
				if($this->user = $result->fetch_object()) {
					foreach($this->user as $key => $val) {
						$
					}
					$result->close();
					return;
				}
				$result->close();
			}
		}
		header('WWW-Authenticate: Basic realm="Marc Greenstock Admin"');
		header('HTTP/1.0 401 Unauthorized');
		print '<h1>We don\'t take too kindly towards your kind around here!</h1>';
		die();
	}
}
?>