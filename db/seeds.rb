# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create([{
	email: "jehyeok.hyun@gmail.com",
	password: "123456",
	nick_name: "제호구",
	favorite_group_number: 0
}])

boards = Board.create([{
	title: "제목입니다.",
	content: "내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다",
	group_number: 0,
	user_id: 1
}, {
	title: "제목입니다.",
	content: "내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다",
	group_number: 0,
	user_id: 1
}])

comments = Comment.create([{
	content: "댓글내용이닷",
	depth: 0,
	user_id: 1,
	board_id: 1,
	parent_id: nil
}, {
	content: "두번째 댓글내용이닷",
	depth: 1,
	user_id: 1,
	board_id: 1,
	parent_id: 1
}, {
	content: "세번째 댓글내용이닷",
	depth: 0,
	user_id: 1,
	board_id: 1,
	parent_id: nil
}])