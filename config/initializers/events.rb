WebsocketRails.setup do |config|

  # Change to :debug for debugging output
  # config.log_level = :debug
  config.log_level = :default

  # Change to true to enable standalone server mode
  # Start the standalone server with rake websocket_rails:start_server
  # Requires Redis
  config.standalone = false

  # Change to true to enable channel synchronization between
  # multiple server instances. Requires Redis.
  config.synchronize = false

  # Uncomment and edit to point to a different redis instance.
  # Will not be used unless standalone or synchronization mode
  # is enabled.
  #config.redis_options = {:host => 'localhost', :port => '6379'}
end

WebsocketRails::EventMap.describe do

  subscribe :client_connected, :to => WsController, :with_method => :connected

  namespace :feeds do
    subscribe :create, :to => Ws::FeedsController, :with_method => :create
    subscribe :delete, :to => Ws::FeedsController, :with_method => :destroy
    subscribe :read, :to => Ws::FeedsController, :with_method => :index
    subscribe :update, :to => Ws::FeedsController, :with_method => :update
  end

  namespace :histories do
    subscribe :create, :to => Ws::HistoriesController, :with_method => :create
    subscribe :delete, :to => Ws::HistoriesController, :with_method => :destroy
    subscribe :read, :to => Ws::HistoriesController, :with_method => :index
    subscribe :update, :to => Ws::HistoriesController, :with_method => :update
  end

  namespace :users do
    subscribe :create, :to => Ws::UsersController, :with_method => :create
    subscribe :destroy, :to => Ws::UsersController, :with_method => :destroy
    subscribe :read, :to => Ws::UsersController, :with_method => :index
    subscribe :update, :to => Ws::UsersController, :with_method => :update
  end

  namespace :companies do
    subscribe :create, :to => Ws::CompaniesController, :with_method => :create
    subscribe :destroy, :to => Ws::CompaniesController, :with_method => :destroy
    subscribe :read, :to => Ws::CompaniesController, :with_method => :index
    subscribe :update, :to => Ws::CompaniesController, :with_method => :update
  end

  namespace :contacts do
    subscribe :create, :to => Ws::ContactsController, :with_method => :create
    subscribe :delete, :to => Ws::ContactsController, :with_method => :destroy
    subscribe :read, :to => Ws::ContactsController, :with_method => :index
    subscribe :update, :to => Ws::ContactsController, :with_method => :update
  end

  namespace :bills do
    subscribe :create, :to => Ws::BillsController, :with_method => :create
    subscribe :destroy, :to => Ws::BillsController, :with_method => :destroy
    subscribe :read, :to => Ws::BillsController, :with_method => :index
    subscribe :update, :to => Ws::BillsController, :with_method => :update
  end

  namespace :positions do
    subscribe :create, :to => Ws::PositionsController, :with_method => :create
    subscribe :destroy, :to => Ws::PositionsController, :with_method => :destroy
    subscribe :read, :to => Ws::PositionsController, :with_method => :index
    subscribe :update, :to => Ws::PositionsController, :with_method => :update
  end

  namespace :ext do
    subscribe :users, :to => Ws::ExtController, :with_method => :get_users
    subscribe :invite, :to => Ws::ExtController, :with_method => :add_invite
    subscribe :upload, :to => Ws::ExtController, :with_method => :upload
    subscribe :cancel_upload, :to => Ws::ExtController, :with_method => :cancel_upload
    subscribe :delete_file, :to => Ws::ExtController, :with_method => :delete_file
    subscribe :payment, :to => Ws::ExtController, :with_method => :payment
  end

  namespace :chats do
    subscribe :create, :to => Ws::ChatsController, :with_method => :create
    #subscribe :destroy, :to => Ws::ChatsController, :with_method => :destroy
    subscribe :read, :to => Ws::ChatsController, :with_method => :index
    subscribe :update, :to => Ws::ChatsController, :with_method => :update
    subscribe :reading, :to => Ws::ChatsController, :with_method => :reading
    subscribe :hide_chat, :to => Ws::ChatsController, :with_method => :hide_chat

    subscribe :typetext, :to => Ws::ChatsController, :with_method => :type_text

  end

  namespace :messages do
    subscribe :create, :to => Ws::MessagesController, :with_method => :create
    subscribe :delete, :to => Ws::MessagesController, :with_method => :destroy
    subscribe :read, :to => Ws::MessagesController, :with_method => :index
    subscribe :update, :to => Ws::MessagesController, :with_method => :update
    subscribe :remove, :to => Ws::MessagesController, :with_method => :remove
  end

  namespace :events do
    #subscribe :create, :to => Ws::MessagesController, :with_method => :create
    subscribe :delete, :to => Ws::EventsController, :with_method => :destroy
    #subscribe :read, :to => Ws::MessagesController, :with_method => :index
    #subscribe :update, :to => Ws::MessagesController, :with_method => :update
  end



  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
end
