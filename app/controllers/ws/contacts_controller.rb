class Ws::ContactsController < WsController

  def index
    contacts = current_user.get_company.contacts
    trigger_success contacts
  end

  def create
    contact = Contact.new(message)
    contact.user_id = current_user.id
    company_id = current_user.get_company.id
    contact.company_id = company_id
    if contact.save
      WebsocketRails["company_#{company_id}"].trigger(:create_contact, contact)
      trigger_success contact
    else
      trigger_failure contact
    end
  end

  def update
    contact = Contact.find(message[:id])
    if contact.update_attributes(message)
      WebsocketRails["company_#{current_user.get_company.id}"].trigger(:update_contact, contact)
      trigger_success contact
    else
      trigger_failure contact
    end
  end

  def destroy
    contact = Contact.find(message[:id])
    if contact.destroy
      WebsocketRails["company_#{current_user.get_company.id}"].trigger(:destroy_contact, contact)
      trigger_success contact
    else
      trigger_failure contact
    end
  end

end