<?php
class emailFormManager {
	public function submit($fields,$to_address) {
		$fields = array_merge($fields,array(
			array('','recaptcha_challenge_field',1),
			array('','recaptcha_response_field',1)
		));
		$result->data		= array();
		$result->errors		= array();
		$result->success	= false;
		$result->recaptcha->key		= recaptcha::get_key();
		$result->recaptcha->error	= false;
		if(isset($_POST['action']) && $_POST['action'] == 'send_message') {
			list($data,$errors) = validateForm::validateDetails($fields);
			$result->data				= $data;
			$result->errors				= $errors;
			$result->recaptcha->error	= !recaptcha::challenge($data['recaptcha_challenge_field'],$data['recaptcha_response_field']);
			if(!count($errors)) {
				$mailTo = "\"Webmaster\" <".$to_address.">";
				$mailSubject = $data['subject'];
				$mailHeaders = 
					"From: \"".$data['name']."\" <".$data['email'].">\r\n".
					"MIME-Version: 1.0\r\n".
					"Content-type: text/html; charset=UTF-8\r\n";
				$mailMessage = 
					"<p>".nl2br($data['message'])."</p>\r\n".
					"<hr>\r\n".
					"<p><strong>IP Address: </strong>".$_SERVER['REMOTE_ADDR']."<br />\r\n".
					"<strong>Host Address: </strong>".gethostbyaddr($_SERVER['REMOTE_ADDR'])."<br />\r\n".
					"<strong>User Agent: </strong>".$_SERVER['HTTP_USER_AGENT']."</p>\r\n";
				mail($mailTo,$mailSubject,$mailMessage,$mailHeaders);
				$result->success = true;
			}
		}
		return($result);
	}
}
?>