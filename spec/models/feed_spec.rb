require 'spec_helper'

describe Feed do

  before (:all) do
    @company = Company.new()
    @company.save()

    @feed = Feed.new()

    @feed.company_id = @company.id

    @before_limit = @company.store_count

    @feed.save()

    @company = Company.find(@company.id)

    @after_limit = @company.store_count
  end

  it 'default feed type' do
    @feed.type_id.should eq 0
  end


  it 'company free space after create feed' do
    ( @after_limit - @before_limit ).should eq 20000.0
  end

  it 'company free space after destroy feed' do
    @feed.destroy

    @company = Company.find(@company.id)

    ( @after_limit - @company.store_count ).should eq 20000.0

    @feed = Feed.new()

  end

  it 'default start and end time' do
    @feed.start.strftime('%Q').should eq (Time.now.getlocal.strftime('%Q'))
  end

end
