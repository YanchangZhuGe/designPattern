// JavaScript Document
$(function(){
	$("li.mlv2").hide();
	var v = $('.sel').children('.mlv1_a_add');
	v.removeClass();
	v.addClass('mlv1_a_subtract');
	$('.sel').parent().children('li.mlv2').show();
	$("li.mlv3").hide();
	$("a.aside_scroll_btn2").hide();
	$(".aside_wrap").css("height",$(window).height()-$("#aside_column").height()-$("#page_nav").height()-35);
	$(".aside_scroll").css("height",$(".aside_wrap").height());
	$(".aside_scroll a").css("margin-top",$(".aside_scroll").height()/2-30);
})

function page_aside_mlv1(obj){
	var cssName = $(obj).attr('class');
	if(cssName=="mlv1_a_add"){
		var v = $('.mlv1_a_subtract');
		v.parent().parent().children('li.mlv2').slideUp(300);
		v.removeClass();
		v.addClass('mlv1_a_add');
		$(obj).removeClass();
		$(obj).addClass('mlv1_a_subtract');
		$(obj).parent().parent().children("li.mlv2").slideDown(300);
	}else if(cssName=="mlv1_a_subtract"){
		$(obj).removeClass();
		$(obj).addClass('mlv1_a_add');
		$(obj).parent().parent().children("li.mlv2").slideUp(300);
	}
}

function page_aside_mlv2(obj){
	var cssName = $(obj).attr('class');

	if(cssName=="mlv2_a_add"){
		$(obj).parent().parent().children("li.mlv2").children("a").removeClass().addClass('mlv2_a_add');
		$(obj).parent().parent().children("li.mlv2").children("ul").children("li.mlv3").slideUp(300);
		$(obj).parent().parent().children("li.mlv2").css("backgroundColor","");
		$(obj).parent().parent().find("a").css("backgroundColor","");
		
		$(obj).removeClass();
		$(obj).addClass('mlv2_a_subtract');
		$(obj).next('ul').children("li.mlv3").slideDown(300);
		/*$(obj).parent().css("backgroundColor","#ffc580");*/
		$(obj).parent().css("backgroundColor","#ddeaf6");
	}else if(cssName=="mlv2_a_subtract"){
		$(obj).removeClass();
		$(obj).addClass('mlv2_a_add');
		
		$(obj).next('ul').children("li.mlv3").slideUp(300);
	}
}

function page_aside_scroll(s){
	if(s=="close"){
		$(".aside_wrap").animate({
			width:"hide"
		});
		$(".aside_scroll_btn1").hide();
		$(".aside_scroll_btn2").show();
		$("#page_listTable").animate({
			width: $("#page_listTable").width()+220
		});
	}else if(s=="open"){
		$(".aside_wrap").animate({
			width:"show"
		});
		$(".aside_scroll_btn1").show();
		$(".aside_scroll_btn2").hide();
		$("#page_listTable").animate({
			width: $("#page_listTable").width()-220
		});
	}
}