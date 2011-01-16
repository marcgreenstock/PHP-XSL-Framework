<?php
class pppXML extends ppp {
	private $doc;
	
	public function __construct($db,$doc) {
		parent::__construct($db);
		$this->doc = $doc;
	}

	public function getCountries() {
		$countries = parent::getCountries();
		$countriesNode = $this->doc->createElement('countries');
		foreach($countries as $country) {
			$countryNode = $countriesNode->appendChild($this->doc->createElement('country'));
			foreach($country as $key => $val) {
				$countryNode->setAttribute($key,$val);
			}
		}
		return($countriesNode);
	}

	public function getCurrencies($include_rates=false) {
		$currencies = parent::getCurrencies($include_rates);
		$currenciesNode = $this->doc->createElement('currencies');
		foreach($currencies as $currency) {
			$currencyNode = $currenciesNode->appendChild($this->doc->createElement('currency'));
			foreach($currency as $key => $val) {
				$currencyNode->setAttribute($key,$val);
			}
		}
		return($currenciesNode);
	}
	
	public function getIndexes() {
		$indexes = parent::getIndexes();
		$indexesNode = $this->doc->createElement('indexes');
		foreach($indexes as $index) {
			$indexNode = $indexesNode->appendChild($this->doc->createElement('index'));
			$indexNode->setAttribute('index_id',$index->index_id);
			$indexNode->setAttribute('index',$index->index);
			foreach($index->data as $data) {
				$dataNode = $indexNode->appendChild($this->doc->createElement('data'));
				foreach($data as $key => $val) {
					$dataNode->setAttribute($key,$val);
				}
			}
		}
		return($indexesNode);
	}
}
?>