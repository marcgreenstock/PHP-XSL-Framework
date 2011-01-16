<?php
class fileManager {
	public $excludeFiles = array('config.php','access_log','error_log');
	public $excludeExtensions = array('doc','pdf','gif','jpg','png','swf','DS_Store');
	protected $fileList = array();
	
	public function getFileList($path) {
		$this->fileList = $this->fileList($path);
		return($this->fileList);
	}
	
	public function getFileSource($file) {
		$flatArray = $this->flattenFileList($this->fileList);
		if(in_array($file,$flatArray)) {
			$source = highlight_string(file_get_contents(PATH_ROOT.$file),true);
			$source = str_replace('&nbsp;','&#160;',$source);
			return($source);
		}
		return(false);
	}
	
	public function flattenFileList($fileList,$result=array(),$parentPath='/') {
		foreach($fileList as $item) {
			if($item->type == 'dir') {
				$result = $this->flattenFileList($item->files,$result,$parentPath.$item->name.'/');
			} else {
				$result[] = $parentPath.$item->name;
			}
		}
		return($result);
	}
	
	private function fileList($dir) {
		$files = array();
		if($dh = opendir($dir)) {
			while(($file = readdir($dh)) !== false) {
				if(in_array($file,$this->excludeFiles) || 
					in_array($file,array('.','..')) || 
					in_array(substr(strrchr($file,'.'),1),$this->excludeExtensions)) {
					continue;
				}			
				if(is_dir($dir.'/'.$file)) {
					$item->type = 'dir';
					$item->name = $file;
					$item->files = $this->fileList($dir.'/'.$file);
				} else {
					$item->type = 'file';
					$item->name = $file;
					$item->mtime = filemtime($dir.'/'.$file);
				}
				$files[] = $item;
				unset($item);
			}
			closedir($dh);
		}
		return($files);
	}
}
?>