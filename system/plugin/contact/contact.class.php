<?php
class contact extends plugin {
	public function contactForm() {
		$emailFormManager = new emailFormManagerXML($GLOBALS['core']->doc);
		$this->node->appendChild($emailFormManager->submit(
			array(
				array('Name','name',1),
				array('Email','email',1,'email'),
				array('Subject','subject',1),
				array('Message','message',1)
			),
			EMAIL
		));
	}
}
?>