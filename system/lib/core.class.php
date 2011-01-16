<?php
class core {
	public $nav, $pathSet, $navigationSet = array();
	public $template, $plugin, $db, $doc;
	
	public function __construct() {
		$GLOBALS['core'] = &$this;
		$this->doc	= new xmlBuilder('1.0','UTF-8');
		$this->db	= new db($this->doc);
		
		$pathSetNode	= $this->setPathSet();
		$navigationNode	= $this->setNavigation();
		$pluginNodes	= $this->setPlugins();
		$contentNode	= $this->setContent();
		
		$configNode = $this->doc->createElement('config');
		$configNode->appendChild($this->setTimestamp());
		$configNode->appendChild($this->setGlobals());
		$configNode->appendChild($pathSetNode);
		$configNode->appendChild($this->setBreadcrumb());
		$configNode->appendChild($navigationNode);
		$configNode->appendChild($contentNode);
		
		foreach($pluginNodes as $pluginNode) {
			$configNode->appendChild($pluginNode);
		}
		$configNode->appendChild($this->db->getSQLNode());
		$this->doc->appendChild($configNode);
	}
	
	public function render() {
		$this->template->output($this->doc);
		return;
	}
	
	public function debugXML() {
		$this->doc->debug();
		return;
	}
	
	public function debugXSL() {
		$this->template->debug();
		return;
	}
	
	private function setTimestamp() {
		$timestampNode = $this->doc->createElement('timestamp');
		$timestampNode->setAttribute('year',date('Y'));
		$timestampNode->setAttribute('month',date('m'));
		$timestampNode->setAttribute('day',date('d'));
		$timestampNode->setAttribute('hour',date('H'));
		$timestampNode->setAttribute('minute',date('i'));
		$timestampNode->setAttribute('second',date('s'));
		return($timestampNode);
	}
	
	private function setBreadcrumb() {
		$breadcrumbNode = $this->doc->createElement('breadcrumb');
		for($i=0;$i<count($this->navigationSet);$i++) {
			$breadcrumbNode->appendChild($this->doc->createElement('item'))->setAttribute('content_id',$this->navigationSet[$i]);
			
		}
		return($breadcrumbNode);
	}
	
	private function setContent() {
		$content		= $this->nav[end($this->navigationSet)];
		$contentNode	= $this->doc->createElementFromString('content',$content->xml);
		if($content->xsl) { $this->template->appendXSL($content->xsl); }
		return($contentNode);
	}
	
	private function setNavigation() {
		$navNodes = array();
		$navNodes[0] = $this->doc->createElement('navigation');
		if($result = $this->db->query(sprintf('
			SELECT
				`content`.`content_id`,
				IF(`content`.`parent_id` IS NULL,0,`content`.`parent_id`) AS `parent_id`,
				`template`.`template`,
				`template`.`media_type`,
				`template`.`callback`,
				`content`.`variables`,
				`content`.`path`,
				`content`.`title`,
				`content`.`xml`,
				`content`.`xsl`
			FROM `%1$s`.`content`
			LEFT JOIN `%1$s`.`template` ON `content`.`template_id` = `template`.`template_id`;
		',
			DB_PREFIX.'core'
		))) {
			while($row = $result->fetch_object()) {
				$this->nav[$row->content_id] = $row;
				$navNodes[$row->content_id] = $this->doc->createElement('item');
				$navNodes[$row->content_id]->setAttribute('content_id',$row->content_id);
				$navNodes[$row->content_id]->setAttribute('parent_id',$row->parent_id);
				$navNodes[$row->content_id]->setAttribute('path',$row->path);
				$navNodes[$row->content_id]->setAttribute('title',$row->title);
				preg_match_all('/(\w+)/s',$row->variables,$variables, PREG_PATTERN_ORDER);
				$variables = array_chunk($variables[0],2);
				for($i=0;$i<count($variables);$i++) {
					$variableNode = $navNodes[$row->content_id]->appendChild($this->doc->createElement('variable'));
					$variableNode->setAttribute('name',$variables[$i][0]);
					$variableNode->setAttribute('value',$variables[$i][1]);
				}
			}
			$result->close();
			foreach($navNodes as $content_id => $item) {
				if($content_id == 0) continue;
				$navNodes[$item->getAttribute('parent_id')]->appendChild($item);
			}
		}
		$this->matchNav();
		return($navNodes[0]);
	}
	
	private function matchNav($parent_id=0,$level=0) {
		if(count($this->pathSet) <= $level) return;
		foreach($this->nav as $content_id => $item) {
			if($content_id == 0) continue;
			if($parent_id == $item->parent_id && $this->pathSet[$level] == $item->path) {
				$this->navigationSet[] = $content_id;
				$this->matchNav($content_id,$level+1);
				if(!is_null($item->template) && !$this->template) {
					$this->template = new template($item->template,$item->media_type,$item->callback);
				}
			}
		}
		return;
	}
	
	private function setPathSet() {
		$path = parse_url('http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'],PHP_URL_PATH);
		$this->pathSet = preg_split('/\//',$path,-1,PREG_SPLIT_NO_EMPTY);
		$pathSetNode = $this->doc->createElement('pathSet');
		for($i=0;$i<count($this->pathSet);$i++) {
			$pathSetNode->appendChild($this->doc->createElement('path',$this->pathSet[$i]));
		}
		array_unshift($this->pathSet,'');
		return($pathSetNode);
	}
	
	private function setGlobals() {
		$globalsNode = $this->doc->createElement('globals');
		$this->setGlobalVar(array(
			'PHP_VERSION'=>phpversion(),
			'HTTP_USER_AGENT'=>@$_SERVER['HTTP_USER_AGENT'],
			'REMOTE_ADDR'=>@$_SERVER['REMOTE_ADDR']
		),'server',$globalsNode);
		$this->setGlobalVar($_POST,'post',$globalsNode);
		$this->setGlobalVar($_GET,'get',$globalsNode);
		$this->setGlobalVar($_COOKIE,'cookie',$globalsNode);
		return($globalsNode);
	}
	
	private function setGlobalVar($array,$type,$parentNode) {
		if(!is_array($array)) return;
		foreach($array as $key => $val) {
			$itemNode = $parentNode->appendChild($this->doc->createElement('item'));
			$itemNode->setAttribute('key',$key);
			$itemNode->setAttribute('type',$type);
			if(is_array($val)) {
				$this->setGlobalVar($val,$type,$itemNode);
			} else {
				$itemNode->setAttribute('value',$val);
			}
		}
		return;
	}
	
	private function setPlugins() {
		$pluginNodes = $plugins = array();
		if($result = $this->db->query(sprintf('
			SELECT
				`plugin`.`plugin_id`,
				`plugin`.`plugin`,
				`plugin_method`.`plugin_method_id`,
				`plugin_method`.`method`,
				`plugin_method_2_content`.`plugin_method_2_content_id`,
				`plugin_method_2_content`.`content_id`,
				`plugin_method_2_content`.`inherit`,
				`plugin_method_2_content`.`sequence`
			FROM `%1$s`.`plugin_method_2_content`
			LEFT JOIN `%1$s`.`plugin_method` USING (`plugin_method_id`)
			LEFT JOIN `%1$s`.`plugin` USING (`plugin_id`)
			WHERE 1
				AND `plugin_method_2_content`.`content_id` = %2$d
				OR (`plugin_method_2_content`.`content_id` IN (%3$s)
				AND `plugin_method_2_content`.`inherit` = 1)
			ORDER BY `plugin_method_2_content`.`sequence` ASC;
		',
			DB_PREFIX.'core',
			end($this->navigationSet),
			implode(',',$this->navigationSet)
		))) {
			while($row = $result->fetch_object()) {
				$plugins[$row->content_id][] = $row;
			}
			$result->close();
		}
		foreach($this->navigationSet as $content_id) {
			if(!isset($plugins[$content_id])) continue;
			foreach($plugins[$content_id] as $plugin) {
				$node = $this->doc->createElement('plugin');
				foreach($plugin as $key => $val) {
					$node->setAttribute($key,$val);
				}
				if(!isset($this->plugin->{$plugin->plugin})) {
					$xslt = PATH_PLUGIN.'/'.$plugin->plugin.'/'.$plugin->plugin.'.xsl';
					if(is_file($xslt)) {
						$this->template->includeXSL($xslt);
					}
					$this->plugin->{$plugin->plugin} = new $plugin->plugin();
				}
				$this->plugin->{$plugin->plugin}->node = $node;
				$this->plugin->{$plugin->plugin}->details = $plugin;
				$this->plugin->{$plugin->plugin}->{$plugin->method}();
				$pluginNodes[] = $node;
			}
		}
		return($pluginNodes);
	}
}
?>