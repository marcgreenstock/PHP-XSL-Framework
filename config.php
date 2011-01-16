<?php
if(isset($_SERVER['SERVER_ADDR']) && $_SERVER['SERVER_ADDR'] == '127.0.0.1') {
	ini_set('display_errors',1);
	ini_set('error_reporting',E_ALL);
} else {
	ini_set('display_errors',0);
}
define('HOST_NAME','www.marcgreenstock.com');
define('DB_HOST','localhost');
define('DB_USER','web');
define('DB_PASS','Bs9QrymzsQsXGNYB');
define('DB_PREFIX','marcgreenstock_');
define('PATH_ROOT',realpath(dirname(__FILE__)));
define('PATH_SYSTEM',PATH_ROOT.'/system');
define('PATH_LIB',PATH_SYSTEM.'/lib');
define('PATH_PLUGIN',PATH_SYSTEM.'/plugin');
define('PATH_TEMPLATE',PATH_SYSTEM.'/template');
define('EMAIL','marc@marcgreenstock.com');
define('reCAPTCHA_PUBLIC','6LcerwYAAAAAAPh3wP9KUjqExB1YFlP10XUtps-1');
define('reCAPTCHA_PRIVATE','6LcerwYAAAAAADzgqmntHDWsAdMwmPHSuFyYEIAQ');

if(get_magic_quotes_gpc()) {
	function stripslashes_deep($value) {
		return(is_array($value) ? array_map('stripslashes_deep', $value) : stripslashes($value));
	}
	$_POST = array_map('stripslashes_deep',$_POST);
	$_GET = array_map('stripslashes_deep',$_GET);
	$_COOKIE = array_map('stripslashes_deep',$_COOKIE);
	$_REQUEST = array_map('stripslashes_deep',$_REQUEST);
}
function __autoload($class) {
	if(is_file(PATH_LIB.'/'.$class.'.class.php')) {
		require_once(PATH_LIB.'/'.$class.'.class.php');
	} elseif(is_file(PATH_PLUGIN.'/'.$class.'/'.$class.'.class.php')) {
		require_once(PATH_PLUGIN.'/'.$class.'/'.$class.'.class.php');
	}
}
?>
