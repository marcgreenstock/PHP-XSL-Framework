<?php
class templateSwitcher extends plugin {
	public $allowedTemplates = array('public','html5');
	
	public function switchTemplate() {	
		if(isset($_GET['template']) && in_array($_GET['template'],$this->allowedTemplates)) {
			$this->setTemplate($_GET['template']);
		} elseif(isset($_COOKIE['template']) && in_array($_COOKIE['template'],$this->allowedTemplates)) {
			$this->setTemplate($_COOKIE['template']);
		}
		return;
	}
	
	private function setTemplate($template_name) {
		$template = $this->getTemplate($template_name);
		$GLOBALS['core']->template = new template($template->template,$template->media_type,$template->callback);
		setcookie('template',$template_name,time()+60*60*24*30,'/');
		return;
	}
	
	private function getTemplate($template_name) {
		$template = false;
		if($result = $GLOBALS['core']->db->query(sprintf('
			SELECT
				`template`,
				`media_type`,
				`callback`
			FROM `%1$s`.`template`
			WHERE `template` = "%2$s";
		',
			DB_PREFIX.'core',
			$GLOBALS['core']->db->escape_string($template_name)
		))) {
			$template = $result->fetch_object();
			$result->close();
		}
		return($template);
	}
}
?>