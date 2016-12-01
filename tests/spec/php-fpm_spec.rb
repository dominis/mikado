require 'spec_helper'

describe package('php') do
  it { should be_installed }
end

describe package('php-fpm') do
  it { should be_installed }
end

describe process("php-fpm") do
  its(:user) { should eq "nignx" }
end
