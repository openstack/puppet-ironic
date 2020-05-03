require 'puppet'
require 'puppet/type/ironic_inspector_config'

describe 'Puppet::Type.type(:ironic_inspector_config)' do
  before :each do
    @ironic_inspector_config = Puppet::Type.type(:ironic_inspector_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'ironic::install::end')
    catalog.add_resource anchor, @ironic_inspector_config
    dependency = @ironic_inspector_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@ironic_inspector_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
