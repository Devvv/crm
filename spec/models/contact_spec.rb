require 'spec_helper'

describe Contact do

  before (:all) do

    @company = Company.new()
    @company.save()

    @contact = Contact.new()
    @contact.name = 'Stanislav'
    @contact.surname = 'Doroshin'
    @contact.company_id = @company.id

    @before_limit = @company.store_count

    @contact.save()

    @company = Company.find(@company.id)
    @after_limit = @company.store_count

  end

  it 'contact name' do
    @contact.get_name.should eq 'Doroshin Stanislav'
  end

  it 'add limit' do
    (@after_limit - @before_limit).should eq 20000.0
  end

  it 'destroy limit' do
    @contact.destroy

    @company = Company.find(@company.id)

    ( @after_limit - @company.store_count ).should eq 20000.0
  end

end
