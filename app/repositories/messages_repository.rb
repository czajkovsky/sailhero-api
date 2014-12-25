class MessagesRepository < OpenStruct
  def initialize(params)
    params[:order] = 'ASC' unless %w(ASC DESC).include?(params[:order])
    params[:sign] = (params[:order] == 'DESC' ? '>=' : '<=')
    params[:messages] = []
    super params
  end

  def call
    reversed_order = (order == 'ASC' ? 'DESC' : 'ASC')
    self.messages = Message.where("id #{sign} ?", since)
                           .where(region_id: region_id)
                           .limit(limit + 1)
                           .order("created_at #{reversed_order}")
    self
  end

  def all
    {
      messages: messages_array,
      next: next_message_id
    }
  end

  def messages_array
    return [] if messages.empty?
    return messages if messages.length < limit + 1
    messages[0...-1]
  end

  def next_message_id
    messages[limit].present? ? messages[limit].id : nil
  end
end
