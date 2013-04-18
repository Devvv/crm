class PaymentController < ApplicationController

  def result
    render :nothing => true
  end

  def success

    if params[:OutSum] and params[:InvId] and params[:SignatureValue]
      payment = Payment.find(params[:InvId])
      if params[:SignatureValue] == Digest::MD5.hexdigest("#{params[:OutSum]}:#{params[:InvId]}:beweek888lll")
        payment.update_attribute :paid, 1
        company = Company.find(payment.company_id)
        if company.type_id.to_i == payment.plan.to_i
          if company.type_to < Time.now
            company.update_attribute :type_to, 1.month.from_now
          else
            company.update_attributes :type_to, company.type_to + 1.month
          end
        else
          company.update_attributes({
            :type_id => payment.plan,
            :type_to => 1.month.from_now
          })
        end
      end
    end

    render :nothing => true
  end

  def failure
    render :nothing => true
  end

end