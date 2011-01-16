<?php
require_once('../../config.php');
$admin = new adminContent();
$admin->loadXSL(PATH_SYSTEM.'/admin/shell.xsl');
$admin->loadContent(PATH_SYSTEM.'/admin');
if(isset($_REQUEST['debug'])) {
	$admin->debug();
} else {
	$admin->render();
}
?>