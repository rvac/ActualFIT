
//Welcome to JS and jQuery world

//toggle Inspections Content
function toggleContent(content){
	//insert check that the variable is div. Better if it is a proper div
	content.fadeToggle("slow");
};
function toggleChat(){
			$(".ChatContainer").toggleClass("span4 ChatDocked");
			$(".ArtifactComments").toggleClass("span4 span6");	
			$(".ArtifactsPanel").toggleClass("span4 span6");
}
//On change Inspection class when expanded/collapsed.
 function toggleContentVisibility(container){
	var content = container.children(".IIContent");
	//something like  if(content != null) is needed
	//container.toggleClass("InspectionItem InspectionItemExpanded");
	toggleContent(content);
 };

function slideUpProps(container){
		var ArtifactProps = container.children("[class*=ActionPanel]");
		ArtifactProps.slideUp("fast");
};

function slideDownProps(container){
		var ArtifactProps = container.children("[class*=ActionPanel]");
		ArtifactProps.slideDown("fast");
};

function toggleChatDock(){
	$(".ChatInner").fadeToggle("slow");
};
function fadeInContent(content){
	//insert check that the variable is div. Better if it is a proper div
	content.fadeIn("slow");
};
function fadeOutContent(content){
	//insert check that the variable is div. Better if it is a proper div
	content.fadeOut("slow");
};
//function refreshPartial() {
//    $.ajax({url: "inspections/refresh_chat"});
//};
$(document).ready(function(){

        // will call refreshPartial every 3 seconds

//    $(window).resize(function() {
//        $("#Remarks").fnAdjustColumnSizing();
////          $('body').prepend('<div>' + $(window).width() + '</div>');
//    });
//    setInterval(refreshPartial, 3000);
    $('#dpsetup, #dpupload, #dpprepare, #dpinspection, #dprework, #dpfinished').datepicker()
        .on('changeDate', function(e){
            var y = e.date.getFullYear(),
                _m = e.date.getMonth() + 1,
                m = (_m > 9 ? _m : '0'+_m),
                _d = e.date.getDate(),
                d = (_d > 9 ? _d : '0'+_d);
            $(this).text(y + '-' + m + '-' + d);
            $(this).next("#dueDate").val(y + '-' + m + '-' + d);
            $(this).next("#dueDate").next("#submitDeadline").show();
            $(this).next("#dueDate").next("#submitDeadline").next("#inspectionDeadline").show();
        });

    $("#ChatTypeBox").keyup(function(event){
            if (event.keyCode == 13 && !event.shiftKey) {
                $('#new_chat_message').submit();
            }
    });
    $("#remark_location_type")
        .change(function () {
            switch ($(this).val()) {
                case 'code':
                    $("#remark_line_number").show();
                    $("#remark_element_name").hide();
                    $("#remark_element_number").hide();
                    $("#remark_element_type").hide();
                    $("#remark_diagram").hide();
                    $("#remark_path").hide();
                    break; //end Timeless Hotel
                case 'document':
                    $("#remark_line_number").hide();
                    $("#remark_element_name").show();
                    $("#remark_element_number").show();
                    $("#remark_element_type").show();
                    $("#remark_diagram").hide();
                    $("#remark_path").hide();
                    break; //end Timeless Hotel
                case 'model':
                    $("#remark_line_number").hide();
                    $("#remark_element_name").show();
                    $("#remark_element_number").hide();
                    $("#remark_element_type").show();
                    $("#remark_diagram").show();
                    $("#remark_path").show();
                    break; //end Timeless Hotel
            }
        })
        .change();

	var propsTimeout;
	var ChatShown = true;
	$("div.ArtifactBody").click(function(){
		fadeInContent($(".ArtifactComments"));
	});

    $(".AddUserToInspectionToggle").click(function(){
        toggleContent($(".AddUserToInspectionListInner"));
    });


	$(".CommentsHeader").hover(function(){
		propsTimeout = window.setTimeout(fadeInContent,1000,$(".CommentsClose"));
		// slideDownProps($(this));
	},function(){
		window.clearTimeout(propsTimeout);
		fadeOutContent($(".CommentsClose"));
	});
	$(".CommentsClose").click(function(){
		fadeOutContent($(".ArtifactComments"));
	});

    $('.ArtifactBody').click(function(){
        $(this).parent().find('.ArtifactComment').slideDown();
    });
    $('.ArtifactComment').click(function(){
        $(this).slideUp();
    });
    $("#InspectionHintMessage").click(function(){
        $(this).slideUp();
    });
});

