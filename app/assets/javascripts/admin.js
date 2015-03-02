$('.rmBoardBtn').click(function(e) {
	var tr = $(this).closest('tr')
	var boardId = tr.find('.boardId').text();

	$.ajax({
		url: '/groups/0/boards/' + boardId,
		type: 'DELETE',
		success: function(msg) {
			if ('success' === msg) {
				tr.remove();
			} else {
				alert('삭제실패');
			}
		}
	});
});

$('.rmUserBtn').click(function(e) {
	var tr = $(this).closest('tr');
	var userId = tr.find('.userId').text();

	$.ajax({
		url: '/users/' + userId,
		type: 'DELETE',
		success: function(msg) {
			if ('success' === msg) {
				tr.remove();
			} else {
				alert('삭제실패');
			}
		}
	});
});

$('#adminSignin input:submit').click(function(e) {
  e.preventDefault();

  var form = $(this).closest('form');
  var formData = new FormData();

  var inputs = form.find('input');
  var email = inputs.eq(0).val();
  var password = inputs.eq(1).val();

  formData.append("email", email);
  formData.append("password", password);

  $.ajax({
    url: '/users/signin',
    type: 'POST',
    data: formData,
    dataType: 'text',
    cache : false,
    contentType: false,
    processData: false,
    success: function(msg){
      if ("success" === msg) {
        debugger;
        window.location = "/admin/main";
      } else {
        alert('관리자 계정이 아닙니다')
      }
    }
  });
});

var formData = new FormData();

$('#writeBoard input:submit').click(function(e) {
	e.preventDefault();

	var form = $(this).closest('form');

	var groupId = $(form).find('input.groupId:radio:checked').val();
	var content = $(form).find('textarea').val();
	var level = $(form).find('input.level:radio:checked').val();

	if (groupId === undefined) {
		alert('그룹을 선택하세요');
		return false;
	} else if (content === "") {
		alert('내용을 입력하세요');

		return false;
	}
	formData.append("groupId", groupId);
	formData.append("content", content);
	formData.append("level", level);

	var filesInput = $(form).find('input:file')

	$(filesInput).each(function(i) {
		processfile(this);
	});

	var actionUrl = '/groups/' + groupId + '/boards';

	// $(form).attr('action', '/groups/' + groupId + '/boards');
	// $(form).submit();

	$.ajax({
    url: actionUrl,
    data: formData,
    cache: false,
    contentType: false,
    processData: false,
    type: 'POST',
    success: function(data){
      alert("게시글 등록 완료");
      window.location = "";
    }
	});
});


function processfile(file, fileInput) {
  
    if( !( /image/i ).test( file.type ) )
        {
            // alert( "File "+ file.name +" is not an image." );
            return false;
        }

    // read the files
    var reader = new FileReader();
    reader.readAsArrayBuffer(file);

    reader.onload = function (fileInput, event) {
      // blob stuff
      debugger;
      var blob = new Blob([event.target.result]); // create blob...
      window.URL = window.URL || window.webkitURL;
      var blobURL = window.URL.createObjectURL(blob); // and get it's URL
      
      // helper Image object
      var image = new Image();
      image.src = blobURL;

      var file = file;

      //preview.appendChild(image); // preview commented out, I am using the canvas instead
      image.onload = function(fileInput) {
        // have to wait till it's loaded
        var resized = resizeMe(image); // send it to canvas
        var newinput = document.createElement("input");
        newinput.type = 'hidden';
        newinput.name = 'images[]';
        // fileInput.value = resized
        newinput.value = resized; // put result from canvas into new hidden input
        // debugger;
        var blob = dataURItoBlob(resized);
        // fileInput.files[0] = blob;
        // fileInput.length += 1;
        // $('form').append(newinput);
        formData.append(fileInput.name, blob);
      }.bind(this, fileInput);
    }.bind(this, fileInput);
}

function readfiles(files, fileInput) {
    for (var i = 0; i < files.length; i++) {
      processfile(files[i], fileInput); // process each file at once
    }
}

// this is where it starts. event triggered when user selects files
// fileinput.onchange = function(){
//   if ( !( window.File && window.FileReader && window.FileList && window.Blob ) ) {
//     alert('The File APIs are not fully supported in this browser.');
//     return false;
//     }
//   readfiles(fileinput.files);
// }
$('.fileInput').change(function(){
  if ( !( window.File && window.FileReader && window.FileList && window.Blob ) ) {
    alert('The File APIs are not fully supported in this browser.');
    return false;
    }
  readfiles(this.files, this);
});

// === RESIZE ====

function resizeMe(img) {
  
  var canvas = document.createElement('canvas');

  var width = img.width;
  var height = img.height;

  // calculate the width and height, constraining the proportions
  // if (width > height) {
  //   if (width > max_width) {
  //     //height *= max_width / width;
  //     height = Math.round(height *= max_width / width);
  //     width = max_width;
  //   }
  // } else {
  //   if (height > max_height) {
  //     //width *= max_height / height;
  //     width = Math.round(width *= max_height / height);
  //     height = max_height;
  //   }
  // }
  
  // resize the canvas and draw the image data into it
  canvas.width = width;
  canvas.height = height;
  var ctx = canvas.getContext("2d");
  ctx.drawImage(img, 0, 0, width, height);
  
  // preview.appendChild(canvas); // do the actual resized preview
  
  return canvas.toDataURL("image/jpeg",0.7); // get the data from canvas as 70% JPG (can be also PNG, etc.)

}

function dataURItoBlob(dataURI) {
    // convert base64/URLEncoded data component to raw binary data held in a string
    var byteString;
    if (dataURI.split(',')[0].indexOf('base64') >= 0)
        byteString = atob(dataURI.split(',')[1]);
    else
        byteString = unescape(dataURI.split(',')[1]);

    // separate out the mime component
    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];

    // write the bytes of the string to a typed array
    var ia = new Uint8Array(byteString.length);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }

    return new Blob([ia], {type:mimeString});
}

$('#setRankForm input:submit').click(function(e) {
  e.preventDefault();

  var form = $(this).closest('form');
  var formData = new FormData();

  var rankInputs = $('input[type=text]');

  rankInputs.each(function(i) {
    formData.append(i, $(this).val());
    console.log($(this).val());
  });

  $.ajax({
    url: '/admin/groups/set_rank',
    data: formData,
    cache: false,
    contentType: false,
    processData: false,
    type: 'POST',
    success: function(data) {
      alert("순위 변경 완료");
      window.location = "";
    }
  });  
});