// JavaScript Document

function table_tr_color(){
	$(".table_list tr:odd").addClass("tr_odd");
	$(".table_list tr:even").addClass("tr_even");
};

$(function(){
	$(".table_list tr th input[type=checkbox]").click(function(){
		if(this.checked){
			$(".table_list tr td input[type=checkbox]").attr("checked",true);
		}else{
			$(".table_list tr td input[type=checkbox]").attr("checked",false);
		}
	});
	$(".table_list tr:gt(0)").hover(function(){
		$(this).addClass("tr_cur");
	},function(){
		$(this).removeClass("tr_cur");
	});
	table_tr_color();
});
