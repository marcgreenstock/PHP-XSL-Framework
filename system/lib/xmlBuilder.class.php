<?php
class xmlBuilder extends DOMDocument {
	public function createElementFromString($name,$string) {
		$doc = new DOMDocument('1.0','UTF-8');
		$doc->preserveWhiteSpace = false;	
		$loadResult = @$doc->loadXML('<'.$name.'>'.$string.'</'.$name.'>');
		if($loadResult) {
			$doc->firstChild->setAttribute('parsable','1');
			return($this->importNode($doc->firstChild,true));
		}
		$cdata = $this->createElement($name);
		$cdata->appendChild($this->createCDATASection($string));
		$cdata->setAttribute('parsable','0');
		return($cdata);
	}
	
	public function debug() {
		header("Content-type: text/xml");
		$this->formatOutput = true;
		print $this->saveXML();
		return;
	}
}
?>