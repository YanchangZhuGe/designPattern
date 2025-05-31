// JavaScript Document
// need link jQuery.js first

$(function(){
	$(".nav ul.navLv1>li").mouseover(function(){
		$(".nav ul.navLv2").hide();
		$(this).children('ul').show();
	});
	$(".nav ul.navLv2").mouseleave(function(){
		$(this).hide();
	});
})