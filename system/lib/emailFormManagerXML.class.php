<?php
class emailFormManagerXML extends emailFormManager {
	private $doc;
	
	public function __construct($doc) {
		$this->doc = $doc;
	}

	public function submit($fields,$to_address) {
		$result = parent::submit($fields,$to_address);
		$formSubmitNode = $this->doc->createElement('formSubmit');	
		foreach($result->errors as $field => $error) {
			$errorNode = $formSubmitNode->appendChild($this->doc->createElement('error',$error));
			$errorNode->setAttribute('field',$field);
		}
		$recaptchaNode = $formSubmitNode->appendChild($this->doc->createElement('recaptcha'));
		$recaptchaNode->setAttribute('public_key',$result->recaptcha->key);
		$recaptchaNode->setAttribute('error',$result->recaptcha->error ? 'yes' : 'no');
		$formSubmitNode->setAttribute('success',$result->success ? 'yes' : 'no');
		return($formSubmitNode);
	}
}
?>