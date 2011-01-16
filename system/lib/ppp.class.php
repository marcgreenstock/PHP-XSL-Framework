<?php
class ppp {
	private $db;
	private $currencies;
	
	public function __construct($db) {
		$this->db = $db;
	}

	public function getCountries() {
		$countries = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`country`.`country_id`,
				`country`.`currency_id`,
				`country`.`ISO`,
				`country`.`country`
			FROM `%1$s`.`country`
			WHERE `country_id` IN (
				SELECT `index_data`.`country_id`
				FROM `%1$s`.`index_data`
			);
		',
			DB_PREFIX.'ppp'
		))) {
			while($row = $result->fetch_object()) {
				$countries[] = $row;
			}
		}
		return($countries);
	}
	
	public function getIndexes() {
		$indexes = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`index`.`index_id`,
				`index`.`index`
			FROM `%1$s`.`index`
			ORDER BY `index`.`index_id` ASC;
		',
			DB_PREFIX.'ppp'
		))) {
			while($row = $result->fetch_object()) {
				$row->data = $this->getIndexData($row->index_id);
				$indexes[] = $row;
			}
			$result->close();
		}
		return($indexes);
	}
	
	public function getIndexData($index_id) {
		$data = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`index_data`.`index_data_id`,
				`index_data`.`index_id`,
				`index_data`.`country_id`,
				`index_data`.`price`
			FROM `%1$s`.`index_data`
			WHERE `index_data`.`index_id` = %2$d;
		',
			DB_PREFIX.'ppp',
			$this->db->escape_string($index_id)
		))) {
			while($row = $result->fetch_object()) {			
				$data[] = $row;
			}
			$result->close();
		}
		return($data);
	}
	
	public function getCurrencies($include_rates=false) {
		if($include_rates) {
			$rates = $this->getExchangeRates();
		} else {
			$rates = array();
		}
		$currencies = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`currency`.`currency_id`,
				`currency`.`code`,
				`currency`.`name_singular`,
				`currency`.`name_plural`,
				`currency`.`symbol`,
				`currency`.`position`
			FROM `%1$s`.`currency`
		',
			DB_PREFIX.'ppp'
		))) {
			while($row = $result->fetch_object()) {
				if(isset($rates[$row->code])) {
					$row->rate = $rates[$row->code];
				}
				$currencies[] = $row;
			}
			$result->close();
		}
		return($currencies);
	}
	
	public function saveIndex($index_id,$index) {
		$this->db->query(sprintf('
			REPLACE INTO `%1$s`.`index` SET
				`index_id` = %2$d,
				`index` = "%3$s";
		',
			DB_PREFIX.'ppp',
			$this->db->escape_string($index_id),
			$this->db->escape_string($index)
		));
		return($this->db->insert_id);
	}
	
	public function saveIndexData($index_data_id,$index_id,$country_id,$price) {
		$this->db->query(sprintf('
			REPLACE INTO `%1$s`.`index_data` SET
				`index_data_id` = %2$d,
				`index_id` = %3$d,
				`country_id` = %4$d,
				`price` = "%5$f";
		',
			DB_PREFIX.'ppp',
			$this->db->escape_string($index_data_id),
			$this->db->escape_string($index_id),
			$this->db->escape_string($country_id),
			$this->db->escape_string($price)
		));
		return($this->db->insert_id);
	}
	
	public function deleteIndex($index_id) {
		$this->db->multi_query(sprintf('
			DELETE FROM `%1$s`.`index_data`
			WHERE `index_id` = %2$d;
			
			DELETE FROM `%1$s`.`index`
			WHERE `index_id` = %2$d;
		',
			DB_PREFIX.'ppp',
			$this->db->escape_string($index_id)
		));
		return(true);
	}
	
	public function deleteIndexData($index_data_id) {
		$this->db->query(sprintf('
			DELETE FROM `%1$s`.`index_data`
			WHERE `index_data_id` = %2$d;
		',
			DB_PREFIX.'ppp',
			$this->db->escape_string($index_data_id)
		));
		return(true);
	}
	
	private function getExchangeRates() {
		$rates = array();
		$ch = curl_init();
		curl_setopt($ch,CURLOPT_URL,'http://api.finance.xaviermedia.com/api/latest.xml');
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
		curl_setopt($ch,CURLOPT_HEADER,false);
		curl_setopt($ch,CURLOPT_USERAGENT,'cURL in PHP 5.2');
		$result = curl_exec($ch);
		curl_close($ch);
		$xml = new DOMDocument('1.0','UTF-8');
		$xml->loadXML($result);
		$rateNodes = $xml->getElementsByTagName('fx');
		foreach($rateNodes as $rateNode) {
			$rates[$rateNode->getElementsByTagName('currency_code')->item(0)->nodeValue] = $rateNode->getElementsByTagName('rate')->item(0)->nodeValue;
		}
		$rates = $this->convertRates($rates,'EUR','USD');
		return($rates);
	}
	
	private function convertRates($rates,$from,$to) {
		$base_rate = 1 / $rates[$to];
		foreach($rates as $code => $rate) {
			$rates[$code] = $base_rate * $rate;
		}
		return($rates);
	}
}
?>