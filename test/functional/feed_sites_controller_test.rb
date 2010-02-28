require 'test_helper'

class FeedSitesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => FeedSite.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    FeedSite.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    FeedSite.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to feed_site_url(assigns(:feed_site))
  end
  
  def test_edit
    get :edit, :id => FeedSite.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    FeedSite.any_instance.stubs(:valid?).returns(false)
    put :update, :id => FeedSite.first
    assert_template 'edit'
  end
  
  def test_update_valid
    FeedSite.any_instance.stubs(:valid?).returns(true)
    put :update, :id => FeedSite.first
    assert_redirected_to feed_site_url(assigns(:feed_site))
  end
  
  def test_destroy
    feed_site = FeedSite.first
    delete :destroy, :id => feed_site
    assert_redirected_to feed_sites_url
    assert !FeedSite.exists?(feed_site.id)
  end
end
