// $(document).on('page:change', function(){
// 
// /*This is a function so you can toggle your click for slide up and slide down between the steps of the tree*/
// $(function(){
//   $("li").each(function(){
//     var str = $(this).text();
//     var withoutvalue = str.split(" ", 1);
//     var fields = withoutvalue[0].split('.',8);
//     if(fields.length >=3){
//       $(this).hide();
//     }
//   });
// });
// 
// /*This is the function for toggling around. Just set some data.*/
// (function($){
//   $.fn.clickToggle = function(func1, func2){
//     var funcs = [func1, func2];
//     this.data('toggleclicked', 0);
//     this.click(function(){
//       var data = $(this).data();
//       var tc = data.toggleclicked;
//       $.proxy(funcs[tc], this)();
//       data.toggleclicked = (tc + 1) % 2;
//     });
//     return this;
//   };
// })(jQuery);
// /*This is the function for open or close the next Treestep. Probobly the functions row should be swiped so you don't have to doubleclick the first the you wanna open.
//   1. get the path you clicked on(just class "param-path")
//   2. split it where is "." -> array("DeviceInfo", "SomeMoreInfo")
//   3. choose all "li" which contains the same text
//   4. the filter get all "li" that contains the clicked element and split it first with " ",so you have the path and the value separated.
//      than like path split with "." and then compare the lenght of the clicked array and the other arrays(whitout value, because it would react if there is a iP Address in value)
//   5.the same with slide down, with one difference: when you open, you open just next step in the tree and not all, when you close you close all steps till the clicked step*/
// $(function(){
// $(".param-path").clickToggle(function(){
//   var pferd = $(this).text();
//   var fields = pferd.split('.', 8);
//   $("li:contains(" + pferd + ")").filter(function(){
//     var apferd = $(this).text();
//     var withoutvalue = apferd.split(" ", 1);
//     var afields = withoutvalue[0].split('.', 8);
//     var chi = fields.length+1;
//     return afields.length >= chi;
//   }).slideUp("fast");
// }, function(){
//   var pferd = $(this).text();
//   var fields = pferd.split('.', 8);
//   $("li:contains(" + pferd + ")").filter(function(){
//     var apferd = $(this).text();
//     var withoutvalue = apferd.split(" ", 1);
//     var afields = withoutvalue[0].split('.', 8);
//     var chi = fields.length+1;
//     return afields.length == chi;
//   }).slideDown("fast");
// });
// });
// var spancounter = 1;
// $(function(){
// $(".param-path").each(function(){
//   var str = $(this).text();
//   var fields = str.split('.',8);
//   var nstr = $("span.param-path").eq(spancounter).text();
//   var nfields = nstr.split('.', 8); 
//   spancounter++;
//   switch(fields.length){
//     case 1:
//       $(this).before("<span>&#9662;</span>");
//       break;
//     case 2:
//       $(this).before("<span>&#9562;</span>");
//       if(fields.length < nfields.length){
// 	$(this).before("<span>&#9662;</span>");
//       }
//       break;
//     case 3:
//       $(this).before("<span>&emsp;&#9562;</span>");
//       if(fields.length < nfields.length){
// 	$(this).before("<span>&#9662;</span>");
//       }
//       break;
//     case 4:
//       $(this).before("<span>&emsp;&emsp;&#9562;</span>");
//       if(fields.length < nfields.length){
// 	$(this).before("<span>&#9662;</span>");
//       }
//       break;
//     case 5:
//       $(this).before("<span>&emsp;&emsp;&emsp;&#9562;</span>");
//       if(fields.length < nfields.length){
// 	$(this).before("<span>&#9662;</span>");
// 	}
// 	break;
//     case 6:
//       $(this).before("<span>&emsp;&emsp;&emsp;&emsp;&#9562;</span>");
//       if(fields.length < nfields.length){
// 	$(this).before("<span>&#9662;</span>");
//       }
//       break;
//     case 7:
//       $(this).before("<span>&emsp;&emsp;&emsp;&emsp;&emsp;&#9562;</span>");
//       if(fields.length < nfields.length){
// 	$(this).before("<span>&#9662;</span>");
//       }
//       break;
//     case 8:
//       $(this).before("<span>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&#9562;</span>");
//       if(fields.length < nfields.length){
// 	$(this).before("<span>&#9662;</span>");
//       }
//       break; 
//   }
// });
// });
// });
