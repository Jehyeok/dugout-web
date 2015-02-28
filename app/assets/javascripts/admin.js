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