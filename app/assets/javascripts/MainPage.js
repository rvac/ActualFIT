
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


//    setInterval(refreshPartial, 3000);

	var propsTimeout;
	var ChatShown = true;
	$("div.ArtifactBody").click(function(){
		fadeInContent($(".ArtifactComments"));
	});

    $(".AddUserToInspectionToggle").click(function(){
        toggleContent($(".AddUserToInspectionListInner"));
    });

	$("div.IIHeader, div.IIHeaderContentExpanded").click(function(){
		var container = $(this).parent();
		toggleContentVisibility(container);
		$(this).toggleClass("IIHeader IIHeaderContentExpanded");
	});

	$(".Artifact, .InspectionItem").hover(function(){
		propsTimeout = window.setTimeout(slideDownProps,1000,$(this));
		// slideDownProps($(this));
	},function(){
		window.clearTimeout(propsTimeout);
		slideUpProps($(this));
	});

	$(".ChatInner").hover(function(){
		fadeInContent($(".Dock"));
	},function(){
		 if(ChatShown){
			propsTimeout = window.setTimeout(fadeOutContent,2000,$(".Dock"));
		 }
	});

	$(".Dock").hover(function(){
		if(ChatShown){
			window.clearTimeout(propsTimeout);
		}
	},function(){
		if(ChatShown){
			fadeOutContent($(".Dock"));	
		}
	});



	$(".Dock").click(function(){
		if(ChatShown){
			// $(".ChatContainer").css("min-width: 20px;");
			ChatShown = false;
			$(".ArtifactComments").css("padding-right","30px");
			$(".Dock").css("left","auto");
			$(".Dock").css('right','0px');	
			fadeOutContent($(".ChatInner"));
			propsTimeout = window.setTimeout(toggleChat,500);
			
	
			
			
			
		}
		else{
			// $(".ChatContainer").css("min-width: 20px;");
			toggleChat();
			fadeInContent($(".ChatInner"));
			$(".Dock").css("right","auto");
		 	$(".Dock").css('left','-25px');
			ChatShown = true;
			
		}
		
	});

	// $(".ActionElement").click(function(){
	// 	alert("action taken");
	// });

	$(".ACTR").hover(function(){
		var ap = $(this).children(".ACTC").children(".ACTRActionPanel")
		var rHeight = $(this).css("height");
		ap.css("line-height", rHeight);
		propsTimeout = window.setTimeout(fadeInContent,1000,ap);
		// slideDownProps($(this));
	},function(){
		window.clearTimeout(propsTimeout);
		var ap = $(this).children(".ACTC").children(".ACTRActionPanel")
		fadeOutContent(ap);
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
	$(".Responsible, .Responsible-Selected").click(function(){
		$(this).toggleClass("Responsible Responsible-Selected");
	});


});

