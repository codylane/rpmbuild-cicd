require 'spec_helper'

$RPMS = [
  'ganglia-3.7.2-33.el8.x86_64.rpm',
  'ganglia-devel-3.7.2-33.el8.x86_64.rpm',
  'ganglia-gmetad-3.7.2-33.el8.x86_64.rpm',
  'ganglia-gmond-3.7.2-33.el8.x86_64.rpm',
  'ganglia-web-3.7.5-33.el8.x86_64.rpm',
  'ganglia-web-3.7.5-33.el8.x86_64.rpm',
]


context 'ensure that the rpms exist on disk' do
  $RPMS.each do |rpm|
    rpm = File.join('', 'rpmbuild', 'RPMS', 'x86_64', rpm)

    describe file(rpm) do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '644' }
    end
  end
end

# context 'test rpm install' do
#   before :each do
#     puts %x[dnf localinstall -y /rpmbuild/RPMS/x86_64/ganglia-3.7.2-33.el8.x86_64.rpm]
#   end
#
#   describe package('ganglia') do
#     it { is_expected.to be_installed }
#   end
#
# end
