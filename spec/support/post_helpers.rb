def create_post
  user = FactoryGirl.create(:user)
  post = FactoryGirl.build(:post)
  user.posts << post
  user.save
  post
end
