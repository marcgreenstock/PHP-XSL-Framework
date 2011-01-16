<?php
class db extends mysqli {
	private $doc;
	private $sqlNode;
	
	public function __construct($doc) {
		parent::__construct(DB_HOST,DB_USER,DB_PASS);
		$this->doc = $doc;
		$this->sqlNode = $this->doc->createElement('sql');
	}
	
	public function getSQLNode() {
		return($this->sqlNode);
	}
	
	public function query($query) {
		$result = parent::query($query);
		$queryNode = $this->sqlNode->appendChild($this->doc->createElement('query'));
		$queryNode->appendChild($this->doc->createCDataSection($query));
		$queryNode->setAttribute('num_rows',@$result->num_rows);
		$queryNode->setAttribute('error',@$this->error);
		$queryNode->setAttribute('info',@$this->info);
		return($result);
	}
	
	public function multi_query($query) {
		$result = parent::multi_query($query);
		$queryNode = $this->sqlNode->appendChild($this->doc->createElement('multi_query'));
		$queryNode->appendChild($this->doc->createCDataSection($query));
		return($result);
	}
	
	public function selectAll($database,$table,$where) {
		$result = $this->query(sprintf('
			SELECT * FROM `%1$s`.`%2$s` WHERE %3$s;
		',
			$database,$table,$where
		));
		return($result);
	}
}
?>