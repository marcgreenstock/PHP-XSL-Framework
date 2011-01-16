/* Suckerfish Menu */
sfHover = function() {
	var sfEls = document.getElementById("nav").getElementsByTagName("LI");
	for (var i=0; i<sfEls.length; i++) {
		sfEls[i].onmouseover=function() {
			this.className+=" sfhover";
		}
		sfEls[i].onmouseout=function() {
			this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
		}
	}
}
if (window.attachEvent) window.attachEvent("onload", sfHover);
/* Recaptcha */
var RecaptchaOptions = {
	theme: 'custom',
	lang: 'en',
	custom_theme_widget: 'recaptcha_widget'
};
/* Input corners */
function roundCorners() {
	var forms = document.getElementsByTagName('FORM');
	for(var i=0;i<forms.length;i++) {
		var inputs = forms[i].elements;
		var num_inputs = inputs.length;
		for(var x=0;x<num_inputs;x++) {
			if(
				inputs[x].type == 'text' ||
				inputs[x].type == 'textarea' ||
				inputs[x].type == 'password' ||
				inputs[x].type == 'select-one' ||
				inputs[x].type == 'select-multiple'
			) {
				var inputNode	= inputs[x];
				var parentNode	= inputNode.parentNode;
				var container	= parentNode.insertBefore(document.createElement('span'),inputNode);
				
				parentNode.removeChild(inputNode);
				
				container.setAttribute('class','input-border');
				container.appendChild(document.createElement('span')).setAttribute('class','input-border-tl');
				container.appendChild(document.createElement('span')).setAttribute('class','input-border-tr');
				container.appendChild(inputNode);
				container.appendChild(document.createElement('span')).setAttribute('class','input-border-bl');
				container.appendChild(document.createElement('span')).setAttribute('class','input-border-br');
			}
		}
	}
	return;
}