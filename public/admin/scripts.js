function setPath(title,path) {
	var string = title.toLowerCase();
	string = string.replace(/[^a-z0-9\ ]/g,'');
	string = string.replace(/ +/g,'-');
	document.getElementById('path').value = string;
}