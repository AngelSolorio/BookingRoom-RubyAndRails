Dropzone.autoDiscover = false;
$('#my-awesome-dropzone').dropzone({ // The camelized version of the ID of the form element

  // The configuration we've talked about above
  url: '/meeting_rooms',
  uploadMultiple: true,
  maxFiles: 100,
  addRemoveLinks: true,
  previewsContainer: '.dropzone-previews',
  clickable: ".dropzone-previews",
  parallelUploads: 100,
  paramName: 'meeting_room[images_attributes]', 
  headers: {
        "Accept": "text/html"
      },
  autoProcessQueue: false,
  // The setting up of the dropzone
  init: function() {
	  
    var myDropzone = this;
	console.log('Init dropzone'+myDropzone);
    // First change the button to actually tell Dropzone to process the queue.
    this.element.querySelector("input[type=submit]").addEventListener("click", function(e) {
      // Make sure that the form isn't actually being sent.
      e.preventDefault();
      e.stopPropagation();
      myDropzone.processQueue();
    });

    // Listen to the sendingmultiple event. In this case, it's the sendingmultiple event instead
    // of the sending event because uploadMultiple is set to true.
    this.on("sendingmultiple", function() {
      // Gets triggered when the form is actually being sent.
      // Hide the success button or the complete form.	  
	  
    });
    this.on("successmultiple", function(files, response) {
      // Gets triggered when the files have successfully been sent.
      // Redirect user or notify of success.

    });
    this.on("errormultiple", function(files, response) {
      // Gets triggered when there was an error sending the files.
      // Maybe show form again, and notify user of error	  
    });
  }

});


