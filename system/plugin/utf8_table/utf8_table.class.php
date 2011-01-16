<?php
class utf8_table extends plugin {
	public function getTable() {
		$keyCodes = array(
			160=>'Non-breaking space',
			169=>'Copyright',
			153=>'Trademark',
			174=>'Registered Trademark',
			165=>'Japanese Yen',
			163=>'Pound Sterling',
			128=>'Euro',
			176=>'Degrees'
		);
		foreach($keyCodes as $code => $desc) {
			$keyCodeNode = $this->node->appendChild($GLOBALS['core']->doc->createElement('keyCode'));
			$keyCodeNode->setAttribute('code',$code);
			$keyCodeNode->setAttribute('desc',$desc);
		}
		return;
	}
}
?>