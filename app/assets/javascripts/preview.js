$(document).ready(function(){
	// 1. Initialize fotorama manually.
	var $fotoramaDiv = $('#gallery').fotorama();
	// 2. Get the API object.
	var fotorama = $fotoramaDiv.data('fotorama');
	$('.meeting-room-link').click(function(link){
		var images = [];
		link.preventDefault();
		$('#default-meeting-description').empty();
		$('#services-preview').empty();
	    var meetingRoomLocation = $(this).find("a[href]").attr('href');
		$.getJSON( meetingRoomLocation + '.json') 
			.done(function(data) {
		      $.each( data['meeting_room']['services'], function( i, item ) {
				$('#services-preview').append(
				    $('<li>').append(
				        $('<img>').attr( "src", item['image']['photo_file']['small']['url']),
					        $('<p>').text(item['name'])
						));
		      });
			      $.each( data['meeting_room']['images'], function( i, item ) {
					images.push({img: item['photo_file']['url']});
			        if ( i === 3 ) {
			          return false;
			        }
			      });
	  		    fotorama.load(images);
			});
	});
	
})