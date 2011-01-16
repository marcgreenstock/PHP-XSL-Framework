<?php
class blogManager {
	private $db;
	
	public function __construct($db) {
		$this->db = $db;
	}
	
	public function storeUserComment() {
		$fields = array(
			array('Name','name',1),
			array('Email','email',1,'email'),
			array('URL','url',0,'url'),
			array('Comment','comment',1),
			array('','entry_id',1,'int'),
			array('','recaptcha_challenge_field',1),
			array('','recaptcha_response_field',1)
		);
		$result->data	= array();
		$result->errors	= array();
		$result->recaptcha->key		= recaptcha::get_key();
		$result->recaptcha->error	= false;
		if(isset($_POST['action']) && $_POST['action'] == 'post_comment') {
			list($data,$errors) = validateForm::validateDetails($fields);
			$result->data				= $data;
			$result->errors				= $errors;
			$result->recaptcha->error	= !recaptcha::challenge($data['recaptcha_challenge_field'],$data['recaptcha_response_field']);
			if(!count($errors)) {
				$data['comment'] = '<p>'.nl2br(htmlentities($data['comment'],ENT_NOQUOTES,'UTF-8')).'</p>';
				$data['comment'] = preg_replace('@(https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?)@', '<a href="$1">$1</a>', $data['comment']);
				
				$result->comment_id = $this->saveComment(
					null,
					$data['entry_id'],
					null,
					$_SERVER['REMOTE_ADDR'],
					gethostbyaddr($_SERVER['REMOTE_ADDR']),
					$_SERVER['HTTP_USER_AGENT'],
					$data['email'],
					$data['name'],
					$data['url'],
					$data['comment']
				);
			}
		}		
		return($result);
	}
	
	public function getEntries($admin=false) {
		$entries = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`entry`.`entry_id`,
				`entry`.`created`,
				`entry`.`published`,
				`entry`.`title`,
				`entry`.`path`,
				`entry`.`body`
			FROM `%1$s`.`entry`
			ORDER BY `entry`.`created` DESC;
		',
			DB_PREFIX.'blog'
		))) {
			while($row = $result->fetch_object()) {
				$entries[$row->entry_id] = $row;
				$entries[$row->entry_id]->comments = $this->getCommentsByEntryId($row->entry_id,$admin);
				$entries[$row->entry_id]->topics = $this->getTopicsByEntryId($row->entry_id);
			}
			$result->close();
		}
		return($entries);
	}
	
	public function getTopics() {
		$topics = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`topic`.`topic_id`,
				`topic`.`topic`,
				`topic`.`path`,
				`topic`.`xhtml`
			FROM `%1$s`.`topic`;
		',
			DB_PREFIX.'blog'
		))) {
			while($row = $result->fetch_object()) {
				$topics[$row->topic_id] = $row;
			}
			$result->close();
		}
		return($topics);
	}
	
	public function getCommentsByEntryId($entry_id,$admin=false) {
		$comments = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`comment`.`comment_id`,
				`comment`.`timestamp`,'.
				($admin ?
				'
				`comment`.`ip_address`,
				`comment`.`host_address`,
				`comment`.`useragent`,
				`comment`.`email`,
				'
				: NULL)
				.'
				`comment`.`name`,
				`comment`.`url`,
				`comment`.`comment`
			FROM `%1$s`.`comment`
			WHERE `comment`.`entry_id` = %2$d
			ORDER BY `comment`.`timestamp` ASC;
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($entry_id)
		))) {
			while($row = $result->fetch_object()) {
				$comments[$row->comment_id] = $row;
			}
			$result->close();
		}
		return($comments);
	}
	
	public function getTopicsByEntryId($entry_id) {
		$topics = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`entry_2_topic`.`entry_2_topic_id`,
				`entry_2_topic`.`topic_id`
			FROM `%1$s`.`entry_2_topic`
			WHERE `entry_2_topic`.`entry_id` = %2$d;
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($entry_id)
		))) {
			while($row = $result->fetch_object()) {
				$topics[] = $row;
			}
			$result->close();
		}
		return($topics);
	}
	
	public function saveTopic($topic_id,$topic,$path,$xhtml) {
		$this->db->query(sprintf('
			REPLACE INTO `%1$s`.`topic` SET
				`topic_id` = %2$d,
				`topic` = "%3$s",
				`path` = "%4$s",
				`xhtml` = "%5$s";
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($topic_id),
			$this->db->escape_string($topic),
			$this->db->escape_string($path),
			$this->db->escape_string($xhtml)
		));
		return($this->db->insert_id);
	}
	
	public function deleteTopic($topic_id) {
		$this->db->multi_query(sprintf('
			DELETE FROM `%1$s`.`topic`
			WHERE `topic_id` = %2$d;
			
			DELETE FROM `%1$s`.`entry_2_topic`
			WHERE `topic_id` = %2$d;
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($topic_id)
		));
		return(true);
	}
	
	public function saveComment($comment_id,$entry_id,$timestamp,$ip_address,$host_address,$useragent,$email,$name,$url,$comment) {
		$this->db->query(sprintf('
			REPLACE INTO `%1$s`.`comment` SET
				`comment_id` = %2$d,
				`entry_id` = %3$d,
				`timestamp` = IF("%4$s" != "","%4$s",NOW()),
				`ip_address` = "%5$s",
				`host_address` = "%6$s",
				`useragent` = "%7$s",
				`name` = "%8$s",
				`email` = "%9$s",
				`url` = "%10$s",
				`comment` = "%11$s";
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($comment_id),
			$this->db->escape_string($entry_id),
			$this->db->escape_string($timestamp),
			$this->db->escape_string($ip_address),
			$this->db->escape_string($host_address),
			$this->db->escape_string($useragent),
			$this->db->escape_string($name),
			$this->db->escape_string($email),
			$this->db->escape_string($url),
			$this->db->escape_string($comment)
		));
		return($this->db->insert_id);
	}
	
	public function deleteComment($comment_id) {
		$this->db->query(sprintf('
			DELETE FROM `%1$s`.`comment`
			WHERE `comment_id` = %2$d;
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($comment_id)
		));
		return(true);
	}
	
	public function saveEntry($entry_id,$created,$published,$path,$title,$body) {
		$this->db->query(sprintf('
			REPLACE INTO `%1$s`.`entry` SET
				`entry_id` = %2$d,
				`created` = IF("%3$s" != "","%3$s",NOW()),
				`published` = IF("%4$s" != "","%4$s",NULL),
				`path` = "%5$s",
				`title` = "%6$s",
				`body` = "%7$s";
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($entry_id),
			$this->db->escape_string($created),
			$this->db->escape_string($published),
			$this->db->escape_string($path),
			$this->db->escape_string($title),
			$this->db->escape_string($body)
		));
		return($this->db->insert_id);
	}
	
	public function deleteEntry($entry_id) {
		$this->db->multi_query(sprintf('
			DELETE FROM `%1$s`.`entry`
			WHERE `entry_id` = %2$d;
			
			DELETE FROM `%1$s`.`comment`
			WHERE `entry_id` = %2$d;
			
			DELETE FROM `%1$s`.`entry_2_topic`
			WHERE `entry_id` = %2$d;
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($entry_id)
		));
		return(true);
	}
	
	public function deleteEntryTopics($entry_id) {
		$this->db->query(sprintf('
			DELETE FROM `%1$s`.`entry_2_topic`
			WHERE `entry_id` = %2$d;
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($entry_id)
		));
		return(true);
	}
	
	public function saveEntryToTopic($entry_2_topic_id,$entry_id,$topic_id) {
		$this->db->query(sprintf('
			REPLACE INTO `%1$s`.`entry_2_topic` SET
				`entry_2_topic_id` = %2$d,
				`entry_id` = %3$d,
				`topic_id` = %4$d;
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($entry_2_topic_id),
			$this->db->escape_string($entry_id),
			$this->db->escape_string($topic_id)
		));
		return($this->db->insert_id);
	}
	
	public function deleteEntryToTopic($entry_2_topic_id) {
		$this->db->query(sprintf('
			DELETE FROM `%1$s`.`entry_2_topic`
			WHERE `entry_2_topic_id` = %2$d;
		',
			DB_PREFIX.'blog',
			$this->db->escape_string($entry_2_topic_id)
		));
		return($this->db->insert_id);
	}
}
?>