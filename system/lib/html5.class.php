<?php
class html5 {
	public static function transform($xml) {
		$xml = preg_replace('/<\?xml.*?>\n/is','',$xml);
		$xml = preg_replace('/xmlns="http:\/\/www.w3.org\/1999\/xhtml" /is','',$xml);
		$xml = preg_replace('/<!DOCTYPE html PUBLIC.*?>/is', '<!DOCTYPE html>', $xml);
		return($xml);
	}
}
?>