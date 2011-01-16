<?='<'.'?xml version="1.0" encoding="UTF-8"?'.'>';?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<style type="text/css" media="screen">@import url("_nav.css");</style>
	</head>
	<body>
		<h1>
		<?php
		if($_SERVER['SERVER_ADDR'] == '127.0.0.1') {
			print "Local Server";
		} else {
			print "Live Server";
		}
		?>
		</h1>
	<body>
</html>