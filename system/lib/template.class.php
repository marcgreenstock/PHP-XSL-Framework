<?php
class template {
	private $xslt, $media_type, $callback;
	
	public function __construct($template,$media_type,$callback) {
		$this->xslt = new DOMDocument();
		$this->xslt->load(PATH_TEMPLATE.'/'.$template.'/'.$template.'.xsl');
		$this->media_type = $media_type;
		$this->callback = $callback;
	}
	
	public function output($doc) {
		header('Content-type: '.$this->media_type);
		print $this->render($doc);
	}
	
	public function render($doc) {
		$xsl = new XSLTProcessor();
		$xsl->registerPHPFunctions();
		$xsl->setParameter('','PATH_ROOT',PATH_ROOT);
		$xsl->importStyleSheet($this->xslt);
		$xml = $xsl->transformToXML($doc);
		if($this->callback) {
			$xml = call_user_func($this->callback,$xml);
		}
		return($xml);
	}
	
	public function debug() {
		header("Content-type: text/xml");
		$this->xslt->formatOutput = true;
		print $this->xslt->saveXML();
		return;
	}
	
	public function includeXSL($file) {
		$xslInclude = $this->xslt->firstChild->appendChild($this->xslt->createElementNS('http://www.w3.org/1999/XSL/Transform','xsl:include'));
		$xslInclude->setAttribute('href',$file);
	}
	
	public function appendXSL($xsl) {
		$contentXSL = new DOMDocument('1.0','UTF-8');
		$contentXSL->loadXML('<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">'.$xsl.'</xsl:stylesheet>');
		foreach($contentXSL->firstChild->childNodes as $node) {
			if($node->nodeType == XML_ELEMENT_NODE) {
				$this->xslt->firstChild->appendChild($this->xslt->importNode($node,true));
			}
		}
		return;
	}
}
?>