<?php
class blogManagerXML extends blogManager {
	private $doc;
	
	public function __construct($db,$doc) {
		parent::__construct($db);
		$this->doc = $doc;
	}
	
	public function storeUserComment() {
		$result = parent::storeUserComment();
		$storeCommentNode = $this->doc->createElement('storeComment');	
		foreach($result->errors as $field => $error) {
			$errorNode = $storeCommentNode->appendChild($this->doc->createElement('error',$error));
			$errorNode->setAttribute('field',$field);
		}
		$recaptchaNode = $storeCommentNode->appendChild($this->doc->createElement('recaptcha'));
		$recaptchaNode->setAttribute('public_key',$result->recaptcha->key);
		$recaptchaNode->setAttribute('error',$result->recaptcha->error ? 'yes' : 'no');
		if(isset($result->comment_id)) {
			$storeCommentNode->setAttribute('success','yes');
		}
		return($storeCommentNode);
	}
	
	public function getEntries($admin=false) {
		$entries = parent::getEntries($admin);
		$entriesNode = $this->doc->createElement('entries');
		foreach($entries as $entry) {
			$entryNode = $entriesNode->appendChild($this->doc->createElement('entry'));
			$entryNode->setAttribute('entry_id',$entry->entry_id);
			$entryNode->setAttribute('title',$entry->title);
			$entryNode->setAttribute('path',$entry->path);
			$entryNode->setAttribute('created',$entry->created);
			$entryNode->setAttribute('published',$entry->published);
			/* Add Date Node */
			$timestamp = strtotime(empty($entry->published) ? $entry->created : $entry->published);
			$dateNode = $entryNode->appendChild($this->doc->createElement('date'));
			$dateNode->setAttribute('year',date('Y',$timestamp));
			$dateNode->setAttribute('month',date('m',$timestamp));
			$dateNode->setAttribute('day',date('d',$timestamp));
			$dateNode->setAttribute('hour',date('H',$timestamp));
			$dateNode->setAttribute('minute',date('i',$timestamp));
			$dateNode->setAttribute('second',date('s',$timestamp));
			/* Add Blog Body XHTML */
			$entryNode->appendChild($this->doc->createElementFromString('xhtml',$entry->body));
			$entryNode->appendChild($this->doc->createElement('text'))->appendChild($this->doc->createCDataSection($entry->body));
			/* Topics */
			foreach($entry->topics as $topic) {
				$topicNode = $entryNode->appendChild($this->doc->createElement('topic'));
				$topicNode->setAttribute('entry_2_topic_id',$topic->entry_2_topic_id);
				$topicNode->setAttribute('topic_id',$topic->topic_id);
			}
			/* User Comments */
			foreach($entry->comments as $comment) {
				$commentNode = $entryNode->appendChild($this->doc->createElement('comment'));
				$commentNode->setAttribute('comment_id',$comment->comment_id);
				$commentNode->setAttribute('name',$comment->name);
				$commentNode->setAttribute('url',$comment->url);
				$commentNode->setAttribute('timestamp',$comment->timestamp);
				if($admin) {
					$commentNode->setAttribute('ip_address',$comment->ip_address);
					$commentNode->setAttribute('host_address',$comment->host_address);
					$commentNode->setAttribute('useragent',$comment->useragent);
					$commentNode->setAttribute('email',$comment->email);
				}
				/* Add Date Node */
				$timestamp = strtotime($comment->timestamp);
				$dateNode = $commentNode->appendChild($this->doc->createElement('date'));
				$dateNode->setAttribute('year',date('Y',$timestamp));
				$dateNode->setAttribute('month',date('m',$timestamp));
				$dateNode->setAttribute('day',date('d',$timestamp));
				$dateNode->setAttribute('hour',date('H',$timestamp));
				$dateNode->setAttribute('minute',date('i',$timestamp));
				$dateNode->setAttribute('second',date('s',$timestamp));
				/* Add Comment XHTML */
				$commentNode->appendChild($this->doc->createElementFromString('xhtml',$comment->comment));
				$commentNode->appendChild($this->doc->createElement('text'))->appendChild($this->doc->createCDataSection($comment->comment));
			}
		}
		return($entriesNode);
	}
	
	public function getTopics() {
		$topics = parent::getTopics();
		$topicsNode = $this->doc->createElement('topics');
		foreach($topics as $topic) {
			$topicNode = $topicsNode->appendChild($this->doc->createElement('topic'));
			$topicNode->setAttribute('topic_id',$topic->topic_id);
			$topicNode->setAttribute('topic',$topic->topic);
			$topicNode->setAttribute('path',$topic->path);
			$topicNode->appendChild($this->doc->createElementFromString('xhtml',$topic->xhtml));
			$topicNode->appendChild($this->doc->createElement('text'))->appendChild($this->doc->createCDataSection($topic->xhtml));
		}
		return($topicsNode);
	}
}
?>