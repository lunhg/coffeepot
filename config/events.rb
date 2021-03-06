WebsocketRails::EventMap.describe do
  namespace :initialize do
    subscribe :audio, :to => EditorController, :with_method => :initialize_audio
    subscribe :feedback, :to => EditorController, :with_method => :initialize_feedback
  end

  namespace :compile do
    subscribe :coffee, :to => EditorController, :with_method => :compile_coffee
  end

  namespace :record do
    subscribe :request, :to => EditorController, :with_method => :record_request
    subscribe :blob, :to => EditorController, :with_method => :record_blob
  end

end
