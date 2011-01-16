<?php
$ppp = new pppXML($this->db,$this->doc);
if(isset($_REQUEST['action'])) {
	switch($_REQUEST['action']) {
		case 'index_save': {
			$index_id = $ppp->saveIndex($_POST['index_id'],$_POST['index']);
			header('location: ?page=ppp&mode=index_edit&index_id='.$index_id);
			die();
		}
		case 'index_data_save': {
			$index_data_id = $ppp->saveIndexData($_POST['index_data_id'],$_POST['index_id'],$_POST['country_id'],$_POST['price']);
			header('location: ?page=ppp&mode=index_data_edit&index_id='.$_POST['index_id'].'&index_data_id='.$index_data_id);
			die();
		}
		case 'index_delete': {
			$ppp->deleteIndex($_REQUEST['index_id']);
			header('location: ?page=ppp&mode=index_list');
			die();
		}
		case 'index_data_delete': {
			$ppp->deleteIndexData($_REQUEST['index_data_id']);
			header('location: ?page=ppp&mode=index_edit&index_id='.$_REQUEST['index_id']);
			die();
		}
	}
}
$this->doc->lastChild->appendChild($ppp->getCurrencies());
$this->doc->lastChild->appendChild($ppp->getCountries());
$this->doc->lastChild->appendChild($ppp->getIndexes());
?>