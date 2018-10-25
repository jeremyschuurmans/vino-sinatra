require 'pry'

describe 'User' do

  before do
    @user = User.create(:name => "Yukihiro Matzumoto", :username => "hiro matzumoto", :email => "matz@rubycentral.org", :password => "objectsobjectsobjects")
  end

  it 'has a name' do
    expect(@user.name).to eq("Yukihiro Matzumoto")
  end

  it 'has a username' do
    expect(@user.username).to eq("hiro matzumoto")
  end

  it 'has an email' do
    expect(@user.email).to eq("matz@rubycentral.org")
  end

  it 'has a password' do
    expect(@user.password).to eq("objectsobjectsobjects")
  end

  it 'can slug the username' do
    expect(@user.slug).to eq("hiro-matzumoto")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).username).to eq("hiro matzumoto")
  end

  it 'has a secure password' do

    expect(@user.authenticate("prototypesprototypes")).to eq(false)

    expect(@user.authenticate("objectsobjectsobjects")).to eq(@user)
  end
end
