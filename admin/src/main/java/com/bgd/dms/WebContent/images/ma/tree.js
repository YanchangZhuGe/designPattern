// 树状菜单
$(document).ready(function(){
   $(".l1").toggle(function(){
         $(".slist").animate({height: 'toggle', opacity: 'hide'}, "slow");
     $(this).next(".slist").animate({height: 'toggle', opacity: 'toggle'}, "slow");
   },function(){
             $(".slist").animate({height: 'toggle', opacity: 'hide'}, "slow");
                 $(this).next(".slist").animate({height: 'toggle', opacity: 'toggle'}, "slow");
   });
   
   $(".l2").toggle(function(){
     $(this).next(".sslist").animate({height: 'toggle', opacity: 'toggle'}, "slow");
   },function(){
                 $(this).next(".sslist").animate({height: 'toggle', opacity: 'toggle'}, "slow");
   });
   
   $(".l2").click(function(){
        $(".l3").removeClass("currentl3");
        $(".l2").removeClass("currentl2");
        $(this).addClass("currentl2");
        });  
   
   $(".l3").click(function(){
        $(".l3").removeClass("currentl3");                  
        $(this).addClass("currentl3");
        });  
   
   $(".close").toggle(function(){
        $(".slist").animate({height: 'toggle', opacity: 'hide'}, "fast");  
        $(".sslist").animate({height: 'toggle', opacity: 'hide'}, "fast");  
         },function(){
        $(".slist").animate({height: 'toggle', opacity: 'show'}, "fast");  
        $(".sslist").animate({height: 'toggle', opacity: 'show'}, "fast");  
        });  
});