<?php
class fileManagerXML extends fileManager {
	private $doc;
	
	public function __construct($doc) {
		$this->doc = $doc;
	}
	
	public function getFileList($path) {
		parent::getFileList($path);
		$fileListNode = $this->doc->createElement('fileList');
		$this->traverseFileList($this->fileList,$fileListNode);
		return($fileListNode);
	}
	
	public function getFileSource($file) {
		$sourceNode = $this->doc->createElement('source');
		if($source = parent::getFileSource($file)) {
			$sourceNode->appendChild($this->doc->createCDATASection($source));
		} else {
			$sourceNode->setAttribute('error','yes');
		}
		return($sourceNode);
	}
	
	private function traverseFileList($fileList,$parentNode) {
		foreach($fileList as $item) {
			if($item->type == 'dir') {
				$dirNode = $parentNode->appendChild($this->doc->createElement('dir'));
				$dirNode->setAttribute('name',$item->name);
				$this->traverseFileList($item->files,$dirNode);
			} else {
				$fileNode = $parentNode->appendChild($this->doc->createElement('file'));
				$fileNode->setAttribute('name',$item->name);
				$fileNode->setAttribute('last_updated',date("c",$item->mtime));
			}
		}
		return;
	}
}
?>