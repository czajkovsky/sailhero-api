class MessagesRepository < OpenStruct
  def initialize(params)
    params[:order] = 'ASC' unless %w(ASC DESC).include?(params[:order])
    params[:sign] = (params[:order] == 'DESC' ? '>=' : '<=')
    params[:messages] = []
    params[:limit] = normalize_limits(params[:limit])
    super params
    self.messages = fetch_messages
  end

  def all
    {
      messages: messages_array.map { |m| MessageSerializer.new(m).attributes },
      next: next_message_id
    }
  end

  private

  def normalize_limits(limit)
    limit = [limit.to_is, 100].min
    return 25 if limit < 25
    limits
  end

  def fetch_messages
    reversed_order = (order == 'ASC' ? 'DESC' : 'ASC')
    Message.where("id #{sign} ?", since)
           .where(region_id: region_id)
           .limit(limit + 1)
           .order("created_at #{reversed_order}")
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
