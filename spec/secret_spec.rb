require './secret.rb'

RSpec.describe Secret do
  it 'saves an message with a short password and retrieves it' do
    secret = Secret.new
    secret.message = 'cat'
    secret.save 'password'

    retrieved_secret = Secret.new
    retrieved_secret.load 'password'
    expect(retrieved_secret.message).to eq('cat')
  end

  it 'can use passwords that are longer than 32 characters' do
    secret = Secret.new
    secret.message = 'cat'
    secret.save 'this_is_a_really_long_password_I_have_decided_to_use_for_this'

    retrieved_secret = Secret.new
    retrieved_secret.load 'this_is_a_really_long_password_I_have_decided_to_use_for_this'
    expect(retrieved_secret.message).to eq('cat')
  end
end
