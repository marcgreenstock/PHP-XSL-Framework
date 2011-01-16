<?php
class adminContent extends admin {
	private $xslt;
	private $doc;
	
	public function __construct() {
		parent::__construct();
		$this->doc = new xmlBuilder('1.0','UTF-8');
		$this->doc->appendChild($this->doc->createElement('config'));
		$this->setGlobals();
	}
	
	public function __destruct() {
		$this->db->close();
		return;
	}
	
	public function loadXSL($xslFile) {
		$this->xslt = new DOMDocument('1.0','UTF-8');
		$this->xslt->load($xslFile);
	}
	
	public function render() {
		$xsl = new XSLTProcessor();
		$xsl->registerPHPFunctions();
		$xsl->importStyleSheet($this->xslt);
		print $xsl->transformToXML($this->doc);
		return;
	}
	
	public function debug() {
		$this->doc->formatOutput = true;
		header("Content-type: text/xml");
		print $this->doc->saveXML();
		return;
	}
	
	public function loadContent($contentDir) {
		$this->db->query(sprintf('
			INSERT DELAYED INTO `%1$s`.`admin_log` SET
				`admin_id` = %2$d,
				`timestamp` = NOW(),
				`request` = "%3$s";
		',
			DB_PREFIX.'core',
			$this->user->admin_id,
			$this->db->escape_string($_SERVER['REQUEST_URI'])
		));
		$page = (isset($_REQUEST['page']) ? $_REQUEST['page'] : 'home');
		if(($phpFile = $contentDir.'/'.$page.'/'.$page.'.php') && is_file($phpFile)) {
			include($phpFile);
		}
		if(($xslFile = $contentDir.'/'.$page.'/'.$page.'.xsl') && is_file($xslFile)) {
			$xslInclude = $this->xslt->firstChild->appendChild($this->xslt->createElementNS('http://www.w3.org/1999/XSL/Transform','xsl:include'));
			$xslInclude->setAttribute('href',$xslFile);
		}
		return;
	}
	
	public function row2config($row,$name) {
		$node = $this->doc->lastChild->appendChild($this->doc->createElement($name));
		foreach($row as $key => $val) {
			$node->setAttribute($key,$val);
		}
		return($node);
	}
	
	private function setGlobals() {
		if(isset($_REQUEST['page'])) { $this->doc->lastChild->setAttribute('page',$_REQUEST['page']); }
		if(isset($_REQUEST['mode'])) { $this->doc->lastChild->setAttribute('mode',$_REQUEST['mode']); }
		$node = $this->doc->lastChild->appendChild($this->doc->createElement('globals'));
		$this->setGlobalVar(array(
			'HTTP_USER_AGENT'=>$_SERVER['HTTP_USER_AGENT'],
			'REMOTE_ADDR'=>$_SERVER['REMOTE_ADDR']
			),'server',$node);
		$this->setGlobalVar($_POST,'post',$node);
		$this->setGlobalVar($_GET,'get',$node);
		$this->setGlobalVar($_COOKIE,'cookie',$node);
		return;
	}
	
	private function setGlobalVar($array,$type,$parentNode) {
		if(!is_array($array)) return;
		foreach($array as $key => $val) {
			$itemNode = $parentNode->appendChild($this->doc->createElement('item'));
			$itemNode->setAttribute('key',$key);
			$itemNode->setAttribute('type',$type);
			if(is_array($val)) {
				$this->setGlobalVar($val,$type,$itemNode);
			} else {
				$itemNode->setAttribute('value',$val);
			}
		}
		return;
	}
}
?>