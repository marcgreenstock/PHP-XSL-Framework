<?php
$blogManager = new blogManagerXML($this->db,$this->doc);
if(isset($_REQUEST['action'])) {
	switch($_REQUEST['action']) {
		case 'topic_save': {
			$topic_id = $blogManager->saveTopic($_POST['topic_id'],$_POST['topic'],$_POST['path'],$_POST['xhtml']);
			header('location: ?page=blog&mode=topic_edit&topic_id='.$topic_id);
			die();
		}
		case 'topic_delete': {
			$blogManaer->deleteTopic($_REQUEST['topic_id']);
			header('location: ?page=blog&mode=topic_list');
			die();
		}
		case 'comment_save': {
			$timestamp = date("Y-m-d H:i:s",strtotime($_POST['timestamp']));
			$comment_id = $blogManager->saveComment($_POST['comment_id'],$_POST['entry_id'],$timestamp,$_POST['ip_address'],$_POST['host_address'],$_POST['useragent'],$_POST['email'],$_POST['name'],$_POST['url'],$_POST['comment']);
			header('location: ?page=blog&mode=comment_edit&entry_id='.$_POST['entry_id'].'&comment_id='.$comment_id);
			die();
		}
		case 'comment_delete': {
			$blogManager->deleteComment($_REQUEST['comment_id']);
			header('location: ?page=blog&mode=entry_edit&entry_id='.$_REQUEST['entry_id']);
			die();
		}
		case 'entry_save': {
			$published = empty($_POST['published']) ? NULL : date("Y-m-d H:i:s",strtotime($_POST['published']));
			$entry_id = $blogManager->saveEntry($_POST['entry_id'],$_POST['created'],$published,$_POST['path'],$_POST['title'],$_POST['body']);
			$blogManager->deleteEntryTopics($entry_id);
			if(isset($_POST['topic']) && is_array($_POST['topic'])) {
				foreach($_POST['topic'] as $topic_id) {
					$blogManager->saveEntryToTopic(NULL,$entry_id,$topic_id);
				}
			}
			header('location: ?page=blog&mode=entry_edit&entry_id='.$entry_id);
			die();
		}
		case 'entry_delete': {
			$blogManager->deleteEntry($_REQUEST['entry_id']);
			header('location: ?page=blog');
			die();
		}
	}
}
$this->doc->lastChild->appendChild($blogManager->getEntries(true));
$this->doc->lastChild->appendChild($blogManager->getTopics());
?>