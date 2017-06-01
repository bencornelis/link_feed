def create_post(args = {})
  user = FactoryGirl.create(:user)
  post = FactoryGirl.build(:post, args)
  user.posts << post
  user.save
  post
end
