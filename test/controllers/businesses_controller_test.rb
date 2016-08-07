require 'test_helper'

class BusinessesControllerTest < ActionController::TestCase

  setup do
    @businesses = FactoryGirl.create_list(:business, 3)
  end

  test 'get index' do
    get :index
    assert_response :success

    body = JSON.parse(response.body)
    assert body.assert_valid_keys('businesses', 'pages')

    assert_equal @businesses.length, body['businesses'].length
    assert_equal @businesses.map(&:id), body['businesses'].map{|b| b['id'].to_i}

    assert body['pages'].assert_valid_keys('current')
    assert_equal businesses_url(page: 1), body['pages']['current']
  end

  test 'index first page' do
    get :index, page_size: 1
    assert_response :success
    body = JSON.parse(response.body)
    assert body['pages'].assert_valid_keys('current', 'first', 'last', 'next')
    assert_equal businesses_url(page: 1, page_size: 1), body['pages']['current']
    assert_equal businesses_url(page_size: 1), body['pages']['first']
    assert_equal businesses_url(page: 3, page_size: 1), body['pages']['last']
    assert_equal businesses_url(page: 2, page_size: 1), body['pages']['next']

    assert_equal @businesses[0].id, body['businesses'][0]['id'].to_i
  end

  test 'index middle page' do
    get :index, page_size: 1, page: 2
    assert_response :success
    body = JSON.parse(response.body)
    assert body['pages'].assert_valid_keys('current', 'first', 'last', 'previous', 'next')
    assert_equal businesses_url(page: 2, page_size: 1), body['pages']['current']
    assert_equal businesses_url(page_size: 1), body['pages']['first']
    assert_equal businesses_url(page: 3, page_size: 1), body['pages']['last']
    assert_equal businesses_url(page: 1, page_size: 1), body['pages']['previous']
    assert_equal businesses_url(page: 3, page_size: 1), body['pages']['next']

    assert_equal @businesses[1].id, body['businesses'][0]['id'].to_i
  end

  test 'index last page' do
    get :index, page_size: 1, page: 3
    assert_response :success
    body = JSON.parse(response.body)
    assert body['pages'].assert_valid_keys('current', 'first', 'last', 'previous')
    assert_equal businesses_url(page: 3, page_size: 1), body['pages']['current']
    assert_equal businesses_url(page_size: 1), body['pages']['first']
    assert_equal businesses_url(page: 3, page_size: 1), body['pages']['last']
    assert_equal businesses_url(page: 2, page_size: 1), body['pages']['previous']

    assert_equal @businesses[2].id, body['businesses'][0]['id'].to_i
  end

  test 'index page outside page range' do
    get :index, page: 5
    assert_response :success
    body = JSON.parse(response.body)
    assert body['pages'].assert_valid_keys('current')
    assert_equal businesses_url(page: 1), body['pages']['current']
  end

  test 'index invalid page' do
    get :index, page: 'abc'
    assert_response :success
    body = JSON.parse(response.body)
    assert body['pages'].assert_valid_keys('current')
    assert_equal businesses_url(page: 1), body['pages']['current']
  end

  test 'index invalid page size' do
    get :index, page_size: 'four-score'
    assert_response :success
    body = JSON.parse(response.body)
    assert body['pages'].assert_valid_keys('current')
    assert_equal businesses_url(page: 1), body['pages']['current']
  end

  test 'get show' do
    get :show, id: @businesses[1].id
    assert_response :success
    body = JSON.parse(response.body)
    assert body.assert_valid_keys('id', 'uuid', 'name', 'address', 'address2',
                                  'city', 'state', 'zip', 'country', 'phone',
                                  'website', 'created_at')
    assert_equal @businesses[1].id, body['id'].to_i
    assert_equal @businesses[1].uuid, body['uuid']
  end

  test 'show not found' do
    get :show, id: -1
    assert_response :not_found
    body = JSON.parse(response.body)
    assert_equal 404, body['status']
    assert_equal 'Object not found', body['message']
  end
end
