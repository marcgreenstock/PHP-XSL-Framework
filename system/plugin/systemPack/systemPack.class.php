<?php
class systemPack extends plugin {
	public function createArchive() {
		$fileManager = new fileManager();
		$fileList = $fileManager->flattenFileList($fileManager->getFileList(PATH_ROOT));
		
		$archive = tempnam(null,'zip');
		$zip = new ZipArchive();
		$zip->open($archive,ZipArchive::OVERWRITE);
		foreach($fileList as $file) {
			$zip->addFile($file);
		}
		$zip->close();
	}
}
?>