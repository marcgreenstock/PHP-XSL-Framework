<?php
class validateForm {
	static function validateDetails($fields) {
		$data = array();
		$error = array();
		for($i=0;$i<count($fields);$i++) {
			$data[$fields[$i][1]] = (isset($_POST[$fields[$i][1]]) ? trim($_POST[$fields[$i][1]]) : null);
			if($fields[$i][2] == 0) { continue; }
			if($data[$fields[$i][1]] == '') {
				$error[$fields[$i][1]] = $fields[$i][0].' can not be left empty';
			} elseif(isset($fields[$i][3])) {
				switch($fields[$i][3]) {
					case 'int': {
						if(!is_numeric($data[$fields[$i][1]])) {
							$error[$fields[$i][1]] = $fields[$i][0].' must be a number';
						}
						break;
					}
					case 'email': {
						if(!eregi("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$", $_POST[$fields[$i][1]])) {
							$error[$fields[$i][1]] = $fields[$i][0].' must be a valid email address';
						}
						break;
					}
				}
			}
		}
		return(array($data,$error));
	}
	static function writeErrors($doc,$node,$error=array()) {
		if(count($error) > 0) {
			foreach($error as $field => $msg) {
				$errorNode = $node->appendChild($doc->createElement('error',$msg));
				$errorNode->setAttribute('field',$field);
			}
			return(true);
		}
		return(false);
	}
}
?>