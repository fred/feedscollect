// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function changeFontSize(element,step) {
	step = parseFloat(step,10);
	var el = document.getElementById(element);
	var curFont = parseFloat(el.style.fontSize,10);
	var newFont = (curFont+step) + 'em';
	el.style.fontSize = newFont;
	return;
}