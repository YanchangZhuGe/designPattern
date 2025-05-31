// JavaScript Document

$(function(){
	$(window).resize(function(){
		$(".aside_wrap").css("height",$(window).height()-$("#page_header").height()-$("#page_nav").height()-50);
		$(".aside_scroll").css("height",$(".aside_wrap").height());
		$(".aside_scroll a").css("margin-top",$(".aside_scroll").height()/2-30);
		
		$("#page_listTable").css("width",$(window).width()-$("#page_aside").width()-20);
		$("#page_listTable").css("height",$(window).height()-$("#page_header").height()-$("#page_nav").height()-35);
		$(".list_body").css("height",$("#page_listTable").height()-$(".list_header").height()-34);
		$(".list_scroll").css("height",$(".list_body").height()-$(".list_ctrlBtn").height()-$(".list_pageNum").height());
	})
})



	