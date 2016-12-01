require 'spec_helper'
require 'net/http'
require 'uri'

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe file('/etc/nginx/nginx.conf') do
  its(:content) { should match(/^\s*server_tokens off;$/) }
  its(:content) { should match(/^\s*include \/etc\/nginx\/sites-enabled\/\*\.conf;$/) }
end

describe Net::HTTP.get(URI('http://localhost/nginx_status')) do
  it { should match(/Active connections/) }
end
