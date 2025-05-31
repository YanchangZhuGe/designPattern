var X;
var Y;
var li_size;
var int_val;
var permition = true;
var height_size;
var li_child;
var main_nav;
var coloring;
var back = true;
var null_;
var part = 0;

$(document).ready(function(){
	
	main_nav = $('div.navigation>ul').html();    //Main Navigation HTML

	//$('div.navigation>div').html($('div.navigation>div').html() + '<div id = "back"></div>');   // Back button
	
	$('#title').html($('#title').html()+ '<div id = "back"></div>'); 
	/** (div.navigation>ul>li).click() **/
	$("div.navigation>ul>li").live('click', function(){
		if(permition == true && $(this).children('ul').html().length){
			
			int_val = 300;
			Y =  $(this).children("a").html();
			li_size = $("div.navigation>ul>li").size();
						
			for(i = 1; i <= li_size; i++){		
				
				X = $("div.navigation>ul>li:nth-child(" + String(i) +")").children("a").html();				
						if(X != Y)
							
							$("div.navigation>ul>li:nth-child(" + String(i) +")").addClass('animated flipIn_left');
							
							setTimeout(function(){
								$("div.navigation>ul>li:nth-child(" + String(i) +")").removeClass('animated flipIn_left');
							}, int_val);
							
					int_val = 300 * i;
					
			} // /End for
			  
			$('div.navigation>ul').animate({opacity : '0.1', marginLeft : '40px'}, 600);  
			  
			$("div.navigation>div>span").animate({opacity : '0.1', top : '-10px'}, 600, function(){
				$("div.navigation>div>span").html(Y);
				$("div.navigation>div>span").animate({opacity : '1', top : '0px'}, 600);
			});
	
			permition = false;
			back = true;
			li_child = $(this).children('ul').html();
			
			coloring = $(this).css("background-color"); // color variable use
			
			setTimeout(function(){
				$('div.navigation>ul').html(li_child);
				$('div#back').show(300);
				$('div.navigation>ul>li').css('background-color', '0033FF'); // Coloring li
				$('div.navigation>ul').animate({opacity : '1', marginLeft : '0px'}, 600);
				$('div.navigation>ul>li').addClass('animated flipIn_right_back');
				
				setTimeout(function(){
						$('div.navigation>ul>li').removeClass('animated flipIn_right_back');
					}, 600);
				
			}, 600);
			
		}
	}); /** /End (div.navigation>ul>li).click() **/

	
	
	
	

	
	
	/** Back Mouse enter **/
	$("div#back").mouseenter(function(){
		$('div#back').css('background-position', '50px -50px');
	});
	
	
	/** Back Mouse Leave **/
	$("div#back").mouseleave(function(){
		$('div#back').css('background-position', '0px 0px');
	});
	
	
	/** Back Mouse Down **/
	$("div#back").mousedown(function(){
		$('div#back').css('background-position', '50px -100px');
	});
	
	
	/** Back Mouse Up **/
	$("div#back").mouseup(function(){
		$('div#back').css('background-position', '50px -50px');
	});
	
	
	/** div#back click **/
	$("div#back").live('click', function(){

		if(back == true){
			$('div.navigation>ul>li').addClass('animated flipIn_left');
			$('div.navigation>ul').animate({opacity : '0.1', marginLeft : '40px'}, 400);
		
			setTimeout(function(){
				
				$('div.navigation>ul').html(main_nav);
				load();
				$('div.navigation>ul>li').addClass('animated flipIn_right_back');
				
				$('div.navigation>ul').animate({opacity : '1', marginLeft : '0px'}, 600);
				$("div#back").hide(300);
				
					setTimeout(function(){
						$('div.navigation>ul>li').removeClass('animated flipIn_right_back');
					}, 400);
				
			}, 400);
			permition = true;
			
			$("div.navigation>div>span").animate({opacity : '0.1', top : '-10px'}, 600, function(){
					$("div.>div>span").html('项目综合数据查询');
					$("div.navigation>div>span").animate({opacity : '1', top : '0px'}, 600);
			});		
		
			back = false;
		}	
	}); /** /End div#back click **/
	
});