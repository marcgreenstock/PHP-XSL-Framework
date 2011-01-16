<?php
require_once('../../config.php');
$admin = new admin();
print '<'.'?xml version="1.0" encoding="UTF-8"?'.'>';
?>
<!DOCTYPE frameset PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Marc Greenstock Administration</title>
	</head>
	<frameset cols="200,*">
		<frame frameborder="1" id="frameNav" name="frameNav" src="/admin/_nav.php" />
		<frameset rows="30,*">
			<frame frameborder="1" id="frameTop" name="frameTop" src="/admin/_top.php" scrolling="no" />
			<frame frameborder="0" id="frameMain" name="frameMain" src="/admin/index.php?<?=$_SERVER['QUERY_STRING'];?>" />
		</frameset>
	</frameset>
</html>


