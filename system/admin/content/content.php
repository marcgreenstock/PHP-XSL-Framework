<?php
if(isset($_REQUEST['action'])) {
	switch($_REQUEST['action']) {
		case 'content_save': {
			$this->db->query(sprintf('
				REPLACE INTO `%1$s`.`content` SET
					`content_id` = %2$d,
					`parent_id` = IF(%3$d != "",%3$d,NULL),
					`template_id` = IF(%4$d != "",%4$d,NULL),
					`variables` = IF("%5$s" != "","%5$s",NULL),
					`path` = IF("%6$s" != "","%6$s",NULL),
					`title` = IF("%7$s" != "","%7$s",NULL),
					`xml` = "%8$s",
					`xsl` = "%9$s";
			',
				DB_PREFIX.'core',
				$this->db->escape_string($_POST['content_id']),
				$this->db->escape_string($_POST['parent_id']),
				$this->db->escape_string($_POST['template_id']),
				$this->db->escape_string($_POST['variables']),
				$this->db->escape_string($_POST['path']),
				$this->db->escape_string($_POST['title']),
				$this->db->escape_string($_POST['xml']),
				$this->db->escape_string($_POST['xsl'])
			));
			header('location: ?page=content&mode=content_edit&content_id='.$this->db->insert_id);
			die();
		}
		case 'content_delete': {
			$this->db->query(sprintf('
				DELETE FROM `%1$s`.`content`
				WHERE `content_id` = %2$d;
			',
				DB_PREFIX.'core',
				$this->db->escape_string($_REQUEST['content_id'])
			));
			header('location: ?page=content');
			die();
		}
		case 'plugin_method_2_content_save': {
			$this->db->query(sprintf('
				REPLACE INTO `%1$s`.`plugin_method_2_content` SET
					`plugin_method_2_content_id` = %2$d,
					`plugin_method_id` = %3$d,
					`content_id` = %4$d,
					`inherit` = %5$d,
					`sequence` = %6$d
			',
				DB_PREFIX.'core',
				$this->db->escape_string($_POST['plugin_method_2_content_id']),
				$this->db->escape_string($_POST['plugin_method_id']),
				$this->db->escape_string($_POST['content_id']),
				$this->db->escape_string($_POST['inherit']),
				$this->db->escape_string($_POST['sequence'])
			));
			header('location: ?page=content&mode=plugin_method_2_content_edit&content_id='.$_POST['content_id'].'&plugin_method_2_content_id='.$this->db->insert_id);
			die();
		}
		case 'plugin_method_2_content_delete': {
			$this->db->query(sprintf('
				DELETE FROM `%1$s`.`plugin_method_2_content`
				WHERE `plugin_method_2_content_id` = %2$d;
			',
				DB_PREFIX.'core',
				$this->db->escape_string($_REQUEST['plugin_method_2_content_id'])
			));
			header('location: ?page=content&mode=content_edit&content_id='.$_REQUEST['content_id']);
			die();
		}
		case 'plugin_method_2_content_reorder': {
			die();
		}
	}
}
if($result = $this->db->query(sprintf('
	SELECT *
	FROM `%1$s`.`content`
	ORDER BY `path` ASC;
',
	DB_PREFIX.'core'
))) {
	while($row = $result->fetch_object()) {
		$this->row2config($row,'content');
	}
	$result->close();
}
if($result = $this->db->query(sprintf('
	SELECT *
	FROM `%1$s`.`template`
',
	DB_PREFIX.'core'
))) {
	while($row = $result->fetch_object()) {
		$this->row2config($row,'template');
	}
	$result->close();
}
if($result = $this->db->query(sprintf('
	SELECT *
	FROM `%1$s`.`plugin`
',
	DB_PREFIX.'core'
))) {
	while($row = $result->fetch_object()) {
		$this->row2config($row,'plugin');
	}
	$result->close();
}
if($result = $this->db->query(sprintf('
	SELECT *
	FROM `%1$s`.`plugin_method`
',
	DB_PREFIX.'core'
))) {
	while($row = $result->fetch_object()) {
		$this->row2config($row,'plugin_method');
	}
	$result->close();
}
if($result = $this->db->query(sprintf('
	SELECT *
	FROM `%1$s`.`plugin_method_2_content`
',
	DB_PREFIX.'core'
))) {
	while($row = $result->fetch_object()) {
		$this->row2config($row,'plugin_method_2_content');
	}
	$result->close();
}
?>