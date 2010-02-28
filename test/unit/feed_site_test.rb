require 'test_helper'

class FeedSiteTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FeedSite.new.valid?
  end
end
