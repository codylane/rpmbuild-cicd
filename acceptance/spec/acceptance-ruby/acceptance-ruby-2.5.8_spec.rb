require 'spec_helper'

context 'when acceptance-ruby-2.5.8 exists a file on disk' do
  describe file('/rpmbuild/RPMS/x86_64/acceptance-ruby-2.5.8-1.el8.x86_64.rpm') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode '644' }
  end
end

context 'when acceptance-ruby-2.5.8 is installed' do
  describe package('acceptance-ruby') do
    it { is_expected.to be_installed.with_version('2.5.8-1.el8.x86_64') }
  end

  describe file('/opt/ruby/2.5.8') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '755' }
  end

  [
    'bundle',
    'gem',
    'ruby',
    'pry',
    'rake',
    'rspec',
    'serverspec-init',
  ].each do |gem_executable|
    gem_executable = File.join('/opt/ruby/2.5.8/bin', gem_executable)

    context "contain executable '#{gem_executable}'" do
      describe file(gem_executable) do
        it { is_expected.to be_file }
        it { is_expected.to be_mode '755' }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
      end
    end
  end
end
