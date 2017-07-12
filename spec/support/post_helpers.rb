def create_post(args = {})
  user = create(:user)
  post = build(:post, args)
  user.posts << post
  user.save
  post
end
