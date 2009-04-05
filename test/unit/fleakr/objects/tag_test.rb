require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class TagTest < Test::Unit::TestCase

    describe "The Tag class" do
      
      should_find_all :tags, :by => :photo_id, :call => 'tags.getListPhoto', :path => 'rsp/photo/tags/tag'
      
    end
    
    describe "An instance of the Tag class" do
      
      context "when populating from the tags_getListPhoto XML data" do
        before do
          @object = Tag.new(Hpricot.XML(read_fixture('tags.getListPhoto')).at('rsp/photo/tags/tag'))
        end
        
        should_have_a_value_for :id => '1'
        should_have_a_value_for :author_id => '15498419@N05'
        should_have_a_value_for :value => 'stu72'
        
      end
      
      it "should have an author" do
        user = stub()
        
        tag = Tag.new
        tag.expects(:author_id).at_least_once.with().returns('1')
        
        
        User.expects(:find_by_id).with('1').returns(user)
        
        tag.author.should == user
      end
      
      it "should memoize the author data" do
        tag = Tag.new
        tag.expects(:author_id).at_least_once.with().returns('1')
        
        User.expects(:find_by_id).with('1').once.returns(stub())
        
        2.times { tag.author }
      end
      
      it "should return nil for author if author_id is not present" do
        tag = Tag.new
        tag.expects(:author_id).with().returns(nil)
        
        tag.author.should be(nil)
      end
      
      it "should have related tags" do
        tag = Tag.new
        tag.expects(:value).with().returns('foo')
        
        response = mock_request_cycle :for => 'tags.getRelated', :with => {:tag => 'foo'}


        stubs = []
        elements = (response.body/'rsp/tags/tag').map
        
        elements.each do |element|
          stub = stub()
          stubs << stub

          Tag.expects(:new).with(element).returns(stub)
        end
        
        tag.related.should == stubs
      end
      
      it "should be able to generate a string representation of itself" do
        tag = Tag.new
        tag.expects(:value).with().returns('foo')
        tag.to_s.should == 'foo'
      end
      
    end
    
  end
end