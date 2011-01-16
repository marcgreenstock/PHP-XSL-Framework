<?php
class widgetManagerXML extends widgetManager {
	private $doc;
	
	public function __construct($db,$doc) {
		$this->doc = $doc;
		parent::__construct($db);
	}
	
	public function getWidgets() {
		$widgets = parent::getWidgets();
		$widgetsNode = $this->doc->createElement('widgets');
		foreach($widgets as $widget) {
			$widgetNode = $widgetsNode->appendChild($this->doc->createElement('widget'));
			$widgetNode->setAttribute('widget_id',$widget->widget_id);
			$widgetNode->setAttribute('name',$widget->name);
			$widgetNode->appendChild($this->doc->createElement('text'))->appendChild($this->doc->createCDataSection($widget->xml));
			$widgetNode->appendChild($this->doc->createElementFromString('xml',$widget->xml));		
		}
		return($widgetsNode);
	}
}
?>