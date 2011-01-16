<?php
class sourceCode extends plugin {
	public function __construct() {
		$this->fileManager = new fileManagerXML($GLOBALS['core']->doc);
	}
	
	public function getFiles() {
		$this->node->appendChild($this->fileManager->getFileList(PATH_ROOT));
		return;
	}
	
	public function getSource() {
		$this->fileManager->getFileList(PATH_ROOT);
		if(isset($_GET['file'])) {
			$this->node->appendChild($this->fileManager->getFileSource($_GET['file']));
		}
		return;
	}
}
?>