require 'spec_helper'

describe History do

  before(:all) do
    @company = Company.all.first()

    @feed = Feed.new()
    @feed.company_id = @company.id
    @feed.save()

    @before_comments = @feed.comments

    @comment = History.new()

    @comment.feed_id = @feed.id

    @comment.save()

    @feed = Feed.find(@feed.id)

    @after_comments = @feed.comments
  end

  it 'comments count' do
    (@after_comments - @before_comments).should eq 1

    @comment.destroy

    @feed = Feed.find(@feed.id)

    (@before_comments - @feed.comments).should eq 0

  end

end
