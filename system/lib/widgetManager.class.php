<?php
class widgetManager {
	private $db;
	
	public function __construct($db) {
		$this->db = $db;
	}
	
	public function getWidgets() {
		$widgets = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`widget`.`widget_id`,
				`widget`.`name`,
				`widget`.`xml`
			FROM `%1$s`.`widget`
			ORDER BY `widget`.`widget_id` ASC;
		',
			DB_PREFIX.'core'
		))) {
			while($row = $result->fetch_object()) {
				$widgets[] = $row;
			}
			$result->close();
		}
		return($widgets);
	}
	
	public function saveWidget($widget_id,$name,$xml) {
		$this->db->query(sprintf('
			REPLACE INTO `%1$s`.`widget` SET
				`widget_id` = %2$d,
				`name` = "%3$s",
				`xml` = "%4$s"
		',
			DB_PREFIX.'core',
			$this->db->escape_string($widget_id),
			$this->db->escape_string($name),
			$this->db->escape_string($xml)
		));
		return(true);
	}
	
	public function deleteWidget($widget_id) {
		$this->db->query(sprintf('
			DELETE FROM `%1$s`.`widget`
			WHERE `widget_id` = %2$d;
		',
			DB_PREFIX.'core',
			$this->db->escape_string($widget_id)
		));
		return(true);
	}
}
?>