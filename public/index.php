<?php
require('../config.php');
$core = new core();
if(isset($_REQUEST['debug'])) {
	if(strtolower($_REQUEST['debug']) == 'xsl') {
		$core->debugXSL();
	} else {
		$core->debugXML();
	}
} else {
	$core->render();
}
?>