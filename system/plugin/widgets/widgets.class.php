<?php
class widgets extends plugin {
	public function getWidgets() {
		$widgetManager = new widgetManagerXML($GLOBALS['core']->db,$GLOBALS['core']->doc);
		$this->node->appendChild($widgetManager->getWidgets());
	}
}
?>