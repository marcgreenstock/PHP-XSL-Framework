<?php
$widgetManager = new widgetManagerXML($this->db,$this->doc);
if(isset($_REQUEST['action'])) {
	switch($_REQUEST['action']) {
		case 'widget_save': {
			$widget_id = $widgetManager->saveWidget($_POST['widget_id'],$_POST['name'],$_POST['xml']);
			header('location: ?page=widgets&mode=widget_edit&widget_id='.$widget_id);
			die();
		}
		case 'widget_delete': {
			$widgetManager->deleteWidget($_REQUEST['widget_id']);
			header('location: ?page=widgets&mode=widget_list');
			die();
		}
	}
}
$this->doc->lastChild->appendChild($widgetManager->getWidgets());
?>