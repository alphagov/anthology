require 'test_helper'

describe User do

  let(:auth_hash) {
    {
      provider: 'google',
      uid: '12345',
      info: {
        name: 'Stub User',
        email: 'stub.user@example.org',
        image: 'http://example.org/image.jpg',
      }
    }
  }

  it 'can be created from an auth hash' do
    user = User.find_or_create_from_auth_hash!(auth_hash)

    assert_equal 'Stub User', user.name
    assert_equal 'stub.user@example.org', user.email
    assert_equal 'google', user.provider
    assert_equal '12345', user.provider_uid
    assert_equal 'http://example.org/image.jpg', user.image_url
  end

  it 'can be found from a matching email' do
    existing_user = create(:user, email: auth_hash[:info][:email])
    user = User.find_or_create_from_auth_hash!(auth_hash)

    assert_equal existing_user.id, user.id
  end

  it 'updates the user details on sign in' do
    existing_user = create(:user, email: auth_hash[:info][:email],
                                  name: 'Another Name')
    User.find_or_create_from_auth_hash!(auth_hash)

    existing_user.reload
    assert_equal 'Stub User', existing_user.name
  end

  it 'does not restrict user emails to a hostname by default' do
    Books.stubs(:permitted_email_hostnames).returns([])

    user = build(:user, email: 'stub.user@something.org')
    assert user.valid?
  end

  it 'restricts user emails to a specified hostname' do
    Books.stubs(:permitted_email_hostnames).returns(['example.org'])

    user = build(:user, email: 'stub.user@foo.org')
    refute user.valid?
    assert user.errors.has_key?(:email)

    user = build(:user, email: 'stub.user@example.org')
    assert user.valid?
  end

  it 'restricts user emails to multiple specified hostnames' do
    Books.stubs(:permitted_email_hostnames).returns(['example.org', 'foo.org'])

    user = build(:user, email: 'stub.user@foo.org')
    assert user.valid?

    user = build(:user, email: 'stub.user@example.org')
    assert user.valid?

    user = build(:user, email: 'stub.user@bar.org')
    refute user.valid?
    assert user.errors.has_key?(:email)
  end

  it 'only enforces the email hostname restriction on create' do
    Books.stubs(:permitted_email_hostnames).returns(['banned.org'])

    user = create(:user, email: 'stub.user@banned.org')

    Books.stubs(:permitted_email_hostnames).returns(['allowed.org'])

    user.reload
    assert user.valid?
  end

end
