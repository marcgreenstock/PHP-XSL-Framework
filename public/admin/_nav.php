<?php
require_once('../../config.php');
$admin = new admin();
print '<'.'?xml version="1.0" encoding="UTF-8"?'.'>';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<style type="text/css" media="screen">@import url("_nav.css");</style>
	</head>
	<body>
		<h1>Marc Greenstock</h1>
		<h2>Hi <?=$admin->user->firstname;?></h2>
		<ul>
			<li><a href="index.php?" target="frameMain">Home</a></li>
			<li><a href="index.php?page=content" target="frameMain">Site Content</a></li>
			<li><a href="index.php?page=widgets&amp;mode=widget_list" target="frameMain">Widgets</a></li>
			<li><a href="index.php?page=blog" target="frameMain">Blog</a></li>
			<li><a href="index.php?page=ppp&amp;mode=index_list" target="frameMain">PPP</a></li>
		</ul>
	</body>
</html>