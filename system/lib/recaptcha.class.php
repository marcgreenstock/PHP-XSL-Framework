<?php
class recaptcha {
	public static function challenge($challenge,$response) {		
		return(recaptcha::post(
			array(
				'privatekey'	=> reCAPTCHA_PRIVATE,
				'remoteip'		=> $_SERVER['REMOTE_ADDR'],
				'challenge'		=> $challenge,
				'response'		=> $response
			)
		));
	}
	
	public static function get_key() {
		return(reCAPTCHA_PUBLIC);
	}
	
	public static function post($data) {
		$request = null;
		foreach($data as $key => $value) {
			$request .= $key.'='.urlencode(stripslashes($value)).'&';
		}
		$request = substr($request,0,strlen($request)-1);
		
		$ch = curl_init();
		curl_setopt($ch,CURLOPT_URL,'api-verify.recaptcha.net/verify');
		curl_setopt($ch,CURLOPT_HTTP_VERSION,CURL_HTTP_VERSION_1_0);
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
		curl_setopt($ch,CURLOPT_HEADER,false);
		curl_setopt($ch,CURLOPT_POST,true);
		curl_setopt($ch,CURLOPT_USERAGENT,'reCAPTCHA/PHP');
		curl_setopt($ch,CURLOPT_HTTPHEADER,array('Content-length: '.strlen($request)));
		curl_setopt($ch,CURLOPT_POSTFIELDS,$request);
		$response = list($result,$error) = explode("\n",curl_exec($ch));
		curl_close($ch);
		return($result == 'true');
	}
}
?>