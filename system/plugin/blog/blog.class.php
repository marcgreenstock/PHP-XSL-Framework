<?php
class blog extends plugin {
	private $blog;
	
	public function __construct() {
		$this->blog = new blogManagerXML($GLOBALS['core']->db,$GLOBALS['core']->doc);
	}
	
	public function getEntries() {
		$this->node->appendChild($this->blog->storeUserComment());
		$this->node->appendChild($this->blog->getEntries());
		return;
	}
	
	public function getTopics() {
		$this->node->appendChild($this->blog->getTopics());
		return;
	}
}
?>