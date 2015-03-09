# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 0 = bears
# 1 = eagles
# 2 = tigers
# 3 = kt
# 4 = giants
# 5 = lgtwins
# 6 = nc
# 7 = heros
# 8 = lions
# 9 = w
groups = Group.create([{
	number: 0,
	name: "bears",
	rank: 0
}, {
	number: 1,
	name: "eagles",
	rank: 1
}, {
	number: 2,
	name: "tigers",
	rank: 2
}, {
	number: 3,
	name: "kt",
	rank: 3
}, {
	number: 4,
	name: "giants",
	rank: 4
}, {
	number: 5,
	name: "lgtwins",
	rank: 5
}, {
	number: 6,
	name: "nc",
	rank: 6
}, {
	number: 7,
	name: "heros",
	rank: 7
}, {
	number: 8,
	name: "lions",
	rank: 8
}, {
	number: 9,
	name: "w",
	rank: 9
}])

users = User.create([{
	email: "jehyeok.hyun@gmail.com",
	password: "123456",
	nick_name: "제호구",
	group_id: 1
}, {
	email: "hook3748@gmail.com",
	password: "123456",
	nick_name: "테스트",
	group_id: 2
}])

boards = Board.create([{
	title: "제목입니다.1",
	content: "그룹1",
	group_id: 1,
	user_id: 1,
	level: 1
}, {
	title: "제목입니다.",
	content: "그룹1",
	group_id: 1,
	user_id: 1
}, {
	title: "제목입니다.2",
	content: "그룹2",
	group_id: 2,
	user_id: 1
}, {
	title: "제목입니다.3",
	content: "그룹3",
	group_id: 3,
	user_id: 1,
	like: 200
}, {
	title: "제목입니다.4",
	content: "그룹4",
	group_id: 4,
	user_id: 1,
	like: 250
}, {
	title: "제목입니다.5",
	content: "그룹5",
	group_id: 5,
	user_id: 1,
	like: 260
}, {
	title: "제목입니다.6",
	content: "그룹6",
	group_id: 6,
	user_id: 1
}, {
	title: "제목입니다.7",
	content: "그룹7",
	group_id: 7,
	user_id: 1
}, {
	title: "제목입니다.8",
	content: "그룹8",
	group_id: 8,
	user_id: 1
}, {
	title: "제목입니다.9",
	content: "그룹9",
	group_id: 9,
	user_id: 1
}, {
	title: "제목입니다.10",
	content: "그룹10",
	group_id: 10,
	user_id: 1
}])

(1..120).each do |i|
	Board.create(
		title: "제목입니다.1",
		content: "내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다내용입니다",
		group_id: 1,
		user_id: 1
	)
end

Board.create(
	content: "의존성테스트",
	group_id: 1,
	user_id: 2
)

comments = Comment.create([{
	content: "댓글내용이닷",
	depth: 0,
	user_id: 1,
	board_id: 1,
	parent_id: nil
}, {
	content: "두번째 댓글내용이닷",
	depth: 1,
	user_id: 2,
	board_id: 1,
	parent_id: 1
}, {
	content: "세번째 댓글내용이닷",
	depth: 0,
	user_id: 2,
	board_id: 1,
	parent_id: nil
}])