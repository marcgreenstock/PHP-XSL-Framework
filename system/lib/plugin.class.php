<?php
class plugin {
	public $node;
	public $core;
	public $details;
	
	final public function getNavPos() {
		return(array_search($this->details->navigation_id,$this->core->navigationSet));
	}
}
?>