class MessageNotifier < Notifier
  def initialize(params = {})
    self.message = 'message'
    self.key = 'sync_messages'
    self.params = params
  end

  def call
    notify_all_users_in_region(params[:message].region)
  end
end
