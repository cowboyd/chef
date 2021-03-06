#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Chef::Knife::NodeRunListRemove do
  before(:each) do
    Chef::Config[:node_name]  = "webmonkey.example.com"
    @knife = Chef::Knife::NodeRunListRemove.new
    @knife.config = {
      :print_after => nil
    }
    @knife.name_args = [ "adam", "role[monkey]" ]
    @knife.stub!(:output).and_return(true)
    @knife.stub!(:confirm).and_return(true)
    @node = Chef::Node.new() 
    @node.run_list << "role[monkey]"
    @node.stub!(:save).and_return(true)
    Chef::Node.stub!(:load).and_return(@node)
  end

  describe "run" do
    it "should load the node" do
      Chef::Node.should_receive(:load).with("adam").and_return(@node)
      @knife.run
    end

    it "should remove the item from the run list" do
      @knife.run
      @node.run_list[0].should_not == 'role[monkey]'
    end

    it "should save the node" do
      @node.should_receive(:save).and_return(true)
      @knife.run
    end

    it "should print the run list" do
      @knife.should_receive(:output).with({ 'run_list' => [] })
      @knife.run
    end
  end
end



