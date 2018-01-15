# # encoding: utf-8

# Inspec test for recipe khanh-pdns::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end

describe command('netstat -tap | grep pdns') do
  its('stdout') { should match /domain/}

end
describe command('dig @127.0.0.1') do
  its('stdout') { should_not match /timed out/}

end
describe command('mysql -updns -ppdns -e "show databases" -s') do
  its('stdout') { should match /pdns/}

end
