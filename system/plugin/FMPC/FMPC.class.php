<?php
class FMPC extends plugin {
	public function calculator() {
		$this->ppp = new pppXML($GLOBALS['core']->db,$GLOBALS['core']->doc);
		$this->node->appendChild($this->ppp->getCountries());
		$this->node->appendChild($this->ppp->getCurrencies(true));
		$this->node->appendChild($this->ppp->getIndexes());
		return;
	}
}
?>